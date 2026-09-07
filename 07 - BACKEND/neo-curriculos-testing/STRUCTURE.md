# STRUCTURE.md - Arquitetura do Projeto

**Versão:** 1.0.0  
**Data:** 2026-09-07

Documentação completa da estrutura de diretórios e arquivos do projeto FASE 3.

---

## 📁 Árvore de Diretórios

```
neo-curriculos-testing/
│
├── 📄 README.md                          # Documentação principal
├── 📄 STRUCTURE.md                       # Este arquivo
├── 📄 .gitignore                         # Git ignore patterns
│
│
├── 🧪 tests/                             # Suíte de testes
│   ├── 📄 10_TESTES_E2E.py               # 30+ E2E tests
│   ├── 📄 11_TESTES_SEGURANCA.py         # 24+ security tests (OWASP Top 10)
│   ├── 📄 12_LOAD_TESTING.py             # 12+ load/performance tests
│   └── 📄 14_SMOKE_TESTS.py              # 5+ health check tests
│
├── 🔧 conftest.py                        # Pytest fixtures e configuration
├── 📋 pytest.ini                         # Pytest settings
├── 📋 requirements-test.txt              # Python dependencies
│
│
├── 🚀 .github/
│   └── workflows/
│       └── 📄 ci-cd.yml                  # GitHub Actions pipeline
│
├── 📦 scripts/
│   ├── 📄 15_DEPLOY_STAGING.sh           # Staging deployment (automated)
│   ├── 📄 deploy-production.sh           # Production deployment (manual)
│   └── 📄 rollback.sh                    # Rollback script (TODO)
│
├── 📊 monitoring/
│   ├── 📄 16_MONITORING_PROMETHEUS.yml   # Prometheus configuration
│   ├── 📄 alert-rules.yml                # Alert rules for Prometheus
│   └── 📄 recording-rules.yml            # Recording rules (TODO)
│
├── 📚 docs/
│   ├── 📄 17_PRODUCTION_CHECKLIST.md     # Pre-deployment checklist (200+ linhas)
│   ├── 📄 DEPLOYMENT_GUIDE.md            # Deployment procedures guide
│   ├── 📄 RUNBOOK.md                     # Troubleshooting guide (TODO)
│   └── 📄 LOAD_TEST_REPORT.md            # Load test results report
│
├── 🐳 docker-compose.test.yml            # Test environment (TODO)
├── 🐳 docker-compose.staging.yml         # Staging environment (TODO)
└── 🐳 docker-compose.production.yml      # Production environment (TODO)
```

---

## 📄 Descrição dos Arquivos

### 🧪 Testes (tests/)

#### `10_TESTES_E2E.py` (800-1000 linhas)
**Propósito:** Testes end-to-end que testam fluxos completos

**Classes:**
- `TestFluxoAutenticacao` - 5 testes
  - Registrar candidato
  - Email duplicado
  - Login sucesso
  - Login senha errada
  - Logout

- `TestUploadCurriculo` - 8 testes
  - Upload PDF válido
  - Upload não-PDF
  - Upload > 10MB
  - Múltiplas versões
  - Versão ativa
  - Hash único
  - Sem consentimento

- `TestLGPDConsentimento` - 7 testes
  - Consentimento LGPD
  - Sem consentimento
  - Deletar conta (soft delete)
  - Anonimização (30 dias)
  - Auditoria registrada
  - TTL index

- `TestBuscaFiltros` - 5 testes
  - Busca RH com paginação
  - Candidato não consegue buscar
  - Listar próprios CVs

- `TestAuditoria` - 3 testes
  - Upload registrado
  - Admin relatório
  - Acesso registrado

- `TestRateLimiting` - 2 testes
  - Rate limit login
  - Rate limit por usuário

**Total:** 30+ testes
**Execução:** `pytest tests/10_TESTES_E2E.py -v`

---

#### `11_TESTES_SEGURANCA.py` (500-600 linhas)
**Propósito:** Testes de segurança cobrindo OWASP Top 10

