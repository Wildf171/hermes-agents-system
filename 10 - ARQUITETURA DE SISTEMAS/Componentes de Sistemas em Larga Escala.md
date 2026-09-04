---
title: "Componentes de Sistemas em Larga Escala"
category: "10 - ARQUITETURA DE SISTEMAS"
tags:
  - engenharia-software
  - arquitetura-sistemas
  - system-design
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Componentes de Sistemas em Larga Escala

## Resumo

Os "blocos de construção" recorrentes de sistemas em escala: **load balancer, CDN, cache, réplicas e sharding de banco, filas/mensageria, API gateway**. Conhecer o que cada um resolve (e seus trade-offs) é a base do [[Arquitetura de Sistemas e System Design - Fundamentos|system design]].

## Load Balancer (LB)

Distribui requisições entre vários servidores para **otimizar tempo de resposta** e evitar sobrecarregar nós. Habilita **escala horizontal** e **alta disponibilidade** (tira nós doentes via health checks).
- **L4** (transporte, TCP/UDP) vs **L7** (aplicação, HTTP — pode rotear por path/host).
- **Algoritmos:** round robin, least connections, IP hash, weighted.
- **Estáticos** (ignoram estado dos nós) vs **dinâmicos** (usam carga atual — mais eficientes, exigem troca de info).
- Requer servidores **stateless** (ou sticky sessions/sessão externa).

## CDN (Content Delivery Network)

Rede de servidores distribuídos geograficamente que **cacheia conteúdo perto do usuário** (estáticos, imagens, vídeo, e até respostas). Reduz **latência** e carga na origem. Ver [[Performance Web]].

## Cache

Camada rápida (memória) para dados quentes → menos latência e menos carga no banco. Ver [[Cache e Redis]].
- Níveis: **client** (browser), **CDN**, **aplicação** (Redis/Memcached), **banco** (query cache).
- Cuidado com **invalidação** e consistência.

## Banco de Dados em escala

- **Réplicas de leitura (replication)** — primary recebe escrita; réplicas atendem leitura (escala leitura, redundância). Cuidado: **lag de replicação** (consistência eventual).
- **[[Teorema CAP e Sistemas Distribuidos|Sharding/particionamento]]** — dividir dados por chave entre nós (escala escrita/volume). Complexo: joins/transações cross-shard, hot shards.
- **Índices** e **read replicas** antes de sharding (sharding é caro — última opção).

## Fila / Mensageria

Desacopla produtores de consumidores, absorve picos e processa em background. Ver [[Mensageria - Fundamentos]], [[Apache Kafka]], [[RabbitMQ]].
- Suaviza rajadas (buffer), habilita processamento assíncrono e resiliência.

## API Gateway

Ponto único de entrada para múltiplos [[Microsservicos|serviços]]: roteamento, autenticação, rate limiting, agregação, TLS termination. Variante: **BFF** (Backend for Frontend).

## Outros blocos

- **Object storage** (S3) para arquivos/blobs.
- **Search** (Elasticsearch/OpenSearch) para busca full-text.
- **Service discovery** e **config** distribuída.
- **Observabilidade** ([[Observabilidade]]) transversal.

## Exemplo — leitura pesada

```
Requisição → CDN (estáticos) → LB → App (stateless)
App → Cache (hit? retorna) → senão DB read-replica → popula cache
Escrita → DB primary → replica para réplicas (lag eventual)
```

## Quando usar cada um

- **LB:** assim que houver mais de um servidor de app.
- **CDN:** conteúdo estático/global, reduzir latência.
- **Cache:** leituras repetidas caras.
- **Read replicas:** leitura ≫ escrita.
- **Sharding:** volume/escrita além de um nó (só quando necessário).
- **Fila:** trabalho assíncrono, desacoplamento, picos.
- **Gateway:** vários serviços/clientes.

## Quando NÃO (nuance)

- Não adicione todos os componentes "por precaução". Cada um adiciona **complexidade operacional**. Comece simples; adote quando a métrica exigir.

## Erros comuns / Anti-patterns

- Servidores **stateful** atrás de LB (quebra escala/failover).
- Sharding prematuro (antes de esgotar índices/réplicas/cache).
- Cache sem estratégia de invalidação → dados velhos.
- SPOF: um único LB/DB sem redundância.
- Ignorar **replication lag** (ler da réplica logo após escrever).

## Boas práticas

- **Stateless** + sessão externa (Redis) para escalar horizontalmente.
- Redundância em cada camada (sem SPOF).
- Cache + read replicas antes de sharding.
- Medir (capacity) e evoluir; observabilidade sempre.

## Conceitos relacionados

- [[Arquitetura de Sistemas e System Design - Fundamentos]]
- [[Integracao de Sistemas]] · [[Processo de System Design]]
- [[Cache e Redis]] · [[Teorema CAP e Sistemas Distribuidos]]
- [[Mensageria - Fundamentos]] · [[Microsservicos]]
- [[22 - ESCALABILIDADE/_INDEX]]

## Perguntas importantes

### Como escalar leitura vs escrita?
**Leitura:** cache + read replicas + CDN. **Escrita:** otimização/índices, depois **sharding** (particionar por chave) — mais complexo, use por último.

### Por que servidores devem ser stateless?
Para que qualquer nó atenda qualquer requisição (load balancing e failover). Estado (sessão) vai para armazenamento externo (ex.: Redis).

## Fontes

1. Wikipedia — Load balancing (computing) — https://en.wikipedia.org/wiki/Load_balancing_(computing) (consultado 2026-09-03)
2. Alex Xu — *System Design Interview.*
3. Kleppmann — *Designing Data-Intensive Applications* (replicação, particionamento).

## Observações

Criar notas próprias: LB L4 vs L7, replicação, sharding strategies, API Gateway. Status: verified.
