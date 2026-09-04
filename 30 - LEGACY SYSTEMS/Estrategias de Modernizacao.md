---
title: "Estratégias de Modernização"
category: "30 - LEGACY SYSTEMS"
tags:
  - engenharia-software
  - legacy
  - modernizacao
  - strangler-fig
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Estratégias de Modernização

## Resumo

Modernizar um sistema legado é, na maioria dos casos, um trabalho **incremental e de baixo risco** — não uma reescrita do zero. O padrão de referência é o **Strangler Fig** (Martin Fowler): envolver o sistema antigo e **substituí-lo aos poucos**, em vez de um "big bang rewrite" (que costuma fracassar).

## O grande dilema: Reescrever vs Refatorar/Evoluir

### Big Bang Rewrite (reescrever do zero) — geralmente perigoso
- **Riscos:** demora anos; o sistema novo precisa **alcançar** um sistema que continua evoluindo; conhecimento do domínio embutido no legado se perde; alto risco de falhar antes de entregar valor.
- Joel Spolsky chamou reescrever do zero de "o pior erro estratégico" (perde-se conhecimento acumulado).
- **Quando pode valer:** sistema pequeno, tecnologia morta/insustentável, ou impossível evoluir.

### Refatorar/Evoluir incrementalmente — preferível
- Melhora contínua com [[Refatoracao|refatoração]] + [[Trabalhando com Codigo Legado|testes de caracterização]].
- Entrega valor durante todo o processo; risco distribuído.

## Strangler Fig Pattern (Fowler)

Nome vem da figueira estranguladora, que cresce sobre a árvore e a substitui gradualmente. A ideia: **envolver** o código antigo e **redirecionar** partes para o código novo, uma de cada vez, até o legado "morrer".

```
1. Coloca-se uma "fachada"/roteamento na frente do sistema legado
2. Constrói-se a funcionalidade nova ao lado; redireciona-se uma fatia
3. Repete-se, fatia por fatia, até o legado ser totalmente substituído
4. Remove-se o legado quando nada mais o usa
```
- Menos arriscado e **incremental**; muito usado para migrar **monólito → [[Microsservicos|microsserviços]]** (Sam Newman, *Monolith to Microservices*).
- Também chamado de "Ship of Theseus".

## Outras estratégias (o espectro "7 Rs" / Gartner)

- **Encapsulate** — expor o legado via API sem mexer no interior.
- **Rehost ("lift and shift")** — mover para nova infra (ex.: cloud) sem mudar o código.
- **Replatform** — pequenas otimizações ao migrar (ex.: banco gerenciado).
- **Refactor/Rearchitect** — reestruturar internamente / mudar arquitetura.
- **Rebuild** — reescrever mantendo o escopo.
- **Replace** — trocar por outra solução (ex.: SaaS de mercado).
- **Retire** — desativar o que não é mais necessário.

## Técnicas de apoio

- **Anti-Corruption Layer (ACL)** ([[Domain-Driven Design (DDD)|DDD]]) — camada que traduz o modelo legado para o novo, evitando contaminação.
- **Branch by Abstraction** — introduzir uma abstração para trocar a implementação por baixo sem parar o desenvolvimento.
- **Feature flags** — ligar/desligar o caminho novo com segurança.
- **Logging (Strangler)** — medir uso do código antigo para decidir o que migrar/aposentar.

## Como escolher

- Pergunte **por que** modernizar (custo de manutenção? segurança? escalar? talento?).
- Prefira **incremental (Strangler)** por padrão.
- **Rewrite** só quando evoluir é comprovadamente inviável — e ainda assim, fatie.
- Sempre com **rede de testes** ([[Trabalhando com Codigo Legado]]) e métricas de valor.

## Quando NÃO modernizar

- Sistema estável, de baixo custo e que não trava a evolução → talvez só manter/encapsular.
- Modernizar por moda (nova stack) sem ganho de negócio.

## Erros comuns / Anti-patterns

- **Big bang rewrite** subestimado (a armadilha clássica).
- Reescrever **e** adicionar features novas ao mesmo tempo (alvo móvel).
- Migrar para microsserviços criando um **[[Anti-patterns de Arquitetura e Design|monólito distribuído]]**.
- Modernizar sem testes de caracterização (perde comportamento).
- Não medir uso (aposentar/reescrever no escuro).

## Boas práticas

- **Strangler Fig** incremental; entregar valor durante o processo.
- **ACL** para isolar o legado; feature flags para segurança.
- Rede de testes antes de mudar.
- Decidir por dados (uso, custo, risco) e documentar em [[45 - DECISOES ARQUITETURAIS/_INDEX|ADRs]].

## Conceitos relacionados

- [[Sistemas Legados - Fundamentos]]
- [[Trabalhando com Codigo Legado]]
- [[Refatoracao]] · [[Microsservicos]]
- [[Domain-Driven Design (DDD)]] (ACL) · [[Integracao de Sistemas]]

## Perguntas importantes

### Por que reescrever do zero costuma dar errado?
Leva anos, precisa alcançar um sistema que continua evoluindo, e o conhecimento de domínio embutido no legado se perde. Entrega valor só no fim (se chegar lá). Prefira modernização incremental.

### O que é o Strangler Fig Pattern?
Substituir o legado **gradualmente**: envolvê-lo, redirecionar uma funcionalidade por vez para o novo código, até o antigo poder ser removido — reduzindo risco vs. big bang.

## Fontes

1. Wikipedia — Strangler fig pattern — https://en.wikipedia.org/wiki/Strangler_fig_pattern (consultado 2026-09-03)
2. Fowler, M. — "StranglerFigApplication" — https://martinfowler.com/bliki/StranglerFigApplication.html
3. Newman, S. (2020). *Monolith to Microservices.*; Spolsky, J. — "Things You Should Never Do."

## Observações

Aprofundar: Branch by Abstraction, ACL, os 7 Rs. Status: verified.
