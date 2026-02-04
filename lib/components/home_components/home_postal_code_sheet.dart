import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../services/postal_code_service.dart';
import '../../services/channel_service.dart';
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
  List<PostalCodeData> searchResults = [];
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
                        searchResults = [];
                        isServiceUnavailable = false;
                      });
                      
                      final postalCodeService = PostalCodeService();
                      final locationData = await postalCodeService.getPostalCodeFromLocation();
                      
                      if (locationData != null) {
                        // Check service availability without switching channel
                        final serviceAvailable = await widget.customerController.hasValidPostalCode(
                          locationData.pincode,
                        );
                        
                        if (!mounted) return;
                        
                        setState(() {
                          isGettingLocation = false;
                          pincodeController.text = locationData.pincode;
                        });
                        
                        // Get Indian postal code data regardless of service availability
                        final postalCodeResults = await widget.customerController.searchPostalCodes(locationData.pincode);
                        
                        if (!mounted) return;
                        
                        if (serviceAvailable) {
                          // Service available - show Indian postal code data for user to select
                          setState(() {
                            searchResults = postalCodeResults;
                            isServiceUnavailable = false;
                          });
                        } else {
                          // Service not available
                          if (postalCodeResults.isNotEmpty) {
                            // Indian postal code data exists - show service unavailable message
                            setState(() {
                              searchResults = postalCodeResults;
                              isServiceUnavailable = true;
                            });
                          } else {
                            // No Indian postal code data - show enter valid postal code
                            setState(() {
                              searchResults = [];
                              isServiceUnavailable = false;
                            });
                            SnackBarWidget.showError('Service not available for this location. Please enter postal code manually.');
                          }
                        }
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
                      // Close keyboard when 6 digits are entered
                      FocusScope.of(context).unfocus();
                      
                      // First check service availability when 6 digits are entered (without switching channel)
                      setState(() {
                        isSearching = true;
                        searchResults = [];
                        isServiceUnavailable = false;
                      });
                      
                      // Check service availability without switching channel
                      final serviceAvailable = await widget.customerController.hasValidPostalCode(value);
                      
                      if (!mounted) return;
                      
                      // Get Indian postal code data regardless of service availability
                      final postalCodeResults = await widget.customerController.searchPostalCodes(value);
                      
                      if (!mounted) return;
                      
                      if (serviceAvailable) {
                        // Service available - show Indian postal code data for user to select
                        setState(() {
                          searchResults = postalCodeResults;
                          isSearching = false;
                          isServiceUnavailable = false;
                        });
                      } else {
                        // Service not available
                        if (postalCodeResults.isNotEmpty) {
                          // Indian postal code data exists - show service unavailable message
                          setState(() {
                            searchResults = postalCodeResults; // Store for reference but don't show
                            isSearching = false;
                            isServiceUnavailable = true;
                          });
                        } else {
                          // No Indian postal code data - show enter valid postal code
                          setState(() {
                            searchResults = [];
                            isSearching = false;
                            isServiceUnavailable = false;
                          });
                        }
                      }
                    } else {
                      setState(() {
                        searchResults = [];
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
                    : searchResults.isEmpty
                        ? Center(
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
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final result = searchResults[index];
                              return ListTile(
                                leading: Icon(Icons.location_city, color: AppColors.button),
                                title: Text(
                                  '${result.city}, ${result.district}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  '${result.state} - ${result.pincode}',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                                onTap: () async {
                                  // When postal code data is tapped: get channel by postal code, update location with channel name
                                  debugPrint('[UpdateLocation] Postal code data tapped: pincode=${result.pincode}, city=${result.city}, district=${result.district}, state=${result.state}');
                                  if (!mounted) return;
                                  final navigator = Navigator.of(context, rootNavigator: false);
                                  setState(() => isSearching = true);
                                  debugPrint('[UpdateLocation] Calling switchChannelByPostalCode(postalCode=${result.pincode}, city=${result.city})');

                                  final success = await widget.customerController.switchChannelByPostalCode(
                                    result.pincode,
                                    city: result.city,
                                    showLoading: false,
                                  );

                                  debugPrint('[UpdateLocation] switchChannelByPostalCode returned success=$success');
                                  if (!mounted) return;
                                  setState(() => isSearching = false);

                                  if (success) {
                                    final channelName = ChannelService.getChannelName() ?? result.city;
                                    debugPrint('[UpdateLocation] Success: channelName=$channelName, popping sheet and calling onPostalCodeSelected');
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (mounted) {
                                        try {
                                          if (navigator.canPop()) navigator.pop();
                                          widget.onPostalCodeSelected();
                                          debugPrint('[UpdateLocation] Sheet closed, callback invoked, snackbar shown');
                                        } catch (e) {
                                          debugPrint('[UpdateLocation] PostFrameCallback error: $e');
                                        }
                                      }
                                    });
                                  } else {
                                    debugPrint('[UpdateLocation] Failed: setting isServiceUnavailable=true');
                                    setState(() => isServiceUnavailable = true);
                                  }
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
      ),
    );
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

