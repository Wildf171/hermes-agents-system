# 02 - DESIGN DA INTEGRAÇÃO: Neo Currículos + Neo RH System

**Sumário Executivo:**  
Definição da arquitetura de integração entre Neo Currículos (Flutter iOS/Android) e Neo RH System (Flask/MongoDB). Utiliza modelo unificado com mesmo banco de dados, autenticação centralizada, e novo tipo de usuário "candidato". Inclui contrato de API, fluxo end-to-end e plano de segurança LGPD.

---

## 1. Arquitetura Escolhida

### 1.1 Decisão: Integração Unificada (Opção A)

Após análise de 3 opções arquiteturais:

| Opção | Descrição | Prós | Contras |
|-------|-----------|------|---------|
| **A: Unificada** | Mesmo DB, mesmo auth | Sincronização simples, audit trail único | Mudança no schema existente |
| B: Federada | DBs separados, API-to-API | Independência, evolução separada | Sincronização complexa, latência, LGPD frágil |
| C: Event-driven | Kafka + CDC | Escalável, async | Muito complexo para MVP |

**SELEÇÃO:** **Opção A - Integração Unificada**

**Justificativa:**
1. **Candidato é único:** Uma pessoa = 1 usuário em ambos os sistemas
2. **LGPD simplificado:** Auditoria centralizada, direito ao esquecimento mais fácil
3. **Performance:** Sem latência de sincronização entre APIs
4. **Segurança:** Permissões e autenticação centralizadas
5. **Tempo de market:** Menor complexidade = MVP mais rápido

```
┌─────────────────────────────────────────────────────┐
│         ARQUITETURA UNIFICADA                       │
└─────────────────────────────────────────────────────┘

CLIENTES
┌────────────────────────────────────┐
│  Web                   │  Flutter   │
│  (Browser RH)          │ (Candidato)│
└────────────────────────────────────┘
           ▲                  ▲
           │                  │
           │ HTTPS JWT        │ HTTPS JWT
           │                  │
           ▼                  ▼
┌──────────────────────────────────────────┐
│   API FLASK UNIFICADA                    │
│  (mesmo serviço, novos endpoints)        │
│                                          │
│  /api/auth/*             (compartilhado) │
│  /api/candidatos/*       (existente)     │
│  /api/curriculos/*       (novo)          │
│  /api/empresas/*         (existente)     │
│  /api/vagas/*            (existente)     │
└──────────────────────────────────────────┘
           ▼
┌──────────────────────────────────────────┐
│   MONGODB COMPARTILHADO                  │
│                                          │
│  usuarios          (novo campo: eh_candidato)
│  candidatos        (novos campos: cv, consentimento)
│  empresas          (sem mudança)
│  vagas             (sem mudança)
│  curriculos        (NOVA coleção)
│  curriculos_acesso (NOVA coleção - auditoria)
│  auditoria         (sem mudança)
└──────────────────────────────────────────┘
           ▼
┌──────────────────────────────────────────┐
│   STORAGE (S3 / MinIO / FS)              │
│  /uploads/curriculos/                    │
│  /uploads/perfis/                        │
└──────────────────────────────────────────┘
```

---

### 1.2 Componentes Principais

#### 1.2.1 API Flask (Backend Unificado)

```python
# app.py - Estrutura
from flask import Flask
from flask_jwt_extended import JWTManager
from flask_cors import CORS
from flask_pymongo import PyMongo

app = Flask(__name__)

# Configuração JWT (compartilhada)
jwt = JWTManager(app)

# Configuração MongoDB
mongo = PyMongo(app)

# CORS
CORS(app, resources={
    r"/api/*": {
        "origins": ["https://app.neorh.com.br", "https://app.neocurriculos.com.br"],
        "methods": ["GET", "POST", "PUT", "PATCH", "DELETE"],
        "allow_headers": ["Content-Type", "Authorization"],
        "max_age": 3600
    }
})

# Blueprints (agrupamento de rotas)
from routes.auth import auth_bp
from routes.candidatos import candidatos_bp
from routes.curriculos import curriculos_bp  # NOVO
from routes.empresas import empresas_bp
from routes.vagas import vagas_bp
from routes.auditoria import auditoria_bp

app.register_blueprint(auth_bp)
app.register_blueprint(candidatos_bp)
app.register_blueprint(curriculos_bp)      # NOVO
app.register_blueprint(empresas_bp)
app.register_blueprint(vagas_bp)
app.register_blueprint(auditoria_bp)
```

