---
title: "Requisitos Não Funcionais"
category: "02 - ENGENHARIA DE REQUISITOS"
tags:
  - engenharia-software
  - requisitos
  - nfr
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Requisitos Não Funcionais (NFRs)

## Resumo

Um **Requisito Não Funcional (NFR)** define **como** o sistema deve ser (suas qualidades) — em contraste com os requisitos funcionais, que definem **o que** ele deve fazer. NFRs são frequentemente chamados de **"atributos de qualidade"** e são **arquiteturalmente significativos**: costumam determinar o sucesso ou o fracasso do projeto.

## O que é?

- **Funcional:** "o sistema **deve fazer** X" (comportamento). Ex.: "permitir login".
- **Não funcional:** "o sistema **deve ser** Y" (propriedade global). Ex.: "responder em < 200 ms para 95% das requisições".

Em [[Arquitetura de Software - Fundamentos|arquitetura]], NFRs são as **"architectural characteristics"** — moldam decisões estruturais (o plano de implementá-los está na **arquitetura**, não no design de uma função).

## Por que importam?

Propriedades emergentes do sistema (desempenho, segurança, disponibilidade) geralmente marcam a diferença entre projeto bem ou malsucedido. Um sistema pode ter todas as funções e ainda **falhar** por ser lento, inseguro ou indisponível. E NFRs são **caros de adaptar depois** — precisam ser considerados desde a arquitetura.

## Principais NFRs (alinhados ao [[Qualidade de Software - Fundamentos|ISO/IEC 25010]])

- **Performance** — latência, throughput. Ver [[Performance - Fundamentos]].
- **Escalabilidade** — crescer com a carga. Ver [[22 - ESCALABILIDADE/_INDEX]].
- **Disponibilidade / Confiabilidade** — uptime, tolerância a falhas (ex.: 99,9%).
- **Segurança** — confidencialidade, integridade, autenticação. Ver [[19 - SEGURANCA/_INDEX]].
- **Usabilidade / Acessibilidade** — facilidade de uso, WCAG.
- **Manutenibilidade** — facilidade de mudar/evoluir.
- **Portabilidade** — rodar em ambientes diferentes.
- **Observabilidade** — capacidade de diagnosticar. Ver [[Observabilidade]].
- **Compliance** — LGPD/GDPR, regulações.

(São as "**ilities**": scalabil**ity**, reliabil**ity**, maintainabil**ity**…)

## Como especificar bem — NFRs mensuráveis

NFR ruim é **vago**; bom é **mensurável e testável**:
```
❌ "O sistema deve ser rápido."
✅ "95% das requisições de busca devem responder em < 300 ms
   com até 1000 usuários simultâneos."

❌ "O sistema deve ser disponível."
✅ "Disponibilidade mensal ≥ 99,9% (downtime ≤ ~43 min/mês)."
```
Ligue NFRs a **SLIs/SLOs** ([[Observabilidade]]) e a **fitness functions** (testes automatizados de características arquiteturais).

## Quando definir

- **Cedo** — antes/durante o design arquitetural (são caros de adicionar depois).
- Revisar a cada mudança de escala/contexto.

## Trade-offs

NFRs **competem** entre si: mais segurança pode custar performance; mais consistência pode custar disponibilidade ([[Teorema CAP e Sistemas Distribuidos|CAP]]). A arquitetura **prioriza** conforme o domínio ("tudo é trade-off").

## Erros comuns / Anti-patterns

- NFRs **vagos**/não testáveis ("rápido", "seguro", "escalável").
- Ignorar NFRs até o fim → retrabalho arquitetural caro.
- Tratar todos os NFRs como igualmente críticos (não priorizar).
- Especificar sem forma de **medir/validar**.

## Boas práticas

- Escrever NFRs **quantificados e testáveis**.
- Priorizar pelos que importam ao domínio (bancário → segurança/consistência; streaming → disponibilidade/latência).
- Validar com testes de carga/segurança e **fitness functions** no [[CI-CD - Integracao e Entrega Continua|CI]].
- Considerá-los na [[Arquitetura de Software - Fundamentos|arquitetura]] desde o início.

## Conceitos relacionados

- [[Engenharia de Requisitos - Fundamentos]]
- [[Qualidade de Software - Fundamentos]] (ISO 25010)
- [[Arquitetura de Software - Fundamentos]]
- [[Performance - Fundamentos]] · [[19 - SEGURANCA/_INDEX]] · [[22 - ESCALABILIDADE/_INDEX]]

## Perguntas importantes

### Qual a diferença entre requisito funcional e não funcional?
Funcional = **o que** o sistema faz (uma função). Não funcional = **como** ele é (uma qualidade global: desempenho, segurança, disponibilidade…).

### Por que NFRs são "arquiteturalmente significativos"?
Porque moldam a estrutura do sistema e são caros de mudar depois. A arquitetura existe em grande parte para atender aos NFRs.

## Fontes

1. Wikipedia — Non-functional requirement — https://en.wikipedia.org/wiki/Non-functional_requirement (consultado 2026-09-03)
2. ISO/IEC 25010 — atributos de qualidade.
3. Richards & Ford — *Fundamentals of Software Architecture* (architectural characteristics).

## Observações

Aprofundar: SLI/SLO, fitness functions, priorização de atributos de qualidade. Status: verified.
