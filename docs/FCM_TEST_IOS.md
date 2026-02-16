# Send test notification to your iOS device (FCM)

Use this to trigger a notification on your iPhone/iPad with the message **"More offers in cart – click to browse coupon codes"**.

---

## Firebase Console notification not working on iOS — fix in 5 steps

1. **Upload APNs key (required)** — Firebase cannot send to iOS without it.  
   **Firebase Console** → your project → **Project settings** (gear) → open the **"Cloud Messaging"** tab at the top (not General) → **Apple app configuration** → **Upload** APNs Authentication Key (.p8). Set **Key ID**, **Team ID** `F987349LN6`, **Bundle ID** `com.kaaikani.kaaikani`.  
   Create the .p8 in [Apple Developer](https://developer.apple.com/account/resources/authkeys/list) → Keys → new key with **Apple Push Notifications service (APNs)**.

2. **Physical device** — Use a real iPhone/iPad; simulator does not support push.

3. **Allow notifications** — Tap Allow when the app asks, or Settings → Kaaikani → Notifications → ON.

4. **Correct FCM token** — Copy `[FCM] Token (iOS): ...` from the current run. In Firebase: Engage → Messaging → New campaign → Firebase Notification messages → Next → Send to single device → paste token.

5. **Notification title + text** — In the campaign set both **Notification title** and **Notification text**. Do not send only Custom data.

After uploading the APNs key (step 1), wait a minute and send again.

---

## Major reasons notifications don’t arrive on iOS (debug, physical device)

1. **APNs key not in Firebase** (most common — even with correct FCM token)  
   FCM **cannot** deliver to iOS without your **APNs Authentication Key** in Firebase.  
   - The APNs key is **not** in the “General” Project settings (where you see Bundle ID, Team ID, GoogleService-Info.plist).  
   - You must open the **Cloud Messaging** tab:  
     **Firebase Console** → your project → **Project settings** (gear) → at the top click the **“Cloud Messaging”** tab → scroll to **“Apple app configuration”** → **Upload** your **APNs Authentication Key** (.p8 file from Apple Developer), and set **Key ID**, **Team ID** (`F987349LN6`), **Bundle ID** (`com.kaaikani.kaaikani`).  
   - Without this step, sending to the correct FCM token will still not deliver on a physical device.

2. **Wrong or old FCM token**  
   Use the token from the **current** run on the **same** device after you’ve allowed notifications.  
   → In Xcode/run logs, copy `[FCM] Token (iOS): ...` or `[FCM] Token (after permission): ...` and paste it in Firebase “Send to single device”.

3. **Notifications not allowed**  
   When the app asks “Kaaikani Would Like to Send You Notifications”, tap **Allow**.  
   → If you tapped Don’t Allow, go to **Settings → Kaaikani → Notifications** and turn them on, then restart the app and use the new token.

4. **Data-only message**  
   For a message to show in the notification center (especially when app is in background), it must have **Notification** title and body in Firebase, not only custom data.

5. **Simulator**  
   Push does not work on the iOS Simulator. Use a **physical iPhone/iPad**.

---

## 1. Prerequisites

- **APNs key in Firebase** (required for iOS):
  - [Firebase Console](https://console.firebase.google.com/) → your project → **Project settings** (gear) → **Cloud Messaging** tab.
  - Under **Apple app configuration**, upload your **APNs Authentication Key** (.p8) and set Key ID, Team ID, Bundle ID `com.kaaikani.kaaikani`.
- App run on a **physical iOS device** (not simulator), with notifications **allowed**.
- FCM token copied from the log: `[FCM] Token (iOS): ...`

---

## 2. Send from Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/) → your project.
2. In the left menu, open **Engage** → **Messaging** (or **Cloud Messaging**).
3. Click **Create your first campaign** or **New campaign** → **Firebase Notification messages**.
4. **Notification content:**
   - **Notification title:** `More offers in cart`
   - **Notification text:** `Click to browse coupon codes`
5. Click **Next**.
6. **Targeting:** choose **Send to single device** (or “Send to device” / “Test on device”).
7. Paste your **FCM token** (the one from the app log, e.g. the iOS token you copied).
8. Click **Next** → **Review** → **Publish** (or **Send test message** if that option is shown).

---

## 3. Your current iOS FCM token

Use the token that appears in the app log when you run on your **iOS device**:

```
[FCM] Token (iOS): dSYiMl8zIErPpqOHc3Q53U:APA91bEYdzimDz6wgKoqj-dtFBlejSiitzjwurKETcHmIrgWybhounyR03U-BPhjanPqro1jg8UQzDSIPZVi-ADgBzVASJshxoIzpN1RHRJGsyiXoAOnBqY
```

Copy the part **after** `(iOS): ` and paste it in Firebase when asked for the device token.

**Note:** Tokens can change (e.g. after reinstall or token refresh). If the notification does not arrive, run the app on the iOS device again and use the latest `[FCM] Token (iOS): ...` from the log.

---

## 4. If the notification does not arrive on iOS

- Confirm **APNs key** is uploaded in Firebase (Project settings → Cloud Messaging → Apple app configuration).
- Confirm you are testing on a **physical iPhone/iPad** (not simulator).
- Use the **latest** token from a run on that **same** iOS device.
- Try with the app in **background** or **closed**; the message must have **Notification** title and text (as above), not only custom data.
