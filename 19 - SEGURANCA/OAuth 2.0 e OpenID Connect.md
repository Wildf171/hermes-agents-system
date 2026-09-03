---
title: "OAuth 2.0 e OpenID Connect"
category: "19 - SEGURANCA"
tags:
  - engenharia-software
  - seguranca
  - oauth
  - oidc
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# OAuth 2.0 e OpenID Connect

## Resumo

**OAuth 2.0** é um padrão aberto (IETF) para **delegação de acesso**: permite que uma aplicação acesse recursos do usuário em outro serviço **sem receber a senha** dele, usando **access tokens**. **OpenID Connect (OIDC)** é uma camada de **autenticação** construída sobre o OAuth 2.0 (o "login com Google/GitHub"). Regra de ouro: **OAuth = autorização; OIDC = autenticação**.

## O que é?

OAuth resolve: "como o app X acessa meus dados no serviço Y sem eu dar minha senha para X?". O usuário autoriza no próprio serviço Y, que emite um **token** de acesso limitado para X. Criado em 2006 (OAuth 1.0); **OAuth 2.0** é o padrão atual.

## Papéis (roles)

- **Resource Owner** — o usuário dono dos dados.
- **Client** — a aplicação que quer acessar os dados.
- **Authorization Server** — autentica o usuário e emite tokens (ex.: Google).
- **Resource Server** — a API que guarda os recursos protegidos.

## Como funciona? — Authorization Code Flow (+ PKCE)

```
1. App redireciona o usuário ao Authorization Server
2. Usuário faz login e consente (no servidor, não no app)
3. Servidor retorna um "authorization code" ao app
4. App troca o code por um ACCESS TOKEN (back-channel)
5. App usa o token para chamar a API (Resource Server)
```
- **PKCE** (Proof Key for Code Exchange) — proteção obrigatória para apps públicos (SPA/mobile) contra interceptação do code.

### Grant types (fluxos)
- **Authorization Code (+ PKCE)** — padrão para web/SPA/mobile.
- **Client Credentials** — máquina-a-máquina (sem usuário).
- **Device Code** — TVs/dispositivos sem teclado.
- ⚠️ **Implicit** e **Resource Owner Password** — **legados/desencorajados**.

## Tokens

- **Access Token** — curto, dá acesso à API (frequentemente um [[JWT (JSON Web Token)|JWT]]).
- **Refresh Token** — obtém novos access tokens sem novo login.
- **ID Token (OIDC)** — JWT que **prova a identidade** do usuário (claims: sub, email, nome).

## OpenID Connect (OIDC)

Camada de **identidade** sobre OAuth 2.0. Adiciona o **ID Token** e o endpoint `/userinfo`. É o que viabiliza **SSO** e "Entrar com Google/Apple/GitHub". Use OIDC quando precisa **saber quem é o usuário** (login), não apenas acessar uma API.

## Quando utilizar

- **OAuth 2.0:** delegar acesso a APIs de terceiros; integrações M2M (client credentials).
- **OIDC:** login social/SSO; autenticação delegada.

## Quando NÃO utilizar (armadilhas)

- Não use OAuth **puro** para "login" (autenticação) — para isso use **OIDC**. OAuth sozinho é autorização.
- Evite os fluxos **Implicit** e **Password** (inseguros/legados).

## Erros comuns / Anti-patterns

- Usar access token como se fosse prova de identidade (é para acesso, não login → use ID Token).
- SPA/mobile sem **PKCE**.
- Guardar tokens em `localStorage` (exposto a XSS) sem considerar riscos; preferir cookies httpOnly quando aplicável.
- Escopos amplos demais (viola menor privilégio).

## Boas práticas

- **Authorization Code + PKCE** como padrão.
- Access tokens de **vida curta** + refresh tokens rotativos.
- Escopos mínimos; validar `aud`, `iss`, `exp` dos tokens.
- Sempre sobre **TLS** ([[Redes - TCP-IP, HTTP, DNS e TLS|HTTPS]]).

## Conceitos relacionados

- [[Autenticacao vs Autorizacao]]
- [[JWT (JSON Web Token)]]
- [[OWASP Top 10]]
- [[Redes - TCP-IP, HTTP, DNS e TLS]]

## Perguntas importantes

### Qual a diferença entre OAuth e OpenID Connect?
OAuth 2.0 é **autorização** (acesso delegado a recursos). OIDC é **autenticação** construída sobre o OAuth (adiciona o ID Token para provar quem é o usuário). "Login com Google" = OIDC.

### OAuth serve para login?
OAuth **puro** não; ele delega acesso, não prova identidade. Para login, use **OIDC** (que usa OAuth por baixo).

## Fontes

1. Wikipedia — OAuth — https://en.wikipedia.org/wiki/OAuth (consultado 2026-09-03)
2. RFC 6749 (OAuth 2.0) e RFC 7636 (PKCE) — IETF.
3. OpenID Connect — https://openid.net/connect/

## Observações

Criar notas próprias: cada grant type, PKCE detalhado, sessão vs token. Status: verified.
