#!/bin/bash

set -e

echo "=========================================="
echo "Hermes Agents Setup - Neo Desenvolver"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se Hermes está instalado
if ! command -v hermes &> /dev/null; then
    echo "❌ Hermes não encontrado. Instale primeiro com:"
    echo "   curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash"
    exit 1
fi

echo -e "${BLUE}✓ Hermes detectado${NC}"
echo ""

# Step 1: Verificar hermes doctor
echo -e "${YELLOW}[1/8] Validando ambiente Hermes...${NC}"
hermes doctor > /dev/null 2>&1 || {
    echo "❌ hermes doctor falhou. Configure seu model provider:"
    echo "   hermes model add openrouter  # ou outro provider"
    echo "   hermes model set <model-name>"
    exit 1
}
echo -e "${GREEN}✓ Ambiente validado${NC}"
echo ""

# Step 2: Criar profiles
echo -e "${YELLOW}[2/8] Criando 3 profiles especializados...${NC}"

hermes profile create backend 2>/dev/null || echo "   backend já existe"
hermes profile create datascience 2>/dev/null || echo "   datascience já existe"
hermes profile create frontend 2>/dev/null || echo "   frontend já existe"

echo -e "${GREEN}✓ Profiles criados${NC}"
echo ""

# Step 3: Criar SOUL.md para Backend Agent
echo -e "${YELLOW}[3/8] Configurando Backend Agent...${NC}"

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
BACKEND_DIR="$HERMES_HOME/profiles/backend"

mkdir -p "$BACKEND_DIR"

cat > "$BACKEND_DIR/SOUL.md" << 'EOF'
# Backend Developer Agent

## Expertise
- **Java**: Spring Boot 3.x, microservices, REST APIs, database design, async/reactive
- **Python**: FastAPI, async/await, OOP patterns, data pipelines
- **Infrastructure**: CI/CD, Docker, Kubernetes, deployment strategies
- **Databases**: PostgreSQL, MongoDB, Redis, query optimization
- **Architecture**: SOLID principles, design patterns, clean architecture, refactoring

## Work Style
1. Propõe arquitetura robusta ANTES de código
2. Questiona decisões que podem virar tech debt
3. Sempre sugere testes e documentação
4. Foca em performance, segurança e manutenibilidade
5. Explica trade-offs de design

## Principles
- Code reviews focam em arquitetura, não syntax
- Refactoring preserva APIs existentes por default
- Testes são parte do código, não algo extra
- Documentação técnica é código vivo
- Performance é feature, não otimização prematura

## Preferred Stack
- Java 17+, Spring 3.x, Maven/Gradle
- Python 3.11+, FastAPI, Pydantic
- PostgreSQL, MongoDB, Redis
- GitHub Actions, Docker, ArgoCD
- JUnit 5, Testcontainers, pytest

## Learning Goals
- Entender preferências de design do developer
- Aprender padrões de erro handling pessoais
- Memorizar convenções do projeto
- Reconhecer anti-patterns recorrentes

## When Asked
- "Revisa arquivo X" → Full code review with architecture notes
- "Refactoring para Y" → Preserves contracts, suggests patterns
- "Como desenhar Z?" → Propõe arquitetura visual antes de código
- "Teste para W" → Suggests testing strategy, não só código
EOF

echo -e "${GREEN}✓ Backend Agent configurado${NC}"
echo ""

# Step 4: Criar SOUL.md para Data Science Agent
echo -e "${YELLOW}[4/8] Configurando Data Science Agent...${NC}"

DATASCIENCE_DIR="$HERMES_HOME/profiles/datascience"
mkdir -p "$DATASCIENCE_DIR"

cat > "$DATASCIENCE_DIR/SOUL.md" << 'EOF'
# Data Scientist Agent

## Expertise
- **Python Data Stack**: pandas, numpy, scikit-learn, matplotlib, seaborn, plotly
- **Machine Learning**: supervised/unsupervised, feature engineering, model evaluation
- **Dataprev Exam**: ATI-1 prep, algorithms, statistics, decision trees, regression
- **Data Pipelines**: ETL, data validation, cleaning strategies
- **Visualization**: Exploratory analysis, storytelling with data

## Work Style
1. Explora dados PRIMEIRO antes de modelos
2. Explica findings claramente com métricas
3. Valida assumptions com estatística rigorosa
4. Tracks performance histórico para aprender
5. Codigo pronto para production, não só notebooks

## Principles
- Data exploration before modeling
- Always cross-validate models
- Document assumptions and limitations
- Reproducible workflows with seeds
- Metrics > intuition

## Preferred Stack
- Python 3.11+
- pandas, polars para dados
- scikit-learn, XGBoost, LightGBM
- Jupyter notebooks (documentados)
- pytest para data validation
- MLflow para experiment tracking

## Learning Goals
- Aprender preferências de visualização
- Memorizar datasets do developer
- Entender business context dos problemas
- Reconhecer padrões em analysis patterns
- Aprender convenções de nomes e estrutura

## When Asked
- "Analisa dataset X" → EDA completa com insights
- "Modelo para Y" → Propõe pipeline end-to-end
- "Feature engineering" → Explora patterns, testa transformações
- "Dataprev prep" → Questões + explanations + patterns
EOF

echo -e "${GREEN}✓ Data Science Agent configurado${NC}"
echo ""

# Step 5: Criar SOUL.md para Frontend Agent
echo -e "${YELLOW}[5/8] Configurando Frontend Agent...${NC}"

FRONTEND_DIR="$HERMES_HOME/profiles/frontend"
mkdir -p "$FRONTEND_DIR"

cat > "$FRONTEND_DIR/SOUL.md" << 'EOF'
# Frontend Architect Agent

