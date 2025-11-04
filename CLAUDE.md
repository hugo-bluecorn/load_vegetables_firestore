# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application named `load_vegetables_firestore` designed to work with Firebase/Firestore. The project uses Flutter SDK ^3.9.2 and targets multiple platforms (Android, Web).

## Development Commands

### Setup
```bash
flutter pub get                    # Install dependencies
```

### Running the Application
```bash
flutter run                        # Run on connected device/emulator
flutter run -d chrome              # Run on Chrome (web)
flutter run -d android             # Run on Android device/emulator
```

### Building
```bash
flutter build apk                  # Build Android APK
flutter build appbundle            # Build Android App Bundle
flutter build web                  # Build for web deployment
```

### Testing
```bash
flutter test                       # Run all tests
flutter test test/path/to/test.dart  # Run specific test file
```

### Code Quality
```bash
flutter analyze                    # Run static analysis
dart format .                      # Format all Dart files
dart format lib/                   # Format only lib directory
```

### Cleaning
```bash
flutter clean                      # Clean build artifacts
flutter pub get                    # Reinstall dependencies after clean
```

## Architecture

### Project Structure
- `lib/` - Main application source code
  - `main.dart` - Application entry point with MaterialApp setup
- `android/` - Android-specific configuration
- `web/` - Web-specific assets and configuration
- `build/` - Generated build artifacts (git-ignored)

### Firebase Integration
The project is configured to use Firebase. Critical Firebase configuration files are git-ignored for security:
- `firebase.json`
- `android/app/google-services.json`
- `lib/firebase_options.dart`
- `web/firebase-messaging-sw.js`
- iOS/macOS: `GoogleService-Info.plist`
- Windows: `google-services.json`

**Important**: When setting up Firebase, these files must be obtained from the Firebase Console and placed in the appropriate directories. Never commit these files to version control.

### Linting
The project uses `flutter_lints` (^5.0.0) with the standard Flutter linting rules from `package:flutter_lints/flutter.yaml`.

## Platform Support
Currently configured for:
- Android (using Gradle with Kotlin DSL)
- Web (with PWA manifest support)

The app uses Material Design (`uses-material-design: true` in pubspec.yaml).
- Always run 'flutter pub upgrade --major-versions' after running 'flutter pub get'
- Always ask to update @CHANGLOG.md and @README.md before a git push