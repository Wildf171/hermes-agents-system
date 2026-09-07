# 03 - SCHEMA MONGODB DETALHADO: Integração Neo Currículos

**Sumário Executivo:**  
Especificação completa das coleções MongoDB para integração Neo Currículos. Inclui novos campos em coleções existentes, 2 novas coleções (curriculos, curriculos_acesso), índices de performance, script de migração e estratégia de backup e retenção.

---

## 1. Resumo das Mudanças no Schema

### 1.1 Coleções Modificadas

| Coleção | Mudança | Justificativa |
|---------|---------|---------------|
| `usuarios` | +2 campos | Suportar novo tipo "candidato" |
| `candidatos` | +3 campos | CV, consentimento LGPD, acesso |

### 1.2 Novas Coleções

| Coleção | Propósito |
|---------|-----------|
| `curriculos` | Armazena versões de CV por candidato |
| `curriculos_acesso` | Auditoria LGPD (quem viu CV, quando) |

---

## 2. Coleção: `usuarios` (MODIFICADA)

### 2.1 Schema Completo

```javascript
db.usuarios = {
  _id: ObjectId,
  
  // Identificação
  email: String,                    // Índice: UNIQUE
  nome: String,
  
  // Tipo de usuário (expandido para "candidato")
  tipo: {
    type: String,
    enum: ["rh", "recruiter", "admin", "empresa", "candidato"],
    description: "Tipo de usuário"
  },
  
  // NOVO: Marcar se é candidato
  eh_candidato: {
    type: Boolean,
    description: "true se tipo='candidato', false caso contrário",
    default: false
  },
  
  // Empresa (empresas com tipo="candidato" não têm)
  empresa_id: {
    type: ObjectId,
    ref: "empresas",
    description: "Null para tipo='candidato'"
  },
  
  // Informações pessoais
  departamento: String,
  telefone: String,
  
  // Autenticação
  senha_hash: String,               // bcrypt
  
  // Status
  ativo: {
    type: Boolean,
    description: "true = pode fazer login"
  },
  
  // Datas
  criado_em: ISODate,
  atualizado_em: ISODate,
  ultimo_login: ISODate,
  
  // NOVO: Marcação para deleção (LGPD)
  marcado_para_delecao: {
    type: Boolean,
    default: false,
    description: "true = aguardando período de 30 dias"
  },
  
  data_delecao_solicitada: {
    type: ISODate,
    description: "Data em que deleção foi solicitada"
  },
  
  motivo_delecao: String,
  
  // Permissões (granulares)
  permissoes: {
    type: [String],
    description: "Ex: 'ver_candidatos', 'criar_vaga', 'enviar_cv'",
    enum: [
      "ver_candidatos",
      "criar_candidato",
      "editar_candidato",
      "deletar_candidato",
      "ver_vagas",
      "criar_vaga",
      "editar_vaga",
      "deletar_vaga",
      "enviar_cv",
      "editar_perfil",
      "exportar_dados",
      "acessar_auditoria",
      "gerenciar_usuarios",
      "gerenciar_empresas"
    ]
  },
  
  // Auditoria de criação
  ip_criacao: String,
  navegador_criacao: String,
  
  // Desativação (soft delete)
  motivo_desativacao: String,
  
  // NOVO: Migração
  migrado_neo_curriculos: {
    type: Boolean,
    default: false,
    description: "true = usuário foi migrado do Neo Currículos"
  }
}

// ÍNDICES
db.usuarios.createIndex({ email: 1 }, { unique: true })
db.usuarios.createIndex({ tipo: 1 })
db.usuarios.createIndex({ empresa_id: 1 })
db.usuarios.createIndex({ eh_candidato: 1 })
db.usuarios.createIndex({ ativo: 1 })
db.usuarios.createIndex({ marcado_para_delecao: 1 })
db.usuarios.createIndex({ criado_em: -1 })
```

### 2.2 Permissões por Tipo de Usuário

