---
title: "Estruturas de Dados"
category: "06 - PROGRAMACAO"
tags:
  - engenharia-software
  - programacao
  - estruturas-de-dados
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Estruturas de Dados

## Resumo

Uma **estrutura de dados** é uma forma de organizar e armazenar dados para acesso e modificação eficientes. A escolha certa costuma ter **mais impacto na eficiência do que o algoritmo** (Rob Pike). Cada estrutura equilibra custos de busca, inserção, remoção e memória.

## O que é?

É a **implementação física** de um tipo de dado — organização em memória + operações (inserção, remoção, busca, travessia). Relaciona-se com o conceito de **Tipo Abstrato de Dados (TAD/ADT)**:

- **ADT** = forma *lógica*: quais operações existem e o que produzem (o "o quê").
- **Estrutura de dados** = forma *física*: como é representada na memória e como as operações são feitas (o "como").
- Um mesmo ADT (ex.: Lista) pode ter várias implementações (array dinâmico ou lista ligada).

## Por que existe?

Dados precisam ser organizados para operações eficientes em escala. Bancos relacionais usam **índices B-tree**; compiladores usam **hash tables** para identificadores; filesystems e buscadores usam estruturas especializadas.

## Como funciona? — Principais estruturas

### Lineares
| Estrutura | Acesso | Busca | Inserção/Remoção | Observação |
|---|---|---|---|---|
| **Array** | O(1) | O(n) | O(n) | Tamanho fixo; memória contígua |
| **Array dinâmico** (list/vector) | O(1) | O(n) | O(1) amortizado no fim | Redimensiona |
| **Lista ligada** | O(n) | O(n) | O(1) com o nó | Sem realocação; mais memória (ponteiros) |
| **Pilha (Stack)** | — | — | O(1) | LIFO (undo, call stack) |
| **Fila (Queue)** | — | — | O(1) | FIFO (buffers, filas de tarefas) |

### Associativas
- **Hash Table (dicionário/map)** — busca/inserção O(1) **médio** (O(n) pior com colisões). Base de `dict`/`Map`/`HashMap`.
- **Set** — coleção sem duplicatas; pertence O(1) médio.

### Hierárquicas / não lineares
- **Árvore binária de busca (BST)** — O(log n) se balanceada, O(n) degenerada.
- **Árvore balanceada (AVL, Red-Black, B-tree)** — O(log n) garantido; B-tree é a base de índices de banco.
- **Heap** — fila de prioridade; min/max em O(1), inserção/remoção O(log n).
- **Trie** — prefixos/autocomplete.
- **Grafo** — nós + arestas; modela redes, dependências, rotas.

## Conceitos fundamentais

- **Trade-off tempo × espaço** — hash gasta memória para ganhar velocidade.
- **Localidade de memória** — arrays são cache-friendly; listas ligadas não.
- **Escolha guiada pelas operações dominantes** — muitas buscas? hash/árvore. Muitas inserções no meio? lista ligada.

## Exemplo prático

```python
# Escolha errada: buscar repetidamente numa lista -> O(n) por busca
usuarios = ["ana", "bob", ...]
if "bob" in usuarios:        # O(n)

# Escolha certa: set -> O(1) médio por busca
usuarios = {"ana", "bob", ...}
if "bob" in usuarios:        # O(1) médio
```

## Quando utilizar (guia rápido)

- Acesso por índice / iteração → **array/lista dinâmica**
- Busca por chave → **hash table**
- Ordem + busca eficiente → **árvore balanceada**
- Prioridade → **heap**
- Relações/rotas → **grafo**
- LIFO/FIFO → **pilha/fila**

## Quando NÃO utilizar

- Hash quando precisa de ordem (use árvore).
- Lista ligada quando precisa de acesso aleatório rápido (use array).
- Estrutura complexa para dados pequenos (um array simples basta).

## Erros comuns

- Usar lista para pertencimento frequente (O(n)) em vez de set (O(1)).
- Ignorar o pior caso do hash (colisões).
- Escolher a estrutura antes de saber as operações dominantes.

## Boas práticas

- Defina as **operações dominantes** e escolha pela complexidade delas ([[Complexidade Algoritmica (Big-O)|Big-O]]).
- Prefira estruturas da biblioteca padrão (testadas e otimizadas).

## Conceitos relacionados

- [[Complexidade Algoritmica (Big-O)]]
- [[Paradigmas de Programacao]]
- [[12 - BANCOS DE DADOS/_INDEX|Bancos de Dados]] (índices B-tree/hash)

## Perguntas importantes

### Qual a diferença entre estrutura de dados e ADT?
ADT define o comportamento (operações e resultados) sem dizer como; a estrutura de dados é a implementação concreta em memória. Uma "Lista" (ADT) pode ser array dinâmico ou lista ligada.

### Estrutura de dados ou algoritmo importa mais?
Rob Pike argumenta que a escolha da estrutura quase sempre tem impacto maior na eficiência — o algoritmo muitas vezes decorre dela.

## Fontes

1. Wikipedia — Data structure — https://en.wikipedia.org/wiki/Data_structure (consultado 2026-09-03)
2. Cormen, Leiserson, Rivest, Stein — *Introduction to Algorithms* (CLRS).
3. Rob Pike — "Notes on Programming in C" (regra sobre estrutura de dados).

## Observações

Complexidades apresentadas são as canônicas (CLRS). Aprofundar cada estrutura (árvores balanceadas, grafos, tries) em notas próprias. Status: verified.
