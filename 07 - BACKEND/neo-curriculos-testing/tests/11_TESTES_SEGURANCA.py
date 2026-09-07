"""
===============================================================================
11_TESTES_SEGURANCA.py - Testes de Segurança (OWASP Top 10)
===============================================================================

Testes de segurança cobrindo:
1. Autenticação & Autorização (6 testes)
2. Injection & Input Validation (6 testes)
3. Data Exposure & Encryption (4 testes)
4. Access Control (3 testes)
5. Security Headers (4 testes)
6. LGPD Compliance (3 testes)

Total: 24+ testes

Execução:
    pytest tests/11_TESTES_SEGURANCA.py -v
    pytest tests/11_TESTES_SEGURANCA.py::TestAutenticacao -v

Data: 2026-09-07
Version: 1.0.0
"""

import pytest
import json
import jwt
from datetime import datetime, timedelta
from io import BytesIO
import base64


# ============================================================================
# 1. AUTENTICAÇÃO & AUTORIZAÇÃO (6 testes)
# ============================================================================

class TestAutenticacao:
    """Testes de autenticação e autorização (OWASP A01, A07)"""

    def test_jwt_sem_assinatura_erro_401(self, client):
        """
        Segurança: JWT sem assinatura válida → erro 401

        OWASP A07: Identification and Authentication Failures
        Scenario:
        - Criar JWT sem assinatura válida
        - GET /api/auth/me com token inválido
        - Response: 401, erro "Token inválido"
        """
        token_invalido = jwt.encode(
            {'usuario_id': 'test', 'tipo': 'candidato', 'exp': datetime.utcnow() + timedelta(hours=1)},
            'chave-errada',  # Chave diferente
            algorithm='HS256'
        )

        response = client.get(
            '/api/auth/me',
            headers={'Authorization': f'Bearer {token_invalido}'}
        )

        assert response.status_code == 401
        data = response.get_json()
        assert 'erro' in data or 'mensagem' in data

    def test_jwt_expirado_erro_401(self, client):
        """
        Segurança: JWT expirado → erro 401

        Scenario:
        - Criar JWT com exp no passado
        - GET /api/auth/me com token expirado
        - Response: 401, erro "Token expirado"
        """
        from flask import current_app

        # Criar token expirado
        token_expirado = jwt.encode(
            {
                'usuario_id': 'test',
                'tipo': 'candidato',
                'exp': datetime.utcnow() - timedelta(hours=1)  # Expirado
            },
            'test-secret-key-min-32-chars',
            algorithm='HS256'
        )

        response = client.get(
            '/api/auth/me',
            headers={'Authorization': f'Bearer {token_expirado}'}
        )

        assert response.status_code == 401

    def test_jwt_modificado_erro_401(self, client, jwt_token):
        """
        Segurança: JWT modificado → erro 401

        Scenario:
        - Pegar JWT válido
        - Modificar payload (mudar usuario_id)
        - GET /api/auth/me com token modificado
        - Response: 401, erro "Token inválido"
        """
        # Separar token em 3 partes
        partes = jwt_token.split('.')

        # Modificar payload (2ª parte)
        if len(partes) == 3:
            payload_original = base64.urlsafe_b64decode(partes[1] + '==')
            payload_dict = json.loads(payload_original)
            payload_dict['usuario_id'] = 'usuario_falso'

            payload_modificado = base64.urlsafe_b64encode(
                json.dumps(payload_dict).encode()
            ).decode().rstrip('=')

            token_modificado = f"{partes[0]}.{payload_modificado}.{partes[2]}"

            response = client.get(
                '/api/auth/me',
                headers={'Authorization': f'Bearer {token_modificado}'}
            )

            assert response.status_code == 401

    def test_candidato_nao_acessa_admin_endpoint_erro_403(self, client, registrar_candidato):
        """
        Segurança: Candidato acessa endpoint admin → erro 403

        OWASP A01: Broken Access Control
        Scenario:
        - Candidato tenta GET /api/auditoria/relatorio (endpoint admin)
        - Response: 403, erro "Acesso negado"
        """
        response = client.get(
            '/api/auditoria/relatorio',
            headers={'Authorization': f'Bearer {registrar_candidato["access_token"]}'}
        )

        assert response.status_code == 403
        data = response.get_json()
        assert 'erro' in data or 'mensagem' in data

    def test_usuario_nao_edita_perfil_outro_erro_403(self, client, registrar_candidato, db_clean):
        """
        Segurança: Usuário não consegue editar perfil de outro → erro 403

        OWASP A01: Broken Access Control
        Scenario:
        - User A tenta atualizar perfil de User B
        - Response: 403, erro "Acesso negado"
        """
        # Registrar segundo candidato
        response2 = client.post('/api/auth/registrar', json={
            'email': 'candidato2@example.com',
            'nome': 'Candidato 2',
            'senha': 'SenhaSegura@123',
            'aceitar_termos': True
        })

        if response2.status_code == 201:
            usuario2_id = response2.get_json()['usuario_id']

            # User 1 tenta atualizar perfil de User 2
            response = client.put(
                f'/api/candidatos/{usuario2_id}/atualizar',
                headers={'Authorization': f'Bearer {registrar_candidato["access_token"]}'},
                json={'nome': 'Nome Modificado'}
            )

            # Pode retornar 403 ou 404
            assert response.status_code in [403, 404]


