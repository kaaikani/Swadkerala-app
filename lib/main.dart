import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:recipe.app/pages/error_page.dart';
import 'package:recipe.app/services/graphql_client.dart';
import 'package:recipe.app/services/in_app_update_service.dart';
import 'package:recipe.app/services/notification_service.dart';
import 'package:recipe.app/services/deep_link_service.dart';
import 'package:recipe.app/services/crashlytics_service.dart';
import 'package:recipe.app/services/analytics_service.dart';
import 'package:recipe.app/services/remote_config_service.dart';
import 'package:recipe.app/services/app_update_check_service.dart';
import 'controllers/customer/customer_controller.dart';
// import 'controllers/banner/bannercontroller.dart'; // Commented out - GraphQL query disabled
import '../controllers/cart/Cartcontroller.dart';
import 'controllers/collection controller/collectioncontroller.dart';
import 'routes.dart';
import 'controllers/utilitycontroller/utilitycontroller.dart';
import 'controllers/authentication/authenticationcontroller.dart';
import 'controllers/theme_controller.dart';
import 'theme/theme.dart';

/// Key used to signal that the update screen should be shown from the initial route (set by checkAppUpdate).
const String _kShowUpdateScreenKey = 'show_update_screen';

/// Key for mandatory update (cannot dismiss; current < min_version from Remote Config).
const String _kUpdateMandatoryKey = 'update_mandatory';

/// Check for app updates on startup
/// This function is called automatically in main() to check for updates
/// when the app starts
Future<void> checkAppUpdate() async {
  try {
    // STEP 1: Check Firebase Remote Config (min_version, latest_version)
    try {
      final result = await AppUpdateCheckService().checkForUpdate();

      if (result.needsMandatoryUpdate) {
        // current < min_version → blocking popup, cannot dismiss
        GetStorage().write(_kShowUpdateScreenKey, true);
        GetStorage().write(_kUpdateMandatoryKey, true);
        return;
      }

      if (result.needsOptionalUpdate) {
        // current < latest_version → optional update (dismissible)
        GetStorage().write(_kShowUpdateScreenKey, true);
        GetStorage().write(_kUpdateMandatoryKey, false);
        return;
      }
    } catch (e) {
      // Remote Config check failed, fall through to Play Store
    }

    // STEP 2: Fallback - Play Store (Android only)
    GetStorage().remove(_kUpdateMandatoryKey);
    final updateService = InAppUpdateService();
    try {
      await updateService.checkForUpdatesAndDetermineType();
      if (updateService.isImmediateUpdateEnabled && updateService.isUpdateAvailable) {
        GetStorage().write(_kShowUpdateScreenKey, true);
      } else {
        GetStorage().remove(_kShowUpdateScreenKey);
      }
    } catch (e) {
      if (e.toString().contains('ERROR_APP_NOT_OWNED')) {}
      GetStorage().remove(_kShowUpdateScreenKey);
    }
  } catch (e) {}
}

