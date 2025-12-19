# iOS Compatibility Checklist

This document lists all packages used in the project and their iOS/Android compatibility status.

## ✅ Packages with Full iOS & Android Support

| Package | Version | iOS Support | Android Support | Notes |
|---------|--------|-------------|-----------------|-------|
| `cupertino_icons` | ^1.0.8 | ✅ Yes | ✅ Yes | Native iOS icons |
| `graphql_flutter` | ^5.1.2 | ✅ Yes | ✅ Yes | Cross-platform |
| `gql` | ^1.0.1 | ✅ Yes | ✅ Yes | Cross-platform |
| `flutter_dotenv` | ^6.0.0 | ✅ Yes | ✅ Yes | Cross-platform |
| `get` | ^4.7.2 | ✅ Yes | ✅ Yes | Cross-platform state management |
| `get_storage` | ^2.1.1 | ✅ Yes | ✅ Yes | Cross-platform storage |
| `connectivity_plus` | ^5.0.2 | ✅ Yes | ✅ Yes | Cross-platform |
| `permission_handler` | ^11.3.1 | ✅ Yes | ✅ Yes | Cross-platform (needs iOS permissions in Info.plist) |
| `package_info_plus` | ^8.0.0 | ✅ Yes | ✅ Yes | Cross-platform |
| `url_launcher` | ^6.3.0 | ✅ Yes | ✅ Yes | Cross-platform |
| `http` | ^1.1.0 | ✅ Yes | ✅ Yes | Cross-platform |
| `flutter_html` | ^3.0.0-beta.2 | ✅ Yes | ✅ Yes | Cross-platform |
| `marquee` | ^2.3.0 | ✅ Yes | ✅ Yes | Cross-platform |
| `skeletonizer` | ^2.1.0+1 | ✅ Yes | ✅ Yes | Cross-platform |
| `firebase_core` | ^2.30.1 | ✅ Yes | ✅ Yes | Cross-platform |
| `firebase_messaging` | ^14.9.1 | ✅ Yes | ✅ Yes | Cross-platform (needs iOS setup) |
| `firebase_crashlytics` | ^3.5.7 | ✅ Yes | ✅ Yes | Cross-platform |
| `firebase_analytics` | ^10.10.7 | ✅ Yes | ✅ Yes | Cross-platform |
| `firebase_remote_config` | ^4.4.7 | ✅ Yes | ✅ Yes | Cross-platform |
| `flutter_local_notifications` | ^17.2.1 | ✅ Yes | ✅ Yes | Cross-platform (needs iOS permissions) |
| `app_links` | ^6.3.3 | ✅ Yes | ✅ Yes | Cross-platform (needs iOS configuration) |
| `share_plus` | ^7.2.1 | ✅ Yes | ✅ Yes | Cross-platform |
| `pdf` | ^3.11.3 | ✅ Yes | ✅ Yes | Cross-platform |
| `printing` | ^5.13.1 | ✅ Yes | ✅ Yes | Cross-platform |
| `path_provider` | ^2.1.5 | ✅ Yes | ✅ Yes | Cross-platform |
| `slide_to_act` | ^2.0.2 | ✅ Yes | ✅ Yes | Cross-platform |

## ⚠️ Packages Requiring iOS Configuration

### 1. `razorpay_flutter` (^1.3.7)
- **iOS Support**: ✅ Yes (with configuration)
- **Android Support**: ✅ Yes
- **iOS Setup Required**:
  - Add Razorpay iOS SDK via CocoaPods
  - Configure in `ios/Podfile`
  - Add payment capabilities in Xcode
  - **Note**: Razorpay iOS SDK may have different API than Android

### 2. `mobile_number` (^3.0.0)
- **iOS Support**: ⚠️ Limited (iOS restrictions)
- **Android Support**: ✅ Yes
- **iOS Limitations**:
  - iOS doesn't allow direct SIM card access like Android
  - Phone number detection is limited on iOS
  - Package may not fully support iOS SIM detection
  - **Action Required**: 
    - Test on iOS device to verify functionality
    - May need to wrap with `Platform.isAndroid` checks
    - Consider alternative for iOS (manual phone number input)
    - **Current Usage**: `lib/services/sim_detection_service.dart`

### 3. `sms_autofill` (^2.3.0)
- **iOS Support**: ✅ Yes (with configuration)
- **Android Support**: ✅ Yes
- **iOS Setup Required**:
  - Add SMS autofill capability in Xcode
  - Configure in `Info.plist`
  - Uses iOS SMS verification codes feature

### 4. `permission_handler` (^11.3.1)
- **iOS Support**: ✅ Yes (with Info.plist entries)
- **Android Support**: ✅ Yes
- **iOS Setup Required**:
  - Add permission descriptions in `Info.plist`:
    - `NSPhotoLibraryUsageDescription`
    - `NSCameraUsageDescription`
    - `NSLocationWhenInUseUsageDescription`
    - `NSContactsUsageDescription`
    - `NSPhoneNumberUsageDescription` (if using mobile_number)

### 5. `firebase_messaging` (^14.9.1)
- **iOS Support**: ✅ Yes (with APNs setup)
- **Android Support**: ✅ Yes
- **iOS Setup Required**:
  - Configure Apple Push Notification service (APNs)
  - Add `GoogleService-Info.plist` to iOS project
  - Enable Push Notifications capability in Xcode
  - Configure APNs certificates

