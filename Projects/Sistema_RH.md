# 💼 Sistema RH — Recrutamento e Seleção

**Status**: 🔄 Desenvolvimento  
**Localização**: `C:\Users\vieir\OneDrive\Área de Trabalho\Sistema_RH`  
**Última atualização**: 2026-09-03

---

## 📋 Visão Geral

Plataforma de **recrutamento e seleção para setor de saúde** que automatiza:
- **Processamento de CVs** — Google Drive + PDFplumber
- **Gestão de candidatos** — Busca, filtros, contato WhatsApp
- **Gestão de vagas** — CRUD + compatibilidade
- **Processos seletivos** — Etapas e histórico
- **Entrevistas** — Agenda + lembretes
- **Banco de talentos** — Reaproveitamento
- **Dashboard** — Funil de recrutamento

---

## 🛠️ Stack

| Camada | Tecnologia |
|-------|------------|
| Backend | Python 3, Flask 3 |
| Database | MongoDB (Atlas ou local) |
| Auth | Flask-Login + Bcrypt |
| Google | Drive API (service account) |
| PDF | pdfplumber |
| Frontend | HTML/CSS/JavaScript |

---

## 🌍 Integração Google Drive

- Service account (sem UI web)
- Importação automática de PDFs
- Extração de dados:
  - Nome, email, telefone
  - Cidade/região
  - Categoria profissional
  - Habilidades, experiências, formação

---

## 🔐 RBAC (2 Papéis)

```
admin (contratante) | funcionario
```

**Segurança**:
- Sem registro público
- Admin convida usuários
- Senhas com bcrypt
- Tokens reset 30 min

---

## 📡 7 Funcionalidades Principais

1. ✅ Processamento automático de CVs
2. ✅ Gestão de candidatos
3. ✅ Gestão de vagas
4. ✅ Processos seletivos
5. ✅ Agenda de entrevistas
6. ✅ Banco de talentos
7. ✅ Dashboard

---

## 🚀 Como Rodar

```bash
cd backend
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt

python criar_usuario.py --nome "Admin" --email admin@empresa.com --role admin
python server.py

# Acesso: http://localhost:5000
```

---

## ⚙️ Configuração (.env)

```env
MONGO_URI=mongodb+srv://...
MONGO_DB_NAME=extrator_curriculos
FLASK_PORT=5000
SECRET_KEY=<token>
GOOGLE_DRIVE_FOLDER_ID=<pasta>
```

---

## 🚀 Roadmap

- [ ] Integração WhatsApp (notificações)
- [ ] Triagem assistida por IA (Neo Triador)
- [ ] Deploy Nginx + Gunicorn
- [ ] Gestão de usuários (admin)

---

## 📚 Referência

[[sistema-rh-recruitment|Detalhes Completos na Memória]]
