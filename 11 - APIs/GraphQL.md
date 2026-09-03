---
title: "GraphQL"
category: "11 - APIs"
tags:
  - engenharia-software
  - api
  - graphql
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# GraphQL

## Resumo

**GraphQL** é uma **linguagem de consulta e manipulação de dados** para APIs que permite ao cliente **especificar exatamente quais dados quer** ("declarative data fetching"). Criado pelo **Facebook/Meta** (desenvolvido em 2012, open source em **2015**; hoje sob a **GraphQL Foundation** / Linux Foundation). Um único endpoint resolve consultas que podem combinar dados de várias fontes em um **grafo unificado**.

## O que é?

Em vez de vários endpoints REST, o cliente envia **uma query** descrevendo a forma exata da resposta. O servidor tem um **schema** tipado (SDL) e **resolvers** que buscam os dados de cada campo. Não é atrelado a nenhum banco.

## Por que existe?

Resolve dois problemas clássicos do REST:
- **Over-fetching** — REST devolve campos demais.
- **Under-fetching** — precisar de várias chamadas REST para montar uma tela (N+1 de rede).

Com GraphQL, o cliente pede só o que precisa, em **uma requisição**.

## Como funciona? — Operações

- **Query** — leitura.
- **Mutation** — escrita.
- **Subscription** — atualizações em tempo real (geralmente via WebSockets).

### Schema (SDL) + Resolvers
```graphql
type Pedido { id: ID!, total: Float!, itens: [Item!]! }
type Query { pedido(id: ID!): Pedido }
```
```graphql
# Cliente pede exatamente estes campos:
query { pedido(id: "42") { total itens { nome } } }
```
Cada campo tem um **resolver** que sabe buscar aquele dado.

## Quando utilizar

- Clientes com **necessidades de dados variadas** (mobile + web + parceiros).
- Telas que agregam muitas entidades (evita múltiplas chamadas).
- APIs voltadas a produto que evoluem rápido (o cliente escolhe os campos).
- Adotado por GitHub, Shopify, Meta, Yelp.

## Quando NÃO utilizar

- CRUD simples → REST é mais direto e cacheável.
- Quando **cache HTTP** e simplicidade de infra importam muito (GraphQL usa 1 endpoint POST; cache é mais complexo).
- Comunicação interna de altíssimo desempenho → [[gRPC]].

## Trade-offs

- **Ganha:** sem over/under-fetching, tipado, evolução sem versionar, um endpoint.
- **Perde:** cache HTTP difícil, complexidade no servidor, risco de queries caras/abusivas, curva de aprendizado.

## Erros comuns / Anti-patterns

- **Problema N+1** nos resolvers (buscar item por item) → use **DataLoader** (batch).
- Não limitar **profundidade/complexidade** da query → cliente pode derrubar o servidor.
- Expor o grafo inteiro sem autorização por campo.
- Ignorar caching e persisted queries.

## Boas práticas

- **DataLoader** para batching; evitar N+1.
- **Limites** de profundidade/complexidade e timeouts.
- Autorização por campo/tipo ([[Autenticacao vs Autorizacao]]).
- Persisted queries e APQ para performance/segurança.
- Versionamento por **evolução do schema** (deprecar campos) em vez de v1/v2.

## Conceitos relacionados

- [[APIs REST - Fundamentos e Design]]
- [[gRPC]]
- [[REST vs GraphQL vs gRPC]]
- [[Boas Praticas de API]]

## Perguntas importantes

### GraphQL substitui REST?
Não necessariamente. Resolve over/under-fetching e brilha com clientes variados, mas REST continua ótimo para CRUD simples e cache HTTP. Muitas empresas usam os dois.

### Como versionar uma API GraphQL?
Geralmente **sem versões numeradas**: adiciona-se campos novos e **deprecam-se** os antigos, evoluindo o schema de forma contínua.

## Fontes

1. Wikipedia — GraphQL — https://en.wikipedia.org/wiki/GraphQL (consultado 2026-09-03)
2. Especificação oficial — https://spec.graphql.org
3. graphql.org — https://graphql.org/learn/

## Observações

Criar notas: DataLoader/N+1, subscriptions, segurança de GraphQL. Status: verified.
