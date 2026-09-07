# 🚀 Staging Deployment Guide - Neo Currículos

**Data:** 2026-09-07  
**Status:** ✅ Ready for Deployment  
**Environment:** Staging  
**Commit:** 83daebf  

---

## 📋 Pré-requisitos

### Infraestrutura Necessária
- [ ] Servidor Linux (Ubuntu 20.04+)
- [ ] Docker 20.10+
- [ ] Docker Compose 2.0+
- [ ] MongoDB 6.0+
- [ ] MinIO (ou AWS S3)
- [ ] 4GB RAM, 20GB Disk, 2+ vCPU

### Configurações Necessárias

```bash
# Variáveis de Ambiente (staging/.env)
STAGING_SERVER=staging.neocurriculos.com
STAGING_USER=deploy
STAGING_SSH_KEY=~/.ssh/staging-key.pem

MONGO_URI=mongodb://admin:password@mongo-staging:27017/neo_rh
JWT_SECRET_KEY=your-super-secret-key-min-32-chars
FLASK_ENV=staging

MINIO_ENDPOINT=minio-staging:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin

SLACK_WEBHOOK=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```

---

## 🚀 Deployment Steps

### PASSO 1: Prepare Environment (Local)

```bash
# Clone repository
git clone https://github.com/Wildf171/hermes-agents-system.git
cd hermes-agents-system

# Checkout latest
git pull origin main
COMMIT_HASH=$(git rev-parse --short HEAD)
echo "Deploying commit: $COMMIT_HASH"
```

### PASSO 2: Pre-deployment Checks

```bash
# Validar todos os testes passam
cd 07\ -\ BACKEND/neo-curriculos-testing
pytest tests/ -v --tb=short

# Validar build do Docker
cd ../neo-curriculos-backend
docker build -t neo-curriculos:staging .

# Validar que app pode iniciar localmente
docker-compose up -d
sleep 5
curl http://localhost:5000/health
docker-compose down
```

**Expected Output:**
```json
{
  "status": "ok",
  "api": "connected",
  "mongodb": "connected",
  "storage": "connected",
  "uptime": "0:00:05"
}
```

### PASSO 3: Deploy to Staging

```bash
# Executar script de deployment
cd ../neo-curriculos-testing/scripts
bash 15_DEPLOY_STAGING.sh

# Ou com força (ignora alguns checks)
bash 15_DEPLOY_STAGING.sh --force
```

**Que faz o script:**
1. ✅ Pull latest code (develop branch)
2. ✅ Build Docker image
3. ✅ Backup containers antigos
4. ✅ Executar migrations
5. ✅ Stop old containers (gracefully)
6. ✅ Start novo container
7. ✅ Health check com retry (10x, 10s timeout)
8. ✅ Validação pós-deployment
9. ✅ Cleanup de imagens antigas
10. ✅ Notificação Slack

### PASSO 4: Validação Pós-Deployment

```bash
# Conectar ao servidor staging
ssh deploy@staging.neocurriculos.com

# Verificar containers rodando
docker ps -a --filter "label=app=neo-curriculos"

# Ver logs
docker logs -f neo-curriculos-api

# Health check
curl http://localhost:5000/health

# Validar endpoints principais
curl -X POST http://localhost:5000/api/auth/login -d '{"email":"test@test.com","senha":"Test123"}' -H "Content-Type: application/json"

# Verificar database
docker exec neo-curriculos-mongodb mongosh --eval "db.usuarios.count()"

# Verificar storage
docker exec neo-curriculos-minio mc ls minio/neo-curriculos
```

### PASSO 5: Run Smoke Tests

```bash
# Rodas testes rápidos de health
cd ../neo-curriculos-testing/tests
pytest 14_SMOKE_TESTS.py -v

# Expected: ✅ 5+ tests PASSED in 30 seconds
```

### PASSO 6: Monitoring Setup

