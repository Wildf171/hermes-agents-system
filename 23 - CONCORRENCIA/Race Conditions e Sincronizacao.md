---
title: "Race Conditions e Sincronização"
category: "23 - CONCORRENCIA"
tags:
  - engenharia-software
  - concorrencia
  - sincronizacao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Race Conditions e Sincronização

## Resumo

Uma **race condition** (condição de corrida) ocorre quando o comportamento do sistema depende da **ordem ou do timing** de eventos incontroláveis, gerando resultados **inconsistentes** — vira bug quando esse resultado é indesejado. A **exclusão mútua** (mutex/locks) e outras primitivas de **sincronização** previnem race conditions no acesso a estado compartilhado.

## O que é uma race condition?

Quando duas ou mais tarefas acessam um recurso compartilhado e o resultado final **depende de quem chega primeiro**. O termo já era usado em 1954 (tese de David Huffman sobre circuitos sequenciais). Em software concorrente, surge no acesso não coordenado a dados compartilhados.

### Exemplo clássico (perda de atualização)
```python
# saldo = 100; duas threads executam saldo += 50 "ao mesmo tempo"
# 1) lê saldo (100)   2) lê saldo (100)
# 1) escreve 150      2) escreve 150   ← deveria ser 200!
```
A operação `+=` **não é atômica** (ler-modificar-escrever); a intercalação corrompe o resultado.

## Seção crítica

Trecho de código que acessa o recurso compartilhado e **não pode** ser executado por mais de uma tarefa ao mesmo tempo. A solução é garantir **exclusão mútua** nessa seção.

## Primitivas de sincronização

- **Mutex (lock)** — apenas uma tarefa detém o lock por vez; as demais esperam. Protege a seção crítica.
- **Semáforo** — contador que permite até N acessos simultâneos (mutex é um semáforo binário).
- **Operações atômicas** — instruções indivisíveis (ex.: compare-and-swap) para contadores sem lock.
- **Read-Write Lock** — vários leitores **ou** um escritor.
- **Condition Variable** — espera/sinaliza uma condição (ex.: fila cheia/vazia).
- **Barrier** — todas as threads esperam até todas chegarem.

## Exemplo com lock

```python
import threading
lock = threading.Lock()
saldo = 100
def depositar(v):
    global saldo
    with lock:            # seção crítica protegida
        saldo += v        # agora atômico em relação a outras threads
```

## Alternativas ao compartilhamento (muitas vezes melhores)

- **Imutabilidade** — dados imutáveis não têm race condition ([[Paradigmas de Programacao|funcional]]).
- **Message passing** — não compartilhe memória; comunique por mensagens ([[Programacao Assincrona e Modelos de Concorrencia|Actor/CSP]]).
- **Confinamento** — cada dado pertence a uma única thread.

## Quando utilizar sincronização

- Sempre que **estado mutável compartilhado** for acessado por mais de uma tarefa concorrente.

## Quando NÃO (evitar o problema)

- Se você **não compartilha estado mutável** (imutabilidade/message passing), não precisa de locks — e evita a classe inteira de bugs. Prefira isso quando possível.

## Trade-offs

- Locks garantem correção, mas **serializam** o acesso (reduzem paralelismo) e podem causar [[Deadlock, Starvation e Livelock|deadlock]].
- Lock-free (atômicos) é rápido, porém difícil de acertar.

## Erros comuns / Anti-patterns

- Assumir que operações como `x += 1` são atômicas (não são).
- Esquecer de proteger **todos** os acessos ao recurso.
- Locks grandes demais (matam concorrência) ou de menos (race).
- Ordem inconsistente de aquisição de locks → [[Deadlock, Starvation e Livelock|deadlock]].
- **Heisenbugs** — bugs que somem ao depurar (timing-dependent).

## Boas práticas

- Minimizar seções críticas; um lock por recurso, ordem consistente.
- Preferir **imutabilidade** e **message passing** a locks.
- Usar estruturas thread-safe/concorrentes da biblioteca.
- Ferramentas: **thread/race detectors** (ThreadSanitizer, `go test -race`).

## Conceitos relacionados

- [[Concorrencia - Fundamentos]]
- [[Deadlock, Starvation e Livelock]]
- [[Programacao Assincrona e Modelos de Concorrencia]]
- [[Transacoes e ACID]] (isolamento é o análogo em bancos)

## Perguntas importantes

### O que causa uma race condition?
Acesso concorrente a **estado mutável compartilhado** sem sincronização, onde o resultado depende do timing/ordem das operações.

### Como preveni-la?
Exclusão mútua (mutex/locks), operações atômicas — ou, melhor, **evitar compartilhar estado mutável** (imutabilidade, message passing).

## Fontes

1. Wikipedia — Race condition — https://en.wikipedia.org/wiki/Race_condition (consultado 2026-09-03)
2. Wikipedia — Concurrency (computer science) — https://en.wikipedia.org/wiki/Concurrency_(computer_science)
3. Herlihy & Shavit — *The Art of Multiprocessor Programming.*

## Observações

Aprofundar: memory model, lock-free/CAS, ThreadSanitizer. Status: verified.
