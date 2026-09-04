---
title: "Técnicas de Debugging"
category: "42 - TROUBLESHOOTING"
tags:
  - engenharia-software
  - troubleshooting
  - debugging
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Técnicas de Debugging

## Resumo

**Debugging** é o processo de encontrar a **causa-raiz** de um bug e sua correção. As táticas incluem **debugger interativo**, **análise de logs**, **bisection**, **rubber duck**, **profiling** e **memory dumps**. O termo remonta ao "bug" (mariposa) registrado por **Grace Hopper** no Mark II (1947).

## O que é?

Aplicar o [[Troubleshooting - Metodo e Fundamentos|método sistemático]] com ferramentas concretas para localizar e corrigir defeitos.

## Técnicas essenciais

### 1. Debugger interativo (breakpoints)
Pausar a execução e **inspecionar estado** (variáveis, pilha, fluxo) passo a passo.
- **Breakpoints** (inclusive condicionais), **step over/into/out**, **watch**.
- Ferramentas: debugger da IDE (VS Code, JetBrains), `pdb` (Python), `gdb`, DevTools do browser.

### 2. Análise de logs
Adicionar/ler **logs estruturados** para ver o caminho e o estado ao longo do tempo — essencial em produção (onde não dá para anexar debugger). Ver [[Observabilidade]].

### 3. Print debugging
"Printar" valores em pontos-chave. Simples e universal; menos poderoso que um debugger, mas útil (especialmente em concorrência/produção). Não deixe os prints no código.

### 4. Bisection (bisseção)
Dividir o espaço do problema ao meio repetidamente para localizar a causa em passos logarítmicos.
- **`git bisect`** — encontra o commit que introduziu o bug (busca binária no histórico).
- Comentar/desabilitar metade do código; ver se o bug persiste.

### 5. Rubber Duck Debugging
Explicar o código **linha a linha em voz alta** (para um "patinho de borracha"). Verbalizar força você a examinar suposições — muitas vezes o bug aparece sozinho.

### 6. Profiling e memory dumps
Para bugs de **performance/memória**: [[Profiling e Otimizacao|profiler]] (onde gasta tempo), heap dumps (vazamentos), análise de alocação. Ver [[21 - PERFORMANCE/_INDEX]].

### 7. Análise de fluxo de controle e estático
Ferramentas de [[Analise Estatica de Codigo|análise estática]] apontam bugs prováveis sem executar.

### 8. Diferencial ("what changed?")
Comparar com uma versão que funciona: diff de código, config, dados, ambiente. `git diff`, comparar ambientes.

## Táticas para bugs difíceis

- **Heisenbug** (some ao observar) → geralmente concorrência/timing; use logs, thread sanitizers, reduzir concorrência.
- **Intermitente** → identificar o gatilho (dados, timing, ordem); aumentar observabilidade.
- **"Funciona na minha máquina"** → diferenças de ambiente (versões, config, dados) → containers/paridade dev-prod.
- **Bug em produção não reproduzível localmente** → logs/tracing, feature flags, reproduzir com dados reais anonimizados.

## Exemplo (git bisect)

```bash
git bisect start
git bisect bad            # commit atual tem o bug
git bisect good v1.2.0    # esta versão era boa
# git checa commits no meio; você marca good/bad
# → git aponta o commit exato que introduziu o bug
git bisect reset
```

## Quando usar cada técnica

- Estado complexo/lógica → **debugger**.
- Produção → **logs/observabilidade**.
- "Quando quebrou?" → **git bisect**.
- Entender o próprio raciocínio → **rubber duck**.
- Lento/memória → **profiling/dumps**.

## Erros comuns / Anti-patterns

- **Shotgun debugging** (mudar tudo ao acaso).
- Depender só de `print` onde um debugger resolveria em minutos.
- Não remover logs/prints de debug depois.
- Ignorar o stack trace / a mensagem de erro.
- "Consertar" sem entender por que funciona.

## Boas práticas

- Reproduzir primeiro; **uma hipótese por vez** ([[Troubleshooting - Metodo e Fundamentos]]).
- Escolher a ferramenta certa (debugger vs logs vs bisect).
- Após corrigir: **teste de regressão** que reproduz o bug.
- Bom logging/observabilidade **antes** do incidente.

## Conceitos relacionados

- [[Troubleshooting - Metodo e Fundamentos]]
- [[Diagnostico em Producao e Postmortems]]
- [[Observabilidade]] · [[Profiling e Otimizacao]]
- [[Git - Fundamentos]] (git bisect) · [[Testes - Fundamentos e Piramide]]

## Perguntas importantes

### O que é rubber duck debugging?
Explicar o código em voz alta (a um "patinho"). Verbalizar o fluxo expõe suposições erradas — o bug frequentemente aparece durante a explicação.

### Como achar qual commit introduziu um bug?
**`git bisect`** — busca binária no histórico: você marca commits como good/bad e o Git isola o commit culpado em passos logarítmicos.

## Fontes

1. Wikipedia — Debugging — https://en.wikipedia.org/wiki/Debugging (consultado 2026-09-03)
2. Agans, D. — *Debugging: The 9 Indispensable Rules.*
3. Documentação Git — git bisect — https://git-scm.com/docs/git-bisect

## Observações

Aprofundar: debugging de concorrência, remote debugging, time-travel debugging. Status: verified.
