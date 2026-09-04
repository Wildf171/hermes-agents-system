---
title: "Troubleshooting - Método e Fundamentos"
category: "42 - TROUBLESHOOTING"
tags:
  - engenharia-software
  - troubleshooting
  - debugging
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Troubleshooting — Método e Fundamentos

## Resumo

**Troubleshooting** é a **busca lógica e sistemática** pela causa de um problema para resolvê-lo. Não é adivinhação: parte dos **sintomas**, isola a **causa mais provável** por **processo de eliminação** e **confirma** que a correção restaurou o funcionamento. É a aplicação do **método científico** a sistemas com defeito.

## O que é?

Uma forma de resolução de problemas: identificar o sintoma (comportamento inesperado), diagnosticar a causa e remediar. Um sistema tem comportamento **esperado**; qualquer desvio é um **sintoma**. Troubleshooting isola a(s) **causa(s)** do sintoma.

## Por que um método importa?

Debugar "no chute" (mudar coisas aleatoriamente) desperdiça tempo e **introduz novos bugs**. Um método:
- Reduz o espaço de busca sistematicamente.
- Evita "consertar" o que não é a causa.
- É reproduzível e comunicável (importante em incidentes/equipe).

## O método (passo a passo)

### 1. Reproduzir o problema
Se você não reproduz, não sabe se corrigiu. Encontre o **caso mínimo** e as condições que disparam o bug. Bugs intermitentes → identificar o gatilho (timing, dados, ambiente).

### 2. Observar e coletar fatos
Ler a **mensagem de erro completa** e o **stack trace**; logs; estado; o que mudou recentemente (deploy, config, dados). **Não presuma** — colete evidências.

### 3. Formular hipóteses
Com base nos fatos, liste **causas prováveis** (não uma só). Priorize pela probabilidade e pelo custo de testar.

### 4. Testar uma hipótese por vez
Mude **uma variável de cada vez** (senão você não sabe o que resolveu). Confirme ou descarte cada hipótese com uma observação.

### 5. Isolar por eliminação / bisseção
Divida o sistema ao meio: o problema está antes ou depois deste ponto? Repita ([[Tecnicas de Debugging|bisection]], `git bisect`). Reduz o espaço exponencialmente.

### 6. Corrigir a causa-raiz (não o sintoma)
Tratar só o sintoma faz o bug voltar. Ache a **causa-raiz** (ex.: 5 Whys).

### 7. Verificar e prevenir
Confirmar que a correção resolve **e** não quebra outra coisa. Adicionar um **teste de regressão** que reproduz o bug (para não voltar).

## Princípios

- **Método científico:** hipótese → experimento → observação → conclusão.
- **"What changed?"** — a maioria dos problemas em produção vem de uma **mudança recente** (deploy, config, dependência, dados).
- **Assumir nada, verificar tudo** — o bug costuma estar onde você tem certeza que não está.
- **Ler a mensagem de erro** (parece óbvio; é ignorado o tempo todo).

## Exemplo (raciocínio)

```
Sintoma: "erro 500 ao salvar pedido, só desde as 14h"
1. Reproduzir: acontece com qualquer pedido? sim.
2. Fatos: deploy às 13h55; log mostra "column X does not exist"
3. Hipótese: migração de banco não rodou no deploy
4. Testar: verificar schema → coluna ausente → confirma
5. Corrigir: rodar a migração (causa-raiz), não "try/catch" no erro
6. Prevenir: migração automática no pipeline + teste
```

## Quando aplicar

- Qualquer bug/falha/incidente. Em produção, combine com [[Diagnostico em Producao e Postmortems|resposta a incidentes]].

## Erros comuns / Anti-patterns

- **Shotgun debugging** — mudar várias coisas ao acaso.
- Corrigir o **sintoma** (esconder o erro) em vez da causa.
- Não reproduzir antes de "corrigir".
- Ignorar a mensagem de erro / o que mudou.
- Não adicionar teste de regressão (o bug volta).

## Boas práticas

- Reproduzir → isolar (bisection) → uma variável por vez → causa-raiz → teste de regressão.
- Comece por **"o que mudou?"**.
- Registrar o diagnóstico (útil para o time e para postmortem).
- Ver [[Tecnicas de Debugging]] para as táticas concretas.

## Conceitos relacionados

- [[Tecnicas de Debugging]]
- [[Diagnostico em Producao e Postmortems]]
- [[Catalogo de Problemas Comuns]]
- [[Observabilidade]] · [[Testes - Fundamentos e Piramide]]

## Perguntas importantes

### Qual o primeiro passo do troubleshooting?
**Reproduzir** o problema de forma confiável. Sem reprodução, você não sabe a causa nem se corrigiu.

### Por que mudar uma variável de cada vez?
Se você muda várias coisas juntas e o problema some, não sabe **qual** o resolveu — e pode ter introduzido outros bugs. Isolar variáveis é a base do método científico.

## Fontes

1. Wikipedia — Troubleshooting — https://en.wikipedia.org/wiki/Troubleshooting (consultado 2026-09-03)
2. Wikipedia — Debugging — https://en.wikipedia.org/wiki/Debugging (consultado 2026-09-03)
3. Agans, D. — *Debugging: The 9 Indispensable Rules.*

## Observações

Aprofundar: 5 Whys, RCA formal, fishbone (Ishikawa). Status: verified.
