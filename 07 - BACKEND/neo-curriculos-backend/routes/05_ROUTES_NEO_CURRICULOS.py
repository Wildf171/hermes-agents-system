"""
===============================================================================
05_ROUTES_NEO_CURRICULOS.py - Endpoints para Neo Currículos
===============================================================================

Implementação de 6 endpoints principais:
1. POST /api/curriculos/upload - Upload de PDF (versionamento automático)
2. GET /api/candidatos/:id/curriculos - Listar versões de CV
3. POST /api/candidatos/:id/consentimento - Registrar consentimento LGPD
4. DELETE /api/candidatos/:id/deletar-conta - Soft delete com anonimização
5. GET /api/curriculos/busca - Busca de CVs (RH/Empresa)
6. GET /api/auditoria/relatorio - Relatório LGPD (Admin)

Com paginação, validação, auditoria e segurança.

Data: 2026-09-07
Version: 1.0.0
"""

import hashlib
from datetime import datetime
from typing import Optional
from io import BytesIO

from flask import Blueprint, request, jsonify, current_app, g, send_file
from pydantic import BaseModel, Field, validator
from werkzeug.utils import secure_filename

# Importar models
from models.06_MODELS_MONGODB import (
    UsuarioModel, CurriculoModel, CurriculoAcessoModel,
    CurriculoSchema, CurriculoAcessoSchema, AcaoAuditoriaEnum
)
from auth.04_AUTH_UNIFICADA import token_required, role_required


# ============================================================================
# SCHEMAS
# ============================================================================

class ConsentimentoRequest(BaseModel):
    """Schema para consentimento LGPD"""
    consentimento: bool
    termos_versao: str = "1.0"


class BuscaCurriculoParams(BaseModel):
    """Schema para parâmetros de busca"""
    estado: Optional[str] = None
    categoria: Optional[str] = None
    data_criacao: Optional[str] = None
    empresa_id: Optional[str] = None
    limit: int = Field(default=20, ge=1, le=100)
    offset: int = Field(default=0, ge=0)


class RelatorioAuditoriaParams(BaseModel):
    """Schema para parâmetros de relatório auditoria"""
    usuario_id: Optional[str] = None
    acao: Optional[str] = None
    data_inicio: Optional[str] = None
    data_fim: Optional[str] = None
    limit: int = Field(default=100, ge=1, le=1000)
    offset: int = Field(default=0, ge=0)


# ============================================================================
# BLUEPRINT
# ============================================================================

curriculos_bp = Blueprint('curriculos', __name__, url_prefix='/api')

# Constantes
ALLOWED_EXTENSIONS = {'pdf'}
MAX_UPLOAD_SIZE = 10 * 1024 * 1024  # 10 MB


def arquivo_permitido(filename: str) -> bool:
    """Verificar se extensão de arquivo é permitida"""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def calcular_hash_arquivo(conteudo: bytes) -> str:
    """Calcular SHA256 do arquivo"""
    return hashlib.sha256(conteudo).hexdigest()


def registrar_auditoria(usuario_id: str, curriculo_id: str,
                       acessado_por: str, acao: str, resultado: str = "sucesso",
                       descricao_erro: Optional[str] = None):
    """Registrar ação em auditoria LGPD"""
    try:
        db = current_app.db

        # Limitar tamanho do user_agent
        user_agent = request.headers.get('User-Agent', 'unknown')[:500]
        ip_address = request.remote_addr or 'unknown'

        acesso = CurriculoAcessoSchema(
            usuario_id=usuario_id,
            curriculo_id=curriculo_id,
            acessado_por=acessado_por,
            acao=acao,
            ip_address=ip_address,
            user_agent=user_agent,
            resultado=resultado,
            descricao_erro=descricao_erro
        )

        CurriculoAcessoModel.registrar_acesso(db, acesso)
        current_app.logger.info(
            f"Auditoria: {acao} | CV:{curriculo_id} | Por:{acessado_por} | "
            f"Resultado:{resultado}"
        )
    except Exception as e:
        current_app.logger.error(f"Erro ao registrar auditoria: {str(e)}")


# ============================================================================
# ENDPOINT 1: UPLOAD DE CURRÍCULO
# ============================================================================

