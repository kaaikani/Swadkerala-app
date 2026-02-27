import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes.dart';
import '../services/graphql_client.dart';
import '../theme/colors.dart';

/// Centralized navigation helper for consistent navigation across the app
class NavigationHelper {
  /// Returns true if user has auth token (logged in).
  static bool get _isLoggedIn => GraphqlService.authToken.isNotEmpty;
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

  static const String _keyIntendedRoute = 'login_intended_route';
  static const String _keyIntendedArguments = 'login_intended_arguments';

  /// Show the same login-required dialog (title, message, Login/Cancel). Login navigates to login page with [intendedRoute].
  static void showLoginRequiredDialog({
    required String title,
    required String message,
    String? intendedRoute,
  }) {
    final route = intendedRoute ?? AppRoutes.account;
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Persist intended route so login page can use it even if Get.arguments is lost
              final storage = GetStorage();
              storage.write(_keyIntendedRoute, route);
              storage.remove(_keyIntendedArguments);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.toNamed(AppRoutes.login,
                    arguments: {'intendedRoute': route});
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: AppColors.buttonText,
            ),
            child: const Text('Login'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Navigate to account page. If guest, show dialog "To view account page, kindly login" with Login/Cancel.
  static Future<void> navigateToAccount() async {
    if (!_isLoggedIn) {
      showLoginRequiredDialog(
        title: 'Login required',
        message: 'To view account page, kindly login.',
        intendedRoute: AppRoutes.account,
      );
      return;
    }
    Get.toNamed(AppRoutes.account);
  }

  /// Navigate to cart page. Guests can view cart; login is required only at proceed to checkout (handled on cart page).
  static Future<void> navigateToCart({bool? isInitialLink}) async {
    if (isInitialLink == true) {
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

  /// Redirect to intended route after authentication.
  /// Pass [intendedRoute] (and optionally [intendedArguments]) when opening login
  /// so they are used after login; otherwise reads from Get.parameters / Get.arguments.
  static Future<void> redirectToIntendedRoute({
    String? intendedRoute,
    dynamic intendedArguments,
  }) async {
    final route = intendedRoute ??
        Get.parameters['intendedRoute'] ??
        Get.arguments?['intendedRoute'] as String?;
    final args = intendedArguments ?? Get.arguments?['intendedArguments'];

    if (route != null && route.isNotEmpty) {
      try {
        // If the intended route is already in the stack below (e.g. Cart → Login → back to Cart),
        // pop back to it instead of creating a duplicate page.
        if (Get.previousRoute == route) {
          Get.back();
        } else if (args != null) {
          Get.offNamed(route, arguments: args);
        } else {
          Get.offNamed(route);
        }
      } catch (e) {
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }

}
