import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../graphql/collections.graphql.dart';
import '../../services/graphql_client.dart';
import '../utilitycontroller/utilitycontroller.dart';
import 'Collectionmodel.dart';

class CollectionsController extends GetxController {
  RxList<Collection> allCollections = <Collection>[].obs;
  RxList<Product> allProducts = <Product>[].obs;
  final UtilityController utilityController = Get.find();

  Rx<Collection?> currentCollection = Rx<Collection?>(null);

  RxList<Query$Products$collection$productVariants$items> uniqueProductVariants = <Query$Products$collection$productVariants$items>[].obs;
  
  // Map to store all variants by product ID for quick lookup
  RxMap<String, List<Query$Products$collection$productVariants$items>> variantsByProductId = <String, List<Query$Products$collection$productVariants$items>>{}.obs;

  // Flag to prevent multiple simultaneous fetches
  bool _isFetching = false;

  /// Get all variants for a specific product ID
  List<Query$Products$collection$productVariants$items> getVariantsForProduct(String productId) {
    return variantsByProductId[productId] ?? [];
  }

  Future<bool> fetchAllCollections({bool force = false}) async {
    // Prevent multiple simultaneous fetches
    if (_isFetching) {
      debugPrint('[Collection] Already fetching, skipping duplicate request');
      return false;
    }

    // Don't fetch again if we already have collections (unless forced)
    if (!force && allCollections.isNotEmpty) {
      debugPrint('[Collection] Collections already loaded (${allCollections.length} items), skipping fetch');
      return true;
    }

    debugPrint('[Collection] Starting fetchAllCollections...');
    _isFetching = true;

    utilityController.setLoadingState(true);

    try {
      final response = await GraphqlService.client.value.query$Collections(
        Options$Query$Collections(
          // variables: Variables$Query$Collections(options: options), // remove this if undefined
        ),
      );

      if (response.hasException) {
        debugPrint(
            '[Collection] GraphQL Exception: ${response.exception.toString()}');
        return false;
      }

      final itemsJson = response.parsedData?.collections.items;
      if (itemsJson != null) {
        allCollections.value = itemsJson
            .map((e) => Collection.fromJson(e.toJson()))
            .toList();
        debugPrint('[Collection] Loaded ${allCollections.length} collections');
      } else {
        debugPrint('[Collection] No collections found');
      }

      return true;
    } catch (e, stacktrace) {
      debugPrint('[Collection] Exception fetching collections: $e');
      debugPrint('[Collection] Stacktrace: $stacktrace');
      return false;
    } finally {
      _isFetching = false;
      utilityController.setLoadingState(false);
      debugPrint('[Collection] fetchAllCollections finished.');
    }
  }


  Future<bool> fetchCollectionproducts({String? slug, String? id}) async {
    debugPrint('=== [Collection] fetchCollectionproducts START ===');
    debugPrint('[Collection] Parameters: slug="$slug", id="$id"');

    // Clear previous data before loading new collection
    currentCollection.value = null;
    uniqueProductVariants.clear();
    variantsByProductId.clear();

    utilityController.setLoadingState(true);

    try {
      final response = await GraphqlService.client.value.query$Products(
        Options$Query$Products(
          variables: Variables$Query$Products(slug: slug, id: id),
        ),
      );

      if (response.hasException) {
        debugPrint('⚠️ [Collection] GraphQL Exception: ${response.exception}');
        return false;
      }

      final collectionData = response.parsedData?.collection;

      if (collectionData != null) {
        currentCollection.value = Collection.fromJson(collectionData.toJson());
        debugPrint('✅ [Collection] Loaded Collection: ${currentCollection.value?.name}');

        final productItems = collectionData.productVariants.items;
        debugPrint('📦 Product Variants count: ${productItems.length}');

        // Filter unique products by product.id and group variants
        final loggedProductIds = <String>{};
        uniqueProductVariants.clear();
        variantsByProductId.clear();
        
        for (var item in productItems) {
          final product = item.product;
          final productId = product.id;
          
          // Add to variants map
          if (!variantsByProductId.containsKey(productId)) {
            variantsByProductId[productId] = [];
          }
          variantsByProductId[productId]!.add(item);
          
          // Add first variant to unique list for display
          if (!loggedProductIds.contains(productId)) {
            loggedProductIds.add(productId);
            uniqueProductVariants.add(item); // Store the first variant
            debugPrint('• Product: ${product.name} | ID: ${productId} | Variants: ${variantsByProductId[productId]!.length}');
          }
        }
      } else {
        debugPrint('⚠️ [Collection] No collection found for slug="$slug" id="$id"');
      }

      return true;
    } catch (e, stacktrace) {
      debugPrint('❌ [Collection] Exception: $e');
      debugPrint('❌ [Collection] Stacktrace: $stacktrace');
      return false;
    } finally {
      utilityController.setLoadingState(false);
      debugPrint('=== [Collection] fetchCollectionproducts END ===');
    }
  }

}