---
type: checklist
status: ativa
---

# ✅ Security Audit Checklist

Use para auditar segurança de aplicação.

---

## 🔐 Autenticação

- [ ] Senhas são hasheadas (bcrypt, argon2)
- [ ] JWT tokens têm expiração
- [ ] Sessions têm timeout
- [ ] 2FA implementado (if critical)

---

## 🛡️ Autorização

- [ ] RBAC implementado
- [ ] Sem hardcoded permissions
- [ ] Sem privilege escalation vulnerabilities

---

## 🌐 Dados em Trânsito

- [ ] HTTPS habilitado
- [ ] SSL/TLS configurado
- [ ] CORS restritivo
- [ ] Headers de segurança (CSP, etc)

---

## 💾 Dados em Repouso

- [ ] Dados sensíveis encriptados
- [ ] Sem logs com dados sensíveis
- [ ] Backup encriptado

---

## 🔒 OWASP Top 10

- [ ] Injection protection
- [ ] Authentication robust
- [ ] XSS prevention
- [ ] Broken access control fixed
- [ ] Security misconfiguration fixed
- [ ] Sensitive data exposure fixed
- [ ] XML external entities fixed
- [ ] Insecure deserialization fixed
- [ ] Known vulnerabilities fixed
- [ ] Insufficient logging fixed

---

## 🚀 Deployment

- [ ] Secrets não no código
- [ ] .env não commitado
- [ ] Default credentials removidas

---
