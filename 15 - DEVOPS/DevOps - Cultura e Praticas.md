---
title: "DevOps - Cultura e Práticas"
category: "15 - DEVOPS"
tags:
  - engenharia-software
  - devops
  - infraestrutura
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# DevOps — Cultura e Práticas

## Resumo

**DevOps** é a **integração e automação** do desenvolvimento de software (Dev) com as operações de TI (Ops). Combina **mudança cultural, práticas e ferramentas** para reduzir o tempo entre commitar uma mudança e colocá-la em produção — mantendo alta qualidade.

## O que é?

Definição acadêmica (Bass, Weber, Zhu): "um conjunto de práticas destinadas a reduzir o tempo entre commitar uma mudança e ela estar em produção normal, garantindo alta qualidade". É a interseção de **Desenvolvimento + Operações + QA**.

Três princípios-chave:
1. **Shared ownership** (responsabilidade compartilhada) — quebra o silo Dev × Ops.
2. **Workflow automation** — automatizar build, teste, deploy, infra.
3. **Rapid feedback** — detectar problemas cedo ("bring the pain forward").

## Por que existe?

Historicamente, Dev e Ops eram silos com objetivos conflitantes (Dev quer mudança; Ops quer estabilidade). DevOps alinha os dois com automação e cultura, acelerando entregas **sem** sacrificar confiabilidade.

- Marco: primeira **DevOpsDays** (Ghent, 2009, Patrick Debois).

## Como funciona? — Práticas centrais

- **[[CI-CD - Integracao e Entrega Continua|CI/CD]]** — integração e entrega/deploy contínuos.
- **Infraestrutura como Código (IaC)** — Terraform, Ansible, CloudFormation (infra versionada e reproduzível).
- **Containers e orquestração** — [[Docker - Fundamentals|Docker]], [[Kubernetes]].
- **[[Observabilidade|Observabilidade]]** — logs, métricas, tracing.
- **Continuous testing / monitoring**.

### Métricas DORA (2016)
Indicadores de desempenho de entrega (State of DevOps):
- **Throughput:** *Deployment Frequency*, *Lead Time for Changes*.
- **Estabilidade:** *Mean Time to Recover (MTTR)*, *Change Failure Rate*.

## Conceitos fundamentais

- **Pipeline** — esteira automatizada build → test → deploy.
- **IaC** — infra declarativa e versionada.
- **Shift-left** — mover testes/segurança para o início.
- **SRE** — abordagem do Google que aplica engenharia às operações (SLOs, error budgets); relacionada, não idêntica.
- **DevSecOps** — segurança integrada ao pipeline.

## Exemplo prático (IaC + pipeline)

```yaml
# GitHub Actions: pipeline mínimo de CI
name: ci
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: pip install -r requirements.txt
      - run: pytest -q          # falha o build se testes quebram
```

## Quando utilizar

- Praticamente qualquer time que entrega software com frequência.
- Essencial para [[Microsservicos|microsserviços]] e cloud-native.

## Quando NÃO utilizar (nuance)

- Não é "contratar um DevOps": é **cultura + prática**, não um cargo isolado.
- Automação sem cultura de responsabilidade compartilhada rende pouco.

## Trade-offs

- Investimento inicial em automação/ferramentas **vs.** entregas mais rápidas e confiáveis.
- Complexidade de tooling pode crescer (precisa de curadoria).

## Erros comuns / Anti-patterns

- Tratar DevOps como um **silo/cargo** ("time de DevOps" separado que vira novo gargalo).
- Automatizar deploy sem testes/observabilidade.
- Perseguir métricas DORA como vaidade, sem mudança cultural.

## Boas práticas

- Automatize build/test/deploy e **infra (IaC)**.
- Meça com **DORA**; use feedback para melhorar.
- Responsabilidade compartilhada: "you build it, you run it".
- Segurança no pipeline (DevSecOps).

## Conceitos relacionados

- [[CI-CD - Integracao e Entrega Continua]]
- [[Docker - Fundamentals]]
- [[Kubernetes]]
- [[Observabilidade]]
- [[14 - COMPUTACAO EM NUVEM/_INDEX|Computação em Nuvem]]

## Perguntas importantes

### DevOps é um cargo?
Não. É cultura + práticas + ferramentas que unem Dev e Ops. "Time de DevOps" isolado costuma ser anti-pattern.

### O que são as métricas DORA?
Quatro indicadores: Deployment Frequency, Lead Time for Changes, MTTR e Change Failure Rate — medem velocidade e estabilidade da entrega.

## Fontes

1. Wikipedia — DevOps — https://en.wikipedia.org/wiki/DevOps (consultado 2026-09-03)
2. Kim, Humble, Debois, Willis — *The DevOps Handbook.*
3. Forsgren, Humble, Kim — *Accelerate* (métricas DORA).

## Observações

Aprofundar: IaC (Terraform), SRE (SLO/error budget), DevSecOps em notas próprias. Status: verified.
