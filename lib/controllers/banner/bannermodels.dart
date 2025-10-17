class BannerModel {
  final String id;
  final List<AssetModel> assets;
  final List<ChannelModel> channels;

  BannerModel({
    required this.id,
    required this.assets,
    required this.channels,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? '',
      assets: (json['assets'] as List<dynamic>)
          .map((asset) => AssetModel.fromJson(asset))
          .toList(),
      channels: (json['channels'] as List<dynamic>)
          .map((ch) => ChannelModel.fromJson(ch))
          .toList(),
    );
  }
}

class AssetModel {
  final String id;
  final String name;
  final String source;

  AssetModel({
    required this.id,
    required this.name,
    required this.source,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      source: json['source'] ?? '',
    );
  }
}

class ChannelModel {
  final String id;
  final String code;

  ChannelModel({
    required this.id,
    required this.code,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
    );
  }
}



class SearchItemModel {
  final String productVariantId;
  final String productId;
  final String slug;
  final String productName;
  final String? productVariantName; // <-- added
  final String? description;
  final List<String>? collectionIds;
  final double? priceMin;
  final double? priceMax;
  final String? previewImage;

  SearchItemModel({
    required this.productVariantId,
    required this.productId,
    required this.slug,
    required this.productName,
    this.productVariantName, // <-- added
    this.description,
    this.collectionIds,
    this.priceMin,
    this.priceMax,
    this.previewImage,
  });

  factory SearchItemModel.fromJson(Map<String, dynamic> json) {
    final price = json['priceWithTax'];
    return SearchItemModel(
      productVariantId: json['productVariantId'].toString(),
      productId: json['productId'].toString(),
      slug: json['slug'],
      productName: json['productName'],
      productVariantName: json['productVariantName'], // <-- map it
      description: json['description'],
      collectionIds: (json['collectionIds'] as List<dynamic>?)?.cast<String>(),
      priceMin: price != null ? (price['min']?.toDouble()) : null,
      priceMax: price != null ? (price['max']?.toDouble()) : null,
      previewImage: json['productAsset'] != null ? json['productAsset']['preview'] : null,
    );
  }
}

// Favorite Models
class FavoriteItemModel {
  final String id;
  final FavoriteProductModel product;

  FavoriteItemModel({
    required this.id,
    required this.product,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      id: json['id'] ?? '',
      product: FavoriteProductModel.fromJson(json['product'] ?? {}),
    );
  }
}

class FavoriteProductModel {
  final String id;
  final String name;
  final bool enabled;
  final FeaturedAssetModel? featuredAsset;
  final List<VariantIdModel> variants;

  FavoriteProductModel({
    required this.id,
    required this.name,
    required this.enabled,
    this.featuredAsset,
    required this.variants,
  });

  factory FavoriteProductModel.fromJson(Map<String, dynamic> json) {
    return FavoriteProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      enabled: json['enabled'] ?? false,
      featuredAsset: json['featuredAsset'] != null 
          ? FeaturedAssetModel.fromJson(json['featuredAsset']) 
          : null,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((v) => VariantIdModel.fromJson(v))
          .toList() ?? [],
    );
  }
}

class FeaturedAssetModel {
  final String name;
  final String preview;

  FeaturedAssetModel({
    required this.name,
    required this.preview,
  });

  factory FeaturedAssetModel.fromJson(Map<String, dynamic> json) {
    return FeaturedAssetModel(
      name: json['name'] ?? '',
      preview: json['preview'] ?? '',
    );
  }
}

class VariantIdModel {
  final String id;

  VariantIdModel({required this.id});

  factory VariantIdModel.fromJson(Map<String, dynamic> json) {
    return VariantIdModel(
      id: json['id'] ?? '',
    );
  }
}

class FavoritesModel {
  final List<FavoriteItemModel> items;
  final int totalItems;

  FavoritesModel({
    required this.items,
    required this.totalItems,
  });

  factory FavoritesModel.fromJson(Map<String, dynamic> json) {
    return FavoritesModel(
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => FavoriteItemModel.fromJson(item))
          .toList() ?? [],
      totalItems: json['totalItems'] ?? 0,
    );
  }
}

class ToggleFavoriteResult {
  final List<FavoriteItemModel> items;
  final int totalItems;

  ToggleFavoriteResult({
    required this.items,
    required this.totalItems,
  });

  factory ToggleFavoriteResult.fromJson(Map<String, dynamic> json) {
    return ToggleFavoriteResult(
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => FavoriteItemModel.fromJson(item))
          .toList() ?? [],
      totalItems: json['totalItems'] ?? 0,
    );
  }
}
