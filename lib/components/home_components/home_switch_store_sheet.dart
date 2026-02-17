import 'package:flutter/material.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../graphql/Customer.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/channel_service.dart';
import '../../services/notification_service.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/cached_app_image.dart';

class HomeSwitchStoreSheet extends StatefulWidget {
  final String postalCode;
  final CustomerController customerController;
  final VoidCallback onChannelSwitched;

  const HomeSwitchStoreSheet({
    Key? key,
    required this.postalCode,
    required this.customerController,
    required this.onChannelSwitched,
  }) : super(key: key);

  @override
  State<HomeSwitchStoreSheet> createState() => _HomeSwitchStoreSheetState();
}

class _HomeSwitchStoreSheetState extends State<HomeSwitchStoreSheet> {
  List<Query$GetAvailableChannels$getAvailableChannels> _channels = [];
  bool _isLoading = true;
  String? _errorMessage;
  final Map<String, bool> _imageLoadFailed = {};

  @override
  void initState() {
    super.initState();
    _fetchChannels();
  }

  Future<void> _fetchChannels() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final channels = await widget.customerController.getAvailableChannels(widget.postalCode);

      final sortedChannels = _sortChannels(channels);

      for (int i = 0; i < sortedChannels.length; i++) {
        final channel = sortedChannels[i];
        // Variables computed but not used - may be needed for future logic
        // ignore: unused_local_variable
        final _isClickable = _isChannelClickable(channel);
        // ignore: unused_local_variable
        final _displayName = _getChannelDisplayName(channel);
      }

