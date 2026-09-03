---
title: "Clean Code"
category: "31 - CLEAN CODE"
tags:
  - engenharia-software
  - clean-code
  - qualidade
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Clean Code

## Resumo

**Clean Code** ("código limpo") é código **fácil de ler, entender e modificar** por outros humanos. O conceito foi popularizado por **Robert C. Martin** no livro *Clean Code: A Handbook of Agile Software Craftsmanship* (2008). Premissa central: **código é lido muito mais vezes do que é escrito** — otimize para leitura.

## O que é?

Código limpo é aquele que:
- Revela sua **intenção** (nomes e estrutura contam a história).
- Faz **uma coisa** por unidade (funções pequenas e focadas).
- Tem **baixa duplicação** ([[DRY, KISS e YAGNI|DRY]]) e baixa complexidade.
- É **testável** e coberto por testes.

> "Qualquer tolo escreve código que um computador entende. Bons programadores escrevem código que humanos entendem." — Martin Fowler.

## Por que existe?

A maior parte do custo do software está na **manutenção/leitura**, não na escrita inicial. Código difícil de entender gera bugs, retarda mudanças e acumula [[43 - ANTIPATTERNS/_INDEX|dívida técnica]].

## Como funciona? — Práticas centrais

### Nomes
- Nomes **reveladores de intenção**: `dias_desde_criacao` > `d`.
- Pronunciáveis e pesquisáveis; sem abreviações obscuras.
- Classes = substantivos; métodos = verbos.

### Funções
- **Pequenas**; fazem **uma única coisa** (SRP no nível de função).
- Poucos parâmetros (idealmente 0–2).
- Sem efeitos colaterais escondidos.
- Um nível de abstração por função.

### Comentários
- O melhor comentário é o que **não foi preciso escrever** (código autoexplicativo).
- Comente o **porquê**, não o **o quê**. Evite comentários que repetem o código ou que mentem por desatualização.

### Formatação e estrutura
- Consistência (use um formatador: Prettier, Black).
- Proximidade: código relacionado fica junto.

### Tratamento de erros
- Use exceções em vez de códigos de retorno; não engula erros silenciosamente.

## Exemplo prático

```python
# ❌ obscuro
def p(d):
    return [x for x in d if x[3] > 0 and x[7] == 1]

# ✅ limpo
def clientes_ativos_com_saldo(clientes):
    return [c for c in clientes if c.saldo > 0 and c.ativo]
```

## Quando utilizar

Praticamente **sempre** em código de produção mantido por equipe. É base para [[18 - QUALIDADE DE SOFTWARE/_INDEX|qualidade]] e velocidade sustentável.

## Quando NÃO utilizar (nuance)

- Protótipos descartáveis podem tolerar menos rigor — mas nomes claros custam quase nada.
- Não confundir "limpo" com "abstrato demais": clareza > esperteza.

## Trade-offs

- Investir em clareza **agora** custa um pouco mais, mas reduz drasticamente o custo de mudança **depois**.
- Excesso de "limpeza" (micro-funções demais) pode fragmentar a leitura — equilíbrio ([[DRY, KISS e YAGNI|KISS]]).

## Erros comuns / Anti-patterns

- Nomes genéricos (`data`, `info`, `manager`, `util`).
- Funções longas que fazem muitas coisas.
- Comentários desatualizados que mentem.
- Números mágicos e código morto.
- "Clever code" que ninguém entende.

## Boas práticas

- **Boy Scout Rule:** deixe o código mais limpo do que encontrou.
- Refatore continuamente ([[Refatoracao|Refatoração]]).
- Automatize estilo (linter + formatter) e cubra com testes.
- Revisão de código ([[46 - CHECKLISTS/Code Review Checklist|checklist]]).

## Conceitos relacionados

- [[DRY, KISS e YAGNI]]
- [[SOLID Principles]]
- [[Coesao e Acoplamento]]
- [[Refatoracao]]
- [[18 - QUALIDADE DE SOFTWARE/_INDEX|Qualidade de Software]]

## Perguntas importantes

### Clean Code é sobre estética?
Não. É sobre **custo de manutenção**: código legível reduz bugs e acelera mudanças. Estética é consequência.

### Comentários são ruins?
Não — mas o ideal é código que dispensa comentários. Quando comentar, explique **o porquê** (decisões, contexto), não o óbvio.

## Fontes

1. Martin, R. C. (2008). *Clean Code: A Handbook of Agile Software Craftsmanship.* Prentice Hall.
2. Fowler, M. — citação sobre código para humanos (Refactoring).
3. Wikipedia — Robert C. Martin — https://en.wikipedia.org/wiki/Robert_C._Martin

## Observações

Notas próprias a criar: "Nomes", "Funções", "Tratamento de erros", "Comentários". Conteúdo baseado no livro Clean Code (não fetchado nesta sessão) — amplamente consolidado. Status: verified (consenso da área).
