# Neo Currículos + Neo RH API - Documentação OpenAPI

**Versão:** 1.0.0  
**Base URL:** `http://localhost:5000/api` ou `https://api.neocurriculos.com/api`  
**Autenticação:** JWT Bearer Token

---

## 📚 Índice

1. [Autenticação](#autenticação)
2. [Currículos](#currículos)
3. [Auditoria LGPD](#auditoria-lgpd)
4. [Status Codes](#status-codes)
5. [Exemplos cURL](#exemplos-curl)

---

## 🔐 Autenticação

### POST /auth/registrar

Registrar novo candidato

**Request:**
```json
{
  "email": "candidato@example.com",
  "nome": "João Silva",
  "senha": "Senha@123",
  "aceitar_termos": true
}
```

**Response (201):**
```json
{
  "usuario_id": "670a5f8c3e2d4c1b2a9d8e7f",
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "Bearer",
  "expires_in": 86400,
  "tipo": "candidato",
  "nome": "João Silva"
}
```

**Validações:**
- Email válido (RFC 5322)
- Senha: 8+ chars, maiúscula, número
- Email único (409 se duplicado)

**Rate Limit:** 10 registros / 1 hora

---

### POST /auth/login

Login para candidato, RH ou admin

**Request:**
```json
{
  "email": "candidato@example.com",
  "senha": "Senha@123"
}
```

**Response (200):**
```json
{
  "usuario_id": "670a5f8c3e2d4c1b2a9d8e7f",
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "Bearer",
  "expires_in": 86400,
  "tipo": "candidato",
  "nome": "João Silva"
}
```

**Errors:**
- 400: Email ou senha ausente
- 401: Email não encontrado ou senha incorreta
- 403: Usuário inativo

**Rate Limit:** 5 tentativas / 15 minutos

---

### POST /auth/refresh

Renovar access token usando refresh token

**Request:**
```json
{
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

**Response (200):**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "Bearer",
  "expires_in": 86400
}
```

**Errors:**
- 400: refresh_token ausente
- 401: Refresh token inválido ou expirado

---

### POST /auth/logout

Logout (invalida token no cliente)

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "mensagem": "Logout bem-sucedido. Remova o token no cliente."
}
```

**Nota:** Token ainda é válido no servidor até expirar (24h). Cliente deve removê-lo localmente.

---

### GET /auth/me

Obter informações do usuário autenticado

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "usuario_id": "670a5f8c3e2d4c1b2a9d8e7f",
  "email": "candidato@example.com",
  "nome": "João Silva",
  "tipo": "candidato",
  "consentimento": false,
  "criado_em": "2026-09-07T10:00:00"
}
```

**Errors:**
- 401: Token ausente ou inválido
- 404: Usuário não encontrado

---

## 📄 Currículos

### POST /curriculos/upload

Upload de currículo em PDF

**Headers:**
```
Authorization: Bearer <access_token>
Content-Type: multipart/form-data
```

**Body:**
```
arquivo: <file.pdf>  (binary, max 10MB)
```

**Response (201):**
```json
{
  "curriculo_id": "670a5f8c3e2d4c1b2a9d8e7f",
  "versao": 1,
  "url": "s3://neo-curriculos/userid/hash.pdf",
  "hash": "sha256_hash_64_chars",
  "tamanho": 512000,
  "criado_em": "2026-09-07T10:00:00"
}
```

**Validações:**
- Arquivo obrigatório
- Extensão: .pdf
- Tamanho: max 10MB
- Usuário deve ter consentimento LGPD

**Errors:**
- 400: Arquivo não enviado, extensão inválida, tamanho excedido
- 401: Token ausente/inválido
- 403: Sem consentimento LGPD

**Features:**
- Versionamento automático
- Hash SHA256 para integridade
- Upload para S3/MinIO
- Auditoria registrada

**Rate Limit:** 20 uploads / 1 hora

---

### GET /candidatos/:id/curriculos

Listar todas as versões de currículo do candidato

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Params:**
```
limit=20 (opcional, default 20, max 100)
offset=0 (opcional, default 0)
```

**Response (200):**
```json
{
  "total": 2,
  "curriculos": [
    {
      "curriculo_id": "670a5f8c3e2d4c1b2a9d8e7f",
      "versao": 2,
      "url": "s3://neo-curriculos/userid/hash_v2.pdf",
      "ativo": true,
      "tamanho": 520000,
      "criado_em": "2026-09-07T11:00:00"
    },
    {
      "curriculo_id": "670a5f8c3e2d4c1a2a9d8e7f",
      "versao": 1,
      "url": "s3://neo-curriculos/userid/hash_v1.pdf",
      "ativo": false,
      "tamanho": 512000,
      "criado_em": "2026-09-07T10:00:00"
    }
  ]
}
```

**Permissões:**
- Candidato: pode acessar seu próprio CV
- Admin: pode acessar qualquer CV

**Errors:**
- 401: Token ausente/inválido
- 403: Acesso negado

---

### POST /candidatos/:id/consentimento

Registrar consentimento LGPD

**Headers:**
```
Authorization: Bearer <access_token>
Content-Type: application/json
```

**Body:**
```json
{
  "consentimento": true,
  "termos_versao": "1.0"
}
```

**Response (200):**
```json
{
  "usuario_id": "670a5f8c3e2d4c1b2a9d8e7f",
  "consentimento": true,
  "consentimento_data": "2026-09-07T10:00:00",
  "consentimento_versao": "1.0"
}
```

**Validações:**
- `consentimento` obrigatório
- `termos_versao` obrigatório

**Errors:**
- 400: Body inválido
- 401: Token ausente/inválido
- 403: Acesso negado

**Importante:** Sem consentimento, não é possível fazer upload de CV.

---

### DELETE /candidatos/:id/deletar-conta

Deletar conta (soft delete + anonimização)

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "mensagem": "Conta marcada para deleção",
  "usuario_id": "670a5f8c3e2d4c1b2a9d8e7f",
  "sera_anonimizado_em": "2026-10-07T10:00:00",
  "nota": "Sua conta será anonimizada após 30 dias. Você pode recuperá-la neste período."
}
```

**Processo LGPD:**
1. Marca `marcacao_delecao` = agora
2. Set `ativo` = false
3. Aguarda 30 dias
4. Auto-anonimiza (TTL index)
5. Nome → "ANONIMIZADO"
6. Email → hash SHA256

**Errors:**
- 401: Token ausente/inválido
- 403: Acesso negado
- 404: Usuário não encontrado

**Período de Recuperação:** 30 dias (pode contactar suporte)

---

### GET /curriculos/busca

Buscar currículos (apenas para RH/Empresa)

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Params:**
```
estado=sp                (opcional)
categoria=dev            (opcional)
data_criacao=2026-09-07  (opcional, ISO date)
empresa_id=...           (opcional)
limit=20                 (opcional, default 20, max 100)
offset=0                 (opcional, default 0)
```

**Response (200):**
```json
{
  "total": 150,
  "limit": 20,
  "offset": 0,
  "curriculos": [
    {
      "curriculo_id": "670a5f8c3e2d4c1b2a9d8e7f",
      "usuario_id": "670a5f8c3e2d4c1b2a9d8e7a",
      "candidato_nome": "João Silva",
      "versao": 1,
      "criado_em": "2026-09-07T10:00:00",
      "tamanho": 512000
    }
  ],
  "proxima_pagina": 20
}
```

**Permissões:**
- RH: acesso total
- Recruiter: acesso limitado
- Empresa: acesso a CVs compartilhados
- Candidato: acesso negado (403)

**Performance:**
- Índices otimizados
- Paginação com limit/offset
- Sem N+1 queries

**Errors:**
- 401: Token ausente/inválido
- 403: Permissão insuficiente

---

## 📊 Auditoria LGPD

### GET /auditoria/relatorio

Relatório de auditoria (apenas admin)

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Params:**
```
usuario_id=...          (opcional)
acao=visualizar         (opcional: visualizar, download, compartilhar)
data_inicio=2026-09-01  (opcional, ISO date)
data_fim=2026-09-07     (opcional, ISO date)
limit=100               (opcional, default 100, max 1000)
offset=0                (opcional, default 0)
```

**Response (200):**
```json
{
  "total": 5000,
  "limit": 100,
  "offset": 0,
  "registros": [
    {
      "timestamp": "2026-09-07T10:00:00",
      "usuario_id": "670a5f8c3e2d4c1b2a9d8e7f",
      "acessado_por": "670a5f8c3e2d4c1b2a9d8e7a",
      "acao": "visualizar",
      "resultado": "sucesso",
      "ip_address": "192.168.1.1"
    }
  ],
  "proxima_pagina": 100
}
```

**Características LGPD:**
- TTL: 7 anos (automático)
- Rastreamento: IP + user-agent
- Ações: visualizar, download, compartilhar, deletar
- Retenção: conforme legislação

**Permissões:**
- Admin: acesso total
- Outros: acesso negado (403)

**Errors:**
- 401: Token ausente/inválido
- 403: Permissão insuficiente

---

## 📊 Status Codes

| Code | Significado | Exemplo |
|------|-------------|---------|
| **200** | OK | Login bem-sucedido |
| **201** | Created | Registro criado |
| **400** | Bad Request | Validação falhou |
| **401** | Unauthorized | Token inválido/ausente |
| **403** | Forbidden | Permissão insuficiente |
| **404** | Not Found | Recurso não encontrado |
| **409** | Conflict | Email duplicado |
| **429** | Too Many Requests | Rate limit atingido |
| **500** | Server Error | Erro interno |

---

## 🔧 Exemplos cURL

### Registrar

```bash
curl -X POST http://localhost:5000/api/auth/registrar \
  -H "Content-Type: application/json" \
  -d '{
    "email": "novo@example.com",
    "nome": "Novo User",
    "senha": "Senha@123",
    "aceitar_termos": true
  }'
```

### Login

```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "novo@example.com",
    "senha": "Senha@123"
  }'
```

### Upload CV

```bash
curl -X POST http://localhost:5000/api/curriculos/upload \
  -H "Authorization: Bearer <token>" \
  -F "arquivo=@meu_cv.pdf"
```

### Listar CVs

```bash
curl -X GET "http://localhost:5000/api/candidatos/{user_id}/curriculos" \
  -H "Authorization: Bearer <token>"
```

### Consentimento

```bash
curl -X POST "http://localhost:5000/api/candidatos/{user_id}/consentimento" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "consentimento": true,
    "termos_versao": "1.0"
  }'
