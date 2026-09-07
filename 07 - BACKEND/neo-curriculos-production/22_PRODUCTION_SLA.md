# 22 - PRODUCTION_SLA.md
## Service Level Agreement (SLA) - Neo Currículos + Neo RH System

**Data:** Setembro 2026  
**Versão:** 1.0.0  
**Efetivo:** Setembro 2026 onwards

---

## 1. SLA Commitments

### Uptime Guarantee

```yaml
Target Uptime: 99.95%
Calculation: (Total Seconds - Downtime Seconds) / Total Seconds
Measurement Period: Calendar month (rolling window)
Exclusions:
  ├─ Planned maintenance (max 1 hour/month, Sunday 02:00-03:00 UTC)
  ├─ Customer-caused outages (rate limit exceeded, bad config)
  ├─ Third-party services (AWS, CDN, external APIs)
  └─ Force majeure (natural disasters, war, etc)

Uptime Tiers:
├─ 99.95% (standard)
├─ 99.9% (best effort)
└─ 99.5% (during beta)
```

### Performance Guarantees

```yaml
API Response Time (p99):
  ├─ Target: < 2 seconds
  ├─ Measured: Continuously via Prometheus
  └─ Grace period: 5 minutes before alert

Database Query Time (p99):
  ├─ Target: < 100 milliseconds
  ├─ Monitored: All queries > 50ms logged
  └─ Alert: > 500ms

Page Load Time:
  ├─ Target: < 3 seconds
  ├─ Measured: RUM (Real User Monitoring)
  └─ Includes: Static assets, API calls, rendering

Throughput:
  ├─ Target: > 100 requests/second
  ├─ Peak capacity: 500 req/sec (before degradation)
  └─ Auto-scaling: Activates at 70% capacity
```

### Support Commitments

```yaml
Support Levels:

🔴 CRITICAL (System Down):
  ├─ Response Time: 15 minutes
  ├─ Resolution Target: 1 hour
  ├─ Escalation: Immediate to VP Eng
  └─ Contact: SMS + Call + Email

🟠 HIGH (Service Degradation):
  ├─ Response Time: 1 hour
  ├─ Resolution Target: 4 hours
  ├─ Escalation: Team lead within 30 min
  └─ Contact: Slack + Email

🟡 MEDIUM (Feature not working):
  ├─ Response Time: 4 hours
  ├─ Resolution Target: 24 hours
  ├─ Escalation: Team lead if unresolved
  └─ Contact: Slack + Email

🟢 LOW (Enhancement request):
  ├─ Response Time: 24 hours
  ├─ Resolution Target: Backlog
  ├─ Escalation: None
  └─ Contact: Email only
```

---

## 2. LGPD & Data Protection Commitments

### Data Retention

```yaml
User Data:
  ├─ Active accounts: Retained as long as active
  ├─ Inactive accounts (> 2 years): Archived (S3 Glacier)
  ├─ Soft-deleted accounts: 30 days grace period, then purged
  └─ LGPD right to be forgotten: Executed within 30 days

Audit Logs:
  ├─ Retention: 7 years (tax/legal requirement)
  ├─ Storage: S3 Glacier (low cost, high security)
  └─ Access: Restricted to compliance team only

Backup Data:
  ├─ Full backups: 7 years
  ├─ Incremental: 90 days
  └─ Testing: Restore validated monthly
```

### Data Protection

```yaml
Encryption:
  ├─ In Transit: TLS 1.3 (all connections)
  ├─ At Rest: AES-256 (database & storage)
  └─ Keys: Rotated quarterly, stored in AWS Secrets Manager

Access Control:
  ├─ Authentication: OAuth 2.0 + JWT
  ├─ Authorization: Role-based (RBAC)
  └─ MFA: Required for admin accounts

Breach Notification:
  ├─ Detection: < 1 hour
  ├─ Investigation: < 24 hours
  ├─ Notification (if required): < 72 hours (LGPD law)
  └─ Post-mortem: Within 5 business days
```

### Compliance

