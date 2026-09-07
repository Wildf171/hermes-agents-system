# DEPLOYMENT GUIDE

**Versão:** 1.0.0  
**Data:** 2026-09-07  

Guia completo para deployment de Neo Currículos em Staging e Produção.

---

## 📋 Índice

1. [Pré-Requisitos](#pré-requisitos)
2. [Ambiente](#ambiente)
3. [Preparação](#preparação)
4. [Deployment Staging](#deployment-staging)
5. [Deployment Produção](#deployment-produção)
6. [Verificação Pós-Deploy](#verificação-pós-deploy)
7. [Rollback](#rollback)
8. [Troubleshooting](#troubleshooting)

---

## 🔧 Pré-Requisitos

### Ferramentas Necessárias
```bash
- Docker 20.10+
- Docker Compose 2.0+
- Git 2.30+
- Python 3.11+
- Bash 4.0+
- curl ou wget
```

### Verificar Ferramentas
```bash
docker --version
docker-compose --version
git --version
python --version
```

### Acesso & Credenciais
- [ ] Acesso SSH ao servidor staging/produção
- [ ] Credenciais AWS (secret key, access key)
- [ ] Credenciais MongoDB (URI)
- [ ] JWT secret key
- [ ] Slack webhook (para notificações)

---

## 🌍 Ambiente

### Variáveis de Ambiente

**Staging:**
```bash
export FLASK_ENV=staging
export MONGO_URI=mongodb://user:pass@mongo-staging:27017/neo_rh_staging
export JWT_SECRET_KEY=<secret-key-staging>
export STORAGE_TYPE=minio
export MINIO_ENDPOINT=minio-staging:9000
export LOG_LEVEL=INFO
```

**Produção:**
```bash
export FLASK_ENV=production
export MONGO_URI=mongodb://user:pass@mongo-prod:27017/neo_rh_prod
export JWT_SECRET_KEY=<secret-key-prod>
export STORAGE_TYPE=s3
export AWS_S3_BUCKET=neo-curriculos-prod
export LOG_LEVEL=WARN
```

### Arquivo `.env` (LOCAL TESTING)
```bash
# .env (NÃO COMMITAR - add to .gitignore)
FLASK_ENV=development
MONGO_URI=mongodb://admin:password@localhost:27017/neo_rh
JWT_SECRET_KEY=dev-secret-key-min-32-chars
LOG_LEVEL=DEBUG
```

---

## 📦 Preparação

### 1. Clonar Repositório
```bash
git clone https://github.com/seu-repo/neo-curriculos.git
cd neo-curriculos
```

### 2. Preparar Branch
```bash
# Para staging
git checkout develop
git pull origin develop

# Para produção
git checkout main
git pull origin main
```

### 3. Validar Código
```bash
# Lint
flake8 .

# Security scan
bandit -r . -ll

# Unit tests
pytest tests/07_TESTES_UNITARIOS.py -v

# E2E tests (contra staging/dev)
pytest tests/10_TESTES_E2E.py -v
```

### 4. Build Docker Image
```bash
# Build
docker build -t neo-curriculos:v1.0.0 .

# Tag latest
docker tag neo-curriculos:v1.0.0 neo-curriculos:latest

# Verificar
docker images | grep neo-curriculos
```

### 5. Push para Registry (opcional)
```bash
# Se usar Docker Hub, ECR, etc
docker push seu-registry/neo-curriculos:v1.0.0
```

---

## 🚀 Deployment Staging

### Automático (Recomendado)
```bash
# Push para develop trigger CI/CD
git add .
git commit -m "Deploy to staging"
git push origin develop

# Verificar em GitHub Actions
# https://github.com/seu-repo/neo-curriculos/actions

# Aguardar workflow completar (5-10 min)
```

### Manual
```bash
# SSH no servidor staging
ssh user@staging-server.com

# Pull latest
cd /opt/neo-curriculos
git pull origin develop

# Build & run
bash scripts/deploy-staging.sh

# Verificar
curl -I http://staging-server.com:5000/health
```

### Validação Pós-Deploy
```bash
# Smoke tests
pytest tests/14_SMOKE_TESTS.py -v -m smoke \
  --tb=short \
  --base-url=http://staging-server.com:5000

# E2E tests contra staging
pytest tests/10_TESTES_E2E.py -v \
  --tb=short \
  --base-url=http://staging-server.com:5000
```

---

## 🎯 Deployment Produção

### ⚠️ IMPORTANTE: Requer Aprovação

1. **Preparação (1 dia antes)**
   - [ ] Branch main está atualizado
   - [ ] Todos os testes passam
   - [ ] Code review aprovado
   - [ ] Release notes estão preparadas
   - [ ] Status page está atualizado

2. **Execução (Horário de Baixa Atividade)**
   - [ ] Escolher horário com baixa carga (ex: 02h00 AM)
   - [ ] Notificar stakeholders 1h antes
   - [ ] Team está disponível (on-call)

3. **Deploy Automático**
   ```bash
   # Push para main trigger CI/CD
   git tag v1.0.0
   git push origin main
   git push origin v1.0.0

   # Aguardar workflow (requer aprovação environment)
   # https://github.com/seu-repo/neo-curriculos/actions
   ```

4. **Deploy Manual (se necessário)**
   ```bash
   # SSH no servidor produção
   ssh user@prod-server.com

   # Executar deployment
   cd /opt/neo-curriculos
   bash scripts/deploy-production.sh

   # Verificar
   curl -I https://api.neo-curriculos.com/health
   ```

### Health Check Produção
```bash
# Imediato
curl https://api.neo-curriculos.com/health

# API endpoints
curl https://api.neo-curriculos.com/api/version

# Login test
curl -X POST https://api.neo-curriculos.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","senha":"Password@123"}'

# Métricas
curl https://api.neo-curriculos.com/metrics | head -20
```

---

## ✅ Verificação Pós-Deploy

### Imediato (0-5 min)
```bash
# Health check
curl -f https://api.neo-curriculos.com/health

# Status page
curl https://status.neo-curriculos.com

# Logs do container
docker logs $(docker ps -q -f label=app=neo-curriculos)
```

### Curto prazo (5-60 min)
```bash
# Smoke tests
pytest tests/14_SMOKE_TESTS.py -v -m smoke \
  --base-url=https://api.neo-curriculos.com

# Monitorar métricas
# - CPU < 70%
# - Memory < 80%
# - Error rate < 0.1%
# - Latency p95 < 2s

# Verificar Prometheus
# https://metrics.neo-curriculos.com/graph?query=up
```

### Médio prazo (1-4 horas)
```bash
# E2E tests
pytest tests/10_TESTES_E2E.py::TestFluxoAutenticacao -v \
  --base-url=https://api.neo-curriculos.com

# Load baseline
pytest tests/12_LOAD_TESTING.py::TestBaselinePerformance -v \
  --base-url=https://api.neo-curriculos.com

# Verificar logs de erro
# - Nenhum erro 500
# - Nenhuma exceção não tratada
```

### Monitoramento 24/7
```bash
# Prometheus/Grafana
# https://metrics.neo-curriculos.com

# Alerts em Slack/PagerDuty
# - API Down
# - High error rate
# - High latency
# - Database issues
```

---

## 🔄 Rollback

### Rollback Automático (Falha de Deploy)
```bash
# GitHub Actions detecta falha
# Executa rollback automático
# Team é notificado no Slack
```

### Rollback Manual
```bash
# SSH no servidor
ssh user@prod-server.com

# Ir para versão anterior
cd /opt/neo-curriculos
bash scripts/rollback.sh

# Versão anterior será restaurada
# Containers antigos serão iniciados
# DNS/LB será atualizado
```

### Rollback Verificação
```bash
# Validar versão anterior
curl https://api.neo-curriculos.com/api/version

# Smoke tests
pytest tests/14_SMOKE_TESTS.py -v -m smoke

# Validar data/hora da versão anterior
# Timeline de eventos no Datadog
```

---

## 🔧 Troubleshooting

### API não responde
```bash
# Verificar se container está rodando
docker ps | grep neo-curriculos

# Verificar logs
docker logs $(docker ps -q -f label=app=neo-curriculos)

# Verificar health
curl http://localhost:5000/health

# Reiniciar container
docker restart $(docker ps -q -f label=app=neo-curriculos)
```

### Alta latência
```bash
# Verificar CPU
docker stats $(docker ps -q -f label=app=neo-curriculos)

# Verificar conexões DB
# No MongoDB: db.serverStatus().connections

# Verificar conexões no load balancer
# nginx -s reload

# Aumentar workers/threads
# Gunicorn: -w 8 (aumentar workers)
```

### Database connection errors
```bash
# Verificar conectividade
mongo "mongodb://user:pass@mongo:27017"

# Verificar URI
echo $MONGO_URI

# Verificar credentials
# AWS Secrets Manager: aws secretsmanager get-secret-value --secret-id neo-mongo-uri

# Validar IP whitelist
# Se cloud: check security group/firewall rules
```

### Memory leak
```bash
# Monitorar memória
watch -n 1 'docker stats --no-stream'

# Verificar logs de erro
docker logs -f $(docker ps -q -f label=app=neo-curriculos) | grep -i "error\|exception"

# Restart container (se necessário)
docker restart $(docker ps -q -f label=app=neo-curriculos)

# Analisar heapdump (Python)
# python -m py-spy dump --pid <PID>
```

### Erro 401/403 authentication
```bash
# Verificar JWT_SECRET_KEY está correto
echo $JWT_SECRET_KEY

# Verificar token não expirou
# Decodificar JWT: jwt.decode(token, secret)

# Verificar banco de dados tem usuário
mongo -u admin -p password --eval "db.usuarios.findOne()"

# Verificar rate limiting não está bloqueando
curl -H "Authorization: Bearer <token>" https://api.neo-curriculos.com/api/auth/me
```

### Erro 503 Service Unavailable
```bash
# Verificar load balancer está online
curl -f http://load-balancer-ip/health

# Verificar backends
# nginx: curl http://localhost/upstream

# Aumentar timeout
# nginx: proxy_connect_timeout 30s;

# Scale up
# docker-compose up -d --scale api=5
```

---

## 📞 Contatos de Emergência

| Função | Nome | Telefone | Email |
|--------|------|----------|-------|
| Lead DevOps | _______ | _______ | _______ |
| Database Admin | _______ | _______ | _______ |
| On-Call | _______ | _______ | _______ |
| Manager | _______ | _______ | _______ |

---

## 📚 Referências

- [Docker Docs](https://docs.docker.com/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [MongoDB Docs](https://docs.mongodb.com/)
- [Prometheus Docs](https://prometheus.io/docs/)
- [12 Factor App](https://12factor.net/)

---

*Última atualização: 2026-09-07*
