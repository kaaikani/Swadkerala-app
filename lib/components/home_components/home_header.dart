import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/app_strings.dart';
import '../../components/searchbarcomponent.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../services/graphql_client.dart';
import '../../services/channel_service.dart';

class HomeHeader extends StatelessWidget {
  final bool isUserAuthenticated;
  final bool isBrandChannel;
  final Widget deliveryAddressHeader;
  final BannerController bannerController;
  final String channelName;
  final CustomerController? customerController;

  const HomeHeader({
    Key? key,
    required this.isUserAuthenticated,
    required this.isBrandChannel,
    required this.deliveryAddressHeader,
    required this.bannerController,
    required this.channelName,
    this.customerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final channelToken = GraphqlService.channelTokenRx.value.isNotEmpty 
          ? GraphqlService.channelTokenRx.value 
          : GraphqlService.channelToken;
      final channelTokenLower = channelToken.toLowerCase();
      final isIndSnacksChannel = channelTokenLower == 'ind-snacks';
      final isIndNonVegChannel = channelTokenLower == 'ind' || channelTokenLower == 'ind-non veg';
      
      if (isIndNonVegChannel) {
        // Special layout for Ind-Non-Veg channel with non-veg themed icons
        return SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.indNonVegBackground,
                  AppColors.indNonVegBackgroundLight,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.indNonVegRed.withValues(alpha: 0.1),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveUtils.rp(16),
                  ResponsiveUtils.rp(12),
                  ResponsiveUtils.rp(16),
                  ResponsiveUtils.rp(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Menu + Welcome Section with Non-Veg Icons + Profile
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Left side: Menu Icon
                        // Center: Welcome Section with Non-Veg Icons
                        Center(
                          child: _buildWelcomeSectionIndNonVeg(),
                        ),
                        // Right side: Profile Icon
                        Positioned(
                          right: 0,
                          child: InkWell(
                            onTap: () => Get.toNamed('/account'),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
                            child: Container(
                              padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                              decoration: BoxDecoration(
                                color: AppColors.indNonVegBackgroundLight,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.indNonVegRed.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.indNonVegRed,
                                size: ResponsiveUtils.rp(26),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ResponsiveUtils.rp(16)),
                    
                    // Search Bar
                    _buildSearchRowIndNonVeg(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      
      if (isIndSnacksChannel) {
        // Special layout for Ind-Snacks channel matching the image exactly
        return SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveUtils.rp(16),
                  ResponsiveUtils.rp(12),
                  ResponsiveUtils.rp(16),
                  ResponsiveUtils.rp(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Hamburger + Centered Title + Profile
                    // Use Stack to truly center the title
                    Stack(
                      alignment: Alignment.center,
                      children: [

                        // Center: Welcome Section (truly centered)
                        Center(
                          child: _buildWelcomeSectionIndSnacks(),
                        ),
                        // Right side: Profile Icon
                        Positioned(
                          right: 0,
                          child: InkWell(
                            onTap: () => Get.toNamed('/account'),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
                            child: Container(
                              padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.border.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.textPrimary,
                                size: ResponsiveUtils.rp(26),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ResponsiveUtils.rp(16)),
                    
                    // Search Bar with Microphone Icon
                    _buildSearchRowIndSnacks(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      
      // Default layout for other channels
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppColors.backgroundLight.withValues(alpha: 0.3),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: Offset(0, 2),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveUtils.rp(16),
              ResponsiveUtils.rp(12),
              ResponsiveUtils.rp(16),
              ResponsiveUtils.rp(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Welcome/Address + Actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome/Address Section
                    Expanded(
                      child: isUserAuthenticated && !isBrandChannel
                          ? deliveryAddressHeader
                          : _buildWelcomeSection(),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(12)),
                    // Action Buttons Row
                    _buildActionButtons(),
                  ],
                ),
                
                SizedBox(height: ResponsiveUtils.rp(16)),
                
                // Search Bar Row with Loyalty Points (hide if brand = city)
                if (!_isCityChannel())
                _buildSearchRow(),
              ],
            ),
          ),
        ),
      ),
    );
    });
  }

  Widget _buildWelcomeSectionIndSnacks() {
    // Centered layout for Ind-Snacks matching the image
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Welcome to South Mithai - centered
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to ",
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "South Mithai",
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.indSnacksBrown, // Reddish-brown color
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(4)),
          // Tagline - centered
          Text(
            "Authentic Sweets & Snacks",
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
    
  Widget _buildWelcomeSection() {
    // Default layout for other channels
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to",
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(12),
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(2)),
        Text(
          channelName.isNotEmpty ? channelName : "Kaaikani",
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(20),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    // Check if channel type is CITY
    final isCityChannel = _isCityChannel();
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search Icon (only show when brand = city)
        if (isCityChannel)
          InkWell(
            onTap: () => Get.toNamed('/search'),
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
            child: Container(
              margin: EdgeInsets.only(right: ResponsiveUtils.rp(8)),
              padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: ResponsiveUtils.rp(4),
                    offset: Offset(0, ResponsiveUtils.rp(1)),
                  ),
                ],
              ),
              child: Icon(
                Icons.search,
                color: AppColors.button,
                size: ResponsiveUtils.rp(26),
              ),
            ),
          ),
        
        // Loyalty Points Badge (if authenticated)
        if (isUserAuthenticated && customerController != null)
          Obx(() {
            final loyaltyPoints = customerController!.loyaltyPoints;
            if (loyaltyPoints <= 0) return SizedBox.shrink();
            
            return GestureDetector(
              onTap: () {
                // Navigate directly to loyalty points transaction page
                Get.toNamed('/loyalty-points-transactions');
              },
              child: Container(
                margin: EdgeInsets.only(right: ResponsiveUtils.rp(8)),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(12),
                  vertical: ResponsiveUtils.rp(8),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.button,
                      AppColors.button.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.button.withValues(alpha: 0.25),
                      blurRadius: ResponsiveUtils.rp(8),
                      offset: Offset(0, ResponsiveUtils.rp(2)),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      color: Colors.white,
                      size: ResponsiveUtils.rp(20),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(5)),
                    Text(
                      '$loyaltyPoints',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(15),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        
        // Profile Icon
        InkWell(
          onTap: () => Get.toNamed('/account'),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
          child: Container(
            padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: ResponsiveUtils.rp(4),
                  offset: Offset(0, ResponsiveUtils.rp(1)),
                ),
              ],
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: AppColors.button,
              size: ResponsiveUtils.rp(26),
            ),
          ),
        ),
      ],
    );
  }
  
  bool _isCityChannel() {
    try {
      final channelType = ChannelService.getChannelType() ?? '';
      if (channelType.isEmpty) return false;
      // Check if it's CITY type (could be "Enum$ChannelType.CITY" or just "CITY")
      return channelType.contains('CITY');
    } catch (e) {
      return false;
    }
  }

  Widget _buildSearchRowIndSnacks() {
    // Search bar with microphone icon for Ind-Snacks
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(14)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
            spreadRadius: 0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/search');
        },
        child: Container(
          height: ResponsiveUtils.rp(44),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(14)),
          child: Row(
            children: [
              // Search icon (left)
              Icon(
                Icons.search,
                color: AppColors.textSecondary,
                size: ResponsiveUtils.rp(20),
              ),
              SizedBox(width: ResponsiveUtils.rp(10)),
              // Placeholder text
              Expanded(
                child: Text(
                  'Search sweets, snacks, laddu, murukku...',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              // Microphone icon (right)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchRow() {
    // Default search bar for other channels
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(14)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SearchComponent(
        hintText: AppStrings.searchForFreshCuts,
        onSearch: (String query) {
          bannerController.searchProducts({'term': query});
        },
      ),
    );
  }

  Widget _buildWelcomeSectionIndNonVeg() {
    // Welcome section for Ind-Non-Veg channel - clean and simple
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            channelName.isNotEmpty ? channelName : "Non-Veg",
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(20),
              fontWeight: FontWeight.bold,
              color: AppColors.indNonVegRed,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.rp(2)),
          Text(
            "Fresh Meat & Seafood",
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchRowIndNonVeg() {
    // Search bar for Ind-Non-Veg channel
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(14)),
        border: Border.all(
          color: AppColors.indNonVegRed.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.indNonVegRed.withValues(alpha: 0.1),
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SearchComponent(
        hintText: 'Search meat, fish, chicken...',
        onSearch: (String query) {
          bannerController.searchProducts({'term': query});
        },
      ),
    );
  }
}
