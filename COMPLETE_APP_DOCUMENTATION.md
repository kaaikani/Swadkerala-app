# Kaaikani E-Commerce App - Complete Documentation

## Table of Contents
1. [Technical Specifications](#technical-specifications)
2. [Setup Instructions](#setup-instructions)
3. [App Flow & Functions](#app-flow--functions)
4. [App Version Management](#app-version-management)
5. [Firebase Notification Setup](#firebase-notification-setup)
6. [Build & Deployment](#build--deployment)

---

## Technical Specifications

### Flutter & Dart Versions
- **Flutter Version**: 3.35.5 (stable channel)
- **Dart Version**: 3.9.2
- **Framework Revision**: ac4e799d23
- **Engine Hash**: 0274ead41f6265309f36e9d74bc8c559becd5345
- **DevTools**: 2.48.0

### SDK Requirements
- **Minimum Dart SDK**: >=2.17.6 <4.0.0
- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 12.0+

### Current App Version
- **Version**: 2.0.97+178
- **Location**: `pubspec.yaml` (line 18)
- **Format**: `version: <major>.<minor>.<patch>+<build_number>`
  - Example: `2.0.97+178` means version 2.0.97, build 178

---

## Setup Instructions

### After Git Clone - Complete Setup Process

#### Step 1: Generate GraphQL Schema
```bash
# Generate schema.graphql from your GraphQL endpoint
# Place the schema file in: lib/graphql/schema.graphql
```

#### Step 2: Generate Dart Files from GraphQL
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

This will generate:
- `lib/graphql/*.graphql.dart` files
- All GraphQL query/mutation type definitions

#### Step 3: Install Dependencies
```bash
flutter pub get
```

#### Step 4: Generate Splash Screen
```bash
dart run flutter_native_splash:create
```

**Configuration** (in `pubspec.yaml`):
```yaml
flutter_native_splash:
  color: "#4CB150"
  image: "assets/images/kk.png"
  fullscreen: true
  android: true
  ios: true
  image_dark: "assets/images/kk.png"
  color_dark: "#4CB150"
  android_12:
    image: "assets/images/kk.png"
    icon_background_color: "#4CB150"
    icon_background_color_dark: "#4CB150"
```

#### Step 5: Generate Launcher Icon
```bash
dart run flutter_launcher_icons
```

**Configuration** (in `pubspec.yaml`):
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/kklogo.png"
  adaptive_icon_background: "#4CB150"
  adaptive_icon_foreground: "assets/images/kklogo_padded.png"
  remove_alpha_ios: true
```

#### Step 6: Run the App
```bash
flutter run
```

#### Step 7: Build APK
```bash
flutter build apk --release
```

**Output Location**: `build/app/outputs/flutter-apk/app-release.apk`

---

## App Flow & Functions

### Authentication Flow

#### 1. Initial Route (`InitialRouteWrapper`)
**File**: `lib/pages/initial_route_wrapper.dart`

**Functions Called**:
- `_checkAuthentication()` - Checks if user is authenticated
- `_checkOnboarding()` - Checks if onboarding is completed
- Navigation to:
  - Onboarding (if first launch)
  - Login (if not authenticated)
  - Home (if authenticated)

#### 2. Login Page (`LoginPage`)
**File**: `lib/pages/login_page.dart`

**initState Functions**:
- `AnalyticsService().logScreenView(screenName: 'Login')`
- `_initializeAnimations()` - Sets up fade/slide animations
- `_initializeSmsAutofill()` - Initializes SMS OTP autofill
- `_clearAllCache()` - Clears cached data
- `_authController.resetFormField()` - Resets form fields
- `_autoFillPhoneNumber()` - Auto-fills phone from SIM card

**Key Functions**:
- `_handlePhoneSubmit()` - Validates phone and sends OTP
  - Calls: `_authController.sendOtpForLogin(phoneNumber)`
- `_handleOtpSubmit()` - Verifies OTP and logs in
  - Calls: `_authController.loginWithPhoneOtp(phoneNumber, otp)`
- `_authController.loginWithPhoneOtp()` - Main login function
  - Calls: `GraphqlService.client.mutate$LoginWithPhoneOtp()`
  - Extracts auth token from response headers
  - Fetches channels by phone number
  - Sets channel token
  - Navigates to home

**Navigation**: 
- Success → Home page
- Failure → Shows error dialog

#### 3. Register/Signup Page (`SignupPage`)
**File**: `lib/pages/signup_page.dart`

**initState Functions**:
- `_initializeAnimations()` - Sets up animations
- `_initializeSmsAutofill()` - Initializes SMS autofill
- `_authController.resetFormField()` - Resets form

**Key Functions**:
- `_nextStep()` - Validates and moves to next step
  - Step 1: Validates name and phone, sends OTP
  - Step 2: Validates OTP and registers
- `_handleFinalSubmit()` - Final registration
  - Calls: `_authController.checkChannelsByPhoneNumber()`
  - Calls: `_authController.sendOtpForRegistration()`
  - Calls: `_authController.verifyOtpForRegistration()`
- `_authController.verifyOtpForRegistration()` - Main registration
  - Calls: `GraphqlService.client.mutate$Authenticate()`
  - Extracts auth token
  - Skips channel fetching (set when user selects postal code)
  - Navigates to home

**Navigation**:
- Success → Home page
- Failure → Shows error dialog

### Main App Flow

#### 4. Home Page (`MyHomePage`)
**File**: `lib/pages/homepage.dart`

**initState Functions**:
- `_updateChannelDisplay()` - Updates channel display
- `_checkPostalCodeAndChannels()` - Checks postal code and validates channels
  - Gets postal code from GetStorage
  - Calls: `customerController.getAvailableChannels()`
  - Shows postal code bottom sheet if no available CITY channel
- `_refreshData()` - Main data refresh function
  - `_isUserAuthenticated()` - Checks authentication
  - If authenticated:
    - `customerController.getActiveCustomer()`
    - `cartController.getActiveOrder()`
    - `bannerController.getCustomerFavorites()`
    - `_checkAndShowShippingAddressDialog()`
  - Always:
    - `collectionController.fetchAllCollections()`
    - `bannerController.getBannersForChannel()`
    - `bannerController.getFrequentlyOrderedProducts()`
  - `_checkAndShowPostalCodeDialog()` - Checks postal code
- `_checkNotificationPermission()` - Checks notification permissions

**Key Functions**:
- `_checkPostalCodeAndChannels()` - Validates postal code and channels
- `_refreshData()` - Refreshes all home page data
- `_checkAndShowPostalCodeDialog()` - Shows postal code dialog if needed
- `_checkAndShowShippingAddressDialog()` - Shows address dialog if needed
- `_showPostalCodeBottomSheet()` - Shows postal code selection sheet
- `_showSwitchStoreBottomSheet()` - Shows store switching sheet

**Navigation**:
- Product tap → Product detail page
- Collection tap → Collection products page
- Cart icon → Cart page
- Account icon → Account page

#### 5. Cart Page (`CartPage`)
**File**: `lib/pages/cart_page.dart`

**initState Functions**:
- `WidgetsBinding.instance.addObserver(this)` - Adds lifecycle observer
- `_blinkAnimationController` - Initializes blink animation
- `_refreshData()` - Main refresh function
  - `cartController.getActiveOrder()` - Gets cart
  - `customerController.getActiveCustomer()` - Gets customer data
  - `orderController.getEligibleShippingMethods()` - Gets shipping methods
  - `_loadExistingShippingMethod()` - Loads existing shipping method
  - `_loadExistingCouponCodes()` - Loads applied coupons
  - `_loadExistingLoyaltyPoints()` - Loads loyalty points
  - `_loadExistingInstructions()` - Loads delivery instructions
- `AnalyticsService().logScreenView(screenName: 'Cart')`

**Key Functions**:
- `_refreshData()` - Refreshes cart data
- `_loadExistingShippingMethod()` - Loads shipping method from order
- `_applyShippingMethod()` - Applies selected shipping method
  - Calls: `orderController.setShippingMethod()`
  - Calls: `cartController.getActiveOrder()` - Refreshes cart
  - Calls: `_refreshPaymentMethods()` - Refreshes payment methods
- `_applyCouponCode()` - Applies coupon code
  - Calls: `orderController.applyCouponCode()`
- `_applyLoyaltyPoints()` - Applies loyalty points
  - Calls: `orderController.applyLoyaltyPoints()`
- `_updateInstructions()` - Updates delivery instructions
  - Calls: `orderController.updateOrderCustomFields()`

**Navigation**:
- Checkout button → Checkout page
- Product tap → Product detail page
- Address change → Addresses page

#### 6. Checkout Page (`CheckoutPage`)
**File**: `lib/pages/checkout_page.dart`

**initState Functions**:
- `WidgetsBinding.instance.addObserver(this)` - Lifecycle observer
- `_razorpayService = RazorpayService()` - Initializes Razorpay
- `_loadCustomerAddresses()` - Loads customer addresses
  - `orderController.getActiveOrder()` - Gets active order
  - `customerController.getActiveCustomer()` - Gets customer
  - `_setShippingAddressFromSelected()` - Sets shipping address
- `Future.wait([...])` - Parallel loading:
  - `_loadShippingMethods()` - Gets shipping methods
  - `_refreshPaymentMethods()` - Gets payment methods
  - `_loadCouponCodes()` - Gets coupon codes
- `_loadExistingShippingMethod()` - Loads existing method
- `_loadExistingInstructions()` - Loads instructions
- `_loadExistingCouponCodes()` - Loads applied coupons
- `_loadExistingLoyaltyPoints()` - Loads loyalty points

**Key Functions**:
- `_loadCustomerAddresses()` - Loads and sets delivery address
- `_setShippingAddressFromSelected()` - Sets shipping address to order
  - Calls: `orderController.setShippingAddress()`
- `_applyShippingMethod()` - Applies shipping method
  - Calls: `orderController.setShippingMethod()`
- `_handleRazorpayPayment()` - Handles Razorpay payment
  - Creates Razorpay order
  - Opens Razorpay checkout
  - On success:
    - `orderController.addPayment()` - Adds payment to order
    - `orderController.transitionToNextState()` - Transitions order
    - `cartController.clearCart()` - Clears cart
    - Navigates to order confirmation
- `_handleCODPayment()` - Handles Cash on Delivery
  - `orderController.transitionToArrangingPayment()` - Transitions state
  - `orderController.addPayment()` - Adds payment
  - Navigates to order confirmation

**Navigation**:
- Place order → Order confirmation page
- Change address → Addresses page
- Payment failure → Stays on checkout (shows error dialog)

#### 7. Account Page (`AccountPage`)
**File**: `lib/pages/account_page.dart`

**initState Functions**:
- `customerController.getActiveCustomer()` - Gets customer data
- `orderController.getActiveOrder()` - Gets cart count
- `AnalyticsService().logScreenView(screenName: 'Account')`

**Key Functions**:
- `_loadCustomerData()` - Loads customer information
- `_updateProfile()` - Updates customer profile
  - Calls: `customerController.updateCustomer()`
- `_updateEmail()` - Updates email
  - Calls: `customerController.updateProfileEmail()`
- `_logout()` - Logs out user
  - Calls: `customerController.logout()`
  - Navigates to login

**Navigation**:
- Orders → Orders page
- Addresses → Addresses page
- Logout → Login page

#### 8. Orders Page (`OrdersPage`)
**File**: `lib/pages/orders_page.dart`

**initState Functions**:
- `customerController.getActiveCustomer()` - Gets customer
- `_loadOrders()` - Loads orders
  - Calls: `customerController.getCustomerOrders()`

**Key Functions**:
- `_loadOrders()` - Loads customer orders
- `_refreshOrders()` - Refreshes orders list
- `_loadMoreOrders()` - Loads more orders (pagination)

**Navigation**:
- Order tap → Order detail page

#### 9. Addresses Page (`AddressesPage`)
**File**: `lib/pages/addresses_page.dart`

**initState Functions**:
- `customerController.getActiveCustomer()` - Gets customer
- `_loadAddresses()` - Loads addresses

**Key Functions**:
- `_loadAddresses()` - Loads customer addresses
- `_createAddress()` - Creates new address
  - Calls: `customerController.createCustomerAddress()`
- `_updateAddress()` - Updates address
  - Calls: `customerController.updateCustomerAddress()`
- `_deleteAddress()` - Deletes address
  - Calls: `customerController.deleteCustomerAddress()`
- `_setDefaultAddress()` - Sets default address
  - Calls: `customerController.updateCustomerAddress()`

**Navigation**:
- Back → Previous page
- Add address → Address form

### Protected Routes (Require Authentication)
All routes with `AuthGuard()` middleware:
- `/cart` - Cart page
- `/checkout` - Checkout page
- `/account` - Account page
- `/addresses` - Addresses page
- `/orders` - Orders page
- `/order-confirmation` - Order confirmation
- `/order-detail` - Order detail
- `/product-detail` - Product detail
- `/favourite` - Favorites page
- `/loyalty-points-transactions` - Loyalty points
- `/frequently-ordered` - Frequently ordered

---

## App Version Management

### Where to Change App Version

**File**: `pubspec.yaml`
**Line**: 18

```yaml
version: 2.0.97+178
```

**Format**: `version: <major>.<minor>.<patch>+<build_number>`

### Version Components:
- **Major Version** (2): Breaking changes
- **Minor Version** (0): New features, backward compatible
- **Patch Version** (97): Bug fixes
- **Build Number** (178): Incremental build number

### How to Update Version:

1. **For Bug Fixes** (Patch):
   ```yaml
   version: 2.0.98+179  # Increment patch and build
   ```

2. **For New Features** (Minor):
   ```yaml
   version: 2.1.0+179  # Increment minor, reset patch, increment build
   ```

3. **For Breaking Changes** (Major):
   ```yaml
   version: 3.0.0+179  # Increment major, reset minor/patch, increment build
   ```

### Android Version Mapping:
- **versionName**: `2.0.97` (from version field)
- **versionCode**: `178` (from build number)

### iOS Version Mapping:
- **CFBundleShortVersionString**: `2.0.97` (from version field)
- **CFBundleVersion**: `178` (from build number)

---

## Firebase Notification Setup

### Firebase Cloud Messaging (FCM) Configuration

#### 1. Firebase Project Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create/Select your project
3. Add Android app:
   - Package name: `com.recipe.app` (check `android/app/build.gradle.kts`)
   - Download `google-services.json`
   - Place in: `android/app/google-services.json`
4. Add iOS app (if needed):
   - Bundle ID: Check `ios/Runner.xcodeproj`
   - Download `GoogleService-Info.plist`
   - Place in: `ios/Runner/GoogleService-Info.plist`

#### 2. Notification Channel Configuration

**Channel ID**: `kaaikani_updates`
**Channel Name**: `Kaaikani Updates`
**Importance**: `High` (Required for heads-up notifications)

**File**: `lib/services/notification_service.dart`

```dart
static const AndroidNotificationChannel _defaultChannel =
    AndroidNotificationChannel(
  'kaaikani_updates',
  'Kaaikani Updates',
  description: 'Order, cart, and promotional updates from Kaaikani',
  importance: Importance.high, // HIGH IMPORTANCE = Heads-up notifications
  playSound: true,
  enableVibration: true,
  showBadge: true,
);
```

#### 3. Sending Notifications from Firebase Console

**Steps**:
1. Go to Firebase Console → Cloud Messaging
2. Click "Send your first message" or "New notification"
3. Fill in:
   - **Title**: Your notification title
   - **Text**: Your notification body
4. Click "Additional options (optional)" to expand
5. In "Custom data", add:
   - Key: `channel_id`
   - Value: `kaaikani_updates`
   - Key: `priority`
   - Value: `high`
   - Key: `sound`
   - Value: `default`
6. Click "Review" → "Publish"

#### 4. Sending Notifications via FCM API

**HTTP v1 API Request**:
```json
{
  "message": {
    "token": "USER_FCM_TOKEN",
    "notification": {
      "title": "New Order!",
      "body": "Your order #1234 has been confirmed"
    },
    "android": {
      "priority": "high",
      "notification": {
        "channel_id": "kaaikani_updates",
        "sound": "default",
        "priority": "high"
      }
    },
    "data": {
      "order_id": "1234",
      "type": "order_update"
    }
  }
}
```

**cURL Example**:
```bash
curl -X POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "token": "USER_FCM_TOKEN",
      "notification": {
        "title": "New Order!",
        "body": "Your order has been confirmed"
      },
      "android": {
        "priority": "high",
        "notification": {
          "channel_id": "kaaikani_updates",
          "sound": "default",
          "priority": "high"
        }
      }
    }
  }'
```

**Node.js Example**:
```javascript
const admin = require('firebase-admin');

const message = {
  token: 'USER_FCM_TOKEN',
  notification: {
    title: 'New Order!',
    body: 'Your order has been confirmed',
  },
  android: {
    priority: 'high',
    notification: {
      channelId: 'kaaikani_updates',
      sound: 'default',
      priority: 'high',
    },
  },
  data: {
    order_id: '1234',
    type: 'order_update',
  },
};

admin.messaging().send(message);
```

#### 5. Key Requirements for Heads-Up Notifications

✅ **High Importance Channel** (`Importance.high`) - Required for heads-up
✅ **High Priority** (`Priority.high`) - Shows when app is closed
✅ **Correct Channel ID** (`kaaikani_updates`) - Must match in FCM payload
✅ **FCM Priority** (`"priority": "high"`) - In Android notification config

#### 6. Notification Behavior

**When App is CLOSED**:
- FCM receives notification
- Android shows system heads-up notification (banner at top)
- User taps → Opens app

**When App is OPEN**:
- FCM receives notification
- Shows heads-up notification + in-app snackbar

#### 7. Troubleshooting

**Heads-up not showing?**
1. Check channel importance is `Importance.high`
2. Check FCM payload has `"priority": "high"`
3. Check channel ID matches: `kaaikani_updates`
4. Check device notification settings
5. Check battery optimization settings
6. Check Do Not Disturb mode

---

## Build & Deployment

### Development Build
```bash
flutter run
```

### Release APK Build
```bash
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk`

### Release App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

### iOS Build
```bash
flutter build ios --release
```

### Clean Build
```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

## Important Files Reference

### Configuration Files
- `pubspec.yaml` - Dependencies, version, assets
- `android/app/build.gradle.kts` - Android build config
- `ios/Runner.xcodeproj` - iOS project config
- `android/app/google-services.json` - Firebase Android config
- `ios/Runner/GoogleService-Info.plist` - Firebase iOS config

### Key Source Files
- `lib/main.dart` - App entry point
- `lib/routes.dart` - Route definitions
- `lib/pages/` - All page widgets
- `lib/controllers/` - Business logic controllers
- `lib/services/` - Service layer (GraphQL, Firebase, etc.)
- `lib/graphql/` - GraphQL queries, mutations, generated files

### GraphQL Files
- `lib/graphql/schema.graphql` - GraphQL schema
- `lib/graphql/*.graphql` - Query/mutation definitions
- `lib/graphql/*.graphql.dart` - Generated Dart files

---

## Quick Command Reference

```bash
# Setup after clone
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run flutter_native_splash:create
dart run flutter_launcher_icons
flutter run

# Build
flutter clean
flutter pub get
flutter build apk --release

# Generate GraphQL files
dart run build_runner build --delete-conflicting-outputs

# Generate splash screen
dart run flutter_native_splash:create

# Generate launcher icons
dart run flutter_launcher_icons
```

---

## Support & Troubleshooting

### Common Issues

1. **GraphQL files not generating**:
   - Check `schema.graphql` exists
   - Run: `dart run build_runner build --delete-conflicting-outputs`

2. **Splash screen not showing**:
   - Check `assets/images/kk.png` exists
   - Run: `dart run flutter_native_splash:create`

3. **Notifications not working**:
   - Check `google-services.json` is in correct location
   - Verify channel ID matches: `kaaikani_updates`
   - Check notification permissions

4. **Build fails**:
   - Run: `flutter clean`
   - Run: `flutter pub get`
   - Check Flutter version: `flutter --version`

5. **App Bundle Signed with Wrong Key**:
   - Error: "Your Android App Bundle is signed with the wrong key"
   - **Solution**: Use the correct keystore file
   - **Steps**:
     1. Find the keystore with matching SHA1 fingerprint
     2. Create `android/key.properties` file:
        ```properties
        storeFile=/path/to/your/upload-keystore.jks
        storePassword=YOUR_KEYSTORE_PASSWORD
        keyAlias=upload
        keyPassword=YOUR_KEY_PASSWORD
        ```
     3. Rebuild the app bundle: `flutter build appbundle --release`
   - **Find Correct Keystore**: Run `./find_correct_keystore.sh` script
   - **Verify SHA1**: `keytool -list -v -keystore /path/to/keystore.jks -alias upload`

---

## Keystore Signing Configuration

### Location
- **Configuration File**: `android/key.properties`
- **Build Config**: `android/app/build.gradle.kts` (lines 86-95)

### Required Information
```properties
storeFile=/absolute/path/to/upload-keystore.jks
storePassword=YOUR_KEYSTORE_PASSWORD
keyAlias=upload
keyPassword=YOUR_KEY_PASSWORD
```

### Finding the Correct Keystore

**Expected SHA1**: `FC:DF:E1:8F:73:8E:87:6A:88:00:55:A5:ED:8F:DE:40:E5:8F:79:AD`

**Check Keystore SHA1**:
```bash
keytool -list -v -keystore /path/to/keystore.jks -alias upload
```

**Common Keystore Locations**:
- `/home/rootuser/Desktop/test release /sriram(no points)/old2/upload-keystore.jks`
- `/home/rootuser/Desktop/3.1.0/old2/upload-keystore.jks`
- `/home/rootuser/Desktop/localsetup/old2/upload-keystore.jks`

**Helper Script**: Run `./find_correct_keystore.sh` to automatically find the correct keystore.

### Important Notes
- ⚠️ **Never commit `key.properties` to version control**
- ⚠️ **Keep keystore file secure and backed up**
- ⚠️ **Losing the keystore means you cannot update the app on Play Store**

---

**Document Version**: 1.0
**Last Updated**: 2025-01-22
**App Version**: 2.0.97+178

