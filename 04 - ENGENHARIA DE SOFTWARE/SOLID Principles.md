---
type: conceito
status: ready
created: 2026-09-03
updated: 2026-09-03
tags: [conceito, engenharia, padrões, ready]
related: []
---

# SOLID Principles

SOLID é um acrônimo para 5 princípios de design orientado a objetos que tornam código mais legível, mantenível e extensível.

---

## Os 5 Princípios

### 1. **S** — Single Responsibility Principle (SRP)
Uma classe deve ter **apenas uma razão para mudar**.

**Significa**: Cada classe/módulo deve ter uma única responsabilidade bem definida.

```python
# ❌ Ruim — Múltiplas responsabilidades
class User:
    def create_user(self): pass
    def send_email(self): pass
    def generate_report(self): pass

# ✅ Bom — Uma responsabilidade por classe
class User:
    def create_user(self): pass

class EmailService:
    def send_email(self): pass

class ReportGenerator:
    def generate_report(self): pass
```

---

### 2. **O** — Open/Closed Principle (OCP)
Classes devem estar **abertas para extensão** mas **fechadas para modificação**.

**Significa**: Você deve conseguir estender comportamento sem modificar código existente.

```python
# ❌ Ruim — Precisa modificar classe existente
class PaymentProcessor:
    def process(self, payment_type):
        if payment_type == "credit_card":
            # processo
        elif payment_type == "paypal":
            # processo

# ✅ Bom — Extensível sem modificação
class PaymentProcessor:
    def process(self, payment_gateway):
        payment_gateway.process()

class CreditCardGateway:
    def process(self): pass

class PayPalGateway:
    def process(self): pass
```

---

### 3. **L** — Liskov Substitution Principle (LSP)
Subclasses devem ser **substituíveis** por suas classes base.

**Significa**: Se S é subtipo de T, instâncias de S devem substituir instâncias de T sem quebrar o programa.

```python
# ❌ Ruim — Viola LSP
class Bird:
    def fly(self): pass

class Penguin(Bird):
    def fly(self):
        raise NotImplementedError("Penguins can't fly")

# ✅ Bom — Respeitando LSP
class Bird:
    def move(self): pass

class FlyingBird(Bird):
    def fly(self): pass

class Penguin(Bird):
    def swim(self): pass
```

---

### 4. **I** — Interface Segregation Principle (ISP)
Clientes não devem ser forçados a depender de interfaces que não usam.

**Significa**: Múltiplas interfaces específicas são melhores que uma interface genérica.

```python
# ❌ Ruim — Interface gigante
class Animal:
    def eat(self): pass
    def fly(self): pass
    def swim(self): pass

# ✅ Bom — Interfaces segregadas
class Eater:
    def eat(self): pass

class Flyer:
    def fly(self): pass

class Swimmer:
    def swim(self): pass

class Duck(Eater, Flyer, Swimmer):
    pass

class Fish(Eater, Swimmer):
    pass
```

---

### 5. **D** — Dependency Inversion Principle (DIP)
Dependa de abstrações, não de implementações concretas.

**Significa**: Classes de alto nível não devem depender de classes de baixo nível. Ambas devem depender de abstrações.

```python
# ❌ Ruim — Dependência em implementação
class UserService:
    def __init__(self):
        self.db = MySQLDatabase()  # Acoplado a MySQL

# ✅ Bom — Dependência injetada
class UserService:
    def __init__(self, database):  # Abstração
        self.db = database

# Pode usar qualquer banco de dados
service = UserService(MySQLDatabase())
service = UserService(MongoDBDatabase())
```

---

## Por Que SOLID Importa?

✅ **Código mais legível** — Fácil de entender  
✅ **Mais mantenível** — Fácil de modificar  
✅ **Mais testável** — Fácil de testar  
✅ **Menos acoplamento** — Menos interdependências  
✅ **Mais extensível** — Fácil de adicionar features  

---

## Quando Usar?

- ✅ Em projetos grandes
- ✅ Em código que será mantido por tempo longo
- ✅ Em equipes (código compartilhado)
- ⚠️ Equilibre — Don't over-engineer

---

## Relacionados

- [[Design Patterns]] — Implementação de SOLID
- [[Clean Code]] — Boas práticas gerais
- [[03 - ENGENHARIA DE SOFTWARE/]] — Mais conceitos

---

**Dica**: SOLID não é um dogma. Use quando fizer sentido, não sempre.

---

**Status**: ready  
**Última revisão**: 2026-09-03
