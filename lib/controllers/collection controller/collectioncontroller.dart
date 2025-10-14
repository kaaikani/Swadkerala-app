import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../graphql/collections.graphql.dart';
import '../../services/graphql_client.dart';
import 'Collectionmodel.dart';

class CollectionsController extends GetxController {
  RxList<Collection> allCollections = <Collection>[].obs;
  RxBool isLoading = false.obs;
  RxList<Product> allProducts = <Product>[].obs;

  Rx<Collection?> currentCollection = Rx<Collection?>(null);

  RxList<Query$Products$collection$productVariants$items> uniqueProductVariants = <Query$Products$collection$productVariants$items>[].obs;

  Future<bool> fetchAllCollections() async {
    debugPrint('[Collection] Starting fetchAllCollections...');

    isLoading.value = true;

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

      final itemsJson = response.parsedData?.collections?.items;
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
      isLoading.value = false;
      debugPrint('[Collection] fetchAllCollections finished.');
    }
  }


  Future<bool> fetchCollectionproducts({String? slug, String? id}) async {
    debugPrint('=== [Collection] fetchCollectionproducts START ===');
    debugPrint('[Collection] Parameters: slug="$slug", id="$id"');

    isLoading.value = true;

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

        final productItems = collectionData.productVariants?.items ?? [];
        debugPrint('📦 Product Variants count: ${productItems.length}');

        // Filter unique products by product.id
        final loggedProductIds = <String>{};
        uniqueProductVariants.clear();
        for (var item in productItems) {
          final product = item.product;
          if (product != null && !loggedProductIds.contains(product.id)) {
            loggedProductIds.add(product.id);
            uniqueProductVariants.add(item); // Store the variant
            debugPrint('• Product: ${product.name} | ID: ${product.id}');
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
      isLoading.value = false;
      debugPrint('=== [Collection] fetchCollectionproducts END ===');
    }
  }

}