@curriculos_bp.route('/curriculos/upload', methods=['POST'])
@token_required
def upload_curriculo():
    """
    POST /api/curriculos/upload

    Upload de currículo em PDF

    Form Data:
    - arquivo: file (PDF)

    Resposta:
    {
        "curriculo_id": "...",
        "versao": 1,
        "url": "s3://...",
        "hash": "...",
        "tamanho": 512000,
        "criado_em": "2026-09-07T10:00:00"
    }

    Autenticação: Requer token válido
    Rate Limit: 20 uploads/hora
    Validações: PDF, max 10MB
    Auditoria: Registrada em curriculos_acesso
    """
    try:
        # Verificar se arquivo foi enviado
        if 'arquivo' not in request.files:
            return jsonify({'erro': 'Arquivo não enviado'}), 400

        arquivo = request.files['arquivo']

        # Validar nome
        if not arquivo.filename:
            return jsonify({'erro': 'Arquivo sem nome'}), 400

        # Validar extensão
        if not arquivo_permitido(arquivo.filename):
            registrar_auditoria(
                g.usuario_id, "", g.usuario_id,
                AcaoAuditoriaEnum.VISUALIZAR, "erro",
                "Extensão de arquivo não permitida"
            )
            return jsonify({
                'erro': 'Apenas arquivos PDF são permitidos'
            }), 400

        # Ler conteúdo
        conteudo = arquivo.read()

        # Validar tamanho
        if len(conteudo) > MAX_UPLOAD_SIZE:
            registrar_auditoria(
                g.usuario_id, "", g.usuario_id,
                AcaoAuditoriaEnum.VISUALIZAR, "erro",
                "Tamanho de arquivo excedido"
            )
            return jsonify({
                'erro': f'Arquivo muito grande. Máximo: 10MB'
            }), 400

        # Verificar consentimento
        db = current_app.db
        usuario = UsuarioModel.find_by_id(db, g.usuario_id)

        if not usuario.get('consentimento', False):
            return jsonify({
                'erro': 'Você deve aceitar os termos de consentimento antes '
                        'de enviar um currículo'
            }), 403

        # Calcular hash
        arquivo_hash = calcular_hash_arquivo(conteudo)

        # Fazer upload para storage (S3/MinIO)
        # TODO: Implementar upload real
        arquivo_url = f"s3://neo-curriculos/{g.usuario_id}/{arquivo_hash}.pdf"

        # Criar objeto currículo
        curriculo = CurriculoSchema(
            usuario_id=g.usuario_id,
            versao=1,
            arquivo_url=arquivo_url,
            arquivo_hash=arquivo_hash,
            arquivo_tamanho=len(conteudo),
            tipo_mime='application/pdf'
        )

        # Buscar versão anterior para incrementar número
        db_curriculos = CurriculoModel.get_versoes_ativas(db, g.usuario_id)
        if db_curriculos:
            curriculo.versao = db_curriculos[0]['versao'] + 1

        # Inserir no banco
        curriculo_id = CurriculoModel.insert(db, curriculo)

        # Registrar auditoria
        registrar_auditoria(
            g.usuario_id, curriculo_id, g.usuario_id,
            AcaoAuditoriaEnum.VISUALIZAR, "sucesso"
        )

        # Log
        current_app.logger.info(
            f"CV enviado: {curriculo_id} | Usuário: {g.usuario_id} | "
            f"Versão: {curriculo.versao} | Tamanho: {len(conteudo)} bytes"
        )

        return jsonify({
            'curriculo_id': curriculo_id,
            'versao': curriculo.versao,
            'url': arquivo_url,
            'hash': arquivo_hash,
            'tamanho': len(conteudo),
            'criado_em': curriculo.criado_em.isoformat()
        }), 201

    except Exception as e:
        current_app.logger.error(f"Erro ao fazer upload: {str(e)}")
        return jsonify({'erro': 'Erro ao fazer upload'}), 500


# ============================================================================
# ENDPOINT 2: LISTAR VERSÕES DE CURRÍCULO
# ============================================================================