### 6. `flutter_local_notifications` (^17.2.1)
- **iOS Support**: ✅ Yes (with permissions)
- **Android Support**: ✅ Yes
- **iOS Setup Required**:
  - Request notification permissions
  - Configure notification categories in iOS

### 7. `app_links` (^6.3.3)
- **iOS Support**: ✅ Yes (with configuration)
- **Android Support**: ✅ Yes
- **iOS Setup Required**:
  - Configure Associated Domains in Xcode
  - Add `apple-app-site-association` file to web server
  - Already configured in `Info.plist` (applinks:kaaikani.co.in)

## ❌ Android-Only Packages

### 1. `in_app_update` (^4.2.3)
- **iOS Support**: ❌ No (Google Play Store only)
- **Android Support**: ✅ Yes
- **Action Required**: 
  - ⚠️ **CRITICAL**: Wrap all `in_app_update` calls with platform checks
  - Use `Platform.isAndroid` checks before calling `InAppUpdate.checkForUpdate()`
  - For iOS, implement App Store update check (use `app_store_version` package or custom implementation)
  - **Current Usage**: `lib/services/in_app_update_service.dart` - **NEEDS PLATFORM CHECKS**
  - **Recommendation**: 
    ```dart
    import 'dart:io' show Platform;
    
    if (Platform.isAndroid) {
      // Use in_app_update
    } else if (Platform.isIOS) {
      // Use App Store update check
    }
    ```

## 📋 Platform-Specific Code Found

### Files with Platform Checks:
1. **`lib/main.dart`**: Uses `kIsWeb` checks for Firebase initialization
2. **`lib/services/crashlytics_service.dart`**: Uses `kIsWeb` checks
3. **`lib/services/remote_config_service.dart`**: Uses `kIsWeb` checks
4. **`lib/services/graphql_client.dart`**: Uses `dart:io` (needs platform checks)
5. **`lib/utils/bill_generator.dart`**: Uses `dart:io` (needs platform checks)

### Services Needing iOS Alternatives:
1. **`lib/services/in_app_update_service.dart`**: 
   - Android: Google Play Store updates
   - iOS: Need App Store update check (different API)

2. **`lib/services/sim_detection_service.dart`**:
   - Android: Full SIM card access
   - iOS: Limited phone number detection (may need alternative)

## 🔧 Required iOS Configuration Steps

### 1. Info.plist Permissions
Add these keys to `ios/Runner/Info.plist`:

```xml
<!-- Phone Number Permission (if using mobile_number) -->
<key>NSPhoneNumberUsageDescription</key>
<string>We need access to your phone number for account verification</string>

<!-- SMS Autofill -->
<key>NSUserTrackingUsageDescription</key>
<string>We use this to improve your experience</string>

<!-- Camera (if used) -->
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan QR codes</string>

<!-- Photo Library (if used) -->
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to save images</string>
```

### 2. Podfile Configuration
Ensure `ios/Podfile` has:
```ruby
platform :ios, '12.0'  # Minimum iOS version (check package requirements)
```

### 3. Firebase iOS Setup
- Add `GoogleService-Info.plist` to `ios/Runner/`
- Configure APNs certificates
- Enable Push Notifications capability

### 4. Razorpay iOS Setup
- Add Razorpay iOS SDK to `Podfile`
- Configure payment capabilities
- Test payment flow on iOS

### 5. App Store Update Check
Replace `in_app_update` with App Store update check for iOS:
- Use `app_store_version` package or custom implementation
- Check App Store API for version comparison

## ✅ Action Items for iOS Integration

1. **✅ Test all packages** - Run `flutter pub get` and check for iOS compatibility warnings
2. **⚠️ Wrap `in_app_update`** - Add platform checks, create iOS alternative
3. **⚠️ Test `mobile_number`** - Verify iOS support, add fallback if needed
4. **✅ Configure permissions** - Add all required Info.plist entries
5. **✅ Setup Firebase** - Configure APNs and add GoogleService-Info.plist
6. **✅ Test Razorpay** - Verify iOS payment flow works
7. **✅ Test SMS autofill** - Verify iOS SMS verification codes work
8. **✅ Test deep links** - Verify app_links works on iOS
9. **✅ Test notifications** - Verify push notifications work on iOS
10. **✅ Build iOS app** - Run `flutter build ios` and fix any errors

## 🧪 Testing Checklist

- [ ] App builds for iOS without errors
- [ ] All Firebase services work (Messaging, Analytics, Crashlytics, Remote Config)
- [ ] Push notifications work on iOS
- [ ] Deep links work on iOS
- [ ] Payment (Razorpay) works on iOS
- [ ] SMS autofill works on iOS
- [ ] Permissions are requested correctly
- [ ] App Store update check works (if implemented)
- [ ] All UI components render correctly
- [ ] Dark mode works correctly
- [ ] Navigation works correctly

## 📚 Resources

- [Flutter iOS Setup Guide](https://docs.flutter.dev/platform-integration/ios/setup)
- [Razorpay iOS Integration](https://razorpay.com/docs/payments/mobile-apps/ios/)
- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
- [iOS Permissions Guide](https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/requesting_authorization_for_media_capture_on_ios)