```javascript
// Padrão de permissões por tipo (para referência)
{
  "rh": [
    "ver_candidatos",
    "criar_candidato",
    "editar_candidato",
    "ver_vagas",
    "criar_vaga",
    "editar_vaga",
    "acessar_auditoria"
  ],
  
  "recruiter": [
    "ver_candidatos",
    "criar_candidato",
    "editar_candidato",
    "ver_vagas",
    "criar_vaga",
    "editar_vaga"
  ],
  
  "admin": [
    "ver_candidatos",
    "criar_candidato",
    "editar_candidato",
    "deletar_candidato",
    "ver_vagas",
    "criar_vaga",
    "editar_vaga",
    "deletar_vaga",
    "acessar_auditoria",
    "gerenciar_usuarios",
    "gerenciar_empresas"
  ],
  
  "empresa": [
    "ver_candidatos",          // Apenas com consentimento
    "ver_vagas"
  ],
  
  "candidato": [               // NOVO
    "enviar_cv",
    "editar_perfil",
    "exportar_dados"
  ]
}
```

---

## 3. Coleção: `candidatos` (MODIFICADA)

### 3.1 Schema Completo

```javascript
db.candidatos = {
  _id: ObjectId,
  
  // Dados Pessoais
  nome: String,
  email: String,                    // Índice: UNIQUE
  telefone: String,
  data_nascimento: ISODate,
  cpf: {
    type: String,
    description: "HASH SHA256 do CPF (nunca plain text)"
  },
  genero: {
    type: String,
    enum: ["M", "F", "outro", "não_informado"],
    default: "não_informado"
  },
  
  // Localização
  estado: String,                   // Índice
  cidade: String,
  cep: String,
  endereco: String,
  
  // Profissional
  area_interesse: [String],
  experiencia_anos: Integer,
  salario_pretendido_min: Number,
  salario_pretendido_max: Number,
  disponibilidade: String,          // "imediato", "15_dias", "30_dias"
  habilidades: [String],
  
  // Relacionamento com usuário
  usuario_id: {
    type: ObjectId,
    ref: "usuarios",
    description: "NOVO: Link para usuário candidato se eh_candidato=true"
  },
  
  // Acesso de empresas
  empresas_acesso: {
    type: [ObjectId],
    ref: "empresas",
    description: "Quais empresas podem ver este candidato"
  },
  
  // ===== NOVO: Seção Currículo =====
  curriculo_ativo: {
    type: {
      curriculo_id: ObjectId,       // Ref para db.curriculos
      versao: Integer,
      criado_em: ISODate,
      arquivo_url: String,          // S3/MinIO URL
      arquivo_hash: String          // SHA256 (32 chars)
    },
    description: "Referência ao CV ativo (versão mais recente)"
  },
  
  historico_curriculos: {
    type: [ObjectId],
    ref: "curriculos",
    description: "Todas as versões de CV (histórico)"
  },
  
  // ===== NOVO: Consentimento LGPD =====
  consentimento_dados: {
    type: {
      aceito: {
        type: Boolean,
        description: "Aceita compartilhar CV com empresas?"
      },
      
      data_aceite: {
        type: ISODate,
        description: "Data/hora do consentimento"
      },
      
      ip_aceite: String,
      
      navegador_aceite: String,
      
      termos_versao: {
        type: String,
        description: "Versão da política de privacidade que aceitou (ex: 1.0, 2.0)"
      },
      
      revogado_em: {
        type: ISODate,
        description: "Data/hora da revogação (se aplicável)"
      },
      
      motivo_revogacao: String
    },
    default: {},
    description: "Controle de consentimento LGPD para compartilhamento de CV"
  },
  
  // ===== NOVO: Permissões adicionais =====
  permissoes: {
    type: [String],
    enum: [
      "receber_contato",              // RH pode enviar email
      "processar_dados",              // Usar dados para análise
      "exportar_cv"                   // Candidato exportar seu próprio CV
    ],
    default: [],
    description: "Permissões específicas do candidato"
  },
  
  // Status candidato
  categoria: {
    type: String,
    enum: ["ativo", "inativo", "bloqueado"],
    default: "ativo"
  },
  
  status_processamento: {
    type: String,
    enum: ["novo", "em_triagem", "aprovado", "recusado", "contratado"],
    default: "novo"
  },
  
  bloqueado_em: ISODate,
  motivo_bloqueio: String,
  
  // Meta dados
  score_compatibilidade: {
    type: Number,
    min: 0,
    max: 100,
    description: "Score calculado pela IA (0-100)"
  },
  
  tags: [String],
  notas_internas: String,           // Visível só para RH
  
  // ===== NOVO: Marcação para deleção =====
  marcado_para_delecao: {
    type: Boolean,
    default: false,
    description: "Soft delete aguardando período"
  },
  
  data_delecao_solicitada: ISODate,
  
  // Datas
  criado_em: ISODate,
  atualizado_em: ISODate,
  deletado_em: {
    type: ISODate,
    description: "Data de deleção (soft delete)"
  }
}

// ÍNDICES
db.candidatos.createIndex({ email: 1 }, { unique: true })
db.candidatos.createIndex({ usuario_id: 1 })
db.candidatos.createIndex({ estado: 1 })
db.candidatos.createIndex({ categoria: 1 })
db.candidatos.createIndex({ empresas_acesso: 1 })
db.candidatos.createIndex({ criado_em: -1 })
db.candidatos.createIndex({ "consentimento_dados.aceito": 1 })
db.candidatos.createIndex({ marcado_para_delecao: 1 })

// Índice composto: buscar por estado + categoria
db.candidatos.createIndex({ estado: 1, categoria: 1 })

// Índice para busca full-text (opcional, Phase 2)
// db.candidatos.createIndex({ nome: "text", habilidades: "text", area_interesse: "text" })
```

