import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/banner/bannercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../graphql/collections.graphql.dart';
import '../widgets/Variant bottom sheet.dart' show VariantBottomSheet;
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/card.dart';
import '../widgets/snackbar.dart';

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

  @override
  void initState() {
    super.initState();
    debugPrint('🎯 [CollectionProductsPage] Initialized with ID: ${widget.collectionId}, Name: ${widget.collectionName}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🔍 [CollectionProductsPage] Fetching products for collection ID: ${widget.collectionId}');
      controller.fetchCollectionproducts(id: widget.collectionId);
      // Fetch favorites to know which products are favorited
      bannerController.getCustomerFavorites();
    });
  }

  /// Handle add to cart - checks if product has single or multiple variants
  void _handleAddToCart(Query$Products$collection$productVariants$items variant) {
    final product = variant.product;
    final allVariants = controller.getVariantsForProduct(product.id);

    if (allVariants.length == 1) {
      // Single variant - add directly to cart
      _addToCart(variant);
    } else {
      // Multiple variants - show bottom sheet
      showVariantSheet(product.name, allVariants);
    }
  }

  /// Add a variant to cart
  Future<void> _addToCart(Query$Products$collection$productVariants$items variant) async {
    final variantId = int.tryParse(variant.id);
    if (variantId == null) {
      showErrorSnackbar('Invalid variant ID');
      return;
    }

    final success = await cartController.addToCart(productVariantId: variantId, quantity: 1);
    
    if (success) {
      showSuccessSnackbar('${variant.name} added to cart');
    } else {
      showErrorSnackbar('Failed to add to cart');
    }
  }

  /// Show bottom sheet with variant options
  void showVariantSheet(String productName, List<Query$Products$collection$productVariants$items> variants) {
    Get.bottomSheet(
      VariantBottomSheet(
        productName: productName,
        variants: variants,
      ),
      isScrollControlled: true,
    );
  }

  /// Handle double tap to toggle favorite
  Future<void> _handleFavoriteToggle(String productId, String productName) async {
    final wasFavorite = bannerController.isFavorite(productId);
    
    final success = await bannerController.toggleFavorite(productId: productId);
    
    if (success) {
      if (wasFavorite) {
        showSuccessSnackbar('$productName removed from favorites');
      } else {
        showSuccessSnackbar('$productName added to favorites');
      }
    } else {
      showErrorSnackbar('Failed to update favorites');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.collectionName,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return const Center(child: CircularProgressIndicator());
        }


        final collection = controller.currentCollection.value;
        if (collection == null) {
          return const Center(child: Text('No collection data'));
        }

        final children = collection.children;
        final variants = controller.uniqueProductVariants;

        if (children.isEmpty && variants.isEmpty) {
          return const Center(child: Text('No products found'));
        }



        return GridView.builder(
          itemCount: variants.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final variant = variants[index];
            final product = variant.product;

            final name = product.name;
            final imageUrl = product.featuredAsset?.preview;
            final productId = product.id;

            return Obx(() {
              final isFavorite = bannerController.isFavorite(productId);
              
              return GestureDetector(
                onDoubleTap: () => _handleFavoriteToggle(productId, name),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: imageUrl != null
                                  ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
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
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image, size: 40),
                                  );
                                },
                              )
                                  : Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image, size: 40),
                              ),
                            ),
                            // Favorite indicator
                            Positioned(
                              top: 8,
                              right: 8,
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
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              onPressed: () async => _handleAddToCart(variant),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        );
      }),
    );
  }
}