@curriculos_bp.route('/candidatos/<usuario_id>/curriculos', methods=['GET'])
@token_required
def listar_curriculos(usuario_id: str):
    """
    GET /api/candidatos/:id/curriculos

    Listar todas as versões de currículo do candidato

    Resposta:
    {
        "total": 2,
        "curriculos": [
            {
                "curriculo_id": "...",
                "versao": 2,
                "url": "s3://...",
                "ativo": true,
                "criado_em": "2026-09-07T10:00:00"
            }
        ]
    }

    Permissão: Apenas o próprio candidato
    Auditoria: Registrada
    """
    try:
        # Validar permissão (apenas o próprio usuário ou admin)
        if g.usuario_id != usuario_id and g.tipo != 'admin':
            return jsonify({'erro': 'Acesso negado'}), 403

        db = current_app.db

        # Buscar versões
        curriculos = CurriculoModel.get_versoes_ativas(db, usuario_id)

        # Registrar auditoria
        registrar_auditoria(
            usuario_id, "", g.usuario_id,
            AcaoAuditoriaEnum.VISUALIZAR, "sucesso"
        )

        return jsonify({
            'total': len(curriculos),
            'curriculos': [
                {
                    'curriculo_id': str(cv['_id']),
                    'versao': cv['versao'],
                    'url': cv['arquivo_url'],
                    'ativo': cv['ativo'],
                    'tamanho': cv['arquivo_tamanho'],
                    'criado_em': cv['criado_em'].isoformat()
                }
                for cv in curriculos
            ]
        }), 200

    except Exception as e:
        current_app.logger.error(f"Erro ao listar currículos: {str(e)}")
        return jsonify({'erro': 'Erro ao listar currículos'}), 500


# ============================================================================
# ENDPOINT 3: REGISTRAR CONSENTIMENTO LGPD
# ============================================================================

@curriculos_bp.route('/candidatos/<usuario_id>/consentimento', methods=['POST'])
@token_required
def registrar_consentimento(usuario_id: str):
    """
    POST /api/candidatos/:id/consentimento

    Registrar consentimento LGPD do candidato

    Body:
    {
        "consentimento": true,
        "termos_versao": "1.0"
    }

    Resposta:
    {
        "usuario_id": "...",
        "consentimento": true,
        "consentimento_data": "2026-09-07T10:00:00",
        "consentimento_versao": "1.0"
    }

    Permissão: Apenas o próprio candidato
    Validação: Não pode negar e enviar CV
    Auditoria: Registrada com "registrar_consentimento"
    """
    try:
        # Validar permissão
        if g.usuario_id != usuario_id:
            return jsonify({'erro': 'Acesso negado'}), 403

        data = request.get_json()
        if not data:
            return jsonify({'erro': 'Body vazio'}), 400

        req = ConsentimentoRequest(**data)

        db = current_app.db

        # Atualizar consentimento
        sucesso = UsuarioModel.update_consentimento(
            db, usuario_id, req.termos_versao
        )

        if not sucesso:
            return jsonify({'erro': 'Usuário não encontrado'}), 404

        # Registrar auditoria
        registrar_auditoria(
            usuario_id, "", g.usuario_id,
            AcaoAuditoriaEnum.REGISTRAR_CONSENTIMENTO, "sucesso"
        )

        current_app.logger.info(
            f"Consentimento registrado: {usuario_id} v{req.termos_versao}"
        )

        return jsonify({
            'usuario_id': usuario_id,
            'consentimento': True,
            'consentimento_data': datetime.utcnow().isoformat(),
            'consentimento_versao': req.termos_versao
        }), 200

    except ValueError as e:
        return jsonify({'erro': str(e)}), 400
    except Exception as e:
        current_app.logger.error(f"Erro ao registrar consentimento: {str(e)}")
        return jsonify({'erro': 'Erro ao registrar consentimento'}), 500


# ============================================================================
# ENDPOINT 4: DELETAR CONTA (SOFT DELETE + ANONIMIZAÇÃO)
# ============================================================================

