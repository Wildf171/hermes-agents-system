---
title: "Índices e Otimização de Queries"
category: "12 - BANCOS DE DADOS"
tags:
  - engenharia-software
  - banco-de-dados
  - indices
  - performance
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Índices e Otimização de Queries

## Resumo

Um **índice** é uma estrutura de dados que **acelera a busca** em uma tabela, ao custo de **espaço extra e escrita mais lenta**. É a principal ferramenta de otimização de consultas: transforma uma busca linear O(n) em algo próximo de O(log n).

## O que é?

Uma cópia ordenada de colunas selecionadas + um ponteiro para a linha original, projetada para busca eficiente. Sem índice, o banco faz **full table scan** (varre todas as linhas). Com índice, faz **lookup** rápido.

## Por que existe?

Busca linear é inviável em tabelas grandes. Índices permitem lookup **sublinear**, essencial para performance de leitura em produção.

## Como funciona? — Tipos de índice (PostgreSQL como referência)

- **B-tree** (padrão) — igualdade e faixas (`=`, `<`, `>`, `BETWEEN`, `ORDER BY`). Base de PKs e da maioria dos casos.
- **Hash** — apenas igualdade (`=`).
- **GIN** — dados compostos: JSONB, arrays, full-text search.
- **GiST** — dados geométricos/espaciais, ranges.
- **BRIN** — tabelas enormes e naturalmente ordenadas (ex.: séries temporais); muito compacto.
- **Índice parcial** — só linhas que satisfazem uma condição (`WHERE ativo = true`).
- **Índice de expressão** — sobre `lower(email)`, por exemplo.
- **Índice composto** — várias colunas; a **ordem importa** (regra do prefixo mais à esquerda).

## Otimização de queries

### EXPLAIN / EXPLAIN ANALYZE
Mostra o **plano de execução**: se usa índice ou seq scan, custo estimado e tempo real.
```sql
EXPLAIN ANALYZE
SELECT * FROM pedidos WHERE cliente_id = 42;
```

### Princípios
- Indexe colunas usadas em **WHERE, JOIN, ORDER BY**.
- Elimine **N+1 queries** (buscar em loop) — use JOIN ou batch.
- Selecione só as colunas necessárias (evite `SELECT *` em hot paths).
- Cuidado com funções na coluna do WHERE (`WHERE upper(nome)=...` ignora índice comum → use índice de expressão).

## Exemplo prático

```sql
-- Lento: full scan em tabela grande
SELECT * FROM usuarios WHERE email = 'a@b.com';   -- Seq Scan

-- Rápido: cria índice
CREATE INDEX idx_usuarios_email ON usuarios(email);
-- agora usa Index Scan (verifique com EXPLAIN)

-- Índice composto (ordem importa): filtra por status e ordena por data
CREATE INDEX idx_ped_status_data ON pedidos(status, criado_em);
```

## Quando utilizar

- Colunas frequentemente filtradas/ordenadas/juntadas.
- Chaves estrangeiras (acelera JOINs e checagens).

## Quando NÃO utilizar (armadilhas)

- **Indexar tudo:** cada índice **desacelera INSERT/UPDATE/DELETE** e ocupa espaço.
- Colunas de baixa cardinalidade (ex.: booleano) raramente valem um B-tree — considere índice parcial.
- Índice que nunca é usado pelo planner (verifique com estatísticas).

## Trade-offs

- Leitura rápida **vs.** escrita mais lenta + armazenamento.
- Mais índices = SELECTs melhores, porém DML pior e manutenção (VACUUM/rebuild).

## Erros comuns / Anti-patterns

- `SELECT *` e N+1 queries.
- Função na coluna do WHERE anulando o índice.
- Ordem errada em índice composto.
- Não rodar `ANALYZE`/atualizar estatísticas → planner escolhe mal.
- Otimizar sem `EXPLAIN` (chute).

## Boas práticas

- **Meça com EXPLAIN ANALYZE** antes e depois.
- Indexe com base nas queries reais; remova índices não usados.
- Mantenha estatísticas atualizadas (autovacuum/ANALYZE no PostgreSQL).
- Considere [[Cache e Redis|cache]] para leituras muito quentes.

## Conceitos relacionados

- [[PostgreSQL - Fundamentals]]
- [[Modelagem de Dados e Normalizacao]]
- [[Complexidade Algoritmica (Big-O)]]
- [[Estruturas de Dados]] (B-tree, hash)
- [[21 - PERFORMANCE/_INDEX|Performance]]

## Perguntas importantes

### Índice sempre melhora a performance?
Não. Melhora **leitura**, mas piora **escrita** e ocupa espaço. Índices demais ou mal escolhidos prejudicam.

### Como sei se minha query usa índice?
Rode `EXPLAIN ANALYZE`: procure "Index Scan" (bom) vs "Seq Scan" (varredura completa) e compare custos/tempo.

## Fontes

1. Wikipedia — Database index — https://en.wikipedia.org/wiki/Database_index (consultado 2026-09-03)
2. Documentação PostgreSQL — Indexes — https://www.postgresql.org/docs/current/indexes.html
3. Markus Winand — *Use The Index, Luke!* — https://use-the-index-luke.com

## Observações

Aprofundar: índices compostos, covering index, EXPLAIN a fundo, VACUUM. Status: verified.
