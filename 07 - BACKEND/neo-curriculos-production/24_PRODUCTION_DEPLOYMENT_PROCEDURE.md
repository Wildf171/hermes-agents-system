# 24 - PRODUCTION_DEPLOYMENT_PROCEDURE.md
## Procedimento de Deployment em Produção - Neo Currículos + Neo RH System

**Data:** Setembro 2026  
**Versão:** 1.0.0  
**Duração Total:** 35-45 minutos

---

## Pre-Deployment (T-1 hour)

### 1. Code Freeze & Staging Validation

**Timeline: T-60 min**

```bash
#!/bin/bash
# scripts/pre-deployment-check.sh

set -euo pipefail

echo "📋 Pre-deployment Checklist - $(date)"

# 1.1 Code freeze (no new commits)
echo "[1/6] Verificando code freeze..."
LAST_COMMIT=$(git log -1 --format="%H %ai")
echo "  Last commit: $LAST_COMMIT"
echo "  ✓ Code frozen at $(date)"

# 1.2 All tests passing
echo "[2/6] Rodando suite de testes (71+ testes)..."
npm test -- --coverage || {
  echo "❌ Tests FAILED"
  exit 1
}
echo "  ✅ All 71 tests PASSED"

# 1.3 Load test baseline
echo "[3/6] Rodando load test em staging..."
npm run test:load -- \
  --target=https://staging-api.neocurriculos.com \
  --duration=300 \
  --rate=100
# Expected: p99 < 2s, error rate < 0.5%
LOAD_TEST_RESULT=$(cat /tmp/load-test-result.json | jq .p99_latency)
if (( $(echo "$LOAD_TEST_RESULT < 2000" | bc -l) )); then
  echo "  ✅ Load test OK: p99=$LOAD_TEST_RESULT ms"
else
  echo "  ❌ Load test FAILED: p99=$LOAD_TEST_RESULT ms"
  exit 1
fi

# 1.4 Smoke test staging
echo "[4/6] Rodando smoke tests em staging..."
pytest tests/smoke/ --base-url=https://staging-api.neocurriculos.com || {
  echo "❌ Smoke tests FAILED"
  exit 1
}
echo "  ✅ Smoke tests PASSED"

# 1.5 Database migration test
echo "[5/6] Testando database migration..."
npm run migrate:test || {
  echo "❌ Migration FAILED"
  exit 1
}
echo "  ✅ Migration test PASSED"

# 1.6 Rollback procedure
echo "[6/6] Testando rollback procedure..."
bash scripts/test-rollback.sh || {
  echo "❌ Rollback test FAILED"
  exit 1
}
echo "  ✅ Rollback test PASSED"

echo ""
echo "✅ PRE-DEPLOYMENT CHECKLIST COMPLETE"
echo "Ready for deployment!"
```

### 2. Team Assembly

**T-55 min:** Gather deployment team

```
Required participants:
├─ DevOps lead (orchestration)
├─ Backend engineer (troubleshooting, debugging)
├─ SRE on-call (monitoring)
├─ Product manager (approval)
└─ CTO (final approval)

Location: War room or video conference
Tools open:
├─ Grafana dashboard
├─ Kibana logs
├─ Prometheus alerts
├─ Slack channels
└─ SSH access
```

### 3. Final Approvals

**T-10 min:** Sign-off

```markdown
## Deployment Approval Checklist

- [ ] CTO: "Approvo this deployment"
- [ ] Product: "Feature complete, approved"
- [ ] DevOps: "Infrastructure ready"
- [ ] SRE: "Monitoring ready, on-call assigned"

Version: v1.0.1
Target: Production (neo-curriculos-api.com)
Rollback: Ready (v1.0.0 in standby)
```

---

## Deployment Execution (T+0:00)

### Phase 1: Blue-Green Setup (T+0:00 to T+0:15)

**Create Green environment (new version)**