---

## 4. Coleção NOVA: `curriculos`

Armazena todas as versões de CV por candidato.

```javascript
db.curriculos = {
  _id: ObjectId,
  
  // Relacionamento
  usuario_id: {
    type: ObjectId,
    ref: "usuarios",
    description: "ID do usuário candidato",
    index: true
  },
  
  candidato_id: {
    type: ObjectId,
    ref: "candidatos",
    description: "ID do candidato (denormalizado para facilitar queries)"
  },
  
  // Versioning
  versao: {
    type: Integer,
    description: "Número sequencial (1, 2, 3, ...)"
  },
  
  ativo: {
    type: Boolean,
    default: true,
    description: "true = versão atual, false = histórico"
  },
  
  // Arquivo
  arquivo_url: {
    type: String,
    description: "URL do S3/MinIO (ex: s3://bucket/curriculos/user_123/v2_abc123.pdf)"
  },
  
  arquivo_hash: {
    type: String,
    description: "SHA256 do arquivo (32 chars)",
    unique: true,
    index: true
  },
  
  arquivo_tamanho: {
    type: Number,
    description: "Tamanho em bytes"
  },
  
  tipo_mime: {
    type: String,
    default: "application/pdf",
    enum: ["application/pdf"]  // Apenas PDF por enquanto
  },
  
  // Metadados do upload
  upload_ip: String,
  upload_navegador: String,
  upload_dispositivo: {
    type: String,
    enum: ["mobile", "desktop", "tablet"],
    description: "Tipo de dispositivo que fez upload"
  },
  
  // Detecção de conteúdo (opcional, Phase 2)
  paginas: {
    type: Integer,
    description: "Número de páginas do PDF"
  },
  
  tempo_leitura_estimado: {
    type: Integer,
    description: "Tempo em segundos para ler todo CV"
  },
  
  // OCR / Análise (opcional, Phase 2)
  texto_extraido: {
    type: String,
    description: "Texto extraído via OCR (para busca full-text)"
  },
  
  habilidades_detectadas: {
    type: [String],
    description: "Habilidades detectadas via NLP (ex: Python, React, Agile)"
  },
  
  // Datas
  criado_em: {
    type: ISODate,
    default: ISODate()
  },
  
  atualizado_em: ISODate,
  
  // Soft delete
  deletado_em: ISODate,
  motivo_delecao: String
}

// ÍNDICES
db.curriculos.createIndex({ usuario_id: 1, versao: -1 })
db.curriculos.createIndex({ usuario_id: 1, ativo: 1 })
db.curriculos.createIndex({ arquivo_hash: 1 }, { unique: true })
db.curriculos.createIndex({ candidato_id: 1 })
db.curriculos.createIndex({ criado_em: -1 })
db.curriculos.createIndex({ ativo: 1, deletado_em: 1 })
```

---

## 5. Coleção NOVA: `curriculos_acesso`

Auditoria LGPD: rastreia quem acessou qual CV e quando.

