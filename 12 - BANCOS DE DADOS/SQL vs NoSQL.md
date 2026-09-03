---
title: "SQL vs NoSQL"
category: "12 - BANCOS DE DADOS"
tags:
  - engenharia-software
  - banco-de-dados
  - sql
  - nosql
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# SQL vs NoSQL

## Resumo

**SQL (relacional)** organiza dados em **tabelas** com schema fixo e prioriza **consistência** (modelo [[Transacoes e ACID|ACID]]). **NoSQL (não relacional / "not only SQL")** usa estruturas flexíveis (documento, chave-valor, coluna larga, grafo), sem schema fixo, e costuma priorizar **escala horizontal** e disponibilidade (modelo BASE / consistência eventual). Não é "um melhor que o outro" — é **trade-off por caso de uso**.

## O que é cada um?

### SQL (Relacional)
Dados em **linhas e colunas**, relações por chaves, linguagem **SQL**, schema definido. Ex.: PostgreSQL, MySQL, SQL Server, Oracle. Baseado no **modelo relacional de Codd** (1970) e em [[Transacoes e ACID|ACID]].

### NoSQL (Não Relacional)
Termo que surgiu nos anos 2000 (Web 2.0). Tipos principais:
- **Documento** — JSON/BSON (MongoDB, Couchbase).
- **Chave-valor** — (Redis, DynamoDB).
- **Coluna larga (wide-column)** — (Cassandra, HBase).
- **Grafo** — nós e relações (Neo4j).

Sem schema fixo, **escala horizontal** (clusters), muitos priorizam **BASE** (basically available, soft state, eventually consistent) sobre ACID — embora alguns (ex.: MongoDB) já ofereçam transações ACID.

## Por que os dois existem?

- **Relacional:** integridade forte, consultas ad hoc com JOINs, transações — décadas de maturidade.
- **NoSQL:** nasceu da necessidade de **escalar horizontalmente** dados grandes/semiestruturados de aplicações web em tempo real, onde o schema rígido e o scale-up do relacional eram limitantes.

## Como escolher — comparação

| Critério | SQL (relacional) | NoSQL |
|---|---|---|
| Schema | Fixo, forte | Flexível/dinâmico |
| Consistência | ACID (forte) | Geralmente BASE (eventual) |
| Escala | Vertical (e réplicas) | Horizontal (nativa) |
| Relações/JOINs | Fortes, ad hoc | Limitadas (modela por agregação) |
| Casos | Transações, dados relacionais, relatórios | Big data, alta escrita, dados semiestruturados, cache |
| Exemplos | PostgreSQL, MySQL | MongoDB, Redis, Cassandra, Neo4j |

Relaciona-se ao [[Teorema CAP e Sistemas Distribuidos|Teorema CAP]]: um banco tende a ACID (CP) **ou** BASE (AP).

## Quando utilizar

- **SQL:** dados relacionais com integridade crítica (financeiro, ERP), necessidade de JOINs e transações, relatórios ad hoc. **Bom default** para a maioria dos sistemas.
- **NoSQL documento:** dados semiestruturados, schema que evolui, agregados que se leem juntos.
- **NoSQL chave-valor:** cache, sessões, contadores (Redis).
- **NoSQL grafo:** relacionamentos densos (redes sociais, recomendação).
- **Wide-column:** escrita massiva/séries temporais (Cassandra).

## Quando NÃO utilizar

- NoSQL "porque é moderno" em dados fortemente relacionais → você reimplementa JOINs na aplicação.
- SQL para dados sem schema e escala horizontal extrema pode custar caro.

## Trade-offs

- SQL: integridade e poder de consulta **vs.** escala horizontal mais difícil.
- NoSQL: escala e flexibilidade **vs.** consistência eventual, sem JOINs, modelagem orientada a acesso.

## Erros comuns / Anti-patterns

- Usar MongoDB como "SQL sem schema" e sofrer com dados inconsistentes.
- Ignorar que muitos problemas cabem bem no PostgreSQL (que também faz JSON!).
- **Polyglot persistence** mal governado (bancos demais, complexidade demais).

## Boas práticas

- **Comece relacional** (PostgreSQL) salvo necessidade clara; ele cobre JSON, full-text e escala razoável.
- Escolha NoSQL pelo **padrão de acesso** e escala, não por hype.
- Modele NoSQL pelas **queries** (agregados), não normalizando como relacional.

## Conceitos relacionados

- [[Transacoes e ACID]]
- [[Modelagem de Dados e Normalizacao]]
- [[Indices e Otimizacao de Queries]]
- [[Teorema CAP e Sistemas Distribuidos]]
- [[PostgreSQL - Fundamentals]]

## Perguntas importantes

### NoSQL significa "sem SQL"?
Não — significa **"not only SQL"** (não apenas relacional). Vários NoSQL têm linguagens tipo-SQL e podem conviver com bancos SQL (polyglot persistence).

### SQL ou NoSQL para meu projeto?
Na dúvida, **SQL (PostgreSQL)**. Vá para NoSQL quando o padrão de acesso, o volume ou a escala horizontal justificarem claramente.

## Fontes

1. Wikipedia — NoSQL — https://en.wikipedia.org/wiki/NoSQL (consultado 2026-09-03)
2. Wikipedia — ACID — https://en.wikipedia.org/wiki/ACID (consultado 2026-09-03)
3. Codd, E. F. (1970). "A Relational Model of Data for Large Shared Data Banks."
4. Martin Kleppmann — *Designing Data-Intensive Applications* (2017).

## Observações

Criar notas por tipo de NoSQL e por banco. Status: verified.