**Classes:**
- `TestAutenticacao` - 6 testes
  - JWT sem assinatura
  - JWT expirado
  - JWT modificado
  - Candidato acessa admin
  - Usuário edita outro perfil

- `TestInjection` - 6 testes
  - SQL injection
  - NoSQL injection
  - XSS prevention
  - Path traversal
  - Validação de tipos
  - CSRF token

- `TestDataExposure` - 4 testes
  - Senha nunca retornada
  - JWT não em logs
  - HTTPS obrigatório
  - Dados sensíveis fora de logs

- `TestAccessControl` - 3 testes
  - Candidato vê apenas seus CVs
  - RH acessa apenas sua empresa
  - Soft-deleted users bloqueados

- `TestSecurityHeaders` - 4 testes
  - Content-Security-Policy
  - X-Frame-Options: DENY
  - X-Content-Type-Options: nosniff
  - Strict-Transport-Security

- `TestLGPDSecurity` - 3 testes
  - Dados deletados não recuperáveis
  - Anonimização funciona
  - Direito ao esquecimento

**Total:** 24+ testes
**Execução:** `pytest tests/11_TESTES_SEGURANCA.py -v`

---

#### `12_LOAD_TESTING.py` (400-500 linhas)
**Propósito:** Testes de carga e performance

**Classes:**
- `TestBaselinePerformance` - 5 testes
  - GET /api/candidatos: < 100ms
  - POST /api/curriculos/upload: < 2s
  - GET /api/curriculos/busca: < 200ms
  - GET /api/auditoria/relatorio: < 500ms
  - GET /health: < 20ms

- `TestLoadTesting` - 3 testes
  - 100 usuários × 5 min
  - 500 usuários × 2 min
  - 1000 req/s throughput

- `TestStressTesting` - 2 testes
  - Aumentar carga até quebrar
  - Recovery automático

- `TestEnduranceTesting` - 2 testes
  - 50 usuários × 30 min
  - Linear DB growth

**Total:** 12+ testes
**Execução:** `pytest tests/12_LOAD_TESTING.py -v`
**Output:** `LOAD_TEST_REPORT.md`

---

#### `14_SMOKE_TESTS.py` (200-300 linhas)
**Propósito:** Testes rápidos de health check pós-deployment

**Classes:**
- `TestSmokeHealthChecks` - 6 testes
  - API health
  - Database connection
  - Storage connection
  - Auth flow
  - Headers segurança
  - JSON válido

- `TestSmokePostDeployment` - 4 testes
  - Versão correta
  - Sem erros 500
  - Tempo resposta < 500ms
  - Base URL acessível

**Total:** 5+ testes
**Execução:** `pytest tests/14_SMOKE_TESTS.py -v -m smoke`
**Tempo:** < 30s

---

### 🔧 Configuração Pytest

#### `conftest.py`
**Propósito:** Fixtures e configuration compartilhadas

**Fixtures:**
- `client` - Flask test client
- `db_clean` - Banco limpo antes de cada teste
- `registrar_candidato` - Candidato pré-registrado
- `registrar_rh` - Usuário RH pré-registrado
- `jwt_token` - Token JWT válido
- `pdf_file` - Arquivo PDF de teste
- `arquivo_grande` - Arquivo > 10MB
- `arquivo_txt` - Arquivo não-PDF

**Pytest Hooks:**
- `pytest_configure` - Setup inicial
- `pytest_collection_modifyitems` - Adicionar markers

---

#### `pytest.ini`
**Propósito:** Configuração do pytest

**Configurações:**
- `testpaths` = `tests/`
- `markers` = `e2e`, `seguranca`, `load`, `smoke`
- `addopts` = coverage, cov-report, strict-markers
- `log_cli_level` = INFO
- `timeout` = 300s

---

#### `requirements-test.txt`
**Propósito:** Dependências Python

**Dependências principais:**
- pytest 7.4.0
- requests 2.31.0
- mongomock 4.1.2
- Flask 2.3.2
- PyJWT 2.8.1
- bandit 1.7.5
- flake8 6.0.0

**Total:** 40+ dependências

---

### 🚀 CI/CD Pipeline

