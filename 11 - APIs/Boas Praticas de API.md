---
title: "Boas Práticas de API"
category: "11 - APIs"
tags:
  - engenharia-software
  - api
  - boas-praticas
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Boas Práticas de API

## Resumo

Independente do estilo ([[APIs REST - Fundamentos e Design|REST]], [[GraphQL]], [[gRPC]]), APIs de produção compartilham práticas de **versionamento, paginação, tratamento de erros, rate limiting, idempotência, segurança e documentação**. Elas tornam a API previsível, evolutiva e segura.

## Versionamento

Permite evoluir sem quebrar clientes existentes.
- **Na URL:** `/v1/pedidos` (mais comum e explícito).
- **Por header:** `Accept: application/vnd.api.v2+json`.
- **GraphQL:** normalmente evolui o schema (deprecar campos) em vez de versionar.
- Regra: **mudança incompatível → nova versão**; mudança aditiva → mesma versão.

## Paginação

Nunca retorne coleções ilimitadas.
- **Offset/limit:** `?page=2&limit=20` — simples, mas ruim para dados que mudam.
- **Cursor-based:** `?cursor=abc` — estável e eficiente para grandes volumes (recomendado).
- Inclua metadados: total, próximo cursor, links.

## Tratamento de erros

Padronize um **formato de erro** consistente:
```json
{ "error": { "code": "PEDIDO_NAO_ENCONTRADO",
             "message": "Pedido 42 não existe",
             "details": [] } }
```
- Use **status HTTP corretos** (404, 409, 422, 429…).
- Não vaze stack traces/detalhes internos (segurança).
- Padrão emergente: **RFC 9457 (Problem Details for HTTP APIs)**.

## Idempotência

Operações repetidas não devem duplicar efeitos (importante para **retries** em rede instável).
- GET/PUT/DELETE são idempotentes por natureza; **POST não**.
- Para POST seguro em retries: **Idempotency-Key** (header com id único que o servidor usa para deduplicar).

## Rate Limiting & Throttling

Protege contra abuso e sobrecarga.
- Limite por cliente/token/IP (ex.: token bucket).
- Responda **429 Too Many Requests** com headers `Retry-After` e `X-RateLimit-*`.

## Segurança (essencial)

- **HTTPS/TLS** sempre ([[Redes - TCP-IP, HTTP, DNS e TLS]]).
- **AuthN/AuthZ** por requisição ([[Autenticacao vs Autorizacao]], [[OAuth 2.0 e OpenID Connect]], [[JWT (JSON Web Token)]]).
- **Validação de entrada** (evita [[OWASP Top 10|injection]]).
- **CORS** configurado corretamente (não `*` para APIs autenticadas).
- Menor privilégio nos escopos/tokens.
- Seguir o [[OWASP Top 10]] (e o OWASP API Security Top 10).

## Documentação

- **OpenAPI/Swagger** (REST), **SDL** (GraphQL), **`.proto`** (gRPC) — contrato como fonte de verdade.
- Docs interativas; exemplos de request/response; changelog.

## Design geral

- **Consistência** de nomes, formatos de data (ISO 8601), casing (snake/camel) — escolha um.
- Filtros/ordenção padronizados (`?status=ativo&sort=-criado_em`).
- **HATEOAS**/links quando fizer sentido.
- Campos de resposta previsíveis; evite quebrar contratos.

## Exemplo prático (erros + paginação, FastAPI)

```python
@app.get("/pedidos")
def listar(limit: int = 20, cursor: str | None = None):
    itens, prox = repo.page(limit=min(limit, 100), cursor=cursor)
    return {"data": itens, "next_cursor": prox}

@app.post("/pagamentos", status_code=201)
def pagar(dados: PagamentoIn, idempotency_key: str = Header(...)):
    if (existente := repo.by_key(idempotency_key)):
        return existente          # dedup: retry seguro
    return repo.create(dados, idempotency_key)
```

## Erros comuns / Anti-patterns

- Não versionar → quebra clientes ao evoluir.
- Retornar listas sem paginação (explode memória/latência).
- Erros sem padrão / status errados.
- POST não idempotente sem Idempotency-Key → cobranças duplicadas em retry.
- `CORS: *` em API autenticada; validação só no cliente.

## Boas práticas (resumo)

- Versione, pagine (cursor), padronize erros (RFC 9457).
- Idempotência para retries; rate limiting com 429.
- HTTPS, authN/authZ por request, validação, CORS restrito.
- Documente com OpenAPI; seja consistente.

## Conceitos relacionados

- [[APIs REST - Fundamentos e Design]]
- [[GraphQL]] · [[gRPC]] · [[REST vs GraphQL vs gRPC]]
- [[19 - SEGURANCA/_INDEX|Segurança]] · [[OWASP Top 10]]
- [[Redes - TCP-IP, HTTP, DNS e TLS]]

## Perguntas importantes

### Como tornar um POST seguro para retry?
Use uma **Idempotency-Key**: o cliente envia um id único; o servidor deduplica requisições repetidas, evitando efeitos duplicados.

### Offset ou cursor para paginação?
**Cursor** para grandes volumes/dados que mudam (estável e eficiente). Offset é simples, mas sofre com inserções/remoções concorrentes.

## Fontes

1. RFC 9457 — Problem Details for HTTP APIs — https://www.rfc-editor.org/rfc/rfc9457
2. OWASP API Security Top 10 — https://owasp.org/API-Security/
3. MDN — HTTP (status, CORS, headers) — https://developer.mozilla.org/docs/Web/HTTP
4. Microsoft/Google API Design Guides — https://cloud.google.com/apis/design

## Observações

Criar notas: OpenAPI a fundo, OWASP API Security Top 10, estratégias de rate limiting. Status: verified.
