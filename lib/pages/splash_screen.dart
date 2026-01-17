import 'package:flutter/material.dart';
import '../widgets/shimmers.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/sim_detection_service.dart';
import '../theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Permission request state (set but not currently read)
  // ignore: unused_field
  bool _isRequestingPermission = false;
  String _statusMessage = 'Loading...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  Future<void> _navigateToApp() async {
    // Wait for animations to complete
    await Future.delayed(const Duration(seconds: 2));

    // Request permissions during splash screen
    await _requestPermissions();

    // Navigate to auth wrapper
    if (mounted) {
      Get.offAllNamed('/');
    }
  }

  Future<void> _requestPermissions() async {

    setState(() {
      _isRequestingPermission = true;
      _statusMessage = 'Requesting permissions...';
    });

    try {
      // Check phone permission using permission_handler
      PermissionStatus phoneStatus = await Permission.phone.status;

      if (phoneStatus.isDenied || phoneStatus.isPermanentlyDenied) {
        setState(() {
          _statusMessage = 'Please grant phone permission for SIM detection...';
        });

        phoneStatus = await Permission.phone.request();

        if (phoneStatus.isGranted) {
          setState(() {
            _statusMessage = 'Permission granted! Detecting SIM cards...';
          });

          // Try to detect SIM cards and cache them
          final simService = SimDetectionService();
          await simService.getAllSimInfo();

          setState(() {
            _statusMessage = 'Ready!';
          });
        } else {
          setState(() {
            _statusMessage =
                'Permission denied. You can enter phone number manually.';
          });
        }
      } else if (phoneStatus.isGranted) {
        setState(() {
          _statusMessage = 'Permission already granted. Detecting SIM cards...';
        });

        // Try to detect SIM cards and cache them
        final simService = SimDetectionService();
        await simService.getAllSimInfo();

        setState(() {
          _statusMessage = 'Ready!';
        });
      } else {
        setState(() {
          _statusMessage =
              'Permission status unknown. You can enter phone number manually.';
        });
      }

      // Wait a bit to show the final status
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      setState(() {
        _statusMessage = 'Ready!';
      });
    } finally {
      setState(() {
        _isRequestingPermission = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenPrimary, // Green background
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo/Icon with white background container
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white, // White background for the logo container
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/images/kklogo.png',
                          fit: BoxFit.contain,
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to icon if image not found
                            return const Icon(
                              Icons.shopping_bag,
                              size: 60,
                              color: AppColors.greenPrimary,
                            );
                          },
                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                            } else if (frame != null) {
                            }
                            return child;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // App Name
                    const Text(
                      'Madurai Store',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tagline
                    const Text(
                      'Your Shopping Destination',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Loading indicator
                    SizedBox(height: 24, child: Skeletons.smallBox(size: 24)),
                    const SizedBox(height: 20),

                    // Status text
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
