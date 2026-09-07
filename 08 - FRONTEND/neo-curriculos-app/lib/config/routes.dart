import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/upload_cv_screen.dart';
import '../screens/cv_history_screen.dart';
import '../screens/cv_viewer_screen.dart';
import '../screens/lgpd_consent_screen.dart';

/// Application routes
class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String uploadCv = '/upload-cv';
  static const String cvHistory = '/cv-history';
  static const String cvViewer = '/cv-viewer';
  static const String lgpdConsent = '/lgpd-consent';

  /// Generate routes based on route name
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case uploadCv:
        return MaterialPageRoute(builder: (_) => const UploadCvScreen());

      case cvHistory:
        return MaterialPageRoute(builder: (_) => const CvHistoryScreen());

      case cvViewer:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CvViewerScreen(
            cvUrl: args?['cvUrl'] ?? '',
            cvTitle: args?['cvTitle'] ?? 'Currículo',
          ),
        );

      case lgpdConsent:
        return MaterialPageRoute(builder: (_) => const LgpdConsentScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Navigate to splash screen
  static Future<void> toSplash(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      splash,
      (route) => false,
    );
  }

  /// Navigate to login screen
  static Future<void> toLogin(BuildContext context) {
    return Navigator.pushNamed(context, login);
  }

  /// Navigate to register screen
  static Future<void> toRegister(BuildContext context) {
    return Navigator.pushNamed(context, register);
  }

  /// Navigate to home screen
  static Future<void> toHome(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      home,
      (route) => false,
    );
  }

  /// Navigate to profile screen
  static Future<void> toProfile(BuildContext context) {
    return Navigator.pushNamed(context, profile);
  }

  /// Navigate to upload CV screen
  static Future<void> toUploadCv(BuildContext context) {
    return Navigator.pushNamed(context, uploadCv);
  }

  /// Navigate to CV history screen
  static Future<void> toCvHistory(BuildContext context) {
    return Navigator.pushNamed(context, cvHistory);
  }

  /// Navigate to CV viewer screen
  static Future<void> toCvViewer(
    BuildContext context, {
    required String cvUrl,
    required String cvTitle,
  }) {
    return Navigator.pushNamed(
      context,
      cvViewer,
      arguments: {
        'cvUrl': cvUrl,
        'cvTitle': cvTitle,
      },
    );
  }

  /// Navigate to LGPD consent screen
  static Future<void> toLgpdConsent(BuildContext context) {
    return Navigator.pushNamed(context, lgpdConsent);
  }

  /// Navigate back
  static void back(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
