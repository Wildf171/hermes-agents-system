---
title: "Event-Driven, CQRS e Event Sourcing"
category: "35 - EVENT DRIVEN"
tags:
  - engenharia-software
  - event-driven
  - cqrs
  - event-sourcing
  - arquitetura
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Event-Driven Architecture, CQRS e Event Sourcing

## Resumo

**Event-Driven Architecture (EDA)** é um paradigma em que componentes produzem e reagem a **eventos** (mudanças significativas de estado), de forma **assíncrona e fracamente acoplada**. **CQRS** separa os modelos de leitura e escrita; **Event Sourcing** guarda o estado como uma **sequência de eventos**. Os três frequentemente aparecem juntos, mas são independentes.

## Event-Driven Architecture (EDA)

### O que é
Um **evento** é "uma mudança significativa de estado" (ex.: carro passa de "à venda" para "vendido"). O que trafega é uma **notificação de evento** (mensagem, geralmente assíncrona) — o evento em si é a mudança que ocorreu ("eventos não viajam, eles ocorrem").

Componentes:
- **Emitters (produtores)** — detectam e publicam eventos; **não conhecem** os consumidores.
- **Consumers (sinks)** — reagem ao evento.
- **Event channels** — transportam (filas/tópicos, ver [[36 - MENSAGERIA/_INDEX|mensageria]]).

### Por que existe
Desacoplar produtores de consumidores → escalabilidade, resiliência, extensibilidade (adicionar consumidores sem tocar no produtor). Bom para cargas complexas e dinâmicas.

### Padrões
- **Event Notification** — avisa que algo aconteceu (payload mínimo).
- **Event-Carried State Transfer** — evento carrega os dados, evitando callback.
- **Pub/Sub** — publicação/assinatura.

## CQRS (Command Query Responsibility Segregation)

Separa **comandos** (escrita, mudam estado) de **queries** (leitura, retornam dados) em **modelos distintos** — possivelmente bancos diferentes.
- **Ganha:** otimizar leitura e escrita separadamente; escalar de forma independente.
- **Perde:** complexidade e, muitas vezes, **consistência eventual** entre os modelos.
- Popularizado por **Greg Young** e **Martin Fowler**; deriva do CQS de Bertrand Meyer.

## Event Sourcing

Em vez de guardar só o **estado atual**, guarda a **sequência de eventos** que levaram a ele. O estado é reconstruído reproduzindo os eventos.
- **Ganha:** auditoria completa, histórico, "viagem no tempo", replay.
- **Perde:** complexidade, versionamento de eventos, consultas exigem projeções.
- Combina naturalmente com CQRS (eventos alimentam os modelos de leitura).

## Exemplo prático (fluxo)

```
Comando: "ConfirmarPedido(42)"
   → Aggregate valida e emite Evento: PedidoConfirmado(42)
   → Event store persiste o evento (Event Sourcing)
   → Publicado no canal (EDA)
   → Consumidores reagem: atualiza leitura (CQRS), envia e-mail, baixa estoque
```

## Quando utilizar

- **EDA:** integração desacoplada, fluxos assíncronos, [[34 - MICROSERVICOS/_INDEX|microsserviços]].
- **CQRS:** grande assimetria entre leitura e escrita; modelos de leitura complexos.
- **Event Sourcing:** necessidade de auditoria/histórico forte (financeiro, domínios regulados).

## Quando NÃO utilizar

- CRUD simples → CQRS/Event Sourcing são **over-engineering** ([[DRY, KISS e YAGNI|YAGNI]]).
- Times sem maturidade em sistemas assíncronos/distribuídos.
- Quando consistência forte imediata é obrigatória e simples de obter com um BD relacional.

## Trade-offs

- Desacoplamento e escalabilidade **vs.** complexidade, depuração difícil, **consistência eventual**.
- Rastrear "o que aconteceu" é mais difícil em fluxos assíncronos (precisa de [[20 - OBSERVABILIDADE/_INDEX|tracing]]).

## Erros comuns / Anti-patterns

- Usar CQRS/Event Sourcing "porque é moderno" em domínio simples.
- Eventos mal definidos (genéricos demais ou acoplados à implementação).
- Ignorar **idempotência** e **ordenação**/entrega duplicada em consumidores.
- Não versionar o schema dos eventos.

## Boas práticas

- Eventos no **passado e no domínio** (`PedidoConfirmado`, não `AtualizarTabela`).
- Consumidores **idempotentes**; lidar com entrega "at-least-once".
- Começar simples; introduzir CQRS/ES só onde o valor é claro.
- Observabilidade e tracing distribuído desde o início.

## Conceitos relacionados

- [[Arquitetura de Software - Fundamentos]]
- [[34 - MICROSERVICOS/_INDEX|Microsserviços]]
- [[36 - MENSAGERIA/_INDEX|Mensageria (Kafka, RabbitMQ)]]
- [[Domain-Driven Design (DDD)]] (Domain Events)
- [[Teorema CAP e Sistemas Distribuidos]]

## Perguntas importantes

### CQRS e Event Sourcing são a mesma coisa?
Não. CQRS separa leitura de escrita; Event Sourcing guarda o estado como eventos. Combinam bem, mas cada um pode ser usado sem o outro.

### EDA sempre implica microsserviços?
Não. EDA é um paradigma de comunicação; pode existir dentro de um monolito (eventos internos) ou entre serviços.

## Fontes

1. Wikipedia — Event-driven architecture — https://en.wikipedia.org/wiki/Event-driven_architecture (consultado 2026-09-03)
2. Fowler, M. — "CQRS" — https://martinfowler.com/bliki/CQRS.html
3. Fowler, M. — "Event Sourcing" — https://martinfowler.com/eaaDev/EventSourcing.html
4. Greg Young — palestras/artigos sobre CQRS e Event Sourcing.

## Observações

Criar notas próprias: Saga vs Event choreography, projeções, idempotência. Status: verified (EDA confirmado na fonte 1; CQRS/ES por fontes canônicas de Fowler).
