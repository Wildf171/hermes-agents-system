---
title: "REST vs GraphQL vs gRPC"
category: "11 - APIs"
tags:
  - engenharia-software
  - api
  - comparacao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# REST vs GraphQL vs gRPC

## Resumo

Três estilos de API para necessidades diferentes: **REST** (recursos sobre HTTP, simples e universal), **GraphQL** (cliente escolhe os dados, ótimo para clientes variados), **gRPC** (RPC binário de alto desempenho, ideal entre serviços). Não há vencedor absoluto — **depende do contexto**.

## Comparação lado a lado

| Critério | REST | GraphQL | gRPC |
|---|---|---|---|
| Estilo | Recursos (HTTP) | Query language | RPC (procedimentos) |
| Transporte | HTTP/1.1+ | HTTP (1 endpoint POST) | **HTTP/2** |
| Formato | JSON (texto) | JSON (texto) | **Protobuf (binário)** |
| Contrato | OpenAPI (opcional) | **Schema (SDL)** | **`.proto`** |
| Over/under-fetching | Comum | **Resolvido** | Não (contrato fixo) |
| Streaming | Limitado (SSE/WebSocket) | Subscriptions | **Bidirecional nativo** |
| Cache HTTP | **Fácil (GET)** | Difícil | Não (binário) |
| Browser | **Nativo** | **Nativo** | Precisa gRPC-Web/proxy |
| Performance | Boa | Boa | **Excelente** |
| Curva | **Baixa** | Média | Média/Alta |

## Quando escolher cada um

### REST — o default
- APIs públicas/gerais, CRUD sobre recursos.
- Quando **cache HTTP**, simplicidade e compatibilidade universal importam.
- Ex.: API pública de um SaaS, backend de app web comum.

### GraphQL
- **Múltiplos clientes** com necessidades de dados diferentes (mobile, web, parceiros).
- Telas que **agregam muitas entidades** (evita várias chamadas).
- Produto que evolui rápido; cliente escolhe os campos.
- Ex.: API do GitHub, apps com UIs ricas e variadas.

### gRPC
- Comunicação **interna entre microsserviços** de alto desempenho.
- **Streaming** bidirecional, baixa latência.
- Ambientes polyglot com contrato `.proto` compartilhado.
- Ex.: malha de microsserviços, sistemas de tempo real.

## Regra prática de decisão

```
API pública / CRUD / cache               → REST
Clientes variados / evitar over-fetching → GraphQL
Serviço↔serviço, performance/streaming   → gRPC
```
Muitos sistemas **combinam**: REST/GraphQL na borda (browser/mobile) e gRPC internamente entre serviços.

## Trade-offs resumidos

- **REST:** simples e cacheável, mas over/under-fetching e muitos endpoints.
- **GraphQL:** flexível e tipado, mas cache difícil e risco de queries caras (N+1).
- **gRPC:** rápido e com streaming, mas binário, não nativo no browser, tooling mais complexo.

## Erros comuns

- Escolher por **hype** e não por necessidade (gRPC/GraphQL onde REST bastava).
- GraphQL sem controle de complexidade → queries abusivas.
- gRPC exposto a browser sem gRPC-Web.

## Boas práticas

- Comece **REST** salvo necessidade clara.
- Adote GraphQL/gRPC quando o trade-off compensar (medido, não presumido).
- Padronize segurança e observabilidade independentemente do estilo.

## Conceitos relacionados

- [[APIs REST - Fundamentos e Design]]
- [[GraphQL]]
- [[gRPC]]
- [[Boas Praticas de API]]
- [[Microsservicos]]

## Perguntas importantes

### Qual é o mais rápido?
**gRPC** (Protobuf binário + HTTP/2), especialmente para tráfego serviço-a-serviço. Mas "rápido" só importa se for o gargalo real.

### Posso usar mais de um?
Sim, e é comum: **REST/GraphQL** para clientes externos e **gRPC** para comunicação interna entre serviços.

## Fontes

1. Wikipedia — REST / GraphQL / gRPC (consultados 2026-09-03)
2. grpc.io, graphql.org, spec.openapis.org — documentações oficiais.
3. Martin Kleppmann — *Designing Data-Intensive Applications* (estilos de comunicação).

## Observações

Comparação de alto nível; medir no seu contexto antes de decidir. Status: verified.
