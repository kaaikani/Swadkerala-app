import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../graphql/product.graphql.dart';
import '../widgets/Variant bottom sheet.dart' show VariantBottomSheet;
import '../widgets/appbar.dart';
import '../widgets/snackbar.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../utils/collection_product_card.dart';
import '../utils/price_formatter.dart';

class CollectionProductsPage extends StatefulWidget {
  final String collectionId;
  final String collectionName;

  const CollectionProductsPage({
    Key? key,
    required this.collectionId,
    required this.collectionName,
  }) : super(key: key);

  @override
  State<CollectionProductsPage> createState() => _CollectionProductsPageState();
}

class _CollectionProductsPageState extends State<CollectionProductsPage> {
  final CollectionsController controller = Get.find();
  final CartController cartController = Get.put(CartController());
  final BannerController bannerController = Get.put(BannerController());
  final UtilityController utilityController = Get.find();
  final Map<String, int> _optimisticQuantityOverrides = {};

  int _getOptimisticQuantity(String variantId, int actualQuantity) {
    final override = _optimisticQuantityOverrides[variantId];
    if (override == null) {
      return actualQuantity;
    }

    // Clear override once the actual quantity matches
    if (override == actualQuantity) {
      _optimisticQuantityOverrides.remove(variantId);
      return actualQuantity;
    }

    return override;
  }