#### 1.2.2 Novo Tipo de Usuário: "candidato"

```python
# models/usuario.py
class Usuario:
    """Usuário no sistema (RH, Recruiter, Admin, Empresa, ou Candidato)"""
    
    tipos_validos = ["rh", "recruiter", "admin", "empresa", "candidato"]
    
    @staticmethod
    def criar_candidato(email, nome, senha_plain):
        """Cria novo usuário candidato (para Neo Currículos)"""
        usuario = {
            "_id": ObjectId(),
            "email": email,
            "nome": nome,
            "tipo": "candidato",           # ← NOVO
            "eh_candidato": True,          # ← NOVO
            "empresa_id": None,            # Candidatos não têm empresa
            "ativo": True,
            "senha_hash": bcrypt.hashpw(senha_plain.encode(), bcrypt.gensalt(12)),
            "permissoes": [
                "enviar_cv",
                "editar_perfil",
                "ver_proprias_vagas"
            ],
            "criado_em": datetime.utcnow(),
            "ultimo_login": None,
        }
        db.usuarios.insert_one(usuario)
        return usuario
    
    @staticmethod
    def eh_candidato(usuario_id):
        """Verifica se usuário é candidato"""
        user = db.usuarios.find_one({"_id": ObjectId(usuario_id)})
        return user and user.get("eh_candidato") == True
```

#### 1.2.3 Armazenamento de Currículo

```python
# models/curriculo.py
class Curriculo:
    """Armazena versões de CV do candidato"""
    
    @staticmethod
    def upload(usuario_id, arquivo_pdf, versao=1):
        """
        Faz upload de novo CV
        - Valida: PDF, tamanho max 10MB
        - Calcula hash SHA256
        - Armazena em S3/MinIO
        - Cria registro em db.curriculos
        - Log em db.auditoria
        """
        # Validações
        if not arquivo_pdf.filename.endswith('.pdf'):
            raise ValueError("Apenas PDF permitido")
        
        if arquivo_pdf.content_length > 10 * 1024 * 1024:  # 10MB
            raise ValueError("Máximo 10MB")
        
        # Gerar hash
        file_hash = hashlib.sha256(arquivo_pdf.read()).hexdigest()
        arquivo_pdf.seek(0)  # Reset para upload
        
        # Upload para storage
        file_path = f"curriculos/{usuario_id}/{versao}_{file_hash[:8]}.pdf"
        s3_url = storage_client.upload(arquivo_pdf, file_path)
        
        # Criar registro
        curriculo_doc = {
            "_id": ObjectId(),
            "usuario_id": ObjectId(usuario_id),
            "versao": versao,
            "arquivo_hash": file_hash,
            "arquivo_url": s3_url,
            "arquivo_tamanho": arquivo_pdf.content_length,
            "tipo_mime": "application/pdf",
            "criado_em": datetime.utcnow(),
            "ativo": True,  # Versão atual
        }
        db.curriculos.insert_one(curriculo_doc)
        
        # Marcar versões anteriores como inativas
        db.curriculos.update_many(
            {"usuario_id": ObjectId(usuario_id), "_id": {"$ne": curriculo_doc["_id"]}},
            {"$set": {"ativo": False}}
        )
        
        # Auditoria
        audit_log({
            "usuario_id": usuario_id,
            "acao": "upload_curriculo",
            "recurso": f"curriculo:{curriculo_doc['_id']}",
            "resultado": "sucesso",
            "arquivo_tamanho": arquivo_pdf.content_length,
            "arquivo_hash": file_hash[:16]  # Parcial por segurança
        })
        
        return curriculo_doc
```

---

## 2. Diagrama da Integração

### 2.1 Fluxo Completo: Candidato → RH

