---
title: "Code Review"
category: "18 - QUALIDADE DE SOFTWARE"
tags:
  - engenharia-software
  - qualidade
  - code-review
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Code Review

## Resumo

**Code review** é a revisão sistemática do código por outras pessoas antes de integrá-lo, com o objetivo de **encontrar defeitos, melhorar a qualidade e compartilhar conhecimento**. É uma das práticas de maior retorno em qualidade de software — e hoje se dá principalmente via **Pull Requests**.

## O que é?

Uma forma de **verificação estática** feita por humanos: um ou mais revisores examinam as mudanças, comentam e aprovam/pedem ajustes. Vai de revisões formais (inspeções de Fagan) a **revisões leves** modernas em PRs.

## Por que existe?

- **Qualidade** — encontra bugs, problemas de design e segurança cedo (mais barato).
- **Conhecimento compartilhado** — reduz o bus factor; dissemina padrões.
- **Consistência** — mantém convenções e [[Clean Code|legibilidade]].
- **Mentoria** — feedback que forma o time.

Estudos (ex.: SmartBear, "Best Kept Secrets of Peer Code Review") mostram forte relação custo-benefício na detecção precoce de defeitos.

## Como funciona? — Fluxo com Pull Request

```
1. Autor abre um PR pequeno e focado (com descrição e contexto)
2. CI roda (build, testes, lint, análise estática)
3. Revisores comentam: bugs, design, clareza, segurança
4. Autor responde/ajusta
5. Aprovação → merge
```

## O que revisar (checklist resumido)

- **Corretude** — a lógica está certa? edge cases?
- **Design** — segue padrões/[[SOLID Principles|SOLID]]? acoplamento?
- **Legibilidade** — nomes, [[Clean Code|clareza]], sem duplicação.
- **Testes** — cobrem o comportamento? casos de borda?
- **Segurança** — validação, [[OWASP Top 10|riscos OWASP]], segredos.
- **Performance** — N+1, loops caros ([[Performance - Fundamentos]]).
- Ver [[46 - CHECKLISTS/Code Review Checklist|checklist completo]].

## Boas práticas (autor e revisor)

### Autor
- **PRs pequenos** (fáceis de revisar; grandes escondem bugs).
- Boa descrição: o quê, por quê, como testar.
- Auto-revisar antes de pedir revisão.

### Revisor
- Revisar **rápido** (não bloquear o time) e com foco.
- **Criticar o código, não a pessoa**; comentários construtivos e específicos.
- Distinguir "obrigatório" de "sugestão" (ex.: prefixo `nit:`).
- Elogiar o que está bom.

### Time
- Automatizar o **objetivo** (lint, formatação, testes) no [[CI-CD - Integracao e Entrega Continua|CI]] → revisão humana foca no que importa (design, lógica).

## Tipos de revisão

- **Pull Request review** (assíncrona, padrão hoje).
- **Pair programming** — revisão contínua em tempo real.
- **Inspeção formal (Fagan)** — processo rigoroso, raro no dia a dia.
- **Over-the-shoulder** — informal.

## Quando utilizar

- **Sempre** em código de produção compartilhado. Especialmente crítico em áreas sensíveis (segurança, dinheiro).

## Quando NÃO (nuance)

- Protótipos descartáveis podem dispensar.
- Revisão que vira gargalo/burocracia perde valor — calibrar profundidade × velocidade.

## Erros comuns / Anti-patterns

- **PRs gigantes** → revisão superficial ("LGTM" sem ler).
- Revisão **lenta** que trava o time.
- Comentários pessoais/ásperos (mata a cultura).
- Revisar estilo manualmente (deveria ser automatizado).
- **Rubber-stamping** — aprovar sem revisar de fato.

## Boas práticas (resumo)

- PRs pequenos + CI automatizado + revisão rápida e gentil.
- Checklist compartilhado; foco em design/lógica/segurança.
- Cultura de aprendizado, não de policiamento.

## Conceitos relacionados

- [[Qualidade de Software - Fundamentos]]
- [[Analise Estatica de Codigo]]
- [[Clean Code]] · [[Code Smells]]
- [[Git - Fundamentos]] (Pull Requests)
- [[46 - CHECKLISTS/Code Review Checklist]]

## Perguntas importantes

### Qual o maior fator de sucesso de um code review?
**PRs pequenos**. Revisões pequenas são feitas com atenção; PRs grandes levam a aprovações superficiais.

### O que automatizar vs revisar por humano?
Automatize o objetivo (formatação, lint, testes, análise estática) no CI; humanos focam em **design, lógica, clareza e segurança**.

## Fontes

1. Wikipedia — Code review — https://en.wikipedia.org/wiki/Code_review (consultado 2026-09-03)
2. Google — Engineering Practices / Code Review Developer Guide — https://google.github.io/eng-practices/review/
3. SmartBear — *Best Kept Secrets of Peer Code Review.*

## Observações

Status: verified. Ver checklist prático em 46-CHECKLISTS.
