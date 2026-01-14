import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:recipe.app/services/graphql_client.dart';
import 'package:recipe.app/services/in_app_update_service.dart';
import 'package:recipe.app/services/notification_service.dart';
import 'package:recipe.app/services/deep_link_service.dart';
import 'package:recipe.app/services/crashlytics_service.dart';
import 'package:recipe.app/services/analytics_service.dart';
import 'package:recipe.app/services/remote_config_service.dart';
import 'controllers/customer/customer_controller.dart';
// import 'controllers/banner/bannercontroller.dart'; // Commented out - GraphQL query disabled
import '../controllers/cart/Cartcontroller.dart';
import 'controllers/collection controller/collectioncontroller.dart';
import 'routes.dart';
import 'controllers/utilitycontroller/utilitycontroller.dart';
import 'controllers/authentication/authenticationcontroller.dart';
import 'controllers/theme_controller.dart';
import 'theme/theme.dart';
import 'pages/error_page.dart';

/// Check for app updates on startup
/// This function is called automatically in main() to check for updates
/// when the app starts
Future<void> checkAppUpdate() async {
  try {
debugPrint('[Main] Starting app update check...');
    
    // COMMENTED OUT: GraphQL query for update info (now using Play Store only)
    // Initialize BannerController for GraphQL calls
    // final bannerController = Get.put(BannerController());
    // 
    // // Try to fetch update info from GraphQL
    // try {
    //   await bannerController.getAppUpdateInfo();
    //   debugPrint('[Main] GraphQL update info fetched successfully');
    // } catch (e) {
    //   debugPrint('[Main] GraphQL update info fetch failed: $e');
    // }
    
    // Get the update service
    final updateService = InAppUpdateService();
    
    // Check Play Store for updates directly (GraphQL query disabled)
    try {
      await updateService.checkForUpdatesAndDetermineType();
      
      // Check if immediate update is needed (based on Play Store only)
      if (updateService.isImmediateUpdateEnabled && updateService.isUpdateAvailable) {
debugPrint('[Main] Immediate update is enabled - update available on Play Store');
        } else {
debugPrint('[Main] No update available on Play Store');
        }
      } catch (e) {
debugPrint('[Main] Play Store check failed: $e');
        if (e.toString().contains('ERROR_APP_NOT_OWNED')) {
debugPrint('[Main] App not installed from Play Store - update check skipped');
        }
    }
    
debugPrint('[Main] App update check completed');
  } catch (e) {
debugPrint('[Main] Error during app update check: $e');
  }
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
debugPrint('[AppUpdate] Performing comprehensive app update check...');
    
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
debugPrint('[AppUpdate] Checking Play Store directly (GraphQL disabled)...');
    try {
      await updateService.checkForUpdatesAndDetermineType();
      final updateAvailable = updateService.isUpdateAvailable && updateService.isImmediateUpdateEnabled;
debugPrint('[AppUpdate] Play Store check result: $updateAvailable');
        return updateAvailable;
      } catch (e) {
debugPrint('[AppUpdate] Play Store check failed: $e');
        if (e.toString().contains('ERROR_APP_NOT_OWNED')) {
debugPrint('[AppUpdate] App not installed from Play Store');
        }
        return false;
    }
  } catch (e) {
debugPrint('[AppUpdate] Error during comprehensive update check: $e');
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
debugPrint('[Main] Skipping Firebase initialization on Web.');
    return;
  }

  try {
    await Firebase.initializeApp();
    
    // Initialize Crashlytics
    await CrashlyticsService.instance.initialize();
    
    // Initialize Firebase Messaging
    await NotificationService.instance.initialize();

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    // Get and print FCM token
    try {
      final token = await messaging.getToken();
debugPrint('🔥 [FCM] Token: $token');
      if (token != null) {
debugPrint('🔥 [FCM] Token length: ${token.length}');
      } else {
debugPrint('🔥 [FCM] Token is null');
      }
    } catch (e) {
debugPrint('🔥 [FCM] Error getting token: $e');
    }

    // Listen for token refresh
    messaging.onTokenRefresh.listen((newToken) {
debugPrint('🔥 [FCM] Token refreshed: $newToken');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.instance.showRemoteNotification(message);
      NotificationService.instance.showSnackbar(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Initialize Analytics
    await AnalyticsService().initialize();
    
    // Initialize Remote Config
    final remoteConfigService = Get.put(RemoteConfigService());
    await remoteConfigService.initialize();
  } catch (e, stackTrace) {
debugPrint('[Main] Firebase initialization error: $e');
    CrashlyticsService.instance.recordError(e, stackTrace, reason: 'Firebase initialization failed');
  }
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

      // Initialize GetStorage
      await GetStorage.init();
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

      // In release mode, show error page
      if (kReleaseMode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            final context = Get.key.currentContext;
            if (context != null) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => ErrorPage(
                    errorDetails: FlutterErrorDetails(
                      exception: error,
                      stack: stackTrace,
                    ),
                    isReleaseMode: true,
                  ),
                ),
                (route) => false,
              );
            }
          } catch (e) {
            debugPrint('Error navigating to error page: $e');
          }
        });
      } else {
        // In debug mode, print error
        debugPrint('Unhandled error: $error');
        debugPrint('Stack trace: $stackTrace');
      }
    },
  );
}

