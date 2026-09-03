# Obsidian + OpenClaw - Agents Executando Projetos & Tarefas

Guia completo para integrar Obsidian com OpenClaw e deixar agents rodando seus projetos.

---

## 🏗️ Arquitetura

### **Obsidian Vault** (Seu cérebro)
- Notes sobre projetos
- Task management
- Knowledge base
- Tracking de progresso

### **OpenClaw Control Plane** (Orquestrador)
- Roda agents 24/7
- Lê e escreve no Obsidian
- Executa tarefas automaticamente
- Coordena entre múltiplos canais (WhatsApp, Slack, Telegram)

### **AgentSkills** (Ações)
- 100+ skills built-in
- Marketplace de community skills
- Custom skills personalizadas
- Integração com APIs

### **Workflow**
```
Obsidian (seu trabalho)
    ↓
OpenClaw (orquestra)
    ↓
Agents (executam)
    ↓
Obsidian (atualiza resultados)
```

---

## 🚀 Setup Completo (30 minutos)

### **Parte 1: Instalar OpenClaw (10 min)**

```bash
# Install OpenClaw (macOS/Linux)
curl -fsSL https://openclaw.ai/install.sh | bash

# Validar instalação
openclaw --version

# Setup inicial
openclaw setup
# Vai pedir:
# - API key (use OpenRouter ou Claude API)
# - Workspace name (recomendo: neo-desenvolver)
# - Padrão de notificação
```

---

### **Parte 2: Criar Obsidian Vault (10 min)**

#### **Opção A: Novo Vault**

```bash
# Criar pasta
mkdir ~/neo-projects-vault
cd ~/neo-projects-vault

# Iniciar Obsidian
# Abra Obsidian app → "Open folder as vault" → selecione ~/neo-projects-vault
```

#### **Opção B: Vault Estruturado**

Crie a estrutura:

```
neo-projects-vault/
├── 📁 Projects
│   ├── 📄 Instituto-Seroto.md
│   ├── 📄 Neo-RH-System.md
│   ├── 📄 Dropshipping.md
│   └── 📄 Café-Vinho.md
├── 📁 Tasks
│   ├── 📄 Backlog.md
│   ├── 📄 In-Progress.md
│   └── 📄 Done.md
├── 📁 Knowledge
│   ├── 📄 Java-Patterns.md
│   ├── 📄 API-Design.md
│   └── 📄 Performance-Tips.md
├── 📁 Agents
│   ├── 📄 Agent-Config.md
│   ├── 📄 Agent-Skills.md
│   └── 📄 Agent-Logs.md
└── 📄 README.md
```

---

### **Parte 3: Configurar OpenClaw (10 min)**

#### **1. Criar Agent Config**

```bash
openclaw agent create neo-developer \
  --model claude-sonnet-4-6 \
  --workspace neo-desenvolver
```

#### **2. Enable Obsidian Integration**

Crie `~/.openclaw/config.yaml`:

```yaml
workspace:
  name: neo-desenvolver
  model: claude-sonnet-4-6

integrations:
  obsidian:
    enabled: true
    vault_path: ~/neo-projects-vault
    auto_sync: true
    sync_interval: 300  # 5 min

agents:
  neo-developer:
    model: claude-sonnet-4-6
    memory:
      location: ~/neo-projects-vault/Agents/memory.md
      auto_save: true
    skills:
      enabled: true
      custom_dir: ~/neo-projects-vault/Agents/skills
    channels:
      - obsidian  # Primary channel
      - whatsapp  # Optional: 61 9 8181-0571
      - slack     # Optional

logging:
  level: info
  location: ~/neo-projects-vault/Agents/logs.md
```

#### **3. Connect Channels (Optional)**

```bash
# WhatsApp (seu número)
openclaw channel add whatsapp \
  --number "55 61 98181-0571" \
  --token "your-whatsapp-token"

# Slack
openclaw channel add slack \
  --token "your-slack-bot-token" \
  --workspace "neo-slack"

# Telegram
openclaw channel add telegram \
  --token "your-telegram-bot-token"
```

---

## 📝 Estrutura Obsidian para Agents

### **1. Projects/Instituto-Seroto.md**

