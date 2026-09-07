import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/curriculo_provider.dart';
import 'utils/logger_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogger();
  runApp(const NeoCurriculosApp());
}

class NeoCurriculosApp extends StatelessWidget {
  const NeoCurriculosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => apiService),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(
            apiService,
            context.read<AuthProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CurriculoProvider(
            apiService,
            context.read<AuthProvider>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Neo Currículos',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}
