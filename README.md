# load_vegetables_firestore

A Flutter application for managing a list of vegetables with local storage persistence and file import capabilities.

## Features

### Core Functionality
- **View Vegetables**: Display vegetables in a scrollable list with timestamps and Material Design
- **Add Vegetables**: Add new vegetables through an intuitive dialog interface
- **Edit Vegetables**: Long press on any vegetable to modify its name
- **Delete Vegetables**: Swipe left to delete with confirmation dialog for safety
- **Import from File**: Load vegetables from text files with smart duplicate detection
- **Automatic Timestamps**: Track when vegetables are created and last updated

### Key Highlights
- 📱 Material 3 design with green color scheme
- 👆 Gesture-based UI (swipe to delete, long press to edit)
- 💾 Local persistence using SharedPreferences with JSON storage
- 📁 File picker integration for importing text files
- 🔍 Case-insensitive duplicate detection during import
- ⏰ Automatic timestamp tracking for all vegetables
- 🔄 Seamless data migration from older versions
- ✨ Clean, user-friendly empty state
- 🧭 Declarative routing with GoRouter
- 🌐 Deep linking support for web platform
- 🧪 Comprehensive test coverage (38 tests)

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
1. Long press on any vegetable item
2. Modify the name in the dialog
3. Tap "Save" to update
4. The "Last Updated" timestamp will be automatically updated

### Deleting Vegetables
1. Swipe left on any vegetable item
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
├── main.dart                                          # Application entry point with ProviderScope
├── config/
│   └── app_router.dart                               # GoRouter configuration and routes
└── ui/
    └── vegetable_list/
        ├── models/
        │   ├── vegetable.dart                        # Vegetable model with HarvestState enum
        │   └── vegetable.mapper.dart                 # Generated mapper code
        ├── providers/
        │   └── vegetable_providers.dart              # Riverpod providers and notifiers
        ├── view_model/
        │   └── vegetable_list_view_model.dart        # VegetableService - data layer
        └── widgets/
            ├── vegetable_list_screen.dart            # Main screen (ConsumerWidget)
            ├── vegetables_list_view.dart             # List display widget
            ├── vegetable_list_item.dart              # Individual list item with gestures
            ├── add_vegetable_dialog.dart             # Add dialog
            ├── edit_vegetable_dialog.dart            # Edit dialog
            ├── delete_vegetable_dialog.dart          # Delete confirmation
            └── import_button.dart                     # File import button (ConsumerWidget)

test/
├── widget_test.dart                                   # UI/Widget tests (17 tests)
└── providers/
    └── vegetable_notifier_test.dart                   # Notifier tests (18 tests)
```

The application follows a **feature-based architecture** with **Riverpod state management**. State is managed reactively with AsyncNotifier, providing automatic UI updates, loading states, and error handling.

## Data Format

### Vegetable JSON Structure

Each vegetable is stored as a JSON object with the following structure:

```json
{
  "name": "Carrot",
  "harvestState": "plenty",
  "createdAt": "2025-11-05T14:30:00.000",
  "lastUpdatedAt": "2025-11-06T10:15:30.000"
}
```

**Fields:**
- `name` (String): The vegetable name
- `harvestState` (String): The harvest state - one of `"scarce"`, `"enough"`, or `"plenty"`
- `createdAt` (String): ISO 8601 timestamp of when the vegetable was first added
- `lastUpdatedAt` (String): ISO 8601 timestamp of the last modification

### Storage Format

The complete vegetables list is stored in SharedPreferences as a JSON array:

```json
[
  {
    "name": "Carrot",
    "harvestState": "plenty",
    "createdAt": "2025-11-05T14:30:00.000",
    "lastUpdatedAt": "2025-11-06T10:15:30.000"
  },
  {
    "name": "Tomato",
    "harvestState": "enough",
    "createdAt": "2025-11-05T15:45:00.000",
    "lastUpdatedAt": "2025-11-05T15:45:00.000"
  },
  {
    "name": "Broccoli",
    "harvestState": "scarce",
    "createdAt": "2025-11-04T09:20:00.000",
    "lastUpdatedAt": "2025-11-06T08:30:00.000"
  }
]
```

This JSON structure is handled automatically by the `dart_mappable` package through the generated `VegetableMapper` class. The app includes automatic migration from the legacy `List<String>` format to this new JSON format.

## Dependencies

- `flutter_riverpod: ^3.0.3` - State management solution
- `go_router: ^16.3.0` - Declarative routing and navigation
- `shared_preferences: ^2.3.3` - Local data persistence
- `file_picker: ^10.3.3` - File selection functionality
- `dart_mappable: ^4.2.2` - Model serialization and JSON mapping
- `intl: ^0.19.0` - Date formatting for timestamps
- `flutter_lints: ^6.0.0` - Code quality and linting

## Technical Details

- **Platform Support**: Android, Web
- **Design System**: Material 3
- **Architecture**: Feature-based with component separation
- **State Management**: Riverpod with AsyncNotifier
- **Navigation**: GoRouter with declarative routing and deep linking
- **Data Storage**: SharedPreferences with JSON format (automatic migration from legacy format)
- **Data Model**: dart_mappable classes with automatic serialization
- **UI Interactions**: Gesture-based (swipe to delete, long press to edit)
- **UI Components**: Modular widgets with ConsumerWidget for reactive updates
- **Timestamps**: Automatic tracking of creation and modification times
- **Error Handling**: Comprehensive error states with retry functionality
- **Test Coverage**: 38 tests (18 notifier + 17 widget tests)

## License

See the [LICENSE](LICENSE) file for details.
