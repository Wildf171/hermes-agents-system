---
title: "Evolução de Software e Leis de Lehman"
category: "28 - MANUTENCAO"
tags:
  - engenharia-software
  - manutencao
  - evolucao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Evolução de Software e Leis de Lehman

## Resumo

Software que é usado no mundo real **precisa mudar continuamente** — ou se torna progressivamente menos útil. As **Leis de Lehman** (Lehman & Belady, a partir de **1974**) descrevem esse fenômeno: a tensão entre as forças que empurram novas mudanças e as que freiam o progresso (complexidade crescente).

## Tipos de programa (Lehman)

- **S-program** — definido por uma **especificação exata** (ex.: resolver as 8 rainhas). Praticamente **não evolui**.
- **P-program** — modela um problema do mundo real (ex.: previsão do tempo); validade comparada ao mundo real.
- **E-program** — "**mecaniza uma atividade humana/social**", embutido no mundo que modela. **Precisa se adaptar continuamente**. É a maioria do software de negócio — e a quem as leis se aplicam.

## As Leis de Lehman (as mais importantes)

São **8 leis** (1974–1996). Destaques:

1. **Continuing Change (Mudança Contínua)** — um E-program deve ser **continuamente adaptado**, ou se torna progressivamente menos satisfatório.
2. **Increasing Complexity (Complexidade Crescente)** — à medida que evolui, sua **complexidade aumenta**, a menos que se trabalhe ativamente para **reduzi-la** (refatoração!).
3. **Self-Regulation** — o processo de evolução se auto-regula (métricas próximas do normal).
4. **Conservation of Organizational Stability** — a taxa de trabalho efetivo tende a ser constante ao longo da vida.
5. **Conservation of Familiarity** — o crescimento incremental tende a ser limitado (a equipe precisa dominar cada versão).
6. **Continuing Growth** — funcionalidade deve crescer para manter a satisfação.
7. **Declining Quality** — a qualidade **decai** se o sistema não for rigorosamente mantido/adaptado ao ambiente.
8. **Feedback System** — o processo de evolução é um sistema de feedback multi-agente/multi-loop.

## Interpretação prática

As duas leis mais citadas resumem o dia a dia:
- **"Mude continuamente ou apodreça"** (Lei 1).
- **"A complexidade cresce sozinha; combatê-la exige esforço deliberado"** (Lei 2) → é por isso que [[Refatoracao|refatoração]] e manutenção **preventiva** não são opcionais: sem elas, o software degenera em [[Anti-patterns de Arquitetura e Design|Big Ball of Mud]]/[[Sistemas Legados - Fundamentos|legado]].
- **"A qualidade decai se você não agir"** (Lei 7) → dívida técnica se acumula por padrão.

## Por que importa?

Explica por que sistemas "ficam ruins com o tempo" e por que a manutenção é inevitável e cara. Dá base teórica para investir em [[Metricas de Qualidade e Divida Tecnica|controle de dívida técnica]], refatoração contínua e adaptação ao ambiente.

## Exemplo

```
Um sistema de faturamento (E-program):
- Leis mudam (imposto novo) → precisa adaptar (Lei 1: Continuing Change)
- Cada feature adicionada sem refatorar → mais acoplamento (Lei 2)
- Sem manutenção preventiva → bugs, lentidão (Lei 7: Declining Quality)
→ em anos, vira legado difícil de mudar
```

## Implicações / o que fazer

- Planejar o software para **mudança** (baixo acoplamento, testes).
- **Investir continuamente** em reduzir complexidade (refatorar) — não só adicionar features.
- Tratar adaptação ao ambiente (deps, plataformas) como trabalho recorrente.
- Aceitar que manutenção/evolução são a **maior parte** do ciclo de vida.

## Erros comuns / Anti-patterns

- Só adicionar features, nunca reduzir complexidade → Lei 2 cobra.
- Assumir que software "pronto" fica pronto (ignora Lei 1).
- Negligenciar qualidade achando que se preserva sozinha (contra Lei 7).

## Boas práticas

- Refatoração contínua e manutenção **preventiva** ([[Manutencao de Software - Fundamentos]]).
- Baixo acoplamento/alta coesão para absorver mudanças ([[Coesao e Acoplamento]]).
- Monitorar complexidade/dívida ([[Metricas de Qualidade e Divida Tecnica]]).

## Conceitos relacionados

- [[Manutencao de Software - Fundamentos]]
- [[Sistemas Legados - Fundamentos]] · [[Refatoracao]]
- [[Metricas de Qualidade e Divida Tecnica]]
- [[Coesao e Acoplamento]]

## Perguntas importantes

### O que dizem as Leis de Lehman, em resumo?
Que software do mundo real (E-programs) **deve mudar continuamente** ou se torna menos útil (Lei 1), e que sua **complexidade cresce** a menos que se trabalhe ativamente para reduzi-la (Lei 2). A qualidade decai sem manutenção (Lei 7).

### Por que a complexidade sempre aumenta?
Porque cada mudança tende a adicionar acoplamento/casos especiais. Sem esforço deliberado de refatoração, a entropia vence (Lei da Complexidade Crescente).

## Fontes

1. Wikipedia — Lehman's laws of software evolution — https://en.wikipedia.org/wiki/Lehman%27s_laws_of_software_evolution (consultado 2026-09-03)
2. Lehman, M. M. & Belady, L. (1974–1985) — laws of software evolution.
3. Lehman, M. M. (1980). "Programs, Life Cycles, and Laws of Software Evolution." Proc. IEEE.

## Observações

Status: verified. Aprofundar: as 8 leis em detalhe, entropia de software. 
