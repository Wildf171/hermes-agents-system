---
type: conceito
status: ready
created: 2026-09-03
updated: 2026-09-03
tags: [conceito, padrões, engenharia, ready]
related: []
---

# Design Patterns — Introdução

Design Patterns são **soluções reutilizáveis** para problemas comuns em design de software.

Pense como "receitas" que você pode usar quando enfrenta um problema típico.

---

## Os 3 Tipos de Patterns

### 1️⃣ **Creational Patterns** — Criação de Objetos
Como criar objetos de forma eficiente e reutilizável.

**Exemplos**:
- **Singleton** — Uma única instância de uma classe
- **Factory** — Criar objetos sem especificar classe exata
- **Builder** — Construir objetos complexos passo a passo
- **Prototype** — Clonar objetos

---

### 2️⃣ **Structural Patterns** — Estrutura de Objetos
Como organizar relacionamentos entre objetos.

**Exemplos**:
- **Adapter** — Adaptar interface de uma classe
- **Decorator** — Adicionar funcionalidade dinamicamente
- **Facade** — Simplificar interface complexa
- **Proxy** — Controlar acesso a outro objeto

---

### 3️⃣ **Behavioral Patterns** — Comportamento de Objetos
Como objetos interagem e distribuem responsabilidades.

**Exemplos**:
- **Observer** — Notificar múltiplos objetos de mudança
- **Strategy** — Encapsular algoritmos intercambiáveis
- **Command** — Encapsular request como objeto
- **State** — Mudar comportamento baseado em estado

---

## Exemplo: Singleton Pattern

```python
# Problema: Você quer garantir que há apenas UMA instância de um objeto
# (ex: database connection, logger, config)

# ✅ Solução: Singleton Pattern
class Database:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

# Qualquer lugar que use:
db1 = Database()
db2 = Database()

print(db1 is db2)  # True — mesma instância!
```

---

## Exemplo: Factory Pattern

```python
# Problema: Você tem múltiplos tipos de pagamento
# (Credit Card, PayPal, Bitcoin) e quer criar sem saber qual

# ✅ Solução: Factory Pattern
class PaymentGateway:
    @staticmethod
    def create(payment_type):
        if payment_type == "credit_card":
            return CreditCardGateway()
        elif payment_type == "paypal":
            return PayPalGateway()
        elif payment_type == "bitcoin":
            return BitcoinGateway()

# Uso:
gateway = PaymentGateway.create("credit_card")
gateway.process()
```

---

## Por Que Usar Design Patterns?

✅ **Solução comprovada** — Não reinventa roda  
✅ **Comunicação** — Nomes padrão que todo dev conhece  
✅ **Manutenção** — Código mais organizado  
✅ **Extensibilidade** — Fácil adicionar novo comportamento  

---

## Cuidado: Não Abuse!

⚠️ **Over-engineering** — Usar pattern quando não precisa  
⚠️ **Complexidade** — Patterns podem adicionar complexidade  
⚠️ **YAGNI** — "You Aren't Gonna Need It"

**Regra**: Use pattern quando resolver um problema real, não porque é "bonitinho".

---

## Próximas Leituras

- [[SOLID Principles]] — Fundações para patterns
- [[Clean Code]] — Boas práticas gerais

---

**Status**: ready  
**Última revisão**: 2026-09-03
