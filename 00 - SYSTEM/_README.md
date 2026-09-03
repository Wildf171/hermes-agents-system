# 📖 Guia do Vault — Como Usar Este Knowledge Base

**Bem-vindo!** Este é seu Knowledge Base pessoal de Engenharia de Software, organizado como um segundo cérebro para desenvolvimento profissional.

---

## 🎯 O Que É Este Vault?

Um repositório estruturado de conhecimento sobre:
- 📚 **Engenharia de Software** — Princípios, padrões, arquitetura
- 💻 **Desenvolvimento** — Backend, Frontend, Banco de Dados
- 🚀 **DevOps** — Deployment, CI-CD, Infrastructure
- 🤖 **IA & Agents** — Claude, Agents, Prompt Engineering
- 🏗️ **Seus Projetos** — Sistema André, RH, neo-clinica, Hermes
- 📝 **Decisões** — ADRs, checklists, troubleshooting

---

## 📁 Estrutura das Pastas

```
neo-projects-vault/
├── 00 - SYSTEM/          ← Sistema (você está aqui)
│   ├── _Dashboard.md     ← Comece por aqui!
│   ├── _README.md        ← Este arquivo
│   ├── Templates/        ← Templates padronizados
│   └── Obsidian/         ← Dicas de uso do Obsidian
├── 01 - MOC/             ← Mapas de conteúdo (navegação)
├── 03 - ENGENHARIA/      ← SOLID, Patterns, Clean Code
├── 04 - PROGRAMACAO/     ← Python, JS, TS, Java
├── 05 - ARQUITETURA/     ← Clean Arch, DDD, Microservices
├── 07 - BACKEND/         ← FastAPI, Django, Flask, Node
├── 08 - FRONTEND/        ← React, HTML, CSS
├── 09 - BANCO DE DADOS/  ← PostgreSQL, MongoDB, Redis
├── 13 - DEVOPS/          ← Docker, K8s, CI-CD
├── 17 - IA & AGENTS/     ← Claude, Hermes, Agents
├── 20 - PROJETOS/        ← Seus 4 sistemas
├── 21 - ADR/             ← Decisions (Architecture Decision Records)
├── 23 - CHECKLISTS/      ← Workflows & checklists
└── 99 - INBOX/           ← Captura rápida (processar depois)
```

**Padrão**: Pastas numeradas (00-99) para ordenação alfabética clara.

---

## 🚀 Como Começar

### 1️⃣ Primeiro: Dashboard
Abra [[_Dashboard]] para ver navegação rápida e progresso.

### 2️⃣ Segundo: MOC Master
Abra [[01 - MOC/_MOC-Master]] para ver o mapa completo de conteúdo.

### 3️⃣ Terceiro: Escolha um Tópico
Clique em uma MOC temática (ex: MOC - Backend) e comece a explorar.

### 4️⃣ Capturar Ideias
Quando tiver uma ideia/artigo/código:
1. Vá para [[99 - INBOX/Notas Rápidas]]
2. Capture a ideia rapidamente
3. **DEPOIS** processa (move para pasta apropriada)

---

## 📝 Como Adicionar Conteúdo

### Método 1: Use Templates
1. Abra a pasta apropriada (ex: 07 - BACKEND/)
2. Crie novo arquivo
3. Use o template correspondente (ex: Template - Conceito)
4. Preencha os campos

### Método 2: Capture no Inbox
1. Vá para [[99 - INBOX/]]
2. Capture a ideia/artigo/link
3. **DEPOIS** quando tiver tempo, processa e move para a pasta correta

### Método 3: A partir de uma MOC
1. Abra uma MOC temática
2. Veja o que está faltando
3. Crie novo documento
4. Linkue na MOC

---

## 🏷️ Sistema de Tags

Todos os documentos usam tags padrão para fácil descoberta:

### Por Tipo
- `#conceito` — Explicações teóricas
- `#projeto` — Seus sistemas
- `#padrão` — Design patterns
- `#ferramenta` — Tools, IDEs, bibliotecas
- `#adr` — Decisions

### Por Tecnologia
- `#python`, `#javascript`, `#typescript`, `#java`, `#go`
- `#fastapi`, `#django`, `#flask`, `#node`
- `#react`, `#html`, `#css`
- `#postgresql`, `#mongodb`, `#redis`
- `#docker`, `#kubernetes`, `#cicd`
- `#claude`, `#agents`