```bash
# Verificar Prometheus está scraping
curl http://staging.neocurriculos.com:9090/api/v1/targets

# Verificar Grafana dashboard
# Acessa: http://staging.neocurriculos.com:3000
# Username: admin
# Password: admin (change on production!)

# Ver alertas ativos
curl http://staging.neocurriculos.com:9093/api/v1/alerts
```

---

## 📊 Deployment Checklist

### Antes do Deploy
- [ ] Todos 116+ testes passando (backend + mobile)
- [ ] Code review aprovado
- [ ] Security scan passou (Bandit clean)
- [ ] Load test validado (< 2s p95)
- [ ] Documentation atualizada
- [ ] Changelog adicionado

### Durante o Deploy
- [ ] SSH acesso ao servidor OK
- [ ] Variáveis de ambiente setadas
- [ ] Backup de dados criado
- [ ] Migration testada
- [ ] Docker image buildado
- [ ] Health check passou

### Depois do Deploy
- [ ] API respondendo 200 OK
- [ ] Database conectado
- [ ] Storage (S3/MinIO) acessível
- [ ] Logs não têm erros críticos
- [ ] Monitoramento ativo (Prometheus)
- [ ] Alertas funcionando
- [ ] Smoke tests 100% pass
- [ ] Slack notificação enviada

---

## 🆘 Rollback Procedure

Se algo der errado **durante** o deploy:

### Automático (Script)
```bash
# Executa rollback automático
bash scripts/rollback-production.sh --version staging-backup

# Esperado: < 5 minutos total
```

### Manual
```bash
# Conectar ao servidor
ssh deploy@staging.neocurriculos.com

# Ver containers antigos disponíveis
docker images | grep neo-curriculos

# Restore do backup
docker-compose -f docker-compose.staging.yml down
docker image prune -f
docker load < /opt/neo-curriculos/backups/neo-curriculos-staging-backup.tar

# Restart com imagem anterior
docker-compose -f docker-compose.staging.yml up -d

# Validar
curl http://localhost:5000/health
```

---

## 📈 Performance Baseline (Pós-Deploy)

Validar que performance está OK:

| Métrica | Target | Status |
|---------|--------|--------|
| API Response (p99) | < 2s | ✅ Monitor |
| Error Rate | < 0.5% | ✅ Monitor |
| Uptime | > 99.9% | ✅ Monitor |
| DB Connections | < 100 | ✅ Monitor |
| Memory Usage | < 80% | ✅ Monitor |
| Disk Usage | < 70% | ✅ Monitor |

**Comandos para verificar:**
```bash
# Via Prometheus
curl 'http://staging:9090/api/v1/query?query=rate(http_requests_total[5m])'

# Via Logs
docker logs neo-curriculos-api | grep -E "ERROR|CRITICAL" | wc -l

# Via Health endpoint
curl http://localhost:5000/health/metrics
```

---

## 📞 Support & Escalation

### Se houver problema:

1. **Verificar logs**
   ```bash
   docker logs neo-curriculos-api --tail=100
   docker logs neo-curriculos-mongodb --tail=100
   ```

2. **Verificar recursos**
   ```bash
   docker stats neo-curriculos-api
   docker exec neo-curriculos-mongodb mongosh --eval "db.serverStatus()"
   ```

3. **Escalate**
   - On-call engineer: Page PagerDuty
   - CTO: Critical issue (error rate > 5%)
   - Team lead: Medium issue (latency > 2s p99)

---

## ✅ Sucesso!

```
🎉 Se você vir isto, o deploy foi um sucesso:

✓ API Health: OK
✓ Database: Connected
✓ Storage: Connected
✓ Monitoring: Active
✓ Logs: Clean
✓ Tests: Passing
✓ Slack: Notified

Próximo passo: Beta launch com 5-10 empresas!
```

---

**Próximo:** Começar [BETA ROLLOUT](./07%20-%20BACKEND/neo-curriculos-production/18_ROLLOUT_PLAN.md)