/// Comprehensive app update check function that can be called from anywhere
/// 
/// Usage examples:
/// ```dart
/// // Check for updates from any widget
/// bool updateAvailable = await performAppUpdateCheck();
/// if (updateAvailable) {
///   // Show update dialog or navigate to update screen
/// }
/// 
/// // Check for updates in a button press
/// onPressed: () async {
///   bool needsUpdate = await performAppUpdateCheck();
///   if (needsUpdate) {
///     Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateScreen()));
///   }
/// }
/// ```
/// 
/// Returns true if update is available, false otherwise
Future<bool> performAppUpdateCheck() async {
  try {
    
    // COMMENTED OUT: GraphQL query for update info (now using Play Store only)
    // Get BannerController (create if not exists)
    // BannerController bannerController;
    // try {
    //   bannerController = Get.find<BannerController>();
    // } catch (e) {
    //   bannerController = Get.put(BannerController());
    // }
    // 
    // // Try to fetch update info from GraphQL
    // bool graphqlSuccess = false;
    // try {
    //   await bannerController.getAppUpdateInfo();
    //   debugPrint('[AppUpdate] GraphQL update info fetched successfully');
    //   graphqlSuccess = true;
    // } catch (e) {
    //   debugPrint('[AppUpdate] GraphQL update info fetch failed: $e');
    //   graphqlSuccess = false;
    // }
    
    // Get the update service
    final updateService = InAppUpdateService();
    
    // Check Play Store directly (GraphQL query disabled)
    try {
      await updateService.checkForUpdatesAndDetermineType();
      final updateAvailable = updateService.isUpdateAvailable && updateService.isImmediateUpdateEnabled;
        return updateAvailable;
      } catch (e) {
        if (e.toString().contains('ERROR_APP_NOT_OWNED')) {
        }
        return false;
    }
  } catch (e) {
    return false;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kIsWeb) return;
  await Firebase.initializeApp();
  await NotificationService.instance.initialize();
  await NotificationService.instance.showRemoteNotification(message);
}

Future<void> _initializeFirebase() async {
  if (kIsWeb) {
    // Skip Firebase initialization on Web (no options configured).
    return;
  }

  try {
    await Firebase.initializeApp();
    
    // Initialize Crashlytics
    await CrashlyticsService.instance.initialize();
    
    // Initialize Firebase Messaging
    await NotificationService.instance.initialize();

    // Don't request notification permission here: on iOS the system dialog often
    // doesn't show if requested before the app window is visible. Permission is
    // requested in InitialRouteWrapper after the first frame (see _requestNotificationPermissionWhenReady).
    final messaging = FirebaseMessaging.instance;

    // iOS: show notifications when app is in foreground (alert, badge, sound).
    // Without this, FCM messages on iOS are not displayed while the app is open.
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get and print FCM token (for push notification debugging)
    try {
      final token = await messaging.getToken();
      final isIos = defaultTargetPlatform == TargetPlatform.iOS;
      if (token != null) {
        final platform = isIos ? 'iOS' : (defaultTargetPlatform == TargetPlatform.android ? 'Android' : 'other');
        debugPrint('[FCM] Token ($platform): $token');
        if (isIos) {
          debugPrint('[FCM] Use this token in Firebase Console → Messaging → Send to single device');
        }
      } else {
        debugPrint('[FCM] Token is null (e.g. permission denied or not yet granted)');
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          debugPrint('[FCM] iOS: Allow notifications when prompted, then restart app or wait for "[FCM] Token (after permission)"');
          debugPrint('[FCM] iOS: Upload APNs .p8 key in Firebase → Project settings → Cloud Messaging → Apple app config');
        }
      }
    } catch (e) {
      if (e.toString().contains('apns-token-not-set')) {
        debugPrint('[FCM] iOS: FCM token will appear after you allow notifications on a physical device (simulator has no APNS).');
        debugPrint('[FCM] iOS: Upload APNs key in Firebase Console → Project settings → Cloud Messaging');
      } else {
        debugPrint('[FCM] getToken error: $e');
      }
    }

    // iOS: retry getToken after delay (user may allow notifications after first frame; token then appears)
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      Future.delayed(const Duration(seconds: 5), () async {
        try {
          final token = await messaging.getToken();
          if (token != null && kDebugMode) {
            debugPrint('[FCM] Token (iOS, after delay): $token');
          }
        } catch (_) {}
      });
    }

    // Listen for token refresh
    messaging.onTokenRefresh.listen((newToken) {
      final platform = defaultTargetPlatform == TargetPlatform.iOS
          ? 'iOS'
          : (defaultTargetPlatform == TargetPlatform.android ? 'Android' : 'other');
      debugPrint('[FCM] Token refreshed ($platform): $newToken');
    });

    // Foreground: show notification banner + snackbar
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.instance.showRemoteNotification(message);
      NotificationService.instance.showSnackbar(message);
    });

    // Background: user taps notification while app was in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationService.instance.handleNotificationOpen(message);
    });

    // Terminated: app was killed, user tapped notification to launch it
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      NotificationService.instance.setPendingInitialMessage(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Subscribe to FCM topic for locally saved channel (so Firebase messages use that topic)
    Future.delayed(const Duration(seconds: 3), () {
      NotificationService.instance.subscribeToChannelTopic();
    });

    // Initialize Analytics
    await AnalyticsService().initialize();
    
    // Initialize Remote Config
    final remoteConfigService = Get.put(RemoteConfigService());
    await remoteConfigService.initialize();
  } catch (e, stackTrace) {
    CrashlyticsService.instance.recordError(e, stackTrace, reason: 'Firebase initialization failed');
  }
}