```javascript
db.curriculos_acesso = {
  _id: ObjectId,
  
  // O que foi acessado
  curriculo_id: {
    type: ObjectId,
    ref: "curriculos"
  },
  
  usuario_candidato_id: {
    type: ObjectId,
    ref: "usuarios",
    description: "ID do candidato que enviou o CV"
  },
  
  candidato_id: {
    type: ObjectId,
    ref: "candidatos",
    description: "ID do perfil de candidato"
  },
  
  // Quem acessou
  usuario_acesso_id: {
    type: ObjectId,
    ref: "usuarios",
    description: "ID de quem acessou (RH, recruiter, etc)"
  },
  
  email_usuario_acesso: {
    type: String,
    description: "Email de quem acessou (denormalizado)"
  },
  
  tipo_usuario_acesso: {
    type: String,
    enum: ["rh", "recruiter", "admin", "empresa"],
    description: "Tipo de quem acessou"
  },
  
  empresa_id_acesso: {
    type: ObjectId,
    ref: "empresas",
    description: "Se tipo_usuario_acesso='empresa', qual empresa"
  },
  
  // Como acessou
  tipo_acesso: {
    type: String,
    enum: ["visualizacao", "download", "impressao", "compartilhamento"],
    description: "Tipo de acesso ao CV"
  },
  
  resultado_acesso: {
    type: String,
    enum: ["sucesso", "negado"],
    description: "Acesso foi permitido ou bloqueado?"
  },
  
  motivo_negacao: {
    type: String,
    description: "Se resultado='negado', qual o motivo? (ex: consentimento revogado)"
  },
  
  // Contexto técnico
  ip_origem: String,
  user_agent: String,
  localizacao_geohash: {
    type: String,
    description: "Geohash da localização (privacidade)"
  },
  
  // Timing
  timestamp: {
    type: ISODate,
    default: ISODate()
  },
  
  duracao_segundos: {
    type: Number,
    description: "Quanto tempo o CV foi visualizado"
  },
  
  // Retenção (obrigatório por lei)
  retenido_ate: {
    type: ISODate,
    description: "Data de expiração deste log (7 anos por lei brasileira)"
  }
}

// ÍNDICES
db.curriculos_acesso.createIndex({ usuario_candidato_id: 1, timestamp: -1 })
db.curriculos_acesso.createIndex({ usuario_acesso_id: 1, timestamp: -1 })
db.curriculos_acesso.createIndex({ curriculo_id: 1 })
db.curriculos_acesso.createIndex({ timestamp: -1 })
db.curriculos_acesso.createIndex({ resultado_acesso: 1 })

// TTL Index: Auto-delete após 7 anos (254,016,000 segundos)
db.curriculos_acesso.createIndex(
  { retenido_ate: 1 },
  { expireAfterSeconds: 0 }  // Expira quando retenido_ate < agora
)
```

---

## 6. Coleção: `auditoria` (SEM MUDANÇAS)

A coleção existente continua funcionando, mas pode ser expandida:

```javascript
db.auditoria = {
  _id: ObjectId,
  
  usuario_id: ObjectId,
  email_usuario: String,
  
  acao: String,
  // Novas ações possíveis:
  // "upload_curriculo"
  // "acessar_curriculo"
  // "baixar_curriculo"
  // "consentimento_dado"
  // "consentimento_revogado"
  // "delecao_solicitada"
  // "delecao_completada"
  
  recurso: String,             // "curriculo:ID" | "candidato:ID"
  recurso_id: ObjectId,
  
  resultado: String,
  motivo_falha: String,
  
  dados_antigos: Object,
  dados_novos: Object,
  
  ip_origem: String,
  user_agent: String,
  
  timestamp: ISODate,
  
  // NOVO campo
  tipo_auditoria: {
    type: String,
    enum: ["seguranca", "lgpd", "acesso", "mutacao"],
    description: "Categoria de auditoria"
  },
  
  payload_hash: String,
  
  // TTL: deletar após 90 dias (padrão)
  // Ou 7 anos para LGPD (ver campo retenido_ate)
  deletado_em: ISODate
}

// Índices
db.auditoria.createIndex({ usuario_id: 1, timestamp: -1 })
db.auditoria.createIndex({ timestamp: -1 })
db.auditoria.createIndex({ recurso_id: 1 })
db.auditoria.createIndex({ tipo_auditoria: 1 })

// TTL: 90 dias padrão
db.auditoria.createIndex(
  { timestamp: 1 },
  { expireAfterSeconds: 7776000 }  // 90 dias
)
```

---

## 7. Coleção: `configuracoes_sistema` (OPCIONAL NOVO)

Para armazenar metadados de versão de termos e políticas:

```javascript
db.configuracoes_sistema = {
  _id: "global",
  
  // Versão de termos
  politica_privacidade: {
    versao: "2.0",
    data_atualizacao: ISODate,
    url: "https://...",
    hash: "abc123..."
  },
  
  termos_servico: {
    versao: "2.0",
    data_atualizacao: ISODate,
    url: "https://...",
    hash: "def456..."
  },
  
  // Configuração LGPD
  periodo_retencao_dias: 2555,      // 7 anos
  periodo_delecao_dias: 30,          // 30 dias após solicitação
  dpo_email: "dpo@company.com",
  
  // Versão do sistema
  versao_api: "2.0.0",
  versao_db_schema: "2.0.0",
  
  ultima_atualizacao: ISODate
}
```

---

## 8. Índices de Performance

### 8.1 Resumo de Todos os Índices

```javascript
// USUARIOS
db.usuarios.createIndex({ email: 1 }, { unique: true })
db.usuarios.createIndex({ tipo: 1 })
db.usuarios.createIndex({ empresa_id: 1 })
db.usuarios.createIndex({ eh_candidato: 1 })
db.usuarios.createIndex({ ativo: 1 })
db.usuarios.createIndex({ marcado_para_delecao: 1 })
db.usuarios.createIndex({ criado_em: -1 })

// CANDIDATOS
db.candidatos.createIndex({ email: 1 }, { unique: true })
db.candidatos.createIndex({ usuario_id: 1 })
db.candidatos.createIndex({ estado: 1 })
db.candidatos.createIndex({ categoria: 1 })
db.candidatos.createIndex({ empresas_acesso: 1 })
db.candidatos.createIndex({ criado_em: -1 })
db.candidatos.createIndex({ "consentimento_dados.aceito": 1 })
db.candidatos.createIndex({ marcado_para_delecao: 1 })
db.candidatos.createIndex({ estado: 1, categoria: 1 })

// CURRICULOS
db.curriculos.createIndex({ usuario_id: 1, versao: -1 })
db.curriculos.createIndex({ usuario_id: 1, ativo: 1 })
db.curriculos.createIndex({ arquivo_hash: 1 }, { unique: true })
db.curriculos.createIndex({ candidato_id: 1 })
db.curriculos.createIndex({ criado_em: -1 })

// CURRICULOS_ACESSO
db.curriculos_acesso.createIndex({ usuario_candidato_id: 1, timestamp: -1 })
db.curriculos_acesso.createIndex({ usuario_acesso_id: 1, timestamp: -1 })
db.curriculos_acesso.createIndex({ curriculo_id: 1 })
db.curriculos_acesso.createIndex({ timestamp: -1 })

// AUDITORIA
db.auditoria.createIndex({ usuario_id: 1, timestamp: -1 })
db.auditoria.createIndex({ timestamp: -1 })
db.auditoria.createIndex({ recurso_id: 1 })
```

### 8.2 Análise de Performance

| Query | Índice Usado | Tempo Estimado |
|-------|-------------|----------------|
| `GET /api/candidatos?estado=SP&categoria=ativo` | { estado, categoria } | < 100ms |
| `GET /api/candidatos/{id}` | { _id } (padrão) | < 10ms |
| `GET /api/curriculos/historico` | { usuario_id, versao } | < 50ms |
| `GET /api/auditoria?usuario_id=X` | { usuario_id, timestamp } | < 100ms |

---

## 9. Script de Migração

### 9.1 Migração em Produção (Zero Downtime)

