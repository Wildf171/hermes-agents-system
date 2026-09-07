# 21 - ONCALL_PROCEDURES.md
## Procedimentos On-Call - Neo Currículos + Neo RH System

**Data:** Setembro 2026  
**Versão:** 1.0.0

---

## On-call Setup

### Escalation & Rotation

```yaml
On-call Schedule:

Primary On-call: 1 person (24 hours)
├─ Time: Monday 00:00 UTC → Sunday 23:59 UTC
├─ Alert methods: SMS + Slack + Email
├─ Response SLA: 5-15 minutes (depends on severity)
└─ Rotation: Weekly

Secondary On-call: 1 person (backup)
├─ Activated if primary unresponsive (15 min)
├─ Full escalation after 30 minutes
└─ Rotation: Weekly (offset from primary)

Escalation Chain:
├─ 5 min: On-call engineer
├─ 15 min: Team lead (if critical)
├─ 30 min: VP Engineering
└─ 60 min: CTO (if still unresolved)
```

### Critical Tools & Access

```bash
# Tools for on-call
Grafana:     https://grafana.neocurriculos.com
Prometheus:  https://prometheus.neocurriculos.com
Kibana:      https://kibana.neocurriculos.com
PagerDuty:   https://pagerduty.neocurriculos.com
AWS Console: https://console.aws.amazon.com/ec2

# Required access
SSH keys: ~/.ssh/prod.pem (on-call laptop)
DB access: Username/password in 1Password
Slack: @on-call pinned in #neo-curriculos-incidents
Phone: +55 11 9XXXX-XXXX (backup contact)
```

---

## Critical Alert Responses

### Alert: Database CPU > 90%

```markdown
## RESPONSE PROCEDURE: Database CPU High

**Alert:** "MongoDBCpuHigh" triggered at 14:30 UTC
**Threshold:** CPU > 90% for 5 minutes
**Severity:** CRITICAL

### Diagnosis (< 5 min)

1. SSH into database server
```bash
ssh -i ~/.ssh/prod.pem ubuntu@db-prod-1.neocurriculos.com
```

2. Check current CPU
```bash
top -b -n 1 | head -20
```

3. Check processes
```bash
ps aux | sort -k3 -r | head -10
```

4. Check I/O
```bash
iostat -x 1 5
```

5. Check database stats
```bash
mongo admin -u $USER -p $PASS
> db.serverStatus().opcounters
> db.currentOp()
```

### Mitigation (Choose one)

**Option 1: Kill slow query (fastest)**
```bash
mongo neo_curriculos
> db.currentOp()
# Find slow operation
> db.killOp(opid)
# Wait 30 seconds for CPU to drop
```

**Option 2: Restart MongoDB (if no single query)**
```bash
# Brief downtime: ~30 seconds
sudo systemctl restart mongod
# Or via K8s:
kubectl rollout restart statefulset neo-curriculos-mongodb
kubectl rollout status statefulset neo-curriculos-mongodb --timeout=300s
```

**Option 3: Failover to replica (if single node bottleneck)**
```bash
# Switch read traffic to replica
# No downtime
kubectl patch service neo-curriculos-db \
  -p '{"spec":{"selector":{"role":"replica"}}}'
```

### Recovery & Validation

```bash
# After mitigation
# 1. Check CPU dropped
watch -n 5 'top -b -n 1 | head -20'

# 2. Verify connectivity
mongo admin --eval "db.adminCommand('ping')"

# 3. Check replication lag
mongo admin --eval "rs.printSecondaryReplicationInfo()"

# 4. Verify no data loss
curl -s https://api.neocurriculos.com/health | jq .database
```

### Post-Incident

1. Post in #neo-curriculos-incidents:
   "Database CPU resolved at 14:35 UTC. Root cause: slow query on curriculos.search. Query optimized (add index). MTTR: 5 min."

2. Create Jira ticket:
   Title: "Optimize curriculos.search query - add index"
   Priority: Medium
   Assignee: Database team
```

### Alert: API Error Rate > 5%

