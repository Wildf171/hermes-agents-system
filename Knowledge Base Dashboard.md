---
title: "Knowledge Base Dashboard"
tags:
  - engenharia-software
  - dashboard
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
---

# 📊 Knowledge Base Dashboard

> [!note] Requer o plugin **Dataview**
> As consultas abaixo só renderizam com o plugin Dataview ativado (Configurações → Plugins da comunidade → Dataview). Sem ele, use o resumo estático.

Voltar para [[00 - INDEX]].

---

## 📈 Resumo estático (Fase de estrutura)

| Métrica | Valor |
|---|---|
| Categorias (schema) | 48 |
| Categorias com esqueleto | 48 / 48 ✅ |
| Notas `verified` (pesquisadas c/ fontes) | ~46 |
| Fases de pesquisa concluídas | 7 / 7 ✅ |
| Sistema (templates, guias, MOCs) | ✅ |
| Última atualização | 2026-09-03 |

**Estado:** as 7 fases do plano de pesquisa foram concluídas (Fundamentos → Desenvolvimento → Arquitetura → Infraestrutura → Dados → Segurança → IA). Próximo ciclo: aprofundar tópicos planejados em cada categoria (ver seções "Tópicos planejados" dos `_INDEX`).

---

## 🔢 Contagem por status

```dataview
TABLE length(rows) AS "Notas"
FROM ""
WHERE status
GROUP BY status
SORT status ASC
```

## 🧩 Notas por categoria

```dataview
TABLE length(rows) AS "Notas"
FROM ""
WHERE category
GROUP BY category
SORT category ASC
```

## 🔬 Em pesquisa agora

```dataview
LIST
FROM ""
WHERE status = "research" OR status = "draft"
SORT file.mtime DESC
```

## ⚠️ Precisam de atenção (outdated / review)

```dataview
TABLE status, updated
FROM ""
WHERE status = "outdated" OR status = "review"
SORT updated ASC
```

## 🆕 Últimas notas modificadas

```dataview
TABLE status, file.mtime AS "Modificado"
FROM ""
WHERE status
SORT file.mtime DESC
LIMIT 15
```

## 🕳️ Lacunas — categorias ainda só com esqueleto

```dataview
LIST
FROM ""
WHERE status = "idea" AND contains(file.name, "_INDEX")
SORT file.folder ASC
```

---

## 🎯 Plano de pesquisa (ordem sugerida)

- **Fase 1 — Fundamentos:** [[01 - FUNDAMENTOS/_INDEX|Fundamentos]], SDLC, [[05 - PRINCÍPIOS DE SOFTWARE/_INDEX|Princípios]], [[06 - PROGRAMACAO/_INDEX|Programação]], [[26 - GIT E VERSIONAMENTO/_INDEX|Git]], estruturas de dados
- **Fase 2 — Desenvolvimento:** [[31 - CLEAN CODE/_INDEX|Clean Code]], [[32 - SOLID/_INDEX|SOLID]], [[08 - DESIGN PATTERNS/_INDEX|Patterns]], [[17 - TESTES/_INDEX|Testes]], [[29 - REFATORACAO/_INDEX|Refatoração]]
- **Fase 3 — Arquitetura:** [[09 - ARQUITETURA DE SOFTWARE/_INDEX|Arquitetura]], [[33 - DDD/_INDEX|DDD]], [[34 - MICROSERVICOS/_INDEX|Microsserviços]], [[35 - EVENT DRIVEN/_INDEX|Event-Driven]], [[13 - SISTEMAS DISTRIBUIDOS/_INDEX|Distribuídos]]
- **Fase 4 — Infra:** [[25 - SISTEMAS OPERACIONAIS/_INDEX|SO]], [[24 - REDES/_INDEX|Redes]], [[15 - DEVOPS/_INDEX|DevOps]], [[16 - CI-CD/_INDEX|CI/CD]], [[14 - COMPUTACAO EM NUVEM/_INDEX|Cloud]], [[20 - OBSERVABILIDADE/_INDEX|Observabilidade]]
- **Fase 5 — Dados:** [[12 - BANCOS DE DADOS/_INDEX|Bancos de Dados]], [[37 - ENGENHARIA DE DADOS/_INDEX|Eng. de Dados]]
- **Fase 6 — Segurança:** [[19 - SEGURANCA/_INDEX|Segurança]] (OWASP, auth, cripto)
- **Fase 7 — IA:** [[38 - IA PARA ENGENHARIA DE SOFTWARE/_INDEX|IA para Eng. de Software]] (LLMs, Agents, RAG, MCP)
