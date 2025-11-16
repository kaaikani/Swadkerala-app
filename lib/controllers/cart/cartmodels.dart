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
      width: json['width'] is int
          ? json['width']
          : int.parse(json['width'].toString()),
      height: json['height'] is int
          ? json['height']
          : int.parse(json['height'].toString()),
      name: json['name'],
      preview: json['preview'],
      focalPoint: json['focalPoint'] != null
          ? FocalPoint.fromJson(json['focalPoint'])
          : null,
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
  final String? stockLevel;
  final double? price;

  ProductVariant({
    required this.id,
    required this.name,
    this.stockLevel,
    this.price,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    return ProductVariant(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      stockLevel: json['stockLevel']?.toString(),
      price: parseDouble(json['price']),
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
  final bool isAvailable;
  final String? unavailableReason;

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
    required this.isAvailable,
    required this.unavailableReason,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value == null) return true;
      return value.toString().toLowerCase() == 'true';
    }

    return OrderLine(
      id: json['id'].toString(),
      featuredAsset: json['featuredAsset'] != null
          ? Asset.fromJson(json['featuredAsset'])
          : null,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      unitPriceWithTax: (json['unitPriceWithTax'] as num).toDouble(),
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.parse(json['quantity'].toString()),
      linePriceWithTax: (json['linePriceWithTax'] as num).toDouble(),
      discountedLinePriceWithTax:
          (json['discountedLinePriceWithTax'] as num).toDouble(),
      productVariant: ProductVariant.fromJson(json['productVariant']),
      discounts: json['discounts'] != null
          ? List<Discount>.from(
              json['discounts'].map((x) => Discount.fromJson(x)))
          : [],
      isAvailable: parseBool(json['isAvailable']),
      unavailableReason: json['unavailableReason']?.toString(),
    );
  }
}

class ValidationStatus {
  final bool isValid;
  final bool hasUnavailableItems;
  final int totalUnavailableItems;
  final List<UnavailableItem> unavailableItems;

  ValidationStatus({
    required this.isValid,
    required this.hasUnavailableItems,
    required this.totalUnavailableItems,
    required this.unavailableItems,
  });

  factory ValidationStatus.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value == null) return false;
      return value.toString().toLowerCase() == 'true';
    }

    return ValidationStatus(
      isValid: parseBool(json['isValid']),
      hasUnavailableItems: parseBool(json['hasUnavailableItems']),
      totalUnavailableItems: parseInt(json['totalUnavailableItems']),
      unavailableItems: (json['unavailableItems'] as List<dynamic>?)
              ?.map((e) => UnavailableItem.fromJson(e))
              .toList() ??
          const [],
    );
  }
}

class UnavailableItem {
  final String orderLineId;
  final String productName;
  final String? variantName;
  final String? reason;

  UnavailableItem({
    required this.orderLineId,
    required this.productName,
    this.variantName,
    this.reason,
  });

  factory UnavailableItem.fromJson(Map<String, dynamic> json) {
    return UnavailableItem(
      orderLineId: json['orderLineId']?.toString() ?? '',
      productName: json['productName'] ?? '',
      variantName: json['variantName'],
      reason: json['reason'],
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
          ? List<ConfigurableOperation>.from(
              json['actions'].map((x) => ConfigurableOperation.fromJson(x)))
          : [],
      conditions: json['conditions'] != null
          ? List<ConfigurableOperation>.from(
              json['conditions'].map((x) => ConfigurableOperation.fromJson(x)))
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
  final ValidationStatus? validationStatus;

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
    this.validationStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    double parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0.0;
    }

    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value == null) return false;
      return value.toString().toLowerCase() == 'true';
    }

    final linesRaw = json['lines'] as List<dynamic>?;
    final lines = linesRaw != null
        ? List<OrderLine>.from(linesRaw.map((e) => OrderLine.fromJson(e)))
        : <OrderLine>[];
    final derivedLineQty = lines.fold<int>(
        0, (previousValue, element) => previousValue + element.quantity);

    final parsedTotalQty = parseInt(json['totalQuantity']);
    final totalQty = parsedTotalQty ?? derivedLineQty;

    return Order(
      id: (json['id'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      active: parseBool(json['active']),
      couponCodes: (json['couponCodes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      promotions: (json['promotions'] as List<dynamic>?)
              ?.map((x) => Promotion.fromJson(x))
              .toList() ??
          const [],
      lines: lines,
      totalQuantity: totalQty,
      subTotal: parseDouble(json['subTotal']),
      subTotalWithTax: parseDouble(json['subTotalWithTax']),
      total: parseDouble(json['total']),
      totalWithTax: parseDouble(json['totalWithTax']),
      shipping: parseDouble(json['shipping']),
      shippingWithTax: parseDouble(json['shippingWithTax']),
      validationStatus: json['validationStatus'] != null
          ? ValidationStatus.fromJson(json['validationStatus'])
          : null,
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