```markdown
## RESPONSE PROCEDURE: High Error Rate

**Alert:** "HighErrorRate" (5%+)
**Severity:** CRITICAL
**SLA:** 15 minute response

### Investigation (< 10 min)

1. Check recent logs
```bash
kubectl logs -l app=neo-curriculos --tail=200 | grep ERROR | head -50
```

2. Common errors
```bash
# Connection errors
kubectl logs -l app=neo-curriculos | grep -i "connection\|timeout"

# Authentication errors
kubectl logs -l app=neo-curriculos | grep -i "auth\|unauthorized"

# Database errors
kubectl logs -l app=neo-curriculos | grep -i "mongodb\|database"
```

3. Check dependencies
```bash
# Database
curl -s http://neo-curriculos-db:27017/serverStatus
# Result should be JSON, not "connection refused"

# Cache
redis-cli ping
# Result should be PONG

# External APIs
curl -v https://external-api.com/health
```

4. Determine root cause
```
Most common causes (order by likelihood):
1. Database unreachable → Check DB server
2. Deployment issue → Check recent deploy
3. Rate limit triggered → Check IP blocklist
4. Cache issues → Check Redis
5. Bad code (regression) → Check git log
```

### Mitigation

**If Database Down:**
```bash
bash scripts/failover.sh neo-curriculos-db-primary
# Wait 15 seconds
# Check error rate dropped
```

**If Recent Deployment Caused It:**
```bash
bash scripts/rollback-production.sh --version v1.0.0
# Verify health
curl https://api.neocurriculos.com/health
```

**If Rate Limit:**
```bash
# Find blocking IP
curl -s https://api.neocurriculos.com/debug/rate-limit-top-ips
# Whitelist if legitimate
bash scripts/whitelist-ip.sh 203.0.113.1
```

### Validation

```bash
# Monitor error rate for 5 min
watch -n 5 'curl -s https://api.neocurriculos.com/metrics | grep error_rate'

# Should return to < 0.5%
```

### Alert: Disk Usage > 95%

```markdown
## RESPONSE PROCEDURE: Low Disk Space

**Alert:** "DiskSpaceHigh" (95%+)
**Severity:** CRITICAL (service will crash at 100%)

### Emergency Cleanup (< 5 min)

1. Find what's using space
```bash
du -sh /* | sort -rh | head -20
```

2. Delete old logs (usually 50-70% of disk)
```bash
# PRODUCTION: Be careful!
find /var/log -name "*.log" -type f -mtime +30 -delete
find /var/log -name "*.gz" -type f -delete
```

3. Clean Docker (5-10 GB often)
```bash
docker system prune -f
docker image prune -a -f
```

4. Verify space freed
```bash
df -h / | tail -1
# Should show > 20% available
```

### Permanent Fix

1. Expand EBS volume (AWS)
```bash
aws ec2 modify-volume --volume-id vol-xxxxx --size 200
# Wait 15 minutes for expansion
sudo resize2fs /dev/nvme0n1p1
```

2. Enable automatic cleanup
```bash
# Delete audit logs > 90 days
mongo neo_curriculos --eval "
  db.audit.deleteMany({
    timestamp: {\$lt: new Date(Date.now() - 90*24*60*60*1000)}
  })
"
```
```

---

## On-call Handoff

### Friday 5:00 PM UTC (Handoff Meeting)

**From:** Previous on-call  
**To:** Next on-call  
**Duration:** 15 minutes

### Handoff Checklist

```markdown
## On-call Handoff Template

**From:** [Previous Name]  
**To:** [Next Name]  
**Date:** Friday 17:00 UTC  

### System Status

- [ ] **API Health**: Healthy / Degraded / Down
  Status: ✅ Healthy
  Uptime: 99.98%
  Latency p99: 1.1s

- [ ] **Database**: Healthy / Issues
  Status: ✅ Healthy
  Connections: 45/100
  Last backup: 2 hours ago

- [ ] **Cache**: Healthy / Issues
  Status: ✅ Healthy
  Memory: 35%

- [ ] **Storage**: OK / Critical
  Status: ✅ OK (60% used)

### Recent Incidents

- None today
- Yesterday: Brief spike in error rate (0.8%) at 10:15 UTC
  Cause: Slow query (now optimized)

### Things to Watch

1. Database CPU trending up (avg 45%, peak 65%)
   - Added index yesterday, should improve
   - Monitor for next 48 hours

