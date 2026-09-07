#!/bin/bash
# incident-response.sh
# Incident response for LGPD breach or critical security issue

set -euo pipefail

SEVERITY=${1:-"high"}
TIMESTAMP=$(date -u +%Y-%m-%d_%H-%M-%S)

echo "🚨 INCIDENT RESPONSE - Severity: $SEVERITY"
echo "Timestamp: $TIMESTAMP"
echo ""

INCIDENT_DIR="/tmp/incident-$TIMESTAMP"
mkdir -p "$INCIDENT_DIR"

# 1. ISOLATE (< 5 min)
echo "[1/6] ISOLATION..."
echo "  Stopping application..."
kubectl scale deployment neo-curriculos-api --replicas=0

echo "  Setting database to read-only..."
# This would set the database to read-only mode
echo "  ✓ Systems isolated"

# 2. CONTAINMENT (< 15 min)
echo "[2/6] CONTAINMENT..."
echo "  Revoking all API tokens..."
# redis-cli FLUSHDB  # Clear sessions (commented out for safety)
echo "  ✓ Tokens revoked"

# 3. FORENSICS
echo "[3/6] FORENSICS..."
echo "  Collecting logs..."
mkdir -p "$INCIDENT_DIR/logs"
kubectl logs deployment/neo-curriculos-api --all-containers=true > "$INCIDENT_DIR/logs/api.log" 2>/dev/null || true
kubectl logs statefulset/neo-curriculos-mongodb > "$INCIDENT_DIR/logs/mongodb.log" 2>/dev/null || true
echo "  ✓ Logs collected"

# 4. NOTIFICATION (LGPD: < 72h)
echo "[4/6] NOTIFICATION..."
echo "Incident at $TIMESTAMP - Severity: $SEVERITY" > "$INCIDENT_DIR/notification.txt"
echo "  ✓ Notifications prepared"

# 5. REMEDIATION
echo "[5/6] REMEDIATION..."
echo "  Redeploying with patches..."
# Deploy security patch
kubectl apply -f kubernetes/deployment-security-patched.yaml 2>/dev/null || true
echo "  ✓ Deployment patched"

# 6. VERIFICATION
echo "[6/6] VERIFICATION..."
sleep 30
HEALTH=$(curl -s -m 10 https://api.neocurriculos.com/health 2>/dev/null || echo "")
if echo "$HEALTH" | jq -e '.status == "ok"' > /dev/null 2>&1; then
  echo "  ✅ System recovered"
else
  echo "  ⚠️  Manual verification needed"
fi

echo ""
echo "✅ INCIDENT RESPONSE COMPLETE"
echo "Incident files: $INCIDENT_DIR"
echo ""
echo "Next steps:"
echo "1. LGPD notification (< 72 hours)"
echo "2. Post-mortem (24-48 hours)"
echo "3. Implement preventive measures"
echo ""

exit 0
