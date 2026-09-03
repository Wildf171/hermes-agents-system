---
title: "Cache e Redis"
category: "12 - BANCOS DE DADOS"
tags:
  - engenharia-software
  - cache
  - redis
  - performance
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Cache e Redis

## Resumo

**Cache** é uma camada de armazenamento rápida que guarda cópias de dados para servir leituras futuras com **baixa latência**, evitando recomputar ou reconsultar a fonte lenta. **Redis** é o armazenamento chave-valor em memória mais usado para cache (e também filas, contadores, sessões, pub/sub).

## O que é?

Guardar resultado de uma operação cara (query, cálculo, chamada externa) em memória para reuso. Baseia-se no princípio de **localidade** e no fato de que muitas leituras se repetem (princípio de Pareto: poucos itens concentram a maioria dos acessos).

## Por que existe?

Reduz **latência** e **carga** na fonte primária (banco/serviço), melhorando desempenho e escalabilidade. Um acesso à memória é ordens de grandeza mais rápido que a disco/rede.

## Como funciona? — Padrões de cache

- **Cache-aside (lazy loading):** a aplicação consulta o cache; se **miss**, busca no banco e popula o cache. O padrão mais comum.
- **Read-through:** o cache busca no banco automaticamente no miss.
- **Write-through:** escreve no cache e no banco ao mesmo tempo (consistente, escrita mais lenta).
- **Write-behind (write-back):** escreve no cache e persiste no banco depois (rápido, risco de perda).

### Invalidação e TTL
- **TTL (time-to-live):** expira entradas automaticamente.
- **Invalidação:** remover/atualizar a entrada quando o dado muda.
> "Só há duas coisas difíceis em computação: invalidação de cache e nomear coisas." — Phil Karlton.

### Políticas de evicção
Quando o cache enche: **LRU** (least recently used), **LFU**, **FIFO**, TTL.

## Redis (fundamentos)

- Armazenamento **chave-valor em memória**, single-threaded (comandos atômicos), extremamente rápido.
- Estruturas: strings, hashes, lists, sets, sorted sets, streams, bitmaps, HyperLogLog.
- Usos: **cache**, sessões, rate limiting, filas, leaderboards (sorted sets), **pub/sub**.
- Persistência opcional (RDB snapshots, AOF) — mas o foco é velocidade.
- Cuidado: é memória — planeje capacidade e evicção.

## Exemplo prático (cache-aside)

```python
def get_produto(id):
    chave = f"produto:{id}"
    if (cached := redis.get(chave)):     # HIT
        return json.loads(cached)
    produto = db.query(id)               # MISS -> banco
    redis.setex(chave, 300, json.dumps(produto))  # TTL 5min
    return produto
```

## Quando utilizar

- Leituras frequentes de dados que mudam pouco (catálogos, perfis, config).
- Reduzir custo de queries caras/chamadas externas.
- Sessões, rate limiting, contadores.

## Quando NÃO utilizar

- Dados que **mudam a cada leitura** ou exigem sempre o valor mais recente.
- Como banco primário para dados que não podem ser perdidos (a menos que configurado e entendido).

## Trade-offs

- Latência baixa **vs.** risco de **dados desatualizados** (stale) e complexidade de invalidação.
- Memória é cara e finita (precisa de evicção).

## Erros comuns / Anti-patterns

- **Cache stampede** — muitas requisições recalculam ao mesmo tempo no miss (use lock/single-flight, TTL jitter).
- Nunca invalidar → dados velhos servidos indefinidamente.
- Cachear dados sensíveis sem cuidado.
- Tratar Redis como banco durável sem configurar persistência/replicação.

## Boas práticas

- **Cache-aside** com TTL como default; invalidar em escrita.
- TTL curto para dados que mudam; adicionar **jitter** para evitar expiração em massa.
- Chaves com namespace claro (`produto:42`).
- Monitorar hit ratio ([[Observabilidade]]).

## Conceitos relacionados

- [[SQL vs NoSQL]] (Redis é NoSQL chave-valor)
- [[Indices e Otimizacao de Queries]]
- [[21 - PERFORMANCE/_INDEX|Performance]]
- [[Teorema CAP e Sistemas Distribuidos]] (consistência do cache)

## Perguntas importantes

### Qual o padrão de cache mais comum?
**Cache-aside**: a aplicação tenta o cache; no miss, lê o banco e popula o cache com TTL.

### Por que invalidação de cache é difícil?
Manter o cache coerente com a fonte à medida que os dados mudam é sutil — expirar cedo demais desperdiça; tarde demais serve dados velhos. Daí a famosa piada de Phil Karlton.

## Fontes

1. Redis — Documentação — https://redis.io/docs/latest/
2. AWS — Caching best practices / cache-aside — https://aws.amazon.com/caching/
3. Martin Kleppmann — *Designing Data-Intensive Applications* (2017).

## Observações

Aprofundar: estruturas do Redis, rate limiting, pub/sub, cluster/replicação. Status: verified.