```python
#!/usr/bin/env python3
"""
Script de migração do Neo RH System para suportar Neo Currículos
Executa sem downtime usando rolling migration
"""

from pymongo import MongoClient, errors
from pymongo.operations import InsertOne, UpdateOne
from datetime import datetime, timedelta
import logging
import os

# Configuração
MONGO_URI = os.getenv("MONGODB_URI")
DB_NAME = "neo_rh_prod"
BATCH_SIZE = 1000

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class Neo_CurriculosMigration:
    def __init__(self):
        self.client = MongoClient(MONGO_URI)
        self.db = self.client[DB_NAME]
    
    def step_1_criar_indices_novos(self):
        """Passo 1: Criar índices novos (não bloqueia writes)"""
        logger.info("Passo 1: Criando índices novos...")
        
        # Índices em usuarios
        self.db.usuarios.create_index(
            [("eh_candidato", 1)],
            background=True
        )
        self.db.usuarios.create_index(
            [("marcado_para_delecao", 1)],
            background=True
        )
        
        logger.info("✓ Índices em 'usuarios' criados")
    
    def step_2_criar_colecoes_novas(self):
        """Passo 2: Criar novas coleções"""
        logger.info("Passo 2: Criando coleções novas...")
        
        # db.curriculos
        if "curriculos" not in self.db.list_collection_names():
            self.db.create_collection("curriculos")
            logger.info("✓ Coleção 'curriculos' criada")
        
        # Índices em curriculos
        self.db.curriculos.create_index(
            [("usuario_id", 1), ("versao", -1)],
            background=True
        )
        self.db.curriculos.create_index(
            [("arquivo_hash", 1)],
            background=True,
            unique=True
        )
        
        # db.curriculos_acesso
        if "curriculos_acesso" not in self.db.list_collection_names():
            self.db.create_collection("curriculos_acesso")
            logger.info("✓ Coleção 'curriculos_acesso' criada")
        
        # Índices em curriculos_acesso
        self.db.curriculos_acesso.create_index(
            [("usuario_candidato_id", 1), ("timestamp", -1)],
            background=True
        )
        self.db.curriculos_acesso.create_index(
            [("retenido_ate", 1)],
            background=True,
            expireAfterSeconds=0
        )
    
    def step_3_adicionar_campos_usuarios(self):
        """Passo 3: Adicionar campos novos em 'usuarios'"""
        logger.info("Passo 3: Adicionando campos em 'usuarios'...")
        
        # Adicionar eh_candidato=false a todos os existentes
        self.db.usuarios.update_many(
            {"eh_candidato": {"$exists": False}},
            {"$set": {"eh_candidato": False}},
            upsert=False
        )
        
        # Adicionar marcado_para_delecao=false a todos
        self.db.usuarios.update_many(
            {"marcado_para_delecao": {"$exists": False}},
            {"$set": {"marcado_para_delecao": False}},
            upsert=False
        )
        
        # Adicionar permissoes se não existem
        self.db.usuarios.update_many(
            {"permissoes": {"$exists": False}},
            {
                "$set": {
                    "permissoes": self._get_default_permissions_by_type()
                }
            },
            upsert=False
        )
        
        logger.info("✓ Campos adicionados a 'usuarios'")
    
    def step_4_adicionar_campos_candidatos(self):
        """Passo 4: Adicionar campos novos em 'candidatos'"""
        logger.info("Passo 4: Adicionando campos em 'candidatos'...")
        
        # Processar em batches
        candidatos = self.db.candidatos.find(
            {"usuario_id": {"$exists": False}}
        ).batch_size(BATCH_SIZE)
        
        operations = []
        for idx, candidato in enumerate(candidatos):
            # Inicializar campos novos
            update_op = UpdateOne(
                {"_id": candidato["_id"]},
                {
                    "$set": {
                        "usuario_id": None,
                        "consentimento_dados": {},
                        "permissoes": ["receber_contato"],
                        "curriculo_ativo": None,
                        "historico_curriculos": [],
                        "marcado_para_delecao": False
                    }
                }
            )
            operations.append(update_op)
            
            # Executar em lotes
            if len(operations) >= 100:
                self.db.candidatos.bulk_write(operations, ordered=False)
                operations = []
                logger.info(f"  Processados {idx} candidatos")
        
        # Executar operações restantes
        if operations:
            self.db.candidatos.bulk_write(operations, ordered=False)
        
        logger.info("✓ Campos adicionados a 'candidatos'")
    
    def step_5_criar_indices_candidatos(self):
        """Passo 5: Criar índices compostos em 'candidatos'"""
        logger.info("Passo 5: Criando índices em 'candidatos'...")
        
        self.db.candidatos.create_index(
            [("usuario_id", 1)],
            background=True
        )
        self.db.candidatos.create_index(
            [("consentimento_dados.aceito", 1)],
            background=True
        )
        self.db.candidatos.create_index(
            [("marcado_para_delecao", 1)],
            background=True
        )
        self.db.candidatos.create_index(
            [("estado", 1), ("categoria", 1)],
            background=True
        )
        
        logger.info("✓ Índices criados em 'candidatos'")
    
    def step_6_validacao(self):
        """Passo 6: Validar integridade dos dados"""
        logger.info("Passo 6: Validando integridade...")
        
        # Verificar usuarios
        usuarios_sem_eh_candidato = self.db.usuarios.count_documents(
            {"eh_candidato": {"$exists": False}}
        )
        if usuarios_sem_eh_candidato > 0:
            logger.error(f"⚠ {usuarios_sem_eh_candidato} usuarios sem 'eh_candidato'")
        
        # Verificar candidatos
        candidatos_sem_consentimento = self.db.candidatos.count_documents(
            {"consentimento_dados": {"$exists": False}}
        )
        if candidatos_sem_consentimento > 0:
            logger.error(f"⚠ {candidatos_sem_consentimento} candidatos sem 'consentimento_dados'")
        
        logger.info("✓ Validação concluída")
    
    def execute(self):
        """Executar todas as etapas da migração"""
        try:
            logger.info("=" * 60)
            logger.info("INICIANDO MIGRAÇÃO NEO_CURRICULOS")
            logger.info("=" * 60)
            
            self.step_1_criar_indices_novos()
            self.step_2_criar_colecoes_novas()
            self.step_3_adicionar_campos_usuarios()
            self.step_4_adicionar_campos_candidatos()
            self.step_5_criar_indices_candidatos()
            self.step_6_validacao()
            
            logger.info("=" * 60)
            logger.info("✓ MIGRAÇÃO CONCLUÍDA COM SUCESSO")
            logger.info("=" * 60)
            
        except Exception as e:
            logger.error(f"✗ ERRO NA MIGRAÇÃO: {e}")
            raise
        finally:
            self.client.close()
    
    def _get_default_permissions_by_type(self):
        """Retornar permissões padrão por tipo"""
        # Implementar mapa de tipos -> permissões
        return []

# Executar
if __name__ == "__main__":
    migration = Neo_CurriculosMigration()
    migration.execute()
```

