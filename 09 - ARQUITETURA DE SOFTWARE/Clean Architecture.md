---
title: "Clean Architecture"
category: "09 - ARQUITETURA DE SOFTWARE"
tags:
  - engenharia-software
  - arquitetura
  - clean-architecture
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Clean Architecture

## Resumo

**Clean Architecture** é um estilo arquitetural proposto por **Robert C. Martin** (2012, livro *Clean Architecture* em 2017) que organiza o sistema em **círculos concêntricos**, mantendo as **regras de negócio no centro**, independentes de frameworks, UI e banco de dados. É uma síntese de ideias anteriores: Hexagonal (Cockburn), Onion (Palermo) e DDD.

## O que é?

Camadas concêntricas com uma **Regra de Dependência**: dependências de código apontam **sempre para dentro**, em direção às políticas de mais alto nível.

```
   ┌──────────────────────────────────────┐
   │  Frameworks & Drivers (UI, DB, Web)   │  ← detalhes
   │  ┌────────────────────────────────┐   │
   │  │ Interface Adapters             │   │  ← controllers, gateways, presenters
   │  │  ┌──────────────────────────┐  │   │
   │  │  │ Use Cases (App Business) │  │   │  ← regras da aplicação
   │  │  │  ┌────────────────────┐  │  │   │
   │  │  │  │ Entities (Enterprise│  │  │   │  ← regras de negócio centrais
   │  │  │  │  Business Rules)    │  │  │   │
   │  │  │  └────────────────────┘  │  │   │
   │  │  └──────────────────────────┘  │   │
   │  └────────────────────────────────┘   │
   └──────────────────────────────────────┘
        Dependências apontam para DENTRO →
```

## Por que existe?

Para que **regras de negócio não dependam de detalhes** (framework, BD, UI). Isso torna o núcleo testável isoladamente, permite trocar detalhes (ex.: trocar banco) sem tocar no domínio e adia decisões de infraestrutura.

## Como funciona? — A Regra da Dependência

- **Nada em um círculo interno sabe** de algo em um círculo externo.
- Nomes definidos fora não podem ser mencionados dentro.
- Cruzar fronteiras "de dentro para fora" usa **Inversão de Dependência** ([[SOLID Principles|DIP]]): interfaces são definidas no núcleo e implementadas fora.

### Camadas
1. **Entities** — regras de negócio corporativas (as mais estáveis).
2. **Use Cases** — regras da aplicação (orquestram entities).
3. **Interface Adapters** — controllers, presenters, gateways (convertem dados).
4. **Frameworks & Drivers** — web, BD, UI, dispositivos (detalhes voláteis).

## Exemplo prático (estrutura)

```
core/
  entities/        # Pedido, Cliente (puros, sem framework)
  usecases/        # CriarPedido, definindo a interface PedidoRepository
adapters/
  controllers/     # HTTP -> usecase
  repositories/    # implementa PedidoRepository (SQL)
infra/
  web/ db/         # framework, driver do banco
```
O `usecase` depende da **interface** `PedidoRepository`, não da implementação SQL (DIP).

## Quando utilizar

- Domínios **complexos** e de vida longa, com regras de negócio ricas.
- Quando testabilidade e independência de tecnologia importam.

## Quando NÃO utilizar

- CRUD simples / MVP: a indireção (muitas interfaces/camadas) vira **over-engineering** ([[DRY, KISS e YAGNI|YAGNI]]).
- Times pequenos com escopo trivial.

## Trade-offs

- **Ganha:** independência de frameworks, testabilidade, flexibilidade.
- **Perde:** mais código/indireção, curva de aprendizado, boilerplate de mapeamento entre camadas.

## Erros comuns / Anti-patterns

- Vazar entidades de framework (ex.: model do ORM) para o núcleo.
- Regra de dependência invertida (domínio importando infra).
- Aplicar em tudo, inclusive onde não compensa.

## Boas práticas

- Definir **interfaces no núcleo**, implementações na borda (DIP).
- Manter entities/use cases **livres de anotações de framework**.
- Combinar com [[33 - DDD/_INDEX|DDD]] (entities/aggregates no centro).

## Conceitos relacionados

- [[Arquitetura de Software - Fundamentos]]
- [[Hexagonal Architecture]] (mesma ideia, ports & adapters)
- [[SOLID Principles]] (DIP é o motor)
- [[33 - DDD/_INDEX|DDD]]

## Perguntas importantes

### Qual a diferença entre Clean e Hexagonal?
São primas: ambas isolam o domínio dos detalhes via inversão de dependência. Hexagonal fala em **ports & adapters**; Clean organiza em **círculos concêntricos** com camadas nomeadas (Entities/Use Cases). Clean é, em parte, uma generalização da Hexagonal + Onion + DDD.

### Clean Architecture serve para qualquer projeto?
Não. Brilha em domínios complexos; em CRUDs simples costuma ser custo sem benefício.

## Fontes

1. Martin, R. C. (2017). *Clean Architecture: A Craftsman's Guide to Software Structure and Design.* Prentice Hall.
2. Martin, R. C. — "The Clean Architecture" — https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
3. Cockburn (Hexagonal); Palermo (Onion) — influências citadas por Martin.

## Observações

Baseada no artigo e livro de Uncle Bob (amplamente consolidados). Aprofundar: mapeamento entre camadas, exemplos por linguagem. Status: verified.