```
┌────────────────────────────────────────────────────────────────┐
│                 FLUXO: CANDIDATO ENVIA CV                      │
└────────────────────────────────────────────────────────────────┘

PASSO 1: CANDIDATO REGISTRA-SE (Neo Currículos - Flutter)
┌──────────────────────────────────────────────────────────┐
│ App Flutter                                              │
│ ┌────────────────────────────────────────────────────┐   │
│ │ Tela: Registro                                     │   │
│ │ Campos: email, nome, senha                        │   │
│ │ [REGISTRAR]                                        │   │
│ └──────────────────────┬───────────────────────────┘   │
│                        │                               │
│                        │ POST /api/auth/registrar      │
│                        │ { email, nome, senha }        │
│                        ▼                               │
│    ┌──────────────────────────────────────────┐        │
│    │ API: criar usuário tipo "candidato"      │        │
│    │ - Hash password com bcrypt               │        │
│    │ - Inserir em db.usuarios                 │        │
│    │ - eh_candidato = true                    │        │
│    │ - permissoes = ["enviar_cv", ...]        │        │
│    └──────────────┬───────────────────────────┘        │
│                   │                                     │
│                   │ JWT Token (24h)                    │
│                   ▼                                     │
│    ┌──────────────────────────────────────────┐        │
│    │ Response:                                │        │
│    │ {                                        │        │
│    │   access_token: "eyJ...",                │        │
│    │   usuario: { id, email, tipo }           │        │
│    │ }                                        │        │
│    └──────────────────────────────────────────┘        │
│                   │                                     │
│                   │ Store token em device              │
│                   ▼                                     │
│    ┌──────────────────────────────────────────┐        │
│    │ App: "Bem-vindo! Envie seu CV"           │        │
│    └──────────────────────────────────────────┘        │
└──────────────────────────────────────────────────────────┘

PASSO 2: CANDIDATO ENVIA CV
┌──────────────────────────────────────────────────────────┐
│ App Flutter                                              │
│ ┌────────────────────────────────────────────────────┐   │
│ │ Tela: Meu Perfil / Carregar CV                    │   │
│ │ [ESCOLHER ARQUIVO]                               │   │
│ │ arquivo: "curriculo_joao.pdf" (5MB)              │   │
│ │ [CONFIRMAR ENVIO]                                │   │
│ └──────────────────────┬───────────────────────────┘   │
│                        │                               │
│                        │ POST /api/curriculos/upload   │
│                        │ Header: Authorization: Bearer │
│                        │ Body: multipart/form-data     │
│                        │   file: <PDF binary>          │
│                        ▼                               │
│    ┌──────────────────────────────────────────┐        │
│    │ API Validation:                          │        │
│    │ ✓ Token válido                           │        │
│    │ ✓ Permissão "enviar_cv"                 │        │
│    │ ✓ PDF válido, < 10MB                    │        │
│    │ ✓ Calcular SHA256                       │        │
│    └──────────────┬───────────────────────────┘        │
│                   │                                     │
│                   │ Upload para S3/MinIO              │
│                   │ /curriculos/{usuario_id}/v1_xxx.pdf
│                   ▼                                     │
│    ┌──────────────────────────────────────────┐        │
│    │ MongoDB: Inserir em db.curriculos        │        │
│    │ {                                        │        │
│    │   usuario_id: "123abc...",              │        │
│    │   versao: 1,                            │        │
│    │   arquivo_url: "s3://...",              │        │
│    │   arquivo_hash: "abc123...",            │        │
│    │   criado_em: now,                       │        │
│    │   ativo: true                           │        │
│    │ }                                        │        │
│    └──────────────┬───────────────────────────┘        │
│                   │                                     │
│                   │ Auditoria: log em db.auditoria    │
│                   │ "usuario_123 fez upload_curriculo"│
│                   ▼                                     │
│    ┌──────────────────────────────────────────┐        │
│    │ Response: 201 Created                    │        │
│    │ { curriculo_id, versao, criado_em }     │        │
│    └──────────────────────────────────────────┘        │
└──────────────────────────────────────────────────────────┘

PASSO 3: CANDIDATO CONCORDA COM LGPD
┌──────────────────────────────────────────────────────────┐
│ App Flutter                                              │
│ ┌────────────────────────────────────────────────────┐   │
│ │ Tela: Permissões                                  │   │
│ │ ☑ Aceito compartilhar CV com empresas            │   │
│ │ ☑ Aceito receber contato via email              │   │
│ │ ☑ Aceito Política de Privacidade                │   │
│ │ [CONFIRMAR]                                      │   │
│ └──────────────────────┬───────────────────────────┘   │
│                        │                               │
│                        │ PATCH /api/candidatos/{id}/  │
│                        │        consentimento         │
│                        │ { consentimento: true }      │
│                        ▼                               │
│    ┌──────────────────────────────────────────┐        │
│    │ MongoDB: Update db.candidatos            │        │
│    │ consentimento_dados = {                  │        │
│    │   aceito: true,                          │        │
│    │   data_aceite: now,                      │        │
│    │   ip_aceite: "192.168.1.1"              │        │
│    │ }                                        │        │
│    └──────────────┬───────────────────────────┘        │
│                   │                                     │
│                   │ Auditoria LGPD                    │
│                   ▼                                     │
│    ┌──────────────────────────────────────────┐        │
│    │ Response: 200 OK                         │        │
│    └──────────────────────────────────────────┘        │
└──────────────────────────────────────────────────────────┘

PASSO 4: RH ACESSA PERFIL DO CANDIDATO (Web Existente)
┌──────────────────────────────────────────────────────────┐
│ Web Neo RH System (RH User)                              │
│ ┌────────────────────────────────────────────────────┐   │
│ │ Painel: Candidatos                               │   │
│ │ [JOAO SILVA] - Estado: SP                        │   │
│ │ └─ Email: joao@example.com                       │   │
│ │ └─ CV: ✓ Enviado em 07/09/2025                   │   │
│ │ [VER CV] ← Click aqui                            │   │
│ └──────────────────────┬───────────────────────────┘   │
│                        │                               │
│                        │ GET /api/candidatos/{id}      │
│                        │ Header: Authorization         │
│                        ▼                               │
│    ┌──────────────────────────────────────────┐        │
│    │ API: Validar permissões                  │        │
│    │ ✓ Token do RH válido                     │        │
│    │ ✓ RH tem permissão "ver_candidatos"     │        │
│    │ ✓ Candidato consentiu                   │        │
│    └──────────────┬───────────────────────────┘        │
│                   │                                     │
│                   │ MongoDB: Query db.candidatos     │
│                   │ + Get URL de db.curriculos      │
│                   ▼                                     │
│    ┌──────────────────────────────────────────┐        │
│    │ Response:                                │        │
│    │ {                                        │        │
│    │   _id: "...",                            │        │
│    │   nome: "Joao Silva",                    │        │
│    │   email: "joao@...",                     │        │
│    │   cv_url: "s3://curriculos/.../v1.pdf", │        │
│    │   consentimento_dados: {                 │        │
│    │     aceito: true,                        │        │
│    │     data_aceite: "2025-09-07T10:00"     │        │
│    │   }                                      │        │
│    │ }                                        │        │
│    └──────────────┬───────────────────────────┘        │
│                   │                                     │
│                   │ Auditoria: registra acesso       │
│                   │ "usuario_rh_456 acessou cv de   │
│                   │ candidato_123"                   │
│                   ▼                                     │
│    ┌──────────────────────────────────────────┐        │
│    │ Web: Mostra CV (iframe ou link)          │        │
│    │ + Score compatibilidade                  │        │
│    │ + Histórico de tentativas de contato    │        │
│    └──────────────────────────────────────────┘        │
└──────────────────────────────────────────────────────────┘

PASSO 5: RH APLICA PARA VAGA (Fluxo Existente)
┌──────────────────────────────────────────────────────────┐
│ Web Neo RH System                                        │
│ ┌────────────────────────────────────────────────────┐   │
│ │ [ADICIONAR A VAGA] (vaga_id = "789xyz")          │   │
│ │ Confirmação: Joao Silva adicionado à vaga        │   │
│ └──────────────────────┬───────────────────────────┘   │
│                        │                               │
│                        │ POST /api/vagas/{id}/aplicar   │
│                        │ { candidato_id }              │
│                        ▼                               │
│    ┌──────────────────────────────────────────┐        │
│    │ MongoDB: Update db.vagas                 │        │
│    │ candidatos_aplicados.push(candidato_123) │        │
│    └──────────────────────────────────────────┘        │
│                        │                               │
│                        │ (Resto do fluxo existente)    │
│                        ▼                               │
│    ┌──────────────────────────────────────────┐        │
│    │ Notificação ao Candidato (email)         │        │
│    │ "Você foi aplicado à vaga..."            │        │
│    └──────────────────────────────────────────┘        │
└──────────────────────────────────────────────────────────┘
```

