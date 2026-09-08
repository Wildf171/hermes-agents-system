"""
===============================================================================
06_MODELS_MONGODB.py - Modelos PyMongo com Índices e Validação
===============================================================================

Definiçao de estruturas MongoDB para Neo Currículos + Neo RH System
- UsuarioModel (candidato, RH, admin, empresa)
- CurriculoModel (versioning automático)
- CurriculoAcessoModel (auditoria LGPD 7 anos)
- Índices otimizados para queries
- TTL index setup para retenção automática

Data: 2026-09-07
Version: 1.0.0
"""

from datetime import datetime, timedelta
from typing import Optional, List, Any, Dict
from enum import Enum
from pydantic import BaseModel, Field, EmailStr, validator
from pymongo import ASCENDING, DESCENDING, TEXT, HASHED
from pymongo.errors import DuplicateKeyError


# ============================================================================
# ENUMS
# ============================================================================

class TipoUsuarioEnum(str, Enum):
    """Tipos de usuários no sistema"""
    CANDIDATO = "candidato"
    RH = "rh"
    RECRUITER = "recruiter"
    ADMIN = "admin"
    EMPRESA = "empresa"


class AcaoAuditoriaEnum(str, Enum):
    """Ações registradas em auditoria LGPD"""
    VISUALIZAR = "visualizar"
    DOWNLOAD = "download"
    COMPARTILHAR = "compartilhar"
    DELETAR = "deletar"
    ANONIMIZAR = "anonimizar"
    REGISTRAR_CONSENTIMENTO = "registrar_consentimento"


# ============================================================================
# SCHEMAS PYDANTIC - VALIDAÇÃO
# ============================================================================

class UsuarioCandidatoSchema(BaseModel):
    """Schema de validação para candidato"""
    email: EmailStr
    nome: str = Field(..., min_length=3, max_length=100)
    senha_hash: str = Field(..., min_length=60)  # bcrypt hash
    tipo: TipoUsuarioEnum = TipoUsuarioEnum.CANDIDATO
    eh_candidato: bool = True
    consentimento: bool = False
    consentimento_data: Optional[datetime] = None
    consentimento_versao: Optional[str] = None
    primeira_vez: bool = True
    criado_em: datetime = Field(default_factory=datetime.utcnow)
    atualizado_em: datetime = Field(default_factory=datetime.utcnow)
    ativo: bool = True
    marcacao_delecao: Optional[datetime] = None
    anonimizado: bool = False

    class Config:
        use_enum_values = True


class UsuarioRHSchema(BaseModel):
    """Schema de validação para usuário RH/Admin"""
    email: EmailStr
    nome: str = Field(..., min_length=3, max_length=100)
    senha_hash: str = Field(..., min_length=60)
    tipo: TipoUsuarioEnum = Field(...)  # rh, recruiter, admin, empresa
    eh_candidato: bool = False
    empresa_id: Optional[str] = None
    primeira_vez: bool = True
    criado_em: datetime = Field(default_factory=datetime.utcnow)
    atualizado_em: datetime = Field(default_factory=datetime.utcnow)
    ativo: bool = True
    permissoes: List[str] = Field(default_factory=list)

    class Config:
        use_enum_values = True


class CurriculoSchema(BaseModel):
    """Schema de validação para currículo"""
    usuario_id: str = Field(...)  # ObjectId como string
    versao: int = Field(default=1)
    arquivo_url: str  # S3/MinIO URL
    arquivo_hash: str = Field(..., min_length=64, max_length=64)  # SHA256
    arquivo_tamanho: int = Field(..., gt=0, le=10485760)  # max 10MB
    tipo_mime: str = "application/pdf"
    criado_em: datetime = Field(default_factory=datetime.utcnow)
    ativo: bool = True
    metadata: Dict[str, Any] = Field(default_factory=dict)

    class Config:
        use_enum_values = True


class CurriculoAcessoSchema(BaseModel):
    """Schema para auditoria LGPD de acesso a currículos"""
    usuario_id: str  # Dono do CV (ObjectId como string)
    curriculo_id: str  # ObjectId do CV (como string)
    acessado_por: str  # Quem acessou (ObjectId RH/Empresa como string)
    acao: AcaoAuditoriaEnum  # visualizar, download, compartilhar, etc
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    ip_address: str = Field(...)
    user_agent: str = Field(...)
    resultado: str = "sucesso"  # sucesso ou erro
    descricao_erro: Optional[str] = None
    ttl: datetime = Field(default_factory=lambda: datetime.utcnow() + timedelta(days=7*365))

    class Config:
        use_enum_values = True


# ============================================================================
# MODELS MONGODB
# ============================================================================

