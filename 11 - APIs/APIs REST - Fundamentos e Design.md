---
title: "APIs REST - Fundamentos e Design"
category: "11 - APIs"
tags:
  - engenharia-software
  - api
  - rest
  - http
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# APIs REST — Fundamentos e Design

## Resumo

**REST (Representational State Transfer)** é um **estilo arquitetural** definido por **Roy Fielding** (dissertação de doutorado, **2000**) para sistemas distribuídos em escala de internet — nasceu para descrever a arquitetura da Web. Uma API "RESTful" usa **HTTP** de forma padronizada: recursos identificados por URLs, manipulados por verbos HTTP, com respostas em representações (geralmente JSON).

## O que é?

REST não é um protocolo, e sim um conjunto de **restrições (constraints)**. Uma API que as respeita é *RESTful*. O termo "RESTful" hoje é comumente associado ao **design de APIs HTTP** e às boas práticas de verbos/recursos — às vezes distante do REST original de Fielding.

## As 6 restrições REST

1. **Client-Server** — separação de responsabilidades (UI × dados).
2. **Stateless** — cada requisição contém tudo que é preciso; o servidor não guarda estado de sessão.
3. **Cacheable** — respostas indicam se podem ser cacheadas.
4. **Uniform Interface** — interface uniforme (recursos, verbos, representações, HATEOAS).
5. **Layered System** — camadas (proxies, gateways) transparentes.
6. **Code on Demand** (opcional) — servidor pode enviar código executável.

## Como funciona? — Design de recursos

### Recursos e URLs (substantivos, no plural)
```
GET    /pedidos           # lista
POST   /pedidos           # cria
GET    /pedidos/42        # obtém um
PUT    /pedidos/42        # substitui
PATCH  /pedidos/42        # atualiza parcial
DELETE /pedidos/42        # remove
GET    /pedidos/42/itens  # sub-recurso
```
- Use **substantivos**, não verbos (`/pedidos`, não `/criarPedido`).
- Hierarquia por sub-recursos.

### Verbos HTTP e semântica
| Método | Ação | Idempotente? | Seguro? |
|---|---|---|---|
| GET | ler | sim | sim (não altera) |
| POST | criar | não | não |
| PUT | substituir | sim | não |
| PATCH | atualizar parcial | não* | não |
| DELETE | remover | sim | não |

*idempotência do PATCH depende da implementação. Ver [[Boas Praticas de API]].

### Status HTTP (use os corretos)
- **2xx** sucesso (200 OK, 201 Created, 204 No Content)
- **3xx** redirecionamento (301, 304 Not Modified)
- **4xx** erro do cliente (400, 401, 403, 404, 409, 422, 429)
- **5xx** erro do servidor (500, 502, 503)

### HATEOAS
Respostas incluem **links** para as próximas ações/recursos — o cliente descobre a navegação. É a restrição menos adotada na prática (nível 3 do Richardson Maturity Model).

## Richardson Maturity Model

Mede quão RESTful é uma API:
- **Nível 0** — HTTP como túnel (um endpoint, tudo POST).
- **Nível 1** — recursos (URLs distintas).
- **Nível 2** — verbos HTTP + status corretos (a maioria das "APIs REST").
- **Nível 3** — HATEOAS (hypermedia).

## Documentação: OpenAPI

**OpenAPI (Swagger)** é o padrão para descrever APIs REST — gera docs interativas, clientes e validação. [[07 - DESIGN DE SOFTWARE/_INDEX|Contrato]] legível por humanos e máquinas.

## Exemplo prático (FastAPI)

```python
@app.get("/pedidos/{id}", status_code=200)
def obter(id: int):
    pedido = repo.get(id)
    if not pedido:
        raise HTTPException(404, "Pedido não encontrado")
    return pedido

@app.post("/pedidos", status_code=201)
def criar(dados: PedidoIn):
    return repo.create(dados)
```

## Quando utilizar

- APIs web públicas/internas de propósito geral (CRUD sobre recursos).
- Quando cache HTTP, simplicidade e ampla compatibilidade importam.

## Quando NÃO utilizar

- Necessidades de dados muito variáveis por cliente → considere [[GraphQL]].
- Comunicação interna de altíssimo desempenho/streaming → considere [[gRPC]].

## Erros comuns / Anti-patterns

- Verbos na URL (`/getPedido`, `/deleteUser`).
- Usar 200 para tudo (inclusive erros).
- Endpoints não idempotentes onde deveriam ser.
- Ignorar versionamento e paginação (ver [[Boas Praticas de API]]).
- Vazar detalhes internos nas respostas de erro.

## Boas práticas

- Substantivos + verbos HTTP + status corretos (nível 2 no mínimo).
- **Versionar** a API; **paginar** coleções; padronizar **erros**.
- Documentar com **OpenAPI**; validar entradas.
- HTTPS sempre ([[Redes - TCP-IP, HTTP, DNS e TLS|TLS]]).

## Conceitos relacionados

- [[Redes - TCP-IP, HTTP, DNS e TLS]]
- [[GraphQL]] · [[gRPC]] · [[REST vs GraphQL vs gRPC]]
- [[Boas Praticas de API]]
- [[19 - SEGURANCA/_INDEX|Segurança de APIs]]
- [[FastAPI - Introduction]]

## Perguntas importantes

### REST é um protocolo?
Não. É um **estilo arquitetural** (conjunto de restrições). HTTP é o protocolo usado pela maioria das APIs REST.

### O que é idempotência em HTTP?
Uma operação é idempotente se repeti-la produz o mesmo efeito de fazê-la uma vez (GET, PUT, DELETE). POST normalmente não é. Importa para retries seguros.

## Fontes

1. Wikipedia — REST — https://en.wikipedia.org/wiki/REST (consultado 2026-09-03)
2. Fielding, R. (2000). Dissertação — Architectural Styles and the Design of Network-based Software Architectures.
3. OpenAPI Specification — https://spec.openapis.org
4. MDN — HTTP methods/status — https://developer.mozilla.org/docs/Web/HTTP

## Observações

Criar notas próprias: status HTTP em detalhe, OpenAPI/Swagger, Richardson Maturity, HATEOAS. Status: verified.
