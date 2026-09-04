---
title: "Sistemas Legados - Fundamentos"
category: "30 - LEGACY SYSTEMS"
tags:
  - engenharia-software
  - legacy
  - manutencao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Sistemas Legados — Fundamentos

## Resumo

Um **sistema legado** é um sistema/tecnologia **antigo, porém ainda em uso** — muitas vezes crítico para o negócio, mas difícil de manter. **Código legado** costuma ser código **sem (ou com poucos) testes**, escrito com padrões/tecnologias ultrapassados, o que torna a mudança arriscada.

## O que é?

- **Sistema legado:** método, tecnologia ou aplicação desatualizada, ainda em operação. "Legado" pode significar tanto "pavimentou o caminho" quanto "precisa de substituição".
- **Código legado:** base de código obsoleta em algum aspecto — frameworks/libs antigas, arquitetura ultrapassada, **testes insuficientes** (o que torna [[Refatoracao|refatorar]] perigoso e propenso a bugs).
- **Definição de Michael Feathers:** *"Legacy code is simply code without tests."* (Código legado é, simplesmente, código sem testes.) — porque sem testes você não tem rede de segurança para mudá-lo.

## Por que existe?

- Software **sobrevive** muito além do previsto (dá valor ao negócio).
- **Software rot** — o entorno muda (SO, libs, hardware) e o código envelhece.
- Reescrever é caro/arriscado → o sistema segue em produção por anos/décadas.
- Rotatividade de equipe → conhecimento se perde.

## Por que é difícil trabalhar com legado?

- **Sem testes** → medo de mudar (qualquer alteração pode quebrar algo invisível).
- **Alta carga cognitiva** — padrões/tecnologias desconhecidos, código emaranhado ([[Anti-patterns de Arquitetura e Design|Big Ball of Mud]]).
- **Documentação ausente/desatualizada**; conhecimento tácito perdido.
- **Acoplamento** alto → mudanças têm efeitos em cascata.
- Dependências obsoletas (riscos de [[19 - SEGURANCA/_INDEX|segurança]]).

## Por que importa?

A maior parte do trabalho de software é **manutenção** de sistemas existentes, não greenfield. Saber lidar com legado com segurança é uma das habilidades mais valiosas — e é onde mora grande parte da [[Metricas de Qualidade e Divida Tecnica|dívida técnica]].

## Legado ≠ ruim

"Legado" não significa mal feito. Muitos sistemas legados **funcionam e geram receita** há anos. O problema é o **custo de mudança** — que se ataca com testes, refatoração e modernização incremental.

## Como abordar (visão geral)

1. **Entender antes de mudar** (ler, mapear, [[Tecnicas de Debugging|instrumentar]]).
2. **Criar rede de segurança** — testes de caracterização. Ver [[Trabalhando com Codigo Legado]].
3. **Refatorar em passos pequenos** ([[Refatoracao]]).
4. **Modernizar incrementalmente** (Strangler Fig). Ver [[Estrategias de Modernizacao]].

## Quando NÃO mexer (nuance)

- "If it ain't broke, don't fix it": código legado **estável que não muda** pode não valer o risco/custo de tocar. Priorize legado que **precisa mudar** ou que trava a evolução.

## Erros comuns / Anti-patterns

- **Big bang rewrite** do zero (ver riscos em [[Estrategias de Modernizacao]]).
- Mudar sem entender nem criar testes → quebrar o que funcionava.
- Desprezar o legado ("código ruim") em vez de respeitar o valor que entrega.
- Deixar dependências obsoletas sem atualização (segurança).

## Boas práticas

- Tratar **"código sem teste"** como o problema central → adicionar testes de caracterização.
- Boy Scout Rule: melhorar aos poucos ao passar pelo código.
- Modernização **incremental** e mensurável, não big bang.
- Documentar o que for descobrindo.

## Conceitos relacionados

- [[Trabalhando com Codigo Legado]]
- [[Estrategias de Modernizacao]]
- [[Refatoracao]] · [[Code Smells]]
- [[28 - MANUTENCAO/_INDEX|Manutenção]] · [[Metricas de Qualidade e Divida Tecnica]]

## Perguntas importantes

### O que é "código legado" segundo Michael Feathers?
**Código sem testes.** Sem uma rede de segurança de testes, qualquer mudança é arriscada — independentemente da idade do código.

### Legado significa código ruim?
Não. Significa **em uso e caro de mudar** (frequentemente por falta de testes/padrões antigos). Muitos sistemas legados são valiosos e funcionam bem.

## Fontes

1. Wikipedia — Legacy system — https://en.wikipedia.org/wiki/Legacy_system (consultado 2026-09-03)
2. Feathers, M. (2004). *Working Effectively with Legacy Code.*
3. Fowler, M. — sobre software rot / evolução.

## Observações

Status: verified. Ver técnicas concretas nas notas ligadas.
