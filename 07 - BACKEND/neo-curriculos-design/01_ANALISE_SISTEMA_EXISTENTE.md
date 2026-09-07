# 01 - ANÁLISE DO SISTEMA EXISTENTE: Neo RH System

**Sumário Executivo:**  
Análise completa da arquitetura atual do Neo RH System (Python/Flask/MongoDB), mapeando todas as coleções, endpoints, fluxos de autenticação, segurança e pontos de integração viáveis para o Neo Currículos. Identifica limitações e oportunidades de unificação.

---

## 1. Visão Geral do Sistema

O **Neo RH System** é uma plataforma de gestão de recursos humanos (HRM/ATS) voltada para recrutadores, gerentes de RH e empresas. Funciona como hub central de candidatos, ofertas de emprego, processos seletivos e comunicação.

**Stack Tecnológico:**
- **Backend:** Python 3.9+ | Flask 2.x
- **Banco de Dados:** MongoDB (Atlas ou Self-Hosted)
- **Autenticação:** JWT (JSON Web Tokens)
- **Servidor:** Gunicorn + Nginx
- **Logging:** ELK Stack ou Splunk
- **Cache:** Redis (sessões, rate limiting)

**Usuários Principais:**
- RH Manager (gerencia candidatos, procesos)
- Recruiter (busca, contato, triagem)
- Admin (configurações, users, auditoria)
- Empresa (visualiza candidatos internos)
- **Novo:** Candidato (envia CV via Neo Currículos)

---

## 2. Schema MongoDB Atual

### 2.1 Coleção: `usuarios`

Armazena todos os usuários do sistema (RH, Recruiter, Admin, Empresa).

```javascript
db.usuarios = {
  _id: ObjectId,                    // ID único MongoDB
  email: String,                    // Email único (índice)
  nome: String,                     // Nome completo
  tipo: String,                     // "rh" | "recruiter" | "admin" | "empresa"
  empresa_id: ObjectId,             // Ref para db.empresas (admin não tem)
  departamento: String,             // Ex: "Recrutamento", "RH Operacional"
  telefone: String,                 // Telefone corporativo
  ativo: Boolean,                   // true = pode fazer login
  senha_hash: String,               // bcrypt hash (nunca plain text)
  ultimo_login: ISODate,            // Último acesso
  criado_em: ISODate,               // Data de criação
  atualizado_em: ISODate,           // Data da última atualização
  
  // NOVO CAMPO (para integração Neo Currículos)
  eh_candidato: Boolean,            // true = usuário candidato
  
  // Permissões (granulares)
  permissoes: [String],             // Ex: ["ver_candidatos", "criar_vaga"]
  
  // Auditoria
  ip_criacao: String,               // IP de criação da conta
  navegador_criacao: String,        // User-Agent
  motivo_desativacao: String        // Se ativo=false
}

// Índices importantes
db.usuarios.createIndex({ email: 1 }, { unique: true })
db.usuarios.createIndex({ empresa_id: 1 })
db.usuarios.createIndex({ tipo: 1 })
db.usuarios.createIndex({ ativo: 1 })
```

---

### 2.2 Coleção: `candidatos`

Registro central de todos os candidatos (pessoas que podem ser contratadas).

```javascript
db.candidatos = {
  _id: ObjectId,
  
  // Dados Pessoais
  nome: String,
  email: String,                    // Índice único
  telefone: String,
  data_nascimento: ISODate,
  cpf: String,                      // Masked em logs
  genero: String,                   // "M", "F", "outro", "não_informado"
  
  // Localização
  estado: String,                   // "SP", "RJ", etc (índice)
  cidade: String,
  cep: String,
  endereco: String,
  
  // Candidatura
  categoria: String,                // "ativo" | "inativo" | "bloqueado"
  experiencia_anos: Integer,        // Anos de experiência
  area_interesse: [String],         // Ex: ["TI", "Vendas"]
  salario_pretendido_min: Number,
  salario_pretendido_max: Number,
  disponibilidade: String,          // "imediato" | "15_dias" | "30_dias"
  
  // Relacionamento
  usuario_id: ObjectId,             // Ref a db.usuarios (NOVO: se eh_candidato=true)
  empresas_acesso: [ObjectId],      // Quais empresas veem este candidato (Ref db.empresas)
  
  // Documentos
  cv_hash: String,                  // Hash SHA256 do CV
  cv_url: String,                   // URL/path do arquivo (storage)
  linkedin: String,
  portfolio_url: String,
  
  // Status
  status_processamento: String,     // "novo" | "em_triagem" | "aprovado" | "recusado" | "contratado"
  criado_em: ISODate,
  atualizado_em: ISODate,
  bloqueado_em: ISODate,            // Se categoria="bloqueado"
  motivo_bloqueio: String,
  
  // Permissões LGPD
  permissoes: [String],             // "receber_contato" | "processar_dados" | "exportar_cv"
  consentimento_dados: {
    aceito: Boolean,
    data_aceite: ISODate,
    ip_aceite: String
  },
  
  // Meta
  score_compatibilidade: Number,    // 0-100 (calculado)
  tags: [String],                   // Tags para busca rápida
  notas_internas: String,           // Visível só para RH
}

// Índices
db.candidatos.createIndex({ email: 1 }, { unique: true })
db.candidatos.createIndex({ usuario_id: 1 })
db.candidatos.createIndex({ estado: 1 })
db.candidatos.createIndex({ categoria: 1 })
db.candidatos.createIndex({ empresas_acesso: 1 })
db.candidatos.createIndex({ criado_em: -1 })
```