#### `.github/workflows/ci-cd.yml` (300-400 linhas)
**Propósito:** Pipeline de CI/CD automático

**Jobs:**
1. `lint-and-test`
   - Flake8 linting
   - Bandit security scan
   - pytest (unit + E2E + security)
   - Coverage report

2. `build-docker`
   - Build Docker image
   - Tag com SHA

3. `staging-deploy` (on develop)
   - Deploy automático
   - Smoke tests
   - Slack notifications

4. `performance-tests` (on develop)
   - Load test baseline

5. `production-deploy` (on main)
   - Deploy produção
   - Smoke tests
   - Notifications

6. `security-scan` (on PR / main)
   - Trivy vulnerability scan
   - SonarCloud analysis

**Triggers:**
- Push to `main`, `develop`, `feature/*`
- Pull Request to `main`, `develop`

**Secrets:**
- STAGING_SERVER, STAGING_USER, STAGING_SSH_KEY
- PROD_SERVER, PROD_USER, PROD_SSH_KEY
- JWT_SECRET_KEY
- SLACK_WEBHOOK
- SONAR_TOKEN

---

### 📦 Scripts de Deployment

#### `scripts/15_DEPLOY_STAGING.sh` (150-200 linhas)
**Propósito:** Deployment automático para staging

**Passos:**
1. Pré-checks (SSH, variáveis, conectividade)
2. Pull latest code
3. Build Docker image
4. Backup containers antigos
5. Executar migrations
6. Stop containers antigos
7. Start novo container
8. Health check (retry 10x)
9. Validação pós-deployment
10. Cleanup
11. Notificação Slack

**Execução:**
```bash
bash scripts/deploy-staging.sh
```

**Variáveis de Ambiente:**
- STAGING_SERVER
- STAGING_USER
- STAGING_SSH_KEY
- MONGO_URI
- JWT_SECRET_KEY

---

#### `scripts/deploy-production.sh` (TODO)
**Propósito:** Deployment manual para produção

**Similar ao staging mas com:**
- Requer aprovação manual
- Horário específico (baixa atividade)
- Notificações mais agressivas
- Rollback mais fácil

---

### 📊 Monitoramento

#### `monitoring/16_MONITORING_PROMETHEUS.yml` (100-150 linhas)
**Propósito:** Configuração do Prometheus

**Scrape Configs:**
- neo-curriculos-api (localhost:5000)
- mongodb (localhost:27017)
- node-exporter (localhost:9100)
- redis (localhost:6379)
- docker-daemon (localhost:9323)
- prometheus (localhost:9090)

**Alertmanagers:**
- localhost:9093

**Métricas Coletadas:**
- http_request_duration_seconds
- http_requests_total
- mongodb_connections
- node_cpu_seconds_total
- node_memory_MemTotal_bytes

---

#### `monitoring/alert-rules.yml`
**Propósito:** Regras de alertas

**Grupos de Alertas:**
1. **neo-curriculos-alerts**
   - APIDown
   - APIHighLatency
   - APIHighErrorRate
   - MongoDBDown
   - HighMemoryUsage
   - HighCPUUsage
   - DiskWillBeFull
   - AuthenticationFailures

2. **neo-curriculos-lgpd**
   - LGPDComplianceCheck
   - AuditLogRetention

**Severity:** info, warning, critical

---

### 📚 Documentação

#### `docs/17_PRODUCTION_CHECKLIST.md` (200+ linhas)
**Propósito:** Checklist pré-deployment

**Seções:**
1. Segurança (credenciais, autenticação, HTTPS, criptografia)
2. Performance (database, caching, load balancing, auto-scaling)
3. Compliance (LGPD, consentimento, retenção, auditoria)
4. Infraestrutura (cloud, database, storage, logging)
5. Operacional (deployment, monitoring, documentation)
6. Testes (unit, integration, E2E, security, load)
7. Configuração (env vars, secrets, feature flags)
8. Compliance Legal (terms, privacy, LGPD, terceiros)
9. Comunicação (status page, customer communication)
10. Financeiro (costs, SLAs, escalabilidade)

**Sign-off:** Tech Lead, Security, Operations, Manager

