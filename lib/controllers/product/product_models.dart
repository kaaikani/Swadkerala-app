
/// Product Detail Models
class ProductDetailModel {
  final String id;
  final String name;
  final String? description;
  final ProductAssetModel? featuredAsset;
  final List<ProductAssetModel> assets;
  final List<ProductVariantDetailModel> variants;
  final List<ProductCollectionModel> collections;

  ProductDetailModel({
    required this.id,
    required this.name,
    this.description,
    this.featuredAsset,
    this.assets = const [],
    this.variants = const [],
    this.collections = const [],
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      featuredAsset: json['featuredAsset'] != null
          ? ProductAssetModel.fromJson(json['featuredAsset'])
          : null,
      assets: (json['assets'] as List?)
              ?.map((e) => ProductAssetModel.fromJson(e))
              .toList() ??
          [],
      variants: (json['variants'] as List?)
              ?.map((e) => ProductVariantDetailModel.fromJson(e))
              .toList() ??
          [],
      collections: (json['collections'] as List?)
              ?.map((e) => ProductCollectionModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ProductAssetModel {
  final String id;
  final String? name;
  final String preview;
  final int? width;
  final int? height;
  final FocalPointModel? focalPoint;

  ProductAssetModel({
    required this.id,
    this.name,
    required this.preview,
    this.width,
    this.height,
    this.focalPoint,
  });

  factory ProductAssetModel.fromJson(Map<String, dynamic> json) {
    return ProductAssetModel(
      id: json['id'] ?? '',
      name: json['name'],
      preview: json['preview'] ?? '',
      width: json['width'],
      height: json['height'],
      focalPoint: json['focalPoint'] != null
          ? FocalPointModel.fromJson(json['focalPoint'])
          : null,
    );
  }
}

class FocalPointModel {
  final double x;
  final double y;

  FocalPointModel({required this.x, required this.y});

  factory FocalPointModel.fromJson(Map<String, dynamic> json) {
    return FocalPointModel(
      x: (json['x'] ?? 0).toDouble(),
      y: (json['y'] ?? 0).toDouble(),
    );
  }
}

class ProductVariantDetailModel {
  final String id;
  final String name;
  final int stockLevel;
  final double? price;
  final double? priceWithTax;
  final String? currencyCode;
  final String? languageCode;
  final String? sku;
  final ProductAssetModel? featuredAsset;
  final List<ProductAssetModel> assets;
  final List<ProductOptionModel> options;

  ProductVariantDetailModel({
    required this.id,
    required this.name,
    required this.stockLevel,
    this.price,
    this.priceWithTax,
    this.currencyCode,
    this.languageCode,
    this.sku,
    this.featuredAsset,
    this.assets = const [],
    this.options = const [],
  });

  factory ProductVariantDetailModel.fromJson(Map<String, dynamic> json) {
    double? parsePrice(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    int parseStockLevel(dynamic value) {
      if (value == null) {
        print('[ProductModel] stockLevel is null, defaulting to 999 (unlimited)');
        return 999; // Default to high value if null (assume in stock)
      }
      if (value is int) {
        print('[ProductModel] stockLevel is int: $value');
        return value;
      }
      if (value is String) {
        final stockLevelUpper = value.toUpperCase().trim();
        
        // Handle special string values that mean "in stock"
        if (stockLevelUpper == 'IN_STOCK' || 
            stockLevelUpper == 'INSTOCK' || 
            stockLevelUpper == 'AVAILABLE' ||
            stockLevelUpper.isEmpty) {
          print('[ProductModel] stockLevel is "$value" (special value), defaulting to 999 (in stock)');
          return 999; // Treat as in stock
        }
        
        // Try to parse as number
        final parsed = int.tryParse(stockLevelUpper);
        if (parsed != null) {
          print('[ProductModel] stockLevel parsed from String "$value" to int: $parsed');
          return parsed;
        } else {
          // If parsing fails and it's not a special value, assume in stock (999)
          print('[ProductModel] stockLevel string "$value" could not be parsed, defaulting to 999 (assume in stock)');
          return 999; // Default to high value (assume in stock)
        }
      }
      if (value is double) {
        print('[ProductModel] stockLevel is double: $value, converting to int');
        return value.toInt();
      }
      print('[ProductModel] stockLevel is unknown type: ${value.runtimeType}, defaulting to 999');
      return 999; // Default to high value (assume in stock)
    }

    return ProductVariantDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      stockLevel: parseStockLevel(json['stockLevel']),
      price: parsePrice(json['price']),
      priceWithTax: parsePrice(json['priceWithTax']),
      currencyCode: json['currencyCode'],
      languageCode: json['languageCode'],
      sku: json['sku'],
      featuredAsset: json['featuredAsset'] != null
          ? ProductAssetModel.fromJson(json['featuredAsset'])
          : null,
      assets: (json['assets'] as List?)
              ?.map((e) => ProductAssetModel.fromJson(e))
              .toList() ??
          [],
      options: (json['options'] as List?)
              ?.map((e) => ProductOptionModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ProductOptionModel {
  final String id;
  final String? code;
  final String? name;

  ProductOptionModel({
    required this.id,
    this.code,
    this.name,
  });

  factory ProductOptionModel.fromJson(Map<String, dynamic> json) {
    return ProductOptionModel(
      id: json['id'] ?? '',
      code: json['code'],
      name: json['name'],
    );
  }
}

class ProductCollectionModel {
  final String id;
  final String? slug;
  final List<BreadcrumbModel> breadcrumbs;

  ProductCollectionModel({
    required this.id,
    this.slug,
    this.breadcrumbs = const [],
  });

  factory ProductCollectionModel.fromJson(Map<String, dynamic> json) {
    return ProductCollectionModel(
      id: json['id'] ?? '',
      slug: json['slug'],
      breadcrumbs: (json['breadcrumbs'] as List?)
              ?.map((e) => BreadcrumbModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class BreadcrumbModel {
  final String id;
  final String name;
  final String? slug;

  BreadcrumbModel({
    required this.id,
    required this.name,
    this.slug,
  });

  factory BreadcrumbModel.fromJson(Map<String, dynamic> json) {
    return BreadcrumbModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
    );
  }
}

