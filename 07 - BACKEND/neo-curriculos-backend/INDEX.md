# Neo Currículos + Neo RH System - Backend - Índice de Navegação

**Status:** ✅ FASE 2 - IMPLEMENTAÇÃO COMPLETA  
**Versão:** 1.0.0  
**Data:** 2026-09-07  

---

## 🚀 COMECE AQUI

### Para Entender o Projeto
1. **[README.md](README.md)** - Documentação principal (setup, endpoints, exemplos)
2. **[PHASE2_SUMMARY.md](PHASE2_SUMMARY.md)** - Sumário da Fase 2 com checklist completo
3. **[docs/API_SWAGGER.md](docs/API_SWAGGER.md)** - Documentação OpenAPI completa

### Para Fazer Setup Local
1. `./setup.sh` (Linux/Mac) ou `docker-compose up -d` (Windows)
2. Seguir [README.md - Setup Local](README.md#-setup-local)
3. Verificar `http://localhost:5000/health`

### Para Usar a API
1. Ver [docs/API_SWAGGER.md](docs/API_SWAGGER.md) para endpoint específico
2. Exemplos cURL em [docs/API_SWAGGER.md - Exemplos](docs/API_SWAGGER.md#-exemplos-curl)
3. OpenAPI interativo: `http://localhost:5000/api/docs`

---

## 📁 ESTRUTURA DE ARQUIVOS

### Arquivos Raiz (Configuração)
| Arquivo | Propósito | Lê-me |
|---------|-----------|-------|
| **app.py** | Entrada Flask, app factory, blueprints | Produção |
| **requirements.txt** | Dependências Python (29 pacotes) | Produção |
| **.env.example** | Variáveis de ambiente | Antes de setup |
| **Dockerfile** | Container image | DevOps |
| **docker-compose.yml** | Orquestração (MongoDB, MinIO, Flask, Redis) | DevOps |
| **setup.sh** | Script setup automático | Antes de rodar |
| **pytest.ini** | Configuração pytest | Testes |
| **.gitignore** | Git ignore rules | Git |

---

## 🔐 MÓDULO AUTH - Autenticação e JWT

**Arquivo:** `auth/04_AUTH_UNIFICADA.py` (580 linhas)

### O que tem?
- JWT tokens (24h TTL access, 30d TTL refresh)
- bcrypt senha (12 rounds)
- Decoradores: `@token_required`, `@role_required`, `@permission_required`
- Rate limiting (5 login/15 min)
- Pydantic schemas para validação

### Endpoints
```
POST   /api/auth/registrar        # Novo candidato
POST   /api/auth/login            # Login
POST   /api/auth/refresh          # Renovar token
POST   /api/auth/logout           # Logout
GET    /api/auth/me               # Info usuário
```

### Documentação
- [docs/API_SWAGGER.md - Autenticação](docs/API_SWAGGER.md#-autenticação)
- [README.md - Autenticação](README.md#-autenticação)
- Exemplos cURL inclusos

---

## 📄 MÓDULO ROTAS - Currículos e LGPD

**Arquivo:** `routes/05_ROUTES_NEO_CURRICULOS.py` (580 linhas)

### O que tem?
- Upload de PDF (versionamento, hash SHA256)
- Consentimento LGPD (termos versioning)
- Soft delete + anonimização automática (30 dias)
- Busca de CVs (RH/Empresa)
- Relatório auditoria (Admin, TTL 7 anos)
- Paginação e filtros

### Endpoints
```
POST   /api/curriculos/upload                 # Upload PDF
GET    /api/candidatos/:id/curriculos         # Listar versões
POST   /api/candidatos/:id/consentimento      # Consentimento LGPD
DELETE /api/candidatos/:id/deletar-conta      # Soft delete
GET    /api/curriculos/busca                  # Buscar (RH)
GET    /api/auditoria/relatorio               # Auditoria (Admin)
```

### Documentação
- [docs/API_SWAGGER.md - Currículos](docs/API_SWAGGER.md#-currículos)
- [docs/API_SWAGGER.md - Auditoria LGPD](docs/API_SWAGGER.md#-auditoria-lgpd)
- Rate limits documentados

---

## 💾 MÓDULO MODELS - MongoDB

**Arquivo:** `models/06_MODELS_MONGODB.py` (380 linhas)

### O que tem?
- `UsuarioModel` - candidatos, RH, admin
- `CurriculoModel` - versionamento automático
- `CurriculoAcessoModel` - auditoria LGPD (TTL 7 anos)
- 15 índices MongoDB otimizados
- Métodos CRUD e helpers
- Pydantic schemas para validação

### Collections MongoDB

**usuarios**
```javascript
{
  _id: ObjectId,
  email: string (unique),
  nome: string,
  tipo: "candidato" | "rh" | "admin" | "empresa",
  senha_hash: string (bcrypt),
  consentimento: boolean,
  marcacao_delecao: Date (soft delete),
  anonimizado: boolean,
  ativo: boolean,
  criado_em: Date
}
```

**curriculos**
```javascript
{
  _id: ObjectId,
  usuario_id: string,
  versao: number,
  arquivo_url: string (S3),
  arquivo_hash: string (SHA256),
  arquivo_tamanho: number,
  ativo: boolean,
  criado_em: Date
}
```

**curriculos_acesso** (LGPD - TTL 7 anos)
```javascript
{
  _id: ObjectId,
  usuario_id: string,
  acessado_por: string,
  acao: "visualizar" | "download" | "compartilhar",
  timestamp: Date,
  ip_address: string,
  user_agent: string,
  ttl: Date (auto-delete)
}
```

### Índices
- 4 em `usuarios` (unique email, tipo, soft delete, TTL)
- 4 em `curriculos` (user+version, hash, ativo, data)
- 7 em `curriculos_acesso` (usuario, rh, acao, TTL, data)

---

## 🧪 TESTES - Pytest

**Arquivo:** `tests/07_TESTES_UNITARIOS.py` (650 linhas)

### Cobertura
- **Autenticação (15 testes):** Registro, login, token, refresh, validação
- **Upload (10 testes):** PDF, tamanho, hash, versionamento, auditoria
- **LGPD (10 testes):** Consentimento, soft delete, anonimização, TTL
- **Busca (8 testes):** Filtros, paginação, permissões
- **Segurança (2 testes):** bcrypt, JWT

**Total:** 45+ testes | Cobertura: ~85%

### Como rodar

```bash
# Todos os testes
pytest tests/ -v --cov=. --cov-report=html

# Testes específicos
pytest tests/07_TESTES_UNITARIOS.py::TestAutenticacao -v
pytest -m auth -v
pytest -m lgpd -v
pytest -m upload -v

# Com coverage
pytest --cov=. --cov-report=term-missing
```

### Fixtures (conftest.py)
- `app` - Flask app de teste
- `client` - Test client
- `usuario_teste` - Dados candidato
- `usuario_rh_teste` - Dados RH
- `usuario_admin_teste` - Dados admin
- `token_valido` - JWT válido
- `curriculo_teste` - Dados CV
- `pdf_file` - PDF fake
- `audit_log_teste` - Log auditoria

---

## 📖 DOCUMENTAÇÃO

### Arquivo: docs/API_SWAGGER.md (OpenAPI Completo)
- Descrição de todos os 11 endpoints
- Request/response examples
- Query params e headers
- Status codes (200, 201, 400, 401, 403, 404, 500)
- Rate limits
- Exemplos cURL prontos

### Arquivo: README.md (Guia Principal)
- [Características](README.md#-características)
- [Setup Local](README.md#-setup-local)
- [Endpoints da API](README.md#-endpoints-da-api)
- [Autenticação](README.md#-autenticação)
- [LGPD e Conformidade](README.md#-lgpd-e-conformidade)
- [Testes](README.md#-testes)
- [Docker](README.md#-docker-compose)
- [Deployment](README.md#-deployment)
- [Troubleshooting](README.md#-troubleshooting)

### Arquivo: PHASE2_SUMMARY.md (Sumário Executivo)
- Estatísticas completas
- Checklist de entregáveis
- Qualidade de código
- Performance
- Segurança
- Próximos passos Fase 3

---

## 🐳 DOCKER & DEPLOYMENT

### docker-compose.yml
```yaml
services:
  mongodb:    # Banco de dados
  minio:      # S3 compatível (storage)
  flask_app:  # Backend API
  redis:      # Cache / rate limiting
```

### Dockerfile
- Python 3.11 slim
- Health checks
- Production-ready
- Layer caching otimizado

### setup.sh
- Valida pré-requisitos (Python, Docker, docker-compose)
- Cria .env com secrets aleatórios
- Inicia docker-compose
- Aguarda health checks
- Resume próximos passos

---

## ⚙️ CONFIGURAÇÃO

### .env.example
```bash
FLASK_ENV=development
MONGO_URI=mongodb://admin:password@localhost:27017/neo_rh
JWT_SECRET_KEY=seu-secret-32-chars
MINIO_ENDPOINT=localhost:9000
CORS_ORIGINS=["http://localhost:3000"]
LOG_LEVEL=INFO
```

Copiar para `.env` e ajustar valores.

---

## 🔍 ENDPOINTS RÁPIDO

### Autenticação (auth/)
```
POST   /registrar        # Novo candidato
POST   /login            # Fazer login
POST   /refresh          # Renovar token
POST   /logout           # Logout
GET    /me               # Info usuário
```

### Currículos (curriculos/)
```
POST   /upload           # Upload PDF
GET    /busca            # Buscar (RH)
```

### Candidato (candidatos/)
```
GET    /:id/curriculos          # Versões CV
POST   /:id/consentimento       # Consentimento LGPD
DELETE /:id/deletar-conta       # Soft delete
```

### Auditoria (auditoria/)
```
GET    /relatorio        # Relatório (Admin)
```

---

## 🚦 STATUS DE DESENVOLVIMENTO

### ✅ CONCLUÍDO (Fase 2)
- [x] Autenticação unificada (JWT + bcrypt)
- [x] Upload de currículos com versionamento
- [x] Conformidade LGPD (consentimento, soft delete, anonimização)
- [x] Auditoria com TTL 7 anos
- [x] Busca e filtros (RH)
- [x] Testes (45+, 85% cobertura)
- [x] Documentação OpenAPI
- [x] Docker + docker-compose
- [x] README e guias

### ⏭️ PRÓXIMO (Fase 3)
- [ ] Testes E2E (Selenium/Cypress)
- [ ] CI/CD (GitHub Actions)
- [ ] Monitoring (Prometheus + Grafana)
- [ ] Load testing
- [ ] Security audit (OWASP)
- [ ] Staging deployment
- [ ] Production deployment

---

## 💬 LEGENDA

| Ícone | Significado |
|-------|-------------|
| ✅ | Completo |
| ⏳ | Em progresso |
| ⏭️ | Próximo |
| 🔐 | Segurança |
| 📊 | Dados/Performance |
| 🧪 | Testes |
| 📖 | Documentação |
| 🐳 | Docker/DevOps |

---

## 🆘 SUPORTE

### Rápido Start
```bash
./setup.sh                              # Setup automático
curl http://localhost:5000/health       # Verificar saúde
curl http://localhost:5000/api/docs     # Ver endpoints
```

### Erros Comuns
Ver [README.md - Troubleshooting](README.md#-troubleshooting)

### Documentação Completa
- **API:** [docs/API_SWAGGER.md](docs/API_SWAGGER.md)
- **Setup:** [README.md - Setup Local](README.md#-setup-local)
- **Testes:** [README.md - Testes](README.md#-testes)
- **Deploy:** [README.md - Deployment](README.md#-deployment)

---

**Última atualização:** 2026-09-07  
**Versão:** 1.0.0  
**Status:** ✅ Pronto para Fase 3
