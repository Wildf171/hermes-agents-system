# FLUTTER PROJECT SETUP - Neo Currículos App

**Versão:** 1.0  
**Data:** Setembro 2026  
**Plataformas:** iOS (14+) + Android (API 21+)  
**Flutter Version:** 3.16+

## 1. Pré-requisitos

### Sistema Operacional
- **macOS 12+** (para build iOS) ou **Windows 10/11** (Android apenas)
- **Xcode 14+** (macOS) para desenvolvimento iOS
- **Android Studio 2023.1+** para desenvolvimento Android

### Software Obrigatório
```bash
# Flutter SDK 3.16+
# Download: https://flutter.dev/docs/get-started/install

# Verificar instalação
flutter --version
dart --version

# Verificar ambiente
flutter doctor
```

### Dependências Adicionais
- **CocoaPods 1.14+** (macOS) - para dependências iOS
- **Java JDK 11+** - para Android
- **Git** - para controle de versão
- **VS Code** ou **Android Studio** - IDE

## 2. Criar Projeto Flutter

### Opção A: Novo Projeto (Fresh Start)
```bash
# Criar projeto
flutter create neo_curriculos_app
cd neo_curriculos_app

# Atualizar pubspec.yaml com dependências
# (veja seção 3 abaixo)

# Testar setup
flutter pub get
flutter run
```

### Opção B: Clonar Repositório
```bash
git clone <repo-url> neo-curriculos-app
cd neo-curriculos-app

# Setup
flutter pub get
flutter run
```

## 3. Dependências (pubspec.yaml)

### Configuration
```yaml
name: neo_curriculos_app
description: Aplicativo Flutter para envio de currículos - Neo Currículos
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'
```

### Dependencies Core
```yaml
dependencies:
  flutter:
    sdk: flutter

  # HTTP Client & API Communication
  dio: ^5.3.0
  pretty_dio_logger: ^1.3.1
  
  # State Management
  provider: ^6.0.0
  
  # Local Storage
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0
  
  # File Handling
  file_picker: ^5.3.0
  permission_handler: ^11.4.0
  
  # PDF Rendering
  pdfx: ^2.5.0
  
  # UI Components
  flutter_svg: ^2.0.0
  google_fonts: ^6.1.0
  
  # Form Validation
  formz: ^0.5.0
  
  # Date & Time
  intl: ^0.19.0
  
  # Logging
  logger: ^2.0.0
  
  # Connectivity
  connectivity_plus: ^5.0.0
  
  # Error Handling
  fimber: ^0.7.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Linting
  flutter_lints: ^3.0.0
  
  # Testing
  mockito: ^5.4.0
  mocktail: ^1.0.0
  
  # Build Helpers
  build_runner: ^2.4.0
```

### Flutter Assets
```yaml
flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
  
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
        - asset: assets/fonts/Poppins-Light.ttf
          weight: 300
```

## 4. Estrutura de Projeto

