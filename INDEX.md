# 📚 Hermes Agents System - Central Hub

**Bem-vindo ao seu knowledge base de desenvolvimento!**

Última atualização: 2026-09-03 | Status: ✅ 100% Operacional

---

## 🚀 Quick Start

### Para Iniciantes
1. Leia [[AGENTS_QUICK_REFERENCE]] - Guia rápido (5 min)
2. Escolha um agent em [[AGENTS_COMPLETE]]
3. Consulte o padrão desejado na specialization

### Para Desenvolvedores
1. Acesse diretamente a specialization do seu agent
2. Use as search (Ctrl+P) para encontrar padrões
3. Consulte [[CODE_TRAINING]] para detalhes

---

## 🤖 Os 9 Agents

### Frontend & UI
- **[[frontend-complete]]** - React, HTML, CSS, Bootstrap, Tailwind
  - Quando usar: Componentes React, formulários, dashboards
  - Padrões: Hooks, propTypes, acessibilidade WCAG

### Backend & APIs
- **[[backend-database-patterns]]** - Node.js, Express, SQL, MongoDB, Redis
  - Quando usar: REST APIs, gerenciamento de BD, caching
  - Padrões: Repository, Service, Controller + migrations

- **[[java-spring-boot-patterns]]** - Spring Boot 3.x, JPA, JUnit 5
  - Quando usar: APIs Java, microserviços Spring
  - Padrões: @RestController, @Service, @Repository

- **[[django-drf-patterns]]** - Django 4.x, DRF, ORM
  - Quando usar: APIs Python, ModelView, QuerySets
  - Padrões: Models, Serializers, ViewSets

### Languages
- **[[javascript-nodejs-patterns]]** - Node.js, ES2022+, Async
  - Quando usar: Backend Node.js, async/await
  - Padrões: Promises, Retry logic, Streams

- **[[typescript-advanced-patterns]]** - TypeScript 5.x, Generics, Strict
  - Quando usar: Type-safe code, Generics
  - Padrões: Utility types, Discriminated unions

### Database
- **[[postgresql-optimization]]** - PostgreSQL, Query optimization
  - Quando usar: Queries lentas, indexes, analytics
  - Padrões: EXPLAIN ANALYZE, Window functions, CTEs

- **[[nosql-mongodb-advanced]]** - MongoDB, Aggregations, Sharding
  - Quando usar: Document design, analytics
  - Padrões: Aggregation pipeline, Transactions

### Visualization
- **[[chartjs-visualization]]** - Chart.js, D3.js, Recharts
  - Quando usar: Dashboards, gráficos, data viz
  - Padrões: Responsive, Accessible, Interactive

---

## 📚 Learning Resources

### Study Materials
- **[[KNOWLEDGE_BASE]]** - 9 Aulas (MongoDB, SQL)
  - MongoDB: Intro → CRUD → Queries → Aggregation → Production
  - SQL: CRUD → Operadores WHERE

- **[[CODE_TRAINING]]** - 13 Módulos de Treinamento
  - Módulo 1: SOLID & Design Patterns
  - Módulos 2-7: Backend, Frontend, Testing, DevOps, Security

### Quick References
- **[[AGENTS_QUICK_REFERENCE]]** - Guia rápido com exemplos
- **[[AGENTS_COMPLETE]]** - Descrição completa do sistema

---

## 🔍 Como Navegar

### Por Tecnologia
- **React**: [[frontend-complete]]
- **Node.js**: [[backend-database-patterns]], [[javascript-nodejs-patterns]]
- **Java**: [[java-spring-boot-patterns]]
- **Python**: [[django-drf-patterns]]
- **TypeScript**: [[typescript-advanced-patterns]]
- **PostgreSQL**: [[postgresql-optimization]]
- **MongoDB**: [[nosql-mongodb-advanced]]
- **Visualization**: [[chartjs-visualization]]

### Por Pattern Type
- **Architecture**: Repository, Service, Controller patterns
- **Data Access**: SQL, MongoDB, Redis, Caching
- **Testing**: Unit tests, Integration tests, Mocks
- **API Design**: RESTful, validation, error handling
- **Performance**: Queries, Indexing, Caching

### Por Problema
- "Minha query está lenta" → [[postgresql-optimization]]
- "Como estruturar uma API?" → [[backend-database-patterns]]
- "Preciso de um componente React" → [[frontend-complete]]
- "Aggregation em MongoDB" → [[nosql-mongodb-advanced]]
- "TypeScript types" → [[typescript-advanced-patterns]]

