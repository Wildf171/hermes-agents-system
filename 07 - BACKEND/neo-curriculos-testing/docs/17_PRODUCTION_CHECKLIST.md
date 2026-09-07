# 17 - PRODUCTION CHECKLIST

**Versão:** 1.0.0  
**Data:** 2026-09-07  
**Status:** ✓ Pronto para Revisão

---

## 📋 CHECKLIST PRÉ-DEPLOYMENT PRODUÇÃO

Checklist completo que deve ser verificado antes de fazer deploy para produção.

---

## 1️⃣ SEGURANÇA

### Credenciais & Secrets
- [ ] Nenhuma senha está hardcoded no código
  - `grep -r "password" . --include="*.py" | grep -v "password_hash"`
  - `grep -r "secret" . --include="*.py" | grep -v "config"`
- [ ] Todos os secrets estão em AWS Secrets Manager (ou Azure Key Vault)
  - JWT_SECRET_KEY
  - MONGO_URI (senha com usuário específico)
  - MINIO credentials
  - Database encryption keys
- [ ] Variáveis de ambiente não contêm valores sensíveis
- [ ] `.env` files são ignorados em `.gitignore`
- [ ] Nenhum token/API key nos logs

### Autenticação & Autorização
- [ ] JWT token expiration está configurado (24h para access, 30d para refresh)
- [ ] Refresh tokens são válidos
- [ ] Rate limiting está ativado (5 tentativas/15 min no login)
- [ ] CORS está configurado com whitelist específica (não `*`)
- [ ] Decoradores `@token_required` e `@role_required` estão em todos os endpoints sensíveis

### HTTPS & TLS
- [ ] HTTPS/TLS está ativado em produção
- [ ] Certificado SSL é válido (não auto-assinado)
- [ ] Certificado não expira nos próximos 30 dias
- [ ] HSTS header está configurado (`Strict-Transport-Security: max-age=31536000`)
- [ ] Redirect HTTP → HTTPS está ativado
- [ ] TLS 1.2+ apenas (sem SSL 3.0, TLS 1.0, 1.1)

### Segurança de Headers
- [ ] Content-Security-Policy header
- [ ] X-Frame-Options: DENY (ou SAMEORIGIN)
- [ ] X-Content-Type-Options: nosniff
- [ ] X-XSS-Protection: 1; mode=block
- [ ] Referrer-Policy: strict-origin-when-cross-origin

### Validação & Sanitização
- [ ] Input validation está implementado (Pydantic)
- [ ] SQL Injection prevention (prepared statements)
- [ ] NoSQL Injection prevention (sanitização de queries)
- [ ] XSS prevention (HTML escaping ou Content-Security-Policy)
- [ ] CSRF protection (se aplicável para formular)
- [ ] Path traversal prevention em uploads

### WAF (Web Application Firewall)
- [ ] WAF está ativado (AWS WAF, Cloudflare, etc)
- [ ] Regras OWASP Top 10 estão configuradas
- [ ] Rate limiting está ativado
- [ ] IP whitelisting/blacklisting configurado (se necessário)

### Criptografia
- [ ] Senhas são hasheadas com bcrypt (12 rounds minimum)
- [ ] Dados sensíveis em repouso estão criptografados (MongoDB encryption)
- [ ] Dados sensíveis em trânsito estão em TLS
- [ ] Chaves de criptografia são rotacionadas regularmente
- [ ] Backup keys estão seguros (não em mesmo servidor)

---

## 2️⃣ PERFORMANCE

### Database
- [ ] Índices MongoDB criados e testados
  - `db.usuarios.createIndex({"email": 1}, {unique: true})`
  - `db.curriculos.createIndex({"usuario_id": 1, "criado_em": -1})`
  - Índices de TTL para soft delete (30 dias)
  - Índices de TTL para retenção LGPD (7 anos)
- [ ] Connection pooling configurado (default: 50-100 connections)
- [ ] Read preference configurado (primary para escrita, secondary para leitura)
- [ ] Write concern configurado (majority para dados críticos)
- [ ] Database backups estão programados (diários)
- [ ] Restore from backup foi testado
- [ ] Database indexes foram analisados (sem query scans completos)

