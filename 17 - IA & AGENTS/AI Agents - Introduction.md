---
type: conceito
status: ready
created: 2026-09-03
updated: 2026-09-03
tags: [conceito, agents, ia, ready]
related: []
---

# AI Agents — Introdução

Um **AI Agent** é um programa que pode tomar decisões, usar ferramentas e executar ações autonomamente.

---

## Diferença: Chatbot vs Agent

### Chatbot
- Responde pergunt as
- Não toma decisões
- Não executa ações

### Agent
- **Planeja** — O que fazer
- **Raciocina** — Como fazer
- **Executa** — Usa ferramentas
- **Itera** — Ajusta se necessário

---

## Componentes de um Agent

### 1. LLM (Language Model)
O "cérebro" — Claude, GPT-4, etc.
- Recebe prompt + contexto
- Raciocina
- Decide próximo passo

### 2. Tools (Ferramentas)
Ações que o agent pode executar:
- Ler arquivo
- Fazer requisição HTTP
- Executar código
- Acessar banco de dados

### 3. Memory (Memória)
Contexto e histórico:
- Conversas passadas
- Decisões tomadas
- Dados aprendidos

### 4. Planning (Planejamento)
Como atingir o objetivo:
- Break down em passos
- Sequência de ações
- Verificação de progresso

---

## Loop de Execução

```
1. User: "Crie um relatório de vendas de 2024"
   ↓
2. Agent raciocina: "Preciso ler dados, processar, gerar"
   ↓
3. Agent escolhe tool: "Ler arquivo Excel"
   ↓
4. Tool executa: Retorna dados
   ↓
5. Agent raciocina novamente: "Agora preciso processar"
   ↓
6. Agent escolhe tool: "Executar Python"
   ↓
7. Tool executa: Calcula totais
   ↓
8. Agent gera resposta: "Relatório pronto!"
```

---

## Tipos de Agents

### 1. **Specialized Agent**
Especializado em um domínio específico.
Exemplo: @backend agent sabe FastAPI, Django, Node.js

```
Input: "Crie endpoint em FastAPI com JWT"
Output: Código pronto com JWT integration
```

---

### 2. **Generalist Agent**
Genérico, pode fazer várias coisas.

```
Input: Qualquer tarefa técnica
Output: Tenta resolver com raciocínio
```

---

### 3. **Multi-Agent System**
Múltiplos agents trabalham juntos.

```
User → Frontend Agent → Backend Agent → Database Agent
                         ↓
                   Orquestrador coordena
```

---

## Hermes Agents (Seus Agents!)

Você tem **9 specialized agents**:

1. **@frontend** — React, HTML, CSS
2. **@backend** — FastAPI, Django, Flask, Node.js
3. **@java** — Spring Boot, JPA
4. **@javascript** — ES2022+, Async
5. **@typescript** — Generics, Advanced Types
6. **@django** — Django, DRF
7. **@postgresql** — Query optimization
8. **@nosql** — MongoDB
9. **@chartjs** — Data visualization

### Como Usar
```bash
hermes chat -q "@backend Crie endpoint para criar usuário" --oneshot
hermes chat -q "@postgresql Optimize esta query" --oneshot
```

---

## Casos de Uso

✅ **Desenvolvimento assistido** — Agents geram código  
✅ **Automação** — Executar tarefas repetitivas  
✅ **Análise** — Processar dados e gerar insights  
✅ **Troubleshooting** — Diagnosticar e corrigir problemas  
✅ **Documentação** — Gerar automàticamente  

---

## Limitações

⚠️ **Alucinações** — Agent pode inventar informações  
⚠️ **Contexto** — Precisa de contexto suficiente  
⚠️ **Custo** — Chamadas de API custam $  
⚠️ **Lentidão** — Múltiplas iterações levam tempo  

---

## Best Practices

### 1. Prompts Claros
```
❌ "Faça um relatório"
✅ "Gere relatório de vendas de 2024, agrupado por região"
```

### 2. Tools Apropriadas
Certifique-se que agent tem ferramentas certas.

### 3. Feedback Loop
Agent aprende com feedback:
```
Agent: "Tentei X, mas falhou"
You: "Tenta Y em vez disso"
Agent: Ajusta e tenta novamente
```

---

## Próximas Leituras

- [[Claude - Capabilities]] — O que Claude pode fazer
- [[Hermes Agents - System]] — Seus 9 agents
- [[17 - IA & AGENTS/]] — Mais sobre IA & Agents

---

**Status**: ready  
**Você tem**: Hermes system com 9 specialized agents!
