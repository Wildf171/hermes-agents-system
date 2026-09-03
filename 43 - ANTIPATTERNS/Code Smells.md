---
title: "Code Smells"
category: "43 - ANTIPATTERNS"
tags:
  - engenharia-software
  - antipatterns
  - code-smells
  - refatoracao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Code Smells

## Resumo

Um **code smell** ("mau cheiro no código") é qualquer característica do código-fonte que **sugere um problema mais profundo** de design. Não é um bug — o código funciona — mas indica **fraqueza de design** que tende a dificultar mudanças e aumentar o risco de defeitos (fonte de dívida técnica). É o principal **gatilho para [[Refatoracao|refatoração]]**.

## O que é?

Termo popularizado por **Kent Beck** (WardsWiki, fim dos anos 1990) e difundido pelo livro **Refactoring** de **Martin Fowler (1999)**. Definição de Cunningham: um smell é uma **sugestão** de que algo *pode* estar errado — não prova de que já há problema. Fowler/Beck: "estruturas no código que indicam violação de princípios fundamentais de design".

## Por que existe (como conceito)?

Dá **heurísticas** para saber **quando** refatorar e **qual** técnica usar. Em vez de regras rígidas, o "cheiro" chama atenção para examinar o trecho.

## Catálogo dos principais smells (Fowler)

### No nível de método/função
- **Long Method** — método longo demais → *Extract Function*.
- **Long Parameter List** — muitos parâmetros → *Introduce Parameter Object*.
- **Duplicated Code** — repetição de conhecimento → *Extract*, aplicar [[DRY, KISS e YAGNI|DRY]].

### No nível de classe
- **Large Class / God Object** — classe que faz demais → *Extract Class* (viola [[SOLID Principles|SRP]]).
- **Feature Envy** — método usa mais dados de outra classe que da própria → *Move Method*.
- **Data Clumps** — mesmos grupos de dados repetidos → agrupar em objeto.
- **Primitive Obsession** — usar tipos primitivos em vez de pequenos objetos de domínio.
- **Data Class** — classe só com dados, sem comportamento (objeto anêmico).

### Entre classes / mudança
- **Shotgun Surgery** — uma mudança exige alterar muitos lugares (alto [[Coesao e Acoplamento|acoplamento]]).
- **Divergent Change** — uma classe muda por muitas razões diferentes (baixa coesão).
- **Inappropriate Intimacy** — classes acopladas demais aos detalhes uma da outra.
- **Message Chains** — `a.getB().getC().getD()` (viola Law of Demeter).
- **Middle Man** — classe que só delega.

### Outros
- **Comments** — comentários que compensam código ruim (melhore o código).
- **Dead Code** — código nunca usado.
- **Magic Numbers** — literais sem nome.
- **Switch Statements** repetidos por tipo → *Replace Conditional with Polymorphism*.

## Exemplo prático

```python
# Smell: Long Parameter List + Primitive Obsession
def criar_endereco(rua, numero, cidade, estado, cep, pais): ...

# Melhor: Introduce Parameter Object
@dataclass
class Endereco: rua: str; numero: str; cidade: str; estado: str; cep: str; pais: str
def criar_endereco(endereco: Endereco): ...
```

## Como usar

1. Detectar o smell (revisão, linters, análise estática).
2. Escolher a **refatoração** correspondente.
3. Refatorar em passos pequenos com testes verdes ([[Refatoracao]]).
4. Reexaminar — um smell removido pode revelar outro.

## Quando NÃO agir (nuance)

- Smell é **sugestão**, não obrigação. Em código estável que não muda, refatorar pode não valer o risco.
- Não persiga "código perfeito"; priorize onde há mudança/dor real.

## Erros comuns / Anti-patterns

- Tratar smell como bug (não é) — ou ignorá-lo até virar dívida grande.
- Refatorar sem testes (regressões).
- "Abstrair na primeira duplicação" (viola AHA/[[DRY, KISS e YAGNI|YAGNI]]) — nem todo smell pede ação imediata.

## Boas práticas

- Usar **linters/SonarQube** para detectar smells automaticamente.
- Boy Scout Rule: melhore um pouco a cada passagem.
- Ligar smell → refatoração específica → testes.

## Conceitos relacionados

- [[Anti-patterns - Fundamentos]]
- [[Refatoracao]]
- [[Clean Code]]
- [[SOLID Principles]]
- [[Coesao e Acoplamento]]

## Perguntas importantes

### Code smell é bug?
Não. O código funciona; o smell indica **fraqueza de design** que aumenta o custo/risco futuro. É gatilho para refatorar.

### Todo smell precisa ser corrigido agora?
Não. É uma heurística. Priorize os que afetam áreas em mudança ativa; evite refatoração especulativa.

## Fontes

1. Wikipedia — Code smell — https://en.wikipedia.org/wiki/Code_smell (consultado 2026-09-03)
2. Fowler, M. (2018). *Refactoring*, 2ª ed. — catálogo de smells.
3. Beck, K. — origem do termo (WardsWiki).

## Observações

Criar notas por smell + refatoração associada. Status: verified.
