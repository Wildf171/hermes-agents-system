---
title: "Processo de System Design"
category: "10 - ARQUITETURA DE SISTEMAS"
tags:
  - engenharia-software
  - system-design
  - processo
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Processo de System Design

## Resumo

Um **método passo a passo** para projetar um sistema em escala — útil tanto no trabalho real quanto em **entrevistas de system design**. A ideia central: **entender requisitos → estimar carga → esboçar o alto nível → detalhar → resolver gargalos**, sempre justificando **trade-offs**.

## Por que um processo?

System design é aberto e ambíguo. Um processo evita pular para soluções cedo demais, garante que os [[Requisitos Nao Funcionais|NFRs certos]] guiem as decisões e torna o raciocínio comunicável.

## Os passos

### 1. Esclarecer requisitos (não pule!)
- **Funcionais:** o que o sistema faz? (features principais, escopo).
- **Não funcionais:** escala esperada, latência, disponibilidade, consistência ([[Requisitos Nao Funcionais|NFRs]]).
- Definir o que está **dentro/fora** de escopo.

### 2. Estimativa de capacidade (back-of-the-envelope)
- Usuários (DAU), **requisições/segundo** (média e pico), leitura vs escrita.
- **Volume de dados** (por dia/ano), largura de banda, memória de cache.
- Essas contas guiam quantos servidores, tamanho de banco, necessidade de sharding.

### 3. Modelo de dados e API
- Entidades e relações ([[Diagrama Entidade-Relacionamento (ER)|ER]]).
- Definir a **API** (endpoints/contratos — [[APIs REST - Fundamentos e Design|REST]]/[[gRPC]]).

### 4. Desenho de alto nível
- Blocos principais e o fluxo: cliente → CDN → LB → serviços → cache/DB/fila. Ver [[Componentes de Sistemas em Larga Escala]].
- Um diagrama simples ([[C4 Model|C4]]/Mermaid).

### 5. Aprofundar (deep dive)
- Detalhar os componentes críticos: esquema do banco, estratégia de **cache**, **replicação/sharding**, **filas**.
- Escolher SQL vs NoSQL ([[SQL vs NoSQL]]) e consistência ([[Teorema CAP e Sistemas Distribuidos|CAP]]) conforme o caso.

### 6. Identificar e resolver gargalos
- Onde está o **SPOF**? O que satura primeiro no pico?
- Adicionar: read replicas, cache, CDN, sharding, filas, autoscaling.
- Tratar disponibilidade (redundância/failover), [[Observabilidade|observabilidade]] e segurança.

### 7. Justificar trade-offs
- Toda escolha tem custo. Explicar **por que** (ex.: "escolhi consistência eventual aqui porque disponibilidade importa mais").

## Checklist mental (atalhos)

- Leitura pesada? → cache + read replicas + CDN.
- Escrita pesada? → sharding, filas, escrita assíncrona.
- Precisa de ordem/consistência? → escolher banco/partição adequados.
- Picos? → filas + autoscaling.
- Global? → CDN + multi-região.
- SPOF? → redundância em toda camada.

## Exemplo (mini-fluxo de raciocínio)

```
"Projete um encurtador de URL"
1. Requisitos: encurtar, redirecionar; 100M URLs, leitura ≫ escrita
2. Estimativa: ~10k redirects/s no pico → cache é essencial
3. API: POST /shorten, GET /{code}; Dados: code → url
4. Alto nível: LB → serviço → cache (Redis) → DB (key-value)
5. Deep dive: geração de code (hash/base62), cache dos populares
6. Gargalos: leitura → cache + replicas; DB → sharding por code
7. Trade-offs: consistência eventual ok (redirect); disponibilidade alta
```

## Quando utilizar

- Projetar sistemas novos; revisar arquitetura; preparar entrevistas.

## Erros comuns / Anti-patterns

- **Pular requisitos** e ir direto para a solução.
- Não fazer **estimativa de carga** (dimensionar no escuro).
- Over-engineering (sharding/microsserviços sem necessidade).
- Não citar **trade-offs** (toda decisão tem custo).
- Esquecer disponibilidade/observabilidade/segurança.

## Boas práticas

- Comece pelos **requisitos e NFRs**; faça as **contas**.
- Do **alto nível ao detalhe**; um diagrama claro.
- Comece simples; adicione componentes conforme a carga exige.
- Sempre explicite **por que** de cada escolha.

## Conceitos relacionados

- [[Arquitetura de Sistemas e System Design - Fundamentos]]
- [[Componentes de Sistemas em Larga Escala]]
- [[Integracao de Sistemas]]
- [[Requisitos Nao Funcionais]] · [[Teorema CAP e Sistemas Distribuidos]]
- [[22 - ESCALABILIDADE/_INDEX]]

## Perguntas importantes

### Por onde começar um system design?
Pelos **requisitos** (funcionais e NFRs) e por uma **estimativa de carga**. Só então esboce o alto nível — nunca comece pela solução.

### O que os entrevistadores mais valorizam?
Raciocínio estruturado e **trade-offs explícitos** — não decorar uma arquitetura. Mostrar como você pensa importa mais que a resposta "certa".

## Fontes

1. Alex Xu — *System Design Interview* (Vol. 1 e 2).
2. Donne Martin — *system-design-primer* — https://github.com/donnemartin/system-design-primer
3. Kleppmann — *Designing Data-Intensive Applications.*

## Observações

Livros/repos citados são referências amplamente reconhecidas na área. Status: verified.
