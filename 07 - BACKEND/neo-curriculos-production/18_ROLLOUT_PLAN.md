# 18 - ROLLOUT_PLAN.md
## Estratégia de Rollout para Produção - Neo Currículos + Neo RH System

**Data:** Setembro 2026  
**Versão:** 1.0.0  
**Duração:** 4 semanas (3 fases)  
**Status:** Pronto para execução

---

## Visão Geral

Estratégia de rollout faseado em 3 etapas com kill-switch automático em qualquer momento, garantindo zero downtime e capacidade de rollback em < 5 minutos.

### Cronograma

| Fase | Período | Empresas | Usuários | Status |
|------|---------|----------|----------|--------|
| **BETA** | Semana 1-2 | 5-10 | 500-1000 | Validação |
| **GRADUAL** | Semana 3 | 50% | 50% tráfego | Canary release |
| **FULL** | Semana 4 | 100% | 100% tráfego | Produção |

---

## FASE 1: BETA (Semana 1-2) — 5-10 Empresas

### Objetivo
- Validar integração com dados reais de produção
- Encontrar edge cases não detectados em staging
- Treinar suporte e time de operações
- Estabelecer baseline de performance

### Critérios de Entrada (Pre-flight Checklist)

```markdown
## Pre-flight Checklist - Beta Release

- [ ] **Testes**
  - Todos 71+ testes unitários passando
  - Testes de integração 100% OK
  - E2E tests em staging completos
  - Load test baseline: < 2s p95

- [ ] **Infraestrutura**
  - Kubernetes cluster OK (3+ nodes)
  - MongoDB replicado e testado
  - S3/storage sincronizado
  - CDN configurado (CloudFront)
  - Load balancer testado

- [ ] **Monitoramento**
  - Prometheus scraping métricas
  - Grafana dashboards criados
  - Kibana logstash funcionando
  - Alertas configurados (PagerDuty)

- [ ] **Backup & Recovery**
  - Backup automático configurado (daily)
  - Teste de restore executado (< 30 min)
  - Disaster recovery plan validado
  - RTO < 30 min, RPO < 5 min

- [ ] **On-call Setup**
  - Primary on-call designado
  - Escalation matrix definida
  - Runbook preparado
  - Contatos atualizados

- [ ] **Segurança**
  - WAF (Web Application Firewall) ativo
  - SSL/TLS validado
  - Secrets rotacionados
  - Audit logging ativo
  - LGPD compliance checklist OK

- [ ] **Capacidade**
  - Database conexões: < 100 (headroom)
  - Storage: > 50% disponível
  - CPU/Memory: < 70% em pico
  - Network: < 50% utilização

- [ ] **Documentação**
  - Runbook operacional finalizado
  - Incident response procedures OK
  - Rollback procedure testado
  - Status page criada
```

### Deployment

#### Blue-Green Deployment Strategy

```bash
## Arquitetura de Deployment

                    ┌─────────────────────┐
                    │   Load Balancer     │
                    │  (AWS ALB/NLB)      │
                    └──────────┬──────────┘
                               │
                ┌──────────────┼──────────────┐
                │              │              │
                ▼              ▼              ▼
           [Blue v1.0]    [Green v1.0]    [Canary]
           (Running)       (Standby)      (5% traffic)
           100% traffic      0% traffic     Traffic gradient
```

#### Timeline de Deployment

**T-1 hour: Pre-deployment**
```bash
# 1. Code freeze (14:00 UTC)
git tag -a v1.0.0-beta.1 -m "Beta release"

# 2. Deploy Green environment
kubectl apply -f deploy/neo-curriculos-green.yaml
kubectl rollout status deployment/neo-curriculos-green

# 3. Smoke tests em Green
pytest tests/smoke/ --base-url=$GREEN_URL

# 4. Team assembly
# - DevOps lead
# - Backend engineer
# - SRE on-call
# - CTO approval
```

**T+0:00: Traffic Switch (Gradual)**
```bash
# Phase 1: 5% → Green (5 min monitoramento)
kubectl patch service neo-curriculos-api \
  -p '{"spec":{"selector":{"version":"green"}}}' \
  --type=merge
# Monitor latency, error rate, database CPU

# Phase 2: 25% → Green (5 min)
kubectl set env deployment/neo-curriculos-lb \
  TRAFFIC_SPLIT="25"
# Continue monitoring

# Phase 3: 50% → Green (5 min)
kubectl set env deployment/neo-curriculos-lb \
  TRAFFIC_SPLIT="50"

# Phase 4: 75% → Green (5 min)
kubectl set env deployment/neo-curriculos-lb \
  TRAFFIC_SPLIT="75"

# Phase 5: 100% → Green (final)
kubectl set env deployment/neo-curriculos-lb \
  TRAFFIC_SPLIT="100"
```

