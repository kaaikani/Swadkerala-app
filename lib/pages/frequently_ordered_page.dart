import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/banner/bannercontroller.dart';
import '../graphql/banner.graphql.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../widgets/appbar.dart';
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
  
  // Track selected variant for each product
  final Map<String, String> _selectedVariantIds = {};

  @override
  void initState() {
    super.initState();
    // Fetch frequently ordered products when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('[FrequentlyOrdered] Fetching frequently ordered products...');
      bannerController.getFrequentlyOrderedProducts();
    });
  }

  /// Handle adding variant to cart
  Future<void> _handleAddToCart(
      String productName, String? variantId) async {
    if (variantId == null || variantId.isEmpty) {
      showErrorSnackbar('No variants available for this product');
      return;
    }

    final parsedVariantId = int.tryParse(variantId);
    if (parsedVariantId == null) {
      showErrorSnackbar('Invalid variant ID');
      return;
    }

    final success = await cartController.addToCart(
        productVariantId: parsedVariantId, quantity: 1);

    if (success) {
      showSuccessSnackbar('$productName added to cart');
      if (mounted) setState(() {});
    } else {
      showErrorSnackbar('Failed to add to cart');
    }
  }

  /// Build variant dropdown for frequently ordered products
  Widget _buildVariantDropdown({
    required String productId,
    required List<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants> variants,
    required String currentVariantId,
  }) {
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
          value: currentVariantId.isNotEmpty ? currentVariantId : null,
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
          items: variants.map((variant) {
            final isSelected = variant.id == currentVariantId;
            final displayName = _getVariantLabelFromName(variant.name);
            return DropdownMenuItem<String>(
              value: variant.id,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.rp(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayName,
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
          onChanged: (String? newVariantId) {
            if (newVariantId == null) return;
            setState(() {
              _selectedVariantIds[productId] = newVariantId;
            });
          },
        ),
      ),
    );
  }

  /// Extract variant label from variant name (remove text before colon if present)
  String _getVariantLabelFromName(String variantName) {
    // If variant name contains ":", return only the part after colon
    if (variantName.contains(':')) {
      return variantName.split(':').last.trim();
    }
    return variantName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Frequently Ordered',
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return _buildShimmerGrid();
        }

        // Filter out disabled products
        final enabledProducts = bannerController.frequentlyOrderedProducts
            .where((item) => item.product.enabled == true)
            .toList();

        if (enabledProducts.isEmpty) {
          return EmptyState(
            icon: Icons.shopping_bag_outlined,
            title: 'No Frequently Ordered Items',
            subtitle: 'Your frequently ordered products will appear here',
            action: AppButton(
              text: 'Browse Products',
              onPressed: () async {
                Get.back();
              },
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
              
              // Get selected variant or default to first variant
              final selectedVariantId = _selectedVariantIds[productId] ?? 
                  (product.variants.isNotEmpty ? product.variants.first.id : '');
              
              final selectedVariant = selectedVariantId.isNotEmpty
                  ? product.variants.firstWhere(
                      (v) => v.id == selectedVariantId,
                      orElse: () => product.variants.first,
                    )
                  : (product.variants.isNotEmpty ? product.variants.first : null);
              
              final hasMultipleVariants = product.variants.length > 1;
              final isFavorite = bannerController.isFavorite(productId);

              return _buildProductTile(
                name: name,
                imageUrl: imageUrl,
                productId: productId,
                product: product,
                variant: selectedVariant,
                hasMultipleVariants: hasMultipleVariants,
                selectedVariantId: selectedVariantId,
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
          return _buildSkeletonTile();
        },
      ),
    );
  }

  Widget _buildProductTile({
    required String name,
    required String? imageUrl,
    required String productId,
    required Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product product,
    required Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants? variant,
    required bool hasMultipleVariants,
    required String selectedVariantId,
    required bool isFavorite,
  }) {
    final priceText = variant != null
        ? PriceFormatter.formatPrice(variant.priceWithTax.round())
        : 'Rs --';

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
      discountPercent: null,
      variantSelector: hasMultipleVariants
          ? _buildVariantDropdown(
              productId: productId,
              variants: product.variants,
              currentVariantId: selectedVariantId,
            )
          : null,
      showVariantSelector: hasMultipleVariants,
      variantLabel: variant != null
          ? _getVariantLabelFromName(variant.name)
          : 'Default',
      priceText: priceText,
      shadowPriceText: null,
      onAddToCart: () => _handleAddToCart(name, selectedVariantId),
    );
  }

  Widget _buildSkeletonTile() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = AppColors.border.withValues(alpha: isDark ? 0.45 : 0.2);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
                  top: Radius.circular(ResponsiveUtils.rp(10)),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ResponsiveUtils.rp(14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  Container(
                    height: ResponsiveUtils.rp(12),
                    width: ResponsiveUtils.rp(80),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: ResponsiveUtils.rp(36),
                    width: ResponsiveUtils.rp(80),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

