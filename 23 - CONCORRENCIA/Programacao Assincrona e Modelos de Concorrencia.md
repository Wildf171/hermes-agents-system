---
title: "Programação Assíncrona e Modelos de Concorrência"
category: "23 - CONCORRENCIA"
tags:
  - engenharia-software
  - concorrencia
  - async
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Programação Assíncrona e Modelos de Concorrência

## Resumo

Além de threads com [[Race Conditions e Sincronizacao|locks]], existem modelos que tornam a concorrência mais segura e escalável: **programação assíncrona** (event loop, async/await) para I/O, e modelos de **message passing** (**Actor**, **CSP**) que evitam estado compartilhado. Escolher o modelo certo depende de a carga ser **I/O-bound** ou **CPU-bound**.

## Programação Assíncrona (async/await)

Concorrência **cooperativa** em (geralmente) **uma única thread**: em vez de bloquear esperando I/O, a tarefa "cede" o controle e o **event loop** executa outra enquanto isso.

```python
import asyncio
async def buscar(url):
    return await http_get(url)      # cede o controle durante a espera de I/O

async def main():
    # 3 downloads concorrentes em 1 thread (intercalando as esperas)
    await asyncio.gather(buscar(a), buscar(b), buscar(c))
```

- **Event loop** — laço que despacha tarefas prontas (Node.js, asyncio, navegadores).
- **Future/Promise** — representa um resultado que estará disponível depois.
- Ótimo para **I/O-bound** (muitas esperas); **não** acelera CPU-bound (é 1 thread).

## I/O-bound vs CPU-bound (decisão-chave)

| Carga | Melhor abordagem |
|---|---|
| **I/O-bound** (rede, disco, DB) | **async** ou threads — enorme ganho de throughput |
| **CPU-bound** (cálculo) | **paralelismo real** — múltiplos processos/núcleos |

### O caso do GIL (Python)
O **GIL** (Global Interpreter Lock) do CPython permite só uma thread executando bytecode por vez → **threads não paralelizam CPU** em Python. Para CPU-bound use **multiprocessing**; para I/O-bound, threads/async funcionam bem. (Java, Go, Rust, C# não têm GIL.)

## Modelos de Concorrência

### Memória compartilhada + locks
Threads compartilham dados protegidos por sincronização. Poderoso, mas propenso a [[Race Conditions e Sincronizacao|races]] e [[Deadlock, Starvation e Livelock|deadlocks]].

### Actor Model
Unidades ("atores") **não compartilham memória**; comunicam-se **só por mensagens** assíncronas; cada ator processa uma mensagem por vez (estado privado). Ex.: **Erlang/Elixir**, **Akka**. Excelente para sistemas distribuídos e tolerantes a falha.

### CSP (Communicating Sequential Processes)
Processos independentes se comunicam por **canais** (channels). Ex.: **Go** (`goroutines` + `channels`).
```go
ch := make(chan int)
go func() { ch <- calcular() }()   // goroutine envia pelo canal
resultado := <-ch                  // recebe (sincroniza sem lock explícito)
```
Lema do Go: *"Não se comuniquem compartilhando memória; compartilhem memória se comunicando."*

## Quando usar cada um

- **Async/event loop:** servidores I/O-bound, alta concorrência de rede (APIs, web).
- **Threads + locks:** paralelismo com estado compartilhado (linguagens sem GIL), quando necessário.
- **Multiprocessing:** CPU-bound (cálculo pesado, especialmente em Python).
- **Actor/CSP:** sistemas concorrentes/distribuídos onde evitar estado compartilhado reduz bugs.

## Quando NÃO usar

- Async para trabalho **CPU-bound** (bloqueia o event loop — trave!). Descarregue para processos/workers.
- Threads para CPU-bound sob GIL (sem ganho).

## Trade-offs

- Async: altíssima concorrência de I/O com pouca memória, mas código "colorido" (async/await se propaga) e cuidado para não bloquear o loop.
- Actor/CSP: seguro e escalável, mas muda o modelo mental; overhead de mensagens.

## Erros comuns / Anti-patterns

- **Bloquear o event loop** com trabalho síncrono/CPU pesado.
- Misturar código bloqueante em contexto async.
- Usar threads para CPU-bound em Python (GIL).
- Compartilhar estado mutável entre goroutines/atores por engano.

## Boas práticas

- Escolher pelo tipo de carga (I/O → async; CPU → processos).
- Não bloquear o event loop; usar executors/workers para trabalho pesado.
- Preferir **message passing/imutabilidade** a locks quando possível.

## Conceitos relacionados

- [[Concorrencia - Fundamentos]]
- [[Race Conditions e Sincronizacao]]
- [[Deadlock, Starvation e Livelock]]
- [[Paradigmas de Programacao]]
- [[21 - PERFORMANCE/_INDEX|Performance]]

## Perguntas importantes

### Async serve para tarefas pesadas de CPU?
Não. Async brilha em **I/O-bound**. Trabalho CPU-bound bloqueia o event loop; use **paralelismo real** (múltiplos processos/núcleos).

### O que é o GIL do Python?
Um lock global que permite uma thread executando bytecode por vez, impedindo paralelismo de CPU com threads. Para CPU-bound em Python, use multiprocessing.

### Qual a ideia do Actor/CSP?
Evitar estado compartilhado: comunicar por **mensagens/canais** em vez de locks — reduz races e deadlocks.

## Fontes

1. Wikipedia — Concurrency (computer science) — https://en.wikipedia.org/wiki/Concurrency_(computer_science) (consultado 2026-09-03)
2. Hoare, C.A.R. (1978) — *Communicating Sequential Processes* (CSP).
3. Hewitt et al. — Actor model; Documentação Go (channels), Python asyncio.

## Observações

Aprofundar: event loop interno, backpressure em streams, structured concurrency. Status: verified.
