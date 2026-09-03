# 9 Agents Complete Guide - Backend + Frontend + 7 Especialistas

Guia prático completo para o novo sistema de 9 agents.

---

## 🎯 Arquitetura dos 9 Agents

### **2 Generalistas (Orquestração)**
- **Backend Agent** — Coordena qualquer backend (Java, Python, Node.js)
- **Frontend Agent** — Coordena qualquer frontend (React, Angular, Vue)

### **7 Especialistas (Expertise)**
- **Java Agent** — Java 17+, Spring Boot, SOLID, design patterns
- **JavaScript Agent** — Node.js, ES2022+, async/await, Express
- **TypeScript Agent** — TS 5.x, strict mode, type system, generics
- **Django Agent** — Django 4.x, ORM, MVT, signals
- **PostgreSQL Agent** — SQL, schema design, optimization, indexing
- **NoSQL Agent** — MongoDB, document design, aggregation, sharding
- **Chart.js Agent** — Visualizations, responsive charts, real-time

---

## 🚀 Quick Start (5 minutos)

### **1. Setup (2 min)**
```bash
bash setup-hermes-9agents.sh
```

Output:
```
✓ 2 Generalistas criados (Backend, Frontend)
✓ 7 Especialistas criados
✓ Git integration configurada
```

---

### **2. Comece com Backend Agent (30 sec)**
```bash
hermes profile backend
```

---

### **3. Cola Initial Prompt (1 min)**

Abre `HERMES-PROMPTS-9AGENTS.md`
Copia "Backend Agent - Initial Prompt"

Cola no chat:
```
Você é o Backend Architect Agent...
[rest of prompt]
```

---

### **4. Primeira Tarefa (1.5 min)**
```bash
$ "Desenha arquitetura pro sistema de clínicas"
```

Agent propõe, você discute, agent aprende.

---

### **5. Use Especialista Quando Precisar (1 min)**
```bash
# Agora muda pra especialista de Java
hermes profile java
$ "Revisa esse Controller Java"
```

---

## 📊 Matriz de Decisão: Qual Agent Usar?

### **Cenário: Novos Endpoint de Pacientes**

| Pergunta | Use Este Agent |
|----------|---|
| "Como estruturar essa feature?" | **Backend Agent** |
| "Qual versioning de API usar?" | **Backend Agent** |
| "Java: como implementar?" | **Java Agent** |
| "Query tá lenta" | **PostgreSQL Agent** |
| "Como testar?" | **Java Agent** (ou especialista) |
| "Frontend: qual componente?" | **Frontend Agent** |
| "TypeScript: tipos pra dados?" | **TypeScript Agent** |
| "Chart: mostrar stats?" | **Chart.js Agent** |

**Padrão:** Começa com Generalista, depois chama Especialista.

---

## 🔧 BACKEND AGENT (Orquestrador de Backend)

**Quando usar:**
- ✅ Arquitetura geral de backend
- ✅ Decisões de tech stack
- ✅ API design overview
- ✅ Performance strategy
- ✅ Database strategy (alto nível)

**Quando NÃO usar:**
- ❌ Code review Java específico (use Java Agent)
- ❌ Django ORM optimization (use Django Agent)
- ❌ Query SQL específica (use PostgreSQL Agent)

### Tarefas Típicas

```bash
hermes profile backend

# Arquitetura
$ "Desenha arquitetura pra sistema de agendamento com 100k usuários"

# Tech decision
$ "Devo usar Java + Spring ou Python + FastAPI? Qual a diferença?"

# API design
$ "Como estruturar versionamento de API?"

# Performance strategy
$ "App tá lento. Como investigar e otimizar?"

# Database strategy
$ "Qual database escolher: PostgreSQL ou MongoDB?"

# Migration strategy
$ "Como migrar de Django pra FastAPI sem quebrar API?"
```

### Skills que Cria

Depois de semanas:
- `backend-architecture-patterns.md` — Seu padrão de arquitetura
- `api-design-strategy.md` — Sua estratégia REST
- `tech-stack-decision.md` — Critérios de decisão
- `performance-priorities.md` — O que é importante pra você

---

## 🎨 FRONTEND AGENT (Orquestrador de Frontend)

**Quando usar:**
- ✅ Arquitetura geral de frontend
- ✅ Decisões de framework (React vs Angular)
- ✅ State management strategy
- ✅ Component architecture overview
- ✅ Performance strategy

**Quando NÃO usar:**
- ❌ TypeScript specific (use TypeScript Agent)
- ❌ React hooks deep dive (use especialista)
- ❌ Tailwind optimization (use Frontend Agent pra estrutura)

### Tarefas Típicas

```bash
hermes profile frontend

# Arquitetura
$ "Desenha componentes pra dashboard de clínicas"

# Framework decision
$ "React ou Angular? Qual escolher?"

# State management
$ "Qual state management: Redux, Context, ou Pinia?"

# Component structure
$ "Como estruturar componentes reusáveis?"

# Performance
$ "Bundle tá 3MB. Como otimizar?"

# Responsive design
$ "Como fazer layout responsivo mobile-first?"
```