### Caching
- [ ] Redis/Memcached está configurado
- [ ] Cache keys têm TTL apropriado
- [ ] Cache invalidation está implementada
- [ ] Cache hit rate > 70% para endpoints críticos
- [ ] Cache não contém dados sensíveis

### Load Balancing
- [ ] Load balancer está configurado (nginx, AWS ELB, etc)
- [ ] Health check está configurado (timeout 5s, unhealthy após 2 falhas)
- [ ] Sticky sessions (se necessário) estão configuradas
- [ ] Connection draining está habilitado
- [ ] Multiple backend instances (minimum 3 em produção)

### Auto-Scaling
- [ ] Auto-scaling está configurado
  - Min instances: 3
  - Max instances: 10-20
  - Scale up trigger: CPU > 70% por 5 min
  - Scale down trigger: CPU < 30% por 10 min
- [ ] Scaling policies foram testadas

### CDN
- [ ] CDN está ativado (CloudFront, Cloudflare, etc)
- [ ] Tempo de cache apropriado para assets
- [ ] Invalidação manual de cache funciona

### Monitoring
- [ ] Prometheus/Datadog está coletando métricas
- [ ] Grafana dashboards estão criados
- [ ] Alertas estão configurados (Slack, PagerDuty, email)

---

## 3️⃣ COMPLIANCE & LGPD

### Consentimento
- [ ] Consentimento explícito é coletado antes de upload de CV
- [ ] Versão de termos é armazenada com consentimento
- [ ] Consentimento pode ser revogado
- [ ] Revogar consentimento bloqueia novos uploads

### Data Retention
- [ ] Dados são retidos por máximo 7 anos (LGPD Art. 15)
- [ ] TTL index MongoDB deleta dados automaticamente após 7 anos
- [ ] Soft delete é feito após 30 dias de deleção (GDPR style)
- [ ] Anonimização é executada após 30 dias de soft delete

### Direito ao Esquecimento
- [ ] Endpoint DELETE /api/candidatos/:id/deletar-conta funciona
- [ ] Hard delete é possível após período de retention
- [ ] Dados deletados não são recuperáveis
- [ ] Backup de dados deletados não contém dados pessoais

### Auditoria
- [ ] Todos os acessos a dados pessoais são auditados
- [ ] Auditoria é imutável (append-only)
- [ ] Auditoria é armazenada separadamente
- [ ] Auditoria pode ser exportada (para autoridades)
- [ ] Eventos auditados incluem: visualizar, download, compartilhar, deletar, anonimizar
- [ ] Cada evento inclui: quem, quando, de onde (IP), resultado

### Privacidade
- [ ] Dados pessoais são minimizados (coletar apenas necessário)
- [ ] Dados são pseudoanonimizados quando possível
- [ ] Terceiros que acessam dados têm contratos de DPA
- [ ] Data Processing Agreement com provedor de cloud

### Portabilidade
- [ ] Usuários conseguem exportar seus dados em formato legível
- [ ] Formato de exportação é open standard (JSON, CSV)
- [ ] Dados de auditoria também podem ser exportados

---

## 4️⃣ INFRAESTRUTURA

### Cloud
- [ ] Provedores de cloud estão selecionados (AWS, Azure, GCP)
- [ ] Regions e availability zones estão configurados
- [ ] Multi-region failover está implementado (se crítico)
- [ ] VPC/Network security está configurada
  - Security groups/NSGs com regras restritivas
  - Acesso ao DB apenas de app servers
  - NAT gateway para outbound traffic
- [ ] VPN ou direct connect para acesso administrativo

### Database
- [ ] MongoDB está em replica set (minimum 3 nodes)
- [ ] Automatic failover está ativado
- [ ] Backup é feito em diferente região/AZ
- [ ] Point-in-time recovery está configurado
- [ ] Encryption at rest está habilitado
- [ ] Encryption in transit (TLS) está ativado

### Storage
- [ ] S3/MinIO bucket tem versioning habilitado
- [ ] Server-side encryption (SSE-S3 ou SSE-KMS) está ativado
- [ ] Bucket policy permite apenas HTTPS
- [ ] Acesso público está bloqueado
- [ ] Lifecycle policy delete old versions (após 1 ano)
- [ ] MFA delete é obrigatório para deletar objects críticos
- [ ] Signed URLs têm expiração (1 hora para downloads)

