import Flutter
import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import FBSDKCoreKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase before any plugin runs (removes "No app has been configured yet" log)
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    // So FCM notifications show when app is in foreground on physical device
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    // Required for FCM on physical device: register for remote notifications so APNs token is obtained
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Pass APNs token to Firebase so FCM can deliver to this device (fixes "token correct but no notification" on physical device)
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
  }

  // MARK: - Aggregated Event Measurement (AEM) / Facebook SDK
  // Required for AEM: measure app events from iOS 14.5+ users who opted out of app tracking.
  // Pass Universal Links from app ads to Facebook SDK for attribution and deep linking.
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    // Pass Universal Link to Facebook SDK for AEM and ad attribution (SDK v14.0.0+)
    ApplicationDelegate.shared.application(application, continue: userActivity)
    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}

// MARK: - Foreground notification presentation
extension AppDelegate {
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound, .badge, .list])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }
}
