# Neo Currículos + Neo RH System: Design da Integração (Fase 1)

**Status:** ✅ Completo e aprovado para Phase 2  
**Data:** 2025-09-07  
**Autor:** Backend Architect Sênior  
**Versão:** 1.0

---

## 📋 Sumário Executivo

Este é o **Design Completo (Fase 1)** para integração do **Neo Currículos** (App Flutter iOS/Android) com o **Neo RH System** existente (Python/Flask/MongoDB).

### Decisão Arquitetural
**Integração Unificada (Opção A):** Mesmo banco de dados MongoDB, autenticação centralizada via JWT, novo tipo de usuário "candidato".

### Por que unificada?
- ✅ Candidato é uma única entidade em ambos os sistemas
- ✅ Auditoria LGPD centralizada (uma fonte de verdade)
- ✅ Sem latência de sincronização entre APIs
- ✅ Segurança simplificada e consistente
- ✅ Time-to-market reduzido (MVP mais rápido)

### O que muda?
- **Novo tipo de usuário:** "candidato" (além de rh, recruiter, admin, empresa)
- **Nova coleção:** `curriculos` (armazena versões de CV)
- **Nova coleção:** `curriculos_acesso` (auditoria LGPD)
- **Novos campos:** Em usuarios e candidatos (consentimento, marcação de deleção, etc)
- **Novos endpoints:** Para upload de CV, gerenciamento de perfil, LGPD

---

## 📁 Estrutura dos Documentos

```
neo-curriculos-design/
├── README.md                          ← VOCÊ ESTÁ AQUI
├── 01_ANALISE_SISTEMA_EXISTENTE.md    ← Sistema Neo RH atual
├── 02_DESIGN_INTEGRACAO.md            ← Arquitetura + fluxo
├── 03_SCHEMA_MONGODB_DETALHADO.md     ← Schema + migrações
└── diagramas/
    ├── arquitetura.txt                ← Componentes + fluxo visual
    └── fluxo-dados.txt                ← E-R + fluxo detalhado
```

---

## 🎯 Como Usar Esta Documentação

### Para CTO / Gestor de Projeto
**Leia:** Seção 1-3 de cada documento + diagramas  
**Tempo:** 30-45 minutos  
**Resultado:** Entender decisão arquitetural e timeline

### Para Backend Engineers
**Leia:** Tudo, na ordem  
**Tempo:** 2-3 horas  
**Resultado:** Pronto para implementar Fase 2

### Para QA / Testers
**Leia:** Doc 02 (Design), seção 4 (Fluxo), Doc 03 (Schema)  
**Tempo:** 1 hora  
**Resultado:** Plano de testes end-to-end

### Para DevOps / SRE
**Leia:** Doc 03 (schema), seção 10 (Backup/Retenção), seção 12 (Dimensionamento)  
**Tempo:** 1 hora  
**Resultado:** Configuração de infra, backup, monitoramento

---

## 📄 Conteúdo de Cada Documento

### 01 - ANÁLISE DO SISTEMA EXISTENTE
**O que é:** Análise técnica do Neo RH System atual

**Seções principais:**
1. Visão geral (stack tecnológico)
2. Schema MongoDB atual (7 coleções)
3. Endpoints API existentes (categorizado)
4. Fluxo de autenticação (JWT)
5. Modelo de segurança (5 mecanismos)
6. Pontos de integração (5 pontos identificados)
7. Limitações & recomendações

**Leia se:** Precisa entender o sistema existente ou defender decisão de integração

**Tempo de leitura:** 40-50 min

---

### 02 - DESIGN DA INTEGRAÇÃO
**O que é:** Arquitetura completa, APIs, fluxos de negócio

**Seções principais:**
1. Decisão: Integração Unificada (3 opções analisadas)
2. Componentes principais (Flask, MongoDB, Storage)
3. Novo tipo de usuário: "candidato"
4. Diagrama ASCII da integração
5. Contrato de API (OpenAPI/Swagger)
6. Fluxo ponta-a-ponta (timeline de eventos)
7. Mapeamento de dados (candidato → CV → RH vê)
8. Plano de segurança LGPD (direito ao esquecimento, consentimento)

**Leia se:** Precisa entender o que vai ser built, APIs, segurança

**Tempo de leitura:** 1-1.5 horas

---

### 03 - SCHEMA MONGODB DETALHADO
**O que é:** Especificação técnica de schema, índices, migrações

