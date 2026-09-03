# Aula 03 - CRUD Básico e ALTER TABLE

## 📋 Resumo
Operações CREATE, INSERT, SELECT básicas e alteração de estrutura de tabelas com ALTER TABLE.

## 🎯 Objetivos
- Criar databases e tabelas
- Inserir dados
- Consultar dados básicos
- Modificar estrutura de tabelas

## 📚 Conteúdo Principal

### Criar Database

```sql
CREATE DATABASE crud1;
USE crud1;
```

### Criar Tabela com Constraints

```sql
CREATE TABLE usuarios (
    coduser INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    idade INT CHECK (idade >= 18),
    cpf VARCHAR(15) NOT NULL UNIQUE,
    uf VARCHAR(2) DEFAULT 'df',
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Constraints Explicados
| Constraint | Descrição |
|---|---|
| PRIMARY KEY | Identificador único, não nulo |
| AUTO_INCREMENT | Incrementa automaticamente |
| NOT NULL | Obrigatório |
| UNIQUE | Valor único em toda coluna |
| CHECK | Validação de valor (ex: idade >= 18) |
| DEFAULT | Valor padrão se não informado |
| TIMESTAMP | Data/hora automática |

### INSERT - Inserindo Dados

#### Sintaxe Completa
```sql
INSERT INTO usuarios 
(coduser, nome, idade, cpf, uf, data_cadastro)
VALUES
(NULL, 'Antonio', 19, '111.111.111-32', DEFAULT, DEFAULT);
```

#### Shorthand (colunas com DEFAULT)
```sql
INSERT INTO usuarios 
VALUES (NULL, 'Antonio', 19, '111.111.111-32', DEFAULT, DEFAULT);
```

### SELECT - Consultando Dados

```sql
-- Todos os registros
SELECT * FROM usuarios;

-- Colunas específicas
SELECT coduser, nome, idade FROM usuarios;
```

### DESCRIBE - Ver Estrutura

```sql
DESCRIBE usuarios;
```

Mostra:
- Nome de cada coluna
- Tipo de dado
- Se permite NULL
- Chaves (KEY)
- DEFAULT
- Extra (AUTO_INCREMENT, etc)

---

## ALTER TABLE - Modificar Estrutura

### ADD COLUMN - Adicionar Coluna

```sql
-- Adicionar email após nome
ALTER TABLE usuarios ADD email VARCHAR(50) AFTER nome;

-- Adicionar no final
ALTER TABLE usuarios ADD endereco VARCHAR(100);
```

### DROP COLUMN - Remover Coluna

```sql
ALTER TABLE usuarios DROP COLUMN email;
```

### MODIFY COLUMN - Alterar Tipo/Tamanho

```sql
-- Alterar tipo de VARCHAR para CHAR
ALTER TABLE usuarios MODIFY COLUMN nome CHAR(100);

-- Alterar restrições
ALTER TABLE usuarios MODIFY COLUMN idade DATE;
```

### CHANGE - Renomear Coluna

```sql
-- Renomear e mudar tipo
ALTER TABLE usuarios CHANGE COLUMN uf estado VARCHAR(2);
```

### ADD CONSTRAINT - Adicionar Restrição

```sql
ALTER TABLE usuarios ADD UNIQUE (cpf);
ALTER TABLE usuarios ADD CHECK (idade >= 18);
```

### DROP CONSTRAINT - Remover Restrição

```sql
-- Encontrar nome da constraint
SHOW CREATE TABLE usuarios;

-- Remover
ALTER TABLE usuarios DROP CONSTRAINT usuarios_ibfk_1;
```

---

## 🔑 Tipos de Dados Principais

| Tipo | Uso |
|---|---|
| INT | Números inteiros |
| VARCHAR(n) | Texto até n caracteres |
| CHAR(n) | Texto fixo n caracteres |
| DECIMAL(p,s) | Número com decimais (p=total, s=casas) |
| DATE | Data (YYYY-MM-DD) |
| DATETIME | Data e hora |
| TIMESTAMP | Data/hora automática |
| BOOLEAN | Verdadeiro/Falso |
| TEXT | Texto longo |

---

## 📝 Tarefas Práticas

- [ ] Criar database "escola"
- [ ] Criar table "alunos" com: id, nome, email, matricula (UNIQUE), data_cadastro
- [ ] Inserir 5 alunos
- [ ] Ver estrutura com DESCRIBE
- [ ] Adicionar coluna "telefone" após email
- [ ] Mudar nome de "matricula" para "registration"
- [ ] Remover coluna "telefone"

---

## ⚠️ Notas Importantes

1. **DEFAULT vs NULL** — DEFAULT define valor automático; NULL permite ausência
2. **AUTO_INCREMENT** — só funciona em INT e como PRIMARY KEY
3. **UNIQUE** — NULL é permitido múltiplas vezes (comportamento padrão)
4. **CHECK** — validação em nível de banco de dados
5. **ALTER TABLE** — melhor fazer planejamento antes de criar tabela

---

## Tags
#mysql #sql #crud #alter-table #constraints