---

#### `docs/DEPLOYMENT_GUIDE.md`
**Propósito:** Guia detalhado de deployment

**Seções:**
1. Pré-Requisitos
2. Ambiente (staging vs produção)
3. Preparação
4. Deployment Staging (automático + manual)
5. Deployment Produção
6. Verificação Pós-Deploy
7. Rollback
8. Troubleshooting

---

#### `docs/RUNBOOK.md` (TODO)
**Propósito:** Procedimentos de troubleshooting

**Tópicos:**
- API não responde
- Alta latência
- Database errors
- Memory leaks
- Authentication errors
- Etc.

---

#### `docs/LOAD_TEST_REPORT.md`
**Propósito:** Relatório de testes de carga

**Seções:**
- Baseline Performance
- Load Testing Results
- Stress Testing Results
- Endurance Testing Results
- Recomendações
- Conclusão

---

## 🔗 Dependências Entre Arquivos

```
CI/CD Pipeline (.github/workflows/ci-cd.yml)
    ↓
    ├→ Lint & Test
    │   └→ conftest.py + pytest.ini + requirements-test.txt
    │       └→ 10_TESTES_E2E.py
    │       └→ 11_TESTES_SEGURANCA.py
    │       └→ 12_LOAD_TESTING.py
    │       └→ 14_SMOKE_TESTS.py
    │
    ├→ Build Docker
    │   └→ Dockerfile + requirements.txt
    │
    ├→ Deploy Staging
    │   └→ scripts/15_DEPLOY_STAGING.sh
    │       └→ monitoring/16_MONITORING_PROMETHEUS.yml
    │       └→ alert-rules.yml
    │
    └→ Deploy Production
        └→ scripts/deploy-production.sh
            └→ docs/17_PRODUCTION_CHECKLIST.md
            └→ docs/DEPLOYMENT_GUIDE.md
            └→ docs/RUNBOOK.md
```

---

## 📊 Estatísticas

| Métrica | Valor |
|---------|-------|
| Total de Arquivos | 15+ |
| Total de Linhas | 2000+ |
| Testes E2E | 30+ |
| Testes Segurança | 24+ |
| Testes Carga | 12+ |
| Testes Smoke | 5+ |
| **Total de Testes** | **71+** |
| Scripts | 2+ |
| Documentação | 5 arquivos |
| Configurações | 3 arquivos |

---

## 🚀 Fluxo de Desenvolvimento

```
1. Developer escreve código
   ↓
2. Push para feature branch
   ↓
3. GitHub Actions roda testes
   ├→ Lint (Flake8, Black)
   ├→ Security (Bandit)
   ├→ Unit tests
   ├→ E2E tests
   └→ Coverage report
   ↓
4. Pull Request para develop
   ├→ Code review
   ├→ Approval
   └→ Merge
   ↓
5. Push para develop
   ├→ Tests + Build
   ├→ Deploy Staging (automático)
   ├→ Smoke tests
   ├→ Performance tests
   └→ Slack notification
   ↓
6. Manual review em staging
   ↓
7. Pull Request para main
   ↓
8. Approval de Production
   ↓
9. Push para main
   ├→ Tests + Build
   ├→ Tag version
   └→ Deploy Production (com aprovação)
   ↓
10. Smoke tests em produção
    ↓
11. Monitoring 24/7
```

---

## 🔐 Segurança de Arquivos

| Arquivo | Confidencial | Backup | Versioning |
|---------|-------------|--------|------------|
| .env* | ✅ | ✅ | ❌ (git ignore) |
| *.pem, *.key | ✅ | ✅ | ❌ (git ignore) |
| ci-cd.yml | ❌ | ✅ | ✅ |
| Testes | ❌ | ✅ | ✅ |
| Docs | ❌ | ✅ | ✅ |

---

## 📚 Referências

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Pytest Docs](https://docs.pytest.org/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Prometheus](https://prometheus.io/docs/)
- [MongoDB Docs](https://docs.mongodb.com/)

---

*Última atualização: 2026-09-07*  
*Versão: 1.0.0*  
*Status: ✅ Complete*