class UsuarioModel:
    """
    Collection: usuarios
    Índices: email (unique), tipo, ativo, marcacao_delecao
    """
    collection_name = "usuarios"

    # Fields
    FIELDS = {
        "_id": "ObjectId",  # MongoDB ObjectId
        "email": str,  # unique
        "nome": str,
        "tipo": str,  # enum: rh, recruiter, admin, empresa, candidato
        "eh_candidato": bool,
        "senha_hash": str,  # bcrypt hash
        "consentimento": bool,
        "consentimento_data": datetime,
        "consentimento_versao": str,
        "marcacao_delecao": datetime,  # nullable
        "anonimizado": bool,
        "empresa_id": str,  # nullable (para RH de empresa)
        "permissoes": list,  # lista de strings
        "criado_em": datetime,
        "atualizado_em": datetime,
        "ativo": bool,
    }

    @staticmethod
    def create_indexes(db):
        """Criar índices otimizados"""
        collection = db[UsuarioModel.collection_name]

        # Índice único em email
        collection.create_index("email", unique=True)

        # Índices de busca frequente
        collection.create_index([("tipo", ASCENDING), ("ativo", ASCENDING)])
        collection.create_index([("marcacao_delecao", ASCENDING)])
        collection.create_index([("criado_em", DESCENDING)])

        # TTL index para soft delete (30 dias)
        collection.create_index(
            "marcacao_delecao",
            expireAfterSeconds=2592000,  # 30 dias
            sparse=True
        )

    @staticmethod
    def insert(db, usuario: UsuarioCandidatoSchema | UsuarioRHSchema) -> str:
        """Inserir novo usuário. Retorna ObjectId como string"""
        collection = db[UsuarioModel.collection_name]
        try:
            result = collection.insert_one(usuario.dict())
            return str(result.inserted_id)
        except DuplicateKeyError:
            raise ValueError(f"Email já registrado: {usuario.email}")

    @staticmethod
    def find_by_email(db, email: str) -> Optional[dict]:
        """Buscar usuário por email"""
        collection = db[UsuarioModel.collection_name]
        return collection.find_one({"email": email})

    @staticmethod
    def find_by_id(db, usuario_id: str) -> Optional[dict]:
        """Buscar usuário por ID"""
        from bson import ObjectId
        collection = db[UsuarioModel.collection_name]
        return collection.find_one({"_id": ObjectId(usuario_id)})

    @staticmethod
    def update_consentimento(db, usuario_id: str, versao: str) -> bool:
        """Atualizar consentimento LGPD"""
        from bson import ObjectId
        collection = db[UsuarioModel.collection_name]
        result = collection.update_one(
            {"_id": ObjectId(usuario_id)},
            {"$set": {
                "consentimento": True,
                "consentimento_data": datetime.utcnow(),
                "consentimento_versao": versao,
                "atualizado_em": datetime.utcnow()
            }}
        )
        return result.modified_count > 0

    @staticmethod
    def soft_delete(db, usuario_id: str) -> bool:
        """Marcar usuário como deletado (soft delete)"""
        from bson import ObjectId
        collection = db[UsuarioModel.collection_name]
        result = collection.update_one(
            {"_id": ObjectId(usuario_id)},
            {"$set": {
                "marcacao_delecao": datetime.utcnow(),
                "ativo": False,
                "atualizado_em": datetime.utcnow()
            }}
        )
        return result.modified_count > 0

    @staticmethod
    def anonimizar(db, usuario_id: str) -> bool:
        """Anonimizar dados do usuário após 30 dias de deleção"""
        from bson import ObjectId
        import hashlib

        collection = db[UsuarioModel.collection_name]

        # Buscar usuário
        usuario = collection.find_one({"_id": ObjectId(usuario_id)})
        if not usuario:
            return False

        # Anonimizar: nome e email
        email_hash = hashlib.sha256(usuario["email"].encode()).hexdigest()[:16]

        result = collection.update_one(
            {"_id": ObjectId(usuario_id)},
            {"$set": {
                "nome": "ANONIMIZADO",
                "email": f"anonimizado_{email_hash}@anonimizado.invalid",
                "anonimizado": True,
                "atualizado_em": datetime.utcnow()
            }}
        )
        return result.modified_count > 0


