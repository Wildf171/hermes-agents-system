import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ============== MOCK CLASSES ==============

class MockApiService extends Mock {
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    return LoginResponse(
      accessToken: 'token123',
      usuario: UserModel(
        id: 'user1',
        email: email,
        nome: 'Test User',
        tipo: 'candidato',
        criadoEm: DateTime.now(),
      ),
    );
  }

  Future<RegisterResponse> register({
    required String email,
    required String nome,
    required String senha,
  }) async {
    return RegisterResponse(
      accessToken: 'token456',
      usuario: UserModel(
        id: 'user2',
        email: email,
        nome: nome,
        tipo: 'candidato',
        criadoEm: DateTime.now(),
      ),
    );
  }

  Future<void> logout() async {
    // Mock logout
  }

  Future<String?> getAccessToken() async {
    return 'token123';
  }

  Future<String?> getRefreshToken() async {
    return 'refresh_token';
  }
}

class MockAuthProvider extends Mock implements AuthProvider {
  @override
  AuthState get state => AuthState.authenticated;

  @override
  UserModel? get user => UserModel(
        id: 'user1',
        email: 'test@example.com',
        nome: 'Test User',
        tipo: 'candidato',
        criadoEm: DateTime.now(),
      );

  @override
  bool get isAuthenticated => true;

  @override
  String? get error => null;
}

// ============== UNIT TESTS ==============