---

## 3. Contrato de API (OpenAPI/Swagger)

### 3.1 Endpoints Novos (Neo Currículos)

```yaml
# openapi: 3.0.0
info:
  title: "Neo RH API - Integração Neo Currículos"
  version: "2.0.0"

paths:
  /api/auth/registrar:
    post:
      summary: "Registro de novo usuário candidato"
      tags: [Auth]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                email:
                  type: string
                  format: email
                  description: "Email único"
                nome:
                  type: string
                  description: "Nome completo"
                senha:
                  type: string
                  format: password
                  description: "Mín 8 chars, 1 maiúscula, 1 número"
                aceito_termos:
                  type: boolean
                  description: "Deve aceitar termos LGPD"
              required: [email, nome, senha, aceito_termos]
      responses:
        201:
          description: "Usuário criado com sucesso"
          content:
            application/json:
              schema:
                type: object
                properties:
                  access_token:
                    type: string
                    description: "JWT token (24h)"
                  usuario:
                    type: object
                    properties:
                      id:
                        type: string
                      email:
                        type: string
                      tipo:
                        type: string
                        enum: ["candidato"]
        400:
          description: "Validação falhou"
          content:
            application/json:
              schema:
                type: object
                properties:
                  erro:
                    type: string
                    example: "Email já registrado"
        409:
          description: "Email já existe"

  /api/curriculos/upload:
    post:
      summary: "Upload de novo currículo (versão)"
      tags: [Currículos]
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          multipart/form-data:
            schema:
              type: object
              properties:
                arquivo:
                  type: string
                  format: binary
                  description: "Arquivo PDF (máx 10MB)"
              required: [arquivo]
      responses:
        201:
          description: "CV enviado com sucesso"
          content:
            application/json:
              schema:
                type: object
                properties:
                  curriculo_id:
                    type: string
                  versao:
                    type: integer
                  arquivo_url:
                    type: string
                  criado_em:
                    type: string
                    format: date-time
        400:
          description: "Arquivo inválido (não PDF ou > 10MB)"
        401:
          description: "Token inválido ou expirado"

  /api/curriculos:
    get:
      summary: "Listar versões de currículo do usuário"
      tags: [Currículos]
      security:
        - bearerAuth: []
      responses:
        200:
          description: "Lista de versões"
          content:
            application/json:
              schema:
                type: object
                properties:
                  total:
                    type: integer
                  versoes:
                    type: array
                    items:
                      type: object
                      properties:
                        id:
                          type: string
                        versao:
                          type: integer
                        criado_em:
                          type: string
                          format: date-time
                        ativo:
                          type: boolean

  /api/candidatos/{id}/consentimento:
    patch:
      summary: "Atualizar consentimento LGPD"
      tags: [Candidatos]
      security:
        - bearerAuth: []
      parameters:
        - in: path
          name: id
          required: true
          schema:
            type: string
            description: "ID do candidato (deve ser próprio usuário)"
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                consentimento:
                  type: boolean
                  description: "Aceita compartilhar dados"
                aceito_contato:
                  type: boolean
                  description: "Aceita ser contatado"
              required: [consentimento]
      responses:
        200:
          description: "Consentimento atualizado"
        403:
          description: "Não pode atualizar candidato alheio"

  /api/candidatos/{id}/perfil-completo:
    get:
      summary: "Perfil completo do candidato (próprio usuário)"
      tags: [Candidatos]
      security:
        - bearerAuth: []
      responses:
        200:
          description: "Perfil com CV"
          content:
            application/json:
              schema:
                type: object
                properties:
                  usuario_id:
                    type: string
                  nome:
                    type: string
                  email:
                    type: string
                  telefone:
                    type: string
                  estado:
                    type: string
                  curriculo_ativo:
                    type: object
                    properties:
                      versao:
                        type: integer
                      url:
                        type: string
                      criado_em:
                        type: string
                  consentimento_lgpd:
                    type: object
                    properties:
                      aceito:
                        type: boolean
                      data_aceite:
                        type: string
                        format: date-time

  /api/candidatos/{id}/deletar-conta:
    delete:
      summary: "Solicitar deleção de conta (LGPD - direito ao esquecimento)"
      tags: [Candidatos]
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                motivo:
                  type: string
                  description: "Motivo da deleção (opcional)"
                confirmar:
                  type: boolean
                  description: "Deve ser true"
              required: [confirmar]
      responses:
        202:
          description: "Deleção agendada (limpeza em 30 dias)"
        400:
          description: "Confirmação não fornecida"

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
```

