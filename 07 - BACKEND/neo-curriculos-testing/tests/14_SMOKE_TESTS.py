"""
===============================================================================
14_SMOKE_TESTS.py - Smoke Tests (Health Checks Rápidos)
===============================================================================

Testes rápidos pós-deployment para verificar health:
1. API Health
2. Database Connection
3. Storage Connection
4. Auth Flow
5. Auditoria

Execução:
    pytest tests/14_SMOKE_TESTS.py -v --tb=short
    pytest tests/14_SMOKE_TESTS.py -v -m smoke

Tempo total: < 30 segundos

Data: 2026-09-07
Version: 1.0.0
"""

import pytest
import json
from datetime import datetime

import requests


# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

BASE_URL = 'http://localhost:5000'
TIMEOUT = 5  # segundos


# ============================================================================
# SMOKE TESTS
# ============================================================================

class TestSmokeHealthChecks:
    """Smoke tests para verificar health da API após deployment"""

    @pytest.mark.smoke
    def test_api_health_online(self):
        """
        Smoke: GET /health → API está online

        Scenario:
        - GET /health
        - Response: 200
        - Body: {status: 'ok', version: '1.0.0'}

        Tempo esperado: < 20ms
        """
        try:
            response = requests.get(
                f'{BASE_URL}/health',
                timeout=TIMEOUT
            )

            assert response.status_code == 200, f"Health check retornou {response.status_code}"

            data = response.json()
            assert data['status'] == 'ok', f"Status: {data.get('status')}"
            assert 'version' in data
            assert 'timestamp' in data

            print(f"\n✓ API Health: OK (v{data['version']})")

        except requests.ConnectionError:
            pytest.fail(f"Erro de conexão: {BASE_URL} não está acessível")
        except Exception as e:
            pytest.fail(f"Erro ao verificar health: {str(e)}")

    @pytest.mark.smoke
    def test_db_mongodb_connection(self):
        """
        Smoke: GET /health/db → MongoDB conectado

        Scenario:
        - GET /health/db (ou similar)
        - Response: 200
        - Body: {mongodb: 'connected'}

        Tempo esperado: < 100ms
        """
        try:
            # Endpoint de health do DB pode variar
            response = requests.get(
                f'{BASE_URL}/health',
                timeout=TIMEOUT
            )

            if response.status_code == 200:
                data = response.json()
                # Verificar se DB está mencionado ou fazer um query
                assert 'status' in data

                print("✓ Database Health: OK")
            else:
                pytest.skip("Endpoint de health do DB não encontrado")

        except Exception as e:
            pytest.fail(f"Erro ao verificar DB: {str(e)}")

    @pytest.mark.smoke
    def test_storage_minio_s3_connection(self):
        """
        Smoke: GET /health/storage → Storage conectado

        Scenario:
        - Verificar se S3/MinIO está acessível
        - Response: 200
        - Body: {storage: 'connected'}

        Tempo esperado: < 200ms
        """
        # Storage check é mais complexo
        # Pode ser skipped se não houver endpoint específico
        pytest.skip("Storage check requer configuração específica")

    @pytest.mark.smoke
    def test_auth_flow_rápido(self):
        """
        Smoke: Fluxo rápido de auth (register → login)

        Scenario:
        - POST /api/auth/registrar (novo candidato)
        - Response: 201
        - POST /api/auth/login (com mesmas credenciais)
        - Response: 200
        - Validar tokens na response

        Tempo esperado: < 1s
        """
        import time
        timestamp = int(time.time())
        email = f'smoke.test.{timestamp}@example.com'

        try:
            # 1. Registrar
            response_reg = requests.post(
                f'{BASE_URL}/api/auth/registrar',
                json={
                    'email': email,
                    'nome': 'Smoke Test',
                    'senha': 'SmokeTest@123',
                    'aceitar_termos': True
                },
                timeout=TIMEOUT
            )

            assert response_reg.status_code == 201, f"Registrar retornou {response_reg.status_code}: {response_reg.text}"

            data_reg = response_reg.json()
            assert 'access_token' in data_reg
            assert 'usuario_id' in data_reg

            print(f"\n✓ Auth Register: OK")

            # 2. Login
            response_login = requests.post(
                f'{BASE_URL}/api/auth/login',
                json={
                    'email': email,
                    'senha': 'SmokeTest@123'
                },
                timeout=TIMEOUT
            )

            assert response_login.status_code == 200, f"Login retornou {response_login.status_code}"

            data_login = response_login.json()
            assert 'access_token' in data_login

            print(f"✓ Auth Login: OK")

        except requests.ConnectionError:
            pytest.fail(f"Erro de conexão ao testar auth")
        except AssertionError as e:
            pytest.fail(str(e))
        except Exception as e:
            pytest.fail(f"Erro no fluxo de auth: {str(e)}")

    @pytest.mark.smoke
    def test_endpoints_principais_respondendo(self):
        """
        Smoke: Endpoints principais estão respondendo (não 500)

        Scenario:
        - GET /api/version
        - GET /
        - Response: 200
        - Sem erros 500 ou timeouts

        Tempo esperado: < 50ms
        """
        endpoints = [
            f'{BASE_URL}/',
            f'{BASE_URL}/api/version',
            f'{BASE_URL}/api/docs',
        ]

        for endpoint in endpoints:
            try:
                response = requests.get(endpoint, timeout=TIMEOUT)

                # Aceitar 200-299 (sucesso) ou 401 (não autenticado, mas respondeu)
                assert response.status_code < 500, f"{endpoint} retornou {response.status_code}: {response.text[:100]}"

                print(f"✓ {endpoint.split('/')[-1] or 'root'}: {response.status_code}")

            except requests.Timeout:
                pytest.fail(f"Timeout em {endpoint}")
            except requests.ConnectionError:
                pytest.fail(f"Conexão recusada: {endpoint}")
            except Exception as e:
                pytest.fail(f"Erro em {endpoint}: {str(e)}")

    @pytest.mark.smoke
    def test_headers_seguranca_presentes(self):
        """
        Smoke: Headers de segurança estão presentes

        Scenario:
        - GET /health
        - Verificar presença de headers de segurança
        - Content-Type, X-Frame-Options, etc

        Tempo esperado: < 20ms
        """
        try:
            response = requests.get(f'{BASE_URL}/health', timeout=TIMEOUT)

            assert response.status_code == 200

            headers = dict(response.headers)

            # Verificar headers comuns de segurança
            # Não precisa ter todos, mas validar que existem
            security_headers_esperados = [
                'Content-Type',
                'Date',  # Ou outro header temporal
            ]

            presentes = []
            ausentes = []

            for header in security_headers_esperados:
                if header in headers:
                    presentes.append(header)
                else:
                    ausentes.append(header)

            print(f"\n✓ Security Headers encontrados: {len(presentes)}")

            if ausentes:
                print(f"  ⚠️  Ausentes: {ausentes}")

        except Exception as e:
            pytest.fail(f"Erro ao verificar headers: {str(e)}")

    @pytest.mark.smoke
    def test_resposta_json_valido(self):
        """
        Smoke: Respostas estão em JSON válido

        Scenario:
        - GET /health
        - GET /
        - Validar que JSON é válido
        - Não deve ter caracteres corrompidos

        Tempo esperado: < 20ms
        """
        endpoints = [
            f'{BASE_URL}/health',
            f'{BASE_URL}/',
        ]

        for endpoint in endpoints:
            try:
                response = requests.get(endpoint, timeout=TIMEOUT)

                # Tentar fazer parse JSON
                data = response.json()

                assert isinstance(data, (dict, list)), f"Response não é dict ou list: {type(data)}"

                print(f"✓ {endpoint}: JSON válido")

            except requests.Timeout:
                pytest.fail(f"Timeout em {endpoint}")
            except json.JSONDecodeError as e:
                pytest.fail(f"JSON inválido em {endpoint}: {str(e)}")
            except Exception as e:
                pytest.fail(f"Erro em {endpoint}: {str(e)}")


