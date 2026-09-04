---
title: "Integração de Sistemas"
category: "10 - ARQUITETURA DE SISTEMAS"
tags:
  - engenharia-software
  - arquitetura-sistemas
  - integracao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Integração de Sistemas

## Resumo

**Integração de sistemas** é fazer aplicações e serviços distintos **trabalharem juntos**, trocando dados e funcionalidades. A decisão-chave é **síncrono vs assíncrono**, e os estilos vão de chamadas de API diretas a **mensageria** e **arquitetura orientada a eventos**.

## O que é?

Conectar sistemas (internos e de terceiros) que foram construídos separadamente, possivelmente com tecnologias diferentes. É central em [[Microsservicos|microsserviços]] e em paisagens corporativas com muitos sistemas legados.

## Síncrono vs Assíncrono (a grande decisão)

### Síncrono (request/response)
O chamador **espera** a resposta. Ex.: [[APIs REST - Fundamentos e Design|REST]], [[gRPC]].
- **Prós:** simples de raciocinar, resposta imediata, fácil de depurar.
- **Contras:** **acoplamento temporal** (ambos precisam estar no ar), falhas em cascata, latência somada em cadeias.

### Assíncrono (mensagens/eventos)
O chamador **não espera**; comunica via [[Mensageria - Fundamentos|fila/tópico]]. Ex.: [[Apache Kafka|Kafka]], [[RabbitMQ]], [[Event-Driven, CQRS e Event Sourcing|eventos]].
- **Prós:** desacoplamento, resiliência (o consumidor pode estar fora), absorção de picos, escala.
- **Contras:** complexidade, **consistência eventual**, depuração difícil (precisa de [[Observabilidade|tracing]]).

> Regra prática: use **síncrono** quando precisa de resposta imediata e consistência forte; **assíncrono** para desacoplar, resiliência e trabalho em background.

## Estilos de integração (evolução histórica)

- **Point-to-point** — cada sistema se conecta direto a outro. Simples no início, vira "spaghetti" (N×M conexões).
- **ESB (Enterprise Service Bus)** — barramento central que roteia/transforma. Reduz o N×M, mas vira **gargalo/SPOF** e acopla lógica no bus (anti-pattern moderno: "smart pipes").
- **API-led / API Gateway** — integração via APIs bem definidas + gateway.
- **Event-driven / mensageria** — "dumb pipes, smart endpoints": broker simples, lógica nos serviços. Padrão moderno para desacoplamento.

## Padrões de integração (EIP)

Do livro *Enterprise Integration Patterns*: **Message Channel, Router, Translator, Aggregator, Content-Based Router**, etc. Ver [[Padroes de Mensageria e Garantias de Entrega]].
- **Anti-Corruption Layer (DDD)** — camada que traduz o modelo de um sistema externo/legado para o seu, evitando contaminação. Ver [[Domain-Driven Design (DDD)]].

## Formatos e contratos

- **Contratos de dados** — JSON, Protobuf, Avro (com **Schema Registry** para evoluir sem quebrar).
- **Versionamento** de APIs/eventos ([[Boas Praticas de API]]).
- **Idempotência** nos consumidores (entrega at-least-once). Ver [[Padroes de Mensageria e Garantias de Entrega]].

## Exemplo prático

```
Pedido criado:
  Síncrono: API valida e responde 201 imediatamente
  Assíncrono: publica evento "PedidoCriado" → estoque, e-mail, faturamento
             reagem sem travar a resposta ao usuário
```

## Quando usar cada abordagem

- **Síncrono (REST/gRPC):** consulta que precisa de resposta agora; consistência forte.
- **Assíncrono (eventos/filas):** notificações, side-effects, processamento pesado, integração desacoplada entre serviços/domínios.

## Quando NÃO usar

- Cadeias longas de chamadas **síncronas** entre muitos serviços → latência e falha em cascata (prefira async ou reduza o acoplamento).
- Async para algo que o usuário precisa ver **imediatamente** confirmado de forma forte.

## Erros comuns / Anti-patterns

- **Integração spaghetti** (point-to-point N×M sem padrão).
- **ESB "inteligente"** com lógica de negócio no bus.
- Cadeia síncrona longa (falha em cascata) — falta [[Microsservicos|circuit breaker]].
- Sem versionamento de contrato → quebra consumidores.
- Consumidor não idempotente com ret್ries.

## Boas práticas

- **Dumb pipes, smart endpoints**; async onde desacoplamento importa.
- Contratos versionados + Schema Registry.
- Resiliência: timeouts, retries com backoff, circuit breaker.
- Anti-Corruption Layer ao integrar legado/terceiros.
- Observabilidade/tracing distribuído.

## Conceitos relacionados

- [[Arquitetura de Sistemas e System Design - Fundamentos]]
- [[Componentes de Sistemas em Larga Escala]]
- [[Mensageria - Fundamentos]] · [[Event-Driven, CQRS e Event Sourcing]]
- [[APIs REST - Fundamentos e Design]] · [[gRPC]]
- [[Microsservicos]] · [[Domain-Driven Design (DDD)]]

## Perguntas importantes

### Síncrono ou assíncrono?
Síncrono quando precisa de resposta imediata/consistência forte (REST/gRPC). Assíncrono para desacoplar, resiliência e background (mensageria/eventos), aceitando consistência eventual.

### O que há de errado com um ESB?
Concentra lógica e roteamento num barramento central que vira gargalo e SPOF ("smart pipes"). A abordagem moderna prefere **dumb pipes, smart endpoints** (brokers simples + lógica nos serviços).

## Fontes

1. Hohpe & Woolf — *Enterprise Integration Patterns* — https://www.enterpriseintegrationpatterns.com
2. Fowler, M. — "Microservices" (dumb pipes, smart endpoints) — https://martinfowler.com/articles/microservices.html
3. Kleppmann — *Designing Data-Intensive Applications.*

## Observações

Criar notas: Anti-Corruption Layer, Schema Registry, circuit breaker. Status: verified.
