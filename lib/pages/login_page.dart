import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/graphql_client.dart';
import '../services/sim_detection_service.dart';
import '../services/sms_autofill_service.dart';
import '../theme/colors.dart';
import '../theme/sizes.dart';
import '../widgets/button.dart';
import '../widgets/textbox.dart';
import 'homepage.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authController = Get.find<AuthController>();
  final _smsAutofillService = SmsAutofillService();
  bool _isOtpVisible = false;
  bool _isDetectingSim = false;
  String _statusMessage = 'Detecting SIM cards...';

  @override
  @override
  void initState() {
    super.initState();
    
    // Initialize SMS autofill service
    _initializeSmsAutofill();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearAllCache();
      _resetState();
      // Add delay for first-time app installs to let mobile_number package initialize
      Future.delayed(const Duration(milliseconds: 1500), () {
        _autoFillPhoneNumberWrapper();
      });
    });
  }

  /// Initialize SMS autofill service
  Future<void> _initializeSmsAutofill() async {
    try {
      await _smsAutofillService.initialize();
      debugPrint('[LoginPage] SMS autofill service initialized');
    } catch (e) {
      debugPrint('[LoginPage] Error initializing SMS autofill: $e');
    }
  }

  /// Fire-and-forget async wrapper
  void _autoFillPhoneNumberWrapper() async {
    await _autoFillPhoneNumber();
  }

  void _resetState() {
    _authController.resetFormField();
    setState(() {
      _isOtpVisible = false;
    });
  }

  /// Clear all local cache and storage when login page loads
  Future<void> _clearAllCache() async {
    try {
      debugPrint('[LoginPage] Clearing all local cache and storage...');
      
      // Clear GraphQL tokens
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');
      
      // Clear all storage data
      final storage = GetStorage();
      await storage.erase();
      
      // Reset authentication state
      _authController.setLoggedIn(false);
      _authController.setOtpSent(false);
      
      debugPrint('[LoginPage] ✅ All cache and storage cleared successfully');
    } catch (e) {
      debugPrint('[LoginPage] ❌ Error clearing cache: $e');
    }
  }

  /// Automatically detect SIM numbers and handle OTP triggering with timeout
  Future<void> _autoFillPhoneNumber() async {
    setState(() {
      _isDetectingSim = true;
    });

    try {
      final simService = SimDetectionService();
      
      // Check if permission is already granted (should be done in splash screen)
      bool hasPermission = await simService.hasPhonePermission();
      
      if (!hasPermission) {
        debugPrint('[LoginPage] No permission available, requesting permission...');
        setState(() {
          _statusMessage = 'Requesting phone permission...';
        });
        
        // Try permission_handler first (more reliable)
        PermissionStatus phoneStatus = await Permission.phone.request();
        debugPrint('[LoginPage] Permission_handler result: $phoneStatus');
        
        hasPermission = phoneStatus.isGranted;
        
        if (!hasPermission) {
          // Fallback to mobile_number package
          debugPrint('[LoginPage] Trying mobile_number package fallback...');
          hasPermission = await simService.requestPhonePermission().timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              debugPrint('[LoginPage] Permission request timeout');
              return false;
            },
          );
        }
        
        if (!hasPermission) {
          debugPrint('[LoginPage] Permission denied, showing manual entry option');
          _showSnackBar('Phone permission denied. Please enter your phone number manually.', isError: false);
          setState(() {
            _isDetectingSim = false;
          });
          return;
        }
        
        debugPrint('[LoginPage] Permission granted, proceeding with SIM detection');
        setState(() {
          _statusMessage = 'Permission granted! Detecting SIM cards...';
        });
        
        // Restart SIM detection (like initState)
        await _restartSimDetection();
        return;
      }

      // Try to get cached SIM info first (should be available from splash screen)
      debugPrint('[LoginPage] Getting cached SIM info...');
      List<SimInfo> simInfoList = await simService.getAllSimInfo().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('[LoginPage] SIM detection timeout');
          return <SimInfo>[];
        },
      );
      
      if (simInfoList.isEmpty) {
        debugPrint('[LoginPage] No SIM cards found');
        _showSnackBar('No SIM cards detected. Please enter your phone number manually.', isError: false);
        return;
      }

      debugPrint('[LoginPage] Found ${simInfoList.length} SIM cards');

      if (simInfoList.length == 1) {
        // Single SIM - auto-fill and send OTP
        final simInfo = simInfoList.first;
        _authController.phoneNumber.text = simInfo.last10Digits;
        debugPrint('[LoginPage] Auto-filling single SIM: ${simInfo.last10Digits}');
        
        _showSnackBar('SIM detected! Sending OTP to +91 ${simInfo.last10Digits}', isError: false);
        
        // Automatically trigger OTP send
        await _sendOtp();
      } else {
        // Multiple SIMs - show selection dialog
        final selectedSim = await simService.showSimSelectionDialog(context, simInfoList);
        
        if (selectedSim != null) {
          if (selectedSim.phoneNumber.isNotEmpty) {
            _authController.phoneNumber.text = selectedSim.last10Digits;
            debugPrint('[LoginPage] Selected SIM: ${selectedSim.last10Digits}');
            
            _showSnackBar('Sending OTP to +91 ${selectedSim.last10Digits}', isError: false);
            
            // Automatically trigger OTP send
            await _sendOtp();
          } else {
            _showSnackBar('Selected SIM has no phone number. Please enter your phone number manually.', isError: false);
            // Focus on phone number field for manual entry
            _authController.phoneNumber.clear();
          }
        } else {
          _showSnackBar('Please select a SIM card or enter your phone number manually', isError: false);
        }
      }
    } catch (e) {
      debugPrint('[LoginPage] Failed to detect SIM numbers: $e');
      _showSnackBar('Failed to detect SIM numbers. Please enter your phone number manually.', isError: true);
    } finally {
      setState(() {
        _isDetectingSim = false;
      });
    }
  }


  /// Restart SIM detection (like initState)
  Future<void> _restartSimDetection() async {
    debugPrint('[LoginPage] Restarting SIM detection...');
    
    setState(() {
      _isDetectingSim = true;
      _statusMessage = 'Detecting SIM cards...';
    });
    
    // Clear any existing phone number
    _authController.phoneNumber.clear();
    
    // Reset OTP state
    setState(() {
      _isOtpVisible = false;
    });
    
    // Start SIM detection
    await _autoFillPhoneNumber();
  }

  /// Manual permission request method with fallback
  Future<void> _requestPermissionManually() async {
    setState(() {
      _isDetectingSim = true;
      _statusMessage = 'Requesting permission...';
    });

    try {
      debugPrint('[LoginPage] Manual permission request...');
      
      // Try permission_handler first (more reliable)
      PermissionStatus phoneStatus = await Permission.phone.request();
      debugPrint('[LoginPage] Permission_handler result: $phoneStatus');
      
      bool hasPermission = phoneStatus.isGranted;
      
      if (!hasPermission) {
        // Fallback to mobile_number package
        debugPrint('[LoginPage] Trying mobile_number package fallback...');
        final simService = SimDetectionService();
        hasPermission = await simService.requestPhonePermission().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('[LoginPage] Mobile_number permission request timeout');
            return false;
          },
        );
      }
      
      if (hasPermission) {
        debugPrint('[LoginPage] Permission granted, detecting SIMs...');
        setState(() {
          _statusMessage = 'Permission granted! Detecting SIM cards...';
        });
        
        // Restart SIM detection (like initState)
        await _restartSimDetection();
      } else {
        debugPrint('[LoginPage] Permission denied');
        _showSnackBar('Permission denied. Please grant phone permission in settings or enter your phone number manually.', isError: true);
        setState(() {
          _isDetectingSim = false;
        });
      }
    } catch (e) {
      debugPrint('[LoginPage] Manual permission request failed: $e');
      _showSnackBar('Failed to request permission. Please enter your phone number manually.', isError: true);
      setState(() {
        _isDetectingSim = false;
      });
    }
  }

  /// Show snackbar with appropriate styling
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Start SMS autofill listening
  Future<void> _startSmsAutofill() async {
    try {
      await _smsAutofillService.startListening((otp) {
        debugPrint('[LoginPage] OTP received from SMS: $otp');
        _authController.otpController.text = otp;
        // Auto-verify OTP
        _verifyOtp();
      });
      debugPrint('[LoginPage] SMS autofill listening started');
    } catch (e) {
      debugPrint('[LoginPage] Error starting SMS autofill: $e');
    }
  }

  /// Stop SMS autofill listening
  void _stopSmsAutofill() {
    try {
      _smsAutofillService.stopListening();
      debugPrint('[LoginPage] SMS autofill listening stopped');
    } catch (e) {
      debugPrint('[LoginPage] Error stopping SMS autofill: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top gradient container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.65,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.login,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),

          // Bottom draggable card
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    left: AppSizes.defaultPadding * 1.5,
                    right: AppSizes.defaultPadding * 1.5,
                    top: AppSizes.defaultPadding * 1.5,
                    bottom: keyboardHeight + AppSizes.defaultPadding * 1.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      _buildPhoneNumberField(),
                      const SizedBox(height: 20),
                      _buildOtpField(),
                      const SizedBox(height: 30),
                      _buildLoginButton(),
                      const SizedBox(height: 16),
                      _buildResendButton(),
                      const SizedBox(height: 24),
                      _buildSignupLink(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      children: [
        Stack(
          children: [
            TextButtonField(
              controller: _authController.phoneNumber,
              hint: _isDetectingSim ? 'Detecting SIM...' : 'Phone Number',
              prefixText: '+91 ',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              enabled: !_isOtpVisible && !_isDetectingSim,
            ),
            if (_isDetectingSim)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (_isDetectingSim)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(
                  _statusMessage,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isDetectingSim = false;
                        });
                        _showSnackBar('SIM detection cancelled. Please enter your phone number manually.', isError: false);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'First time? This may take a moment...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        // Add permission request button when not detecting
        if (!_isDetectingSim && !_isOtpVisible)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _requestPermissionManually,
                  icon: const Icon(Icons.sim_card, size: 16),
                  label: const Text('Detect SIM Cards'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOtpField() {
    return Obx(() {
      if (!_authController.isOtpSent) return const SizedBox.shrink();

      return Column(
        children: [
          TextButtonField(
            controller: _authController.otpController,
            hint: '4-Digit OTP',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            onChanged: (value) {
              // Auto-verify OTP when 4 digits are entered
              if (value.length == 4) {
                _verifyOtp();
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            'OTP sent to +91 ${_authController.phoneNumber.text}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'SMS will be auto-filled when received',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.green[600],
              fontSize: 12,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLoginButton() {
    return Obx(() {
      final isLoading = _authController.isLoading;
      final isOtpSent = _authController.isOtpSent;

      return AppButton(
        text: isOtpSent ? 'Verify & Login' : 'Send OTP',
        backgroundColor: AppColors.primary,
        onPressed: isLoading ? null : _handleButtonPress,
      );
    });
  }

  Widget _buildResendButton() {
    return Obx(() {
      if (!_authController.isOtpSent) return const SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Didn't receive OTP? ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          TextButton(
            onPressed: _authController.isLoading ? null : _handleResendOtp,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text(
              'Resend',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        TextButton(
          onPressed: () {
            Get.to(() => const SignupPage());
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleButtonPress() async {
    if (_authController.isOtpSent) {
      await _verifyOtp();
    } else {
      await _sendOtp();
    }
  }

  Future<void> _sendOtp() async {
    if (_authController.phoneNumber.text.length != 10) return;

    final success = await _authController.startLoginFlow(context);
    if (success) {
      setState(() => _isOtpVisible = true);
      // Start listening for SMS autofill
      _startSmsAutofill();
    }
  }

  Future<void> _verifyOtp() async {
    if (_authController.otpController.text.length != 4) return;

    final success = await _authController.verifyOtp(context);
    if (success) Get.offAll(() => MyHomePage());
  }

  Future<void> _handleResendOtp() async {
    await _authController.resendOtp(context);
  }

  @override
  void dispose() {
    // Stop SMS autofill listening
    _stopSmsAutofill();
    super.dispose();
  }
}