### Por Status
- `#draft` — Rascunho, incompleto
- `#ready` — Pronto para usar
- `#review` — Em revisão
- `#deprecated` — Obsoleto

---

## 🔗 Linking — O Poder Do Obsidian

Use `[[]]` para criar links internos:

```markdown
Ver também [[SOLID Principles]] e [[Design Patterns]]

Para FastAPI, leia [[07 - BACKEND/FastAPI]]

Projeto relacionado: [[20 - PROJETOS/Sistema André]]
```

**Por quê?** Obsidian usa esses links para criar graph view e você vê conexões entre conceitos.

---

## 🗺️ Mapas de Conteúdo (MOCs)

MOCs são **índices temáticos** que conectam documentos relacionados.

Exemplo — MOC - Backend:
```
## Backend Frameworks
- [[07 - BACKEND/FastAPI/]]
- [[07 - BACKEND/Django/]]
- [[07 - BACKEND/Flask/]]

## Padrões
- [[Repository Pattern]]
- [[Service Layer]]

## Banco de Dados
- Veja [[MOC - Banco de Dados]]
```

**Use MOCs** para navegar por tema ao invés de procurar pasta por pasta.

---

## ✅ Checklists & ADRs

### Checklists
Use quando precisa de workflow passo-a-passo:
- Deploy Checklist
- Code Review Checklist
- Refactoring Checklist

Abra [[23 - CHECKLISTS/]] e escolha.

### ADRs (Architecture Decision Records)
Use quando toma decisão importante:
- "Por que usar FastAPI e não Django?"
- "Por que PostgreSQL ao invés de MongoDB?"

Use [[Template - ADR]] para documentar.

---

## 🔍 Encontrando Coisas

### Opção 1: Busca (Ctrl+Shift+F)
Procure por palavra-chave, vai encontrar em todos os arquivos.

### Opção 2: Graph View
Abra o graph view para VER as conexões entre documentos visualmente.

### Opção 3: Links Saintes
Clique em um documento e veja todos os links saindo dele → descubra documentos relacionados.

### Opção 4: MOCs
Simplesmente navegue pelo MOC temático apropriado.

---

## 💻 Dicas de Obsidian

### Abra Dashboard Automaticamente
1. Vá em Configurações → Iniciar
2. Abra arquivo → `00 - SYSTEM/_Dashboard.md`

### Use Templates
1. Vá em Configurações → Templates
2. Aponte para pasta: `00 - SYSTEM/Templates/`
3. Crie novo arquivo → Use template

### Customize Hotkeys
Sugeridos:
- `Ctrl+Shift+N` — Novo conceito
- `Ctrl+Shift+P` — Novo projeto
- `Ctrl+Shift+I` — Novo no inbox

### Habilite Plugins
Recomendados:
- **Graph View** — Ver conexões (já vem enabled)
- **Backlinks** — Ver quem linka para este doc
- **Outline** — Ver estrutura do documento
- **Search** — Busca avançada

---

## 📊 Fases do Vault

### FASE 1 ✅ — Auditoria
Análise do que existe (5 documentos, 1 pasta).

### FASE 2 ✅ — Proposta
Desenho final da arquitetura (26 pastas, 10 MOCs).

### FASE 3 🔄 — Criar Estrutura
Criar pastas, templates, MOCs base (você está aqui).

### FASE 4 — Preencher MOCs
Popular MOCs com documentos base.

### FASE 5 — Organizar
Mover 5 documentos existentes para pastas certas.

### FASE 6-8 — Finalizar
Corrigir links, verificar duplicações, relatório final.

---

## 🎯 Meta

Transformar este vault em um **Knowledge Base profissional** com:
- ✅ 200+ documentos bem organizados
- ✅ 10 MOCs temáticas funcionais
- ✅ Sistema de tags consistente
- ✅ Links internos em tudo
- ✅ Pronto para ser consultado por Agents IA

---

## 📞 Precisa de Ajuda?

1. **Estrutura não está clara?** → Leia [[00 - SYSTEM/_Dashboard]]
2. **Não sabe onde colocar algo?** → Capture em [[99 - INBOX/]]
3. **Quer adicionar novo tópico?** → Use [[Template - Conceito]]
4. **Confuso sobre navegação?** → Consulte [[01 - MOC/_MOC-Master]]

---

**Bem-vindo ao seu Knowledge Base de Engenharia de Software!** 🚀

*Comece pelo Dashboard, explore as MOCs, e comece a adicionar conhecimento continuamente.*
