# 🏷️ Sistema de Tags

Use tags para organizar e encontrar documentos rapidamente.

---

## Tags Obrigatórias

Todo documento deve ter pelo menos **1 tag de tipo**:

```
#conceito #projeto #padrão #ferramenta #adr #checklist #inbox
```

---

## Tags de Tecnologia (Recomendadas)

```
#python #javascript #typescript #java #sql #go

#fastapi #django #flask #node #express

#react #html #css #bootstrap #tailwind

#postgresql #mongodb #redis #mysql

#docker #kubernetes #github-actions #terraform

#claude #agents #hermes #rag #llm
```

---

## Tags de Status

```
#draft — Em desenvolvimento
#ready — Pronto para usar
#review — Em revisão
#deprecated — Obsoleto
```

---

## Tags de Prioridade (Opcional)

```
#critico #alto #medio #baixo
```

---

## Como Usar No Obsidian

### No Frontmatter
```yaml
tags: [conceito, python, django, ready]
```

### No Corpo do Documento
Use `#tag` em qualquer lugar:

```markdown
Este é um conceito sobre #python e #fastapi que é #ready.
```

---

## Pesquisar por Tags

1. Abra Search (Ctrl+Shift+F)
2. Use: `tag:#python` para encontrar tudo com tag python
3. Use `tag:#conceito` para encontrar conceitos
4. Combine: `tag:#django tag:#ready` para filtrar

---

## Sugestões

- **Mínimo 2 tags** por documento
- **Máximo 5 tags** (senão vira poluição)
- **Revise regularmente** se as tags ainda fazem sentido

---

**Dica**: Abra Tag Pane no Obsidian (à direita) para ver todas as tags usadas e suas frequências!
