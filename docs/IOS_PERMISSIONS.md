# iOS: Notification, Speech-to-Text, and Google Login (Allow)

How **notifications**, **speech-to-text**, and **Google Sign-In** are allowed and configured on iOS.

---

## 1. Notifications – Allow

- **What:** Push and local notifications (order updates, offers, reminders).
- **How it’s allowed:**
  - The app requests permission in code (e.g. `requestPermission()`). iOS shows the system dialog: **“Kaaikani Would Like to Send You Notifications”** with **Don’t Allow** / **Allow**.
  - No usage description key is required in `Info.plist` for this system dialog.
- **To enable in Xcode (if needed):** Signing & Capabilities → **Push Notifications**, and **Background Modes** → **Remote notifications**. The project uses **Runner.entitlements** with `aps-environment` (development/production) for push.
- **User:** When the app first asks, tap **Allow** to enable notifications.

### Push / FCM: physical device only

- **App notification (FCM) integration works only on a physical iOS device.** The iOS Simulator does not support Apple Push Notification service (APNs), so:
  - On **simulator:** You may see logs like `no valid "aps-environment" entitlement` or `didFailToRegisterForRemoteNotificationsWithError` — that is expected; push is not available there.
  - On a **physical device:** Use a provisioning profile that has the **Push Notifications** capability. Then the app can register for remote notifications and receive FCM messages.
- **To test push notifications:** Run the app on a **real iPhone/iPad** (not simulator), allow notifications when prompted, and send test messages from Firebase Console or your backend.

### If FCM token is saved but notifications are not received (especially “send to specific token” on iOS)

1. **Use the correct token for the device** – FCM tokens are **per-device and per-platform**. The log now shows platform, e.g. `[FCM] Token (iOS): ...` or `[FCM] Token (Android): ...`. If you trigger from Firebase to a **specific FCM token**:
   - **On iOS device:** Run the app **on the iOS device**, copy the token from the log line that says `[FCM] Token (iOS): ...`. Do **not** use a token from an Android run (tokens starting with `...:APA91b...` are Android); that will not deliver to the iOS device.
   - **On Android device:** Use a token from a run that shows `[FCM] Token (Android): ...`.
2. **APNs key in Firebase (required for iOS)** – Firebase cannot deliver to iOS without your APNs key:
   - [Firebase Console](https://console.firebase.google.com/) → Project → **Project settings** (gear) → **Cloud Messaging** tab.
   - Under **Apple app configuration**, upload your **APNs Authentication Key** (.p8) from Apple Developer, and set Key ID, Team ID, and Bundle ID (`com.kaaikani.kaaikani`). Without this, notifications to an iOS token will not be delivered.
3. **aps-environment** – In `ios/Runner/Runner.entitlements`, `aps-environment` should be `development` for debug builds and `production` for App Store/TestFlight. Mismatch can prevent delivery.
4. **Physical device** – Simulator does not support push. Use a real iPhone/iPad.
5. **Payload** – When sending to a single device, use a message that includes **Notification** (title + body). Data-only messages may not show in the notification center on iOS when the app is in background.
6. **Test from Firebase** – Cloud Messaging → “Send your first message” or “New campaign” → **Single device** → paste the **iOS** token from the log (from a run on the iOS device).

---

## 2. Speech-to-Text (Voice Search) – Allow

- **What:** Microphone and speech recognition for voice search.
- **How it’s allowed:**
  - **`NSSpeechRecognitionUsageDescription`** in `ios/Runner/Info.plist`: explains why speech recognition is used. System shows this when asking for speech recognition.
  - **`NSMicrophoneUsageDescription`** in `Info.plist`: explains why the microphone is used (for voice input).
  - User must tap **Allow** on both prompts when the app first uses voice search.
- **Plist strings (already in project):**
  - Speech: *“Allow speech recognition so you can use voice search”*
  - Microphone: *“Allow microphone access for voice search (speech to text)”*

---

## 3. Google Login – Allow

- **What:** Sign in with Google (OAuth).
- **How it’s allowed:**
  - **URL scheme** in `ios/Runner/Info.plist` under **CFBundleURLTypes**: the Google Sign-In callback URL scheme (reversed client ID, e.g. `com.googleusercontent.apps.XXXX-YYYY`). This allows the system to open your app again after the user signs in in the browser.
  - **Client ID** is read from **`.env`** only (`GOOGLE_CLIENT_ID`; optional `GOOGLE_CLIENT_ID_IOS`). Not from `GoogleService-Info.plist`.
  - No separate “permission” dialog; the user taps “Sign in with Google” in the app, completes sign-in in Safari/system browser, and is returned to the app.
- **If “Sign in with Google” fails:** Ensure the URL scheme in Info.plist matches the reversed client ID used on iOS (see [GOOGLE_AUTH_SETUP.md](./GOOGLE_AUTH_SETUP.md)).

---

## Summary

| Feature          | Where it’s allowed / configured |
|------------------|----------------------------------|
| **Notifications** | Requested in code; system dialog; Push Notifications + Remote notifications in Xcode if needed. |
| **Speech-to-text** | `NSSpeechRecognitionUsageDescription` + `NSMicrophoneUsageDescription` in `Info.plist`. |
| **Google login**   | `CFBundleURLTypes` (reversed client ID) in `Info.plist`; client ID from `.env`. |

All three are set up so the user can **allow** notifications, **allow** speech/microphone for voice search, and use **Sign in with Google** without extra plist-based blocks.
