# Kaaikani E-Commerce App

A Flutter-based e-commerce application using GetX for state management and GraphQL for API communication.

## Quick Start

After cloning the repository, follow these steps:

```bash
# 1. Install dependencies
flutter pub get

# 2. Firebase: add config files (required for push, Crashlytics, Remote Config)
#    - Android: download google-services.json from Firebase Console → place at android/app/google-services.json
#    - iOS:     download GoogleService-Info.plist from Firebase Console → place at ios/Runner/GoogleService-Info.plist
#    Then add GoogleService-Info.plist to the Xcode project: open ios/Runner.xcworkspace, right-click Runner → Add Files to "Runner" → select ios/Runner/GoogleService-Info.plist

# 3. Generate GraphQL files
dart run build_runner build --delete-conflicting-outputs

# 4. Generate splash screen
dart run flutter_native_splash:create

# 5. Generate launcher icons
dart run flutter_launcher_icons

# 6. Run the app
flutter run

# 7. Build APK
flutter build apk --release
```

## Analytics (Firebase + Meta)

Analytics and Crashlytics collection is gated on `kReleaseMode` — **auto-enabled for any release build** (Xcode Archive, `flutter build apk|appbundle|ipa --release`) and off for debug/profile runs. No flag needed.

```bash
# Release APK (Play Store)
flutter build apk --release

# Release App Bundle (Play Store)
flutter build appbundle --release

# Release IPA (App Store) — or just Product > Archive in Xcode
flutter build ipa --release
```

Gate defined in [lib/services/analytics_service.dart](lib/services/analytics_service.dart) and [lib/services/crashlytics_service.dart](lib/services/crashlytics_service.dart).

## Toggle Debug Prints

Comment out every `print(...)` / `debugPrint(...)` in `lib/` with one command (macOS):

```bash
# Comment all prints
find lib -name "*.dart" -exec sed -i '' -E 's|^([[:space:]]*)(print\()|\1// \2|; s|^([[:space:]]*)(debugPrint\()|\1// \2|' {} +

# Uncomment all prints
find lib -name "*.dart" -exec sed -i '' -E 's|^([[:space:]]*)// (print\()|\1\2|; s|^([[:space:]]*)// (debugPrint\()|\1\2|' {} +
```

On Linux, drop the `''` after `-i` (use `sed -i -E ...`). Only affects statement-start `print`/`debugPrint` lines — prints embedded mid-expression are left alone.

## Complete Documentation

For detailed documentation including:
- Complete setup instructions
- App flow and function calls for each page
- Version management
- Firebase notification setup
- Build and deployment guide

See: **[COMPLETE_APP_DOCUMENTATION.md](./COMPLETE_APP_DOCUMENTATION.md)**

**Google Sign-In (env-only):** Bundle ID, App Store ID, Team ID and `.env` setup: **[docs/GOOGLE_AUTH_SETUP.md](./docs/GOOGLE_AUTH_SETUP.md)**

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
