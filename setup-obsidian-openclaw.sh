#!/bin/bash

set -e

echo "=========================================="
echo "Obsidian + OpenClaw Setup"
echo "Neo Desenvolver"
echo "=========================================="
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar dependências
echo -e "${YELLOW}[1/8] Verificando dependências...${NC}"

# Check if OpenClaw is installed
if ! command -v openclaw &> /dev/null; then
    echo "❌ OpenClaw não encontrado. Instalando..."
    curl -fsSL https://openclaw.ai/install.sh | bash
fi

# Check if Obsidian is installed
if ! command -v obsidian &> /dev/null && [ ! -d "/Applications/Obsidian.app" ] && [ ! -f "$HOME/.local/bin/obsidian" ]; then
    echo "⚠️  Obsidian não encontrado. Por favor, instale de https://obsidian.md"
    echo "   Continuando com Obsidian setup..."
fi

echo -e "${GREEN}✓ Dependências OK${NC}"
echo ""

# Criar estrutura Obsidian Vault
echo -e "${YELLOW}[2/8] Criando estrutura Obsidian Vault...${NC}"

VAULT_PATH="$HOME/neo-projects-vault"

mkdir -p "$VAULT_PATH"/{Projects,Tasks,Knowledge,Agents,Dashboards,Archive}

echo -e "${GREEN}✓ Vault criado em: $VAULT_PATH${NC}"
echo ""

# Criar README.md
echo -e "${YELLOW}[3/8] Criando README e estrutura...${NC}"

cat > "$VAULT_PATH/README.md" << 'EOF'
# Neo Desenvolver - Project Management Vault

Seu cérebro + OpenClaw Agents = Produtividade ⚡

## Estrutura

- **Projects** — Projetos ativos
- **Tasks** — Tarefas (Backlog, In Progress, Done)
- **Knowledge** — Knowledge base (patterns, docs, tips)
- **Agents** — Configuração e logs dos agents
- **Dashboards** — Views com Dataview
- **Archive** — Projetos completados

## Como Usar

1. Crie task em `Tasks/In-Progress.md`
2. Atribua a: `@openclaw`
3. Agent detecta e executa
4. Progress é atualizado em tempo real
5. WhatsApp/Slack notificam você

## Links Úteis

- [[Agents/Agent-Config]] — Configuração do OpenClaw
- [[Agents/Agent-Skills]] — Skills disponíveis
- [[Dashboards/Overview]] — Dashboard geral
- [[Knowledge/Getting-Started]] — Como começar

---

**Vault criado:** 2024-01-20
**OpenClaw Version:** Latest
**Status:** Ready for agents
EOF

echo -e "${GREEN}✓ README criado${NC}"
echo ""

# Criar Projects template
echo -e "${YELLOW}[4/8] Criando templates...${NC}"

cat > "$VAULT_PATH/Projects/Instituto-Seroto.md" << 'EOF'
# Instituto Seroto - Clinic Management System

## Project Status
- Status: IN_PROGRESS
- Start Date: 2024-01-15
- Target: 2024-06-30
- Progress: 20%

## Architecture
- Backend: FastAPI + PostgreSQL + Redis
- Frontend: React + TypeScript
- Infrastructure: Docker + GitHub Actions

