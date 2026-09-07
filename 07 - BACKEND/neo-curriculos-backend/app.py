"""
===============================================================================
app.py - Entrada Principal da Aplicação Flask
===============================================================================

Neo Currículos + Neo RH System - Backend
- Autenticação unificada (candidato/RH/admin)
- Upload de currículos com versionamento
- Conformidade LGPD (retenção 7 anos, soft delete, anonimização)
- API RESTful com OpenAPI/Swagger

Executar:
    python app.py
    python -m flask run
    gunicorn -w 4 -b 0.0.0.0:5000 app:app

Data: 2026-09-07
Version: 1.0.0
"""

import os
import logging
from datetime import datetime
from dotenv import load_dotenv

from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_pymongo import PyMongo
from pymongo import MongoClient

# ============================================================================
# LOAD ENV
# ============================================================================

load_dotenv()


# ============================================================================
# LOGGING
# ============================================================================

def setup_logging(app):
    """Configurar logging estruturado"""
    log_level = os.getenv('LOG_LEVEL', 'INFO')
    log_format = os.getenv('LOG_FORMAT', 'text')

    if log_format == 'json':
        # JSON logging (usar python-json-logger em produção)
        handler = logging.StreamHandler()
        handler.setFormatter(logging.Formatter(
            '{"timestamp": "%(asctime)s", "level": "%(levelname)s", "message": "%(message)s"}'
        ))
    else:
        # Text logging
        handler = logging.StreamHandler()
        handler.setFormatter(logging.Formatter(
            '[%(asctime)s] %(levelname)s - %(name)s - %(message)s'
        ))

    app.logger.addHandler(handler)
    app.logger.setLevel(log_level)

    return app.logger


# ============================================================================
# APP FACTORY
# ============================================================================