---

### 3.2 Endpoints Existentes Reutilizados

| Endpoint | Método | Descrição | Quem Usa |
|----------|--------|-----------|----------|
| `/api/auth/login` | POST | Login (email + senha) | RH + Candidato |
| `/api/auth/refresh` | POST | Renovar token | RH + Candidato |
| `/api/auth/logout` | POST | Logout | RH + Candidato |
| `/api/candidatos` | GET | Listar (filtros) | RH, Recruiter |
| `/api/candidatos/{id}` | GET | Ver perfil | RH, Recruiter, own |
| `/api/vagas` | GET | Listar vagas | Público |
| `/api/vagas/{id}` | GET | Detalhe vaga | Público |
| `/api/painel/resumo` | GET | Dashboard | RH, Admin |

---

## 4. Fluxo Ponta-a-Ponta

### 4.1 Caso de Uso Completo: Joao Silva

```
T=0: JOAO BAIXA APP (Neo Currículos)
└─ Abre app
└─ Vê tela de registro

T=1: REGISTRA CONTA (email: joao@gmail.com)
└─ POST /api/auth/registrar
└─ Body: { email, nome, senha }
└─ Cria: db.usuarios (tipo="candidato", eh_candidato=true)
└─ Retorna: JWT access_token (24h)
└─ App armazena token em device keychain

T=2: FAZ LOGIN
└─ POST /api/auth/login
└─ JWT válido, retorna novo token
└─ Acessa home do app

T=3: COMPLETA PERFIL
└─ PUT /api/candidatos/{joao_id}
└─ Envia: telefone, estado, experiencia_anos, salario_pretendido
└─ Atualiza db.candidatos

T=4: ENVIA CV (PDF)
└─ POST /api/curriculos/upload
└─ Multipart: arquivo PDF (5MB)
└─ Validações: ✓ PDF, ✓ < 10MB, ✓ Token válido
└─ Upload S3: /curriculos/joao_user_id/v1_hash.pdf
└─ Cria: db.curriculos (versao=1, ativo=true)
└─ Auditoria: log de upload

T=5: ACEITA TERMOS LGPD
└─ PATCH /api/candidatos/{joao_id}/consentimento
└─ Body: { consentimento: true, aceito_contato: true }
└─ Atualiza: db.candidatos.consentimento_dados
└─ Auditoria: log de consentimento + IP + device

T=6: CANDIDATO PODE VISUALIZAR VAGAS
└─ GET /api/vagas (públicas)
└─ Vê lista de vagas abertas
└─ Clica em vaga → GET /api/vagas/{vaga_id}
└─ (Fluxo existente)

T=7: RH ACESSA PAINEL WEB (Neo RH System)
└─ Login: POST /api/auth/login (RH user)
└─ Acessa: GET /api/candidatos
└─ Vê: Joao Silva (novo candidato)
└─ Clica: GET /api/candidatos/{joao_id}
└─ Validações:
│  ├─ RH token válido? ✓
│  ├─ RH tem permissão "ver_candidatos"? ✓
│  ├─ Candidato consentiu? ✓
│  └─ Candidato está ativo? ✓
└─ Retorna: Perfil + CV URL
└─ Auditoria: "rh_user_id acessou candidato_joao"

T=8: RH VISUALIZA CV
└─ GET /curriculos/joao_id/v1_hash.pdf (S3)
└─ Abre em iframe/viewer
└─ Auditoria: "rh_user_id viu_cv candidato_joao"

T=9: RH ADICIONA JOAO À VAGA
└─ POST /api/vagas/{vaga_id}/aplicar
└─ Body: { candidato_id: joao_id }
└─ Atualiza: db.vagas.candidatos_aplicados
└─ Notificação: email "Você foi pré-selecionado!"
└─ Auditoria: "rh_user_id aplicou joao em vaga_id"

T=10 (FUTURO): JOAO DELETA CONTA (LGPD)
└─ DELETE /api/candidatos/{joao_id}/deletar-conta
└─ Body: { confirmar: true }
└─ Marca: db.candidatos.marcado_para_delecao=true
└─ Auditoria: "joao solicitou direito ao esquecimento"
└─ Job Agendado: após 30 dias
│  ├─ Anonimizar: nome → "ANONIMIZADO"
│  ├─ Deletar: email, telefone, cv_url
│  ├─ Manter: auditoria (compliance)
│  └─ Auditoria: "deleção de joao completada"
```

