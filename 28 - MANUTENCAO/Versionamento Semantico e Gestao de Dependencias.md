---
title: "Versionamento Semântico e Gestão de Dependências"
category: "28 - MANUTENCAO"
tags:
  - engenharia-software
  - manutencao
  - semver
  - dependencias
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Versionamento Semântico e Gestão de Dependências

## Resumo

**Versionamento Semântico (SemVer)** dá significado aos números de versão (`MAJOR.MINOR.PATCH`), comunicando o impacto de cada release. **Gestão de dependências** é manter as bibliotecas de terceiros atualizadas, seguras e compatíveis — parte essencial da [[Manutencao de Software - Fundamentos|manutenção adaptativa]].

## Versionamento Semântico (SemVer)

Formato **`MAJOR.MINOR.PATCH`** (ex.: `2.4.1`):
- **MAJOR** — mudança **incompatível** (breaking change). Quebra quem usa.
- **MINOR** — adiciona funcionalidade de forma **retrocompatível**.
- **PATCH** — correção de bug retrocompatível.

Regras-chave:
- Uma vez publicada, uma versão **não muda** (imutável).
- **0.y.z** = desenvolvimento inicial (tudo pode mudar).
- Pré-lançamentos: `1.0.0-alpha.1`, `1.0.0-rc.1`.

```
1.4.2 → 1.4.3  (patch: corrigiu bug)
1.4.3 → 1.5.0  (minor: nova função, compatível)
1.5.0 → 2.0.0  (major: breaking change)
```

## Ranges de versão (em manifests)

Como declarar dependências (npm/pip/etc.):
- **`^1.4.2`** (caret) — aceita minor/patch (`>=1.4.2 <2.0.0`). Padrão comum.
- **`~1.4.2`** (tilde) — aceita só patch (`>=1.4.2 <1.5.0`).
- **`1.4.2`** — exato (pin).
- **`*`/`latest`** — perigoso (pega qualquer versão).

## Lockfiles

`package-lock.json`, `poetry.lock`, `Cargo.lock` etc. **congelam as versões exatas** de toda a árvore de dependências → builds **reproduzíveis** (mesmo resultado em qualquer máquina/CI). **Sempre versionar o lockfile.**

## Gestão de Dependências

### Riscos das dependências
- **Vulnerabilidades** (a maioria dos apps é 80%+ código de terceiros) → [[OWASP Top 10|Software Supply Chain Failures]].
- **Breaking changes** ao atualizar.
- **Dependências transitivas** (deps das suas deps).
- **Abandono** (lib sem manutenção).
- Incidentes famosos: left-pad, log4shell.

### Boas práticas
- **SCA** (Software Composition Analysis): Dependabot, Snyk, `npm audit` — alertam sobre vulnerabilidades.
- Atualizar **regularmente e aos poucos** (não deixar acumular anos).
- Ler **changelogs**; testar após atualizar (rede de [[Testes - Fundamentos e Piramide|testes]]).
- **Lockfile** versionado; builds reproduzíveis.
- Minimizar dependências (cada uma é passivo de manutenção/segurança).
- **SBOM** (Software Bill of Materials) para rastrear o que você usa.

## Deprecação (retirar algo com cuidado)

Ao remover/alterar uma API pública:
1. **Marcar como deprecated** (aviso), mantendo funcionando.
2. Documentar a alternativa e o prazo.
3. Remover só em uma versão **MAJOR** (SemVer).
Dá tempo aos consumidores migrarem — essencial em APIs/bibliotecas.

## Exemplo prático

```bash
npm audit                 # vê vulnerabilidades nas deps
npm outdated              # o que está desatualizado
# Dependabot abre PRs automáticos de atualização
# Atualizar minor/patch com frequência; major com cuidado (breaking)
```

## Quando aplicar

- **SemVer:** ao publicar qualquer biblioteca/API versionada.
- **Gestão de deps:** contínua, em todo projeto (segurança e compatibilidade).

## Erros comuns / Anti-patterns

- **Dependency hell** — versões conflitantes que não resolvem.
- Não versionar o **lockfile** → "funciona na minha máquina".
- Deixar deps desatualizadas por anos → atualização vira projeto gigante e arriscado.
- `*`/`latest` em produção (builds não reproduzíveis).
- Breaking change em release **minor/patch** (viola SemVer, quebra usuários).

## Boas práticas (resumo)

- Seguir **SemVer** ao publicar; respeitar breaking = MAJOR.
- **Lockfile** sempre; SCA no [[CI-CD - Integracao e Entrega Continua|CI]].
- Atualizar cedo e com frequência; deprecar antes de remover.
- Menos dependências, mais saúde.

## Conceitos relacionados

- [[Manutencao de Software - Fundamentos]]
- [[Git - Fundamentos]] · [[CI-CD - Integracao e Entrega Continua]]
- [[Boas Praticas de API]] (versionamento de API)
- [[OWASP Top 10]] (supply chain) · [[Analise Estatica de Codigo]] (SCA)

## Perguntas importantes

### O que significa cada número em SemVer?
`MAJOR.MINOR.PATCH`: MAJOR = mudança incompatível (breaking); MINOR = nova função compatível; PATCH = correção compatível.

### Por que versionar o lockfile?
Para builds **reproduzíveis**: o lockfile congela as versões exatas de toda a árvore de dependências, garantindo o mesmo resultado em qualquer ambiente e no CI.

## Fontes

1. Semantic Versioning 2.0.0 — https://semver.org (consultado 2026-09-03)
2. Wikipedia — Software versioning — https://en.wikipedia.org/wiki/Software_versioning
3. OWASP — Dependency-Check / Software Supply Chain; docs npm/pip.

## Observações

Aprofundar: SBOM, renovate/dependabot, calendar versioning (CalVer). Status: verified.
