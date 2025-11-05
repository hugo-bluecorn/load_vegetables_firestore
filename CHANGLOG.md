# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2025-11-05

### Added
- **Vegetable Data Model**: Implemented comprehensive model using dart_mappable
  - Created `Vegetable` class with JSON serialization support
  - Added `HarvestState` enum (scarce, enough, plenty) for future harvest tracking
  - Added `createdAt` timestamp to track when vegetables are added
  - Added `lastUpdatedAt` timestamp to track modifications
  - Default harvest state is `scarce`
  - Both timestamps default to current time
- **Data Migration**: Automatic migration from old List<String> format to new JSON format
  - Detects and converts legacy data on first load
  - Preserves existing vegetable names
  - Sets default timestamps and harvest state for migrated data
- **Date Formatting**: Added intl package (^0.19.0) for timestamp display
  - Format: "MMM d, y h:mm a" (e.g., "Nov 5, 2025 2:30 PM")
  - Displays both created and last updated timestamps in UI

### Changed
- **Gesture-Based UI**: Replaced button actions with intuitive gestures
  - Delete: Swipe left to dismiss vegetable (shows confirmation dialog)
  - Edit: Long press on vegetable to edit name
  - Removed edit and delete IconButtons for cleaner UI
- **Data Storage**: Changed from List<String> to JSON string format
  - Uses VegetableMapper for serialization/deserialization
  - Supports rich vegetable data with timestamps and harvest state
- **UI Display**: Updated VegetableListItem to show timestamps
  - Three-line list tile with subtitle showing created and updated dates
  - More informative vegetable entries

### Improved
- Cleaner, more modern UI without visible action buttons
- Better user experience with familiar mobile gestures
- Richer data model supporting future features (harvest tracking)
- Automatic timestamp tracking for all vegetables
- Seamless data migration preserves user data during upgrade

### Testing
- Updated all tests to use new Vegetable model
- Added `createMockVegetablesJson` helper for test data
- Updated widget tests for swipe and long press gestures
- All 38 tests passing (18 notifier + 17 widget tests)

### Technical Details
- Dependencies:
  - `dart_mappable: ^4.2.2` - Model serialization
  - `dart_mappable_builder: ^4.2.3` (dev) - Code generation
  - `intl: ^0.19.0` - Date formatting
- Generated code: `lib/ui/vegetable_list/models/vegetable.mapper.dart`
- Build command: `dart run build_runner build --delete-conflicting-outputs`
- Backwards compatible through automatic data migration

## [0.4.0] - 2025-11-05

### Added
- **GoRouter Navigation**: Integrated go_router (^16.3.0) for declarative routing
  - Created `lib/config/app_router.dart` with centralized route configuration
  - Implemented `goRouterProvider` using Riverpod for router state management
  - Added home route (`/`) with error handling for unknown routes
  - Enabled deep linking support for web platform
  - Set up debug logging for route diagnostics

### Changed
- Converted `MainApp` from `StatelessWidget` to `ConsumerWidget` for router access
- Replaced `MaterialApp` with `MaterialApp.router` using `routerConfig`
- Updated main.dart imports to use router configuration

### Improved
- Better navigation architecture with declarative routing
- Enhanced web support with URL-based navigation
- Foundation for future route guards and nested navigation
- Cleaner separation of navigation logic from UI components

### Testing
- All 38 tests passing (18 notifier + 17 widget tests)
- No breaking changes to existing functionality
- Router integration fully compatible with existing Riverpod state management

### Technical Details
- Dependency: `go_router: ^16.3.0`
- Router managed through Riverpod provider pattern
- Debug logging enabled for development
- Maintained backwards compatibility with all existing features

## [0.3.0] - 2025-11-05

### Added
- **Riverpod State Management**: Integrated flutter_riverpod (^3.0.3) for reactive state management
  - Created `VegetablesNotifier` extending `AsyncNotifier<List<String>>`
  - Implemented provider layer with `vegetableServiceProvider` and `vegetablesProvider`
  - Added comprehensive error handling with `AsyncValue`
  - Implemented error states with retry functionality
  - Added refresh capability to reload data
- Enhanced error UI with user-friendly error messages and retry button

### Changed
- Converted `VegetableListScreen` from `StatefulWidget` to `ConsumerWidget`
- Converted `ImportButton` from `StatelessWidget` to `ConsumerWidget`
- Refactored state management from local state to Riverpod providers
- Removed manual `setState()` calls in favor of reactive updates
- Updated all UI widgets to use `ref.watch()` for observing state
- Updated all UI widgets to use `ref.read()` for triggering actions

### Improved
- Automatic UI updates when state changes
- Better loading state handling with `AsyncValue.loading`
- Comprehensive error handling with `AsyncValue.error`
- Eliminated prop drilling with global state access
- Improved testability with `ProviderContainer`
- More maintainable code with separation of state and UI

### Testing
- Refactored tests to use Riverpod's `ProviderContainer`
- Renamed `test/services/vegetable_service_test.dart` to `test/providers/vegetable_notifier_test.dart`
- Updated all widget tests to wrap with `ProviderScope`
- All 35 tests passing (18 notifier + 17 widget tests)

### Technical Details
- Dependency: `flutter_riverpod: ^3.0.3`
- State managed through `AsyncNotifier` pattern
- Uses `AsyncValue.guard()` for safe async operations
- Maintained backwards compatibility with existing data storage

## [0.2.0] - 2025-11-05

### Changed
- **Architecture Refactoring**: Reorganized codebase with feature-based structure
  - Created `lib/ui/vegetable_list/` feature directory
  - Separated UI components into modular widgets:
    - `vegetable_list_screen.dart` - Main screen container
    - `vegetables_list_view.dart` - List display component
    - `vegetable_list_item.dart` - Individual item widget
    - `add_vegetable_dialog.dart` - Add dialog component
    - `edit_vegetable_dialog.dart` - Edit dialog component
    - `delete_vegetable_dialog.dart` - Delete confirmation dialog
    - `import_button.dart` - File import button component
  - Moved `VegetableService` to `lib/ui/vegetable_list/view_model/`
  - Improved separation of concerns between UI and business logic

### Improved
- Enhanced code maintainability with component-based architecture
- Better code reusability through widget separation
- Clearer file organization following Flutter best practices
- Updated documentation (CLAUDE.md, README.md) to reflect new structure

### Technical Details
- All 35 tests continue to pass (18 unit + 17 widget tests)
- No changes to functionality or user-facing features
- Maintained backwards compatibility with existing data storage

## [0.1.0] - 2025-11-04

### Added
- Initial release of vegetables list management app
- Full CRUD functionality (Create, Read, Update, Delete) for vegetables
- Local data persistence using `shared_preferences`
- File import functionality to load vegetables from text files
- Case-insensitive duplicate detection during import
- Material Design UI with:
  - ListView displaying vegetables with eco icons
  - Floating action button for adding vegetables
  - Edit and delete buttons for each vegetable item
  - Dialog-based add/edit forms
  - Confirmation dialog for deletions
  - Empty state with friendly messaging
  - Import button in app bar
- Comprehensive test coverage:
  - 18 unit tests for VegetableService
  - 17 widget tests for UI functionality
  - All 35 tests passing
- Documentation:
  - CLAUDE.md for AI-assisted development
  - README.md with project overview and features
  - This CHANGELOG.md file

### Technical Details
- Flutter SDK ^3.9.2
- Dependencies:
  - `shared_preferences: ^2.3.3` for local storage
  - `file_picker: ^10.3.3` for file selection
  - `flutter_lints: ^6.0.0` for code quality
- Target platforms: Android, Web
- Uses Material 3 design system
