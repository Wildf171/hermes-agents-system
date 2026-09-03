---
title: "Observabilidade"
category: "20 - OBSERVABILIDADE"
tags:
  - engenharia-software
  - observabilidade
  - sre
  - infraestrutura
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Observabilidade

## Resumo

**Observabilidade** é a capacidade de **entender o estado interno de um sistema** a partir dos dados que ele produz — sem precisar enviar código novo para investigar. O termo vem da **teoria de controle** (quão bem se determina o estado a partir das saídas). É fundação de **SRE** e o primeiro passo para diagnosticar uma falha.

## O que é?

Medir quão bem se pode compreender **qualquer estado** em que o sistema entre — inclusive novos e inesperados — usando **telemetria**. Objetivo: **minimizar o conhecimento prévio** necessário para depurar um problema.

### Os "3 pilares" (+1)
- **Logs** — eventos discretos com contexto (o que aconteceu).
- **Métricas** — valores numéricos agregados no tempo (quanto/quantos).
- **Traces** — o caminho de uma requisição através de serviços (onde/por quê), essencial em [[Microsservicos|sistemas distribuídos]].
- **(+) Profiling** — uso de recursos por trecho de código.

## Por que existe?

Sistemas modernos (distribuídos, dinâmicos, [[14 - COMPUTACAO EM NUVEM/_INDEX|cloud]]) falham de formas imprevisíveis. **Monitoramento** clássico responde a perguntas **conhecidas** (dashboards prontos); **observabilidade** permite fazer perguntas **novas** sobre comportamentos não previstos — sem redeploy.

## Como funciona?

1. **Instrumentar** o código para emitir telemetria (logs estruturados, métricas, spans de trace).
2. **Coletar/agregar** em uma plataforma central.
3. **Correlacionar e analisar** (ex.: ligar um trace lento a um pico de métrica e a um log de erro).

### Padrão aberto: OpenTelemetry (OTel)
Projeto da CNCF que padroniza a **geração e coleta** de logs, métricas e traces — evita lock-in de fornecedor.

### Monitoramento vs Observabilidade
- **Monitoramento:** vigia sinais conhecidos, alerta quando saem do esperado.
- **Observabilidade:** capacidade de **explorar** propriedades/padrões **não definidos de antemão**.
(São complementares — observabilidade habilita monitoramento melhor.)

## Conceitos fundamentais

- **Telemetria** — dados emitidos (logs/métricas/traces).
- **SLI / SLO / SLA** — indicador / objetivo / acordo de nível de serviço (SRE).
- **Error budget** — margem de falha tolerada por um SLO.
- **Cardinalidade** — nº de séries distintas (alta cardinalidade custa caro em métricas).
- **Alerting** — acionar humanos com base em sintomas do usuário, não em ruído.

## Exemplo prático (stack comum)

- **Métricas:** Prometheus + Grafana.
- **Logs:** ELK/OpenSearch ou Loki.
- **Traces:** Jaeger/Tempo via **OpenTelemetry**.
- **APM/SaaS:** Datadog, New Relic, Honeycomb, Dynatrace.

## Quando utilizar

- Qualquer sistema em produção; **obrigatório** em [[Microsservicos|microsserviços]]/[[Kubernetes|K8s]].
- Diagnóstico de incidentes, performance e capacidade.

## Quando NÃO utilizar (nuance)

- Não é "coletar tudo": telemetria em excesso custa caro e vira ruído. Instrumente com propósito.

## Trade-offs

- Mais visibilidade **vs.** custo de armazenamento/processamento e overhead de instrumentação.
- Alta cardinalidade dá poder de investigação, mas encarece.

## Erros comuns / Anti-patterns

- Logs não estruturados (difíceis de consultar).
- Alertar em **causas** e ruído, não em **sintomas do usuário** (fadiga de alerta).
- Métricas sem traces → sabe-se "que está lento", não "onde".
- Instrumentação proprietária → lock-in (prefira OpenTelemetry).

## Boas práticas

- **Logs estruturados** (JSON) com correlação (trace/request id).
- Padronizar em **OpenTelemetry**.
- Definir **SLOs** e alertar por **error budget**/sintomas.
- Correlacionar os três pilares para acelerar o diagnóstico.

## Conceitos relacionados

- [[DevOps - Cultura e Praticas]]
- [[Microsservicos]]
- [[Kubernetes]]
- [[Teorema CAP e Sistemas Distribuidos]]
- [[21 - PERFORMANCE/_INDEX|Performance]]

## Perguntas importantes

### Qual a diferença entre monitoramento e observabilidade?
Monitoramento vigia **perguntas conhecidas** (dashboards/alertas pré-definidos). Observabilidade permite **fazer perguntas novas** sobre estados inesperados a partir da telemetria, sem redeploy.

### Quais são os pilares da observabilidade?
Logs, métricas e traces (frequentemente + profiling).

## Fontes

1. Wikipedia — Observability (software) — https://en.wikipedia.org/wiki/Observability_(software) (consultado 2026-09-03)
2. OpenTelemetry — https://opentelemetry.io/docs/
3. Google — *Site Reliability Engineering* (SRE book) — https://sre.google/books/

## Observações

Criar notas próprias: SLI/SLO/error budget, OpenTelemetry, Prometheus/Grafana. Status: verified.
