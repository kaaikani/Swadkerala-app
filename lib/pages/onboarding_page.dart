import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../generated/assets.dart';

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

            // Overlaid UI elements
            Column(
              children: [
                // Skip button at top right
                if (_currentPage < _onboardingImages.length - 1)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                      child: TextButton(
                        onPressed: () {
                          _markOnboardingComplete();
                          Get.offAllNamed('/login');
                        },
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

                // Spacer to push content to bottom
                const Spacer(),

                // Page indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingImages.length,
                    (index) => _buildPageIndicator(index == _currentPage),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(20)),

                // Bottom buttons
                Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
                  child: _currentPage < _onboardingImages.length - 1
                      ? _buildNextButton()
                      : _buildActionButtons(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(String imagePath, int index) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          // Debug: Print error details
          debugPrint('[OnboardingPage] Error loading image: $imagePath');
          debugPrint('[OnboardingPage] Error: $error');
          // Fallback if image not found
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: ResponsiveUtils.rp(80),
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: ResponsiveUtils.rp(16)),
                Text(
                  'Image: ${imagePath.split('/').last}',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(12),
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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
    return Row(
      children: [
        // Register Button
        Expanded(
          child: OutlinedButton(
            onPressed: _navigateToSignup,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.button,
              side: BorderSide(color: AppColors.button, width: 2),
              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
            ),
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: ResponsiveUtils.rp(16)),
        // Login Button
        Expanded(
          child: ElevatedButton(
            onPressed: _navigateToLogin,
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
              'Login',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

