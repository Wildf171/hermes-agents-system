---
title: "JWT (JSON Web Token)"
category: "19 - SEGURANCA"
tags:
  - engenharia-software
  - seguranca
  - jwt
  - tokens
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# JWT — JSON Web Token

## Resumo

**JWT** é um padrão (**RFC 7519**, IETF) para representar **claims** (afirmações) em um token compacto, URL-safe e **assinado** (e opcionalmente criptografado). É muito usado para transportar identidade/autorização entre serviços, especialmente em **SSO** e APIs stateless.

## O que é?

Um token que carrega dados JSON assinados. Estrutura: **três partes separadas por ponto**, cada uma em Base64URL:

```
header.payload.signature
```

### Header
Algoritmo e tipo:
```json
{ "alg": "HS256", "typ": "JWT" }
```
Algoritmos comuns: **HS256** (HMAC-SHA256, chave secreta) e **RS256** (RSA, par de chaves pública/privada).

### Payload (claims)
Afirmações sobre o usuário/token. Claims padrão: `sub` (subject/id), `iss` (issuer), `aud` (audience), `exp` (expiração), `iat` (emitido em), `nbf`.
```json
{ "sub": "42", "name": "Ana", "role": "admin", "exp": 1735689600 }
```

### Signature
Assinatura de `header.payload` com a chave — garante **integridade e autenticidade** (não foi adulterado; veio de quem tem a chave).

## Por que existe?

Permite verificação **stateless**: o servidor valida o token pela assinatura, sem consultar sessão no banco. Útil para APIs distribuídas e [[Microsservicos|microsserviços]].

## Como funciona?

```
1. Login -> servidor cria JWT assinado com sua chave e envia ao cliente
2. Cliente guarda o token e o envia em cada request (Authorization: Bearer <jwt>)
3. Servidor valida a assinatura + claims (exp, iss, aud) -> confia no conteúdo
```

> ⚠️ **JWT assinado ≠ criptografado.** O payload é apenas Base64 (legível por qualquer um). **Nunca** coloque segredos no payload. Para sigilo, use JWE.

## Quando utilizar

- APIs stateless, SSO, comunicação entre serviços.
- Access/ID tokens do [[OAuth 2.0 e OpenID Connect|OAuth/OIDC]].

## Quando NÃO utilizar (nuance)

- Como **sessão de longa duração revogável**: JWT é difícil de **revogar** antes de expirar (é stateless). Para logout imediato/revogação, sessões server-side ou listas de revogação são melhores.
- Para dados sensíveis no payload (não é sigiloso).

## Trade-offs

- **Ganha:** stateless, escalável, interoperável.
- **Perde:** revogação difícil, tamanho maior que um session id, risco se mal implementado.

## Erros comuns / Anti-patterns

- **`alg: none`** aceito pelo servidor → falsificação (vulnerabilidade clássica). Sempre fixar o algoritmo esperado.
- Confundir assinado com criptografado → colocar dados sensíveis no payload.
- Tokens de **vida longa** sem refresh → janela de ataque grande.
- Guardar JWT em `localStorage` (exposto a XSS).
- Não validar `exp`, `iss`, `aud`.

## Boas práticas

- Access token **curto** + refresh token rotativo.
- Validar assinatura **e** claims (`exp`, `iss`, `aud`); fixar `alg`.
- Chaves fortes; rotação de chaves (RS256 facilita).
- Considerar cookies `httpOnly`/`Secure` para o armazenamento no browser.

## Conceitos relacionados

- [[OAuth 2.0 e OpenID Connect]]
- [[Autenticacao vs Autorizacao]]
- [[Criptografia - Hashing, Encryption e Senhas]]
- [[OWASP Top 10]]

## Perguntas importantes

### JWT é criptografado?
Não por padrão. É **assinado** (integridade/autenticidade); o payload é apenas Base64URL, legível. Para confidencialidade use JWE.

### Como faço logout com JWT?
Como é stateless, não dá para "apagar" o token no servidor. Estratégias: expiração curta + refresh, blacklist/denylist de tokens, ou trocar a chave. Se precisa de revogação imediata, sessões server-side são melhores.

## Fontes

1. Wikipedia — JSON Web Token — https://en.wikipedia.org/wiki/JSON_Web_Token (consultado 2026-09-03)
2. RFC 7519 (JWT), RFC 7515 (JWS), RFC 7519/7518 (JWA) — IETF.
3. jwt.io — introdução e debugger — https://jwt.io

## Observações

Aprofundar: JWS vs JWE, rotação de chaves, refresh token rotation. Status: verified.
