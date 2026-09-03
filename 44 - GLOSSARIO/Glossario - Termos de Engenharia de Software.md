---
title: "Glossário - Termos de Engenharia de Software"
category: "44 - GLOSSARIO"
tags:
  - engenharia-software
  - glossario
  - referencia
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Glossário — Termos de Engenharia de Software

> [!info] Como usar
> Definições curtas de referência. Quando há uma nota dedicada, o termo linka para ela ([[wikilink]]). Para siglas, veja [[Glossario - Siglas e Acronimos]].

## A

- **Abstração** — expor o essencial, esconder detalhes de implementação. Ver [[Orientacao a Objetos]].
- **[[Transacoes e ACID|ACID]]** — Atomicidade, Consistência, Isolamento, Durabilidade (garantias de transação).
- **Acoplamento** — grau de dependência entre módulos; quer-se **baixo**. Ver [[Coesao e Acoplamento]].
- **[[AI Coding Agents|Agente de IA]]** — programa que planeja, usa ferramentas e age para atingir um objetivo.
- **Aggregate** — cluster de objetos tratado como unidade no [[Domain-Driven Design (DDD)|DDD]].
- **Alucinação** — quando um [[LLMs - Fundamentos|LLM]] gera informação plausível, porém falsa.
- **[[Anti-patterns - Fundamentos|Anti-pattern]]** — solução comum, mas contraproducente.
- **API** — interface para software se comunicar com software. Ver [[APIs REST - Fundamentos e Design]].
- **Assíncrono** — operação que não bloqueia esperando o resultado. Ver [[23 - CONCORRENCIA/_INDEX|Concorrência]].

## B

- **BASE** — Basically Available, Soft state, Eventually consistent (oposto de ACID). Ver [[SQL vs NoSQL]].
- **Big-O** — notação de [[Complexidade Algoritmica (Big-O)|complexidade algorítmica]].
- **Bounded Context** — fronteira onde um modelo de domínio é consistente ([[Domain-Driven Design (DDD)|DDD]]).
- **Broker** — intermediário que roteia mensagens. Ver [[Mensageria - Fundamentos]].

## C

- **Cache** — camada rápida que guarda dados para leitura futura. Ver [[Cache e Redis]].
- **[[Teorema CAP e Sistemas Distribuidos|CAP]]** — teorema: em partição, escolha entre Consistência e Disponibilidade.
- **[[Clean Architecture]]** — arquitetura com regras de negócio isoladas de detalhes.
- **[[Clean Code]]** — código legível e fácil de manter.
- **Coesão** — o quanto os elementos de um módulo pertencem juntos; quer-se **alta**. Ver [[Coesao e Acoplamento]].
- **[[Code Smells|Code smell]]** — sinal no código de um problema de design mais profundo.
- **Commit** — snapshot no [[Git - Fundamentos|Git]]; ou efetivação de uma transação.
- **Consistência Eventual** — réplicas convergem com o tempo. Ver [[Teorema CAP e Sistemas Distribuidos]].
- **Container** — empacotamento de app + dependências isolado. Ver [[Docker - Fundamentals]].
- **[[Event-Driven, CQRS e Event Sourcing|CQRS]]** — separar modelos de leitura e escrita.

## D

- **[[Domain-Driven Design (DDD)|DDD]]** — modelar o software conforme o domínio de negócio.
- **Deploy** — colocar software em produção. Ver [[CI-CD - Integracao e Entrega Continua]].
- **[[DevOps - Cultura e Praticas|DevOps]]** — integração e automação de Dev + Ops.
- **DLQ (Dead Letter Queue)** — fila para mensagens que falham. Ver [[Padroes de Mensageria e Garantias de Entrega]].
- **[[DRY, KISS e YAGNI|DRY]]** — Don't Repeat Yourself.
- **Dívida Técnica** — custo futuro de atalhos tomados hoje.

## E

- **Embedding** — representação vetorial de dados (base de [[RAG - Retrieval-Augmented Generation|RAG]]).
- **Encapsulamento** — esconder estado interno atrás de interface. Ver [[Orientacao a Objetos]].
- **Endpoint** — URL/rota de uma [[APIs REST - Fundamentos e Design|API]].
- **Event Sourcing** — guardar o estado como sequência de eventos. Ver [[Event-Driven, CQRS e Event Sourcing]].
- **Exactly-once / At-least-once** — garantias de entrega. Ver [[Padroes de Mensageria e Garantias de Entrega]].

## F–G

- **Fine-tuning** — ajustar um [[LLMs - Fundamentos|LLM]] a um comportamento/estilo.
- **[[Git - Fundamentos|Git]]** — sistema de controle de versão distribuído.
- **[[GraphQL]]** — linguagem de consulta para APIs (cliente escolhe os dados).
- **[[gRPC]]** — framework RPC de alto desempenho (HTTP/2 + Protobuf).

## H–I

- **HATEOAS** — hipermídia como motor de estado em REST. Ver [[APIs REST - Fundamentos e Design]].
- **Hashing** — função unidirecional (integridade/senhas). Ver [[Criptografia - Hashing, Encryption e Senhas]].
- **[[Hexagonal Architecture|Hexagonal]]** — arquitetura de ports & adapters.
- **Idempotência** — repetir a operação tem o mesmo efeito de fazê-la uma vez.
- **Índice** — estrutura que acelera busca no banco. Ver [[Indices e Otimizacao de Queries]].
- **Injeção de Dependência** — fornecer dependências de fora (base do [[SOLID Principles|DIP]]).

