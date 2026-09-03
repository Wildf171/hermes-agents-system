---
title: "Domain-Driven Design (DDD)"
category: "33 - DDD"
tags:
  - engenharia-software
  - ddd
  - arquitetura
  - modelagem
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Domain-Driven Design (DDD)

## Resumo

**DDD** é uma abordagem de design de software que foca em **modelar o software para refletir o domínio do negócio**, com base na colaboração contínua entre desenvolvedores e **especialistas do domínio**. Em vez de um único modelo unificado, divide o sistema em **bounded contexts**, cada um com seu próprio modelo. O termo foi cunhado por **Eric Evans** no livro homônimo (2003).

## O que é?

A estrutura e a linguagem do código (nomes de classes, métodos, variáveis) devem **espelhar o domínio de negócio**. Ex.: um sistema de empréstimos tem classes como `SolicitacaoEmprestimo`, `Cliente` e métodos como `aceitarProposta`, `cancelar`.

Objetivos:
- Focar no **core domain** e na lógica de domínio.
- Basear designs complexos em um **modelo do domínio**.
- Colaboração criativa e iterativa entre técnicos e especialistas.

## Por que existe?

Software complexo falha quando o código não fala a língua do negócio. DDD alinha modelo, código e linguagem para dominar a complexidade **essencial** do domínio. A Microsoft recomenda DDD **apenas para domínios complexos**, onde o modelo traz benefício claro.

## Como funciona? — Design Estratégico e Tático

### Estratégico (macro)
- **Ubiquitous Language** — linguagem comum entre domínio e código; um dos pilares.
- **Bounded Context** — fronteira onde um modelo é válido e consistente; sistemas grandes têm vários.
- **Context Map** — como os bounded contexts se relacionam (partnership, anticorruption layer, etc.).
- **Core / Supporting / Generic subdomains** — onde investir mais esforço.

### Tático (micro) — blocos de construção
- **Entity** — objeto com identidade própria ao longo do tempo (ex.: `Cliente`).
- **Value Object** — definido pelos valores, imutável, sem identidade (ex.: `Dinheiro`, `Endereco`).
- **Aggregate** — cluster de objetos tratado como unidade; tem uma **Aggregate Root** que garante invariantes.
- **Repository** — abstração de persistência de aggregates.
- **Domain Service** — lógica de domínio que não pertence a uma entity.
- **Domain Event** — algo relevante que aconteceu no domínio (liga a [[35 - EVENT DRIVEN/_INDEX|event-driven]]).
- **Factory** — cria aggregates complexos.

## Exemplo prático

```python
# Value Object (imutável, sem identidade)
@dataclass(frozen=True)
class Dinheiro:
    valor: Decimal
    moeda: str

# Entity + Aggregate Root garantindo invariante
class Pedido:                      # Aggregate Root
    def __init__(self): self._itens = []
    def adicionar_item(self, item):
        if self._fechado: raise Erro("pedido fechado")
        self._itens.append(item)   # invariante controlada pela raiz
```

## Quando utilizar

- Domínios **complexos** com regras de negócio ricas e em evolução.
- Quando há acesso a especialistas do domínio.
- Base natural para fronteiras de [[34 - MICROSERVICOS/_INDEX|microsserviços]] (um bounded context ≈ um serviço).

## Quando NÃO utilizar

- CRUD simples / domínio trivial → DDD vira cerimônia sem retorno.
- Sem acesso a especialistas do domínio → a ubiquitous language não se forma.

## Trade-offs

- **Ganha:** modelo alinhado ao negócio, manutenibilidade, fronteiras claras.
- **Perde:** curva de aprendizado, exige isolamento/encapsulamento e disciplina.

## Erros comuns / Anti-patterns

- **Modelo anêmico** — entities só com dados, lógica espalhada em "services" (não é DDD de verdade).
- Aggregates grandes demais (problemas de consistência/performance).
- Ignorar bounded contexts → um "modelo único" que vira big ball of mud.
- Aplicar DDD tático sem o estratégico (perde o essencial).

## Boas práticas

- Comece pela **ubiquitous language** e pelos **bounded contexts**.
- Aggregates pequenos; consistência forte só dentro do aggregate.
- Alinhe fronteiras de serviço aos bounded contexts.
- Combine com [[Clean Architecture]] / [[Hexagonal Architecture]] (domínio no centro).

## Conceitos relacionados

- [[Arquitetura de Software - Fundamentos]]
- [[Clean Architecture]]
- [[34 - MICROSERVICOS/_INDEX|Microsserviços]]
- [[35 - EVENT DRIVEN/_INDEX|Event-Driven / CQRS]]
- [[Coesao e Acoplamento]]

## Perguntas importantes

### O que é Bounded Context?
Uma fronteira explícita dentro da qual um modelo de domínio é definido e consistente. Termos podem significar coisas diferentes em contextos diferentes; cada um tem seu modelo.

### Qual a diferença entre Entity e Value Object?
Entity tem **identidade** que persiste (dois clientes com mesmos dados são diferentes). Value Object é definido pelos **valores** e é imutável (dois `Dinheiro(10, BRL)` são iguais).

## Fontes

1. Wikipedia — Domain-driven design — https://en.wikipedia.org/wiki/Domain-driven_design (consultado 2026-09-03)
2. Evans, E. (2003). *Domain-Driven Design: Tackling Complexity in the Heart of Software.*
3. Vernon, V. (2013). *Implementing Domain-Driven Design.*

## Observações

Criar notas próprias: Bounded Context, Aggregates, Value Objects, Context Mapping. Status: verified.
