# Aula 05 - Schema Validation e Design

## 📋 Resumo
Validação de schema, design de documentos e boas práticas no MongoDB.

## 🎯 Objetivos
- Impor validação em collections
- Desenhar schemas eficientes
- Evitar problemas comuns
- Aplicar normalizações necessárias

## 📚 Conteúdo Principal

### Por que Validação?
- MongoDB é schema-less, mas dados precisam de consistência
- Validação garante qualidade
- Previne erros em aplicações

### Schema Validation

#### Criar Collection com Validação
```javascript
db.createCollection("users", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["email", "nome"],
      properties: {
        _id: { bsonType: "objectId" },
        nome: { 
          bsonType: "string",
          minLength: 3,
          maxLength: 100
        },
        email: { 
          bsonType: "string",
          pattern: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        },
        idade: { 
          bsonType: "int",
          minimum: 0,
          maximum: 150
        },
        ativo: { bsonType: "bool" }
      }
    }
  }
})
```

### Tipos de Dados BSON
- `string` — texto
- `int` / `double` — números
- `bool` — verdadeiro/falso
- `date` — data
- `array` — lista
- `object` — documento
- `null` — nulo
- `objectId` — ID único

### Design de Documentos

#### Estrutura de Usuário
```javascript
{
  _id: ObjectId("..."),
  nome: "William",
  email: "william@example.com",
  perfil: {
    idade: 25,
    cidade: "São Paulo",
    bio: "Desenvolvedor"
  },
  skills: ["JavaScript", "Java", "MongoDB"],
  cursos: [
    {
      nome: "JavaScript Avançado",
      status: "Em andamento",
      progresso: 75
    }
  ],
  dataCadastro: ISODate("2024-01-20"),
  ativo: true
}
```

### Normalização vs Desnormalização

#### Normalizado (Referências)
```javascript
// Collection users
{ _id: 1, nome: "William" }

// Collection posts
{ _id: 1, userId: 1, titulo: "MongoDB Tips" }
```

#### Desnormalizado (Embedded)
```javascript
{
  _id: 1,
  nome: "William",
  posts: [
    { titulo: "MongoDB Tips", data: ISODate(...) }
  ]
}
```

**Quando usar:**
- **Embedded** — dados frequentemente acessados juntos
- **Referências** — dados grandes ou compartilhados

### Indices para Performance

```javascript
// Criar índice simples
db.users.createIndex({ email: 1 })

// Índice composto
db.users.createIndex({ nome: 1, idade: -1 })

// Índice único
db.users.createIndex({ email: 1 }, { unique: true })

// Listar índices
db.users.getIndexes()
```

## 🔑 Boas Práticas
1. Use `_id` com ObjectId (automático)
2. Normalize quando dados são mutáveis ou muito grandes
3. Denormalize quando há muitos JOINs
4. Sempre valide tipos críticos
5. Crie índices em campos frequentemente consultados
6. Evite arrays infinitos

## 📝 Tarefas Práticas
- [ ] Criar collection "alunos" com validação
- [ ] Definir tipos para nome, email, idade
- [ ] Fazer requerido: nome, email
- [ ] Testar inserção válida e inválida
- [ ] Criar índice em email

## Tags
#mongodb #schema #validation #design
