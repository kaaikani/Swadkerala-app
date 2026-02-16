# Google Sign-In setup (env-only, no GoogleService-Info.plist)

Google Auth in this app uses **only `.env`** for the client ID. The app does **not** read Google Sign-In config from `GoogleService-Info.plist` (that file is for Firebase only: FCM, Analytics, etc.).

## 1. Add to `.env`

```env
# Web OAuth client ID (for ID token / backend verification).
# From Google Cloud Console → Credentials → OAuth 2.0 Client ID (Web).
GOOGLE_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

**Required on iOS** – Google does **not** allow custom URL schemes (e.g. `com.googleusercontent.apps.xxx`) for the **Web** client type. You will see "Access blocked - Custom schema URLs are not allowed for web client type" if you use only the Web client on iOS. You must create an **iOS** OAuth client and set:

```env
# Required on iOS. From Google Cloud Console → Credentials → OAuth client ID → iOS (Bundle ID: com.kaaikani.kaaikani).
GOOGLE_CLIENT_ID_IOS=YOUR_IOS_CLIENT_ID.apps.googleusercontent.com
```

**Important (iOS):** The URL scheme in `ios/Runner/Info.plist` (under `CFBundleURLTypes`) must be the **reversed** form of your **iOS** client ID (`GOOGLE_CLIENT_ID_IOS`), not the Web client. Example: client ID `12345-xxx.apps.googleusercontent.com` → scheme `com.googleusercontent.apps.12345-xxx`.

---

## 2. How to get Bundle ID, App Store ID, Team ID (for Google Cloud / Firebase)

You need these when creating an **iOS OAuth 2.0 Client** in Google Cloud Console or when configuring the iOS app in Firebase.

### Bundle ID

- **What it is:** Your app’s unique identifier on Apple (e.g. `com.kaaikani.kaaikani`).
- **Where to get it:**
  1. Open the project in **Xcode** → select the **Runner** target.
  2. **General** tab → **Identity** → **Bundle Identifier**.
  - Or: `ios/Runner.xcodeproj` → open in Xcode → Runner target → General → Bundle Identifier.
- **Used for:** iOS OAuth client in Google Cloud, Firebase iOS app config.

### Team ID

- **What it is:** Your Apple Developer Team ID (10-character string, e.g. `ABC123XYZ1`).
- **Where to get it:**
  1. [Apple Developer](https://developer.apple.com/account) → **Membership** → **Team ID**.
  2. Or in **Xcode**: **Signing & Capabilities** for the Runner target → **Team** dropdown → hover or click your team → Team ID is shown.
  3. Or: **Xcode** → **Preferences** (or **Settings**) → **Accounts** → select your Apple ID → select your team → **Team ID**.
- **Used for:** Sometimes required in Firebase/Google Cloud for iOS app or OAuth setup.

### App Store ID

- **What it is:** The numeric ID of your app on the App Store (e.g. `1234567890`), only after the app is published.
- **Where to get it:**
  1. [App Store Connect](https://appstoreconnect.apple.com) → **My Apps** → select your app.
  2. **App Information** → **Apple ID** (this is the App Store ID).
  3. Or from the app’s URL: `https://apps.apple.com/app/id**1234567890**` → the number is the App Store ID.
- **Used for:** Optional in Firebase (e.g. “App Store ID” in project settings); not required for Google Sign-In OAuth client creation.

---

## 3. Create OAuth clients in Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/) → your project.
2. **APIs & Services** → **Credentials** → **Create Credentials** → **OAuth client ID**.
3. **Application type:**
   - **Web application** → create one; use this value as `GOOGLE_CLIENT_ID` in `.env` (for backend ID token).
   - **iOS** → create one; use your **Bundle ID** from step 2 above. Use this client’s ID for iOS native sign-in (and for the iOS URL scheme below if you use a separate iOS client).

---

## 4. iOS: URL scheme in Info.plist (required for callback)

After the user signs in, Google opens a URL back into your app. That URL uses a **reversed client ID** scheme. It must be in `ios/Runner/Info.plist`; the app does **not** read this from `GoogleService-Info.plist`.

