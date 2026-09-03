---
title: "Arquitetura de Software - Fundamentos"
category: "09 - ARQUITETURA DE SOFTWARE"
tags:
  - engenharia-software
  - arquitetura
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Arquitetura de Software — Fundamentos

## Resumo

**Arquitetura de software** é o conjunto de estruturas necessárias para raciocinar sobre um sistema — seus **elementos, as relações entre eles e as propriedades de ambos** — e a disciplina de criar essas estruturas. Trata das **decisões estruturais fundamentais**, aquelas caras de mudar depois de implementadas.

## O que é?

É o "blueprint" do sistema: componentes, como se relacionam e as regras que governam essas relações. Foca em atender aos **requisitos não funcionais** (desempenho, escalabilidade, segurança, manutenibilidade) — os chamados **atributos de qualidade** ou *architectural characteristics*.

> Duas "leis" da arquitetura de software:
> 1. **Tudo é um trade-off.**
> 2. **"Por quê" é mais importante que "como".**

## Por que existe?

Decisões arquiteturais são **caras de reverter**. Uma boa arquitetura reduz risco, permite evolução, comunica o design entre stakeholders e habilita o time a trabalhar em paralelo. Documentá-la (ex.: [[45 - DECISOES ARQUITETURAIS/_INDEX|ADRs]], C4 Model) captura decisões cedo.

## Como funciona? — Estilos e níveis

### Dois grandes tipos
- **Monolito** — aplicação única e coesa (com subtipos: modular monolith, layered).
- **Distribuída** — múltiplos serviços/processos (microsserviços, event-driven, SOA).

### Estilos comuns
- **Layered (em camadas)** — apresentação → aplicação → domínio → dados. Simples e popular; risco de virar "big ball of mud".
- **[[Clean Architecture]]** e **[[Hexagonal Architecture]]** — isolam o domínio de detalhes (UI, BD, frameworks).
- **[[33 - DDD/_INDEX|DDD]]** — organiza por domínio e bounded contexts.
- **[[34 - MICROSERVICOS/_INDEX|Microsserviços]]** — serviços independentes por capacidade de negócio.
- **[[35 - EVENT DRIVEN/_INDEX|Event-Driven]]** — componentes reagem a eventos.

### Ferramentas de modelagem
- **C4 Model** (Context, Container, Component, Code) — modela "o suficiente".
- Diagramas de componentes, sequência ([[04 - MODELAGEM/_INDEX|Modelagem]]).

## Conceitos fundamentais

- **Atributos de qualidade** (NFRs) — dirigem a arquitetura.
- **Trade-offs** — todo estilo troca algo (ex.: microsserviços trocam simplicidade por escala/independência).
- **Acoplamento entre componentes** — comunicação síncrona acopla; ambos passam a compartilhar as mesmas características.
- **Fitness functions** — testes automatizados de características arquiteturais (Evolutionary Architecture).

## Quando utilizar (escolha do estilo)

- Requisitos simples/equipe pequena → **monolito modular** (comece simples).
- Necessidade real de escalar/deploy independente por parte → **microsserviços**.
- Domínio complexo → **DDD + Clean/Hexagonal**.
- Fluxos assíncronos, integração desacoplada → **event-driven**.

## Quando NÃO utilizar

- Microsserviços "por moda" em sistema simples → complexidade distribuída sem retorno.
- Arquitetura elaborada demais para um MVP → over-engineering ([[DRY, KISS e YAGNI|YAGNI]]).

## Trade-offs (exemplos)

| Decisão | Ganha | Perde |
|---|---|---|
| Monolito | Simplicidade, deploy único | Escala granular, autonomia de times |
| Microsserviços | Escala/deploy independentes | Complexidade distribuída, latência |
| Síncrono | Simples de raciocinar | Acoplamento temporal |
| Assíncrono | Desacoplamento, resiliência | Complexidade, consistência eventual |

## Erros comuns / Anti-patterns

- **Big Ball of Mud** — ausência de arquitetura perceptível.
- Escolher estilo por moda, não por atributo de qualidade.
- Arquitetura no papel que diverge do código (falta de fitness functions/ADR).
- Acoplamento acidental via comunicação síncrona em cadeia.

## Boas práticas

- Comece simples; adote complexidade **quando um atributo de qualidade exigir**.
- Documente o **porquê** das decisões ([[45 - DECISOES ARQUITETURAIS/_INDEX|ADRs]]).
- Isole o domínio de detalhes técnicos ([[Clean Architecture]], [[Hexagonal Architecture]]).
- Meça características com fitness functions.

## Conceitos relacionados

- [[Clean Architecture]]
- [[Hexagonal Architecture]]
- [[33 - DDD/_INDEX|DDD]]
- [[34 - MICROSERVICOS/_INDEX|Microsserviços]]
- [[13 - SISTEMAS DISTRIBUIDOS/_INDEX|Sistemas Distribuídos]]
- [[Coesao e Acoplamento]]

## Perguntas importantes

### Qual a diferença entre arquitetura e design de software?
Arquitetura decide a **infraestrutura estrutural** e os atributos de qualidade (decisões caras de mudar); design de aplicação foca nos **processos e dados** que entregam a funcionalidade.

### Existe "a melhor arquitetura"?
Não — **tudo é trade-off**. A melhor é a que atende aos atributos de qualidade do seu contexto com o menor custo.

## Fontes

1. Wikipedia — Software architecture — https://en.wikipedia.org/wiki/Software_architecture (consultado 2026-09-03)
2. Bass, Clements, Kazman — *Software Architecture in Practice* (SEI).
3. Richards & Ford — *Fundamentals of Software Architecture* (O'Reilly) — "everything is a trade-off".
4. Simon Brown — C4 Model — https://c4model.com

## Observações

Criar notas próprias: Layered Architecture, C4 Model, Fitness Functions, atributos de qualidade. Status: verified.
