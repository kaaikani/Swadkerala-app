import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart/Cartcontroller.dart';
import '../graphql/collections.graphql.dart';
import 'snackbar.dart';

class VariantBottomSheet extends StatelessWidget {
  final String productName;
  final List<Query$Products$collection$productVariants$items> variants;

  const VariantBottomSheet({
    super.key,
    required this.productName,
    required this.variants,
  });

  Future<void> _addToCart(Query$Products$collection$productVariants$items variant) async {
    final cartController = Get.find<CartController>();
    final variantId = int.tryParse(variant.id);
    
    if (variantId == null) {
      showErrorSnackbar('Invalid variant ID');
      return;
    }

    final success = await cartController.addToCart(
      productVariantId: variantId,
      quantity: 1,
    );

    if (success) {
      showSuccessSnackbar('${variant.name} added to cart');
    } else {
      showErrorSnackbar('Failed to add to cart');
    }
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
            final price = variant.priceWithTax;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(variant.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rs.${(price / 100).toStringAsFixed(2)}'),
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
