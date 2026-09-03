---
title: "Transações e ACID"
category: "12 - BANCOS DE DADOS"
tags:
  - engenharia-software
  - banco-de-dados
  - acid
  - transacoes
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Transações e ACID

## Resumo

Uma **transação** é uma unidade de trabalho no banco composta por uma ou mais operações que devem ser tratadas como um todo. **ACID** (Atomicidade, Consistência, Isolamento, Durabilidade) é o conjunto de propriedades que garante **validade dos dados** mesmo diante de erros, quedas de energia e concorrência. O acrônimo foi cunhado por **Andreas Reuter e Theo Härder (1983)**, sobre trabalho de **Jim Gray**.

## O que é? — As 4 propriedades

### A — Atomicidade
A transação é "tudo ou nada": ou todas as operações são efetivadas, ou nenhuma. Ex.: transferência bancária (debitar A + creditar B) — se uma falha, ambas são desfeitas (**rollback**).

### C — Consistência
A transação leva o banco de um **estado válido a outro**, respeitando todas as regras/constraints (chaves, checks). (⚠️ é diferente do "C" do [[Teorema CAP e Sistemas Distribuidos|CAP]].)

### I — Isolamento
Transações concorrentes não interferem umas nas outras; o resultado é como se fossem executadas em série. Controlado por **níveis de isolamento**.

### D — Durabilidade
Uma vez efetivada (**commit**), a transação persiste mesmo com falha de energia/sistema (via write-ahead log, etc.).

## Por que existe?

Sem transações, falhas parciais corromperiam dados (dinheiro sumindo, estoque negativo). ACID dá **garantias fortes** essenciais para domínios críticos (financeiro, reservas, estoque). O IBM IMS já suportava transações ACID em 1973.

## Como funciona? — Isolamento e anomalias

Níveis de isolamento (SQL standard), do mais fraco ao mais forte, e as anomalias que evitam:

| Nível | Dirty read | Non-repeatable read | Phantom read |
|---|---|---|---|
| Read Uncommitted | ❌ permite | ❌ | ❌ |
| Read Committed | ✅ evita | ❌ | ❌ |
| Repeatable Read | ✅ | ✅ | ❌ |
| Serializable | ✅ | ✅ | ✅ (mais forte) |

Mais isolamento = mais correção, menos concorrência/performance (trade-off).

## ACID vs BASE

- **ACID** (bancos SQL): prioriza **consistência**; a transação falha inteira se algo dá errado.
- **BASE** (muitos NoSQL): *Basically Available, Soft state, Eventually consistent* — prioriza **disponibilidade**, aceitando dados temporariamente inconsistentes.
- Um banco tende a ACID **ou** BASE (relacionado ao [[Teorema CAP e Sistemas Distribuidos|CAP]]).

## Exemplo prático

```sql
BEGIN;                                   -- inicia transação
UPDATE conta SET saldo = saldo - 100 WHERE id = 1;
UPDATE conta SET saldo = saldo + 100 WHERE id = 2;
COMMIT;                                  -- efetiva (durável)
-- Se algo falhar entre BEGIN e COMMIT:
-- ROLLBACK;  -> desfaz tudo (atomicidade)
```

## Quando utilizar

- Sempre que **integridade** importa: dinheiro, estoque, reservas, contadores críticos.
- Operações com múltiplos passos que precisam ser atômicas.

## Quando NÃO utilizar (nuance)

- Em escala distribuída extrema, ACID global é caro/inviável → usa-se consistência eventual e padrões como **Saga** ([[Event-Driven, CQRS e Event Sourcing|event-driven]]).

## Erros comuns / Anti-patterns

- Transações **longas** que travam recursos (locks) e derrubam a concorrência.
- Confundir consistência do ACID com a do CAP.
- Nível de isolamento errado (ex.: relatório financeiro em Read Uncommitted).
- Lógica de negócio que assume atomicidade entre serviços distintos (não há commit distribuído fácil).

## Boas práticas

- Transações **curtas**; abrir o mais tarde e fechar o quanto antes.
- Escolher o **nível de isolamento** pelo caso (default costuma ser Read Committed).
- Em sistemas distribuídos, preferir **Saga** a transações distribuídas.

## Conceitos relacionados

- [[SQL vs NoSQL]]
- [[Teorema CAP e Sistemas Distribuidos]]
- [[Indices e Otimizacao de Queries]]
- [[23 - CONCORRENCIA/_INDEX|Concorrência]]

## Perguntas importantes

### O que significa ACID?
Atomicidade, Consistência, Isolamento, Durabilidade — as garantias de uma transação de banco.

### ACID e BASE podem coexistir?
Um banco tende a um ou outro. ACID prioriza consistência; BASE prioriza disponibilidade (consistência eventual), conforme o trade-off do CAP.

## Fontes

1. Wikipedia — ACID — https://en.wikipedia.org/wiki/ACID (consultado 2026-09-03)
2. Härder, T. & Reuter, A. (1983). "Principles of Transaction-Oriented Database Recovery."
3. Gray, J. — trabalho seminal sobre o conceito de transação.

## Observações

Aprofundar níveis de isolamento e MVCC (PostgreSQL) em nota própria. Status: verified.