### 9.2 Script de Rollback

```python
#!/usr/bin/env python3
"""
Rollback da migração (caso necessário)
Remove campos e coleções novos
"""

from pymongo import MongoClient
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

client = MongoClient(os.getenv("MONGODB_URI"))
db = client["neo_rh_prod"]

logger.info("EXECUTANDO ROLLBACK...")

# Remover campos de usuarios
db.usuarios.update_many(
    {},
    {
        "$unset": {
            "eh_candidato": "",
            "marcado_para_delecao": "",
            "data_delecao_solicitada": ""
        }
    }
)

# Remover campos de candidatos
db.candidatos.update_many(
    {},
    {
        "$unset": {
            "usuario_id": "",
            "consentimento_dados": "",
            "permissoes": "",
            "curriculo_ativo": "",
            "historico_curriculos": "",
            "marcado_para_delecao": ""
        }
    }
)

# Deletar coleções novas
db.drop_collection("curriculos")
db.drop_collection("curriculos_acesso")

logger.info("✓ ROLLBACK CONCLUÍDO")
```

---

## 10. Estratégia de Backup & Retenção

### 10.1 Backup

```yaml
# Configuração MongoDB Atlas (recomendada)
backup:
  tipo: "snapshot"
  frequencia: "diária"
  horario: "02:00 UTC"  # Off-peak
  retencao:
    snapshots_diarios: 7      # 7 dias
    snapshots_semanais: 4     # 4 semanas
    snapshots_mensais: 12     # 12 meses
  criptografia: "AES-256"
  versao_db: "6.0+"
  
# Self-hosted (MongoDB community)
backup_script:
  tipo: "mongodump"
  frequencia: "diária"
  comando: |
    mongodump --uri="mongodb://..." \
      --out=/backups/neo-rh-$(date +%Y%m%d)
  compressao: "gzip"
  armazenamento: "S3"
  
# Teste de restore
restore_test:
  frequencia: "semanal"
  ambiente: "staging"
  verificacao: "restore + validação de integridade"
```

### 10.2 Retenção de Dados (LGPD)

| Tipo de Dado | Retenção | TTL Index |
|--------------|----------|-----------|
| Auditoria (geral) | 90 dias | ✓ 7,776,000s |
| Auditoria LGPD | 7 anos | ✓ 220,320,000s |
| Currículos acesso | 7 anos | ✓ 220,320,000s |
| Candidato (ativo) | Indefinido | ✗ |
| Candidato (deletado) | 30 dias | Soft delete |
| Usuário (ativo) | Indefinido | ✗ |
| Usuário (desativado) | 1 ano | ✓ (opcional) |

