---
title: "Sistemas Operacionais - Fundamentos"
category: "25 - SISTEMAS OPERACIONAIS"
tags:
  - engenharia-software
  - sistemas-operacionais
  - infraestrutura
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Sistemas Operacionais — Fundamentos

## Resumo

Um **Sistema Operacional (SO)** é o software de sistema que **gerencia hardware e recursos de software** e oferece serviços comuns aos programas. Atua como **intermediário** entre aplicações e hardware. O componente sempre em execução é o **kernel**.

## O que é?

Camada de software que administra os recursos do computador para usuários e aplicações. Principais responsabilidades:
- **Gerência de processos** — criação, escalonamento (scheduling), concorrência.
- **Gerência de memória** — alocação, memória virtual, paginação.
- **Sistema de arquivos** — organização e acesso a dados persistentes.
- **Device drivers / I/O** — comunicação com dispositivos.
- **Rede** e **segurança** (permissões, isolamento).

Aplicações usam o SO via **system calls** (chamadas de sistema) — a fronteira entre o *user space* e o *kernel space*.

## Por que existe?

Sem SO, cada programa teria de falar diretamente com o hardware. O SO **abstrai o hardware**, compartilha recursos entre vários programas com segurança e isolamento, e evita que um processo interfira em outro.

## Como funciona? — Conceitos centrais

### Processos e Threads
- **Processo** — programa em execução, com espaço de memória próprio.
- **Thread** — linha de execução dentro de um processo (compartilha memória).
- **Scheduler** — decide qual processo/thread roda em cada CPU (preempção, prioridades). Ver [[23 - CONCORRENCIA/_INDEX|Concorrência]].

### Memória
- **Memória virtual** — cada processo "vê" um espaço de endereços próprio.
- **Paginação** — memória dividida em páginas; troca com disco (swap).

### Kernel: monolítico vs microkernel
- **Monolítico** (Linux) — serviços no mesmo espaço do kernel (rápido).
- **Microkernel** — mínimo no kernel, serviços em user space (mais isolado).

### Linux
Domina servidores, cloud e supercomputação; base de containers ([[Docker - Fundamentals|Docker]] usa recursos do kernel Linux: namespaces e cgroups).

## Conceitos fundamentais

- **User space vs Kernel space** — isolamento de privilégios.
- **System call** — interface de serviços do kernel (`read`, `write`, `fork`).
- **Interrupções** — hardware sinaliza o CPU.
- **Namespaces e cgroups** (Linux) — isolamento e limite de recursos (base de containers).

## Exemplo prático

```bash
# Linux: inspecionar processos e recursos
ps aux            # processos em execução
top / htop        # uso de CPU/memória em tempo real
free -h           # memória
df -h             # disco (filesystem)
strace ls         # observa as system calls que um comando faz
```

## Quando importa para o dev

- Diagnosticar performance (CPU, memória, I/O, ver [[21 - PERFORMANCE/_INDEX|Performance]]).
- Entender containers ([[Docker - Fundamentals|Docker]]/[[Kubernetes]]) — são recursos do SO.
- Concorrência, limites de arquivos/portas, permissões.

## Erros comuns

- Ignorar limites do SO (file descriptors, memória) em produção.
- Confundir processo com thread ao raciocinar sobre concorrência.
- Assumir comportamento igual entre Windows/Linux (paths, sinais, permissões).

## Boas práticas

- Conhecer as ferramentas de diagnóstico do SO (top, strace, journalctl).
- Rodar produção em Linux quando possível (ecossistema cloud/containers).
- Definir limites (cgroups) para processos em produção.

## Conceitos relacionados

- [[23 - CONCORRENCIA/_INDEX|Concorrência]]
- [[Docker - Fundamentals]] (namespaces/cgroups)
- [[24 - REDES/_INDEX|Redes]]
- [[21 - PERFORMANCE/_INDEX|Performance]]

## Perguntas importantes

### O que é o kernel?
O núcleo do SO, sempre em execução, que gerencia recursos e media o acesso ao hardware via system calls.

### Qual a diferença entre processo e thread?
Processo tem espaço de memória próprio; threads vivem dentro de um processo e compartilham memória — mais leves, porém exigem cuidado com concorrência.

## Fontes

1. Wikipedia — Operating system — https://en.wikipedia.org/wiki/Operating_system (consultado 2026-09-03)
2. Tanenbaum, A. — *Modern Operating Systems.*
3. Silberschatz, Galvin, Gagne — *Operating System Concepts.*

## Observações

Aprofundar: escalonamento, memória virtual, namespaces/cgroups em notas próprias. Status: verified.
