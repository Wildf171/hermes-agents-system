---
title: "Autenticação vs Autorização"
category: "19 - SEGURANCA"
tags:
  - engenharia-software
  - seguranca
  - autenticacao
  - autorizacao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Autenticação vs Autorização

## Resumo

**Autenticação (AuthN)** verifica **quem você é**; **Autorização (AuthZ)** verifica **o que você pode fazer**. São etapas distintas e sequenciais: primeiro autentica, depois autoriza. Confundi-las é fonte comum de falhas (o risco nº 1 do [[OWASP Top 10]] é justamente **Broken Access Control** — falha de autorização).

## O que é cada uma?

### Autenticação (AuthN) — "Quem é você?"
Confirma a identidade do usuário/sistema. Fatores:
- **Algo que você sabe** — senha, PIN.
- **Algo que você tem** — token, celular (OTP), chave.
- **Algo que você é** — biometria.
- **MFA (multifator)** — combina 2+ fatores; forte contra roubo de senha.

### Autorização (AuthZ) — "O que você pode fazer?"
Após autenticado, decide quais recursos/ações são permitidos. Modelos:
- **RBAC (Role-Based)** — permissões por papel (admin, editor, viewer).
- **ABAC (Attribute-Based)** — decisão por atributos (departamento, hora, localização).
- **ACL** — lista de permissões por recurso.

## Por que importa?

Separar as duas evita brechas. **Broken Access Control** (autorização mal feita) é o risco mais crítico do OWASP: usuário autenticado acessando dados/ações de outro (IDOR, escalada de privilégio).

## Como funciona? (fluxo típico)

```
1. Login (AuthN): valida credenciais -> emite sessão/token (ex.: [[JWT (JSON Web Token)|JWT]])
2. Requisição: cliente envia o token/cookie
3. Servidor valida o token (AuthN da requisição)
4. Servidor checa permissões (AuthZ) para AQUELE recurso/ação
5. Permite ou nega (403)
```

Códigos HTTP: **401 Unauthorized** = não autenticado (na prática, "não identificado"); **403 Forbidden** = autenticado, mas **sem permissão**.

## Exemplo prático

```python
@app.delete("/pedidos/{id}")
def deletar(id, user = Depends(auth)):        # AuthN: quem é o user
    pedido = repo.get(id)
    if pedido.dono_id != user.id and not user.is_admin:
        raise HTTPException(403)               # AuthZ: pode este user?
    repo.delete(id)
```

## Quando utilizar

Sempre. Toda aplicação com usuários precisa de AuthN; toda que tem recursos protegidos precisa de AuthZ **no servidor**, por requisição.

## Quando NÃO utilizar (armadilha)

- Nunca confie em autorização **só no frontend** (esconder botão ≠ proteger). AuthZ é sempre **server-side**.

## Erros comuns / Anti-patterns

- **IDOR** — usar id do recurso sem checar dono (`/pedidos/123` de outro usuário).
- Autorização só no cliente.
- Confundir 401 e 403.
- "Confused deputy" — serviço age com privilégios que o chamador não deveria ter.
- Verificar papel por **igualdade** em vez de hierarquia (ex.: sistemas com "papel ou maior").

## Boas práticas

- **Deny by default**; conceder explicitamente (menor privilégio).
- Checar AuthZ em **todo** endpoint, por recurso.
- **MFA** para contas sensíveis.
- Centralizar a lógica de autorização (policies), testá-la.

## Conceitos relacionados

- [[OWASP Top 10]] (A01 Broken Access Control, A07 Authentication Failures)
- [[OAuth 2.0 e OpenID Connect]]
- [[JWT (JSON Web Token)]]
- [[Criptografia - Hashing, Encryption e Senhas]]

## Perguntas importantes

### Qual a diferença entre autenticação e autorização?
Autenticação = **quem você é** (identidade). Autorização = **o que você pode fazer** (permissões). Autentica primeiro, autoriza depois.

### 401 ou 403?
**401** = falta autenticação válida. **403** = autenticado, mas sem permissão para o recurso.

## Fontes

1. OWASP Top 10 — A01 Broken Access Control / A07 — https://owasp.org/Top10/ (consultado 2026-09-03)
2. OWASP — Authentication Cheat Sheet — https://cheatsheetseries.owasp.org/
3. NIST SP 800-63 — Digital Identity Guidelines.

## Observações

Aprofundar RBAC vs ABAC e sessões vs tokens em notas próprias. Status: verified.
