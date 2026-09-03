---
type: projeto
status: desenvolvimento
stack: [FastAPI, React, PostgreSQL]
priority: alto
created: 2026-09-03
updated: 2026-09-03
---

# 🏥 Sistema André — Gestão de Clínica + Faturamento

**Stack**: FastAPI + React + PostgreSQL  
**Status**: 🔄 Etapa 1+  
**Localização**: `C:\Users\vieir\OneDrive\Área de Trabalho\Sistema_Andre`

---

## 📋 Visão Geral

Sistema completo para gestão de clínicas com foco em:
- ✅ Faturamento e repasse
- ✅ RBAC (5 papéis hierárquicos)
- ✅ Auditoria de operações
- ✅ Soft-delete para dados

---

## 🛠️ Stack Tecnológico

| Camada | Tecnologia |
|-------|------------|
| **Backend** | FastAPI + Python 3.12 |
| **Frontend** | React + TypeScript |
| **Banco de Dados** | PostgreSQL 16 |
| **DevOps** | Docker + GitHub Actions |
| **Testing** | pytest + Jest |

---

## 🏗️ Arquitetura

**Padrão**: Clean Architecture + DDD

```
views.py (valida → service → responde)
    ↓
services.py (regra, auditoria, transações)
    ↓
managers.py (queries reutilizáveis)
    ↓
models.py (campos, constraints)
```

**Motor de Repasse**: Python puro (sem Django)
- Testável em memória
- Reutilizável

---

## 🔐 RBAC (5 Papéis)

Hierarquia: `admin > gerente > secretaria > faturista > prestador`

**Regra**: Sempre "papel ou maior", nunca igualdade

---

## 📊 Fases

| Fase | Status | Foco | % |
|------|--------|------|---|
| 1 | ✅ | RBAC, cadastros | 100% |
| 2 | 🔄 | Faturamento, repasse | 50% |
| 3 | 📋 | Lançamento, relatórios | 0% |
| 4+ | 📋 | Financeiro, captação | 0% |

---

## 🚀 Próximos Passos

- [ ] Expandir Fase 2 (repasse completo)
- [ ] Implementar DRE
- [ ] Dashboard com gráficos
- [ ] Integração com contabilidade

---

## 🔗 Relacionados

- [[07 - BACKEND/FastAPI - Introduction]] — Framework usado
- [[09 - BANCO DE DADOS (APLICADO)/PostgreSQL - Fundamentals]] — Banco de dados
- [[17 - IA & AGENTS/Hermes]] — Agents para assistência

---

**GitHub**: [Será adicionado]  
**Documentação Completa**: [[20 - PROJETOS/Sistema André/]]