---

## 5. Mapeamento de Dados

### 5.1 Fluxo de Dados Entre Sistemas

```
Neo Currículos (Flutter)         Neo RH System (Web)
    │                                │
    ├─ Candidato se registra        │
    │  └─ db.usuarios (novo)        │
    │  └─ db.candidatos (novo)      │
    │                               │
    ├─ Faz upload CV               │
    │  └─ db.curriculos (novo)      │
    │                               │
    ├─ Aceita LGPD                 │
    │  └─ db.candidatos.consentimento
    │                               │
    │                               ├─ RH lista candidatos
    │                               │  GET /api/candidatos
    │                               │
    │                               ├─ RH vê perfil + CV
    │                               │  GET /api/candidatos/{id}
    │                               │  Retorna: cv_url (S3)
    │                               │
    │                               ├─ RH aplica a vaga
    │                               │  POST /api/vagas/{id}/aplicar
    │                               │  └─ db.vagas.candidatos_aplicados
    │
    └─ Candidato recebe notificação
       (email ou push)
```

### 5.2 Campos Mapeados

| Campo Candidato | Neo Currículos | Neo RH | Storage |
|-----------------|----------------|--------|---------|
| Nome | ✓ Enviar | ✓ Exibir | db.candidatos |
| Email | ✓ Enviar | ✓ Exibir | db.usuarios |
| Telefone | ✓ Enviar | ✓ Exibir | db.candidatos |
| CPF | - Não | - Não | - (LGPD) |
| CV PDF | ✓ Upload | ✓ Link | S3/MinIO |
| Experiência | ✓ Enviar | ✓ Filtro | db.candidatos |
| Salário pretendido | ✓ Enviar | ✓ Match | db.candidatos |
| Consentimento LGPD | ✓ Aceitar | ✓ Validar | db.candidatos |
| Score compatibilidade | - | ✓ Calcular | db.candidatos |