## J–K–L

- **[[JWT (JSON Web Token)|JWT]]** — token assinado que carrega claims.
- **[[Apache Kafka|Kafka]]** — plataforma de event streaming baseada em log.
- **[[Kubernetes]]** — orquestrador de containers.
- **Latência** — tempo de resposta. Ver [[21 - PERFORMANCE/_INDEX|Performance]].
- **[[LLMs - Fundamentos|LLM]]** — Large Language Model.

## M

- **[[MCP - Model Context Protocol|MCP]]** — padrão para conectar IA a ferramentas/dados.
- **[[Mensageria - Fundamentos|Mensageria]]** — comunicação assíncrona por mensagens.
- **[[Microsservicos|Microsserviço]]** — serviço pequeno, independente, por capacidade de negócio.
- **Middleware** — software entre camadas (processa requests, integra sistemas).
- **Monolito** — aplicação única e coesa. Ver [[Arquitetura de Software - Fundamentos]].

## N–O

- **Normalização** — organizar tabelas para reduzir redundância. Ver [[Modelagem de Dados e Normalizacao]].
- **[[SQL vs NoSQL|NoSQL]]** — bancos não relacionais.
- **[[OAuth 2.0 e OpenID Connect|OAuth]]** — padrão de delegação de acesso (autorização).
- **Observabilidade** — entender o estado do sistema pela telemetria. Ver [[Observabilidade]].
- **[[Orientacao a Objetos|OOP]]** — paradigma baseado em objetos.
- **OpenAPI** — padrão de descrição de APIs REST. Ver [[APIs REST - Fundamentos e Design]].
- **[[OWASP Top 10|OWASP]]** — projeto/lista dos riscos de segurança web.

## P

- **Paginação** — dividir coleções em páginas. Ver [[Boas Praticas de API]].
- **[[Paradigmas de Programacao|Paradigma]]** — forma de estruturar programas (imperativo, funcional…).
- **Partição** — divisão de dados/tópicos (sharding; ordem por partição no [[Apache Kafka|Kafka]]).
- **Polimorfismo** — mesmo contrato, comportamentos diferentes. Ver [[Orientacao a Objetos]].
- **[[Prompt Engineering|Prompt]]** — instrução dada a um modelo de IA.
- **Pub/Sub** — publicar/assinar eventos. Ver [[Mensageria - Fundamentos]].

## Q–R

- **[[RAG - Retrieval-Augmented Generation|RAG]]** — recuperar dados externos para fundamentar a geração.
- **[[APIs REST - Fundamentos e Design|REST]]** — estilo arquitetural de APIs sobre HTTP.
- **[[Refatoracao|Refatoração]]** — reestruturar código sem mudar o comportamento.
- **Rollback** — desfazer uma operação/deploy.

## S

- **Saga** — transação distribuída por passos compensáveis. Ver [[Padroes de Mensageria e Garantias de Entrega]].
- **[[SDLC - Ciclo de Vida do Software|SDLC]]** — ciclo de vida do software.
- **Sharding** — particionar dados horizontalmente. Ver [[Teorema CAP e Sistemas Distribuidos]].
- **[[SOLID Principles|SOLID]]** — 5 princípios de design OO.
- **[[Testes - Fundamentos e Piramide|SRE]]** / SLO / SLA — confiabilidade e níveis de serviço. Ver [[Observabilidade]].
- **Stateless** — sem estado guardado entre requisições. Ver [[APIs REST - Fundamentos e Design]].
- **[[SWEBOK - Corpo de Conhecimento|SWEBOK]]** — corpo de conhecimento da engenharia de software.

## T–U

- **[[TDD - Test-Driven Development|TDD]]** — desenvolvimento guiado por testes.
- **[[Redes - TCP-IP, HTTP, DNS e TLS|TLS]]** — criptografia em trânsito (HTTPS).
- **Token** — unidade de texto de um [[LLMs - Fundamentos|LLM]]; ou credencial de acesso ([[JWT (JSON Web Token)|JWT]]).
- **Transação** — unidade atômica de trabalho no banco. Ver [[Transacoes e ACID]].
- **Ubiquitous Language** — linguagem comum no [[Domain-Driven Design (DDD)|DDD]].

## V–Y

- **Value Object** — objeto imutável definido por seus valores ([[Domain-Driven Design (DDD)|DDD]]).
- **Versionamento** — de código ([[Git - Fundamentos|Git]]) ou de [[Boas Praticas de API|API]].
- **[[DRY, KISS e YAGNI|YAGNI]]** — You Aren't Gonna Need It.

## Conceitos relacionados

- [[Glossario - Siglas e Acronimos]]
- [[00 - INDEX]]

## Fontes

1. ISO/IEC/IEEE 24765 — Systems and Software Engineering — Vocabulary.
2. [[SWEBOK - Corpo de Conhecimento|SWEBOK Guide]] (IEEE Computer Society) — glossário.
3. Notas desta Knowledge Base (definições resumidas).

## Observações

Glossário vivo: adicionar termos conforme novas notas surgem e linkar. Status: verified.
