---
title: "Criptografia - Hashing, Encryption e Senhas"
category: "19 - SEGURANCA"
tags:
  - engenharia-software
  - seguranca
  - criptografia
  - hashing
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Criptografia — Hashing, Encryption e Senhas

## Resumo

Três conceitos frequentemente confundidos: **Hashing** é uma via única (irreversível), para **verificar integridade** e **guardar senhas**; **Encryption** é reversível (com chave), para **confidencialidade**; **Encoding** (ex.: Base64) **não é segurança** — só representação. Escolher errado é uma das causas de **Cryptographic Failures** (A04 do [[OWASP Top 10]]).

## Hashing (função de hash criptográfica)

Mapeia entrada de tamanho arbitrário para uma saída **fixa** de n bits. Propriedades:
- **Unidirecional** — rápido de calcular, inviável de reverter (pré-imagem).
- **Efeito avalanche** — mudança mínima na entrada → hash totalmente diferente.
- **Resistência a colisão** — difícil achar duas entradas com o mesmo hash.

Usos: **verificar integridade** (checksums), **assinaturas digitais**, **armazenar senhas**.
- Famílias: **SHA-2** (SHA-256), **SHA-3**. ❌ **MD5** e **SHA-1** estão **quebrados** (colisões) — não usar para segurança.

## Hashing de SENHAS (caso especial)

Para senhas, um hash rápido (SHA-256) é **ruim** — atacantes testam bilhões/seg. Use hashes **lentos e com sal**, desenhados para senha:
- **bcrypt**, **scrypt**, **Argon2** (recomendado atual), **PBKDF2**.
- **Salt** — valor aleatório por senha; impede rainbow tables e que senhas iguais gerem o mesmo hash.
- **Work factor / cost** — ajustável para acompanhar o hardware.

> Regra: **nunca** guarde senha em texto puro nem com MD5/SHA1. Use Argon2/bcrypt com salt.

## Encryption (criptografia reversível)

Transforma dados para que só quem tem a **chave** os leia. Dois tipos:
- **Simétrica** — mesma chave cifra e decifra (ex.: **AES**). Rápida; problema é distribuir a chave.
- **Assimétrica** — par **pública/privada** (ex.: **RSA**, **ECC**). A pública cifra / verifica; a privada decifra / assina. Base de TLS, PGP, assinaturas.

Usos: dados em trânsito ([[Redes - TCP-IP, HTTP, DNS e TLS|TLS]]), dados em repouso (disco/BD), mensagens.

## Encoding ≠ Criptografia

**Base64, URL-encoding, hex** são **representação**, reversíveis por qualquer um, **sem chave**. Não protegem nada. (O payload de um [[JWT (JSON Web Token)|JWT]] é só Base64 — legível!)

## Comparação rápida

| | Reversível? | Usa chave? | Para quê |
|---|---|---|---|
| **Hashing** | Não | Não | Integridade, senhas |
| **Encryption** | Sim | Sim | Confidencialidade |
| **Encoding** | Sim | Não | Representação (não é segurança) |

## Exemplo prático

```python
# Senha: hash lento + salt (bcrypt/argon2), NUNCA sha256 puro
from argon2 import PasswordHasher
ph = PasswordHasher()
hash = ph.hash("senha-do-usuario")   # inclui salt e parâmetros
ph.verify(hash, "senha-do-usuario")  # valida no login

# Integridade de arquivo (não-senha): SHA-256 é ok
import hashlib
hashlib.sha256(open("f.bin","rb").read()).hexdigest()
```

## Quando utilizar

- **Hashing (SHA-2):** checksums, assinaturas, deduplicação.
- **Hashing de senha (Argon2/bcrypt):** armazenar credenciais.
- **Encryption simétrica (AES):** dados em repouso/volume.
- **Encryption assimétrica (RSA/ECC):** troca de chaves, assinaturas, TLS.

## Quando NÃO utilizar (armadilhas)

- **Nunca invente sua própria cripto** — use bibliotecas testadas.
- Não use hash rápido (SHA-256) para senhas.
- Não use Base64 achando que é segurança.
- MD5/SHA-1 para segurança: proibidos.

## Erros comuns / Anti-patterns

- Senhas em texto puro ou com MD5.
- Hash de senha sem salt.
- Chaves/segredos hardcoded no código ou versionados.
- Reuso de IV/nonce; modo de cifra inseguro (ex.: AES-ECB).
- Confundir encoding com encryption.

## Boas práticas

- **Argon2/bcrypt + salt** para senhas.
- **AES-GCM** (autenticado) para dados; **TLS** em trânsito.
- Gestão de segredos (Vault, KMS); rotação de chaves.
- Seguir bibliotecas/padrões; princípio de menor exposição.

## Conceitos relacionados

- [[OWASP Top 10]] (A04 Cryptographic Failures)
- [[JWT (JSON Web Token)]]
- [[Autenticacao vs Autorizacao]]
- [[Redes - TCP-IP, HTTP, DNS e TLS]]

## Perguntas importantes

### Qual a diferença entre hashing e encryption?
Hashing é **irreversível** e sem chave (integridade/senhas). Encryption é **reversível com chave** (confidencialidade).

### Como guardar senha corretamente?
Com um hash **lento e salgado** feito para senhas: **Argon2** (preferido), bcrypt ou scrypt. Nunca texto puro, MD5 ou SHA-256 puro.

### Base64 é seguro?
Não. É **encoding** (representação), reversível por qualquer um. Não oferece nenhuma proteção.

## Fontes

1. Wikipedia — Cryptographic hash function — https://en.wikipedia.org/wiki/Cryptographic_hash_function (consultado 2026-09-03)
2. OWASP — Password Storage Cheat Sheet — https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
3. NIST — SHA-2/SHA-3 (FIPS 180-4, FIPS 202); OWASP A04 Cryptographic Failures.

## Observações

Aprofundar: AES modos (GCM), assinatura digital, PKI/certificados, gestão de segredos. Status: verified.