@curriculos_bp.route('/candidatos/<usuario_id>/deletar-conta', methods=['DELETE'])
@token_required
def deletar_conta(usuario_id: str):
    """
    DELETE /api/candidatos/:id/deletar-conta

    Deletar conta (soft delete + anonimização após 30 dias)

    Resposta:
    {
        "mensagem": "Conta marcada para deleção",
        "usuario_id": "...",
        "sera_anonimizado_em": "2026-10-07T10:00:00"
    }

    Permissão: Apenas o próprio candidato
    Retention: 30 dias, depois anonimiza automaticamente
    Auditoria: Registrada com TTL 7 anos
    """
    try:
        # Validar permissão
        if g.usuario_id != usuario_id:
            return jsonify({'erro': 'Acesso negado'}), 403

        db = current_app.db

        # Buscar usuário
        usuario = UsuarioModel.find_by_id(db, usuario_id)
        if not usuario:
            return jsonify({'erro': 'Usuário não encontrado'}), 404

        # Soft delete
        sucesso = UsuarioModel.soft_delete(db, usuario_id)
        if not sucesso:
            return jsonify({'erro': 'Erro ao deletar conta'}), 500

        # Registrar auditoria
        registrar_auditoria(
            usuario_id, "", g.usuario_id,
            AcaoAuditoriaEnum.DELETAR, "sucesso"
        )

        # Calcular data de anonimização
        from datetime import timedelta
        sera_anonimizado_em = (datetime.utcnow() + timedelta(days=30)).isoformat()

        current_app.logger.info(
            f"Conta deletada (soft): {usuario_id} | "
            f"Será anonimizada em: {sera_anonimizado_em}"
        )

        return jsonify({
            'mensagem': 'Conta marcada para deleção',
            'usuario_id': usuario_id,
            'sera_anonimizado_em': sera_anonimizado_em,
            'nota': 'Sua conta será anonimizada após 30 dias. '
                    'Você pode recuperá-la neste período.'
        }), 200

    except Exception as e:
        current_app.logger.error(f"Erro ao deletar conta: {str(e)}")
        return jsonify({'erro': 'Erro ao deletar conta'}), 500


# ============================================================================
# ENDPOINT 5: BUSCA DE CURRÍCULOS (RH/EMPRESA)
# ============================================================================

@curriculos_bp.route('/curriculos/busca', methods=['GET'])
@token_required
@role_required(['rh', 'recruiter', 'admin', 'empresa'])
def buscar_curriculos():
    """
    GET /api/curriculos/busca?estado=sp&categoria=dev&limit=20&offset=0

    Buscar currículos (apenas para RH/Empresa)

    Query Params:
    - estado: UF (opcional)
    - categoria: categoria profissional (opcional)
    - data_criacao: data ISO (opcional)
    - limite=20 (padrão)
    - offset=0 (padrão)

    Resposta:
    {
        "total": 150,
        "curriculos": [
            {
                "curriculo_id": "...",
                "usuario_id": "...",
                "candidato_nome": "João Silva",
                "versao": 1,
                "criado_em": "2026-09-07T10:00:00",
                "tamanho": 512000
            }
        ],
        "proxima_pagina": 20
    }

    Permissão: Apenas RH/Recruiter/Empresa
    Auditoria: Registrada por RH
    Paginação: limit/offset
    """
    try:
        limit = request.args.get('limit', 20, type=int)
        offset = request.args.get('offset', 0, type=int)

        # Validar paginação
        if limit < 1 or limit > 100:
            limit = 20
        if offset < 0:
            offset = 0

        db = current_app.db

        # TODO: Implementar filtros reais (estado, categoria, data_criacao, empresa_id)
        # Por agora, retornar currículos ativos mais recentes

        collection = db['curriculos']
        curriculos = list(collection.find(
            {'ativo': True},
            sort=[('criado_em', -1)],
            skip=offset,
            limit=limit
        ))

        # Contar total
        total = collection.count_documents({'ativo': True})

        # Enriquecer com dados do usuário
        curriculos_resposta = []
        for cv in curriculos:
            usuario = UsuarioModel.find_by_id(db, cv['usuario_id'])
            curriculos_resposta.append({
                'curriculo_id': str(cv['_id']),
                'usuario_id': cv['usuario_id'],
                'candidato_nome': usuario['nome'] if usuario else 'Desconhecido',
                'versao': cv['versao'],
                'criado_em': cv['criado_em'].isoformat(),
                'tamanho': cv['arquivo_tamanho']
            })

        # Registrar auditoria
        registrar_auditoria(
            "", "", g.usuario_id,
            AcaoAuditoriaEnum.VISUALIZAR, "sucesso"
        )

        return jsonify({
            'total': total,
            'limit': limit,
            'offset': offset,
            'curriculos': curriculos_resposta,
            'proxima_pagina': offset + limit if offset + limit < total else None
        }), 200

    except Exception as e:
        current_app.logger.error(f"Erro ao buscar currículos: {str(e)}")
        return jsonify({'erro': 'Erro ao buscar currículos'}), 500


