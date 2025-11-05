# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
