# Aula 02 - Conceitos Intermediários

## 📋 Resumo
Aprofundamento em operações intermediárias de MongoDB, manipulação de dados e otimizações.

## 🎯 Objetivos
- Dominar operações complexas
- Trabalhar com subdocumentos
- Aplicar validações
- Otimizar operações

## 📚 Conteúdo Principal

### Estruturas Aninhadas (Nested Documents)

#### Exemplo de Estrutura
```javascript
{
  _id: ObjectId("..."),
  nome: "William",
  endereco: {
    rua: "Av. Paulista",
    numero: 1000,
    cidade: "São Paulo",
    cep: "01311-100"
  },
  contatos: [
    { tipo: "email", valor: "william@example.com" },
    { tipo: "telefone", valor: "11-99999999" }
  ]
}
```

#### Consultando Nested Documents
```javascript
// Buscar por campo aninhado
db.usuarios.find({ "endereco.cidade": "São Paulo" })

// Com múltiplos critérios
db.usuarios.find({
  "endereco.cep": "01311-100",
  "ativo": true
})
```

#### Atualizando Nested Documents
```javascript
// Atualizar subdocumento
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $set: { "endereco.cidade": "Rio de Janeiro" } }
)
```

### Trabalhando com Arrays

#### Adicionar a Array
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $push: { skills: "Python" } }
)
```

#### Remover de Array
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $pull: { skills: "Python" } }
)
```

#### Adicionar Múltiplos
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $push: { skills: { $each: ["Python", "Go", "Rust"] } } }
)
```

#### Encontrar por Elemento do Array
```javascript
// Usuários que sabem "JavaScript"
db.usuarios.find({ skills: "JavaScript" })

// Usuários com array vazio
db.usuarios.find({ skills: [] })
```

### Operadores Especiais

#### $exists - Campo Existe?
```javascript
// Usuários que têm campo "telefone"
db.usuarios.find({ telefone: { $exists: true } })

// Usuários que NÃO têm "telefone"
db.usuarios.find({ telefone: { $exists: false } })
```

#### $type - Verificar Tipo
```javascript
// Campos "idade" que são inteiros
db.usuarios.find({ idade: { $type: "int" } })

// Campos "ativo" que são booleanos
db.usuarios.find({ ativo: { $type: "bool" } })
```

#### $regex - Expressão Regular
```javascript
// Nomes que contêm "william" (case-insensitive)
db.usuarios.find({
  nome: { $regex: "william", $options: "i" }
})
```

### Bulk Operations

#### Múltiplas Operações Eficientes
```javascript
db.usuarios.bulkWrite([
  { 
    insertOne: { 
      document: { nome: "Alice", idade: 25 } 
    } 
  },
  { 
    updateOne: { 
      filter: { nome: "Bob" },
      update: { $set: { ativo: true } }
    } 
  },
  { 
    deleteOne: { 
      filter: { nome: "Charlie" } 
    } 
  }
])
```

### Transações

#### Operação Atomica (Aula 06+)
```javascript
const session = db.getMongo().startSession()
session.startTransaction()

try {
  db.usuarios.updateOne(
    { _id: user_id },
    { $inc: { saldo: -100 } },
    { session }
  )
  db.transacoes.insertOne(
    { usuario_id: user_id, tipo: "saque", valor: 100 },
    { session }
  )
  session.commitTransaction()
} catch (error) {
  session.abortTransaction()
  console.log(error)
}
```

### TTL Index - Dados que Expiram

```javascript
// Sessions expiram após 3600 segundos (1 hora)
db.sessions.createIndex(
  { createdAt: 1 },
  { expireAfterSeconds: 3600 }
)
```

### Text Index - Busca por Texto

```javascript
// Criar índice de texto
db.posts.createIndex({ titulo: "text", conteudo: "text" })

// Buscar
db.posts.find({ $text: { $search: "MongoDB" } })
```

## 🔑 Operadores Úteis
- `$size` — tamanho do array
- `$elemMatch` — elemento que satisfaz condição
- `$position` — posição no array
- `$each` — iterar sobre array
- `$slice` — fatiar array (primeiros/últimos N)

## 📝 Tarefas Práticas
- [ ] Criar documento com subdocumentos
- [ ] Consultar por campo aninhado
- [ ] Atualizar array (push/pull)
- [ ] Usar $exists para verificar campos
- [ ] Fazer bulk operation com 3+ operações
- [ ] Criar TTL index para limpeza automática

## 🎯 Resumo Rápido
- Nested documents = estruturas hierárquicas
- Arrays = dados repetidos
- Operadores especiais = buscas avançadas
- Bulk operations = eficiência
- TTL index = limpeza automática

## Tags
#mongodb #nested #arrays #operadores #intermediario
