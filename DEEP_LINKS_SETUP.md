# Deep Links / App Links Setup Guide

This app supports both **Custom URL Schemes** and **Universal Links (App Links)** for deep linking.

## Supported Link Formats

### Custom URL Scheme
- Format: `kaaikani://path?param=value`
- Examples:
  - `kaaikani://product?id=123`
  - `kaaikani://collection?slug=electronics`
  - `kaaikani://order?code=ABC123`
  - `kaaikani://cart`
  - `kaaikani://checkout`

### Universal Links (HTTPS)
- Format: `https://kaaikani.co.in/path?param=value`
- Examples:
  - `https://kaaikani.co.in/product?id=123`
  - `https://kaaikani.co.in/collection?slug=electronics`
  - `https://kaaikani.co.in/order?code=ABC123`
  - `https://kaaikani.co.in/cart`
  - `https://kaaikani.co.in/checkout`

## Supported Routes

| Path | Description | Query Parameters |
|------|-------------|------------------|
| `/product` | Open product detail page | `id` or `productId` |
| `/collection` or `/category` | Open collection/category page | `id`, `collectionId`, `slug`, or `collectionSlug` |
| `/order` or `/orders` | Open order detail or orders list | `id`, `orderId`, `code`, or `orderCode` |
| `/cart` | Open cart page | None |
| `/checkout` | Open checkout page | None |
| `/account` or `/profile` | Open account page | None |
| `/login` | Open login page | None |
| `/signup` or `/register` | Open signup page | None |
| `/home` | Navigate to home (clears navigation stack) | None |
| `/` or empty | Navigate to home | None |

## Testing Deep Links

### Android

#### Using ADB:
```bash
# Custom URL scheme
adb shell am start -W -a android.intent.action.VIEW -d "kaaikani://product?id=123" com.kaaikani.kaaikani

# Universal link
adb shell am start -W -a android.intent.action.VIEW -d "https://kaaikani.co.in/product?id=123" com.kaaikani.kaaikani
```

#### Using Browser:
1. Open Chrome browser on Android device
2. Type in address bar: `kaaikani://product?id=123`
3. The app should open automatically

### iOS

#### Using Terminal (Simulator):
```bash
xcrun simctl openurl booted "kaaikani://product?id=123"
xcrun simctl openurl booted "https://kaaikani.co.in/product?id=123"
```

#### Using Safari:
1. Open Safari on iOS device
2. Type in address bar: `kaaikani://product?id=123`
3. The app should open automatically

## Universal Links Setup (Additional Steps)

### For Android App Links:

1. **Create Digital Asset Links file** on your web server:
   - Location: `https://kaaikani.co.in/.well-known/assetlinks.json`
   - Content example:
   ```json
   [{
     "relation": ["delegate_permission/common.handle_all_urls"],
     "target": {
       "namespace": "android_app",
       "package_name": "com.kaaikani.kaaikani",
       "sha256_cert_fingerprints": [
         "YOUR_APP_SHA256_FINGERPRINT"
       ]
     }
   }]
   ```

2. **Get your app's SHA256 fingerprint:**
   ```bash
   # For debug keystore
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

   # For release keystore
   keytool -list -v -keystore /path/to/your/keystore.jks -alias your-key-alias
   ```

3. **Verify the setup:**
   ```bash
   # Use Google's Digital Asset Links API
   curl "https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://kaaikani.co.in&relation=delegate_permission/common.handle_all_urls"
   ```

### For iOS Universal Links:

1. **Enable Associated Domains in Xcode:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select Runner target → Signing & Capabilities
   - Click "+ Capability" → Add "Associated Domains"
   - Add: `applinks:kaaikani.co.in`

2. **Create apple-app-site-association file** on your web server:
   - Location: `https://kaaikani.co.in/.well-known/apple-app-site-association`
   - Content example:
   ```json
   {
     "applinks": {
       "apps": [],
       "details": [
         {
           "appID": "TEAM_ID.com.kaaikani.kaaikani",
           "paths": [
             "/product/*",
             "/collection/*",
             "/order/*",
             "/cart",
             "/checkout",
             "/account",
             "/login",
             "/signup",
             "/home"
           ]
         }
       ]
     }
   }
   ```
   - Replace `TEAM_ID` with your Apple Developer Team ID
   - File must be served with `Content-Type: application/json`
   - File must be accessible via HTTPS (no redirects)

3. **Verify the setup:**
   ```bash
   curl https://kaaikani.co.in/.well-known/apple-app-site-association
   ```

## Implementation Details

- **Service**: `lib/services/deep_link_service.dart`
- **Initialization**: Done in `main.dart` before app starts
- **Navigation**: Uses GetX routing (`Get.toNamed()`)
- **Error Handling**: Errors are logged but don't crash the app

## Customization

To add new routes, edit `lib/services/deep_link_service.dart` and add cases in the `_navigateFromLink()` method's switch statement.

## Notes

- Universal Links work only when the app is installed
- Custom URL schemes work even if the app is not installed (but will show an error)
- Deep links are handled automatically when the app is opened from a link
- Deep links are also handled when the app is already running