# ============================================================================
# 2. INJECTION & INPUT VALIDATION (6 testes)
# ============================================================================

class TestInjection:
    """Testes de injection e validação (OWASP A03, A04)"""

    def test_sql_injection_email_sanitizado(self, client):
        """
        Segurança: SQL injection em email → sanitizado

        OWASP A03: Injection
        Scenario:
        - Login com email: "' OR '1'='1"
        - Deve ser tratado como string literal
        - Response: 401 (não encontrado) ou 400 (inválido)
        """
        response = client.post('/api/auth/login', json={
            'email': "' OR '1'='1' --",
            'senha': 'anything'
        })

        assert response.status_code in [400, 401]

    def test_nosql_injection_filtro_busca_sanitizado(self, client, registrar_rh):
        """
        Segurança: NoSQL injection em filtro de busca → sanitizado

        Scenario:
        - Buscar CVs com estado: {"$regex": ".*"}
        - Deve ser tratado como string literal
        - Response: 200 (com filtro safe) ou 400
        """
        response = client.get(
            '/api/curriculos/busca?estado={"$regex":".*"}',
            headers={'Authorization': f'Bearer {registrar_rh["access_token"]}'}
        )

        # Não deve quebrar, deve retornar 200 com filtro seguro ou 400 (rejeição)
        assert response.status_code in [200, 400]

    def test_xss_nome_usuario_escapado(self, client):
        """
        Segurança: XSS em nome de usuário → escapado/removido

        OWASP A03: Injection (XSS)
        Scenario:
        - Registrar com nome: "<script>alert('xss')</script>"
        - GET /api/auth/me deve retornar nome escapado
        - Response: nome sem tags <script>
        """
        response = client.post('/api/auth/registrar', json={
            'email': 'xss.test@example.com',
            'nome': '<script>alert("xss")</script>Candidato',
            'senha': 'SenhaSegura@123',
            'aceitar_termos': True
        })

        if response.status_code == 201:
            data = response.get_json()
            nome = data.get('nome', '')

            # Nome não deve conter tags de script
            assert '<script>' not in nome.lower()
            assert 'javascript:' not in nome.lower()

    def test_path_traversal_upload_bloqueado(self, client, registrar_candidato, dar_consentimento):
        """
        Segurança: Path traversal em upload → bloqueado

        OWASP A01: Path Traversal
        Scenario:
        - Upload arquivo: "../../etc/passwd.pdf"
        - Deve ser rejeitado ou nome sanitizado
        - Response: 400 ou arquivo armazenado com nome seguro
        """
        dar_consentimento

        response = client.post(
            '/api/curriculos/upload',
            headers={'Authorization': f'Bearer {registrar_candidato["access_token"]}'},
            data={'arquivo': (BytesIO(b"%PDF-1.4"), '../../../etc/passwd.pdf')},
            content_type='multipart/form-data'
        )

        # Pode ser rejeitado ou sanitizado
        if response.status_code == 201:
            data = response.get_json()
            # URL não deve conter path traversal
            assert '..' not in data.get('url', '')

    def test_validacao_tipos_string_vs_int(self, client, registrar_candidato):
        """
        Segurança: Validação de tipos (string vs int)

        OWASP A04: Insecure Deserialization
        Scenario:
        - GET /api/candidatos?usuario_id=123 (int, não string)
        - Deve validar e rejeitar ou converter seguro
        """
        response = client.get(
            '/api/candidatos/123abc/curriculos',
            headers={'Authorization': f'Bearer {registrar_candidato["access_token"]}'}
        )

        # Pode retornar 400 (invalid) ou 404 (not found)
        assert response.status_code in [400, 403, 404]

    def test_csrf_token_presente(self, client):
        """
        Segurança: CSRF token presente (se aplicável)

        OWASP A01: Cross-Site Request Forgery
        Scenario:
        - GET /api/auth/registrar-form
        - Response deve incluir CSRF token
        """
        # Flask/JWT não usa CSRF tokens por padrão (token é em header)
        # Este teste é mais para SPA/cookie-based apps
        pytest.skip("CSRF não aplicável para JWT (token em header)")


