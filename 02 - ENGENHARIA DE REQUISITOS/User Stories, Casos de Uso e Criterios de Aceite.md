---
title: "User Stories, Casos de Uso e Critérios de Aceite"
category: "02 - ENGENHARIA DE REQUISITOS"
tags:
  - engenharia-software
  - requisitos
  - user-story
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# User Stories, Casos de Uso e Critérios de Aceite

## Resumo

Formas de **especificar requisitos funcionais**: **user stories** (leves, ágeis, focadas em conversa), **casos de uso** (fluxos de interação mais detalhados) e **critérios de aceite** (as condições que confirmam que o requisito foi atendido). Cada um serve a um contexto.

## User Stories

Descrição **informal, em linguagem natural**, de uma funcionalidade do ponto de vista do **usuário**. Introduzidas por **Kent Beck** no XP (projeto C3 da Chrysler, 1997/1999); referência: *User Stories Applied* de **Mike Cohn** (2004).

### Formato (Connextra, 2001)
```
Como <tipo de usuário>,
Quero <uma ação/objetivo>,
Para que <um benefício/valor>.
```
Ex.: *"Como cliente, quero cancelar um pedido, para que eu não pague por algo que não quero mais."*

### Os "Três C's" (Ron Jeffries, 2001)
- **Card** — o registro curto (post-it/card): lembrete, não especificação completa.
- **Conversation** — a conversa entre stakeholders que detalha a história ("uma história é uma promessa de conversa" — Cockburn).
- **Confirmation** — os **critérios de aceite** que confirmam que está pronta.

### INVEST (boa user story — Bill Wake)
**I**ndependent, **N**egotiable, **V**aluable, **E**stimable, **S**mall, **T**estable.

### Épico vs Story vs Task
- **Épico** — grande, quebrado em várias stories.
- **Story** — cabe em um sprint, entrega valor.
- **Task** — passo técnico de uma story.

## Casos de Uso

Descrição mais **estruturada** de como um **ator** interage com o sistema para atingir um objetivo — com fluxo principal e alternativos. Popularizados por Ivar Jacobson; associados a [[04 - MODELAGEM/_INDEX|UML]].

```
Caso de uso: Cancelar Pedido
Ator: Cliente
Fluxo principal:
  1. Cliente seleciona o pedido
  2. Sistema verifica se é cancelável
  3. Cliente confirma
  4. Sistema cancela e notifica
Fluxos alternativos:
  2a. Pedido já enviado → sistema recusa e informa
```
Mais adequado quando o comportamento tem muitos passos/exceções.

## Critérios de Aceite

Condições **objetivas e testáveis** que definem quando a história está "pronta" (satisfaz o requisito). Base para testes de aceitação ([[TDD - Test-Driven Development|ATDD/BDD]]).

### Formato Gherkin (Given-When-Then / BDD)
```gherkin
Cenário: Cancelar pedido não enviado
  Dado que tenho um pedido com status "pendente"
  Quando eu solicito o cancelamento
  Então o pedido muda para "cancelado"
  E eu recebo um e-mail de confirmação
```

## Definition of Ready vs Definition of Done

- **DoR** — critérios para uma story **entrar** no sprint (clara, estimada, com critérios de aceite).
- **DoD** — critérios para considerá-la **concluída** (código + testes + revisão + deploy).

## User Story vs Caso de Uso — quando usar

| | User Story | Caso de Uso |
|---|---|---|
| Detalhe | Leve (conversa) | Estruturado (fluxos) |
| Contexto | Ágil, backlog | Sistemas complexos/regulados |
| Foco | Valor ao usuário | Interação passo a passo |

## Quando utilizar

- **User stories:** a maioria dos times ágeis; requisitos incrementais.
- **Casos de uso:** interações complexas, muitos fluxos de exceção, contexto formal.
- **Critérios de aceite:** sempre — tornam o requisito testável.

## Erros comuns / Anti-patterns

- Story sem valor ("como dev, quero refatorar" — não é user story).
- Story gigante que não cabe no sprint (viola INVEST "Small").
- Sem critérios de aceite → "pronto" ambíguo.
- Tratar o card como especificação completa (esquecer a **conversa**).
- Critérios não testáveis.

## Boas práticas

- Aplicar **INVEST**; quebrar épicos em stories pequenas.
- Sempre com **critérios de aceite** (Gherkin ajuda).
- A story é um lembrete para **conversar**, não um contrato detalhado.
- Ligar critérios de aceite a testes automatizados ([[Testes - Fundamentos e Piramide]]).

## Conceitos relacionados

- [[Engenharia de Requisitos - Fundamentos]]
- [[Elicitacao de Requisitos]]
- [[Requisitos Nao Funcionais]]
- [[TDD - Test-Driven Development]] (ATDD/BDD)
- [[03 - PROCESSOS E METODOLOGIAS/_INDEX|Processos (Scrum)]]

## Perguntas importantes

### Qual o formato de uma user story?
"Como \<usuário\>, quero \<ação\>, para que \<benefício\>." Acompanhada dos **Três C's** (Card, Conversation, Confirmation) e de critérios de aceite.

### User story ou caso de uso?
User story para agilidade e valor incremental; caso de uso quando a interação é complexa, com muitos fluxos alternativos, ou o contexto exige documentação formal.

## Fontes

1. Wikipedia — User story — https://en.wikipedia.org/wiki/User_story (consultado 2026-09-03)
2. Cohn, M. (2004). *User Stories Applied.*
3. Wake, B. — INVEST; Jeffries, R. — Três C's; Cockburn, A. — casos de uso.

## Observações

Aprofundar: BDD/Gherkin, story splitting, casos de uso UML. Status: verified.