---

## 6. Plano de Segurança LGPD

### 6.1 Princípios LGPD Implementados

| Princípio | Implementação |
|-----------|---------------|
| **Legalidade** | Consentimento explícito antes de compartilhar CV |
| **Transparência** | Política de privacidade acessível no app |
| **Limitação** | Dados coletados apenas o necessário |
| **Exatidão** | Candidato pode editar/corrigir dados |
| **Integridade** | Criptografia em repouso (MongoDB) + trânsito (HTTPS) |
| **Confidencialidade** | JWT + permissões granulares |
| **Direito de acesso** | Candidato pode baixar seus dados (export) |
| **Direito ao esquecimento** | Deleção em 30 dias após requisição |
| **Auditoria** | Log completo em db.auditoria |

### 6.2 Fluxo de Consentimento

```
Neo Currículos (Flutter)
┌──────────────────────────────────────┐
│ 1. Registro do usuário               │
│ ☐ Politica de privacidade            │
│ ☐ Termos de serviço                  │
│ [REGISTRAR]                          │
└──────────────┬───────────────────────┘
               │
               ▼
┌──────────────────────────────────────┐
│ 2. Tela de Permissões (LGPD)         │
│ ☐ Compartilhar CV com empresas      │
│ ☐ Receber contato via email         │
│ ☐ Processar dados para analytics    │
│ [CONFIRMAR ACESSO]                  │
└──────────────┬───────────────────────┘
               │ POST /api/candidatos/{id}/
               │        consentimento
               │ { consentimento: true }
               ▼
        db.candidatos
        consentimento_dados: {
          aceito: true,
          data_aceite: "2025-09-07T10:00Z",
          ip_aceite: "192.168.1.1",
          navegador: "Chrome Android"
        }
               │
               │ Auditoria log criado
               ▼
   "usuario_123 deu consentimento
    para compartilhamento de dados"

FLUXO DE REVOGAÇÃO (A QUALQUER MOMENTO)
┌──────────────────────────────────────┐
│ Configurações → Privacidade          │
│ ☑ Compartilhar CV com empresas      │
│ [REVOGAR CONSENTIMENTO]              │
└──────────────┬───────────────────────┘
               │
               ▼
        db.candidatos
        consentimento_dados.aceito = false
        consentimento_revogado_em = now
               │
               │ A partir daí:
               │ - RH não consegue ver CV
               │ - Candidato fica "invisível"
               │ - Auditoria registra revogação
               ▼
   "usuario_123 revogou consentimento"
```

### 6.3 Direito ao Esquecimento (Deleção)

```
┌─────────────────────────────────────────────┐
│ DELEÇÃO DE CONTA (LGPD)                     │
└─────────────────────────────────────────────┘

T=0: CANDIDATO SOLICITA DELEÇÃO
     App → DELETE /api/candidatos/{id}/deletar-conta
     Body: { confirmar: true, motivo: "..." }

T=0+1min: SOFT DELETE
     db.candidatos.marcado_para_delecao = true
     db.candidatos.data_delecao_solicitada = now
     db.usuarios.ativo = false

T=0+30d: JOB EXECUTADO (Celery scheduled task)
     ├─ Verificar: ainda marcado para deleção?
     ├─ Anonimizar PII:
     │  ├─ nome → "ANONIMIZADO_" + hash
     │  ├─ email → "deleted_" + hash + "@anonimizado.local"
     │  ├─ telefone → NULL
     │  ├─ endereco → NULL
     │  └─ cv_url → deletar arquivo S3
     │
     ├─ Manter (compliance):
     │  ├─ db.auditoria (logs)
     │  ├─ db.curriculos_acesso (who saw what)
     │  └─ Histórico de vagas (para reclamações)
     │
     └─ Auditoria final: "deleção de {candidato_id} completada"
```

