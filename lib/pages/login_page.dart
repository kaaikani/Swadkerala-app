import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/graphql_client.dart';
import '../theme/theme.dart';
import '../utils/navigation_helper.dart';
import '../utils/responsive.dart';
import '../services/analytics_service.dart';
import '../routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _authController = Get.find<AuthController>();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Per-button loading
  bool _isLoadingGoogle = false;
  bool _isLoadingApple = false;
  bool get _isAnyLoginLoading => _isLoadingGoogle || _isLoadingApple;

  // Intended route after login
  String? _intendedRoute;
  dynamic _intendedArguments;

  static const String _keyIntendedRoute = 'login_intended_route';
  static const String _keyIntendedArguments = 'login_intended_arguments';
  final GetStorage _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _captureIntendedRoute();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureIntendedRoute();
      AnalyticsService().logScreenView(screenName: 'Login');
      _clearAllCache();
      _authController.resetFormField();
    });
    _initializeAnimations();
  }

  void _captureIntendedRoute() {
    final args = Get.arguments is Map ? Get.arguments as Map : null;
    if (args != null) {
      final route = args['intendedRoute']?.toString();
      if (route != null && route.isNotEmpty) {
        _intendedRoute = route;
        _intendedArguments = args['intendedArguments'];
        _storage.write(_keyIntendedRoute, route);
        if (args['intendedArguments'] != null) {
          _storage.write(_keyIntendedArguments, args['intendedArguments']);
        } else {
          _storage.remove(_keyIntendedArguments);
        }
      }
    }
  }

  String? _getIntendedRouteForRedirect() {
    final route = _intendedRoute ?? _storage.read(_keyIntendedRoute)?.toString();
    return (route != null && route.isNotEmpty) ? route : null;
  }

  dynamic _getIntendedArgumentsForRedirect() {
    if (_intendedArguments != null) return _intendedArguments;
    return _storage.read(_keyIntendedArguments);
  }

  void _clearStoredIntendedRoute() {
    _storage.remove(_keyIntendedRoute);
    _storage.remove(_keyIntendedArguments);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _clearAllCache() async {
    try {
      await GraphqlService.clearToken('auth');
      final storage = GetStorage();

      // Preserve important flags
      final preservedOnboardingComplete = storage.read('onboarding_complete');
      final preservedIntroShown = storage.read('intro_shown');
      final preservedPostalCode = storage.read('postal_code');
      final preservedChannelCode = storage.read('channel_code');
      final preservedChannelName = storage.read('channel_name');
      final preservedChannelType = storage.read('channel_type');
      final preservedChannelToken = storage.read('channel_token')?.toString();

      await storage.erase();

      if (preservedOnboardingComplete != null) {
        await storage.write('onboarding_complete', preservedOnboardingComplete);
      }
      if (preservedIntroShown != null) {
        await storage.write('intro_shown', preservedIntroShown);
      }
      if (preservedPostalCode != null) {
        await storage.write('postal_code', preservedPostalCode);
      }
      if (preservedChannelCode != null) {
        await storage.write('channel_code', preservedChannelCode);
      }
      if (preservedChannelName != null) {
        await storage.write('channel_name', preservedChannelName);
      }
      if (preservedChannelType != null) {
        await storage.write('channel_type', preservedChannelType);
      }
      if (preservedChannelToken != null && preservedChannelToken.isNotEmpty) {
        await storage.write('channel_token', preservedChannelToken);
      }
    } catch (e) {
      // debugPrint('[LoginPage] Error clearing cache: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.button.withValues(alpha: 0.08),
                AppColors.background,
                AppColors.button.withValues(alpha: 0.03),
              ],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(24),
                      vertical: ResponsiveUtils.rp(32),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 420),
                      child: _buildLoginOptions(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo
        Center(
          child: Image.asset(
            'assets/images/kklogo_foreground_large.png',
            width: ResponsiveUtils.rp(220),
            height: ResponsiveUtils.rp(220),
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(height: ResponsiveUtils.rp(24)),

        // Header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign In',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(32),
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -1.0,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
            Text(
              'Choose how you want to sign in',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        SizedBox(height: ResponsiveUtils.rp(32)),

        // Google Sign In
        _buildSignInButton(
          icon: null,
          title: 'Sign in with Google',
          subtitle: 'Use your Google account',
          onTap: _isAnyLoginLoading ? null : _handleGoogleSignIn,
          color: Colors.blue.shade700,
          backgroundColor: Colors.blue.withValues(alpha: 0.06),
          isLoading: _isLoadingGoogle,
          customIcon: Image.asset(
            'assets/images/google_logo.png',
            width: ResponsiveUtils.rp(24),
            height: ResponsiveUtils.rp(24),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return FaIcon(
                FontAwesomeIcons.google,
                size: ResponsiveUtils.rp(22),
                color: Colors.blue.shade700,
              );
            },
          ),
        ),

        // Apple Sign In - iOS only
        if (defaultTargetPlatform == TargetPlatform.iOS) ...[
          SizedBox(height: ResponsiveUtils.rp(12)),
          _buildSignInButton(
            icon: Icons.apple,
            title: 'Sign in with Apple',
            subtitle: 'Use your Apple ID',
            onTap: _isAnyLoginLoading ? null : _handleAppleSignIn,
            color: Colors.black,
            backgroundColor: Colors.black.withValues(alpha: 0.06),
            isLoading: _isLoadingApple,
            iconSize: 28,
          ),
        ],

        SizedBox(height: ResponsiveUtils.rp(32)),

        // Guest continue
        Center(
          child: TextButton(
            onPressed: _isAnyLoginLoading
                ? null
                : () => Get.offAllNamed(AppRoutes.home),
            child: Text(
              'Continue as Guest',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton({
    IconData? icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    required Color color,
    required Color backgroundColor,
    bool isLoading = false,
    Widget? customIcon,
    double iconSize = 24,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.rp(20),
            vertical: ResponsiveUtils.rp(18),
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
          ),
          child: Row(
            children: [
              // Icon
              SizedBox(
                width: ResponsiveUtils.rp(48),
                height: ResponsiveUtils.rp(48),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: ResponsiveUtils.rp(20),
                          height: ResponsiveUtils.rp(20),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        )
                      : customIcon ??
                          Icon(icon, size: ResponsiveUtils.rp(iconSize), color: color),
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(16)),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(2)),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(13),
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: ResponsiveUtils.rp(16),
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isAnyLoginLoading) return;
    setState(() => _isLoadingGoogle = true);
    try {
      final success = await _authController.signInWithGoogle(context);
      if (success) {
        await AnalyticsService().logLogin(loginMethod: 'Google');
        _captureIntendedRoute();
        await NavigationHelper.redirectToIntendedRoute(
          intendedRoute: _getIntendedRouteForRedirect(),
          intendedArguments: _getIntendedArgumentsForRedirect(),
        );
        _clearStoredIntendedRoute();
      }
    } finally {
      if (mounted) setState(() => _isLoadingGoogle = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    if (_isAnyLoginLoading) return;
    setState(() => _isLoadingApple = true);
    try {
      final success = await _authController.signInWithApple(context);
      if (success) {
        await AnalyticsService().logLogin(loginMethod: 'Apple');
        _captureIntendedRoute();
        await NavigationHelper.redirectToIntendedRoute(
          intendedRoute: _getIntendedRouteForRedirect(),
          intendedArguments: _getIntendedArgumentsForRedirect(),
        );
        _clearStoredIntendedRoute();
      }
    } finally {
      if (mounted) setState(() => _isLoadingApple = false);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}
