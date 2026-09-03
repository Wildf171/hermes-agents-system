---
title: "Kubernetes"
category: "15 - DEVOPS"
tags:
  - engenharia-software
  - kubernetes
  - containers
  - devops
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Kubernetes (K8s)

## Resumo

**Kubernetes (K8s)** é um sistema **open source de orquestração de containers** que automatiza deployment, escala e gerência de aplicações conteinerizadas. Criado pelo **Google**, hoje mantido pela **Cloud Native Computing Foundation (CNCF)**. Escrito em **Go**, licença **Apache 2.0**, lançado em **2014**.

## O que é?

Agrupa uma ou mais máquinas (VMs ou bare metal) em um **cluster** que roda cargas em containers. Trabalha com runtimes como **containerd** e **CRI-O**. O nome vem do grego *kubernḗtēs* (timoneiro); "K8s" = K + 8 letras + s.

## Por que existe?

Rodar containers ([[Docker - Fundamentals|Docker]]) em produção, em escala, exige: distribuir containers por várias máquinas, reiniciar os que falham, escalar conforme demanda, atualizar sem downtime e descobrir serviços. Fazer isso manualmente é inviável — Kubernetes **automatiza** tudo isso (self-healing, rolling updates, auto-scaling).

## Como funciona? — Arquitetura

### Control Plane (cérebro)
- **API Server** — porta de entrada (REST); tudo passa por ele.
- **etcd** — banco chave-valor com o estado do cluster.
- **Scheduler** — decide em qual nó cada Pod roda.
- **Controller Manager** — reconciliação (estado desejado × real).

### Nodes (onde rodam as apps)
- **kubelet** — agente que roda os Pods no nó.
- **kube-proxy** — rede/roteamento.
- **Container runtime** — containerd/CRI-O.

### Objetos principais
- **Pod** — menor unidade; um ou mais containers juntos.
- **Deployment** — gerencia réplicas e rolling updates.
- **Service** — IP/DNS estável para um conjunto de Pods (load balancing).
- **ConfigMap / Secret** — configuração e segredos.
- **Ingress** — expõe HTTP/HTTPS externamente.
- **Namespace** — isolamento lógico.

> Modelo **declarativo**: você descreve o **estado desejado** (YAML) e o K8s reconcilia continuamente.

## Exemplo prático

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: { name: api }
spec:
  replicas: 3
  selector: { matchLabels: { app: api } }
  template:
    metadata: { labels: { app: api } }
    spec:
      containers:
        - name: api
          image: minha-api:1.0
          ports: [{ containerPort: 8000 }]
```
```bash
kubectl apply -f deploy.yaml    # aplica o estado desejado
kubectl get pods                # observa
kubectl scale deploy/api --replicas=5
```

## Quando utilizar

- Muitos containers/serviços que precisam de escala, resiliência e deploy automatizado.
- [[Microsservicos|Microsserviços]] em produção.

## Quando NÃO utilizar

- App simples/monolito pequeno → K8s é **complexidade excessiva**; um PaaS ou Docker Compose basta.
- Time sem maturidade operacional → curva de aprendizado íngreme.

## Trade-offs

- **Ganha:** self-healing, escala, portabilidade multi-cloud, rolling updates.
- **Perde:** complexidade alta, custo operacional, curva de aprendizado.

## Erros comuns / Anti-patterns

- Adotar K8s sem necessidade real ("resume-driven development").
- Sem **limits/requests** de recursos → nós saturam.
- Segredos em ConfigMap (use Secret + gestor de segredos).
- Sem [[Observabilidade|observabilidade]] → difícil depurar.

## Boas práticas

- Definir **requests/limits** de CPU/memória.
- **Liveness/readiness probes** para self-healing correto.
- GitOps (ArgoCD/Flux) e IaC para gerenciar o cluster.
- Observabilidade desde o início.

## Conceitos relacionados

- [[Docker - Fundamentals]]
- [[DevOps - Cultura e Praticas]]
- [[Microsservicos]]
- [[14 - COMPUTACAO EM NUVEM/_INDEX|Computação em Nuvem]]
- [[Observabilidade]]

## Perguntas importantes

### Qual a diferença entre Docker e Kubernetes?
Docker cria e roda **containers**; Kubernetes **orquestra** muitos containers em um cluster (escala, self-healing, rede, deploy). São complementares.

### Preciso de Kubernetes?
Só quando a escala/complexidade justifica. Para apps pequenas, Docker Compose ou um PaaS costumam ser suficientes.

## Fontes

1. Wikipedia — Kubernetes — https://en.wikipedia.org/wiki/Kubernetes (consultado 2026-09-03)
2. Documentação oficial — https://kubernetes.io/docs/
3. CNCF — https://www.cncf.io

## Observações

Criar notas próprias: Pods/Deployments/Services detalhados, Helm, GitOps. Status: verified.