- **Rule:** The URL scheme must be the **reversed** form of your **iOS** OAuth client ID (`GOOGLE_CLIENT_ID_IOS`). Do **not** use the Web client ID here (Google blocks "Custom schema URLs are not allowed for web client type").
  - Example: iOS client ID  
    `349081914352-xxxx.apps.googleusercontent.com`  
    → scheme  
    `com.googleusercontent.apps.349081914352-xxxx`
- **Where to set it:**  
  `ios/Runner/Info.plist` → **CFBundleURLTypes** → one entry with **CFBundleURLSchemes** = `com.googleusercontent.apps.XXXX-YYYY` (your reversed client ID).

If you change `GOOGLE_CLIENT_ID` (or `GOOGLE_CLIENT_ID_IOS`) in `.env`, update this URL scheme in Info.plist to match the reversed value.

---

## 5. Google account from phone (avoid web view) – use iOS client

If on the **phone** sign-in opens a **web view** or browser instead of showing an account picker or using accounts already on the device:

1. **Create an iOS OAuth client** (see section 3): Google Cloud Console → Credentials → Create OAuth client ID → **iOS** → Bundle ID `com.kaaikani.kaaikani`.
2. **Set `GOOGLE_CLIENT_ID_IOS`** in `.env` to that iOS client’s ID (e.g. `XXXX-YYYY.apps.googleusercontent.com`).
3. **Update the URL scheme** in `ios/Runner/Info.plist`: it must be the **reversed** form of this **iOS** client ID (e.g. `com.googleusercontent.apps.XXXX-YYYY`), not the Web client.
4. Keep **`GOOGLE_CLIENT_ID`** as your **Web** client ID (used for `serverClientId` and backend).

With the iOS client set, the app uses the native-style flow on the phone and fetches the account in-app instead of relying on a full web view.

---

## 6. "Access blocked" or "Authorized error" when signing in (web page opens)

If tapping **Connect with Google** opens a browser/web page that shows **"Access blocked"** or **"This app isn't verified"** or an authorized/redirect error, the cause is almost always **Google Cloud OAuth consent** or **redirect** configuration.

### Fix 1: Add your account as a Test user (app in Testing)

1. Open [Google Cloud Console](https://console.cloud.google.com/) → your project.
2. Go to **APIs & Services** → **OAuth consent screen**.
3. If **Publishing status** is **Testing**, only accounts listed under **Test users** can sign in. Others see "Access blocked".
4. Click **+ ADD USERS** under Test users and add the Gmail address you use to sign in (e.g. `yourname@gmail.com`).
5. Save. Try **Connect with Google** again on the phone.

### Fix 2: Publish the app (for real users)

- To allow any Google user (not just test users), set **Publishing status** to **In production** on the OAuth consent screen. This may require verification for sensitive scopes.

### Fix 3: Redirect / client configuration (if you see "redirect_uri" or "invalid request")

- **iOS:** Ensure the **iOS** OAuth client exists and its **Bundle ID** matches your app (`com.kaaikani.kaaikani`). The URL scheme in `ios/Runner/Info.plist` must be the **reversed** iOS client ID (see section 4).
- **Web client:** `GOOGLE_CLIENT_ID` in `.env` must be the **Web application** client ID. Do not use the iOS client ID there.
- **iOS client:** If you use `GOOGLE_CLIENT_ID_IOS`, it must be the **iOS** OAuth client ID; the Info.plist URL scheme must match that client.

---

## 7. Summary

| Item        | Where to get it | Where to use it |
|------------|------------------|------------------|
| **Bundle ID**   | Xcode → Runner target → General → Bundle Identifier | Google Cloud iOS OAuth client; Firebase iOS app |
| **Team ID**     | developer.apple.com → Membership, or Xcode → Signing & Capabilities / Accounts | Firebase / Apple config if asked |
| **App Store ID**| App Store Connect → App → App Information → Apple ID | Optional in Firebase; not for OAuth client |
| **GOOGLE_CLIENT_ID** | Google Cloud → Credentials → Web OAuth client | `.env` only; app does not read from `GoogleService-Info.plist` |
| **GOOGLE_CLIENT_ID_IOS** | Google Cloud → Credentials → iOS OAuth client (Bundle ID) | `.env` on iOS so sign-in uses in-app flow instead of web view (see section 5) |
| **Access blocked** | OAuth consent in Testing + your email not in Test users | Add your Gmail under OAuth consent screen → Test users (see section 6) |
