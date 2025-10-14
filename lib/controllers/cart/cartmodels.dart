class Asset {
  final int id;
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
      id: json['id'],
      width: json['width'],
      height: json['height'],
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
    return FocalPoint(x: json['x'], y: json['y']);
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
      amount: json['amount'].toDouble(),
      amountWithTax: json['amountWithTax'].toDouble(),
      description: json['description'],
      adjustmentSource: json['adjustmentSource'],
      type: json['type'],
    );
  }
}
class ProductVariant {
  final int id;
  final String name;

  ProductVariant({required this.id, required this.name});

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      name: json['name'],
    );
  }
}
class OrderLine {
  final int id;
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
      id: json['id'],
      featuredAsset: json['featuredAsset'] != null ? Asset.fromJson(json['featuredAsset']) : null,
      unitPrice: json['unitPrice'].toDouble(),
      unitPriceWithTax: json['unitPriceWithTax'].toDouble(),
      quantity: json['quantity'],
      linePriceWithTax: json['linePriceWithTax'].toDouble(),
      discountedLinePriceWithTax: json['discountedLinePriceWithTax'].toDouble(),
      productVariant: ProductVariant.fromJson(json['productVariant']),
      discounts: json['discounts'] != null
          ? List<Discount>.from(json['discounts'].map((x) => Discount.fromJson(x)))
          : [],
    );
  }
}
class Order {
  final int id;
  final String code;
  final String state;
  final bool active;
  final List<String> couponCodes;
  final List<OrderLine> lines;
  final int totalQuantity;
  final double subTotal;
  final double subTotalWithTax;
  final double total;
  final double totalWithTax;

  Order({
    required this.id,
    required this.code,
    required this.state,
    required this.active,
    required this.couponCodes,
    required this.lines,
    required this.totalQuantity,
    required this.subTotal,
    required this.subTotalWithTax,
    required this.total,
    required this.totalWithTax,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      code: json['code'],
      state: json['state'],
      active: json['active'],
      couponCodes: List<String>.from(json['couponCodes'] ?? []),
      lines: json['lines'] != null
          ? List<OrderLine>.from(json['lines'].map((x) => OrderLine.fromJson(x)))
          : [],
      totalQuantity: json['totalQuantity'],
      subTotal: json['subTotal'].toDouble(),
      subTotalWithTax: json['subTotalWithTax'].toDouble(),
      total: json['total'].toDouble(),
      totalWithTax: json['totalWithTax'].toDouble(),
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

