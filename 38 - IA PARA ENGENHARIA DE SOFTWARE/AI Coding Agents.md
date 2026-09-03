---
title: "AI Coding Agents"
category: "38 - IA PARA ENGENHARIA DE SOFTWARE"
tags:
  - engenharia-software
  - ia
  - agents
  - coding-agents
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# AI Coding Agents

## Resumo

**Coding agents** são [[AI Agents - Introduction|agentes de IA]] especializados em **tarefas de desenvolvimento**: leem o repositório, escrevem e editam código, rodam comandos/testes, corrigem erros e iteram até concluir a tarefa — de forma autônoma ou semiautônoma. Exemplos: **Claude Code**, Cursor, GitHub Copilot (modo agente), Aider, Devin.

## O que é?

Diferente de um autocompletar (que sugere a próxima linha), um coding agent opera em **loop agêntico**: recebe um objetivo, **planeja**, usa **ferramentas** (ler/editar arquivos, executar shell, buscar), observa o resultado e **itera**. Muitos se integram via [[MCP - Model Context Protocol|MCP]] a ferramentas e dados.

## Por que existe?

Acelerar e ampliar o trabalho de engenharia: automatizar tarefas repetitivas, navegar bases grandes, gerar boilerplate/testes, refatorar, diagnosticar bugs — deixando o humano focar em decisões e revisão.

## Como funciona? — Loop agêntico

```
Objetivo → [Planejar] → [Agir: editar arquivo / rodar teste / buscar]
        → [Observar resultado] → [Refinar] → ... → Concluir
```

Capacidades típicas:
- **Contexto do repositório** — lê múltiplos arquivos, entende a estrutura.
- **Ferramentas** — filesystem, shell, git, execução de testes, web/MCP.
- **Autoverificação** — roda testes/linters e corrige com base no feedback.
- **Multi-arquivo** — muda vários arquivos de forma coordenada.

## Espectro de autonomia

- **Assistente/autocomplete** (Copilot clássico) — sugere, humano decide.
- **Pair/chat no IDE** (Cursor, Copilot Chat) — conversa e aplica edições.
- **Agente autônomo** (Claude Code, Devin) — executa tarefas ponta a ponta com supervisão.

## Exemplo prático

- "Adicione paginação ao endpoint `/pedidos` e escreva os testes": o agente localiza o handler, edita o código, cria testes, roda `pytest`, corrige falhas e mostra o diff para revisão.
- Este próprio vault foi construído por um coding agent (Claude Code) pesquisando e escrevendo notas.

## Quando utilizar

- Tarefas bem definidas: features incrementais, refatorações, testes, correções, migrações.
- Exploração de bases desconhecidas; geração de boilerplate/documentação.

## Quando NÃO utilizar (com cautela)

- Decisões de **arquitetura** de alto impacto sem revisão humana.
- Código crítico/sensível sem revisão rigorosa (o agente pode errar/alucinar).
- Contextos onde não se pode revisar/testar a saída.

## Trade-offs

- **Ganha:** velocidade, cobertura, menos trabalho repetitivo.
- **Perde:** risco de bugs sutis/alucinação, custo de tokens, dependência de boa supervisão e testes.

## Erros comuns / Anti-patterns

- **Aceitar código sem revisar** ("vibe coding" sem verificação).
- Deixar o agente rodar comandos destrutivos sem sandbox/aprovação.
- Falta de testes → sem rede de segurança para o que o agente muda.
- Tratar saída de ferramentas/web como confiável (**prompt injection**).

## Boas práticas

- **Sempre revisar** o diff; manter humano no loop para decisões.
- Boa suíte de [[Testes - Fundamentos e Piramide|testes]] + [[Git - Fundamentos|Git]] (commits pequenos, fácil reverter).
- Permissões/sandbox para comandos; princípio de menor privilégio.
- Dar contexto claro (objetivo, restrições) — bom [[Prompt Engineering|prompt/context engineering]].
- Usar [[MCP - Model Context Protocol|MCP]] para ferramentas padronizadas e auditáveis.

## Conceitos relacionados

- [[AI Agents - Introduction]]
- [[MCP - Model Context Protocol]]
- [[LLMs - Fundamentos]]
- [[Prompt Engineering]]
- [[Hermes/System-Overview|Hermes Agents]]
- [[Claude - Capabilities]]

## Perguntas importantes

### Qual a diferença entre autocomplete e coding agent?
Autocomplete sugere a próxima linha; um coding agent executa **tarefas completas** em loop (planeja, edita vários arquivos, roda testes, corrige) com ferramentas.

### Posso confiar no código gerado?
Trate como código de um colega júnior competente: **revise e teste sempre**. O agente acelera, mas a responsabilidade pela qualidade continua humana.

## Fontes

1. Anthropic — Claude Code / Building agents — https://docs.anthropic.com
2. Wikipedia — Model Context Protocol — https://en.wikipedia.org/wiki/Model_Context_Protocol (consultado 2026-09-03)
3. Anthropic — "Building effective agents" (2024).

## Observações

Campo em evolução rápida; ferramentas e capacidades mudam. Aprofundar: padrões de agentes, avaliação, segurança de agentes. Status: verified (conceitos estáveis; exemplos de produtos podem mudar).
