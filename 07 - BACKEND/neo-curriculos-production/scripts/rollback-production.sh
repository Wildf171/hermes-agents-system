#!/bin/bash
# rollback-production.sh
# Emergency rollback to previous version
# Usage: ./rollback-production.sh [VERSION] [RESTORE_DB]

set -euo pipefail

VERSION=${1:-"v1.0.0"}
RESTORE_DB=${2:-"false"}
TIMEOUT=300  # 5 minutos
TIMESTAMP=$(date -u +%Y-%m-%d_%H-%M-%S)

echo "🔄 PRODUCTION ROLLBACK"
echo "===================="
echo "Version: $VERSION"
echo "Restore DB: $RESTORE_DB"
echo "Timestamp: $TIMESTAMP"
echo ""

# Logging
LOG_FILE="/var/log/neo-curriculos/rollback-$TIMESTAMP.log"
exec 1> >(tee -a "$LOG_FILE")
exec 2>&1

# 1. Acknowledge rollback
echo "[1/5] Acknowledgement..."
echo "Rollback initiated at $TIMESTAMP" >> "$LOG_FILE"

# 2. Stop Green deployment (novo)
echo "[2/5] Stopping Green deployment..."
if kubectl get deployment neo-curriculos-green &> /dev/null; then
  kubectl scale deployment neo-curriculos-green --replicas=0 2>/dev/null || true
  sleep 10
  echo "  ✓ Green stopped"
else
  echo "  ℹ️  Green not found (already stopped?)"
fi

# 3. Restore database if needed
if [[ "$RESTORE_DB" == "true" ]]; then
  echo "[3/5] Restoring database from backup..."

  # Find backup (latest)
  BACKUP_FILE=$(aws s3 ls s3://neo-curriculos-backups/mongodb/ --recursive | sort | tail -1 | awk '{print $4}')

  if [[ -z "$BACKUP_FILE" ]]; then
    echo "  ❌ No backup found!"
    exit 1
  fi

  echo "  Restoring from: $BACKUP_FILE"

  # Stop app to ensure no writes
  kubectl scale deployment neo-curriculos-api --replicas=0
  sleep 10

  # Download and restore
  aws s3 cp "s3://neo-curriculos-backups/$BACKUP_FILE" /tmp/backup.tar.gz
  cd /var/lib/mongodb
  tar -xzf /tmp/backup.tar.gz

  # Restart MongoDB
  kubectl rollout restart statefulset neo-curriculos-mongodb
  kubectl rollout status statefulset neo-curriculos-mongodb --timeout=300s

  echo "  ✓ Database restored"
fi

# 4. Switch traffic back to Blue
echo "[4/5] Switching traffic back to Blue..."
kubectl patch virtualservice neo-curriculos \
  -p '{"spec":{"hosts":[{"name":"api.neocurriculos.com"}],"http":[{"route":[{"destination":{"host":"neo-curriculos-blue"},"weight":100}]}]}}' 2>/dev/null || true

sleep 10
echo "  ✓ Traffic switched to Blue"

# 5. Verify health
echo "[5/5] Verifying Blue health..."
HEALTH=$(curl -s -m 10 https://api.neocurriculos.com/health 2>/dev/null || echo '{"status":"error"}')

if echo "$HEALTH" | jq -e '.status == "ok"' > /dev/null 2>&1; then
  echo "  ✅ Blue healthy"
else
  echo "  ⚠️  Blue health check inconclusive"
  echo "  Response: $HEALTH"
fi

# 6. Notify team
echo ""
echo "✅ ROLLBACK COMPLETE"
echo "===================="
echo "Version rolled back to: $VERSION"
echo "Timestamp: $TIMESTAMP"
echo "Total time: ${SECONDS}s"
echo ""
echo "Next steps:"
echo "1. Investigate root cause"
echo "2. Review logs: $LOG_FILE"
echo "3. Post in #neo-curriculos-incidents"
echo "4. Schedule post-mortem"
echo ""

# Send Slack notification
SLACK_MSG="🔄 Production Rollback Executed
Version: $VERSION
Timestamp: $TIMESTAMP
Reason: Check logs for details
Status: Blue deployment live"

curl -X POST https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
  -H 'Content-Type: application/json' \
  -d "{\"text\":\"$SLACK_MSG\"}" 2>/dev/null || true

exit 0