### Skills que Cria

- `component-architecture.md` — Seu padrão de componentes
- `state-management-strategy.md` — Sua abordagem
- `framework-decision-criteria.md` — Quando cada framework
- `performance-optimization.md` — Suas técnicas

---

## 🔧 ESPECIALISTAS - Quando Chamar

### **Java Agent**
```bash
hermes profile java

# Use quando:
# - Código Java específico
# - Spring Boot patterns
# - Design patterns em Java
# - JUnit/testing em Java
# - Null-safety, optional usage
# - Microservices em Spring

$ "Revisa esse Spring Boot Controller"
$ "Como estruturar JPA queries?"
$ "Refactor pra usar Optional"
```

---

### **JavaScript Agent**
```bash
hermes profile javascript

# Use quando:
# - Node.js específico
# - Express middleware
# - Async/await patterns
# - npm/yarn issues
# - Event loop problems
# - Streaming/buffers

$ "Middleware Express pra autenticação"
$ "Como fazer 3 requests em paralelo?"
$ "App Node lento, como debugar?"
```

---

### **TypeScript Agent**
```bash
hermes profile typescript

# Use quando:
# - Type-safety issues
# - Generics design
# - Strict mode compliance
# - Discriminated unions
# - Utility types
# - Advanced type system

$ "Refactor pra estar strict mode compliant"
$ "Desenha generic type-safe função"
$ "Como usar Record<K,V> pra esse caso?"
```

---

### **Django Agent**
```bash
hermes profile django

# Use quando:
# - Django models específico
# - ORM optimization (N+1)
# - Queryset strategy
# - Views architecture
# - Forms validation
# - Signals design

$ "Essa query tem N+1? Como otimizar?"
$ "Django models pra sistema de pacientes"
$ "Como estruturar class-based views?"
```

---

### **PostgreSQL Agent**
```bash
hermes profile postgresql

# Use quando:
# - Schema design
# - Query optimization
# - Indexing strategy
# - Performance tuning
# - Backup/recovery
# - SQL específico

$ "Desenha schema pra clínica + pacientes"
$ "Otimiza essa query lenta"
$ "Qual index adicionar aqui?"
```

---

### **NoSQL Agent**
```bash
hermes profile nosql

# Use quando:
# - MongoDB document design
# - Aggregation pipeline
# - Sharding strategy
# - Query optimization
# - Schema validation
# - Embed vs reference

$ "Desenha documento MongoDB pra pacientes"
$ "Aggregation pipeline pra report"
$ "Qual shard key usar?"
```

---

### **Chart.js Agent**
```bash
hermes profile chartjs

# Use quando:
# - Chart type selection
# - Dashboard layout
# - Real-time updates
# - Customization
# - Performance (large datasets)
# - Interactivity

$ "Chart pra receita vs consultas"
$ "Desenha dashboard com 4 charts"
$ "Real-time updates via WebSocket"
```

---

## 📈 Progression Model

### **Dia 1-3: Learning Phase**
- Backend Agent está aprendendo seus padrões
- Feedback é IMPORTANTE
- "Gostei dessa abordagem"
- "Não, prefiro assim"
- Agente nota e cria skills

### **Dia 4-7: Tuning Phase**
- Backend Agent já conhece suas preferências
- Sugestões mais relevantes (~70-80%)
- Skills começam a ser aplicadas
- Menos back-and-forth

### **Semana 2+: Productive Phase**
- Backend Agent é **muito** produtivo
- Entende seu context
- Sugestões são precisas
- Pode delegar mais tarefas

### **Semana 3+: Scaling Phase**
- Agora invite Frontend Agent
- Depois adicione Especialistas conforme necessário
- Cada um aprende seus padrões
- Produtividade exponencial

---

## 🎯 Real-World Workflows

### **Workflow 1: Feature Backend Simples (JSON API)**

```
1. Backend Agent (arquitecta)
   $ "Novo endpoint pra listar pacientes com filtros"
   → Agent propõe REST structure, response format

2. Java Agent (implementa se Java)
   $ "Implementa Controller pra esse endpoint"
   → Agent cria código Spring Boot

3. PostgreSQL Agent (otimiza query)
   $ "Query tá lenta pra 100k registros"
   → Agent otimiza com indexes

4. Backend Agent (review final)
   $ "Revisa se tudo tá bom"
   → Agent valida arquitetura
```

---

### **Workflow 2: Feature Frontend Completa**

```
1. Frontend Agent (arquitecta)
   $ "Componentes pra editar agendamento de paciente"
   → Agent propõe estrutura, state, forms

2. TypeScript Agent (types)
   $ "Tipos type-safe pra dados de paciente"
   → Agent cria discriminated unions

3. Frontend Agent (state strategy)
   $ "Como gerenciar state do formulário?"
   → Agent recomenda Context vs Redux

4. Chart.js Agent (stats)
   $ "Dashboard mostrando stats de agendamentos"
   → Agent cria charts responsivos

5. Frontend Agent (review)
   $ "Tudo tá ok?"
   → Agent valida arquitetura
```

