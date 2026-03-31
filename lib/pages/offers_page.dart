import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/coupon/coupon_controller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../utils/price_formatter.dart';
import '../utils/responsive.dart';
import '../utils/app_strings.dart';
import '../utils/navigation_helper.dart';
import '../theme/colors.dart';
import '../widgets/appbar.dart';
import '../widgets/snackbar.dart';
import '../widgets/cart/cart_coupon_section.dart';
import '../widgets/cart/cart_coupon_bottom_sheet.dart';
import '../widgets/cart/cart_loyalty_points_section.dart';
import '../widgets/cart/cart_other_instructions_section.dart';
import '../widgets/cart/cart_order_summary_section.dart';
import '../services/analytics_service.dart';
import '../services/notification_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart' as analytics;
import '../graphql/order.graphql.dart';
import '../graphql/Customer.graphql.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final BannerController bannerController = Get.find<BannerController>();
  final CouponController couponController = Get.find<CouponController>();
  final CustomerController customerController = Get.find<CustomerController>();

  // Address selection
  Query$GetActiveCustomer$activeCustomer$addresses? _selectedAddress;
  final RxBool _shouldBlinkAddress = false.obs;

  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: 'Offers');
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadCustomerAddresses(),
      couponController.getCouponCodeList(),
      bannerController.fetchLoyaltyPointsConfig(),
    ], eagerError: false);

    _loadExistingCouponCodes();
    _loadExistingInstructions();

    if (mounted) {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _loadCustomerAddresses() async {
    await customerController.getActiveCustomer(skipPostalCodeCheck: true);
    Query$GetActiveCustomer$activeCustomer$addresses? defaultShipping;

    for (final address in customerController.addresses) {
      if (address.defaultShippingAddress ?? false) {
        defaultShipping = address;
        break;
      }
    }

    if (defaultShipping == null && customerController.addresses.isNotEmpty) {
      defaultShipping = customerController.addresses.first;
    }

    if (!mounted) return;

    final previousAddress = _selectedAddress;
    setState(() {
      _selectedAddress = defaultShipping;
    });

    if (_selectedAddress != null) {
      final isNewAddress = previousAddress == null || previousAddress.id != _selectedAddress!.id;
      if (isNewAddress) {
        await _setShippingAddressFromSelected();
      }
    }
  }

  Future<void> _setShippingAddressFromSelected() async {
    if (_selectedAddress == null) return;
    try {
      await orderController.setShippingAddress(
        fullName: _selectedAddress!.fullName ?? '',
        phoneNumber: _selectedAddress!.phoneNumber ?? '',
        streetLine1: _selectedAddress!.streetLine1,
        streetLine2: _selectedAddress!.streetLine2 ?? '',
        city: _selectedAddress!.city ?? '',
        province: null,
        postalCode: _selectedAddress!.postalCode ?? '',
        countryCode: _selectedAddress!.country.code,
        skipLoading: true,
      );
    } catch (e) {
      // silently ignore
    }
  }

  void _triggerAddressBlink() {
    int blinkCount = 0;
    const totalBlinks = 3;
    const blinkDuration = Duration(milliseconds: 200);

    Timer.periodic(blinkDuration, (timer) {
      blinkCount++;
      _shouldBlinkAddress.value = blinkCount % 2 == 1;
      if (blinkCount >= totalBlinks * 2) {
        timer.cancel();
        _shouldBlinkAddress.value = false;
      }
    });
  }

  Future<void> _loadExistingCouponCodes() async {
    try {
      final cart = cartController.cart.value;
      if (cart != null && cart.couponCodes.isNotEmpty) {
        for (final couponCode in cart.couponCodes) {
          if (!couponController.appliedCouponCodes.contains(couponCode)) {
            couponController.appliedCouponCodes.add(couponCode);
          }
        }
      }
    } catch (e) {
      // silently ignore
    }
  }

  Future<void> _loadExistingInstructions() async {
    try {
      final order = orderController.currentOrder.value;
      if (order != null) {
        try {
          if (order is Query$ActiveOrder$activeOrder && order.customFields != null) {
            final customFields = order.customFields as Query$ActiveOrder$activeOrder$customFields;
            final instructions = customFields.otherInstructions;
            if (instructions != null && instructions.isNotEmpty && mounted) {
              // Instructions are managed by CartOtherInstructionsSection internally
            }
          }
        } catch (e) {
          // Fragment$Cart doesn't have customFields
        }
      }
    } catch (e) {
      // silently ignore
    }
  }

  Timer? _instructionsDebounceTimer;
  void _saveOtherInstructions(String instructions) {
    _instructionsDebounceTimer?.cancel();
    _instructionsDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await orderController.setOtherInstruction(instructions);
    });
  }

  @override
  void dispose() {
    _instructionsDebounceTimer?.cancel();
    super.dispose();
  }

  void _proceedToCheckout() {
    if (cartController.cartItemCount == 0) {
      showErrorSnackbar('Your cart is empty');
      return;
    }

    if (_selectedAddress == null) {
      _triggerAddressBlink();
      showErrorSnackbar('Please select a delivery address');
      return;
    }

    final cart = cartController.cart.value;
    if (cart != null) {
      final items = cart.lines.map((line) {
        return analytics.AnalyticsEventItem(
          itemId: line.productVariant.id,
          itemName: line.productVariant.name,
          itemCategory: 'Product',
          price: line.unitPriceWithTax / 100.0,
          quantity: line.quantity,
        );
      }).toList();

      AnalyticsService().logBeginCheckout(
        value: cart.totalWithTax / 100.0,
        currency: 'INR',
        items: items,
      );
    }

    NavigationHelper.navigateToCheckout();
  }

  // ── UI Helpers ──

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
    String? trailingText,
    VoidCallback? onTrailingTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(6),
            offset: Offset(0, ResponsiveUtils.rp(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveUtils.rp(16),
              ResponsiveUtils.rp(14),
              ResponsiveUtils.rp(16),
              ResponsiveUtils.rp(10),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(6)),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  ),
                  child: Icon(icon, color: iconColor, size: ResponsiveUtils.rp(18)),
                ),
                SizedBox(width: ResponsiveUtils.rp(10)),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (trailingText != null)
                  GestureDetector(
                    onTap: onTrailingTap,
                    child: Text(
                      trailingText,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(13),
                        fontWeight: FontWeight.w600,
                        color: AppColors.button,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.15)),
          // Content
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            child: child,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Address & Offers',
      ),
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : Obx(() {
              final cart = cartController.cart.value;
              if (cart == null || cart.lines.isEmpty) {
                return Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: ResponsiveUtils.sp(16), color: AppColors.textSecondary),
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.wait([
                          cartController.getActiveOrder(),
                          _loadCustomerAddresses(),
                          couponController.getCouponCodeList(),
                          bannerController.fetchLoyaltyPointsConfig(),
                        ]);
                      },
                      color: AppColors.refreshIndicator,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: ResponsiveUtils.rp(12)),

                            // ── 1. Delivery Address ──
                            _buildSectionCard(
                              title: 'Delivery Address',
                              icon: Icons.location_on_rounded,
                              iconColor: AppColors.button,
                              trailingText: _selectedAddress != null ? 'Change' : null,
                              onTrailingTap: () async {
                                await Get.toNamed('/addresses');
                                await _loadCustomerAddresses();
                              },
                              child: _selectedAddress == null
                                  ? _buildNoAddressContent()
                                  : _buildAddressContent(),
                            ),

                            SizedBox(height: ResponsiveUtils.rp(12)),

                            // ── 2. Coupons ──
                            Obx(() {
                              final authController = Get.find<AuthController>();
                              if (!authController.isLoggedIn) return const SizedBox.shrink();
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                                    child: CartCouponSection(
                                      bannerController: couponController,
                                      cartController: cartController,
                                      orderController: orderController,
                                      onShowCouponBottomSheet: () {
                                        CartCouponBottomSheet.show(
                                          context: context,
                                          bannerController: couponController,
                                          cartController: cartController,
                                        );
                                      },
                                    ),
                                  ),
                                  // Coupon suggestion banner
                                  _buildCouponSuggestion(),
                                  SizedBox(height: ResponsiveUtils.rp(12)),
                                ],
                              );
                            }),

                            // ── 3. Loyalty Points ──
                            Obx(() {
                              final availablePoints = customerController.loyaltyPoints;
                              final config = bannerController.loyaltyPointsConfig.value;
                              final minimumPoints = config?.pointsPerRupee ?? 0;
                              final isApplied = bannerController.loyaltyPointsApplied.value;
                              if (minimumPoints > 0 && availablePoints < minimumPoints && !isApplied) {
                                return const SizedBox.shrink();
                              }
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                                    child: CartLoyaltyPointsSection(
                                      bannerController: bannerController,
                                      customerController: customerController,
                                      onApplyLoyaltyPoints: (pointsText) async {
                                        if (pointsText.isEmpty) {
                                          showErrorSnackbar(AppStrings.pleaseEnterLoyaltyPoints);
                                          return;
                                        }
                                        final points = int.tryParse(pointsText);
                                        if (points == null || points <= 0) {
                                          showErrorSnackbar(AppStrings.pleaseEnterValidLoyaltyPoints);
                                          return;
                                        }
                                        final available = customerController.loyaltyPoints;
                                        if (points > available) {
                                          showErrorSnackbar('Insufficient loyalty points! You have $available points available.');
                                          return;
                                        }
                                        final cfg = bannerController.loyaltyPointsConfig.value;
                                        if (cfg != null && points < cfg.pointsPerRupee) {
                                          showErrorSnackbar('Minimum loyalty points required: ${cfg.pointsPerRupee} points.');
                                          return;
                                        }
                                        final success = await bannerController.applyLoyaltyPoints(points);
                                        if (success) {
                                          showSuccessSnackbar(AppStrings.loyaltyPointsAppliedSuccessfully);
                                        } else {
                                          showErrorSnackbar(AppStrings.failedToApplyLoyaltyPoints);
                                        }
                                      },
                                      onRemoveLoyaltyPoints: () async {
                                        final success = await bannerController.removeLoyaltyPoints();
                                        if (success) {
                                          showSuccessSnackbar(AppStrings.loyaltyPointsRemovedSuccessfully);
                                        } else {
                                          showErrorSnackbar(AppStrings.failedToRemoveLoyaltyPoints);
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveUtils.rp(12)),
                                ],
                              );
                            }),

                            // ── 4. Delivery Instructions ──
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                              child: CartOtherInstructionsSection(
                                bannerController: bannerController,
                                onSaveInstructions: _saveOtherInstructions,
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.rp(12)),

                            // ── 5. Order Summary ──
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                              child: CartOrderSummarySection(
                                cartController: cartController,
                                orderController: orderController,
                                bannerController: bannerController,
                                couponController: couponController,
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.rp(16)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Bottom Bar ──
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.rp(16),
                        vertical: ResponsiveUtils.rp(12),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Obx(() {
                        final cart = cartController.cart.value;
                        final order = orderController.currentOrder.value;
                        if (cart == null) return const SizedBox.shrink();

                        final finalTotal = order?.totalWithTax != null
                            ? order!.totalWithTax.toInt()
                            : cart.totalWithTax.toInt();

                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.sp(12),
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    PriceFormatter.formatPrice(finalTotal),
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.sp(18),
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _proceedToCheckout,
                                icon: Icon(Icons.payment_rounded, size: ResponsiveUtils.rp(18)),
                                label: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(15),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.button,
                                  foregroundColor: AppColors.buttonText,
                                  padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              );
            }),
    );
  }

  // ── Address Content Widgets ──

  Widget _buildNoAddressContent() {
    return Obx(() {
      final shouldBlink = _shouldBlinkAddress.value;
      return Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: ResponsiveUtils.rp(40),
            color: shouldBlink ? AppColors.error : AppColors.textSecondary,
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Text(
            'No delivery address selected',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: shouldBlink ? AppColors.error : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Get.toNamed('/addresses');
                await _loadCustomerAddresses();
              },
              icon: Icon(Icons.add_location_alt_rounded, size: ResponsiveUtils.rp(18)),
              label: Text(AppStrings.addAddress),
              style: ElevatedButton.styleFrom(
                backgroundColor: shouldBlink ? AppColors.error : AppColors.button,
                foregroundColor: AppColors.buttonText,
                padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAddressContent() {
    final addr = _selectedAddress!;
    return InkWell(
      onTap: () async {
        await Get.toNamed('/addresses');
        await _loadCustomerAddresses();
      },
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addr.fullName ?? '',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(15),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(4)),
                Text(
                  '${addr.streetLine1}${(addr.streetLine2?.isNotEmpty ?? false) ? ', ${addr.streetLine2}' : ''}, ${addr.city ?? ''}${(addr.postalCode?.isNotEmpty ?? false) ? ' - ${addr.postalCode}' : ''}',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(13),
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(4)),
                Text(
                  addr.phoneNumber ?? '',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: ResponsiveUtils.rp(22)),
        ],
      ),
    );
  }

  Widget _buildCouponSuggestion() {
    return Obx(() {
      final cart = cartController.cart.value;
      if (cart == null) return const SizedBox.shrink();

      if (couponController.appliedCouponCodes.isNotEmpty) return const SizedBox.shrink();

      final hasOutOfStockItems = cart.lines.any((line) {
        final stockLevel = line.productVariant.stockLevel.toUpperCase();
        final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
        final isProductDisabled = line.productVariant.product.enabled == false;
        return !line.isAvailable || isOutOfStock || isProductDisabled;
      });

      if (hasOutOfStockItems) return const SizedBox.shrink();

      final subTotal = cart.subTotalWithTax.toInt();
      final eligibleCoupons = couponController.getEligibleCoupons(subTotal);
      if (eligibleCoupons.isEmpty) return const SizedBox.shrink();

      final coupon = eligibleCoupons.first;
      final requiredAmount = couponController.getRequiredAmount(coupon);
      final difference = requiredAmount - subTotal;

      if (difference <= 0 || difference >= 40000) return const SizedBox.shrink();

      final differenceInRupees = difference / 100;

      return Container(
        margin: EdgeInsets.only(
          left: ResponsiveUtils.rp(16),
          right: ResponsiveUtils.rp(16),
          top: ResponsiveUtils.rp(8),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(14),
          vertical: ResponsiveUtils.rp(10),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFFF6B35), const Color(0xFFFFA500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
        ),
        child: Row(
          children: [
            Icon(Icons.local_offer_rounded, color: Colors.white, size: ResponsiveUtils.rp(18)),
            SizedBox(width: ResponsiveUtils.rp(10)),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: ResponsiveUtils.sp(13), color: Colors.white, fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(text: 'Add \u20B9${PriceFormatter.addCommas(differenceInRupees.toStringAsFixed(2))} more to unlock '),
                    TextSpan(
                      text: coupon.promotion.couponCode ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.8),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    });
  }
}
