---
title: "SDLC - Ciclo de Vida do Software"
category: "01 - FUNDAMENTOS"
tags:
  - engenharia-software
  - fundamentos
  - sdlc
  - processos
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# SDLC — Ciclo de Vida do Software (Software Development Life Cycle)

## Resumo

O **SDLC** descreve as fases típicas pelas quais um sistema de software passa, do início ao fim de vida. Uma **metodologia** (Waterfall, Ágil, Espiral…) prescreve *como* a equipe conduz o sistema por essas fases. SDLC é o **"o quê"** (fases); metodologia é o **"como"**.

## O que é?

Conjunto de fases estruturadas para desenvolver e sustentar software de forma deliberada e metódica. Fases típicas:

1. **Requisitos** — levantar e especificar necessidades
2. **Análise/Design** — projetar arquitetura e componentes
3. **Implementação (construção)** — codificar
4. **Testes/Verificação** — validar qualidade
5. **Implantação (deployment)** — entregar em produção
6. **Manutenção/Operação** — corrigir, evoluir, sustentar

Padronizado internacionalmente pela **ISO/IEC/IEEE 12207** (processos de ciclo de vida de software).

## Por que existe?

Surgiu nos anos 1960 para desenvolver grandes sistemas de negócio de forma estruturada. A ideia central: conduzir o desenvolvimento de modo **deliberado, estruturado e metódico**, em vez de ad hoc. Reduz risco, torna o esforço previsível e gerenciável.

## Como funciona? — Principais modelos de processo

### Waterfall (Cascata) — sequencial
Fases executadas em ordem, cada uma concluída antes da próxima. Documentado por **Winston Royce (1970)** — ironicamente, o próprio Royce já alertava para os riscos da forma puramente sequencial.
- **Quando usar:** requisitos estáveis e bem compreendidos; projetos com forte necessidade regulatória/documental.
- **Trade-off:** rígido; mudanças tardias são caras (Big Design Up Front — BDUF).

### V-Model
Extensão do Waterfall que associa cada fase de desenvolvimento a um nível de teste correspondente.

### Iterativo e Incremental
Constrói o sistema em ciclos, refinando/expandindo a cada iteração (ex.: Rational Unified Process).
- **Quando usar:** requisitos evoluem; quer entregar valor cedo.

### Espiral (Spiral) — Boehm (1988)
Combina iteração com **análise de risco** explícita em cada volta.
- **Quando usar:** projetos grandes, caros e de alto risco.

### Ágil (Agile) — Scrum, XP, Kanban
Processos leves e adaptativos; uma *user story* pode passar por todas as fases do SDLC dentro de um sprint de ~2 semanas.
- **Quando usar:** requisitos mudam rápido; feedback contínuo é possível.
- **Trade-off:** exige disciplina de engenharia (testes automatizados, CI, refatoração) para não virar caos.

> Diferença-chave entre modelos: **grau de sequencialidade vs. iteração**. Ver detalhes em [[03 - PROCESSOS E METODOLOGIAS/_INDEX|Processos e Metodologias]].

## Conceitos fundamentais

- **Metodologia ≠ SDLC**: metodologia é um blueprint para conduzir o SDLC.
- **PLC vs SDLC**: o *Project Life Cycle* abrange todo o projeto; o SDLC foca em realizar os requisitos do produto (Taylor, 2004).
- **BDUF** (Big Design Up Front) vs. design emergente.

## Quando utilizar / Quando NÃO

- **Sequencial (Waterfall/V):** requisitos fixos, alta necessidade de documentação. Evitar quando requisitos são incertos.
- **Ágil/Iterativo:** incerteza, necessidade de feedback rápido. Evitar quando contrato/escopo são rígidos e imutáveis.

## Erros comuns

- Usar "SDLC" como sinônimo exclusivo de Waterfall.
- Adotar Ágil sem as práticas de suporte (CI, testes, refatoração) → dívida técnica.
- Pular a fase de manutenção no planejamento (é onde vai a maior parte do custo).

## Boas práticas

- Escolher o modelo pelo **contexto** (risco, estabilidade de requisitos, regulação), não por moda.
- Automatizar testes e integração desde cedo.
- Rastrear requisitos → design → testes.

## Conceitos relacionados

- [[Engenharia de Software]]
- [[SWEBOK - Corpo de Conhecimento]]
- [[03 - PROCESSOS E METODOLOGIAS/_INDEX|Processos e Metodologias (Scrum, XP, Kanban)]]

## Perguntas importantes

### Qual a diferença entre SDLC e metodologia?
SDLC = as fases (o quê). Metodologia = como conduzir essas fases (Waterfall, Scrum, Espiral…).

### Waterfall está "morto"?
Não; é adequado quando requisitos são estáveis e a documentação/regulação exige sequência. Mas para a maioria dos produtos modernos, modelos iterativos/ágeis reduzem risco de construir a coisa errada.

## Fontes

1. Wikipedia — Software development process — https://en.wikipedia.org/wiki/Software_development_process (consultado 2026-09-03)
2. ISO/IEC/IEEE 12207:2017 — Systems and software engineering — Software life cycle processes — https://www.iso.org/standard/63712.html
3. Royce, W. W. (1970). "Managing the Development of Large Software Systems."
4. Boehm, B. (1988). "A Spiral Model of Software Development and Enhancement." IEEE Computer.

## Observações

Detalhar cada metodologia (Scrum, XP, Kanban) em notas próprias na categoria 03. Status: verified para o mapa geral; papers de Royce/Boehm citados por referência canônica.
