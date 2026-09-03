# 🏥 Sistema André — Gestão de Clínica + Faturamento

**Status**: 🔄 Etapa 1+  
**Localização**: `C:\Users\vieir\OneDrive\Área de Trabalho\Sistema_Andre`  
**Última atualização**: 2026-09-03

---

## 📋 Visão Geral

Sistema completo de **gestão de clínica com faturamento** incluindo:
- RBAC com 5 níveis (admin > gerente > secretaria > faturista > prestador)
- Motor de repasse automático
- Gestão de atendimentos
- Tabelas de preço por convênio
- Planilha mensal por prestador
- Relatórios e exportação
- Auditoria completa

---

## 🛠️ Stack

| Camada | Tecnologia |
|-------|------------|
| Backend | Python 3.12, FastAPI, SQLAlchemy 2.x |
| Database | PostgreSQL |
| Auth | JWT + bcrypt |
| PDF | WeasyPrint |
| Frontend | React 18, Vite, TypeScript |
| Storage | LocalStorage (S3 planejado) |

---

## 🏗️ Arquitetura

**Camadas**:
```
API (v1/admin, v1/gerente, v1/secretaria, v1/faturista, v1/prestador)
    ↓
Service (regras de negócio, auditoria, transações)
    ↓
Repository (acesso a dados)
    ↓
SQLAlchemy Models (PostgreSQL)
```

**Regra de Ouro**: 
- Endpoint valida → Service com lógica → Repository (sem query solta)
- DTOs separados de Models ORM
- Motor repasse = função pura em Python

---

## 🔐 RBAC (5 Papéis)

```
admin > gerente > secretaria > faturista > prestador
```

| Papel | Acesso |
|-------|--------|
| admin | Total + cadastro tudo |
| gerente | Supervisão, relatórios |
| secretaria | Lançamentos avulsos, pacientes novos |
| faturista | Lança/corrige produção, captação |
| prestador | Perfil próprio, extrato |

---

## 📊 Fases

| Fase | Status | Foco |
|------|--------|------|
| 1 | 🔄 | Cadastros, RBAC, admin |
| 2 | 🔄 | Tabela preço, regra repasse |
| 3+ | 🔜 | Lançamento, fechamento, relatórios |

---

## 🚀 Como Rodar

```bash
cd Sistema_Andre
docker-compose up -d
# db + api + web sobem

# Acesso
# Web: http://localhost:5000
# API: http://localhost:8000
```

---

## 📖 Documentação

- **CLAUDE.md** — Convenções e regras de ouro
- **PLANO.md** — Modelagem completa
- **PLANO_REPASSE.md** — Algoritmo de repasse
- **PLANO_FASES_3_A_6.md** — Roadmap

---

## 📚 Referência

[[sistema-andre-clinic|Detalhes Completos na Memória]]
