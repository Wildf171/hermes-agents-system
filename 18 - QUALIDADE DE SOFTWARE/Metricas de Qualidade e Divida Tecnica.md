---
title: "Métricas de Qualidade e Dívida Técnica"
category: "18 - QUALIDADE DE SOFTWARE"
tags:
  - engenharia-software
  - qualidade
  - metricas
  - divida-tecnica
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Métricas de Qualidade e Dívida Técnica

## Resumo

**Métricas de software** quantificam aspectos do código (complexidade, cobertura, acoplamento) para orientar decisões de qualidade. **Dívida técnica** é a metáfora (Ward Cunningham, 1992) para o **custo futuro** de escolher soluções expedientes hoje: acelera no curto prazo, encarece a manutenção depois se não for "paga".

## Métricas comuns

### Complexidade Ciclomática (McCabe, 1976)
Mede o **número de caminhos linearmente independentes** no código, via grafo de fluxo de controle: `M = E − N + 2P` (arestas − nós + 2×componentes). Cada `if/for/while/case` aumenta o valor.
- Baixa (1–10): simples, fácil de testar.
- Alta (>10–15): difícil de entender/testar → candidata a [[Refatoracao|refatoração]].
- Guia o **basis path testing**: nº de testes ≈ complexidade.

### Outras métricas
- **Cobertura de testes (coverage)** — % de código exercitado por testes. Útil, mas **não** mede qualidade dos testes (100% ≠ sem bugs).
- **Acoplamento e Coesão** — dependências entre módulos / foco interno. Ver [[Coesao e Acoplamento]].
- **LOC** — linhas de código (métrica fraca isolada).
- **Maintainability Index** — índice composto (complexidade + volume + LOC).
- **Duplicação** — % de código repetido ([[DRY, KISS e YAGNI|DRY]]).
- **Code churn** — quanto o código muda (instabilidade).
- **Depth of Inheritance / Fan-in/Fan-out** — métricas OO.

> Cuidado: métricas são **indicadores**, não metas. "Quando uma métrica vira meta, deixa de ser boa métrica" (Lei de Goodhart).

## Dívida Técnica

### O que é
Metáfora de **Ward Cunningham (1992)**: entregar código apressado é "entrar em dívida" — acelera agora, mas cobra "juros" (custo extra) em cada mudança futura, até ser "paga" com refatoração.

### Tipos (quadrante de Fowler)
Cruzando **deliberada × inadvertida** com **prudente × imprudente**:
- **Prudente & deliberada** — "vamos entregar agora e refatorar depois" (estratégica, ok se paga).
- **Imprudente & deliberada** — "não temos tempo para design" (perigosa).
- **Prudente & inadvertida** — "agora sabemos como deveríamos ter feito" (aprendizado).
- **Imprudente & inadvertida** — "o que é design em camadas?" (ignorância).

### Fontes de dívida
[[Code Smells|Code smells]], [[Anti-patterns - Fundamentos|anti-patterns]], falta de testes, documentação desatualizada, dependências obsoletas, atalhos de prazo.

### Gerir dívida
- **Tornar visível** (backlog de dívida, comentários TODO rastreáveis, relatórios do [[Analise Estatica de Codigo|SonarQube]]).
- **Pagar incrementalmente** (Boy Scout Rule, tempo reservado por sprint).
- Decidir conscientemente quando **contrair** dívida (estratégica) e planejar o pagamento.

## Exemplo prático

```
SonarQube reporta: complexidade ciclomática 34 numa função, cobertura 40%,
duplicação 12% → "dívida técnica estimada: 3 dias".
Ação: refatorar (Extract Function reduz complexidade), adicionar testes.
```

## Quando usar métricas

- Para **encontrar hotspots** (alta complexidade + muita mudança = risco).
- Como tendência ao longo do tempo, não como número absoluto isolado.

## Quando NÃO (armadilhas)

- Usar métrica como **meta** (Goodhart): perseguir 100% de cobertura gera testes inúteis; reduzir complexidade "no papel" sem melhorar de fato.
- Comparar LOC entre pessoas/times.

## Erros comuns / Anti-patterns

- Ignorar dívida até virar crise ("bankruptcy" técnica).
- Tratar toda dívida como ruim (a estratégica pode ser sábia).
- Métrica sem contexto/ação.

## Boas práticas

- Focar em **hotspots** (complexidade × churn).
- Tornar a dívida **visível e priorizada**; pagar aos poucos.
- Métricas no [[CI-CD - Integracao e Entrega Continua|pipeline]] como tendência + portões razoáveis.

## Conceitos relacionados

- [[Qualidade de Software - Fundamentos]]
- [[Analise Estatica de Codigo]]
- [[Code Smells]] · [[Refatoracao]]
- [[Coesao e Acoplamento]] · [[Complexidade Algoritmica (Big-O)]]

## Perguntas importantes

### O que é complexidade ciclomática?
Uma métrica (McCabe, 1976) que conta os caminhos linearmente independentes no código. Alta complexidade indica código difícil de testar e manter.

### Dívida técnica é sempre ruim?
Não. Pode ser uma **escolha estratégica** (entregar rápido e pagar depois). Torna-se problema quando é imprudente ou nunca é paga, aumentando o custo de cada mudança.

## Fontes

1. Wikipedia — Cyclomatic complexity — https://en.wikipedia.org/wiki/Cyclomatic_complexity (consultado 2026-09-03)
2. Wikipedia — Technical debt — https://en.wikipedia.org/wiki/Technical_debt (consultado 2026-09-03)
3. Cunningham, W. (1992) — origem do termo; Fowler, M. — quadrante da dívida técnica.

## Observações

Aprofundar: hotspots (Adam Tornhill), Maintainability Index, quality gates. Status: verified.