class CurriculoModel:
    """
    Collection: curriculos
    Índices: usuario_id, versao, ativo, criado_em
    Versionamento automático
    """
    collection_name = "curriculos"

    FIELDS = {
        "_id": "ObjectId",
        "usuario_id": str,  # ObjectId como string
        "versao": int,
        "arquivo_url": str,  # S3/MinIO URL
        "arquivo_hash": str,  # SHA256 (64 chars)
        "arquivo_tamanho": int,
        "tipo_mime": str,
        "criado_em": datetime,
        "ativo": bool,
        "metadata": dict,
    }

    @staticmethod
    def create_indexes(db):
        """Criar índices otimizados"""
        collection = db[CurriculoModel.collection_name]

        # Índice composto: usuário + versão
        collection.create_index([
            ("usuario_id", ASCENDING),
            ("versao", DESCENDING)
        ])

        # Índices de busca
        collection.create_index([("usuario_id", ASCENDING), ("ativo", ASCENDING)])
        collection.create_index([("criado_em", DESCENDING)])
        collection.create_index([("arquivo_hash", ASCENDING)])

    @staticmethod
    def insert(db, curriculo: CurriculoSchema) -> str:
        """Inserir novo currículo com versionamento"""
        collection = db[CurriculoModel.collection_name]

        # Marcar versão anterior como inativa
        collection.update_many(
            {"usuario_id": curriculo.usuario_id},
            {"$set": {"ativo": False}}
        )

        # Inserir nova versão
        result = collection.insert_one(curriculo.dict())
        return str(result.inserted_id)

    @staticmethod
    def get_versoes_ativas(db, usuario_id: str) -> List[dict]:
        """Listar todas as versões de CV do usuário"""
        collection = db[CurriculoModel.collection_name]
        return list(collection.find(
            {"usuario_id": usuario_id},
            sort=[("versao", DESCENDING)]
        ))

    @staticmethod
    def get_versao_ativa(db, usuario_id: str) -> Optional[dict]:
        """Obter versão ativa atual do CV"""
        collection = db[CurriculoModel.collection_name]
        return collection.find_one(
            {"usuario_id": usuario_id, "ativo": True},
            sort=[("versao", DESCENDING)]
        )

    @staticmethod
    def deletar_por_usuario(db, usuario_id: str) -> int:
        """Deletar todos os CVs de um usuário"""
        collection = db[CurriculoModel.collection_name]
        result = collection.delete_many({"usuario_id": usuario_id})
        return result.deleted_count


class CurriculoAcessoModel:
    """
    Collection: curriculos_acesso
    Auditoria LGPD - Retenção de 7 anos
    TTL index automático
    """
    collection_name = "curriculos_acesso"

    FIELDS = {
        "_id": "ObjectId",
        "usuario_id": str,  # Dono do CV
        "curriculo_id": str,
        "acessado_por": str,  # RH/Empresa que acessou
        "acao": str,  # visualizar, download, compartilhar
        "timestamp": datetime,
        "ip_address": str,
        "user_agent": str,
        "resultado": str,  # sucesso ou erro
        "descricao_erro": str,
        "ttl": datetime,  # Auto-delete após 7 anos
    }

    @staticmethod
    def create_indexes(db):
        """Criar índices e TTL"""
        collection = db[CurriculoAcessoModel.collection_name]

        # TTL index (7 anos = 220752000 segundos)
        collection.create_index("ttl", expireAfterSeconds=220752000)

        # Índices de busca auditoria
        collection.create_index([
            ("usuario_id", ASCENDING),
            ("timestamp", DESCENDING)
        ])
        collection.create_index([
            ("acessado_por", ASCENDING),
            ("timestamp", DESCENDING)
        ])
        collection.create_index("curriculo_id")
        collection.create_index([("acao", ASCENDING), ("timestamp", DESCENDING)])

    @staticmethod
    def registrar_acesso(db, acesso: CurriculoAcessoSchema) -> str:
        """Registrar acesso/ação LGPD"""
        collection = db[CurriculoAcessoModel.collection_name]
        result = collection.insert_one(acesso.dict())
        return str(result.inserted_id)

    @staticmethod
    def relatorio_usuario(db, usuario_id: str, dias: int = 30) -> List[dict]:
        """Relatório de acessos ao CV de um usuário"""
        from datetime import timedelta
        collection = db[CurriculoAcessoModel.collection_name]

        data_inicio = datetime.utcnow() - timedelta(days=dias)

        return list(collection.find(
            {
                "usuario_id": usuario_id,
                "timestamp": {"$gte": data_inicio}
            },
            sort=[("timestamp", DESCENDING)]
        ))

    @staticmethod
    def relatorio_rh(db, rh_id: str, dias: int = 30) -> List[dict]:
        """Relatório de ações de um RH"""
        from datetime import timedelta
        collection = db[CurriculoAcessoModel.collection_name]

        data_inicio = datetime.utcnow() - timedelta(days=dias)

        return list(collection.find(
            {
                "acessado_por": rh_id,
                "timestamp": {"$gte": data_inicio}
            },
            sort=[("timestamp", DESCENDING)]
        ))

    @staticmethod
    def deletar_por_usuario(db, usuario_id: str) -> int:
        """Deletar registros de auditoria de um usuário"""
        collection = db[CurriculoAcessoModel.collection_name]
        result = collection.delete_many({"usuario_id": usuario_id})
        return result.deleted_count


# ============================================================================
# INICIALIZAÇÃO
# ============================================================================

def setup_database(db):
    """Inicializar database com todas as collections e índices"""
    print("[DB] Criando índices para usuarios...")
    UsuarioModel.create_indexes(db)

    print("[DB] Criando índices para curriculos...")
    CurriculoModel.create_indexes(db)

    print("[DB] Criando índices para curriculos_acesso (LGPD)...")
    CurriculoAcessoModel.create_indexes(db)

    print("[DB] Database inicializado com sucesso!")
