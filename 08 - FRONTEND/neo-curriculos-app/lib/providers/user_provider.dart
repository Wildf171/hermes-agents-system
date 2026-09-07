import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

enum UserState { initial, loading, loaded, error }

/// User profile provider
class UserProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AuthProvider _authProvider;
  final logger = Logger();

  UserState _state = UserState.initial;
  UserModel? _user;
  String? _error;

  UserProvider(this._apiService, this._authProvider) {
    _initUser();
  }

  // ============== GETTERS ==============

  UserState get state => _state;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isLoading => _state == UserState.loading;
  bool get isLoaded => _state == UserState.loaded;

  // ============== INITIALIZATION ==============

  /// Initialize user data from auth provider
  Future<void> _initUser() async {
    if (_authProvider.isAuthenticated) {
      _user = _authProvider.user;
      if (_user != null) {
        _state = UserState.loaded;
      } else {
        await fetchUserProfile();
      }
    }
    notifyListeners();
  }

  // ============== FETCH DATA ==============

  /// Fetch user profile from API
  Future<bool> fetchUserProfile() async {
    _state = UserState.loading;
    _error = null;
    notifyListeners();

    try {
      _user = await _apiService.getUserProfile();
      _state = UserState.loaded;
      _error = null;

      logger.i('User profile fetched: ${_user?.email}');
      notifyListeners();
      return true;
    } catch (e) {
      _state = UserState.error;
      _error = _parseError(e);

      logger.e('Failed to fetch user profile: $e');
      notifyListeners();
      return false;
    }
  }

  // ============== UPDATE DATA ==============

  /// Update user profile
  Future<bool> updateProfile({
    required String nome,
    String? email,
  }) async {
    _state = UserState.loading;
    _error = null;
    notifyListeners();

    try {
      if (nome.isEmpty) {
        throw Exception('Nome é obrigatório');
      }

      _user = await _apiService.updateUserProfile(
        nome: nome,
        email: email,
      );

      _state = UserState.loaded;
      _error = null;

      logger.i('User profile updated: ${_user?.nome}');
      notifyListeners();
      return true;
    } catch (e) {
      _state = UserState.error;
      _error = _parseError(e);

      logger.e('Profile update failed: $e');
      notifyListeners();
      return false;
    }
  }

  // ============== HELPER METHODS ==============

  String _parseError(dynamic error) {
    return error.toString().replaceAll('Exception: ', '');
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _state = UserState.initial;
    _user = null;
    _error = null;
    notifyListeners();
  }
}
