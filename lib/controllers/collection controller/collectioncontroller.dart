import 'package:get/get.dart';
import '../../graphql/product.graphql.dart';
import '../../services/graphql_client.dart';
import '../utilitycontroller/utilitycontroller.dart';
import 'Collectionmodel.dart';
import 'package:flutter/foundation.dart';
class CollectionsController extends GetxController {
  RxList<Collection> allCollections = <Collection>[].obs;
  RxList<Product> allProducts = <Product>[].obs;
  final UtilityController utilityController = Get.find();

  Rx<Collection?> currentCollection = Rx<Collection?>(null);

  RxList<Query$Products$collection$productVariants$items> uniqueProductVariants = <Query$Products$collection$productVariants$items>[].obs;
  
  // Map to store all variants by product ID for quick lookup
  RxMap<String, List<Query$Products$collection$productVariants$items>> variantsByProductId = <String, List<Query$Products$collection$productVariants$items>>{}.obs;
  // Track the currently selected variant ID per product for UI dropdowns
  RxMap<String, String> selectedVariantIdByProductId = <String, String>{}.obs;

  // Lazy loading state - client-side pagination
  static const int _itemsPerPage = 20;
  int _displayedItemsCount = 0;
  List<Query$Products$collection$productVariants$items> _allUniqueVariants = [];
  bool _isLoadingMore = false;

  // Flag to prevent multiple simultaneous fetches
  bool _isFetching = false;

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
debugPrint(  '[Collection] GraphQL Exception: ${response.exception.toString()}');
        return false;
      }

      final itemsJson = response.parsedData?.collections.items;
      if (itemsJson != null) {
        final collections = itemsJson
            .map((e) => Collection.fromJson(e.toJson()))
            .toList();
        
        // Sort collections: slugs ending with numbers first (by number), then others
        collections.sort((a, b) {
          final aSlug = a.slug ?? '';
          final bSlug = b.slug ?? '';
          
          // Extract number from end of slug if present
          final aMatch = RegExp(r'(\d+)$').firstMatch(aSlug);
          final bMatch = RegExp(r'(\d+)$').firstMatch(bSlug);
          
          final aNumber = aMatch != null ? int.tryParse(aMatch.group(1) ?? '') : null;
          final bNumber = bMatch != null ? int.tryParse(bMatch.group(1) ?? '') : null;
          
          // Both have numbers - sort by number
          if (aNumber != null && bNumber != null) {
            return aNumber.compareTo(bNumber);
          }
          
          // Only a has number - a comes first
          if (aNumber != null && bNumber == null) {
            return -1;
          }
          
          // Only b has number - b comes first
          if (aNumber == null && bNumber != null) {
            return 1;
          }
          
          // Neither has number - maintain original order (or sort alphabetically)
          return aSlug.compareTo(bSlug);
        });
        
        allCollections.value = collections;
debugPrint('[Collection] Loaded ${allCollections.length} collections');
      } else {
debugPrint('[Collection] No collections found');
      }

      return true;
    } catch (e) {
debugPrint('[Collection] Exception fetching collections: $e');
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
    selectedVariantIdByProductId.clear();
    _allUniqueVariants.clear();
    _displayedItemsCount = 0;

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
            _allUniqueVariants.add(item); // Store all variants
            selectedVariantIdByProductId[productId] = item.id;
            debugPrint('• Product: ${product.name} | ID: $productId | Variants: ${variantsByProductId[productId]!.length}');
          }
        }
        
        // Initially display first batch
        _displayedItemsCount = _allUniqueVariants.length < _itemsPerPage 
            ? _allUniqueVariants.length 
            : _itemsPerPage;
        uniqueProductVariants.value = _allUniqueVariants.take(_displayedItemsCount).toList();
        
        debugPrint('📊 [Collection] Lazy Loading: displaying $_displayedItemsCount of ${_allUniqueVariants.length} products');
      } else {
        debugPrint('⚠️ [Collection] No collection found for slug="$slug" id="$id"');
      }

      return true;
    } catch (e) {
      debugPrint('❌ [Collection] Exception: $e');
      return false;
    } finally {
      utilityController.setLoadingState(false);
      debugPrint('=== [Collection] fetchCollectionproducts END ===');
    }
  }

  /// Load more products (client-side pagination)
  Future<bool> loadMoreProducts() async {
    if (_isLoadingMore || !hasMoreItems) {
      return false;
    }
    
    _isLoadingMore = true;
    
    try {
      // Simulate loading delay for better UX
      await Future.delayed(Duration(milliseconds: 300));
      
      final nextBatchStart = _displayedItemsCount;
      final nextBatchEnd = (nextBatchStart + _itemsPerPage).clamp(0, _allUniqueVariants.length);
      
      if (nextBatchStart < _allUniqueVariants.length) {
        final newItems = _allUniqueVariants.sublist(nextBatchStart, nextBatchEnd);
        uniqueProductVariants.addAll(newItems);
        _displayedItemsCount = nextBatchEnd;
        
        debugPrint('📥 [Collection] Loaded more: $_displayedItemsCount of ${_allUniqueVariants.length} products');
        return true;
      }
      
      return false;
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Check if there are more items to load
  bool get hasMoreItems => _displayedItemsCount < _allUniqueVariants.length;
  
  /// Check if currently loading more items
  bool get isLoadingMore => _isLoadingMore;

  /// Returns the list of variants for the given product ID (empty list if none)
  List<Query$Products$collection$productVariants$items> getVariantsForProduct(String productId) {
    return variantsByProductId[productId] ?? const [];
  }

  /// Sets the selected variant for a product if the ID exists in the cached list
  void setSelectedVariant(String productId, String variantId) {
    final variants = variantsByProductId[productId];
    if (variants == null) return;
    final exists = variants.any((variant) => variant.id == variantId);
    if (exists) {
      selectedVariantIdByProductId[productId] = variantId;
    }
  }

  /// Returns the currently selected variant for the product. Defaults to first variant.
  Query$Products$collection$productVariants$items? getSelectedVariantForProduct(String productId) {
    final variants = variantsByProductId[productId];
    if (variants == null || variants.isEmpty) return null;

    final selectedId = selectedVariantIdByProductId[productId];
    if (selectedId != null) {
      for (final variant in variants) {
        if (variant.id == selectedId) {
          return variant;
        }
      }
    }
    return variants.first;
  }

  /// Builds a readable label for a variant using its option group names if present
  String buildVariantLabel(Query$Products$collection$productVariants$items variant) {
    if (variant.options.isEmpty) {
      return variant.name;
    }

    final parts = variant.options.map((option) {
      final optionName = option.name.trim();
      // Return only the option name (remove group name before colon)
      return optionName;
    }).toList();

    return parts.join(' • ');
  }

  /// Returns all unique option values for the given product and option group name
  List<String> getUniqueOptionsForGroup(String productId, String groupName) {
    final variants = variantsByProductId[productId] ?? const [];
    if (variants.isEmpty) return const [];

    final uniqueValues = <String>{};
    for (final variant in variants) {
      for (final option in variant.options) {
        if (option.group.name == groupName) {
          uniqueValues.add(option.name);
          break;
        }
      }
    }
    return uniqueValues.toList();
  }
}