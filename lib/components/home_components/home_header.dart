import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/app_strings.dart';
import '../../components/searchbarcomponent.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/customer/customer_controller.dart';

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
                
                // Search Bar Row with Loyalty Points
                _buildSearchRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    // Check if channel is South Mithai
    final isSouthMithai = channelName.toLowerCase().contains('south mithai') || 
                          channelName.toLowerCase() == 'south mithai';
    
    if (isSouthMithai) {
      // Single row layout for South Mithai
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome to South Mithai in single row
          Row(
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
                channelName,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(4)),
          // Tagline
          Text(
            "Authentic Sweets & Snacks",
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }
    
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Loyalty Points Badge (if authenticated)
        if (isUserAuthenticated && customerController != null)
          Obx(() {
            final loyaltyPoints = customerController!.loyaltyPoints;
            if (loyaltyPoints <= 0) return SizedBox.shrink();
            
            return GestureDetector(
              onTap: () => Get.toNamed('/account'),
              child: Container(
                margin: EdgeInsets.only(right: ResponsiveUtils.rp(8)),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(10),
                  vertical: ResponsiveUtils.rp(6),
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
                      size: ResponsiveUtils.rp(16),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(4)),
                    Text(
                      '$loyaltyPoints',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(13),
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
              Icons.person_outline_rounded,
              color: AppColors.button,
              size: ResponsiveUtils.rp(22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchRow() {
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
}