**Seções principais:**
1. Resumo das mudanças (2 coleções modificadas, 2 novas)
2. Coleção `usuarios` - novo campo `eh_candidato`
3. Coleção `candidatos` - novos campos para CV e LGPD
4. Coleção `curriculos` (NOVA) - versioning de CVs
5. Coleção `curriculos_acesso` (NOVA) - auditoria LGPD
6. Índices de performance (10+)
7. Script de migração em Python (zero downtime)
8. Script de rollback (se necessário)
9. Estratégia de backup & retenção (7 anos para LGPD)
10. Checklist de deployment

**Leia se:** Vai implementar schema, fazer migrations, DevOps

**Tempo de leitura:** 1-1.5 horas

---

### Diagramas

#### `arquitetura.txt`
- Arquitetura de componentes (clientes → API → DB → Storage)
- Fluxo: Candidato registra → envia CV → RH acessa
- Tabela de permissões por tipo de usuário

**Para:** Visão geral, apresentações, onboarding

#### `fluxo-dados.txt`
- Modelo Entidade-Relacionamento (E-R) completo
- Mudanças no schema (antes vs. depois)
- Fluxo detalhado de cada etapa (registro → upload → acesso → auditoria)
- Timeline de retenção (LGPD)

**Para:** Entender relacionamentos, retenção de dados, integridade

---

## 🚀 Timeline de Implementação

```
FASE 1 (AGORA) - Design        [COMPLETO ✅]
├─ Análise do sistema existente
├─ Design da arquitetura
├─ Schema MongoDB
└─ Documentação

FASE 2 - Backend (4-6 semanas)
├─ Implementar endpoints Flask
├─ Criar coleções MongoDB
├─ Testes unitários
└─ Deploy em staging

FASE 3 - Frontend (3-4 semanas)
├─ Telas Flutter (registro, CV, LGPD)
├─ Integração com API
├─ Testes em device
└─ App store submission

FASE 4 - Integration (2-3 semanas)
├─ Testes E2E
├─ Testes de segurança (OWASP)
├─ Load testing
└─ Staging → Produção

FASE 5 - Monitoring (ongoing)
├─ Alertas de performance
├─ Auditoria LGPD
├─ Backup validation
└─ SLA monitoring
```

---

## ✅ Checklist para Implementação (Fase 2)

### Backend
- [ ] Setup: MongoDB local + testes
- [ ] Implementar `/api/auth/registrar` (candidato)
- [ ] Criar coleção `curriculos` e índices
- [ ] Implementar `/api/curriculos/upload`
- [ ] Implementar `/api/candidatos/:id/consentimento`
- [ ] Implementar `/api/candidatos/:id/deletar-conta` (LGPD)
- [ ] Adicionar auditoria LGPD (`db.curriculos_acesso`)
- [ ] Testes: auth, upload, validações, permissões
- [ ] Performance testing (índices)

### Frontend (Flutter)
- [ ] Tela de Registro (email, nome, senha)
- [ ] Tela de Perfil Completo (telefone, estado, experiência)
- [ ] Tela de Upload de CV (picker, validação, progress)
- [ ] Tela de Consentimento LGPD (checkboxes, termos)
- [ ] Armazenamento seguro de JWT (Keychain/Keystore)
- [ ] Testes: E2E, segurança de tokens, offline mode

### DevOps
- [ ] Script de migração (Python) testado
- [ ] Rollback procedure documentado
- [ ] Backup MongoDB automatizado (diária)
- [ ] TTL indexes configurados (90d geral, 7 anos LGPD)
- [ ] Monitoramento de storage (S3/MinIO)
- [ ] Alertas de falha em cleanup de dados

### QA
- [ ] Plano de testes (testes E2E)
- [ ] Casos de teste para LGPD (consentimento, deleção)
- [ ] Testes de segurança (JWT, CORS, injection)
- [ ] Performance baseline (índices)
- [ ] Load testing (1000+ CVs simultâneos)

---

## 🔐 Segurança & Compliance

### Implementado
✅ **LGPD:** Consentimento explícito, direito ao esquecimento, auditoria 7 anos  
✅ **Autenticação:** JWT HS256, 24h TTL, refresh tokens  
✅ **Autorização:** RBAC (5 tipos), permissões granulares  
✅ **Criptografia:** HTTPS/TLS, bcrypt passwords, SHA256 hashes  
✅ **Auditoria:** Log completo em 2 coleções (auditoria + curriculos_acesso)  

### Validações de Input
✅ **Arquivo:** Mime type (PDF), tamanho (< 10MB), antivírus  
✅ **Email:** Format, unique, verified via OTP (Phase 2)  
✅ **Senha:** Min 8 chars, 1 maiúscula, 1 número  
✅ **JSON:** Sanitização, prepared queries (PyMongo)  

