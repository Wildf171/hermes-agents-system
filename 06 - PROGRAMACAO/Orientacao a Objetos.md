---
title: "Orientação a Objetos"
category: "06 - PROGRAMACAO"
tags:
  - engenharia-software
  - programacao
  - oop
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Orientação a Objetos (OOP)

## Resumo

**Programação Orientada a Objetos (OOP)** é um paradigma baseado em **objetos** — entidades de software que **encapsulam dados e comportamento** — que interagem entre si. É o paradigma dominante em linguagens como Java, C#, Python, C++ e Ruby.

## O que é?

Um programa OO é composto por objetos que se comunicam. Um objeto reúne:
- **Estado** (atributos/campos de dados)
- **Comportamento** (métodos/funções)

Uma **classe** é o molde; **objetos** são instâncias dela.

## Por que existe? — História

- Origem nos anos 1950–60 (grupo de IA do MIT; Sketchpad de Ivan Sutherland, 1960–61).
- **Simula (Noruega, 1961–1967)** — geralmente aceita como a **primeira linguagem OO**; introduziu **classes, herança e ligação dinâmica**.
- **Alan Kay** cunhou o termo "object-oriented programming" (~1967) e criou o **Smalltalk** (anos 70); sua visão enfatizava **troca de mensagens** entre objetos, como células biológicas.

Motivação: modularizar sistemas grandes agrupando dados + comportamento relacionados, aproximando o código do domínio do mundo real.

## Como funciona? — Os 4 pilares

### 1. Encapsulamento
Esconde o estado interno e expõe uma interface controlada. Reduz acoplamento; protege invariantes. (getters/setters, campos privados)

### 2. Abstração
Expõe **o essencial**, esconde detalhes de implementação. Modela conceitos do domínio (uma `ContaBancaria` sem expor como o saldo é guardado).

### 3. Herança
Uma classe (subclasse) reutiliza/estende outra (superclasse). Cria hierarquias "é-um". ⚠️ Herança profunda gera acoplamento — **prefira composição sobre herança**.

### 4. Polimorfismo
O mesmo contrato assume comportamentos diferentes conforme o tipo. Permite escrever código que trata subtipos uniformemente (base do [[32 - SOLID/_INDEX|princípio de Liskov e da inversão de dependência]]).

## Conceitos fundamentais

- **Classe vs. Objeto** — molde vs. instância.
- **Mensagem/método** — como objetos interagem.
- **Interface / classe abstrata** — contratos sem (ou com pouca) implementação.
- **Composição** — objetos contêm outros objetos ("tem-um"), alternativa flexível à herança.
- **Class-based** (Java/Python) vs **prototype-based** (JavaScript).

## Exemplo prático

```python
class ContaBancaria:
    def __init__(self, saldo=0):
        self.__saldo = saldo          # encapsulamento (privado)

    def depositar(self, valor):        # comportamento
        if valor <= 0:
            raise ValueError("valor deve ser positivo")
        self.__saldo += valor

    @property
    def saldo(self):                   # abstração da leitura
        return self.__saldo

class ContaPoupanca(ContaBancaria):    # herança
    def render_juros(self, taxa):
        self.depositar(self.saldo * taxa)
```

## Quando utilizar

- Domínios com **entidades ricas** e comportamento associado (sistemas de negócio, ver [[33 - DDD/_INDEX|DDD]]).
- Times grandes que se beneficiam de modularidade e contratos claros.

## Quando NÃO utilizar

- Scripts pequenos ou transformações de dados → funções/[[Paradigmas de Programacao|funcional]] costumam ser mais simples.
- Quando a hierarquia de herança fica artificial → prefira composição ou outro paradigma.

## Trade-offs

- **Prós:** modularidade, reutilização, aderência ao domínio, encapsulamento.
- **Contras:** cerimônia, risco de sobre-engenharia, hierarquias frágeis, estado mutável dificultando concorrência.

## Erros comuns / Anti-patterns

- **Herança em excesso** (deep inheritance) em vez de composição.
- **Objetos anêmicos** (só dados, sem comportamento) — vira estrutura procedural disfarçada.
- **God object** — classe que faz tudo (viola [[32 - SOLID/_INDEX|SRP]]).
- Expor estado interno (quebra encapsulamento).

## Boas práticas

- **Composição sobre herança.**
- Programar para **interfaces**, não implementações.
- Aplicar [[32 - SOLID/_INDEX|SOLID]] e [[05 - PRINCÍPIOS DE SOFTWARE/_INDEX|princípios]] (alta coesão, baixo acoplamento).

## Conceitos relacionados

- [[Paradigmas de Programacao]]
- [[32 - SOLID/_INDEX|SOLID]]
- [[Coesao e Acoplamento]]
- [[08 - DESIGN PATTERNS/_INDEX|Design Patterns]]
- [[33 - DDD/_INDEX|DDD]]

## Perguntas importantes

### Quais são os 4 pilares da OOP?
Encapsulamento, Abstração, Herança e Polimorfismo.

### Qual foi a primeira linguagem OO?
**Simula** (1961–1967), que introduziu classes, herança e ligação dinâmica. O termo "OOP" foi cunhado por **Alan Kay** (Smalltalk).

### Herança ou composição?
Prefira **composição** por padrão; use herança apenas para relações "é-um" genuínas e estáveis.

## Fontes

1. Wikipedia — Object-oriented programming — https://en.wikipedia.org/wiki/Object-oriented_programming (consultado 2026-09-03)
2. Alan Kay — sobre a origem do termo e mensagens entre objetos (citado na fonte 1).
3. Gamma et al. — *Design Patterns* (1994) — "favor composition over inheritance".

## Observações

Aprofundar cada pilar e "composição vs herança" em notas próprias; ligar a SOLID. Status: verified (história e pilares confirmados).