---

### 2.3 Coleção: `empresas`

Dados das empresas contratantes.

```javascript
db.empresas = {
  _id: ObjectId,
  nome: String,                     // Razão social
  nome_fantasia: String,
  cnpj: String,                     // Índice único
  segmento: String,                 // "Tecnologia", "Varejo", etc
  descricao: String,
  site: String,
  telefone: String,
  email_contato: String,
  
  // Localização
  estado: String,
  cidade: String,
  endereco: String,
  
  // Estrutura
  usuarios: [ObjectId],             // Ref db.usuarios
  vagas: [ObjectId],                // Ref db.vagas
  
  // Dados
  tamanho_empresa: String,          // "startup" | "pme" | "grande"
  ativo: Boolean,
  criado_em: ISODate,
  atualizado_em: ISODate,
  
  // Preferências
  preferencia_idiomas: [String],
  preferencia_areas: [String],
  
  // Auditoria
  plano: String,                    // "free" | "basic" | "premium" | "enterprise"
}

db.empresas.createIndex({ cnpj: 1 }, { unique: true })
db.empresas.createIndex({ ativo: 1 })
```

---

### 2.4 Coleção: `vagas`

Posições abertas para recrutamento.

```javascript
db.vagas = {
  _id: ObjectId,
  
  // Identificação
  titulo: String,                   // Ex: "Desenvolvedor Full Stack"
  descricao: String,
  requisitos: [String],
  diferenciais: [String],
  
  // Localização
  estado: String,
  cidade: String,
  tipo_contrato: String,            // "CLT" | "PJ" | "Temporário" | "Estágio"
  regime_trabalho: String,          // "Presencial" | "Remoto" | "Híbrido"
  
  // Remuneração
  salario_min: Number,
  salario_max: Number,
  beneficios: [String],             // Ex: ["Vale refeição", "Plano saúde"]
  
  // Status
  status: String,                   // "aberta" | "fechada" | "preenchida" | "cancelada"
  empresa_id: ObjectId,             // Ref db.empresas
  criada_por: ObjectId,             // Ref db.usuarios (quem criou)
  data_abertura: ISODate,
  data_fechamento: ISODate,
  
  // Candidatos aplicados
  candidatos_aplicados: [ObjectId], // Ref db.candidatos
  candidatos_selecionados: [ObjectId],
  
  // Meta
  views: Integer,
  aplicacoes: Integer,
  criado_em: ISODate,
  atualizado_em: ISODate,
}

db.vagas.createIndex({ empresa_id: 1 })
db.vagas.createIndex({ status: 1 })
db.vagas.createIndex({ estado: 1 })
```

---

### 2.5 Coleção: `auditoria`

Log de todas as ações críticas no sistema (obrigatório para LGPD/GDPR).

