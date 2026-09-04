---
title: "Escalabilidade - Fundamentos"
category: "22 - ESCALABILIDADE"
tags:
  - engenharia-software
  - escalabilidade
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Escalabilidade — Fundamentos

## Resumo

**Escalabilidade** é a capacidade de um sistema **lidar com carga crescente adicionando recursos**. Um sistema é escalável na faixa em que o **custo marginal** de trabalho adicional é aproximadamente constante. As duas abordagens são **vertical (scale up)** e **horizontal (scale out)**.

## O que é?

Propriedade de suportar aumento de trabalho (usuários, requisições, dados) mantendo a performance. A analogia clássica: uma entrega é escalável adicionando mais veículos — mas se **tudo passa por um único armazém**, esse armazém vira o **gargalo** e o sistema não escala. Escalabilidade é, em essência, **eliminar gargalos**.

## Escala Vertical vs Horizontal

### Vertical (Scale Up)
Máquina **maior** (mais CPU/RAM).
- **Prós:** simples, sem mudança de arquitetura, sem problemas de sistemas distribuídos.
- **Contras:** **teto físico**, caro no topo, **ponto único de falha (SPOF)**, downtime para upgrade.

### Horizontal (Scale Out)
**Mais máquinas** trabalhando juntas.
- **Prós:** escala "quase infinita", redundância (sem SPOF), commodity hardware.
- **Contras:** exige **stateless**, [[Componentes de Sistemas em Larga Escala|load balancing]], e lidar com [[Teorema CAP e Sistemas Distribuidos|sistemas distribuídos]] (consistência, coordenação).

> Regra moderna: **scale out** é o caminho para grande escala; scale up resolve até certo ponto e é bom começar por ele (mais simples).

## Conceitos fundamentais

- **Statelessness** — servidores sem estado local permitem adicionar/remover nós livremente (estado vai para cache/DB externos). **Pré-requisito** da escala horizontal.
- **Elasticidade** — escalar **automaticamente** para cima/baixo com a demanda (autoscaling, cloud). Ver [[Estrategias de Escala Web]].
- **Gargalo (bottleneck)** — o recurso que satura primeiro; escalar o resto não adianta (relaciona-se à [[Performance - Fundamentos|Lei de Amdahl]]).
- **Escalar leitura vs escrita** — leitura escala com [[Replicacao de Dados|réplicas]]/cache; escrita escala com [[Particionamento e Sharding|sharding]].

## Escalabilidade vs Performance

- **Performance** — rápido para **um** usuário/requisição ([[Performance - Fundamentos]]).
- **Escalabilidade** — manter performance à medida que a **carga cresce**.
Um sistema pode ser rápido com 10 usuários e desabar com 10.000 (não escalável).

## Dimensões de escala

- **Carga** (req/s), **dados** (volume), **usuários simultâneos**, **geografia** (multi-região).

## Como escalar (visão geral)

1. **Stateless** + [[Componentes de Sistemas em Larga Escala|load balancer]] → mais instâncias de app.
2. **Cache** ([[Cache e Redis]]) → tira carga do banco.
3. **[[Replicacao de Dados|Read replicas]]** → escala leitura.
4. **[[Particionamento e Sharding|Sharding]]** → escala escrita/volume.
5. **Filas** ([[Mensageria - Fundamentos]]) → absorver picos, trabalho assíncrono.
6. **Autoscaling** → elasticidade.

## Quando se preocupar

- Quando o crescimento é real/previsto e as métricas mostram saturação.
- Projetar para **stateless** desde cedo (barato) facilita escalar depois.

## Quando NÃO (nuance)

- Escalar para "escala do Google" sem necessidade é **over-engineering**. Comece simples ([[DRY, KISS e YAGNI|YAGNI]]); a maioria dos sistemas cabe em um servidor grande + réplicas por muito tempo.

## Erros comuns / Anti-patterns

- Estado na aplicação (sessão local) impedindo scale out.
- Sharding prematuro (antes de cache/réplicas).
- Ignorar o gargalo real (escalar a camada errada).
- Confundir escalabilidade com performance.

## Boas práticas

- **Stateless** por padrão; estado externo (Redis/DB).
- Medir para achar o **gargalo**; escalar a camada certa.
- Cache + réplicas antes de sharding.
- Projetar para escala horizontal quando o crescimento justificar.

## Conceitos relacionados

- [[Particionamento e Sharding]]
- [[Replicacao de Dados]]
- [[Estrategias de Escala Web]]
- [[Arquitetura de Sistemas e System Design - Fundamentos]]
- [[Teorema CAP e Sistemas Distribuidos]] · [[Performance - Fundamentos]]

## Perguntas importantes

### Vertical ou horizontal?
Vertical (máquina maior) é simples, mas tem teto e SPOF. Horizontal (mais máquinas) escala muito mais, exigindo stateless, load balancing e lidar com sistemas distribuídos.

### Qual a diferença entre escalabilidade e performance?
Performance = rápido para uma requisição. Escalabilidade = **manter** a performance conforme a carga cresce. São coisas diferentes.

## Fontes

1. Wikipedia — Scalability — https://en.wikipedia.org/wiki/Scalability (consultado 2026-09-03)
2. Kleppmann — *Designing Data-Intensive Applications* (cap. Scalability).
3. Alex Xu — *System Design Interview.*

## Observações

Aprofundar: elasticidade/autoscaling, back-pressure, escala geográfica. Status: verified.