```
neo_curriculos_app/
│
├── .dart_tool/                          (Generated)
├── .idea/                               (IDE config)
├── android/                             (Android native config)
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/
│   └── local.properties
│
├── ios/                                 (iOS native config)
│   ├── Podfile
│   ├── Podfile.lock
│   └── Runner.xcworkspace
│
├── lib/
│   ├── main.dart                        (Entry point - MUST BE CONCISE)
│   │
│   ├── config/
│   │   ├── app_config.dart              (Constants, URLs)
│   │   ├── theme.dart                   (Material Theme, Colors)
│   │   ├── routes.dart                  (Navigation routes)
│   │   └── di_container.dart            (Dependency injection setup)
│   │
│   ├── models/
│   │   ├── 36_MODELS.dart               (User, Curriculo, Responses)
│   │   ├── exceptions.dart              (Custom exceptions)
│   │   └── page_state.dart              (Generic state wrapper)
│   │
│   ├── services/
│   │   ├── 26_API_SERVICE.dart          (Dio client + interceptors)
│   │   ├── auth_service.dart            (Token management)
│   │   ├── storage_service.dart         (SharedPreferences wrapper)
│   │   ├── file_service.dart            (File operations)
│   │   └── connectivity_service.dart    (Network monitoring)
│   │
│   ├── providers/
│   │   ├── 27_AUTH_PROVIDER.dart        (Auth state - ChangeNotifier)
│   │   ├── user_provider.dart           (User profile state)
│   │   ├── curriculo_provider.dart      (CV management state)
│   │   └── app_provider.dart            (Global app state)
│   │
│   ├── screens/
│   │   ├── 28_SPLASH_SCREEN.dart        (Splash + Onboarding)
│   │   ├── 29_LOGIN_SCREEN.dart         (Login form)
│   │   ├── 30_REGISTER_SCREEN.dart      (Registration form)
│   │   ├── 31_HOME_SCREEN.dart          (Dashboard)
│   │   ├── 32_UPLOAD_CV_SCREEN.dart     (File picker + upload)
│   │   ├── 33_CV_HISTORY_SCREEN.dart    (List previous CVs)
│   │   ├── 34_CV_VIEWER_SCREEN.dart     (PDF preview)
│   │   └── 35_LGPD_CONSENT_SCREEN.dart  (LGPD compliance)
│   │
│   ├── widgets/
│   │   ├── buttons/
│   │   │   ├── primary_button.dart
│   │   │   ├── secondary_button.dart
│   │   │   └── icon_button.dart
│   │   ├── forms/
│   │   │   ├── text_input_field.dart
│   │   │   ├── password_field.dart
│   │   │   └── checkbox_field.dart
│   │   ├── cards/
│   │   │   ├── cv_card.dart
│   │   │   ├── info_card.dart
│   │   │   └── error_card.dart
│   │   ├── dialogs/
│   │   │   ├── confirmation_dialog.dart
│   │   │   ├── error_dialog.dart
│   │   │   └── loading_dialog.dart
│   │   ├── loaders/
│   │   │   ├── loading_widget.dart
│   │   │   └── skeleton_loader.dart
│   │   └── app_bar.dart
│   │
│   └── utils/
│       ├── validators.dart              (Form validation logic)
│       ├── extensions.dart              (String, DateTime extensions)
│       ├── constants.dart               (App-wide constants)
│       ├── logger_setup.dart            (Logging configuration)
│       └── error_handler.dart           (Centralized error handling)
│
├── test/
│   ├── 37_TESTS_FLUTTER.dart            (Unit + Widget tests)
│   ├── mocks/
│   │   ├── mock_api_service.dart
│   │   ├── mock_auth_provider.dart
│   │   └── mock_storage_service.dart
│   └── fixtures/
│       └── test_data.dart
│
├── integration_test/
│   ├── app_test.dart                    (E2E tests)
│   └── auth_flow_test.dart
│
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   └── splash_bg.png
│   ├── icons/
│   │   ├── ic_upload.svg
│   │   └── ic_history.svg
│   └── fonts/
│       └── Poppins-*.ttf
│
├── 25_FLUTTER_PROJECT_SETUP.md          (This file)
├── pubspec.yaml                          (Dependencies)
├── pubspec.lock                          (Lock file)
├── analysis_options.yaml                 (Linting rules)
├── README.md                             (Project documentation)
└── .gitignore                            (Git ignore patterns)
```

## 5. Configuração por Plataforma

### iOS Setup (macOS)

```bash
# Navigate to iOS directory
cd ios

# Install pods
pod install
pod repo update

# Back to project root
cd ..

# Configure iOS deployment target
# Edit ios/Podfile:
platform :ios, '14.0'  # Minimum iOS 14
```

**Xcode Configuration:**
1. Abrir `ios/Runner.xcworkspace` (NÃO `.xcodeproj`)
2. Selecionar "Runner" target
3. General → Minimum Deployments = iOS 14.0
4. Signing & Capabilities → Add Team ID
5. Build → Build for Any iOS Device

### Android Setup

```bash
# Verify Android SDK
flutter doctor -v

# Configure Android SDK path in local.properties
# (Usually automatic if Android Studio is installed)

# Update minSdkVersion in android/app/build.gradle
android {
  compileSdkVersion 34
  
  defaultConfig {
    minSdkVersion 21
    targetSdkVersion 34
  }
}
```