def create_app():
    """Factory function para criar aplicação Flask"""

    app = Flask(__name__)

    # =====================================================================
    # CONFIGURAÇÃO
    # =====================================================================

    # Flask config
    app.config['FLASK_ENV'] = os.getenv('FLASK_ENV', 'development')
    app.config['DEBUG'] = os.getenv('FLASK_DEBUG', True)
    app.config['JSON_SORT_KEYS'] = False

    # MongoDB
    app.config['MONGO_URI'] = os.getenv(
        'MONGO_URI',
        'mongodb://admin:password@localhost:27017/neo_rh'
    )

    # JWT
    app.config['JWT_SECRET_KEY'] = os.getenv('JWT_SECRET_KEY', 'dev-secret-key-min-32-chars')
    app.config['JWT_ACCESS_TOKEN_EXPIRES'] = int(
        os.getenv('JWT_ACCESS_TOKEN_EXPIRES', 86400)
    )
    app.config['JWT_REFRESH_TOKEN_EXPIRES'] = int(
        os.getenv('JWT_REFRESH_TOKEN_EXPIRES', 2592000)
    )

    # Storage
    app.config['STORAGE_TYPE'] = os.getenv('STORAGE_TYPE', 'minio')
    app.config['MINIO_ENDPOINT'] = os.getenv('MINIO_ENDPOINT', 'localhost:9000')
    app.config['MINIO_ACCESS_KEY'] = os.getenv('MINIO_ACCESS_KEY', 'minioadmin')
    app.config['MINIO_SECRET_KEY'] = os.getenv('MINIO_SECRET_KEY', 'minioadmin')
    app.config['MINIO_BUCKET'] = os.getenv('MINIO_BUCKET', 'neo-curriculos')
    app.config['MINIO_USE_SSL'] = os.getenv('MINIO_USE_SSL', 'false').lower() == 'true'

    # Upload
    app.config['MAX_UPLOAD_SIZE_MB'] = int(os.getenv('MAX_UPLOAD_SIZE_MB', 10))
    app.config['UPLOAD_FOLDER'] = os.path.join(os.path.dirname(__file__), 'uploads')

    # CORS
    cors_origins = os.getenv('CORS_ORIGINS', '["http://localhost:3000", "http://localhost:5000"]')
    import json
    try:
        cors_origins = json.loads(cors_origins)
    except:
        cors_origins = ['http://localhost:3000', 'http://localhost:5000']

    # =====================================================================
    # LOGGING
    # =====================================================================

    logger = setup_logging(app)

    # =====================================================================
    # BANCO DE DADOS
    # =====================================================================

    try:
        # Usar PyMongo para gerenciamento de conexão
        mongo = PyMongo(app)
        app.db = mongo.db

        logger.info("MongoDB conectado com sucesso")

        # Inicializar índices
        import importlib
        models_module = importlib.import_module('models.06_MODELS_MONGODB')
        models_module.setup_database(app.db)

    except Exception as e:
        logger.error(f"Erro ao conectar MongoDB: {str(e)}")
        # Em dev, continuar sem DB para testes
        app.db = None

    # =====================================================================
    # CORS
    # =====================================================================

    CORS(
        app,
        resources={r"/api/*": {
            "origins": cors_origins,
            "methods": ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization"],
            "max_age": 3600
        }}
    )

    # =====================================================================
    # ERROR HANDLERS
    # =====================================================================

    @app.errorhandler(400)
    def bad_request(error):
        return jsonify({
            'erro': 'Bad Request',
            'mensagem': str(error)
        }), 400

    @app.errorhandler(401)
    def unauthorized(error):
        return jsonify({
            'erro': 'Unauthorized',
            'mensagem': 'Token ausente ou inválido'
        }), 401

    @app.errorhandler(403)
    def forbidden(error):
        return jsonify({
            'erro': 'Forbidden',
            'mensagem': 'Acesso negado'
        }), 403

    @app.errorhandler(404)
    def not_found(error):
        return jsonify({
            'erro': 'Not Found',
            'mensagem': 'Recurso não encontrado'
        }), 404

    @app.errorhandler(500)
    def internal_error(error):
        logger.error(f"Erro interno: {str(error)}")
        return jsonify({
            'erro': 'Internal Server Error',
            'mensagem': 'Erro interno do servidor'
        }), 500

    # =====================================================================
    # REQUEST/RESPONSE HOOKS
    # =====================================================================

    @app.before_request
    def before_request():
        """Log de request antes do processamento"""
        g_request_start = request.environ.get('werkzeug.request', None)
        request.start_time = datetime.utcnow()
        logger.info(f"{request.method} {request.path}")

    @app.after_request
    def after_request(response):
        """Log de response após processamento"""
        duration = (datetime.utcnow() - request.start_time).total_seconds()
        logger.info(
            f"{request.method} {request.path} - "
            f"Status: {response.status_code} - Duration: {duration}s"
        )
        return response

    # =====================================================================
    # BLUEPRINTS - AUTENTICAÇÃO
    # =====================================================================

    auth_module = importlib.import_module('auth.04_AUTH_UNIFICADA')
    auth_module.register_auth_bp(app)

    # =====================================================================
    # BLUEPRINTS - CURRÍCULOS
    # =====================================================================

    routes_module = importlib.import_module('routes.05_ROUTES_NEO_CURRICULOS')
    routes_module.register_curriculos_bp(app)

    # =====================================================================
    # HEALTH CHECK E VERSÃO
    # =====================================================================

    @app.route('/health', methods=['GET'])
    def health_check():
        """Health check endpoint"""
        return jsonify({
            'status': 'ok',
            'timestamp': datetime.utcnow().isoformat(),
            'version': '1.0.0',
            'service': 'neo-curriculos-api'
        }), 200

    @app.route('/api/version', methods=['GET'])
    def get_version():
        """Versão da API"""
        return jsonify({
            'version': '1.0.0',
            'environment': app.config['FLASK_ENV'],
            'timestamp': datetime.utcnow().isoformat()
        }), 200

    @app.route('/', methods=['GET'])
    def index():
        """Página inicial"""
        return jsonify({
            'service': 'Neo Currículos + Neo RH API',
            'version': '1.0.0',
            'docs': '/api/docs',
            'health': '/health',
            'endpoints': {
                'auth': '/api/auth',
                'curriculos': '/api/curriculos',
                'auditoria': '/api/auditoria'
            }
        }), 200

    # =====================================================================
    # OPENAPI/SWAGGER
    # =====================================================================

    @app.route('/api/docs', methods=['GET'])
    def swagger_docs():
        """Retornar documentação OpenAPI"""
        return jsonify({
            'title': 'Neo Currículos + Neo RH API',
            'version': '1.0.0',
            'description': 'API para gerenciamento de currículos e RH',
            'endpoints': {
                'POST /api/auth/registrar': 'Registrar novo candidato',
                'POST /api/auth/login': 'Login de candidato/RH',
                'POST /api/auth/refresh': 'Renovar token',
                'POST /api/auth/logout': 'Logout',
                'GET /api/auth/me': 'Informações do usuário',
                'POST /api/curriculos/upload': 'Upload de currículo',
                'GET /api/candidatos/:id/curriculos': 'Listar versões de CV',
                'POST /api/candidatos/:id/consentimento': 'Registrar consentimento LGPD',
                'DELETE /api/candidatos/:id/deletar-conta': 'Deletar conta',
                'GET /api/curriculos/busca': 'Buscar currículos (RH)',
                'GET /api/auditoria/relatorio': 'Relatório auditoria (Admin)',
            }
        }), 200

    # =====================================================================
    # LOGGING INICIAL
    # =====================================================================

    logger.info("="*80)
    logger.info("Neo Currículos + Neo RH API - Iniciando")
    logger.info(f"Environment: {app.config['FLASK_ENV']}")
    logger.info(f"Debug: {app.config['DEBUG']}")
    logger.info(f"MongoDB: {app.config['MONGO_URI'][:30]}...")
    logger.info(f"Storage: {app.config['STORAGE_TYPE']}")
    logger.info("="*80)

    return app


# ============================================================================
# MAIN
# ============================================================================

if __name__ == '__main__':
    app = create_app()

    # Executar Flask development server
    app.run(
        host='0.0.0.0',
        port=5000,
        debug=app.config['DEBUG']
    )