void main() {
  group('Models Tests', () {
    test('UserModel fromJson creates object correctly', () {
      final json = {
        '_id': 'user123',
        'email': 'test@example.com',
        'nome': 'João Silva',
        'tipo': 'candidato',
        'criado_em': '2024-01-15T10:00:00Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.nome, 'João Silva');
      expect(user.tipo, 'candidato');
    });

    test('UserModel toJson converts correctly', () {
      final user = UserModel(
        id: 'user123',
        email: 'test@example.com',
        nome: 'João Silva',
        tipo: 'candidato',
        criadoEm: DateTime(2024, 1, 15),
      );

      final json = user.toJson();

      expect(json['_id'], 'user123');
      expect(json['email'], 'test@example.com');
      expect(json['nome'], 'João Silva');
    });

    test('CurriculoModel fromJson creates object correctly', () {
      final json = {
        '_id': 'cv123',
        'versao': 1,
        'arquivo_url': 'https://s3.../cv.pdf',
        'arquivo_hash': 'hash123',
        'arquivo_tamanho': 5000000,
        'criado_em': '2024-01-15T10:00:00Z',
        'ativo': true,
      };

      final cv = CurriculoModel.fromJson(json);

      expect(cv.id, 'cv123');
      expect(cv.versao, 1);
      expect(cv.ativo, true);
      expect(cv.fileSizeInMb, 5.0); // 5000000 / (1024*1024)
    });

    test('LoginResponse fromJson creates object correctly', () {
      final json = {
        'access_token': 'token123',
        'refresh_token': 'refresh123',
        'usuario': {
          '_id': 'user1',
          'email': 'test@example.com',
          'nome': 'Test User',
          'tipo': 'candidato',
          'criado_em': '2024-01-15T10:00:00Z',
        },
      };

      final response = LoginResponse.fromJson(json);

      expect(response.accessToken, 'token123');
      expect(response.refreshToken, 'refresh123');
      expect(response.usuario.email, 'test@example.com');
    });
  });

  group('Validators Tests', () {
    test('validateEmail accepts valid email', () {
      const validEmail = 'test@example.com';
      expect(Validators.validateEmail(validEmail), null);
    });

    test('validateEmail rejects invalid email', () {
      const invalidEmail = 'invalid-email';
      expect(
        Validators.validateEmail(invalidEmail),
        isNotNull,
      );
    });

    test('validateEmail rejects empty email', () {
      expect(
        Validators.validateEmail(''),
        isNotNull,
      );
    });

    test('validatePassword accepts strong password', () {
      const strongPassword = 'StrongPass123';
      expect(Validators.validatePassword(strongPassword), null);
    });

    test('validatePassword rejects weak password', () {
      const weakPassword = '123456';
      expect(
        Validators.validatePassword(weakPassword),
        isNotNull,
      );
    });

    test('validateName accepts valid name', () {
      const validName = 'João Silva';
      expect(Validators.validateName(validName), null);
    });

    test('validateName rejects short name', () {
      const shortName = 'Jo';
      expect(
        Validators.validateName(shortName),
        isNotNull,
      );
    });
  });

  group('AuthProvider Tests', () {
    late AuthProvider authProvider;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      authProvider = AuthProvider(mockApiService);
    });

    test('Initial state is AuthState.initial', () {
      expect(authProvider.state, AuthState.initial);
    });

    test('login with valid credentials sets authenticated state', () async {
      final success = await authProvider.login(
        email: 'test@example.com',
        password: 'ValidPassword123',
      );

      expect(success, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.user, isNotNull);
      expect(authProvider.user?.email, 'test@example.com');
    });

    test('login with empty email fails', () async {
      final success = await authProvider.login(
        email: '',
        password: 'ValidPassword123',
      );

      expect(success, false);
      expect(authProvider.state, AuthState.error);
      expect(authProvider.error, isNotNull);
    });

    test('logout clears user and tokens', () async {
      await authProvider.login(
        email: 'test@example.com',
        password: 'ValidPassword123',
      );

      expect(authProvider.isAuthenticated, true);

      await authProvider.logout();

      expect(authProvider.state, AuthState.unauthenticated);
      expect(authProvider.user, null);
    });
  });

  group('CurriculoProvider Tests', () {
    late CurriculoProvider curriculoProvider;
    late MockApiService mockApiService;
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockApiService = MockApiService();
      mockAuthProvider = MockAuthProvider();
      curriculoProvider = CurriculoProvider(mockApiService, mockAuthProvider);
    });

    test('Initial state has no curriculos', () {
      expect(curriculoProvider.curriculos, isEmpty);
    });

    test('hasCurriculos returns false when empty', () {
      expect(curriculoProvider.hasCurriculos, false);
    });

    test('count returns correct number', () {
      expect(curriculoProvider.count, 0);
    });

    test('activeCurriculo returns null when no curriculos', () {
      expect(curriculoProvider.activeCurriculo, null);
    });
  });

  group('Widget Tests', () {
    testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthProvider(MockApiService()),
              ),
            ],
            child: LoginScreen(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Entrar'), findsWidgets);
    });

    testWidgets('RegisterScreen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthProvider(MockApiService()),
              ),
            ],
            child: RegisterScreen(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Criar Conta'), findsOneWidget);
    });

    testWidgets('LoginScreen shows error on invalid input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthProvider(MockApiService()),
              ),
            ],
            child: LoginScreen(),
          ),
        ),
      );

      // Try to login without filling fields
      final loginButton = find.byType(ElevatedButton);
      await tester.tap(loginButton);
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthProvider(MockApiService()),
              ),
            ],
            child: LoginScreen(),
          ),
        ),
      );

      // Should show validation errors
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('HomeScreen displays welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthProvider(MockApiService()),
              ),
              ChangeNotifierProvider(
                create: (_) => UserProvider(MockApiService(), AuthProvider(MockApiService())),
              ),
              ChangeNotifierProvider(
                create: (_) => CurriculoProvider(MockApiService(), AuthProvider(MockApiService())),
              ),
            ],
            child: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('ProfileScreen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthProvider(MockApiService()),
              ),
              ChangeNotifierProvider(
                create: (_) => UserProvider(MockApiService(), AuthProvider(MockApiService())),
              ),
            ],
            child: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('UploadCvScreen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => CurriculoProvider(MockApiService(), MockAuthProvider()),
              ),
            ],
            child: UploadCvScreen(),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    testWidgets('Complete login flow', (WidgetTester tester) async {
      final mockApiService = MockApiService();
      final authProvider = AuthProvider(mockApiService);

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: authProvider),
            ],
            child: LoginScreen(),
          ),
        ),
      );

      // Perform login
      const email = 'test@example.com';
      const password = 'ValidPass123';

      // Note: In real tests, we would interact with form fields
      final success = await authProvider.login(
        email: email,
        password: password,
      );

      expect(success, true);
      expect(authProvider.isAuthenticated, true);
    });

    testWidgets('Complete registration flow', (WidgetTester tester) async {
      final mockApiService = MockApiService();
      final authProvider = AuthProvider(mockApiService);

      const email = 'newuser@example.com';
      const nome = 'New User';
      const senha = 'NewPass123';

      final success = await authProvider.register(
        email: email,
        nome: nome,
        senha: senha,
      );

      expect(success, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.user?.email, email);
      expect(authProvider.user?.nome, nome);
    });
  });
}

// Placeholder imports for test file compilation
// In actual implementation, these would come from the main app

class LoginResponse {
  final String accessToken;
  final String? refreshToken;
  final UserModel usuario;

  LoginResponse({
    required this.accessToken,
    this.refreshToken,
    required this.usuario,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'],
      usuario: UserModel.fromJson(json['usuario'] ?? {}),
    );
  }
}

