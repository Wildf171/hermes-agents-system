# 🏨 neo-clinica — Reescrita Django

**Status**: ✅ Fases 1-5 Completas  
**Localização**: `C:\Users\vieir\OneDrive\Área de Trabalho\neo-clinica`  
**Última atualização**: 2026-09-03

---

## 📋 Visão Geral

**Reescrita em Django** do neo-desenvolver com:
- ✅ **13 páginas operacionais** implementadas
- ✅ **100+ endpoints** estruturados
- ✅ **Fases 1-5 completas**
- ✅ **9 armadilhas de domínio** documentadas
- ✅ **130+ testes** (backend + frontend)

---

## 🛠️ Stack

| Camada | Tecnologia |
|-------|------------|
| Backend | Django 6, Python 3.12, PostgreSQL 16 |
| Frontend | ES2022 + HTMX + Bootstrap 5.3 |
| Testing | pytest (130+) + Vitest (59) |
| DevOps | Docker + GitHub Actions |

---

## 🏗️ Arquitetura

**Camadas**:
```
views.py (valida → service → responde)
    ↓
services.py (regra, auditoria, transações)
    ↓
managers.py (queries reutilizáveis)
    ↓
models.py (campos, constraints)
```

**Especial**: `clinica/dominio/` é **Python puro** (sem Django):
- Motor de repasse
- RBAC hierarquia
- Testável em memória

---

## 🔐 RBAC (5 Papéis)

```
admin > gerente > secretaria > faturista > prestador
```

**Regra**: Sempre "papel ou maior", nunca igualdade

---

## 📊 Fases (5 ✅ + 4 🔜)

| Fase | Status | Foco | Páginas |
|------|--------|------|---------|
| 1 | ✅ | RBAC, cadastros | 5 |
| 2 | ✅ | Dinheiro, preço, repasse | 2 |
| 3 | ✅ | Lançamento, planilha | 3 |
| 4 | ✅ | Relatórios, exportação | 2 |
| 5 | ✅ | Auditoria, captação | 3 |
| 6 | 🔜 | Relatórios avançados | ? |
| 7 | 🔜 | Financeiro, DRE | ? |
| 8 | 🔜 | Captação expandida | ? |
| 9 | 🔜 | Produção, deploy | ? |

---

## 🎓 9 Armadilhas de Domínio

Cada uma é um teste obrigatório (ARMADILHAS.md):

1. soft-delete vs deletar
2. RBAC hierarquia vs igualdade
3. Decimal vs float em dinheiro
4. Auditoria em admin também
5. localStorage com TTL
6. Validação reutilizável
7-9. (mais a definir)

---

## 📡 Frontend Modular

**Componentes (Fases 1-2)**:
- EventBus — pub/sub central
- ComponentRegistry — auto-instancia
- DraftManager — localStorage
- Validator — regras
- Form, Modal, Accordion — UX
- **Zero dependências npm**

---

## 🧪 Testes

```bash
# Backend
pytest -q                    # Todos
pytest tests/unit -q        # Sem banco
pytest tests/integration -q # Com DB

# Frontend
npm test                    # 59 testes
npm test:watch             # Watching
```

---

## 🚀 Como Rodar

```bash
# Docker
git clone https://github.com/Wildf171/neo-clinica.git
cd neo-clinica
cp .env.example .env
docker-compose up -d
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser

# Acesso: http://localhost:8000
```

---

## 💰 Dinheiro

```
Decimal (Python) → NUMERIC(12,2) (PostgreSQL)
Nunca float
```

---

## 📚 Referência

[[neo-clinica-django|Detalhes Completos na Memória]]
