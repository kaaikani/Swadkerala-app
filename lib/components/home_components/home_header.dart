import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/navigation_helper.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/customer/customer_controller.dart';

class HomeHeader extends StatelessWidget {
  final bool isUserAuthenticated;
  final bool isBrandChannel;
  final Widget deliveryAddressHeader;
  final BannerController bannerController;
  final String channelName;
  final CustomerController? customerController;
  /// Shown next to "Welcome to [channel]" when provided. When [onWelcomeTap] is set, the welcome area is tappable to open the postal code sheet.
  final String? postalCode;
  final VoidCallback? onWelcomeTap;

  const HomeHeader({
    Key? key,
    required this.isUserAuthenticated,
    required this.isBrandChannel,
    required this.deliveryAddressHeader,
    required this.bannerController,
    required this.channelName,
    this.customerController,
    this.postalCode,
    this.onWelcomeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        // Swad Kerala layout
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: _buildWelcomeSectionSwadKerala(),
                        ),
                        Positioned(
                          right: 0,
                          child: Obx(() {
                            final customer = customerController?.activeCustomer.value;
                            final hasError = customer != null && CustomerController.isProfileIncomplete(customer);

                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                InkWell(
                                  onTap: () => NavigationHelper.navigateToAccount(),
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
                                      color: AppColors.swadKeralaPrimary,
                                      size: ResponsiveUtils.rp(26),
                                    ),
                                  ),
                                ),
                                if (hasError)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: ResponsiveUtils.rp(12),
                                      height: ResponsiveUtils.rp(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.rp(16)),
                    _buildSearchRowSwadKerala(),
                  ],
                ),
              ),
            ),
          ),
        );
    });
  }

  Widget _buildWelcomeSectionSwadKerala() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
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
                "SwadKerala",
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.swadKeralaPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(4)),
          Text(
            "Pure Spices, True Flavours",
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

  Widget _buildSearchRowSwadKerala() {
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
        onTap: () => Get.toNamed('/search'),
        child: Container(
          height: ResponsiveUtils.rp(44),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(14)),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: AppColors.textSecondary,
                size: ResponsiveUtils.rp(20),
              ),
              SizedBox(width: ResponsiveUtils.rp(10)),
              Expanded(
                child: Text(
                  'Search spices, masala, tea...',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
