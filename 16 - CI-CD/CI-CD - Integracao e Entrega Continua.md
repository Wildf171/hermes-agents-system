---
title: "CI/CD - Integração e Entrega Contínua"
category: "16 - CI-CD"
tags:
  - engenharia-software
  - ci-cd
  - devops
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# CI/CD — Integração e Entrega Contínua

## Resumo

**CI/CD** combina **Integração Contínua (CI)** e **Entrega/Implantação Contínua (CD)**: práticas que automatizam **build, teste e deploy**, permitindo entregar mudanças pequenas com frequência e segurança. É a **espinha dorsal** do [[DevOps - Cultura e Praticas|DevOps]].

## O que é? — Os componentes

- **Continuous Integration (CI):** integrar (merge) mudanças pequenas na **branch principal com frequência**, disparando build + testes automáticos a cada commit. Objetivo: descobrir defeitos cedo.
- **Continuous Delivery (CD):** produzir software em ciclos curtos de modo que uma versão confiável possa ser **liberada a qualquer momento** — o deploy final é uma **decisão manual**, mas o processo é automático e repetível.
- **Continuous Deployment (CD):** vai além — **todo** commit que passa nos testes é **implantado automaticamente** em produção.

Quando os três ocorrem em ordem, formam um **pipeline CI/CD**.

## Por que existe?

Substitui a integração "big bang" (juntar muitas mudanças de uma vez, dolorosa) por fluxo contínuo. Reduz risco por lote pequeno, acelera feedback e libera releases com mais frequência e confiança.

## Como funciona? — Pipeline típico

```
commit → [Build] → [Testes unit/integração] → [Análise estática/segurança]
        → [Empacotar/artefato/imagem] → [Deploy staging] → [Testes E2E]
        → (aprovação) → [Deploy produção] → [Monitorar]
```

Cada etapa que falha **para o pipeline** (fail fast). Depende de [[Git - Fundamentos|Git]] (dispara por push/PR) e de uma boa suíte de [[Testes - Fundamentos e Piramide|testes]].

## Conceitos fundamentais

- **Pipeline as code** — pipeline versionado no repositório.
- **Artefato** — resultado do build (imagem Docker, pacote) promovido entre ambientes.
- **Ambientes** — dev → staging → produção.
- **Estratégias de deploy** — blue-green, canary, rolling (reduzem risco/downtime).
- **Rollback** — reverter rápido quando algo falha.

## Exemplo prático

```yaml
# GitHub Actions: CI + build de imagem
name: pipeline
on: { push: { branches: [main] } }
jobs:
  build-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: pip install -r requirements.txt
      - run: pytest -q                 # CI: falha impede o merge/deploy
      - run: docker build -t api:${{ github.sha }} .
```

## Quando utilizar

- **Sempre** que houver testes automatizados e deploy frequente.
- Essencial para [[Microsservicos|microsserviços]] e cloud-native.

## Quando NÃO utilizar (nuance)

- **Continuous Deployment** (automático em produção) exige testes maduros e observabilidade; sem isso, prefira Continuous **Delivery** (com aprovação).

## Trade-offs

- Investir em automação/testes **vs.** releases rápidas, seguras e frequentes.
- Pipeline lento vira gargalo — precisa ser rápido para dar feedback útil.

## Erros comuns / Anti-patterns

- Pipeline sem testes reais (só "build passou").
- Testes lentos/flaky que minam a confiança.
- Deploy manual/artesanal fora do pipeline (não reproduzível).
- Segredos hardcoded no pipeline (use secret manager).

## Boas práticas

- Commits pequenos e frequentes na main; branch de vida curta.
- Pipeline rápido e determinístico; fail fast.
- Deploy com canary/blue-green e **rollback** fácil.
- Medir com [[DevOps - Cultura e Praticas|métricas DORA]] (lead time, change failure rate).

## Conceitos relacionados

- [[DevOps - Cultura e Praticas]]
- [[Git - Fundamentos]]
- [[Testes - Fundamentos e Piramide]]
- [[Docker - Fundamentals]] / [[Kubernetes]]

## Perguntas importantes

### Qual a diferença entre Continuous Delivery e Continuous Deployment?
Em **Delivery**, o software fica sempre **pronto para liberar**, mas o deploy em produção é uma decisão manual. Em **Deployment**, todo commit aprovado vai **automaticamente** para produção.

### O que é CI, exatamente?
Integrar mudanças pequenas na branch principal com frequência, com build e testes automáticos a cada commit, para achar defeitos cedo.

## Fontes

1. Wikipedia — CI/CD — https://en.wikipedia.org/wiki/CI/CD (consultado 2026-09-03)
2. Humble, J. & Farley, D. — *Continuous Delivery* (2010).
3. Fowler, M. — "Continuous Integration" — https://martinfowler.com/articles/continuousIntegration.html

## Observações

Aprofundar: estratégias de deploy (canary/blue-green), pipeline as code por ferramenta (GitHub Actions/GitLab). Status: verified.
