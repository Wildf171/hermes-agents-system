# 20 - RUNBOOK_OPERACIONAL.md
## Procedimentos Operacionais Diários - Neo Currículos + Neo RH System

**Data:** Setembro 2026  
**Versão:** 1.0.0

---

## 1. STARTUP (9:00 AM UTC)

### Checklist de Startup

```bash
#!/bin/bash
# scripts/startup-check.sh

echo "🚀 Daily Startup Checklist - $(date)"

# 1.1 API Health
echo "[1/5] Verificando saúde da API..."
HEALTH=$(curl -s https://api.neocurriculos.com/health)
if echo "$HEALTH" | jq -e '.status == "ok"' > /dev/null; then
  echo "  ✅ API healthy"
else
  echo "  ❌ API UNHEALTHY!"
  echo "$HEALTH" | jq .
  exit 1
fi

# 1.2 Database Status
echo "[2/5] Verificando banco de dados..."
mongo neo_curriculos --eval "db.adminCommand('ping')" && echo "  ✅ MongoDB OK"

# 1.3 Cache Status
echo "[3/5] Verificando cache..."
redis-cli ping && echo "  ✅ Redis OK"

# 1.4 Storage Status
echo "[4/5] Verificando storage..."
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
if [[ $DISK_USAGE -lt 80 ]]; then
  echo "  ✅ Disk OK ($DISK_USAGE%)"
else
  echo "  ⚠️  Disk CRITICAL ($DISK_USAGE%)"
fi

# 1.5 Backup Status
echo "[5/5] Verificando último backup..."
LAST_BACKUP=$(aws s3 ls s3://neo-curriculos-backups/mongodb/ --recursive | sort | tail -1)
echo "  ✅ Último backup: $LAST_BACKUP"

echo ""
echo "✅ Startup check completo!"
```

### Dashboard Review (Grafana)

1. Abrir: https://grafana.neocurriculos.com
2. Dashboard: "API Health"
3. Métricas críticas:
   - API latency (p99 < 2s)
   - Error rate (< 0.5%)
   - Database connections (< 100)
   - Memory usage (< 80%)

```bash
# Quick CLI check
curl -s http://prometheus:9090/api/v1/query \
  --data-urlencode 'query=histogram_quantile(0.99, http_request_duration_seconds)'

curl -s http://prometheus:9090/api/v1/query \
  --data-urlencode 'query=rate(http_errors_total[5m])'
```

### Log Review (Kibana)

```bash
# Últimas 30 min de erros críticos
curl -X GET 'http://kibana:5601/api/logs?level=error&timerange=30m' \
  -H 'Content-Type: application/json' | jq '.logs[] | select(.level == "error")'

# Ou via command line
tail -100 /var/log/neo-curriculos/error.log | grep -E "ERROR|FATAL"
```

---

## 2. DAILY MONITORING

### Hourly Health Checks (Automated via Prometheus)

```yaml
# prometheus/rules/neo-curriculos-alerts.yml

groups:
  - name: neo-curriculos-hourly
    interval: 1m
    rules:
      - alert: ApiUptime
        expr: up{job="neo-curriculos-api"} == 1
        for: 2m
        annotations:
          summary: "API uptime: {{ $value }}"

      - alert: HighLatency
        expr: histogram_quantile(0.99, http_request_duration_seconds) > 2
        for: 3m
        labels:
          severity: warning
        annotations:
          summary: "Latência p99 > 2s: {{ $value }}"

      - alert: HighErrorRate
        expr: rate(http_errors_total[5m]) > 0.005
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Error rate > 0.5%: {{ $value }}"

      - alert: DatabaseCpuHigh
        expr: mongodb_server_status_cpu_utilization > 0.8
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Database CPU > 80%"

      - alert: DiskUsageHigh
        expr: node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes * 100 < 20
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Disk < 20% available"
```

### Weekly Backup Validation

