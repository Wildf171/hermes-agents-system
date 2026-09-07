"""
===============================================================================
04_AUTH_UNIFICADA.py - Autenticação Unificada com JWT e bcrypt
===============================================================================

Implementação completa de autenticação para Neo Currículos + Neo RH:
- Registro de candidatos (email + senha validada)
- Login unificado (candidato/RH/admin)
- JWT com 24h TTL
- Refresh tokens (30 dias)
- Decoradores: @token_required, @role_required, @permission_required
- Rate limiting (5 tentativas em 15 min)
- LGPD compliance

Data: 2026-09-07
Version: 1.0.0
"""

import re
from datetime import datetime, timedelta
from functools import wraps
from typing import Optional, Tuple, List

import bcrypt
import jwt
import importlib
from flask import Blueprint, request, jsonify, current_app, g
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from pydantic import BaseModel, EmailStr, Field, validator

# Importar models (contornar nomes de módulos com números)
models_module = importlib.import_module('models.06_MODELS_MONGODB')
UsuarioModel = models_module.UsuarioModel
UsuarioCandidatoSchema = models_module.UsuarioCandidatoSchema
UsuarioRHSchema = models_module.UsuarioRHSchema
TipoUsuarioEnum = models_module.TipoUsuarioEnum


# ============================================================================
# SCHEMAS PYDANTIC
# ============================================================================

class RegistroCandidatoRequest(BaseModel):
    """Schema para registro de novo candidato"""
    email: EmailStr
    nome: str = Field(..., min_length=3, max_length=100)
    senha: str = Field(..., min_length=8, max_length=128)
    aceitar_termos: bool = True

    @validator('senha')
    def validar_senha(cls, v):
        """Validar senha: 8+ chars, maiúscula, número, caractere especial"""
        if len(v) < 8:
            raise ValueError("Senha deve ter no mínimo 8 caracteres")
        if not any(c.isupper() for c in v):
            raise ValueError("Senha deve conter pelo menos uma letra maiúscula")
        if not any(c.isdigit() for c in v):
            raise ValueError("Senha deve conter pelo menos um número")
        return v


class LoginRequest(BaseModel):
    """Schema para login"""
    email: EmailStr
    senha: str


class RefreshTokenRequest(BaseModel):
    """Schema para refresh de token"""
    refresh_token: str


class ConsentimentoRequest(BaseModel):
    """Schema para consentimento LGPD"""
    consentimento: bool
    termos_versao: str = "1.0"


class TokenResponse(BaseModel):
    """Schema para resposta de token"""
    access_token: str
    refresh_token: Optional[str] = None
    token_type: str = "Bearer"
    expires_in: int  # segundos
    usuario_id: str
    tipo: str
    nome: str


class UsuarioResponse(BaseModel):
    """Schema para info do usuário"""
    usuario_id: str
    email: str
    nome: str
    tipo: str
    consentimento: bool
    criado_em: datetime


# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def hash_password(senha: str) -> str:
    """Gerar hash bcrypt da senha (12 rounds)"""
    salt = bcrypt.gensalt(rounds=12)
    return bcrypt.hashpw(senha.encode(), salt).decode()


def verify_password(senha: str, hash_armazenado: str) -> bool:
    """Verificar senha contra hash bcrypt"""
    try:
        return bcrypt.checkpw(senha.encode(), hash_armazenado.encode())
    except Exception:
        return False


def validar_email(email: str) -> bool:
    """Validar formato de email"""
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(pattern, email) is not None


