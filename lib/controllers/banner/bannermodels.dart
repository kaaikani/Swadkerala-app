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
