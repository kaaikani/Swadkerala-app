import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../graphql/Customer.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
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
      debugPrint('[SwitchStore] Calling customerController.getAvailableChannels()...');
      final channels = await widget.customerController.getAvailableChannels(widget.postalCode);
      
      debugPrint('[SwitchStore] Received ${channels.length} channels from controller');
      debugPrint('[SwitchStore] Sorting channels...');
      final sortedChannels = _sortChannels(channels);
      
      debugPrint('[SwitchStore] Sorted channels: ${sortedChannels.length} total');
      debugPrint('[SwitchStore] ──── SORTED CHANNELS LIST ────');
      for (int i = 0; i < sortedChannels.length; i++) {
        final channel = sortedChannels[i];
        final isClickable = _isChannelClickable(channel);
        final displayName = _getChannelDisplayName(channel);
        debugPrint('[SwitchStore] ${i + 1}. ${displayName} (${channel.code})');
        debugPrint('[SwitchStore]    Type: ${channel.type}, Available: ${channel.isAvailable}, Clickable: $isClickable');
        debugPrint('[SwitchStore]    Message: ${channel.message ?? "null"}');
      }
      debugPrint('[SwitchStore] ─────────────────────────────────────');
      
      setState(() {
        _channels = sortedChannels;
        _isLoading = false;
      });
      
      debugPrint('[SwitchStore] ========== FETCH COMPLETED ==========');
    } catch (e, stackTrace) {
      debugPrint('[SwitchStore] ========== ERROR FETCHING CHANNELS ==========');
      debugPrint('[SwitchStore] ❌ Exception: $e');
      debugPrint('[SwitchStore] Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'Error loading channels: $e';
        _isLoading = false;
      });
    }
  }

  List<Query$GetAvailableChannels$getAvailableChannels> _sortChannels(
    List<Query$GetAvailableChannels$getAvailableChannels> channels,
  ) {
    debugPrint('[SwitchStore] Filtering and sorting ${channels.length} channels...');
    final List<Query$GetAvailableChannels$getAvailableChannels> cityAvailable = [];
    final List<Query$GetAvailableChannels$getAvailableChannels> brandAvailable = [];
    final List<Query$GetAvailableChannels$getAvailableChannels> brandComingSoon = [];

    for (final channel in channels) {
      if (channel.type == Enum$ChannelType.CITY && channel.isAvailable == true) {
        debugPrint('[SwitchStore]   → Adding to cityAvailable: ${channel.name}');
        cityAvailable.add(channel);
      } else if (channel.type == Enum$ChannelType.BRAND) {
        final message = channel.message?.toLowerCase().trim() ?? '';
        
        if ((message.isEmpty || message == 'null') && channel.isAvailable == true) {
          debugPrint('[SwitchStore]   → Adding to brandAvailable: ${channel.name} (message: null/empty, available: true)');
          brandAvailable.add(channel);
        } else if (message.contains('brand will available soon') || 
                   message.contains('will available soon')) {
          debugPrint('[SwitchStore]   → Adding to brandComingSoon: ${channel.name} (message: $message)');
          brandComingSoon.add(channel);
        } else {
          debugPrint('[SwitchStore]   → Skipping brand: ${channel.name} (message: $message, available: ${channel.isAvailable})');
        }
      } else {
        debugPrint('[SwitchStore]   → Skipping channel: ${channel.name} (type: ${channel.type})');
      }
    }

    debugPrint('[SwitchStore] Filter results:');
    debugPrint('[SwitchStore]   - cityAvailable: ${cityAvailable.length}');
    debugPrint('[SwitchStore]   - brandAvailable: ${brandAvailable.length}');
    debugPrint('[SwitchStore]   - brandComingSoon: ${brandComingSoon.length}');

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

    LoadingDialog.show(message: 'Switching store...');
    
    try {
      final box = GetStorage();
      
      await box.write('channel_code', channel.code);
      await box.write('channel_token', channel.token!);
      await box.write('channel_name', channel.name);
      await box.write('channel_type', channel.type.toString());
      await box.write('postal_code', widget.postalCode);
      
      await GraphqlService.setToken(key: 'channel', token: channel.token!);
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
    if (channel.type == Enum$ChannelType.CITY) {
      final isClickable = channel.isAvailable == true;
      debugPrint('[SwitchStore] _isChannelClickable - CITY ${channel.name}: isAvailable=${channel.isAvailable}, clickable=$isClickable');
      return isClickable;
    }
    
    if (channel.type == Enum$ChannelType.BRAND) {
      final message = channel.message?.toLowerCase().trim() ?? '';
      final isClickable = (message.isEmpty || message == 'null') && channel.isAvailable == true;
      debugPrint('[SwitchStore] _isChannelClickable - BRAND ${channel.name}: message="$message", isAvailable=${channel.isAvailable}, clickable=$isClickable');
      return isClickable;
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ResponsiveUtils.rp(20)),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
                width: ResponsiveUtils.rp(40),
                height: ResponsiveUtils.rp(4),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                child: Row(
                  children: [
                    Icon(
                      Icons.store,
                      color: AppColors.button,
                      size: ResponsiveUtils.rp(24),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(12)),
                    Expanded(
                      child: Text(
                        'Switch Store',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(20),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.button,
                        ),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: ResponsiveUtils.rp(48),
                                  color: AppColors.error,
                                ),
                                SizedBox(height: ResponsiveUtils.rp(16)),
                                Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(16),
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: ResponsiveUtils.rp(16)),
                                ElevatedButton(
                                  onPressed: _fetchChannels,
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : _channels.isEmpty
                            ? Center(
                                child: Text(
                                  'No stores available for this postal code',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(16),
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                                itemCount: _channels.length,
                                itemBuilder: (context, index) {
                                  final channel = _channels[index];
                                  final isClickable = _isChannelClickable(channel);
                                  final displayName = _getChannelDisplayName(channel);
                                  
                                  // Check if this is the currently selected channel
                                  final box = GetStorage();
                                  final currentChannelToken = box.read('channel_token') ?? '';
                                  final isSelected = channel.token != null && 
                                                    channel.token == currentChannelToken;

                                  return Card(
                                    margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                                    elevation: isClickable ? 2 : 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                      side: BorderSide(
                                        color: isClickable 
                                            ? Colors.transparent 
                                            : AppColors.border.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: isClickable
                                          ? () => _switchChannel(channel)
                                          : null,
                                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                      child: Opacity(
                                        opacity: isClickable ? 1.0 : 0.5,
                                        child: Padding(
                                          padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                                                decoration: BoxDecoration(
                                                  color: isClickable
                                                      ? AppColors.button.withValues(alpha: 0.1)
                                                      : AppColors.border.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                                                ),
                                                child: Icon(
                                                  channel.type == Enum$ChannelType.CITY
                                                      ? Icons.location_city
                                                      : Icons.store,
                                                  color: isClickable 
                                                      ? AppColors.button 
                                                      : AppColors.textSecondary,
                                                  size: ResponsiveUtils.rp(24),
                                                ),
                                              ),
                                              SizedBox(width: ResponsiveUtils.rp(16)),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      displayName,
                                                      style: TextStyle(
                                                        fontSize: ResponsiveUtils.sp(16),
                                                        fontWeight: FontWeight.w600,
                                                        color: isClickable 
                                                            ? AppColors.textPrimary 
                                                            : AppColors.textSecondary,
                                                      ),
                                                    ),
                                                    if (channel.code.isNotEmpty) ...[
                                                      SizedBox(height: ResponsiveUtils.rp(4)),
                                                      Text(
                                                        channel.code,
                                                        style: TextStyle(
                                                          fontSize: ResponsiveUtils.sp(12),
                                                          color: AppColors.textSecondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              if (isSelected)
                                                Icon(
                                                  Icons.check_circle,
                                                  size: ResponsiveUtils.rp(24),
                                                  color: AppColors.button,
                                                )
                                              else if (isClickable)
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: ResponsiveUtils.rp(16),
                                                  color: AppColors.textSecondary,
                                                )
                                              else
                                                Icon(
                                                  Icons.block,
                                                  size: ResponsiveUtils.rp(16),
                                                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          ),
        );
      },
    );
  }
}

