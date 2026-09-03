---
title: "Mensageria - Fundamentos"
category: "36 - MENSAGERIA"
tags:
  - engenharia-software
  - mensageria
  - filas
  - pub-sub
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Mensageria — Fundamentos

## Resumo

**Mensageria** é a comunicação **assíncrona** entre processos/serviços por meio de **mensagens** que trafegam por um intermediário (**broker/fila**). O remetente e o destinatário **não precisam estar ativos ao mesmo tempo**: mensagens ficam armazenadas até serem consumidas. É a base do desacoplamento em sistemas distribuídos e [[Microsservicos|microsserviços]].

## O que é?

Uma **fila de mensagens** (message queue) implementa comunicação assíncrona: o produtor coloca mensagens, que ficam guardadas até o consumidor as retirar. Faz parte de um **message-oriented middleware (MOM)**. É "irmã" do padrão **publish/subscribe**. Exemplos: RabbitMQ, Apache Kafka, IBM MQ, Amazon SQS/SNS, Redis.

## Por que existe?

- **Desacoplamento** — produtor não conhece o consumidor (temporal e de implementação).
- **Resiliência** — se o consumidor cai, as mensagens esperam na fila.
- **Absorção de picos (buffering)** — a fila amortece rajadas de carga.
- **Escala** — múltiplos consumidores processam em paralelo (**competing consumers**).
- Base de [[Event-Driven, CQRS e Event Sourcing|arquiteturas orientadas a eventos]].

## Como funciona? — Dois modelos

### 1. Point-to-Point (Fila / Queue)
Uma mensagem é entregue a **um** consumidor entre vários (competing consumers). Bom para **distribuir trabalho** (task queue).

```
Produtor → [ fila ] → Consumidor A  (cada msg vai para 1 consumidor)
                    ↘ Consumidor B
```

### 2. Publish/Subscribe (Tópico)
Uma mensagem é entregue a **todos** os assinantes interessados. Bom para **notificar eventos**.

```
Publisher → [ tópico ] → Subscriber 1
                       → Subscriber 2  (todos recebem)
```

## Conceitos fundamentais

- **Producer / Consumer** — quem envia / quem processa.
- **Broker** — o intermediário que roteia e armazena.
- **Message / Event** — a unidade de dados.
- **Ack (acknowledgement)** — consumidor confirma o processamento; sem ack, a msg é reentregue.
- **Offset (log-based)** — posição de leitura em um log (ex.: Kafka).
- **Backpressure** — controlar produção quando o consumo não acompanha.
- **DLQ (Dead Letter Queue)** — para onde vão mensagens que falham repetidamente.

## Garantias de entrega

- **At-most-once** — pode perder, nunca duplica.
- **At-least-once** — nunca perde, **pode duplicar** (mais comum) → exige **idempotência**.
- **Exactly-once** — sem perda nem duplicação; difícil e custoso (Kafka oferece em cenários específicos).

Ver [[Padroes de Mensageria e Garantias de Entrega]].

## Exemplo prático (task queue)

```
API recebe upload → publica "processar_video(id)" na fila → responde 202 Accepted
Workers consomem a fila e processam em background (escala horizontal)
```
Usuário não espera; o trabalho pesado roda assíncrono.

## Quando utilizar

- Tarefas assíncronas/background (e-mails, processamento pesado).
- Desacoplar serviços; integração orientada a eventos.
- Absorver picos e distribuir carga.

## Quando NÃO utilizar

- Quando você precisa de **resposta imediata síncrona** (use [[APIs REST - Fundamentos e Design|REST]]/[[gRPC]]).
- Sistemas simples onde a fila adiciona complexidade sem ganho.

## Trade-offs

- **Ganha:** desacoplamento, resiliência, escala, absorção de picos.
- **Perde:** complexidade operacional, consistência eventual, depuração mais difícil (fluxos assíncronos exigem [[Observabilidade|tracing]]).

## Erros comuns / Anti-patterns

- Consumidores **não idempotentes** com entrega at-least-once → efeitos duplicados.
- Sem **DLQ** → mensagens venenosas travam a fila (poison message).
- Ignorar ordenação quando ela importa.
- Usar mensageria para request/response síncrono disfarçado.

## Boas práticas

- Consumidores **idempotentes**; tratar duplicatas.
- Configurar **DLQ** e política de retry (com backoff).
- Monitorar tamanho de fila/lag e backpressure.
- Mensagens pequenas e versionadas (schema).

## Conceitos relacionados

- [[Apache Kafka]] · [[RabbitMQ]] · [[Kafka vs RabbitMQ]]
- [[Padroes de Mensageria e Garantias de Entrega]]
- [[Event-Driven, CQRS e Event Sourcing]]
- [[Microsservicos]]

## Perguntas importantes

### Qual a diferença entre fila e pub/sub?
Na **fila** (point-to-point), cada mensagem vai para **um** consumidor (distribuir trabalho). No **pub/sub**, cada mensagem vai para **todos** os assinantes (notificar eventos).

### O que é entrega "at-least-once"?
Garante que a mensagem não se perde, mas pode ser **entregue mais de uma vez** — por isso os consumidores devem ser **idempotentes**.

## Fontes

1. Wikipedia — Message queue — https://en.wikipedia.org/wiki/Message_queue (consultado 2026-09-03)
2. Enterprise Integration Patterns (Hohpe & Woolf) — https://www.enterpriseintegrationpatterns.com
3. Kleppmann — *Designing Data-Intensive Applications* (2017), cap. sobre streams.

## Observações

Aprofundar cada broker e padrões em notas próprias. Status: verified.
