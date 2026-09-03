---
title: "SOLID Principles"
category: "32 - SOLID"
tags:
  - engenharia-software
  - solid
  - design
  - oop
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# SOLID — Cinco Princípios de Design OO

## Resumo

**SOLID** é um acrônimo mnemônico para cinco princípios de design orientado a objetos que tornam o código mais **compreensível, flexível e manutenível**. Introduzidos por **Robert C. Martin** ("Uncle Bob") no paper *Design Principles and Design Patterns* (2000, sobre *software rot*); o acrônimo foi cunhado por **Michael Feathers** (~2004).

## O que é? — Os 5 princípios

### S — Single Responsibility Principle (SRP)
"Uma classe nunca deve ter mais de uma razão para mudar" — ou seja, **uma única responsabilidade**.
- **Ganhos:** manutenibilidade, testabilidade, mudanças isoladas.
- Aumenta [[Coesao e Acoplamento|coesão]].

```python
# ❌ duas responsabilidades: regra + persistência
class Fatura:
    def calcular_total(self): ...
    def salvar_no_banco(self): ...

# ✅ separadas
class Fatura:
    def calcular_total(self): ...
class FaturaRepository:
    def salvar(self, fatura): ...
```

### O — Open–Closed Principle (OCP)
"Entidades de software devem ser **abertas para extensão, fechadas para modificação**." Adicione comportamento novo sem alterar código existente (via polimorfismo/abstrações).

```python
# ✅ novo meio de pagamento sem tocar no processador
class Pagamento:  # abstração
    def pagar(self, v): ...
class Pix(Pagamento): ...
class Cartao(Pagamento): ...
def processar(p: Pagamento, v): p.pagar(v)
```

### L — Liskov Substitution Principle (LSP)
Objetos de uma subclasse devem poder **substituir** os da superclasse **sem quebrar** o programa. Subtipos honram o contrato do supertipo (ligado a *Design by Contract*).
- Clássico anti-exemplo: `Quadrado` herdando de `Retângulo` quebra invariantes.

### I — Interface Segregation Principle (ISP)
Clientes **não devem ser forçados a depender** de métodos que não usam. Prefira **interfaces pequenas e específicas** a uma "gorda".

```python
# ❌ interface gorda
class Maquina:  # imprimir, escanear, faxear...
# ✅ segregada
class Impressora: def imprimir(self): ...
class Scanner: def escanear(self): ...
```

### D — Dependency Inversion Principle (DIP)
Módulos de alto nível **não devem depender** de módulos de baixo nível; ambos dependem de **abstrações**. Detalhes dependem de abstrações, não o contrário. Base da **injeção de dependência**.

```python
class Notificador:            # alto nível depende de abstração
    def __init__(self, canal: Canal): self.canal = canal
class Canal: ...              # abstração
class Email(Canal): ...       # detalhe
```

## Por que existe?

Combater o **apodrecimento do software** (*software rot*): rigidez, fragilidade, imobilidade e viscosidade que surgem quando o design não absorve mudanças. SOLID torna o código adaptável a requisitos que mudam.

## Quando utilizar

- Sistemas OO de médio/grande porte, mantidos por tempo.
- Onde requisitos evoluem e testes automatizados importam.

## Quando NÃO utilizar (com moderação)

- Scripts pequenos e descartáveis: aplicar SOLID inteiro é sobre-engenharia.
- Cuidado com **abstração prematura** (conflito com [[DRY, KISS e YAGNI|YAGNI/AHA]]): introduza a abstração quando a variação realmente aparecer.

## Trade-offs

- Mais flexível e testável **vs.** mais classes/indireção.
- Excesso de interfaces e camadas pode reduzir legibilidade — equilíbrio com [[DRY, KISS e YAGNI|KISS]].

## Erros comuns / Anti-patterns

- Confundir SRP com "uma classe = um método".
- OCP via `if/else` gigante em vez de polimorfismo.
- Violar LSP com subclasses que lançam `NotImplemented`.
- DIP "de mentira": injetar classe concreta em vez de abstração.

## Boas práticas

- SRP → alta [[Coesao e Acoplamento|coesão]]; DIP/ISP → baixo acoplamento.
- Combinar com [[08 - DESIGN PATTERNS/Design Patterns - Introduction|Design Patterns]] (Strategy, Factory, Observer implementam SOLID).
- Guiar por testes ([[TDD - Test-Driven Development|TDD]]) — código testável tende a ser SOLID.

## Conceitos relacionados

- [[Orientacao a Objetos]]
- [[Coesao e Acoplamento]]
- [[DRY, KISS e YAGNI]]
- [[08 - DESIGN PATTERNS/Design Patterns - Introduction|Design Patterns]]
- [[31 - CLEAN CODE/Clean Code|Clean Code]]

## Perguntas importantes

### Quem criou o SOLID?
Os princípios são de **Robert C. Martin** (2000); o acrônimo foi cunhado por **Michael Feathers** (~2004).

### SOLID só vale para OO?
Nasceu no OO, mas a filosofia (responsabilidade única, depender de abstrações) influencia design ágil e até programação funcional.

## Fontes

1. Wikipedia — SOLID — https://en.wikipedia.org/wiki/SOLID (consultado 2026-09-03)
2. Martin, R. C. (2000). *Design Principles and Design Patterns.*
3. Martin, R. C. *Agile Software Development, Principles, Patterns, and Practices* (2002).

## Observações

Detalhar LSP (Design by Contract) e exemplos de violação em nota própria. Status: verified (autoria e definições confirmadas).
