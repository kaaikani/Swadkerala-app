# iOS Run Guide

## ⚠️ Important: iOS Development Requirements

**iOS development requires macOS with Xcode installed.** You cannot run iOS apps on Linux or Windows directly.

## Current System Status

- **OS**: Ubuntu 24.10 (Linux)
- **iOS Support**: ❌ Not available (requires macOS)
- **Android Support**: ✅ Available
- **Web Support**: ✅ Available

## Options to Run on iOS

### Option 1: Use a Mac (Recommended)

If you have access to a Mac:

1. **Install Xcode**:
   ```bash
   # Open App Store on Mac and install Xcode
   # Or download from: https://developer.apple.com/xcode/
   ```

2. **Install CocoaPods**:
   ```bash
   sudo gem install cocoapods
   ```

3. **Navigate to project**:
   ```bash
   cd /path/to/Unified-EcomApp
   ```

4. **Install iOS dependencies**:
   ```bash
   cd ios
   pod install
   cd ..
   ```

5. **Get Flutter dependencies**:
   ```bash
   flutter pub get
   ```

6. **Check available iOS devices**:
   ```bash
   flutter devices
   ```

7. **Run on iOS Simulator**:
   ```bash
   # List available simulators
   xcrun simctl list devices available
   
   # Run on default simulator
   flutter run -d ios
   
   # Or specify a device
   flutter run -d "iPhone 15 Pro"
   ```

8. **Run on Physical iOS Device**:
   ```bash
   # Connect iPhone via USB
   # Trust the computer on iPhone
   # Run:
   flutter run -d <device-id>
   ```

### Option 2: Use CI/CD Service (GitHub Actions, Codemagic, etc.)

You can set up automated iOS builds using cloud services:

- **GitHub Actions** (free for public repos)
- **Codemagic** (free tier available)
- **AppCircle** (free tier available)
- **Bitrise** (free tier available)

### Option 3: Use Remote Mac Service

Services like MacStadium or MacInCloud provide remote Mac access for iOS development.

## Pre-Flight Checklist (Before Running on Mac)

✅ **Completed**:
- [x] iOS project structure exists
- [x] Podfile created with minimum iOS 13.0
- [x] Info.plist permissions configured
- [x] Platform checks added for Android-only packages
- [x] iOS compatibility documentation created

⚠️ **To Do on Mac**:
- [ ] Install Xcode (latest version recommended)
- [ ] Install CocoaPods: `sudo gem install cocoapods`
- [ ] Run `cd ios && pod install`
- [ ] Configure Razorpay iOS SDK (if using payments)
- [ ] Setup Firebase APNs for push notifications
- [ ] Configure App Store ID in `update_screen.dart`
- [ ] Test on iOS Simulator
- [ ] Test on physical iOS device

## Quick Start Commands (On Mac)

```bash
# 1. Navigate to project
cd /path/to/Unified-EcomApp

# 2. Get Flutter dependencies
flutter pub get

# 3. Install iOS pods
cd ios
pod install
cd ..

# 4. Open iOS Simulator (optional)
open -a Simulator

# 5. Run on iOS
flutter run -d ios

# Or build for release
flutter build ios
```

## Troubleshooting

### "No iOS devices found"
- Make sure Xcode is installed
- Open Xcode and accept license: `sudo xcodebuild -license accept`
- Run: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`

### "CocoaPods not found"
- Install: `sudo gem install cocoapods`
- Update: `pod repo update`

### "Pod install fails"
- Clean: `cd ios && rm -rf Pods Podfile.lock && pod install`
- Update CocoaPods: `sudo gem update cocoapods`

### "Signing errors"
- Open `ios/Runner.xcworkspace` in Xcode
- Select Runner target → Signing & Capabilities
- Select your development team
- Or configure automatic signing

## Current Project Status

The project is **ready for iOS** with:
- ✅ Platform checks for Android-only packages
- ✅ iOS permissions configured
- ✅ Podfile created
- ✅ Info.plist properly configured
- ✅ All compatibility issues documented

**Next Step**: Transfer project to Mac and follow the "Quick Start Commands" above.












