# 🕸️ Graph View — Visualizar Conexões

O Graph View é uma das maiores vantagens do Obsidian. Veja como usar.

---

## O Que É Graph View?

É uma visualização gráfica de **como seus documentos se conectam** através de links internos `[[]]`.

- Cada nó = um documento
- Cada linha = um link entre documentos
- Cor = tipo de documento (if configured)

---

## Como Abrir

1. **Hotkey**: Ctrl+Shift+G (ou Cmd+Shift+G no Mac)
2. **Menu**: Clique no ícone de grafo (lado direito)
3. **Command palette**: Ctrl+P → "Graph: Open graph view"

---

## Filtros Úteis

Na janela Graph View, você verá:
- **Search box** — Procure por tag ou nome
- **Filters** — Configure tipos de nós
- **Settings** — Ajuste de visualização

### Filtros Recomendados

```
file:tag:#conceito        # Mostrar só conceitos
file:tag:#projeto         # Mostrar só projetos
file:tag:#ready           # Mostrar só documentos prontos
file:type:#moc            # Mostrar só MOCs
```

---

## Dicas de Leitura

### Nós Isolados
Se um documento está **sozinho** = falta de links!
→ Considere linkear em uma MOC

### Agrupamentos
Documentos **agrupados** = boa organização temática ✅

### Hubs
Um documento com **muitos links** = provavelmente uma MOC ou Dashboard ✅

### Cadeias Longas
Documentos em **fileira** = bom caminho de aprendizado ✅

---

## Dicas de Otimização

1. **Link conceitos relacionados** — Mais cores na tela
2. **Use MOCs** — Criam hubs conectores
3. **Não link tudo** — Só o que realmente se relaciona
4. **Review periodicamente** — Quais nós estão isolados?

---

## Exemplo de Bom Graph View

```
00 - SYSTEM (Dashboard)
    ├─ 01 - MOC (10 MOCs)
    │   ├─ MOC Backend
    │   │   ├─ FastAPI (documentos)
    │   │   ├─ Django (documentos)
    │   │   └─ Node.js (documentos)
    │   ├─ MOC Frontend
    │   │   ├─ React (documentos)
    │   │   └─ CSS (documentos)
    │   └─ ...
    └─ 20 - PROJETOS (4 projetos linkados)
```

---

## Investigação

No Graph View, você pode:
1. **Clique em um nó** → Vê como se conecta
2. **Arraste nós** → Reorganize a visualização (visual only!)
3. **Zoom** → Scroll do mouse
4. **Fullscreen** → Botão de fullscreen

---

## Objetivo

Um bom Graph View = Documentos bem conectados = Conhecimento navegável = Vault útil!

---

**Revise o Graph View 1x por mês** para garantir que está bem estruturado. 🕸️