      setState(() {
        _channels = sortedChannels;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading channels: $e';
        _isLoading = false;
      });
    }
  }

  List<Query$GetAvailableChannels$getAvailableChannels> _sortChannels(
    List<Query$GetAvailableChannels$getAvailableChannels> channels,
  ) {
    final List<Query$GetAvailableChannels$getAvailableChannels> cityAvailable = [];
    final List<Query$GetAvailableChannels$getAvailableChannels> brandAvailable = [];
    final List<Query$GetAvailableChannels$getAvailableChannels> brandComingSoon = [];

    for (final channel in channels) {
      if (channel.type == Enum$ChannelType.CITY && channel.isAvailable == true) {
        cityAvailable.add(channel);
      } else if (channel.type == Enum$ChannelType.BRAND) {
        final message = channel.message?.toLowerCase().trim() ?? '';

        if ((message.isEmpty || message == 'null') && channel.isAvailable == true) {
          brandAvailable.add(channel);
        } else if (message.contains('brand will available soon') ||
                   message.contains('will available soon')) {
          brandComingSoon.add(channel);
        } else {
        }
      } else {
      }
    }


    return [
      ...cityAvailable,
      ...brandAvailable,
      ...brandComingSoon,
    ];
  }

  /// Helper function to check if channel is Swad Kerala
  bool _isSwadKeralaChannel(Query$GetAvailableChannels$getAvailableChannels channel) {
    final channelToken = channel.token?.toLowerCase() ?? '';
    final channelName = channel.name.toLowerCase();
    final channelCode = channel.code.toLowerCase();
    
    return channelToken == 'ind-swadkerala' || 
           channelName.contains('swad kerala') || 
           channelCode.contains('swad kerala') ||
           channelName.contains('swadkerala') ||
           channelCode.contains('swadkerala');
  }

  Future<void> _switchChannel(Query$GetAvailableChannels$getAvailableChannels channel) async {
    if (channel.token == null || channel.token!.isEmpty) {
      showErrorSnackbar('Channel token is missing');
      return;
    }

    // Check if channel is already selected - no action needed
    final currentChannelToken = ChannelService.getChannelToken() ?? '';
    if (channel.token == currentChannelToken) {
      return;
    }
    
    // Check if channel is Swad Kerala - should not switch
    if (_isSwadKeralaChannel(channel)) {
      return;
    }

    LoadingDialog.show(message: 'Switching store...');

    try {
      await ChannelService.setChannelInfo(
        token: channel.token!,
        code: channel.code,
        name: channel.name,
        type: channel.type.toString(),
        postalCode: widget.postalCode,
      );
      await NotificationService.instance.subscribeToChannelTopic();
      await widget.customerController.refreshAllDataAfterChannelChange();

      LoadingDialog.hide();
      Navigator.of(context).pop();
      widget.onChannelSwitched();
    } catch (e) {
      LoadingDialog.hide();
      showErrorSnackbar('Error switching store: $e');
    }
  }

  String _getChannelDisplayName(Query$GetAvailableChannels$getAvailableChannels channel) {
    // Check if channel is Swad Kerala
    if (_isSwadKeralaChannel(channel)) {
      return '${channel.name} - Opening soon';
    }
    
    if (channel.type == Enum$ChannelType.CITY && channel.isAvailable) {
      return 'Kaaikani ${channel.name}';
    } else if (channel.type == Enum$ChannelType.BRAND) {
      final message = channel.message?.toLowerCase().trim() ?? '';
      if (message.isEmpty || message == 'null') {
        return channel.name;
      } else if (message.contains('brand will available soon') ||
                 message.contains('will available soon')) {
        return '${channel.name} - Opening soon';
      }
      return channel.name;
    }
    return channel.name;
  }

  bool _isChannelClickable(Query$GetAvailableChannels$getAvailableChannels channel) {
    // Check if channel is Swad Kerala - not clickable
    if (_isSwadKeralaChannel(channel)) {
      return false;
    }
    
    if (channel.type == Enum$ChannelType.CITY) {
      final isClickable = channel.isAvailable == true;
      return isClickable;
    }

    if (channel.type == Enum$ChannelType.BRAND) {
      final message = channel.message?.toLowerCase().trim() ?? '';
      final isClickable = (message.isEmpty || message == 'null') && channel.isAvailable == true;
      return isClickable;
    }

    return false;
  }

  String? _getChannelImageUrl(Query$GetAvailableChannels$getAvailableChannels channel) {
    final channelToken = channel.token?.toLowerCase() ?? '';
    final channelName = channel.name.toLowerCase();
    final channelCode = channel.code.toLowerCase();
    
    debugPrint('🔍 [SwitchStore] Getting image URL for channel:');
    debugPrint('   - Token: "${channel.token}"');
    debugPrint('   - Token (lowercase): "$channelToken"');
    debugPrint('   - Name: "${channel.name}"');
    debugPrint('   - Name (lowercase): "$channelName"');
    debugPrint('   - Code: "${channel.code}"');
    debugPrint('   - Code (lowercase): "$channelCode"');
    debugPrint('   - Type: ${channel.type}');
    
    // Check if channel token is ind-snacks
    if (channelToken == 'ind-snacks') {
      final assetPath = 'assets/images/SouthMithai.jpeg';
      debugPrint('✅ [SwitchStore] Returning ind-snacks image asset path: $assetPath');
      return assetPath;
    }
    
    // Check if channel is Swad Kerala
    if (_isSwadKeralaChannel(channel)) {
      final assetPath = 'assets/images/SwadKerala Ban.jpeg';
      debugPrint('✅ [SwitchStore] Returning Swad Kerala image asset path (matched by token/name/code): $assetPath');
      return assetPath;
    }

    // Check if channel type is CITY
    if (channel.type == Enum$ChannelType.CITY) {
      final assetPath = 'assets/images/Kaaikani.jpeg';
      debugPrint('✅ [SwitchStore] Returning CITY image asset path: $assetPath');
      return assetPath;
    }

    // For other channels, return null to show a placeholder
    debugPrint('⚠️ [SwitchStore] No image URL found, returning null');
    return null;
  }

  Widget _buildImageGrid(ScrollController scrollController) {
    final currentChannelToken = ChannelService.getChannelToken() ?? '';

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.zero,
      itemCount: _channels.length,
      itemBuilder: (context, index) {
        final channel = _channels[index];
        final isClickable = _isChannelClickable(channel);
        final displayName = _getChannelDisplayName(channel);
        final isSelected = channel.token != null &&
                          channel.token == currentChannelToken;
        final imageUrl = _getChannelImageUrl(channel);
        
        debugPrint('📦 [SwitchStore] Building card for channel:');
        debugPrint('   - Token: "${channel.token}"');
        debugPrint('   - Display Name: "$displayName"');
        debugPrint('   - Image URL: $imageUrl');
        debugPrint('   - Is Clickable: $isClickable');
        debugPrint('   - Is Selected: $isSelected');

        return _buildChannelImageCard(
          channel: channel,
          displayName: displayName,
          imageUrl: imageUrl,
          isSelected: isSelected,
          isClickable: isClickable,
        );
      },
    );
  }

  Widget _buildChannelImageCard({
    required Query$GetAvailableChannels$getAvailableChannels channel,
    required String displayName,
    required String? imageUrl,
    required bool isSelected,
    required bool isClickable,
  }) {
    final channelKey = channel.token ?? channel.code;
    final channelToken = channel.token?.toLowerCase() ?? '';
    final channelName = channel.name.toLowerCase();
    final channelCode = channel.code.toLowerCase();
    final isSwadkerala = _isSwadKeralaChannel(channel);
    
    debugPrint('🎴 [SwitchStore] Building image card:');
    debugPrint('   - Channel Key: "$channelKey"');
    debugPrint('   - Channel Token: "$channelToken"');
    debugPrint('   - Channel Name: "$channelName"');
    debugPrint('   - Channel Code: "$channelCode"');
    debugPrint('   - Is Swadkerala: $isSwadkerala');
    debugPrint('   - Image URL passed: $imageUrl');

    // Check if channel is already selected
    final currentChannelToken = ChannelService.getChannelToken() ?? '';
    final isAlreadySelected = channel.token != null && channel.token == currentChannelToken;
    
    // Don't allow tap if already selected, not clickable, or is Swadkerala
    final shouldAllowTap = isClickable && !isAlreadySelected && !isSwadkerala;
    
    return GestureDetector(
      onTap: shouldAllowTap ? () => _switchChannel(channel) : null,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(16),
          vertical: ResponsiveUtils.rp(6),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
          border: Border.all(
            color: isSelected
                ? AppColors.button
                : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.button.withValues(alpha: 0.4),
                blurRadius: ResponsiveUtils.rp(16),
                offset: Offset(0, ResponsiveUtils.rp(6)),
                spreadRadius: 0,
              ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: ResponsiveUtils.rp(10),
              offset: Offset(0, ResponsiveUtils.rp(2)),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
          child: AspectRatio(
            aspectRatio: 3 / 1, // Fixed 3:1 aspect ratio
            child: Stack(
              children: [
              // Background Image or Placeholder
              imageUrl != null
                  ? Stack(
                      children: [
                        // Image (dimmed for Swad Kerala)
                        Opacity(
                          opacity: isSwadkerala ? 0.3 : 1.0, // Grey shade effect - 30% opacity for Swad Kerala
                          child: _buildImageWithFallback(
                            imageUrl,
                            // Use appropriate fallback based on channel
                            isSwadkerala
                                ? 'assets/images/SwadKerala Ban.jpeg'
                                : 'assets/images/Kaaikani.jpeg',
                            channelKey: channelKey,
                          ),
                        ),
                        // Grey overlay for Swad Kerala
                        if (isSwadkerala)
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.grey.withValues(alpha: 0.3), // Additional grey overlay
                          ),
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.button.withValues(alpha: 0.5),
                            AppColors.button.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              channel.type == Enum$ChannelType.CITY
                                  ? Icons.location_city_rounded
                                  : Icons.store_rounded,
                              size: ResponsiveUtils.rp(56),
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            SizedBox(height: ResponsiveUtils.rp(12)),
                            Text(
                              displayName,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

              // Gradient Overlay - Only show if selected

              // White Tick Mark - Only show when selected (above image)
              if (isSelected)
                Positioned(
                  top: ResponsiveUtils.rp(16),
                  right: ResponsiveUtils.rp(16),
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: ResponsiveUtils.rp(8),
                          offset: Offset(0, ResponsiveUtils.rp(2)),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.button,
                      size: ResponsiveUtils.rp(24),
                    ),
                  ),
                ),

              // Opening Soon Text - Show in center for Swad Kerala (Grey color)
              if (isSwadkerala && imageUrl != null)
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(24),
                      vertical: ResponsiveUtils.rp(12),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: ResponsiveUtils.rp(12),
                          offset: Offset(0, ResponsiveUtils.rp(4)),
                          spreadRadius: ResponsiveUtils.rp(2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: Colors.grey.shade200,
                          size: ResponsiveUtils.rp(24),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(10)),
                        Text(
                          'Opening Soon',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(18),
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade200,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Content Overlay - Bottom Section (Only show if NOT selected)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWithFallback(String primaryPath, String fallbackPath, {String? channelKey}) {
    debugPrint('🖼️ [SwitchStore] Loading image:');
    debugPrint('   - Primary Path: $primaryPath');
    debugPrint('   - Fallback Path: $fallbackPath');
    debugPrint('   - Channel Key: $channelKey');
    
    // Check if primary path is an asset
    final isPrimaryAsset = primaryPath.startsWith('assets/');
    final isFallbackAsset = fallbackPath.startsWith('assets/');
    
    // If primary is an asset, use Image.asset
    if (isPrimaryAsset) {
      return Image.asset(
        primaryPath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ [SwitchStore] Primary asset failed to load: $primaryPath');
          debugPrint('   - Error: $error');
          
          // Try fallback
          if (isFallbackAsset) {
            return Image.asset(
              fallbackPath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('❌ [SwitchStore] Fallback asset also failed: $fallbackPath');
                return _buildPlaceholder();
              },
            );
          } else {
            // Fallback is a network URL, use cached image
            return CachedAppImage(
              imageUrl: fallbackPath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              httpHeaders: {'Accept': 'image/*'},
              cacheWidth: 600,
              cacheHeight: 400,
              errorWidget: _buildPlaceholder(channelKey: channelKey),
            );
          }
        },
      );
    }
    
    // Otherwise, use cached network image
    return CachedAppImage(
      imageUrl: primaryPath,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      httpHeaders: {'Accept': 'image/*'},
      cacheWidth: 600,
      cacheHeight: 400,
      placeholder: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.border.withValues(alpha: 0.1),
        ),
        child: Center(
          child: SizedBox(
            width: ResponsiveUtils.rp(24),
            height: ResponsiveUtils.rp(24),
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
      errorWidget: _buildPlaceholder(channelKey: channelKey),
    );
  }

  Widget _buildPlaceholder({String? channelKey}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.button.withValues(alpha: 0.4),
            AppColors.button.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.store_rounded,
          color: Colors.white.withValues(alpha: 0.8),
          size: ResponsiveUtils.rp(48),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ResponsiveUtils.rp(24)),
            ),
          ),
          child: Column(
            children: [
              // Handle Bar
              Container(
                margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
                width: ResponsiveUtils.rp(48),
                height: ResponsiveUtils.rp(5),
                decoration: BoxDecoration(
                  color: AppColors.border.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(3)),
                ),
              ),

              // Header Section with Gradient Background
              Container(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveUtils.rp(20),
                  ResponsiveUtils.rp(20),
                  ResponsiveUtils.rp(20),
                  ResponsiveUtils.rp(16),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.button.withValues(alpha: 0.08),
                      AppColors.button.withValues(alpha: 0.03),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                      decoration: BoxDecoration(
                        color: AppColors.button.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                      ),
                      child: Icon(
                        Icons.storefront_rounded,
                        color: AppColors.button,
                        size: ResponsiveUtils.rp(24),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(14)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Switch Store',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(22),
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.rp(4)),
                          Text(
                            'Select your preferred store',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(13),
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: ResponsiveUtils.rp(8),
                            offset: Offset(0, ResponsiveUtils.rp(2)),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                        color: AppColors.textPrimary,
                        iconSize: ResponsiveUtils.rp(20),
                        padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Section
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.button,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: ResponsiveUtils.rp(16)),
                            Text(
                              'Loading stores...',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(14),
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.error_outline_rounded,
                                      size: ResponsiveUtils.rp(48),
                                      color: AppColors.error,
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveUtils.rp(20)),
                                  Text(
                                    'Oops! Something went wrong',
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.sp(18),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveUtils.rp(8)),
                                  Text(
                                    _errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.sp(14),
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveUtils.rp(24)),
                                  ElevatedButton.icon(
                                    onPressed: _fetchChannels,
                                    icon: Icon(Icons.refresh_rounded),
                                    label: Text('Try Again'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.button,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveUtils.rp(24),
                                        vertical: ResponsiveUtils.rp(12),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _channels.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.store_outlined,
                                        size: ResponsiveUtils.rp(64),
                                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                                      ),
                                      SizedBox(height: ResponsiveUtils.rp(16)),
                                      Text(
                                        'No stores available',
                                        style: TextStyle(
                                          fontSize: ResponsiveUtils.sp(18),
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: ResponsiveUtils.rp(8)),
                                      Text(
                                        'No stores are available for this postal code',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: ResponsiveUtils.sp(14),
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _buildImageGrid(scrollController),
              ),
            ],
          ),
        );
      },
    );
  }
}