```markdown
# Instituto Seroto - Clinic Management System

## Project Status
- Status: IN_PROGRESS
- Start Date: 2024-01-15
- Target: 2024-06-30

## Architecture
- Backend: FastAPI + PostgreSQL + Redis
- Frontend: React + TypeScript
- Infrastructure: Docker + GitHub Actions

## Tasks (Linked to Agent)
- [ ] [[#Database Design]] - Assigned to @openclaw
- [ ] [[#API Endpoints]] - Assigned to @openclaw
- [ ] [[#Frontend Components]] - Assigned to @openclaw

## Database Design
Status: IN_PROGRESS
Agent Task ID: task_001

### Schema
- [ ] Create tables: Patient, Doctor, Clinic, Appointment
- [ ] Foreign keys + constraints
- [ ] Indexes strategy
- [ ] Backup strategy

**Agent Notes:**
```query
SELECT * FROM patients WHERE clinic_id = $1;
```
- Query tá N+1. Precisamos select_related
- Index em clinic_id + created_at

## API Endpoints
Status: BACKLOG
Agent Task ID: task_002

### Patient CRUD
- [ ] GET /patients - list with pagination
- [ ] POST /patients - create
- [ ] PATCH /patients/:id - update
- [ ] DELETE /patients/:id - soft delete

## Frontend Components
Status: BACKLOG
Agent Task ID: task_003

### Patient Management
- [ ] PatientList component
- [ ] PatientForm component
- [ ] PatientDetail component
- [ ] Type-safe with TypeScript

## Agent Log
```
[2024-01-20 09:15] @openclaw analyzed schema
  - Detected N+1 in query
  - Suggested: add select_related, create index
  - Time: 2min

[2024-01-20 10:30] @openclaw implemented Database Design
  - Created schema with 5 tables
  - Added constraints + indexes
  - Status: ✓ DONE
```
```

---

### **2. Tasks/In-Progress.md**

```markdown
# In Progress Tasks

## task_001: Database Design - Instituto Seroto
- Assigned to: @openclaw (Backend Agent)
- Created: 2024-01-15
- Deadline: 2024-01-25
- Status: 60% done

**Description:**
Design database schema para clinic management system.

**Requirements:**
- [ ] Patients table
- [ ] Doctors table
- [ ] Clinics table
- [ ] Appointments table
- [ ] Prescriptions table
- [ ] Proper indexes
- [ ] Constraints + validation

**Agent Progress:**
- ✓ Schema designed
- ✓ Tables created
- ✓ Foreign keys added
- ⏳ Indexes being optimized
- ⏳ Backup strategy

**Links:** [[Instituto-Seroto]]

---

## task_002: API Endpoints - Instituto Seroto
- Assigned to: @openclaw (Backend Agent)
- Created: 2024-01-20
- Deadline: 2024-02-01
- Status: 0% done (PENDING)

**Description:**
Implement REST API endpoints for patient management.

**Requirements:**
- [ ] Patient CRUD endpoints
- [ ] Filtering & pagination
- [ ] Error handling
- [ ] Request validation
- [ ] API documentation
- [ ] Integration tests

**Agent Progress:**
- ⏳ Waiting for Database Design completion
- Will start: 2024-01-26

**Links:** [[Instituto-Seroto]]

---

## task_003: Frontend Components - Instituto Seroto
- Assigned to: @openclaw (Frontend Agent)
- Created: 2024-01-20
- Deadline: 2024-02-15
- Status: 0% done (BACKLOG)

**Description:**
Create reusable React components for patient management.

**Requirements:**
- [ ] PatientList component
- [ ] PatientForm component
- [ ] PatientDetail component
- [ ] Type-safe with TypeScript
- [ ] Unit tests with Jest
- [ ] Responsive design

**Links:** [[Instituto-Seroto]]
```

---

### **3. Agents/Agent-Config.md**