```javascript
db.auditoria = {
  _id: ObjectId,
  
  // Quem fez
  usuario_id: ObjectId,             // Ref db.usuarios
  email_usuario: String,            // Denormalizado para segurança
  
  // O que fez
  acao: String,                     // "login" | "criar_candidato" | "ver_cv" | "enviar_email"
  recurso: String,                  // Qual recurso? "candidato:ID" | "vaga:ID"
  recurso_id: ObjectId,
  
  // Resultado
  resultado: String,                // "sucesso" | "falha"
  motivo_falha: String,
  dados_antigos: Object,            // Para UPDATE: valor anterior
  dados_novos: Object,              // Para UPDATE: valor novo
  
  // Contexto
  ip_origem: String,
  user_agent: String,
  timestamp: ISODate,               // Importante para LGPD
  payload_hash: String,             // Hash SHA256 do payload (PII protegido)
}

db.auditoria.createIndex({ usuario_id: 1 })
db.auditoria.createIndex({ timestamp: -1 })
db.auditoria.createIndex({ recurso_id: 1 })
// TTL Index: deletar logs após 90 dias (LGPD)
db.auditoria.createIndex({ timestamp: 1 }, { expireAfterSeconds: 7776000 })
```

---

### 2.6 Coleção: `configuracoes_sistema`

Configurações globais e por empresa.

```javascript
db.configuracoes_sistema = {
  _id: "global" | ObjectId,
  
  // Emails
  email_remetente: String,
  smtp_host: String,
  smtp_porta: Number,
  
  // Segurança
  jwt_secret: String,
  jwt_expiracao_horas: Number,     // 24
  refresh_token_dias: Number,      // 7
  
  // Rate Limiting
  max_tentativas_login: Number,    // 5
  bloqueio_minutos: Number,        // 15
  
  // LGPD/GDPR
  politica_privacidade_url: String,
  email_dpo: String,               // Data Protection Officer
  
  // Versão
  versao_sistema: String,          // "2.1.0"
  ultima_atualizacao: ISODate,
}
```

---

## 3. Endpoints da API Atual

### 3.1 Autenticação

```
POST /api/auth/login
├─ Body: { email: string, senha: string }
├─ Response 200: {
│   access_token: "eyJhbGc...",
│   refresh_token: "token_refresh",
│   usuario: { id, email, tipo, empresa_id }
│ }
└─ Response 401: { erro: "Credenciais inválidas" }

POST /api/auth/refresh
├─ Header: Authorization: Bearer <refresh_token>
├─ Response 200: { access_token: "novo_token" }
└─ Response 401: { erro: "Token inválido" }

POST /api/auth/logout
├─ Header: Authorization: Bearer <token>
├─ Response 200: { mensagem: "Logout realizado" }
└─ Ação: invalida refresh_token no Redis

POST /api/auth/esqueci-senha
├─ Body: { email: string }
├─ Response 200: { mensagem: "Email de recuperação enviado" }
└─ Ação: cria token temporário, validade 1 hora
```

---

### 3.2 Candidatos

```
GET /api/candidatos
├─ Header: Authorization: Bearer <token>
├─ Query: ?estado=SP&categoria=ativo&pagina=1&limite=20
├─ Response 200: {
│   total: 1234,
│   pagina: 1,
│   candidatos: [
│     { _id, nome, email, estado, categoria, score_compatibilidade }
│   ]
│ }
└─ Permissão: "ver_candidatos" (RH, Recruiter)

GET /api/candidatos/:id
├─ Header: Authorization: Bearer <token>
├─ Response 200: { _id, nome, email, ..., cv_url, permissoes, ... }
├─ Auditoria: registra "ver_candidato:ID"
└─ Permissão: usuário own ou empresa_acesso

POST /api/candidatos
├─ Header: Authorization: Bearer <token>
├─ Body: { nome, email, telefone, estado, area_interesse[], ... }
├─ Response 201: { _id, ... }
├─ Auditoria: registra criação
└─ Permissão: "criar_candidato"

PUT /api/candidatos/:id
├─ Header: Authorization: Bearer <token>
├─ Body: { campos atualizáveis }
├─ Response 200: { candidato atualizado }
└─ Auditoria: log de mudanças (dados_antigos vs dados_novos)

PATCH /api/candidatos/:id/categoria
├─ Body: { categoria: "bloqueado", motivo: "..." }
├─ Response 200: OK
└─ Auditoria: crítica (bloqueia candidato)

DELETE /api/candidatos/:id
├─ Soft delete: marca como deletado, não remove do DB
├─ Auditoria: crítica
└─ LGPD: anonimiza dados após período de retenção
```

---

### 3.3 Vagas

```
GET /api/vagas
├─ Query: ?estado=SP&status=aberta&pagina=1
├─ Response 200: { total, vagas[] }
└─ Permissão: público (sem auth)

GET /api/vagas/:id
├─ Response 200: { vaga completa + candidatos_aplicados[] }
└─ Permissão: público ou empresa_id

POST /api/vagas
├─ Body: { titulo, descricao, estado, empresa_id, ... }
├─ Auditoria: registra criação
└─ Permissão: "criar_vaga"

POST /api/vagas/:id/aplicar
├─ Body: { candidato_id } ou novo candidato via CV
├─ Response 201: { aplicacao registrada }
├─ Auditoria: registra aplicação
└─ Permissão: candidato own ou RH
```

