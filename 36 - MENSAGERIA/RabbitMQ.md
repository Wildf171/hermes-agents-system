---
title: "RabbitMQ"
category: "36 - MENSAGERIA"
tags:
  - engenharia-software
  - mensageria
  - rabbitmq
  - amqp
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# RabbitMQ

## Resumo

**RabbitMQ** é um **message broker** open source (message-oriented middleware) que implementa o protocolo **AMQP** (e, via plugins, STOMP, MQTT e outros). Escrito em **Erlang** (forte em concorrência e failover), é conhecido pelo **roteamento flexível** de mensagens e por ser um "broker inteligente" com consumidores simples.

## O que é?

Um intermediário que recebe mensagens de produtores e as **roteia** para filas conforme regras, entregando-as a consumidores. Originou-se na Rabbit Technologies (2007), passou por SpringSource/VMware/Pivotal e hoje é da **Broadcom**. Bibliotecas cliente para todas as linguagens principais.

## Por que existe?

Oferecer **mensageria confiável com roteamento sofisticado**: diferentes tipos de troca (exchange) permitem padrões variados (broadcast, roteamento por chave, por padrão) — ideal para **filas de tarefas** e integração entre serviços com regras de entrega finas.

## Como funciona? — Modelo AMQP

```
Producer → Exchange → (binding) → Queue → Consumer
```
- **Exchange** — recebe a mensagem e decide para quais filas encaminhar.
- **Queue** — armazena mensagens até o consumo.
- **Binding** — regra que liga exchange a fila (com routing key/pattern).

### Tipos de Exchange
- **Direct** — roteia pela **routing key** exata.
- **Topic** — roteia por **padrão** de chave (`pedido.*.criado`).
- **Fanout** — **broadcast** para todas as filas ligadas (pub/sub).
- **Headers** — roteia por atributos do header.

### Entrega
- **Ack manual** — consumidor confirma; sem ack (ou nack), a mensagem é **reenfileirada**.
- **Prefetch (QoS)** — limita quantas mensagens não-confirmadas um consumidor recebe (backpressure).
- **DLX (Dead Letter Exchange)** — mensagens rejeitadas/expiradas vão para uma DLQ.
- **Prioridade** de mensagens e **TTL** suportados.

> Filosofia: **"smart broker / dumb consumer"** — a inteligência de roteamento fica no broker (oposto do Kafka, "dumb broker / smart consumer").

## Exemplo prático (task queue)

```
Producer publica em exchange "" (default) com routing key = "emails"
→ fila "emails" → workers consomem (competing consumers)
Ack só após enviar o e-mail; se o worker cair, a msg volta para a fila
```

## Quando utilizar

- **Filas de tarefas** (background jobs) e processamento assíncrono.
- Roteamento **complexo/flexível** por mensagem (topic/headers).
- Necessidade de **prioridade**, TTL, roteamento fino, RPC assíncrono.
- Volume baixo/médio com entrega confiável.

## Quando NÃO utilizar

- **Streaming de altíssimo volume** e replay de histórico → [[Apache Kafka]].
- Quando você precisa reter e reprocessar o log de eventos (RabbitMQ remove a msg após ack).

## Trade-offs

- **Ganha:** roteamento flexível, maturidade, prioridade/TTL, fácil de começar, confiável.
- **Perde:** throughput menor que Kafka em cargas massivas; mensagens somem após consumidas (sem replay nativo como o log do Kafka).

## Erros comuns / Anti-patterns

- Sem **DLX/DLQ** → mensagens venenosas reenfileiram infinitamente.
- Consumidores não idempotentes com reentrega.
- Prefetch mal configurado (1 consumidor pega tudo, ou fica ocioso).
- Usar RabbitMQ como event store/streaming (não é o caso de uso).

## Boas práticas

- Configurar **DLX** + retry com backoff.
- Ack manual após processar; ajustar **prefetch** para balancear.
- Consumidores idempotentes.
- Filas duráveis + mensagens persistentes quando não pode perder.

## Conceitos relacionados

- [[Mensageria - Fundamentos]]
- [[Apache Kafka]] · [[Kafka vs RabbitMQ]]
- [[Padroes de Mensageria e Garantias de Entrega]]
- [[Microsservicos]]

## Perguntas importantes

### Qual a diferença de filosofia entre RabbitMQ e Kafka?
RabbitMQ é **smart broker / dumb consumer** (roteamento no broker, mensagem some após ack). Kafka é **dumb broker / smart consumer** (log durável, consumidor controla offset e reprocessa).

### O que faz um Exchange?
Recebe a mensagem do produtor e decide, pelas bindings/routing keys, para **quais filas** encaminhá-la (direct, topic, fanout, headers).

## Fontes

1. Wikipedia — RabbitMQ — https://en.wikipedia.org/wiki/RabbitMQ (consultado 2026-09-03)
2. Documentação oficial — https://www.rabbitmq.com/docs
3. AMQP 0-9-1 Model — https://www.rabbitmq.com/tutorials/amqp-concepts

## Observações

Aprofundar: tipos de exchange com exemplos, quorum queues, streams (novo no RabbitMQ). Status: verified.
