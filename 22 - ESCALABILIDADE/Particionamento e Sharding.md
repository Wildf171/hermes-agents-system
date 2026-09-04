---
title: "Particionamento e Sharding"
category: "22 - ESCALABILIDADE"
tags:
  - engenharia-software
  - escalabilidade
  - sharding
  - banco-de-dados
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Particionamento e Sharding

## Resumo

**Sharding** é o **particionamento horizontal** de dados: dividir as **linhas** de uma tabela entre vários servidores (shards), cada um sendo a fonte única do seu subconjunto. É a principal técnica para **escalar escrita e volume** além do que um único banco aguenta.

## O que é?

- **Particionamento horizontal** — separa **linhas** (registros) em partições. Cada partição faz parte de um **shard**, que pode ficar em um servidor separado.
- **Particionamento vertical** — separa **colunas** (diferente; relaciona-se a normalização).

Cada shard tem menos linhas → **índices menores** → busca mais rápida; e a carga se distribui por várias máquinas.

## Por que existe?

Um único banco tem limites de escrita, armazenamento e memória. Réplicas escalam **leitura**, mas não **escrita/volume**. Sharding distribui os dados (e a escrita) por vários nós → escala horizontal do banco.

## Como funciona? — Estratégias de particionamento

### Por intervalo (Range)
Divide por faixas da chave (ex.: A–M / N–Z, ou por data).
- **Prós:** consultas por faixa eficientes.
- **Contras:** **hot spots** (uma faixa recebe muito mais tráfego, ex.: dados recentes).

### Por hash
Aplica hash na chave e distribui.
- **Prós:** distribuição uniforme.
- **Contras:** consultas por faixa ficam ruins (dados espalhados).

### Consistent Hashing
Hashing que **minimiza a redistribuição** ao adicionar/remover nós (só uma fração das chaves migra). Essencial para elasticidade em sistemas distribuídos (usado em Cassandra, DynamoDB).

### Por diretório / lookup
Um serviço mapeia chave → shard (flexível, mas o diretório vira ponto crítico).

## Escolha da Shard Key

Decisão **crítica** e difícil de mudar. Uma boa shard key:
- Distribui a carga **uniformemente** (evita hot shards).
- Alinha-se aos padrões de consulta (evita "scatter-gather" em todos os shards).
- Ex.: `user_id` costuma ser melhor que `data` (que concentra no shard "recente").

## Desafios do sharding

- **Joins e transações cross-shard** — caros ou inviáveis (repensar o modelo).
- **Rebalanceamento** — mover dados ao adicionar shards (consistent hashing ajuda).
- **Hot shards** — distribuição desigual.
- **Consultas scatter-gather** — que precisam consultar todos os shards.
- Aumenta muito a **complexidade operacional**.

## Exemplo

```
Tabela usuarios (500M linhas) → shard por hash(user_id) em 8 shards
Shard N = hash(user_id) % 8
Consulta por user_id → vai direto ao shard certo (rápido)
Consulta "todos criados hoje" → scatter-gather (lenta) → evitar/duplicar dado
```

## Quando utilizar

- Quando **volume/escrita** excede a capacidade de um único nó **e** já se esgotaram [[Replicacao de Dados|réplicas]], [[Cache e Redis|cache]] e [[Indices e Otimizacao de Queries|otimização]].
- Datasets muito grandes.

## Quando NÃO utilizar

- **Sharding prematuro** — é a última alavanca, não a primeira. Adiciona complexidade enorme.
- Se o dado cabe (com folga) em um banco grande + réplicas, **não faça sharding**.

## Trade-offs

- **Ganha:** escala de escrita/volume horizontal.
- **Perde:** simplicidade (sem joins/transações globais fáceis), complexidade operacional, rebalanceamento.

## Erros comuns / Anti-patterns

- **Shard key ruim** → hot shards / scatter-gather em tudo.
- Sharding antes de cache/réplicas/índices.
- Assumir joins cross-shard como triviais.
- Ignorar o custo de **rebalanceamento**.

## Boas práticas

- Escolher shard key com cuidado (distribuição + padrão de acesso).
- **Consistent hashing** para elasticidade.
- Muitos bancos modernos fazem sharding "nativo" (Mongo, Cassandra, Citus) — prefira a plantar o seu.
- Denormalizar/duplicar para evitar cross-shard quando necessário.

## Conceitos relacionados

- [[Escalabilidade - Fundamentos]]
- [[Replicacao de Dados]]
- [[Teorema CAP e Sistemas Distribuidos]]
- [[SQL vs NoSQL]] · [[Modelagem de Dados e Normalizacao]]
- [[Componentes de Sistemas em Larga Escala]]

## Perguntas importantes

### Sharding escala leitura ou escrita?
Principalmente **escrita e volume** (distribui os dados). Leitura escala melhor com **réplicas + cache**. Muitas vezes usa-se sharding **e** réplicas juntos.

### O que é consistent hashing?
Técnica de hashing que, ao adicionar/remover nós, **remapeia apenas uma fração** das chaves (em vez de quase todas) — reduzindo o custo de rebalanceamento em sistemas distribuídos.

## Fontes

1. Wikipedia — Shard (database architecture) — https://en.wikipedia.org/wiki/Shard_(database_architecture) (consultado 2026-09-03)
2. Kleppmann — *Designing Data-Intensive Applications* (Partitioning).
3. Karger et al. (1997) — Consistent Hashing.

## Observações

Aprofundar: consistent hashing detalhado, scatter-gather, resharding online. Status: verified.
