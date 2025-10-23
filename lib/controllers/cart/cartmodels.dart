class Asset {
  final String id;
  final int width;
  final int height;
  final String name;
  final String preview;
  final FocalPoint? focalPoint;

  Asset({
    required this.id,
    required this.width,
    required this.height,
    required this.name,
    required this.preview,
    this.focalPoint,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'].toString(),
      width: json['width'] is int ? json['width'] : int.parse(json['width'].toString()),
      height: json['height'] is int ? json['height'] : int.parse(json['height'].toString()),
      name: json['name'],
      preview: json['preview'],
      focalPoint: json['focalPoint'] != null ? FocalPoint.fromJson(json['focalPoint']) : null,
    );
  }
}

class FocalPoint {
  final double x;
  final double y;

  FocalPoint({required this.x, required this.y});

  factory FocalPoint.fromJson(Map<String, dynamic> json) {
    return FocalPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }
}

// Place other models like Discount, ProductVariant, OrderLine, Order below this

class Discount {
  final double amount;
  final double amountWithTax;
  final String description;
  final String adjustmentSource;
  final String type;

  Discount({
    required this.amount,
    required this.amountWithTax,
    required this.description,
    required this.adjustmentSource,
    required this.type,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      amount: (json['amount'] as num).toDouble(),
      amountWithTax: (json['amountWithTax'] as num).toDouble(),
      description: json['description'],
      adjustmentSource: json['adjustmentSource'],
      type: json['type'],
    );
  }
}
class ProductVariant {
  final String id;
  final String name;

  ProductVariant({required this.id, required this.name});

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}
class OrderLine {
  final String id;
  final Asset? featuredAsset;
  final double unitPrice;
  final double unitPriceWithTax;
  final int quantity;
  final double linePriceWithTax;
  final double discountedLinePriceWithTax;
  final ProductVariant productVariant;
  final List<Discount> discounts;

  OrderLine({
    required this.id,
    this.featuredAsset,
    required this.unitPrice,
    required this.unitPriceWithTax,
    required this.quantity,
    required this.linePriceWithTax,
    required this.discountedLinePriceWithTax,
    required this.productVariant,
    required this.discounts,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      id: json['id'].toString(),
      featuredAsset: json['featuredAsset'] != null ? Asset.fromJson(json['featuredAsset']) : null,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      unitPriceWithTax: (json['unitPriceWithTax'] as num).toDouble(),
      quantity: json['quantity'] is int ? json['quantity'] : int.parse(json['quantity'].toString()),
      linePriceWithTax: (json['linePriceWithTax'] as num).toDouble(),
      discountedLinePriceWithTax: (json['discountedLinePriceWithTax'] as num).toDouble(),
      productVariant: ProductVariant.fromJson(json['productVariant']),
      discounts: json['discounts'] != null
          ? List<Discount>.from(json['discounts'].map((x) => Discount.fromJson(x)))
          : [],
    );
  }
}

class Promotion {
  final String couponCode;
  final String name;
  final bool enabled;
  final List<ConfigurableOperation> actions;
  final List<ConfigurableOperation> conditions;

  Promotion({
    required this.couponCode,
    required this.name,
    required this.enabled,
    required this.actions,
    required this.conditions,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      couponCode: json['couponCode'] ?? '',
      name: json['name'] ?? '',
      enabled: json['enabled'] ?? false,
      actions: json['actions'] != null
          ? List<ConfigurableOperation>.from(json['actions'].map((x) => ConfigurableOperation.fromJson(x)))
          : [],
      conditions: json['conditions'] != null
          ? List<ConfigurableOperation>.from(json['conditions'].map((x) => ConfigurableOperation.fromJson(x)))
          : [],
    );
  }
}

class ConfigurableOperation {
  final List<ConfigArg> args;
  final String code;

  ConfigurableOperation({
    required this.args,
    required this.code,
  });

  factory ConfigurableOperation.fromJson(Map<String, dynamic> json) {
    return ConfigurableOperation(
      args: json['args'] != null
          ? List<ConfigArg>.from(json['args'].map((x) => ConfigArg.fromJson(x)))
          : [],
      code: json['code'] ?? '',
    );
  }
}

class ConfigArg {
  final String name;
  final String value;

  ConfigArg({
    required this.name,
    required this.value,
  });

  factory ConfigArg.fromJson(Map<String, dynamic> json) {
    return ConfigArg(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class Order {
  final String id;
  final String code;
  final String state;
  final bool active;
  final List<String> couponCodes;
  final List<Promotion> promotions;
  final List<OrderLine> lines;
  final int totalQuantity;
  final double subTotal;
  final double subTotalWithTax;
  final double total;
  final double totalWithTax;
  final double shipping;
  final double shippingWithTax;

  Order({
    required this.id,
    required this.code,
    required this.state,
    required this.active,
    required this.couponCodes,
    required this.promotions,
    required this.lines,
    required this.totalQuantity,
    required this.subTotal,
    required this.subTotalWithTax,
    required this.total,
    required this.totalWithTax,
    required this.shipping,
    required this.shippingWithTax,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      code: json['code'],
      state: json['state'],
      active: json['active'],
      couponCodes: List<String>.from(json['couponCodes'] ?? []),
      promotions: json['promotions'] != null
          ? List<Promotion>.from(json['promotions'].map((x) => Promotion.fromJson(x)))
          : [],
      lines: json['lines'] != null
          ? List<OrderLine>.from(json['lines'].map((x) => OrderLine.fromJson(x)))
          : [],
      totalQuantity: json['totalQuantity'] is int ? json['totalQuantity'] : int.parse(json['totalQuantity'].toString()),
      subTotal: (json['subTotal'] as num).toDouble(),
      subTotalWithTax: (json['subTotalWithTax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      totalWithTax: (json['totalWithTax'] as num).toDouble(),
      shipping: (json['shipping'] as num?)?.toDouble() ?? 0.0,
      shippingWithTax: (json['shippingWithTax'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
class ErrorResult {
  final String errorCode;
  final String message;

  ErrorResult({required this.errorCode, required this.message});

  factory ErrorResult.fromJson(Map<String, dynamic> json) {
    return ErrorResult(
      errorCode: json['errorCode'],
      message: json['message'],
    );
  }
}

