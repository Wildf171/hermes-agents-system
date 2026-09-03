---
title: "Performance Web"
category: "21 - PERFORMANCE"
tags:
  - engenharia-software
  - performance
  - web
  - frontend
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Performance Web

## Resumo

Performance web é a rapidez percebida de um site/app no navegador. O Google unificou as métricas mais importantes nas **Core Web Vitals** — **LCP** (carregamento), **INP** (interatividade) e **CLS** (estabilidade visual) — que refletem a experiência real do usuário e influenciam SEO.

## Core Web Vitals (métricas atuais)

| Métrica | Mede | Meta (boa) |
|---|---|---|
| **LCP** — Largest Contentful Paint | Carregamento (maior elemento visível) | ≤ **2,5 s** |
| **INP** — Interaction to Next Paint | Interatividade (resposta a interações) | ≤ **200 ms** |
| **CLS** — Cumulative Layout Shift | Estabilidade visual (saltos de layout) | ≤ **0,1** |

> **INP substituiu o FID** (First Input Delay) como métrica de interatividade em **março de 2024**. As Core Web Vitals evoluem com o tempo.

Outras métricas úteis: **TTFB** (Time to First Byte), **FCP** (First Contentful Paint), **TBT** (Total Blocking Time).

## Por que importa?

- **Experiência**: sites lentos aumentam bounce e reduzem conversão.
- **SEO**: Core Web Vitals são sinal de ranqueamento do Google.
- **Alcance**: usuários em redes/dispositivos fracos dependem de otimização.

## Como funciona? — Otimizações

### Frontend (carregamento e render)
- **Reduzir bundle**: code splitting, tree shaking, minificação.
- **Lazy loading** de imagens/componentes; imagens responsivas e formatos modernos (WebP/AVIF).
- **Critical CSS**; adiar JS não essencial (`defer`/`async`).
- Evitar CLS: reservar espaço para imagens/anúncios (width/height), fontes com `font-display`.
- **Caching** do navegador (Cache-Control) e **Service Workers** (PWA).

### Rede/entrega
- **CDN** para servir estáticos perto do usuário.
- **Compressão** (gzip/brotli); **HTTP/2/3** (multiplexação — ver [[Redes - TCP-IP, HTTP, DNS e TLS]]).
- Reduzir round-trips; preconnect/preload.

### Backend
- Reduzir **TTFB**: [[Cache e Redis|cache]], [[Indices e Otimizacao de Queries|queries rápidas]], menos trabalho por request.
- **SSR/SSG/edge** para entregar HTML pronto rápido.

### Rendering strategies
- **CSR** (client-side), **SSR** (server-side), **SSG** (static), **ISR** — escolher pelo trade-off de TTFB/interatividade/complexidade.

## Ferramentas de medição

- **Lighthouse** / PageSpeed Insights (lab + campo).
- **Chrome DevTools** (Performance panel).
- **web-vitals** (JS) para RUM (Real User Monitoring).
- **CrUX** (Chrome User Experience Report) — dados de campo.

## Lab vs Field data

- **Lab** (Lighthouse) — ambiente controlado, reproduzível (bom para debugar).
- **Field/RUM** (CrUX/web-vitals) — usuários reais (o que o Google usa para ranquear). Otimize para o **campo**.

## Quando utilizar

- Qualquer site/app voltado ao usuário — especialmente e-commerce, conteúdo, SEO-sensível.

## Quando NÃO priorizar (nuance)

- Ferramentas internas de baixo tráfego podem tolerar menos otimização.
- Não persiga 100 no Lighthouse às custas de funcionalidade; otimize o que afeta usuários reais (campo).

## Erros comuns / Anti-patterns

- JS gigante bloqueando a thread principal (INP/TBT ruins).
- Imagens sem dimensões → **CLS** alto (saltos de layout).
- Otimizar só o **lab** e ignorar dados de **campo**.
- Ignorar TTFB (problema é backend, não frontend).
- Carregar tudo de uma vez (sem lazy loading/splitting).

## Boas práticas

- Meça no **campo** (RUM) + Lighthouse para debug.
- Otimize as **três** Core Web Vitals (LCP, INP, CLS).
- CDN + compressão + cache; imagens modernas e dimensionadas.
- Enviar menos JS; dividir e adiar.

## Conceitos relacionados

- [[Performance - Fundamentos]]
- [[Profiling e Otimizacao]]
- [[Redes - TCP-IP, HTTP, DNS e TLS]]
- [[Cache e Redis]]
- [[Computacao em Nuvem - Fundamentos]] (CDN/edge)

## Perguntas importantes

### Quais são as Core Web Vitals?
**LCP** (carregamento ≤2,5s), **INP** (interatividade ≤200ms), **CLS** (estabilidade visual ≤0,1). INP substituiu o FID em 2024.

### Lab ou field data?
Ambos: **lab** (Lighthouse) para debugar de forma reproduzível; **field/RUM** para a experiência real dos usuários — é o que conta para SEO.

## Fontes

1. web.dev — Web Vitals (Google, atualizado out/2024) — https://web.dev/articles/vitals (consultado 2026-09-03)
2. web.dev — Otimização de LCP/INP/CLS — https://web.dev/
3. MDN — Web Performance — https://developer.mozilla.org/docs/Web/Performance

## Observações

Métricas evoluem (FID→INP em 2024); revalidar limites/definições periodicamente. Status: verified (Core Web Vitals confirmadas na fonte oficial).
