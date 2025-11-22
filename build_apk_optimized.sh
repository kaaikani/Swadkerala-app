#!/bin/bash
# Optimized APK build script - Builds APK under 30MB
# This script builds an APK with only arm64-v8a architecture

echo "🧹 Cleaning previous builds..."
flutter clean

echo "📦 Building optimized release APK (arm64-v8a only)..."
flutter build apk --release --target-platform android-arm64

if [ $? -eq 0 ]; then
    APK_SIZE=$(ls -lh build/app/outputs/flutter-apk/app-release.apk | awk '{print $5}')
    echo ""
    echo "✅ Build successful!"
    echo "📱 APK Size: $APK_SIZE"
    echo "📍 Location: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "Architectures included:"
    unzip -l build/app/outputs/flutter-apk/app-release.apk 2>/dev/null | grep -E "lib/.*\.so$" | awk '{print $4}' | sed 's|lib/||' | sed 's|/.*||' | sort -u
else
    echo "❌ Build failed!"
    exit 1
fi