**Permissions (AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## 6. Build & Run Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run debug build (iOS)
flutter run -d <device-name>

# Run debug build (Android)
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=integration_test/app_test.dart

# Run specific test file
flutter test test/37_TESTS_FLUTTER.dart
```

### Build Release

#### Android
```bash
# Generate APK
flutter build apk --release

# Generate App Bundle (for Google Play)
flutter build appbundle --release

# Output: build/app/outputs/apk/release/app-release.apk
```

#### iOS
```bash
# Build IPA
flutter build ios --release

# Archive & export
open ios/Runner.xcworkspace
# Product → Archive
# Distribute App

# Or use xcodebuild:
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build \
  -allowProvisioningUpdates
```

### Size & Performance
```bash
# Check APK/IPA size
flutter build apk --split-per-abi --release

# Analyze bundle
flutter pub global activate devtools
dart devtools

# Profile app
flutter run --profile

# Run Lighthouse audit
flutter pub global activate flutter_web_tester
```

## 7. Configuration Files

### .gitignore
```
# Flutter build files
build/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
pubspec.lock

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Sensitive
.env
.env.local
```

### analysis_options.yaml
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - avoid_empty_else
    - avoid_print
    - avoid_relative_lib_imports
    - avoid_returning_null_for_future
    - avoid_slow_async_io
    - cancel_subscriptions
    - close_sinks
    - comment_references
    - control_flow_in_finally
    - empty_statements
    - hash_and_equals
    - invariant_booleans
    - iterable_contains_unrelated_type
    - list_remove_unrelated_type
    - literal_only_boolean_expressions
    - no_adjacent_strings_in_list
    - no_duplicate_case_values
    - prefer_void_to_null
    - throw_in_finally
    - unnecessary_statements
    - unrelated_type_equality_checks
```

## 8. Environment Configuration

### Development (.env.dev)
```
API_BASE_URL=https://api.dev.neocurriculos.com
API_TIMEOUT=30
LOG_LEVEL=debug
ENABLE_LOGGING=true
```

### Production (.env.prod)
```
API_BASE_URL=https://api.neocurriculos.com
API_TIMEOUT=30
LOG_LEVEL=error
ENABLE_LOGGING=false
```

**Load in main.dart:**
```dart
// Use package:flutter_dotenv for environment configuration
void main() async {
  await dotenv.load(fileName: ".env.${const String.fromEnvironment('FLAVOR')}");
  runApp(const NeoCurriculosApp());
}
```

## 9. IDE Setup

### VS Code
**Install Extensions:**
- Flutter (Dart Code)
- Dart (Dart Code)
- REST Client (Huachao Mao)
- JSON to Dart Model (Bruce (builttoroam))

**settings.json:**
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.devToolsLocation": "sidebar",
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "Dart-Code.dart-code"
  }
}
```

### Android Studio
1. Install Flutter & Dart plugins
2. Open project folder
3. Flutter -> Get Dependencies
4. Run on emulator or device

### Xcode (macOS)
1. Open `ios/Runner.xcworkspace`
2. Select Runner target
3. Configure signing
4. Run (Cmd+R)

## 10. Troubleshooting

### Common Issues

**"Flutter SDK not found"**
```bash
# Set PATH
export PATH="$PATH:/path/to/flutter/bin"
# Add to ~/.bashrc or ~/.zshrc for persistence
```

**"Pod install" fails**
```bash
cd ios
rm Podfile.lock
pod repo update
pod install
cd ..
```

**"Gradle sync failed"**
```bash
# Clear Gradle cache
rm -rf ~/.gradle/caches/
flutter clean
flutter pub get
```

**APK too large (>50MB)**
```bash
# Use split per ABI
flutter build apk --split-per-abi --release

# Enable ProGuard/R8
# android/app/build.gradle: minifyEnabled true
```

**iOS build fails on M1/M2 Mac**
```bash
# Run Flutter doctor
flutter doctor

# Add to Podfile:
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
      ]
    end
  end
end
```

## 11. Development Workflow

### Daily Development
```bash
# 1. Pull latest changes
git pull origin develop

# 2. Get dependencies
flutter pub get

# 3. Run app (hot reload enabled)
flutter run

# 4. Make changes (hot reload automatically reloads)

# 5. Run tests
flutter test

# 6. Commit changes
git add .
git commit -m "feature: implement auth flow"
git push origin feature/auth-flow
```

### Pre-Release Checklist
- [ ] All tests passing (`flutter test`)
- [ ] No lint warnings (`flutter analyze`)
- [ ] Version bumped in `pubspec.yaml`
- [ ] Changelog updated
- [ ] Android & iOS builds successful
- [ ] Tested on physical devices
- [ ] LGPD compliance verified
- [ ] API endpoints verified in staging

## 12. References

- Flutter Docs: https://flutter.dev/docs
- Dart Language: https://dart.dev/guides
- Provider State Management: https://pub.dev/packages/provider
- Dio HTTP Client: https://pub.dev/packages/dio
- Flutter Testing: https://flutter.dev/docs/testing
- Material Design 3: https://m3.material.io

## 13. Team Responsibilities

| Role | Responsibility |
|------|-----------------|
| **Lead Dev** | Architecture, API integration, code review |
| **UI/UX Dev** | Screens, widgets, animations, accessibility |
| **QA** | Testing, bug reporting, device compatibility |
| **DevOps** | CI/CD, builds, distribution (TestFlight, Play Store) |

---

**Status:** Complete & Ready for Development  
**Last Updated:** Setembro 2026  
**Maintainer:** Neo Currículos Team