2. S3 storage increasing (now 800 GB)
   - Run cleanup job if > 1 TB
   - Script: bash scripts/cleanup-old-files.sh

### Contacts

**For help, contact:**
- Backend lead: +55 11 9XXXX-XXXX (non-urgent)
- CTO: +55 11 9XXXX-XXXX (critical only)
- Database admin: +55 11 9XXXX-XXXX (DB issues)

### Action Items

- Monitor: Database CPU next 24h
- Investigate: S3 storage growth
- Follow-up: Schedule post-mortem from yesterday

### Tools & Access Verified

- [ ] SSH access: working
- [ ] Database access: tested
- [ ] PagerDuty: acknowledged
- [ ] Slack channels: all joined

### Previous On-call Notes

"Hi @on-call-next, everything is stable. No issues to report. 
Just the normal monitoring. Have a quiet week! 👍"

### Sign-off

Handoff acknowledged: @on-call-next
Time: 17:05 UTC
Next handoff: Friday Sept 14 17:00 UTC
```

---

## Common Issues & Quick Fixes

### "API is slow (latency > 3s)"

```bash
# 1. Check database
mongo --eval "db.adminCommand('ping')"

# 2. Check if query is slow
db.system.profile.find({millis: {$gt: 1000}})

# 3. If specific query slow, add index
db.collection.createIndex({field: 1})

# 4. Check cache
redis-cli --stat

# 5. If still slow, consider scaling
kubectl scale deployment neo-curriculos-api --replicas=5
```

### "Login not working"

```bash
# Check auth service
curl https://api.neocurriculos.com/auth/health

# Check JWT secret rotation
env | grep JWT_KEY

# Reset JWT secret
bash scripts/rotate-secrets.sh --jwt-only
kubectl rollout restart deployment neo-curriculos-api
```

### "Users getting 502 Bad Gateway"

```bash
# Check if app is running
kubectl get pods -l app=neo-curriculos

# Check app logs
kubectl logs -l app=neo-curriculos | grep ERROR

# Restart if needed
kubectl rollout restart deployment neo-curriculos-api

# Verify health
curl https://api.neocurriculos.com/health
```

---

## Escalation Decision Tree

```
Problem detected
├─ Yes → Acknowledge alert (< 5 min)
│  ├─ Can I fix it?
│  │  ├─ Yes → Fix & monitor
│  │  └─ No → Escalate immediately
│  └─ Latency to diagnosis: < 10 min
│
└─ Critical + Can't fix in 15 min
   ├─ Call team lead: +55 11 9XXXX-XXXX
   ├─ Post #neo-curriculos-incidents: "Need backup, here's what I've tried"
   └─ Start war room call if needed
```

---

## Post-Incident Checklist

After resolving any incident:

```markdown
## Post-Incident Tasks (< 24 hours)

- [ ] Document what happened (timeline)
- [ ] Identify root cause
- [ ] Note quick fixes applied
- [ ] Create Jira tickets for prevention
- [ ] Schedule post-mortem (if critical)
- [ ] Update runbook if procedure changed
- [ ] Notify team in #neo-curriculos-incidents

Example ticket:
Title: "Add monitoring for [condition that caused issue]"
Priority: High
Assignee: On-call team
```

---

## Emergency Contacts

```
PRIMARY CONTACTS:
- On-call: +55 11 9XXXX-XXXX (SMS/Call)
- Team Lead: +55 11 9XXXX-XXXX
- CTO: +55 11 9XXXX-XXXX (Critical only)
- Database Admin: +55 11 9XXXX-XXXX
- AWS Support: AWS Console > Support

SLACK:
- #neo-curriculos-incidents (thread investigations)
- #neo-curriculos-prod-alerts (all alerts)
- #neo-curriculos-on-call (specific on-call channel)

TOOLS:
- PagerDuty: https://pagerduty.neocurriculos.com
- Grafana: https://grafana.neocurriculos.com
- Kibana: https://kibana.neocurriculos.com
```

---

## Summary

✅ **Response SLA:** 5-15 minutes (depends on severity)  
✅ **Escalation:** Automatic after 15 minutes of no progress  
✅ **Handoff:** Weekly, documented, 15 min meeting  
✅ **Training:** New on-calls shadow first week  
✅ **Post-incident:** Always document & improve
