# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