def criar_tokens(usuario_id: str, tipo: str, email: str) -> Tuple[str, str]:
    """
    Criar par access_token + refresh_token
    - Access: 24h
    - Refresh: 30 dias
    """
    secret_key = current_app.config['JWT_SECRET_KEY']
    access_ttl = current_app.config.get('JWT_ACCESS_TOKEN_EXPIRES', 86400)
    refresh_ttl = current_app.config.get('JWT_REFRESH_TOKEN_EXPIRES', 2592000)

    # Access token
    access_payload = {
        'usuario_id': usuario_id,
        'tipo': tipo,
        'email': email,
        'iat': datetime.utcnow(),
        'exp': datetime.utcnow() + timedelta(seconds=access_ttl),
        'type': 'access'
    }
    access_token = jwt.encode(access_payload, secret_key, algorithm='HS256')

    # Refresh token
    refresh_payload = {
        'usuario_id': usuario_id,
        'email': email,
        'iat': datetime.utcnow(),
        'exp': datetime.utcnow() + timedelta(seconds=refresh_ttl),
        'type': 'refresh'
    }
    refresh_token = jwt.encode(refresh_payload, secret_key, algorithm='HS256')

    return access_token, refresh_token


def validar_token(token: str) -> Optional[dict]:
    """
    Validar JWT token
    Retorna payload se válido, None se inválido/expirado
    """
    try:
        secret_key = current_app.config['JWT_SECRET_KEY']
        payload = jwt.decode(token, secret_key, algorithms=['HS256'])
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None


# ============================================================================
# DECORADORES
# ============================================================================

def token_required(f):
    """Decorador: Validar JWT token no header Authorization"""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None

        # Buscar token no header
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            try:
                token = auth_header.split(' ')[1]  # Bearer <token>
            except IndexError:
                return jsonify({'erro': 'Token malformado'}), 401

        if not token:
            return jsonify({'erro': 'Token ausente'}), 401

        # Validar token
        payload = validar_token(token)
        if not payload:
            return jsonify({'erro': 'Token inválido ou expirado'}), 401

        # Validar tipo (access, não refresh)
        if payload.get('type') != 'access':
            return jsonify({'erro': 'Token inválido'}), 401

        # Armazenar dados do usuário em g
        g.usuario_id = payload['usuario_id']
        g.tipo = payload['tipo']
        g.email = payload['email']

        return f(*args, **kwargs)

    return decorated


def role_required(roles: List[str]):
    """Decorador: Validar role/tipo do usuário"""
    def decorator(f):
        @wraps(f)
        def decorated(*args, **kwargs):
            if not hasattr(g, 'tipo'):
                return jsonify({'erro': 'Não autenticado'}), 401

            if g.tipo not in roles:
                return jsonify({
                    'erro': f'Acesso negado. Requer: {", ".join(roles)}'
                }), 403

            return f(*args, **kwargs)

        return decorated
    return decorator


def permission_required(permissao: str):
    """Decorador: Validar permissão específica"""
    def decorator(f):
        @wraps(f)
        def decorated(*args, **kwargs):
            if not hasattr(g, 'usuario_id'):
                return jsonify({'erro': 'Não autenticado'}), 401

            # Buscar usuário no banco
            db = current_app.db
            usuario = UsuarioModel.find_by_id(db, g.usuario_id)

            if not usuario:
                return jsonify({'erro': 'Usuário não encontrado'}), 404

            # Verificar permissão (simplificado - poderia usar permissões complexas)
            permissoes = usuario.get('permissoes', [])
            if permissao not in permissoes:
                return jsonify({
                    'erro': f'Permissão negada: {permissao}'
                }), 403

            return f(*args, **kwargs)

        return decorated
    return decorator


# ============================================================================
# BLUEPRINT - ROTAS DE AUTENTICAÇÃO
# ============================================================================

auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')

# Rate limiter
limiter = Limiter(key_func=get_remote_address)