```markdown
# OpenClaw Agent Configuration

## Main Agent: neo-developer

### Model
- Model: claude-sonnet-4-6
- Provider: OpenRouter
- Temperature: 0.7
- Max tokens: 4000

### Memory
- Type: Obsidian-backed
- Location: ~/neo-projects-vault/Agents/memory.md
- Auto-save: Yes
- Compression: Every 10k tokens

### Skills Enabled
```
✓ obsidian:read - Ler arquivos Obsidian
✓ obsidian:write - Escrever em arquivos Obsidian
✓ git:clone - Clonar repositórios
✓ git:pull - Atualizar código
✓ git:commit - Fazer commits
✓ bash:execute - Rodar commands
✓ python:execute - Rodar scripts Python
✓ node:execute - Rodar scripts Node
✓ docker:run - Executar containers
✓ http:request - APIs chamadas
✓ database:query - Queries SQL
```

### Channels
- Primary: Obsidian (local)
- Secondary: WhatsApp (+55 61 98181-0571)
- Secondary: Slack (neo-slack workspace)
- Secondary: Telegram (@neo_developer_bot)

### Behavior
```
autonomy_level: medium
  - Execute tasks automatically
  - Ask for confirmation on destructive operations
  - Report progress to Obsidian every 30 min

error_handling: automatic_retry
  - Retry failed operations 3x
  - Escalate to human after 3 failures

notification_style: minimal
  - Only notify on task completion
  - Only escalate on errors
```

### Custom Skills Directory
Location: ~/neo-projects-vault/Agents/skills/

Example custom skills:
- neo-develop-backend.yaml
- neo-develop-frontend.yaml
- neo-optimize-queries.yaml
```

---

### **4. Agents/Agent-Skills.md**

```markdown
# Agent Skills & Commands

## Built-in Skills (100+ available)

### Code Execution
```bash
# Python
@openclaw execute_python "script.py"

# Node.js
@openclaw execute_node "script.js"

# Bash
@openclaw bash "git pull && npm install"
```

### Obsidian Operations
```bash
# Read file
@openclaw read_obsidian "Projects/Instituto-Seroto.md"

# Write/Append
@openclaw write_obsidian "Tasks/Done.md" "## Task Completed
- Task: X
- Time: 2h
- Status: ✓"

# Update status
@openclaw update_task "task_001" "status: DONE"
```

### Git Operations
```bash
# Clone repo
@openclaw git_clone "https://github.com/neo/instituto-seroto.git"

# Pull latest
@openclaw git_pull "~/neo-projects/instituto-seroto"

# Commit + Push
@openclaw git_commit \
  --repo "~/neo-projects/instituto-seroto" \
  --message "Implement database schema" \
  --push
```

### Database Operations
```bash
# Execute query
@openclaw db_query "postgresql://localhost/clinica" \
  "SELECT * FROM patients WHERE clinic_id = $1"

# Backup
@openclaw db_backup "postgresql://localhost/clinica"
```

## Custom Skills (Neo Develop)

### neo-develop-backend.yaml
```yaml
name: neo-develop-backend
description: Backend development tasks for Neo

commands:
  design_api:
    description: Design REST API endpoints
    action: |
      1. Read [[Projects/Instituto-Seroto]]
      2. Extract requirements
      3. Design endpoints
      4. Write to [[Tasks]]

  implement_endpoint:
    description: Implement specific endpoint
    params:
      - endpoint: string (e.g., "POST /patients")
      - project: string (reference to project)
    action: |
      1. Create service class
      2. Create controller
      3. Add validation
      4. Write tests
      5. Commit to git

  optimize_query:
    description: Optimize slow database query
    params:
      - query: string (SQL)
      - project: string
    action: |
      1. EXPLAIN ANALYZE query
      2. Identify bottleneck
      3. Suggest indexes
      4. Test improvements
      5. Document changes
```

### neo-develop-frontend.yaml
```yaml
name: neo-develop-frontend
description: Frontend development tasks for Neo

commands:
  create_component:
    description: Create React component
    params:
      - name: string (component name)
      - type: enum (Form, List, Detail)
      - project: string
    action: |
      1. Create component folder
      2. Component.tsx with TypeScript
      3. Component.test.tsx
      4. Component.stories.tsx
      5. Export from index.ts

  add_types:
    description: Add TypeScript types
    params:
      - entity: string (Patient, Doctor, etc)
      - project: string
    action: |
      1. Define interface
      2. Add discriminated unions if needed
      3. Create Zod schema for validation
      4. Export from types/index.ts
```
```

---

### **5. Agents/Agent-Logs.md**

Auto-updated por agent a cada 30 min.