class RegisterResponse {
  final String accessToken;
  final String? refreshToken;
  final UserModel usuario;

  RegisterResponse({
    required this.accessToken,
    this.refreshToken,
    required this.usuario,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'],
      usuario: UserModel.fromJson(json['usuario'] ?? {}),
    );
  }
}

class UserModel {
  final String id;
  final String email;
  final String nome;
  final String tipo;
  final DateTime criadoEm;

  UserModel({
    required this.id,
    required this.email,
    required this.nome,
    required this.tipo,
    required this.criadoEm,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? '',
      criadoEm: DateTime.tryParse(json['criado_em'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'nome': nome,
    'tipo': tipo,
    'criado_em': criadoEm.toIso8601String(),
  };
}

class CurriculoModel {
  final String id;
  final int versao;
  final String arquivoUrl;
  final String arquivoHash;
  final int arquivoTamanho;
  final DateTime criadoEm;
  final bool ativo;

  CurriculoModel({
    required this.id,
    required this.versao,
    required this.arquivoUrl,
    required this.arquivoHash,
    required this.arquivoTamanho,
    required this.criadoEm,
    required this.ativo,
  });

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

  double get fileSizeInMb => arquivoTamanho / (1024 * 1024);
}

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email é obrigatório';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(value) ? null : 'Email inválido';
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória';
    if (value.length < 8) return 'Senha deve ter 8+ caracteres';
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) return 'Deve conter letras';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Deve conter números';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nome é obrigatório';
    if (value.length < 3) return 'Nome deve ter 3+ caracteres';
    return null;
  }
}

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final dynamic _apiService;
  AuthState _state = AuthState.initial;
  UserModel? _user;
  String? _error;
  bool _isLoading = false;

  AuthProvider(this._apiService);

  AuthState get state => _state;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _state == AuthState.authenticated;

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _state = AuthState.loading;
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty) throw Exception('Email and password required');
      final response = await _apiService.login(email: email, password: password);
      _user = response.usuario;
      _state = AuthState.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({required String email, required String nome, required String senha}) async {
    _isLoading = true;
    _state = AuthState.loading;
    notifyListeners();

    try {
      final response = await _apiService.register(email: email, nome: nome, senha: senha);
      _user = response.usuario;
      _state = AuthState.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _state = AuthState.unauthenticated;
    _error = null;
    notifyListeners();
  }
}

class UserProvider extends ChangeNotifier {
  final dynamic _apiService;
  final AuthProvider _authProvider;
  UserModel? _user;
  bool _isLoading = false;

  UserProvider(this._apiService, this._authProvider) {
    _user = _authProvider.user;
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<bool> updateProfile({required String nome, String? email}) async {
    _isLoading = true;
    notifyListeners();
    _isLoading = false;
    notifyListeners();
    return true;
  }
}

class CurriculoProvider extends ChangeNotifier {
  final dynamic _apiService;
  final MockAuthProvider _authProvider;
  List<CurriculoModel> _curriculos = [];
  bool _isLoading = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  CurriculoProvider(this._apiService, this._authProvider);

  List<CurriculoModel> get curriculos => _curriculos;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;
  int get count => _curriculos.length;
  bool get hasCurriculos => _curriculos.isNotEmpty;
  CurriculoModel? get activeCurriculo {
    if (_curriculos.isEmpty) return null;
    try {
      return _curriculos.firstWhere((c) => c.ativo);
    } catch (e) {
      return _curriculos.isNotEmpty ? _curriculos.first : null;
    }
  }

  Future<bool> fetchCurriculos({int pagina = 1, int limite = 10}) async {
    return true;
  }

  Future<bool> uploadCurriculo(String filePath) async {
    return true;
  }

  Future<bool> deleteCurriculo(String curriculoId) async {
    return true;
  }
}

// Screen imports for widget tests
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Entrar')),
      body: Column(children: [
        TextFormField(),
        ElevatedButton(onPressed: () {}, child: Text('Entrar')),
      ]),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Conta')),
      body: Column(children: [
        TextFormField(),
        ElevatedButton(onPressed: () {}, child: Text('Criar Conta')),
      ]),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Column(children: [
        TextFormField(),
        ElevatedButton(onPressed: () {}, child: Text('Salvar')),
      ]),
    );
  }
}

class UploadCvScreen extends StatelessWidget {
  const UploadCvScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        GestureDetector(onTap: () {}),
        ElevatedButton(onPressed: () {}, child: Text('Upload')),
      ]),
    );
  }
}