---

## 💡 Tips & Tricks

### Using Obsidian Links
```markdown
[[page-name]] - Link simples
[[page-name#heading]] - Link para heading
[[page-name|custom text]] - Link com texto customizado
```

### Using Tags
```markdown
#hermes #agents #development
#react #backend #database
#solid #design-pattern #testing
```

### Search (Ctrl+P)
- Busque por tecnologia: "React", "MongoDB", "SQL"
- Busque por padrão: "Repository", "Async", "Index"
- Busque por problema: "slow query", "caching", "testing"

### Graph View
Veja conexões entre agents e padrões:
- `Ctrl+Shift+G` - Abrir Graph View
- Visualize as conexões entre specializations

---

## 📊 Estatísticas

| Item | Valor |
|---|---|
| Agents | 9 |
| Specializations | 9 arquivos |
| Módulos CODE_TRAINING | 13 |
| Aulas KNOWLEDGE_BASE | 9 |
| Padrões Documentados | 54+ |
| Exemplos de Código | 100+ |
| Links Internos | 30+ |
| Tags | 15+ |

---

## 🎯 Próximas Ações

### Para Estudar
- [ ] Ler [[AGENTS_QUICK_REFERENCE]]
- [ ] Escolher um agent para aprender
- [ ] Estudar 3 padrões da specialization
- [ ] Praticar com um exemplo de código

### Para Usar em Projetos
- [ ] Usar @frontend para componentes React
- [ ] Usar @backend para APIs
- [ ] Consultar padrões antes de codificar
- [ ] Adaptar exemplos para seu projeto

### Para Expandir
- [ ] Adicionar novos padrões
- [ ] Criar exemplos customizados
- [ ] Documentar seus próprios patterns
- [ ] Compartilhar conhecimento

---

## 🔗 Links Úteis

### Principais
- [[AGENTS_COMPLETE]] - Sistema completo
- [[AGENTS_QUICK_REFERENCE]] - Quick start
- [[CODE_TRAINING]] - Módulos de treinamento
- [[KNOWLEDGE_BASE]] - Aulas de estudo
- [[OBSIDIAN_BEST_PRACTICES]] - Como navegar este vault (ler primeiro!)

### Agents
- Frontend: [[frontend-complete]]
- Backend: [[backend-database-patterns]]
- All 9 agents: Ver seção "Os 9 Agents" acima

---

## 🌟 Como Usar Este Index

1. **Primeira Visita**: Leia [[AGENTS_QUICK_REFERENCE]]
2. **Procurando um Pattern**: Use Ctrl+P para buscar
3. **Aprendendo**: Escolha um agent e leia a specialization
4. **Codificando**: Copie um exemplo e adapte
5. **Expandindo**: Adicione seus próprios patterns

---

## 📱 Estrutura do Vault

```
neo-projects-vault/
├── INDEX.md                          ← Você está aqui
├── AGENTS_COMPLETE.md
├── AGENTS_QUICK_REFERENCE.md
├── CODE_TRAINING.md
├── KNOWLEDGE_BASE.md
│
├── Agent Specializations/
│   ├── frontend-complete.md
│   ├── backend-database-patterns.md
│   ├── java-spring-boot-patterns.md
│   ├── javascript-nodejs-patterns.md
│   ├── typescript-advanced-patterns.md
│   ├── django-drf-patterns.md
│   ├── postgresql-optimization.md
│   ├── nosql-mongodb-advanced.md
│   └── chartjs-visualization.md
│
├── Courses/
│   ├── NoSQL-MongoDB/ (7 aulas)
│   ├── SQL-MySQL/ (2 aulas)
│   └── ...
│
├── Tasks/
│   ├── Backlog.md
│   ├── In-Progress.md
│   └── Done.md
│
└── ...
```

---

## 🚀 Commands

### No Hermes
```bash
# Usar um agent
hermes chat -q "@frontend Your prompt" --oneshot

# Estudar
hermes chat -q "Explain MongoDB aggregation" --oneshot
```

### No Obsidian
```
Ctrl+P - Search (Quick open)
Ctrl+Shift+G - Graph view
Ctrl+F - Search in page
Ctrl+Shift+F - Search all files
```

---

**Bem-vindo! Comece explorando os agents! 🚀**

Tags: #obsidian #index #hermes #agents #navigation

---

*Last Updated: 2026-09-03 | Created with ❤️ for development*