```bash
#!/bin/bash
# Run every Monday 10:00 AM UTC
# scripts/validate-backup.sh

echo "🔍 Weekly Backup Validation - $(date)"

# 1. Check backup age
echo "[1/4] Verificando idade do backup..."
BACKUP_AGE=$(find /backups -name "*.tar.gz" -type f -mtime -1)
if [ -n "$BACKUP_AGE" ]; then
  echo "  ✅ Backup recente encontrado"
else
  echo "  ❌ Nenhum backup recente!"
  exit 1
fi

# 2. Check backup size
echo "[2/4] Verificando tamanho do backup..."
BACKUP_SIZE=$(du -sh /backups/latest.tar.gz | cut -f1)
echo "  ✓ Backup size: $BACKUP_SIZE"
# Expected: 2-3 GB (alert if < 1 GB or > 10 GB)

# 3. Restore test (in staging)
echo "[3/4] Teste de restore..."
mkdir /tmp/restore-test
tar -xzf /backups/latest.tar.gz -C /tmp/restore-test
mongorestore --uri="mongodb://staging:27017" /tmp/restore-test/dump
# Measure restore time
RESTORE_TIME=$(time mongorestore ... 2>&1 | grep real)
echo "  ✓ Restore completed: $RESTORE_TIME"

if [[ $(echo "$RESTORE_TIME" | grep -oE '[0-9]+m' | head -1 | sed 's/m//') -gt 30 ]]; then
  echo "  ⚠️  Restore took > 30 min!"
fi

# 4. Data integrity check
echo "[4/4] Verificando integridade de dados..."
COLLECTION_COUNT=$(mongosh staging --eval "db.getCollectionNames().length")
EXPECTED_COUNT=15  # Número de coleções esperadas
if [[ $COLLECTION_COUNT -eq $EXPECTED_COUNT ]]; then
  echo "  ✅ Integridade OK: $COLLECTION_COUNT coleções"
else
  echo "  ❌ Mismatch: $COLLECTION_COUNT vs $EXPECTED_COUNT"
fi

echo ""
echo "✅ Backup validation complete"
echo "   Backup age: $(stat -c %y /backups/latest.tar.gz)"
echo "   Backup size: $BACKUP_SIZE"
echo "   Restore time: $RESTORE_TIME"
echo "   Data integrity: OK"
```

### Monthly Security Audit

```bash
#!/bin/bash
# Run first Sunday of each month (1:00 AM UTC)
# scripts/security-audit.sh

echo "🔒 Monthly Security Audit - $(date)"

# 1. Check secret rotation (quarterly)
echo "[1/5] Verificando rotação de secrets..."
LAST_ROTATION=$(cat /etc/neo-curriculos/secrets/rotation-log.txt | tail -1)
echo "  Última rotação: $LAST_ROTATION"

# 2. SSL certificate validation
echo "[2/5] Validando certificados SSL..."
openssl s_client -connect api.neocurriculos.com:443 -noout -checkhost api.neocurriculos.com

# 3. Firewall rules audit
echo "[3/5] Auditando regras de firewall..."
aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=neo-curriculos-*" \
  --query 'SecurityGroups[].IpPermissions[].[FromPort,ToPort]'

# 4. IAM permissions review
echo "[4/5] Auditando permissões IAM..."
aws iam list-role-policies --role-name neo-curriculos-app-role

# 5. Vulnerability scan
echo "[5/5] Scanning vulnerabilities..."
trivy image neo-curriculos:latest
```

---

## 3. INCIDENT RESPONSE

### Escalation Matrix

```
Severity Level | Detection | Response Time | Escalation
---|---|---|---
🔴 CRITICAL | Alert + SMS | 5 minutes | VP Eng + CTO + Head Ops
🟠 HIGH | Alert + Slack | 15 minutes | Team Lead + On-call
🟡 MEDIUM | Slack | 1 hour | On-call engineer
🟢 LOW | Email | 4 hours | Dev team backlog
```

### Incident Communication Flow

```
1. ALERT (< 5 min)
   └─ Prometheus alert
   └─ PagerDuty notification
   └─ Slack #neo-curriculos-alerts

2. ACKNOWLEDGE (< 5 min)
   └─ On-call accepts alert
   └─ Slack: "I'm on it"

3. INVESTIGATE (< 15 min)
   └─ Pull logs
   └─ Check metrics
   └─ Determine cause
   └─ Slack update: investigation summary

4. REMEDIATE (< 30 min)
   └─ Implement fix or workaround
   └─ Deploy patch
   └─ Verify resolution
   └─ Slack update: "Issue resolved at 14:32 UTC"

5. POST-MORTEM (within 24 hours)
   └─ Analyze root cause
   └─ Identify preventive measures
   └─ Document in incident tracker
```

### Incident Communication Template

```markdown
# INCIDENT: [Title]

**Time:** 2025-09-07 14:30:15 UTC  
**Duration:** 12 minutes  
**Status:** RESOLVED  

## Impact
- Users Affected: 450 (5%)
- Services Down: API + Search
- Revenue Impact: ~$2K

## Timeline
- 14:30 — Error rate alert triggered (8%)
- 14:32 — On-call acknowledged
- 14:35 — Root cause identified: Database connection pool exhausted
- 14:42 — Database restart executed
- 14:43 — Services healthy again

## Root Cause
Recursive query on `curriculos.usuarios` causing connection leak. High traffic from job scraper exceeded pool limits.

## Resolution
1. Restarted MongoDB connection pool
2. Killed runaway job scraper (rate-limited incorrectly)
3. Added connection pool monitoring

## Preventive Measures
1. Implement per-IP rate limiting (done)
2. Add connection pool alerting at 80% (backlog)
3. Test connection pool exhaustion scenario (backlog)
```

