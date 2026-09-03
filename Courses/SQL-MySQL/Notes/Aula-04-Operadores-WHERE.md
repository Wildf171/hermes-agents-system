# Aula 04 - Operadores WHERE e Filtros

## 📋 Resumo
Operadores lógicos e de filtro para queries complexas: AND, OR, NOT, IN, BETWEEN, LIKE e NULL.

## 🎯 Objetivos
- Dominar operadores WHERE
- Filtrar dados com múltiplas condições
- Usar padrões de busca (LIKE)
- Trabalhar com valores NULL

## 📚 Conteúdo Principal

### Tabela de Referência

A aula usa tabela `funcionarios`:
- id, nome, cargo, departamento, salario, idade, cidade, email, data_admissao, ativo

---

## Operadores Lógicos

### AND - Todas as Condições

```sql
-- Funcionários de TI em Taguatinga
SELECT * FROM funcionarios 
WHERE departamento = 'ti' AND cidade = 'taguatinga';

-- Desenvolvedores com idade > 30
SELECT * FROM funcionarios 
WHERE cargo = 'desenvolvedor' AND idade > 30;

-- TI, salário > 5000 E idade < 30
SELECT nome, cargo, salario, idade 
FROM funcionarios 
WHERE departamento = 'ti' 
  AND salario > 5000 
  AND idade < 30;
```

### OR - Qualquer Uma das Condições

```sql
-- TI OU Financeiro
SELECT * FROM funcionarios 
WHERE departamento = 'ti' OR departamento = 'financeiro';

-- Brasília OU Águas Claras
SELECT nome, cargo, salario 
FROM funcionarios 
WHERE cidade = 'brasilia' OR cidade = 'aguas claras';
```

### NOT - Inverter Condição

```sql
-- NÃO TI e NÃO Financeiro
SELECT * FROM funcionarios 
WHERE NOT departamento = 'ti' 
  AND NOT departamento = 'financeiro';

-- NÃO Brasília e NÃO Águas Claras
SELECT nome, cargo, salario 
FROM funcionarios 
WHERE NOT (cidade = 'brasilia' OR cidade = 'aguas claras');
```

---

## IS NULL / IS NOT NULL

### Verificar Valores Nulos

```sql
-- Funcionários SEM email
SELECT * FROM funcionarios 
WHERE email IS NULL;

-- Sem email E sem cidade
SELECT * FROM funcionarios 
WHERE email IS NULL AND cidade IS NULL;

-- Com email E com cidade
SELECT * FROM funcionarios 
WHERE email IS NOT NULL AND cidade IS NOT NULL;
```

---

## IN - Contém na Lista

### Sintaxe Simples para OR

```sql
-- Cidades: Brasília ou Taguatinga
SELECT * FROM funcionarios 
WHERE cidade IN ('brasilia', 'taguatinga');

-- NÃO nestas cidades
SELECT * FROM funcionarios 
WHERE NOT cidade IN ('brasilia', 'taguatinga');

-- Ou com NOT IN
SELECT * FROM funcionarios 
WHERE cidade NOT IN ('brasilia', 'taguatinga');
```

### Comparação: IN vs OR

```sql
-- COM IN (mais legível)
WHERE cidade IN ('brasilia', 'taguatinga', 'gama')

-- COM OR (mais verboso)
WHERE cidade = 'brasilia' 
   OR cidade = 'taguatinga' 
   OR cidade = 'gama'
```

---

## BETWEEN - Intervalo

### Sintaxe

```sql
-- Idade entre 18 e 30 (inclusive)
SELECT * FROM funcionarios 
WHERE idade BETWEEN 18 AND 30;

-- Fora do intervalo
SELECT * FROM funcionarios 
WHERE NOT idade BETWEEN 18 AND 30;

-- Ou
SELECT * FROM funcionarios 
WHERE idade < 18 OR idade > 30;
```

### Com Datas

```sql
-- Contratados em 2022
SELECT * FROM funcionarios 
WHERE data_admissao BETWEEN '2022-01-01' AND '2022-12-31';

-- Salário entre 5000 e 8000
SELECT * FROM funcionarios 
WHERE salario BETWEEN 5000 AND 8000;
```

---

## LIKE - Padrão de Texto

### Wildcards

| Padrão | Significado | Exemplo |
|---|---|---|
| `%` | Qualquer sequência | `'a%'` = começa com A |
| `_` | Exatamente 1 caractere | `'_a%'` = segunda letra A |

### Exemplos

```sql
-- Nomes começam com 'A'
SELECT * FROM funcionarios 
WHERE nome LIKE 'a%';

-- Segunda letra é 'a'
SELECT * FROM funcionarios 
WHERE nome LIKE '_a%';

-- Contém 'silva' em qualquer posição
SELECT * FROM funcionarios 
WHERE nome LIKE '%silva%';

-- Última letra é 's'
SELECT * FROM funcionarios 
WHERE nome LIKE '%s';

-- Terceira letra é 'b'
SELECT * FROM funcionarios 
WHERE nome LIKE '%__b%';
```

### Case-Insensitive por Padrão

```sql
-- Iguais em MySQL padrão:
WHERE nome LIKE 'antonio'  -- ANTONIO, Antonio, antonio
WHERE nome LIKE 'ANTONIO'

-- Forçar case-sensitive (se necessário):
WHERE BINARY nome LIKE 'antonio'  -- só 'antonio'
```

---

## Combinando Operadores

### Exemplo Complexo

```sql
-- Funcionários ativos
-- que são de TI ou Financeiro
-- com salário > 6000
-- e que têm email registrado
SELECT nome, cargo, salario 
FROM funcionarios 
WHERE ativo = TRUE 
  AND (departamento = 'ti' OR departamento = 'financeiro')
  AND salario > 6000
  AND email IS NOT NULL;
```

---

## 🔑 Resumo Rápido

| Operador | Uso |
|---|---|
| AND | Todas as condições devem ser verdadeiras |
| OR | Pelo menos uma deve ser verdadeira |
| NOT | Nega uma condição |
| IN (...) | Valor está na lista |
| BETWEEN ... AND | Valor está no intervalo |
| LIKE | Texto segue padrão |
| IS NULL | Campo vazio |
| IS NOT NULL | Campo preenchido |

---

## 📝 Tarefas Práticas

- [ ] Listar funcionários de 'TI' com salário > 7000
- [ ] Encontrar quem está em 'Brasília' OU 'Taguatinga'
- [ ] Mostrar funcionários NÃO ativos
- [ ] Listar quem NÃO tem email
- [ ] Funcionários nascidos entre 2000 e 2005
- [ ] Nomes que começam com 'C' ou 'P'
- [ ] Sem email E sem cidade registrada
- [ ] Salário BETWEEN 5000 AND 8000

---

## Tags
#mysql #sql #where #operadores #filtros
