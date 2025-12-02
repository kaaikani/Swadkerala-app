import 'package:flutter/material.dart';
import '../widgets/shimmers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/authentication/authenticationcontroller.dart';
import 'auth_wrapper.dart';

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  bool _updateInProgress = false;
  int _retryCount = 0;
  final AuthController authController = Get.find<AuthController>();

  void _performImmediateUpdate() async {
    // Clear cache or perform logout before starting the update
    /*
 await _clearCacheOrLogout();
*/

    setState(() {
      _updateInProgress = true;
    });

    try {
      // First try to perform immediate update
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      setState(() {
        _updateInProgress = false;
      });

      // If immediate update fails (e.g., app not from Play Store), open Play Store
// debugPrint('[UpdateScreen] Immediate update failed: $e');
// debugPrint('[UpdateScreen] Falling back to Play Store...');

      try {
        await _openPlayStoreForUpdate();
      } catch (playStoreError) {
// debugPrint('[UpdateScreen] Play Store fallback also failed: $playStoreError');

        // Show error dialog with only retry option (no bypass)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            _retryCount++;
            return AlertDialog(
              title: Text('Update Required'),
              content: Text(
                  'Unable to update the app. This may happen if the app is not installed from Play Store.\n\nPlease try again or install the app from Play Store.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _performImmediateUpdate(); // Retry update
                  },
                  child: Text('Retry Update'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _openPlayStoreForUpdate(); // Open Play Store
                  },
                  child: Text('Open Play Store'),
                ),
                // Only show skip option after 3 failed attempts
                if (_retryCount >= 3)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to login/auth wrapper
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AuthWrapper()),
                      );
                    },
                    child: Text('Skip (Not Recommended)',
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
            );
          },
        );
      }
    }
  }

  /// Open Play Store to update the app
  Future<void> _openPlayStoreForUpdate() async {
    try {
      const packageName = 'com.kaaikani.kaaikani';
      final Uri playStoreUrl = Uri.parse('market://details?id=$packageName');
      final Uri webStoreUrl = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName');

// debugPrint('[UpdateScreen] Opening Play Store...');

      // Try to open Play Store app
      if (await canLaunchUrl(playStoreUrl)) {
        await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to web browser
        await launchUrl(webStoreUrl, mode: LaunchMode.externalApplication);
      }

      // Show message that user should return after updating
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please update the app and return to continue'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
// debugPrint('[UpdateScreen] Error opening Play Store: $e');
      rethrow; // Re-throw to be caught by the calling method
    }
  }

  /*  Future<void> _clearCacheOrLogout() async {
    // Example: Log out the user
    loginPageController.onUserLogout(context);

    // Example: Clear cache (if applicable)
    // await someCacheClearingFunction();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Center(
            child: _updateInProgress
                ? SizedBox(height: 20, child: Skeletons.smallBox(size: 20))
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Update.png', // Replace with your image path
                          height: 300,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Update Required!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 15),
                        const Text(
                          'A new version is available and must be installed to continue using the app.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 15),
                        const Text(
                          'This update includes important bug fixes, security improvements, and new features.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _performImmediateUpdate,
                    icon: Icon(Icons.system_update_alt, color: Colors.white),
                    label: const Text(
                      'Update Now',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 10,
                      minimumSize: const Size(double.infinity,
                          60), // Full width button with more height
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'T&C apply',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 150,
              color: Colors.amber,
            ),
            const SizedBox(height: 32),
            const Text(
              'If you encounter any issues, please contact Support.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSupportButton(
                  context,
                  'assets/images/support.png',
                  'Call us',
                  Icons.call,
                  Colors.white,
                  () => _callSupport(context),
                ),
                const SizedBox(width: 16),
                _buildSupportButton(
                  context,
                  'assets/images/whatapp.png',
                  'Chat us',
                  Icons.chat,
                  Colors.green,
                  () => _chatSupport(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportButton(
    BuildContext context,
    String imagePath,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 50,
          height: 50,
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20, color: Colors.white),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _callSupport(BuildContext context) async {
    final String? helpCall = dotenv.env['HELP_CALL'];
    if (helpCall != null) {
      final Uri phoneUri = Uri(scheme: 'tel', path: helpCall);
      try {
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not make a call')),
          );
        }
      } catch (e) {
// print('Error launching call: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred while making the call')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Help call number not available')),
      );
    }
  }

  Future<void> _chatSupport(BuildContext context) async {
    const String supportPhoneNumber = '919894681385';
    const String message = 'Hello, Kaaikani\n\nMy Kaaikani App has an issue';
    final Uri whatsappUri = Uri.parse(
      "https://wa.me/$supportPhoneNumber?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }
}
