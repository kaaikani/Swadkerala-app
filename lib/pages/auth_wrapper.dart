import 'package:flutter/material.dart';
import '../widgets/shimmers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../services/graphql_client.dart';
import 'login_page.dart';
import 'homepage.dart';
import 'intro_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _hasCheckedTokens = false;

  @override
  void initState() {
    super.initState();
    _checkTokensAfterInit();
  }

  Future<void> _checkTokensAfterInit() async {
    // Small delay to ensure GraphqlService is ready
    await Future.delayed(const Duration(milliseconds: 100));

    final AuthController authController = Get.find();

    try {
      await authController.checkLoginStatusFromGraphqlService();
    } catch (e) {
      debugPrint('[AuthWrapper] GraphQL auth check failed: $e');
      authController.setLoggedIn(false);
    }

    setState(() {
      _hasCheckedTokens = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final UtilityController utilityController = Get.find();
    final box = GetStorage();

    return Obx(() {
      // Show loading while checking authentication
      if (utilityController.isLoading || !_hasCheckedTokens) {
        return Scaffold(body: Skeletons.fullScreen());
      }

      final authToken = GraphqlService.authToken;
      final channelToken = GraphqlService.channelToken;

      debugPrint('[AuthWrapper] Auth token present: ${authToken.isNotEmpty}');
      debugPrint(
          '[AuthWrapper] Channel token present: ${channelToken.isNotEmpty}');
      debugPrint(
          '[AuthWrapper] AuthController logged in: ${authController.isLoggedIn}');

      // User is logged in and tokens are valid → Home
      if (authController.isLoggedIn &&
          authToken.isNotEmpty &&
          channelToken.isNotEmpty) {
        return MyHomePage();
      }

      // If user is logged in but tokens missing → reset login state
      if (authController.isLoggedIn &&
          (authToken.isEmpty || channelToken.isEmpty)) {
        debugPrint('[AuthWrapper] Tokens missing, clearing login state');
        authController.setLoggedIn(false);
      }

      // Check if intro page has been shown
      final bool introShown = box.read('intro_shown') ?? false;

      if (!introShown) {
        // Mark intro as shown after displaying
        WidgetsBinding.instance.addPostFrameCallback((_) {
          box.write('intro_shown', true);
        });
        return const IntroPage();
      }

      // Default → show login page
      return const LoginPage();
    });
  }
}
