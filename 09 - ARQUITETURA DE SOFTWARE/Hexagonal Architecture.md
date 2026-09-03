---
title: "Hexagonal Architecture"
category: "09 - ARQUITETURA DE SOFTWARE"
tags:
  - engenharia-software
  - arquitetura
  - hexagonal
  - ports-and-adapters
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Hexagonal Architecture (Ports & Adapters)

## Resumo

A **arquitetura hexagonal**, ou **Ports & Adapters**, é um estilo criado por **Alistair Cockburn** que isola o **núcleo da aplicação** de tudo que é externo (UI, banco, APIs) por meio de **portas** (interfaces) e **adaptadores** (implementações). Torna componentes intercambiáveis e o núcleo facilmente testável.

## O que é?

O núcleo (regras de negócio) expõe **ports** — APIs abstratas — e o mundo externo se conecta via **adapters** que implementam/consomem esses ports. O nome "hexagonal" é só uma convenção gráfica (espaço para várias interfaces), **não** significa "seis lados".

- **Driving/primary adapters** (lado esquerdo) — quem *aciona* a aplicação (UI, controllers, testes).
- **Driven/secondary adapters** (lado direito) — o que a aplicação *aciona* (BD, mensageria, e-mail).

## Por que existe?

Cockburn queria evitar armadilhas estruturais do design OO: **dependências indevidas entre camadas** e **contaminação da UI com lógica de negócio**. Isolando o núcleo, você pode trocar UI/BD e automatizar testes com facilidade. (Renomeado "Ports and Adapters" em 2005; livro em 2024 com Juan Manuel Garrido de Paz.)

## Como funciona?

```
   [UI]      [Testes]                 (driving adapters)
      \        /
       \      /
     ┌──PORTS──┐
     │  NÚCLEO  │   ← regras de negócio (sem framework/BD)
     └──PORTS──┘
       /      \
      /        \
  [Banco]   [Fila/Email]              (driven adapters)
```

- **Port** = interface (contrato) definida pelo núcleo.
- **Adapter** = implementação técnica do port (SQL, REST, Kafka…).
- O núcleo depende só de ports; adapters dependem do núcleo (inversão de dependência).

## Exemplo prático

```python
# PORT (definido no núcleo)
class RepositorioPedido:               # interface
    def salvar(self, pedido): ...

# NÚCLEO usa o port, não a implementação
class CriarPedido:
    def __init__(self, repo: RepositorioPedido): self.repo = repo
    def executar(self, dados): self.repo.salvar(Pedido(dados))

# ADAPTER (fora do núcleo)
class RepositorioPedidoSQL(RepositorioPedido):
    def salvar(self, pedido): ...      # detalhe: SQL
# Em teste: um RepositorioPedidoEmMemoria implementa o mesmo port
```

## Quando utilizar

- Quando quer **testar o domínio sem infraestrutura** (troca adapters por fakes).
- Sistemas com múltiplas interfaces de entrada/saída.
- Domínios de média/alta complexidade.

## Quando NÃO utilizar

- CRUDs triviais: a indireção não compensa.
- Protótipos rápidos.

## Trade-offs

- **Ganha:** testabilidade, troca de tecnologia, baixo acoplamento.
- **Perde:** mais interfaces/boilerplate; exige disciplina.

## Erros comuns / Anti-patterns

- Vazar tipos de infraestrutura pelo port.
- Colocar lógica de negócio no adapter.
- Ports "anêmicos" que só espelham o ORM.

## Boas práticas

- Ports pequenos e orientados ao caso de uso (não à tecnologia).
- Adapters finos; regra de negócio só no núcleo.
- Um adapter em memória para testes rápidos.

## Conceitos relacionados

- [[Clean Architecture]] (mesma essência, camadas nomeadas)
- [[Arquitetura de Software - Fundamentos]]
- [[SOLID Principles]] (DIP)
- [[33 - DDD/_INDEX|DDD]]

## Perguntas importantes

### Hexagonal tem que ter 6 lados?
Não. O hexágono é só uma convenção de desenho com espaço para várias interfaces; o número de ports é livre.

### Hexagonal vs Clean Architecture?
Mesma ideia central (isolar o domínio via inversão de dependência). Clean adiciona camadas nomeadas (Entities/Use Cases) e a "regra da dependência" concêntrica; Hexagonal foca em ports & adapters.

## Fontes

1. Wikipedia — Hexagonal architecture (software) — https://en.wikipedia.org/wiki/Hexagonal_architecture_(software) (consultado 2026-09-03)
2. Cockburn, A. — "Hexagonal Architecture" / "Ports and Adapters" — https://alistair.cockburn.us/hexagonal-architecture/
3. Cockburn, A. & Garrido de Paz, J. M. (2024). *Hexagonal Architecture Explained.*

## Observações

Status: verified (origem e princípio confirmados na fonte 1).
