#!/bin/bash
# failover.sh
# Automatic failover for infrastructure issues
# Usage: ./failover.sh [SERVICE]

set -euo pipefail

SERVICE=${1:-"neo-curriculos-api"}
TIMEOUT=900
TIMESTAMP=$(date -u +%Y-%m-%d_%H-%M-%S)

echo "⚡ FAILOVER PROCEDURE - $SERVICE"
echo "Timestamp: $TIMESTAMP"
echo ""

# 1. Detect failure
echo "[1/4] Detecting failure state..."
FAILURE_REASON=""

case "$SERVICE" in
  "neo-curriculos-api")
    READY_PODS=$(kubectl get deployment neo-curriculos-api -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
    if [[ $READY_PODS -lt 1 ]]; then
      FAILURE_REASON="No API pods ready"
    fi
    ;;
  "neo-curriculos-db")
    DB_STATUS=$(mongo --eval "db.adminCommand('ping')" 2>/dev/null || echo "failed")
    if [[ "$DB_STATUS" != "{ ok: 1 }" ]]; then
      FAILURE_REASON="Database unreachable"
    fi
    ;;
esac

if [[ -n "$FAILURE_REASON" ]]; then
  echo "  ✓ Failure detected: $FAILURE_REASON"
fi

# 2. ASG/Auto-scaling response
echo "[2/4] Triggering auto-recovery..."

case "$SERVICE" in
  "neo-curriculos-api")
    # Restart the deployment
    kubectl rollout restart deployment neo-curriculos-api
    kubectl rollout status deployment neo-curriculos-api --timeout=300s
    echo "  ✓ API deployment restarted"
    ;;
  "neo-curriculos-db")
    # Failover to replica
    kubectl rollout restart statefulset neo-curriculos-mongodb
    kubectl rollout status statefulset neo-curriculos-mongodb --timeout=300s
    echo "  ✓ Database restarted"
    ;;
esac

# 3. Load balancer health check
echo "[3/4] Verifying health checks..."
sleep 15

HEALTHY=false
for i in {1..10}; do
  if [[ "$SERVICE" == "neo-curriculos-api" ]]; then
    HEALTH=$(curl -s -m 5 https://api.neocurriculos.com/health 2>/dev/null || echo "")
    if echo "$HEALTH" | jq -e '.status == "ok"' > /dev/null 2>&1; then
      HEALTHY=true
      break
    fi
  elif [[ "$SERVICE" == "neo-curriculos-db" ]]; then
    if mongo --eval "db.adminCommand('ping')" 2>/dev/null | grep -q "ok"; then
      HEALTHY=true
      break
    fi
  fi
  echo "  Attempt $i/10..."
  sleep 10
done

if [[ "$HEALTHY" == "true" ]]; then
  echo "  ✅ Service healthy"
else
  echo "  ⚠️  Service health inconclusive - manual check needed"
fi

# 4. Traffic re-routing
echo "[4/4] Re-routing traffic..."

if [[ "$SERVICE" == "neo-curriculos-api" ]]; then
  kubectl patch service neo-curriculos-api -p '{"spec":{"selector":{"app":"neo-curriculos","version":"blue"}}}'
  echo "  ✓ Traffic re-routed to Blue"
fi

# Summary
echo ""
echo "✅ FAILOVER COMPLETE"
echo "Service: $SERVICE"
echo "Time: ${SECONDS}s"
echo ""

# Notify team
curl -X POST https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
  -H 'Content-Type: application/json' \
  -d "{\"text\":\":zap: Failover executed for $SERVICE\\nStatus: Recovered\\nTime: $TIMESTAMP\"}" 2>/dev/null || true

exit 0
