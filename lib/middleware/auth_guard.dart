import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/graphql_client.dart';
import '../routes.dart';

/// Authentication guard middleware for protected routes
/// Redirects unauthenticated users to login page with intended route stored
class AuthGuard extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Handle null route
    if (route == null) {
      debugPrint('[AuthGuard] Route is null, allowing access');
      return null;
    }
    
    debugPrint('[AuthGuard] 🔐 Checking authentication for route: $route');
    
    // Check if user is authenticated
    if (!_isUserAuthenticated()) {
      debugPrint('[AuthGuard] 🚫 User not authenticated, redirecting to login');
      
      // Store the intended route and its arguments for post-login redirection
      final intendedRoute = route;
      final intendedArguments = Get.arguments;
      
      debugPrint('[AuthGuard] Storing intended route: $intendedRoute with arguments: $intendedArguments');
      
      // Redirect to login page with intended route and arguments
      return RouteSettings(
        name: AppRoutes.login,
        arguments: {
          'intendedRoute': intendedRoute,
          'intendedArguments': intendedArguments,
        },
      );
    }
    
    debugPrint('[AuthGuard] ✅ User authenticated, allowing access to: $route');
    return null; // Allow access to the route
  }

  /// Check if user is authenticated
  /// 
  /// Returns true if user has valid authentication tokens
  bool _isUserAuthenticated() {
    try {
      // Primary check: tokens in GraphqlService (most reliable)
      final authToken = GraphqlService.authToken;
      final channelToken = GraphqlService.channelToken;
      final hasValidTokens = authToken.isNotEmpty && channelToken.isNotEmpty;
      
      debugPrint('[AuthGuard] Token check - authToken: ${authToken.isNotEmpty}, channelToken: ${channelToken.isNotEmpty}');
      
      // If tokens are present, consider authenticated
      if (hasValidTokens) {
        debugPrint('[AuthGuard] ✅ Valid tokens found, user is authenticated');
        
        // Update AuthController state if it's available but out of sync
        if (Get.isRegistered<AuthController>()) {
          final authController = Get.find<AuthController>();
          if (!authController.isLoggedIn) {
            debugPrint('[AuthGuard] 🔄 Syncing AuthController state with token presence');
            // Note: We don't directly set isLoggedIn here to avoid side effects
            // The AuthController should handle this internally
          }
        }
        
        return true;
      }
      
      // Secondary check: AuthController if tokens are not available
      if (Get.isRegistered<AuthController>()) {
        final authController = Get.find<AuthController>();
        final isLoggedIn = authController.isLoggedIn;
        debugPrint('[AuthGuard] AuthController fallback - isLoggedIn: $isLoggedIn');
        return isLoggedIn;
      }
      
      debugPrint('[AuthGuard] ❌ No valid authentication found');
      return false;
    } catch (e) {
      debugPrint('[AuthGuard] Error checking authentication: $e');
      // If any error occurs, assume not authenticated
      return false;
    }
  }
}
