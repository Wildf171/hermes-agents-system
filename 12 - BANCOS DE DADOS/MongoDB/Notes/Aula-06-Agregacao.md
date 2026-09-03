# Aula 06 - Aggregation Pipeline

## 📋 Resumo
Pipeline de agregação do MongoDB — ferramenta poderosa para transformar e analisar dados.

## 🎯 Objetivos
- Dominar o aggregation pipeline
- Usar $group, $match, $sort
- Calcular estatísticas
- Transformar dados complexos

## 📚 Conteúdo Principal

### O que é Aggregation Pipeline?
- Série de estágios que processam dados sequencialmente
- Cada estágio transforma o output do anterior
- Muito mais flexível que find()
- Ideal para relatórios e analytics

### Sintaxe Básica
```javascript
db.collection.aggregate([
  { $stage1: { ... } },
  { $stage2: { ... } },
  { $stage3: { ... } }
])
```

### Principais Estágios

#### $match - Filtrar (como find())
```javascript
db.users.aggregate([
  { $match: { ativo: true, idade: { $gte: 18 } } }
])
```

#### $project - Selecionar/Transformar Campos
```javascript
db.users.aggregate([
  { $project: {
    nome: 1,
    idade: 1,
    email: 0,
    nomeUpper: { $toUpper: "$nome" }
  }}
])
```

#### $group - Agrupar por Campo
```javascript
db.usuarios.aggregate([
  { $group: {
    _id: "$cidade",
    total: { $sum: 1 },
    mediaIdade: { $avg: "$idade" }
  }}
])
```

#### $sort - Ordenar
```javascript
db.users.aggregate([
  { $sort: { idade: -1 } }
])
```

#### $limit e $skip - Paginação
```javascript
db.users.aggregate([
  { $skip: 10 },
  { $limit: 5 }
])
```

#### $unwind - Desempacotar Arrays
```javascript
// Documento com array skills
{ nome: "William", skills: ["JS", "Java"] }

// Com $unwind:
{ nome: "William", skills: "JS" }
{ nome: "William", skills: "Java" }
```

```javascript
db.users.aggregate([
  { $unwind: "$skills" },
  { $group: {
    _id: "$skills",
    quantidade: { $sum: 1 }
  }}
])
```

### Exemplo Completo

```javascript
// Listar top 5 skills mais populares entre usuários ativos
db.users.aggregate([
  { $match: { ativo: true } },
  { $unwind: "$skills" },
  { $group: {
    _id: "$skills",
    quantidadeUsuarios: { $sum: 1 }
  }},
  { $sort: { quantidadeUsuarios: -1 } },
  { $limit: 5 }
])
```

### Operadores de Agregação

#### Aritméticos
- `$add` — soma
- `$subtract` — subtração
- `$multiply` — multiplicação
- `$divide` — divisão

#### Strings
- `$toUpper` — maiúsculas
- `$toLower` — minúsculas
- `$concat` — concatenar
- `$substr` — substring

#### Estatísticos
- `$sum` — soma
- `$avg` — média
- `$min` — mínimo
- `$max` — máximo
- `$count` — contagem

### Performance
- Coloque `$match` **primeiro** quando possível (reduz documentos)
- Use `$limit` e `$skip` no final
- Crie índices nos campos de `$match`

## 📝 Tarefas Práticas
- [ ] Contar usuários por cidade
- [ ] Calcular média de idade por skill
- [ ] Top 3 skills mais populares
- [ ] Contar posts por usuário
- [ ] Agrupar vendas por mês

## Tags
#mongodb #aggregation #pipeline #analytics
