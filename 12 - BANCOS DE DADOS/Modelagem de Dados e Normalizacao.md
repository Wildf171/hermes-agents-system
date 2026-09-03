---
title: "Modelagem de Dados e Normalização"
category: "12 - BANCOS DE DADOS"
tags:
  - engenharia-software
  - banco-de-dados
  - modelagem
  - normalizacao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Modelagem de Dados e Normalização

## Resumo

**Modelagem de dados** é o processo de estruturar como os dados serão organizados e relacionados. **Normalização** é a técnica (proposta por **E. F. Codd**, no modelo relacional) de organizar tabelas em **formas normais** para **reduzir redundância** e **melhorar integridade**, eliminando anomalias de inserção, atualização e exclusão.

## O que é?

- **Modelo conceitual** → entidades e relações (diagrama ER, alto nível).
- **Modelo lógico** → tabelas, colunas, chaves, tipos.
- **Modelo físico** → implementação concreta no SGBD (índices, particionamento).

Normalização organiza colunas e tabelas para que as **dependências** sejam corretamente impostas por constraints de integridade.

## Por que existe?

Dados redundantes geram **anomalias**:
- **Inserção** — não consigo registrar um dado sem outro (ex.: professor sem curso).
- **Atualização** — o mesmo dado em vários lugares fica inconsistente (endereço divergente).
- **Exclusão** — apagar um registro perde informação não relacionada.

Normalizar elimina essas anomalias e aumenta a vida útil do design.

## Como funciona? — Formas Normais (principais)

- **1NF (Primeira Forma Normal):** valores atômicos (sem grupos repetidos/listas em uma célula); cada registro único.
- **2NF:** está em 1NF **e** todos os atributos não-chave dependem da **chave inteira** (elimina dependência parcial em chaves compostas).
- **3NF:** está em 2NF **e** nenhum atributo não-chave depende de outro não-chave (elimina **dependência transitiva**).
- **BCNF:** versão mais estrita da 3NF.
- (Existem 4NF, 5NF para casos específicos.)

> Regra mnemônica (3NF): cada atributo depende de **"a chave, a chave inteira e nada além da chave"**.

## Desnormalização

Introduzir redundância **de propósito** para ganhar performance de leitura (menos JOINs). Comum em relatórios, data warehouse e sistemas de leitura intensiva.
- **Trade-off:** leitura mais rápida × risco de inconsistência e escrita mais cara.

## Exemplo prático

```
❌ Não normalizado (anomalias):
Pedido(id, cliente_nome, cliente_email, produto, preco)
 → email do cliente repetido em todo pedido (update anomaly)

✅ Normalizado (3NF):
Cliente(id, nome, email)
Produto(id, nome, preco)
Pedido(id, cliente_id → Cliente, ...)
ItemPedido(pedido_id → Pedido, produto_id → Produto, qtd)
```

## Quando utilizar

- **Normalizar (até 3NF/BCNF):** default para bancos transacionais (OLTP) — integridade primeiro.
- **Desnormalizar:** leitura intensiva, relatórios, [[Engenharia de Dados|data warehouse]] (esquema estrela).

## Quando NÃO utilizar

- Normalização extrema (muitos JOINs) em cargas de leitura pesadas pode prejudicar performance.
- Em NoSQL documento, modela-se por **agregados/queries**, não normalizando como relacional ([[SQL vs NoSQL]]).

## Trade-offs

- Normalizado: integridade, escrita consistente **vs.** mais JOINs (leitura).
- Desnormalizado: leitura rápida **vs.** redundância e risco de inconsistência.

## Erros comuns / Anti-patterns

- Guardar listas/valores múltiplos em uma coluna (viola 1NF).
- Repetir dados de outra entidade (viola 3NF) → update anomalies.
- Desnormalizar cedo demais "por performance" sem medir.
- Chaves naturais instáveis como PK (prefira surrogate keys quando fizer sentido).

## Boas práticas

- Normalize até 3NF por padrão; desnormalize **conscientemente** com medição.
- Use constraints (FK, UNIQUE, CHECK) para impor integridade.
- Modele o conceitual (ER) antes do físico.

## Conceitos relacionados

- [[SQL vs NoSQL]]
- [[Transacoes e ACID]]
- [[Indices e Otimizacao de Queries]]
- [[04 - MODELAGEM/_INDEX|Modelagem (UML/ER)]]
- [[Engenharia de Dados]] (esquema estrela)

## Perguntas importantes

### O que a normalização evita?
Redundância e as anomalias de inserção, atualização e exclusão, melhorando a integridade dos dados.

### Devo sempre normalizar até a forma mais alta?
Não. 3NF/BCNF é um bom alvo para OLTP. Para leitura intensiva/analytics, desnormalização controlada é legítima.

## Fontes

1. Wikipedia — Database normalization — https://en.wikipedia.org/wiki/Database_normalization (consultado 2026-09-03)
2. Codd, E. F. (1970/1971) — modelo relacional e normalização.
3. Date, C. J. — *An Introduction to Database Systems.*

## Observações

Criar notas por forma normal e sobre modelagem dimensional (star/snowflake). Status: verified.
