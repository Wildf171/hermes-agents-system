import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../config/app_config.dart';
import '../models/models.dart';

/// API Service using Dio with interceptors
class ApiService {
  late Dio _dio;
  final logger = Logger();
  final _secureStorage = const FlutterSecureStorage();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.apiTimeout,
        receiveTimeout: AppConfig.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'NeoCurriculosApp/1.0',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(this),
      _LoggingInterceptor(logger),
      _ErrorInterceptor(logger),
      _RetryInterceptor(_dio),
    ]);
  }

  // ============== AUTH ENDPOINTS ==============

  /// Register a new user
  Future<RegisterResponse> register({
    required String email,
    required String nome,
    required String senha,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/registrar',
        data: {
          'email': email,
          'nome': nome,
          'senha': senha,
        },
      );

      final registerResponse = RegisterResponse.fromJson(response.data);

      // Save token securely
      await _secureStorage.write(
        key: AppConfig.accessTokenKey,
        value: registerResponse.accessToken,
      );

      if (registerResponse.refreshToken != null) {
        await _secureStorage.write(
          key: AppConfig.refreshTokenKey,
          value: registerResponse.refreshToken!,
        );
      }

      logger.i('Registration successful: ${registerResponse.usuario.email}');
      return registerResponse;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// Login user
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'senha': password, // Backend uses 'senha'
        },
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      // Save token securely
      await _secureStorage.write(
        key: AppConfig.accessTokenKey,
        value: loginResponse.accessToken,
      );

      if (loginResponse.refreshToken != null) {
        await _secureStorage.write(
          key: AppConfig.refreshTokenKey,
          value: loginResponse.refreshToken!,
        );
      }

      logger.i('Login successful: ${loginResponse.usuario.email}');
      return loginResponse;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// Refresh access token
  Future<String> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: AppConfig.refreshTokenKey,
      );

      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _dio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'] as String;

      await _secureStorage.write(
        key: AppConfig.accessTokenKey,
        value: newAccessToken,
      );

      logger.i('Token refreshed successfully');
      return newAccessToken;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _dio.post('/api/auth/logout');
      await _secureStorage.delete(key: AppConfig.accessTokenKey);
      await _secureStorage.delete(key: AppConfig.refreshTokenKey);
      logger.i('Logout successful');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // ============== CV ENDPOINTS ==============

  /// Upload CV (PDF file)
  Future<UploadResponse> uploadCurriculo(String filePath) async {
    try {
      final file = File(filePath);

      // Validation
      if (!file.path.endsWith('.pdf')) {
        throw Exception('Apenas arquivos PDF são permitidos');
      }

      final fileSize = file.lengthSync();
      if (fileSize > AppConfig.maxFileSize) {
        throw Exception(
          'Arquivo não pode exceder ${AppConfig.maxFileSizeMB}MB',
        );
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: DioMediaType.parse(AppConfig.mimeTypePdf),
        ),
      });

      final response = await _dio.post(
        '/api/curriculos/upload',
        data: formData,
      );

      final uploadResponse = UploadResponse.fromJson(response.data);
      logger.i('CV uploaded: ${uploadResponse.curriculoId}');
      return uploadResponse;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// List user's curriculos
  Future<List<CurriculoModel>> listCurriculos({
    int? pagina,
    int? limite,
  }) async {
    try {
      final response = await _dio.get(
        '/api/candidatos/curriculos',
        queryParameters: {
          if (pagina != null) 'pagina': pagina,
          if (limite != null) 'limite': limite,
        },
      );

      final curriculosList = (response.data['curriculos'] as List?)
          ?.map((e) => CurriculoModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];

      logger.i('Fetched ${curriculosList.length} CVs');
      return curriculosList;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// Get single curriculo details
  Future<CurriculoModel> getCurriculo(String curriculoId) async {
    try {
      final response = await _dio.get(
        '/api/curriculos/$curriculoId',
      );

      final curriculo = CurriculoModel.fromJson(
        response.data['curriculo'] as Map<String, dynamic>,
      );

      logger.i('Fetched curriculo: $curriculoId');
      return curriculo;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// Delete curriculo
  Future<void> deleteCurriculo(String curriculoId) async {
    try {
      await _dio.delete('/api/curriculos/$curriculoId');
      logger.i('Deleted curriculo: $curriculoId');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // ============== USER PROFILE ENDPOINTS ==============

  /// Get user profile
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dio.get('/api/candidatos/perfil');

      final usuario = UserModel.fromJson(
        response.data['usuario'] as Map<String, dynamic>,
      );

      logger.i('Fetched user profile: ${usuario.email}');
      return usuario;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// Update user profile
  Future<UserModel> updateUserProfile({
    required String nome,
    String? email,
  }) async {
    try {
      final response = await _dio.post(
        '/api/candidatos/perfil',
        data: {
          'nome': nome,
          if (email != null) 'email': email,
        },
      );

      final usuario = UserModel.fromJson(
        response.data['usuario'] as Map<String, dynamic>,
      );

      logger.i('Updated user profile: ${usuario.email}');
      return usuario;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // ============== LGPD ENDPOINTS ==============

  /// Give LGPD consent
  Future<void> consentirLGPD({required bool consentimento}) async {
    try {
      await _dio.post(
        '/api/candidatos/consentimento',
        data: {
          'consentimento': consentimento,
          'termos_versao': AppConfig.lgpdTermsVersion,
        },
      );

      logger.i('LGPD consent given: $consentimento');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// Delete user account and data
  Future<void> deletarConta() async {
    try {
      await _dio.delete('/api/candidatos/deletar-conta');
      await _secureStorage.deleteAll();
      logger.i('Account deleted');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // ============== TOKEN MANAGEMENT ==============

  /// Get access token from secure storage
  Future<String?> getAccessToken() {
    return _secureStorage.read(key: AppConfig.accessTokenKey);
  }

  /// Get refresh token from secure storage
  Future<String?> getRefreshToken() {
    return _secureStorage.read(key: AppConfig.refreshTokenKey);
  }

  /// Clear all stored tokens
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: AppConfig.accessTokenKey);
    await _secureStorage.delete(key: AppConfig.refreshTokenKey);
  }

  // ============== ERROR HANDLING ==============

  void _handleDioError(DioException e) {
    String message = 'Erro desconhecido';

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      if (data is Map && data.containsKey('message')) {
        message = data['message'] as String;
      } else {
        message = _getStatusCodeMessage(statusCode);
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = 'Timeout de conexão';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = 'Timeout ao receber dados';
    } else if (e.type == DioExceptionType.unknown) {
      message = 'Erro de conexão';
    }

    logger.e('API Error: $message', error: e, stackTrace: e.stackTrace);
  }

  String _getStatusCodeMessage(int? code) {
    switch (code) {
      case 400:
        return 'Requisição inválida';
      case 401:
        return 'Não autenticado';
      case 403:
        return 'Sem permissão';
      case 404:
        return 'Recurso não encontrado';
      case 409:
        return 'Conflito';
      case 413:
        return 'Arquivo muito grande';
      case 500:
        return 'Erro do servidor';
      case 503:
        return 'Serviço indisponível';
      default:
        return 'Erro HTTP $code';
    }
  }
}

// ============== INTERCEPTORS ==============

/// Authentication interceptor
class _AuthInterceptor extends Interceptor {
  final ApiService apiService;

  _AuthInterceptor(this.apiService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await apiService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 - try to refresh token
    if (err.response?.statusCode == 401) {
      try {
        await apiService.refreshToken();
        // Retry original request with new token
        final token = await apiService.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        return handler.resolve(await apiService._dio.fetch(err.requestOptions));
      } catch (e) {
        return handler.next(err);
      }
    }
    handler.next(err);
  }
}

/// Logging interceptor
class _LoggingInterceptor extends Interceptor {
  final Logger logger;

  _LoggingInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d('╔══════════════════════════════════════════');
    logger.d('║ ${options.method} ${options.path}');
    logger.d('╟──────────────────────────────────────────');
    if (options.data != null) {
      logger.d('║ Data: ${options.data}');
    }
    logger.d('╚══════════════════════════════════════════');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('╔══════════════════════════════════════════');
    logger.d('║ ✓ ${response.statusCode} ${response.requestOptions.path}');
    logger.d('╟──────────────────────────────────────────');
    logger.d('║ Response: ${response.data}');
    logger.d('╚══════════════════════════════════════════');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('╔══════════════════════════════════════════');
    logger.e('║ ✗ ${err.message}');
    logger.e('╟──────────────────────────────────────────');
    logger.e('║ ${err.requestOptions.method} ${err.requestOptions.path}');
    logger.e('║ Status: ${err.response?.statusCode}');
    logger.e('║ Error: ${err.error}');
    logger.e('╚══════════════════════════════════════════');
    handler.next(err);
  }
}

/// Error interceptor
class _ErrorInterceptor extends Interceptor {
  final Logger logger;

  _ErrorInterceptor(this.logger);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('API Error: ${err.message}', error: err);
    handler.next(err);
  }
}

/// Retry interceptor with exponential backoff
class _RetryInterceptor extends Interceptor {
  final Dio dio;
  static const int maxRetries = AppConfig.apiMaxRetries;

  _RetryInterceptor(this.dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only retry on network errors or 5xx
    if (_shouldRetry(err)) {
      final retryCount = _getRetryCount(err.requestOptions);

      if (retryCount < maxRetries) {
        _setRetryCount(err.requestOptions, retryCount + 1);

        // Exponential backoff
        final delayMs = 100 * (2 ^ retryCount);
        await Future.delayed(Duration(milliseconds: delayMs));

        try {
          return handler.resolve(await dio.fetch(err.requestOptions));
        } catch (e) {
          return handler.next(err);
        }
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode ?? 0) >= 500;
  }

  int _getRetryCount(RequestOptions options) {
    return options.extra['retryCount'] ?? 0;
  }

  void _setRetryCount(RequestOptions options, int count) {
    options.extra['retryCount'] = count;
  }
}
