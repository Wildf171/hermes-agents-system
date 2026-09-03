---
type: conceito
status: ready
created: 2026-09-03
updated: 2026-09-03
tags: [conceito, fastapi, backend, ready]
related: []
---

# FastAPI — Introdução

FastAPI é um framework **moderno e rápido** para construir APIs REST em Python.

---

## Por Que FastAPI?

✅ **Rápido** — Um dos mais rápidos em Python (comparable ao Node.js)  
✅ **Type hints** — Validação automática com Pydantic  
✅ **Documentação automática** — Swagger UI pronto  
✅ **Async nativo** — async/await por padrão  
✅ **Seguro** — Validação de dados built-in  

---

## Conceitos Chave

### 1. Hello World
```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def read_root():
    return {"message": "Hello, World!"}

# Rodas com: uvicorn main:app --reload
```

---

### 2. Path Parameters
```python
@app.get("/users/{user_id}")
async def get_user(user_id: int):
    return {"user_id": user_id}

# GET /users/123 → {"user_id": 123}
```

---

### 3. Query Parameters
```python
@app.get("/items/")
async def read_items(skip: int = 0, limit: int = 10):
    return {"skip": skip, "limit": limit}

# GET /items/?skip=5&limit=20 → {"skip": 5, "limit": 20}
```

---

### 4. Request Body (Pydantic Models)
```python
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    price: float
    description: str = None

@app.post("/items/")
async def create_item(item: Item):
    return item

# Validação automática! Se enviar price como string, vai retornar erro.
```

---

### 5. Status Codes & Responses
```python
from fastapi import status

@app.post("/items/", status_code=status.HTTP_201_CREATED)
async def create_item(item: Item):
    return item

@app.delete("/items/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_item(item_id: int):
    return None  # 204 No Content
```

---

## Estrutura Típica

```
projeto/
├── main.py              # Aplicação FastAPI
├── database.py          # Conexão com BD
├── models.py            # Modelos de dados (SQLAlchemy)
├── schemas.py           # Schemas Pydantic (request/response)
├── routers/
│   ├── users.py         # Rotas de usuários
│   ├── items.py         # Rotas de itens
│   └── auth.py          # Autenticação
├── services/
│   ├── user_service.py  # Lógica de negócio
│   └── item_service.py
└── requirements.txt
```

---

## Segurança Básica

### JWT Authentication
```python
from fastapi import Depends
from fastapi.security import HTTPBearer

security = HTTPBearer()

@app.get("/protected")
async def protected_route(credentials = Depends(security)):
    return {"user": "authenticated"}
```

---

## Performance

### Async/Await
```python
import httpx

@app.get("/external-data")
async def get_external_data():
    async with httpx.AsyncClient() as client:
        response = await client.get("https://api.example.com/data")
        return response.json()
```

FastAPI executa múltiplas requisições em paralelo! 🚀

---

## Documentação Automática

FastAPI cria automaticamente:
- **Swagger UI** em `/docs`
- **ReDoc** em `/redoc`

Basta rodar e acessar no browser!

---

## Próximas Leituras

- [[07 - BACKEND/FastAPI - Route Handlers]] — Endpoints avançados
- [[07 - BACKEND/FastAPI - Database Integration]] — Integração com BD

---

**Status**: ready  
**Usada em**: Sistema André (seu projeto!)
