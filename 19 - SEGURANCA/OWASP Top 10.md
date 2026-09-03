---
title: "OWASP Top 10"
category: "19 - SEGURANCA"
tags:
  - engenharia-software
  - seguranca
  - owasp
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# OWASP Top 10

## Resumo

O **OWASP Top 10** é o documento de referência mais reconhecido sobre os **riscos de segurança mais críticos** em aplicações web. Publicado pela **OWASP** (Open Worldwide Application Security Project, fundada em 2001 por Mark Curphey), é atualizado periodicamente. A edição atual é a **2025**.

## O que é?

Uma lista consensual dos 10 riscos de segurança mais críticos, usada por desenvolvedores como **primeiro passo para código mais seguro**. Serve de base para padrões e programas de AppSec. Primeira edição em 2003; edições em 2004, 2007, 2010, 2013, 2017, 2021 e **2025**.

## OWASP Top 10:2025 (edição atual)

| # | Categoria | Do que se trata |
|---|---|---|
| **A01** | **Broken Access Control** | Falhas de autorização: usuário acessa o que não deveria (IDOR, escalada de privilégio) |
| **A02** | **Security Misconfiguration** | Configuração insegura (defaults, headers, permissões, verbosidade de erro) |
| **A03** | **Software Supply Chain Failures** | Riscos em dependências, build e pipeline (novo/expandido em 2025) |
| **A04** | **Cryptographic Failures** | Cripto ausente/fraca; dados sensíveis expostos |
| **A05** | **Injection** | SQL, NoSQL, comando, XSS — entrada não confiável interpretada como código |
| **A06** | **Insecure Design** | Falhas de projeto (falta threat modeling/controles por design) |
| **A07** | **Authentication Failures** | Autenticação quebrada (senhas fracas, sessão, brute force) |
| **A08** | **Software or Data Integrity Failures** | Deserialização insegura, updates/CI sem verificação de integridade |
| **A09** | **Security Logging and Alerting Failures** | Sem logs/alertas → ataques passam despercebidos |
| **A10** | **Mishandling of Exceptional Conditions** | Tratamento inadequado de erros/condições excepcionais (novo em 2025) |

> Mudanças de 2021→2025: entra **Software Supply Chain Failures** (A03) e **Mishandling of Exceptional Conditions** (A10); categorias reorganizadas.

## Por que existe?

Padroniza a conscientização sobre AppSec, dá vocabulário comum e prioriza onde investir esforço de segurança. Adotar o Top 10 é o passo mais efetivo para mudar a cultura de desenvolvimento rumo a código seguro.

## Como usar

- **Checklist** em code review e design ([[46 - CHECKLISTS/Security Audit Checklist|checklist de segurança]]).
- Base para **threat modeling** e testes de segurança (SAST/DAST, ex.: OWASP ZAP).
- Treinamento de devs.

## Mitigações-chave (por risco)

- **A01:** autorização server-side em todo endpoint; negar por padrão. Ver [[Autenticacao vs Autorizacao]].
- **A04:** [[Criptografia - Hashing, Encryption e Senhas|hashing forte de senhas]], TLS, não inventar cripto.
- **A05:** queries parametrizadas/ORM, validação e escaping de saída.
- **A07:** MFA, políticas de senha, [[JWT (JSON Web Token)|tokens]]/sessões seguras.
- **A03:** SCA (scan de dependências), lockfiles, SBOM, verificação de integridade.

## Quando utilizar / Quando NÃO

- **Use** como base mínima de AppSec em qualquer app web.
- **Não** trate como lista exaustiva: é awareness, não substitui threat modeling específico, pentest e defesa em profundidade.

## Erros comuns / Anti-patterns

- Tratar o Top 10 como "checklist completo de segurança".
- Validar/autorizar só no frontend (A01).
- Guardar segredos no código (relaciona A02/A04).

## Boas práticas

- **Security by design** e **shift-left** (segurança cedo no [[16 - CI-CD/_INDEX|pipeline]]).
- Defesa em profundidade; menor privilégio.
- Automatizar SAST/DAST/SCA no CI.

## Conceitos relacionados

- [[Autenticacao vs Autorizacao]]
- [[OAuth 2.0 e OpenID Connect]]
- [[JWT (JSON Web Token)]]
- [[Criptografia - Hashing, Encryption e Senhas]]
- [[Redes - TCP-IP, HTTP, DNS e TLS]]

## Perguntas importantes

### Qual o risco nº 1 do OWASP?
Na edição 2025 (como na 2021), **A01 Broken Access Control** — falhas de autorização.

### O OWASP Top 10 cobre tudo em segurança?
Não. É um documento de **conscientização** dos riscos mais críticos; segurança real exige threat modeling, testes, defesa em profundidade e processos.

## Fontes

1. OWASP Top 10:2025 — https://owasp.org/Top10/ (consultado 2026-09-03)
2. OWASP — https://owasp.org/www-project-top-ten/ (consultado 2026-09-03)
3. Wikipedia — OWASP — https://en.wikipedia.org/wiki/OWASP (consultado 2026-09-03)

## Observações

Criar nota por risco (A01–A10) com exemplos e mitigações detalhadas. Status: verified (lista 2025 confirmada na fonte oficial).