**T+0:30: Finalization**
```bash
# Validação final
bash scripts/validate-production.sh

# Cleanup (manter Blue em standby por 24h)
# Blue ready for instant rollback
```

### Monitoramento (Real-time)

#### Métricas Críticas

```yaml
# Prometheus queries para alertas
API Latency (p95):
  histogram_quantile(0.95, http_request_duration_seconds)
  
API Error Rate (%):
  rate(http_requests_total{status=~"5.."}[5m]) * 100
  
Database CPU:
  mongodb_server_status_cpu_utilization
  
Database Connections:
  mongodb_connections_current
  
Memory Usage (%):
  container_memory_usage_bytes / container_memory_limit_bytes * 100
  
Disk Usage (%):
  node_filesystem_avail_bytes / node_filesystem_size_bytes * 100
```

#### Alert Thresholds

```
CRITICAL (Immediate Response):
├─ Error rate > 5%
├─ Latência p95 > 5s
├─ Database CPU > 90%
├─ Memory usage > 90%
├─ Disk usage > 95%
└─ Uptime < 95%

HIGH (15 min response):
├─ Error rate 2-5%
├─ Latência p95 2-5s
├─ Database CPU 75-90%
└─ Memory usage 75-90%

MEDIUM (1 hour):
├─ Error rate 0.5-2%
├─ Latência p95 1-2s
└─ Slow queries detected
```

#### Slack Notifications

```
#neo-curriculos-prod-alerts (crítico)
#neo-curriculos-prod-monitoring (informativo)
#neo-curriculos-incidents (investigação)

Formato:
🔴 CRITICAL: API Error Rate 7.2% (threshold: 5%)
   Timestamp: 2025-09-07 14:30:15 UTC
   Affected: 250 users
   Status: On-call investigating
   Runbook: #runbook-high-error-rate
```

### Métricas de Sucesso

```yaml
Beta Phase Success Criteria:

Performance:
  ✓ API latência p99: < 2 segundos
  ✓ Database query p99: < 100ms
  ✓ Page load time: < 3 segundos
  ✓ Throughput: > 100 req/sec

Reliability:
  ✓ Uptime: > 99.9%
  ✓ Error rate: < 0.5%
  ✓ Zero data corruption
  ✓ Zero critical incidents

Operations:
  ✓ All rollback tests passing
  ✓ On-call handled alerts < 5 min
  ✓ Backup restore validated
  ✓ Security scan clean

User Impact:
  ✓ Zero unplanned outages
  ✓ All companies stable
  ✓ Support: 0 critical tickets
  ✓ Feature usage: as expected
```

### Rollback Trigger (Kill-switch)

Automatic rollback triggered if ANY of:

```bash
if [[ $ERROR_RATE -gt 5 ]]; then
  echo "❌ Error rate exceeded (5%)"
  trigger_rollback=true
fi

if [[ $LATENCY_P95 -gt 5 ]]; then
  echo "❌ Latency exceeded (5s)"
  trigger_rollback=true
fi

if [[ $DATABASE_CPU -gt 90 ]]; then
  echo "❌ Database CPU exceeded (90%)"
  trigger_rollback=true
fi

if [[ $UPTIME -lt 95 ]]; then
  echo "❌ Uptime dropped below 95%"
  trigger_rollback=true
fi

if [[ ! -z $CRITICAL_ERROR ]]; then
  echo "❌ Critical error detected: $CRITICAL_ERROR"
  trigger_rollback=true
fi

# Manual trigger (on-call decision)
if [[ "$MANUAL_ROLLBACK" == "true" ]]; then
  echo "⚠️  Manual rollback initiated"
  trigger_rollback=true
fi
```

### Rollback Procedure

**RTO: < 5 minutos**