  @override
  void initState() {
    super.initState();
    debugPrint(
        '🎯 [CollectionProductsPage] Initialized with ID: ${widget.collectionId}, Name: ${widget.collectionName}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
          '🔍 [CollectionProductsPage] Fetching products for collection ID: ${widget.collectionId}');
      controller.fetchCollectionproducts(id: widget.collectionId);
      // Fetch favorites to know which products are favorited
      bannerController.getCustomerFavorites();
      cartController.getActiveOrder();
    });
  }

  /// Handle add to cart - show selector only when explicitly allowed.
  void _handleAddToCart(
    Query$Products$collection$productVariants$items variant, {
    bool allowVariantSelector = true,
  }) {
    final product = variant.product;
    final allVariants = controller.getVariantsForProduct(product.id);

    if (!allowVariantSelector || allVariants.length <= 1) {
      _addToCart(variant);
      return;
    }

    // Multiple variants and selector allowed — show sheet for quick pick
    showVariantSheet(product.name, allVariants);
  }

  /// Get display name from variant options, fallback to variant name
  String _getVariantDisplayName(
      Query$Products$collection$productVariants$items variant) {
    final collectionsController = Get.find<CollectionsController>();
    return collectionsController.buildVariantLabel(variant);
  }

  double? _calculateDiscountPercent(
      Query$Products$collection$productVariants$items variant) {
    final shadowPriceMinor = _getShadowPriceMinor(variant);
    if (shadowPriceMinor == null) {
      return null;
    }

    final currentPriceMinor = variant.priceWithTax.round();
    if (shadowPriceMinor <= currentPriceMinor) {
      return null;
    }

    final discount =
        ((shadowPriceMinor - currentPriceMinor) / shadowPriceMinor) * 100;
    if (discount <= 0) {
      return null;
    }
    return discount;
  }

  int? _getShadowPriceMinor(
      Query$Products$collection$productVariants$items variant) {
    final rawValue = variant.customFields?.shadowPrice;
    if (rawValue == null || rawValue <= 0) {
      return null;
    }

    final currentPriceMinor = variant.priceWithTax.round();

    // If the stored value already looks like minor units (>= current price), use it directly
    if (rawValue > currentPriceMinor) {
      return rawValue;
    }

    // Some catalog entries may store shadow price in rupees; scale up to paise
    final scaledValue = rawValue * 100;
    if (scaledValue > currentPriceMinor) {
      return scaledValue;
    }

    return null;
  }

  /// Dropdown selector for product option groups (Blinkit style)
  Widget _buildVariantSelector({
    required String productId,
    required List<Query$Products$collection$productVariants$items>
        variantsForProduct,
  }) {
    final referenceVariant = variantsForProduct.first;

    if (referenceVariant.product.optionGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    final optionGroup = referenceVariant.product.optionGroups.first;
    final groupName = optionGroup.name;

    final uniqueOptions =
        controller.getUniqueOptionsForGroup(productId, groupName);
    if (uniqueOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedVariant =
        controller.getSelectedVariantForProduct(productId) ?? referenceVariant;

    String? currentOptionValue;
    for (final opt in selectedVariant.options) {
      if (opt.group.name == groupName) {
        currentOptionValue = opt.name;
        break;
      }
    }

    return Container(
      height: ResponsiveUtils.rp(36),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(8)),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentOptionValue,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: ResponsiveUtils.rp(18),
            color: AppColors.icon,
          ),
          hint: Text(
            groupName,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(13),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          items: uniqueOptions.map((optionName) {
            return DropdownMenuItem<String>(
              value: optionName,
              child: Text(
                '$optionName',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(12),
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newOptionName) {
            if (newOptionName == null) return;

            Query$Products$collection$productVariants$items? matchingVariant;
            for (final variant in variantsForProduct) {
              final hasOption = variant.options.any(
                (opt) =>
                    opt.name == newOptionName && opt.group.name == groupName,
              );
              if (hasOption) {
                matchingVariant = variant;
                break;
              }
            }

            if (matchingVariant != null) {
              controller.setSelectedVariant(productId, matchingVariant.id);
            }
          },
        ),
      ),
    );
  }

  /// Add a variant to cart
  Future<void> _addToCart(
      Query$Products$collection$productVariants$items variant) async {
    final variantId = int.tryParse(variant.id);
    if (variantId == null) {
      return;
    }

    final current = cartController.getVariantQuantity(variant.id);
    _optimisticQuantityOverrides[variant.id] = current + 1;
    setState(() {});

    final success = await cartController.addToCart(
        productVariantId: variantId, quantity: 1);

    if (success) {
      final displayName = _getVariantDisplayName(variant);
      showSuccessSnackbar('$displayName added to cart');
    }

    _optimisticQuantityOverrides.remove(variant.id);
    if (mounted) setState(() {});
  }

  /// Show bottom sheet with variant options
  void showVariantSheet(String productName,
      List<Query$Products$collection$productVariants$items> variants) {
    Get.bottomSheet(
      VariantBottomSheet(
        productName: productName,
        variants: variants,
      ),
      isScrollControlled: true,
    );
  }

  /// Handle double tap to toggle favorite
  Future<void> _handleFavoriteToggle(
      String productId, String productName) async {
    final wasFavorite = bannerController.isFavorite(productId);

    final success = await bannerController.toggleFavorite(productId: productId);

    if (success) {
      if (wasFavorite) {
        showSuccessSnackbar('$productName removed from favorites');
      } else {
        showSuccessSnackbar('$productName added to favorites');
      }
    } else {}
  }

  Future<void> _handleDecreaseVariant(
    Query$Products$collection$productVariants$items variant,
    String productName,
  ) async {
    final current = cartController.getVariantQuantity(variant.id);
    final nextQuantity = current - 1 < 0 ? 0 : current - 1;
    _optimisticQuantityOverrides[variant.id] = nextQuantity;
    setState(() {});

    final success =
        await cartController.decrementVariant(variantId: variant.id);
    if (!success) {
      // Revert optimistic change if decrement failed
      _optimisticQuantityOverrides[variant.id] = current;
    }

    _optimisticQuantityOverrides.remove(variant.id);
    if (mounted) setState(() {});
  }

  // --- Start of UI Restructure: Blinkit Style ---

  // Counter widget
  Widget _buildCounterWidget({
    required int quantity,
    required Query$Products$collection$productVariants$items variant,
    required String productName,
  }) {
    return Container(
      width: double.infinity,
      height: ResponsiveUtils.rp(36),
      decoration: BoxDecoration(
        color: AppColors.button,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Decrease button
          GestureDetector(
            onTap: () => _handleDecreaseVariant(variant, productName),
            child: Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(4)),
              child: Icon(
                Icons.remove,
                size: ResponsiveUtils.rp(20),
                color: Colors.white,
              ),
            ),
          ),
          // Quantity display
          Text(
            quantity.toString(),
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          // Increase button
          GestureDetector(
            onTap: () => _handleAddToCart(
              variant,
              allowVariantSelector: false,
            ),
            child: Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(4)),
              child: Icon(
                Icons.add,
                size: ResponsiveUtils.rp(20),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.collectionName,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.button,
              strokeWidth: 3,
            ),
          );
        }

        final collection = controller.currentCollection.value;

        // Show shimmer grid while loading or when collection is null
        if (collection == null || utilityController.isLoadingRx.value) {
          return _buildShimmerGrid();
        }

        final children = collection.children;
        final variants = controller.uniqueProductVariants;

        if (children.isEmpty && variants.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              controller.fetchCollectionproducts(id: widget.collectionId),
              bannerController.getCustomerFavorites(),
            ]);
          },
          child: GridView.builder(
            // Reduced padding for denser layout
            padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
            itemCount: variants.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: ResponsiveUtils.rp(8), // Reduced spacing
              mainAxisSpacing: ResponsiveUtils.rp(8), // Reduced spacing
              childAspectRatio:
                  0.60, // Significantly reduced aspect ratio for a shorter card
            ),
            itemBuilder: (context, index) {
              final variant = variants[index];
              final product = variant.product;

              final name = product.name;
              final imageUrl = product.featuredAsset?.preview;
              final productId = product.id;

              return Obx(() {
                final variantsForProduct =
                    controller.getVariantsForProduct(productId);
                if (variantsForProduct.isEmpty) {
                  return const SizedBox.shrink();
                }

                final selectedVariant =
                    controller.getSelectedVariantForProduct(productId) ??
                        variant;
                final actualQuantity =
                    cartController.getVariantQuantity(selectedVariant.id);
                final quantity =
                    _getOptimisticQuantity(selectedVariant.id, actualQuantity);

                final priceMinorUnits = selectedVariant.priceWithTax.round();
                final priceText = PriceFormatter.formatPrice(priceMinorUnits);

                final variantLabel =
                    controller.buildVariantLabel(selectedVariant);
                final shadowPriceMinor = _getShadowPriceMinor(selectedVariant);
                final discountPercent =
                    _calculateDiscountPercent(selectedVariant);

                final isFavorite = bannerController.isFavorite(productId);

                final showVariantSelector = product.optionGroups.isNotEmpty &&
                    variantsForProduct.length > 1;
                final shadowPriceText = (shadowPriceMinor != null &&
                        shadowPriceMinor > priceMinorUnits)
                    ? PriceFormatter.formatPrice(shadowPriceMinor)
                    : null;

                return CollectionProductCard(
                  name: name,
                  imageUrl: imageUrl,
                  onTap: () {
                    Get.toNamed('/product-detail', arguments: {
                      'productId': productId,
                      'productName': name,
                    });
                  },
                  onDoubleTap: () => _handleFavoriteToggle(productId, name),
                  isFavorite: isFavorite,
                  onFavoriteToggle: () =>
                      _handleFavoriteToggle(productId, name),
                  discountPercent: discountPercent,
                  variantSelector: showVariantSelector
                      ? _buildVariantSelector(
                          productId: productId,
                          variantsForProduct: variantsForProduct,
                        )
                      : null,
                  showVariantSelector: showVariantSelector,
                  variantLabel: variantLabel,
                  priceText: priceText,
                  shadowPriceText: shadowPriceText,
                  quantity: quantity,
                  counterBuilder: () => _buildCounterWidget(
                    quantity: quantity,
                    variant: selectedVariant,
                    productName: name,
                  ),
                  onAddToCart: () => _handleAddToCart(
                    selectedVariant,
                    allowVariantSelector: false,
                  ),
                );
              });
            },
          ),
        );
      }),
    );
  }

  // Rest of the class methods (_buildShimmerGrid, etc.) remain the same...

  Widget _buildShimmerGrid() {
    // Shimmer grid adjustment for new aspect ratio
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: const EdgeInsets.all(8), // Reduced padding
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8, // Reduced spacing
          mainAxisSpacing: 8, // Reduced spacing
          childAspectRatio: 0.60, // Adjusted aspect ratio
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10), // Reduced border radius
              border:
                  Border.all(color: AppColors.border.withValues(alpha: 0.5)),
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
                        top: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                // Content shimmer
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name shimmer (2 lines)
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 14,
                          width: ResponsiveUtils.rp(100),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 8),
                        // Price shimmer
                        Container(
                          height: 14,
                          width: ResponsiveUtils.rp(50),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Spacer(),
                        // Button shimmer
                        Container(
                          height: 36,
                          width:
                              ResponsiveUtils.rp(80), // Smaller button shimmer
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
        },
      ),
    );
  }
}
