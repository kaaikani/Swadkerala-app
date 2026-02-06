# Google Play Data Safety – Checklist

This doc helps you complete the **Data safety** section and fix the **"Device or other IDs"** declaration issue.

---

## 1. Data collection and security (form answers)

Use these answers in **Policy → App content → Data safety → Data collection and security**.

| Question | Answer | Notes |
|----------|--------|--------|
| **Does your app collect or share any of the required user data types?** | **Yes** | You collect device IDs, personal info (name, email, phone), purchase/order data, etc. |
| **Is all of the user data collected by your app encrypted in transit?** | **Yes** | Use **Yes** if your app only talks to servers over HTTPS (GraphQL/shop API, Firebase, etc.). |
| **Which methods of account creation does your app support?** | **Username and other authentication** and **OAuth** | Your app: (1) Phone number + OTP = username + other auth, (2) Google Sign-In = OAuth. Do **not** select "Username and password" unless you also have email/password sign-up. |
| **Delete account URL** | **Required** | You must add a URL. It can be: (a) a webpage (e.g. `https://yoursite.com/delete-account` or your privacy/contact page) that explains how to request account and data deletion, or (b) a deep link into the app if you have an in-app delete-account flow. The page/link must: mention your app/developer name, clearly explain steps to request deletion, and state what data is deleted or retained and retention period. |
| **Do you provide a way for users to request that some or all of their data is deleted without deleting their account?** | **Yes** / **No** / **No, but user data is automatically deleted within 90 days** | Choose **Yes** if you support partial data deletion (e.g. via support or in-app). **No** if you only offer full account deletion. **No, but...** only if you actually auto-delete within 90 days. |
| **Independent security review** | Optional | Only if you have had an independent review. |
| **UPI Payments verified** | Optional | Only for India UPI finance apps with NPCI accreditation. |

### Delete account URL – what you need to do

- **If you already have a web page** that explains how to request account/data deletion (or a contact/support form for that), use that URL.
- **If you don’t:** create a simple page (e.g. on your main website or help centre) that:
  - Is titled for your app/developer (e.g. “Kaaikani – Delete my account”).
  - Says how to request account and data deletion (e.g. email to support, or in-app “Delete account” in Account settings).
  - States what data is deleted (e.g. account, orders, addresses) and what is kept (e.g. anonymized analytics) and for how long.
- Then paste that URL into **Delete account URL** in the form.

---

## 2. Why “Device or other IDs” was flagged (Invalid Data safety form)

Google detected that your app (or SDKs inside it) **sends data that counts as "Device or other IDs"** off the device, but this was **not declared** in the Data safety section. Version code **188** was cited.

### What counts as "Device or other IDs"

- **Advertising ID** (e.g. GAID on Android)  
- **Android ID** / device identifiers  
- **Firebase Installation ID**  
- **FCM (Firebase Cloud Messaging) token**  
- **Crashlytics / analytics identifiers** that identify the device or app instance  

If any of these (or similar) are sent to your servers or to third‑party SDKs’ servers, you must declare **Device or other IDs** in the form.

---

## SDKs in this app that use Device or other IDs