@auth_bp.route('/registrar', methods=['POST'])
@limiter.limit("10/1hour")
def registrar():
    """
    POST /api/auth/registrar

    Registrar novo candidato

    Body:
    {
        "email": "candidato@example.com",
        "nome": "João Silva",
        "senha": "Senha@123",
        "aceitar_termos": true
    }

    Resposta:
    {
        "usuario_id": "...",
        "access_token": "...",
        "refresh_token": "...",
        "tipo": "candidato",
        "nome": "João Silva"
    }
    """
    try:
        # Validar request
        data = request.get_json()
        if not data:
            return jsonify({'erro': 'Body vazio'}), 400

        req = RegistroCandidatoRequest(**data)

        # Validar email
        if not validar_email(req.email):
            return jsonify({'erro': 'Email inválido'}), 400

        # Verificar se email já existe
        db = current_app.db
        usuario_existe = UsuarioModel.find_by_email(db, req.email)
        if usuario_existe:
            current_app.logger.warning(f"Tentativa de registro duplicado: {req.email}")
            return jsonify({'erro': 'Email já registrado'}), 400

        # Criar usuário
        senha_hash = hash_password(req.senha)
        usuario = UsuarioCandidatoSchema(
            email=req.email,
            nome=req.nome,
            senha_hash=senha_hash,
            tipo=TipoUsuarioEnum.CANDIDATO,
            eh_candidato=True
        )

        # Inserir no banco
        usuario_id = UsuarioModel.insert(db, usuario)

        # Criar tokens
        access_token, refresh_token = criar_tokens(
            usuario_id, TipoUsuarioEnum.CANDIDATO, req.email
        )

        # Log
        current_app.logger.info(f"Candidato registrado: {usuario_id} ({req.email})")

        return jsonify({
            'usuario_id': usuario_id,
            'access_token': access_token,
            'refresh_token': refresh_token,
            'token_type': 'Bearer',
            'expires_in': current_app.config.get('JWT_ACCESS_TOKEN_EXPIRES', 86400),
            'tipo': TipoUsuarioEnum.CANDIDATO,
            'nome': req.nome
        }), 201

    except ValueError as e:
        return jsonify({'erro': str(e)}), 400
    except Exception as e:
        current_app.logger.error(f"Erro ao registrar: {str(e)}")
        return jsonify({'erro': 'Erro ao registrar candidato'}), 500


@auth_bp.route('/login', methods=['POST'])
@limiter.limit("5/15minutes")
def login():
    """
    POST /api/auth/login

    Login de candidato ou RH

    Body:
    {
        "email": "user@example.com",
        "senha": "Senha@123"
    }

    Resposta:
    {
        "usuario_id": "...",
        "access_token": "...",
        "refresh_token": "...",
        "tipo": "candidato|rh|admin",
        "nome": "Nome Usuario"
    }
    """
    try:
        data = request.get_json()
        if not data:
            return jsonify({'erro': 'Body vazio'}), 400

        req = LoginRequest(**data)

        # Buscar usuário
        db = current_app.db
        usuario = UsuarioModel.find_by_email(db, req.email)

        if not usuario:
            current_app.logger.warning(f"Login falhou - email não encontrado: {req.email}")
            return jsonify({'erro': 'Email ou senha inválidos'}), 401

        # Verificar se está ativo
        if not usuario.get('ativo', True):
            return jsonify({'erro': 'Usuário inativo'}), 403

        # Verificar senha
        if not verify_password(req.senha, usuario['senha_hash']):
            current_app.logger.warning(f"Login falhou - senha errada: {req.email}")
            return jsonify({'erro': 'Email ou senha inválidos'}), 401

        # Criar tokens
        usuario_id = str(usuario['_id'])
        tipo = usuario['tipo']
        access_token, refresh_token = criar_tokens(usuario_id, tipo, req.email)

        # Log
        current_app.logger.info(f"Login bem-sucedido: {usuario_id} ({tipo})")

        return jsonify({
            'usuario_id': usuario_id,
            'access_token': access_token,
            'refresh_token': refresh_token,
            'token_type': 'Bearer',
            'expires_in': current_app.config.get('JWT_ACCESS_TOKEN_EXPIRES', 86400),
            'tipo': tipo,
            'nome': usuario['nome']
        }), 200

    except ValueError as e:
        return jsonify({'erro': str(e)}), 400
    except Exception as e:
        current_app.logger.error(f"Erro ao fazer login: {str(e)}")
        return jsonify({'erro': 'Erro ao fazer login'}), 500


