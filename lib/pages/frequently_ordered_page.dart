import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/banner/bannercontroller.dart';
import '../graphql/banner.graphql.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../widgets/appbar.dart';
import '../widgets/cart_button_with_badge.dart';
import '../widgets/button.dart';
import '../widgets/empty_state.dart';
import '../widgets/snackbar.dart';
import '../theme/colors.dart';
import '../utils/price_formatter.dart';
import '../utils/responsive.dart';
import '../widgets/product_card.dart';
import '../utils/navigation_helper.dart';

class FrequentlyOrderedPage extends StatefulWidget {
  const FrequentlyOrderedPage({super.key});

  @override
  State<FrequentlyOrderedPage> createState() => _FrequentlyOrderedPageState();
}

class _FrequentlyOrderedPageState extends State<FrequentlyOrderedPage> {
  final BannerController bannerController = Get.find<BannerController>();
  final CartController cartController = Get.put(CartController());
  final UtilityController utilityController = Get.find<UtilityController>();
  

  @override
  void initState() {
    super.initState();
    // Fetch frequently ordered products when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bannerController.getFrequentlyOrderedProducts();
    });
  }

  /// Handle adding variant to cart
  Future<bool> _handleAddToCart(
      String productName, String? variantId) async {
    if (variantId == null || variantId.isEmpty) {
      showErrorSnackbar('No variants available for this product');
      return false;
    }

    final parsedVariantId = int.tryParse(variantId);
    if (parsedVariantId == null) {
      showErrorSnackbar('Invalid variant ID');
      return false;
    }

    final success = await cartController.addToCart(
        productVariantId: parsedVariantId, quantity: 1);

    if (success) {
      if (mounted) setState(() {});
    } else {
      showErrorSnackbar('Failed to add to cart');
    }
    
    return success;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Frequently Ordered',
        actions: [
          CartButtonWithBadge(
            cartController: cartController,
            useIconButton: true,
          ),
        ],
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return Container(
            color: AppColors.background,
            child: _buildShimmerGrid(),
          );
        }

        // Filter out disabled products
        final enabledProducts = bannerController.frequentlyOrderedProducts
            .where((item) => item.product.enabled == true)
            .toList();

        if (enabledProducts.isEmpty) {
          return Container(
            color: AppColors.background,
            child: EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'No Frequently Ordered Items',
              subtitle: 'Your frequently ordered products will appear here',
              action: AppButton(
                text: 'Browse Products',
                backgroundColor: AppColors.button,
                textColor: Colors.white,
                onPressed: () async {
                  Get.back();
                },
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await bannerController.getFrequentlyOrderedProducts();
          },
          color: AppColors.refreshIndicator,
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(16),
              vertical: ResponsiveUtils.rp(20),
            ),
            itemCount: enabledProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: ResponsiveUtils.rp(14),
              mainAxisSpacing: ResponsiveUtils.rp(18),
              childAspectRatio: ResponsiveUtils.rp(0.72),
            ),
            itemBuilder: (context, index) {
              final item = enabledProducts[index];
              final product = item.product;

              final name = product.name;
              final imageUrl = product.featuredAsset?.preview;
              final productId = product.id;

              // Get all variants (enabled check not available in this GraphQL query)
              final variantsForProduct = product.variants;

              if (variantsForProduct.isEmpty) {
                return const SizedBox.shrink();
              }

              // Get first variant as default (can be improved with variant selection state)
              final variant = variantsForProduct.first;

              final isFavorite = bannerController.isFavorite(productId);

              return _buildProductTile(
                name: name,
                imageUrl: imageUrl,
                productId: productId,
                product: product,
                variant: variant,
                variantsForProduct: variantsForProduct,
                isFavorite: isFavorite,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildShimmerGrid() {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(16),
          vertical: ResponsiveUtils.rp(20),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: ResponsiveUtils.rp(14),
          mainAxisSpacing: ResponsiveUtils.rp(18),
          childAspectRatio: ResponsiveUtils.rp(0.72),
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image shimmer (proportional)
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(ResponsiveUtils.rp(10)),
                      ),
                    ),
                  ),
                ),
                // Content shimmer
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(8),
                      vertical: ResponsiveUtils.rp(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product name shimmer (2 lines)
                        Container(
                          height: ResponsiveUtils.rp(14),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(3)),
                        Container(
                          height: ResponsiveUtils.rp(12),
                          width: ResponsiveUtils.rp(80),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(4)),
                        // Price shimmer
                        Container(
                          height: ResponsiveUtils.rp(14),
                          width: ResponsiveUtils.rp(50),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Get variant label from selected variant (option name)
  String _getVariantLabelFromSelectedVariant(
      Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants selectedVariant,
      String? groupName) {
    // If there's an option group, get the option name from that group
    if (groupName != null && selectedVariant.options.isNotEmpty) {
      for (final opt in selectedVariant.options) {
        if (opt.group.name == groupName) {
          return opt.name; // Return the option name
        }
      }
    }
    
    // If variant has options, return the first option name
    if (selectedVariant.options.isNotEmpty) {
      return selectedVariant.options.first.name;
    }
    
    // Fallback to variant name if no options
    return selectedVariant.name;
  }

  Widget _buildProductTile({
    required String name,
    required String? imageUrl,
    required String productId,
    required Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product product,
    required Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants variant,
    required List<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants> variantsForProduct,
    required bool isFavorite,
  }) {
    final priceMinorUnits = variant.priceWithTax.round();
    final priceText = PriceFormatter.formatPrice(priceMinorUnits);

    // Get group name from first variant's options (if available)
    String? groupName;
    if (variant.options.isNotEmpty) {
      groupName = variant.options.first.group.name;
    }

    // Get variant label
    final variantLabel = _getVariantLabelFromSelectedVariant(variant, groupName);

    // No shadow price or discount available in this GraphQL query
    final discountPercent = null;
    final shadowPriceText = null;

    // Check if product has multiple variants
    final hasMultipleVariants = variantsForProduct.length > 1;
    final showVariantSelector = groupName != null && hasMultipleVariants;

    // Stock level not available in this GraphQL query - default to false
    final isOutOfStock = false;

    // Build variant selector if needed
    Widget? variantSelectorWidget;
    if (showVariantSelector) {
      // groupName is guaranteed to be non-null when showVariantSelector is true
      // ignore: unnecessary_null_checks
      variantSelectorWidget = _buildVariantSelector(
        productId: productId,
        variantsForProduct: variantsForProduct,
        groupName: groupName,
      );
    }

    return ProductCard(
      name: name,
      imageUrl: imageUrl,
      onTap: () {
        NavigationHelper.navigateToProductDetail(
          productId: productId,
          productName: name,
        );
      },
      onDoubleTap: () => bannerController.toggleFavorite(productId: productId),
      isFavorite: isFavorite,
      onFavoriteToggle: () => bannerController.toggleFavorite(productId: productId),
      discountPercent: discountPercent,
      variantSelector: variantSelectorWidget,
      showVariantSelector: showVariantSelector,
      variantLabel: variantLabel,
      priceText: priceText,
      shadowPriceText: shadowPriceText,
      isOutOfStock: isOutOfStock,
      groupName: groupName,
      hasMultipleVariants: hasMultipleVariants,
      onAddToCart: () => _handleAddToCart(name, variant.id),
    );
  }

  /// Dropdown selector for product option groups (similar to collection products page)
  Widget _buildVariantSelector({
    required String productId,
    required List<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants> variantsForProduct,
    required String groupName,
  }) {
    if (variantsForProduct.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedVariant = variantsForProduct.first;

    // Get unique options from all variants
    final uniqueOptions = <String>{};
    for (final variant in variantsForProduct) {
      for (final opt in variant.options) {
        if (opt.group.name == groupName) {
          uniqueOptions.add(opt.name);
        }
      }
    }

    if (uniqueOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get first variant as default
    String? currentOptionValue;
    for (final opt in selectedVariant.options) {
      if (opt.group.name == groupName) {
        currentOptionValue = opt.name;
        break;
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
          items: uniqueOptions.map((optionName) {
            final isSelected = optionName == currentOptionValue;
            return DropdownMenuItem<String>(
              value: optionName,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.rp(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        optionName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(13),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
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
            // Note: Variant selection state management can be added here if needed
            // For now, this is a UI-only selector
            setState(() {});
          },
        ),
      ),
    );
  }

}