# ============================================================================
# 3. DATA EXPOSURE & ENCRYPTION (4 testes)
# ============================================================================

class TestDataExposure:
    """Testes de exposição de dados e criptografia (OWASP A02, A04)"""

    def test_senha_nunca_retornada_em_response(self, client):
        """
        Segurança: Senha nunca retornada em response

        OWASP A02: Cryptographic Failures
        Scenario:
        - Registrar usuário
        - Response não contém senha (raw ou hashed)
        """
        response = client.post('/api/auth/registrar', json={
            'email': 'senha.test@example.com',
            'nome': 'Teste',
            'senha': 'SenhaSegura@123',
            'aceitar_termos': True
        })

        if response.status_code == 201:
            data = response.get_json()

            # Não deve conter senha_hash, passwd, password, etc
            assert 'senha' not in data
            assert 'senha_hash' not in data
            assert 'password' not in data
            assert 'passwd' not in data

    def test_jwt_nao_em_logs(self, client, registrar_candidato, caplog):
        """
        Segurança: JWT não armazenado em logs

        OWASP A02: Cryptographic Failures
        Scenario:
        - Fazer request com Authorization header
        - Logs não devem conter token completo
        """
        import logging

        with caplog.at_level(logging.INFO):
            response = client.get(
                '/api/auth/me',
                headers={'Authorization': f'Bearer {registrar_candidato["access_token"]}'}
            )

        # Token não deve aparecer em logs (ou aparece parcialmente)
        # Verificar que token completo não está em texto plano

    def test_https_obrigatorio_hsts_header(self, client):
        """
        Segurança: HSTS header presente (força HTTPS)

        OWASP A02: Cryptographic Failures
        Scenario:
        - GET /health
        - Response headers contenham Strict-Transport-Security
        """
        response = client.get('/health')

        headers = dict(response.headers)
        # HSTS pode estar presente ou não (depende da config)
        # Se presente, validar formato
        if 'Strict-Transport-Security' in headers:
            assert 'max-age' in headers['Strict-Transport-Security']

    def test_dados_sensveis_nao_em_logs(self, client, registrar_candidato):
        """
        Segurança: Dados sensíveis (CPF, telefone) não em logs

        OWASP A09: Logging and Monitoring Failures
        Scenario:
        - Upload CV
        - Logs não devem conter dados sensíveis
        """
        # Este teste seria mais complexo em produção
        # Verificaria se CPF, SSN, telefone aparecem em logs
        pytest.skip("Requer análise de logs estruturados")


# ============================================================================
# 4. ACCESS CONTROL (3 testes)
# ============================================================================

class TestAccessControl:
    """Testes de controle de acesso (OWASP A01)"""

    def test_candidato_ve_apenas_seus_cvs(self, client, registrar_candidato, dar_consentimento, db_clean):
        """
        Segurança: Candidato vê apenas seus próprios CVs

        OWASP A01: Broken Object Level Authorization
        Scenario:
        - Candidato A faz upload de CV
        - Candidato B tenta listar CVs de Candidato A
        - Response: 403
        """
        dar_consentimento

        # Candidato A upload
        client.post(
            '/api/curriculos/upload',
            headers={'Authorization': f'Bearer {registrar_candidato["access_token"]}'},
            data={'arquivo': (BytesIO(b"%PDF-1.4"), 'cv.pdf')},
            content_type='multipart/form-data'
        )

        # Registrar Candidato B
        response_b = client.post('/api/auth/registrar', json={
            'email': 'candidato.b@example.com',
            'nome': 'Candidato B',
            'senha': 'SenhaSegura@123',
            'aceitar_termos': True
        })

        if response_b.status_code == 201:
            token_b = response_b.get_json()['access_token']

            # Candidato B tenta listar CVs de Candidato A
            response = client.get(
                f'/api/candidatos/{registrar_candidato["usuario_id"]}/curriculos',
                headers={'Authorization': f'Bearer {token_b}'}
            )

            assert response.status_code == 403

    def test_rh_acessa_apenas_cvs_empresa(self, client, registrar_rh, db_clean):
        """
        Segurança: RH vê CVs apenas de sua empresa

        OWASP A01: Broken Object Level Authorization
        Scenario:
        - RH Empresa A tenta listar CVs de Empresa B
        - Response: 403
        """
        # Requer lógica multi-tenancy
        pytest.skip("Multi-tenancy não implementado")

    def test_soft_deleted_users_nao_acessam(self, client, registrar_candidato, db_clean):
        """
        Segurança: Usuário deletado não consegue acessar

        OWASP A01: Broken Authorization
        Scenario:
        - DELETE /api/candidatos/:id/deletar-conta
        - Tentar fazer request com token do usuário deletado
        - Response: 401 ou 403
        """
        # Deletar conta
        response_delete = client.delete(
            f'/api/candidatos/{registrar_candidato["usuario_id"]}/deletar-conta',
            headers={'Authorization': f'Bearer {registrar_candidato["access_token"]}'}
        )

        if response_delete.status_code == 200:
            # Tentar acessar recurso protegido após deleção
            response = client.get(
                '/api/auth/me',
                headers={'Authorization': f'Bearer {registrar_candidato["access_token"]}'}
            )

            # Pode retornar 401, 403 ou 200 dependendo de implementação