| SDK / feature | What it does | Device/ID usage |
|---------------|--------------|------------------|
| **Firebase Analytics** | App analytics, events, screen views | Collects/sends analytics identifiers and device-related data (see [Firebase SDK Index](https://developers.google.com/privacy-safety/play-sdk-index)). |
| **Firebase Crashlytics** | Crash and error reporting | Uses device/installation identifiers to associate reports with an app instance. |
| **Firebase Cloud Messaging** | Push notifications | Uses **FCM token** (device/app instance identifier). |
| **Facebook App Events** (`facebook_app_events`) | Meta analytics / events | May collect or use **Advertising ID** and other identifiers (check [Meta’s data use](https://developers.facebook.com/docs/app-events)). |
| **Google Sign-In** | Sign in with Google | May use device/account identifiers as per Google’s SDK. |
| **Razorpay** | Payments | Payment SDKs often collect device/risk identifiers; check Razorpay’s Play SDK Index / privacy docs. |

Your app also sends **`x-device-medium`** (e.g. `"android"`) in API headers; that is a **category label**, not an ID. The main triggers for “Device or other IDs” are the SDKs above.

---

## How to fix (Option 1 – recommended): Update the Data safety form

You **must declare** the data type **"Device or other IDs"** and how it is used. Steps:

1. **Open Data safety**
   - Play Console → Your app → **Policy** → **App content** → **Data safety**.

2. **Data collection and security**
   - If you previously said the app does **not** collect any required user data, change that to **Yes**.
   - Complete all questions in this section (e.g. whether data is collected, shared, optional/required).

3. **Add “Device or other IDs”**
   - In the **Data types** section, find **Device or other IDs** (under the same name or under a “Device or other IDs” group).
   - **Select** “Device or other IDs”.

4. **Describe how this data is used**
   - For each purpose that applies, select the right options. For this app, typical choices are:
     - **Collected**: Yes.  
     - **Shared**: Yes, if any SDK sends it to third parties (e.g. Firebase/Google, Meta, Crashlytics).  
     - **Purposes**: e.g.  
       - **Analytics** (Firebase Analytics, Meta App Events)  
       - **Crash reporting / App functionality** (Crashlytics)  
       - **Push notifications / Messaging** (FCM)  
       - **Account management / Sign-in** (Google Sign-In)  
       - **Fraud prevention / security** (Razorpay, if they use device IDs)  
     - **Optional or required**: Usually **Required** for core features (e.g. push, crash reporting, analytics as implemented).
   - Use the exact wording and checkboxes Google shows; the above is a mapping from your app’s behaviour to the form.

5. **Other data types**
   - Declare any other types you collect or share (e.g. **User IDs**, **Email**, **Phone number**, **Purchase history**, **Location** if you use it), so the form stays consistent with the app and SDKs.

6. **Save and submit**
   - Save the Data safety section and **send the app for review** (e.g. via **Publishing overview** or your release flow).

After this, the “Invalid Data safety form” / “Device or other IDs not declared” finding for version code 188 (and future versions) should be resolved, as long as the declaration matches what the app and SDKs actually do.

---

## Optional: Declare other data types (if you use them)

To avoid further mismatches, ensure the form also reflects:

- **Personal info**: Name, email, phone (e.g. login, account, orders).  
- **Financial**: Purchase history, payment info (e.g. Razorpay, order history).  
- **App activity**: In-app actions, search, views (e.g. Firebase Analytics, Meta).  
- **Device or other IDs**: As above.

You can cross-check with [Google Play SDK Index](https://developers.google.com/privacy-safety/play-sdk-index) for each SDK’s declared data types.

---

## If you prefer to remove the functionality (Option 2)

If you do **not** want to declare Device or other IDs:

- You would need to **remove or replace** SDKs that collect/send them (e.g. disable or remove Firebase Analytics/Crashlytics/Messaging, Meta App Events, or any use of Advertising ID).
- Then ship **new builds** that do not send such data and **re-declare** Data safety (e.g. “No” for that type if you truly don’t collect it).

For most apps, **Option 1 (declare Device or other IDs)** is the practical fix.

---

## Summary

- **Cause**: App/SDKs send “Device or other IDs” (e.g. FCM token, analytics/Crashlytics IDs, possibly advertising ID) but it wasn’t declared.  
- **Fix**: In Play Console → Data safety, add **Device or other IDs**, state that it is **collected** (and **shared** if applicable), and set **purposes** (analytics, crash reporting, push, etc.).  
- **Reference**: Use [Google Play SDK Index](https://developers.google.com/privacy-safety/play-sdk-index) and each SDK’s privacy docs to align the form with actual behaviour.
