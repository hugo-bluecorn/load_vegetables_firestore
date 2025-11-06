# load_vegetables_firestore

A Flutter application for managing a list of vegetables with local storage persistence and file import capabilities.

## Features

### Core Functionality
- **View Vegetables**: Display vegetables in a scrollable list with timestamps and Material Design
- **Tabbed Navigation**: Filter vegetables by harvest state (Plenty, Enough, Scarce) with color-coded tabs
- **Add Vegetables**: Add new vegetables through an intuitive dialog interface
- **Multi-Select Mode**: Long press to enter selection mode with batch operations
- **Edit Vegetables**: Select single item in selection mode or swipe for individual edit
- **Delete Vegetables**: Swipe left for single delete or use batch delete in selection mode
- **Move Vegetables**: Batch update harvest state for multiple vegetables
- **Import from File**: Load vegetables from text files with smart duplicate detection
- **Automatic Timestamps**: Track when vegetables are created and last updated

### Key Highlights
- 📱 Material 3 design with per-tab color themes (Amber, Blue, Purple)
- 👆 Gesture-based UI (swipe to delete, long press for selection mode)
- ✅ Multi-select mode with batch operations (edit, delete, move)
- 🎨 Color-coded harvest state tabs with themed navigation
- 💾 Local persistence using SharedPreferences with JSON storage
- 📁 File picker integration for importing text files
- 🔍 Case-insensitive duplicate detection during import
- ⏰ Automatic timestamp tracking for all vegetables
- 🔄 Seamless data migration from older versions
- ✨ Clean, user-friendly empty state
- 🧭 Declarative routing with GoRouter and StatefulShellRoute
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

### Navigating Between Harvest States
1. Use the bottom navigation bar to switch between tabs
2. Three tabs available: Plenty (🌾), Enough (🌿), Scarce (🌱)
3. Each tab shows only vegetables with that harvest state
4. Each tab has a unique color theme

### Adding Vegetables
1. Tap the floating action button (➕) at the bottom right
2. Enter the vegetable name in the dialog
3. Select harvest state (defaults to current tab)
4. Tap "Add" to save

### Single Item Operations

**Deleting a Single Vegetable:**
1. Swipe left on any vegetable item
2. Confirm deletion in the dialog
3. The vegetable will be removed from the list

### Multi-Select Mode

**Entering Selection Mode:**
1. Long press on any vegetable item
2. The item will be selected (checkmark appears)
3. AppBar changes to show selection count and actions

**Selecting Multiple Items:**
- Tap on items to toggle selection
- Selected items show checkmarks
- Title shows count (e.g., "3 selected")

**Editing a Single Selected Item:**
1. Select exactly one item
2. Tap the edit icon (✏️) in the AppBar
3. Modify the name and/or harvest state
4. Tap "Save" to update

**Deleting Multiple Items:**
1. Select one or more items
2. Tap the delete icon (🗑️) in the AppBar
3. Confirm deletion in the dialog
4. All selected vegetables will be removed

**Moving Multiple Items:**
1. Select one or more items
2. Tap the move icon (📁) in the AppBar
3. Select the target harvest state
4. Tap "Move" to update all selected vegetables

**Exiting Selection Mode:**
- Tap the close icon (X) in the AppBar, or
- Press the back button, or
- Complete an action (edit/delete/move)

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
├── routing/
│   ├── app_router.dart                               # GoRouter configuration and routes
│   └── harvest_state_shell_screen.dart               # Navigation shell with bottom bar
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
            ├── vegetable_list_screen.dart            # Main screen (ConsumerStatefulWidget)
            ├── vegetables_list_view.dart             # List display widget
            ├── vegetable_list_item.dart              # Individual list item with gestures
            ├── add_vegetable_dialog.dart             # Add dialog
            ├── edit_vegetable_dialog.dart            # Edit dialog
            ├── delete_vegetable_dialog.dart          # Delete confirmation
            ├── move_vegetables_dialog.dart           # Move dialog for batch updates
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
- `intl: ^0.20.0` - Date formatting for timestamps
- `flutter_lints: ^6.0.0` - Code quality and linting

## Technical Details

- **Platform Support**: Android, Web
- **Design System**: Material 3 with per-tab theming
- **Architecture**: Feature-based with component separation
- **State Management**: Riverpod with AsyncNotifier and local StatefulWidget state for selection
- **Navigation**: GoRouter with StatefulShellRoute for tabbed navigation and deep linking
- **Data Storage**: SharedPreferences with JSON format (automatic migration from legacy format)
- **Data Model**: dart_mappable classes with automatic serialization
- **UI Interactions**:
  - Normal mode: Swipe to delete, long press for selection mode
  - Selection mode: Tap to toggle, batch edit/delete/move
- **UI Components**: Modular widgets with ConsumerWidget/ConsumerStatefulWidget for reactive updates
- **Batch Operations**: Multi-select with batch delete and harvest state updates
- **Timestamps**: Automatic tracking of creation and modification times
- **Error Handling**: Comprehensive error states with retry functionality
- **Test Coverage**: 38 tests (18 notifier + 17 widget tests)

## License

See the [LICENSE](LICENSE) file for details.
