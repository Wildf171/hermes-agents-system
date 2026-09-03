---
title: "Padrões de Mensageria e Garantias de Entrega"
category: "36 - MENSAGERIA"
tags:
  - engenharia-software
  - mensageria
  - padroes
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Padrões de Mensageria e Garantias de Entrega

## Resumo

Sistemas de mensageria confiáveis dependem de **padrões** bem estabelecidos (Enterprise Integration Patterns, Hohpe & Woolf) para lidar com **duplicação, falhas, ordenação e consistência entre serviços**. Os pilares práticos: entender as **garantias de entrega**, tornar consumidores **idempotentes**, usar **DLQ**, e resolver a consistência dados↔mensagem com o **Outbox Pattern**.

## Garantias de entrega

- **At-most-once** — no máximo uma vez (pode perder). Raramente aceitável.
- **At-least-once** — pelo menos uma vez; **pode duplicar** (o padrão da maioria dos brokers). Exige **idempotência**.
- **Exactly-once** — exatamente uma vez; difícil e custoso. Kafka oferece em cenários específicos (produtor idempotente + transações), mas fim-a-fim geralmente se simula com **at-least-once + idempotência**.

## Idempotência (o padrão mais importante)

Processar a **mesma mensagem duas vezes** deve ter o **mesmo efeito** que processar uma vez.
- **Chave de idempotência / dedup:** guardar ids de mensagens já processadas e ignorar repetidas.
- **Operações naturalmente idempotentes:** `set status = PAGO` (vs. `saldo += 100`, que não é).

```python
def consumir(msg):
    if repo.ja_processada(msg.id):   # dedup
        return ack(msg)
    aplicar_efeito(msg)
    repo.marcar_processada(msg.id)
    ack(msg)
```

## Dead Letter Queue (DLQ)

Fila para onde vão mensagens que **falham repetidamente** (poison messages) ou expiram. Evita que uma mensagem ruim trave o fluxo; permite inspeção/reprocessamento manual. Combine com **retry + backoff exponencial** (e limite de tentativas).

## Outbox Pattern (consistência dados ↔ evento)

Problema: salvar no banco **e** publicar um evento não é atômico (pode salvar e falhar ao publicar → inconsistência).
Solução: na **mesma transação** do banco, grave o evento em uma tabela **outbox**; um processo separado (ou CDC) lê a outbox e publica no broker.
```
BEGIN;
  INSERT INTO pedidos ...;
  INSERT INTO outbox (evento) VALUES ('PedidoCriado', ...);
COMMIT;                      -- atômico
-- Relay lê outbox → publica no broker (at-least-once) → marca enviado
```
Garante que o evento é publicado **se e somente se** os dados foram persistidos.

## Saga (transações distribuídas)

Sem commit global entre serviços, uma transação vira uma **sequência de passos locais** com **compensações** em caso de falha.
- **Coreografia** — serviços reagem a eventos uns dos outros (desacoplado; difícil de rastrear).
- **Orquestração** — um orquestrador central coordena os passos (mais visível; ponto central).
Ver [[Event-Driven, CQRS e Event Sourcing]].

## Outros padrões (EIP)

- **Competing Consumers** — vários consumidores escalam o processamento de uma fila.
- **Publish/Subscribe** — broadcast a múltiplos interessados.
- **Message Routing** — direct/topic/fanout ([[RabbitMQ]]).
- **Claim Check** — payload grande vai para storage; a mensagem carrega só uma referência.
- **Content-Based Router / Filter** — roteia por conteúdo.

## Ordenação

- Ordem total é cara em sistemas distribuídos. [[Apache Kafka|Kafka]] garante ordem **por partição**; use a **chave** para agrupar o que precisa ser ordenado (ex.: por `pedido_id`).

## Quando aplicar

- **Sempre:** idempotência + DLQ em qualquer consumidor de produção.
- **Outbox:** quando precisa consistência entre estado do banco e eventos publicados.
- **Saga:** transações que cruzam serviços.

## Erros comuns / Anti-patterns

- Consumidor não idempotente com at-least-once → duplica efeitos (cobrança dupla).
- Publicar evento fora da transação do banco (dual-write) → inconsistência (use Outbox).
- Sem DLQ nem limite de retry → loop de poison message.
- Assumir exactly-once "de graça".
- Depender de ordem global onde só há ordem por partição.

## Boas práticas

- **At-least-once + idempotência** como padrão mental.
- **Outbox** para dual-write; **Saga** para transações distribuídas.
- DLQ + retry com backoff + limite de tentativas.
- [[Observabilidade|Tracing distribuído]] para seguir mensagens entre serviços.

## Conceitos relacionados

- [[Mensageria - Fundamentos]]
- [[Apache Kafka]] · [[RabbitMQ]] · [[Kafka vs RabbitMQ]]
- [[Event-Driven, CQRS e Event Sourcing]]
- [[Teorema CAP e Sistemas Distribuidos]]
- [[Microsservicos]]

## Perguntas importantes

### Por que idempotência é tão importante em mensageria?
Porque a garantia usual é **at-least-once** (pode duplicar). Se processar a mesma mensagem duas vezes causar efeito duplicado (ex.: cobrar duas vezes), o sistema está errado. Idempotência neutraliza duplicatas.

### O que o Outbox Pattern resolve?
O problema do **dual-write**: salvar no banco e publicar um evento de forma atômica. Grava-se o evento na mesma transação (tabela outbox) e um relay publica depois — garantindo consistência.

## Fontes

1. Hohpe, G. & Woolf, B. — *Enterprise Integration Patterns* — https://www.enterpriseintegrationpatterns.com
2. Microservices.io — Outbox / Saga (Chris Richardson) — https://microservices.io/patterns/
3. Kleppmann — *Designing Data-Intensive Applications* (2017).

## Observações

Criar notas próprias: Saga (coreografia vs orquestração), Outbox + CDC, exactly-once no Kafka. Status: verified.