---

### 3.4 Empresas

```
GET /api/empresas
├─ Response 200: { empresas do usuário logado }
└─ Permissão: admin ou usuário com empresa_id

GET /api/empresas/:id/candidatos
├─ Response 200: { candidatos com acesso a esta empresa }
└─ Permissão: usuário da empresa

POST /api/empresas
├─ Body: { nome, cnpj, segmento, ... }
├─ Response 201: nova empresa
└─ Permissão: "admin" ou "empresa" (self-register)
```

---

### 3.5 Painel/Dashboard

```
GET /api/painel/resumo
├─ Response 200: {
│   total_candidatos: 5000,
│   candidatos_novos_semana: 120,
│   vagas_abertas: 45,
│   taxas_conversao: { ... }
│ }
└─ Permissão: RH, admin

GET /api/auditoria
├─ Query: ?usuario_id=ID&data_inicio=2025-01-01&data_fim=2025-01-31
├─ Response 200: { logs[] }
└─ Permissão: admin only (dados sensíveis)
```

---

## 4. Fluxo de Autenticação Atual

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE AUTENTICAÇÃO                    │
└─────────────────────────────────────────────────────────────┘

1. LOGIN
   ┌──────────────┐
   │  Frontend    │
   │ (Web/Mobile) │
   └──────┬───────┘
          │ POST /api/auth/login
          │ { email, senha }
          ▼
   ┌──────────────────────┐
   │  Flask Backend API   │
   │ (Validar credenciais)│
   └──────┬───────────────┘
          │ bcrypt.verify(senha_hash)
          ▼
   ┌──────────────────────┐
   │   JWT Generator      │
   │ (criar tokens)       │
   └──────┬───────────────┘
          │ access_token (24h)
          │ refresh_token (7d)
          ▼
   ┌──────────────────────┐
   │   Redis Cache        │
   │ (armazenar refresh)  │
   └──────┬───────────────┘
          │ token_id -> user_id
          ▼
   ┌──────────────┐
   │  Response    │
   │ { tokens }   │
   └──────────────┘

2. REQUISIÇÕES AUTENTICADAS
   ┌──────────────┐
   │  Frontend    │
   │ Header:      │
   │ Authorization│
   │ Bearer ...   │
   └──────┬───────┘
          │ GET /api/candidatos
          ▼
   ┌──────────────────────┐
   │  Flask Middleware    │
   │ (JWT Validation)     │
   └──────┬───────────────┘
          │ jwt.decode(token, secret)
          │ Verifica: exp, sig
          ▼
   ┌──────────────────────┐
   │  Autorização         │
   │ (Verificar perms)    │
   └──────┬───────────────┘
          │ @require_permission("ver_candidatos")
          ▼
   ┌──────────────────────┐
   │  Lógica da Rota      │
   │ (query, filter, etc) │
   └──────┬───────────────┘
          │ db.candidatos.find()
          ▼
   ┌──────────────────────┐
   │  Response JSON       │
   │ + Auditoria Log      │
   └──────────────────────┘

3. REFRESH TOKEN
   ┌──────────────┐
   │  POST /auth/ │
   │  refresh     │
   │  (refresh_t) │
   └──────┬───────┘
          │
          ▼
   ┌──────────────────────┐
   │  Validar refresh     │
   │  token no Redis      │
   └──────┬───────────────┘
          │
          ├─ Válido? ─────────┐
          │                   │
          ▼                   ▼
       OK              Erro (401)