---

### **Workflow 3: Full-Stack Feature (Novo Sistema)**

```
1. Backend Agent (orquestra)
   $ "Desenha arquitetura completa pra clínica management"

2. Backend Agent (API design)
   $ "Qual estrutura de endpoints?"

3. Java Agent (backend implementation)
   $ "Implementa controllers e services"

4. PostgreSQL Agent (database)
   $ "Schema pra clínica + pacientes + médicos"

5. Frontend Agent (orquestra frontend)
   $ "Componentes pra dashboard"

6. TypeScript Agent (types)
   $ "Types pra integração com API"

7. Chart.js Agent (analytics)
   $ "Dashboard com estatísticas"

8. Backend Agent (final validation)
   $ "Tudo integrado e funcionando?"
```

---

## 💡 Tips & Tricks

### **1. Rápido Switch Entre Agents**
```bash
# Estava no Backend
hermes profile backend
$ "Arquitetura da API"

# Muda pra Java
hermes profile java
$ "Implementa esse endpoint"

# Volta pro Backend
hermes profile backend
$ "Revisa o código"
```

### **2. Força Aprendizado Rápido**
```bash
# Dê feedback muito claro
$ "Perfeito! Esse padrão de validation é exatamente o que uso"

# Ou crie skill explicitamente
$ "Cria skill com esse padrão de Spring Boot validation"

# Agent aprende e memoriza
```

### **3. Ver o que cada agent aprendeu**
```bash
# Memory do Backend Agent
hermes profile backend memory show

# Skills criadas
hermes profile backend skills list

# Ver uma skill
hermes profile backend skills show api-design-strategy.md
```

### **4. Telegram 24/7 pra qualquer agent**
```bash
# Setup backend pra telegram
hermes profile backend gateway install

# Depois conversa via cel:
@backend-agent: "Desenha arquitetura pra..."

# Ou especialista:
hermes profile java gateway install
```

### **5. Crons pra aprendizado contínuo**
```bash
# Daily code review
hermes profile backend cron add "daily-architecture-review" \
  --schedule "0 9 * * *" \
  --command "Revisa commits de hoje, identifica patterns e antipatterns"
```

---

## 📋 Cheat Sheet

### **Quick Commands**

```bash
# Setup uma vez
bash setup-hermes-9agents.sh

# Listar todos agents
hermes profile list

# Abrir agent
hermes profile backend
hermes profile frontend
hermes profile java
hermes profile typescript
hermes profile postgresql
hermes profile django
hermes profile javascript
hermes profile nosql
hermes profile chartjs

# Ver memory
hermes profile backend memory show

# Ver skills
hermes profile backend skills list

# Setup Telegram
hermes profile backend gateway install

# Help
hermes --help
hermes profile --help
```

### **Quando Chamar Cada Um**

| Pergunta | Agent |
|----------|-------|
| "Como estruturar essa feature?" | Backend/Frontend |
| "Qual framework usar?" | Frontend |
| "Qual database usar?" | Backend |
| "Code review Java" | Java |
| "Code review Node" | JavaScript |
| "Types TypeScript" | TypeScript |
| "Django ORM" | Django |
| "SQL query" | PostgreSQL |
| "MongoDB schema" | NoSQL |
| "Charts e dashboards" | Chart.js |

---

## 🚀 Getting Started

### **Step 1: Setup (2 min)**
```bash
bash setup-hermes-9agents.sh
```

### **Step 2: Abrir Backend Agent (30 sec)**
```bash
hermes profile backend
```

### **Step 3: Cola Initial Prompt (1 min)**
```
Você é o Backend Architect Agent...
[cola do arquivo HERMES-PROMPTS-9AGENTS.md]
```

### **Step 4: Primeira Tarefa (1.5 min)**
```bash
$ "Desenha arquitetura do meu novo projeto"
```

### **Step 5: Add Frontend Agent (1 min)**
```bash
hermes profile frontend
$ [cola frontend initial prompt]
```

### **Step 6: Use Especialistas Conforme Necessário**
```bash
hermes profile java
$ "Revisa Controller Java"
```

---

## 📁 Arquivos Importantes

- **setup-hermes-9agents.sh** — Rodar uma vez
- **HERMES-PROMPTS-9AGENTS.md** — Initial prompts
- **HERMES-SPECIALIZED-GUIDE.md** — Detalhes de cada especialista (anterior)

---

## 🎓 Recomendação de Progressão

### **Semana 1: Backend Focus**
- Comece com Backend Agent
- Depois Java/Django/PostgreSQL conforme stack

### **Semana 2: Full-Stack**
- Add Frontend Agent
- Depois TypeScript/Chart.js

### **Semana 3+: Master**
- Todos os 9 agents já conhecem você
- Use o certo pra cada tarefa
- Productivity boost notável

---

**9 Agents prontos: 2 Generalistas + 7 Especialistas! 🚀**

Next: Comece com Backend Agent e vá crescendo!
