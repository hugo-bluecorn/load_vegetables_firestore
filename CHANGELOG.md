# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.1] - 2025-11-08

### Changed
- **Dependency Update**: Upgraded go_router from ^16.3.0 to ^17.0.0

### Fixed
- Fixed typo in changelog filename: renamed CHANGLOG.md to CHANGELOG.md

## [0.7.0] - 2025-11-06

### Added
- **Multi-Select Mode**: Implemented selection mode with batch operations
  - Long press on any vegetable item enters selection mode
  - First item automatically selected on long press
  - Tap items to toggle selection (checkmarks displayed)
  - AppBar title shows selection count (e.g., "3 selected")
  - Close button (X) in AppBar to exit selection mode
  - FAB (floating action button) hidden during selection mode
  - Back button exits selection mode
- **Batch Operations**: Added three AppBar actions during selection mode
  - **Edit** (✏️): Enabled only when exactly 1 item selected, opens edit dialog
  - **Delete** (🗑️): Deletes all selected vegetables with confirmation dialog
  - **Move** (📁): Changes harvest state for all selected vegetables
- **Move Vegetables Dialog**: New dialog for batch harvest state updates
  - Shows count of vegetables being moved
  - Dropdown to select target harvest state (Plenty 🌾, Enough 🌿, Scarce 🌱)
  - Updates `lastUpdatedAt` timestamp for all moved vegetables
- **Batch Service Methods**: Added to VegetableService
  - `deleteMultiple()` - Delete multiple vegetables in one operation
  - `updateHarvestStateForMultiple()` - Batch update harvest states
- **Batch Notifier Methods**: Added to VegetablesNotifier
  - `deleteMultiple()` - Reactive batch deletion
  - `updateHarvestStateForMultiple()` - Reactive batch state updates

### Changed
- **Long Press Behavior**: Changed from "edit single item" to "enter selection mode"
  - Removed long-press-to-edit gesture entirely
  - Edit now only available through selection mode → edit icon (1 item selected)
- **Swipe-to-Delete**: Now disabled during selection mode
  - Prevents conflicting gestures during multi-select
  - Swipe still works in normal mode
- **VegetableListScreen**: Converted from `ConsumerWidget` to `ConsumerStatefulWidget`
  - Added local state for selection mode (`_isSelectionMode`)
  - Added local state for selected items (`Set<Vegetable> _selectedVegetables`)
  - Dynamic AppBar actions based on mode and selection count
  - PopScope handling for back button during selection mode
- **VegetableListItem**: Enhanced with selection mode support
  - Added `isSelectionMode`, `isSelected` parameters
  - Checkbox replaces CircleAvatar icon when in selection mode
  - `onTap` callback for selection toggle
  - `onLongPress` callback for entering selection mode
  - Removed `onEdit` parameter (no longer used)
- **VegetablesListView**: Updated to pass selection state to items
  - Added `isSelectionMode`, `selectedVegetables` parameters
  - Added `onItemTap`, `onItemLongPress` callbacks
  - Removed `onEdit` parameter

### Fixed
- Fixed deprecated `withOpacity` → `withValues(alpha:)` in harvest_state_shell_screen.dart
- Fixed deprecated `value` → `initialValue` in move_vegetables_dialog.dart
- Removed unused `_showEditDialog` method from vegetable_list_screen.dart

### Testing
- Updated widget tests to reflect new long-press behavior
  - Test: "Long pressing vegetable enters selection mode"
  - Test: "Can edit a vegetable in selection mode"
- All 38 tests passing (18 notifier + 17 widget tests)
- No linting issues (`flutter analyze` clean)

### Technical Details
- Selection state uses `Set<Vegetable>` instead of indices to avoid filter mapping issues
- Batch operations match vegetables by name, createdAt, and harvestState
- Selection automatically clears when exiting selection mode or completing actions
- Edit action only enabled when exactly 1 item selected

## [0.6.0] - 2025-11-06

### Added
- **Harvest State Tabs**: Implemented tabbed navigation for filtering vegetables by harvest state
  - Three tabs: Plenty, Enough, Scarce (ordered left to right)
  - URL-based routing: `/plenty`, `/enough`, `/scarce`
  - Each tab filters vegetables to show only matching harvest state
  - Default view opens to "Plenty" tab
- **Bottom Navigation Bar**: Material 3 NavigationBar with themed icons and indicators
  - Dynamic indicator color changes based on selected tab
  - Color-coded icons: Amber (Plenty), Blue (Enough), Purple (Scarce)
  - Visual feedback with different shades for selected/unselected states
- **Per-Tab Theming**: Each tab has a unique color scheme
  - Plenty tab: Amber/Yellow theme (Colors.amber)
  - Enough tab: Blue theme (Colors.blue)
  - Scarce tab: Deep Purple theme (Colors.deepPurple)
  - Theme colors applied to AppBar background and navigation indicator
  - Title displays current filter (e.g., "Vegetables - Plenty")
- **Harvest State Selection**: Added harvest state dropdown to Add and Edit dialogs
  - Default to current tab's harvest state when adding
  - Show current state when editing
  - Options with emojis: 🌱 Scarce, 🌿 Enough, 🌾 Plenty
- **Routing Structure**: Moved routing files to dedicated directory
  - Created `lib/routing/` directory for routing-related files
  - Moved from `lib/config/app_router.dart` to `lib/routing/app_router.dart`
  - Added `lib/routing/harvest_state_shell_screen.dart` for navigation shell

### Changed
- **Navigation Architecture**: Refactored from single route to StatefulShellRoute
  - Uses `StatefulShellRoute.indexedStack` for persistent tab state
  - Each tab maintains independent navigation stack
  - Uses `NoTransitionPage` for seamless tab switching without animations
- **VegetableListScreen**: Now requires `harvestState` parameter
  - Filters vegetables list based on provided harvest state
  - Applies theme colors dynamically based on harvest state
  - Title reflects current filter state
- **Edit/Delete Operations**: Updated to handle filtered list indices
  - Maps filtered list index to actual index in full vegetables list
  - Ensures correct vegetable is edited/deleted when operating on filtered views

### Improved
- Better organization of vegetables by harvest availability
- Enhanced visual hierarchy with color-coded navigation
- Clearer context of which harvest state view is active
- More intuitive workflow for categorizing vegetables
- Improved project structure with dedicated routing directory

### Testing
- Updated test helper `createMockVegetablesJson` to default to `HarvestState.plenty`
- Updated widget tests to expect "Vegetables - Plenty" as default title
- All 38 tests passing (18 notifier + 17 widget tests)

### Documentation
- Added "Data Format" section to README.md
  - Documented Vegetable JSON structure with field descriptions
  - Included example of storage format in SharedPreferences
  - Explained dart_mappable integration and data migration

### Technical Details
- Uses `StatefulShellRoute.indexedStack` from go_router for tab management
- Updated `intl` package from ^0.19.0 to ^0.20.0
- Theme applied using `Theme.copyWith()` with `ColorScheme.fromSeed()`
- Navigation indicator uses theme color with 30% opacity
- Icon colors use shade700 (unselected) and shade900 (selected)
- Maintained backwards compatibility with existing data

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