/// Set up global error handlers to catch unhandled exceptions
/// In release mode, shows user-friendly error page instead of grey screen
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
      // This is a known Flutter framework bug, especially on Android emulators
      // It doesn't affect app functionality, so we'll silently ignore it
      debugPrint('[Main] Ignoring known keyboard event assertion error (Flutter framework bug)');
      return;
    }
    
    // Log to Crashlytics
    CrashlyticsService.instance.recordError(
      details.exception,
      details.stack,
      reason: 'Flutter framework error',
      fatal: true,
    );

    // In release mode, show error page instead of grey screen
    if (kReleaseMode) {
      // Navigate to error page after frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          // Use Get.key.currentContext or navigate directly
          final context = Get.key.currentContext;
          if (context != null) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => ErrorPage(
                  errorDetails: details,
                  isReleaseMode: true,
                ),
              ),
              (route) => false,
            );
          }
        } catch (e) {
          debugPrint('Error navigating to error page: $e');
        }
      });
    } else {
      // In debug mode, show default error screen
      FlutterError.presentError(details);
    }
  };

  // Handle async errors (Future errors, Zone errors, etc.)
  PlatformDispatcher.instance.onError = (error, stack) {
    // Filter out known harmless keyboard assertion errors (Flutter framework bug)
    final errorString = error.toString();
    if (errorString.contains('KeyUpEvent is dispatched') ||
        errorString.contains('_pressedKeys.containsKey') ||
        errorString.contains('HardwareKeyboard') ||
        (errorString.contains('physical key is not pressed') && 
         errorString.contains('KeyUpEvent'))) {
      // This is a known Flutter framework bug, especially on Android emulators
      // It doesn't affect app functionality, so we'll silently ignore it
      debugPrint('[Main] Ignoring known keyboard event assertion error (Flutter framework bug)');
      return true; // Return true to indicate error was handled
    }
    
    // Log to Crashlytics
    CrashlyticsService.instance.recordError(
      error,
      stack,
      reason: 'Async error',
      fatal: true,
    );

    // In release mode, show error page
    if (kReleaseMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final context = Get.key.currentContext;
          if (context != null) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => ErrorPage(
                  errorDetails: FlutterErrorDetails(
                    exception: error,
                    stack: stack,
                  ),
                  isReleaseMode: true,
                ),
              ),
              (route) => false,
            );
          }
        } catch (e) {
          debugPrint('Error navigating to error page: $e');
        }
      });
    }

    return true; // Return true to indicate error was handled
  };

  // Override ErrorWidget.builder to show custom error page in release mode
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // Filter out known harmless keyboard assertion errors (Flutter framework bug)
    final errorString = details.exception.toString();
    if (errorString.contains('KeyUpEvent is dispatched') ||
        errorString.contains('_pressedKeys.containsKey') ||
        errorString.contains('HardwareKeyboard') ||
        (errorString.contains('physical key is not pressed') && 
         errorString.contains('KeyUpEvent'))) {
      // This is a known Flutter framework bug, especially on Android emulators
      // Return an empty widget to suppress the error display
      debugPrint('[Main] Ignoring known keyboard event assertion error in ErrorWidget (Flutter framework bug)');
      return const SizedBox.shrink();
    }
    
    // In release mode, return error page
    if (kReleaseMode) {
      return ErrorPage(
        errorDetails: details,
        isReleaseMode: true,
      );
    }
    // In debug mode, show default error widget
    return ErrorWidget(details.exception);
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
      title: 'Kaaikani',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
      navigatorObservers: analyticsObserver != null ? [analyticsObserver] : [],
      );
    });
  }
}