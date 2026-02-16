# Razorpay "SDK Compatibility Status" dialog

## What it is

When you open Razorpay checkout, you may see a **"SDK Compatibility Status"** dialog with:
- Version Upgrade Check: 1.5.2  
- Minimum Deployment Version Check: Project deployment target > iOS 10  
- Button: **"Hide alert forever !"**

This dialog is shown by the **Razorpay native iOS SDK** (razorpay-pod), not by our app code.

## Why it appears

Per [Razorpay’s iOS FAQ](https://razorpay.com/docs/payments/payment-gateway/ios-integration/standard/troubleshooting-faqs/):

- The message **does not appear to your customers** in production.
- It is shown only when:
  - You run the app on the **simulator**, or
  - You use a **test key** to initialise the SDK.

So in production (real device + live key), the alert should not show.

## How to get rid of it

1. **Dismiss it in the app**  
   Tap **"Hide alert forever !"** so the SDK stops showing it in this environment (it uses local storage).

2. **Use live key on a real device**  
   When testing with a **live key** on a **physical device**, the SDK typically does not show this alert.

3. **Options in code**  
   We pass `show_sdk_update_alert: false` and `ios.show_sdk_update_alert: false` in the Razorpay options to try to suppress the alert. Whether the current SDK version respects these depends on Razorpay’s implementation.

4. **Upgrade Razorpay SDK**  
   Razorpay recommends using the latest SDK. To upgrade:
   - In `ios/Podfile` (or via `razorpay_flutter` / CocoaPods), use the latest `razorpay-pod` version.
   - Run `pod install` in the `ios` folder.

## Summary

- The dialog is from Razorpay’s iOS SDK, not from our Flutter code.
- It is intended for development (simulator / test key) and should not be shown to end users in production.
- Use **"Hide alert forever !"** to dismiss it during development, or test with a live key on a real device to avoid it.
