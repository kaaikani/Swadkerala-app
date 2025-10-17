import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/card.dart';
import '../widgets/empty_state.dart';
import '../widgets/snackbar.dart';

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
      debugPrint('[Favorites] Fetching customer favorites...');
      bannerController.getCustomerFavorites();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache images for better performance
    for (var favorite in bannerController.favoritesList) {
      final imageUrl = favorite.product.featuredAsset?.preview;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        precacheImage(NetworkImage(imageUrl), context);
      }
    }
  }

  /// Handle removing a product from favorites
  Future<void> _handleRemoveFavorite(String productId, String productName) async {
    debugPrint('[Favorites] Removing product: $productName (ID: $productId)');
    
    // Add small delay to ensure image has time to render if loading
    await Future.delayed(const Duration(milliseconds: 100));
    
    final success = await bannerController.toggleFavorite(productId: productId);
    
    if (success) {
      showSuccessSnackbar('$productName removed from favorites');
      debugPrint('[Favorites] Successfully removed. Remaining: ${bannerController.favoritesList.length}');
    } else {
      showErrorSnackbar('Failed to remove from favorites');
    }
  }

  /// Handle adding first variant to cart
  Future<void> _handleAddToCart(String productName, String? firstVariantId) async {
    if (firstVariantId == null) {
      showErrorSnackbar('No variants available for this product');
      return;
    }

    final variantId = int.tryParse(firstVariantId);
    if (variantId == null) {
      showErrorSnackbar('Invalid variant ID');
      return;
    }

    final success = await cartController.addToCart(productVariantId: variantId, quantity: 1);
    
    if (success) {
      showSuccessSnackbar('$productName added to cart');
    } else {
      showErrorSnackbar('Failed to add to cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'My Favorites',
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bannerController.favoritesList.isEmpty) {
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
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bannerController.favoritesList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final favoriteItem = bannerController.favoritesList[index];
              final product = favoriteItem.product;
              
              final name = product.name;
              final imageUrl = product.featuredAsset?.preview;
              final productId = product.id;
              final firstVariantId = product.variants.isNotEmpty 
                  ? product.variants.first.id 
                  : null;

              return GestureDetector(
                key: ValueKey(productId),
                onDoubleTap: () => _handleRemoveFavorite(productId, name),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Product Image
                      Expanded(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      key: ValueKey(imageUrl),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      cacheWidth: 300,
                                      cacheHeight: 300,
                                      loadingBuilder: (context, childWidget, progress) {
                                        if (progress == null) return childWidget;
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        debugPrint('Image error: $error for URL: $imageUrl');
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.broken_image,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image, size: 40),
                                    ),
                            ),
                            // Remove from favorites button
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => _handleRemoveFavorite(productId, name),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Product Info
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppButton(
                              text: 'Add to Cart',
                              icon: Icons.add_shopping_cart,
                              onPressed: () => _handleAddToCart(name, firstVariantId),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
