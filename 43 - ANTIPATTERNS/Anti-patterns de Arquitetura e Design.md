---
title: "Anti-patterns de Arquitetura e Design"
category: "43 - ANTIPATTERNS"
tags:
  - engenharia-software
  - antipatterns
  - arquitetura
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Anti-patterns de Arquitetura e Design

## Resumo

Anti-patterns no nível de **design de classes/módulos** e de **arquitetura de sistemas**: soluções estruturais comuns que corroem manutenibilidade. Reconhecê-los cedo evita custo alto, pois decisões arquiteturais são caras de reverter ([[Arquitetura de Software - Fundamentos]]).

## Anti-patterns de Design (classes/objetos)

- **God Object / God Class** — uma classe concentra controle e responsabilidades demais. Viola [[SOLID Principles|SRP]]. → dividir (*Extract Class*).
- **Objeto Anêmico (Anemic Domain Model)** — entidades só com dados, lógica espalhada em "services" (parece OO, é procedural). Contrário do [[Domain-Driven Design (DDD)|DDD]].
- **Poltergeist** — classes efêmeras que só repassam chamadas.
- **Yo-yo Problem** — hierarquia de herança tão profunda que força pular de classe em classe para entender o fluxo.
- **Circular Dependency** — módulos que dependem mutuamente → alto [[Coesao e Acoplamento|acoplamento]].
- **Magic Numbers/Strings** — literais sem significado explícito.
- **Golden Hammer** — "para quem tem um martelo, tudo é prego": aplicar a mesma ferramenta/tecnologia favorita a todo problema.

## Anti-patterns de Arquitetura (sistema)

- **Big Ball of Mud** — sistema **sem arquitetura perceptível**; comum na prática por pressão de negócio, rotatividade e entropia. O anti-pattern arquitetural por excelência.
- **Spaghetti Code** — fluxo de controle emaranhado, sem estrutura clara.
- **Lava Flow** — código morto/obsoleto que ninguém remove por medo, "endurecendo" no sistema.
- **Distributed Monolith** — microsserviços tão acoplados que precisam ser implantados juntos (o pior dos dois mundos — ver [[Microsservicos]]).
- **Stovepipe / Silos** — sistemas/integrar duplicando soluções sem reuso.
- **Vendor Lock-in** — dependência excessiva de um fornecedor dificultando migração ([[Computacao em Nuvem - Fundamentos|cloud]]).
- **Over-engineering / Gold Plating** — complexidade e recursos além do necessário (viola [[DRY, KISS e YAGNI|KISS/YAGNI]]).
- **Premature Optimization** — otimizar antes de medir ("a raiz de todo mal", Knuth) — ver [[21 - PERFORMANCE/_INDEX|Performance]].

## Exemplo — de God Object para responsabilidades separadas

```python
# ❌ God Object
class Sistema:
    def autenticar(self): ...
    def calcular_frete(self): ...
    def gerar_relatorio(self): ...
    def enviar_email(self): ...

# ✅ Responsabilidades distribuídas (SRP)
class Autenticador: ...
class CalculadoraFrete: ...
class GeradorRelatorio: ...
class ServicoEmail: ...
```

## Como evitar / sair

- **Design guiado por princípios:** [[SOLID Principles|SOLID]], alta [[Coesao e Acoplamento|coesão / baixo acoplamento]].
- **Fronteiras claras:** [[Domain-Driven Design (DDD)|bounded contexts]], [[Clean Architecture]]/[[Hexagonal Architecture]].
- **Refatoração contínua** ([[Refatoracao]]) e remoção de código morto.
- **Fitness functions** e ADRs ([[45 - DECISOES ARQUITETURAIS/_INDEX]]) para conter erosão arquitetural.
- **Comece simples**; adote complexidade só quando um atributo de qualidade exigir.

## Quando "não é" anti-pattern (nuance)

- Um monolito **modular** bem feito não é Big Ball of Mud — monolito não é anti-pattern por si.
- Alguma duplicação/simplicidade pode ser melhor que abstração errada (AHA).

## Erros comuns

- Rotular escolhas legítimas de "anti-pattern" por preferência.
- Migrar para microsserviços e criar um **monólito distribuído**.
- Otimizar/abstrair prematuramente.

## Conceitos relacionados

- [[Anti-patterns - Fundamentos]]
- [[Code Smells]]
- [[SOLID Principles]] · [[Coesao e Acoplamento]]
- [[Arquitetura de Software - Fundamentos]] · [[Clean Architecture]]
- [[Microsservicos]]

## Perguntas importantes

### O que é Big Ball of Mud?
Um sistema sem arquitetura perceptível, com dependências emaranhadas. É o anti-pattern arquitetural mais comum, resultado de pressão de prazo, rotatividade e entropia acumulada.

### Monolito é um anti-pattern?
Não. Um **monolito modular** é uma escolha válida. O anti-pattern é o **Big Ball of Mud** (falta de estrutura) ou o **monólito distribuído** (microsserviços acoplados).

## Fontes

1. Wikipedia — Anti-pattern — https://en.wikipedia.org/wiki/Anti-pattern (consultado 2026-09-03)
2. Foote & Yoder — "Big Ball of Mud" (1997) — http://www.laputan.org/mud/
3. Brown et al. (1998). *AntiPatterns.*

## Observações

Criar notas próprias: Big Ball of Mud, Distributed Monolith, Golden Hammer. Status: verified.
