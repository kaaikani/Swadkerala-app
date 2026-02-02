#!/bin/bash
# Script to fix namespace and v1 embedding issues in Flutter plugins
# Run this after 'flutter pub get' if build fails

echo "🔧 Fixing Flutter plugin issues..."

# Remove plugins that fail Android Kotlin compile (v1 embedding / Registrar issues).
# Flutter reads from BOTH .flutter-plugins AND .flutter-plugins-dependencies (JSON).
FLUTTER_PLUGINS=".flutter-plugins"
if [ -f "$FLUTTER_PLUGINS" ]; then
  if grep -qE '^(fluttertoast|speech_to_text)=' "$FLUTTER_PLUGINS"; then
    echo "  ✅ Removing fluttertoast and speech_to_text from .flutter-plugins..."
    grep -vE '^(fluttertoast|speech_to_text)=' "$FLUTTER_PLUGINS" > "${FLUTTER_PLUGINS}.tmp" && mv "${FLUTTER_PLUGINS}.tmp" "$FLUTTER_PLUGINS"
  fi
fi
if [ -f .flutter-plugins-dependencies ]; then
  if grep -qE '"name":"(fluttertoast|speech_to_text)"' .flutter-plugins-dependencies; then
    echo "  ✅ Removing fluttertoast and speech_to_text from .flutter-plugins-dependencies..."
    jq '
      .plugins.android |= map(select(.name != "fluttertoast" and .name != "speech_to_text")) |
      .plugins.ios |= map(select(.name != "fluttertoast" and .name != "speech_to_text")) |
      .plugins.web |= map(select(.name != "fluttertoast" and .name != "speech_to_text")) |
      .plugins.macos |= map(select(.name != "fluttertoast" and .name != "speech_to_text")) |
      .plugins.linux |= map(select(.name != "fluttertoast" and .name != "speech_to_text")) |
      .plugins.windows |= map(select(.name != "fluttertoast" and .name != "speech_to_text")) |
      .dependencyGraph |= map(select(.name != "fluttertoast" and .name != "speech_to_text")) |
      .dependencyGraph |= map(if .dependencies then .dependencies |= map(select(. != "fluttertoast" and . != "speech_to_text")) else . end)
    ' .flutter-plugins-dependencies > .flutter-plugins-dependencies.tmp && mv .flutter-plugins-dependencies.tmp .flutter-plugins-dependencies
    echo "     fluttertoast and speech_to_text excluded (avoids Kotlin compile errors)"
  fi
fi

# Fix flutter_app_badger
BADGER_FILE="$HOME/.pub-cache/hosted/pub.dev/flutter_app_badger-1.5.0/android/build.gradle"
if [ -f "$BADGER_FILE" ]; then
    if ! grep -q "namespace 'fr.g123k.flutterappbadge.flutterappbadger'" "$BADGER_FILE"; then
        echo "  ✅ Fixing flutter_app_badger..."
        sed -i '/^android {/a\    namespace '\''fr.g123k.flutterappbadge.flutterappbadger'\''' "$BADGER_FILE"
        echo "     Added namespace to flutter_app_badger"
    else
        echo "  ✓ flutter_app_badger already fixed"
    fi
else
    echo "  ⚠ flutter_app_badger not found (may not be installed)"
fi

# Fix flutter_dynamic_icon
DYNAMIC_ICON_FILE="$HOME/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/build.gradle"
if [ -f "$DYNAMIC_ICON_FILE" ]; then
    if ! grep -q "namespace 'io.github.tastelessjolt.flutterdynamicicon'" "$DYNAMIC_ICON_FILE"; then
        echo "  ✅ Fixing flutter_dynamic_icon..."
        sed -i '/^android {/a\    namespace '\''io.github.tastelessjolt.flutterdynamicicon'\''' "$DYNAMIC_ICON_FILE"
        echo "     Added namespace to flutter_dynamic_icon"
    else
        echo "  ✓ flutter_dynamic_icon already fixed"
    fi
else
    echo "  ⚠ flutter_dynamic_icon not found (may not be installed)"
fi

