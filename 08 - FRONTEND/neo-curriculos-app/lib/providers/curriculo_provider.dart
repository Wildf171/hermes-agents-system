import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

enum CurriculoState { initial, loading, loaded, error }

/// Curriculo (CV) management provider
class CurriculoProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AuthProvider _authProvider;
  final logger = Logger();

  CurriculoState _state = CurriculoState.initial;
  List<CurriculoModel> _curriculos = [];
  String? _error;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  CurriculoProvider(this._apiService, this._authProvider) {
    _initCurriculos();
  }

  // ============== GETTERS ==============

  CurriculoState get state => _state;
  List<CurriculoModel> get curriculos => _curriculos;
  String? get error => _error;
  bool get isLoading => _state == CurriculoState.loading;
  bool get isLoaded => _state == CurriculoState.loaded;
  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;

  /// Get active (latest) curriculo
  CurriculoModel? get activeCurriculo {
    if (_curriculos.isEmpty) return null;
    try {
      return _curriculos.firstWhere((c) => c.ativo);
    } catch (e) {
      return _curriculos.first;
    }
  }

  /// Get total number of curriculos
  int get count => _curriculos.length;

  /// Check if has any curriculos
  bool get hasCurriculos => _curriculos.isNotEmpty;

  // ============== INITIALIZATION ==============

  /// Initialize by fetching user curriculos
  Future<void> _initCurriculos() async {
    if (_authProvider.isAuthenticated) {
      await fetchCurriculos();
    }
  }

  // ============== FETCH DATA ==============

  /// Fetch list of curriculos
  Future<bool> fetchCurriculos({
    int pagina = 1,
    int limite = 10,
  }) async {
    _state = CurriculoState.loading;
    _error = null;
    notifyListeners();

    try {
      _curriculos = await _apiService.listCurriculos(
        pagina: pagina,
        limite: limite,
      );

      _state = CurriculoState.loaded;
      _error = null;

      logger.i('Fetched ${_curriculos.length} curriculos');
      notifyListeners();
      return true;
    } catch (e) {
      _state = CurriculoState.error;
      _error = _parseError(e);

      logger.e('Failed to fetch curriculos: $e');
      notifyListeners();
      return false;
    }
  }

  /// Get single curriculo details
  Future<CurriculoModel?> getCurriculo(String curriculoId) async {
    try {
      final curriculo = await _apiService.getCurriculo(curriculoId);
      logger.i('Fetched curriculo details: $curriculoId');
      return curriculo;
    } catch (e) {
      logger.e('Failed to fetch curriculo: $e');
      return null;
    }
  }

  // ============== UPLOAD CV ==============

  /// Upload a CV file
  Future<bool> uploadCurriculo(String filePath) async {
    _isUploading = true;
    _uploadProgress = 0.0;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.uploadCurriculo(filePath);

      // Add to list
      _curriculos.insert(
        0,
        CurriculoModel(
          id: response.curriculoId,
          versao: response.versao,
          arquivoUrl: response.url,
          arquivoHash: response.hash,
          arquivoTamanho: response.tamanho,
          criadoEm: DateTime.now(),
          ativo: true,
        ),
      );

      _isUploading = false;
      _uploadProgress = 1.0;
      _error = null;
      _state = CurriculoState.loaded;

      logger.i('CV uploaded successfully: ${response.curriculoId}');
      notifyListeners();

      // Reset upload progress after delay
      await Future.delayed(Duration(seconds: 1));
      _uploadProgress = 0.0;
      notifyListeners();

      return true;
    } catch (e) {
      _isUploading = false;
      _uploadProgress = 0.0;
      _error = _parseError(e);
      _state = CurriculoState.error;

      logger.e('CV upload failed: $e');
      notifyListeners();
      return false;
    }
  }

  // ============== DELETE CV ==============

  /// Delete a curriculo
  Future<bool> deleteCurriculo(String curriculoId) async {
    try {
      await _apiService.deleteCurriculo(curriculoId);

      // Remove from list
      _curriculos.removeWhere((c) => c.id == curriculoId);

      logger.i('Curriculo deleted: $curriculoId');
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);

      logger.e('Failed to delete curriculo: $e');
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

  void updateProgress(double progress) {
    _uploadProgress = progress;
    notifyListeners();
  }

  void reset() {
    _state = CurriculoState.initial;
    _curriculos = [];
    _error = null;
    _isUploading = false;
    _uploadProgress = 0.0;
    notifyListeners();
  }
}
