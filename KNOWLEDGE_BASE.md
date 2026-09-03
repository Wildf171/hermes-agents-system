# Knowledge Base - Cursos de William

Esta é a base de conhecimento centralizada que os Hermes agents consultam para fornecer recomendações e ajuda sobre os cursos de estudo.

---

## 📚 MongoDB (NoSQL)

### Aulas Disponíveis
1. **Aula 01 - Introdução ao MongoDB**
   - O que é MongoDB, SQL vs NoSQL
   - Instalação, primeiro database
   - Estrutura: Database > Collection > Document

2. **Aula 02 - Conceitos Intermediários**
   - Nested documents e arrays
   - Operadores especiais ($exists, $type, $regex)
   - Bulk operations e transações
   - TTL index, Text index

3. **Aula 03 - CRUD Operations**
   - insertOne(), insertMany()
   - find(), findOne()
   - updateOne(), updateMany(), operadores ($set, $inc, $push, $pull)
   - deleteOne(), deleteMany()

4. **Aula 04 - Queries Avançadas**
   - AND, OR, $not
   - Busca em arrays
   - Expressões regulares
   - Projeção, sorting, limit, skip
   - Paginação

5. **Aula 05 - Schema Validation**
   - JSON Schema validation
   - Tipos BSON
   - Normalização vs Desnormalização
   - Índices para performance

6. **Aula 06 - Aggregation Pipeline**
   - $match, $project, $group, $sort
   - $unwind — desempacotar arrays
   - Operadores: $sum, $avg, $min, $max
   - Pipeline com múltiplos estágios

7. **Aula 07 - Produção (MDB 2B)**
   - ReplicaSet (alta disponibilidade)
   - Sharding (escalabilidade horizontal)
   - Autenticação e segurança
   - Backup com mongodump/mongorestore
   - Monitoramento: mongostat, mongotop

### Quick Reference
```javascript
// Inserir
db.collection.insertOne({ name: "William", age: 25 })

// Consultar
db.collection.find({ age: { $gt: 20 } })

// Atualizar
db.collection.updateOne(
  { name: "William" },
  { $set: { age: 26 } }
)

// Agregar
db.collection.aggregate([
  { $match: { active: true } },
  { $group: { _id: "$category", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])
```

### Recomendação de Sequência
**Iniciante**: Aula 01 → 02 → 03
**Intermediário**: Aula 04 → 05
**Avançado**: Aula 06 → 07

---

## 📚 SQL/MySQL (Relacional)

### Aulas Disponíveis
1. **Aula 01 - Introdução a Banco de Dados** (em breve)
2. **Aula 02 - Modelagem ER e Criação de Tabelas** (em breve)

3. **Aula 03 - CRUD Básico e ALTER TABLE**
   - CREATE DATABASE, CREATE TABLE
   - Constraints: PRIMARY KEY, UNIQUE, NOT NULL, CHECK, DEFAULT, TIMESTAMP
   - INSERT INTO, SELECT, DESCRIBE
   - ALTER TABLE: ADD, DROP, MODIFY COLUMN

4. **Aula 04 - Operadores WHERE e Filtros**
   - AND, OR, NOT — operadores lógicos
   - IS NULL, IS NOT NULL
   - IN — busca em lista
   - BETWEEN — intervalo
   - LIKE — padrões com % e _

5. **Aula 05 - JOINs Relacionais** (em breve)
6. **Aula 06 - Aggregations** (em breve)
7. **Aula 07 - Subqueries Avançadas** (em breve)
8. **Aula 08 - Índices e Otimização** (em breve)

### Quick Reference
```sql
-- Criar tabela
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    idade INT CHECK (idade >= 18),
    ativo BOOLEAN DEFAULT TRUE
);

-- Inserir
INSERT INTO usuarios (nome, email, idade) 
VALUES ('William', 'william@example.com', 25);

-- Consultar com filtros
SELECT * FROM usuarios 
WHERE idade > 20 AND ativo = TRUE 
ORDER BY nome 
LIMIT 10;

-- Atualizar
UPDATE usuarios 
SET idade = 26 
WHERE nome = 'William';

-- Deletar
DELETE FROM usuarios WHERE ativo = FALSE;
```

### Recomendação de Sequência
**Iniciante**: Aula 03 → 04
**Intermediário**: Aula 05 → 06
**Avançado**: Aula 07 → 08

---

## 🎯 Roadmaps por Agent

### Agent: **backend** (Java, APIs, BD)
**Recomendação**: MongoDB (Aula 06-07 para scaling), SQL (Aula 05-08 para JOINs complexos)
**Use case**: "Recomende aggregations para agrupar vendas por mês"

### Agent: **database** ou **postgresql**/**nosql**
**Recomendação**: Todo o conteúdo SQL/MongoDB
**Use case**: "Como indexar collection para melhorar query?"

### Agent: **java**/**javascript**
**Recomendação**: MongoDB Aula 03-04, SQL Aula 03-04
**Use case**: "Escreva Node.js code para conectar em MongoDB"

### Agent: **frontend**
**Recomendação**: SQL Aula 06 (Aggregations para relatórios), MongoDB Aula 06
**Use case**: "Dados para dashboard de vendas"

---

## 💡 Como Usar

### Para William
Quando você disser a um agent:
- "Me explique JOINs" → Agent consulta SQL Aula 05
- "Como fazer aggregation de vendas?" → Agent consulta MongoDB Aula 06
- "Crie uma query SQL otimizada" → Agent consulta SQL Aula 08

### Para Agents (Sistema)
1. Consultar este arquivo quando receber perguntas sobre cursos
2. Referenciar a aula específica quando encontrar correspondência
3. Sugerir sequência de aprendizado baseado no nível
4. Fornecer exemplos das aulas quando pertinente

---

## 📊 Status dos Cursos

| Curso | Aulas | Completas | % |
|---|---|---|---|
| MongoDB | 7 | 7 | 100% |
| SQL/MySQL | 8 | 2 | 25% |
| JavaScript | (em breve) | - | - |
| Java | (em breve) | - | - |

---

## 🔗 Links para Aulas Completas

### MongoDB
- [[Courses/NoSQL-MongoDB/Notes/Aula-01-Introducao-ao-MongoDB]]
- [[Courses/NoSQL-MongoDB/Notes/Aula-02-Conceitos-Intermediarios]]
- [[Courses/NoSQL-MongoDB/Notes/Aula-03-CRUD-Operations]]
- [[Courses/NoSQL-MongoDB/Notes/Aula-04-Queries-Avancadas]]
- [[Courses/NoSQL-MongoDB/Notes/Aula-05-Schema-Validation]]
- [[Courses/NoSQL-MongoDB/Notes/Aula-06-Agregacao]]
- [[Courses/NoSQL-MongoDB/Notes/Aula-07-MDB2B]]

### SQL/MySQL
- [[Courses/SQL-MySQL/Notes/Aula-03-CRUD-e-ALTER-TABLE]]
- [[Courses/SQL-MySQL/Notes/Aula-04-Operadores-WHERE]]

---

**Última atualização**: 2026-09-02
**Autores das aulas**: William Gabriel (estudos Neo Desenvolver)
