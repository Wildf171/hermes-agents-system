---
title: "Teorema CAP e Sistemas Distribuídos"
category: "13 - SISTEMAS DISTRIBUIDOS"
tags:
  - engenharia-software
  - distribuidos
  - cap
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Teorema CAP e Sistemas Distribuídos

## Resumo

Um **sistema distribuído** é um conjunto de computadores que cooperam pela rede aparentando ser um só sistema. O **Teorema CAP** (Brewer) afirma que, diante de uma **partição de rede**, um armazenamento de dados distribuído só pode garantir **duas** de três propriedades: **Consistência (C)**, **Disponibilidade (A)** e **Tolerância a Partição (P)** — na prática, é preciso escolher entre **C e A** quando há partição.

## O que é o Teorema CAP?

Também chamado **Teorema de Brewer** (Eric Brewer; formalizado por Gilbert e Lynch). As três garantias:

- **Consistency (C)** — toda leitura recebe a escrita mais recente (ou um erro); todos os nós veem os mesmos dados ao mesmo tempo. (⚠️ diferente do "C" do ACID.)
- **Availability (A)** — todo pedido a um nó **não falho** recebe resposta, sem garantir que seja a versão mais recente.
- **Partition tolerance (P)** — o sistema continua operando mesmo com mensagens perdidas/atrasadas entre nós.

## Por que existe?

Nenhum sistema distribuído está livre de **falhas de rede**, então **P é obrigatório** na prática. Logo, quando ocorre uma partição, a escolha real é:
- **CP** — cancelar a operação (erro/timeout) para preservar **consistência**.
- **AP** — responder mesmo assim, arriscando dados **desatualizados**, para preservar **disponibilidade**.

Sem partição (operação normal), dá para ter **C e A** ao mesmo tempo.

## Como funciona? — Escolhas na prática

| Escolha | Comportamento na partição | Exemplos típicos |
|---|---|---|
| **CP** | Recusa/erro se não puder garantir dado atual | bancos fortemente consistentes, ZooKeeper, HBase |
| **AP** | Sempre responde, consistência eventual | Cassandra, DynamoDB, Riak |

> **PACELC** estende o CAP: *se* há Partição (P), troca entre A e C; **senão (Else, E)**, troca entre **Latência (L)** e **Consistência (C)**. Ou seja, mesmo sem falha há um trade-off latência × consistência.

## Conceitos fundamentais de sistemas distribuídos

- **Consistência eventual** — réplicas convergem com o tempo (comum em AP).
- **Replicação** e **particionamento (sharding)** — para disponibilidade e escala.
- **Consenso** — algoritmos como **Paxos** e **Raft** para acordar valores entre nós.
- **Relógios e ordenação** — relógios lógicos (Lamport), vetores de versão.
- **Falácias da computação distribuída** — "a rede é confiável", "latência é zero", "banda é infinita"... (Deutsch/Gosling): premissas falsas que causam bugs.
- **Idempotência** — essencial com entrega "at-least-once".

## Exemplo prático

Um carrinho de compras replicado em duas regiões durante uma partição:
- **AP:** aceita adicionar item nas duas regiões; ao reconectar, **mescla** (pode duplicar) — prioriza disponibilidade.
- **CP:** bloqueia a escrita na região que não consegue confirmar → cliente vê erro, mas dados ficam consistentes.

## Quando utilizar cada abordagem

- **CP** quando **correção** é crítica (financeiro, estoque, reservas).
- **AP** quando **disponibilidade/latência** importam mais e a app tolera consistência eventual (feeds, catálogos, métricas).

## Quando NÃO utilizar (mal-entendidos)

- Não use CAP para "provar" que consistência é impossível — sem partição, dá para ter C e A.
- Não escolha AP sem projetar a **resolução de conflitos** e a **idempotência**.

## Erros comuns / Anti-patterns

- Tratar CAP como "escolha 2 de 3 sempre" (o trade-off só é forçado **durante partição**).
- Assumir as **falácias** da rede (confiável, sem latência).
- Ignorar consistência eventual no design da UI/negócio.

## Boas práticas

- Escolha C vs A **por caso de uso**, não para o sistema inteiro.
- Projete para **idempotência** e **retries**; assuma falhas de rede.
- Considere **PACELC** (latência também é trade-off).
- Observabilidade e tracing distribuído ([[20 - OBSERVABILIDADE/_INDEX]]).

## Conceitos relacionados

- [[34 - MICROSERVICOS/_INDEX|Microsserviços]]
- [[Event-Driven, CQRS e Event Sourcing]]
- [[36 - MENSAGERIA/_INDEX|Mensageria]]
- [[12 - BANCOS DE DADOS/_INDEX|Bancos de Dados]] (SQL vs NoSQL)

## Perguntas importantes

### CAP significa escolher só 2 de 3 sempre?
Não. **P é obrigatório** em sistemas distribuídos reais; o trade-off entre **C e A** só é forçado **quando há partição**. Em operação normal, C e A coexistem.

### O "C" do CAP é o mesmo do ACID?
Não. No CAP, C = todos veem o dado mais recente. No ACID, C = a transação leva o BD de um estado válido a outro (invariantes). São conceitos diferentes.

## Fontes

1. Wikipedia — CAP theorem — https://en.wikipedia.org/wiki/CAP_theorem (consultado 2026-09-03)
2. Gilbert, S. & Lynch, N. (2002) — prova formal do teorema de Brewer.
3. Brewer, E. — "CAP Twelve Years Later" (2012).
4. Abadi, D. — PACELC.

## Observações

Criar notas próprias: Raft/Paxos (consenso), consistência eventual, falácias da computação distribuída, sharding/replicação. Status: verified.