### Logging & Monitoring
- [ ] Logs centralizados (CloudWatch, ELK, Datadog)
- [ ] Log retention: 90 dias (ou legal requirement)
- [ ] Logs não contêm dados sensíveis (PII, tokens, senhas)
- [ ] Log aggregation está configurada
- [ ] Search & alerting nos logs funciona
- [ ] Prometheus/Datadog coleta métricas

### Backup & Disaster Recovery
- [ ] Backup diário está programado
- [ ] Backup é armazenado em diferente região
- [ ] RPO (Recovery Point Objective): máximo 24 horas
- [ ] RTO (Recovery Time Objective): máximo 4 horas
- [ ] Restore from backup foi testado (monthly)
- [ ] Backup encryption está ativado
- [ ] Backup retenção por 7 anos (LGPD)

---

## 5️⃣ OPERACIONAL

### Deployment
- [ ] CI/CD pipeline está funcionando
- [ ] Automated tests rodam antes de deploy
- [ ] Code review é obrigatório (2 approvals)
- [ ] Deployment é automático (ou 1-click para produção)
- [ ] Blue-green deployment está implementado (zero downtime)
- [ ] Rollback automático está configurado

### Monitoring & Alerting
- [ ] Prometheus/Datadog está monitorando
- [ ] Alertas foram configurados
  - API Down
  - High latency (p95 > 2s)
  - High error rate (> 1%)
  - High CPU/Memory
  - Disk space < 10%
  - Database connection pool full
- [ ] Alertas vão para Slack, PagerDuty, email
- [ ] On-call rotation está definida (SRE team)
- [ ] Runbooks estão documentados

### Logging
- [ ] Logs estruturados (JSON format)
- [ ] Logging levels apropriados (INFO, WARN, ERROR)
- [ ] Logs não contêm dados sensíveis
- [ ] Logs estão centralizados (CloudWatch, ELK)
- [ ] Log search funciona
- [ ] Log alerts configurados para erros críticos

### Documentation
- [ ] Runbook para incidentes comuns
- [ ] Escalation procedures estão documentadas
- [ ] Architecture documentation existe
- [ ] API documentation (Swagger/OpenAPI) está completa
- [ ] Database schema documentation
- [ ] Deployment guide for new team members

### Maintenance
- [ ] Plano de manutenção preventiva
- [ ] Patches de segurança são aplicados em < 1 semana
- [ ] Dependency updates são testadas antes de produção
- [ ] Database maintenance (vacuuming, etc) está programada

---

## 6️⃣ TESTES

### Unit Tests
- [ ] Coverage > 70%
- [ ] Todos os testes passam
- [ ] Testes rodam em CI/CD
- [ ] Testes são executados rapidamente (< 5 min)

### Integration Tests
- [ ] Testes com banco de dados real
- [ ] Testes de migrations
- [ ] Testes de webhooks (se aplicável)

### E2E Tests
- [ ] Fluxo completo de usuário testado
- [ ] Autenticação até download de CV testado
- [ ] LGPD flow (consentimento, deletar) testado

### Security Tests
- [ ] OWASP Top 10 coberto
- [ ] Injection tests (SQL, NoSQL, XSS)
- [ ] Authentication & authorization testados
- [ ] Rate limiting testado

### Load Tests
- [ ] Baseline performance (100 usuários): < 200ms p95
- [ ] Load test (500 usuários): < 1% error rate
- [ ] Stress test (até quebrar): ponto de quebra identificado
- [ ] SLAs foram validados

### Smoke Tests
- [ ] Health check passa
- [ ] Endpoints principais respondem
- [ ] Database está online
- [ ] Storage está acessível
- [ ] Smoke tests rodam pós-deployment

---

## 7️⃣ CONFIGURAÇÃO

### Environment Variables
- [ ] Variáveis de ambiente estão documentadas
- [ ] Valores default são seguros (nunca um segredo)
- [ ] Staging & produção têm configs diferentes
- [ ] Variáveis críticas têm alerts se não definidas

