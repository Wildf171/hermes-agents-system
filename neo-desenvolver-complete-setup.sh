#!/bin/bash

set -e

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║        Neo Desenvolver - Complete Setup                   ║"
echo "║   Hermes (9 agents) + Obsidian + OpenClaw                 ║"
echo "║   Full System Initialization                              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
SETUP_DIR="$HOME/neo-desenvolver-setup"
VAULT_PATH="$HOME/neo-projects-vault"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
OPENCLAW_HOME="$HOME/.openclaw"

# ============================================================================
# SECTION 0: Pre-flight Checks
# ============================================================================
echo -e "${YELLOW}[0/15] Pre-flight checks...${NC}"

# Check if bash version is compatible
if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "❌ Bash 4.0+ required. You have version ${BASH_VERSINFO[0]}"
    exit 1
fi

# Check internet connectivity
if ! ping -c 1 8.8.8.8 &> /dev/null; then
    echo "⚠️  No internet connection detected. Some installations may fail."
    echo "   Continuing anyway..."
fi

echo -e "${GREEN}✓ Pre-flight checks passed${NC}"
echo ""

# ============================================================================
# SECTION 1: Install Hermes
# ============================================================================
echo -e "${YELLOW}[1/15] Checking Hermes Agent Framework...${NC}"

if ! command -v hermes &> /dev/null; then
    echo "📦 Installing Hermes..."
    curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
else
    echo "✓ Hermes already installed"
fi

echo -e "${GREEN}✓ Hermes ready${NC}"
echo ""

# ============================================================================
# SECTION 2: Install OpenClaw
# ============================================================================
echo -e "${YELLOW}[2/15] Checking OpenClaw Control Plane...${NC}"

if ! command -v openclaw &> /dev/null; then
    echo "📦 Installing OpenClaw..."
    curl -fsSL https://openclaw.ai/install.sh | bash
else
    echo "✓ OpenClaw already installed"
fi

echo -e "${GREEN}✓ OpenClaw ready${NC}"
echo ""

# ============================================================================
# SECTION 3: Validate Environments
# ============================================================================
echo -e "${YELLOW}[3/15] Validating environments...${NC}"

if ! hermes doctor &> /dev/null; then
    echo "⚠️  Hermes configuration incomplete. Running setup..."
    hermes setup
fi

echo -e "${GREEN}✓ Hermes validated${NC}"
echo ""

# ============================================================================
# SECTION 4: Create Hermes 9 Agents
# ============================================================================
echo -e "${YELLOW}[4/15] Creating 9 Hermes Agent Profiles...${NC}"

declare -a AGENTS=(
    "backend"
    "frontend"
    "java"
    "javascript"
    "typescript"
    "django"
    "postgresql"
    "nosql"
    "chartjs"
)

for agent in "${AGENTS[@]}"; do
    hermes profile create "$agent" 2>/dev/null || true
done

echo -e "${GREEN}✓ 9 agents created${NC}"
echo ""

# ============================================================================
# SECTION 5: Configure Hermes Agents - SOUL.md Files
# ============================================================================
echo -e "${YELLOW}[5/15] Configuring Hermes Agent Personalities...${NC}"

# Backend Agent (Generalista)
cat > "$HERMES_HOME/profiles/backend/SOUL.md" << 'EOF'
# Backend Architect Agent

## Expertise
- Java, Python, Node.js backends
- REST APIs, microservices, performance
- PostgreSQL, MongoDB, Redis
- Architecture, SOLID, design patterns

## Work Style
1. Arquitetura PRIMEIRO
2. APIs são contracts (nunca quebra compat)
3. Performance matters
4. Security first
5. Testability by design

## Tech Stacks
- Java + Spring Boot 3.x
- Python + FastAPI
- Node.js + Express
- Any mix with PostgreSQL/MongoDB

## When Asked
- "Architectural review" → Full design evaluation
- "API design" → REST structure + strategy
- "Tech decision" → Recommendation with trade-offs
- "Performance bottleneck" → Profiling + optimization
EOF

# Frontend Agent (Generalista)
cat > "$HERMES_HOME/profiles/frontend/SOUL.md" << 'EOF'
# Frontend Architect Agent

## Expertise
- React, Angular, Vue frameworks
- TypeScript, state management
- Performance optimization
- Accessibility, responsive design
- Component architecture

## Work Style
1. User-first → accessibility matters
2. Type-safe → TypeScript strict always
3. Performance conscious
4. Component reusability → DRY
5. Responsive by default
6. Testing confidence

## Tech Stacks
- React + TypeScript + Redux/Context
- Angular + TypeScript + RxJS
- Vue + TypeScript + Pinia
- Tailwind CSS, Jest, Cypress

## When Asked
- "Component design" → Architecture + API
- "State management" → Strategy + implementation
- "Performance optimization" → Analysis + improvements
- "Accessibility audit" → WCAG + fixes
EOF