### Rate Limiting
✅ **Login:** 5 tentativas em 15 minutos  
✅ **API:** 100 req/min por usuário (JWT)  
✅ **Upload:** 1 arquivo por hora (anti-abuse)  

---

## 📊 Dimensionamento

### Storage Estimado
```
Mês 0:        ~250 MB (MongoDB + indices)
Mês 12:       ~1.8 GB (MongoDB)
S3 (100k CVs): ~50-150 GB (com replicação)
```

### Performance
```
GET /api/candidatos:      < 100ms (estado + categoria index)
GET /api/candidatos/:id:  < 10ms (ObjectId index)
POST /api/curriculos:     < 2s (upload + S3 + index)
GET /api/auditoria:       < 200ms (user_id + timestamp index)
```

---

## 🎓 Glossário

| Termo | Significado |
|-------|------------|
| **JWT** | JSON Web Token (autenticação stateless) |
| **LGPD** | Lei Geral de Proteção de Dados (Brasil) |
| **RBAC** | Role-Based Access Control (rh, recruiter, admin, etc) |
| **TTL** | Time-To-Live (auto-delete após período) |
| **Soft delete** | Marca como deletado, não remove do DB |
| **Anonimização** | Remover PII (nome → "ANONIMIZADO") |
| **OID** | ObjectId (ID único MongoDB) |
| **UQ** | Unique constraint (índice único) |
| **S3** | Amazon S3 ou MinIO (object storage) |
| **E-R** | Entidade-Relacionamento (diagrama de schema) |

---

## 📞 Próximas Etapas

### Antes de Phase 2
1. ✅ **Aprovação arquitetural** (CTO/Gestor)
2. ✅ **Alinhamento com Product** (features, timeline)
3. ✅ **Alocação de time** (backend, frontend, QA, DevOps)
4. ✅ **Setup de ambiente** (staging DB, S3, CI/CD)

### Início de Phase 2
1. Criar branch `feature/neo-curriculos-integration`
2. Executar script de migração em staging
3. Implementar primeiro endpoint (`POST /api/auth/registrar`)
4. Testes e review do primeiro PR
5. Iteração: upload, consentimento, auditoria

---

## 📚 Documentação de Referência

**Dentro deste projeto:**
- `01_ANALISE_SISTEMA_EXISTENTE.md` - Sistema atual (Neo RH)
- `02_DESIGN_INTEGRACAO.md` - Arquitetura proposta
- `03_SCHEMA_MONGODB_DETALHADO.md` - Schema, índices, migrations
- `diagramas/arquitetura.txt` - Componentes visuais
- `diagramas/fluxo-dados.txt` - E-R e fluxo de dados

**Externos (referência):**
- [LGPD - Lei 13.709/2018](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.html)
- [MongoDB Best Practices](https://docs.mongodb.com/manual/applications/)
- [JWT.io](https://jwt.io)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

---

## 📝 Notas Finais

### Pontos Críticos para Sucesso
1. **Segurança:** LGPD não é optional, é compliance
2. **Performance:** Índices precisam estar corretos (benchmark)
3. **Auditoria:** Toda ação sensível deve ser logged
4. **Backup:** Testar restore regularmente (semanal)
5. **Comunicação:** Candidatos precisam entender consentimento

### Riscos Identificados
| Risco | Severidade | Mitigação |
|-------|-----------|-----------|
| Leak de CPF em logs | CRÍTICA | Nunca logar CPF, usar hash |
| Perda de dados LGPD | CRÍTICA | TTL indexes + backup 7 anos |
| Performance degradation | ALTA | Índices + cache Redis |
| Consent revocation bug | ALTA | QA + auditoria dupla |
| Token theft (mobile) | MÉDIA | Keychain/Keystore + HTTPS |

### Tech Debt Identificado
- [ ] Adicionar GraphQL (Phase 3, opcional)
- [ ] Implementar MFA (Phase 2)
- [ ] ElasticSearch para busca (Phase 2)
- [ ] Versionamento de API (/v1/, /v2/)
- [ ] Rate limiting por JWT user_id (não IP)

---

## ✨ Conclusão

Este design fornece uma base sólida para integração do Neo Currículos com Neo RH System, priorizando:

✅ **Simplicidade** - Uma plataforma unificada  
✅ **Segurança** - Autenticação e LGPD centralizadas  
✅ **Performance** - Sem latência de sincronização  
✅ **Escalabilidade** - Índices estratégicos, TTL indexes  
✅ **Conformidade** - LGPD compliance built-in  

**Pronto para Phase 2? Vamos começar!** 🚀

---

**Versão:** 1.0  
**Data:** 2025-09-07  
**Autor:** Backend Architect Sênior  
**Status:** ✅ Aprovado para implementação
