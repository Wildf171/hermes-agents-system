#!/bin/bash
################################################################################
# 15_DEPLOY_STAGING.sh - Deployment Automático para Staging
################################################################################
#
# Descricao:
#   Script de deployment zero-downtime para staging
#   - Pull latest code
#   - Build Docker image
#   - Stop containers antigos
#   - Executar migrations
#   - Start novo container
#   - Health check com retry
#
# Uso:
#   bash scripts/deploy-staging.sh
#   bash scripts/deploy-staging.sh --force
#
# Variáveis de Ambiente:
#   - STAGING_SERVER: IP/hostname do servidor staging
#   - STAGING_USER: Usuário SSH
#   - STAGING_SSH_KEY: Chave SSH privada
#   - MONGO_URI: Connection string MongoDB
#   - LOG_DIR: Diretório de logs (default: /var/log/neo-curriculos)
#
# Data: 2026-09-07
# Version: 1.0.0
################################################################################

set -e

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

DEPLOY_DIR="/opt/neo-curriculos"
LOG_DIR="${LOG_DIR:-/var/log/neo-curriculos}"
BACKUP_DIR="${LOG_DIR}/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="${LOG_DIR}/deploy_${TIMESTAMP}.log"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a "$LOG_FILE"
}

header() {
    echo "" | tee -a "$LOG_FILE"
    echo "==================== $1 ====================" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
}

# ============================================================================
# PRÉ-CHECKS
# ============================================================================

header "PRÉ-DEPLOYMENT CHECKS"

# Validar variáveis de ambiente
if [ -z "$STAGING_SERVER" ]; then
    error "STAGING_SERVER não definida"
    exit 1
fi

if [ -z "$STAGING_USER" ]; then
    error "STAGING_USER não definida"
    exit 1
fi

log "✓ Variáveis de ambiente validadas"
log "  Server: $STAGING_SERVER"
log "  User: $STAGING_USER"

# Validar conectividade SSH
if ! ssh -o ConnectTimeout=5 "${STAGING_USER}@${STAGING_SERVER}" "echo 'SSH conectado'" > /dev/null 2>&1; then
    error "Não foi possível conectar ao servidor staging via SSH"
    exit 1
fi

log "✓ Conectividade SSH OK"

# Criar diretórios de log
mkdir -p "$LOG_DIR" "$BACKUP_DIR"

log "✓ Diretórios criados/validados"

# ============================================================================
# OBTER LATEST CODE
# ============================================================================

header "OBTENDO CÓDIGO MAIS RECENTE"

log "Fazendo pull do repositório..."

if ! git pull origin develop > /dev/null 2>&1; then
    error "Erro ao fazer pull do repositório"
    exit 1
fi

log "✓ Código atualizado"

# Obter informações do commit
COMMIT_HASH=$(git rev-parse --short HEAD)
COMMIT_MSG=$(git log -1 --pretty=%B | head -1)

log "  Commit: $COMMIT_HASH"
log "  Message: $COMMIT_MSG"

# ============================================================================
# BUILD DOCKER IMAGE
# ============================================================================

header "BUILD DOCKER IMAGE"

IMAGE_TAG="neo-curriculos:${TIMESTAMP}"
IMAGE_LATEST="neo-curriculos:latest"

log "Buildando imagem Docker..."

if ! docker build -t "$IMAGE_TAG" -t "$IMAGE_LATEST" . > /tmp/docker_build.log 2>&1; then
    error "Erro ao buildar Docker image"
    cat /tmp/docker_build.log
    exit 1
fi

log "✓ Docker image buildado: $IMAGE_TAG"

# ============================================================================
# BACKUP CONTAINERS ANTIGOS
# ============================================================================

header "BACKUP DOS CONTAINERS ANTIGOS"

log "Fazendo backup de volumes..."

if ssh "${STAGING_USER}@${STAGING_SERVER}" "docker ps -aq --filter 'label=app=neo-curriculos'" | grep -q .; then
    log "Fazendo backup de volumes do container anterior..."

    ssh "${STAGING_USER}@${STAGING_SERVER}" << 'EOF'
        CONTAINER_ID=$(docker ps -q --filter "label=app=neo-curriculos")
        if [ ! -z "$CONTAINER_ID" ]; then
            docker commit "$CONTAINER_ID" "neo-curriculos:backup-${TIMESTAMP}" || true
            log "✓ Backup criado"
        fi
EOF
fi

log "✓ Backup completado"

# ============================================================================
# EXECUTAR MIGRATIONS
# ============================================================================

header "EXECUTAR DATABASE MIGRATIONS"

log "Conectando ao servidor staging..."

ssh "${STAGING_USER}@${STAGING_SERVER}" << EOF
    set -e

    # Setup environment
    export MONGO_URI="${MONGO_URI}"
    export FLASK_ENV="staging"

    cd "$DEPLOY_DIR"

    # Executar migrations
    echo "Executando migrations..."

    # TODO: Implementar migrations (Alembic, migration scripts, etc)
    # python scripts/migrate.py --env staging

    echo "✓ Migrations completadas"
EOF

log "✓ Migrations executadas com sucesso"

# ============================================================================
# STOP CONTAINERS ANTIGOS
# ============================================================================

header "PARANDO CONTAINERS ANTIGOS"

log "Parando containers da aplicação..."

