---
title: "Kafka vs RabbitMQ"
category: "36 - MENSAGERIA"
tags:
  - engenharia-software
  - mensageria
  - kafka
  - rabbitmq
  - comparacao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Kafka vs RabbitMQ

## Resumo

Ambos movem mensagens de forma assíncrona, mas resolvem problemas diferentes. **RabbitMQ** é um **broker de mensagens** com roteamento flexível — ótimo para **filas de tarefas** e integração. **Apache Kafka** é uma **plataforma de streaming baseada em log** — ótima para **eventos em alto volume** com retenção e replay. Não é "melhor/pior", é **caso de uso**.

## Diferença de paradigma

- **RabbitMQ:** *smart broker / dumb consumer.* O broker roteia; a mensagem é **removida após o ack**. Pense em "fila de tarefas".
- **Kafka:** *dumb broker / smart consumer.* Log **append-only durável**; o consumidor controla o **offset** e pode **reprocessar**. Pense em "stream de eventos".

## Comparação lado a lado

| Critério | RabbitMQ | Apache Kafka |
|---|---|---|
| Modelo | Broker/fila (AMQP) | Log de eventos distribuído |
| Retenção | Some após consumo (ack) | Retém por tempo/tamanho; **replay** |
| Ordem | Por fila | Por **partição** |
| Throughput | Alto (milhares–dezenas de mil/s) | **Muito alto** (milhões/s) |
| Roteamento | **Flexível** (direct/topic/fanout/headers) | Simples (tópico/partição por chave) |
| Múltiplos consumidores | Compartilham a fila | **Grupos independentes** leem o mesmo tópico |
| Prioridade de msg | Sim | Não |
| Reprocessar histórico | Não (nativamente) | **Sim** (offsets) |
| Escrito em | Erlang | Scala/Java |
| Complexidade operacional | Menor | Maior |

## Quando escolher cada um

### RabbitMQ
- **Filas de tarefas** / background jobs.
- Roteamento **complexo por mensagem** (topic/headers), prioridade, TTL.
- RPC assíncrono, integração entre serviços com regras finas.
- Volume baixo/médio; começar rápido.

### Kafka
- **Event streaming** de alto volume (logs, métricas, cliques, IoT).
- **Event sourcing**, pipelines de [[Engenharia de Dados|dados]], analytics em tempo real.
- Vários consumidores independentes sobre o mesmo fluxo; **replay** de histórico.
- Backbone de eventos entre muitos [[Microsservicos|microsserviços]].

## Regra prática

```
"Preciso distribuir TAREFAS com roteamento/prioridade"      → RabbitMQ
"Preciso de um FLUXO de eventos, alto volume, com replay"    → Kafka
```
É comum usar **os dois** na mesma empresa, para propósitos distintos.

## Erros comuns

- Usar Kafka como fila de tarefas com roteamento complexo (não é o forte).
- Usar RabbitMQ como event store/streaming de altíssimo volume com replay.
- Escolher por hype em vez do padrão de uso.

## Boas práticas

- Decida pelo **padrão de consumo** (tarefa única vs fluxo multi-consumidor) e pela necessidade de **replay/retenção**.
- Em ambos: consumidores **idempotentes**, DLQ, observabilidade de lag.

## Conceitos relacionados

- [[Mensageria - Fundamentos]]
- [[Apache Kafka]]
- [[RabbitMQ]]
- [[Padroes de Mensageria e Garantias de Entrega]]
- [[Event-Driven, CQRS e Event Sourcing]]

## Perguntas importantes

### Kafka substitui RabbitMQ?
Não. São ferramentas para problemas diferentes: Kafka para **streams de eventos** (retenção/replay/volume); RabbitMQ para **filas de tarefas** com roteamento flexível.

### Qual tem maior throughput?
**Kafka**, por design (log append-only, escritas sequenciais, partições). Mas throughput bruto só importa se for o requisito real.

## Fontes

1. Wikipedia — Apache Kafka / RabbitMQ (consultados 2026-09-03)
2. Documentações oficiais — kafka.apache.org, rabbitmq.com
3. Kleppmann — *Designing Data-Intensive Applications* (2017).

## Observações

Comparação de alto nível; validar números de throughput no seu cenário. Status: verified.
