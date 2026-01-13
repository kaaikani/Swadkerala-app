import 'package:get/get.dart';
import '../../graphql/product.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../utilitycontroller/utilitycontroller.dart';
import 'package:flutter/foundation.dart';

class CollectionsController extends GetxController {
  RxList<Query$Collections$collections$items> allCollections = <Query$Collections$collections$items>[].obs;
  final UtilityController utilityController = Get.find();

  Rx<Query$Products$collection?> currentCollection = Rx<Query$Products$collection?>(null);

  RxList<Query$Products$collection$productVariants$items> uniqueProductVariants = <Query$Products$collection$productVariants$items>[].obs;
  
  // Map to store all variants by product ID for quick lookup
  RxMap<String, List<Query$Products$collection$productVariants$items>> variantsByProductId = <String, List<Query$Products$collection$productVariants$items>>{}.obs;
  // Track the currently selected variant ID per product for UI dropdowns
  RxMap<String, String> selectedVariantIdByProductId = <String, String>{}.obs;

  // Lazy loading state - client-side pagination for products
  static const int _itemsPerPage = 20;
  int _displayedItemsCount = 0;
  List<Query$Products$collection$productVariants$items> _allUniqueVariants = [];
  bool _isLoadingMore = false;

  // Lazy loading state for collections (server-side pagination)
  static const int _collectionsPerPage = 15; // Load 15 collections at a time
  int _collectionsSkip = 0;
  bool _isLoadingMoreCollections = false;
  bool _hasMoreCollections = true;
  List<Query$Collections$collections$items> _allFetchedCollections = []; // Store all fetched collections for sorting

  // Flag to prevent multiple simultaneous fetches
  bool _isFetching = false;

  /// Fetch initial batch of collections (lazy loading)
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

    // Reset pagination state if force refresh
    if (force) {
      _collectionsSkip = 0;
      _hasMoreCollections = true;
      _allFetchedCollections.clear();
      allCollections.clear();
    }

    debugPrint('[Collection] Starting fetchAllCollections (lazy loading)...');
    _isFetching = true;

    utilityController.setLoadingState(true);