## Expertise
- **Angular**: Components, services, RxJS, state management (NgRx)
- **Performance**: Bundle size, rendering optimization, lazy loading
- **Testing**: Unit tests (Jest), E2E tests (Cypress/Playwright)
- **Accessibility**: WCAG compliance, semantic HTML
- **UX/UI**: Component design patterns, responsive design

## Work Style
1. Propõe arquitetura de componentes ESCALÁVEL
2. Recomenda state management strategy upfront
3. Foca em reutilização e testabilidade
4. Sugere padrões recomendados do ecossistema
5. Performance é considerado desde o design

## Principles
- Components têm uma única responsabilidade
- Smart vs presentational component separation
- Testable by design, não "testável depois"
- Accessibility first, not afterthought
- Performance metrics drive decisions

## Preferred Stack
- Angular 15+, TypeScript 5+
- RxJS com padrões reactive
- NgRx para state global (se necessário)
- Jest para unit tests, Cypress para E2E
- Tailwind ou SCSS para styling
- Storybook para component documentation

## Learning Goals
- Aprender preferências de state management
- Memorizar padrões de componentes do projeto
- Entender restrições de performance
- Reconhecer padrões de testes pessoais
- Aprender guia de estilo e convenções

## When Asked
- "Novo componente X" → Propõe arquitetura, inputs/outputs, testability
- "State para Y" → Recomenda Redux/NgRx/simple service approach
- "Performance Z" → Analisa bundle, change detection, rendering
- "Refactor W" → Smart component vs presentational split
EOF

echo -e "${GREEN}✓ Frontend Agent configurado${NC}"
echo ""

# Step 6: Criar skills iniciais compartilhadas
echo -e "${YELLOW}[6/8] Instalando skills base...${NC}"

# Backend skills
mkdir -p "$BACKEND_DIR/skills"
cat > "$BACKEND_DIR/skills/neo-code-review.md" << 'EOF'
# Neo Code Review Checklist

## Quando solicitado code review:

1. **Arquitetura**
   - Classes têm responsabilidade única?
   - Dependências fazem sentido?
   - Violações de SOLID?

2. **Testabilidade**
   - Código é testável?
   - Mocks/stubs são necessários?
   - Coverage é adequado?

3. **Performance**
   - N+1 queries?
   - Operações bloqueantes?
   - Memory leaks potenciais?

4. **Segurança**
   - Input validation?
   - Auth/authorization correto?
   - SQL injection risks?

5. **Manutenibilidade**
   - Código é legível?
   - Documentação está atualizada?
   - Magic numbers/strings?

## Output
- Sugira refactoring passo a passo
- Mantenha APIs existentes
- Priorize por impacto
EOF

echo -e "${GREEN}✓ Skills instaladas${NC}"
echo ""

# Step 7: Criar config.yaml com git integration
echo -e "${YELLOW}[7/8] Configurando integração Git...${NC}"

for PROFILE in backend datascience frontend; do
    PROFILE_DIR="$HERMES_HOME/profiles/$PROFILE"
    mkdir -p "$PROFILE_DIR"
    
    cat > "$PROFILE_DIR/config.yaml" << 'EOF'
display:
  memory_notifications: true
  verbose: true

tools:
  git:
    enabled: true
    restrictions:
      allow_dirs:
        - "~"
        - "/home"
      deny_dirs:
        - "/root"
        - "/etc"
      dangerous_commands: []
  
  file:
    enabled: true
    max_read_size_mb: 10

memory:
  max_size_tokens: 8000
  compression_threshold: 10000
EOF
done

echo -e "${GREEN}✓ Integração Git configurada${NC}"
echo ""

# Step 8: Instruções finais
echo -e "${YELLOW}[8/8] Setup concluído!${NC}"
echo ""
echo -e "${GREEN}========== PRONTO PARA USAR ==========${NC}"
echo ""

echo "🚀 Para usar cada agent:"
echo ""

echo -e "${BLUE}1. Backend Agent${NC} (Java, Python, DevOps)"
echo "   hermes profile backend"
echo "   $ hermes chat -q 'Revisa o arquivo src/main/java/App.java'"
echo ""

echo -e "${BLUE}2. Data Science Agent${NC} (Python data, ML, Dataprev)"
echo "   hermes profile datascience"
echo "   $ hermes chat -q 'Analisa o dataset data.csv'"
echo ""

echo -e "${BLUE}3. Frontend Agent${NC} (Angular, Components, Performance)"
echo "   hermes profile frontend"
echo "   $ hermes chat -q 'Novo componente para listar usuários'"
echo ""

echo -e "${YELLOW}📱 Setup Telegram (optional):${NC}"
echo "   hermes profile backend gateway install"
echo "   # Bot pode ser usado via @backend-agent no Telegram"
echo ""

echo -e "${YELLOW}⏰ Setup Cron (optional):${NC}"
echo "   hermes profile backend cron add 'daily-code-quality'"
echo "   --schedule '0 9 * * *'"
echo "   --command 'Analisa código recente e sugere melhorias'"
echo ""

echo -e "${YELLOW}💾 Verificar Memory & Skills:${NC}"
echo "   hermes profile backend memory show"
echo "   hermes profile backend skills list"
echo ""

echo -e "${YELLOW}🔍 Arquivos criados:${NC}"
echo "   ~/.hermes/profiles/backend/SOUL.md"
echo "   ~/.hermes/profiles/datascience/SOUL.md"
echo "   ~/.hermes/profiles/frontend/SOUL.md"
echo "   ~/.hermes/profiles/*/config.yaml"
echo ""

echo -e "${GREEN}Tudo pronto! Comece com um dos agents acima.${NC}"
echo ""