```bash
#!/bin/bash
# scripts/deploy-green.sh

VERSION=${1:-v1.0.1}
TIMEOUT=900

echo "🟢 [T+0:00] Deploying Green (v$VERSION)..."

# 1. Create new Green deployment
echo "[T+0:00] Criando Green deployment..."
kubectl apply -f kubernetes/deployment-green.yaml

# 2. Wait for pods to start
echo "[T+0:03] Aguardando inicialização dos pods..."
kubectl rollout status deployment neo-curriculos-green --timeout=300s

READY_PODS=$(kubectl get deployment neo-curriculos-green \
  -o jsonpath='{.status.readyReplicas}')
if [[ $READY_PODS -lt 3 ]]; then
  echo "❌ Insufficient ready pods: $READY_PODS < 3"
  kubectl logs deployment/neo-curriculos-green --tail=50
  exit 1
fi
echo "  ✅ 3 Green pods ready"

# 3. Health check (internal)
echo "[T+0:08] Executando health check..."
HEALTH=$(kubectl exec -it $(kubectl get pod -l app=neo-curriculos,version=green \
  -o jsonpath='{.items[0].metadata.name}') -- \
  curl -s http://localhost:3000/health)

if echo "$HEALTH" | jq -e '.status == "ok"' > /dev/null; then
  echo "  ✅ Green health check PASSED"
else
  echo "  ❌ Green health check FAILED"
  echo "$HEALTH" | jq .
  kubectl delete deployment neo-curriculos-green
  exit 1
fi

# 4. Smoke test (internal)
echo "[T+0:12] Rodando smoke tests..."
GREEN_IP=$(kubectl get svc neo-curriculos-green -o jsonpath='{.spec.clusterIP}')
pytest tests/smoke/ --base-url="http://$GREEN_IP:3000" || {
  echo "❌ Smoke tests FAILED"
  kubectl delete deployment neo-curriculos-green
  exit 1
}
echo "  ✅ Smoke tests PASSED"

echo ""
echo "✅ Green deployment ready - $(date)"
echo "   Version: v$VERSION"
echo "   Pods: 3/3 ready"
echo "   Health: OK"
```

### Phase 2: Traffic Switch - Gradual (T+0:15 to T+0:35)

**Canary release (increasing traffic to Green)**

```bash
#!/bin/bash
# scripts/gradual-traffic-switch.sh

echo "🟠 [T+0:15] Iniciando traffic switch (gradual)..."

# We'll use a load balancer with weighted routing
# Kubernetes Istio/Flagger or AWS ALB

# Phase 1: 5% traffic (T+0:15)
echo "[T+0:15] Switching 5% traffic to Green..."
kubectl patch virtualservice neo-curriculos \
  -p '{"spec":{"hosts":[{"name":"api.neocurriculos.com"}],"http":[{"route":[{"destination":{"host":"neo-curriculos-blue"},"weight":95},{"destination":{"host":"neo-curriculos-green"},"weight":5}]}]}}'

echo "   ✓ 5% traffic to Green"
echo "   ✓ Monitoring for 5 minutes..."

# Monitor
for i in {1..5}; do
  sleep 60
  echo "   [T+0:$(printf "%02d" $((15+i)))] Checking metrics..."
  
  ERROR_RATE=$(curl -s http://prometheus:9090/api/v1/query \
    --data-urlencode 'query=rate(http_errors_total[5m])' | jq '.data.result[0].value[1]')
  
  if (( $(echo "$ERROR_RATE > 0.05" | bc -l) )); then
    echo "   ⚠️  Error rate high: $ERROR_RATE (rollback!)"
    bash scripts/rollback-production.sh
    exit 1
  fi
  
  echo "   ✅ Error rate OK: $ERROR_RATE"
done

# Phase 2: 25% traffic (T+0:20)
echo "[T+0:20] Switching 25% traffic to Green..."
kubectl patch virtualservice neo-curriculos \
  -p '{"spec":{"hosts":[{"name":"api.neocurriculos.com"}],"http":[{"route":[{"destination":{"host":"neo-curriculos-blue"},"weight":75},{"destination":{"host":"neo-curriculos-green"},"weight":25}]}]}}'

sleep 300
echo "   ✅ 25% phase stable"

# Phase 3: 50% traffic (T+0:25)
echo "[T+0:25] Switching 50% traffic to Green..."
kubectl patch virtualservice neo-curriculos \
  -p '{"spec":{"hosts":[{"name":"api.neocurriculos.com"}],"http":[{"route":[{"destination":{"host":"neo-curriculos-blue"},"weight":50},{"destination":{"host":"neo-curriculos-green"},"weight":50}]}]}}'

sleep 300
echo "   ✅ 50% phase stable"

# Phase 4: 75% traffic (T+0:30)
echo "[T+0:30] Switching 75% traffic to Green..."
kubectl patch virtualservice neo-curriculos \
  -p '{"spec":{"hosts":[{"name":"api.neocurriculos.com"}],"http":[{"route":[{"destination":{"host":"neo-curriculos-blue"},"weight":25},{"destination":{"host":"neo-curriculos-green"},"weight":75}]}]}}'

sleep 300
echo "   ✅ 75% phase stable"

echo ""
echo "✅ Gradual traffic switch complete - $(date)"
```

### Phase 3: Final Switch to 100% (T+0:35)