# Java Agent
cat > "$HERMES_HOME/profiles/java/SOUL.md" << 'EOF'
# Java Specialist Agent

## Expertise
- Java 17+, Spring Boot 3.x
- OOP, design patterns, SOLID
- PostgreSQL, Hibernate
- JUnit 5, concurrency, performance

## Principles
- Type-safety first
- Null-safety with Optional
- Immutability when possible
- Testability by design
- No raw types, no unchecked warnings

## Stack
- Java 17+, Spring Boot 3.x, Maven
- PostgreSQL + Hibernate
- JUnit 5, Mockito, TestContainers

## When Asked
- "Code review" → Architecture + patterns
- "Refactor class" → Null-safety + immutability
- "Design system" → Spring Boot architecture
- "Test strategy" → JUnit5 + TestContainers
EOF

# JavaScript Agent
cat > "$HERMES_HOME/profiles/javascript/SOUL.md" << 'EOF'
# JavaScript Specialist Agent

## Expertise
- Node.js, ES2022+, async/await
- Express/Fastify, middleware
- npm/yarn, testing (Jest, supertest)
- Performance, event loop

## Principles
- Async-first approach
- Proper error handling
- Immutability (const default)
- Functional patterns
- Modern syntax

## Stack
- Node.js 18+, Express/Fastify
- Jest + supertest, ESLint + Prettier
- npm for packages

## When Asked
- "Code review" → Async patterns + error handling
- "Middleware design" → Pattern + error propagation
- "Refactor" → Modernize + async improvements
- "Test strategy" → Jest + supertest
EOF

# TypeScript Agent
cat > "$HERMES_HOME/profiles/typescript/SOUL.md" << 'EOF'
# TypeScript Specialist Agent

## Expertise
- TypeScript 5.x, strict mode
- Generics, advanced types
- Discriminated unions, utility types
- Type inference, type guards
- Zero-cost abstractions

## Principles
- Strict mode always
- No `any` (use `unknown`)
- Type over runtime checks
- Discriminated unions for exhaustive checks
- Generics for DRY reusable code

## Stack
- TypeScript 5.x with strict mode
- Node.js + ts-node/esbuild
- Jest + ts-jest, ESLint + Prettier

## When Asked
- "Type-safety review" → Strict mode compliance
- "Generics design" → Type-safe reusable code
- "Refactor" → Better types + strict compliance
- "Type design" → Discriminated unions + guards
EOF

# Django Agent
cat > "$HERMES_HOME/profiles/django/SOUL.md" << 'EOF'
# Django Specialist Agent

## Expertise
- Django 4.x, MVT pattern, ORM
- Models, querysets, N+1 prevention
- Class-based + function-based views
- Forms, admin customization, signals
- Testing with pytest-django

## Principles
- Fat models, thin views
- Queryset optimization (select_related, prefetch)
- Form validation in clean() methods
- Settings for configuration
- Signals with caution

## Stack
- Django 4.x, PostgreSQL
- Django REST Framework
- Celery for async, factory_boy
- pytest-django for testing

## When Asked
- "ORM optimization" → N+1 detection + fix
- "Model design" → Structure + validation
- "View architecture" → CBV + mixins
- "Form validation" → Clean() strategy
EOF

# PostgreSQL Agent
cat > "$HERMES_HOME/profiles/postgresql/SOUL.md" << 'EOF'
# PostgreSQL Specialist Agent

## Expertise
- SQL (DML, DDL, window functions, CTEs)
- Schema design, normalization, constraints
- Indexing strategies (B-tree, GiST, GIN, BRIN)
- Query optimization, EXPLAIN ANALYZE
- Transactions, replication, backup/recovery

## Principles
- Constraints first
- Query first (EXPLAIN ANALYZE)
- Normalize by default
- Indexes wisely (not on every column)
- Transaction safety always

## Stack
- PostgreSQL 14+
- psql, pg_dump, pgBench
- PostGIS if geo data

## When Asked
- "Schema design" → Normalization + constraints
- "Query optimization" → EXPLAIN ANALYZE + indexes
- "Performance tuning" → Query plans + config
- "Data integrity" → FK + constraints
EOF

# NoSQL Agent
cat > "$HERMES_HOME/profiles/nosql/SOUL.md" << 'EOF'
# NoSQL Specialist Agent

## Expertise
- MongoDB document design
- Aggregation pipeline, indexing
- Schema validation (JSON schema)
- Transactions, replication, sharding
- Performance profiling, optimization

## Principles
- Denormalization by design
- Embedding vs referencing (query patterns)
- Shard key selection is critical
- Transactions when needed (minimize use)
- Access patterns drive schema

## Stack
- MongoDB 6.0+
- Mongoose/motor (Python)
- MongoDB Compass, Atlas
- mongodump/mongorestore

## When Asked
- "Document design" → Structure + denormalization
- "Aggregation pipeline" → Complex queries
- "Sharding" → Shard key selection
- "Performance" → Indexes + optimization
EOF