```markdown
# Agent Execution Logs

## 2024-01-20

### 09:15 - Task Analysis
Agent started analyzing [[Instituto-Seroto]] project.
- Read project requirements
- Analyzed existing architecture
- Identified: Database schema needed first

### 09:45 - Database Design
Agent started task_001: Database Design
- Created 5 tables (Patients, Doctors, Clinics, Appointments, Prescriptions)
- Added constraints + indexes
- Generated SQL migration
- Status: ✓ COMPLETE

### 10:00 - Task Planning
Agent planned next tasks based on dependencies:
- task_002 ready to start (depends on Database Design ✓)
- task_003 ready to start in parallel

### 11:30 - Progress Report
```
Status Summary:
- Projects: 1 active
- Tasks: 3 total
  ✓ Completed: 1 (Database Design)
  ⏳ In Progress: 0
  ⏰ Ready: 2 (API Endpoints, Components)
  📋 Backlog: 0
```

### 14:00 - Next Steps Queued
Agent queued next tasks in order:
1. Implement API Endpoints (task_002)
2. Create Frontend Components (task_003)
3. Integration testing

**Next Agent Run:** 2024-01-21 09:00 (or manual trigger)
```

---

## 🔄 How It Works: Agent Loop

```
1. DETECT
   Agent reads Obsidian vault
   Finds tasks assigned to @openclaw
   Checks dependencies

2. PLAN
   Agent creates execution plan
   Breaks task into subtasks
   Estimates time

3. EXECUTE
   Agent runs code/commands
   Updates progress in real-time
   Handles errors

4. REPORT
   Agent writes results to Obsidian
   Updates task status
   Logs execution
   Notifies on channels (WhatsApp/Slack/etc)

5. LOOP
   Agent waits for next cycle
   Or triggers on manual command
   Or responds to channel messages
```

---

## 🎯 Workflows Práticos

### **Workflow 1: Auto-Implement Feature**

```
1. Você cria em Obsidian:
   [[Tasks/In-Progress.md]]
   
   ## task_004: Implement Patient Create Endpoint
   - Assigned to: @openclaw
   - Project: [[Instituto-Seroto]]
   - Status: READY

2. Agent detecta task novo:
   - Reads requirements
   - Checks dependencies (database ✓)
   - Starts implementation

3. Agent executa:
   - Create FastAPI endpoint
   - Add validation with Pydantic
   - Write unit tests
   - Commit to git

4. Agent reporta:
   - Obsidian: task_004 = ✓ DONE
   - WhatsApp: "Feature implementada! Link: github.com/..."
   - Slack: Post com link pro PR

5. Você:
   - Revisa PR no GitHub
   - Aprova
   - Merge

6. Agent:
   - Detecta merge
   - Deploy automático (se configurado)
   - Update task status
```

---

### **Workflow 2: Daily Standup Automático**

```bash
# Cria cron job:
openclaw schedule create "daily-standup" \
  --time "09:00" \
  --task "Generate daily standup from Obsidian"

# Agent executa:
1. Lê todos os projetos
2. Resume progresso
3. Identifica blockers
4. Envia:
   - WhatsApp: Quick summary
   - Slack: Detailed report
   - Obsidian: Daily log
```

---

### **Workflow 3: Continuous Learning**

```bash
# Setup learning agent:
openclaw schedule create "daily-learning" \
  --time "17:00" \
  --task "Learn from today's work"

# Agent:
1. Analisa commits de hoje
2. Identifica patterns/anti-patterns
3. Salva em [[Knowledge]]
4. Cria skills personalizadas
5. Melhora pra próximo dia
```

---

## 📲 Integração com Canais

### **WhatsApp (Seu celular)**

```
Você: @openclaw task_002 status?
Agent: Task: API Endpoints
       Status: Ready to start
       Time: ~8h
       Start? (Y/N)

Você: Y

Agent: Started API Endpoints task
       Progress: 10%
       ...
       [30 min depois]
       Progress: 50%
       ...
       [2h depois]
       ✓ COMPLETED
       Link: github.com/neo/instituto-seroto/pull/42
```

---

### **Slack (Team)**

```
Agent posts:
📊 Daily Standup - 2024-01-21

📈 Progress
- Instituto Seroto: 60% done
  ✓ Database Design (DONE)
  ⏳ API Endpoints (IN_PROGRESS - 50%)
  ⏰ Frontend (READY)

🚨 Blockers: None

👷 Today's work:
- Implemented 5 API endpoints
- Added 12 tests
- PR: github.com/...

📅 Tomorrow:
- Complete remaining endpoints
- Start frontend components
```

---