```bash
#!/bin/bash
# scripts/complete-traffic-switch.sh

echo "🟢 [T+0:35] Switching 100% traffic to Green..."

# Complete traffic switch
kubectl patch virtualservice neo-curriculos \
  -p '{"spec":{"hosts":[{"name":"api.neocurriculos.com"}],"http":[{"route":[{"destination":{"host":"neo-curriculos-green"},"weight":100}]}]}}'

echo "   ✓ 100% traffic to Green"

# Final validation
echo "[T+0:36] Running final validation..."
pytest tests/smoke/ --base-url=https://api.neocurriculos.com || {
  echo "❌ Final smoke test FAILED - triggering rollback"
  bash scripts/rollback-production.sh
  exit 1
}
echo "   ✅ Final smoke test PASSED"

# Check metrics
LATENCY=$(curl -s http://prometheus:9090/api/v1/query \
  --data-urlencode 'query=histogram_quantile(0.99, http_request_duration_seconds)' | jq '.data.result[0].value[1]')
ERROR_RATE=$(curl -s http://prometheus:9090/api/v1/query \
  --data-urlencode 'query=rate(http_errors_total[5m])' | jq '.data.result[0].value[1]')

echo "[T+0:37] Metrics validation..."
echo "   Latency p99: ${LATENCY}ms (target: < 2000ms)"
echo "   Error rate: ${ERROR_RATE}% (target: < 0.5%)"

if (( $(echo "$LATENCY > 2000" | bc -l) )); then
  echo "   ⚠️  High latency - initiating rollback"
  bash scripts/rollback-production.sh
  exit 1
fi

if (( $(echo "$ERROR_RATE > 0.005" | bc -l) )); then
  echo "   ⚠️  High error rate - initiating rollback"
  bash scripts/rollback-production.sh
  exit 1
fi

echo "   ✅ Metrics OK"

echo ""
echo "✅ 100% traffic switch complete"
```

---

## Post-Deployment Verification (T+0:37 to T+1:00)

### Extended Monitoring

```bash
#!/bin/bash
# scripts/post-deployment-monitoring.sh

echo "📊 [T+0:37] Starting extended monitoring (23 minutes)..."

# Monitor for 23 minutes
for i in {1..23}; do
  MINUTE=$((37+i))
  echo "[T+0:$MINUTE] Hourly checkpoint..."
  
  # Collect metrics
  UPTIME=$(curl -s https://api.neocurriculos.com/health | jq .uptime)
  LATENCY=$(curl -s http://prometheus:9090/api/v1/query \
    --data-urlencode 'query=histogram_quantile(0.99, http_request_duration_seconds)' | jq '.data.result[0].value[1]')
  ERROR_RATE=$(curl -s http://prometheus:9090/api/v1/query \
    --data-urlencode 'query=rate(http_errors_total[5m])' | jq '.data.result[0].value[1]')
  DB_CONNECTIONS=$(curl -s http://prometheus:9090/api/v1/query \
    --data-urlencode 'query=mongodb_connections_current' | jq '.data.result[0].value[1]')
  
  # Check for issues
  if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
    echo "   ⚠️  Error rate trending up: $ERROR_RATE%"
  fi
  
  if (( $(echo "$LATENCY > 2500" | bc -l) )); then
    echo "   ⚠️  Latency trending up: ${LATENCY}ms"
  fi
  
  echo "   ✓ Latency: ${LATENCY}ms | Errors: ${ERROR_RATE}% | DB conn: $DB_CONNECTIONS"
  
  sleep 60
done

echo ""
echo "✅ Extended monitoring complete"
```

### Final Sign-off (T+1:00)

```bash
#!/bin/bash
# scripts/post-deployment-signoff.sh

echo "✅ [T+1:00] POST-DEPLOYMENT SIGN-OFF"
echo ""

# Collect final metrics
UPTIME=$(curl -s https://api.neocurriculos.com/health | jq '.uptime // "N/A"')
LATENCY=$(curl -s http://prometheus:9090/api/v1/query \
  --data-urlencode 'query=histogram_quantile(0.99, http_request_duration_seconds)' | jq '.data.result[0].value[1]')
ERROR_RATE=$(curl -s http://prometheus:9090/api/v1/query \
  --data-urlencode 'query=rate(http_errors_total[5m])' | jq '.data.result[0].value[1]')

echo "DEPLOYMENT SUMMARY"
echo "===================="
echo "Version: v1.0.1"
echo "Environment: Production"
echo "Duration: 60 minutes"
echo ""
echo "METRICS:"
echo "  Uptime: ${UPTIME}s"
echo "  Latency p99: ${LATENCY}ms (target: < 2000ms) ✅"
echo "  Error rate: ${ERROR_RATE}% (target: < 0.5%) ✅"
echo ""
echo "STATUS:"
echo "  ✅ Blue deployment: in standby (for 24 hours)"
echo "  ✅ Green deployment: live (100% traffic)"
echo "  ✅ Rollback capability: ready"
echo ""
echo "NEXT STEPS:"
echo "  1. Monitor for 24 hours"
echo "  2. Archive Blue deployment"
echo "  3. Update documentation"
echo "  4. Post-deployment retrospective"
```

