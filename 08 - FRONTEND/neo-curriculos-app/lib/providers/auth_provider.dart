import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/models.dart';
import '../services/api_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

/// Authentication provider managing login/register state
class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final logger = Logger();

  AuthState _state = AuthState.initial;
  UserModel? _user;
  String? _error;
  bool _isLoading = false;

  AuthProvider(this._apiService) {
    _initAuth();
  }

  // ============== GETTERS ==============

  AuthState get state => _state;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _state == AuthState.authenticated;
  String? get userEmail => _user?.email;
  String? get userName => _user?.nome;

  // ============== INITIALIZATION ==============

  /// Initialize auth state (check if already authenticated)
  Future<void> _initAuth() async {
    try {
      _state = AuthState.initial;
      final token = await _apiService.getAccessToken();

      if (token != null) {
        _state = AuthState.authenticated;
        // Try to fetch user profile if authenticated
        try {
          _user = await _apiService.getUserProfile();
        } catch (e) {
          logger.w('Failed to fetch user profile after init: $e');
        }
      } else {
        _state = AuthState.unauthenticated;
      }
    } catch (e) {
      _state = AuthState.unauthenticated;
      logger.e('Auth initialization failed: $e');
    }
    notifyListeners();
  }

  // ============== LOGIN ==============

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _state = AuthState.loading;
    _error = null;
    notifyListeners();

    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email e senha são obrigatórios');
      }

      final response = await _apiService.login(
        email: email,
        password: password,
      );

      _user = response.usuario;
      _state = AuthState.authenticated;
      _error = null;
      _isLoading = false;

      logger.i('Login successful: ${_user?.email}');
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _error = _parseError(e);
      _isLoading = false;

      logger.e('Login failed: $e');
      notifyListeners();
      return false;
    }
  }

  // ============== REGISTRATION ==============

  /// Register a new user
  Future<bool> register({
    required String email,
    required String nome,
    required String senha,
  }) async {
    _isLoading = true;
    _state = AuthState.loading;
    _error = null;
    notifyListeners();

    try {
      // Validate input
      if (email.isEmpty || nome.isEmpty || senha.isEmpty) {
        throw Exception('Email, nome e senha são obrigatórios');
      }

      if (senha.length < 8) {
        throw Exception('Senha deve ter no mínimo 8 caracteres');
      }

      final response = await _apiService.register(
        email: email,
        nome: nome,
        senha: senha,
      );

      _user = response.usuario;
      _state = AuthState.authenticated;
      _error = null;
      _isLoading = false;

      logger.i('Registration successful: ${_user?.email}');
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _error = _parseError(e);
      _isLoading = false;

      logger.e('Registration failed: $e');
      notifyListeners();
      return false;
    }
  }

  // ============== LOGOUT ==============

  /// Logout user and clear tokens
  Future<void> logout() async {
    _isLoading = true;
    _state = AuthState.loading;
    notifyListeners();

    try {
      await _apiService.logout();
      _user = null;
      _state = AuthState.unauthenticated;
      _error = null;

      logger.i('Logout successful');
      notifyListeners();
    } catch (e) {
      _state = AuthState.error;
      _error = _parseError(e);

      logger.e('Logout failed: $e');
      notifyListeners();
    } finally {
      _isLoading = false;
    }
  }

  // ============== TOKEN REFRESH ==============

  /// Refresh access token
  Future<bool> refreshToken() async {
    try {
      await _apiService.refreshToken();
      _state = AuthState.authenticated;
      logger.i('Token refreshed successfully');
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.unauthenticated;
      _error = 'Falha ao renovar sessão';
      logger.e('Token refresh failed: $e');
      notifyListeners();
      return false;
    }
  }

  // ============== ACCOUNT MANAGEMENT ==============

  /// Update user profile
  Future<bool> updateProfile({
    required String nome,
    String? email,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (nome.isEmpty) {
        throw Exception('Nome é obrigatório');
      }

      _user = await _apiService.updateUserProfile(
        nome: nome,
        email: email,
      );

      _error = null;
      _isLoading = false;

      logger.i('Profile updated: ${_user?.nome}');
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;

      logger.e('Profile update failed: $e');
      notifyListeners();
      return false;
    }
  }

  /// Delete user account
  Future<bool> deleteAccount() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deletarConta();
      _user = null;
      _state = AuthState.unauthenticated;
      _error = null;
      _isLoading = false;

      logger.i('Account deleted');
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;

      logger.e('Account deletion failed: $e');
      notifyListeners();
      return false;
    }
  }

  // ============== HELPER METHODS ==============

  /// Parse error message from exception
  String _parseError(dynamic error) {
    if (error is DioException) {
      final message = error.response?.data['message'];
      if (message is String) {
        return message;
      }
    }

    return error.toString().replaceAll('Exception: ', '');
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Reset auth state
  void reset() {
    _state = AuthState.initial;
    _user = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Check if user is authenticated and token is valid
  Future<bool> checkAuthStatus() async {
    try {
      final token = await _apiService.getAccessToken();
      return token != null;
    } catch (e) {
      return false;
    }
  }
}

// Imported but needed for error parsing
import 'package:dio/dio.dart';
