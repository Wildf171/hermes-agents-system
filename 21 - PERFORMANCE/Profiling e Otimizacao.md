---
title: "Profiling e Otimização"
category: "21 - PERFORMANCE"
tags:
  - engenharia-software
  - performance
  - profiling
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Profiling e Otimização

## Resumo

**Profiling** é medir onde um programa gasta tempo e recursos, para **encontrar o gargalo real** antes de otimizar. O ciclo correto é **medir → identificar o gargalo → otimizar → medir de novo**. Sem medir, otimização é chute (e geralmente ataca a parte errada — [[Performance - Fundamentos|Lei de Amdahl]]).

## O que é?

- **Profiler** — ferramenta que instrumenta/amostra a execução e reporta o consumo por função/linha (CPU, alocações, chamadas).
- **Benchmark** — medição controlada e repetível do desempenho de um trecho.
- **Tracing** — segue uma operação através de componentes/serviços ([[Observabilidade|observabilidade]]/tracing distribuído).

## Por que existe?

Intuição sobre performance costuma estar **errada**. Profiling revela o gargalo verdadeiro, que raramente é onde se imagina — evitando otimizar código irrelevante.

## Como funciona? — Tipos de profiling

- **Sampling** — amostra a pilha em intervalos (baixo overhead; bom para produção).
- **Instrumentation** — insere medições em cada função (preciso, mas mais lento).
- **Memory profiling** — alocações, vazamentos, pressão de GC.
- **Flame graph** — visualização de onde o tempo é gasto na pilha de chamadas (Brendan Gregg).

## Ciclo de otimização

```
1. Definir meta (SLO/percentil) e um benchmark reproduzível
2. Profiling -> achar o gargalo dominante (CPU/IO/memory-bound?)
3. Otimizar SÓ o gargalo
4. Medir de novo (confirmar ganho, sem regressão)
5. Repetir até atingir a meta (parar nos retornos decrescentes)
```

## Estratégias comuns de otimização

### Banco de dados (gargalo mais comum em apps web)
- Eliminar **N+1 queries**; usar JOIN/batch.
- Criar **índices** adequados; ler o plano com EXPLAIN. Ver [[Indices e Otimizacao de Queries]].
- **Cache** de resultados quentes ([[Cache e Redis]]).
- Paginação; buscar só colunas necessárias.

### Aplicação
- Melhor **algoritmo/estrutura de dados** ([[Complexidade Algoritmica (Big-O)|Big-O]]) — maior alavanca.
- **Async/concorrência** para I/O-bound ([[23 - CONCORRENCIA/_INDEX|Concorrência]]).
- Reduzir alocações; reuso/pooling; lazy loading.
- Memoização/cache de cálculos caros.

### Rede/sistema
- Menos round-trips; compressão; connection pooling; CDN ([[Performance Web]]).

## Exemplo prático (Python)

```python
import cProfile
cProfile.run("processar_pedidos()")   # mostra tempo por função

# Benchmark simples
import timeit
timeit.timeit("f()", globals=globals(), number=1000)
```
Ache a função no topo do profile → otimize-a → rode o benchmark de novo.

## Quando utilizar

- Sempre que houver **problema de performance medido** (SLO não atendido).
- Antes de qualquer otimização não trivial.

## Quando NÃO utilizar (nuance)

- Não faça profiling/otimização sem uma **meta** e um caso representativo (dados/carga reais).
- Micro-benchmarks podem enganar (JIT, cache de CPU) — meça em condições realistas.

## Erros comuns / Anti-patterns

- Otimizar sem profiling (ataca a parte errada).
- Otimizar em ambiente/dados não representativos.
- Micro-benchmark enganoso; medir só a média.
- Otimização que quebra legibilidade por ganho marginal.

## Boas práticas

- **Meça antes e depois**; guarde números.
- Profiling em condições realistas (dados/carga de produção quando possível).
- Ataque o gargalo dominante; comece pelo alto nível (algoritmo/DB).
- Automatize benchmarks de regressão em [[CI-CD - Integracao e Entrega Continua|CI]] para o que é crítico.

## Conceitos relacionados

- [[Performance - Fundamentos]]
- [[Performance Web]]
- [[Indices e Otimizacao de Queries]] · [[Cache e Redis]]
- [[Complexidade Algoritmica (Big-O)]]
- [[Observabilidade]]

## Perguntas importantes

### Por onde começo a otimizar?
Pelo **profiling**: encontre o gargalo dominante. Otimizar sem medir quase sempre ataca a parte errada.

### Sampling ou instrumentation?
**Sampling** tem baixo overhead (ok em produção); **instrumentation** é mais preciso, porém mais lento. Use sampling para descobrir o gargalo, instrumentation para detalhar.

## Fontes

1. Wikipedia — Program optimization — https://en.wikipedia.org/wiki/Program_optimization (consultado 2026-09-03)
2. Gregg, B. — *Systems Performance* e flame graphs — https://www.brendangregg.com
3. Documentações de profilers (cProfile, perf, async-profiler).

## Observações

Aprofundar: flame graphs, load testing (k6/JMeter), APM. Status: verified.