# Fix flutter_dynamic_icon v1 embedding issue
DYNAMIC_ICON_PLUGIN_FILE="$HOME/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/src/main/java/io/github/tastelessjolt/flutterdynamicicon/FlutterDynamicIconPlugin.java"
if [ -f "$DYNAMIC_ICON_PLUGIN_FILE" ]; then
    if grep -q "public static void registerWith" "$DYNAMIC_ICON_PLUGIN_FILE"; then
        echo "  ✅ Fixing flutter_dynamic_icon v1 embedding issue..."
        # Comment out the deprecated registerWith method
        sed -i 's/@SuppressWarnings("deprecation")/\/\/ Removed deprecated v1 embedding method - plugin now uses v2 embedding only\n  \/\/ @SuppressWarnings("deprecation")/' "$DYNAMIC_ICON_PLUGIN_FILE"
        sed -i 's/public static void registerWith/  \/\/ public static void registerWith/' "$DYNAMIC_ICON_PLUGIN_FILE"
        sed -i '/\/\/ public static void registerWith/,/}/s/^/  \/\//' "$DYNAMIC_ICON_PLUGIN_FILE"
        echo "     Removed deprecated v1 embedding method"
    else
        echo "  ✓ flutter_dynamic_icon v1 embedding already fixed"
    fi
else
    echo "  ⚠ flutter_dynamic_icon plugin file not found"
fi

echo "✨ Done! You can now try building your app."


# Run this after 'flutter pub get' if build fails

echo "🔧 Fixing Flutter plugin issues..."

# Fix flutter_app_badger
BADGER_FILE="$HOME/.pub-cache/hosted/pub.dev/flutter_app_badger-1.5.0/android/build.gradle"
if [ -f "$BADGER_FILE" ]; then
    if ! grep -q "namespace 'fr.g123k.flutterappbadge.flutterappbadger'" "$BADGER_FILE"; then
        echo "  ✅ Fixing flutter_app_badger..."
        sed -i '/^android {/a\    namespace '\''fr.g123k.flutterappbadge.flutterappbadger'\''' "$BADGER_FILE"
        echo "     Added namespace to flutter_app_badger"
    else
        echo "  ✓ flutter_app_badger already fixed"
    fi
else
    echo "  ⚠ flutter_app_badger not found (may not be installed)"
fi

# Fix flutter_dynamic_icon
DYNAMIC_ICON_FILE="$HOME/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/build.gradle"
if [ -f "$DYNAMIC_ICON_FILE" ]; then
    if ! grep -q "namespace 'io.github.tastelessjolt.flutterdynamicicon'" "$DYNAMIC_ICON_FILE"; then
        echo "  ✅ Fixing flutter_dynamic_icon..."
        sed -i '/^android {/a\    namespace '\''io.github.tastelessjolt.flutterdynamicicon'\''' "$DYNAMIC_ICON_FILE"
        echo "     Added namespace to flutter_dynamic_icon"
    else
        echo "  ✓ flutter_dynamic_icon already fixed"
    fi
else
    echo "  ⚠ flutter_dynamic_icon not found (may not be installed)"
fi

# Fix flutter_dynamic_icon v1 embedding issue
DYNAMIC_ICON_PLUGIN_FILE="$HOME/.pub-cache/hosted/pub.dev/flutter_dynamic_icon-2.1.0/android/src/main/java/io/github/tastelessjolt/flutterdynamicicon/FlutterDynamicIconPlugin.java"
if [ -f "$DYNAMIC_ICON_PLUGIN_FILE" ]; then
    if grep -q "public static void registerWith" "$DYNAMIC_ICON_PLUGIN_FILE"; then
        echo "  ✅ Fixing flutter_dynamic_icon v1 embedding issue..."
        # Comment out the deprecated registerWith method
        sed -i 's/@SuppressWarnings("deprecation")/\/\/ Removed deprecated v1 embedding method - plugin now uses v2 embedding only\n  \/\/ @SuppressWarnings("deprecation")/' "$DYNAMIC_ICON_PLUGIN_FILE"
        sed -i 's/public static void registerWith/  \/\/ public static void registerWith/' "$DYNAMIC_ICON_PLUGIN_FILE"
        sed -i '/\/\/ public static void registerWith/,/}/s/^/  \/\//' "$DYNAMIC_ICON_PLUGIN_FILE"
        echo "     Removed deprecated v1 embedding method"
    else
        echo "  ✓ flutter_dynamic_icon v1 embedding already fixed"
    fi
else
    echo "  ⚠ flutter_dynamic_icon plugin file not found"
fi

echo "✨ Done! You can now try building your app."