### Secrets Management
- [ ] Secrets estão em AWS Secrets Manager
- [ ] Acesso a secrets é auditado (IAM logs)
- [ ] Rotation de secrets está automatizada
- [ ] Backup de secrets está seguro

### Feature Flags
- [ ] Feature flags estão implementadas
- [ ] Flags podem ser ligadas/desligadas sem deploy
- [ ] Flags podem ser ativadas por % de usuários (gradual rollout)

---

## 8️⃣ COMPLIANCE & LEGAL

### Terms & Privacy
- [ ] Termos de Serviço foram revisados por legal
- [ ] Privacy Policy está completa e publicada
- [ ] Política de retenção de dados está explícita
- [ ] Links legais estão acessíveis em landing page

### LGPD Específico
- [ ] LGPD terms foram aceitos por usuário
- [ ] Consentimento é gravado com timestamp
- [ ] Direito ao esquecimento pode ser exercido
- [ ] Portabilidade de dados está implementada
- [ ] Auditoria LGPD está completa
- [ ] DPA (Data Processing Agreement) com cloud provider
- [ ] Breach notification procedure está implementada

### Terceiros
- [ ] Todos os terceiros que acessam dados têm NDA
- [ ] Data Processing Agreements estão assinados
- [ ] Subcontratados (analytics, logging) são apropriados

---

## 9️⃣ COMUNICAÇÃO

### Status Page
- [ ] Status page está funcionando
- [ ] Status page mostra real-time availability
- [ ] Histórico de incidentes está visível

### Customer Communication
- [ ] Incidentes são comunicados aos clientes
- [ ] Postmortem é enviado após incidentes
- [ ] Security breaches são reportados (se houver)

---

## 🔟 FINANCEIRO & OPERACIONAL

### Costs
- [ ] Estimativa mensal de custos
- [ ] Budget foi aprovado
- [ ] Cost monitoring está ativado
- [ ] Cost optimization foi feita (reserved instances, spot, etc)

### SLAs
- [ ] SLA de disponibilidade está definido (99.9% ou 99.95%)
- [ ] SLA de latência está definido (p95 < 2s)
- [ ] SLA está em contrato com clientes
- [ ] SLA está sendo monitorado

### Escalabilidade
- [ ] Arquitetura consegue escalar horizontalmente
- [ ] Database consegue escalar (sharding, read replicas)
- [ ] Load balancer consegue distribuir carga
- [ ] Auto-scaling foi testado

---

## 11️⃣ VERIFICAÇÃO FINAL

### 24h Antes de Deploy
- [ ] Todos os itens acima foram checados
- [ ] Stakeholders foram notificados
- [ ] Runbooks foram revisados pela team
- [ ] On-call engineer confirmou disponibilidade

### 1h Antes de Deploy
- [ ] Último teste de smoke passou
- [ ] Rollback procedure está testado
- [ ] Database backup foi feito
- [ ] Team está pronto (Slack, Zoom, etc)

### Após Deploy
- [ ] Health checks passaram
- [ ] Metrics estão normais
- [ ] Usuários conseguem fazer login
- [ ] Smoke tests passaram em produção
- [ ] Postmortem será feito em 24h (mesmo que sucesso)

---

## ✅ SIGN OFF

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Tech Lead | _______ | _______ | _______ |
| Security | _______ | _______ | _______ |
| Operations | _______ | _______ | _______ |
| Manager | _______ | _______ | _______ |

---

## 📝 NOTAS & OBSERVAÇÕES

```
_________________________________________________________________

_________________________________________________________________

_________________________________________________________________
```

---

## 📚 REFERÊNCIAS

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [LGPD Lei 13.709](http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709.htm)
- [CIS AWS Foundations Benchmark](https://www.cisecurity.org/)
- [12 Factor App](https://12factor.net/)
- [Reliability Engineering (SRE)](https://sre.google/)

---

**Status Geral:** 🔴 ⭕ 🟢 (Vermelho/Amarelo/Verde)

**Pronto para Produção?** [ ] SIM [ ] NÃO

**Data de Aprovação:** _____________

**Realizado por:** _____________

---

*Última atualização: 2026-09-07*