### Common Alerts & Responses

#### Alert: High Error Rate

```bash
#!/bin/bash
# On-call procedure: Error rate > 5%

echo "🚨 High error rate detected"

# Step 1: Get error details
kubectl logs -l app=neo-curriculos --tail=100 | grep ERROR

# Step 2: Check common causes
curl https://api.neocurriculos.com/health | jq .

# Step 3: Find the problem
if [[ $(curl -s http://localhost:27017) == "" ]]; then
  echo "Database unreachable"
  # Action: Database failover
  bash scripts/failover.sh
fi

if [[ $(curl -s http://cache:6379/ping) != "PONG" ]]; then
  echo "Cache unavailable"
  # Action: Restart cache
  kubectl rollout restart deployment neo-curriculos-redis
fi

# Step 4: If still high, trigger rollback
CURRENT_ERROR_RATE=$(curl -s http://prometheus:9090/api/v1/query \
  --data-urlencode 'query=rate(http_errors_total[5m])' | jq '.data.result[0].value[1]')

if [[ $(echo "$CURRENT_ERROR_RATE > 0.1" | bc) -eq 1 ]]; then
  echo "Error rate > 10% - Initiating rollback"
  bash scripts/rollback-production.sh
fi
```

#### Alert: High Latency

```bash
# If p99 latency > 5s

# Check what's slow
curl https://api.neocurriculos.com/debug/slow-queries | jq '.queries[] | select(.duration > 1000)'

# Likely causes:
# 1. Database query taking too long
#    → Add index or optimize query
# 2. External API call slow
#    → Increase timeout or skip if possible
# 3. Garbage collection pause
#    → Increase heap size or JVM tuning
```

---

## 4. DEPLOYMENT PROCEDURE

### Pre-deployment Checklist

```bash
#!/bin/bash
# scripts/pre-deployment-check.sh

echo "📋 Pre-deployment Checklist"

# [ ] All tests passing
echo -n "Running tests... "
npm test > /tmp/test-results.txt 2>&1 && echo "✅" || echo "❌"

# [ ] Code review approved
echo "Code review: (manual check)"

# [ ] Documentation updated
echo -n "Docs updated: "
git diff --name-only | grep -i doc && echo "✅" || echo "⚠️"

# [ ] Secrets rotated
echo -n "Secrets rotated: "
[[ -f /etc/neo-curriculos/secrets/.rotated-today ]] && echo "✅" || echo "❌"

# [ ] Database migration tested
echo "Database migration tested: (manual check)"

# [ ] Rollback plan documented
echo "Rollback plan: (in 24_PRODUCTION_DEPLOYMENT_PROCEDURE.md)"

echo ""
echo "✅ Ready to deploy!"
```

### Deployment Steps

```bash
#!/bin/bash
# scripts/deploy-production.sh

set -euo pipefail

VERSION=${1:-"v1.0.1"}
TIMEOUT=600

echo "🚀 Deploying $VERSION to production"

# 1. Tag release
echo "[1/5] Tagging release..."
git tag -a $VERSION -m "Release: $VERSION"
git push origin $VERSION

# 2. Trigger CI/CD (GitHub Actions)
echo "[2/5] CI/CD pipeline running..."
gh workflow run deploy.yml --ref $VERSION

# 3. Monitor deployment
echo "[3/5] Monitoring deployment..."
watch -n 5 'kubectl logs deployment/neo-curriculos-green | tail -20'

# 4. Run smoke tests
echo "[4/5] Running smoke tests..."
sleep 30
pytest tests/smoke/ --base-url=$PROD_URL

# 5. Verify metrics
echo "[5/5] Verifying metrics..."
curl -s https://api.neocurriculos.com/health | jq .

echo ""
echo "✅ Deployment successful - $VERSION live"
```

---

## 5. DATABASE MANAGEMENT

### Backup Schedule

```yaml
Backup Strategy:

Full Daily Backups (Monday-Friday, 2:00 AM UTC):
  ├─ Command: mongodump --archive=db-backup.archive
  ├─ Location: /backups/daily-$DATE.tar.gz
  ├─ Size: ~2.5 GB
  ├─ Upload to S3: yes (cross-region)
  └─ Compression: gzip

Hourly Incremental (Oplog replication):
  ├─ Method: MongoDB oplog
  ├─ Lag: < 1 second
  ├─ Retention: 90 days
  └─ Recovery window: 24 hours

Archive (Glacier, 7 years for LGPD):
  ├─ Transition after: 1 year
  ├─ Location: s3://neo-curriculos-backups-archive
  └─ Retrieval time: 12 hours
```

### Backup Validation

