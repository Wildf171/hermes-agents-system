---
title: "Performance - Fundamentos"
category: "21 - PERFORMANCE"
tags:
  - engenharia-software
  - performance
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Performance — Fundamentos

## Resumo

**Performance** é o quão eficientemente um sistema usa recursos para entregar resultados — medida por **latência**, **throughput** e uso de **recursos** (CPU, memória, I/O, energia). Otimização é sempre um jogo de **trade-offs** (ex.: espaço × tempo) e deve ser guiada por **medição**, não por intuição.

## O que é? — Métricas centrais

- **Latência** — tempo de uma operação (ex.: responder a 1 request). Menor é melhor.
- **Throughput** — quantidade de trabalho por unidade de tempo (ex.: requests/s). Maior é melhor.
- **Uso de recursos** — CPU, memória, disco, rede, energia.
- **Utilização / Saturação** — quão ocupado e quão além da capacidade um recurso está.

> Latência e throughput **não são a mesma coisa**: um sistema pode ter alto throughput e, ainda assim, latência ruim para requisições individuais (e vice-versa).

## Percentis > média

Médias escondem os piores casos. Use **percentis**:
- **p50 (mediana)** — experiência típica.
- **p95 / p99 / p99.9** — a "cauda" (tail latency), que afeta os usuários mais lentos.
- Em escala, a cauda domina a experiência (um request de página aciona muitos serviços; o mais lento manda).

## Por que existe (a disciplina)?

Performance é um **atributo de qualidade** ([[Arquitetura de Software - Fundamentos|NFR]]) que impacta experiência do usuário, custo (menos hardware) e escalabilidade. Mas otimizar tem custo — e retornos decrescentes.

## Princípios

### Premature optimization
> "A otimização prematura é a raiz de todo mal." — Donald Knuth.
Otimizar antes de medir desperdiça esforço e complica o código. **Meça primeiro**, otimize o gargalo real.

### Lei de Amdahl
O ganho de otimizar uma parte é limitado pela fração do tempo que essa parte representa. Acelerar 2× algo que consome 5% do tempo total quase não muda nada. **Ataque o que domina.**

### Trade-offs
- **Espaço × tempo** — mais memória (cache/índice) para menos tempo, ou vice-versa.
- Legibilidade × velocidade; custo × latência.
- Raramente há um design ótimo para tudo — **priorize** o que importa para a aplicação.

### Níveis de otimização
Níveis mais altos (arquitetura, algoritmo, estrutura de dados) têm **impacto muito maior** e são mais caros de mudar depois; micro-otimizações de código rendem pouco. Comece pelo alto nível: melhor [[Complexidade Algoritmica (Big-O)|algoritmo/estrutura]] > truque de código.

## Onde está o gargalo? (bound)

- **CPU-bound** — limitado por processamento.
- **I/O-bound** — limitado por disco/rede/banco (o mais comum em apps web).
- **Memory-bound** — limitado por memória/alocação/GC.
Identificar o tipo direciona a solução (ex.: I/O-bound → cache/async, não CPU mais rápida).

## Exemplo prático

```
Página lenta (p99 = 3s). Profiling revela: 90% do tempo é 1 query SQL sem índice.
→ Lei de Amdahl: otimizar o resto é inútil.
→ Criar índice ([[Indices e Otimizacao de Queries]]) leva p99 para 300ms.
```

## Quando otimizar

- Quando há **requisito** de performance (SLO) e **medição** mostra que não é atendido.
- No gargalo comprovado (profiling), não no que "parece" lento.

## Quando NÃO otimizar

- Antes de medir (premature optimization).
- Onde o ganho é irrelevante (parte que consome pouco tempo — Amdahl).
- Sacrificando legibilidade/corretude por ganho marginal.

## Erros comuns / Anti-patterns

- Otimizar por intuição, sem profiling.
- Focar em micro-otimizações e ignorar o algoritmo/arquitetura ([[Anti-patterns de Arquitetura e Design|Premature Optimization]]).
- Medir só a média (ignora a cauda p99).
- Confundir latência com throughput.

## Boas práticas

- **Meça** (profiling/benchmark) antes e depois — ver [[Profiling e Otimizacao]].
- Defina metas via **percentis** e SLOs ([[Observabilidade]]).
- Ataque o gargalo dominante; melhore o alto nível primeiro.
- Considere [[Cache e Redis|cache]] e [[Indices e Otimizacao de Queries|índices]] antes de reescrever tudo.

## Conceitos relacionados

- [[Profiling e Otimizacao]]
- [[Performance Web]]
- [[Complexidade Algoritmica (Big-O)]]
- [[Cache e Redis]] · [[Indices e Otimizacao de Queries]]
- [[22 - ESCALABILIDADE/_INDEX|Escalabilidade]] · [[Observabilidade]]

## Perguntas importantes

### Qual a diferença entre latência e throughput?
Latência é o tempo de **uma** operação; throughput é **quantas** operações por segundo. São dimensões diferentes — otimizar uma não garante a outra.

### Por que usar p99 em vez de média?
A média esconde os piores casos. O p99 mostra a experiência dos 1% mais lentos, que em escala afeta muitos usuários (tail latency).

## Fontes

1. Wikipedia — Program optimization — https://en.wikipedia.org/wiki/Program_optimization (consultado 2026-09-03)
2. Knuth, D. — origem de "premature optimization is the root of all evil".
3. Amdahl, G. (1967) — Lei de Amdahl.
4. Gregg, B. — *Systems Performance* (método USE).

## Observações

Aprofundar: método USE/RED, tail latency, GC tuning. Status: verified.