## 🛠️ Ferramentas & Extensões

### **Obsidian Plugins (Recomendados)**

```bash
# Instale via Obsidian Community Plugins:
- Dataview (view tasks dinamicamente)
- Tasks (manage tasks com status)
- Templater (templates automáticos)
- Calendar (ver tarefas por data)
- Project (view kanban de tasks)
- Git (sync automático)
- Excalidraw (diagramas)
```

### **GitHub Integration**

```yaml
# ~/.openclaw/github.yaml
repository: neo/instituto-seroto
auto_pr: true
auto_review: false  # Você revisa manualmente
commit_style: conventional

pull_request_template: |
  ## Task
  Closes #{{task_id}}
  
  ## Changes
  {{agent_summary}}
  
  ## Tests
  {{test_results}}
```

---

## 📊 Monitoring & Analytics

### **Task Dashboard** (em Obsidian)

Crie `Dashboards/Overview.md`:

```markdown
# Project Overview

## Status Geral
```dataview
TABLE status, progress, deadline
FROM "Projects"
WHERE status != "DONE"
SORT deadline ASC
```

## Tasks por Status
```dataview
TABLE project, status, assigned_to
FROM "Tasks"
GROUP BY status
```

## Agent Performance
```dataview
TABLE date, tasks_completed, total_time
FROM "Agents/logs"
WHERE date = dateformat(today, "yyyy-MM-dd")
```

## Velocity (últimas 2 semanas)
```dataview
TABLE week, tasks_completed, bugs_found
FROM "Agents/analytics"
SORT week DESC
LIMIT 2
```
```

---

## 🔐 Security & Safety

### **Agent Permissions**

```yaml
# ~/.openclaw/security.yaml
permissions:
  code_execution:
    enabled: true
    languages: [python, javascript, bash]
    directories: [~/neo-projects, ~/neo-projects-vault]
    block_directories: [/, /etc, /root]
  
  file_operations:
    enabled: true
    read_dirs: [~/neo-projects, ~/neo-projects-vault]
    write_dirs: [~/neo-projects, ~/neo-projects-vault]
    
  git_operations:
    enabled: true
    repositories: [neo/instituto-seroto, neo/neo-rh-system]
    allow_push: true
    require_review: false  # Você revisa em GitHub
    
  database_operations:
    enabled: true
    databases: [postgresql://localhost/clinica]
    allow_delete: false  # Never auto-delete
    allow_drop: false    # Never auto-drop tables
  
  network:
    enabled: true
    allowed_domains: [github.com, api.openai.com, api.anthropic.com]

approval_required_for:
  - database migrations
  - deleting files
  - pushing to main branch (deve usar PR)
  - deploying to production
```

---

## 🚀 Start Now (30 min total)

### **Step 1: Install OpenClaw (5 min)**
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
openclaw setup
```

### **Step 2: Create Obsidian Vault (10 min)**
```bash
mkdir ~/neo-projects-vault
# Open in Obsidian app
# Create folder structure from guide above
```

### **Step 3: Configure Integration (10 min)**
```bash
# Create ~/.openclaw/config.yaml (from guide)
# Configure Obsidian integration
# Test with: openclaw test obsidian-integration
```

### **Step 4: Create First Task (5 min)**
```
In Obsidian, create:
[[Tasks/In-Progress.md]]

## task_001: Simple Test
- Assigned to: @openclaw
- Status: READY

Agent will detect and execute automatically!
```

### **Step 5: Monitor Execution**
- Watch WhatsApp/Slack for updates
- Check Obsidian logs
- See agent progress in real-time

---

## 📚 Próximas Integrações

### **GitHub Actions**
```yaml
# .github/workflows/auto-deploy.yml
on:
  pull_request:
    branches: [main]

jobs:
  openclaw-review:
    runs-on: ubuntu-latest
    steps:
      - uses: openclaw/github-action@v1
        with:
          vault-path: ~/neo-projects-vault
          auto-review: false
```

### **Calendar Integration**
- Sync task deadlines com Google Calendar
- Agent suggestions de timeboxing
- Reminders via WhatsApp

### **Analytics**
- Weekly velocity charts
- Time tracking per project
- Learning progress visualization

---

**Obsidian + OpenClaw = Seu brain + Agents executando! 🚀**

Próximos passos: Comece instalando e crie seu primeiro vault!
