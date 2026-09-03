---
type: conceito
status: ready
created: 2026-09-03
updated: 2026-09-03
tags: [conceito, postgresql, database, ready]
related: []
---

# PostgreSQL — Fundamentals

PostgreSQL é um SGBD **relacional, open-source e poderoso** com suporte a JSON, arrays, e muito mais.

---

## Por Que PostgreSQL?

✅ **Confiável** — ACID transactions  
✅ **Poderoso** — JSON, Arrays, Full-text search  
✅ **Versátil** — Relacional + NoSQL features  
✅ **Open-source** — Grátis e comunidade ativa  
✅ **Production-ready** — Usado em grandes sistemas  

---

## Conceitos Chave

### 1. CREATE TABLE
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

### 2. CRUD Operations
```sql
-- CREATE
INSERT INTO users (name, email) 
VALUES ('John Doe', 'john@example.com');

-- READ
SELECT * FROM users WHERE name = 'John Doe';

-- UPDATE
UPDATE users SET email = 'newemail@example.com' WHERE id = 1;

-- DELETE
DELETE FROM users WHERE id = 1;
```

---

### 3. JOINs — Relacionamentos
```sql
-- INNER JOIN
SELECT users.name, orders.total
FROM users
INNER JOIN orders ON users.id = orders.user_id;

-- LEFT JOIN
SELECT users.name, COUNT(orders.id) as order_count
FROM users
LEFT JOIN orders ON users.id = orders.user_id
GROUP BY users.id;
```

---

### 4. Índices — Performance
```sql
-- Sem índice: scan completo (SLOW)
SELECT * FROM users WHERE email = 'john@example.com';

-- Com índice: lookup rápido (FAST)
CREATE INDEX idx_users_email ON users(email);
```

---

### 5. Constraints
```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    total DECIMAL(10, 2) NOT NULL CHECK (total > 0),
    status VARCHAR(20) DEFAULT 'pending'
);
```

---

## Tipos de Dados Especiais

### JSON
```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    metadata JSON  -- ou JSONB (melhor performance)
);

INSERT INTO products (name, metadata)
VALUES ('Widget', '{"color": "blue", "size": "large"}');

-- Query JSON
SELECT metadata->>'color' FROM products;
```

---

### Arrays
```sql
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    tags TEXT[]
);

INSERT INTO tags (tags)
VALUES (ARRAY['python', 'django', 'fastapi']);

-- Query arrays
SELECT * FROM tags WHERE 'python' = ANY(tags);
```

---

## Transações — ACID

```sql
BEGIN;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

COMMIT;  -- Se tudo OK, salva
-- ROLLBACK;  -- Se erro, desfaz
```

---

## Window Functions — Análise

```sql
-- Rank por departamento
SELECT name, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) as rank
FROM employees;
```

---

## Armadilhas Comuns

⚠️ **N+1 Queries**
```sql
-- ❌ Ruim — múltiplas queries
SELECT * FROM users;
-- Para cada user, fazer:
SELECT * FROM orders WHERE user_id = ?;

-- ✅ Bom — uma query
SELECT users.*, orders.*
FROM users
LEFT JOIN orders ON users.id = orders.user_id;
```

⚠️ **Sem índices em WHERE**
```sql
-- ❌ Slow
SELECT * FROM users WHERE created_at > '2024-01-01';

-- ✅ Fast
CREATE INDEX idx_users_created ON users(created_at);
```

---

## Próximas Leituras

- [[Window Functions in PostgreSQL]] — Análise avançada
- [[Query Optimization]] — Performance tuning
- [[09 - BANCO DE DADOS (APLICADO)/]] — Mais sobre BD

---

**Status**: ready  
**Usada em**: Sistema André, neo-clinica
