---
title: "Diagnóstico em Produção e Postmortems"
category: "42 - TROUBLESHOOTING"
tags:
  - engenharia-software
  - troubleshooting
  - sre
  - incidentes
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Diagnóstico em Produção e Postmortems

## Resumo

Diagnosticar problemas **em produção** é diferente de debugar localmente: você não anexa um debugger, precisa restaurar o serviço rápido e depende de **[[Observabilidade|observabilidade]]** (logs, métricas, traces). Depois, um **postmortem sem culpa (blameless)** captura a causa-raiz e as ações para não repetir.

## O que muda em produção?

- **Não dá para pausar/anexar debugger** → depende de telemetria já existente.
- **Pressão de tempo** → prioridade é **mitigar** (restaurar o serviço), depois investigar a fundo.
- **Dados reais e escala** → bugs que não aparecem localmente.
- **Impacto no usuário/negócio** → comunicação importa.

## Resposta a Incidentes

### Prioridade: mitigar primeiro
Restaurar o serviço vem **antes** de achar a causa-raiz. Táticas de mitigação rápida:
- **Rollback** do deploy recente ("what changed?" — a causa mais comum).
- **Feature flag** off; **failover**; escalar recursos; reiniciar.

### Papéis (em incidentes maiores)
- **Incident Commander** — coordena.
- **Communications** — atualiza stakeholders.
- **Ops/Responders** — investigam e mitigam.

### Severidade (SEV)
Classificar (SEV1 crítico … SEV3 menor) define urgência e quem é acionado.

## Diagnóstico com observabilidade

Usar os pilares ([[Observabilidade]]):
- **Métricas** → o quê e quando (picos, saturação, taxa de erro). Método **USE** (Utilization, Saturation, Errors) e **RED** (Rate, Errors, Duration).
- **Logs** → detalhes do erro.
- **Traces** → onde na cadeia de serviços está o gargalo/falha ([[Microsservicos]]).
- Correlacionar os três acelera o diagnóstico.

## Postmortem (retrospectiva de incidente)

Documento após o incidente com: **linha do tempo, impacto, causa-raiz, o que funcionou/não, ações corretivas**.

### Blameless (sem culpa)
Foco em **processos e sistemas**, não em punir pessoas. Cultura blameless (Google SRE) faz as pessoas relatarem erros honestamente → o sistema melhora. Culpar → as pessoas escondem → repete.

### Causa-raiz
Técnicas: **5 Whys**, diagrama de Ishikawa. Buscar a causa **sistêmica** (por que o processo permitiu o erro?), não parar em "fulano errou".

## SLO / Error Budget

[[Observabilidade|SLOs]] definem o nível de confiabilidade alvo; o **error budget** (o quanto se pode falhar) orienta quando priorizar confiabilidade vs features. Consumo do budget dispara ação.

## Exemplo (linha do tempo de incidente)

```
13:55 deploy v2.3
14:02 alerta: taxa de erro 5xx > 5% (SLO violado)
14:05 IC declara SEV2; hipótese: deploy recente
14:08 rollback para v2.2 (mitigação) → erros caem
14:30 investigação: migração incompatível (causa-raiz)
Postmortem: ação = migrações compatíveis + gate no CI
```
Note: **mitigou (rollback) antes** de achar a causa-raiz.

## Quando aplicar

- Qualquer falha em produção. Postmortem para incidentes relevantes (SEV alto) — e também para "quase-incidentes".

## Erros comuns / Anti-patterns

- Investigar causa-raiz **antes** de mitigar (serviço fica fora mais tempo).
- **Postmortem com culpa** → medo, ocultação, repetição.
- Sem observabilidade → "debugar no escuro" em produção.
- Não gerar **ações corretivas** rastreáveis (postmortem vira teatro).
- Ignorar "o que mudou" (deploy/config recentes).

## Boas práticas

- **Mitigar → depois diagnosticar.** Rollback fácil e rápido.
- **Observabilidade antes do incidente** (logs/métricas/traces, alertas por sintoma).
- **Postmortem blameless** com ações corretivas acompanhadas.
- SLO/error budget para priorizar confiabilidade.
- Runbooks para incidentes conhecidos.

## Conceitos relacionados

- [[Troubleshooting - Metodo e Fundamentos]]
- [[Tecnicas de Debugging]]
- [[Catalogo de Problemas Comuns]]
- [[Observabilidade]] · [[DevOps - Cultura e Praticas]] · [[CI-CD - Integracao e Entrega Continua]]

## Perguntas importantes

### O que fazer primeiro em um incidente de produção?
**Mitigar** (restaurar o serviço) — normalmente rollback do que mudou. A investigação da causa-raiz vem **depois** que o impacto ao usuário cessou.

### O que é um postmortem blameless?
Uma análise de incidente focada em **sistemas e processos** (não em culpar pessoas), para extrair a causa-raiz e ações preventivas — criando cultura de aprendizado.

## Fontes

1. Google — *Site Reliability Engineering* / *SRE Workbook* (postmortem culture, error budgets) — https://sre.google/books/
2. Wikipedia — Troubleshooting / Debugging (consultados 2026-09-03).
3. Nygard, M. — *Release It!* (estabilidade em produção).

## Observações

Aprofundar: USE/RED, runbooks, chaos engineering, on-call. Status: verified.
