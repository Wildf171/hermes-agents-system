---
type: conceito
status: ready
created: 2026-09-03
updated: 2026-09-03
tags: [conceito, python, programação, ready]
related: []
---

# Python — Fundamentals

Python é uma linguagem interpretada, dinâmica e com foco em legibilidade.

---

## Por Que Python?

✅ Sintaxe clara e legível  
✅ Curva de aprendizado suave  
✅ Comunidade enorme  
✅ Bibliotecas ricas (NumPy, Pandas, Django, FastAPI, etc)  
✅ Versátil (web, data science, automation, ML)  

---

## Conceitos Chave

### 1. Type Hints (Python 3.5+)
```python
def greet(name: str) -> str:
    return f"Hello, {name}"

def add(a: int, b: int) -> int:
    return a + b
```

**Por quê?** Melhor documentação e detecção de erros com mypy.

---

### 2. List Comprehensions
```python
# Sem comprehension
numbers = [1, 2, 3, 4, 5]
squared = []
for n in numbers:
    squared.append(n ** 2)

# Com comprehension
squared = [n ** 2 for n in numbers]  # Mais legível!
```

---

### 3. Decorators
```python
def timer(func):
    def wrapper(*args, **kwargs):
        print(f"Executando {func.__name__}")
        return func(*args, **kwargs)
    return wrapper

@timer
def hello():
    print("Hello!")

hello()  # Printa "Executando hello" e depois "Hello!"
```

---

### 4. Context Managers
```python
# Sem context manager
f = open("file.txt")
content = f.read()
f.close()

# Com context manager (melhor — fecha automaticamente)
with open("file.txt") as f:
    content = f.read()
```

---

### 5. Async & Await (Python 3.7+)
```python
import asyncio

async def fetch_data():
    # Simular requisição HTTP
    await asyncio.sleep(1)
    return "Data"

async def main():
    result = await fetch_data()
    print(result)

asyncio.run(main())
```

---

## Padrões Comuns

### Unpacking
```python
# Tuplas
x, y = (1, 2)

# Dicts
person = {"name": "John", "age": 30}
name, age = person.values()

# Com *args
first, *rest = [1, 2, 3, 4]
# first = 1, rest = [2, 3, 4]
```

### Walrus Operator (Python 3.8+)
```python
# Antes
data = get_data()
if data:
    process(data)

# Com walrus operator
if (data := get_data()):
    process(data)
```

---

## Armadilhas Comuns

⚠️ **Mutable Default Arguments**
```python
# ❌ Ruim
def add_item(item, list=[]):
    list.append(item)
    return list

# ✅ Bom
def add_item(item, list=None):
    if list is None:
        list = []
    list.append(item)
    return list
```

⚠️ **Global vs Local**
```python
x = 10

def change_x():
    x = 20  # Cria nova variável local, não muda a global
    return x

print(change_x())  # 20
print(x)  # 10 (não mudou!)
```

---

## Próximas Leituras

- [[Python - Type Hints]] — Sistema de tipos
- [[Async & Await in Python]] — Programação assíncrona
- [[04 - PROGRAMACAO/]] — Mais sobre Python

---

**Status**: ready  
**Última revisão**: 2026-09-03
