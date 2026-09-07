/**
 * =========================================================================
 * init-mongodb.js - Inicialização do MongoDB
 * =========================================================================
 *
 * Script executado pelo docker-entrypoint-initdb.d do MongoDB
 * Cria database, collections e índices
 *
 * Executar: automaticamente ao iniciar container
 */

// Conectar ao database
db = db.getSiblingDB('neo_rh');

// =========================================================================
// CRIAR COLLECTIONS
// =========================================================================

print('>>> Criando collections...');

// Usuarios
if (!db.getCollectionNames().includes('usuarios')) {
    db.createCollection('usuarios');
    print('✓ Collection "usuarios" criada');
}

// Curriculos
if (!db.getCollectionNames().includes('curriculos')) {
    db.createCollection('curriculos');
    print('✓ Collection "curriculos" criada');
}

// Curriculos Acesso (Auditoria LGPD)
if (!db.getCollectionNames().includes('curriculos_acesso')) {
    db.createCollection('curriculos_acesso');
    print('✓ Collection "curriculos_acesso" criada');
}

// =========================================================================
// CRIAR ÍNDICES - USUARIOS
// =========================================================================

print('>>> Criando índices para usuarios...');

db.usuarios.createIndex({email: 1}, {unique: true});
print('✓ Índice único em "email"');

db.usuarios.createIndex({tipo: 1, ativo: 1});
print('✓ Índice em "tipo, ativo"');

db.usuarios.createIndex({marcacao_delecao: 1});
print('✓ Índice em "marcacao_delecao"');

db.usuarios.createIndex({criado_em: -1});
print('✓ Índice em "criado_em"');

// TTL index para soft delete (30 dias = 2592000 segundos)
db.usuarios.createIndex(
    {marcacao_delecao: 1},
    {expireAfterSeconds: 2592000, sparse: true, name: "ttl_soft_delete"}
);
print('✓ TTL index para soft delete (30 dias)');

// =========================================================================
// CRIAR ÍNDICES - CURRICULOS
// =========================================================================

print('>>> Criando índices para curriculos...');

db.curriculos.createIndex({usuario_id: 1, versao: -1});
print('✓ Índice em "usuario_id, versao"');

db.curriculos.createIndex({usuario_id: 1, ativo: 1});
print('✓ Índice em "usuario_id, ativo"');

db.curriculos.createIndex({criado_em: -1});
print('✓ Índice em "criado_em"');

db.curriculos.createIndex({arquivo_hash: 1});
print('✓ Índice em "arquivo_hash"');

// =========================================================================
// CRIAR ÍNDICES - CURRICULOS_ACESSO (LGPD)
// =========================================================================

print('>>> Criando índices para curriculos_acesso (LGPD)...');

// TTL index para retenção LGPD 7 anos = 220752000 segundos
db.curriculos_acesso.createIndex(
    {ttl: 1},
    {expireAfterSeconds: 220752000, name: "ttl_lgpd_7_anos"}
);
print('✓ TTL index para LGPD (7 anos)');

db.curriculos_acesso.createIndex({usuario_id: 1, timestamp: -1});
print('✓ Índice em "usuario_id, timestamp"');

db.curriculos_acesso.createIndex({acessado_por: 1, timestamp: -1});
print('✓ Índice em "acessado_por, timestamp"');

db.curriculos_acesso.createIndex({curriculo_id: 1});
print('✓ Índice em "curriculo_id"');

db.curriculos_acesso.createIndex({acao: 1, timestamp: -1});
print('✓ Índice em "acao, timestamp"');

// =========================================================================
// INSERIR DADOS DE TESTE (OPCIONAL)
// =========================================================================

print('>>> Inserindo dados de teste...');

// Usuário teste - Candidato
if (db.usuarios.countDocuments({email: 'candidato@example.com'}) === 0) {
    db.usuarios.insertOne({
        email: 'candidato@example.com',
        nome: 'Candidato Teste',
        tipo: 'candidato',
        eh_candidato: true,
        senha_hash: '$2b$12$abcdefghijklmnopqrstuvwxyz1234567890abcdef',
        consentimento: false,
        ativo: true,
        criado_em: new Date(),
        atualizado_em: new Date()
    });
    print('✓ Usuário candidato criado');
}

// Usuário teste - RH
if (db.usuarios.countDocuments({email: 'rh@example.com'}) === 0) {
    db.usuarios.insertOne({
        email: 'rh@example.com',
        nome: 'RH Teste',
        tipo: 'rh',
        eh_candidato: false,
        senha_hash: '$2b$12$abcdefghijklmnopqrstuvwxyz1234567890abcdef',
        ativo: true,
        permissoes: ['buscar_cv', 'compartilhar_cv'],
        criado_em: new Date(),
        atualizado_em: new Date()
    });
    print('✓ Usuário RH criado');
}

// Usuário teste - Admin
if (db.usuarios.countDocuments({email: 'admin@example.com'}) === 0) {
    db.usuarios.insertOne({
        email: 'admin@example.com',
        nome: 'Admin Teste',
        tipo: 'admin',
        eh_candidato: false,
        senha_hash: '$2b$12$abcdefghijklmnopqrstuvwxyz1234567890abcdef',
        ativo: true,
        permissoes: ['*'],
        criado_em: new Date(),
        atualizado_em: new Date()
    });
    print('✓ Usuário admin criado');
}

// =========================================================================
// SUMÁRIO
// =========================================================================

print('==========================================================================');
print('MongoDB inicializado com sucesso!');
print('==========================================================================');
print('Database: neo_rh');
print('Collections: usuarios, curriculos, curriculos_acesso');
print('Índices: 15+');
print('Dados de teste: 3 usuários (candidato, rh, admin)');
print('==========================================================================');
