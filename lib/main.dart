import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:recipe.app/services/graphql_client.dart';
import 'package:recipe.app/services/in_app_update_service.dart';
import 'package:recipe.app/services/notification_service.dart';
import 'package:recipe.app/services/deep_link_service.dart';
import 'controllers/customer/customer_controller.dart';
import 'controllers/banner/bannercontroller.dart';
import 'routes.dart';
import 'controllers/utilitycontroller/utilitycontroller.dart';
import 'controllers/authentication/authenticationcontroller.dart';
import 'controllers/theme_controller.dart';
import 'theme/theme.dart';

/// Check for app updates on startup
/// This function is called automatically in main() to check for updates
/// when the app starts
Future<void> checkAppUpdate() async {
  try {
    debugPrint('[Main] Starting app update check...');
    
    // Initialize BannerController for GraphQL calls
    final bannerController = Get.put(BannerController());
    
    // Try to fetch update info from GraphQL
    try {
      await bannerController.getAppUpdateInfo();
      debugPrint('[Main] GraphQL update info fetched successfully');
    } catch (e) {
      debugPrint('[Main] GraphQL update info fetch failed: $e');
    }
    
    // Get the update service
    final updateService = InAppUpdateService();
    
    // Check if immediate update is needed
    if (updateService.isImmediateUpdateEnabled) {
      debugPrint('[Main] Immediate update is enabled');
      
      // Check Play Store for updates
      try {
        final updateAvailable = await updateService.checkPlayStoreDirectly();
        if (updateAvailable) {
          debugPrint('[Main] Update available on Play Store');
        } else {
          debugPrint('[Main] No update available on Play Store');
        }
      } catch (e) {
        debugPrint('[Main] Play Store check failed: $e');
        if (e.toString().contains('ERROR_APP_NOT_OWNED')) {
          debugPrint('[Main] App not installed from Play Store - update check skipped');
        }
      }
    } else {
      debugPrint('[Main] Immediate update is disabled');
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
    
    // Get BannerController (create if not exists)
    BannerController bannerController;
    try {
      bannerController = Get.find<BannerController>();
    } catch (e) {
      bannerController = Get.put(BannerController());
    }
    
    // Try to fetch update info from GraphQL
    bool graphqlSuccess = false;
    try {
      await bannerController.getAppUpdateInfo();
      debugPrint('[AppUpdate] GraphQL update info fetched successfully');
      graphqlSuccess = true;
    } catch (e) {
      debugPrint('[AppUpdate] GraphQL update info fetch failed: $e');
      graphqlSuccess = false;
    }
    
    // Get the update service
    final updateService = InAppUpdateService();
    
    // Check if GraphQL provided update info
    if (graphqlSuccess && updateService.latestVersion != updateService.currentVersion) {
      debugPrint('[AppUpdate] GraphQL provided version info: ${updateService.currentVersion} -> ${updateService.latestVersion}');
      debugPrint('[AppUpdate] Immediate update enabled: ${updateService.isImmediateUpdateEnabled}');
      return updateService.isImmediateUpdateEnabled;
    } else {
      // GraphQL failed or didn't provide version info - fallback to Play Store check
      debugPrint('[AppUpdate] GraphQL failed or no version info, checking Play Store directly...');
      try {
        final updateAvailable = await updateService.checkPlayStoreDirectly();
        debugPrint('[AppUpdate] Play Store check result: $updateAvailable');
        return updateAvailable;
      } catch (e) {
        debugPrint('[AppUpdate] Play Store check failed: $e');
        if (e.toString().contains('ERROR_APP_NOT_OWNED')) {
          debugPrint('[AppUpdate] App not installed from Play Store');
        }
        return false;
      }
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

Future<void> _initializeFirebaseMessaging() async {
  if (kIsWeb) {
    // Skip Firebase Messaging initialization on Web (no options configured).
    debugPrint('[Main] Skipping Firebase Messaging initialization on Web.');
    return;
  }
  await Firebase.initializeApp();
  await NotificationService.instance.initialize();

  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationService.instance.showRemoteNotification(message);
    NotificationService.instance.showSnackbar(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Messaging only on mobile/desktop, not Web.
  await _initializeFirebaseMessaging();

  // Initialize GetStorage
  await GetStorage.init();
  await dotenv.load(fileName: ".env"); // <-- load dotenv first
  await GraphqlService.initialize();
  
  // Initialize in-app update service
  await InAppUpdateService().initialize();

  // Initialize deep link service
  await DeepLinkService().initialize();

  // Initialize controllers
  Get.put(UtilityController());
  Get.put(CustomerController());
  Get.put<AuthController>(AuthController());
  final themeController = Get.put(ThemeController());
  
  // Check for app updates
  await checkAppUpdate();

  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  
  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      title: 'Kaaikani',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
    ));
  }
}
