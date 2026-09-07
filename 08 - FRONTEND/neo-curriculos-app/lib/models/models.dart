import 'package:equatable/equatable.dart';

// ============== USER MODELS ==============

/// User model representing a candidate
class UserModel extends Equatable {
  final String id;
  final String email;
  final String nome;
  final String tipo; // "candidato"
  final DateTime criadoEm;

  const UserModel({
    required this.id,
    required this.email,
    required this.nome,
    required this.tipo,
    required this.criadoEm,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? 'candidato',
      criadoEm: DateTime.tryParse(json['criado_em'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'nome': nome,
    'tipo': tipo,
    'criado_em': criadoEm.toIso8601String(),
  };

  /// Create a copy with optional changes
  UserModel copyWith({
    String? id,
    String? email,
    String? nome,
    String? tipo,
    DateTime? criadoEm,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  List<Object?> get props => [id, email, nome, tipo, criadoEm];
}

// ============== CURRICULO MODELS ==============

/// Curriculo (CV) model
class CurriculoModel extends Equatable {
  final String id;
  final int versao;
  final String arquivoUrl;
  final String arquivoHash;
  final int arquivoTamanho;
  final DateTime criadoEm;
  final bool ativo;

  const CurriculoModel({
    required this.id,
    required this.versao,
    required this.arquivoUrl,
    required this.arquivoHash,
    required this.arquivoTamanho,
    required this.criadoEm,
    required this.ativo,
  });

  /// Create CurriculoModel from JSON
  factory CurriculoModel.fromJson(Map<String, dynamic> json) {
    return CurriculoModel(
      id: json['_id'] ?? '',
      versao: json['versao'] ?? 1,
      arquivoUrl: json['arquivo_url'] ?? '',
      arquivoHash: json['arquivo_hash'] ?? '',
      arquivoTamanho: json['arquivo_tamanho'] ?? 0,
      criadoEm: DateTime.tryParse(json['criado_em'] ?? '') ?? DateTime.now(),
      ativo: json['ativo'] ?? true,
    );
  }

  /// Convert CurriculoModel to JSON
  Map<String, dynamic> toJson() => {
    '_id': id,
    'versao': versao,
    'arquivo_url': arquivoUrl,
    'arquivo_hash': arquivoHash,
    'arquivo_tamanho': arquivoTamanho,
    'criado_em': criadoEm.toIso8601String(),
    'ativo': ativo,
  };

  /// Get file size in MB
  double get fileSizeInMb => arquivoTamanho / (1024 * 1024);

  /// Create a copy with optional changes
  CurriculoModel copyWith({
    String? id,
    int? versao,
    String? arquivoUrl,
    String? arquivoHash,
    int? arquivoTamanho,
    DateTime? criadoEm,
    bool? ativo,
  }) {
    return CurriculoModel(
      id: id ?? this.id,
      versao: versao ?? this.versao,
      arquivoUrl: arquivoUrl ?? this.arquivoUrl,
      arquivoHash: arquivoHash ?? this.arquivoHash,
      arquivoTamanho: arquivoTamanho ?? this.arquivoTamanho,
      criadoEm: criadoEm ?? this.criadoEm,
      ativo: ativo ?? this.ativo,
    );
  }

  @override
  List<Object?> get props => [
    id,
    versao,
    arquivoUrl,
    arquivoHash,
    arquivoTamanho,
    criadoEm,
    ativo,
  ];
}

// ============== RESPONSE MODELS ==============

/// Login response model
class LoginResponse extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final UserModel usuario;

  const LoginResponse({
    required this.accessToken,
    this.refreshToken,
    required this.usuario,
  });

  /// Create LoginResponse from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'],
      usuario: UserModel.fromJson(json['usuario'] ?? {}),
    );
  }

  /// Convert LoginResponse to JSON
  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'usuario': usuario.toJson(),
  };

  @override
  List<Object?> get props => [accessToken, refreshToken, usuario];
}

/// Register response model
class RegisterResponse extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final UserModel usuario;

