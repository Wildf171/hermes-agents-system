"""
===============================================================================
conftest.py - Configuração pytest com Fixtures
===============================================================================

Fixtures compartilhadas para todos os testes:
- client: Flask test client
- db_clean: Banco de dados limpo antes de cada teste
- jwt_token: Token JWT válido
- pdf_file: Arquivo PDF de teste

Data: 2026-09-07
Version: 1.0.0
"""

import os
import sys
import json
import jwt
from datetime import datetime, timedelta
from io import BytesIO
from pathlib import Path

import pytest
import mongomock
import requests
from dotenv import load_dotenv

# Adicionar backend ao path
backend_path = Path(__file__).parent.parent / 'neo-curriculos-backend'
sys.path.insert(0, str(backend_path))

# Load environment
load_dotenv()


# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

# Base URL para testes E2E
BASE_URL = os.getenv('TEST_BASE_URL', 'http://localhost:5000')

# Dados de teste
TEST_USUARIO_CANDIDATO = {
    'email': 'teste.candidato@example.com',
    'nome': 'Candidato Teste',
    'senha': 'SenhaSegura@123'
}

TEST_USUARIO_RH = {
    'email': 'teste.rh@example.com',
    'nome': 'RH Teste',
    'senha': 'SenhaSegura@123',
    'tipo': 'rh'
}

TEST_USUARIO_ADMIN = {
    'email': 'teste.admin@example.com',
    'nome': 'Admin Teste',
    'senha': 'SenhaSegura@123',
    'tipo': 'admin'
}


# ============================================================================
# FIXTURES - CLIENT & DB
# ============================================================================

@pytest.fixture(scope='function')
def client():
    """
    Fixture: Flask test client

    Fornece acesso à API para testes E2E
    """
    from app import create_app

    app = create_app()
    app.config['TESTING'] = True
    app.config['MONGO_URI'] = os.getenv(
        'TEST_MONGO_URI',
        'mongodb://admin:password@localhost:27017/neo_rh_test'
    )

    with app.test_client() as client:
        with app.app_context():
            yield client


@pytest.fixture(scope='function')
def db_clean(client):
    """
    Fixture: Limpar banco de dados antes de cada teste

    Remove todas as collections e recreia índices
    """
    from flask import current_app
    from models.06_MODELS_MONGODB import (
        UsuarioModel, CurriculoModel, CurriculoAcessoModel
    )

    app = current_app
    db = app.db

    # Limpar collections
    for collection_name in ['usuarios', 'curriculos', 'curriculos_acesso', 'auditoria']:
        if collection_name in db.list_collection_names():
            db[collection_name].delete_many({})

    # Recriar índices
    UsuarioModel.create_indexes(db)
    CurriculoModel.create_indexes(db)
    CurriculoAcessoModel.create_indexes(db)

    yield db

    # Cleanup após teste
    for collection_name in ['usuarios', 'curriculos', 'curriculos_acesso', 'auditoria']:
        if collection_name in db.list_collection_names():
            db[collection_name].delete_many({})


# ============================================================================
# FIXTURES - AUTENTICAÇÃO
# ============================================================================

@pytest.fixture(scope='function')
def registrar_candidato(client, db_clean):
    """
    Fixture: Registrar candidato de teste

    Retorna token JWT e dados do usuário
    """
    response = client.post('/api/auth/registrar', json={
        'email': TEST_USUARIO_CANDIDATO['email'],
        'nome': TEST_USUARIO_CANDIDATO['nome'],
        'senha': TEST_USUARIO_CANDIDATO['senha'],
        'aceitar_termos': True
    })

    assert response.status_code == 201, f"Erro ao registrar: {response.get_json()}"

    data = response.get_json()
    return {
        'usuario_id': data['usuario_id'],
        'email': data['email'],
        'nome': data['nome'],
        'access_token': data['access_token'],
        'refresh_token': data.get('refresh_token'),
        'tipo': 'candidato'
    }


@pytest.fixture(scope='function')
def registrar_rh(client, db_clean):
    """
    Fixture: Registrar usuário RH de teste

    Retorna token JWT e dados do usuário RH
    """
    from models.06_MODELS_MONGODB import UsuarioModel, UsuarioRHSchema
    from auth.04_AUTH_UNIFICADA import hash_password, criar_tokens
    from flask import current_app
    from bson import ObjectId

    db = current_app.db

    # Criar usuário RH diretamente (sem endpoint específico)
    usuario = UsuarioRHSchema(
        email=TEST_USUARIO_RH['email'],
        nome=TEST_USUARIO_RH['nome'],
        senha_hash=hash_password(TEST_USUARIO_RH['senha']),
        tipo='rh',
        eh_candidato=False
    )

    usuario_id = UsuarioModel.insert(db, usuario)
    access_token, refresh_token = criar_tokens(usuario_id, 'rh', usuario.email)

    return {
        'usuario_id': usuario_id,
        'email': usuario.email,
        'nome': usuario.nome,
        'access_token': access_token,
        'refresh_token': refresh_token,
        'tipo': 'rh'
    }


