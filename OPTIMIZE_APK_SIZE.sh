#!/bin/bash

echo "========================================="
echo "APK Size Optimization Script"
echo "========================================="
echo ""

echo "Current APK size: 61.3MB"
echo "Target: < 40MB"
echo ""

echo "Step 1: Cleaning build..."
flutter clean
echo ""

echo "Step 2: Building release APK with optimizations..."
echo "This will create separate APKs for each architecture:"
echo "  - app-armeabi-v7a-release.apk (32-bit ARM)"
echo "  - app-arm64-v8a-release.apk (64-bit ARM - most common)"
echo "  - app-x86_64-release.apk (64-bit x86)"
echo ""

flutter build apk --release

echo ""
echo "========================================="
echo "Build Complete!"
echo "========================================="
echo ""
echo "APK files created in: build/app/outputs/flutter-apk/"
echo ""
echo "To see sizes:"
echo "  ls -lh build/app/outputs/flutter-apk/*.apk"
echo ""
echo "For Play Store, build App Bundle instead:"
echo "  flutter build appbundle --release"
echo ""












