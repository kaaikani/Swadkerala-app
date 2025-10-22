import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../services/graphql_client.dart';
import 'login_page.dart';
import 'homepage.dart';
import 'intro_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final UtilityController utilityController = Get.find();

    return Obx(() {
      // Show loading while checking authentication status
      if (utilityController.isLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Additional check: Ensure both tokens exist
      final authToken = GraphqlService.authToken;
      final channelToken = GraphqlService.channelToken;
      
      debugPrint('[AuthWrapper] Auth token present: ${authToken.isNotEmpty}');
      debugPrint('[AuthWrapper] Channel token present: ${channelToken.isNotEmpty}');
      debugPrint('[AuthWrapper] AuthController logged in: ${authController.isLoggedIn}');

      // If user is logged in AND has valid tokens, go to home page
      if (authController.isLoggedIn && authToken.isNotEmpty && channelToken.isNotEmpty) {
        return MyHomePage();
      }

      // If tokens are missing but user thinks they're logged in, clear the state
      if (authController.isLoggedIn && (authToken.isEmpty || channelToken.isEmpty)) {
        debugPrint('[AuthWrapper] User marked as logged in but tokens missing, clearing state');
        authController.setLoggedIn(false);
      }

      // Check if intro has been shown
      if (_hasIntroBeenShown()) {
        return const LoginPage();
      } else {
        return const IntroPage();
      }
    });
  }

  /// Check if intro page has been shown before
  bool _hasIntroBeenShown() {
    // You can implement this logic based on your requirements
    // For now, we'll assume intro should always be shown for new users
    return true; // Set to false if you want to show intro page first
  }
}