```yaml
Standards Compliance:

LGPD (Lei Geral de Proteção de Dados):
  ├─ Consent: Explicit opt-in
  ├─ Transparency: Privacy policy updated
  ├─ Right to access: API endpoint available
  ├─ Right to erasure: 30-day grace period
  └─ Data processing: Signed DPA (Data Processing Agreement)

GDPR (if EU data):
  ├─ GDPR compliance: Same as LGPD + extras
  ├─ Data residency: EU-only (if requested)
  └─ Sub-processors: All approved & audited

ISO 27001 (Security):
  ├─ Target: Certification Q4 2026
  ├─ Controls: Information security policy
  └─ Audits: Annual third-party audit

SOC 2 Type II (if needed):
  ├─ Timeline: Q1 2027
  └─ Focus: Security, availability, processing integrity
```

---

## 3. Service Remedies (Credit Policy)

### Uptime-Based Credits

```yaml
Monthly Uptime Achievement | Service Credit to Customer
---|---
99.95% - 99.5% | 10% of monthly subscription
99.5% - 99.0% | 25% of monthly subscription
99.0% - 95.0% | 50% of monthly subscription
< 95.0% | 100% of monthly subscription

Example:
  If uptime = 98% (0.95% below target)
  And monthly fee = R$ 5,000
  Credit = 25% × R$ 5,000 = R$ 1,250

Maximum credit: 100% of monthly subscription
Credits carry forward 1 month if unused
```

### Performance-Based Credits

```yaml
P99 Latency Achievement | Latency-Based Credit
---|---
< 2s | No credit
2s - 5s | 5% credit
5s - 10s | 10% credit
> 10s | 25% credit

Error Rate Achievement | Error-Rate Credit
---|---
< 0.5% | No credit
0.5% - 1% | 5% credit
1% - 5% | 10% credit
> 5% | 25% credit
```

### Claiming Credits

```
1. Report incident in support ticket
2. We validate within 5 business days
3. Credit issued to next month's invoice
4. Automatic if metrics prove qualification
5. No need to request (automatic crediting)
```

---

## 4. Maintenance Windows

### Planned Maintenance

```yaml
Frequency: 1 window per month (max)
Duration: 1 hour
Schedule: Sunday 02:00-03:00 UTC (low traffic)

Announcement:
  ├─ 14 days prior: Email notification
  ├─ 7 days prior: In-app notification
  ├─ 24 hours prior: Slack announcement
  ├─ During: Real-time status page updates
  └─ After: Post-mortem if issues encountered

Types:
  ├─ Database maintenance (indices, cleanup)
  ├─ Security patching (OS, libraries)
  ├─ Infrastructure upgrades
  └─ Major feature deployments (if needed)
```

### Emergency Maintenance

```yaml
Unplanned Maintenance (Security Patches):
  ├─ Announcement: ASAP (in-app + email)
  ├─ Duration: Typically 15-30 minutes
  ├─ Target: Minimal, high-severity only
  └─ Example: Critical security vulnerability discovered

Note: Emergency maintenance NOT counted against SLA
```

---

## 5. Exclusions & Limitations

### Explicitly Excluded from SLA

```yaml
1. Customer-Caused Outages:
   ├─ Exceeded rate limits
   ├─ Bad input causing 5XX errors
   ├─ Misconfigured API keys
   └─ Abuse/attack from customer's account

2. Third-Party Failures:
   ├─ AWS infrastructure outage
   ├─ CloudFront CDN failure
   ├─ External payment processor down
   └─ Internet connectivity issues

3. Force Majeure:
   ├─ Natural disasters
   ├─ War or terrorism
   ├─ Pandemics or epidemics
   └─ Extreme weather events

4. Planned Maintenance:
   ├─ Announced 14+ days in advance
   ├─ Limited to 1 hour/month
   └─ Scheduled during low-traffic window
```

### Service Limitations

```yaml
No SLA for Beta Features:
  ├─ Marked "Beta" in documentation
  ├─ Uptime: Best effort only
  ├─ No credits for beta outages
  └─ Subject to change without notice

Free/Trial Accounts:
  ├─ Best effort support only
  ├─ No SLA guarantees
  └─ May be deprioritized during incidents
```

---

## 6. Monitoring & Reporting

