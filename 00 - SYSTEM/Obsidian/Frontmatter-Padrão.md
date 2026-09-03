# 📝 Frontmatter Padrão

Use este frontmatter YAML no topo de todos os seus documentos.

---

## Para Conceitos

```yaml
---
type: conceito
status: draft | ready | deprecated
created: 2026-09-03
updated: 2026-09-03
tags: [tag1, tag2]
related: []
---
```

---

## Para Projetos

```yaml
---
type: projeto
status: planejamento | desenvolvimento | produção | arquivado
stack: [FastAPI, React, PostgreSQL]
priority: crítico | alto | médio | baixo
created: 2026-09-03
updated: 2026-09-03
---
```

---

## Para MOCs

```yaml
---
type: moc
status: draft | ready
created: 2026-09-03
updated: 2026-09-03
---
```

---

## Para ADRs

```yaml
---
type: adr
status: proposto | aceito | descartado | obsoleto
created: 2026-09-03
updated: 2026-09-03
---
```

---

## Para Checklists

```yaml
---
type: checklist
status: ativa | arquivada
created: 2026-09-03
updated: 2026-09-03
---
```

---

## Campos Explicados

| Campo | Valores | Uso |
|-------|---------|-----|
| **type** | conceito, projeto, moc, adr, checklist, inbox | Tipo de documento |
| **status** | draft, ready, deprecated, etc | Status do documento |
| **created** | YYYY-MM-DD | Quando foi criado |
| **updated** | YYYY-MM-DD | Última atualização |
| **tags** | lista de strings | Para encontrar via tags |
| **related** | lista de documentos | Links relacionados |
| **stack** | lista de tecnologias | Para projetos |
| **priority** | crítico/alto/médio/baixo | Importância |

---

## Tags Padronizadas

### Por Tipo
- `#conceito` — Conceito teórico
- `#projeto` — Um dos seus projetos
- `#padrão` — Design pattern
- `#ferramenta` — Tool/IDE/biblioteca
- `#adr` — Architecture Decision

### Por Tecnologia
- `#python`, `#javascript`, `#typescript`, `#java`
- `#fastapi`, `#django`, `#flask`, `#node`
- `#react`, `#html`, `#css`
- `#postgresql`, `#mongodb`, `#redis`
- `#docker`, `#kubernetes`
- `#claude`, `#agents`

### Por Status
- `#draft` — Rascunho
- `#ready` — Pronto para usar
- `#review` — Em revisão
- `#deprecated` — Obsoleto

---

## Dica: Use Templates

1. Em Obsidian, Settings → Templates
2. Folder location → `00 - SYSTEM/Templates/`
3. Novo arquivo → Clique em template
4. Frontmatter será preenchido automaticamente!

---

**Manter este arquivo atualizado conforme adicionar novos tipos de documentos.**
