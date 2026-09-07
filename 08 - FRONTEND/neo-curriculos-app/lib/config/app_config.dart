/// Application configuration constants
class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'https://api.neocurriculos.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration apiRetryDuration = Duration(seconds: 5);
  static const int apiMaxRetries = 3;

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String lgpdConsentKey = 'lgpd_consent';
  static const String firstLaunchKey = 'first_launch';

  // File Configuration
  static const int maxFileSizeMB = 10;
  static const int maxFileSize = maxFileSizeMB * 1024 * 1024; // 10MB
  static const List<String> allowedFileExtensions = ['pdf'];
  static const String mimeTypePdf = 'application/pdf';

  // App Configuration
  static const String appName = 'Neo Currículos';
  static const String appVersion = '1.0.0';
  static const String appBuild = '1';

  // LGPD Configuration
  static const String lgpdTermsVersion = '1.0';
  static const bool lgpdConsentRequired = true;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 100;
  static const int maxEmailLength = 254;

  // Timeouts (milliseconds)
  static const int splashScreenDuration = 2000;
  static const int navigationAnimationDuration = 300;
  static const int loadingMinDuration = 500; // Minimum time to show loading state

  // UI
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
}

/// Environment configuration
enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment currentEnvironment = Environment.production;

  static String getApiUrl() {
    switch (currentEnvironment) {
      case Environment.development:
        return 'https://api.dev.neocurriculos.com';
      case Environment.staging:
        return 'https://api.staging.neocurriculos.com';
      case Environment.production:
        return 'https://api.neocurriculos.com';
    }
  }

  static bool isProduction() => currentEnvironment == Environment.production;
  static bool isStaging() => currentEnvironment == Environment.staging;
  static bool isDevelopment() => currentEnvironment == Environment.development;
}