### Real-time Status Page

```
Status: https://status.neocurriculos.com

Components Monitored:
├─ API (neo-curriculos-api.com)
├─ Web App (app.neocurriculos.com)
├─ Mobile Apps (iOS + Android)
├─ Database (availability only)
├─ Authentication
└─ File Storage

Status Indicators:
├─ 🟢 Operational: 99%+ uptime
├─ 🟡 Degraded Performance: 95-99% uptime
├─ 🟠 Partial Outage: some users affected
└─ 🔴 Major Outage: system down
```

### Monthly SLA Report

```
Sent to all customers: First day of month

Example Report:
─────────────────────
September 2025 SLA Report
─────────────────────

Uptime: 99.97% ✅ (Target: 99.95%)
API Latency p99: 1.2s ✅ (Target: < 2s)
Error Rate: 0.08% ✅ (Target: < 0.5%)
Incidents: 0 🎉
Downtime: 0 minutes

Performance Metrics:
  - Peak throughput: 285 req/sec
  - Average latency: 0.8s
  - Database connections: avg 45, peak 87
  - Storage growth: +50 GB

Maintenance:
  - Scheduled: 0 (No maintenance this month)
  - Emergency: 0 (No emergency patches)

Credits: None (SLA exceeded target)

Next Month Forecast:
  - Database indices optimization
  - Security hardening (planned)
```

---

## 7. Customer Responsibilities

### For SLA to Apply, Customers Must:

```yaml
1. Use the service as documented
   ├─ Follow API guidelines
   ├─ Respect rate limits
   └─ Use valid credentials

2. Maintain account security
   ├─ Protect API keys
   ├─ Use strong passwords
   ├─ Enable MFA if available
   └─ Report compromised accounts immediately

3. Provide accurate contact info
   ├─ For support notifications
   ├─ For billing inquiries
   └─ For security alerts

4. Comply with ToS & policies
   ├─ Acceptable Use Policy
   ├─ LGPD requirements
   └─ Data protection standards
```

---

## 8. Escalation & Disputes

### SLA Dispute Process

```
1. Customer identifies SLA miss
2. Opens support ticket with evidence
3. Engineering team investigates (< 5 days)
4. Determination made (justify deny or credit)
5. Credit issued if validated (next invoice)

Dispute Timeline:
├─ Report deadline: Within 30 days of incident
├─ Investigation: 5 business days
├─ Decision: 10 business days
└─ Remediation: Next billing cycle
```

### SLA Review & Updates

```yaml
SLA Review Cycle: Quarterly
├─ Review actual metrics vs targets
├─ Adjust targets if needed
├─ Customer feedback considered
└─ Updated terms posted 30 days before change

Changes Require:
├─ Board approval (if stricter)
├─ 30-day notice (if loosened)
└─ Customer agreement (if substantial)
```

---

## 9. Contact & Support

### Support Channels

```
Email: support@neocurriculos.com (all levels)
Slack: For customers with Slack integration
Chat: In-app chat (business hours only)
Phone: +55 11 3XXX-XXXX (critical only, 24/7)

Response Times:
├─ Email: 4 hours (business hours)
├─ Slack: 1 hour (business hours)
├─ Chat: 15 minutes (9-17 UTC, Mon-Fri)
└─ Phone: < 15 min (critical, 24/7)
```

### SLA Contact

```
Questions about SLA?
├─ Email: sla@neocurriculos.com
├─ Support: support@neocurriculos.com
└─ Escalation: sre-team@neocurriculos.com

SLA Document:
├─ Full version: https://neocurriculos.com/sla
├─ PDF: https://neocurriculos.com/sla.pdf
└─ Last updated: September 1, 2026
```

---

## Summary

✅ **99.95% Uptime Guarantee** (4 hours downtime per year)  
✅ **< 2s API Latency** (p99)  
✅ **< 0.5% Error Rate**  
✅ **LGPD Compliant** (right to erasure, data protection)  
✅ **Automatic Credits** (no need to request)  
✅ **24/7 Support** (critical incidents)  
✅ **Monthly SLA Reports** (transparency)  
✅ **Real-time Status Page** (public monitoring)