/// Initialize GetStorage synchronously - blocks until ready or timeout
Future<void> _initializeGetStorageSync() async {
  try {
    // Try to initialize GetStorage immediately
    await GetStorage.init();
    if (kDebugMode) {
      debugPrint('✅ GetStorage initialized synchronously');
    }
  } catch (e) {
    // If it fails, try with a short delay (platform channels might not be ready)
    if (kDebugMode) {
      debugPrint('⚠️ GetStorage sync init failed, retrying...');
    }
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await GetStorage.init();
      if (kDebugMode) {
        debugPrint('✅ GetStorage initialized on retry');
      }
    } catch (e2) {
      // If still fails, log but continue - background retry will handle it
      if (kDebugMode) {
        debugPrint('⚠️ GetStorage sync init failed, will retry in background');
      }
    }
  }
}

/// Initialize GetStorage - non-blocking, runs in background after app starts
Future<void> _initializeGetStorageWithRetry() async {
  // Don't wait - initialize in background to avoid blocking app startup
  // Wait for app to fully start before initializing storage
  Future.delayed(const Duration(seconds: 2), () async {
    // Additional delay to ensure platform channels are fully ready
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      await GetStorage.init();
      if (kDebugMode) {
        debugPrint('✅ GetStorage initialized successfully');
      }
    } catch (e) {
      // Log error in debug mode (but don't spam)
      if (kDebugMode) {
        if (e is PlatformException && 
            e.code == 'channel-error' && 
            e.message?.contains('path_provider') == true) {
          debugPrint('⚠️ GetStorage initialization failed - path_provider not ready');
          debugPrint('   App will continue. Storage will be available after platform channels are ready.');
        } else {
          debugPrint('⚠️ GetStorage initialization failed: $e');
        }
      }
      // Record to Crashlytics if available
      try {
        CrashlyticsService.instance.recordError(
          e, 
          StackTrace.current, 
          reason: 'GetStorage initialization failed - will retry later'
        );
      } catch (_) {
        // Crashlytics might not be initialized yet, ignore
      }
      
      // Retry once more after a longer delay
      Future.delayed(const Duration(seconds: 3), () async {
        try {
          await GetStorage.init();
          if (kDebugMode) {
            debugPrint('✅ GetStorage initialized successfully on retry');
          }
        } catch (e2) {
          if (kDebugMode) {
            debugPrint('⚠️ GetStorage retry also failed. Storage may not be available.');
          }
        }
      });
    }
  });
}