### 10.3 Job de Limpeza Automática

```python
# celery_tasks.py
from celery import shared_task
from datetime import datetime, timedelta
from pymongo import MongoClient
import logging

logger = logging.getLogger(__name__)

@shared_task
def limpar_dados_marcados_delecao():
    """
    Job que executa diariamente (00:00 UTC)
    Deleta dados após 30 dias de serem marcados para deleção
    """
    client = MongoClient(os.getenv("MONGODB_URI"))
    db = client["neo_rh_prod"]
    
    data_limite = datetime.utcnow() - timedelta(days=30)
    
    # Candidatos
    resultado_candidatos = db.candidatos.update_many(
        {
            "marcado_para_delecao": True,
            "data_delecao_solicitada": {"$lt": data_limite}
        },
        {
            "$set": {
                "nome": "ANONIMIZADO",
                "email": "deleted@anonimizado.local",
                "telefone": None,
                "endereco": None,
                "cpf": None,
                "curriculo_ativo": None,
                "historico_curriculos": [],
                "deletado_em": datetime.utcnow()
            }
        }
    )
    
    logger.info(f"Anonimizados {resultado_candidatos.modified_count} candidatos")
    
    # Usuários
    resultado_usuarios = db.usuarios.update_many(
        {
            "marcado_para_delecao": True,
            "data_delecao_solicitada": {"$lt": data_limite},
            "tipo": "candidato"  # Apenas candidatos
        },
        {
            "$set": {
                "email": "deleted@anonimizado.local",
                "ativo": False,
                "deletado_em": datetime.utcnow()
            }
        }
    )
    
    logger.info(f"Anonimizados {resultado_usuarios.modified_count} usuários")
    
    client.close()
    
    return {
        "candidatos_anonimizados": resultado_candidatos.modified_count,
        "usuarios_anonimizados": resultado_usuarios.modified_count
    }

# Agendamento (settings do Celery)
app.conf.beat_schedule = {
    'limpar-dados-diario': {
        'task': 'celery_tasks.limpar_dados_marcados_delecao',
        'schedule': crontab(hour=0, minute=0),  # 00:00 UTC
    },
}
```

---

## 11. Checklist de Deployment

- [ ] Backup completo feito antes da migração
- [ ] Teste de migração em staging
- [ ] Script de rollback testado
- [ ] Índices criados (background=True)
- [ ] Validação de dados pós-migração
- [ ] Monitoramento de performance durante migração
- [ ] Notificação a usuários sobre novos recursos
- [ ] Documentação atualizada
- [ ] TTL indexes configurados
- [ ] Job de limpeza automática agendado

---

## 12. Dimensionamento de Storage

### 12.1 Estimativa de Crescimento

```
Base (mês 0):
├─ usuarios: 5,000 docs × 2KB = 10MB
├─ candidatos: 50,000 docs × 3KB = 150MB
├─ curriculos: 20,000 docs × 1KB = 20MB
└─ curriculos_acesso: 100,000 docs × 0.5KB = 50MB
Total DB: ~230MB

Projeção (12 meses):
├─ usuarios: 20,000 docs × 2KB = 40MB
├─ candidatos: 200,000 docs × 3KB = 600MB
├─ curriculos: 100,000 docs × 1KB = 100MB (versões)
├─ curriculos_acesso: 500,000 docs × 0.5KB = 250MB
└─ auditoria: 1,000,000 docs × 0.8KB = 800MB
Total DB: ~1.8GB

Storage S3 (arquivos PDF):
├─ Média: 500KB por CV
├─ 100,000 CVs × 500KB = 50GB
└─ Com replicas + redundância: ~150GB
```

---

## 13. Conclusão

Esta especificação de schema suporta:

✓ **Novo tipo de usuário "candidato"** (Neo Currículos)  
✓ **Upload e versionamento de CVs** (db.curriculos)  
✓ **Auditoria LGPD completa** (db.curriculos_acesso)  
✓ **Consentimento granular** (candidatos.consentimento_dados)  
✓ **Soft delete + deleção programada** (direito ao esquecimento)  
✓ **Performance otimizada** (índices estratégicos)  
✓ **Retenção legal** (TTL indexes por tipo de dado)  

---

**Versão:** 1.0  
**Data:** 2025-09-07  
**Autor:** Backend Architect Sênior  
**Status:** ✓ Pronto para implementação Phase 2
