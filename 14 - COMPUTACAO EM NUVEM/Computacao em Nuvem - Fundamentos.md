---
title: "Computação em Nuvem - Fundamentos"
category: "14 - COMPUTACAO EM NUVEM"
tags:
  - engenharia-software
  - cloud
  - infraestrutura
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Computação em Nuvem — Fundamentos

## Resumo

**Computação em nuvem** é, pela ISO, "um paradigma para acesso via rede a um **pool escalável e elástico** de recursos físicos ou virtuais compartilháveis, com **autoprovisionamento sob demanda**". Em vez de comprar e manter servidores, você **aluga** recursos de um provedor (AWS, Azure, GCP) e paga pelo uso.

## O que é? — 5 características essenciais (NIST, 2011)

1. **On-demand self-service** — provisiona recursos sozinho, sem interação humana.
2. **Broad network access** — acesso pela rede, de qualquer dispositivo.
3. **Resource pooling** — recursos compartilhados (multi-tenant).
4. **Rapid elasticity** — escala para cima/baixo rapidamente, parecendo "ilimitado".
5. **Measured service** — uso medido e cobrado (pay-as-you-go).

## Por que existe?

Elimina o **CapEx** (comprar hardware) em favor de **OpEx** (pagar pelo uso), acelera provisionamento (minutos vs. semanas), escala sob demanda e delega parte da operação ao provedor.

## Como funciona? — Modelos de serviço

| Modelo | Você gerencia | Provedor gerencia | Exemplo |
|---|---|---|---|
| **IaaS** | SO, apps, dados | Hardware, virtualização | AWS EC2, Azure VM |
| **PaaS** | Apps, dados | + SO, runtime | Heroku, App Engine |
| **SaaS** | Só uso | Tudo | Gmail, Salesforce |
| **FaaS/Serverless** | Só o código (funções) | Toda a infra e escala | AWS Lambda |

### Modelos de implantação
- **Público** (AWS/Azure/GCP), **Privado**, **Híbrido**, **Multi-cloud**.

### Conceitos cloud-native
- **Serverless** — sem gerenciar servidores; escala a zero.
- **Managed services** — banco, fila, cache gerenciados.
- **Regions/Availability Zones** — para alta disponibilidade e latência.
- **Auto-scaling** e **load balancing**.

## Exemplo prático

- App web: **VMs (IaaS)** ou containers em **Kubernetes gerenciado** (EKS/GKE/AKS) + **banco gerenciado** (RDS) + **object storage** (S3) + **CDN**.
- Processamento por evento: **Lambda (FaaS)** disparada por upload no S3.

## Quando utilizar

- Quase sempre para novas aplicações (velocidade, elasticidade, custo variável).
- Cargas variáveis/imprevisíveis (paga pelo pico só quando acontece).

## Quando NÃO utilizar (nuance)

- Cargas **constantes e previsíveis** de altíssimo volume podem sair mais caras que on-premises.
- Requisitos de **soberania de dados**/regulação podem exigir nuvem privada/local.
- Risco de **vendor lock-in**.

## Trade-offs

- **Ganha:** elasticidade, velocidade, menos CapEx, serviços gerenciados.
- **Perde:** custo pode escalar sem governança, lock-in, menos controle, complexidade de rede/segurança.

## Erros comuns / Anti-patterns

- **Lift-and-shift** ingênuo (mover monolito para VM sem repensar) → caro e sem ganho.
- Sem **FinOps**/governança → conta explode.
- Ignorar segurança da nuvem (buckets públicos, IAM permissivo).
- Lock-in acidental por usar tudo proprietário sem abstração.

## Boas práticas

- Preferir **managed services** para reduzir operação.
- **IaC** ([[DevOps - Cultura e Praticas|Terraform]]) para reprodutibilidade.
- Governança de custos (tags, budgets, FinOps).
- Segurança: IAM de menor privilégio, criptografia, rede segmentada ([[19 - SEGURANCA/_INDEX|Segurança]]).

## Conceitos relacionados

- [[DevOps - Cultura e Praticas]]
- [[Kubernetes]]
- [[Microsservicos]]
- [[Observabilidade]]
- [[Teorema CAP e Sistemas Distribuidos]]

## Perguntas importantes

### Qual a diferença entre IaaS, PaaS e SaaS?
Quanto o provedor gerencia por você: **IaaS** (infra), **PaaS** (+ plataforma/runtime), **SaaS** (aplicação inteira). Quanto mais alto, menos você opera e menos controla.

### O que é serverless?
Modelo (FaaS) em que você só fornece o código; o provedor cuida de servidores, escala e disponibilidade, cobrando por execução. Pode escalar a zero.

## Fontes

1. Wikipedia — Cloud computing — https://en.wikipedia.org/wiki/Cloud_computing (consultado 2026-09-03)
2. NIST SP 800-145 — The NIST Definition of Cloud Computing (2011).
3. ISO/IEC 22123 — Cloud computing vocabulary.

## Observações

Criar notas próprias por provedor (AWS/Azure/GCP) e por serviço (serverless, storage, IAM). Status: verified (características NIST/ISO confirmadas).