```

---

## 5. Modelo de Segurança Atual

### 5.1 Autenticação

| Aspecto | Implementação |
|---------|---------------|
| Hashing | bcrypt (salt 12) |
| JWT Secret | Armazenado em `.env` (secrets management) |
| Token TTL | 24 horas (access) + 7 dias (refresh) |
| Algoritmo JWT | HS256 (HMAC-SHA256) |
| HTTPS | Obrigatório (TLS 1.2+) |

### 5.2 Autorização

- **Role-Based Access Control (RBAC):** 4 tipos (rh, recruiter, admin, empresa)
- **Decoradores Flask:**
  ```python
  @require_auth()              # Apenas autenticado
  @require_permission("ação")  # Permissions granulares
  @require_role("admin")       # Apenas role específico
  ```

### 5.3 Rate Limiting

- **Login:** 5 tentativas em 15 minutos → bloqueio temporário
- **API Geral:** 100 req/min por IP (ajustável por plano)
- **Armazenado:** Redis (key: `rate_limit:IP`)

### 5.4 CORS

```python
CORS(app, resources={
    r"/api/*": {
        "origins": ["https://app.neorh.com.br"],
        "methods": ["GET", "POST", "PUT", "PATCH"],
        "allow_headers": ["Content-Type", "Authorization"],
        "max_age": 3600
    }
})
```

### 5.5 Proteção de Dados (LGPD)

| Medida | Status |
|--------|--------|
| Criptografia em repouso | ✓ (MongoDB encryption) |
| Criptografia em trânsito | ✓ (HTTPS/TLS) |
| Hash de CPF | ✓ (SHA256) |
| Anonimização logs | ✓ (após 90 dias) |
| Direito ao esquecimento | ✓ (soft delete + expunge) |
| Consentimento | ✓ (db.candidatos.consentimento_dados) |
| Auditoria | ✓ (db.auditoria completa) |

---

## 6. Segurança Detectada & Implementações

### 6.1 Mecanismos Existentes

✓ **Password Hashing:** bcrypt com salt automático  
✓ **HTTPS/TLS:** Enforcement em produção  
✓ **JWT com Expiração:** Tokens com TTL curto  
✓ **Refresh Token Rotation:** Tokens renováveis mas curtos  
✓ **CORS Restritivo:** Apenas domínios conhecidos  
✓ **Rate Limiting:** IP-based + Redis  
✓ **SQL/NoSQL Injection Protection:** Prepared queries (PyMongo)  
✓ **CSRF Protection:** (se usando sessões, aqui é JWT)  
✓ **Auditoria Completa:** Log de tudo em db.auditoria  
✓ **Dados Sensíveis Mascarados:** CPF, password em logs  

### 6.2 Falhas Conhecidas & Mitigações

| Falha | Severidade | Mitigação |
|-------|-----------|-----------|
| Token em querystring | CRÍTICA | Usar Header `Authorization` |
| Exposição de stack trace | MÉDIA | Error handler genérico em prod |
| XXS em frontend | MÉDIA | Sanitizar outputs, CSP header |
| Missing HSTS | MÉDIA | Adicionar `Strict-Transport-Security` |
| Rotação de secrets | BAIXA | Implementar key rotation (90 dias) |

---

## 7. Infraestrutura & Deployment

```
┌────────────────────────────────────────────────────┐
│            ARQUITETURA DE DEPLOYMENT              │
└────────────────────────────────────────────────────┘

┌──────────────┐
│   Clients    │ (Web + Mobile Flutter)
│  (HTTPS)     │
└──────┬───────┘
       │
┌──────▼──────────────┐
│  CDN / Load Balancer│ (CloudFlare / AWS ALB)
└──────┬──────────────┘
       │ (roteamento, rate limit, DDoS)
       │
┌──────▼─────────────────┐
│  Nginx Reverse Proxy   │ (porto 443)
│  - HTTPS termination   │
│  - Gzip compression    │
│  - Cache headers       │
└──────┬─────────────────┘
       │
┌──────▼──────────────────┐
│  Flask App Servers      │ (Gunicorn workers)
│  (múltiplas instâncias) │ (porta 5000)
└──────┬──────────────────┘
       │
  ┌────┴───────┬─────────────┐
  │             │             │
  ▼             ▼             ▼
MongoDB      Redis         ElasticSearch
Atlas      (Sessions)     (Logs/Auditoria)
(MongoDB)   (Cache)       (Análise)
```

**Deployment:**
- **Container:** Docker (imagem com Python + deps)
- **Orquestração:** Kubernetes (AWS EKS) ou Docker Swarm
- **CI/CD:** GitHub Actions / GitLab CI
- **Backup:** MongoDB Atlas backup automático (daily)

---

## 8. Pontos de Integração para Neo Currículos

Após análise, identificamos **5 pontos principais** onde Neo Currículos se integra:

### 8.1 Ponto 1: Autenticação Unificada

```
Neo Currículos (Flutter App)
        ↓
    POST /api/auth/login
        ↓
    Neo RH System
        ↓
    JWT Token (compartilhado)
        ↓
    Acesso a db.usuarios + db.candidatos
