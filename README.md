# load_vegetables_firestore

A Flutter application for managing a list of vegetables with local storage persistence and file import capabilities.

## Features

### Core Functionality
- **View Vegetables**: Display vegetables in a scrollable list with Material Design
- **Add Vegetables**: Add new vegetables through an intuitive dialog interface
- **Edit Vegetables**: Modify existing vegetable names with a single tap
- **Delete Vegetables**: Remove vegetables with confirmation dialog for safety
- **Import from File**: Load vegetables from text files with smart duplicate detection

### Key Highlights
- 📱 Material 3 design with green color scheme
- 💾 Local persistence using SharedPreferences
- 📁 File picker integration for importing text files
- 🔍 Case-insensitive duplicate detection during import
- ✨ Clean, user-friendly empty state
- 🧪 Comprehensive test coverage (35 tests)

## Getting Started

### Prerequisites
- Flutter SDK ^3.9.2
- Dart 3.9.2 or higher

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd load_vegetables_firestore
```

2. Install dependencies:
```bash
flutter pub get
flutter pub upgrade --major-versions
```

3. Run the app:
```bash
flutter run                # Run on connected device/emulator
flutter run -d chrome      # Run on Chrome (web)
flutter run -d android     # Run on Android device/emulator
```

## Usage

### Adding Vegetables
1. Tap the floating action button (➕) at the bottom right
2. Enter the vegetable name in the dialog
3. Tap "Add" to save

### Editing Vegetables
1. Tap the edit icon (✏️) on any vegetable item
2. Modify the name in the dialog
3. Tap "Save" to update

### Deleting Vegetables
1. Tap the delete icon (🗑️) on any vegetable item
2. Confirm deletion in the dialog
3. The vegetable will be removed from the list

### Importing from File
1. Tap the upload icon (📤) in the app bar
2. Select a text file from your device
3. The app will import vegetables, skipping duplicates
4. A snackbar will show the import results

**File Format**: One vegetable per line
```
Carrot
Tomato
Broccoli
Cucumber
```

## Development

### Running Tests
```bash
flutter test                    # Run all tests
flutter test --coverage         # Run tests with coverage report
```

### Code Quality
```bash
flutter analyze                 # Static analysis
dart format .                   # Format code
```

### Project Structure
```
lib/
├── main.dart                                          # Application entry point
└── ui/
    └── vegetable_list/
        ├── view_model/
        │   └── vegetable_list_view_model.dart        # VegetableService - business logic
        └── widgets/
            ├── vegetable_list_screen.dart            # Main screen
            ├── vegetables_list_view.dart             # List display widget
            ├── vegetable_list_item.dart              # Individual list item
            ├── add_vegetable_dialog.dart             # Add dialog
            ├── edit_vegetable_dialog.dart            # Edit dialog
            ├── delete_vegetable_dialog.dart          # Delete confirmation
            └── import_button.dart                     # File import button

test/
├── widget_test.dart                                   # UI/Widget tests (17 tests)
└── services/
    └── vegetable_service_test.dart                    # Unit tests (18 tests)
```

The application follows a **feature-based architecture** with modular, reusable components. UI widgets are separated from business logic, promoting maintainability and testability.

## Dependencies

- `shared_preferences: ^2.3.3` - Local data persistence
- `file_picker: ^10.3.3` - File selection functionality
- `flutter_lints: ^6.0.0` - Code quality and linting

## Technical Details

- **Platform Support**: Android, Web
- **Design System**: Material 3
- **Architecture**: Feature-based with component separation
- **State Management**: StatefulWidget with local state
- **Data Storage**: SharedPreferences (key-value store)
- **UI Components**: Modular widgets for reusability and maintainability
- **Test Coverage**: 35 tests (18 unit + 17 widget tests)

## License

See the [LICENSE](LICENSE) file for details.
