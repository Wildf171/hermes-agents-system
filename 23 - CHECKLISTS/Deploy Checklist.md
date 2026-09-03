---
type: checklist
status: ativa
created: 2026-09-03
updated: 2026-09-03
---

# ✅ Deploy Checklist

Use antes de fazer deploy em produção.

**Tempo**: ~30 minutos

---

## 📋 Preparação

- [ ] Código está no branch certo (main/master)
- [ ] Todos os testes passam (`pytest` ou `npm test`)
- [ ] Sem commits ainda unmerged
- [ ] Git status está limpo (`git status`)
- [ ] Versão foi atualizada (if applicable)

---

## 🔍 Verificação

- [ ] Enviroment variables estão corretos
- [ ] Database migrations estão preparadas
- [ ] Logs estão configurados
- [ ] Monitoring/alertas estão prontos
- [ ] Rollback plan está documentado

---

## 🚀 Deploy

- [ ] Backup do banco feito
- [ ] Deploy em staging primeiro (if applicable)
- [ ] Testes de smoke em staging
- [ ] Deploy em produção
- [ ] Verificar se aplicação está up
- [ ] Verificar logs para erros
- [ ] Testar fluxo crítico

---

## ✅ Verificação Pós-Deploy

- [ ] Aplicação responde (curl/browser)
- [ ] Database está acessível
- [ ] APIs estão funcionando
- [ ] Dados não foram corrompidos
- [ ] Performance está aceitável
- [ ] Sem erros críticos nos logs
- [ ] Monitoring mostra status verde

---

## 📞 Comunicação

- [ ] Time notificado sobre deploy
- [ ] Usuários notificados (se necessário)
- [ ] Documentação atualizada
- [ ] Release notes publicadas

---

**Próxima revisão**: Sempre antes de deploy
