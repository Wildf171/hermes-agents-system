---
title: "Deadlock, Starvation e Livelock"
category: "23 - CONCORRENCIA"
tags:
  - engenharia-software
  - concorrencia
  - deadlock
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Deadlock, Starvation e Livelock

## Resumo

**Deadlock** é quando um grupo de tarefas fica travado para sempre, cada uma esperando um recurso que outra segura. **Starvation** é quando uma tarefa nunca consegue o recurso (sempre "furada" por outras). **Livelock** é quando tarefas reagem umas às outras sem progredir. São os riscos clássicos da sincronização por [[Race Conditions e Sincronizacao|locks]].

## Deadlock

Situação em que nenhum membro de um grupo pode prosseguir porque cada um espera outro liberar um recurso (lock). Comum em multiprocessamento, [[13 - SISTEMAS DISTRIBUIDOS/_INDEX|sistemas distribuídos]] e bancos.

### Exemplo
```
Thread A: lock(R1) ... quer lock(R2)
Thread B: lock(R2) ... quer lock(R1)
→ A espera R2 (com B), B espera R1 (com A) → travados para sempre
```

### As 4 condições de Coffman (todas necessárias)
Um deadlock só ocorre se **as quatro** acontecem juntas:
1. **Exclusão mútua** — recurso não compartilhável (um por vez).
2. **Hold and wait** — segura um recurso e pede outro.
3. **No preemption** — recurso não pode ser tomado à força; só liberado voluntariamente.
4. **Circular wait** — existe um ciclo de espera (A→B→...→A).

Quebrar **qualquer uma** previne o deadlock.

## Como lidar com deadlock

- **Prevenção** — negar uma das condições de Coffman. Ex.: **ordem global de aquisição** de locks (quebra circular wait); pegar todos os locks de uma vez (quebra hold-and-wait).
- **Evitação (avoidance)** — algoritmo do banqueiro (aloca só se o estado permanece seguro).
- **Detecção e recuperação** — detectar ciclo (grafo de espera) e abortar/reiniciar uma tarefa (comum em bancos: a transação vítima sofre rollback).
- **Timeouts** — desistir após esperar demais e tentar de novo.

## Starvation (inanição)

Uma tarefa **nunca** obtém o recurso porque outras têm sempre prioridade (ou "furam a fila"). Causada por escalonamento injusto ou prioridades mal definidas.
- **Solução:** políticas **justas** (FIFO, aging — aumentar prioridade com o tempo de espera).

## Livelock

Tarefas **não travam**, mas ficam **reagindo umas às outras** sem progredir (como duas pessoas se desviando no corredor no mesmo sentido, repetidamente).
- **Solução:** introduzir aleatoriedade/backoff nas tentativas.

## Deadlock em bancos de dados

SGBDs detectam deadlocks entre transações (grafo de espera) e escolhem uma **vítima** para rollback. Relaciona-se a [[Transacoes e ACID|isolamento]] e locking. Boas práticas: transações curtas, ordem consistente de acesso.

## Quando isso importa

- Qualquer sistema com **múltiplos locks/recursos** e concorrência.
- Bancos com transações concorrentes; sistemas distribuídos.

## Erros comuns / Anti-patterns

- Adquirir locks em **ordens diferentes** em pontos distintos do código (causa clássica).
- Locks aninhados sem disciplina.
- Prioridades sem aging → starvation.
- Retry sem backoff → livelock.

## Boas práticas

- **Ordem global e consistente** de aquisição de locks.
- Locks de granularidade e duração mínimas; evitar segurar lock durante I/O.
- **Timeouts** e detecção; transações curtas.
- Preferir **message passing/imutabilidade** para evitar locks. Ver [[Programacao Assincrona e Modelos de Concorrencia]].

## Conceitos relacionados

- [[Concorrencia - Fundamentos]]
- [[Race Conditions e Sincronizacao]]
- [[Transacoes e ACID]]
- [[Sistemas Operacionais - Fundamentos]]

## Perguntas importantes

### Quais são as 4 condições de Coffman?
Exclusão mútua, hold and wait, no preemption e circular wait. As quatro precisam ocorrer juntas; negar uma previne o deadlock.

### Qual a diferença entre deadlock, starvation e livelock?
**Deadlock:** todos travados esperando uns aos outros. **Starvation:** uma tarefa nunca é atendida (as outras têm prioridade). **Livelock:** tarefas mudam de estado reagindo entre si, mas sem progredir.

## Fontes

1. Wikipedia — Deadlock (computer science) — https://en.wikipedia.org/wiki/Deadlock_(computer_science) (consultado 2026-09-03)
2. Coffman, E. G. (1971) — condições de deadlock.
3. Silberschatz et al. — *Operating System Concepts.*

## Observações

Aprofundar: algoritmo do banqueiro, detecção por grafo de espera. Status: verified.