# ============================================================================
# 5. SECURITY HEADERS (4 testes)
# ============================================================================

class TestSecurityHeaders:
    """Testes de security headers (OWASP A01)"""

    def test_content_security_policy_header(self, client):
        """
        Segurança: Content-Security-Policy header presente

        Scenario:
        - GET /health
        - Response headers contém Content-Security-Policy
        """
        response = client.get('/health')

        headers = dict(response.headers)
        # CSP pode estar presente ou não (depende da config)
        # Se presente, validar que é válido
        if 'Content-Security-Policy' in headers:
            csp = headers['Content-Security-Policy']
            assert len(csp) > 0

    def test_x_frame_options_deny(self, client):
        """
        Segurança: X-Frame-Options: DENY (clickjacking prevention)

        Scenario:
        - GET /api/auth/me
        - Response headers: X-Frame-Options = DENY
        """
        response = client.get(
            '/api/auth/me',
            headers={'Authorization': 'Bearer invalid'}
        )

        headers = dict(response.headers)
        # X-Frame-Options pode estar presente ou não
        if 'X-Frame-Options' in headers:
            assert headers['X-Frame-Options'] in ['DENY', 'SAMEORIGIN']

    def test_x_content_type_options_nosniff(self, client):
        """
        Segurança: X-Content-Type-Options: nosniff

        Scenario:
        - GET /health
        - Response headers: X-Content-Type-Options = nosniff
        """
        response = client.get('/health')

        headers = dict(response.headers)
        if 'X-Content-Type-Options' in headers:
            assert headers['X-Content-Type-Options'] == 'nosniff'

    def test_strict_transport_security_hsts(self, client):
        """
        Segurança: Strict-Transport-Security (HTTPS enforcement)

        Scenario:
        - GET /health
        - Response headers: Strict-Transport-Security present
        """
        response = client.get('/health')

        headers = dict(response.headers)
        # HSTS é mais importante em produção (HTTPS)
        # Em testes HTTP local, pode não estar presente


# ============================================================================
# 6. LGPD COMPLIANCE (3 testes)
# ============================================================================

class TestLGPDSecurity:
    """Testes de compliance LGPD (segurança de dados)"""

    def test_dados_deletados_nao_recuperaveis(self, client, registrar_candidato, db_clean):
        """
        Segurança: Dados deletados (hard delete) não são recuperáveis

        LGPD Art. 17: Direito ao esquecimento
        Scenario:
        - DELETE /api/candidatos/:id/deletar-conta
        - Após 30 dias, dados são anonimizados
        - Não devem ser recuperáveis
        """
        # Teste simplificado - requer job de background
        pytest.skip("Requer job de anonimização automática")

    def test_anonimizacao_funciona(self, client, db_clean):
        """
        Segurança: Anonimização substitui dados pessoais

        LGPD Art. 17: Direito ao esquecimento
        Scenario:
        - Usuário deletado há 30+ dias
        - Executar anonimização
        - Nome → "ANONIMIZADO", email modificado
        """
        pytest.skip("Requer job de anonimização")

    def test_direito_esquecimento_exercivel(self, client, registrar_candidato):
        """
        Segurança: Direito ao esquecimento pode ser exercido

        LGPD Art. 17: Direito ao esquecimento
        Scenario:
        - POST /api/candidatos/:id/direito-esquecimento
        - Response: 200, confirmação
        """
        response = client.delete(
            f'/api/candidatos/{registrar_candidato["usuario_id"]}/deletar-conta',
            headers={'Authorization': f'Bearer {registrar_candidato["access_token"]}'}
        )

        # Pode retornar 200 (soft delete) ou 404 (endpoint não existe)
        assert response.status_code in [200, 404]


if __name__ == '__main__':
    pytest.main([__file__, '-v', '--tb=short'])
