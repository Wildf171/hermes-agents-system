---
title: "Catálogo de Problemas Comuns"
category: "42 - TROUBLESHOOTING"
tags:
  - engenharia-software
  - troubleshooting
  - referencia
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Catálogo de Problemas Comuns

> Guia de diagnóstico rápido de problemas frequentes. Formato: **sintoma → causas prováveis → diagnóstico → solução → prevenção**. Aplique o [[Troubleshooting - Metodo e Fundamentos|método sistemático]].

## Erro de CORS (browser)

- **Sintoma:** requisição do frontend falha com "blocked by CORS policy"; funciona no Postman/curl.
- **Causas:** servidor não envia headers `Access-Control-Allow-Origin`; falta responder ao **preflight** (OPTIONS); origem não permitida.
- **Diagnóstico:** aba Network do DevTools; ver resposta do OPTIONS e headers.
- **Solução:** configurar CORS no **servidor** (origens/métodos/headers permitidos).
- **Prevenção:** CORS explícito por ambiente; nunca `*` com credenciais. Ver [[Redes - TCP-IP, HTTP, DNS e TLS]], [[Boas Praticas de API]].

## HTTP 500 (Internal Server Error)

- **Sintoma:** erro genérico do servidor.
- **Causas:** exceção não tratada, migração de banco faltando, config/variável de ambiente ausente, dependência fora.
- **Diagnóstico:** **ler o stack trace nos logs** do servidor (o 500 é genérico; o log tem a causa); "o que mudou?" (deploy recente).
- **Solução:** corrigir a causa-raiz (não engolir o erro).
- **Prevenção:** logging/observabilidade, testes, migrações no pipeline.

## HTTP 502/503/504 (gateway)

- **Sintoma:** 502 Bad Gateway / 503 Unavailable / 504 Timeout.
- **Causas:** app atrás do proxy/LB caiu ou está lento; sem instâncias saudáveis; timeout upstream.
- **Diagnóstico:** health checks do LB; logs do app; uso de CPU/memória; latência.
- **Solução:** reiniciar/escalar; corrigir lentidão; ajustar timeouts.
- **Prevenção:** health checks, autoscaling, [[Estrategias de Escala Web|degradação graciosa]].

## Memory Leak (vazamento de memória)

- **Sintoma:** memória cresce sem parar; app fica lento e cai (OOM) após horas/dias.
- **Causas:** referências retidas (listeners não removidos, caches sem limite, closures), conexões não fechadas.
- **Diagnóstico:** monitorar memória ao longo do tempo; **heap dump**/profiler; reproduzir com carga.
- **Solução:** liberar referências; limitar caches (TTL/tamanho); fechar recursos.
- **Prevenção:** [[Profiling e Otimizacao|profiling de memória]], limites (cgroups/K8s), testes de longa duração.

## Timeout / Lentidão

- **Sintoma:** requisições lentas ou estouram timeout.
- **Causas:** query lenta/sem índice, N+1, chamada externa lenta, falta de cache, saturação de recurso.
- **Diagnóstico:** [[Profiling e Otimizacao|profiling]], `EXPLAIN` na query, tracing distribuído; achar o gargalo ([[Performance - Fundamentos|Amdahl]]).
- **Solução:** índice/cache, eliminar N+1, timeouts+retries em chamadas externas, async.
- **Prevenção:** ver [[Indices e Otimizacao de Queries]], [[Cache e Redis]], [[21 - PERFORMANCE/_INDEX]].

## N+1 Queries

- **Sintoma:** endpoint lento; log mostra centenas de queries quase idênticas.
- **Causas:** carregar relações em loop (lazy loading por item).
- **Diagnóstico:** contar queries por request; ORM logging.
- **Solução:** eager loading/JOIN/batch (`select_related`/`prefetch_related`, `JOIN`).
- **Prevenção:** revisar queries geradas pelo ORM; testes que contam queries.

## Deadlock (banco ou threads)

- **Sintoma:** transações travam/abortam; app congela.
- **Causas:** aquisição de locks em ordens diferentes ([[Deadlock, Starvation e Livelock|Coffman]]).
- **Diagnóstico:** logs de deadlock do SGBD; grafo de espera; thread dump.
- **Solução:** ordem consistente de locks; transações curtas; retry.
- **Prevenção:** ver [[Deadlock, Starvation e Livelock]], [[Transacoes e ACID]].

## "Funciona na minha máquina"

- **Sintoma:** passa local, falha em outro ambiente.
- **Causas:** versões/config/variáveis/dados diferentes; dependência do SO.
- **Diagnóstico:** diff de ambiente (versões, env vars, dados).
- **Solução:** alinhar ambientes.
- **Prevenção:** **containers** ([[Docker - Fundamentals]]), paridade dev-prod, IaC.

## Segredo/credencial vazando ou faltando

- **Sintoma:** auth falha em produção; ou segredo commitado.
- **Causas:** env var ausente; `.env` não configurado; segredo no repositório.
- **Diagnóstico:** checar config do ambiente; histórico do git.
- **Solução:** configurar via secret manager; **rotacionar** segredo exposto; remover do histórico.
- **Prevenção:** `.gitignore`, secret scanning, gestão de segredos ([[19 - SEGURANCA/_INDEX]]).

## Como usar este catálogo

1. Localize o sintoma mais próximo.
2. Siga do diagnóstico à prevenção.
3. Se não estiver aqui, aplique o [[Troubleshooting - Metodo e Fundamentos|método]] e considere adicionar o novo caso.

## Conceitos relacionados

- [[Troubleshooting - Metodo e Fundamentos]]
- [[Tecnicas de Debugging]]
- [[Diagnostico em Producao e Postmortems]]
- [[Observabilidade]] · [[Performance - Fundamentos]]

## Fontes

1. MDN — CORS / HTTP status — https://developer.mozilla.org/docs/Web/HTTP
2. Documentações oficiais (PostgreSQL deadlocks, ORMs) e experiência consolidada da área.
3. Nygard, M. — *Release It!*

## Observações

Catálogo vivo: adicionar novos casos reais no mesmo formato. Status: verified.