### 6.4 Auditoria LGPD Completa

```javascript
// Cada ação relacionada a dados sensíveis é registrada
db.auditoria_lgpd = {
  _id: ObjectId,
  
  // Quem
  usuario_id: ObjectId,
  tipo_usuario: "candidato" | "rh" | "admin",
  
  // O que
  acao: "upload_cv" | "acessar_cv" | 
        "consentimento_dado" | "consentimento_revogado" |
        "delecao_solicitada" | "delecao_completada" |
        "export_dados" | "direito_acesso",
  
  // Dados acessados
  dados_tipo: "nome" | "email" | "cv" | "cpf" | "telefone",
  dados_sensibilidade: "alto" | "médio" | "baixo",
  
  // Contexto
  ip_origem: "192.168.1.1",
  user_agent: "Mozilla/5.0...",
  localizacao_geohash: "u9tpx6y6", // Opcional, por privacidade
  timestamp: ISODate,
  
  // Retenção
  ttl_dias: 2555, // 7 anos (lei brasileira)
}

// Índices para auditoria rápida
db.auditoria_lgpd.createIndex({ usuario_id: 1, timestamp: -1 })
db.auditoria_lgpd.createIndex({ acao: 1, timestamp: -1 })
db.auditoria_lgpd.createIndex({ timestamp: 1 }, 
  { expireAfterSeconds: 220320000 }) // 7 anos em segundos
```

---

## 7. Segurança Geral

### 7.1 Proteções Implementadas

| Proteção | Como |
|----------|------|
| **HTTPS** | TLS 1.3, certificado Let's Encrypt |
| **JWT** | HS256, 24h expiration, stored in memory (app) |
| **CORS** | Whitelist apenas domínios autorizados |
| **Rate Limiting** | 100 req/min por user (JWT), 5 login/15min |
| **Password** | bcrypt 12 rounds, mín 8 chars + mix |
| **File Upload** | Validação tipo (PDF), tamanho (10MB), scan antivírus |
| **Injection** | Prepared queries (PyMongo), input sanitization |
| **CSRF** | Não aplica (JWT stateless) |
| **XSS** | Sanitização HTML no frontend |

### 7.2 Checklist de Deployment

- [ ] `.env` configurado (JWT_SECRET, DB_URL, S3_KEY, SMTP)
- [ ] MongoDB encryption at rest habilitado
- [ ] TLS 1.3 configurado no nginx
- [ ] HSTS header ativado
- [ ] CSP headers configurados
- [ ] Rate limiting ativado
- [ ] Logs centralizados (ELK / Splunk)
- [ ] Backup diário MongoDB agendado
- [ ] Monitoramento de falhas de segurança
- [ ] DPO (Data Protection Officer) designado

---

## 8. Próximos Passos

### 8.1 Fase 2: Implementação

1. **Backend Flask:**
   - Adicionar endpoints: `/api/curriculos/*`, `/api/auth/registrar`
   - Criar coleções MongoDB: `curriculos`, `curriculos_acesso`, `auditoria_lgpd`
   - Implementar validações e permissões

2. **Frontend Flutter:**
   - Telas: Registro, Upload CV, Consentimento LGPD
   - Integração com endpoints
   - Armazenamento seguro de tokens (keychain)

3. **Testing:**
   - Testes unitários (pytest + jest)
   - Testes E2E (Cypress)
   - Testes de segurança (OWASP)

4. **Deployment:**
   - Docker + Kubernetes
   - CI/CD (GitHub Actions)
   - Monitoramento (Prometheus + Grafana)

---

## 9. Conclusão

A integração unificada do Neo Currículos com Neo RH System oferece:

✓ **Simplicidade:** Candidato = usuário único  
✓ **Segurança:** Autenticação centralizada  
✓ **Conformidade:** LGPD com auditoria completa  
✓ **Performance:** Sem sincronização entre DBs  
✓ **Escalabilidade:** Pronto para crescimento  

---

**Versão:** 1.0  
**Data:** 2025-09-07  
**Autor:** Backend Architect Sênior  
**Status:** ✓ Pronto para Fase 2 de implementação
