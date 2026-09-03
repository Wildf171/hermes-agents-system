---
title: "Microsserviços"
category: "34 - MICROSERVICOS"
tags:
  - engenharia-software
  - microservicos
  - arquitetura
  - distribuidos
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Microsserviços

## Resumo

**Arquitetura de microsserviços** organiza a aplicação como uma coleção de **serviços pequenos, fracamente acoplados e independentemente implantáveis**, cada um modelado em torno de uma **capacidade de negócio** e comunicando-se por protocolos leves. Ganha modularidade, escalabilidade e autonomia de times — ao custo de **complexidade distribuída**.

## O que é?

Não há definição única universal, mas caracterizam-se por:
- Cada serviço em torno de uma **capacidade de negócio** específica.
- **Fracamente acoplados** e **independentemente implantáveis/escaláveis**.
- Associados a **[[Domain-Driven Design (DDD)|DDD]]**, **descentralização** de dados e governança, e liberdade de tecnologia por serviço (**polyglot**).

Contrasta com o **monolito** (aplicação única). Popularizado por James Lewis e **Martin Fowler** (2014).

## Por que existe?

Permitir que **times e serviços evoluam e escalem independentemente**. No monolito, escalar uma função exige escalar tudo; com microsserviços, escala-se só o serviço com gargalo — otimizando recursos e custo.

## Como funciona?

- **Comunicação:** síncrona (REST/gRPC) ou assíncrona ([[35 - EVENT DRIVEN/_INDEX|eventos]]/[[36 - MENSAGERIA/_INDEX|mensageria]]).
- **Dados descentralizados:** cada serviço com seu banco (database-per-service) → evita acoplamento por dados.
- **Infra:** cloud-native, containers ([[15 - DEVOPS/_INDEX|Docker/Kubernetes]]), CI/CD, service discovery, API gateway.
- **Observabilidade** ([[20 - OBSERVABILIDADE/_INDEX]]) é obrigatória (logs, métricas, tracing distribuído).
- **Resiliência:** timeouts, retries, circuit breaker, bulkhead.

## Conceitos fundamentais

- **Bounded Context ≈ serviço** (fronteira vinda do DDD).
- **Saga** — transações distribuídas via sequência de passos compensáveis (não há commit global).
- **Consistência eventual** — trade-off imposto por dados distribuídos ([[Teorema CAP e Sistemas Distribuidos|CAP]]).
- **API Gateway / BFF** — ponto de entrada e agregação.

## Quando utilizar

- Sistemas grandes com **múltiplos times** que precisam de autonomia.
- Partes com **necessidades de escala muito diferentes**.
- Organização madura em **DevOps/CI-CD e observabilidade**.

## Quando NÃO utilizar

- Startups/MVP e sistemas pequenos → comece com **monolito modular** ("Monolith First", Fowler).
- Time sem maturidade de automação/observabilidade → a complexidade distribuída esmaga os ganhos.

## Trade-offs

- **Ganha:** deploy/escala independentes, isolamento de falhas, liberdade tecnológica, times autônomos.
- **Perde:** complexidade operacional, latência de rede, consistência eventual, testes/depuração distribuídos mais difíceis.

## Erros comuns / Anti-patterns

- **Monólito distribuído** — serviços tão acoplados que precisam ser deployados juntos (pior dos dois mundos).
- **Nanoservices** — serviços pequenos demais → overhead de comunicação.
- Banco compartilhado entre serviços (acoplamento por dados).
- Comunicação síncrona em cadeia (falha em cascata, alta latência).
- Adotar sem CI/CD e observabilidade.

## Boas práticas

- **Comece monolito, extraia serviços** quando a dor justificar.
- Fronteiras por **capacidade de negócio / bounded context**.
- **Database per service**; comunicação assíncrona onde possível.
- Padrões de resiliência (circuit breaker) e tracing distribuído.

## Conceitos relacionados

- [[Arquitetura de Software - Fundamentos]]
- [[Domain-Driven Design (DDD)]]
- [[35 - EVENT DRIVEN/_INDEX|Event-Driven / CQRS]]
- [[36 - MENSAGERIA/_INDEX|Mensageria (Kafka, RabbitMQ)]]
- [[Teorema CAP e Sistemas Distribuidos]]
- [[15 - DEVOPS/_INDEX|DevOps]]

## Perguntas importantes

### Monolito ou microsserviços?
Comece com **monolito (modular)**. Migre para microsserviços quando houver necessidade real de escala/independência e maturidade de DevOps — não por moda.

### Microsserviço = um serviço bem pequeno?
Não necessariamente. O "micro" é sobre **escopo de responsabilidade** (uma capacidade de negócio), não sobre linhas de código. Serviços pequenos demais viram anti-pattern.

## Fontes

1. Wikipedia — Microservices — https://en.wikipedia.org/wiki/Microservices (consultado 2026-09-03)
2. Lewis, J. & Fowler, M. (2014) — "Microservices" — https://martinfowler.com/articles/microservices.html
3. Newman, S. — *Building Microservices* (O'Reilly).

## Observações

Criar notas próprias: Saga, API Gateway, Circuit Breaker, database-per-service. Status: verified.
