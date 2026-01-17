import 'package:flutter/material.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../graphql/Customer.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/channel_service.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/snackbar.dart';

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
        final isClickable = _isChannelClickable(channel);
        final displayName = _getChannelDisplayName(channel);
      }

      setState(() {
        _channels = sortedChannels;
        _isLoading = false;
      });

    } catch (e, stackTrace) {
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
    
    // Check if channel token is ind-Swadkerala - should not switch
    final channelToken = channel.token!.toLowerCase();
    if (channelToken == 'ind-swadkerala') {
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
      await widget.customerController.refreshAllDataAfterChannelChange();

      LoadingDialog.hide();
      Navigator.of(context).pop();
      widget.onChannelSwitched();
      showSuccessSnackbar('Store switched successfully');
    } catch (e) {
      LoadingDialog.hide();
      showErrorSnackbar('Error switching store: $e');
    }
  }

  String _getChannelDisplayName(Query$GetAvailableChannels$getAvailableChannels channel) {
    // Check if channel token is ind-Swadkerala (case-insensitive)
    final channelToken = channel.token?.toLowerCase() ?? '';
    if (channelToken == 'ind-swadkerala') {
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
    // Check if channel token is ind-Swadkerala (case-insensitive) - not clickable
    final channelToken = channel.token?.toLowerCase() ?? '';
    if (channelToken == 'ind-swadkerala') {
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
    // Check if channel token is ind-snacks
    final channelToken = channel.token?.toLowerCase() ?? '';
    if (channelToken == 'ind-snacks') {
      return 'https://s3.ap-south-1.amazonaws.com/cdn.kaaikani.co.in/App-switch-store-image/bcc15eac-3b2b-4faf-9862-769f43fd3b30.jpg';
    }

    // Check if channel type is CITY
    if (channel.type == Enum$ChannelType.CITY) {
      return 'https://s3.ap-south-1.amazonaws.com/cdn.kaaikani.co.in/App-switch-store-image/Kaaikani+(2).jpg';
    }

    // For other channels, return null to show a placeholder
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
    final isSwadkerala = channelToken == 'ind-swadkerala';
    // Show "Coming Soon" if image fails, no image URL, or is ind-Swadkerala
    final showComingSoon = isSwadkerala || imageUrl == null || _imageLoadFailed[channelKey] == true;

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
              imageUrl != null && !showComingSoon
                  ? _buildNetworkImageWithFallback(
                      imageUrl,
                      'https://s3.ap-south-1.amazonaws.com/cdn.kaaikani.co.in/App-switch-store-image/bcc15eac-3b2b-4faf-9862-769f43fd3b30.jpg',
                      channelKey: channelKey,
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

              // Content Overlay - Bottom Section (Only show if NOT selected)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImageWithFallback(String primaryUrl, String fallbackUrl, {String? channelKey}) {
    return Image.network(
      primaryUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain, // Show image at exact size without zooming
      headers: {
        'Accept': 'image/*',
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
          return Container(
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
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Try fallback URL
        return Image.network(
          fallbackUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain, // Show image at exact size without zooming
          headers: {
            'Accept': 'image/*',
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
          return Container(
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
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Mark image as failed for this channel
            if (channelKey != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _imageLoadFailed[channelKey] = true;
                  });
                }
              });
            }
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
          },
        );
      },
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

