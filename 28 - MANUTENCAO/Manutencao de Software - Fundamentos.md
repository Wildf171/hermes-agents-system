---
title: "Manutenção de Software - Fundamentos"
category: "28 - MANUTENCAO"
tags:
  - engenharia-software
  - manutencao
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Manutenção de Software — Fundamentos

## Resumo

**Manutenção de software** é a **modificação do software após a entrega**. Apesar de menos glamourosa que o desenvolvimento novo, é a fase que **consome a maior parte do custo total** do software ao longo da vida — tipicamente **60–80%**. Divide-se em quatro tipos (ISO/IEC 14764): **corretiva, adaptativa, perfectiva e preventiva**.

## O que é?

Toda alteração feita depois que o software entrou em produção: corrigir bugs, adaptar a novos ambientes, adicionar/melhorar funcionalidades e prevenir problemas futuros. Cada ciclo começa com um **change request** (geralmente do usuário), que é avaliado, e o programador **estuda o código existente** antes de mudar.

## Os 4 tipos de manutenção (ISO/IEC 14764)

Cruzando **corrigir/preservar × reativo/proativo**:

| Tipo | O que é | Reativo/Proativo |
|---|---|---|
| **Corretiva** | Corrigir defeitos/bugs encontrados | Reativa |
| **Adaptativa** | Adaptar a mudanças do ambiente (novo SO, lib, API, lei) | Reativa |
| **Perfectiva** | Melhorar/adicionar funcionalidade e desempenho conforme o uso | Proativa |
| **Preventiva** | Reduzir risco de falhas futuras (refatorar, atualizar deps) | Proativa |

> Surpresa comum: a **maior parte** da manutenção não é corrigir bugs — é **perfectiva/adaptativa** (evoluir o produto).

## Por que custa tanto? (o "iceberg")

- **Entender o código existente** antes de mudar consome grande parte do esforço (R. G. Canning, "The Maintenance Iceberg", 1972).
- **Testar** que a funcionalidade existente continua funcionando (regressão) é caro.
- Software entregue **incompleto/com bugs**; devs originais nem sempre escrevem para ser mantido; a equipe de manutenção costuma ser **diferente** da que criou.

## O ciclo de manutenção

```
Change request (usuário/negócio)
  → avaliar/priorizar
  → entender o código existente  ← grande parte do custo
  → implementar a mudança
  → testar (nova função + regressão)
  → deploy
```

## O que torna software manutenível?

Atributos que **reduzem** o custo de manutenção (ligados à [[Qualidade de Software - Fundamentos|manutenibilidade do ISO 25010]]):
- **Testes automatizados** ([[Testes - Fundamentos e Piramide]]) — rede de segurança.
- **[[Clean Code|Código limpo]]**, baixo [[Coesao e Acoplamento|acoplamento]], [[SOLID Principles|SOLID]].
- **Documentação** viva ([[27 - DOCUMENTACAO/_INDEX]], [[45 - DECISOES ARQUITETURAIS/_INDEX|ADRs]]).
- **[[Observabilidade]]** para diagnosticar.
- Controle de [[Metricas de Qualidade e Divida Tecnica|dívida técnica]].

## Manutenção vs Evolução vs Legado

- **Manutenção** — modificar após entrega (guarda-chuva).
- **Evolução** — a mudança contínua e inevitável do software (ver [[Evolucao de Software e Leis de Lehman]]).
- **[[Sistemas Legados - Fundamentos|Legado]]** — sistema antigo, difícil de manter (caso extremo).

## Quando priorizar cada tipo

- **Corretiva:** bugs que afetam usuários (urgência por severidade).
- **Adaptativa:** mudanças de ambiente/deps (segurança!) — não deixar acumular.
- **Perfectiva:** guiada por valor/uso.
- **Preventiva:** contínua (Boy Scout Rule), evita virar [[Sistemas Legados - Fundamentos|legado]].

## Erros comuns / Anti-patterns

- Tratar manutenção como "segunda classe" → código apodrece.
- Só manutenção **corretiva** (apagar incêndios), sem preventiva → dívida explode.
- Mudar sem entender/testar → regressões.
- Ignorar manutenção adaptativa (deps desatualizadas = risco de [[19 - SEGURANCA/_INDEX|segurança]]).

## Boas práticas

- Escrever software **para ser mantido** desde o início (testes, clareza).
- **Preventiva contínua**: atualizar deps, refatorar ao passar pelo código.
- Priorizar por valor/risco; medir dívida técnica.
- Documentar decisões (ADRs) para o "eu do futuro"/próxima equipe.

## Conceitos relacionados

- [[Evolucao de Software e Leis de Lehman]]
- [[Versionamento Semantico e Gestao de Dependencias]]
- [[Sistemas Legados - Fundamentos]] · [[Refatoracao]]
- [[Qualidade de Software - Fundamentos]] · [[Metricas de Qualidade e Divida Tecnica]]

## Perguntas importantes

### Quais são os 4 tipos de manutenção?
**Corretiva** (bugs), **Adaptativa** (mudanças de ambiente), **Perfectiva** (melhorias/novas funções) e **Preventiva** (evitar problemas futuros). ISO/IEC 14764.

### Manutenção é só corrigir bugs?
Não. A maior parte é **perfectiva e adaptativa** (evoluir e adaptar). E manutenção consome a maior fatia do custo total do software.

## Fontes

1. Wikipedia — Software maintenance — https://en.wikipedia.org/wiki/Software_maintenance (consultado 2026-09-03)
2. ISO/IEC 14764 — Software maintenance; [[SWEBOK - Corpo de Conhecimento|SWEBOK]] — Maintenance KA.
3. Canning, R. G. (1972). "The Maintenance 'Iceberg'."

## Observações

Aprofundar: processo de manutenção (ISO 14764), estimativa de custo. Status: verified.