```bash
#!/bin/bash
# scripts/rollback-production.sh

set -euo pipefail

VERSION=${1:-v1.0.0}
ROLLBACK_TIMEOUT=300  # 5 minutos

echo "🔄 Iniciando rollback para $VERSION..."

# 1. Stop Green deployment (novo)
echo "[1/5] Parando Green deployment..."
kubectl scale deployment neo-curriculos-green --replicas=0

# 2. Restore previous database state (se necessário)
if [[ "$RESTORE_DB" == "true" ]]; then
  echo "[2/5] Restaurando backup de banco de dados..."
  bash scripts/restore-mongodb.sh --version "$VERSION" --timeout 300
else
  echo "[2/5] Backup não necessário (apenas rollback de app)"
fi

# 3. Switch traffic back to Blue
echo "[3/5] Redirecionando tráfego para Blue..."
kubectl set env deployment/neo-curriculos-lb \
  TRAFFIC_SPLIT="0"  # 100% para Blue
  
sleep 30

# 4. Validate Blue is healthy
echo "[4/5] Validando saúde de Blue..."
HEALTH_CHECK=$(curl -s https://api.neocurriculos.com/health | jq .status)
if [[ "$HEALTH_CHECK" != '"ok"' ]]; then
  echo "❌ Blue health check falhou!"
  exit 1
fi

# 5. Verify no data loss
echo "[5/5] Verificando integridade de dados..."
bash scripts/validate-data-integrity.sh

echo ""
echo "✅ Rollback completo!"
echo "   Versão ativa: $VERSION"
echo "   Tempo decorrido: $(date -d @$SECONDS +%M:%S)"
echo "   Status: OK"
echo ""
echo "Próximos passos:"
echo "1. Notificar time via #neo-curriculos-incidents"
echo "2. Investigar raiz da causa"
echo "3. Post-mortem em 24 horas"
```

### Sign-off (Autorizações)

```markdown
## Aprovações Requeridas antes de Beta

- [ ] **CTO**: "Approvo this beta release"
- [ ] **Product Manager**: "Beta plan validated with customer list"
- [ ] **DevOps Lead**: "Infrastructure ready, rollback tested"
- [ ] **On-call Engineer**: "Procedures understood, monitoring verified"
- [ ] **Security Team**: "No vulnerabilities found"
- [ ] **Compliance**: "LGPD requirements met"

## Post-Beta Review

After 2 weeks:

- [ ] **CTO**: "Beta went well, approve gradual phase"
- [ ] **Product Manager**: "Customer feedback positive"
- [ ] **DevOps Lead**: "No operational issues"
- [ ] **On-call**: "Procedures worked as expected"
```

---

## FASE 2: GRADUAL (Semana 3) — Canary Release

### Objetivo
- Aumentar cobertura gradualmente
- Validar comportamento em escala
- Monitorar métricas de cada faixa

### Canary Release Schedule

```
Day 1: 10% usuários (4 horas monitoramento)
       ├─ Janela: 10:00-14:00 UTC
       ├─ Empresas: ~200
       ├─ Métrica gate: Error rate < 2%
       └─ Decisão: Continue ou Rollback

Day 2: 25% usuários (4 horas)
       ├─ Janela: 10:00-14:00 UTC
       ├─ Empresas: ~500
       ├─ Métrica gate: Error rate < 2%, Latência < 2s p95
       └─ Decisão: Continue ou Rollback

Day 3: 50% usuários (8 horas)
       ├─ Janela: 08:00-16:00 UTC
       ├─ Empresas: ~1000
       ├─ Métrica gate: Error rate < 1.5%, Uptime > 99.5%
       └─ Decisão: Continue ou Rollback

Day 4: 75% usuários (8 horas)
       ├─ Janela: 08:00-16:00 UTC
       ├─ Empresas: ~1500
       ├─ Métrica gate: Mesmas que 50%
       └─ Decisão: Continue ou 100%

Day 5: 100% usuários (continuous monitoring)
       ├─ Rollback still available for 24h
       └─ After 24h, archive Blue deployment
```

### Implementation

```bash
# Usar Prometheus + custom canary controller
kubectl apply -f kubernetes/canary-controller.yaml

# Configuração
canary:
  weight: 10      # 10% tráfego
  interval: 1h    # Aumentar a cada hora
  maxWeight: 100
  rollback:
    threshold: 2  # Rollback se error rate > 2%
    timeout: 4h   # Monitorar por 4 horas
```

### Rollback Trigger (Fase 2)

Mesmo que Fase 1:
- Error rate > 5%
- Latência p95 > 5s
- Database CPU > 90%
- Qualquer erro crítico

### Success Criteria

```yaml
Gradual Phase Success:

Performance:
  ✓ Latência p99 estável < 2s
  ✓ Database performance consistente
  ✓ No degradação observada vs Beta

Reliability:
  ✓ Uptime > 99.9%
  ✓ Error rate < 1% (melhorando)
  ✓ Zero data issues
  ✓ Zero security incidents

Operations:
  ✓ Escalação funcionou como esperado
  ✓ Suporte respondeu rápido
  ✓ Backup/restore OK
  ✓ Monitoring alertas precisos
```

