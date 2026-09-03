---
title: "Complexidade Algorítmica (Big-O)"
category: "06 - PROGRAMACAO"
tags:
  - engenharia-software
  - programacao
  - algoritmos
  - complexidade
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Complexidade Algorítmica (Notação Big-O)

## Resumo

A **notação Big-O** descreve como o tempo de execução (ou uso de memória) de um algoritmo **cresce em função do tamanho da entrada** (n), ignorando constantes e termos de menor ordem. É a linguagem padrão para comparar a eficiência de algoritmos independentemente de hardware.

## O que é?

Big-O faz parte da **notação de Bachmann–Landau**, inventada pelos matemáticos alemães **Paul Bachmann (1894)** e **Edmund Landau (1909)**. O "O" vem de *Ordnung* (ordem). Em ciência da computação, classifica algoritmos pela **taxa de crescimento assintótica**.

- **Big-O (O)** — limite **superior** (pior caso ou cota de cima).
- **Big-Omega (Ω)** — limite inferior.
- **Big-Theta (Θ)** — limite justo (cresce exatamente assim).

Formalmente: `f(x) = O(g(x))` se existe constante M > 0 tal que `|f(x)| ≤ M·g(x)` para todo x no domínio (a partir de certo ponto).

## Por que existe?

Para comparar algoritmos **sem depender de máquina, linguagem ou constantes**. Um algoritmo O(n) vence um O(n²) para n grande, não importa o hardware. Foca no que domina quando a entrada cresce.

## Como funciona? — Classes comuns (da melhor à pior)

| Notação | Nome | Exemplo típico |
|---|---|---|
| O(1) | Constante | Acesso a índice de array; hash lookup |
| O(log n) | Logarítmica | Busca binária; operações em árvore balanceada |
| O(n) | Linear | Percorrer uma lista |
| O(n log n) | Linearítmica | Merge sort, quicksort (médio) |
| O(n²) | Quadrática | Loops aninhados; bubble sort |
| O(n³) | Cúbica | Multiplicação de matrizes ingênua |
| O(2ⁿ) | Exponencial | Subconjuntos; força bruta |
| O(n!) | Fatorial | Permutações; caixeiro-viajante ingênuo |

## Conceitos fundamentais

- **Assintótico** — comportamento quando n → ∞; constantes e termos menores são descartados (`3n² + 5n + 2` → `O(n²)`).
- **Pior / médio / melhor caso** — Big-O geralmente descreve o **pior caso**; quicksort é O(n log n) no médio e O(n²) no pior.
- **Complexidade de tempo vs. espaço** — ambas se medem com Big-O.
- **Análise amortizada** — custo médio por operação numa sequência (ex.: `append` em array dinâmico é O(1) amortizado).

## Exemplo prático

```python
# O(1) - tempo constante
def primeiro(lista): return lista[0]

# O(n) - linear
def contem(lista, x):
    for item in lista:      # percorre até n elementos
        if item == x: return True
    return False

# O(n^2) - quadrático (loops aninhados)
def tem_duplicata(lista):
    for i in lista:
        for j in lista:
            if i is not j and i == j: return True
    return False
# Melhor: usar set -> O(n) de tempo, O(n) de espaço
```

## Quando utilizar

- Ao escolher algoritmo/estrutura para dados que **crescem**.
- Em entrevistas técnicas e revisão de código sensível a desempenho.
- Para justificar decisões de [[21 - PERFORMANCE/_INDEX|performance]] e [[22 - ESCALABILIDADE/_INDEX|escalabilidade]].

## Quando NÃO utilizar (armadilhas)

- Para **n pequeno**, constantes dominam: um O(n²) simples pode ser mais rápido que um O(n log n) com overhead alto.
- Big-O **não mede** o desempenho real absoluto (constantes, cache, I/O). Sempre valide com **benchmark** quando importa.

## Erros comuns

- Otimizar complexidade sem medir (premature optimization).
- Ignorar complexidade de **espaço**.
- Confundir pior caso com caso médio.
- Esquecer o custo escondido de operações (ex.: `in` numa lista é O(n), num set é O(1)).

## Boas práticas

- Conheça a complexidade das operações das suas [[Estruturas de Dados|estruturas de dados]].
- Prefira a estrutura certa antes do algoritmo esperto (Rob Pike: a estrutura de dados geralmente importa mais).
- Meça (profiling) para confirmar suposições.

## Conceitos relacionados

- [[Estruturas de Dados]]
- [[Paradigmas de Programacao]]
- [[21 - PERFORMANCE/_INDEX|Performance]]
- [[22 - ESCALABILIDADE/_INDEX|Escalabilidade]]

## Perguntas importantes

### Big-O mede o tempo real do algoritmo?
Não. Mede a **taxa de crescimento** do custo com o tamanho da entrada, ignorando constantes. Para tempo absoluto, use benchmark.

### Qual a diferença entre O, Ω e Θ?
O = cota superior (no máximo cresce assim); Ω = cota inferior; Θ = cota justa (cresce exatamente assim).

## Fontes

1. Wikipedia — Big O notation — https://en.wikipedia.org/wiki/Big_O_notation (consultado 2026-09-03)
2. Cormen, Leiserson, Rivest, Stein — *Introduction to Algorithms* (CLRS), 4ª ed.
3. Bachmann (1894); Landau (1909) — notação de Bachmann–Landau.

## Observações

Tabela de classes com exemplos amplamente consolidada (CLRS). Status: verified. Aprofundar: análise amortizada e complexidade de espaço em nota própria.
