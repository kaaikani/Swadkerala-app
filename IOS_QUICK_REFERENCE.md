# iOS Integration Quick Reference

## 🚨 Critical Issues to Fix

### 1. `in_app_update` - Android Only
**File**: `lib/services/in_app_update_service.dart`
**Issue**: No platform checks, will crash on iOS
**Fix**: Add platform checks before all `InAppUpdate` calls

```dart
import 'dart:io' show Platform;

Future<bool> checkForUpdate() async {
  if (!Platform.isAndroid) {
    // iOS: Use App Store update check instead
    return false;
  }
  // Android: Use in_app_update
  _updateInfo = await InAppUpdate.checkForUpdate();
  // ...
}
```

### 2. `mobile_number` - Limited iOS Support
**File**: `lib/services/sim_detection_service.dart`
**Issue**: iOS has restrictions on SIM access
**Fix**: Add platform checks and fallback

```dart
import 'dart:io' show Platform;

Future<List<SimInfo>> getAllSimInfo() async {
  if (!Platform.isAndroid) {
    // iOS: Return empty or use alternative method
    return [];
  }
  // Android: Use mobile_number package
  // ...
}
```

## ✅ Packages Status Summary

| Package | iOS Ready | Action Needed |
|---------|-----------|---------------|
| All Firebase packages | ✅ Yes | Configure APNs |
| `razorpay_flutter` | ✅ Yes | Setup iOS SDK in Podfile |
| `sms_autofill` | ✅ Yes | Configure Info.plist |
| `permission_handler` | ✅ Yes | Add Info.plist entries |
| `in_app_update` | ❌ No | Add platform checks + iOS alternative |
| `mobile_number` | ⚠️ Limited | Add platform checks + iOS fallback |
| All other packages | ✅ Yes | None |

## 📝 Required iOS Info.plist Entries

Add to `ios/Runner/Info.plist`:

```xml
<!-- Phone Number (if using mobile_number) -->
<key>NSPhoneNumberUsageDescription</key>
<string>We need access to your phone number for account verification</string>

<!-- SMS Autofill -->
<key>NSUserTrackingUsageDescription</key>
<string>We use this to improve your experience</string>
```

## 🔧 Quick Commands

```bash
# Check iOS compatibility
flutter doctor -v

# Build for iOS
flutter build ios

# Run on iOS simulator
flutter run -d ios

# Install iOS dependencies
cd ios && pod install && cd ..
```

## ⚠️ Platform-Specific Code Locations

1. `lib/services/in_app_update_service.dart` - Needs platform checks
2. `lib/services/sim_detection_service.dart` - Needs platform checks
3. `lib/services/graphql_client.dart` - Uses `dart:io` (may need checks)
4. `lib/utils/bill_generator.dart` - Uses `dart:io` (may need checks)