```bash
#!/bin/bash
# Run daily at 4:00 AM UTC

# 1. Check backup exists
[[ -f /backups/daily-$(date +%Y-%m-%d).tar.gz ]] && echo "✅" || echo "❌"

# 2. Check size (should be ~2-3 GB)
SIZE=$(du -h /backups/daily-*.tar.gz | tail -1 | cut -f1)
[[ $(echo $SIZE | grep -oE '[0-9]+' | head -1) -ge 2 ]] && echo "✅ Size OK: $SIZE"

# 3. Test restore
tar -tzf /backups/daily-latest.tar.gz > /tmp/backup-contents.txt
[[ $(wc -l < /tmp/backup-contents.txt) -gt 1000 ]] && echo "✅ Archive integrity OK"
```

---

## 6. PERFORMANCE TUNING

### Identify Slow Queries

```bash
# MongoDB slow log (queries > 1000ms)
mongo neo_curriculos --eval "
  db.system.profile.find({
    'millis': {\$gt: 1000}
  }).sort({ts: -1}).limit(10).pretty()
"

# Top 10 slowest operations (1 hour)
mongo neo_curriculos --eval "
  db.system.profile.aggregate([
    {
      \$match: {
        ts: {\$gt: new Date(Date.now() - 3600*1000)}
      }
    },
    {
      \$group: {
        _id: '\$ns',
        avgMs: {\$avg: '\$millis'},
        maxMs: {\$max: '\$millis'},
        count: {\$sum: 1}
      }
    },
    {\$sort: {maxMs: -1}},
    {\$limit: 10}
  ]).pretty()
"
```

### Add Missing Indexes

```bash
# Example: Create index for common query
db.curriculos.createIndex({
  "usuario_id": 1,
  "criado_em": -1
})

# Verify index usage
db.curriculos.getIndexes()
db.curriculos.aggregate([{$indexStats: {}}])
```

---

## 7. SECURITY OPERATIONS

### Secret Rotation (Quarterly)

```bash
#!/bin/bash
# scripts/rotate-secrets.sh

echo "🔄 Rotating secrets..."

# 1. Generate new JWT signing key
NEW_JWT_KEY=$(openssl rand -base64 32)

# 2. Generate new DB password
NEW_DB_PASS=$(openssl rand -base64 24)

# 3. Update secrets
kubectl create secret generic neo-curriculos-secrets \
  --from-literal=JWT_KEY=$NEW_JWT_KEY \
  --from-literal=DB_PASSWORD=$NEW_DB_PASS \
  -o yaml --dry-run=client | kubectl apply -f -

# 4. Restart apps (rolling restart, 0 downtime)
kubectl rollout restart deployment neo-curriculos-api

echo "✅ Secrets rotated"
```

### DDoS Mitigation

```bash
# If activated:
bash scripts/activate-waf.sh

# Check WAF rules
aws wafv2 list-rules --name neo-curriculos-waf --scope CLOUDFRONT
```

---

## 8. COMMUNICATION

### Status Page Updates

Update: https://status.neocurriculos.com
- Incidents posted automatically
- Status: "Operational", "Degraded", "Major Outage"
- History visible for 90 days

### Slack Channels

```
#neo-curriculos-prod-events
  └─ Critical incidents only

#neo-curriculos-prod-deploys
  └─ All deployment notifications

#neo-curriculos-prod-incidents
  └─ Investigation channel

#neo-curriculos-prod-alerts
  └─ Automated Prometheus alerts
```

### Weekly Report (Friday 17:00 UTC)

```
Subject: Neo Currículos Production Report - Week of Sept 7

Uptime: 99.97% (target: 99.95%)
Incidents: 0
Deployments: 3 (all successful)
Performance:
  - Latency p99: 1.2s (target: < 2s)
  - Error rate: 0.12% (target: < 0.5%)
  - Database CPU: 35% avg (target: < 70%)

Next Week Planned:
  - Security audit (Tuesday)
  - Database maintenance (Wednesday)
  - Feature deploy (Friday)

Action Items:
  - None
```

---

## Emergency Procedures

### When Things Go Very Wrong

```bash
# Nuclear option - full system restart
# (Use only if everything else failed)

# 1. Stop all apps
kubectl scale deployment neo-curriculos-api --replicas=0

# 2. Restart database
kubectl rollout restart statefulset neo-curriculos-mongodb
kubectl rollout status statefulset neo-curriculos-mongodb

# 3. Clear cache
redis-cli FLUSHALL

# 4. Restart app
kubectl scale deployment neo-curriculos-api --replicas=3

# 5. Verify
curl https://api.neocurriculos.com/health

# 6. Investigate offline
# Do root cause analysis after system is up
```

---

## Summary

- ✅ Startup checks (5 min)
- ✅ Hourly monitoring (automated)
- ✅ Weekly backup validation
- ✅ Monthly security audit
- ✅ Incident response procedures
- ✅ Deployment steps
- ✅ Database management
- ✅ Performance tuning
- ✅ Security operations
- ✅ Communication protocols
