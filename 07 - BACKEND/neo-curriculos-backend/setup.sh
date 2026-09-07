#!/bin/bash

# ============================================================================
# setup.sh - Setup Local do Neo Currículos Backend
# ============================================================================
# Instalar dependências, configurar env, iniciar docker-compose
# Uso: chmod +x setup.sh && ./setup.sh

set -e

echo "========================================================================"
echo "Neo Currículos + Neo RH System - Setup Local"
echo "========================================================================"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# =========================================================================
# 1. VERIFICAR PRÉ-REQUISITOS
# =========================================================================

echo -e "\n${YELLOW}[1/6]${NC} Verificando pré-requisitos..."

# Verificar Python
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}[ERRO]${NC} Python 3 não encontrado"
    exit 1
fi
echo -e "${GREEN}✓${NC} Python 3 encontrado: $(python3 --version)"

# Verificar pip
if ! command -v pip3 &> /dev/null; then
    echo -e "${RED}[ERRO]${NC} pip3 não encontrado"
    exit 1
fi
echo -e "${GREEN}✓${NC} pip3 encontrado"

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}[ERRO]${NC} Docker não encontrado. Instale em https://docker.com"
    exit 1
fi
echo -e "${GREEN}✓${NC} Docker encontrado: $(docker --version)"

# Verificar docker-compose
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}[ERRO]${NC} docker-compose não encontrado"
    exit 1
fi
echo -e "${GREEN}✓${NC} docker-compose encontrado: $(docker-compose --version)"

# =========================================================================
# 2. CRIAR ARQUIVO .env
# =========================================================================

echo -e "\n${YELLOW}[2/6]${NC} Configurando .env..."

if [ ! -f .env ]; then
    echo -e "${YELLOW}→${NC} Criando .env a partir de .env.example"
    cp .env.example .env
    # Gerar JWT_SECRET_KEY aleatório
    SECRET=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")
    sed -i "s/JWT_SECRET_KEY=.*/JWT_SECRET_KEY=$SECRET/" .env
    echo -e "${GREEN}✓${NC} Arquivo .env criado com JWT_SECRET_KEY gerado"
else
    echo -e "${GREEN}✓${NC} Arquivo .env já existe"
fi

# =========================================================================
# 3. CRIAR DIRETÓRIOS NECESSÁRIOS
# =========================================================================

echo -e "\n${YELLOW}[3/6]${NC} Criando diretórios..."

mkdir -p uploads
mkdir -p logs
mkdir -p setup

echo -e "${GREEN}✓${NC} Diretórios criados"

# =========================================================================
# 4. INSTALAR DEPENDÊNCIAS PYTHON (OPCIONAL - para dev local)
# =========================================================================

echo -e "\n${YELLOW}[4/6]${NC} Instalando dependências Python (opcional)..."

if [ "$1" == "--local" ]; then
    echo -e "${YELLOW}→${NC} Instalando requirements.txt localmente..."
    python3 -m venv venv
    source venv/bin/activate || . venv/Scripts/activate
    pip install --upgrade pip
    pip install -r requirements.txt
    echo -e "${GREEN}✓${NC} Dependências instaladas localmente"
else
    echo -e "${YELLOW}→${NC} Pulando instalação local (usar --local para instalar)"
fi

# =========================================================================
# 5. INICIAR DOCKER COMPOSE
# =========================================================================

echo -e "\n${YELLOW}[5/6]${NC} Iniciando containers Docker..."

if [ "$1" != "--no-docker" ]; then
    echo -e "${YELLOW}→${NC} Iniciando MongoDB, MinIO, Flask e Redis..."
    docker-compose up -d

    # Aguardar containers ficarem prontos
    echo -e "${YELLOW}→${NC} Aguardando containers ficarem prontos..."
    sleep 10

    # Verificar status
    if docker ps | grep -q "neo_rh_mongodb"; then
        echo -e "${GREEN}✓${NC} MongoDB ativo"
    else
        echo -e "${RED}[ERRO]${NC} MongoDB não iniciou"
    fi

    if docker ps | grep -q "neo_rh_minio"; then
        echo -e "${GREEN}✓${NC} MinIO ativo"
    else
        echo -e "${RED}[ERRO]${NC} MinIO não iniciou"
    fi
else
    echo -e "${YELLOW}→${NC} Pulando docker-compose (usar --no-docker para pular)"
fi

# =========================================================================
# 6. RESUMO E PRÓXIMOS PASSOS
# =========================================================================

echo -e "\n${YELLOW}[6/6]${NC} Setup completo!"

echo ""
echo -e "${GREEN}======================================================================${NC}"
echo "Próximos passos:"
echo -e "${GREEN}======================================================================${NC}"

echo ""
echo "1. Iniciar a aplicação:"
if [ "$1" == "--local" ]; then
    echo "   source venv/bin/activate  # Ativar venv (Linux/Mac)"
    echo "   . venv\\Scripts\\activate   # Ativar venv (Windows)"
fi
echo "   python app.py"
echo ""

echo "2. Acessar endpoints:"
echo "   API:                http://localhost:5000"
echo "   Health Check:       http://localhost:5000/health"
echo "   Docs:               http://localhost:5000/api/docs"
echo ""

echo "3. MongoDB:"
echo "   Connection String:  mongodb://admin:password@localhost:27017/neo_rh"
echo "   Admin:              http://localhost:27017"
echo ""

echo "4. MinIO (S3):"
echo "   Console:            http://localhost:9001"
echo "   Access Key:         minioadmin"
echo "   Secret Key:         minioadmin"
echo "   Endpoint:           http://localhost:9000"
echo ""

echo "5. Executar testes:"
echo "   pytest tests/ -v --cov=."
echo ""

echo "6. Ver logs:"
echo "   docker-compose logs -f flask_app"
echo ""

echo -e "${GREEN}======================================================================${NC}"
echo "Setup concluído com sucesso!"
echo -e "${GREEN}======================================================================${NC}"