## Quick Links
- [[#Database Design]]
- [[#API Endpoints]]
- [[#Frontend Components]]

## Database Design
**Status:** IN_PROGRESS
**Agent Task ID:** task_001
**Assigned to:** @openclaw

- [ ] Design schema (5 tables)
- [ ] Create migrations
- [ ] Add indexes
- [ ] Setup backup strategy

---

## API Endpoints
**Status:** READY
**Agent Task ID:** task_002
**Assigned to:** @openclaw

- [ ] Patient CRUD
- [ ] Doctor CRUD
- [ ] Appointment CRUD
- [ ] Authentication

---

## Frontend Components
**Status:** BACKLOG
**Agent Task ID:** task_003
**Assigned to:** @openclaw

- [ ] Patient management
- [ ] Doctor management
- [ ] Appointment scheduling
- [ ] Dashboard

---

## Progress Log

### 2024-01-20 09:15
Agent analyzed requirements and started Database Design.

### 2024-01-20 10:30
Database schema completed.
Status: ✓ DONE

[Agent logs will update here]
EOF

echo -e "${GREEN}✓ Project template criado${NC}"
echo ""

# Criar Tasks template
echo -e "${YELLOW}[5/8] Criando Tasks structure...${NC}"

cat > "$VAULT_PATH/Tasks/In-Progress.md" << 'EOF'
# In Progress Tasks

## task_001: Database Design - Instituto Seroto
- Assigned to: @openclaw
- Created: 2024-01-15
- Deadline: 2024-01-25
- Status: IN_PROGRESS
- Progress: 80%

**Description:**
Design database schema for clinic management system.

**Requirements:**
- [ ] Patients table (id, name, email, phone)
- [ ] Doctors table (id, name, specialty)
- [ ] Clinics table (id, name, address)
- [ ] Appointments table
- [ ] Prescriptions table
- [ ] Proper indexes
- [ ] Foreign key constraints

**Links:** [[Instituto-Seroto]]

---

[More tasks will be added here]
EOF

cat > "$VAULT_PATH/Tasks/Backlog.md" << 'EOF'
# Backlog Tasks

Add new tasks here with:
```
## task_XXX: Task Name - Project
- Assigned to: @openclaw
- Deadline: YYYY-MM-DD
- Priority: HIGH/MEDIUM/LOW

**Description:** ...
**Requirements:** ...
**Links:** [[Project-Name]]
```

Agent will detect and execute when you change status to IN_PROGRESS.
EOF

cat > "$VAULT_PATH/Tasks/Done.md" << 'EOF'
# Completed Tasks

Tasks automatically move here when agent completes them.

Format:
```
## task_XXX: Task Name ✓
- Completed: YYYY-MM-DD
- Time: 2h 30m
- PR: [link]

Summary of what was done.
```
EOF

echo -e "${GREEN}✓ Tasks structure criada${NC}"
echo ""

# Criar Agents configuration
echo -e "${YELLOW}[6/8] Criando Agents configuration...${NC}"

cat > "$VAULT_PATH/Agents/Agent-Config.md" << 'EOF'
# OpenClaw Agent Configuration

## Main Agent: neo-developer

### Model Settings
- Model: claude-sonnet-4-6
- Provider: OpenRouter
- Temperature: 0.7
- Max Tokens: 4000

### Memory
- Type: Obsidian-backed
- Location: ~/neo-projects-vault/Agents/memory.md
- Auto-save: Enabled (every 10k tokens)
- Compression: Enabled

### Enabled Skills
- ✓ obsidian:read - Read Obsidian files
- ✓ obsidian:write - Write to Obsidian
- ✓ git:clone - Clone repositories
- ✓ git:pull - Update code
- ✓ bash:execute - Run bash commands
- ✓ python:execute - Run Python scripts
- ✓ database:query - Execute SQL queries
- ✓ http:request - Make API calls

### Behavior
- Autonomy: Medium (auto-execute, ask on destructive ops)
- Error Handling: Auto-retry 3x, then escalate
- Notifications: On completion and errors only

### Channels
- Primary: Obsidian
- Optional: WhatsApp (+55 61 98181-0571)
- Optional: Slack
- Optional: Telegram

---

**Setup Status:** Ready
**Last Updated:** 2024-01-20
EOF

cat > "$VAULT_PATH/Agents/Agent-Skills.md" << 'EOF'
# Available Agent Skills

## Built-in Skills (100+ available)

### Code Execution
```bash
@openclaw execute_python "script.py"
@openclaw execute_bash "git pull && npm install"
@openclaw execute_node "script.js"
```

### Obsidian Operations
```bash
@openclaw read_obsidian "Projects/Instituto-Seroto.md"
@openclaw write_obsidian "Tasks/Done.md" "## task_001: Completed ✓"
@openclaw update_task "task_001" "status: DONE"
```

### Git Operations
```bash
@openclaw git_clone "https://github.com/neo/projeto.git"
@openclaw git_pull "~/neo-projects/projeto"
@openclaw git_commit --repo "~/repo" --message "msg" --push
```

### Database Operations
```bash
@openclaw db_query "postgresql://localhost/clinica" "SELECT ..."
@openclaw db_backup "postgresql://localhost/clinica"
```

---

[More skills will be discovered after setup]
EOF

cat > "$VAULT_PATH/Agents/Agent-Logs.md" << 'EOF'
# Agent Execution Logs

Auto-updated every 30 minutes by agent.

## Current Session

Agent waiting for tasks...

Check [[Tasks/In-Progress]] for assigned tasks.
EOF

echo -e "${GREEN}✓ Agent configuration criada${NC}"
echo ""

# Criar Dashboards
echo -e "${YELLOW}[7/8] Criando Dashboards...${NC}"

cat > "$VAULT_PATH/Dashboards/Overview.md" << 'EOF'
# Project Overview Dashboard

## Projects Status
| Project | Status | Progress | Deadline |
|---------|--------|----------|----------|
| Instituto Seroto | IN_PROGRESS | 20% | 2024-06-30 |
| Neo RH System | BACKLOG | 0% | TBD |

## Tasks Summary
- Total: 0
- Completed: 0
- In Progress: 0
- Ready: 0
- Backlog: 0

---

## Recent Activity
Check [[Agents/Agent-Logs]] for latest updates.

## Quick Actions
- Create new task: [[Tasks/In-Progress]]
- View projects: [[Projects]]
- Check knowledge: [[Knowledge]]
EOF

echo -e "${GREEN}✓ Dashboards criada${NC}"
echo ""

# Criar OpenClaw config
echo -e "${YELLOW}[8/8] Criando configuração OpenClaw...${NC}"

OPENCLAW_CONFIG="$HOME/.openclaw/config.yaml"
mkdir -p "$HOME/.openclaw"

cat > "$OPENCLAW_CONFIG" << EOF
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

# Optional: Channel Integrations
# channels:
#   whatsapp:
#     enabled: false
#     number: "+55 61 98181-0571"
#     token: "your-token-here"
#   slack:
#     enabled: false
#     workspace: "neo-slack"
#     token: "xoxb-..."
#   telegram:
#     enabled: false
#     token: "your-telegram-token"
EOF

echo -e "${GREEN}✓ OpenClaw config criada${NC}"
echo ""

# Final summary
echo -e "${GREEN}========== SETUP COMPLETO! ==========${NC}"
echo ""

echo -e "${BLUE}📁 Obsidian Vault criado em:${NC}"
echo "   $VAULT_PATH"
echo ""

echo -e "${BLUE}⚙️  OpenClaw config em:${NC}"
echo "   $OPENCLAW_CONFIG"
echo ""

echo -e "${YELLOW}🚀 Próximos Passos:${NC}"
echo ""
echo "1. Abrir Obsidian:"
echo "   - Abra Obsidian app"
echo "   - Clique 'Open folder as vault'"
echo "   - Selecione: $VAULT_PATH"
echo ""

echo "2. Validar OpenClaw:"
echo "   openclaw test obsidian-integration"
echo ""

echo "3. Start agent:"
echo "   openclaw start neo-developer"
echo ""

echo "4. Criar primeira tarefa:"
echo "   Abra $VAULT_PATH/Tasks/In-Progress.md"
echo "   Altere task_001 de BACKLOG para READY"
echo "   Agent vai detectar e executar!"
echo ""

echo -e "${YELLOW}📲 Optional: Setup Channels${NC}"
echo ""
echo "WhatsApp:"
echo "  openclaw channel add whatsapp --number '+55 61 98181-0571'"
echo ""
echo "Slack:"
echo "  openclaw channel add slack --token 'xoxb-...'"
echo ""
echo "Telegram:"
echo "  openclaw channel add telegram --token 'your-token'"
echo ""

echo -e "${YELLOW}📚 Documentação:${NC}"
echo "   Ver: OBSIDIAN-OPENCLAW-COMPLETE.md"
echo ""

echo -e "${GREEN}Tudo pronto! Vault + OpenClaw configurados! 🚀${NC}"
echo ""

# Criar quick start guide
cat > "$VAULT_PATH/Knowledge/Getting-Started.md" << 'EOF'
# Getting Started - OpenClaw + Obsidian

## 5 Minute Quick Start

### 1. Create a Task (1 min)
Open: `Tasks/In-Progress.md`

```
## task_001: My First Task
- Assigned to: @openclaw
- Deadline: YYYY-MM-DD
- Status: READY

**Description:** Do something awesome
```

### 2. Agent Detects It (30 sec)
Agent automatically detects `Status: READY` and starts.

### 3. Watch Progress (2 min)
Check: `Agents/Agent-Logs.md`

Agent is executing your task!

### 4. Get Updates (1 min)
Check WhatsApp/Slack/Telegram for notifications.

### 5. Review Results (30 sec)
When done, agent updates task status to `DONE`.

---

## Common Commands

```bash
# Start agent
openclaw start neo-developer

# Check status
openclaw status

# View logs
openclaw logs neo-developer

# Stop agent
openclaw stop
```

---

## Tips

✅ Assign tasks with: `@openclaw`
✅ Keep task format consistent
✅ Agent learns from feedback in comments
✅ Use GitHub integration for code review
✅ Setup channels for real-time updates

---

Good luck! 🚀
EOF

echo -e "${GREEN}✓ Getting Started guide criado${NC}"
