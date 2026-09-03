---
type: projeto
status: produção
stack: [9 Agents Especializados, Python, Claude]
priority: crítico
created: 2026-09-03
updated: 2026-09-03
---

# 🤖 Hermes Agents — 9 Agents Especializados

**Status**: ✅ Completo  
**Localização**: `~/.hermes/specializations/`  
**Última atualização**: 2026-09-03

---

## 📋 Visão Geral

Sistema de **9 agents especializados** para desenvolvimento de software com:
- ✅ 54+ padrões documentados
- ✅ 100+ exemplos de código
- ✅ 13 módulos de treinamento (CODE_TRAINING)
- ✅ 9 aulas de conhecimento (KNOWLEDGE_BASE)
- ✅ Knowledge base integrado em cada agent

---

## 🤖 Os 9 Agents

### 1. **@frontend** — React, HTML, CSS, Bootstrap, Tailwind
- Componentes React com Hooks
- HTML semântico + ARIA (acessibilidade WCAG)
- CSS responsivo + SCSS
- Bootstrap 5 + Tailwind
- Testes com React Testing Library

**Use para**: Desenvolvimento frontend, componentes React, CSS

---

### 2. **@backend** — Node.js, Express, SQL, MongoDB, Redis
- REST APIs com Express
- Repository Pattern
- Service layer com lógica
- SQL: migrations, transactions, pooling
- MongoDB: agregações, sharding
- Redis: caching, TTL, cache invalidation

**Use para**: Desenvolvimento backend, APIs, databases

---

### 3. **@java** — Spring Boot, JPA, JUnit, Mockito
- @Entity relationships
- @Repository interfaces
- @Service transactions
- @RestController endpoints
- Global exception handlers
- JUnit 5 + Mockito testing

**Use para**: Desenvolvimento Java/Spring Boot

---

### 4. **@javascript** — Node.js, ES2022+, Async
- Async/await patterns
- Promise optimization
- Custom error classes
- Retry logic com exponential backoff
- Streams para grandes dados
- Worker threads

**Use para**: JavaScript avançado, async patterns

---

### 5. **@typescript** — Generics, Tipos Avançados
- Generic repositories
- Constrained generics
- Utility types (Partial, Pick, Omit, Record)
- Discriminated unions
- Type guards
- Conditional types

**Use para**: TypeScript avançado, tipos complexos

---

### 6. **@django** — Django 4.x, DRF, ORM
- Models com relationships
- QuerySet optimization (select_related, prefetch_related)
- DRF serializers
- ViewSets
- Signals
- APITestCase patterns

**Use para**: Desenvolvimento Django, DRF

---

### 7. **@postgresql** — Query Optimization, Indexes
- EXPLAIN ANALYZE
- Index strategies (B-tree, GIN, GiST, BRIN, partial)
- Window functions
- CTEs (including recursive)
- VACUUM/ANALYZE maintenance

**Use para**: Otimização PostgreSQL, performance

---

### 8. **@nosql** — MongoDB Advanced
- Document design patterns (embedded vs reference)
- Aggregation pipelines
- Sharding configuration
- Replica sets
- Multi-document transactions
- Change streams
- Index types including TTL

**Use para**: MongoDB avançado, NoSQL patterns

---

### 9. **@chartjs** — Chart.js, Recharts, D3.js
- Chart.js: line/bar/pie/scatter/bubble
- React com Recharts
- D3.js sunburst diagrams
- Responsive dashboards
- Accessibility (ARIA labels)
- Export/download functionality

**Use para**: Visualização de dados, gráficos

---

## 📚 Documentação

### CODE_TRAINING.md (13 Módulos)
1. SOLID & Design Patterns
2. Node.js/Express Patterns
3. Java/Spring Boot Patterns
4. REST API Design
5. Frontend - React Patterns
6. Frontend - HTML Semântico
7. Frontend - CSS Responsivo
8. Frontend - Bootstrap Integration
9. Backend - Repository Pattern
10. Backend - SQL Patterns
11. Backend - MongoDB Patterns
12. Backend - Caching Patterns
13. Testing & DevOps

### KNOWLEDGE_BASE.md (9 Aulas)
**MongoDB** (7 aulas):
1. Introdução ao MongoDB
2. Conceitos Intermediários
3. CRUD Operations
4. Queries Avançadas
5. Schema Validation
6. Agregação
7. Production (Replication/Sharding)

**SQL** (2 aulas):
1. CRUD + ALTER TABLE
2. Operadores WHERE

---

## 📊 Estatísticas

| Métrica | Valor |
|---------|-------|
| Agents | 9 |
| Padrões | 54+ |
| Exemplos | 100+ |
| Módulos | 13 |
| Aulas | 9 |
| Linhas | 2,600+ |
| Links internos | 30+ |
| Tags | 15+ |

---

## 🎯 Como Usar

```bash
# Usar um agent
hermes chat -q "@frontend Cree componente React" --oneshot

# Estudar pattern
hermes chat -q "@postgresql Explain window functions" --oneshot

# Múltiplos agents
hermes chat -q "@backend Crie API REST em Express" --oneshot
```

---

## 📁 Estrutura

```
~/.hermes/specializations/
├── frontend-complete.md
├── backend-database-patterns.md
├── java-spring-boot-patterns.md
├── javascript-nodejs-patterns.md
├── typescript-advanced-patterns.md
├── django-drf-patterns.md
├── postgresql-optimization.md
├── nosql-mongodb-advanced.md
└── chartjs-visualization.md
```

---

## 💡 Use Cases

✅ **Desenvolvimento assistido** — Agents geram código  
✅ **Padrões de referência** — Exemplos de cada agent  
✅ **Troubleshooting** — Agents diagnosticam problemas  
✅ **Learning** — Aprender padrões de cada tecnologia  
✅ **Code review** — Agents revisam código  

---

## 🔗 Relacionados

- [[17 - IA & AGENTS/Claude - Capabilities]] — Claude power
- [[17 - IA & AGENTS/AI Agents - Introduction]] — Como agents funcionam
- [[MOC - Projetos]] — Seus 4 projetos que usam Hermes

---

## 📊 Integração com Seus Projetos

- **Sistema André** (FastAPI) → Use @backend, @postgresql
- **Sistema RH** (Flask) → Use @backend, @nosql
- **neo-clinica** (Django) → Use @django, @postgresql
- **Todos** → Use @frontend para UI, @java/@typescript para patterns

---

**Status**: ✅ Production Ready  
**Próximos**: Adicionar mais specializations conforme necessário
