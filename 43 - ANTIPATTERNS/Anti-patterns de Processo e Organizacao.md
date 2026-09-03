---
title: "Anti-patterns de Processo e Organização"
category: "43 - ANTIPATTERNS"
tags:
  - engenharia-software
  - antipatterns
  - processos
  - gestao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Anti-patterns de Processo e Organização

## Resumo

Nem todo anti-pattern está no código: muitos vivem em **como o time trabalha e a organização se estrutura**. O livro *AntiPatterns* (1998) já estendia o conceito à **gestão de projetos**; autores posteriores incluíram anti-patterns **organizacionais e culturais**. Reconhecê-los melhora [[03 - PROCESSOS E METODOLOGIAS/_INDEX|processo]] e entrega.

## Anti-patterns de Gestão de Projetos (livro AntiPatterns)

- **Analysis Paralysis** — analisar/planejar sem fim, sem produzir. (excesso de design up-front)
- **Death by Planning** — esforço excessivo em planejamento detalhado que a realidade invalida.
- **Viewgraph Engineering** — tempo demais em apresentações/slides, de menos no software.
- **Fear of Success** — medos irracionais perto de concluir o projeto.
- **Smoke and Mirrors** — demos/protótipos usados para aparentar prontidão que não existe.
- **Throw It Over the Wall** — jogar decisões/artefatos para a próxima equipe sem colaboração (silos Dev↔Ops — origem do [[DevOps - Cultura e Praticas|DevOps]]).
- **Irrational Management** — maus hábitos de gestão; decisões sem base.

## Anti-patterns de Processo / Times

- **Scrum-but / Cargo Cult Agile** — seguir os rituais do ágil sem os princípios ("fazemos Scrum, mas...").
- **Water-Scrum-Fall** — ágil no meio, cascata rígida no início e no fim.
- **Hero Culture / Firefighting** — depender de "heróis" que salvam o dia; recompensar apagar incêndios em vez de preveni-los.
- **Bikeshedding (Lei da Trivialidade)** — gastar tempo desproporcional em detalhes triviais e pouco no que importa.
- **Not Invented Here (NIH)** — reconstruir tudo internamente por rejeitar soluções externas.
- **Bus Factor baixo** — conhecimento concentrado em uma pessoa (risco se ela sai).
- **Design by Committee** — decisões diluídas por consenso de muitos → resultado incoerente.

## Anti-patterns Organizacionais

- **Silos** — áreas que não colaboram nem compartilham informação.
- **Lei de Conway (mal gerida)** — o software espelha a comunicação da organização; estruturas de time ruins produzem arquiteturas ruins. (Usada bem, vira "**Inverse Conway Maneuver**": organizar times para obter a arquitetura desejada.)
- **Micromanagement** — gestão que sufoca autonomia e velocidade.

## Por que importam

Problemas de processo/organização costumam ter **impacto maior** que os de código: minam entrega, moral e qualidade de forma sistêmica — e muitas vezes **causam** os anti-patterns técnicos (pressão → [[Anti-patterns de Arquitetura e Design|Big Ball of Mud]]).

## Como evitar / mitigar

- **DevOps** e responsabilidade compartilhada (contra "throw over the wall").
- Ágil de verdade: princípios sobre rituais; entregar valor iterativo.
- **Documentar decisões** ([[45 - DECISOES ARQUITETURAIS/_INDEX|ADRs]]) e compartilhar conhecimento (elevar o bus factor).
- Foco no que importa (evitar bikeshedding); prevenção sobre heroísmo.
- Estruturar times pensando na arquitetura desejada (Inverse Conway).

## Erros comuns (meta)

- Copiar rituais ágeis sem entender o porquê (cargo cult).
- Recompensar heróis em vez de sistemas robustos.
- Ignorar a Lei de Conway ao desenhar times e serviços.

## Conceitos relacionados

- [[Anti-patterns - Fundamentos]]
- [[03 - PROCESSOS E METODOLOGIAS/_INDEX|Processos e Metodologias]]
- [[DevOps - Cultura e Praticas]]
- [[Anti-patterns de Arquitetura e Design]]
- [[SDLC - Ciclo de Vida do Software]]

## Perguntas importantes

### O que é a Lei de Conway?
"Organizações projetam sistemas que espelham sua própria estrutura de comunicação." Times mal estruturados tendem a produzir arquiteturas mal estruturadas; a *Inverse Conway Maneuver* usa isso a favor, moldando times para obter a arquitetura desejada.

### O que é "Cargo Cult Agile"?
Adotar os **rituais** do ágil (stand-ups, sprints) sem os **princípios** (feedback, adaptação, entrega de valor) — a aparência sem a substância.

## Fontes

1. Wikipedia — Anti-pattern (project management) — https://en.wikipedia.org/wiki/Anti-pattern (consultado 2026-09-03)
2. Brown et al. (1998). *AntiPatterns.*
3. Conway, M. (1968) — "How Do Committees Invent?" (Lei de Conway).

## Observações

Criar notas próprias: Lei de Conway, Cargo Cult Agile, Bus Factor. Status: verified.