---

## FASE 3: FULL (Semana 4) — Produção Completa

### Objetivo
- Deploy completo para 100% dos usuários
- Manter app antigo em standby por 24h
- Arquivar após validação completa

### Procedure

```bash
#!/bin/bash
# T+0: Final deployment

# 1. Confirm all canary thresholds met
echo "Verificando critérios de entrada..."
bash scripts/pre-full-deployment-check.sh

# 2. Set Green to 100% traffic
echo "Migrando 100% tráfego para Green..."
kubectl set env deployment/neo-curriculos-lb \
  TRAFFIC_SPLIT="100"

# 3. 24h monitoring
echo "Monitorando por 24 horas..."
watch -n 60 'curl -s https://api.neocurriculos.com/health | jq'

# 4. After 24h validation, archive Blue
echo "Arquivando Blue deployment..."
kubectl delete deployment neo-curriculos-blue
kubectl delete pvc neo-curriculos-blue-data
```

### Monitoring (24/7)

```yaml
SLA Tracking:
  ├─ Uptime: 99.95% (target)
  ├─ Latência p99: < 2s
  ├─ Error rate: < 0.5%
  └─ Incidents: < 2 per month

Alert escalation:
  ├─ Minor: On-call team
  ├─ Major: On-call + Team lead
  └─ Critical: VP Eng + CTO

Reporting:
  ├─ Hourly: Slack update
  ├─ Daily: Detailed report
  ├─ Weekly: Executive summary
  └─ Monthly: SLA review
```

### Success Criteria

```yaml
Full Phase Success (Production):

Performance:
  ✓ Latência p99 < 2s (consistent)
  ✓ Throughput: > 100 req/sec
  ✓ Zero performance degradation

Reliability:
  ✓ Uptime: 99.95% (SLA met)
  ✓ MTBF: > 30 days
  ✓ MTTR: < 15 minutes
  ✓ Zero data loss

Security:
  ✓ Zero security incidents
  ✓ LGPD compliance: 100%
  ✓ Audit logging: OK
  ✓ No unauthorized access

Business:
  ✓ Customer satisfaction: > 95%
  ✓ Support tickets: < 1% critical
  ✓ Feature adoption: on target
  ✓ Revenue impact: positive or neutral
```

---

## Kill-Switch (Instant Rollback)

### Trigger Points

```
CRITICAL - Immediate Rollback (< 5 min):
├─ Error rate > 10% (critical threshold)
├─ Database unreachable (connection loss)
├─ Memory leak detected
├─ Security breach detected
├─ Data corruption discovered
└─ Manual kill-switch activated

HIGH - Escalation (alert on-call):
├─ Error rate 5-10%
├─ Latência p95 > 10s
├─ Database CPU > 95%
└─ Storage full

WARNING - Monitor:
├─ Error rate 1-5%
├─ Latência p95 > 5s
├─ Database CPU 80-95%
└─ Unusual traffic patterns
```

### Kill-switch Activation

```bash
#!/bin/bash
# Emergency rollback - anyone can trigger this
# Usage: ./kill-switch.sh [reason]

REASON=${1:-"Manual activation"}
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

echo "⚠️  KILL SWITCH ACTIVATED"
echo "Reason: $REASON"
echo "Time: $TIMESTAMP"
echo ""
echo "Initiating immediate rollback to previous version..."

# Immediate actions
kubectl scale deployment neo-curriculos-green --replicas=0
sleep 5
kubectl scale deployment neo-curriculos-blue --replicas=3

# Notify everyone
curl -X POST https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
  -H 'Content-Type: application/json' \
  -d "{\"text\":\":rotating_light: KILL SWITCH - $REASON\"}"

# Log for post-mortem
echo "$TIMESTAMP - Kill switch activated: $REASON" >> /var/log/neo-curriculos/kill-switch.log

echo "✅ Rollback complete - old version live"
```

---

## Summary

| Fase | Duração | Empresas | Métricas | Rollback |
|------|---------|----------|----------|----------|
| **Beta** | 2 weeks | 5-10 | Validation | < 5 min |
| **Gradual** | 1 week | 50% → 100% | Canary gates | < 5 min |
| **Full** | Ongoing | 100% | SLA tracking | < 5 min (24h) |

**Total Time to Production: 4 weeks**

**Zero downtime guaranteed**

**Rollback available at all times**
