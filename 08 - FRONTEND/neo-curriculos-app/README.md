# Neo Currículos - Flutter App

Mobile application for CV submission - iOS & Android.

## Overview

Neo Currículos App is a Flutter-based mobile application that enables candidates to register, manage their profiles, and submit CVs through an intuitive interface. The app integrates with the Neo Currículos API backend and includes LGPD compliance features.

**Status:** Production Ready  
**Version:** 1.0.0  
**Platforms:** iOS 14+, Android 21+

## Features

- **Authentication:** Register & Login with JWT tokens
- **Profile Management:** Edit user profile information
- **CV Management:** Upload, view, and manage multiple CV versions
- **LGPD Compliance:** User consent management for data processing
- **Offline Support:** Local caching with SharedPreferences
- **Security:** Secure token storage using platform keychain/keystore
- **Responsive UI:** Optimized for all device sizes
- **Dark Mode:** Material Design 3 with dark mode support

## Tech Stack

- **Framework:** Flutter 3.16+
- **Language:** Dart 3.2+
- **State Management:** Provider 6.0+
- **HTTP Client:** Dio 5.3+
- **Storage:** SharedPreferences, FlutterSecureStorage
- **Testing:** Flutter Test, Mockito
- **UI:** Material Design 3, GoogleFonts

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── config/                      # Configuration files
│   ├── app_config.dart         # App constants
│   ├── theme.dart              # UI theme
│   └── routes.dart             # Navigation
├── models/                      # Data models
│   └── models.dart             # User, CV, Response models
├── services/                    # Business logic
│   └── api_service.dart        # API client with Dio
├── providers/                   # State management
│   ├── auth_provider.dart      # Authentication state
│   ├── user_provider.dart      # User profile state
│   └── curriculo_provider.dart # CV management state
├── screens/                     # UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   ├── upload_cv_screen.dart
│   ├── cv_history_screen.dart
│   ├── cv_viewer_screen.dart
│   └── lgpd_consent_screen.dart
├── widgets/                     # Reusable widgets
└── utils/                       # Utilities
    ├── validators.dart
    ├── constants.dart
    ├── logger_setup.dart
    └── extensions.dart
```

## Getting Started

### Prerequisites

- Flutter 3.16+ (install from [flutter.dev](https://flutter.dev))
- Dart SDK 3.2+
- Xcode 14+ (for iOS)
- Android Studio 2023.1+ (for Android)

### Installation

1. **Clone Repository**
   ```bash
   git clone <repo-url>
   cd neo-curriculos-app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   flutter pub upgrade
   ```

3. **Verify Setup**
   ```bash
   flutter doctor
   ```

### Running the App

**Debug Mode**
```bash
# Run on all available devices
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

**Release Mode**
```bash
# iOS
flutter run --release -d ios

# Android
flutter run --release -d android
```

## Building for Distribution

### Android APK/App Bundle

```bash
# Generate APK
flutter build apk --release

# Generate App Bundle (for Play Store)
flutter build appbundle --release

# Output locations:
# APK: build/app/outputs/apk/release/app-release.apk
# Bundle: build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA

```bash
# Build for physical device
flutter build ios --release

# Archive in Xcode
open ios/Runner.xcworkspace
# Product → Archive

# Or use xcodebuild
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build \
  -allowProvisioningUpdates
```

## Testing

### Run Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/app_test.dart

# Watch mode
flutter test --watch

# With coverage
flutter test --coverage
```

### Test Coverage
```bash
flutter test --coverage

# View coverage report (macOS)
open coverage/index.html
```

### Integration Tests
```bash
flutter drive --target=integration_test/app_test.dart
```

## Configuration

### Environment Variables

Create `.env.dev` and `.env.prod` files:

```env
# .env.prod
API_BASE_URL=https://api.neocurriculos.com
API_TIMEOUT=30
LOG_LEVEL=error
```

### Theme Customization

Edit `lib/config/theme.dart` to customize colors, fonts, and UI elements.

### API Configuration

Modify `lib/config/app_config.dart` to change:
- API base URL
- Request timeouts
- File upload limits
- LGPD settings

## API Integration

The app connects to the Neo Currículos API with the following endpoints:

### Authentication
- `POST /api/auth/registrar` - Register new user
- `POST /api/auth/login` - User login
- `POST /api/auth/refresh` - Refresh JWT token
- `POST /api/auth/logout` - Logout user

### Curriculum
- `POST /api/curriculos/upload` - Upload CV
- `GET /api/candidatos/curriculos` - List user CVs
- `DELETE /api/curriculos/{id}` - Delete CV

### User Profile
- `GET /api/candidatos/perfil` - Get profile
- `POST /api/candidatos/perfil` - Update profile

### LGPD
- `POST /api/candidatos/consentimento` - Record consent
- `DELETE /api/candidatos/deletar-conta` - Delete account

## Security

### Token Management
- Access tokens stored in platform keychain (iOS) or Keystore (Android)
- Automatic token refresh on 401 responses
- Secure storage using `flutter_secure_storage`

### HTTPS Only
- All API communications use HTTPS
- Certificate pinning ready (configure in `api_service.dart`)

### LGPD Compliance
- Explicit user consent required before using app
- Data deletion capability implemented
- Privacy policy acceptance tracked

## Performance

### Build Size
- APK: ~45-55 MB (release, single ABI)
- IPA: ~60-70 MB (release)

### Performance Targets
- Startup time: < 2 seconds
- Frame rate: 60 FPS (smooth animations)
- Memory usage: < 100 MB (typical)

### Optimization Tips
```bash
# Shrink APK size
flutter build apk --split-per-abi --release

# Profile app performance
flutter run --profile

# Analyze bundle
flutter pub global activate devtools
dart devtools
```

## Debugging

### Enable Logging
```dart
// In main.dart
setupLogger();

// In any file
final logger = Logger();
logger.i('Info message');
logger.e('Error message', error: error);
```

### Debug Console
```bash
# Show all logs
flutter run -v

# Run app with debugger
flutter run
# Press 'D' to dump widget tree
# Press 'L' to dump layer tree
```

### Network Debugging
Dio logging is enabled automatically. Check logs for all HTTP requests/responses.

## Troubleshooting

### Common Issues

**"Flutter SDK not found"**
```bash
export PATH="$PATH:$HOME/flutter/bin"
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
```

**"Gradle build fails"**
```bash
flutter clean
rm -rf android/.gradle
flutter pub get
flutter run
```

**"Pod install fails on macOS"**
```bash
cd ios
rm Podfile.lock
pod repo update
pod install
cd ..
```

**"App crashes on startup"**
```bash
# Check logs
flutter logs

# Rebuild clean
flutter clean
flutter pub get
flutter run
```

## Contributing

1. Create feature branch: `git checkout -b feature/amazing-feature`
2. Commit changes: `git commit -m 'feat: add amazing feature'`
3. Push to branch: `git push origin feature/amazing-feature`
4. Create Pull Request

### Code Style
- Use meaningful variable names
- Follow Dart conventions (camelCase for variables/functions)
- Add comments for complex logic
- Format code: `dart format lib/`
- Analyze: `dart analyze`

## Deployment

### Play Store
1. Create Google Play Developer account
2. Generate app signing key
3. Build App Bundle: `flutter build appbundle --release`
4. Upload to Play Store Console
5. Fill app details and screenshots
6. Submit for review

### App Store
1. Create Apple Developer account
2. Create App ID and certificates in Developer Portal
3. Build IPA: `flutter build ios --release`
4. Archive and export in Xcode
5. Upload to App Store Connect using Transporter
6. Fill app information and submit for review

### TestFlight
```bash
# Build for TestFlight
flutter build ios --release

# Archive in Xcode and upload
open ios/Runner.xcworkspace
# Product → Archive
# Export and upload to TestFlight
```

## Support & Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [API Documentation](../07%20-%20BACKEND/README.md)

## License

Proprietary - Neo Currículos Platform

## Changelog

### Version 1.0.0 (Initial Release)
- ✅ User authentication (register, login, logout)
- ✅ Profile management
- ✅ CV upload and management
- ✅ CV history and viewer
- ✅ LGPD consent screen
- ✅ Material Design 3 UI
- ✅ Dark mode support
- ✅ Comprehensive testing

---

**Last Updated:** September 2026  
**Maintainers:** Neo Currículos Team
