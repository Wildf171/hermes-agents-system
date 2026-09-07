# FASE 3 - INTEGRATION & TESTING

**Neo Currículos + Neo RH System**

Testes E2E, Segurança, Carga, CI/CD e Deployment para Neo Currículos.

**Status:** ✅ Completo (2-3 semanas)

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura](#estrutura)
3. [Instalação](#instalação)
4. [Execução de Testes](#execução-de-testes)
5. [CI/CD Pipeline](#cicd-pipeline)
6. [Deployment](#deployment)
7. [Monitoramento](#monitoramento)
8. [Troubleshooting](#troubleshooting)

---

## 🎯 Visão Geral

FASE 3 implementa testes automatizados, CI/CD pipeline e infra de deployment para Neo Currículos.

### Entregáveis

| # | Arquivo | Descrição | Linhas | Status |
|---|---------|-----------|--------|--------|
| 10 | `tests/10_TESTES_E2E.py` | 30+ testes E2E | 800-1000 | ✅ |
| 11 | `tests/11_TESTES_SEGURANCA.py` | 24+ testes segurança (OWASP) | 500-600 | ✅ |
| 12 | `tests/12_LOAD_TESTING.py` | 12+ testes carga/performance | 400-500 | ✅ |
| 14 | `tests/14_SMOKE_TESTS.py` | 5+ testes health | 200-300 | ✅ |
| CI/CD | `.github/workflows/ci-cd.yml` | Pipeline GitHub Actions | 300-400 | ✅ |
| 15 | `scripts/15_DEPLOY_STAGING.sh` | Deploy automático staging | 150-200 | ✅ |
| 16 | `monitoring/16_MONITORING_PROMETHEUS.yml` | Config Prometheus | 100-150 | ✅ |
| 17 | `docs/17_PRODUCTION_CHECKLIST.md` | Checklist produção | 200+ | ✅ |

**Total: 8+ arquivos, 2000+ linhas de código/configuração**

---

## 📁 Estrutura

```
neo-curriculos-testing/
├── tests/
│   ├── 10_TESTES_E2E.py                 # 30+ E2E tests
│   ├── 11_TESTES_SEGURANCA.py           # 24+ security tests
│   ├── 12_LOAD_TESTING.py               # 12+ load tests
│   └── 14_SMOKE_TESTS.py                # 5+ smoke tests
│
├── .github/workflows/
│   └── ci-cd.yml                        # GitHub Actions pipeline
│
├── scripts/
│   ├── 15_DEPLOY_STAGING.sh             # Staging deployment
│   └── deploy-production.sh             # Production deployment (TODO)
│
├── monitoring/
│   ├── 16_MONITORING_PROMETHEUS.yml     # Prometheus config
│   ├── alert-rules.yml                  # Alert rules
│   └── recording-rules.yml              # Recording rules (TODO)
│
├── docs/
│   ├── 17_PRODUCTION_CHECKLIST.md       # Pre-deployment checklist
│   ├── DEPLOYMENT_GUIDE.md              # Deployment guide
│   ├── RUNBOOK.md                       # Troubleshooting (TODO)
│   └── LOAD_TEST_REPORT.md              # Load test results
│
├── conftest.py                          # pytest fixtures & config
├── pytest.ini                           # pytest configuration
├── requirements-test.txt                # Test dependencies
├── docker-compose.test.yml              # Test environment
├── docker-compose.staging.yml           # Staging environment
├── docker-compose.production.yml        # Production environment
└── README.md                            # This file
```

---

## 🚀 Instalação

### 1. Clonar Repositório
```bash
git clone https://github.com/seu-repo/neo-curriculos.git
cd neo-curriculos/07\ -\ BACKEND/neo-curriculos-testing
```

### 2. Instalar Dependências
```bash
# Python 3.11+
python --version

# Virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate.bat # Windows

# Instalar dependências
pip install -r requirements-test.txt
```

### 3. Setup Banco de Dados (para testes)
```bash
# MongoDB local (Docker)
docker run -d \
  --name mongodb-test \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  -p 27017:27017 \
  mongo:6.0

# Ou usar docker-compose
docker-compose -f docker-compose.test.yml up -d
```

### 4. Configurar Variáveis
```bash
# Copiar .env de exemplo
cp .env.example .env

# Editar com valores corretos
export FLASK_ENV=testing
export TEST_MONGO_URI=mongodb://admin:password@localhost:27017/neo_rh_test
export JWT_SECRET_KEY=test-secret-key-min-32-chars
```

---

## 🧪 Execução de Testes

### Testes E2E (30+ testes)
```bash
# Todos os E2E tests
pytest tests/10_TESTES_E2E.py -v

# Teste específico
pytest tests/10_TESTES_E2E.py::TestFluxoAutenticacao::test_registrar_candidato_sucesso -v

# Com coverage
pytest tests/10_TESTES_E2E.py --cov --cov-report=html
```

### Testes de Segurança (24+ testes)
```bash
# Todos os security tests
pytest tests/11_TESTES_SEGURANCA.py -v

# Apenas OWASP A01 (Injection)
pytest tests/11_TESTES_SEGURANCA.py::TestInjection -v

# Com bandit SAST
bandit -r . -ll --skip B101,B601
```

### Testes de Carga (12+ testes)
```bash
# Testes de baseline performance
pytest tests/12_LOAD_TESTING.py::TestBaselinePerformance -v

# Load testing (500 usuários)
pytest tests/12_LOAD_TESTING.py::TestLoadTesting -v

# Stress testing (até quebrar)
pytest tests/12_LOAD_TESTING.py::TestStressTesting -v

# Endurance testing (30 min)
pytest tests/12_LOAD_TESTING.py::TestEnduranceTesting -v
```

### Smoke Tests (5+ testes)
```bash
# Todos os smoke tests
pytest tests/14_SMOKE_TESTS.py -v -m smoke

# Apenas health checks
pytest tests/14_SMOKE_TESTS.py::TestSmokeHealthChecks -v

# Com base URL específica
pytest tests/14_SMOKE_TESTS.py -v --base-url=http://staging-server.com:5000
```

### Todos os Testes
```bash
# Run all tests
pytest tests/ -v

# With coverage
pytest tests/ --cov --cov-report=html --cov-report=xml

# Stop on first failure
pytest tests/ -x

# Show slowest 10 tests
pytest tests/ --durations=10

# Parallel execution
pytest tests/ -n auto
```

### Filtrar por Marker
```bash
# E2E tests only
pytest -m e2e -v

# Security tests only
pytest -m seguranca -v

# Smoke tests only
pytest -m smoke -v

# Load tests only
pytest -m load -v

# Exclude slow tests
pytest -m "not slow" -v
```

---

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

**Trigger:** Push to `develop` ou `main`, Pull Request

**Jobs:**
1. **lint-and-test** (Always)
   - Flake8 linting
   - Bandit security scan
   - pytest (unit + integration + E2E)
   - Coverage report

2. **build-docker** (After lint-and-test)
   - Build Docker image
   - Tag com SHA

3. **staging-deploy** (On develop, after build)
   - Deploy to staging server
   - Run smoke tests
   - Notify Slack

4. **performance-tests** (On develop, after deploy)
   - Load test baseline
   - Generate report

5. **production-deploy** (On main, manual approval)
   - Deploy to production
   - Run smoke tests
   - Notify team

6. **security-scan** (On PR / main)
   - Trivy vulnerability scan
   - SonarCloud analysis

### Rodar Workflow Localmente

```bash
# Instalar act (GitHub Actions locally)
brew install act  # macOS
# ou: https://github.com/nektos/act

# Rodar workflow
act -j lint-and-test

# Com dados de staging
act -j staging-deploy -s STAGING_SERVER=staging.example.com
```

---

## 📦 Deployment

### Staging (Automático)
```bash
# Push para develop
git push origin develop

# Workflow roda automaticamente
# Checks: GitHub Actions → ci-cd workflow → staging-deploy job

# Status: https://github.com/seu-repo/neo-curriculos/actions

# Verificar
curl http://staging-server.com:5000/health
```

### Manual (Se Necessário)
```bash
# SSH no servidor
ssh user@staging-server.com

# Deploy
cd /opt/neo-curriculos
bash scripts/deploy-staging.sh

# Verificar
curl -I http://localhost:5000/health
```

### Produção (Manual com Aprovação)
```bash
# Push para main
git push origin main

# Aguardar workflow rodar
# GitHub Actions pedirá aprovação

# Ambiente de produção
# https://github.com/seu-repo/neo-curriculos/actions/runs/123456

# Deploy será executado
# Smoke tests rodarão automaticamente

# Verificar
curl https://api.neo-curriculos.com/health
```

### Rollback
```bash
# Se algo der errado
bash scripts/rollback.sh

# Versão anterior será restaurada
docker-compose restart
```

---

## 📊 Monitoramento

### Prometheus
```bash
# Acessar Prometheus
http://localhost:9090

# Exemplo de query
up{job="neo-curriculos-api"}

# Gráficos disponíveis
- API availability
- Request latency (p50, p95, p99)
- Error rate
- Database connections
- Memory/CPU usage
```

### Grafana
```bash
# Acessar Grafana
http://localhost:3000
Username: admin
Password: admin

# Dashboards
- Neo Currículos API Overview
- Database Performance
- Infrastructure Health
- SLA Compliance
```

### Alertas
```bash
# Configurados automaticamente
- API Down (2min)
- High latency p95 > 2s (5min)
- High error rate > 5% (5min)
- High memory > 85% (5min)
- High CPU > 85% (10min)
- Disk space < 15% (10min)

# Notificações
- Slack: #neo-curriculos-alerts
- Email: devops-team@example.com
- PagerDuty: (se configurado)
```

---

## 🔧 Configuração

### Environment Variables

**Development:**
```bash
FLASK_ENV=development
MONGO_URI=mongodb://admin:password@localhost:27017/neo_rh
JWT_SECRET_KEY=dev-secret-key-min-32-chars
LOG_LEVEL=DEBUG
```

**Staging:**
```bash
FLASK_ENV=staging
MONGO_URI=mongodb://user:pass@mongo-staging:27017/neo_rh_staging
JWT_SECRET_KEY=<staging-secret>
STORAGE_TYPE=minio
```

**Production:**
```bash
FLASK_ENV=production
MONGO_URI=<prod-mongo-uri>
JWT_SECRET_KEY=<prod-secret>
STORAGE_TYPE=s3
AWS_S3_BUCKET=neo-curriculos-prod
LOG_LEVEL=WARN
```

### Secrets Management

**AWS Secrets Manager:**
```bash
# Store secrets
aws secretsmanager create-secret \
  --name neo-curriculos/prod/jwt-secret \
  --secret-string "$(openssl rand -base64 32)"

# Retrieve secrets
aws secretsmanager get-secret-value \
  --secret-id neo-curriculos/prod/jwt-secret
```

---

## 📚 Documentação

- [17_PRODUCTION_CHECKLIST.md](docs/17_PRODUCTION_CHECKLIST.md) - Pre-deployment checklist
- [DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md) - Deployment procedures
- [RUNBOOK.md](docs/RUNBOOK.md) - Troubleshooting guide (TODO)

---

## 🐛 Troubleshooting

### Testes não rodam
```bash
# Verificar Python
python --version  # Deve ser 3.11+

# Verificar dependências
pip list | grep pytest

# Reinstalar
pip install -r requirements-test.txt

# Verificar banco de dados
mongo --version
docker ps | grep mongodb
```

### Erro de conexão MongoDB
```bash
# Verificar conexão
mongo "mongodb://admin:password@localhost:27017"

# Verificar URI
echo $TEST_MONGO_URI

# Verificar container
docker logs mongodb-test
```

### Rate limiting nos testes
```bash
# Desabilitar rate limiting em testes
FLASK_ENV=testing pytest tests/

# Ou no código:
if app.config['FLASK_ENV'] == 'testing':
    limiter.disable()
```

### Testes lentos
```bash
# Rodar em paralelo
pytest -n auto tests/

# Mostrar mais lentos
pytest --durations=10 tests/

# Usar fixtures de cache
@pytest.fixture(scope="session")
def cached_data():
    # Setup once
    pass
```

---

## 📈 Métricas de Qualidade

### Coverage
- **Target:** > 70% de cobertura
- **Atual:** Executar `pytest --cov --cov-report=html`
- **Report:** `htmlcov/index.html`

### Test Counts
- **E2E:** 30+ testes
- **Security:** 24+ testes
- **Load:** 12+ testes
- **Smoke:** 5+ testes
- **Total:** 71+ testes

### SLAs
- **Availability:** 99.9%
- **Latency p95:** < 2s
- **Error rate:** < 1%

---

## 🚨 Checklist Pré-Produção

Antes de fazer deploy para produção:

- [ ] Todos os testes passam (`pytest -v`)
- [ ] Coverage > 70% (`pytest --cov`)
- [ ] Security scan passou (`bandit -r .`)
- [ ] Load tests passaram
- [ ] Smoke tests passaram
- [ ] Production checklist completo ([17_PRODUCTION_CHECKLIST.md](docs/17_PRODUCTION_CHECKLIST.md))
- [ ] Deployment guide revisado ([DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md))
- [ ] Todos os secrets em AWS Secrets Manager
- [ ] Backups configurados
- [ ] Monitoring ativo
- [ ] Team notificada

---

## 📞 Suporte

- **Documentação:** [docs/](docs/)
- **GitHub Issues:** [neo-curriculos/issues](https://github.com/seu-repo/neo-curriculos/issues)
- **Slack:** #neo-curriculos-dev
- **Email:** devops@example.com

---

## 📄 Licença

MIT License

---

## ✅ Próximos Passos (FASE 4+)

- [ ] Kubernetes deployment
- [ ] Helm charts
- [ ] Multi-region failover
- [ ] GraphQL API
- [ ] Real-time notifications (WebSocket)
- [ ] Advanced analytics
- [ ] AI-powered CV parsing

---

*Última atualização: 2026-09-07*  
*Versão: 1.0.0*  
*Status: ✅ Production Ready*
