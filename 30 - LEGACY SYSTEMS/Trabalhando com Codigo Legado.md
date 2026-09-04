---
title: "Trabalhando com Código Legado"
category: "30 - LEGACY SYSTEMS"
tags:
  - engenharia-software
  - legacy
  - testes
  - refatoracao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Trabalhando com Código Legado

## Resumo

Mudar código legado com segurança exige uma **rede de testes** primeiro. As técnicas de **Michael Feathers** (*Working Effectively with Legacy Code*, 2004) — **testes de caracterização**, **seams** e "quebrar dependências" — permitem colocar código sem testes sob teste para então [[Refatoracao|refatorar]] com confiança.

## O problema central

**Legado = código sem testes.** O dilema: para adicionar testes com segurança, muitas vezes é preciso **mudar** o código; mas mudar sem testes é arriscado. Feathers chama isso de **"the legacy code dilemma"**. A saída são técnicas para inserir testes com o mínimo de mudança arriscada.

## Testes de Caracterização (Characterization Tests)

Testes que **documentam o comportamento atual** do código — inclusive bugs — sem julgar se está certo.
- Objetivo: **congelar o comportamento** para detectar regressões ao refatorar.
- Como: chame o código, veja o que ele retorna, e **escreva o teste afirmando esse resultado atual**.
- Não é "o que deveria fazer", e sim "o que faz hoje" — a rede de segurança.

```python
# Não sei o que "certo" deveria ser; capturo o comportamento atual:
def test_calcula_taxa_caracterizacao():
    assert calcula_taxa(100, "premium") == 12.5   # o que retorna hoje
```

## Seams (costuras)

Um **seam** é um ponto onde você pode **alterar o comportamento sem editar naquele local** — permite injetar um teste/substituto.
- Ex.: extrair uma dependência para um parâmetro/interface (injeção de dependência) para poder passar um **fake/mock** no teste.
- Tipos: object seam (polimorfismo), etc.

## Quebrar dependências

Legado costuma ter dependências difíceis de testar (banco, rede, singletons, `new` interno). Técnicas de Feathers para isolá-las:
- **Extract Interface / Extract Method** para criar um seam.
- **Parameterize Constructor/Method** — injetar a dependência.
- **Sprout Method/Class** — escrever o **código novo** em um método/classe **testável à parte** e chamá-lo do legado (evita mexer no miolo intocável).
- **Wrap Method/Class** — envolver o comportamento existente para adicionar o novo.

## O fluxo seguro

```
1. Identificar o "change point" (onde preciso mudar)
2. Achar/criar um SEAM para testar essa área
3. Escrever testes de CARACTERIZAÇÃO (congela o comportamento)
4. Fazer a mudança / refatorar em passos pequenos
5. Rodar os testes a cada passo (rede de segurança)
```

## Ferramentas de apoio

- **Cobertura** para ver o que os testes de caracterização já cobrem.
- **`git bisect`** e logs para entender comportamento ([[Tecnicas de Debugging]]).
- **Aproximação por logging** (Strangler): logar uso para entender o código antes de mexer.

## Quando utilizar

- Sempre que precisar **modificar** ou **corrigir bug** em código sem testes.
- Antes de qualquer refatoração relevante em legado.

## Quando NÃO (nuance)

- Código legado **estável que não vai mudar** → talvez não valha o esforço de caracterizar agora (priorize o que muda).

## Erros comuns / Anti-patterns

- Refatorar legado **sem** testes de caracterização (quebra silenciosa).
- Tentar reescrever tudo de uma vez ([[Estrategias de Modernizacao|big bang]]).
- Escrever testes de caracterização que assumem o comportamento "correto" (eles devem capturar o **atual**).
- Mexer no miolo intocável quando um **Sprout/Wrap** resolveria com menos risco.

## Boas práticas

- **Caracterização primeiro**, depois refatorar (passos pequenos, testes verdes).
- Preferir **Sprout/Wrap** para adicionar comportamento novo com segurança.
- Criar seams via injeção de dependência.
- Melhorar a cobertura das áreas que você toca (Boy Scout Rule).

## Conceitos relacionados

- [[Sistemas Legados - Fundamentos]]
- [[Estrategias de Modernizacao]]
- [[Refatoracao]] · [[Testes - Fundamentos e Piramide]]
- [[TDD - Test-Driven Development]] · [[SOLID Principles]] (DIP para seams)

## Perguntas importantes

### O que é um teste de caracterização?
Um teste que captura o **comportamento atual** do código (não o "correto"), servindo de rede de segurança para detectar regressões ao refatorar legado.

### O que é um "seam"?
Um ponto onde é possível **alterar o comportamento sem editar naquele local** — permitindo injetar um substituto/teste. Criar seams (ex.: via injeção de dependência) é o que torna o legado testável.

## Fontes

1. Feathers, M. (2004). *Working Effectively with Legacy Code* — referência canônica.
2. Wikipedia — Legacy system — https://en.wikipedia.org/wiki/Legacy_system (consultado 2026-09-03)
3. Nicolas Carlo — *Understand Legacy Code.*

## Observações

Conteúdo baseado na obra de Feathers (amplamente consolidada). Aprofundar: catálogo de técnicas de quebra de dependência. Status: verified.
