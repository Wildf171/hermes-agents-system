---
title: "Qualidade de Software - Fundamentos"
category: "18 - QUALIDADE DE SOFTWARE"
tags:
  - engenharia-software
  - qualidade
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Qualidade de Software — Fundamentos

## Resumo

**Qualidade de software** tem duas faces: **qualidade funcional** (o software faz o que deveria, conforme os requisitos) e **qualidade estrutural** (atende aos requisitos não funcionais — manutenibilidade, robustez, segurança). O padrão de referência para os atributos de qualidade é o **ISO/IEC 25010**.

## O que é?

- **Qualidade funcional** — conformidade com especificações/requisitos; "fitness for purpose" (produziu-se o software **correto**).
- **Qualidade estrutural** — quão bem atende NFRs que sustentam a entrega das funções (robustez, manutenibilidade). Avaliada muito por **análise estática** do código e da arquitetura.

Avaliação pode ser **estática** (revisar código/estrutura — ver [[Analise Estatica de Codigo]]) ou **dinâmica** (executar/testar — ver [[Testes - Fundamentos e Piramide]]).

## Modelo ISO/IEC 25010 (8 características de qualidade de produto)

1. **Functional Suitability** — completude, correção, adequação funcional.
2. **Performance Efficiency** — tempo, recursos, capacidade. Ver [[Performance - Fundamentos]].
3. **Compatibility** — coexistência e interoperabilidade.
4. **Usability** — facilidade de uso, acessibilidade.
5. **Reliability** — maturidade, disponibilidade, tolerância a falhas, recuperabilidade.
6. **Security** — confidencialidade, integridade, autenticidade. Ver [[19 - SEGURANCA/_INDEX]].
7. **Maintainability** — modularidade, reusabilidade, analisabilidade, modificabilidade, testabilidade.
8. **Portability** — adaptabilidade, instalabilidade.

(O 25010 substituiu o antigo **ISO/IEC 9126**; edições recentes acrescentam ainda *Safety*.)

## Por que existe?

"Qualidade" é vaga sem um modelo. O ISO 25010 dá **vocabulário e dimensões mensuráveis** para especificar, avaliar e comparar qualidade — em vez de "achismos".

## Como se garante qualidade?

- **Processo:** [[TDD - Test-Driven Development|TDD]], [[Code Review]], CI/CD com portões de qualidade.
- **Medição:** [[Metricas de Qualidade e Divida Tecnica|métricas]] e [[Analise Estatica de Codigo|análise estática]].
- **Práticas de código:** [[Clean Code]], [[SOLID Principles|SOLID]], [[Refatoracao|refatoração]] contínua.
- **Testes:** [[Testes - Fundamentos e Piramide|pirâmide de testes]], fitness functions.

## QA vs QC vs Testing

- **QA (Quality Assurance)** — o **processo** que previne defeitos (práticas, padrões).
- **QC (Quality Control)** — **verificar** o produto (inspeções, testes).
- **Testing** — uma técnica de QC (executar para achar defeitos).

## Quando priorizar (nuance)

- Nem toda característica importa igualmente: um MVP prioriza functional suitability; um sistema bancário prioriza security/reliability. **Especifique** os atributos que importam para o contexto.

## Erros comuns / Anti-patterns

- Tratar qualidade só como "ausência de bugs" (ignora manutenibilidade, segurança…).
- Qualidade como fase final ("testar no fim") em vez de embutida no processo.
- Perseguir métricas como fim em si (ex.: 100% cobertura) — ver [[Metricas de Qualidade e Divida Tecnica]].

## Boas práticas

- **Shift-left:** qualidade desde o início (design, testes, revisão).
- Definir atributos de qualidade (NFRs) explicitamente e medi-los.
- Automatizar verificação no [[CI-CD - Integracao e Entrega Continua|pipeline]].

## Conceitos relacionados

- [[Metricas de Qualidade e Divida Tecnica]]
- [[Code Review]]
- [[Analise Estatica de Codigo]]
- [[Testes - Fundamentos e Piramide]]
- [[Clean Code]] · [[SOLID Principles]]

## Perguntas importantes

### Qual a diferença entre qualidade funcional e estrutural?
Funcional = faz o que deveria (requisitos). Estrutural = como é por dentro (manutenibilidade, robustez, segurança — os NFRs).

### Qual o padrão de atributos de qualidade?
**ISO/IEC 25010** (8 características), que substituiu o ISO/IEC 9126.

## Fontes

1. Wikipedia — Software quality — https://en.wikipedia.org/wiki/Software_quality (consultado 2026-09-03)
2. ISO/IEC 25010 — System and software quality models — https://iso25000.com/index.php/en/iso-25000-standards/iso-25010
3. [[SWEBOK - Corpo de Conhecimento|SWEBOK]] — Software Quality KA.

## Observações

Confirmar edição vigente do ISO 25010 (revisão 2023) ao citar formalmente. Status: verified.
