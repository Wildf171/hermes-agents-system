---
title: "Paradigmas de Programação"
category: "06 - PROGRAMACAO"
tags:
  - engenharia-software
  - programacao
  - paradigmas
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Paradigmas de Programação

## Resumo

Um **paradigma de programação** é uma forma de alto nível de conceitualizar e estruturar a implementação de um programa. Uma linguagem pode suportar **um ou vários** paradigmas. Os dois grandes ramos são **Imperativo** (descreve *como* computar) e **Declarativo** (descreve *o que* se quer).

## O que é?

Paradigmas se separam por **dimensões** diferentes: modelo de execução (permite efeitos colaterais? a ordem das operações é definida?), organização do código (agrupar estado+comportamento em objetos?), e sintaxe/gramática.

## Como funciona? — Taxonomia

### Imperativo
Código controla diretamente o fluxo de execução e a mudança de estado via instruções explícitas.
- **Procedural** — organizado em procedimentos que chamam uns aos outros (C, Pascal).
- **Orientado a Objetos (OO)** — organiza dados + comportamento em objetos.
  - *Class-based* (Java, C#, Python) — tipos abstratos e herança via classes.
  - *Prototype-based* (JavaScript) — herança via clonagem de instâncias.
  - *Object-based* — encapsula estado/comportamento sem herança.

### Declarativo
Código declara propriedades do resultado, não o passo a passo.
- **Funcional** — resultado como avaliação de funções matemáticas; evita estado e dados mutáveis (Haskell, Elixir; recursos em JS, Python).
- **Lógico** — resultado como resposta a perguntas sobre fatos e regras (Prolog).
- **Reativo** — resultado declarado com streams de dados e propagação de mudança (RxJS).

### Outros (transversais)
- **Concorrente** — construtos para concorrência (threads, mensagens, futures).
- **Actor** — computação concorrente com atores que decidem localmente (Erlang).
- **Orientado a eventos**, **Dataflow** (planilhas), **Constraint**, **Genérico** (algoritmos sobre tipos a especificar depois), **Distribuído**.

## Conceitos fundamentais

- **Efeito colateral** — alteração de estado observável fora da função.
- **Imutabilidade** — dados que não mudam após criados (central no funcional).
- **Estado compartilhado** — fonte de bugs em concorrência.
- **Multi-paradigma** — a maioria das linguagens modernas (Python, JS, C#, Scala, Rust) mistura paradigmas.

## Exemplo prático (mesmo problema, 3 estilos)

Somar os quadrados dos pares de uma lista:

```python
# Imperativo (procedural)
total = 0
for n in nums:
    if n % 2 == 0:
        total += n * n

# Funcional (declarativo)
total = sum(n*n for n in nums if n % 2 == 0)
```

O imperativo diz *como* iterar; o funcional declara *o que* se quer.

## Quando utilizar

- **OO:** domínios com entidades e comportamento ricos; times grandes; ver [[33 - DDD/_INDEX|DDD]].
- **Funcional:** transformações de dados, concorrência, previsibilidade (sem estado mutável).
- **Procedural:** scripts, sistemas de baixo nível, desempenho previsível.
- **Reativo/Event-driven:** UIs, streams, sistemas assíncronos.

## Quando NÃO utilizar

- OO pesado para scripts triviais → cerimônia desnecessária.
- Funcional puro onde a equipe/linguagem não dá suporte → curva de aprendizado alta.

## Trade-offs

- Imperativo: controle fino, mas mais propenso a bugs de estado.
- Funcional: mais seguro/previsível, porém pode ter overhead e curva de aprendizado.
- Multi-paradigma: flexível, mas exige disciplina para manter consistência.

## Erros comuns

- Tratar paradigma como "religião" em vez de ferramenta.
- Forçar OO onde funções puras bastariam (e vice-versa).
- Ignorar imutabilidade em código concorrente.

## Boas práticas

- Escolher o paradigma pelo problema, não por preferência.
- Em linguagens multi-paradigma, isolar efeitos colaterais e favorecer funções puras onde possível.

## Conceitos relacionados

- [[Engenharia de Software]]
- [[DRY, KISS e YAGNI]]
- [[32 - SOLID/_INDEX|SOLID]] (princípios de OO)
- [[23 - CONCORRENCIA/_INDEX|Concorrência]]

## Perguntas importantes

### Qual a diferença entre imperativo e declarativo?
Imperativo descreve **como** (passos e mudança de estado); declarativo descreve **o que** se deseja (SQL, HTML, funcional).

### OO e Funcional são incompatíveis?
Não. Linguagens multi-paradigma (Scala, Kotlin, Python, JS) combinam objetos com funções puras e imutabilidade.

## Fontes

1. Wikipedia — Programming paradigm — https://en.wikipedia.org/wiki/Programming_paradigm (consultado 2026-09-03)
2. Van Roy, P. "Programming Paradigms for Dummies" (2009) — taxonomia clássica.

## Observações

Aprofundar em notas próprias: OO, Funcional, e cada linguagem (Python/Java/JS) na categoria 06. Status: verified para a taxonomia.
