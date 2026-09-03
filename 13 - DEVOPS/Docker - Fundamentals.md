---
type: conceito
status: ready
created: 2026-09-03
updated: 2026-09-03
tags: [conceito, docker, devops, ready]
related: []
---

# Docker — Fundamentals

Docker é uma plataforma para **containerizar aplicações** — empacotar código + dependências em um container.

---

## Por Que Docker?

✅ **Consistência** — Funciona igual em dev, staging, production  
✅ **Isolamento** — Cada app em seu container  
✅ **Portabilidade** — Funciona em qualquer máquina com Docker  
✅ **Eficiência** — Leve (vs máquinas virtuais)  
✅ **Escalabilidade** — Fácil replicar containers  

---

## Conceitos Chave

### 1. Dockerfile
```dockerfile
# Usar imagem base
FROM python:3.12

# Diretório de trabalho
WORKDIR /app

# Copiar arquivos
COPY requirements.txt .

# Instalar dependências
RUN pip install -r requirements.txt

# Copiar código
COPY . .

# Comando default
CMD ["python", "main.py"]
```

---

### 2. Buildar Imagem
```bash
# docker build -t <nome>:<tag> <diretório>
docker build -t meu-app:1.0 .

# Listar imagens
docker images
```

---

### 3. Rodar Container
```bash
# docker run [options] <image>
docker run -d -p 8000:8000 --name meu-container meu-app:1.0

# -d: detached (background)
# -p: port mapping (host:container)
# --name: nome do container

# Listar containers
docker ps

# Ver logs
docker logs meu-container

# Parar container
docker stop meu-container
```

---

### 4. Docker Compose (Multi-container)
```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://db/myapp
    depends_on:
      - db

  db:
    image: postgres:15
    environment:
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=myapp
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

**Rodar**:
```bash
docker-compose up -d
docker-compose down
```

---

## Best Practices

### 1. Use .dockerignore
```
__pycache__
.git
.env
node_modules
.DS_Store
```

### 2. Minimize Layer Count
```dockerfile
# ❌ Muitas camadas
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y pip

# ✅ Uma camada
RUN apt-get update && apt-get install -y python3 pip
```

### 3. Use Tag Específicas
```dockerfile
# ❌ Ruim
FROM python:latest

# ✅ Bom
FROM python:3.12-slim
```

---

## Workflow Típico

```
1. Escrever Dockerfile
2. docker build -t app:1.0 .
3. docker run -p 8000:8000 app:1.0
4. Testar em http://localhost:8000
5. Push para registry (Docker Hub, ECR, etc)
6. Deploy em produção
```

---

## Variáveis de Ambiente

### No Dockerfile
```dockerfile
ENV DATABASE_URL=postgresql://localhost/myapp
```

### No Docker Compose
```yaml
environment:
  - DATABASE_URL=postgresql://db/myapp
  - DEBUG=False
```

### Na linha de comando
```bash
docker run -e DATABASE_URL=postgresql://db/myapp app:1.0
```

---

## Próximas Leituras

- [[Kubernetes - Basics]] — Orquestração de containers
- [[Docker Compose]] — Multi-container apps
- [[13 - DEVOPS/]] — Mais sobre DevOps

---

**Status**: ready  
**Usado em**: Todos os seus projetos!