@pytest.fixture(scope='function')
def jwt_token(registrar_candidato):
    """
    Fixture: Token JWT válido de candidato

    Retorna apenas o token (string)
    """
    return registrar_candidato['access_token']


# ============================================================================
# FIXTURES - ARQUIVO PDF
# ============================================================================

@pytest.fixture(scope='function')
def pdf_file():
    """
    Fixture: Arquivo PDF de teste

    Cria um PDF mínimo válido em memória
    Retorna BytesIO que pode ser usado com client.post
    """
    # PDF mínimo válido (estrutura básica)
    pdf_content = b"""%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj
2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj
3 0 obj
<<
/Type /Page
/Parent 2 0 R
/MediaBox [0 0 612 792]
/Contents 4 0 R
/Resources <<
/Font <<
/F1 <<
/Type /Font
/Subtype /Type1
/BaseFont /Helvetica
>>
>>
>>
>>
endobj
4 0 obj
<<
/Length 44
>>
stream
BT
/F1 12 Tf
100 700 Td
(Teste PDF) Tj
ET
endstream
endobj
xref
0 5
0000000000 65535 f
0000000009 00000 n
0000000058 00000 n
0000000115 00000 n
0000000375 00000 n
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
469
%%EOF"""

    return BytesIO(pdf_content)


@pytest.fixture(scope='function')
def arquivo_grande():
    """
    Fixture: Arquivo maior que limite (> 10MB)

    Retorna BytesIO com arquivo PDF grande demais
    """
    pdf_header = b"%PDF-1.4\n"
    # Criar arquivo > 10MB
    conteudo_grande = pdf_header + (b"x" * (11 * 1024 * 1024))
    return BytesIO(conteudo_grande)


@pytest.fixture(scope='function')
def arquivo_txt():
    """
    Fixture: Arquivo TXT (não PDF, deve ser rejeitado)
    """
    return BytesIO(b"Conteudo em TXT que nao eh PDF")


# ============================================================================
# FIXTURES - HELPERS
# ============================================================================

@pytest.fixture(scope='function')
def fazer_login(client, db_clean):
    """
    Fixture: Helper para fazer login

    Retorna função que aceita email/senha
    """
    def login(email: str, senha: str):
        response = client.post('/api/auth/login', json={
            'email': email,
            'senha': senha
        })
        return response

    return login


@pytest.fixture(scope='function')
def dar_consentimento(client, registrar_candidato):
    """
    Fixture: Helper para registrar consentimento LGPD

    Usa o candidato registrado
    """
    response = client.post(
        f'/api/candidatos/{registrar_candidato["usuario_id"]}/consentimento',
        headers={'Authorization': f'Bearer {registrar_candidato["access_token"]}'},
        json={
            'consentimento': True,
            'termos_versao': '1.0'
        }
    )
    return response


# ============================================================================
# PYTEST HOOKS
# ============================================================================

def pytest_configure(config):
    """Hook executado antes de rodar os testes"""
    print("\n" + "="*80)
    print("Neo Currículos - TESTES E2E + SEGURANÇA + CARGA")
    print("="*80)
    print(f"Base URL: {BASE_URL}")
    print(f"Database: {os.getenv('TEST_MONGO_URI', 'default')}")
    print("="*80 + "\n")


def pytest_collection_modifyitems(config, items):
    """Hook para adicionar marcadores aos testes"""
    for item in items:
        # Adicionar marcador baseado no arquivo
        if 'e2e' in str(item.fspath):
            item.add_marker(pytest.mark.e2e)
        elif 'seguranca' in str(item.fspath):
            item.add_marker(pytest.mark.seguranca)
        elif 'load' in str(item.fspath):
            item.add_marker(pytest.mark.load)
        elif 'smoke' in str(item.fspath):
            item.add_marker(pytest.mark.smoke)


@pytest.fixture(scope='session', autouse=True)
def setup_test_env():
    """Setup do ambiente de testes"""
    os.environ['FLASK_ENV'] = 'testing'
    os.environ['JWT_SECRET_KEY'] = 'test-secret-key-min-32-chars'
    yield
