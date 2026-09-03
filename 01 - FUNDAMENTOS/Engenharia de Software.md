---
title: "Engenharia de Software"
category: "01 - FUNDAMENTOS"
tags:
  - engenharia-software
  - fundamentos
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Engenharia de Software

## Resumo

Engenharia de Software é a **aplicação de uma abordagem sistemática, disciplinada e quantificável** ao desenvolvimento, operação e manutenção de software. É um ramo tanto da Ciência da Computação quanto da Engenharia, focado em produzir software confiável, eficiente e que atenda às necessidades dos usuários — de forma econômica e sustentável ao longo do tempo.

## O que é?

Definições notáveis (fontes primárias):

- **IEEE Standard Glossary of Software Engineering Terminology (IEEE 610.12)**: "A aplicação de uma abordagem sistemática, disciplinada e quantificável ao desenvolvimento, operação e manutenção de software."
- **Fritz Bauer (NATO, 1968)**: "O estabelecimento e uso de princípios sólidos de engenharia para obter economicamente software que seja confiável e funcione eficientemente em máquinas reais."
- **Ian Sommerville**: "Uma disciplina de engenharia preocupada com todos os aspectos da produção de software."
- **Software Engineering at Google**: software engineering é "programação integrada ao longo do tempo" — não apenas escrever código, mas todas as ferramentas e processos usados para construir e manter esse código com o passar do tempo.

Distingue-se de **programação** (escrever código) e de **ciência da computação** (teoria): engenharia de software é a *prática disciplinada* de produzir sistemas de software reais, em equipe, sob restrições de tempo, custo e qualidade.

## Por que existe?

Surgiu como resposta à **"crise do software"** dos anos 1960: projetos estouravam orçamento e prazo, exigiam manutenção e depuração extensas, não atendiam aos usuários ou nunca eram concluídos.

- O termo apareceu informalmente em 1965–1966 (ACM, carta de Anthony Oettinger) e foi formalizado pela **1ª Conferência da NATO sobre Engenharia de Software, em 1968** (organizada em torno do termo por Friedrich L. Bauer).
- **Margaret Hamilton** cunhou o uso do termo durante o programa Apollo para dar legitimidade à disciplina.
- Em **1984** criou-se o **Software Engineering Institute (SEI)** na Carnegie Mellon; Watts Humphrey criou o programa de processo que originou o **CMMI**.

O objetivo central é **domar a complexidade e a mudança**: software vive, evolui e precisa ser mantido por anos por múltiplas pessoas.

## Como funciona?

A prática se organiza em **atividades centrais** (que se repetem ao longo do [[SDLC - Ciclo de Vida do Software|ciclo de vida]]):

1. **Requisitos** — entender o que precisa ser construído
2. **Design/Projeto** — decidir como construir
3. **Construção (implementação)** — escrever o código
4. **Testes** — validar que funciona
5. **Implantação (deployment)** — colocar em produção
6. **Manutenção e operação** — sustentar e evoluir

Essas atividades são regidas por um **processo/metodologia** (ver [[SDLC - Ciclo de Vida do Software]]) e apoiadas por disciplinas como qualidade, segurança, gerência de configuração e gestão de projeto.

## Conceitos fundamentais

- **Processo de software** — como o trabalho é organizado (ver [[03 - PROCESSOS E METODOLOGIAS/_INDEX|Processos]])
- **Corpo de conhecimento** — o [[SWEBOK - Corpo de Conhecimento|SWEBOK]] cataloga as áreas
- **Qualidade** — corretude, confiabilidade, manutenibilidade, desempenho
- **Dívida técnica** — custo futuro de atalhos tomados hoje
- **Ciclo de vida** — do berço ao fim de vida do sistema

## Quando utilizar

Sempre que o software for **não-trivial**: mantido por tempo, por mais de uma pessoa, com requisitos que mudam, ou onde falhas têm custo. Quanto maior o sistema e a equipe, mais disciplina de engenharia paga o investimento.

## Quando NÃO utilizar (com peso reduzido)

Para **scripts descartáveis**, protótipos de vida curta ou provas de conceito individuais, aplicar todo o rigor de engenharia pode ser desperdício. Ainda assim, princípios básicos (versionamento, nomes claros) quase sempre compensam.

## Vantagens

- Sistemas mais confiáveis, manuteníveis e previsíveis
- Redução de retrabalho e de dívida técnica
- Escala para equipes e para o tempo

## Trade-offs

- Processo demais → burocracia e lentidão
- Processo de menos → caos e dívida técnica
- O equilíbrio depende de tamanho, criticidade e maturidade da equipe

## Erros comuns

- Confundir "engenharia de software" com "só programar"
- Ignorar manutenção (a maior parte do custo total do software é pós-entrega)
- Big design up front rígido em contexto de requisitos incertos

## Boas práticas

- Versionar tudo ([[Git - Fundamentos|Git]])
- Automatizar testes e integração ([[17 - TESTES/_INDEX|Testes]], [[16 - CI-CD/_INDEX|CI/CD]])
- Escrever código legível ([[31 - CLEAN CODE/_INDEX|Clean Code]]) e respeitar [[DRY, KISS e YAGNI|princípios]]
- Documentar decisões ([[45 - DECISOES ARQUITETURAIS/_INDEX|ADRs]])

## Conceitos relacionados

- [[SWEBOK - Corpo de Conhecimento]]
- [[SDLC - Ciclo de Vida do Software]]
- [[DRY, KISS e YAGNI]]
- [[Paradigmas de Programacao]]
- [[00 - INDEX]]

## Perguntas importantes

### Qual a diferença entre Engenharia de Software e Programação?
Programação é escrever código para resolver um problema. Engenharia de Software é o conjunto de disciplinas para produzir e **manter** software de qualidade em escala e ao longo do tempo — inclui processo, testes, arquitetura, colaboração e operação.

### Qual a diferença entre Engenharia de Software e Ciência da Computação?
Ciência da Computação estuda a *teoria* (algoritmos, computabilidade, complexidade). Engenharia de Software é a *prática disciplinada* de construir sistemas reais.

## Fontes

1. Wikipedia — Software engineering — https://en.wikipedia.org/wiki/Software_engineering (consultado 2026-09-03)
2. IEEE Std 610.12 / ISO/IEC/IEEE 24765 — Systems and software engineering — Vocabulary
3. SWEBOK Guide (IEEE Computer Society) — https://www.computer.org/education/bodies-of-knowledge/software-engineering
4. Winston W. Royce; Fritz Bauer (NATO Software Engineering Conference, 1968)

## Observações

Definições do IEEE 610.12 e ISO/IEC/IEEE 24765 citadas via Wikipedia; para citação acadêmica formal, validar na norma original (paga). Status: verified (multi-fonte para os fatos centrais).
