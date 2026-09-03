---
title: "Refatoração"
category: "29 - REFATORACAO"
tags:
  - engenharia-software
  - refatoracao
  - qualidade
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Refatoração

## Resumo

**Refatoração** é reestruturar código-fonte existente **sem alterar seu comportamento externo**, para melhorar design, legibilidade e manutenibilidade. Popularizada por **Martin Fowler** no livro *Refactoring: Improving the Design of Existing Code* (1999; 2ª ed. 2018). É motivada por **code smells** e sustentada por **testes automatizados**.

## O que é?

Mudança que **preserva o comportamento** e melhora atributos não funcionais (legibilidade, complexidade, extensibilidade). Aplica-se como uma série de **micro-refatorações** — pequenas transformações seguras (renomear, extrair função, mover método). IDEs automatizam muitas delas.

> Não confundir com **rewrite** (reescrita) nem com **corrigir bug/adicionar feature**: refatorar não muda o que o software faz.

## Por que existe?

Software evolui e acumula complexidade. Sem melhorar o design continuamente, fica cada vez mais caro mudar. Refatorar mantém o código **fácil de trabalhar** e pode revelar bugs ocultos ao simplificar a lógica.

## Como funciona?

### Gatilho: Code Smells
Sinais de que algo pode ser melhorado (Fowler & Beck):
- **Long Method** — função longa demais.
- **Large Class / God Object** — classe que faz demais.
- **Duplicated Code** — viola [[DRY, KISS e YAGNI|DRY]].
- **Long Parameter List**.
- **Feature Envy** — método que usa mais dados de outra classe.
- **Shotgun Surgery** — uma mudança exige tocar em muitos lugares (alto [[Coesao e Acoplamento|acoplamento]]).
- **Primitive Obsession**, **Data Clumps**, **Comments** (comentando código ruim em vez de melhorá-lo).

### Refatorações comuns
- **Extract Function/Method** — extrair trecho para função nomeada.
- **Rename** — nomes reveladores.
- **Inline** — remover indireção desnecessária.
- **Extract Class** / **Move Method** — redistribuir responsabilidades.
- **Replace Conditional with Polymorphism** — troca `if/switch` por [[08 - DESIGN PATTERNS/Design Patterns - Introduction|polimorfismo]].
- **Introduce Parameter Object** — agrupar parâmetros.

### Segurança: rede de testes
Refatorar **exige testes** que garantam que o comportamento não mudou. Sem eles, o risco de introduzir bugs é alto. Combina com [[TDD - Test-Driven Development|TDD]] (etapa "refactor") e [[Testes - Fundamentos e Piramide|testes]].

## Exemplo prático — Extract Function

```python
# Antes
def imprimir_fatura(fatura):
    total = 0
    for item in fatura.itens:
        total += item.preco * item.qtd
    print(f"Total: {total}")

# Depois (Extract Function + nome revelador)
def calcular_total(itens):
    return sum(i.preco * i.qtd for i in itens)

def imprimir_fatura(fatura):
    print(f"Total: {calcular_total(fatura.itens)}")
```

## Quando utilizar

- Ao notar um **code smell** enquanto trabalha (Boy Scout Rule).
- **Antes** de adicionar uma feature difícil ("primeiro torne a mudança fácil, depois faça a mudança fácil" — Kent Beck).
- Continuamente, em passos pequenos.

## Quando NÃO utilizar

- Sem cobertura de testes adequada (crie testes de caracterização primeiro — ver [[30 - LEGACY SYSTEMS/_INDEX|legacy]]).
- Perto de um deadline crítico sem testes; ou quando o certo é **reescrever** (código irrecuperável).
- "Refatorar" e mudar comportamento ao mesmo tempo (misturar os dois é fonte de bugs).

## Trade-offs

- Investe tempo agora para reduzir custo de mudança futuro.
- Refatoração sem disciplina/testes pode introduzir regressões.

## Erros comuns / Anti-patterns

- Refatorar sem testes → quebra silenciosa.
- Misturar refatoração com nova feature no mesmo commit (dificulta revisão).
- "Big bang refactor" em vez de passos pequenos e commits frequentes.
- Refatorar por estética sem valor de manutenção real.

## Boas práticas

- Passos pequenos, testes verdes entre cada passo.
- Commits separados: refatoração ≠ mudança de comportamento.
- Usar ferramentas automáticas do IDE.
- Guiar-se por code smells e por [[SOLID Principles|SOLID]] / [[Coesao e Acoplamento|coesão-acoplamento]].

## Conceitos relacionados

- [[Clean Code]]
- [[TDD - Test-Driven Development]]
- [[Testes - Fundamentos e Piramide]]
- [[SOLID Principles]]
- [[43 - ANTIPATTERNS/_INDEX|Anti-patterns]] (code smells)
- [[30 - LEGACY SYSTEMS/_INDEX|Legacy Systems]]

## Perguntas importantes

### Refatorar muda o comportamento do software?
Não. Por definição, refatoração **preserva o comportamento externo**; muda apenas a estrutura interna.

### Posso refatorar sem testes?
É arriscado. Testes (ou testes de caracterização em código legado) são a rede de segurança que garante que o comportamento não mudou.

## Fontes

1. Wikipedia — Code refactoring — https://en.wikipedia.org/wiki/Code_refactoring (consultado 2026-09-03)
2. Fowler, M. (2018). *Refactoring: Improving the Design of Existing Code*, 2ª ed. Addison-Wesley.
3. Kerievsky, J. *Refactoring to Patterns* (citado na fonte 1).

## Observações

Criar catálogo de code smells e de refatorações individuais como notas próprias. Status: verified (definição e motivação confirmadas).
