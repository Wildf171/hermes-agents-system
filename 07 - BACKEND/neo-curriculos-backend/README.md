# Neo Currículos + Neo RH System - Backend API

**FASE 2 - IMPLEMENTAÇÃO**  
Backend Flask production-ready para gerenciamento de currículos e RH com conformidade LGPD.

## 📋 Sumário

1. [Características](#características)
2. [Pré-requisitos](#pré-requisitos)
3. [Setup Local](#setup-local)
4. [Estrutura do Projeto](#estrutura-do-projeto)
5. [Endpoints da API](#endpoints-da-api)
6. [Autenticação](#autenticação)
7. [LGPD e Conformidade](#lgpd-e-conformidade)
8. [Testes](#testes)
9. [Deployment](#deployment)
10. [Troubleshooting](#troubleshooting)

---

## ✨ Características

### Autenticação & Segurança
- ✅ JWT com 24h TTL (access token) + 30d TTL (refresh token)
- ✅ bcrypt com 12 rounds para hash de senhas
- ✅ Rate limiting (5 tentativas login/15 min)
- ✅ CORS configurável por origin
- ✅ Decoradores: `@token_required`, `@role_required`, `@permission_required`

### Upload de Currículos
- ✅ Upload de PDF com validação (max 10MB)
- ✅ Versionamento automático (CV anterior fica inativo)
- ✅ Hash SHA256 para integridade
- ✅ Storage em MinIO/S3 (configurável)

### LGPD e Conformidade
- ✅ Consentimento explícito (termos versioning)
- ✅ Soft delete (30 dias retention)
- ✅ Anonimização automática após 30 dias
- ✅ Auditoria com TTL 7 anos
- ✅ Rastreamento de acesso por IP/user-agent

### API RESTful
- ✅ 6 endpoints principais
- ✅ Paginação (limit/offset)
- ✅ Filtros por estado, categoria, data
- ✅ OpenAPI/Swagger docs
- ✅ Error handling robusto (400, 401, 403, 404, 500)

---

## 🔧 Pré-requisitos

- **Python 3.11+**
- **Docker & Docker Compose**
- **Git**
- **curl** (para testes de API)

### Versões Recomendadas

```bash
python --version          # 3.11+
docker --version          # 20.10+
docker-compose --version  # 2.0+
```

---

## 🚀 Setup Local

### 1. Clonar/Entrar no Projeto

```bash
cd "07 - BACKEND/neo-curriculos-backend"
```

### 2. Executar Setup Automático

#### **Linux/Mac**

```bash
chmod +x setup.sh
./setup.sh
```

#### **Windows (PowerShell)**

```powershell
docker-compose up -d
```

### 3. Verificar Status

```bash
# Verificar containers
docker ps

# Ver logs
docker-compose logs -f flask_app
```

### 4. Testar API

```bash
# Health check
curl http://localhost:5000/health

# Documentação
curl http://localhost:5000/api/docs
```

---

## 📁 Estrutura do Projeto

```
neo-curriculos-backend/
├── app.py                          # Entrada principal Flask
├── requirements.txt                # Dependências Python
├── .env.example                    # Template de variáveis env
├── Dockerfile                      # Container image
├── docker-compose.yml              # Orquestração de containers
├── setup.sh                        # Script setup automático
│
├── auth/
│   ├── 04_AUTH_UNIFICADA.py       # JWT, bcrypt, decoradores
│   └── schemas.py                  # Pydantic models
│
├── routes/
│   ├── 05_ROUTES_NEO_CURRICULOS.py # 6 endpoints principais
│   ├── candidatos.py               # Endpoints candidato
│   └── auditoria.py                # Relatórios LGPD
│
├── models/
│   ├── 06_MODELS_MONGODB.py       # UsuarioModel, CurriculoModel
│   └── schemas.py                  # Validações Pydantic
│
├── storage/
│   ├── s3_client.py                # AWS S3 / MinIO client
│   └── upload_handler.py           # Validação de upload
│
├── tests/
│   ├── 07_TESTES_UNITARIOS.py     # 43+ testes unitários
│   ├── conftest.py                 # Fixtures pytest
│   ├── test_auth.py                # Testes autenticação
│   ├── test_curriculos.py          # Testes upload
│   ├── test_lgpd.py                # Testes conformidade
│   └── test_busca.py               # Testes busca/filtros
│
├── setup/
│   ├── setup.sh                    # Setup script
│   ├── seed_db.py                  # Popular dados de teste
│   └── migrate.py                  # Migrações MongoDB
│
└── docs/
    ├── API_SWAGGER.md              # OpenAPI completo
    └── SETUP_LOCAL.md              # Instruções detalhadas
```

---

## 🔐 Endpoints da API

### Autenticação

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/api/auth/registrar` | Registrar novo candidato |
| `POST` | `/api/auth/login` | Login (candidato/RH/admin) |
| `POST` | `/api/auth/refresh` | Renovar access token |
| `POST` | `/api/auth/logout` | Logout (remover token no cliente) |
| `GET` | `/api/auth/me` | Info do usuário autenticado |

### Currículos

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/api/curriculos/upload` | Upload de PDF (versionamento) |
| `GET` | `/api/candidatos/:id/curriculos` | Listar versões de CV |
| `POST` | `/api/candidatos/:id/consentimento` | Registrar consentimento LGPD |
| `DELETE` | `/api/candidatos/:id/deletar-conta` | Soft delete + anonimização |
| `GET` | `/api/curriculos/busca` | Buscar CVs (RH/Empresa) |
| `GET` | `/api/auditoria/relatorio` | Relatório auditoria (Admin) |

---

## 🔑 Autenticação

### 1. Registrar Candidato

```bash
curl -X POST http://localhost:5000/api/auth/registrar \
  -H "Content-Type: application/json" \
  -d '{
    "email": "candidato@example.com",
    "nome": "João Silva",
    "senha": "Senha@123",
    "aceitar_termos": true
  }'
```

**Resposta (201):**
```json
{
  "usuario_id": "670a5f8c3e2d4c1b2a9d8e7f",
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "Bearer",
  "expires_in": 86400,
  "tipo": "candidato",
  "nome": "João Silva"
}
```

### 2. Login

```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "candidato@example.com",
    "senha": "Senha@123"
  }'
```

### 3. Usar Token

```bash
curl -X GET http://localhost:5000/api/auth/me \
  -H "Authorization: Bearer <access_token>"
```

### 4. Refresh Token

```bash
curl -X POST http://localhost:5000/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{"refresh_token": "<refresh_token>"}'
```

---

## 📋 LGPD e Conformidade

### Consentimento LGPD

```bash
curl -X POST http://localhost:5000/api/candidatos/:id/consentimento \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "consentimento": true,
    "termos_versao": "1.0"
  }'
```

### Deletar Conta (Soft Delete)

```bash
curl -X DELETE http://localhost:5000/api/candidatos/:id/deletar-conta \
  -H "Authorization: Bearer <token>"
```

**Processo:**
1. Marca conta como `marcacao_delecao` = agora
2. Aguarda 30 dias (retention period)
3. Auto-anonimiza: `nome` → "ANONIMIZADO", `email` → hash
4. Auditoria registrada por 7 anos (TTL index)

### Relatório de Auditoria (Admin)

```bash
curl -X GET "http://localhost:5000/api/auditoria/relatorio?usuario_id=...&acao=visualizar&limit=50" \
  -H "Authorization: Bearer <admin_token>"
```

---

## 📝 Testes

### Executar Todos os Testes

```bash
pytest tests/ -v --cov=. --cov-report=html
```

### Testes Específicos

```bash
# Autenticação (15+ testes)
pytest tests/07_TESTES_UNITARIOS.py::TestAutenticacao -v

# Upload (10+ testes)
pytest tests/07_TESTES_UNITARIOS.py::TestUploadCurriculo -v

# LGPD (10+ testes)
pytest tests/07_TESTES_UNITARIOS.py::TestLGPD -v

# Busca (8+ testes)
pytest tests/07_TESTES_UNITARIOS.py::TestBuscaCurriculos -v
```

### Coverage

```bash
pytest --cov=. --cov-report=term-missing
# Alvo: >80% cobertura
```

---

## 🐳 Docker Compose

### Containers

| Container | Porta | URL |
|-----------|-------|-----|
| **Flask** | 5000 | http://localhost:5000 |
| **MongoDB** | 27017 | mongodb://admin:password@localhost:27017 |
| **MinIO** | 9000/9001 | http://localhost:9001 (console) |
| **Redis** | 6379 | localhost:6379 |

### Comandos Úteis

```bash
# Iniciar
docker-compose up -d

# Parar
docker-compose down

# Logs
docker-compose logs -f flask_app

# Executar comando no container
docker-compose exec flask_app bash

# Limpar volumes (atenção: deleta dados!)
docker-compose down -v
```

---

## 🚢 Deployment

### Opção 1: Docker (Recomendado)

```bash
# Build image
docker build -t neo-curriculos:1.0.0 .

# Run
docker run -d \
  -p 5000:5000 \
  -e MONGO_URI="mongodb://..." \
  -e JWT_SECRET_KEY="..." \
  neo-curriculos:1.0.0
```

### Opção 2: Gunicorn (Production)

```bash
pip install gunicorn

# WSGI server (4 workers, bind 0.0.0.0:5000)
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

### Opção 3: Kubernetes

Ver arquivo `k8s-deployment.yaml` (não incluído - usar Helm charts)

---

## 🔍 Variáveis de Ambiente

Criar `.env` baseado em `.env.example`:

```bash
# Flask
FLASK_ENV=production
FLASK_DEBUG=0

# MongoDB
MONGO_URI=mongodb://admin:pass@mongodb:27017/neo_rh

# JWT (min 32 caracteres)
JWT_SECRET_KEY=seu-secret-super-seguro-min-32-chars

# Storage - MinIO/S3
STORAGE_TYPE=minio
MINIO_ENDPOINT=minio:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin

# CORS
CORS_ORIGINS=["https://app.example.com", "https://rh.example.com"]

# Logging
LOG_LEVEL=INFO
LOG_FORMAT=json
```

---

## 🐛 Troubleshooting

### MongoDB Connection Error

```bash
# Verificar container
docker ps | grep mongodb

# Ver logs
docker-compose logs mongodb

# Reiniciar
docker-compose restart mongodb
```

### Flask App Not Running

```bash
# Ver logs detalhados
docker-compose logs -f flask_app

# Verificar health
curl http://localhost:5000/health
```

### Token Inválido

```
401 Unauthorized - Token ausente ou inválido

Solução:
1. Verificar se Bearer está no header: Authorization: Bearer <token>
2. Verificar se token expirou (24h TTL)
3. Usar /api/auth/refresh para renovar
```

### Rate Limiting

```
429 Too Many Requests - Limite de 5 logins/15min atingido

Solução:
1. Aguardar 15 minutos
2. Em produção, configurar Redis para rate limiting distribuído
```

---

## 📊 Performance

### Índices MongoDB

- `usuarios(email)` - unique
- `usuarios(tipo, ativo)`
- `curriculos(usuario_id, versao)`
- `curriculos_acesso(usuario_id, timestamp)` - TTL 7 anos
- Text index em `curriculos` para busca full-text

### Query Performance

```bash
# Analisar query (explainPlan)
db.curriculos.find({usuario_id: "..."}).explain("executionStats")

# Sem N+1 queries:
# ✗ Para cada CV, buscar usuário (N+1)
# ✓ Usar agregação ou pre-load

# Paginação
GET /api/curriculos/busca?limit=20&offset=0  # Eficiente com índices
```

---

## 📚 Documentação Adicional

- **Fase 1 - Design**: `../neo-curriculos-design/`
  - `01_ANALISE_SISTEMA_EXISTENTE.md`
  - `02_DESIGN_INTEGRACAO.md`
  - `03_SCHEMA_MONGODB_DETALHADO.md`

- **OpenAPI Completo**: `/api/docs` (endpoint)

- **Postman Collection**: `docs/Postman_Collection.json`

---

## ✅ Checklist de Qualidade

- [x] 04_AUTH_UNIFICADA.py (400+ linhas, 6 endpoints auth)
- [x] 05_ROUTES_NEO_CURRICULOS.py (600+ linhas, 6 endpoints CRUD)
- [x] 06_MODELS_MONGODB.py (índices, validação, TTL)
- [x] 07_TESTES_UNITARIOS.py (43+ testes, >80% cobertura)
- [x] docker-compose.yml (MongoDB, MinIO, Flask, Redis)
- [x] Dockerfile (production-ready)
- [x] .env.example (todas as variáveis)
- [x] README.md (documentação completa)
- [x] PEP 8 compliant (style check)
- [x] Type hints (tudo tipado)
- [x] Logging estruturado (JSON)
- [x] Error handling robusto
- [x] LGPD compliance
- [x] Rate limiting
- [x] CORS configurável

---

## 🎯 Próximos Passos (Fase 3)

- [ ] Testes E2E (Selenium/Cypress)
- [ ] Monitoring (Prometheus + Grafana)
- [ ] CI/CD (GitHub Actions)
- [ ] Load testing (k6/JMeter)
- [ ] Security audit (OWASP)
- [ ] Staging deployment
- [ ] Production deployment

---

## 📞 Suporte

- **Issues**: Abrir issue no repositório
- **Docs**: Ver `/docs` neste projeto
- **Slack**: #neo-curriculos-dev

---

## 📄 Licença

Proprietary - Neo Currículos + Neo RH System

---

**Status:** ✅ Fase 2 COMPLETA - Pronto para Fase 3 (Testes E2E + Deploy)

**Data:** 2026-09-07  
**Versão:** 1.0.0