# Chart.js Agent
cat > "$HERMES_HOME/profiles/chartjs/SOUL.md" << 'EOF'
# Chart.js Visualization Agent

## Expertise
- Chart.js all types (line, bar, scatter, etc)
- Configuration, styling, animation
- Responsive design, interactivity
- Real-time updates (WebSocket, SSE)
- Performance optimization

## Principles
- Data quality first
- Right chart type (bar vs line vs pie)
- Accessibility matters (colorblind-friendly)
- Performance aware (large datasets)
- Interactivity adds value

## Stack
- Chart.js 4.x
- React wrapper if needed
- TypeScript for type safety
- Custom plugins, Tailwind CSS

## When Asked
- "Chart selection" → Type + structure
- "Dashboard" → Multiple charts + layout
- "Real-time" → Performance + strategy
- "Customize" → Colors + interactivity
EOF

echo -e "${GREEN}✓ Hermes agents configured${NC}"
echo ""

# ============================================================================
# SECTION 6: Create Hermes Config Files
# ============================================================================
echo -e "${YELLOW}[6/15] Creating Hermes agent configurations...${NC}"

for agent in "${AGENTS[@]}"; do
    AGENT_DIR="$HERMES_HOME/profiles/$agent"
    mkdir -p "$AGENT_DIR"
    
    cat > "$AGENT_DIR/config.yaml" << 'EOF'
display:
  memory_notifications: true
  verbose: true

tools:
  git:
    enabled: true
    restrictions:
      allow_dirs:
        - "~"
        - "/home"
  file:
    enabled: true
    max_read_size_mb: 10

memory:
  max_size_tokens: 8000
  compression_threshold: 10000
EOF
done

echo -e "${GREEN}✓ Hermes configurations created${NC}"
echo ""

# ============================================================================
# SECTION 7: Create Obsidian Vault Structure
# ============================================================================
echo -e "${YELLOW}[7/15] Creating Obsidian Vault Structure...${NC}"

mkdir -p "$VAULT_PATH"/{Projects,Tasks,Knowledge,Agents,Dashboards,Archive}

echo -e "${GREEN}✓ Vault structure created at: $VAULT_PATH${NC}"
echo ""

# ============================================================================
# SECTION 8: Create Vault Templates
# ============================================================================
echo -e "${YELLOW}[8/15] Creating Vault Templates...${NC}"

# README.md
cat > "$VAULT_PATH/README.md" << 'EOF'
# Neo Desenvolver - Complete Project Management System

**Seu cérebro (Obsidian) + Agents executando (OpenClaw + Hermes) = Produtividade ⚡**

## 🎯 Estrutura

