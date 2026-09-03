---
title: "Engenharia de Requisitos - Fundamentos"
category: "02 - ENGENHARIA DE REQUISITOS"
tags:
  - engenharia-software
  - requisitos
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Engenharia de Requisitos — Fundamentos

## Resumo

**Engenharia de Requisitos (ER)** é o processo de **descobrir, analisar, documentar, validar e gerenciar** o que um sistema deve fazer e como deve ser. É a base de todo o resto: requisitos errados levam a construir "a coisa errada", o defeito mais caro de corrigir.

## O que é?

Conjunto de atividades para transformar necessidades de stakeholders em requisitos claros e acordados. No modelo cascata é a **primeira fase**; em métodos iterativos (RUP, ágil) **continua por toda a vida** do sistema. Relaciona-se com Systems Engineering (INCOSE).

## Tipos de requisito

- **Funcionais (FR)** — o que o sistema **deve fazer** ("o sistema deve permitir cancelar um pedido"). Comportamentos/funções.
- **Não Funcionais (NFR)** — como o sistema **deve ser** (desempenho, segurança, usabilidade). "Quality attributes". Ver [[Requisitos Nao Funcionais]].
- **Restrições (constraints)** — limites impostos (tecnologia, orçamento, legislação, prazo).
- **Regras de negócio** — políticas do domínio que o sistema respeita.

## Por que existe?

- Requisitos são a **maior fonte de retrabalho** e falha de projetos. Corrigir um erro de requisito em produção custa ordens de grandeza mais que na especificação.
- Alinha stakeholders, dev e negócio sobre **o que** será construído.

## Como funciona? — As atividades da ER

1. **Elicitação (levantamento)** — descobrir necessidades com stakeholders. Ver [[Elicitacao de Requisitos]].
2. **Análise e negociação** — identificar, priorizar e **resolver conflitos** entre requisitos/stakeholders.
3. **Especificação** — documentar de forma clara (user stories, casos de uso, SRS). Ver [[User Stories, Casos de Uso e Criterios de Aceite]].
4. **Validação** — confirmar que os requisitos estão **corretos, completos e viáveis** (revisões, protótipos).
5. **Gestão de requisitos** — rastrear mudanças, versionar, manter **rastreabilidade** (requisito → design → código → teste).

## Conceitos fundamentais

- **Stakeholder** — qualquer pessoa com interesse no sistema (usuário, cliente, negócio, regulador).
- **Rastreabilidade** — ligar cada requisito às suas origens e às implementações/testes.
- **Priorização** — nem tudo cabe; técnicas como **MoSCoW** (Must/Should/Could/Won't).
- **Baseline** — conjunto de requisitos acordado e versionado.
- **Requisito vs necessidade** — o pedido do cliente nem sempre é a real necessidade (investigar o "porquê").

## Requisitos em Ágil vs Tradicional

- **Tradicional (cascata):** documento extenso de requisitos (SRS) aprovado antes de construir.
- **Ágil:** requisitos como **backlog** vivo de [[User Stories, Casos de Uso e Criterios de Aceite|user stories]], refinado continuamente; detalhamento just-in-time.

## Boas práticas

- Focar no **problema/necessidade**, não só na solução pedida.
- Priorizar (MoSCoW) e manter **rastreabilidade**.
- Validar cedo com protótipos ([[Elicitacao de Requisitos]]).
- Requisitos **testáveis** e sem ambiguidade.

## Erros comuns / Anti-patterns

- **Gold plating** — implementar além do pedido.
- **Scope creep** — escopo crescendo sem controle.
- Requisitos ambíguos/não testáveis ("o sistema deve ser rápido" — quão rápido?).
- Pular validação → construir a coisa errada.
- Ignorar NFRs até o fim (caro de adaptar).

## Conceitos relacionados

- [[Elicitacao de Requisitos]]
- [[User Stories, Casos de Uso e Criterios de Aceite]]
- [[Requisitos Nao Funcionais]]
- [[SDLC - Ciclo de Vida do Software]]
- [[03 - PROCESSOS E METODOLOGIAS/_INDEX|Processos e Metodologias]]

## Perguntas importantes

### Qual a diferença entre requisito funcional e não funcional?
Funcional = o que o sistema **faz** (comportamento). Não funcional = como o sistema **é** (qualidade: desempenho, segurança…). "Shall do" vs "shall be".

### Por que requisitos são tão importantes?
São a maior fonte de retrabalho e falha. Um erro de requisito descoberto tarde custa muito mais que um bug de código.

## Fontes

1. Wikipedia — Requirements engineering — https://en.wikipedia.org/wiki/Requirements_engineering (consultado 2026-09-03)
2. [[SWEBOK - Corpo de Conhecimento|SWEBOK]] — Software Requirements KA.
3. Sommerville, I. — *Software Engineering* (cap. Requisitos); IEEE 29148.

## Observações

Aprofundar: MoSCoW, rastreabilidade, SRS (IEEE 29148). Status: verified.
