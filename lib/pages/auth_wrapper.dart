import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
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

      // If user is logged in, go to home page
      if (authController.isLoggedIn) {
        return  MyHomePage();
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