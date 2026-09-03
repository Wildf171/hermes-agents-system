---
title: "Diagrama Entidade-Relacionamento (ER)"
category: "04 - MODELAGEM"
tags:
  - engenharia-software
  - modelagem
  - er
  - banco-de-dados
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Diagrama Entidade-Relacionamento (ER)

## Resumo

O **modelo Entidade-Relacionamento (ER)** descreve as "coisas de interesse" de um domínio como **entidades**, seus **atributos** e os **relacionamentos** entre elas. É a notação clássica para **projetar bancos de dados** (vira, tipicamente, um esquema relacional). Criado por **Peter Chen** (1976).

## O que é?

Um **modelo de dados abstrato** que representa o que um negócio precisa "lembrar" para operar. Composto por:
- **Entidade** — coisa de interesse (Cliente, Pedido, Produto). Tipos de entidade classificam instâncias.
- **Atributo** — propriedade da entidade (nome, preço). Um é a **chave** (identificador).
- **Relacionamento** — associação entre entidades (Cliente **faz** Pedido).

Vira um modelo de dados **concreto** implementável em banco (geralmente [[SQL vs NoSQL|relacional]]).

## Cardinalidade (multiplicidade)

Quantas instâncias se relacionam:
- **1:1** — um-para-um (Usuário ↔ Perfil).
- **1:N** — um-para-muitos (Cliente → Pedidos).
- **N:M** — muitos-para-muitos (Produto ↔ Pedido) → resolvido com **tabela associativa** (ItemPedido).

## Notações

- **Chen** (original, 1976) — losangos para relacionamentos, elipses para atributos.
- **Crow's Foot (pé de galinha)** — a mais usada hoje; símbolos nas pontas indicam cardinalidade.
- Também representável em [[UML - Diagramas Essenciais|UML]] (diagrama de classes) e em **Mermaid**.

## Níveis do modelo ER

- **Conceitual** — entidades e relações de negócio, sem detalhes técnicos.
- **Lógico** — atributos, chaves, tipos, normalização ([[Modelagem de Dados e Normalizacao]]).
- **Físico** — tabelas, colunas, índices no SGBD específico.

## Exemplo (Mermaid)

```mermaid
erDiagram
  CLIENTE ||--o{ PEDIDO : faz
  PEDIDO ||--|{ ITEM_PEDIDO : contem
  PRODUTO ||--o{ ITEM_PEDIDO : referencia
  CLIENTE { int id PK; string nome; string email }
  PEDIDO { int id PK; int cliente_id FK; datetime criado_em }
```

## Do ER ao esquema relacional

- Entidade → **tabela**; atributo → **coluna**; chave → **PK**.
- Relacionamento 1:N → **chave estrangeira (FK)** no lado "muitos".
- Relacionamento N:M → **tabela associativa** com duas FKs.
Depois, aplicar [[Modelagem de Dados e Normalizacao|normalização]] (3NF) e [[Indices e Otimizacao de Queries|índices]].

## Quando utilizar

- Projetar/entender um **banco relacional** antes de criar tabelas.
- Comunicar o modelo de dados a stakeholders/time.
- Documentar um schema existente (engenharia reversa).

## Quando NÃO utilizar (nuance)

- Bancos **NoSQL documento** modelam por agregados/queries, não por ER normalizado ([[SQL vs NoSQL]]).
- Domínios muito comportamentais → o modelo de classes/[[Domain-Driven Design (DDD)|DDD]] pode ser mais adequado que só ER.

## Erros comuns / Anti-patterns

- Esquecer a **tabela associativa** em N:M.
- Modelar atributos multivalorados numa coluna (viola 1NF — ver [[Modelagem de Dados e Normalizacao]]).
- Confundir cardinalidades (1:N vs N:M).
- Misturar níveis (conceitual com detalhes físicos).

## Boas práticas

- Comece no **conceitual**, refine para lógico/físico.
- Use **Crow's Foot** (clareza de cardinalidade).
- ER como código (Mermaid `erDiagram`) versionado.
- Alinhe com normalização e nomes do domínio ([[Domain-Driven Design (DDD)|ubiquitous language]]).

## Conceitos relacionados

- [[Modelagem de Software - Fundamentos]]
- [[Modelagem de Dados e Normalizacao]]
- [[SQL vs NoSQL]]
- [[Indices e Otimizacao de Queries]]
- [[UML - Diagramas Essenciais]]

## Perguntas importantes

### Como representar um relacionamento N:M?
Com uma **tabela associativa** (junction table) que contém as chaves estrangeiras das duas entidades (ex.: ItemPedido liga Pedido e Produto).

### ER serve para NoSQL?
Menos. ER é natural para o modelo **relacional**. Em NoSQL documento, modela-se por **agregados** e padrões de acesso, não por normalização ER.

## Fontes

1. Wikipedia — Entity–relationship model — https://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model (consultado 2026-09-03)
2. Chen, P. (1976). "The Entity-Relationship Model — Toward a Unified View of Data."
3. Documentação Mermaid — erDiagram — https://mermaid.js.org

## Observações

Aprofundar: Crow's Foot detalhado, generalização/especialização, engenharia reversa de schema. Status: verified.
