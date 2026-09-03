---
title: "Anti-patterns - Fundamentos"
category: "43 - ANTIPATTERNS"
tags:
  - engenharia-software
  - antipatterns
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Anti-patterns — Fundamentos

## Resumo

Um **anti-pattern** é uma solução **comum, porém contraproducente**, para uma classe de problema: parece apropriada e eficaz no início, mas traz **mais prejuízo que benefício** — e existe uma alternativa **documentada, repetível e melhor**. O termo foi cunhado por **Andrew Koenig (1995)**, inspirado no livro *Design Patterns*, e popularizado pelo livro *AntiPatterns* (1998).

## O que é?

O oposto de um [[08 - DESIGN PATTERNS/Design Patterns - Introduction|design pattern]]: enquanto patterns catalogam boas soluções, anti-patterns catalogam **armadilhas recorrentes** e mostram **como sair delas**.

Dois traços distinguem um anti-pattern de "só uma má ideia":
1. É um processo/estrutura **comumente usado** que **aparenta** ser adequado, mas cujos custos superam os benefícios.
2. Existe **outra forma** conhecida, documentada e eficaz de resolver o problema.

> Como nos patterns, vale a **"regra de três"**: para ser anti-pattern, deve ter ocorrido ao menos 3 vezes.

## Por que documentar anti-patterns?

- **Capturam conhecimento de especialista** (o que evitar e por quê).
- Dão **vocabulário comum** ("isso é um God Object").
- Boa documentação de anti-pattern **inclui a saída** (refatoração/alternativa), não só a consequência.

## Categorias (escopo se expandiu)

O conceito começou em design de software e se estendeu para:
- **Código** — [[Code Smells|code smells]] e maus hábitos de implementação.
- **Arquitetura/Design** — ver [[Anti-patterns de Arquitetura e Design]] (God Object, Big Ball of Mud…).
- **Processo/Gestão** — ver [[Anti-patterns de Processo e Organizacao]] (Analysis Paralysis, Death by Planning…).
- **Organizacionais/culturais** — dinâmicas de time e empresa.

## Exemplos rápidos (software)

- **God Object** — uma classe controla tudo em vez de distribuir responsabilidades.
- **Magic Number** — literal com significado importante e não explicado (use constante nomeada).
- **Poltergeist** — classes efêmeras que só existem para chamar métodos de outras.
- **Big Ball of Mud** — sistema sem arquitetura perceptível.

## Como usar (na prática)

- Em **code review**: nomear o anti-pattern acelera a conversa e aponta a correção.
- Em **arquitetura**: reconhecer cedo evita custo alto depois.
- Ligados a [[Refatoracao|refatoração]]: o anti-pattern indica **o que** e **como** melhorar.

## Relação com dívida técnica

Anti-patterns e [[Code Smells|code smells]] são fontes clássicas de **dívida técnica**: funcionam hoje, mas encarecem cada mudança futura.

## Erros comuns (meta)

- Chamar tudo que não gosta de "anti-pattern" (precisa dos dois traços + alternativa melhor).
- Documentar só a dor, sem a **saída**.
- Aplicar "regra" fora de contexto — às vezes o "anti-pattern" é o certo para aquele caso específico.

## Boas práticas

- Prefira sempre o [[08 - DESIGN PATTERNS/Design Patterns - Introduction|pattern]]/princípio adequado.
- Ao identificar um anti-pattern, planeje a **refatoração** incremental (com testes).
- Documente anti-patterns recorrentes do seu time com a alternativa.

## Conceitos relacionados

- [[Code Smells]]
- [[Anti-patterns de Arquitetura e Design]]
- [[Anti-patterns de Processo e Organizacao]]
- [[Refatoracao]]
- [[08 - DESIGN PATTERNS/Design Patterns - Introduction|Design Patterns]]
- [[05 - PRINCÍPIOS DE SOFTWARE/_INDEX|Princípios de Software]]

## Perguntas importantes

### Qual a diferença entre anti-pattern e bug?
Bug é comportamento incorreto. Anti-pattern é uma **solução estrutural** que funciona, mas é contraproducente (dificulta manutenção, aumenta risco). Anti-patterns geram bugs futuros, não são bugs em si.

### Quem cunhou o termo?
**Andrew Koenig (1995)**; o livro *AntiPatterns* (1998) popularizou e ampliou o conceito para arquitetura e gestão de projetos.

## Fontes

1. Wikipedia — Anti-pattern — https://en.wikipedia.org/wiki/Anti-pattern (consultado 2026-09-03)
2. Brown, Malveau, McCormick, Mowbray (1998). *AntiPatterns.*
3. Koenig, A. (1995) — origem do termo.

## Observações

Status: verified. Notas detalhadas por anti-pattern nas notas ligadas.
