---
title: "Engenharia de Dados"
category: "37 - ENGENHARIA DE DADOS"
tags:
  - engenharia-software
  - engenharia-de-dados
  - etl
  - pipelines
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Engenharia de Dados

## Resumo

**Engenharia de dados** é a abordagem de engenharia de software para **construir sistemas de dados** — coletar, mover, transformar e disponibilizar dados de forma confiável e em escala — habilitando análise, BI, [[38 - IA PARA ENGENHARIA DE SOFTWARE/_INDEX|IA]] e machine learning. Envolve **pipelines**, armazenamento (data warehouse/lake) e processamento.

## O que é?

Disciplina que projeta e opera a infraestrutura que torna os dados **usáveis**: ingestão, pipelines (ETL/ELT), modelagem analítica, qualidade e governança. Fornece a base para **data scientists** e **analistas**.

## Por que existe?

Dados brutos, espalhados por sistemas transacionais, APIs e arquivos, não servem diretamente para análise. É preciso **integrar, limpar, transformar e organizar** em escala — trabalho especializado que difere do desenvolvimento de aplicações (OLTP).

## Como funciona? — Conceitos centrais

### ETL vs ELT
- **ETL (Extract, Transform, Load):** extrai da fonte, **transforma** e então carrega no destino. Clássico em data warehouses tradicionais.
- **ELT (Extract, Load, Transform):** carrega os dados brutos primeiro e **transforma dentro** do destino (aproveita a potência de warehouses modernos como BigQuery/Snowflake). Tendência atual.

### Armazenamento analítico
- **Data Warehouse (DW):** repositório estruturado e otimizado para análise (OLAP). Modelagem dimensional (**esquema estrela/snowflake**, fatos e dimensões — Kimball). Ex.: Snowflake, BigQuery, Redshift.
- **Data Lake:** guarda dados **brutos** (estruturados e não estruturados) em baixo custo (ex.: S3). Flexível, mas risco de virar "data swamp".
- **Data Lakehouse:** híbrido que une flexibilidade do lake com estrutura/gestão do warehouse (ex.: Databricks/Delta Lake).

### Processamento
- **Batch** — processa grandes volumes periodicamente (Spark, dbt).
- **Streaming** — processa em tempo real (Kafka, Flink, Spark Streaming). Ver [[36 - MENSAGERIA/_INDEX|Mensageria]].

### Orquestração
- Ferramentas como **Airflow**, Dagster, Prefect agendam e monitoram pipelines (DAGs).

## OLTP vs OLAP

| | **OLTP** (transacional) | **OLAP** (analítico) |
|---|---|---|
| Objetivo | Operações do dia a dia | Análise/relatórios |
| Escrita/Leitura | Muitas escritas curtas | Muitas leituras agregadas |
| Modelagem | Normalizada (3NF) | Dimensional (estrela) |
| Exemplo | PostgreSQL da app | BigQuery/Snowflake |

## Exemplo prático (pipeline ELT)

```
Fontes (app DB, APIs, logs)
   → Ingestão (Airbyte/Fivetran/Kafka)
   → Data Lake / Warehouse (carrega bruto)
   → Transformação (dbt / Spark) → tabelas modeladas (fato/dimensão)
   → BI (dashboards) / ML
   ↑ Orquestração: Airflow  |  Observabilidade de dados: qualidade, freshness
```

## Quando utilizar

- Necessidade de **análise/relatórios** sobre muitos dados de várias fontes.
- Alimentar ML/IA com dados confiáveis.
- Consolidar dados de múltiplos sistemas.

## Quando NÃO utilizar (nuance)

- App pequena com pouca análise → um banco transacional + queries/relatórios simples bastam. Montar DW/lake seria over-engineering.

## Trade-offs

- ELT (moderno) é flexível e rápido de ingerir **vs.** custo de computação no warehouse e governança de dados brutos.
- Data Lake é barato/flexível **vs.** risco de "data swamp" sem catálogo/qualidade.

## Erros comuns / Anti-patterns

- **Data swamp** — lake sem catálogo, qualidade ou governança.
- Pipelines frágeis sem monitoramento de **qualidade/freshness**.
- Misturar cargas OLTP e OLAP no mesmo banco (concorrência e performance ruins).
- Transformações não versionadas/testadas.

## Boas práticas

- Versionar e testar transformações (ex.: **dbt** + testes de dados).
- Orquestrar com DAGs idempotentes e reprocessáveis.
- Monitorar **qualidade de dados** (data observability): freshness, volume, schema.
- Separar OLTP de OLAP.

## Conceitos relacionados

- [[SQL vs NoSQL]]
- [[Modelagem de Dados e Normalizacao]] (dimensional vs normalizado)
- [[36 - MENSAGERIA/_INDEX|Mensageria (Kafka)]]
- [[38 - IA PARA ENGENHARIA DE SOFTWARE/_INDEX|IA / ML]]
- [[Observabilidade]]

## Perguntas importantes

### Qual a diferença entre ETL e ELT?
ETL transforma **antes** de carregar; ELT carrega o dado bruto e transforma **dentro** do warehouse. ELT é a tendência com warehouses modernos.

### Data Warehouse ou Data Lake?
DW: dados estruturados e modelados para análise. Lake: dados brutos, baratos e flexíveis. Lakehouse tenta unir os dois.

## Fontes

1. Wikipedia — Data engineering — https://en.wikipedia.org/wiki/Data_engineering (consultado 2026-09-03)
2. Kimball, R. — *The Data Warehouse Toolkit* (modelagem dimensional).
3. Reis & Housley — *Fundamentals of Data Engineering* (O'Reilly, 2022).

## Observações

Criar notas próprias: dbt, Airflow, Kafka streaming, modelagem dimensional, data quality. Status: verified.