Future<void> main() async {
  // Set up global error handlers first (before any initialization)
  _setupErrorHandlers();

  // Run everything in a Zone to catch all errors
  runZonedGuarded(
    () async {
      // Initialize Flutter bindings inside the zone
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase (Crashlytics + Messaging) only on mobile/desktop, not Web.
      await _initializeFirebase();

      // Initialize GetStorage synchronously before creating controllers
      await _initializeGetStorageSync();
      // Also initialize in background for retry logic
      _initializeGetStorageWithRetry();
      await dotenv.load(fileName: ".env"); // <-- load dotenv first
      
      try {
        await GraphqlService.initialize();
      } catch (e, stackTrace) {
        CrashlyticsService.instance.recordError(e, stackTrace, reason: 'GraphQL initialization failed');
      }
      
      // Initialize in-app update service
      try {
        await InAppUpdateService().initialize();
      } catch (e, stackTrace) {
        CrashlyticsService.instance.recordError(e, stackTrace, reason: 'In-app update initialization failed');
      }

      // Initialize deep link service
      try {
        await DeepLinkService().initialize();
      } catch (e, stackTrace) {
        CrashlyticsService.instance.recordError(e, stackTrace, reason: 'Deep link initialization failed');
      }

      // Initialize controllers
      try {
        Get.put(UtilityController());
        Get.put(CustomerController());
        Get.put<AuthController>(AuthController());
        Get.put(CartController());
        Get.put(CollectionsController());

        // Initialize theme controller early and ensure storage is ready
        final themeController = Get.put(ThemeController());
        // Ensure theme is loaded before app starts
        // The constructor already loads it, but we ensure it's ready
        
        // Check for app updates
        await checkAppUpdate();

        // Run the app
        runApp(MyApp(themeController: themeController));
      } catch (e, stackTrace) {
        CrashlyticsService.instance.recordError(e, stackTrace, reason: 'App initialization failed', fatal: true);
        rethrow;
      }
    },
    (error, stackTrace) {
      // Log to Crashlytics
      CrashlyticsService.instance.recordError(
        error,
        stackTrace,
        reason: 'Unhandled error in Zone',
        fatal: true,
      );
    },
  );
}

/// Set up global error handlers; widget build errors are shown via ErrorWidget
void _setupErrorHandlers() {
  // Handle Flutter framework errors (widget build errors, etc.)
  FlutterError.onError = (FlutterErrorDetails details) {
    // Filter out known harmless keyboard assertion errors (Flutter framework bug)
    final errorString = details.exception.toString();
    if (errorString.contains('KeyUpEvent is dispatched') ||
        errorString.contains('_pressedKeys.containsKey') ||
        errorString.contains('HardwareKeyboard') ||
        (errorString.contains('physical key is not pressed') && 
         errorString.contains('KeyUpEvent'))) {
      return;
    }
    CrashlyticsService.instance.recordError(
      details.exception,
      details.stack,
      reason: 'Flutter framework error',
      fatal: true,
    );
    FlutterError.presentError(details);
  };

  // Handle async errors (Future errors, Zone errors, etc.)
  PlatformDispatcher.instance.onError = (error, stack) {
    final errorString = error.toString();
    if (errorString.contains('KeyUpEvent is dispatched') ||
        errorString.contains('_pressedKeys.containsKey') ||
        errorString.contains('HardwareKeyboard') ||
        (errorString.contains('physical key is not pressed') && 
         errorString.contains('KeyUpEvent'))) {
      return true;
    }
    CrashlyticsService.instance.recordError(
      error,
      stack,
      reason: 'Async error',
      fatal: true,
    );
    return true;
  };

  // For widget build errors only: show AppErrorWidget (error page) instead of default red box
  ErrorWidget.builder = (FlutterErrorDetails details) {
    final errorString = details.exception.toString();
    if (errorString.contains('KeyUpEvent is dispatched') ||
        errorString.contains('_pressedKeys.containsKey') ||
        errorString.contains('HardwareKeyboard') ||
        (errorString.contains('physical key is not pressed') &&
         errorString.contains('KeyUpEvent'))) {
      return const SizedBox.shrink();
    }
    return const ErrorPage();
  };
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  
  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    final analyticsObserver = AnalyticsService().observer;
    
    return Obx(() {
      // Force theme update by rebuilding when theme changes
      final isDark = themeController.isDarkMode;
      
      return GetMaterialApp(
      title: 'SwadKerala',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial, // Start with initial route wrapper
      getPages: AppRoutes.routes,
      navigatorObservers: analyticsObserver != null ? [analyticsObserver] : [],
      scrollBehavior: ScrollBehavior().copyWith(scrollbars: false),
      );
    });
  }
}