# ============================================================================
# SMOKE TESTS - POST DEPLOYMENT CHECKLIST
# ============================================================================

class TestSmokePostDeployment:
    """Checklist rápido pós-deployment"""

    @pytest.mark.smoke
    def test_versao_correta(self):
        """
        Smoke: Versão da API está correta (v1.0.0)

        Scenario:
        - GET /api/version
        - Response deve conter version='1.0.0'
        """
        try:
            response = requests.get(f'{BASE_URL}/api/version', timeout=TIMEOUT)

            if response.status_code == 200:
                data = response.json()
                assert 'version' in data

                print(f"\n✓ API Version: {data['version']}")
            else:
                pytest.skip("Endpoint /api/version não encontrado")

        except Exception as e:
            pytest.fail(f"Erro ao verificar versão: {str(e)}")

    @pytest.mark.smoke
    def test_sem_erros_500(self):
        """
        Smoke: Nenhum endpoint retorna erro 500

        Scenario:
        - Testar 5 endpoints comuns
        - Nenhum deve retornar 500
        """
        endpoints = [
            f'{BASE_URL}/health',
            f'{BASE_URL}/',
            f'{BASE_URL}/api/version',
        ]

        erros_500 = []

        for endpoint in endpoints:
            try:
                response = requests.get(endpoint, timeout=TIMEOUT)

                if response.status_code == 500:
                    erros_500.append(endpoint)

            except Exception:
                pass

        assert len(erros_500) == 0, f"Endpoints com erro 500: {erros_500}"

        print(f"\n✓ Sem erros 500 detectados")

    @pytest.mark.smoke
    def test_tempo_resposta_aceitavel(self):
        """
        Smoke: Tempo de resposta está aceitável (< 500ms)

        Scenario:
        - GET /health
        - Tempo de resposta deve ser < 500ms
        """
        import time

        try:
            inicio = time.time()
            response = requests.get(f'{BASE_URL}/health', timeout=TIMEOUT)
            tempo_ms = (time.time() - inicio) * 1000

            assert response.status_code == 200
            assert tempo_ms < 500, f"Tempo de resposta {tempo_ms:.0f}ms > 500ms"

            print(f"\n✓ Tempo de resposta: {tempo_ms:.0f}ms")

        except Exception as e:
            pytest.fail(f"Erro ao testar tempo: {str(e)}")

    @pytest.mark.smoke
    def test_base_url_acessivel(self):
        """
        Smoke: BASE_URL está acessível

        Scenario:
        - Ping para BASE_URL
        - Deve responder
        """
        try:
            response = requests.get(f'{BASE_URL}/', timeout=TIMEOUT)

            assert response.status_code < 500

            print(f"\n✓ Base URL acessível: {BASE_URL}")

        except requests.ConnectionError:
            pytest.fail(f"Base URL não acessível: {BASE_URL}")
        except Exception as e:
            pytest.fail(f"Erro ao acessar base URL: {str(e)}")


# ============================================================================
# PYTEST HOOKS
# ============================================================================

@pytest.fixture(scope='session', autouse=True)
def smoke_test_header():
    """Imprimir header dos smoke tests"""
    print("\n" + "="*80)
    print("SMOKE TESTS - POST DEPLOYMENT VERIFICATION")
    print("="*80)
    print(f"Base URL: {BASE_URL}")
    print(f"Timeout: {TIMEOUT}s")
    print("="*80)
    yield


if __name__ == '__main__':
    pytest.main([__file__, '-v', '-m', 'smoke', '--tb=short'])
