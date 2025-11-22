# Building Optimized APK (Under 30MB)

## Quick Build (Recommended)

Use the provided build script:
```bash
./build_apk_optimized.sh
```

Or manually:
```bash
flutter build apk --release --target-platform android-arm64
```

**Result**: ~22-23MB APK ✅

## Why Not `flutter build apk --release`?

The default `flutter build apk --release` command includes **all architectures** (arm64-v8a, armeabi-v7a, x86_64), resulting in:
- **Size**: ~61-63MB (too large!)
- **Architectures**: All 3 (57.6MB in native libraries alone)

## Solution: Use `--target-platform android-arm64`

This builds only for **arm64-v8a** architecture:
- **Size**: ~22-23MB ✅ (under 30MB target)
- **Coverage**: 95%+ of modern Android devices
- **Architectures**: Only arm64-v8a (19.5MB native libraries)

## Build Commands

### Option 1: Optimized Single Architecture (Recommended)
```bash
flutter build apk --release --target-platform android-arm64
```
**Size**: ~22-23MB  
**Coverage**: 95%+ devices

### Option 2: Split APKs (Maximum Compatibility)
```bash
flutter build apk --release --split-per-abi
```
**Creates**:
- `app-arm64-v8a-release.apk` (~22MB)
- `app-armeabi-v7a-release.apk` (~20MB)  
- `app-x86_64-release.apk` (~25MB)

**Use Case**: Upload all 3 to Play Store - it serves the correct one automatically

### Option 3: Universal APK (Not Recommended)
```bash
flutter build apk --release
```
**Size**: ~61-63MB ❌ (too large!)

## APK Location

All builds output to:
```
build/app/outputs/flutter-apk/app-release.apk
```

For split APKs:
```
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
```

## Size Comparison

| Build Type | Size | Architectures | Coverage |
|------------|------|---------------|----------|
| `--target-platform android-arm64` | **22MB** ✅ | arm64-v8a | 95%+ devices |
| `--split-per-abi` | 22-25MB each | Separate APKs | 99%+ devices |
| Default (no flags) | **63MB** ❌ | All 3 | 100% devices |

## Recommendations

1. **For Production**: Use `--target-platform android-arm64`
   - Smallest size (22MB)
   - Covers 95%+ of real devices
   - Single APK to distribute

2. **For Play Store**: Use `--split-per-abi`
   - Play Store serves correct APK automatically
   - Maximum device compatibility
   - Smaller downloads per device

3. **For Testing Emulators**: Build x86_64 separately
   ```bash
   flutter build apk --release --target-platform android-x64
   ```

## Build Script

Use the provided script for convenience:
```bash
./build_apk_optimized.sh
```

This script:
- Cleans previous builds
- Builds optimized APK (arm64-v8a only)
- Shows APK size and location
- Lists included architectures

## Summary

✅ **Use**: `flutter build apk --release --target-platform android-arm64`  
✅ **Result**: 22-23MB APK (under 30MB target)  
✅ **Coverage**: 95%+ of modern Android devices  

Your optimized APK is ready! 🎉

