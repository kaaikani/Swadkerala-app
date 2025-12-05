import 'package:get/get.dart';
import '../routes.dart';
import 'package:flutter/foundation.dart';
/// Centralized navigation helper for consistent navigation across the app
class NavigationHelper {
  /// Navigate to product detail page
  /// 
  /// [productId] - Required product ID
  /// [productName] - Optional product name for analytics/tracking
  /// [isInitialLink] - If true, ensures home page is in navigation stack
  static Future<void> navigateToProductDetail({
    required String productId,
    String? productName,
    bool? isInitialLink,
  }) async {
    final arguments = <String, dynamic>{
      'productId': productId,
      if (productName != null) 'productName': productName,
    };

    if (isInitialLink == true) {
      // For initial links, first navigate to home, then push the product detail
      // This ensures there's always a home page to go back to
      await Get.offAllNamed(AppRoutes.home);
      await Get.toNamed(AppRoutes.productDetail, arguments: arguments);
    } else {
      await Get.toNamed(AppRoutes.productDetail, arguments: arguments);
    }
  }

  /// Navigate to cart page
  /// 
  /// [isInitialLink] - If true, ensures home page is in navigation stack
  /// Authentication is now handled by AuthGuard middleware in routes
  static Future<void> navigateToCart({bool? isInitialLink}) async {
    if (isInitialLink == true) {
      // For initial links, first navigate to home, then push the cart
      // This ensures there's always a home page to go back to
      await Get.offAllNamed(AppRoutes.home);
      await Get.toNamed(AppRoutes.cart);
    } else {
      await Get.toNamed(AppRoutes.cart);
    }
  }

  /// Navigate to checkout page
  /// 
  /// [isInitialLink] - If true, ensures home page is in navigation stack
  /// Authentication is now handled by AuthGuard middleware in routes
  static Future<void> navigateToCheckout({bool? isInitialLink}) async {
    if (isInitialLink == true) {
      // For initial links, first navigate to home, then push the checkout
      // This ensures there's always a home page to go back to
      await Get.offAllNamed(AppRoutes.home);
      await Get.toNamed(AppRoutes.checkout);
    } else {
      await Get.toNamed(AppRoutes.checkout);
    }
  }

  /// Redirect to intended route after authentication
  /// 
  /// Checks for stored intended route, navigates there if available,
  /// otherwise navigates to home page
  static Future<void> redirectToIntendedRoute() async {
    // Get intended route and arguments from GetX arguments or storage
    final intendedRoute = Get.parameters['intendedRoute'] ?? 
                         Get.arguments?['intendedRoute'] as String?;
    final intendedArguments = Get.arguments?['intendedArguments'];
    
debugPrint('[NavigationHelper] Intended route: $intendedRoute, arguments: $intendedArguments');
    
    if (intendedRoute != null && intendedRoute.isNotEmpty) {
      try {
        // For intended routes after login, first navigate to home, then push the intended route
        // This ensures there's always a home page to go back to
        await Get.offAllNamed(AppRoutes.home);
        
        // Then navigate to the intended route
        if (intendedArguments != null) {
          await Get.toNamed(intendedRoute, arguments: intendedArguments);
        } else {
          await Get.toNamed(intendedRoute);
        }
debugPrint('[NavigationHelper] Successfully navigated to intended route: $intendedRoute with home in stack');
      } catch (e) {
debugPrint('[NavigationHelper] Error navigating to intended route: $e');
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
debugPrint('[NavigationHelper] No intended route found, navigating to home');
      Get.offAllNamed(AppRoutes.home);
    }
  }

}
