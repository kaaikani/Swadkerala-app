import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/app_config.dart';
import '../../widgets/snackbar.dart';

class HomePostalCodeSheet extends StatefulWidget {
  final CustomerController customerController;
  final VoidCallback onPostalCodeSelected;
  final bool isMandatory;

  const HomePostalCodeSheet({
    Key? key,
    required this.customerController,
    required this.onPostalCodeSelected,
    this.isMandatory = false,
  }) : super(key: key);

  @override
  State<HomePostalCodeSheet> createState() => _HomePostalCodeSheetState();
}

class _HomePostalCodeSheetState extends State<HomePostalCodeSheet> {
  final box = GetStorage();
  final pincodeController = TextEditingController();
  bool isSearching = false;
  bool isGettingLocation = false;
  bool isServiceUnavailable = false;

  @override
  void dispose() {
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if postal code is already saved - if not, hide close button
    // Also hide close button if this is mandatory (invalid postal code)
    final storedPostalCode = box.read('postal_code');
    final bool hasPostalCode = storedPostalCode != null && storedPostalCode.toString().isNotEmpty && !widget.isMandatory;

    return PopScope(
      canPop: !widget.isMandatory, // Prevent back button when mandatory
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveUtils.rp(20)),
          ),
        ),
        child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
            width: ResponsiveUtils.rp(40),
            height: ResponsiveUtils.rp(4),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.button, size: ResponsiveUtils.rp(24)),
                SizedBox(width: ResponsiveUtils.rp(12)),
                Expanded(
                  child: Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                // Only show close button if postal code is already saved
                if (hasPostalCode)
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () {
                      try {
                        final navigator = Navigator.of(context, rootNavigator: false);
                        if (mounted && navigator.canPop()) {
                          navigator.pop();
                        }
                      } catch (e) {
                      }
                    },
                  ),
              ],
            ),
          ),
          Divider(height: 1),
          // Search section
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            child: Column(
              children: [
                // Location button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: isGettingLocation ? null : () async {
                      setState(() {
                        isGettingLocation = true;

                        isServiceUnavailable = false;
                      });
                      
                      final postalCode = await _getPostalCodeFromLocation();

                      if (postalCode != null && postalCode.isNotEmpty) {
                        setState(() {
                          isGettingLocation = false;
                          pincodeController.text = postalCode;
                          isSearching = true;
  
                          isServiceUnavailable = false;
                        });

                        // Try to switch channel directly in Vendure
                        final navigator = Navigator.of(context, rootNavigator: false);
                        final channelSwitched = await widget.customerController
                            .switchChannelByPostalCode(postalCode, showLoading: false);

                        if (!mounted) return;

                        if (channelSwitched) {
                          setState(() => isSearching = false);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              try {
                                if (navigator.canPop()) navigator.pop();
                                widget.onPostalCodeSelected();
                              } catch (_) {}
                            }
                          });
                          return;
                        }

                        setState(() {
  
                          isSearching = false;
                          isServiceUnavailable = false;
                        });
                        SnackBarWidget.showError('Service not available for this location.');
                      } else {
                        if (!mounted) return;
                        setState(() {
                          isGettingLocation = false;
                        });
                        SnackBarWidget.showError('Could not get location. Please enter postal code manually.');
                      }
                    },
                    icon: isGettingLocation
                        ? SizedBox(
                            width: ResponsiveUtils.rp(20),
                            height: ResponsiveUtils.rp(20),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.my_location, color: AppColors.button),
                    label: Text(
                      isGettingLocation ? 'Getting location...' : 'Use Current Location',
                      style: TextStyle(color: AppColors.button),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.button),
                      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(16)),
                // Search field
                TextField(
                  controller: pincodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: 'Enter 6-digit postal code',
                    hintText: 'eg: 625018',
                    prefixIcon: Icon(Icons.pin),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    ),
                  ),
                  onChanged: (value) async {
                    if (value.length == 6) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isSearching = true;

                        isServiceUnavailable = false;
                      });

                      // Step 1: Try to switch channel directly in Vendure
                      final navigator = Navigator.of(context, rootNavigator: false);
                      final channelSwitched = await widget.customerController
                          .switchChannelByPostalCode(value, showLoading: false);

                      if (!mounted) return;

                      if (channelSwitched) {
                        // Vendure has this postal code — switched, close sheet
                        setState(() => isSearching = false);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            try {
                              if (navigator.canPop()) navigator.pop();
                              widget.onPostalCodeSelected();
                            } catch (_) {}
                          }
                        });
                        return;
                      }

                      // Not in Vendure — show service unavailable
                      if (!mounted) return;
                      setState(() {

                        isSearching = false;
                        isServiceUnavailable = true;
                      });
                    } else {
                      setState(() {

                        isServiceUnavailable = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1),
          // Results section
          Expanded(
            child: isSearching
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: ResponsiveUtils.rp(16)),
                          Text(
                            'Checking service availability...',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: ResponsiveUtils.sp(14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : isServiceUnavailable
                    ? Column(
                        children: [
                          // Error message banner at top
                          Container(
                            margin: EdgeInsets.all(ResponsiveUtils.rp(16)),
                            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                              border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: ResponsiveUtils.rp(24),
                                ),
                                SizedBox(width: ResponsiveUtils.rp(12)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Service Not Available',
                                        style: TextStyle(
                                          color: AppColors.error,
                                          fontSize: ResponsiveUtils.sp(16),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: ResponsiveUtils.rp(4)),
                                      Text(
                                        'Not available in this postal code. Contact customer care',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: ResponsiveUtils.sp(14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: ResponsiveUtils.rp(8)),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _launchPhone(AppConfig.phoneNumber),
                                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                                      child: Padding(
                                        padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                          size: ResponsiveUtils.rp(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Empty space below
                          Expanded(
                            child: SizedBox.shrink(),
                          ),
                        ],
                      )
                    : Center(
                            child: Padding(
                              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                              child: Text(
                                pincodeController.text.length == 6
                                    ? 'Enter valid postal code'
                                    : 'Enter 6-digit postal code or use current location',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveUtils.sp(14),
                                ),
                              ),
                            ),
                          ),
          ),
        ],
      ),
      ),
    );
  }

  /// Get postal code from device location
  Future<String?> _getPostalCodeFromLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return null;
      return placemarks.first.postalCode;
    } catch (e) {
      return null;
    }
  }

  /// Launch phone call
  Future<void> _launchPhone(String phoneNumber) async {
    try {
      final url = Uri.parse('tel:$phoneNumber');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        SnackBarWidget.showError('Could not make phone call');
      }
    } catch (e) {
      SnackBarWidget.showError('Error opening phone');
    }
  }
}

