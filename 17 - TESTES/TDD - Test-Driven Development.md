---
title: "TDD - Test-Driven Development"
category: "17 - TESTES"
tags:
  - engenharia-software
  - testes
  - tdd
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# TDD — Test-Driven Development

## Resumo

**TDD (Desenvolvimento Guiado por Testes)** é uma técnica em que você escreve um **teste que falha antes** de escrever o código de produção, implementa **o mínimo** para o teste passar e depois **refatora** — repetindo o ciclo. Foi (re)descoberta e popularizada por **Kent Beck** no contexto do **Extreme Programming (XP)**.

## O que é?

Fluxo curto e repetido: teste → código → refatoração. Testes e código de produção são escritos **juntos**, encurtando o tempo de depuração. TDD faz o desenvolvedor **focar nos requisitos antes de codar**.

## Por que existe?

- Feedback rápido e confiança para mudar código.
- Design **emergente** e testável (baixo acoplamento).
- Documentação executável do comportamento esperado.

Kent Beck: descreveu TDD em *Test-Driven Development by Example* (2003) e diz que "**encoraja designs simples e inspira confiança**"; refere-se a ter "redescoberto" a técnica.

## Como funciona? — Ciclo Red-Green-Refactor

```
🔴 RED      escreva um teste que falha (comportamento ainda não existe)
🟢 GREEN    escreva o MÍNIMO de código para o teste passar
🔵 REFACTOR melhore o design mantendo os testes verdes
   ↺        repita para o próximo cenário
```

Passos (baseados em *TDD by Example* e no "Canon TDD" de Beck):
1. Liste os cenários da nova funcionalidade.
2. Escreva **um** teste para um cenário → vermelho.
3. Faça passar do jeito mais simples → verde.
4. Refatore (código e teste) sem quebrar.
5. Repita.

## Exemplo prático

```python
# 1) RED — teste primeiro (falha: função não existe)
def test_fizzbuzz():
    assert fizzbuzz(3) == "Fizz"

# 2) GREEN — mínimo para passar
def fizzbuzz(n):
    if n % 3 == 0: return "Fizz"
    return str(n)

# 3) REFACTOR — generaliza quando novos testes exigirem (5->Buzz, 15->FizzBuzz)
```

## Conceitos fundamentais

- **Baby steps** — passos pequenos e seguros.
- **YAGNI na prática** — só implementa o que um teste exige ([[DRY, KISS e YAGNI|YAGNI]]).
- Variantes: **ATDD** (aceitação) e **BDD** (comportamento, Given-When-Then).

## Quando utilizar

- Lógica de negócio com regras claras e testáveis.
- Quando design/requisitos se beneficiam de feedback incremental.
- Ao corrigir bug: escreva um teste que o reproduz, depois corrija.

## Quando NÃO utilizar

- Exploração/prototipagem (spikes) onde o design é incerto.
- UI muito visual/experimental ou integrações difíceis de isolar — TDD puro pode atrapalhar; combine com outros níveis de teste.

## Trade-offs

- Investimento inicial maior **vs.** menos bugs e refatoração segura depois.
- Requer disciplina; sem refatoração contínua, perde valor.
- Pode induzir over-mocking e testes acoplados à implementação se mal aplicado.

## Erros comuns / Anti-patterns

- Escrever o teste **depois** do código e chamar de TDD.
- Pular a etapa **refactor** (acumula dívida).
- Testes gigantes que testam muita coisa de uma vez.
- Mock excessivo → testes frágeis.

## Boas práticas

- Ciclos curtos (minutos), um cenário por vez.
- Testar **comportamento**, não implementação.
- Manter a suíte rápida (roda a cada mudança) e verde.
- Combinar com [[Refatoracao|refatoração]] e [[16 - CI-CD/_INDEX|CI]].

## Conceitos relacionados

- [[Testes - Fundamentos e Piramide]]
- [[Refatoracao]]
- [[DRY, KISS e YAGNI]]
- [[SOLID Principles]] (código testável tende a ser SOLID)

## Perguntas importantes

### O que é Red-Green-Refactor?
O ciclo do TDD: escrever teste que falha (red), fazer passar com o mínimo (green), melhorar o design mantendo verde (refactor).

### TDD garante código sem bugs?
Não. Reduz defeitos e melhora o design/confiança, mas depende da qualidade dos testes e das práticas de suporte.

## Fontes

1. Wikipedia — Test-driven development — https://en.wikipedia.org/wiki/Test-driven_development (consultado 2026-09-03)
2. Beck, K. (2003). *Test-Driven Development by Example.* Addison-Wesley.
3. Beck, K. — "Canon TDD" (artigo).

## Observações

Aprofundar BDD (Given-When-Then) e ATDD em notas próprias. Status: verified (autoria e ciclo confirmados).