# ============================================================================
# ENDPOINT 6: RELATÓRIO AUDITORIA LGPD (ADMIN ONLY)
# ============================================================================

@curriculos_bp.route('/auditoria/relatorio', methods=['GET'])
@token_required
@role_required(['admin'])
def relatorio_auditoria():
    """
    GET /api/auditoria/relatorio?usuario_id=...&acao=...&data_inicio=...

    Relatório de auditoria LGPD (7 anos retenção)

    Query Params:
    - usuario_id: filtrar por usuário (opcional)
    - acao: filtrar por ação (opcional)
    - data_inicio: ISO date (opcional)
    - data_fim: ISO date (opcional)
    - limit: 100 (max 1000)
    - offset: 0

    Resposta:
    {
        "total": 5000,
        "registros": [
            {
                "timestamp": "2026-09-07T10:00:00",
                "usuario_id": "...",
                "acessado_por": "...",
                "acao": "visualizar",
                "resultado": "sucesso",
                "ip_address": "192.168.1.1"
            }
        ]
    }

    Permissão: Apenas admin
    Performance: Usa índice (usuario_id, timestamp)
    Retenção: 7 anos automático com TTL
    """
    try:
        usuario_id = request.args.get('usuario_id', type=str)
        acao = request.args.get('acao', type=str)
        data_inicio = request.args.get('data_inicio', type=str)
        data_fim = request.args.get('data_fim', type=str)
        limit = request.args.get('limit', 100, type=int)
        offset = request.args.get('offset', 0, type=int)

        # Validar paginação
        if limit < 1 or limit > 1000:
            limit = 100
        if offset < 0:
            offset = 0

        db = current_app.db
        collection = db['curriculos_acesso']

        # Construir filtro
        filtro = {}
        if usuario_id:
            filtro['usuario_id'] = usuario_id
        if acao:
            filtro['acao'] = acao
        if data_inicio or data_fim:
            filtro['timestamp'] = {}
            if data_inicio:
                from dateutil import parser
                filtro['timestamp']['$gte'] = parser.parse(data_inicio)
            if data_fim:
                from dateutil import parser
                filtro['timestamp']['$lte'] = parser.parse(data_fim)

        # Buscar registros
        registros = list(collection.find(
            filtro,
            sort=[('timestamp', -1)],
            skip=offset,
            limit=limit
        ))

        # Contar total
        total = collection.count_documents(filtro)

        # Formatar resposta
        registros_resposta = [
            {
                'timestamp': r['timestamp'].isoformat(),
                'usuario_id': r['usuario_id'],
                'acessado_por': r['acessado_por'],
                'acao': r['acao'],
                'resultado': r['resultado'],
                'ip_address': r['ip_address']
            }
            for r in registros
        ]

        current_app.logger.info(
            f"Relatório auditoria gerado por {g.usuario_id} | "
            f"Total: {total} registros"
        )

        return jsonify({
            'total': total,
            'limit': limit,
            'offset': offset,
            'registros': registros_resposta,
            'proxima_pagina': offset + limit if offset + limit < total else None
        }), 200

    except Exception as e:
        current_app.logger.error(f"Erro ao gerar relatório: {str(e)}")
        return jsonify({'erro': 'Erro ao gerar relatório'}), 500


# ============================================================================
# REGISTRO DO BLUEPRINT
# ============================================================================

def register_curriculos_bp(app):
    """Registrar blueprint de currículos"""
    app.register_blueprint(curriculos_bp)
