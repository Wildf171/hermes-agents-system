---
title: "Análise Estática de Código"
category: "18 - QUALIDADE DE SOFTWARE"
tags:
  - engenharia-software
  - qualidade
  - analise-estatica
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Análise Estática de Código

## Resumo

**Análise estática** é examinar o código **sem executá-lo** para encontrar defeitos, vulnerabilidades, code smells e violações de estilo. Complementa os testes (análise **dinâmica**) e é peça central da qualidade automatizada no [[CI-CD - Integracao e Entrega Continua|pipeline]].

## O que é?

Ferramentas que "leem" o código-fonte (ou bytecode) e apontam problemas por regras/heurísticas: bugs prováveis, vulnerabilidades ([[OWASP Top 10|OWASP]]), [[Code Smells|smells]], métricas ([[Metricas de Qualidade e Divida Tecnica|complexidade]]), e desvios de padrão. Roda em tempo de desenvolvimento/CI, antes de executar.

## Estático vs Dinâmico

- **Estático** — analisa o código parado (linters, SAST). Acha problemas sem rodar; pode ter **falsos positivos**.
- **Dinâmico** — observa o programa em execução ([[Testes - Fundamentos e Piramide|testes]], DAST, profiling). Acha o que só aparece rodando.
São **complementares**.

## Categorias de ferramentas

- **Linters** — estilo e erros comuns: ESLint (JS/TS), Pylint/Flake8/Ruff (Python), RuboCop (Ruby), golangci-lint (Go).
- **Formatters** — formatação automática: Prettier, Black, gofmt. (Elimina discussões de estilo no [[Code Review]].)
- **Type checkers** — mypy (Python), TypeScript, verificação de tipos.
- **Plataformas de qualidade** — **SonarQube/SonarCloud**: métricas, smells, cobertura, dívida técnica, quality gates.
- **SAST (Static Application Security Testing)** — foco em vulnerabilidades: Semgrep, CodeQL, Snyk Code, Bandit (Python).
- **SCA (Software Composition Analysis)** — vulnerabilidades em **dependências** (Dependabot, Snyk) → relaciona-se a [[OWASP Top 10|Supply Chain Failures]].

## Por que existe?

- **Feedback rápido e barato** — acha problemas antes de rodar/revisar.
- **Consistência** — impõe padrões automaticamente.
- **Segurança** — detecta padrões vulneráveis cedo (shift-left security / DevSecOps).
- Libera o [[Code Review|code review]] humano para o que importa (design, lógica).

## Como usar (no pipeline)

```
pre-commit: formatter + linter (feedback local imediato)
CI: lint + type check + SAST + SCA + testes + cobertura
→ quality gate: bloqueia merge se violar limites (ex.: nova vulnerabilidade, cobertura caindo)
```

## Exemplo prático

```bash
ruff check .            # lint Python (rápido)
mypy .                  # checagem de tipos
bandit -r .             # SAST (segurança) Python
# no CI: sonar-scanner + gate; dependabot para dependências
```

## Quando utilizar

- **Sempre** em projetos de produção; especialmente com CI.
- SAST/SCA em qualquer app exposto (segurança).

## Quando NÃO / cuidado

- Regras demais/ruins geram **ruído** (falsos positivos) e fadiga → o time passa a ignorar.
- Não substitui testes nem revisão humana; é uma camada.

## Erros comuns / Anti-patterns

- **Falsos positivos** não gerenciados → alertas ignorados.
- Habilitar tudo de uma vez em base legada → milhares de avisos.
- Tratar linter como opcional (não roda no CI).
- Confundir análise estática com testes (são complementares).

## Boas práticas

- Adotar **incremental** (regras essenciais primeiro; "baseline" em legado).
- **Formatação automática** + lint no pre-commit e no CI.
- **Quality gates** razoáveis (foco em regressões: não piorar).
- Integrar SAST/SCA (DevSecOps) e revisar/silenciar falsos positivos com critério.

## Conceitos relacionados

- [[Qualidade de Software - Fundamentos]]
- [[Metricas de Qualidade e Divida Tecnica]]
- [[Code Review]]
- [[CI-CD - Integracao e Entrega Continua]]
- [[OWASP Top 10]] (SAST/SCA)

## Perguntas importantes

### Análise estática substitui testes?
Não. Estática acha problemas **sem executar** (estilo, bugs prováveis, vulnerabilidades); testes verificam **comportamento em execução**. Use os dois.

### O que são quality gates?
Critérios automáticos no CI (ex.: sem novas vulnerabilidades, cobertura mínima, complexidade máxima) que **bloqueiam o merge** se não forem atendidos.

## Fontes

1. Wikipedia — Static program analysis — https://en.wikipedia.org/wiki/Static_program_analysis (consultado 2026-09-03)
2. OWASP — Source Code Analysis Tools / SAST — https://owasp.org/www-community/Source_Code_Analysis_Tools
3. Documentações: SonarQube, ESLint, Ruff, Semgrep, CodeQL.

## Observações

Aprofundar: SAST vs DAST vs IAST, CodeQL, gestão de falsos positivos. Status: verified.
