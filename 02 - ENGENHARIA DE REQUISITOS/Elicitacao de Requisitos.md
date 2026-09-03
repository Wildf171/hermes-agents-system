---
title: "Elicitação de Requisitos"
category: "02 - ENGENHARIA DE REQUISITOS"
tags:
  - engenharia-software
  - requisitos
  - elicitacao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Elicitação de Requisitos

## Resumo

**Elicitação** (levantamento) é a atividade de **descobrir** as necessidades e restrições dos stakeholders para o sistema. Não é só "perguntar o que querem" — envolve investigar o problema real, pois stakeholders muitas vezes não sabem articular o que precisam.

## O que é?

Primeira atividade da [[Engenharia de Requisitos - Fundamentos|Engenharia de Requisitos]]: desenvolvedores/analistas e stakeholders se encontram e as necessidades são investigadas. O desafio central é o **conhecimento tácito** (o que as pessoas sabem mas não expressam) e requisitos **implícitos**.

## Por que é difícil?

- Stakeholders pedem **soluções**, não **problemas** (é preciso perguntar "por quê?").
- Necessidades **conflitantes** entre stakeholders.
- Requisitos **tácitos/óbvios demais** para serem ditos.
- Conhecimento espalhado por muitas pessoas/sistemas.

## Técnicas de elicitação

### Diretas (com pessoas)
- **Entrevistas** — estruturadas ou abertas; profundidade individual.
- **Workshops / JAD** — reunir stakeholders para acordar requisitos rapidamente.
- **Brainstorming** — gerar ideias sem filtro inicial.
- **Questionários/surveys** — muitos stakeholders, respostas amplas.

### Observacionais
- **Observação / Etnografia** — observar o usuário no trabalho real (revela o tácito).
- **Shadowing** — acompanhar um usuário no dia a dia.

### Baseadas em artefatos
- **Análise de documentos** — processos, sistemas legados, normas.
- **Prototipação** — mostrar um protótipo para obter feedback concreto (ótimo para o que é difícil de verbalizar).
- **Análise de sistemas existentes/concorrentes**.

### Colaborativas/ágeis
- **Histórias de usuário** em conversas ([[User Stories, Casos de Uso e Criterios de Aceite]]).
- **Event Storming** — explorar o domínio por eventos (liga a [[Domain-Driven Design (DDD)|DDD]]).

## Como escolher a técnica

- Poucos especialistas, tema profundo → **entrevistas**.
- Muitos stakeholders, alinhar rápido → **workshop**.
- Requisito difícil de verbalizar → **observação** + **protótipo**.
- Domínio complexo → **event storming**.
Combine várias — nenhuma técnica sozinha captura tudo.

## Exemplo prático

```
Cliente: "Quero um botão de exportar relatório em PDF."
Analista (investiga o porquê): "O que você faz com o PDF?"
Cliente: "Envio por e-mail ao contador toda sexta."
→ Necessidade real: enviar o relatório ao contador semanalmente.
→ Solução melhor: envio automático agendado (não só um botão).
```
Elicitar o **problema**, não apenas transcrever o pedido.

## Quando utilizar

- Início de projeto e continuamente (ágil): o entendimento evolui.
- Sempre que houver nova feature/mudança de escopo.

## Erros comuns / Anti-patterns

- Transcrever o pedido sem entender a necessidade (o "botão exportar").
- Ouvir só um stakeholder (viés).
- Confiar só em entrevista (o tácito escapa) — faltam observação/protótipo.
- Não registrar/validar o que foi elicitado.

## Boas práticas

- Perguntar **"por quê"** (5 Whys); focar no problema.
- Triangular: múltiplas técnicas e stakeholders.
- Validar com **protótipos** e exemplos concretos.
- Registrar e confirmar (evitar mal-entendidos).

## Conceitos relacionados

- [[Engenharia de Requisitos - Fundamentos]]
- [[User Stories, Casos de Uso e Criterios de Aceite]]
- [[Requisitos Nao Funcionais]]
- [[Domain-Driven Design (DDD)]] (ubiquitous language, event storming)

## Perguntas importantes

### Por que não basta perguntar o que o cliente quer?
Porque clientes pedem soluções e têm conhecimento tácito. É preciso investigar o **problema/necessidade** real — senão constrói-se a coisa certa para o problema errado.

### Qual a melhor técnica de elicitação?
Não há uma só; combine entrevistas, workshops, observação e prototipação conforme o contexto (nº de stakeholders, profundidade, quão tácito é o conhecimento).

## Fontes

1. Wikipedia — Requirements elicitation / Requirements engineering — https://en.wikipedia.org/wiki/Requirements_engineering (consultado 2026-09-03)
2. [[SWEBOK - Corpo de Conhecimento|SWEBOK]] — Software Requirements KA.
3. BABOK (IIBA) — técnicas de análise de negócio.

## Observações

Aprofundar: Event Storming, 5 Whys, JAD, personas. Status: verified.
