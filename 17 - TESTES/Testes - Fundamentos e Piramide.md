---
title: "Testes - Fundamentos e Pirâmide"
category: "17 - TESTES"
tags:
  - engenharia-software
  - testes
  - qualidade
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Testes de Software — Fundamentos e Pirâmide

## Resumo

**Teste de software** é o ato de verificar se o software atende aos seus objetivos e expectativas. Fornece informação **objetiva sobre qualidade e risco**. Não prova ausência de bugs — "testes mostram a presença, não a ausência, de defeitos" (Dijkstra). A **pirâmide de testes** orienta a proporção: muitos unitários, alguns de integração, poucos end-to-end.

## O que é?

Verificação de que o software **faz o que deve**. Pode ser:
- **Funcional** (comportamento/requisitos) vs. **não funcional** (desempenho, segurança, usabilidade).
- **Dinâmico** (executa o software e compara saída real × esperada) vs. **estático** (revisão de código/docs, análise estática).

A correção é medida contra um **oráculo**: especificação, contrato, versão anterior, expectativa do usuário, norma, etc.

## Por que existe?

Reduzir risco e custo de falhas. Um estudo do **NIST (2002)** estimou que bugs custavam US$ 59,5 bilhões/ano à economia dos EUA. Encontrar defeitos cedo é muito mais barato do que em produção.

## Como funciona? — Níveis e a Pirâmide

### Pirâmide de Testes (Mike Cohn)
```
        /\      E2E (poucos): lentos, caros, frágeis; validam o fluxo real
       /--\
      /    \    Integração (alguns): módulos + BD/APIs juntos
     /------\
    /        \  Unitários (muitos): rápidos, isolados, baratos
   /----------\
```
Regra: **a maior parte** dos testes deve ser unitária (rápida e barata), com menos integração e poucos E2E.

### Níveis
- **Unitário** — testa a menor unidade (função/classe) isoladamente; usa *mocks/stubs*.
- **Integração** — testa a colaboração entre componentes (ex.: serviço + banco).
- **Sistema / E2E** — testa o sistema completo pela interface do usuário.
- **Aceitação** — valida requisitos de negócio (pode ser [[TDD - Test-Driven Development|ATDD/BDD]]).

### Técnicas
- **Caixa-preta** (só entrada/saída) × **caixa-branca** (conhece o interior).
- **Cobertura** (coverage) — % de código exercitado; alta cobertura não garante qualidade dos testes.

## Exemplo prático (unitário, pytest)

```python
def somar(a, b): return a + b

def test_somar():
    assert somar(2, 3) == 5
    assert somar(-1, 1) == 0
```

## Quando utilizar

Sempre em código de produção. Automatize e rode em [[16 - CI-CD/_INDEX|CI]]. Priorize unitários por velocidade e integração para pontos de risco.

## Quando NÃO utilizar (nuance)

- Testar getters/setters triviais ou código gerado raramente compensa.
- E2E para tudo → suíte lenta e frágil ("sorvete invertido" / ice-cream cone anti-pattern).

## Trade-offs

- Mais testes = mais confiança, porém mais tempo de manutenção.
- E2E dá realismo, mas é lento/frágil; unitário é rápido, mas não pega problemas de integração.

## Erros comuns / Anti-patterns

- **Ice-cream cone:** muitos E2E, poucos unitários.
- Testes acoplados à implementação (quebram a cada refatoração).
- Perseguir 100% de cobertura como meta em si.
- Testes não determinísticos ("flaky").

## Boas práticas

- Testes rápidos, isolados, determinísticos e legíveis (AAA: Arrange-Act-Assert).
- Um motivo de falha por teste; nomes descritivos.
- Rodar na [[16 - CI-CD/_INDEX|pipeline de CI]] a cada commit.
- Testar comportamento, não implementação.

## Conceitos relacionados

- [[TDD - Test-Driven Development]]
- [[Refatoracao]]
- [[18 - QUALIDADE DE SOFTWARE/_INDEX|Qualidade de Software]]
- [[16 - CI-CD/_INDEX|CI/CD]]

## Perguntas importantes

### O que é a pirâmide de testes?
Heurística que recomenda **muitos testes unitários, alguns de integração e poucos E2E** — equilibrando velocidade, custo e confiança.

### Teste prova que o software não tem bugs?
Não. Testes revelam a **presença** de defeitos, nunca sua ausência total.

## Fontes

1. Wikipedia — Software testing — https://en.wikipedia.org/wiki/Software_testing (consultado 2026-09-03)
2. Mike Cohn — *Succeeding with Agile* (2009) — pirâmide de testes.
3. Estudo NIST (2002) sobre custo de bugs (citado na fonte 1).

## Observações

Aprofundar: mocks/stubs/fakes, cobertura, testes de contrato, property-based testing. Status: verified.