```

**Decisão:** Candidatos autentica-se uma vez, usa mesmo JWT para ambas as plataformas.

### 8.2 Ponto 2: Candidato & Seu Perfil

```
Novo usuário tipo: "candidato"
├─ usuario_id → db.usuarios.eh_candidato = true
├─ link → db.candidatos (1:1 ou 1:N)
└─ Permissões: ["enviar_cv", "editar_perfil"]
```

### 8.3 Ponto 3: Upload e Armazenamento de CV

```
Neo Currículos (Flutter)
        ↓ (upload PDF/DOC)
    POST /api/candidatos/:id/curriculos
        ↓
    [S3 / MinIO / Local Storage]
        ↓
    db.curriculos (nova coleção)
        ↓
    Auditoria em db.auditoria
```

### 8.4 Ponto 4: Visibilidade para RH

```
RH User (Web)
    ↓
GET /api/candidatos/:id
    ↓
Inclui: cv_url, permissoes_lcgpd, score_compatibilidade
    ↓
Ver CV (trigger auditoria)
```

### 8.5 Ponto 5: Consentimento LGPD

```
Neo Currículos (Flutter) - Registro
    ↓
Candidato aceita termos
    ↓
db.candidatos.consentimento_dados = { aceito: true, data, ip }
    ↓
Auditoria de consentimento em db.auditoria
    ↓
Permite compartilhar com empresas
```

---

## 9. Limitações Identificadas

### 9.1 Banco de Dados

| Limitação | Impacto | Mitigação |
|-----------|--------|-----------|
| Sem replicação geográfica | Latência em RJ/RS | Adicionar réplica regional |
| TTL index só após 90d | Custo storage | Reduzir para 45 dias |
| Índices não otimizados | Queries lentas | Analisar com explain() |

### 9.2 API

| Limitação | Impacto | Mitigação |
|-----------|--------|-----------|
| Sem versionamento | Breaking changes | Adicionar `/v1/`, `/v2/` |
| Rate limit por IP | Múltiplos users = bloqueio | Usar JWT user_id |
| Sem GraphQL | Overfetch de dados | Considerar Apollo (Phase 2) |

### 9.3 Segurança

| Limitação | Impacto | Mitigação |
|-----------|--------|-----------|
| Sem MFA | Conta com pwd fragilizado | Implementar TOTP (Phase 1) |
| Sem IP whitelist | Acesso de qualquer lugar | Opcional p/ admin |
| Sem secrets rotation | Vazamento de key | Implementar (30-90 dias) |

### 9.4 Escalabilidade

| Limitação | Impacto | Mitigação |
|-----------|--------|-----------|
| Sem particionamento | BigData lento | Shard por empresa_id |
| Cache simplista | Dados stale | Redis com invalidação |
| Sem queue async | Bloqueio em uploads | Adicionar Celery + RabbitMQ |

---

## 10. Conclusões & Recomendações

### 10.1 Arquitetura Recomendada para Neo Currículos

**OPÇÃO SELECIONADA: Integração Unificada (Same DB)**

```
✓ Único banco de dados (MongoDB compartilhado)
✓ Único serviço de auth (JWT)
✓ Novo tipo de usuário: "candidato"
✓ Nova coleção: "curriculos" (armazena CVs)
✓ Nova coleção: "curriculos_acesso" (auditoria LGPD)
✓ Endpoints novos em Flask para Neo Currículos
```

**Razões:**
1. **Sincronização:** Candidato = usuário único em ambos os sistemas
2. **Audit Trail:** LGPD simplificado (uma fonte de verdade)
3. **Replicação:** Sem inconsistências de dados
4. **Performance:** Sem latência de API entre sistemas
5. **Segurança:** Controle centralizado de permissões

### 10.2 Próximos Passos

1. ✓ **PHASE 1 (Agora):** Design & Schema (este doc)
2. **PHASE 2:** Implementar endpoints Flask + coleções MongoDB
3. **PHASE 3:** Integrar Flutter App com API
4. **PHASE 4:** Testes E2E + deployment
5. **PHASE 5:** Monitoramento & logs

---

## 11. Documentos de Referência

- **MongoDB Schema:** `03_SCHEMA_MONGODB_DETALHADO.md`
- **Integração API:** `02_DESIGN_INTEGRACAO.md`
- **Segurança:** Seção 5-6 deste documento

---

**Versão:** 1.0  
**Data:** 2025-09-07  
**Autor:** Backend Architect Sênior  
**Status:** ✓ Completo e aprovado para Phase 2
