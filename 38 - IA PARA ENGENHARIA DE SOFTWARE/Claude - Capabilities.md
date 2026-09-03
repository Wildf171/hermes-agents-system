---
type: conceito
status: ready
created: 2026-09-03
updated: 2026-09-03
tags: [conceito, claude, ia, ready]
related: []
---

# Claude — Capabilities

Claude é um **assistente IA** desenvolvido pela Anthropic com capacidades de raciocínio, análise e criação de conteúdo.

---

## Versões de Claude

### Claude 3 Family (Current)
- **Claude 3 Opus** — Mais poderoso, melhor raciocínio
- **Claude 3 Sonnet** — Balanceado (velocidade + capacidade)
- **Claude 3 Haiku** — Rápido e barato

**Recomendado para desenvolvimento**: Claude 3 Sonnet (melhor balanço)

---

## Capacidades Principais

### 1. Análise & Síntese
Claude pode:
- Resumir textos longos
- Analisar documentos
- Identificar padrões
- Sintetizar informações

```
"Analise este código Python e identifique problemas de segurança"
"Resuma este artigo em 3 pontos principais"
```

---

### 2. Criação de Código
Claude pode:
- Gerar código em múltiplas linguagens
- Corrigir bugs
- Refatorar código
- Explicar código

```
"Crie uma função Python para validar email"
"Por que este código está lento?"
"Refatore isto para ser mais legível"
```

---

### 3. Reasoning & Problem Solving
Claude pode:
- Resolver problemas matemáticos
- Raciocinar sobre lógica complexa
- Fazer planejamento
- Análise crítica

```
"Qual é a melhor arquitetura para isto?"
"Ajude-me a planejar este projeto"
"Analise as tradeoffs entre X e Y"
```

---

### 4. Conversação & Diálogo
Claude pode:
- Manter conversação contextual
- Responder follow-up questions
- Esclarecer ambiguidades

---

## Limites Importantes

⚠️ **Knowledge Cutoff**: Conhecimento até April 2024  
⚠️ **Token Limit**: Claude 3 Opus = 200K tokens (~150K palavras)  
⚠️ **Sem acesso à internet**: Não pode buscar dados reais  
⚠️ **Sem memória**: Cada conversa é independente  

---

## Token Limits

### Estimativa
- 1 token ≈ 4 caracteres
- 1 token ≈ 0.75 palavras
- 200K tokens ≈ 150K palavras ≈ 500 páginas

```
# Exemplo
"Hello, how are you?" = ~5 tokens
Um parágrafo = ~100 tokens
Este documento = ~400 tokens
```

---

## Use Cases Ideais

✅ **Análise de código** — Revisar, debugar, refatorar  
✅ **Documentação** — Gerar, melhorar, traduzir  
✅ **Brainstorming** — Ideias, planejamento, design  
✅ **Aprendizado** — Explicar conceitos  
✅ **Escrita** — Conteúdo, emails, respostas  

---

## Use Cases NÃO Ideais

❌ **Dados sensíveis** — Não compartilhe senhas, tokens  
❌ **Código proprietary** — Se não pode compartilhar em GitHub  
❌ **Legal/médico** — Não é substituto para especialista  
❌ **Real-time data** — Não acessa internet  

---

## Dicas Para Bom Prompting

### 1. Seja Específico
```
❌ "Ajude com código"
✅ "Crie uma função Python que valida CPF com regex"
```

### 2. Dê Contexto
```
❌ "Por que está lento?"
✅ "Tenho uma query SQL que lê 50M de linhas, por que está lenta?"
```

### 3. Formato da Resposta
```
"Responda em formato de checklist"
"Explique como se eu fosse iniciante"
"Use exemplos de código"
```

### 4. Iteração
```
Claude responde
"Explique melhor o ponto X"
"Mostre um exemplo diferente"
"Agora fiz assim, está correto?"
```

---

## Próximas Leituras

- [[Prompt Engineering - Best Practices]] — Como fazer prompts melhores
- [[AI Agents - Introduction]] — Agents com Claude
- [[17 - IA & AGENTS/]] — Mais sobre IA

---

**Status**: ready  
**Usado em**: Claude Code, Hermes Agents, seus projetos!