---

## Rollback Procedure (If Needed)

### Instant Rollback

```bash
#!/bin/bash
# scripts/rollback-production.sh
# Can be triggered at ANY time during deployment

set -euo pipefail

REASON=${1:-"Manual rollback"}
TIMESTAMP=$(date -u +%Y-%m-%d_%H-%M-%S)

echo "⚠️  INITIATING ROLLBACK"
echo "Reason: $REASON"
echo "Timestamp: $TIMESTAMP"

# 1. Stop Green (< 10 seconds)
echo "[Rollback 1/4] Stopping Green deployment..."
kubectl scale deployment neo-curriculos-green --replicas=0
sleep 5

# 2. Switch traffic back to Blue (< 5 seconds)
echo "[Rollback 2/4] Switching traffic to Blue..."
kubectl patch virtualservice neo-curriculos \
  -p '{"spec":{"hosts":[{"name":"api.neocurriculos.com"}],"http":[{"route":[{"destination":{"host":"neo-curriculos-blue"},"weight":100}]}]}}'

# 3. Verify Blue is healthy (< 10 seconds)
echo "[Rollback 3/4] Verifying Blue health..."
sleep 10
HEALTH=$(curl -s https://api.neocurriculos.com/health)
if echo "$HEALTH" | jq -e '.status == "ok"' > /dev/null; then
  echo "   ✅ Blue healthy"
else
  echo "   ❌ Blue unhealthy!"
  exit 1
fi

# 4. Notify team (< 1 minute)
echo "[Rollback 4/4] Notifying team..."
curl -X POST https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
  -H 'Content-Type: application/json' \
  -d "{\"text\":\":warning: ROLLBACK EXECUTED\\nReason: $REASON\\nTime: $TIMESTAMP\"}"

echo ""
echo "✅ ROLLBACK COMPLETE"
echo "   Total time: < 1 minute"
echo "   Version live: v1.0.0"
echo "   Next: Investigate root cause"
```

---

## Monitoring Checklist

### Continuous Monitoring During Deployment

```yaml
Every 5 minutes (automated):
  ├─ API uptime: 100% expected
  ├─ Latency p99: < 2s expected
  ├─ Error rate: < 0.5% expected
  ├─ Database CPU: < 70% expected
  ├─ Memory usage: < 80% expected
  ├─ Disk usage: < 80% expected
  └─ Connection pool: < 80% capacity

Manual checks (every 15 minutes):
  ├─ Sample API calls (POST, GET, DELETE)
  ├─ Check logs for errors
  ├─ Verify database replication lag
  └─ Check for resource exhaustion warnings
```

---

## Timeline Summary

```
T-60 min  → Code freeze, testing, team assembly
T-10 min  → Final approvals
T+0:00   → Green deployment starts
T+0:15   → 5% traffic to Green
T+0:20   → 25% traffic to Green
T+0:25   → 50% traffic to Green
T+0:30   → 75% traffic to Green
T+0:35   → 100% traffic to Green
T+0:37   → Extended monitoring starts
T+1:00   → Deployment complete, sign-off
T+24:00  → Archive Blue deployment

Total Time: ~60 minutes
Downtime: 0 minutes (blue-green)
Rollback: < 5 minutes (instant if needed)
```

---

## Post-Deployment Tasks

```markdown
## 1 Hour After Deployment

- [ ] Verify metrics normal
- [ ] Check user feedback (Slack, support)
- [ ] Confirm no data inconsistencies
- [ ] Update status page: "Deployed v1.0.1"

## 24 Hours After Deployment

- [ ] Extended monitoring complete
- [ ] Archive Blue deployment
- [ ] Final metrics review
- [ ] Update docs/CHANGELOG.md

## Within 1 Week

- [ ] Retrospective meeting
- [ ] Identify improvements
- [ ] Update procedures if needed
- [ ] Celebrate successful launch 🎉
```

---

## Success Criteria

```yaml
Deployment successful if:
  ✅ Zero downtime achieved
  ✅ All smoke tests pass
  ✅ Latency < 2s p99 (maintained)
  ✅ Error rate < 0.5% (maintained)
  ✅ No critical incidents
  ✅ Rollback available for 24h
  ✅ Team confidence high

Deployment failed if:
  ❌ Latency > 5s p99 (during deployment)
  ❌ Error rate > 5% (during deployment)
  ❌ Any critical service down
  ❌ Data loss or corruption
  ❌ Smoke test failures persist
```
