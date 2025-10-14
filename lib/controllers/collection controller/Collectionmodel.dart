/// Featured asset model
class FeaturedAsset {
  final String id;
  final String preview;

  FeaturedAsset({required this.id, required this.preview});

  factory FeaturedAsset.fromJson(Map<String, dynamic> json) {
    return FeaturedAsset(
      id: json['id'] ?? '',
      preview: json['preview'] ?? '',
    );
  }
}

/// Parent collection model
class Parent {
  final String name;

  Parent({required this.name});

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(name: json['name'] ?? '');
  }
}

/// Child collection (sub-collection) model
class Child {
  final String id;
  final String name;
  final String slug;
  final FeaturedAsset? featuredAsset;

  Child({
    required this.id,
    required this.name,
    required this.slug,
    this.featuredAsset,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      featuredAsset: json['featuredAsset'] != null
          ? FeaturedAsset.fromJson(json['featuredAsset'])
          : null,
    );
  }
}

/// Product model
class Product {
  final String id;
  final String name;
  final bool? enabled;
  final FeaturedAsset? featuredAsset;

  Product({required this.id, required this.name, this.enabled, this.featuredAsset});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      enabled: json['enabled'],
      featuredAsset: json['featuredAsset'] != null
          ? FeaturedAsset.fromJson(json['featuredAsset'])
          : null,
    );
  }
}

/// Product variant item
class ProductVariantItem {
  final String productId;
  final String name;
  final Product? product;
  final int stockLevel;
  final double? priceWithTax;
  final bool? enabled;

  ProductVariantItem({
    required this.productId,
    required this.name,
    this.product,
    required this.stockLevel,
    this.priceWithTax,
    this.enabled,
  });

  factory ProductVariantItem.fromJson(Map<String, dynamic> json) {
    int parseStockLevel(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return ProductVariantItem(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      stockLevel: parseStockLevel(json['stockLevel']),
      priceWithTax: json['priceWithTax']?.toDouble(),
      enabled: json['product']?['enabled'],
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }
}

/// Product variants wrapper
class ProductVariants {
  final int totalItems;
  final List<ProductVariantItem>? items;

  ProductVariants({required this.totalItems, this.items});

  factory ProductVariants.fromJson(Map<String, dynamic> json) {
    return ProductVariants(
      totalItems: json['totalItems'] ?? 0,
      items: (json['items'] as List?)
          ?.map((e) => ProductVariantItem.fromJson(e))
          .toList(),
    );
  }
}

/// Collection model
class Collection {
  final String id;
  final String name;
  final String? slug;
  final ProductVariants productVariants;
  final Parent? parent;
  final FeaturedAsset? featuredAsset;
  final List<Child> children;

  Collection({
    required this.id,
    required this.name,
    required this.productVariants,
    this.slug,
    this.parent,
    this.featuredAsset,
    this.children = const [],
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
      productVariants: ProductVariants.fromJson(json['productVariants'] ?? {}),
      parent: json['parent'] != null ? Parent.fromJson(json['parent']) : null,
      featuredAsset: json['featuredAsset'] != null
          ? FeaturedAsset.fromJson(json['featuredAsset'])
          : null,
      children: (json['children'] as List?)
          ?.map((e) => Child.fromJson(e))
          .toList() ??
          [],
    );
  }
}

/// Response for collections list
class CollectionsResponse {
  final List<Collection> items;

  CollectionsResponse({required this.items});

  factory CollectionsResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['collections']?['items'] as List? ?? [];
    final itemsList = itemsJson.map((e) => Collection.fromJson(e)).toList();
    return CollectionsResponse(items: itemsList);
  }
}

/// Response for a single collection
class CollectionResponse {
  final Collection? collection;

  CollectionResponse({this.collection});

  factory CollectionResponse.fromJson(Map<String, dynamic> json) {
    return CollectionResponse(
      collection: json['collection'] != null
          ? Collection.fromJson(json['collection'])
          : null,
    );
  }
}
