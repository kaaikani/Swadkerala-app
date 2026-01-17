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
      return null;
    }
    
    
    // Check if user is authenticated
    if (!_isUserAuthenticated()) {
      
      // Store the intended route and its arguments for post-login redirection
      final intendedRoute = route;
      final intendedArguments = Get.arguments;
      
      
      // Redirect to login page with intended route and arguments
      return RouteSettings(
        name: AppRoutes.login,
        arguments: {
          'intendedRoute': intendedRoute,
          'intendedArguments': intendedArguments,
        },
      );
    }
    
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
      
      
      // If tokens are present, consider authenticated
      if (hasValidTokens) {
        
        // Update AuthController state if it's available but out of sync
        if (Get.isRegistered<AuthController>()) {
          final authController = Get.find<AuthController>();
          if (!authController.isLoggedIn) {
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
        return isLoggedIn;
      }
      
      return false;
    } catch (e) {
      // If any error occurs, assume not authenticated
      return false;
    }
  }
}
