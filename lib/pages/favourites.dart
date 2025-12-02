import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/banner/bannermodels.dart';
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

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final BannerController bannerController = Get.find<BannerController>();
  final CartController cartController = Get.put(CartController());
  final UtilityController utilityController = Get.find<UtilityController>();

  @override
  void initState() {
    super.initState();
    // Fetch favorites when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
// debugPrint('[Favorites] Fetching customer favorites...');
      bannerController.getCustomerFavorites();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache images for better performance (only for enabled products)
    for (var favorite in bannerController.favoritesList) {
      if (favorite.product.enabled) {
        final imageUrl = favorite.product.featuredAsset?.preview;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          precacheImage(NetworkImage(imageUrl), context);
        }
      }
    }
  }

  /// Handle removing a product from favorites
  Future<void> _handleRemoveFavorite(
      String productId, String productName) async {
// debugPrint('[Favorites] Removing product: $productName (ID: $productId)');

    // Add small delay to ensure image has time to render if loading
    await Future.delayed(const Duration(milliseconds: 100));

    final success = await bannerController.toggleFavorite(productId: productId);

    if (success) {
/// debugPrint(  '[Favorites] Successfully removed. Remaining: ${bannerController.favoritesList.length}');
    } else {
      showErrorSnackbar('Failed to remove from favorites');
    }
  }

  /// Handle adding first variant to cart
  Future<void> _handleAddToCart(
      String productName, String? firstVariantId) async {
    if (firstVariantId == null) {
      showErrorSnackbar('No variants available for this product');
      return;
    }

    final variantId = int.tryParse(firstVariantId);
    if (variantId == null) {
      showErrorSnackbar('Invalid variant ID');
      return;
    }

    final success = await cartController.addToCart(
        productVariantId: variantId, quantity: 1);

    if (success) {
      if (mounted) setState(() {});
    } else {
      showErrorSnackbar('Failed to add to cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'My Favorites',
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return _buildShimmerGrid();
        }

        // Filter out disabled products
        final enabledFavorites = bannerController.favoritesList
            .where((item) => item.product.enabled == true)
            .toList();

        if (enabledFavorites.isEmpty) {
          return EmptyState(
            icon: Icons.favorite_border,
            title: 'No Favorites Yet',
            subtitle: 'Double tap on any product to add it to your favorites',
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
            await bannerController.getCustomerFavorites();
          },
          color: AppColors.refreshIndicator,
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(16),
              vertical: ResponsiveUtils.rp(20),
            ),
            itemCount: enabledFavorites.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: ResponsiveUtils.rp(14),
              mainAxisSpacing: ResponsiveUtils.rp(18),
              childAspectRatio: ResponsiveUtils.rp(0.72),
            ),
            itemBuilder: (context, index) {
              final favoriteItem = enabledFavorites[index];
              final product = favoriteItem.product;

              final name = product.name;
              final imageUrl = product.featuredAsset?.preview;
              final productId = product.id;
              final firstVariant =
                  product.variants.isNotEmpty ? product.variants.first : null;

              return _buildFavoriteTile(
                name: name,
                imageUrl: imageUrl,
                productId: productId,
                product: product,
                variant: firstVariant,
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

  Widget _buildFavoriteTile({
    required String name,
    required String? imageUrl,
    required String productId,
    required FavoriteProductModel product, // <-- correct type
    required FavoriteVariantModel? variant,
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
      onDoubleTap: () => _handleRemoveFavorite(productId, name),
      isFavorite: true,
      onFavoriteToggle: () => _handleRemoveFavorite(productId, name),
      discountPercent: null,
      variantSelector: variant == null
          ? null
          : _buildVariantDropdown(
              productId: productId,
              currentVariantId: variant.id,
            ),
      showVariantSelector: variant != null && product.variants.length > 1,
      variantLabel: variant?.name ?? 'Default',
      priceText: priceText,
      shadowPriceText: null,
      onAddToCart: () => _handleAddToCart(name, variant?.id),
    );
  }


  Widget _buildSkeletonTile() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = AppColors.border.withValues(alpha: isDark ? 0.45 : 0.2);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(12),
              vertical: ResponsiveUtils.rp(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(8)),
                Container(
                  height: 16,
                  width: ResponsiveUtils.rp(100),
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(14)),
                Container(
                  height: ResponsiveUtils.rp(40),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantDropdown({
    required String productId,
    required String currentVariantId,
  }) {
    final product = bannerController.favoritesList
        .firstWhere((item) => item.product.id == productId)
        .product;

    final variantOptions = product.variants;

    return Container(
      height: ResponsiveUtils.rp(36),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(8)),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentVariantId,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: ResponsiveUtils.rp(18),
            color: AppColors.icon,
          ),
          items: variantOptions.map((variant) {
            return DropdownMenuItem<String>(
              value: variant.id,
              child: Text(
                variant.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(12),
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newVariantId) {
            if (newVariantId == null) return;
            setState(() {
              final favIndex = bannerController.favoritesList
                  .indexWhere((item) => item.product.id == productId);
              if (favIndex != -1) {
                final productVariants =
                    bannerController.favoritesList[favIndex].product.variants;
                FavoriteVariantModel? newVariant;
                for (final v in productVariants) {
                  if (v.id == newVariantId) {
                    newVariant = v;
                    break;
                  }
                }
                if (newVariant != null) {
                  bannerController.favoritesList[favIndex].product.variants
                    ..remove(newVariant)
                    ..insert(0, newVariant);
                }
              }
            });
          },
        ),
      ),
    );
  }
}
