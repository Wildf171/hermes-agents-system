# Aula 03 - CRUD Operations

## 📋 Resumo
Operações fundamentais de Create, Read, Update e Delete em MongoDB.

## 🎯 Objetivos
- Dominar inserção de documentos
- Consultar dados com queries
- Atualizar documentos
- Deletar dados

## 📚 Conteúdo Principal

### CREATE - Inserindo Documentos

#### insertOne()
```javascript
db.users.insertOne({
  nome: "William",
  email: "william@example.com",
  idade: 25
})
```

#### insertMany()
```javascript
db.users.insertMany([
  { nome: "Alice", idade: 22 },
  { nome: "Bob", idade: 30 }
])
```

### READ - Consultando Dados

#### find() - Listar todos
```javascript
db.users.find()
```

#### find() com filtro
```javascript
db.users.find({ idade: { $gt: 25 } })
```

#### findOne() - Um documento
```javascript
db.users.findOne({ nome: "William" })
```

### UPDATE - Atualizando Dados

#### updateOne()
```javascript
db.users.updateOne(
  { nome: "William" },
  { $set: { idade: 26 } }
)
```

#### updateMany()
```javascript
db.users.updateMany(
  { idade: { $lt: 18 } },
  { $set: { ativo: false } }
)
```

#### Operadores de Update
- `$set` — define valor
- `$inc` — incrementa
- `$push` — adiciona a array
- `$pull` — remove de array
- `$unset` — remove campo

### DELETE - Deletando Dados

#### deleteOne()
```javascript
db.users.deleteOne({ nome: "William" })
```

#### deleteMany()
```javascript
db.users.deleteMany({ ativo: false })
```

## 🔑 Operadores de Query
- `$eq` — igual
- `$ne` — não igual
- `$gt` — maior que
- `$gte` — maior ou igual
- `$lt` — menor que
- `$lte` — menor ou igual
- `$in` — em array
- `$nin` — não em array

## 📝 Tarefas Práticas
- [ ] Inserir 5 documentos em collection "alunos"
- [ ] Encontrar todos com idade > 20
- [ ] Atualizar idade de um aluno
- [ ] Deletar um documento
- [ ] Atualizar múltiplos documentos

## Tags
#mongodb #crud #operacoes #basico
