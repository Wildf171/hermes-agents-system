---
title: "Design Patterns - Introdução (GoF)"
category: "08 - DESIGN PATTERNS"
tags:
  - engenharia-software
  - design-patterns
  - gof
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Design Patterns — Introdução (Gang of Four)

## Resumo

**Design Patterns** são soluções reutilizáveis e nomeadas para problemas recorrentes de design de software. O catálogo canônico vem do livro ***Design Patterns: Elements of Reusable Object-Oriented Software* (1994)**, de **Erich Gamma, Richard Helm, Ralph Johnson e John Vlissides** — a "**Gang of Four (GoF)**" — com **23 padrões** em 3 categorias.

## O que é?

Um padrão descreve um problema recorrente e o **cerne da solução**, de forma que possa ser reaplicada. Não é código pronto: é um *template* de design. O livro do GoF (Addison-Wesley, 1994, exemplos em C++ e Smalltalk) parte de dois princípios centrais:

- **"Program to an interface, not an implementation."**
- **"Favor object composition over class inheritance."**

## Por que existe?

Para dar **vocabulário comum** e soluções comprovadas a problemas de design OO — evitando reinventar a roda e comunicando intenção ("aqui uso um Observer") de forma concisa.

## Como funciona? — As 3 categorias e os 23 padrões

### Creational (5) — criação de objetos
Abstraem o processo de instanciação.
- **Singleton** — uma única instância global.
- **Factory Method** — subclasses decidem qual objeto criar.
- **Abstract Factory** — famílias de objetos relacionados.
- **Builder** — constrói objetos complexos passo a passo.
- **Prototype** — cria por clonagem.

### Structural (7) — composição de classes/objetos
- **Adapter** — adapta uma interface a outra esperada.
- **Bridge** — separa abstração de implementação.
- **Composite** — árvores parte-todo tratadas uniformemente.
- **Decorator** — adiciona comportamento dinamicamente (alternativa à herança).
- **Facade** — interface simples para subsistema complexo.
- **Flyweight** — compartilha objetos para economizar memória.
- **Proxy** — substituto que controla acesso.

### Behavioral (11) — comunicação entre objetos
- **Strategy** — algoritmos intercambiáveis (implementa OCP).
- **Observer** — notifica dependentes de mudanças (pub/sub).
- **Command** — encapsula requisição como objeto.
- **Iterator** — percorre coleção sem expor estrutura.
- **State** — muda comportamento conforme estado interno.
- **Template Method** — esqueleto do algoritmo, passos nas subclasses.
- **Chain of Responsibility** — passa requisição por uma cadeia.
- **Mediator** — centraliza comunicação entre objetos.
- **Memento** — captura/restaura estado (undo).
- **Visitor** — adiciona operações sem alterar classes.
- **Interpreter** — interpreta uma linguagem/gramática.

## Exemplo prático — Strategy

```python
class FreteStrategy:
    def calcular(self, peso): ...
class Sedex(FreteStrategy):
    def calcular(self, peso): return peso * 2.5
class PAC(FreteStrategy):
    def calcular(self, peso): return peso * 1.2

class Pedido:
    def __init__(self, frete: FreteStrategy): self.frete = frete
    def total_frete(self, peso): return self.frete.calcular(peso)
# Troca o algoritmo sem alterar Pedido (OCP)
```

## Quando utilizar

- Quando reconhecer um **problema recorrente** que um padrão resolve.
- Para comunicar design em equipe com vocabulário comum.

## Quando NÃO utilizar

- **Patternitis:** aplicar padrões por status, não por necessidade → complexidade desnecessária ([[DRY, KISS e YAGNI|KISS/YAGNI]]).
- Linguagens dinâmicas/funcionais às vezes tornam certos padrões triviais ou desnecessários (ex.: Strategy = passar função).

## Trade-offs

- Ganho de flexibilidade/comunicação **vs.** indireção e mais classes.
- Padrão errado para o problema piora o design.

## Erros comuns / Anti-patterns

- Forçar Singleton (vira estado global → acoplamento, dificulta testes).
- Usar padrão sem entender o problema que ele resolve.
- Confundir padrão (design) com framework/biblioteca.

## Boas práticas

- Aprender o **problema** que cada padrão resolve, não só a estrutura.
- Preferir composição (base de Strategy, Decorator).
- Combinar com [[SOLID Principles|SOLID]] (muitos padrões implementam OCP/DIP).

## Conceitos relacionados

- [[SOLID Principles]]
- [[Orientacao a Objetos]]
- [[09 - ARQUITETURA DE SOFTWARE/_INDEX|Arquitetura]] (padrões arquiteturais são outra camada)
- [[43 - ANTIPATTERNS/_INDEX|Anti-patterns]]

## Perguntas importantes

### Quantos padrões GoF existem?
**23**, em 3 categorias: Creational (5), Structural (7), Behavioral (11).

### Design pattern é o mesmo que padrão arquitetural?
Não. Patterns GoF operam no nível de **classes/objetos**; padrões arquiteturais (MVC, Camadas, Microsserviços) operam no nível do **sistema**.

## Fontes

1. Wikipedia — Design Patterns (book) — https://en.wikipedia.org/wiki/Design_Patterns (consultado 2026-09-03)
2. Gamma, Helm, Johnson, Vlissides (1994). *Design Patterns: Elements of Reusable Object-Oriented Software.* Addison-Wesley.

## Observações

Criar notas individuais por padrão (Strategy, Observer, Factory, Decorator…) com exemplos executáveis. Status: verified (catálogo e autoria confirmados).