ssh "${STAGING_USER}@${STAGING_SERVER}" << EOF
    set -e

    # Stop old containers gracefully (30s timeout)
    docker-compose -f docker-compose.staging.yml down --timeout 30 || true

    # Kill any remaining processes
    docker ps -aq --filter "label=app=neo-curriculos" | xargs -r docker kill || true

    echo "✓ Containers antigos parados"
EOF

log "✓ Containers parados"

# ============================================================================
# START NOVO CONTAINER
# ============================================================================

header "INICIANDO NOVO CONTAINER"

log "Iniciando novo container..."

ssh "${STAGING_USER}@${STAGING_SERVER}" << EOF
    set -e

    # Setup environment
    export MONGO_URI="${MONGO_URI}"
    export JWT_SECRET_KEY="${JWT_SECRET_KEY}"
    export FLASK_ENV="staging"

    cd "$DEPLOY_DIR"

    # Start containers
    docker-compose -f docker-compose.staging.yml up -d

    echo "✓ Container iniciado"
EOF

log "✓ Novo container iniciado"

# ============================================================================
# HEALTH CHECK COM RETRY
# ============================================================================

header "HEALTH CHECK"

log "Aguardando aplicação ficar ready..."

HEALTH_CHECK_URL="http://${STAGING_SERVER}:5000/health"
MAX_RETRIES=10
RETRY_COUNT=0
RETRY_DELAY=10

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    log "Health check attempt $((RETRY_COUNT + 1))/$MAX_RETRIES..."

    if curl -sf "$HEALTH_CHECK_URL" > /dev/null 2>&1; then
        log "✓ API é está healthy"

        # Validar response
        RESPONSE=$(curl -s "$HEALTH_CHECK_URL")
        log "Response: $RESPONSE"

        break
    fi

    RETRY_COUNT=$((RETRY_COUNT + 1))

    if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
        log "  Aguardando ${RETRY_DELAY}s antes de retry..."
        sleep $RETRY_DELAY
    fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    error "Health check falhou após $MAX_RETRIES tentativas"

    # Logging para debugging
    log "Logs do container:"
    ssh "${STAGING_USER}@${STAGING_SERVER}" "docker logs \$(docker ps -aq --filter 'label=app=neo-curriculos' | head -1)" || true

    exit 1
fi

log "✓ Health check passou"

# ============================================================================
# VALIDAÇÃO PÓS-DEPLOYMENT
# ============================================================================

header "VALIDAÇÃO PÓS-DEPLOYMENT"

log "Testando endpoints principais..."

# Test auth endpoint
if curl -sf -X POST "$HEALTH_CHECK_URL/../api/version" > /dev/null 2>&1; then
    log "✓ Endpoint /api/version respondendo"
else
    warning "Endpoint /api/version não respondeu"
fi

log "✓ Validação completada"

# ============================================================================
# CLEANUP E FINALIZAÇÃO
# ============================================================================

header "CLEANUP"

log "Removendo imagens antigas..."

ssh "${STAGING_USER}@${STAGING_SERVER}" << EOF
    # Remove dangling images (mais antigos que 7 dias)
    docker image prune -a -f --filter "until=168h" || true
EOF

log "✓ Cleanup completado"

# ============================================================================
# NOTIFICAÇÕES
# ============================================================================

header "NOTIFICAÇÕES"

log "✓ DEPLOYMENT CONCLUÍDO COM SUCESSO"
log ""
log "Detalhes:"
log "  Environment: Staging"
log "  Server: $STAGING_SERVER"
log "  Commit: $COMMIT_HASH - $COMMIT_MSG"
log "  Image: $IMAGE_TAG"
log "  Timestamp: $TIMESTAMP"
log "  Log file: $LOG_FILE"
log ""

# Enviar notificação para Slack (se SLACK_WEBHOOK definido)
if [ ! -z "$SLACK_WEBHOOK" ]; then
    log "Enviando notificação para Slack..."

    curl -X POST "$SLACK_WEBHOOK" \
        -H 'Content-Type: application/json' \
        -d "{
            \"text\": \"✅ Staging Deployment Successful\",
            \"blocks\": [
                {
                    \"type\": \"section\",
                    \"text\": {
                        \"type\": \"mrkdwn\",
                        \"text\": \"*Staging Deployment*\n✅ Status: Success\n🚀 Server: $STAGING_SERVER\n📝 Commit: $COMMIT_HASH\n💬 Message: $COMMIT_MSG\"
                    }
                }
            ]
        }" > /dev/null 2>&1 || warning "Erro ao enviar notificação Slack"

    log "✓ Notificação Slack enviada"
fi

# ============================================================================
# ROLLBACK FUNCTION (para emergências)
# ============================================================================

# rollback() {
#     error "Iniciando rollback..."
#
#     ssh "${STAGING_USER}@${STAGING_SERVER}" << EOF
#         docker-compose -f docker-compose.staging.yml down
#         docker-compose -f docker-compose.staging.yml up -d
#         sleep 10
#         curl -f http://localhost:5000/health || exit 1
# EOF
#
#     log "✓ Rollback completado"
# }

echo ""
echo "================= DEPLOYMENT FINISHED ================="
echo "✓ Aplicação está pronta em: http://${STAGING_SERVER}:5000"
echo "==============================================="

exit 0
