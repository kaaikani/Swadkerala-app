import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';
import '../../graphql/banner.graphql.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/price_formatter.dart';
import '../../utils/navigation_helper.dart';
import '../../utils/analytics_helper.dart';
import '../../widgets/responsive_spacing.dart';
import '../../widgets/product_card.dart';
import '../../widgets/snackbar.dart';
import '../../services/graphql_client.dart';

class HomeFavoritesSection extends StatefulWidget {
  final BannerController bannerController;
  final CartController cartController;
  final UtilityController utilityController;

  const HomeFavoritesSection({
    Key? key,
    required this.bannerController,
    required this.cartController,
    required this.utilityController,
  }) : super(key: key);

  @override
  State<HomeFavoritesSection> createState() => _HomeFavoritesSectionState();
}

class _HomeFavoritesSectionState extends State<HomeFavoritesSection> {
  final Map<String, String> _selectedVariantIds = {};

  String _getVariantLabel(Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants? variant) {
    if (variant == null) return 'Default';
    if (variant.options.isNotEmpty) {
      return variant.options.first.name;
    }
    return variant.name;
  }

  Widget _buildVariantDropdown({
    required String productId,
    required List<Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants> variants,
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
    
    // Check if channel is Ind-Snacks
    return Obx(() {
      final channelToken = GraphqlService.channelTokenRx.value.isNotEmpty 
          ? GraphqlService.channelTokenRx.value 
          : GraphqlService.channelToken;
      final isIndSnacksChannel = channelToken == 'Ind-Snacks' || channelToken == 'ind-snacks';
    
    return Container(
      height: ResponsiveUtils.rp(32),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(10)),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
        border: Border.all(
            color: isIndSnacksChannel ? AppColors.indSnacksAccent : AppColors.border.withValues(alpha: 0.6),
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
            
            Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants? matchingVariant;
            for (final variant in variants) {
              String? optionValue;
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
    });
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

  Widget _buildShimmerRow() {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: ResponsiveSpacing.screenPadding,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, __) => ResponsiveSpacing.horizontal(16),
        itemBuilder: (context, index) {
          return Container(
            width: ResponsiveUtils.rp(170),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(6)),
                      Container(
                        height: 14,
                        width: ResponsiveUtils.rp(80),
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      Container(
                        height: ResponsiveUtils.rp(32),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final enabledFavorites = widget.bannerController.favoritesList
          .where((item) => item.product?.enabled == true)
          .where((item) => item.product != null)
          .toList();
      
      if (enabledFavorites.isEmpty) return SizedBox.shrink();

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
                      Icon(
                        Icons.favorite,
                        color: AppColors.error,
                        size: ResponsiveUtils.rp(20),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Text(
                        'Your Favorites',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveUtils.sp(18),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (enabledFavorites.length > 3)
                    Obx(() {
                      final channelToken = GraphqlService.channelTokenRx.value.isNotEmpty 
                          ? GraphqlService.channelTokenRx.value 
                          : GraphqlService.channelToken;
                      final isIndSnacksChannel = channelToken == 'Ind-Snacks' || channelToken == 'ind-snacks';
                      
                      return TextButton(
                      onPressed: AnalyticsHelper.trackButton(
                        'See All - Favorites',
                        screenName: 'Home',
                        callback: () {
                          Get.toNamed('/favourite');
                        },
                      ),
                      child: Text(
                          isIndSnacksChannel ? 'See All >' : 'See All',
                        style: TextStyle(
                          color: AppColors.button,
                          fontSize: ResponsiveUtils.sp(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      );
                    }),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.rp(260),
              child: widget.utilityController.isLoadingRx.value && enabledFavorites.isEmpty
                  ? _buildShimmerRow()
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: ResponsiveSpacing.screenPadding,
                      physics: const BouncingScrollPhysics(),
                      itemCount: enabledFavorites.length > 10 ? 10 : enabledFavorites.length,
                      separatorBuilder: (_, __) => ResponsiveSpacing.horizontal(16),
                      itemBuilder: (context, index) {
                        final favorite = enabledFavorites[index];
                        final product = favorite.product;
                        if (product == null) return SizedBox.shrink();
                        final imageUrl = product.featuredAsset?.preview;
                        
                        final selectedVariantId = _selectedVariantIds[product.id] ?? 
                            (product.variants.isNotEmpty ? product.variants.first.id : '');
                        
                        final selectedVariant = selectedVariantId.isNotEmpty
                            ? product.variants.firstWhere(
                                (v) => v.id == selectedVariantId,
                                orElse: () => product.variants.first,
                              )
                            : (product.variants.isNotEmpty ? product.variants.first : null);
                        
                        final hasMultipleVariants = product.variants.length > 1;

                        return SizedBox(
                          width: ResponsiveUtils.rp(170),
                          child: ProductCard(
                            name: product.name,
                            imageUrl: imageUrl,
                            onTap: () {
                              NavigationHelper.navigateToProductDetail(
                                productId: product.id,
                                productName: product.name,
                              );
                            },
                            onDoubleTap: () => widget.bannerController.toggleFavorite(productId: product.id),
                            isFavorite: true,
                            onFavoriteToggle: () => widget.bannerController.toggleFavorite(productId: product.id),
                            discountPercent: null,
                            variantSelector: hasMultipleVariants
                                ? _buildVariantDropdown(
                                    productId: product.id,
                                    variants: product.variants,
                                    currentVariantId: selectedVariantId,
                                  )
                                : null,
                            showVariantSelector: hasMultipleVariants,
                            variantLabel: selectedVariant != null
                                ? _getVariantLabel(selectedVariant)
                                : 'Default',
                            priceText: selectedVariant != null
                                ? PriceFormatter.formatPrice(selectedVariant.priceWithTax.round())
                                : 'Rs --',
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

