import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/shimmers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/graphql_client.dart';
import '../services/notification_service.dart';
import '../theme/colors.dart';
import '../routes.dart';
import 'login_page.dart';
import 'homepage.dart';
import 'onboarding_page.dart';

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
    // debugPrint('[AuthWrapper] initState called');
    _checkTokensAfterInit();
  }

  Future<void> _checkTokensAfterInit() async {
    // Small delay to ensure GraphqlService is ready
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final AuthController authController = Get.find();

    // debugPrint('[AuthWrapper] Starting token check...');
    try {
      // Add timeout to prevent blocking
      await authController.checkLoginStatusFromGraphqlService().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          // debugPrint('[AuthWrapper] Token check timed out');
          // If token check times out, assume not logged in
          authController.setLoggedIn(false);
        },
      );
      // debugPrint('[AuthWrapper] Token check completed');
    } catch (e) {
      // debugPrint('[AuthWrapper] Token check error: $e');
      authController.setLoggedIn(false);
    }

    // debugPrint('[AuthWrapper] Setting _hasCheckedTokens = true');
    if (mounted) {
      setState(() {
        _hasCheckedTokens = true;
      });
      // Handle pending notification from terminated state (after auth + navigator are ready)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 600), () {
          NotificationService.instance.handlePendingInitialMessageIfAny();
          NotificationService.instance.handlePendingTimerNavigation();
        });
      });
    }
    } catch (e) {
      // debugPrint('[AuthWrapper] Error getting AuthController: $e');
      // If Get.find() fails, set checked anyway to proceed
      if (mounted) {
        setState(() {
          _hasCheckedTokens = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final AuthController authController = Get.find();
      // Removed utilityController check - it was causing the app to hang
      final box = GetStorage();

      // Show loading while checking authentication
      if (!_hasCheckedTokens) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Skeletons.fullScreen(),
        );
      }

      // Use Obx to react to authController.isLoggedIn changes
      // Access the reactive variable through the controller
      return Obx(() {
        final authToken = GraphqlService.authToken;
        final channelToken = GraphqlService.channelToken;
        
        // Access isLoggedIn to trigger Obx rebuild when it changes
        final isLoggedIn = authController.isLoggedIn;

        // User is logged in and tokens are valid → Home
        if (isLoggedIn &&
            authToken.isNotEmpty &&
            channelToken.isNotEmpty) {
          return MyHomePage();
        }

        // If user is logged in but tokens missing → reset login state
        if (isLoggedIn &&
            (authToken.isEmpty || channelToken.isEmpty)) {
          authController.setLoggedIn(false);
        }

        // Check if onboarding has been completed
        // Onboarding should only show on first app install/launch
        // Once completed, it should never show again (even after logout)
        final bool onboardingComplete = box.read('onboarding_complete') ?? false;
        final bool introShown = box.read('intro_shown') ?? false;

        // Show onboarding ONLY if both flags are false (first time ever)
        // If either flag is true, user has seen onboarding before - don't show again
        if (!onboardingComplete && !introShown) {
          // debugPrint('[AuthWrapper] First app launch - showing onboarding');
          return const OnboardingPage();
        } else {
          // debugPrint('[AuthWrapper] Onboarding already shown - onboardingComplete: $onboardingComplete, introShown: $introShown');
        }

        // Not logged in → show Home with Guest/Sign up dialog once; checkout will ask for mandatory login (AuthGuard)
        return _GuestOrSignupGate(child: MyHomePage());
      });
    } catch (e) {
      // debugPrint('[AuthWrapper] Error in build: $e');
      // Fallback to login page if anything fails
      return const LoginPage();
    }
  }
}

/// Shows a one-time dialog on app open when user is not logged in: Continue as Guest or Sign up.
/// Guest → stay on home and can add to cart; checkout will require mandatory login (AuthGuard).
class _GuestOrSignupGate extends StatefulWidget {
  final Widget child;

  const _GuestOrSignupGate({required this.child});

  @override
  State<_GuestOrSignupGate> createState() => _GuestOrSignupGateState();
}

class _GuestOrSignupGateState extends State<_GuestOrSignupGate> {
  static bool _dialogShownThisSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showDialogOnce());
  }

  void _showDialogOnce() {
    if (!mounted || _dialogShownThisSession) return;
    _dialogShownThisSession = true;
    _showGuestOrSignupDialog();
  }

  void _showGuestOrSignupDialog() {
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.button.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 40,
                  color: AppColors.button,
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'Browse products and add to cart.\nSign in when you\'re ready to checkout.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              // Sign in button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Get.toNamed(AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Continue as guest button (secondary)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
