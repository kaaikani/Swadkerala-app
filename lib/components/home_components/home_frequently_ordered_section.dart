import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../graphql/banner.graphql.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/price_formatter.dart';
import '../../utils/navigation_helper.dart';
import '../../utils/analytics_helper.dart';
import '../../widgets/responsive_spacing.dart';
import '../../widgets/product_card.dart';
import '../../widgets/snackbar.dart';

class HomeFrequentlyOrderedSection extends StatefulWidget {
  final BannerController bannerController;
  final CartController cartController;

  const HomeFrequentlyOrderedSection({
    Key? key,
    required this.bannerController,
    required this.cartController,
  }) : super(key: key);

  @override
  State<HomeFrequentlyOrderedSection> createState() => _HomeFrequentlyOrderedSectionState();
}

class _HomeFrequentlyOrderedSectionState extends State<HomeFrequentlyOrderedSection> {
  final Map<String, String> _selectedVariantIds = {};

  String _getVariantLabel(Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants? variant) {
    if (variant == null) return 'Default';
    if (variant.options.isNotEmpty) {
      return variant.options.first.name;
    }
    return variant.name;
  }

  Widget _buildVariantDropdown({
    required String productId,
    required List<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants> variants,
    required String currentVariantId,
  }) {
    final uniqueOptions = <String>{};
    for (final variant in variants) {
      String optionValue;
      if (variant.options.isNotEmpty) {
        optionValue = variant.options.first.name;
      } else {
        optionValue = variant.name;
      }
      uniqueOptions.add(optionValue);
    }
    
    final uniqueOptionsList = uniqueOptions.toList();
    if (uniqueOptionsList.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final currentVariant = variants.firstWhere(
      (v) => v.id == currentVariantId,
      orElse: () => variants.first,
    );
    String currentOptionValue;
    if (currentVariant.options.isNotEmpty) {
      currentOptionValue = currentVariant.options.first.name;
    } else {
      currentOptionValue = currentVariant.name;
    }
    
    String groupName = 'Size';
    if (variants.isNotEmpty && variants.first.options.isNotEmpty) {
      final firstOption = variants.first.options.first;
      if (firstOption.group.name.isNotEmpty) {
        groupName = firstOption.group.name;
      }
    }
    
    return Container(
      height: ResponsiveUtils.rp(32),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(10)),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentOptionValue,
          isExpanded: true,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: ResponsiveUtils.rp(20),
            color: AppColors.icon.withValues(alpha: 0.7),
          ),
          iconSize: ResponsiveUtils.rp(20),
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(12),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          hint: Text(
            groupName,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          items: uniqueOptionsList.map((optionName) {
            final isSelected = optionName == currentOptionValue;
            return DropdownMenuItem<String>(
              value: optionName,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(4)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        optionName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(13),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: ResponsiveUtils.rp(6)),
                      Icon(
                        Icons.check_circle_rounded,
                        size: ResponsiveUtils.rp(16),
                        color: AppColors.button,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
          dropdownColor: AppColors.card,
          menuMaxHeight: ResponsiveUtils.rp(200),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
          onChanged: (String? newOptionName) {
            if (newOptionName == null) return;
            
            Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants? matchingVariant;
            for (final variant in variants) {
              String optionValue;
              if (variant.options.isNotEmpty) {
                optionValue = variant.options.first.name;
              } else {
                optionValue = variant.name;
              }
              
              if (optionValue == newOptionName) {
                matchingVariant = variant;
                break;
              }
            }
            
            if (matchingVariant != null) {
              setState(() {
                _selectedVariantIds[productId] = matchingVariant!.id;
              });
            }
          },
        ),
      ),
    );
  }

  Future<bool> _addVariantToCart(String variantId, String productName) async {
    final parsedVariantId = int.tryParse(variantId);
    if (parsedVariantId == null) {
      SnackBarWidget.showWarning(
        'Unable to add $productName right now.',
        title: 'Variant unavailable',
      );
      return false;
    }

    final success = await widget.cartController.addToCart(productVariantId: parsedVariantId);
    if (success && mounted) {
      setState(() {});
    }
    
    return success;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final allProducts = widget.bannerController.frequentlyOrderedProducts;
      final enabledProducts = allProducts
          .where((item) => item.product.enabled == true)
          .toList();
      
      if (enabledProducts.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: ResponsiveSpacing.screenPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: ResponsiveUtils.rp(4),
                        height: ResponsiveUtils.rp(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.button,
                              AppColors.button.withValues(alpha: 0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Text(
                        'Frequently Ordered',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveUtils.sp(20),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  if (enabledProducts.length > 3)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.button.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                      ),
                      child: TextButton(
                        onPressed: AnalyticsHelper.trackButton(
                          'See All - Frequently Ordered',
                          screenName: 'Home',
                          callback: () {
                            Get.toNamed('/frequently-ordered');
                          },
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(12),
                            vertical: ResponsiveUtils.rp(6),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'See All',
                              style: TextStyle(
                                color: AppColors.button,
                                fontSize: ResponsiveUtils.sp(13),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: ResponsiveUtils.rp(4)),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: ResponsiveUtils.rp(12),
                              color: AppColors.button,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.rp(260),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: ResponsiveSpacing.screenPadding,
                physics: const BouncingScrollPhysics(),
                itemCount: enabledProducts.length > 10 ? 10 : enabledProducts.length,
                separatorBuilder: (_, __) => ResponsiveSpacing.horizontal(16),
                itemBuilder: (context, index) {
                  final item = enabledProducts[index];
                  final product = item.product;
                  final variants = product.variants;
                  
                  if (variants.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  
                  final selectedVariantId = _selectedVariantIds[product.id] ?? 
                      (variants.isNotEmpty ? variants.first.id : '');
                  
                  final selectedVariant = selectedVariantId.isNotEmpty
                      ? variants.firstWhere(
                          (v) => v.id == selectedVariantId,
                          orElse: () => variants.first,
                        )
                      : variants.first;
                  
                  final priceText = PriceFormatter.formatPrice(selectedVariant.priceWithTax.round());
                  final isFavorite = widget.bannerController.isFavorite(product.id);
                  final hasMultipleVariants = variants.length > 1;
                  final variantLabel = _getVariantLabel(selectedVariant);

                  return SizedBox(
                    width: ResponsiveUtils.rp(170),
                    child: ProductCard(
                      name: product.name,
                      imageUrl: product.featuredAsset?.preview,
                      onTap: () {
                        NavigationHelper.navigateToProductDetail(
                          productId: product.id,
                          productName: product.name,
                        );
                      },
                      onDoubleTap: () => widget.bannerController.toggleFavorite(productId: product.id),
                      isFavorite: isFavorite,
                      onFavoriteToggle: () => widget.bannerController.toggleFavorite(productId: product.id),
                      discountPercent: null,
                      variantSelector: hasMultipleVariants
                          ? _buildVariantDropdown(
                              productId: product.id,
                              variants: variants,
                              currentVariantId: selectedVariantId,
                            )
                          : null,
                      showVariantSelector: hasMultipleVariants,
                      variantLabel: variantLabel,
                      priceText: priceText,
                      shadowPriceText: null,
                      onAddToCart: () async {
                        if (selectedVariantId.isEmpty) {
                          SnackBarWidget.showWarning(
                            'Unable to add this item right now.',
                            title: 'Variant unavailable',
                          );
                          return false;
                        } else {
                          return await _addVariantToCart(selectedVariantId, product.name);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

