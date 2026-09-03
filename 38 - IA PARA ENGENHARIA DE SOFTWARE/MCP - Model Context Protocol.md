---
title: "MCP - Model Context Protocol"
category: "38 - IA PARA ENGENHARIA DE SOFTWARE"
tags:
  - engenharia-software
  - ia
  - mcp
  - agents
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# MCP — Model Context Protocol

## Resumo

O **Model Context Protocol (MCP)** é um **padrão aberto** criado pela **Anthropic** (introduzido em **25/11/2024**) para **padronizar como sistemas de IA (LLMs) se conectam a ferramentas, sistemas e fontes de dados externos**. É frequentemente descrito como o "USB-C da integração de IA": uma interface única em vez de conectores sob medida para cada fonte.

## O que é?

Uma interface padronizada para **ler arquivos, executar funções e fornecer contexto** a um LLM. Resolve o problema **"N×M"**: sem MCP, cada aplicação de IA (N) precisava de um conector próprio para cada ferramenta/dado (M). Com MCP, cada lado implementa o padrão uma vez.

Reaproveita ideias de fluxo de mensagens do **Language Server Protocol (LSP)** — assim como o LSP padronizou editores × linguagens, o MCP padroniza agentes × ferramentas.

## Por que existe?

- Elimina **silos de informação** e integrações frágeis e duplicadas.
- Anteriores (function calling da OpenAI em 2023, plugins do ChatGPT) resolviam parcialmente, mas exigiam **conectores específicos por fornecedor**.
- Foi **adotado por outros grandes** (OpenAI, Google DeepMind) e, em **dezembro de 2025**, doado à **Agentic AI Foundation** (fundo sob a Linux Foundation, co-fundado por Anthropic, Block e OpenAI).

## Como funciona? — Arquitetura

Três papéis:
- **MCP Host** — a aplicação/agente de IA que interage com o LLM (ex.: Claude Desktop, um IDE, o Claude Code).
- **MCP Client** — vive no host e mantém a conexão com um servidor.
- **MCP Server** — expõe recursos ao modelo, de forma padronizada.

### Primitivas expostas por um servidor MCP
- **Tools** — funções que o modelo pode executar (ex.: consultar banco, chamar API).
- **Resources** — dados/arquivos que o modelo pode ler.
- **Prompts** — templates de prompt reutilizáveis.

## Exemplo prático

- Um **servidor MCP de banco de dados** permite ao agente consultar tabelas em linguagem natural.
- Servidores MCP comuns: filesystem, GitHub, Slack, Postgres, browser — o host conecta e o modelo passa a "enxergar" essas ferramentas de forma uniforme.
- Companheiro: **Agent Skills** (Anthropic, dez/2025) — padrão aberto para empacotar instruções/recursos que agentes carregam sob demanda.

## Quando utilizar

- Conectar um agente/assistente a **ferramentas e dados reais** (arquivos, APIs, bancos) de forma padronizada e reutilizável.
- Construir integrações que funcionem em **múltiplos hosts** de IA.

## Quando NÃO utilizar (nuance)

- Interações simples de um único prompt sem ferramentas não precisam de MCP.
- Para uma integração única e trivial, um function-calling direto pode bastar (mas MCP dá padronização/reuso).

## Trade-offs

- **Ganha:** padronização, reuso, ecossistema crescente, evita lock-in de conectores.
- **Perde:** camada extra a operar; segurança dos servidores MCP precisa de atenção.

## Erros comuns / Anti-patterns

- Expor servidores MCP com **permissões amplas demais** (um servidor com acesso a tudo é risco).
- Confiar em conteúdo retornado por servidores/ferramentas como se fosse instrução confiável (**prompt injection** via dados) — tratar como dado, não comando.
- Não isolar/segredar credenciais usadas pelos servidores.

## Boas práticas

- **Menor privilégio** por servidor MCP; escopos claros.
- Tratar saídas de ferramentas como **dados não confiáveis**.
- Auditoria/observabilidade das ações do agente.

## Conceitos relacionados

- [[AI Agents - Introduction]]
- [[AI Coding Agents]]
- [[LLMs - Fundamentos]]
- [[Claude - Capabilities]]
- [[Hermes/System-Overview|Hermes Agents]]

## Perguntas importantes

### Que problema o MCP resolve?
O problema **N×M** de integração: em vez de um conector sob medida para cada par (aplicação de IA × ferramenta), todos implementam **um padrão comum**.

### Quem criou e mantém o MCP?
Criado pela **Anthropic** (2024, engenheiros David Soria Parra e Justin Spahr-Summers); em 2025 foi doado à **Agentic AI Foundation** (Linux Foundation). Adotado também por OpenAI e Google.

## Fontes

1. Wikipedia — Model Context Protocol — https://en.wikipedia.org/wiki/Model_Context_Protocol (consultado 2026-09-03)
2. modelcontextprotocol.io — especificação oficial — https://modelcontextprotocol.io
3. Anthropic — anúncio do MCP (nov/2024).

## Observações

Criar notas: construir um servidor MCP, segurança de MCP, Agent Skills. Status: verified (datas e arquitetura confirmadas na fonte).
