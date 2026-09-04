---
title: "Estratégias de Escala Web"
category: "22 - ESCALABILIDADE"
tags:
  - engenharia-software
  - escalabilidade
  - web
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Estratégias de Escala Web

## Resumo

Técnicas práticas para escalar aplicações web: **statelessness + load balancing**, **caching em camadas**, **autoscaling/elasticidade**, **processamento assíncrono** e **degradação graciosa**. Aplicadas na ordem certa, levam de um servidor a milhões de usuários.

## 1. Statelessness + Load Balancing

Base de tudo: servidores de aplicação **sem estado local** → qualquer nó atende qualquer requisição → dá para adicionar/remover nós atrás de um [[Componentes de Sistemas em Larga Escala|load balancer]].
- Estado (sessão) vai para **cache externo** (Redis) ou token ([[JWT (JSON Web Token)|JWT]]).
- Evitar **sticky sessions** (prendem usuário a um nó, atrapalham o balanceamento).

## 2. Caching em camadas

Cada camada de cache tira carga da seguinte (ver [[Cache e Redis]]):
- **Browser / cliente** — Cache-Control.
- **CDN** — estáticos e conteúdo perto do usuário ([[Performance Web]]).
- **Aplicação** — Redis/Memcached (dados quentes, sessões).
- **Banco** — query cache, materialized views.
> "A coisa mais rápida é o trabalho que você **não faz**" — cache bem colocado é a maior alavanca de escala/leitura.

## 3. Escalar o banco (na ordem)

1. **Índices** e otimização de query ([[Indices e Otimizacao de Queries]]).
2. **Cache** de leituras quentes.
3. **[[Replicacao de Dados|Read replicas]]** (escala leitura).
4. **[[Particionamento e Sharding|Sharding]]** (escala escrita/volume) — por último.

## 4. Processamento assíncrono

Tirar trabalho pesado do caminho da requisição via [[Mensageria - Fundamentos|filas]]:
- Responder rápido (ex.: 202 Accepted) e processar em **workers** em background.
- Absorve **picos** (a fila amortece) e desacopla.

## 5. Autoscaling (elasticidade)

Ajustar o nº de instâncias **automaticamente** conforme métricas (CPU, req/s, tamanho de fila).
- **Horizontal Pod Autoscaler** ([[Kubernetes]]), Auto Scaling Groups (cloud).
- Cuidado: **cold start**, tempo de provisionamento, e escalar o **gargalo real** (adianta pouco escalar app se o banco satura).

## 6. Degradação graciosa e resiliência

Sob sobrecarga, **degradar** em vez de cair:
- **Circuit breaker** — parar de chamar um serviço que está falhando.
- **Rate limiting / throttling** — proteger contra abuso/picos ([[Boas Praticas de API]]).
- **Load shedding** — descartar/enfileirar excesso.
- **Bulkhead** — isolar recursos para uma falha não derrubar tudo.
- **Fallbacks** — resposta reduzida quando um componente falha.

## 7. Multi-região / geográfica

Para latência global e disaster recovery: réplicas/CDN em várias regiões (traz complexidade de consistência — [[Teorema CAP e Sistemas Distribuidos|CAP]]).

## Ordem prática de escala

```
1. Otimizar (perfil, queries, índices)  ← barato
2. Cache (browser → CDN → app → DB)
3. Escala horizontal do app (stateless + LB + autoscaling)
4. Read replicas
5. Async (filas) para trabalho pesado
6. Sharding do banco                    ← caro, por último
```

## Quando aplicar

- Conforme as métricas mostram saturação — uma alavanca por vez, medindo o efeito.

## Erros comuns / Anti-patterns

- App **stateful** impedindo scale out.
- Autoscaling do app com **banco** como gargalo real (não resolve).
- Sem cache → banco sofre desnecessariamente.
- Sem degradação graciosa → falha em cascata derruba tudo.
- Sharding antes das alavancas mais baratas.

## Boas práticas

- **Stateless** desde o início; sessão externa.
- Cache agressivo com invalidação pensada.
- Async para picos e trabalho pesado.
- Resiliência (circuit breaker, rate limit, bulkhead) + [[Observabilidade|observabilidade]].
- Medir, escalar o gargalo, repetir.

## Conceitos relacionados

- [[Escalabilidade - Fundamentos]]
- [[Componentes de Sistemas em Larga Escala]]
- [[Replicacao de Dados]] · [[Particionamento e Sharding]]
- [[Cache e Redis]] · [[Mensageria - Fundamentos]]
- [[Kubernetes]] · [[Observabilidade]]

## Perguntas importantes

### Por onde começar a escalar uma app web?
Otimização + **cache** e tornar o app **stateless** atrás de um load balancer (escala horizontal). Banco: índices → cache → réplicas → sharding, nessa ordem.

### O que é degradação graciosa?
Sob sobrecarga/falha, o sistema **reduz funcionalidade** em vez de cair por completo (fallbacks, rate limiting, circuit breaker) — preservando o essencial.

## Fontes

1. Wikipedia — Scalability — https://en.wikipedia.org/wiki/Scalability (consultado 2026-09-03)
2. Alex Xu — *System Design Interview.*
3. Nygard, M. — *Release It!* (padrões de resiliência: circuit breaker, bulkhead).

## Observações

Aprofundar: circuit breaker, bulkhead, load shedding, multi-região. Status: verified.
