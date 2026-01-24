# Kaaikani E-Commerce App

A Flutter-based e-commerce application using GetX for state management and GraphQL for API communication.

## Quick Start

After cloning the repository, follow these steps:

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate GraphQL files
dart run build_runner build --delete-conflicting-outputs

# 3. Generate splash screen
dart run flutter_native_splash:create

# 4. Generate launcher icons
dart run flutter_launcher_icons

# 5. Run the app
flutter run

# 6. Build APK
flutter build apk --release
```

## Complete Documentation

For detailed documentation including:
- Complete setup instructions
- App flow and function calls for each page
- Version management
- Firebase notification setup
- Build and deployment guide

See: **[COMPLETE_APP_DOCUMENTATION.md](./COMPLETE_APP_DOCUMENTATION.md)**

## Technical Specifications

- **Flutter**: 3.35.5
- **Dart**: 3.9.2
- **Current Version**: 2.0.97+178

## Converting Documentation to PDF

To convert the markdown documentation to PDF:

```bash
# Install pandoc and LaTeX
sudo apt-get install pandoc texlive-latex-base

# Generate PDF
pandoc COMPLETE_APP_DOCUMENTATION.md -o COMPLETE_APP_DOCUMENTATION.pdf --pdf-engine=pdflatex
```

Or use an online markdown to PDF converter.
