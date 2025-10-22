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

// Coupon Code Models
class CouponCodeModel {
  final String id;
  final String name;
  final String couponCode;
  final String? description;
  final bool enabled;
  final String? endsAt;
  final String? startsAt;
  final String createdAt;
  final String updatedAt;
  final int? perCustomerUsageLimit;
  final List<CouponActionModel> actions;
  final List<CouponConditionModel> conditions;
  final int? usageLimit;
  final List<CouponProductModel>? products; // Products associated with this coupon

  CouponCodeModel({
    required this.id,
    required this.name,
    required this.couponCode,
    this.description,
    required this.enabled,
    this.endsAt,
    this.startsAt,
    required this.createdAt,
    required this.updatedAt,
    this.perCustomerUsageLimit,
    required this.actions,
    required this.conditions,
    this.usageLimit,
    this.products,
  });

  factory CouponCodeModel.fromJson(Map<String, dynamic> json) {
    return CouponCodeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      couponCode: json['couponCode'] ?? '',
      description: json['description'],
      enabled: json['enabled'] ?? false,
      endsAt: json['endsAt'],
      startsAt: json['startsAt'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      perCustomerUsageLimit: json['perCustomerUsageLimit'],
      actions: (json['actions'] as List<dynamic>?)
          ?.map((action) => CouponActionModel.fromJson(action))
          .toList() ?? [],
      conditions: (json['conditions'] as List<dynamic>?)
          ?.map((condition) => CouponConditionModel.fromJson(condition))
          .toList() ?? [],
      usageLimit: json['usageLimit'],
      products: (json['products'] as List<dynamic>?)
          ?.map((product) => CouponProductModel.fromJson(product))
          .toList(),
    );
  }
}

class CouponActionModel {
  final String code;
  final List<CouponArgModel> args;

  CouponActionModel({
    required this.code,
    required this.args,
  });

  factory CouponActionModel.fromJson(Map<String, dynamic> json) {
    return CouponActionModel(
      code: json['code'] ?? '',
      args: (json['args'] as List<dynamic>?)
          ?.map((arg) => CouponArgModel.fromJson(arg))
          .toList() ?? [],
    );
  }
}

class CouponConditionModel {
  final String code;
  final List<CouponArgModel> args;

  CouponConditionModel({
    required this.code,
    required this.args,
  });

  factory CouponConditionModel.fromJson(Map<String, dynamic> json) {
    return CouponConditionModel(
      code: json['code'] ?? '',
      args: (json['args'] as List<dynamic>?)
          ?.map((arg) => CouponArgModel.fromJson(arg))
          .toList() ?? [],
    );
  }
}

class CouponArgModel {
  final String name;
  final dynamic value;

  CouponArgModel({
    required this.name,
    required this.value,
  });

  factory CouponArgModel.fromJson(Map<String, dynamic> json) {
    return CouponArgModel(
      name: json['name'] ?? '',
      value: json['value'],
    );
  }
}

class CouponProductModel {
  final String id;
  final String name;
  final String productVariantId;
  final double price;
  final double priceWithTax;
  final String? imageUrl;
  final int quantity;
  final String? description;

  CouponProductModel({
    required this.id,
    required this.name,
    required this.productVariantId,
    required this.price,
    required this.priceWithTax,
    this.imageUrl,
    required this.quantity,
    this.description,
  });

  factory CouponProductModel.fromJson(Map<String, dynamic> json) {
    return CouponProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      productVariantId: json['productVariantId'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceWithTax: (json['priceWithTax'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'],
      quantity: json['quantity'] ?? 1,
      description: json['description'],
    );
  }
}
