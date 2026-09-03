---
title: "Concorrência - Fundamentos"
category: "23 - CONCORRENCIA"
tags:
  - engenharia-software
  - concorrencia
  - paralelismo
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Concorrência — Fundamentos

## Resumo

**Concorrência** é a capacidade de um sistema **lidar com múltiplas tarefas** ao mesmo tempo — por execução simultânea ou por **time-sharing** (troca de contexto). Melhora responsividade, throughput e escalabilidade. **Não é sinônimo de paralelismo**: um programa pode ter concorrência sem paralelismo e vice-versa.

## Concorrência vs Paralelismo

- **Concorrência** — *lidar* com muitas tarefas (estrutura do programa: múltiplas linhas de controle que podem intercalar).
- **Paralelismo** — *executar* várias tarefas ao mesmo tempo em **múltiplos núcleos** de CPU.

> Rob Pike: "Concorrência é sobre **lidar** com muitas coisas ao mesmo tempo; paralelismo é sobre **fazer** muitas coisas ao mesmo tempo." Um programa pode exibir só concorrência, só paralelismo, ambos ou nenhum.

Exemplo: um único núcleo alternando entre tarefas (time-slicing) é **concorrente, não paralelo**. Vários núcleos rodando tarefas de fato ao mesmo tempo é **paralelo**.

## Unidades de execução

- **Processo** — programa em execução com **espaço de memória próprio** (isolado). Comunicação via IPC.
- **Thread** — linha de execução **dentro de um processo**, compartilha memória com outras threads (leve, mas exige sincronização). Ver [[Sistemas Operacionais - Fundamentos]].
- **Coroutine / Task** — unidade leve cooperativa (async), gerenciada pelo runtime, não pelo SO.

## Por que existe?

- **Responsividade** — não travar enquanto espera I/O.
- **Throughput** — processar mais em paralelo (multi-core).
- **Aproveitar hardware** — CPUs modernas têm muitos núcleos.
- **Escala** — atender muitos usuários/requisições simultâneas.

## O grande desafio: estado compartilhado

Quando tarefas concorrentes acessam **dados compartilhados**, o número de intercalações possíveis explode e o resultado pode ser **indeterminado** → [[Race Conditions e Sincronizacao|race conditions]], [[Deadlock, Starvation e Livelock|deadlocks]] e starvation. Coordenar esse acesso é o cerne da programação concorrente.

## Modelos de concorrência (visão geral)

- **Memória compartilhada + locks** — threads compartilham dados, protegidos por sincronização (clássico; propenso a bugs). Ver [[Race Conditions e Sincronizacao]].
- **Message passing** — tarefas não compartilham memória; comunicam por mensagens (mais seguro). Ex.: **Actor model** (Erlang/Akka), **CSP** (Go channels). Ver [[Programacao Assincrona e Modelos de Concorrencia]].
- **Async / event loop** — concorrência cooperativa single-thread para I/O (Node.js, async Python).

## Exemplo prático

```python
# I/O-bound: concorrência com async (1 thread, intercala esperas)
import asyncio
async def baixar(url): await http_get(url)
await asyncio.gather(baixar(a), baixar(b), baixar(c))  # concorrente

# CPU-bound: precisa de paralelismo real (múltiplos processos)
from multiprocessing import Pool
with Pool() as p: p.map(calculo_pesado, dados)
```

## Quando usar concorrência

- **I/O-bound** (rede, disco, banco) → async/threads: enorme ganho de throughput.
- **CPU-bound** → paralelismo real (multiprocessing/múltiplos núcleos).
- Servidores que atendem muitas requisições simultâneas.

## Quando NÃO usar (ou com cautela)

- Se a tarefa é simples e sequencial, concorrência só adiciona complexidade e bugs.
- CPU-bound com threads em runtimes com **GIL** (Python) não paraleliza — use processos. Ver [[Programacao Assincrona e Modelos de Concorrencia]].

## Trade-offs

- **Ganha:** responsividade, throughput, uso de multi-core.
- **Perde:** complexidade alta, bugs difíceis (não determinísticos), depuração árdua.

## Erros comuns / Anti-patterns

- Compartilhar estado mutável sem sincronização (race conditions).
- Usar threads para CPU-bound sob GIL (sem ganho).
- Concorrência prematura onde sequencial bastaria.

## Boas práticas

- **Prefira não compartilhar estado** (imutabilidade, message passing).
- Escolher o modelo pelo tipo de carga (I/O → async; CPU → paralelo).
- Isolar e minimizar seções críticas.

## Conceitos relacionados

- [[Race Conditions e Sincronizacao]]
- [[Deadlock, Starvation e Livelock]]
- [[Programacao Assincrona e Modelos de Concorrencia]]
- [[Sistemas Operacionais - Fundamentos]]
- [[21 - PERFORMANCE/_INDEX|Performance]]

## Perguntas importantes

### Concorrência é o mesmo que paralelismo?
Não. Concorrência é **lidar** com várias tarefas (podem intercalar em um núcleo); paralelismo é **executá-las de fato ao mesmo tempo** em múltiplos núcleos.

### Processo ou thread?
Processos são isolados (mais seguros, mais pesados, comunicação por IPC); threads compartilham memória (leves, mas exigem sincronização).

## Fontes

1. Wikipedia — Concurrency (computer science) — https://en.wikipedia.org/wiki/Concurrency_(computer_science) (consultado 2026-09-03)
2. Rob Pike — "Concurrency Is Not Parallelism" (2012).
3. Tanenbaum — *Modern Operating Systems.*

## Observações

Aprofundar: memória compartilhada vs message passing, escalonamento. Status: verified.
