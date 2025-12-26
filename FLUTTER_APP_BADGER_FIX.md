# Flutter Plugin Namespace Fixes

## Issue
Several Flutter packages don't have a namespace specified in their `build.gradle` files, which causes build failures with newer Android Gradle Plugin versions.

## Fixes Applied

### 1. flutter_app_badger (v1.5.0)
- File: `~/.pub-cache/hosted/pub.dev/flutter_app_badger-1.5.0/android/build.gradle`
- Added: `namespace 'fr.g123k.flutterappbadge.flutterappbadger'` in the `android` block

### 2. flutter_dynamic_icon (v2.1.0)
- File: `~/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/build.gradle`
- Added: `namespace 'io.github.tastelessjolt.flutterdynamicicon'` in the `android` block

### 3. flutter_dynamic_icon - v1 Embedding Fix
- File: `~/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/src/main/java/io/github/tastelessjolt/flutterdynamicicon/FlutterDynamicIconPlugin.java`
- Removed: Deprecated `registerWith()` method that uses Flutter v1 embedding API (which has been removed)
- The plugin already supports v2 embedding via `onAttachedToEngine()` and `onDetachedFromEngine()` methods

## Important Note
⚠️ **This fix is temporary** - The file is in the pub cache and will be overwritten if you run `flutter pub get` or `flutter clean && flutter pub get`.

## Permanent Solutions

### Option 1: Re-apply the fixes after pub get
If the build fails again, re-apply the namespace fixes:

**For flutter_app_badger:**
```bash
# Edit the file
nano ~/.pub-cache/hosted/pub.dev/flutter_app_badger-1.5.0/android/build.gradle

# Add this line inside the android { } block:
namespace 'fr.g123k.flutterappbadge.flutterappbadger'
```

**For flutter_dynamic_icon:**
```bash
# Edit the file
nano ~/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/build.gradle

# Add this line inside the android { } block:
namespace 'io.github.tastelessjolt.flutterdynamicicon'
```

### Option 2: Use a script to auto-fix
Create a script to automatically apply the fixes:
```bash
#!/bin/bash
# fix_plugins.sh
# Fix flutter_app_badger
sed -i '/^android {/a\    namespace '\''fr.g123k.flutterappbadge.flutterappbadger'\''' ~/.pub-cache/hosted/pub.dev/flutter_app_badger-1.5.0/android/build.gradle

# Fix flutter_dynamic_icon
sed -i '/^android {/a\    namespace '\''io.github.tastelessjolt.flutterdynamicicon'\''' ~/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/build.gradle
```

### Option 3: Fork the package (Recommended for production)
1. Fork `flutter_app_badger` on GitHub
2. Add the namespace fix
3. Use your fork in `pubspec.yaml`:
```yaml
dependencies:
  flutter_app_badger:
    git:
      url: https://github.com/your-username/flutter_app_badger.git
      ref: main
```

### Option 4: Use an alternative package
Consider migrating to a maintained alternative if available.

## Current Status
✅ Fix applied - Build should work now.


## Issue
Several Flutter packages don't have a namespace specified in their `build.gradle` files, which causes build failures with newer Android Gradle Plugin versions.

## Fixes Applied

### 1. flutter_app_badger (v1.5.0)
- File: `~/.pub-cache/hosted/pub.dev/flutter_app_badger-1.5.0/android/build.gradle`
- Added: `namespace 'fr.g123k.flutterappbadge.flutterappbadger'` in the `android` block

### 2. flutter_dynamic_icon (v2.1.0)
- File: `~/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/build.gradle`
- Added: `namespace 'io.github.tastelessjolt.flutterdynamicicon'` in the `android` block

### 3. flutter_dynamic_icon - v1 Embedding Fix
- File: `~/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/src/main/java/io/github/tastelessjolt/flutterdynamicicon/FlutterDynamicIconPlugin.java`
- Removed: Deprecated `registerWith()` method that uses Flutter v1 embedding API (which has been removed)
- The plugin already supports v2 embedding via `onAttachedToEngine()` and `onDetachedFromEngine()` methods

## Important Note
⚠️ **This fix is temporary** - The file is in the pub cache and will be overwritten if you run `flutter pub get` or `flutter clean && flutter pub get`.

## Permanent Solutions

### Option 1: Re-apply the fixes after pub get
If the build fails again, re-apply the namespace fixes:

**For flutter_app_badger:**
```bash
# Edit the file
nano ~/.pub-cache/hosted/pub.dev/flutter_app_badger-1.5.0/android/build.gradle

# Add this line inside the android { } block:
namespace 'fr.g123k.flutterappbadge.flutterappbadger'
```

**For flutter_dynamic_icon:**
```bash
# Edit the file
nano ~/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/build.gradle

# Add this line inside the android { } block:
namespace 'io.github.tastelessjolt.flutterdynamicicon'
```

### Option 2: Use a script to auto-fix
Create a script to automatically apply the fixes:
```bash
#!/bin/bash
# fix_plugins.sh
# Fix flutter_app_badger
sed -i '/^android {/a\    namespace '\''fr.g123k.flutterappbadge.flutterappbadger'\''' ~/.pub-cache/hosted/pub.dev/flutter_app_badger-1.5.0/android/build.gradle

# Fix flutter_dynamic_icon
sed -i '/^android {/a\    namespace '\''io.github.tastelessjolt.flutterdynamicicon'\''' ~/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/build.gradle
```

### Option 3: Fork the package (Recommended for production)
1. Fork `flutter_app_badger` on GitHub
2. Add the namespace fix
3. Use your fork in `pubspec.yaml`:
```yaml
dependencies:
  flutter_app_badger:
    git:
      url: https://github.com/your-username/flutter_app_badger.git
      ref: main
```

### Option 4: Use an alternative package
Consider migrating to a maintained alternative if available.

## Current Status
✅ Fix applied - Build should work now.
