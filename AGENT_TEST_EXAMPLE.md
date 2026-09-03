# Agent Knowledge Base - Test Example

Este arquivo demonstra como os agents Hermes usam o KNOWLEDGE_BASE.md para responder perguntas sobre os cursos.

---

## Test Case 1: Pergunta sobre MongoDB Aggregation

### Entrada
```
Usuário: @nosql "Como usar $group em MongoDB aggregation?"
```

### Processo do Agent
1. **Consulta KNOWLEDGE_BASE.md** → Encontra MongoDB Aula 06
2. **Identifica nível**: Intermediário-avançado
3. **Extrai exemplo** da aula
4. **Estrutura resposta** com contexto e próximos passos

### Resposta Esperada
```
📚 Você está consultando: MongoDB Aula 06 - Aggregation Pipeline (Nível: Intermediário)

$group é um estágio crucial do aggregation pipeline que permite agrupar documentos por um valor específico.

## Sintaxe Básica
```javascript
db.collection.aggregate([
  { $group: {
    _id: "$campoParaAgrupar",
    quantidade: { $sum: 1 },
    media: { $avg: "$campoNumerador" }
  }}
])
```

## Exemplo Prático - Contar usuários por cidade
```javascript
db.usuarios.aggregate([
  { $group: {
    _id: "$cidade",          // Agrupar por cidade
    totalUsuarios: { $sum: 1 }  // Contar quantidade
  }},
  { $sort: { totalUsuarios: -1 } }  // Ordenar decrescente
])
```

Resultado:
```
{ "_id": "São Paulo", "totalUsuarios": 45 }
{ "_id": "Rio de Janeiro", "totalUsuarios": 32 }
{ "_id": "Brasília", "totalUsuarios": 28 }
```

## Operadores de Agregação Disponíveis
- $sum — soma valores
- $avg — calcula média
- $min — valor mínimo
- $max — valor máximo

## Próximos Passos
✅ Aula 06 - Aggregation Pipeline (atual)
→ Aula 07 - MongoDB em Produção (escalar com sharding)

## Tarefas Práticas
1. Agrupe vendas por mês
2. Calcule total de vendas por categoria
3. Encontre cliente com mais compras
```

---

## Test Case 2: Pergunta sobre SQL WHERE

### Entrada
```
Usuário: @backend "Como usar LIKE em SQL para buscar padrões?"
```

### Processo do Agent
1. **Consulta KNOWLEDGE_BASE.md** → Encontra SQL Aula 04
2. **Identifica nível**: Básico
3. **Alerta**: "Você está aprendendo ainda, veja Aula 03 antes"
4. **Fornece exemplos** com wildcards

### Resposta Esperada
```
📚 Você está consultando: SQL Aula 04 - Operadores WHERE (Nível: Básico)

LIKE é um operador para buscar padrões de texto em SQL.

## Wildcards
| Símbolo | Significado |
|---------|------------|
| % | Qualquer sequência de caracteres |
| _ | Exatamente 1 caractere |

## Exemplos Práticos

### Nomes que começam com 'A'
```sql
SELECT * FROM usuarios WHERE nome LIKE 'a%';
-- Resultado: Antonio, Alice, Amanda, Ana...
```

### Segunda letra é 'a'
```sql
SELECT * FROM usuarios WHERE nome LIKE '_a%';
-- Resultado: Carlos, Marcelo, Patricia, Rafaela...
```

### Contém 'silva'
```sql
SELECT * FROM usuarios WHERE nome LIKE '%silva%';
-- Resultado: Silva, De Silva, Silva Junior, Silva Santos...
```

### Termina com 's'
```sql
SELECT * FROM usuarios WHERE nome LIKE '%s';
-- Resultado: Carlos, Lucas, Marcus, Dennis...
```

## Próximos Passos
✅ Aula 04 - Operadores WHERE (atual)
→ Aula 05 - JOINs (combinar múltiplas tabelas)

## Tarefas Práticas
1. Buscar emails que contenham '@gmail'
2. Listar cidades que começam com 'São'
3. Encontrar nomes com 3 letras exatas (_ _ _)
```

---

## Test Case 3: Recomendação de Aprendizado

### Entrada
```
Usuário: @backend "Qual aula devo estudar primeiro?"
```

### Processo do Agent
1. **Consulta roadmap** do agent no KNOWLEDGE_BASE.md
2. **Verifica status** dos cursos
3. **Recomenda sequência** personalizada

### Resposta Esperada
```
🎯 Recomendação para Agent Backend

## Seu Roadmap
Para um backend developer, recomendo:

### Fase 1: Fundamentos (Semana 1-2)
✅ SQL Aula 03 - CRUD Básico (complete!)
✅ SQL Aula 04 - Operadores WHERE (complete!)

### Fase 2: Intermediário (Semana 3-4)
→ SQL Aula 05 - JOINs Relacionais (próximo)
→ MongoDB Aula 03 - CRUD Operations

### Fase 3: Avançado (Semana 5-6)
→ MongoDB Aula 06 - Aggregation Pipeline
→ SQL Aula 08 - Índices e Otimização

### Fase 4: Produção (Semana 7+)
→ MongoDB Aula 07 - Replication & Sharding
→ Projeto: API com Node.js + MongoDB + MySQL

## Status Atual
- MongoDB: 7/7 aulas disponíveis
- SQL: 2/8 aulas completas

Recomendação: Comece por SQL Aula 05 (JOINs) esta semana.
```

---

## Como Testar Localmente

### Pré-requisitos
1. Ter Hermes instalado (`hermes --version`)
2. Ter API key configurada (`.hermes/.env`)
3. Ter KNOWLEDGE_BASE.md em `.hermes/`
4. Ter AGENT_INSTRUCTIONS.md em `.hermes/`

### Comando de Teste
```bash
hermes chat -q "Como usar aggregation em MongoDB?" --oneshot
```

### Com Agent Específico
```bash
hermes chat -q "Explique $group em MongoDB" -t nosql --oneshot
```

---

## Sucesso Esperado

✅ Agent consulta KNOWLEDGE_BASE.md
✅ Agent identifica aula relevante
✅ Agent fornece exemplos práticos
✅ Agent sugere próximos passos
✅ Agent responde em português
✅ Agent menciona número da aula

---

**Data do teste**: 2026-09-03
**Status**: Pronto para integração
**Próximo passo**: Ativar API key do Hermes para testes reais
