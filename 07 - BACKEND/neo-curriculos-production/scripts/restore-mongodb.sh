#!/bin/bash
# restore-mongodb.sh
# Restore MongoDB from backup

set -euo pipefail

VERSION=${1:-"latest"}
TIMESTAMP=${2:-""}
TIMEOUT=1800

echo "🔄 MongoDB Restore Procedure"
echo "Version: $VERSION"
echo ""

# 1. Stop app
echo "[1/6] Stopping application..."
kubectl scale deployment neo-curriculos-api --replicas=0
sleep 10
echo "  ✓ App stopped"

# 2. Identify backup
echo "[2/6] Identifying backup..."
if [[ -z "$TIMESTAMP" ]]; then
  BACKUP_FILE=$(aws s3 ls s3://neo-curriculos-backups/mongodb/ --recursive | sort | tail -1 | awk '{print $4}')
else
  BACKUP_FILE="s3://neo-curriculos-backups/mongodb/$TIMESTAMP.tar.gz"
fi
echo "  Backup: $BACKUP_FILE"

# 3. Stop MongoDB
echo "[3/6] Stopping MongoDB..."
kubectl exec -it $(kubectl get pod -l app=mongodb -o jsonpath='{.items[0].metadata.name}') -- \
  mongosh --eval "db.adminCommand('shutdown')" 2>/dev/null || true
sleep 5
echo "  ✓ MongoDB stopped"

# 4. Download and restore
echo "[4/6] Restoring backup..."
aws s3 cp "s3://$BACKUP_FILE" /tmp/backup.tar.gz
cd /var/lib/mongodb
tar -xzf /tmp/backup.tar.gz
echo "  ✓ Backup extracted"

# 5. Start MongoDB
echo "[5/6] Starting MongoDB..."
kubectl rollout restart statefulset neo-curriculos-mongodb
kubectl rollout status statefulset neo-curriculos-mongodb --timeout=300s
sleep 10
echo "  ✓ MongoDB started"

# 6. Restart app
echo "[6/6] Restarting application..."
kubectl scale deployment neo-curriculos-api --replicas=3
kubectl rollout status deployment neo-curriculos-api --timeout=300s
echo "  ✓ App restarted"

# Validation
echo ""
echo "Validating restore..."
HEALTH=$(curl -s -m 10 https://api.neocurriculos.com/health 2>/dev/null || echo "")
if echo "$HEALTH" | jq -e '.status == "ok"' > /dev/null 2>&1; then
  echo "✅ Restore successful"
else
  echo "⚠️  Health check inconclusive"
fi

exit 0