```

### Buscar CVs (RH)

```bash
curl -X GET "http://localhost:5000/api/curriculos/busca?limit=20&offset=0" \
  -H "Authorization: Bearer <rh_token>"
```

### Deletar Conta

```bash
curl -X DELETE "http://localhost:5000/api/candidatos/{user_id}/deletar-conta" \
  -H "Authorization: Bearer <token>"
```

### Relatório Auditoria (Admin)

```bash
curl -X GET "http://localhost:5000/api/auditoria/relatorio?limite=100" \
  -H "Authorization: Bearer <admin_token>"
```

---

## 🔒 Segurança

- **JWT**: HS256, 24h TTL (access) + 30d TTL (refresh)
- **Senha**: bcrypt 12 rounds, min 8 chars + maiúscula + número
- **Rate Limiting**: 5 logins/15 min, 10 registros/hora
- **CORS**: Configurável por origin
- **HTTPS**: Requerido em produção
- **Auditoria**: Todos os acessos registrados (7 anos TTL)

---

## 📝 Versionamento

- **Versão API**: 1.0.0
- **Compatibilidade**: semver
- **Deprecação**: comunicada com 6 meses antecedência

---

## 📞 Suporte

- **Docs:** http://localhost:5000/api/docs
- **Health:** http://localhost:5000/health
- **Issues:** Abrir issue no repositório

---

**Última atualização:** 2026-09-07  
**Status:** ✅ Production Ready