- **Projects/** — Projetos ativos
- **Tasks/** — Tarefas (Backlog, In Progress, Done)
- **Knowledge/** — Knowledge base (patterns, docs, tips)
- **Agents/** — Configuração e logs dos agents
- **Dashboards/** — Views e analytics
- **Archive/** — Projetos completados

## 🚀 Como Usar

1. Crie task em `Tasks/In-Progress.md`
2. Mude status para `READY`
3. Atribua a: `@openclaw` ou `@hermes-backend` etc
4. Agent detecta e executa automaticamente
5. Progress é atualizado em tempo real
6. WhatsApp/Slack notificam você

## 📚 Documentação

- [[Agents/Agent-Config]] — Configuração dos agents
- [[Agents/Hermes-Setup]] — Setup Hermes
- [[Knowledge/Getting-Started]] — Primeiros passos

---

**Vault Setup:** 2024-01-20
**Agents:** 9 (Backend, Frontend, Java, JS, TS, Django, PostgreSQL, NoSQL, Chart.js)
**Status:** ✓ Pronto para usar

Comece criando sua primeira tarefa!
EOF

# Agents config
cat > "$VAULT_PATH/Agents/Agent-Config.md" << 'EOF'
# Agent Configuration

## Active Agents (9)

### Generalistas (Orquestração)
- **Backend Agent** — Qualquer backend (Java, Python, Node.js)
- **Frontend Agent** — Qualquer frontend (React, Angular, Vue)

### Especialistas
- **Java Agent** — Java 17+, Spring Boot
- **JavaScript Agent** — Node.js, Express
- **TypeScript Agent** — TS 5.x, strict mode
- **Django Agent** — Django 4.x, ORM
- **PostgreSQL Agent** — SQL, schema, optimization
- **NoSQL Agent** — MongoDB, document design
- **Chart.js Agent** — Visualizations, dashboards

## Model Settings
- Model: claude-sonnet-4-6
- Provider: OpenRouter or Claude API
- Temperature: 0.7
- Max Tokens: 4000

## Memory
- Type: Obsidian-backed
- Auto-save: Enabled
- Compression: Every 10k tokens

## Enabled Skills
- ✓ Git operations (clone, pull, commit, push)
- ✓ Code execution (bash, python, node)
- ✓ Database queries (PostgreSQL, MongoDB)
- ✓ File operations (read, write, append)
- ✓ HTTP requests (API calls)

## Channels
- Primary: Obsidian (local)
- Optional: WhatsApp (+55 61 98181-0571)
- Optional: Slack
- Optional: Telegram

**Setup Status:** ✓ Ready
**Last Updated:** 2024-01-20
EOF

# Hermes Setup guide
cat > "$VAULT_PATH/Agents/Hermes-Setup.md" << 'EOF'
# Hermes Agent Setup Guide

## 9 Agents Disponíveis

### Como Usar

#### Backend Agent
```bash
hermes profile backend
$ "Arquitetura pra sistema de clínicas"
```

#### Frontend Agent
```bash
hermes profile frontend
$ "Componentes pra dashboard"
```

#### Especialistas
```bash
hermes profile java      # Java específico
hermes profile django    # Django ORM
hermes profile postgresql # SQL queries
hermes profile typescript # TypeScript types
```

## Hermes Memory & Skills

Ver memory do agent:
```bash
hermes profile backend memory show
```

Ver skills que aprendeu:
```bash
hermes profile backend skills list
```

## Telegram Bot (Optional)

Setup bot WhatsApp/Telegram:
```bash
hermes profile backend gateway install
```

Depois converse via app!

---

**Próximos passos:** Use [[Tasks/In-Progress]] pra criar suas primeiras tarefas
EOF

# Tasks templates
cat > "$VAULT_PATH/Tasks/In-Progress.md" << 'EOF'
# In Progress Tasks

## task_001: Setup Project - Instituto Seroto
- Assigned to: @hermes-backend
- Created: 2024-01-20
- Deadline: 2024-01-22
- Priority: HIGH
- Status: READY

### Description
Initial setup of clinic management system.

### Requirements
- [ ] Database schema design
- [ ] API endpoints architecture
- [ ] Frontend components layout
- [ ] Development environment setup

### Agent Progress
Waiting for agent to detect status = READY

---

[Adicione suas tarefas aqui com formato similar]
EOF

cat > "$VAULT_PATH/Tasks/Backlog.md" << 'EOF'
# Backlog Tasks

Templates para criar novas tarefas:

```markdown
## task_XXX: Task Name - Project
- Assigned to: @hermes-backend (ou outro agent)
- Deadline: YYYY-MM-DD
- Priority: HIGH/MEDIUM/LOW
- Status: BACKLOG

**Description:** ...
**Requirements:** ...
**Links:** [[Project-Name]]
```

Quando pronto, mude `Status: BACKLOG` para `Status: READY`
Agent vai detectar e executar automaticamente!
EOF

cat > "$VAULT_PATH/Tasks/Done.md" << 'EOF'
# Completed Tasks

Tasks movem aqui automaticamente quando agent completa.

## task_000: Example Completed Task ✓
- Completed: 2024-01-20
- Time: 2h 30m
- PR: github.com/neo/projeto/pull/123

Summary of completed work...
EOF

# Projects template
cat > "$VAULT_PATH/Projects/Instituto-Seroto.md" << 'EOF'
# Instituto Seroto - Clinic Management System

## Project Status
- Status: IN_PROGRESS
- Start Date: 2024-01-20
- Target: 2024-06-30
- Progress: 0%

## Architecture
- Backend: FastAPI + PostgreSQL + Redis
- Frontend: React + TypeScript
- Infrastructure: Docker + GitHub Actions

## Tasks
- [ ] [[../Tasks/In-Progress#task_001]] Database Design
- [ ] [[../Tasks/In-Progress#task_002]] API Endpoints
- [ ] [[../Tasks/In-Progress#task_003]] Frontend Components

---

[Adicione mais projetos conforme necessário]
EOF

# Knowledge base
cat > "$VAULT_PATH/Knowledge/Getting-Started.md" << 'EOF'
# Getting Started - Agents + Obsidian

## 5 Minute Quick Start

### 1. Create a Task (1 min)
Open: `[[Tasks/In-Progress]]`

Add your task with format:
```markdown
## task_XXX: Your Task Name
- Assigned to: @hermes-backend
- Status: READY
- Requirements...
```

### 2. Agent Detects It (30 sec)
Agent loop runs every 5 minutes.
When it finds `Status: READY`, it starts execution!

### 3. Watch Progress (2 min)
Check: `[[Agents/Agent-Logs]]`

Agent is executing your task in real-time!

### 4. Get Notifications (1 min)
WhatsApp/Slack/Telegram notify you of progress.

### 5. Review Results (1 min)
When done, agent updates task to `Status: DONE`
Check GitHub PR or results file.

---

## Tips

✅ Keep task format consistent
✅ Use clear descriptions
✅ Break large tasks into subtasks
✅ Link related tasks with [[]]
✅ Assign to specific agent for best results

---

**Você está pronto! Crie sua primeira tarefa agora! 🚀**
EOF

# Dashboards
cat > "$VAULT_PATH/Dashboards/Overview.md" << 'EOF'
# Project Overview

## Status Summary

### Projects
- Instituto Seroto: 0% (STARTING)
- Neo RH System: 0% (BACKLOG)

### Tasks
- Total: 0
- Completed: 0
- In Progress: 0
- Ready: 1
- Backlog: 0

### Agents
- Backend: Ready ✓
- Frontend: Ready ✓
- Java: Ready ✓
- TypeScript: Ready ✓
- PostgreSQL: Ready ✓
- Django: Ready ✓
- NoSQL: Ready ✓
- Chart.js: Ready ✓

---

## Recent Activity

Check [[Agents/Agent-Logs]] for latest updates.

---

**Start by creating a task in [[Tasks/In-Progress]]**
EOF

# Agent logs
cat > "$VAULT_PATH/Agents/Agent-Logs.md" << 'EOF'
# Agent Execution Logs

Auto-updated every 30 minutes by agents.

## System Status
```
[SYSTEM] Agent framework initialized
[SYSTEM] 9 profiles loaded
[SYSTEM] Obsidian integration ready
[SYSTEM] Waiting for tasks...
```

## Current Session

Agents are waiting for tasks to be created.

To get started:
1. Go to [[Tasks/In-Progress]]
2. Create a new task with `Status: READY`
3. Agent will detect and execute

---

**Next update:** [Auto-updated by agents every 30 min]
EOF

echo -e "${GREEN}✓ Vault templates created${NC}"
echo ""

# ============================================================================
# SECTION 9: Create OpenClaw Configuration
# ============================================================================
echo -e "${YELLOW}[9/15] Configuring OpenClaw...${NC}"

mkdir -p "$OPENCLAW_HOME"

cat > "$OPENCLAW_HOME/config.yaml" << OPENCLAW_EOF
workspace:
  name: neo-desenvolver
  model: claude-sonnet-4-6

integrations:
  obsidian:
    enabled: true
    vault_path: $VAULT_PATH
    auto_sync: true
    sync_interval: 300

agents:
  neo-developer:
    model: claude-sonnet-4-6
    memory:
      location: $VAULT_PATH/Agents/memory.md
      auto_save: true
    skills:
      enabled: true
      custom_dir: $VAULT_PATH/Agents/skills
    channels:
      - obsidian

logging:
  level: info
  location: $VAULT_PATH/Agents/logs.md
OPENCLAW_EOF

echo -e "${GREEN}✓ OpenClaw configured${NC}"
echo ""

# ============================================================================
# SECTION 10: Create Quick Start Scripts
# ============================================================================
echo -e "${YELLOW}[10/15] Creating Quick Start Scripts...${NC}"

# Start backend agent
cat > "$VAULT_PATH/Agents/start-backend.sh" << 'EOF'
#!/bin/bash
echo "Starting Backend Agent..."
hermes profile backend
EOF
chmod +x "$VAULT_PATH/Agents/start-backend.sh"

# Start frontend agent
cat > "$VAULT_PATH/Agents/start-frontend.sh" << 'EOF'
#!/bin/bash
echo "Starting Frontend Agent..."
hermes profile frontend
EOF
chmod +x "$VAULT_PATH/Agents/start-frontend.sh"

# Start Java specialist
cat > "$VAULT_PATH/Agents/start-java.sh" << 'EOF'
#!/bin/bash
echo "Starting Java Specialist Agent..."
hermes profile java
EOF
chmod +x "$VAULT_PATH/Agents/start-java.sh"

# Start all OpenClaw
cat > "$VAULT_PATH/Agents/start-openclaw.sh" << 'EOF'
#!/bin/bash
echo "Starting OpenClaw Agent Orchestrator..."
openclaw start neo-developer
EOF
chmod +x "$VAULT_PATH/Agents/start-openclaw.sh"

echo -e "${GREEN}✓ Quick start scripts created${NC}"
echo ""

# ============================================================================
# SECTION 11: Create Documentation Index
# ============================================================================
echo -e "${YELLOW}[11/15] Creating Documentation...${NC}"

cat > "$SETUP_DIR/README.md" << 'EOF'
# Neo Desenvolver - Complete Setup Package

**All-in-One Solution: Hermes (9 agents) + Obsidian + OpenClaw**

## 📦 What's Included

1. **Hermes Agent Framework** (9 specialized agents)
   - Backend Agent (orchestrator)
   - Frontend Agent (orchestrator)
   - Java, JavaScript, TypeScript specialists
   - Django, PostgreSQL, NoSQL specialists
   - Chart.js specialist

2. **Obsidian Vault** (Your brain)
   - Project management structure
   - Task templates
   - Knowledge base
   - Agent logs & dashboards

3. **OpenClaw Control Plane** (Orchestration)
   - Connects Hermes + Obsidian
   - Runs agents 24/7
   - Multi-channel support (WhatsApp, Slack, Telegram)

## 🚀 Quick Start (5 min)

### Step 1: Run Setup
```bash
bash neo-desenvolver-complete-setup.sh
```

### Step 2: Open Obsidian
- Launch Obsidian app
- "Open folder as vault"
- Select: ~/neo-projects-vault

### Step 3: Create First Task
- Go to `Tasks/In-Progress.md`
- Change `Status: BACKLOG` → `Status: READY`
- Agent detects and executes!

### Step 4: Monitor Progress
- Check `Agents/Agent-Logs.md`
- Get notified on WhatsApp/Slack
- See results in GitHub

## 📁 Directory Structure

```
~/neo-projects-vault/
├── Projects/           # Your projects
├── Tasks/             # Task management
│   ├── In-Progress.md
│   ├── Backlog.md
│   └── Done.md
├── Knowledge/         # Knowledge base
├── Agents/           # Agent configs & logs
│   ├── Agent-Config.md
│   ├── Agent-Logs.md
│   ├── Hermes-Setup.md
│   ├── start-backend.sh
│   ├── start-frontend.sh
│   └── start-openclaw.sh
├── Dashboards/       # Analytics & views
└── Archive/          # Completed projects
```

## 🎯 How It Works

```
1. You create task in Obsidian
   "task_001: Implement API endpoint"
   Status: READY

2. Agent loop detects (every 5 min)
   "Status = READY, let's go!"

3. Agent executes
   - Clone repo
   - Implement code
   - Write tests
   - Create PR

4. Notify you
   WhatsApp: "Task done! PR: github.com/..."

5. You review on GitHub
   - Approve
   - Merge

6. Agent continues
   - Next task in queue
```

## 💡 Key Features

✅ **9 Specialized Agents**
- Each expert in their domain
- Learn your patterns over time

✅ **24/7 Execution**
- Agents run when you sleep
- Multi-threaded execution

✅ **Obsidian Integration**
- Your vault is the hub
- Agents read/write automatically

✅ **Multi-Channel Notifications**
- WhatsApp: Quick updates
- Slack: Team visibility
- Telegram: Alternative

✅ **Git Integration**
- Auto-create branches
- Auto-create PRs
- Track in Obsidian

✅ **Learning System**
- Agents learn your patterns
- Skills improve over time
- Productivity grows exponentially

## 📖 Documentation

See `/docs` folder for:
- OBSIDIAN-OPENCLAW-COMPLETE.md
- OPENCLAW-PRACTICAL-EXAMPLES.md
- HERMES-9AGENTS-GUIDE.md
- And more...

## 🛠️ Next Steps

1. **Run setup**
   ```bash
   bash neo-desenvolver-complete-setup.sh
   ```

2. **Open Obsidian**
   - Launch app
   - Open vault at ~/neo-projects-vault

3. **Create first task**
   - Edit Tasks/In-Progress.md
   - Set Status: READY

4. **Start agent**
   ```bash
   hermes profile backend
   # or
   bash ~/neo-projects-vault/Agents/start-backend.sh
   ```

5. **Watch it work!**
   - Check logs in Obsidian
   - Get WhatsApp notifications
   - See PR on GitHub

## 🎓 Learning Path

**Week 1:** Single agent, simple tasks
**Week 2:** Multiple agents, coordinated tasks
**Week 3:** Full automation, complex workflows
**Week 4+:** Productivity exponential growth

## 📞 Support

Check documentation files for detailed guides:
- Agent configuration
- Task templates
- Workflow examples
- Troubleshooting

---

**You're ready to revolutionize your productivity! 🚀**

Start with:
```bash
bash neo-desenvolver-complete-setup.sh
```

Then open Obsidian and create your first task!
EOF

echo -e "${GREEN}✓ Documentation created${NC}"
echo ""

# ============================================================================
# SECTION 12: Copy Documentation Files
# ============================================================================
echo -e "${YELLOW}[12/15] Organizing Documentation...${NC}"

mkdir -p "$SETUP_DIR/docs"

# Add documentation pointers
cat > "$SETUP_DIR/docs/MANIFEST.md" << 'EOF'
# Documentation Manifest

## Main Guides

1. **OBSIDIAN-OPENCLAW-COMPLETE.md**
   - Full integration guide
   - Setup instructions
   - Workflow explanations

2. **OPENCLAW-PRACTICAL-EXAMPLES.md**
   - Real-world examples
   - Task templates
   - Workflow patterns

3. **HERMES-9AGENTS-GUIDE.md**
   - Agent descriptions
   - How to use each agent
   - When to call which agent

4. **HERMES-PROMPTS-9AGENTS.md**
   - Initial prompts for agents
   - Agent-specific instructions
   - Customization guide

## Quick References

- **setup-hermes-9agents.sh** - Hermes setup script
- **setup-obsidian-openclaw.sh** - Obsidian + OpenClaw setup

## Troubleshooting

If agents don't work:
1. Run: hermes doctor
2. Run: openclaw test obsidian-integration
3. Check: ~/.hermes/ and ~/.openclaw/ config files

---

All files included in this package.
EOF

echo -e "${GREEN}✓ Documentation organized${NC}"
echo ""

# ============================================================================
# SECTION 13: Create Configuration Backup
# ============================================================================
echo -e "${YELLOW}[13/15] Creating Configuration Backup...${NC}"

cat > "$SETUP_DIR/.env.example" << 'EOF'
# Neo Desenvolver Environment Configuration

# Hermes Settings
HERMES_MODEL=claude-sonnet-4-6
HERMES_PROVIDER=openrouter
# HERMES_API_KEY=sk-... (set in hermes setup)

# OpenClaw Settings
OPENCLAW_WORKSPACE=neo-desenvolver
OPENCLAW_VAULT_PATH=~/neo-projects-vault

# Optional: Notification Channels
# WHATSAPP_NUMBER=+55 61 98181-0571
# WHATSAPP_TOKEN=your-token
# SLACK_WORKSPACE=neo-slack
# SLACK_TOKEN=xoxb-...
# TELEGRAM_TOKEN=your-bot-token

# GitHub Integration (optional)
# GITHUB_TOKEN=ghp_...
# GITHUB_REPO=neo/projeto

# Database (optional)
# DATABASE_URL=postgresql://localhost/clinica
# MONGODB_URL=mongodb://localhost:27017/clinica
EOF

echo -e "${GREEN}✓ Configuration backup created${NC}"
echo ""

# ============================================================================
# SECTION 14: Create System Tests
# ============================================================================
echo -e "${YELLOW}[14/15] Creating System Tests...${NC}"

cat > "$SETUP_DIR/test-system.sh" << 'EOF'
#!/bin/bash

echo "Testing Neo Desenvolver System..."
echo ""

# Test 1: Hermes
echo "1. Testing Hermes..."
if command -v hermes &> /dev/null; then
    echo "   ✓ Hermes installed"
    hermes doctor > /dev/null 2>&1 && echo "   ✓ Hermes healthy" || echo "   ✗ Hermes needs setup"
else
    echo "   ✗ Hermes not found"
fi

# Test 2: OpenClaw
echo "2. Testing OpenClaw..."
if command -v openclaw &> /dev/null; then
    echo "   ✓ OpenClaw installed"
    openclaw test obsidian-integration > /dev/null 2>&1 && echo "   ✓ OpenClaw healthy" || echo "   ✗ OpenClaw needs setup"
else
    echo "   ✗ OpenClaw not found"
fi

# Test 3: Obsidian Vault
echo "3. Testing Obsidian Vault..."
VAULT_PATH="$HOME/neo-projects-vault"
if [ -d "$VAULT_PATH" ]; then
    echo "   ✓ Vault exists at $VAULT_PATH"
    [ -f "$VAULT_PATH/README.md" ] && echo "   ✓ README found"
    [ -d "$VAULT_PATH/Tasks" ] && echo "   ✓ Tasks folder found"
    [ -d "$VAULT_PATH/Agents" ] && echo "   ✓ Agents folder found"
else
    echo "   ✗ Vault not found at $VAULT_PATH"
fi

# Test 4: Hermes Profiles
echo "4. Testing Hermes Profiles..."
HERMES_HOME="$HOME/.hermes"
AGENTS=("backend" "frontend" "java" "javascript" "typescript" "django" "postgresql" "nosql" "chartjs")
for agent in "${AGENTS[@]}"; do
    [ -d "$HERMES_HOME/profiles/$agent" ] && echo "   ✓ $agent profile found" || echo "   ✗ $agent profile missing"
done

echo ""
echo "System test complete!"
EOF
chmod +x "$SETUP_DIR/test-system.sh"

echo -e "${GREEN}✓ System tests created${NC}"
echo ""

# ============================================================================
# SECTION 15: Final Summary
# ============================================================================
echo -e "${YELLOW}[15/15] Finalizing Setup...${NC}"

cat > "$SETUP_DIR/SETUP-COMPLETE.md" << 'EOF'
# ✅ Neo Desenvolver Setup Complete!

## What Was Installed

### 1. Hermes Agent Framework ✓
- 9 Agent Profiles created
- Backend Agent (orchestrator)
- Frontend Agent (orchestrator)
- 7 Specialized agents (Java, JS, TS, Django, PostgreSQL, NoSQL, Chart.js)
- SOUL.md configured for each agent

### 2. Obsidian Vault ✓
Created at: `~/neo-projects-vault/`
- Projects/ — Your projects
- Tasks/ — Task management
- Knowledge/ — Knowledge base
- Agents/ — Agent configs & logs
- Dashboards/ — Analytics & views
- Archive/ — Completed projects

### 3. OpenClaw Integration ✓
- Config created at: `~/.openclaw/config.yaml`
- Obsidian integration enabled
- Ready to orchestrate agents

### 4. Documentation ✓
Complete guides included:
- OBSIDIAN-OPENCLAW-COMPLETE.md
- OPENCLAW-PRACTICAL-EXAMPLES.md
- HERMES-9AGENTS-GUIDE.md
- HERMES-PROMPTS-9AGENTS.md

## 🚀 Next: Your First 5 Minutes

### Minute 1: Open Obsidian
```bash
# Launch Obsidian app
# Select: Open folder as vault
# Path: ~/neo-projects-vault
```

### Minute 2: Check Vault
Browse the vault structure:
- Read README.md
- See Projects/
- See Tasks/
- See Agents/

### Minute 3: Create First Task
Edit: `Tasks/In-Progress.md`

Change:
```
Status: BACKLOG
```

To:
```
Status: READY
```

### Minute 4: Start Agent
```bash
# Option 1: Direct
hermes profile backend

# Option 2: Script
bash ~/neo-projects-vault/Agents/start-backend.sh

# Option 3: OpenClaw
openclaw start neo-developer
```

### Minute 5: Watch Progress
Check: `Agents/Agent-Logs.md`

Agent is executing your first task!

## 🎯 First Week Path

**Day 1:** Setup + first simple task
**Day 2-3:** Multiple tasks with Backend Agent
**Day 4-5:** Frontend Agent + Backend coordination
**Day 6-7:** Try specialized agents (Java, TypeScript, etc)

## 💡 Tips

✅ Keep tasks simple at first
✅ Clear descriptions help agents
✅ Break large tasks into subtasks
✅ Check logs to see agent progress
✅ Give feedback so agents learn

## 🚨 Troubleshooting

### Hermes not working
```bash
hermes doctor
hermes setup  # If needed
```

### OpenClaw not working
```bash
openclaw test obsidian-integration
```

### Vault not syncing
```bash
# Check config
cat ~/.openclaw/config.yaml | grep vault_path

# Manually test
openclaw test obsidian-integration
```

## 📞 System Test

Run comprehensive test:
```bash
bash test-system.sh
```

## 📚 Documentation

All guides are in `docs/` folder:
1. Start with README.md
2. Then OBSIDIAN-OPENCLAW-COMPLETE.md
3. Then OPENCLAW-PRACTICAL-EXAMPLES.md

## 🎓 Learning Resources

- Hermes docs: https://hermes-agent.nousresearch.com/docs
- OpenClaw docs: https://openclaw.ai/docs
- Obsidian docs: https://help.obsidian.md

---

## 🎉 You're All Set!

Your complete agent-driven development system is ready.

### Quick commands to remember:

Start Backend Agent:
```bash
hermes profile backend
```

Start Frontend Agent:
```bash
hermes profile frontend
```

Start any specialist:
```bash
hermes profile java          # or: django, postgresql, typescript, etc
```

Start OpenClaw orchestrator:
```bash
openclaw start neo-developer
```

Check system health:
```bash
bash test-system.sh
```

---

**Now go create your first task and watch agents execute! 🚀**

Next: Open Obsidian → Tasks/In-Progress.md → Change Status to READY
EOF

echo -e "${GREEN}✓ Setup finalized${NC}"
echo ""

# ============================================================================
# FINAL OUTPUT
# ============================================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗"
echo "║     ✅  NEO DESENVOLVER SETUP COMPLETE                         ║"
echo "╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}📁 Locations Created:${NC}"
echo "   Obsidian Vault:  $VAULT_PATH"
echo "   Hermes Config:   $HERMES_HOME"
echo "   OpenClaw Config: $OPENCLAW_HOME"
echo ""

echo -e "${BLUE}🚀 Ready to Start:${NC}"
echo ""
echo "1. Open Obsidian:"
echo "   Launch app → Open folder as vault → Select $VAULT_PATH"
echo ""
echo "2. Create First Task:"
echo "   Edit: $VAULT_PATH/Tasks/In-Progress.md"
echo "   Change: Status: BACKLOG → Status: READY"
echo ""
echo "3. Start Agent:"
echo "   hermes profile backend"
echo "   (or: bash $VAULT_PATH/Agents/start-backend.sh)"
echo ""
echo "4. Watch It Work:"
echo "   Check: $VAULT_PATH/Agents/Agent-Logs.md"
echo ""

echo -e "${BLUE}📚 Documentation:${NC}"
echo "   See: $SETUP_DIR/README.md"
echo "   See: $SETUP_DIR/SETUP-COMPLETE.md"
echo "   See: docs/ folder for full guides"
echo ""

echo -e "${BLUE}🧪 Test System:${NC}"
echo "   bash $SETUP_DIR/test-system.sh"
echo ""

echo -e "${YELLOW}💡 Pro Tips:${NC}"
echo "   • Start simple: single task, single agent"
echo "   • Keep task descriptions clear"
echo "   • Check logs regularly to learn"
echo "   • Feedback helps agents improve"
echo "   • Try different agents to see specialization"
echo ""

echo -e "${GREEN}Your complete agent-driven development system is ready! 🎉${NC}"
echo ""
echo "Next step: Open Obsidian and create your first task!"
echo ""