    try {
      final response = await GraphqlService.client.value.query$Collections(
        Options$Query$Collections(
          variables: Variables$Query$Collections(
            options: Input$CollectionListOptions(
              skip: _collectionsSkip,
              take: _collectionsPerPage,
            ),
          ),
        ),
      );

      if (response.hasException) {
        debugPrint('[Collection] GraphQL Exception: ${response.exception.toString()}');
        return false;
      }

      final collectionsData = response.parsedData?.collections;
      final items = collectionsData?.items;
      
      if (items != null && items.isNotEmpty) {
        // Add new items to the fetched list
        _allFetchedCollections.addAll(items);
        
        // Sort collections: slugs ending with numbers positioned by number (1=first, 2=second, etc.), then others at last
        final sortedCollections = _sortCollectionsBySlugNumber(_allFetchedCollections);
        
        allCollections.value = sortedCollections;
        _collectionsSkip = allCollections.length;
        
        // If we got fewer items than requested, we've reached the end
        _hasMoreCollections = items.length >= _collectionsPerPage;
        
        debugPrint('[Collection] Loaded ${allCollections.length} collections (hasMore: $_hasMoreCollections, fetched: ${items.length})');
      } else {
        debugPrint('[Collection] No collections found');
        _hasMoreCollections = false;
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

  /// Load more collections (lazy loading)
  Future<bool> loadMoreCollections() async {
    if (_isLoadingMoreCollections || !_hasMoreCollections || _isFetching) {
      debugPrint('[Collection] Cannot load more: isLoading=$_isLoadingMoreCollections, hasMore=$_hasMoreCollections, isFetching=$_isFetching');
      return false;
    }

    _isLoadingMoreCollections = true;
    debugPrint('[Collection] Loading more collections (skip: $_collectionsSkip, take: $_collectionsPerPage)...');

    try {
      final response = await GraphqlService.client.value.query$Collections(
        Options$Query$Collections(
          variables: Variables$Query$Collections(
            options: Input$CollectionListOptions(
              skip: _collectionsSkip,
              take: _collectionsPerPage,
            ),
          ),
        ),
      );

      if (response.hasException) {
        debugPrint('[Collection] GraphQL Exception loading more: ${response.exception.toString()}');
        return false;
      }

      final collectionsData = response.parsedData?.collections;
      final items = collectionsData?.items;
      
      if (items != null && items.isNotEmpty) {
        // Add new items to the fetched list
        _allFetchedCollections.addAll(items);
        
        // Sort all collections again
        final sortedCollections = _sortCollectionsBySlugNumber(_allFetchedCollections);
        
        allCollections.value = sortedCollections;
        _collectionsSkip = allCollections.length;
        
        // If we got fewer items than requested, we've reached the end
        _hasMoreCollections = items.length >= _collectionsPerPage;
        
        debugPrint('[Collection] Loaded more: ${allCollections.length} collections (hasMore: $_hasMoreCollections, fetched: ${items.length})');
        return true;
      } else {
        _hasMoreCollections = false;
        debugPrint('[Collection] No more collections to load');
        return false;
      }
    } catch (e) {
      debugPrint('[Collection] Exception loading more collections: $e');
      return false;
    } finally {
      _isLoadingMoreCollections = false;
    }
  }

  /// Sort collections by slug number
  List<Query$Collections$collections$items> _sortCollectionsBySlugNumber(
    List<Query$Collections$collections$items> collections,
  ) {
    // Separate collections into those with numbers and those without
    final collectionsWithNumbers = <Query$Collections$collections$items>[];
    final collectionsWithoutNumbers = <Query$Collections$collections$items>[];
    
    for (final collection in collections) {
      final slug = collection.slug;
      final match = RegExp(r'(\d+)$').firstMatch(slug);
      if (match != null) {
        collectionsWithNumbers.add(collection);
      } else {
        collectionsWithoutNumbers.add(collection);
      }
    }
    
    // Sort collections with numbers by the number at the end (1, 2, 11, etc.)
    collectionsWithNumbers.sort((a, b) {
      final aSlug = a.slug;
      final bSlug = b.slug;
      final aMatch = RegExp(r'(\d+)$').firstMatch(aSlug);
      final bMatch = RegExp(r'(\d+)$').firstMatch(bSlug);
      
      final aNumber = aMatch != null ? int.tryParse(aMatch.group(1) ?? '') : null;
      final bNumber = bMatch != null ? int.tryParse(bMatch.group(1) ?? '') : null;
      
      if (aNumber != null && bNumber != null) {
        return aNumber.compareTo(bNumber);
      }
      
      return aSlug.compareTo(bSlug);
    });
    
    // Combine: collections with numbers (sorted by number) first, then collections without numbers
    final arrangedCollections = <Query$Collections$collections$items>[];
    arrangedCollections.addAll(collectionsWithNumbers);
    arrangedCollections.addAll(collectionsWithoutNumbers);
    
    return arrangedCollections;
  }

  /// Check if there are more collections to load
  bool get hasMoreCollections => _hasMoreCollections;
  
  /// Check if currently loading more collections
  bool get isLoadingMoreCollections => _isLoadingMoreCollections;


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
        currentCollection.value = collectionData;
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
        
        // Sort products based on slug ending numbers
        _allUniqueVariants = _sortProductsBySlugNumber(_allUniqueVariants);
        
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

  /// Sort products by the number at the end of their slug
  /// Products ending with 1 appear first, 2 second, etc.
  /// Products without numbers appear last
  List<Query$Products$collection$productVariants$items> _sortProductsBySlugNumber(
    List<Query$Products$collection$productVariants$items> variants,
  ) {
    final variantsWithNumbers = <Query$Products$collection$productVariants$items>[];
    final variantsWithoutNumbers = <Query$Products$collection$productVariants$items>[];

    // Separate variants with and without numbers
    for (final variant in variants) {
      final slug = variant.product.slug;
      final match = RegExp(r'(\d+)$').firstMatch(slug);
      if (match != null) {
        variantsWithNumbers.add(variant);
      } else {
        variantsWithoutNumbers.add(variant);
      }
    }

    // Sort variants with numbers by the number at the end
    variantsWithNumbers.sort((a, b) {
      final aSlug = a.product.slug;
      final bSlug = b.product.slug;
      final aMatch = RegExp(r'(\d+)$').firstMatch(aSlug);
      final bMatch = RegExp(r'(\d+)$').firstMatch(bSlug);

      final aNumber = aMatch != null ? int.tryParse(aMatch.group(1) ?? '') : null;
      final bNumber = bMatch != null ? int.tryParse(bMatch.group(1) ?? '') : null;

      if (aNumber != null && bNumber != null) {
        // Sort by number: 1 comes first, 2 comes second, 11 comes 11th, etc.
        return aNumber.compareTo(bNumber);
      }

      // Fallback to slug comparison if parsing fails
      return aSlug.compareTo(bSlug);
    });

    // Combine: variants with numbers (sorted by number) first, then variants without numbers
    final sortedVariants = <Query$Products$collection$productVariants$items>[];
    sortedVariants.addAll(variantsWithNumbers);
    sortedVariants.addAll(variantsWithoutNumbers);

    return sortedVariants;
  }
}