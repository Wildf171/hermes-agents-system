---
title: "Replicação de Dados"
category: "22 - ESCALABILIDADE"
tags:
  - engenharia-software
  - escalabilidade
  - replicacao
  - banco-de-dados
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Replicação de Dados

## Resumo

**Replicação** é manter **cópias dos mesmos dados** em vários nós. Serve para **escalar leitura**, aumentar **disponibilidade** (redundância/failover) e reduzir **latência** (dados perto do usuário). É complementar ao [[Particionamento e Sharding|sharding]] (que divide os dados; replicação os copia).

## Por que replicar?

- **Escala de leitura** — distribuir leituras por várias réplicas.
- **Alta disponibilidade** — se um nó cai, outro assume (failover).
- **Latência** — réplicas em regiões próximas ao usuário.
- **Durabilidade** — cópias reduzem risco de perda.

## Modelos de replicação

### Single-Leader (Leader–Follower / Primary–Replica)
Um nó **líder** recebe as **escritas** e propaga para os **seguidores**, que atendem **leituras**.
- **Prós:** simples, sem conflitos de escrita.
- **Contras:** líder é gargalo de escrita e SPOF (mitigado por failover); **lag de replicação**.
- O mais comum (PostgreSQL, MySQL).

### Multi-Leader
Vários nós aceitam escrita (ex.: multi-região).
- **Prós:** escrita local em cada região, tolera partição.
- **Contras:** **conflitos de escrita** (mesmo dado alterado em dois líderes) precisam de resolução.

### Leaderless (Dynamo-style)
Qualquer réplica aceita escrita/leitura; usa **quórum** (W + R > N) para consistência.
- Ex.: Cassandra, DynamoDB.
- **Prós:** alta disponibilidade, sem SPOF.
- **Contras:** consistência eventual, resolução de conflitos (versionamento, LWW).

## Síncrona vs Assíncrona

- **Síncrona** — confirma a escrita só após a réplica receber. Consistente, porém mais lenta e sensível a falha da réplica.
- **Assíncrona** — confirma antes de replicar. Rápida, mas há **janela de perda** e **lag** (a réplica pode estar atrasada).

## Replication Lag (o problema clássico)

Em replicação assíncrona, a réplica fica **atrás** do líder. Consequência: ler da réplica **logo após** escrever no líder pode **não ver** a própria escrita (**consistência eventual**).
- Mitigações: **read-your-writes** (ler do líder após escrever), monitorar lag, roteamento consciente.

## Relação com CAP

Replicação é onde o [[Teorema CAP e Sistemas Distribuidos|CAP]] "morde": durante uma partição, escolher **consistência** (recusar/esperar) ou **disponibilidade** (servir dado possivelmente velho).

## Exemplo

```
Escrita → DB Primary → replica (async) → Réplica 1, Réplica 2
Leituras → balanceadas entre réplicas (escala leitura)
⚠️ Ler da réplica logo após escrever pode não ver o dado (lag)
   → para dados críticos, ler do primary (read-your-writes)
```

## Quando utilizar

- **Leitura ≫ escrita** (a maioria das apps) → read replicas.
- Necessidade de **alta disponibilidade**/failover.
- Multi-região para latência global.

## Quando NÃO / cuidado

- Não resolve escala de **escrita** (para isso, [[Particionamento e Sharding|sharding]]).
- Multi-leader/leaderless só quando a complexidade de conflitos se justifica.

## Trade-offs

- Síncrona: consistência × latência/disponibilidade.
- Assíncrona: performance × risco de lag/perda.
- Mais réplicas: mais leitura/HA × mais custo e complexidade de consistência.

## Erros comuns / Anti-patterns

- Ignorar **replication lag** (bugs de "não vejo o que acabei de salvar").
- Usar réplica para leitura que exige o dado mais recente.
- Multi-leader sem estratégia de resolução de conflito.
- Achar que replicação escala escrita (não escala).

## Boas práticas

- **Read-your-writes** para dados que o usuário acabou de alterar.
- Monitorar lag; failover automatizado testado.
- Combinar com [[Cache e Redis|cache]] e, se necessário, [[Particionamento e Sharding|sharding]].
- Escolher o modelo pela necessidade (single-leader cobre a maioria).

## Conceitos relacionados

- [[Escalabilidade - Fundamentos]]
- [[Particionamento e Sharding]]
- [[Teorema CAP e Sistemas Distribuidos]]
- [[Transacoes e ACID]] · [[Componentes de Sistemas em Larga Escala]]

## Perguntas importantes

### Replicação escala escrita?
Não. Escala **leitura** e melhora disponibilidade. Para escalar **escrita**, use **sharding** (particionamento).

### O que é replication lag?
O atraso da réplica em relação ao líder na replicação assíncrona. Pode fazer uma leitura na réplica não ver uma escrita recente (consistência eventual) — mitigado lendo do líder quando necessário.

## Fontes

1. Kleppmann — *Designing Data-Intensive Applications* (Replication) — referência principal.
2. Wikipedia — Replication (computing) — https://en.wikipedia.org/wiki/Replication_(computing)
3. Amazon Dynamo paper (2007) — leaderless/quórum.

## Observações

Aprofundar: quórum (W+R>N), resolução de conflitos (LWW, CRDTs), failover. Status: verified.
