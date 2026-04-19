# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application project named `note_app`. It's a minimal Flutter project initialized with a basic "Hello World" app structure.

## Communication Language

When communicating with users, respond in Japanese.

## Architecture and Structure

- **Framework**: Flutter 3.9.0+ with Dart
- **Main Entry Point**: `lib/main.dart` - Contains the main app with a simple MaterialApp showing "Hello World"
- **Dependencies**: Uses Material Design components (`uses-material-design: true`)
- **Linting**: Uses `flutter_lints` package with standard Flutter linting rules
- **Platforms**: Supports iOS and Android (evidenced by `/ios` and `/android` directories)

## Development Commands

### Essential Commands

- **Install dependencies**: `flutter pub get`
- **Run the app**: `flutter run`
- **Build for release**: `flutter build apk` (Android) or `flutter build ios` (iOS)
- **Run tests**: `flutter test`
- **Analyze code**: `flutter analyze`
- **Format code**: `dart format .`

### Development Workflow

- **Hot reload**: Available when running `flutter run` in debug mode
- **Clean build cache**: `flutter clean` then `flutter pub get`

## Configuration Files

- `pubspec.yaml`: Project configuration and dependencies
- `analysis_options.yaml`: Includes Flutter linting rules from `package:flutter_lints/flutter.yaml`
- `lib/main.dart`: Single-file app with `MainApp` StatelessWidget

## Testing

Test files live under `test/`. Use `flutter test` to run.

```
test/
└── widget_test.dart
```

### Testing notes

- Widget tests use `flutter_test` package
- Use `tester.pumpWidget()` to render widgets
- Use `find.text()` to locate widgets by text

## Code Style

- Follow standard Dart conventions
- Use `dart format` before committing
- Keep functions small and focused
- Write clean, readable code

## Git

- Use git for version control
- Commit messages should be descriptive

## Development Notes

- Project uses standard Flutter project structure
- Material Design is enabled for UI components
- Currently supports iOS and Android platforms out of the box
