"""
===============================================================================
conftest.py - Configuração de Testes Pytest
===============================================================================

Fixtures compartilhadas entre todos os testes:
- app: Flask application
- client: Test client
- mock_db: Mock MongoDB
- usuario_teste: Dados de usuário
- token_valido: JWT válido

Uso:
    pytest tests/ -v
"""

import os
import sys
import pytest
from datetime import datetime
from unittest.mock import MagicMock
from io import BytesIO

# Adicionar diretório raiz ao path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app import create_app
from auth.04_AUTH_UNIFICADA import hash_password, criar_tokens
from models.06_MODELS_MONGODB import TipoUsuarioEnum


@pytest.fixture
def app():
    """
    Criar aplicação Flask de teste

    Configuração:
    - TESTING = True
    - Sem banco real
    - JWT_SECRET_KEY de teste
    """
    app = create_app()

    # Override configurações de teste
    app.config['TESTING'] = True
    app.config['JWT_SECRET_KEY'] = 'test-secret-key-' * 3
    app.config['PROPAGATE_EXCEPTIONS'] = True

    # Mock database
    app.db = MagicMock()

    return app


@pytest.fixture
def client(app):
    """Cliente de teste Flask"""
    return app.test_client()


@pytest.fixture
def app_context(app):
    """Context da aplicação para testes"""
    with app.app_context():
        yield app


@pytest.fixture
def mock_db():
    """Mock do banco de dados MongoDB"""
    db = MagicMock()
    db.__getitem__ = MagicMock(return_value=MagicMock())
    return db


@pytest.fixture
def usuario_teste():
    """
    Dados de usuário de teste

    Tipo: candidato
    Email: test@example.com
    Senha: Senha@123
    """
    return {
        '_id': 'test_user_id_123456789012',
        'email': 'test@example.com',
        'nome': 'Test User',
        'tipo': TipoUsuarioEnum.CANDIDATO,
        'eh_candidato': True,
        'senha_hash': hash_password('Senha@123'),
        'consentimento': False,
        'consentimento_data': None,
        'consentimento_versao': None,
        'ativo': True,
        'anonimizado': False,
        'marcacao_delecao': None,
        'criado_em': datetime.utcnow()
    }


@pytest.fixture
def usuario_rh_teste():
    """
    Dados de usuário RH de teste

    Tipo: RH
    Email: rh@example.com
    """
    return {
        '_id': 'test_rh_id_123456789012',
        'email': 'rh@example.com',
        'nome': 'RH User',
        'tipo': TipoUsuarioEnum.RH,
        'eh_candidato': False,
        'senha_hash': hash_password('RHSenha@123'),
        'empresa_id': None,
        'ativo': True,
        'permissoes': ['buscar_cv', 'compartilhar_cv', 'relatorios'],
        'criado_em': datetime.utcnow()
    }


@pytest.fixture
def usuario_admin_teste():
    """
    Dados de usuário Admin de teste

    Tipo: Admin
    Email: admin@example.com
    """
    return {
        '_id': 'test_admin_id_123456789012',
        'email': 'admin@example.com',
        'nome': 'Admin User',
        'tipo': TipoUsuarioEnum.ADMIN,
        'eh_candidato': False,
        'senha_hash': hash_password('AdminSenha@123'),
        'ativo': True,
        'permissoes': ['*'],  # Todas as permissões
        'criado_em': datetime.utcnow()
    }


@pytest.fixture
def token_valido(app, usuario_teste):
    """
    JWT token válido de teste

    TTL: 24 horas
    Tipo: access token
    """
    access_token, _ = criar_tokens(
        usuario_teste['_id'],
        usuario_teste['tipo'],
        usuario_teste['email']
    )
    return access_token


@pytest.fixture
def token_rh(app, usuario_rh_teste):
    """JWT token válido para RH"""
    access_token, _ = criar_tokens(
        usuario_rh_teste['_id'],
        usuario_rh_teste['tipo'],
        usuario_rh_teste['email']
    )
    return access_token


@pytest.fixture
def token_admin(app, usuario_admin_teste):
    """JWT token válido para Admin"""
    access_token, _ = criar_tokens(
        usuario_admin_teste['_id'],
        usuario_admin_teste['tipo'],
        usuario_admin_teste['email']
    )
    return access_token


@pytest.fixture
def curriculo_teste():
    """Dados de currículo de teste"""
    import hashlib

    conteudo = b'%PDF-1.4 fake pdf content'
    arquivo_hash = hashlib.sha256(conteudo).hexdigest()

    return {
        '_id': 'test_cv_id_123456789012',
        'usuario_id': 'test_user_id_123456789012',
        'versao': 1,
        'arquivo_url': 's3://neo-curriculos/test_user_id_123456789012/cv.pdf',
        'arquivo_hash': arquivo_hash,
        'arquivo_tamanho': len(conteudo),
        'tipo_mime': 'application/pdf',
        'ativo': True,
        'criado_em': datetime.utcnow(),
        'metadata': {}
    }


@pytest.fixture
def pdf_file():
    """Arquivo PDF fake para upload"""
    pdf_conteudo = b'%PDF-1.4\n%fake pdf content'
    return (BytesIO(pdf_conteudo), 'test.pdf')


@pytest.fixture
def audit_log_teste():
    """Log de auditoria de teste"""
    return {
        '_id': 'test_audit_id_123456789012',
        'usuario_id': 'test_user_id_123456789012',
        'curriculo_id': 'test_cv_id_123456789012',
        'acessado_por': 'test_rh_id_123456789012',
        'acao': 'visualizar',
        'timestamp': datetime.utcnow(),
        'ip_address': '127.0.0.1',
        'user_agent': 'Mozilla/5.0 Test',
        'resultado': 'sucesso',
        'ttl': datetime.utcnow()
    }


@pytest.fixture
def autouse_cleanup():
    """Cleanup após cada teste"""
    yield
    # Limpar recursos se necessário


# ============================================================================
# MARCADORES DE TESTE
# ============================================================================

def pytest_configure(config):
    """Registrar marcadores personalizados"""
    config.addinivalue_line(
        "markers", "auth: marca testes de autenticação"
    )
    config.addinivalue_line(
        "markers", "upload: marca testes de upload"
    )
    config.addinivalue_line(
        "markers", "lgpd: marca testes de conformidade LGPD"
    )
    config.addinivalue_line(
        "markers", "busca: marca testes de busca/filtros"
    )
    config.addinivalue_line(
        "markers", "seguranca: marca testes de segurança"
    )
    config.addinivalue_line(
        "markers", "slow: marca testes lentos"
    )


# ============================================================================
# HOOKS PYTEST
# ============================================================================

def pytest_collection_modifyitems(config, items):
    """
    Modificar items de teste antes de execução

    Adiciona marcadores automáticos baseado no nome do teste
    """
    for item in items:
        # Auth
        if "auth" in item.nodeid:
            item.add_marker(pytest.mark.auth)

        # Upload
        if "upload" in item.nodeid or "curriculo" in item.nodeid:
            item.add_marker(pytest.mark.upload)

        # LGPD
        if "lgpd" in item.nodeid or "consentimento" in item.nodeid or "deletar" in item.nodeid:
            item.add_marker(pytest.mark.lgpd)

        # Busca
        if "busca" in item.nodeid or "filtro" in item.nodeid or "paginacao" in item.nodeid:
            item.add_marker(pytest.mark.busca)

        # Segurança
        if "senha" in item.nodeid or "token" in item.nodeid or "bcrypt" in item.nodeid:
            item.add_marker(pytest.mark.seguranca)
