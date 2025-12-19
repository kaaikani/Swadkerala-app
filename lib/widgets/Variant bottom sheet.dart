import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart/Cartcontroller.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../graphql/product.graphql.dart';
import '../utils/price_formatter.dart';
import 'snackbar.dart';

class VariantBottomSheet extends StatelessWidget {
  final String productName;
  final List<Query$Products$collection$productVariants$items> variants;

  const VariantBottomSheet({
    super.key,
    required this.productName,
    required this.variants,
  });

  String _getVariantDisplayName(
      Query$Products$collection$productVariants$items variant) {
    final collectionsController = Get.find<CollectionsController>();
    return collectionsController.buildVariantLabel(variant);
  }

  Future<void> _addToCart(
      Query$Products$collection$productVariants$items variant) async {
    final cartController = Get.find<CartController>();
    final variantId = int.tryParse(variant.id);

    if (variantId == null) {
      showErrorSnackbar('Invalid variant ID');
      return;
    }

    // For Blinkit style, we want to add 1 unit directly.
    final success = await cartController.addToCart(
      productVariantId: variantId,
      quantity: 1,
    );

    if (!success) {
      showErrorSnackbar('Failed to add to cart');
    }
  }

  int? _getShadowPriceMinor(
      Query$Products$collection$productVariants$items variant) {
    final rawValue = variant.customFields?.shadowPrice;
    if (rawValue == null || rawValue <= 0) return null;

    final currentPriceMinor = variant.priceWithTax.round();

    if (rawValue > currentPriceMinor) {
      return rawValue;
    }

    final scaledValue = rawValue * 100;
    if (scaledValue > currentPriceMinor) {
      return scaledValue;
    }

    return null;
  }

  double? _calculateDiscountPercent(
      Query$Products$collection$productVariants$items variant) {
    final shadowPriceMinor = _getShadowPriceMinor(variant);
    if (shadowPriceMinor == null) return null;

    final currentPriceMinor = variant.priceWithTax.round();
    if (shadowPriceMinor <= currentPriceMinor) return null;

    final discount =
        ((shadowPriceMinor - currentPriceMinor) / shadowPriceMinor) * 100;
    return discount > 0 ? discount : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select $productName',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...variants.map((variant) {
            final stockLevelStr = variant.stockLevel.toUpperCase();
            final isInStock = stockLevelStr == 'IN_STOCK' ||
                (int.tryParse(variant.stockLevel) ?? 0) > 0;
            final stockDisplay = stockLevelStr == 'IN_STOCK'
                ? 'In Stock'
                : (int.tryParse(variant.stockLevel) != null
                    ? 'In Stock (${variant.stockLevel})'
                    : 'Out of Stock');
            final priceMinor = variant.priceWithTax.round();
            final shadowPriceMinor = _getShadowPriceMinor(variant);
            final discountPercent = _calculateDiscountPercent(variant);
            final displayName = _getVariantDisplayName(variant);
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(displayName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(PriceFormatter.formatPrice(priceMinor)),
                        if (shadowPriceMinor != null &&
                            shadowPriceMinor > priceMinor) ...[
                          const SizedBox(width: 8),
                          Text(
                            PriceFormatter.formatPrice(shadowPriceMinor),
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                        if (discountPercent != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${discountPercent.round()}% OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      isInStock ? stockDisplay : 'Out of Stock',
                      style: TextStyle(
                        color: isInStock ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: isInStock
                      ? () {
                          Get.back();
                          _addToCart(variant);
                        }
                      : null,
                  child: const Text('Add'),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
