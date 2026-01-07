import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/app_strings.dart';

class CartLoyaltyPointsSection extends StatefulWidget {
  final BannerController bannerController;
  final CustomerController customerController;
  final Future<void> Function(String pointsText) onApplyLoyaltyPoints;
  final Future<void> Function() onRemoveLoyaltyPoints;

  const CartLoyaltyPointsSection({
    super.key,
    required this.bannerController,
    required this.customerController,
    required this.onApplyLoyaltyPoints,
    required this.onRemoveLoyaltyPoints,
  });

  @override
  State<CartLoyaltyPointsSection> createState() => _CartLoyaltyPointsSectionState();
}

class _CartLoyaltyPointsSectionState extends State<CartLoyaltyPointsSection> {
  final _loyaltyPointsController = TextEditingController();
  final FocusNode _loyaltyPointsFocusNode = FocusNode();
  final RxBool _applyAllPoints = false.obs;
  final RxBool _showManualInput = false.obs;

  @override
  void dispose() {
    _loyaltyPointsController.dispose();
    _loyaltyPointsFocusNode.dispose();
    super.dispose();
  }

  Future<void> _applyLoyaltyPoints() async {
    final pointsText = _loyaltyPointsController.text.trim();
    await widget.onApplyLoyaltyPoints(pointsText);
  }

  Future<void> _removeLoyaltyPoints() async {
    await widget.onRemoveLoyaltyPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final availablePoints = widget.customerController.loyaltyPoints;
      final config = widget.bannerController.loyaltyPointsConfig.value;
      final minimumPoints = config?.pointsPerRupee ?? 0;
      
      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loyalty Points',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
              decoration: BoxDecoration(
                color: availablePoints > 0
                    ? AppColors.info.withValues(alpha: 0.1)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                border: Border.all(
                  color: availablePoints > 0
                      ? AppColors.info.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.stars,
                      color: availablePoints > 0
                          ? AppColors.info
                          : AppColors.textSecondary,
                      size: ResponsiveUtils.rp(20)),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Text(
                    'Available: $availablePoints points',
                    style: TextStyle(
                      color: availablePoints > 0
                          ? AppColors.info
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.sp(14),
                    ),
                  ),
                ],
              ),
            ),
            if (minimumPoints > 0) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
              Text(
                'Minimum: $minimumPoints points',
                style: TextStyle(
                    color: AppColors.warning,
                    fontSize: ResponsiveUtils.sp(12)),
              ),
            ],
            SizedBox(height: ResponsiveUtils.rp(12)),
            Obx(() {
              final isApplied = widget.bannerController.loyaltyPointsApplied.value;
              final appliedPoints = widget.bannerController.loyaltyPointsUsed.value;
              final availablePoints = widget.customerController.loyaltyPoints;
              
              if (isApplied && _loyaltyPointsController.text != appliedPoints.toString()) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _loyaltyPointsController.text = appliedPoints.toString();
                });
              }
              
              return Column(
                children: [
                  // Toggle and Edit button row (hidden when manual input is shown)
                  if (!_showManualInput.value) ...[
                    Row(
                      children: [
                        // Toggle Switch
                        Expanded(
                          child: Row(
                            children: [
                              Switch(
                                value: isApplied,
                                onChanged: (value) {
                                  if (value) {
                                    _applyAllPoints.value = true;
                                    _loyaltyPointsController.text = availablePoints.toString();
                                    _applyLoyaltyPoints();
                                  } else {
                                    _removeLoyaltyPoints();
                                    _applyAllPoints.value = false;
                                  }
                                },
                                activeColor: AppColors.success,
                              ),
                              SizedBox(width: ResponsiveUtils.rp(8)),
                              Expanded(
                                child: Text(
                                  isApplied 
                                      ? 'Points Applied ($appliedPoints)' 
                                      : 'Apply All Points ($availablePoints)',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(14),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(8)),
                        // Edit Button
                        Container(
                          height: ResponsiveUtils.rp(40),
                          decoration: BoxDecoration(
                            color: AppColors.button.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _showManualInput.value = true;
                                if (isApplied && appliedPoints > 0) {
                                  _loyaltyPointsController.text = appliedPoints.toString();
                                }
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _loyaltyPointsFocusNode.requestFocus();
                                });
                              },
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(12)),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: ResponsiveUtils.rp(16),
                                      ),
                                      SizedBox(width: ResponsiveUtils.rp(4)),
                                      Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: ResponsiveUtils.sp(12),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Manual input field (shown when Edit is clicked, replaces toggle)
                  if (_showManualInput.value) ...[
                    SizedBox(height: ResponsiveUtils.rp(12)),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _loyaltyPointsController,
                            focusNode: _loyaltyPointsFocusNode,
                            keyboardType: TextInputType.number,
                            enabled: true,
                            style: TextStyle(
                                fontSize: ResponsiveUtils.sp(14),
                                color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: isApplied 
                                  ? 'Current: $appliedPoints points' 
                                  : 'Enter points manually',
                              hintStyle: TextStyle(
                                  color: AppColors.textTertiary,
                                fontSize: ResponsiveUtils.sp(14)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(ResponsiveUtils.rp(8)),
                                  borderSide: BorderSide(
                                      color: AppColors.border,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(ResponsiveUtils.rp(8)),
                                  borderSide: BorderSide(
                                      color: AppColors.border,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(ResponsiveUtils.rp(8)),
                                  borderSide: BorderSide(
                                      color: AppColors.button,
                                    width: 2,
                                  )),
                              filled: true,
                              fillColor: AppColors.inputFill,
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(8)),
                        // Close button
                        Container(
                          height: ResponsiveUtils.rp(50),
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _showManualInput.value = false;
                                _loyaltyPointsFocusNode.unfocus();
                              },
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(12)),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.textSecondary,
                                    size: ResponsiveUtils.rp(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(8)),
                        Container(
                          height: ResponsiveUtils.rp(50),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                    colors: [AppColors.button, AppColors.buttonLight],
                              ),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () async {
                                  await _applyLoyaltyPoints();
                                  _showManualInput.value = false;
                                },
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                                  child: Center(
                                    child: Text(
                                        AppStrings.apply,
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.sp(14),
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Show applied points info when points are applied
                  if (isApplied && !_showManualInput.value) ...[
                    SizedBox(height: ResponsiveUtils.rp(12)),
                    Container(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: ResponsiveUtils.rp(20),
                          ),
                          SizedBox(width: ResponsiveUtils.rp(8)),
                          Text(
                            'Applied: $appliedPoints points',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14),
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            }),
          ],
        ),
      );
    });
  }
}