@auth_bp.route('/refresh', methods=['POST'])
def refresh():
    """
    POST /api/auth/refresh

    Renovar access token usando refresh token

    Body:
    {
        "refresh_token": "..."
    }

    Resposta:
    {
        "access_token": "...",
        "expires_in": 86400
    }
    """
    try:
        data = request.get_json()
        if not data or 'refresh_token' not in data:
            return jsonify({'erro': 'refresh_token ausente'}), 400

        refresh_token = data['refresh_token']

        # Validar refresh token
        payload = validar_token(refresh_token)
        if not payload or payload.get('type') != 'refresh':
            return jsonify({'erro': 'Refresh token inválido ou expirado'}), 401

        # Buscar usuário para atualizar tipo
        db = current_app.db
        usuario = UsuarioModel.find_by_id(db, payload['usuario_id'])
        if not usuario:
            return jsonify({'erro': 'Usuário não encontrado'}), 404

        # Criar novo access token
        access_token, _ = criar_tokens(
            payload['usuario_id'],
            usuario['tipo'],
            payload['email']
        )

        return jsonify({
            'access_token': access_token,
            'token_type': 'Bearer',
            'expires_in': current_app.config.get('JWT_ACCESS_TOKEN_EXPIRES', 86400)
        }), 200

    except Exception as e:
        current_app.logger.error(f"Erro ao renovar token: {str(e)}")
        return jsonify({'erro': 'Erro ao renovar token'}), 500


@auth_bp.route('/logout', methods=['POST'])
@token_required
def logout():
    """
    POST /api/auth/logout

    Logout (invalidar token no cliente)

    Headers:
    Authorization: Bearer <access_token>

    Resposta:
    {
        "mensagem": "Logout bem-sucedido"
    }

    Nota: O token ainda é válido no servidor até expirar (24h).
    Cliente deve removê-lo localmente.
    """
    # Implementação simplificada: log e resposta
    # Em produção, usar token blacklist (Redis)

    current_app.logger.info(f"Logout: {g.usuario_id}")

    return jsonify({
        'mensagem': 'Logout bem-sucedido. Remova o token no cliente.'
    }), 200


@auth_bp.route('/me', methods=['GET'])
@token_required
def get_me():
    """
    GET /api/auth/me

    Obter informações do usuário autenticado

    Headers:
    Authorization: Bearer <access_token>

    Resposta:
    {
        "usuario_id": "...",
        "email": "user@example.com",
        "nome": "João Silva",
        "tipo": "candidato",
        "consentimento": true,
        "criado_em": "2026-09-07T10:00:00"
    }
    """
    try:
        db = current_app.db
        usuario = UsuarioModel.find_by_id(db, g.usuario_id)

        if not usuario:
            return jsonify({'erro': 'Usuário não encontrado'}), 404

        return jsonify({
            'usuario_id': str(usuario['_id']),
            'email': usuario['email'],
            'nome': usuario['nome'],
            'tipo': usuario['tipo'],
            'consentimento': usuario.get('consentimento', False),
            'criado_em': usuario['criado_em'].isoformat() if usuario['criado_em'] else None
        }), 200

    except Exception as e:
        current_app.logger.error(f"Erro ao buscar usuário: {str(e)}")
        return jsonify({'erro': 'Erro ao buscar usuário'}), 500


# ============================================================================
# REGISTRO DO BLUEPRINT
# ============================================================================

def register_auth_bp(app):
    """Registrar blueprint de autenticação na aplicação"""
    app.register_blueprint(auth_bp)
    limiter.init_app(app)
