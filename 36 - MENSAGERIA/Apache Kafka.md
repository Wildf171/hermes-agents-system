---
title: "Apache Kafka"
category: "36 - MENSAGERIA"
tags:
  - engenharia-software
  - mensageria
  - kafka
  - streaming
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Apache Kafka

## Resumo

**Apache Kafka** é uma plataforma distribuída de **event streaming** e um **event store** baseado em **log append-only**. Projetado para **alto throughput e baixa latência** em feeds de dados em tempo real. Criado no **LinkedIn** (Jay Kreps, Neha Narkhede, Jun Rao), open source em **2011**, mantido pela Apache Software Foundation. Escrito em Scala/Java.

## O que é?

Diferente de uma fila tradicional, o Kafka **retém as mensagens em um log durável e imutável**, permitindo que múltiplos consumidores leiam em **offsets diferentes** e **reprocessem** o histórico. É simultaneamente um broker de mensagens e uma plataforma de streaming.

## Por que existe?

Para processar **fluxos massivos de eventos** em tempo real (logs, métricas, cliques, transações) com throughput altíssimo e durabilidade — cenário onde filas tradicionais não escalavam. Jay Kreps o nomeou em homenagem a Franz Kafka, "um sistema otimizado para escrita".

## Como funciona? — Conceitos centrais

- **Topic** — categoria/stream de eventos (append-only log).
- **Partition** — o tópico é dividido em partições; **a ordem é garantida por partição** (não no tópico inteiro). Chave de partição decide onde a msg vai.
- **Offset** — posição sequencial de cada mensagem na partição; o consumidor controla seu offset (leitura no seu ritmo, reprocessável).
- **Producer / Consumer** — escrevem/leem.
- **Consumer Group** — consumidores dividem as partições (escala horizontal); cada partição é lida por **um** consumidor do grupo.
- **Broker / Cluster** — servidores Kafka; replicação entre brokers para durabilidade.
- **Retention** — mensagens ficam por tempo/tamanho configurável (não somem ao serem lidas).
- **Kafka Connect** — integração com sistemas externos (import/export).
- **Kafka Streams / ksqlDB** — processamento de streams.

> Kafka moderno substituiu o ZooKeeper por **KRaft** (metadados internos) para gerenciamento do cluster.

## Como o desempenho é alto

Log append-only + "message sets" (agrupa mensagens) → **escritas sequenciais em disco**, pacotes de rede maiores e uso eficiente de memória. Transforma escritas aleatórias em **escritas lineares**.

## Exemplo prático (conceito)

```
Producers → topic "pedidos" (12 partições, chave = pedido_id)
Consumer Group "faturamento" (4 consumidores) → cada um lê 3 partições
Consumer Group "analytics" → lê as MESMAS mensagens de forma independente
```
Vários grupos consomem o mesmo tópico sem interferir (offsets separados).

## Quando utilizar

- **Event streaming** de alto volume (logs, telemetria, IoT, cliques).
- Event sourcing / pipelines de dados ([[Engenharia de Dados]]).
- Quando precisa **reprocessar** histórico e ter **múltiplos consumidores** independentes.
- Backbone de eventos entre [[Microsservicos|microsserviços]].

## Quando NÃO utilizar

- Filas de tarefa simples com roteamento complexo por mensagem → [[RabbitMQ]] costuma ser mais direto.
- Baixo volume onde a complexidade operacional do Kafka não compensa.
- Necessidade de prioridade por mensagem / roteamento fino (não é o forte do Kafka).

## Trade-offs

- **Ganha:** throughput enorme, durabilidade, replay, múltiplos consumidores, escala.
- **Perde:** complexidade operacional, latência de setup, sem prioridade de mensagem, ordenação só por partição.

## Erros comuns / Anti-patterns

- Assumir ordem **global** (só existe por partição).
- Escolher chave de partição ruim → partições desbalanceadas ("hot partition").
- Poucas partições → limita paralelismo do consumer group.
- Consumidores não idempotentes com reprocessamento.
- Tratar Kafka como fila de tarefas com roteamento complexo.

## Boas práticas

- Escolher **chave de partição** que distribua bem e preserve a ordem necessária.
- Dimensionar partições pensando no paralelismo futuro.
- Consumidores **idempotentes**; gerenciar offsets com cuidado.
- Usar Schema Registry (Avro/Protobuf) para evoluir eventos.

## Conceitos relacionados

- [[Mensageria - Fundamentos]]
- [[RabbitMQ]] · [[Kafka vs RabbitMQ]]
- [[Event-Driven, CQRS e Event Sourcing]]
- [[Engenharia de Dados]]
- [[Padroes de Mensageria e Garantias de Entrega]]

## Perguntas importantes

### Kafka garante ordem das mensagens?
Apenas **dentro de uma partição**, não no tópico inteiro. Mensagens que precisam de ordem devem compartilhar a mesma chave de partição.

### As mensagens somem depois de lidas?
Não. Kafka **retém** por tempo/tamanho configurável; consumidores leem por offset e podem **reprocessar**. Isso o diferencia de filas tradicionais.

## Fontes

1. Wikipedia — Apache Kafka — https://en.wikipedia.org/wiki/Apache_Kafka (consultado 2026-09-03)
2. Documentação oficial — https://kafka.apache.org/documentation/
3. Kleppmann — *Designing Data-Intensive Applications* (streams).

## Observações

Aprofundar: KRaft, exactly-once semantics, Kafka Streams, Schema Registry. Status: verified.
