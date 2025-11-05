# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application for managing a vegetables list with local storage persistence. Despite the name `load_vegetables_firestore`, the app currently uses SharedPreferences for local storage (not Firebase/Firestore). The project uses Flutter SDK ^3.9.2 and targets multiple platforms (Android, Web).

### Current Features
- Full CRUD operations for vegetables (Create, Read, Update, Delete)
- Local data persistence using SharedPreferences
- File import from text files with duplicate detection
- Material 3 UI with dialogs for user interactions

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
flutter test                       # Run all tests (35 tests total)
flutter test --coverage            # Run tests with coverage report
flutter test test/services/vegetable_service_test.dart  # Run unit tests only
flutter test test/widget_test.dart # Run widget tests only
```

**Test Structure:**
- `test/services/vegetable_service_test.dart` - 18 unit tests for VegetableService
- `test/widget_test.dart` - 17 widget tests for UI functionality
- Tests use `SharedPreferences.setMockInitialValues()` for isolated testing
- Coverage reports generated in `coverage/lcov.info`

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
```
lib/
├── main.dart                                          # Application entry point
└── ui/
    └── vegetable_list/
        ├── view_model/
        │   └── vegetable_list_view_model.dart        # VegetableService - business logic
        └── widgets/
            ├── vegetable_list_screen.dart            # Main screen (StatefulWidget)
            ├── vegetables_list_view.dart             # List display widget
            ├── vegetable_list_item.dart              # Individual list item
            ├── add_vegetable_dialog.dart             # Add dialog
            ├── edit_vegetable_dialog.dart            # Edit dialog
            ├── delete_vegetable_dialog.dart          # Delete confirmation dialog
            └── import_button.dart                     # File import button

test/
├── widget_test.dart                                   # Widget/UI tests (17 tests)
└── services/
    └── vegetable_service_test.dart                    # Unit tests (18 tests)

android/                                               # Android-specific configuration
web/                                                   # Web-specific assets
build/                                                 # Build artifacts (git-ignored)
coverage/                                              # Coverage reports (git-ignored)
```

### Design Patterns
The application follows a **feature-based organization** with separation of concerns:

**UI Layer** (`lib/ui/vegetable_list/widgets/`):
- `VegetableListScreen` - Main container widget managing state
- `VegetablesListView` - Presentation widget for list display
- `VegetableListItem` - Reusable component for each vegetable
- Dialog widgets - Modular, reusable dialogs for user interactions
- `ImportButton` - Self-contained import functionality

**Business Logic** (`lib/ui/vegetable_list/view_model/`):
- `VegetableService` - Handles all CRUD operations and data persistence
- Methods are async and return Futures
- Import functionality includes case-insensitive duplicate detection

### Data Persistence
The app uses SharedPreferences for local storage. All vegetables are stored as a string list under the key `'vegetables'`.

**Service Layer:**
- `VegetableService` provides a clean API for data operations
- All persistence logic is isolated from UI components
- Supports: load, save, add, update, delete, and import operations

### Future Firebase Integration
The project name suggests Firebase/Firestore integration may be planned. Firebase configuration files are git-ignored for security:
- `firebase.json`
- `android/app/google-services.json`
- `lib/firebase_options.dart`
- `web/firebase-messaging-sw.js`
- iOS/macOS: `GoogleService-Info.plist`
- Windows: `google-services.json`

**Note**: These files must be obtained from the Firebase Console and never committed to version control.

### Linting
The project uses `flutter_lints` (^6.0.0) with the standard Flutter linting rules from `package:flutter_lints/flutter.yaml`.

## Platform Support
Currently configured for:
- Android (using Gradle with Kotlin DSL)
- Web (with PWA manifest support)

The app uses Material Design (`uses-material-design: true` in pubspec.yaml).
- Always run 'flutter pub upgrade --major-versions' after running 'flutter pub get'
- Always ask to update @CHANGLOG.md and @README.md before a git push