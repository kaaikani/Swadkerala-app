import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../generated/assets.dart';
import '../controllers/authentication/authenticationcontroller.dart' show AuthController;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final GetStorage _storage = GetStorage();
  int _currentPage = 0;

  // Onboarding images - using Assets constants
  final List<String> _onboardingImages = [
    Assets.images01Onboarding1,
    Assets.images02Onboarding2,
    Assets.images03Onboarding3,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingImages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _markOnboardingComplete() {
    _storage.write('onboarding_complete', true);
    _storage.write('intro_shown', true); // Also mark intro as shown for compatibility
  }

  void _navigateToHome() {
    _markOnboardingComplete();
    Get.offAllNamed('/home');
  }

  void _navigateToLogin() {
    _markOnboardingComplete();
    Get.offAllNamed('/login');
  }

  void _navigateToSignup() {
    _markOnboardingComplete();
    Get.offAllNamed('/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Full-screen background image
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _onboardingImages.length,
              itemBuilder: (context, index) {
                return _buildOnboardingPage(_onboardingImages[index], index);
              },
            ),

            // Overlaid UI elements (only for screens 1 & 2)
            if (_currentPage < _onboardingImages.length - 1)
              Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                      child: TextButton(
                        onPressed: _navigateToHome,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.3),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(16),
                            vertical: ResponsiveUtils.rp(8),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
                          ),
                        ),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingImages.length,
                      (index) => _buildPageIndicator(index == _currentPage),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Padding(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
                    child: _buildNextButton(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(String imagePath, int index) {
    if (index == 2) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            // Image at the top, no extra whitespace
            Expanded(
              flex: 5,
              child: Image.asset(
                imagePath,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                alignment: Alignment.topCenter,
              ),
            ),
            // Page indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingImages.length,
                (i) => _buildPageIndicator(i == _currentPage),
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            // Buttons below the image
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(24)),
              child: _buildActionButtons(),
            ),
            SizedBox(height: ResponsiveUtils.rp(16)),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          // debugPrint('[OnboardingPage] Error loading image: $imagePath');
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.background,
            child: Icon(
              Icons.image_not_supported,
              size: ResponsiveUtils.rp(80),
              color: AppColors.textSecondary,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(4)),
      width: isActive ? ResponsiveUtils.rp(24) : ResponsiveUtils.rp(8),
      height: ResponsiveUtils.rp(8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.button : AppColors.border,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(4)),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(16)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          ),
          elevation: 2,
        ),
        child: Text(
          'Next',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Continue with Google
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              _markOnboardingComplete();
              final authController = Get.find<AuthController>();
              final success = await authController.signInWithGoogle(context);
              if (success) {
                Get.offAllNamed('/home');
              }
            },
            icon: Image.asset(
              'assets/images/google_logo.png',
              height: ResponsiveUtils.rp(24),
              width: ResponsiveUtils.rp(24),
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.g_mobiledata,
                size: ResponsiveUtils.rp(24),
                color: Colors.white,
              ),
            ),
            label: Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
              elevation: 2,
            ),
          ),
        ),
        // Continue with Apple (iOS only)
        if (isIOS) ...[
          SizedBox(height: ResponsiveUtils.rp(12)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                _markOnboardingComplete();
                final authController = Get.find<AuthController>();
                final success = await authController.signInWithApple(context);
                if (success) {
                  Get.offAllNamed('/home');
                }
              },
              icon: Icon(Icons.apple, size: ResponsiveUtils.rp(24)),
              label: Text(
                'Continue with Apple',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(16)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
        // Continue as Guest
        SizedBox(height: ResponsiveUtils.rp(12)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _navigateToHome,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: BorderSide(color: AppColors.border),
              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
            ),
            child: Text(
              'Continue as Guest',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