  const RegisterResponse({
    required this.accessToken,
    this.refreshToken,
    required this.usuario,
  });

  /// Create RegisterResponse from JSON
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'],
      usuario: UserModel.fromJson(json['usuario'] ?? {}),
    );
  }

  /// Convert RegisterResponse to JSON
  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'usuario': usuario.toJson(),
  };

  @override
  List<Object?> get props => [accessToken, refreshToken, usuario];
}

/// CV Upload response model
class UploadResponse extends Equatable {
  final String curriculoId;
  final String url;
  final String hash;
  final int tamanho;
  final int versao;

  const UploadResponse({
    required this.curriculoId,
    required this.url,
    required this.hash,
    required this.tamanho,
    required this.versao,
  });

  /// Create UploadResponse from JSON
  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      curriculoId: json['curriculo_id'] ?? '',
      url: json['url'] ?? '',
      hash: json['hash'] ?? '',
      tamanho: json['tamanho'] ?? 0,
      versao: json['versao'] ?? 1,
    );
  }

  /// Convert UploadResponse to JSON
  Map<String, dynamic> toJson() => {
    'curriculo_id': curriculoId,
    'url': url,
    'hash': hash,
    'tamanho': tamanho,
    'versao': versao,
  };

  @override
  List<Object?> get props => [curriculoId, url, hash, tamanho, versao];
}

/// Generic API response wrapper
class ApiResponse<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  /// Create ApiResponse from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) dataBuilder,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null ? dataBuilder(json['data']) : null,
      statusCode: json['statusCode'],
    );
  }

  @override
  List<Object?> get props => [success, message, data, statusCode];
}

/// Paginated list response
class PaginatedResponse<T> extends Equatable {
  final List<T> items;
  final int total;
  final int pagina;
  final int limite;
  final bool hasMore;

  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.pagina,
    required this.limite,
    required this.hasMore,
  });

  /// Create PaginatedResponse from JSON
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) itemBuilder,
  ) {
    final items = (json['items'] as List<dynamic>?)
        ?.map((item) => itemBuilder(item))
        .toList() ?? [];

    final pagina = json['pagina'] ?? 1;
    final limite = json['limite'] ?? 10;
    final total = json['total'] ?? 0;
    final hasMore = (pagina * limite) < total;

    return PaginatedResponse(
      items: items,
      total: total,
      pagina: pagina,
      limite: limite,
      hasMore: hasMore,
    );
  }

  @override
  List<Object?> get props => [items, total, pagina, limite, hasMore];
}

// ============== ERROR MODELS ==============

/// API error response
class ApiErrorResponse extends Equatable {
  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, dynamic>? details;

  const ApiErrorResponse({
    required this.message,
    this.code,
    this.statusCode,
    this.details,
  });

  /// Create ApiErrorResponse from JSON
  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      message: json['message'] ?? 'Unknown error',
      code: json['code'],
      statusCode: json['statusCode'],
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [message, code, statusCode, details];
}

// ============== CONSENT MODELS ==============

/// LGPD Consent model
class LgpdConsent extends Equatable {
  final bool consentimento;
  final String termsVersion;
  final DateTime consentidoEm;

  const LgpdConsent({
    required this.consentimento,
    required this.termsVersion,
    required this.consentidoEm,
  });

  /// Create LgpdConsent from JSON
  factory LgpdConsent.fromJson(Map<String, dynamic> json) {
    return LgpdConsent(
      consentimento: json['consentimento'] ?? false,
      termsVersion: json['termos_versao'] ?? '1.0',
      consentidoEm: DateTime.tryParse(json['consentido_em'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert LgpdConsent to JSON
  Map<String, dynamic> toJson() => {
    'consentimento': consentimento,
    'termos_versao': termsVersion,
    'consentido_em': consentidoEm.toIso8601String(),
  };

  @override
  List<Object?> get props => [consentimento, termsVersion, consentidoEm];
}
