class CollectionsResponse {
  final List<Collection> items;

  CollectionsResponse({required this.items});

  factory CollectionsResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['collections']?['items'] as List? ?? [];
    final itemsList = itemsJson.map((e) => Collection.fromJson(e)).toList();
    return CollectionsResponse(items: itemsList);
  }
}

class Collection {
  final String id;
  final String name;
  final ProductVariants productVariants;
  final String? slug;
  final Parent? parent;
  final FeaturedAsset? featuredAsset;

  Collection({
    required this.id,
    required this.name,
    required this.productVariants,
    this.slug,
    this.parent,
    this.featuredAsset,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      productVariants: ProductVariants.fromJson(json['productVariants'] ?? {}),
      slug: json['slug'],
      parent: json['parent'] != null ? Parent.fromJson(json['parent']) : null,
      featuredAsset: json['featuredAsset'] != null
          ? FeaturedAsset.fromJson(json['featuredAsset'])
          : null,
    );
  }
}

class ProductVariants {
  final int totalItems;

  ProductVariants({required this.totalItems});

  factory ProductVariants.fromJson(Map<String, dynamic> json) {
    return ProductVariants(totalItems: json['totalItems'] ?? 0);
  }
}

class Parent {
  final String name;

  Parent({required this.name});

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(name: json['name'] ?? '');
  }
}

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
