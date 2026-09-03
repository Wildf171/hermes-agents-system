# Aula 04 - Queries Avançadas

## 📋 Resumo
Técnicas avançadas de busca e filtragem em MongoDB.

## 🎯 Objetivos
- Dominar queries complexas
- Usar agregação
- Otimizar buscas
- Trabalhar com expressões regulares

## 📚 Conteúdo Principal

### Queries com Múltiplos Critérios

#### AND (implícito)
```javascript
db.users.find({
  idade: { $gte: 18 },
  ativo: true
})
```

#### OR Explícito
```javascript
db.users.find({
  $or: [
    { email: "william@example.com" },
    { email: "alice@example.com" }
  ]
})
```

#### AND + OR Combinado
```javascript
db.users.find({
  $and: [
    { idade: { $gte: 18 } },
    { $or: [{ cidade: "SP" }, { cidade: "RJ" }] }
  ]
})
```

### Busca em Arrays

#### Elemento em Array
```javascript
db.users.find({
  skills: "JavaScript"
})
```

#### Múltiplos Elementos
```javascript
db.users.find({
  skills: { $all: ["JavaScript", "MongoDB"] }
})
```

#### Tamanho do Array
```javascript
db.users.find({
  skills: { $size: 3 }
})
```

### Expressões Regulares

```javascript
// Começa com 'W'
db.users.find({
  nome: { $regex: "^W" }
})

// Contém 'son' (case-insensitive)
db.users.find({
  nome: { $regex: "son", $options: "i" }
})
```

### Projeção - Selecionar Campos

```javascript
// Mostrar só nome e idade
db.users.find({}, { nome: 1, idade: 1, _id: 0 })

// Excluir email
db.users.find({}, { email: 0 })
```

### Sorting e Limitação

```javascript
// Ordenar por idade descrescente, limite 10
db.users.find()
  .sort({ idade: -1 })
  .limit(10)

// Paginação
db.users.find()
  .skip(20)
  .limit(10)
```

### Contagem

```javascript
// Contar documentos
db.users.find({ ativo: true }).count()

// Ou
db.users.countDocuments({ ativo: true })
```

## 🔑 Operadores Importantes
- `$regex` — expressão regular
- `$all` — contém todos
- `$size` — tamanho do array
- `$elemMatch` — elemento que atende critério
- `$exists` — campo existe

## 📝 Tarefas Práticas
- [ ] Buscar usuários que moram em SP ou RJ
- [ ] Encontrar quem tem JavaScript AND Java
- [ ] Buscar nomes que começam com 'A'
- [ ] Listar top 5 usuários mais velhos
- [ ] Contar quantos estudam Java

## Tags
#mongodb #queries #avancado #agregacao
