#!/bin/bash

# Fix 16 KB Page Size Rejection - Re-align APK with 64 KB alignment
# This script should be run after: flutter build apk --release
# Usage: ./realign_apk.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APK_DIR="$SCRIPT_DIR/build/app/outputs/flutter-apk"
ZIPALIGN_PATH=""

# Find zipalign in Android SDK
if [ -n "$ANDROID_HOME" ]; then
    ZIPALIGN_PATH="$ANDROID_HOME/build-tools/36.0.0/zipalign"
elif [ -n "$ANDROID_SDK_ROOT" ]; then
    ZIPALIGN_PATH="$ANDROID_SDK_ROOT/build-tools/36.0.0/zipalign"
else
    # Try common locations
    for path in "$HOME/Android/Sdk/build-tools/36.0.0/zipalign" \
                "$HOME/Library/Android/sdk/build-tools/36.0.0/zipalign" \
                "/opt/android-sdk/build-tools/36.0.0/zipalign"; do
        if [ -f "$path" ]; then
            ZIPALIGN_PATH="$path"
            break
        fi
    done
fi

if [ -z "$ZIPALIGN_PATH" ] || [ ! -f "$ZIPALIGN_PATH" ]; then
    echo "Error: zipalign not found. Please set ANDROID_HOME or ANDROID_SDK_ROOT"
    echo "Or install Android SDK Build Tools 36.0.0"
    exit 1
fi

if [ ! -d "$APK_DIR" ]; then
    echo "Error: APK directory not found: $APK_DIR"
    echo "Please run 'flutter build apk --release' first"
    exit 1
fi

echo "Using zipalign: $ZIPALIGN_PATH"
echo "Re-aligning APKs in $APK_DIR with 64 KB alignment for 16 KB page size support..."
echo ""

APK_COUNT=0
ALIGNED_COUNT=0

find "$APK_DIR" -name "*.apk" ! -name "*-aligned.apk" ! -name "*-backup.apk" | while read apk; do
    APK_COUNT=$((APK_COUNT + 1))
    echo "Processing: $(basename "$apk")"
    
    aligned_apk="${apk%.apk}-aligned.apk"
    backup_apk="${apk%.apk}-backup.apk"
    
    # Create aligned version with 64 KB (65536 bytes) alignment
    if "$ZIPALIGN_PATH" -f -v 65536 "$apk" "$aligned_apk" 2>&1; then
        if [ -f "$aligned_apk" ]; then
            # Replace original with aligned version
            mv "$apk" "$backup_apk"
            mv "$aligned_apk" "$apk"
            rm -f "$backup_apk"
            echo "✓ Successfully re-aligned $(basename "$apk") with 64 KB alignment"
            ALIGNED_COUNT=$((ALIGNED_COUNT + 1))
        else
            echo "✗ Failed: aligned APK not created"
        fi
    else
        echo "✗ Failed to align $(basename "$apk")"
    fi
    echo ""
done

if [ $APK_COUNT -eq 0 ]; then
    echo "No APK files found in $APK_DIR"
    exit 1
fi

echo "Done! Re-aligned $ALIGNED_COUNT APK(s)"
echo ""
echo "You can now verify the alignment using Android Studio's APK Analyzer:"
echo "  - Open the APK in Android Studio"
echo "  - Check the Alignment column for lib/*.so files"
echo "  - It should show '64 KB' or '64 KB zip|64 KB LOAD section'"

