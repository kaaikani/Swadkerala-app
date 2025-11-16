import 'package:flutter/foundation.dart';

class OrderModel {
  final String id;
  final String code;
  final String state;
  final bool active;
  final int totalQuantity;
  final int subTotal;
  final int subTotalWithTax;
  final int total;
  final int totalWithTax;
  final int shipping;
  final int shippingWithTax;
  final List<OrderLine> lines;
  final List<String> couponCodes;
  final List<Discount> discounts;
  final List<ShippingLine> shippingLines;
  final String? currencyCode;
  final DateTime? orderPlacedAt;
  final OrderAddress? shippingAddress;
  final OrderAddress? billingAddress;
  final List<Payment> payments;
  final OrderCustomFields? customFields;

  OrderModel({
    required this.id,
    required this.code,
    required this.state,
    required this.active,
    required this.totalQuantity,
    required this.subTotal,
    required this.subTotalWithTax,
    required this.total,
    required this.totalWithTax,
    required this.shipping,
    required this.shippingWithTax,
    required this.lines,
    required this.couponCodes,
    required this.discounts,
    required this.shippingLines,
    this.currencyCode,
    this.orderPlacedAt,
    this.shippingAddress,
    this.billingAddress,
    required this.payments,
    this.customFields,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      state: json['state'] ?? '',
      active: json['active'] ?? false,
      totalQuantity: (json['totalQuantity'] is int) 
          ? json['totalQuantity'] 
          : (json['totalQuantity'] as num?)?.toInt() ?? 0,
      subTotal: (json['subTotal'] is int) 
          ? json['subTotal'] 
          : (json['subTotal'] as num?)?.toInt() ?? 0,
      subTotalWithTax: (json['subTotalWithTax'] is int) 
          ? json['subTotalWithTax'] 
          : (json['subTotalWithTax'] as num?)?.toInt() ?? 0,
      total: (json['total'] is int) 
          ? json['total'] 
          : (json['total'] as num?)?.toInt() ?? 0,
      totalWithTax: (json['totalWithTax'] is int) 
          ? json['totalWithTax'] 
          : (json['totalWithTax'] as num?)?.toInt() ?? 0,
      shipping: (json['shipping'] is int) 
          ? json['shipping'] 
          : (json['shipping'] as num?)?.toInt() ?? 0,
      shippingWithTax: (json['shippingWithTax'] is int) 
          ? json['shippingWithTax'] 
          : (json['shippingWithTax'] as num?)?.toInt() ?? 0,
      lines: (json['lines'] as List<dynamic>?)
              ?.map((line) => OrderLine.fromJson(line))
              .toList() ??
          [],
      couponCodes: (json['couponCodes'] as List<dynamic>?)?.cast<String>() ?? [],
      discounts: (json['discounts'] as List<dynamic>?)
              ?.map((d) => Discount.fromJson(d))
              .toList() ??
          [],
      shippingLines: (json['shippingLines'] as List<dynamic>?)
              ?.map((sl) => ShippingLine.fromJson(sl))
              .toList() ??
          [],
      currencyCode: json['currencyCode'],
      orderPlacedAt: json['orderPlacedAt'] != null 
          ? DateTime.tryParse(json['orderPlacedAt']) 
          : null,
      shippingAddress: _parseAddress(json['shippingAddress'], 'shipping'),
      billingAddress: _parseAddress(json['billingAddress'], 'billing'),
      payments: (json['payments'] as List<dynamic>?)
              ?.map((p) => Payment.fromJson(p))
              .toList() ??
          [],
      customFields: _parseCustomFields(json['customFields']),
    );
  }

  static OrderAddress? _parseAddress(dynamic addressData, String type) {
    if (addressData == null) return null;
    
    try {
      if (addressData is Map<String, dynamic>) {
        return OrderAddress.fromJson(addressData);
      } else {
        debugPrint('[OrderModel] $type address is not a Map, got: ${addressData.runtimeType}, value: $addressData');
        return null;
      }
    } catch (e) {
      debugPrint('[OrderModel] Error parsing $type address: $e');
      return null;
    }
  }

  static OrderCustomFields? _parseCustomFields(dynamic customFieldsData) {
    if (customFieldsData == null) return null;
    
    try {
      if (customFieldsData is Map<String, dynamic>) {
        debugPrint('[OrderModel] Custom fields data: $customFieldsData');
        return OrderCustomFields.fromJson(customFieldsData);
      } else {
        debugPrint('[OrderModel] Custom fields is not a Map, got: ${customFieldsData.runtimeType}, value: $customFieldsData');
        return null;
      }
    } catch (e) {
      debugPrint('[OrderModel] Error parsing custom fields: $e');
      return null;
    }
  }

}

class OrderLine {
  final String id;
  final int quantity;
  final int unitPrice;
  final int unitPriceWithTax;
  final int linePriceWithTax;
  final int discountedLinePriceWithTax;
  final ProductVariant productVariant;
  final Asset? featuredAsset;
  final List<Discount> discounts;

  OrderLine({
    required this.id,
    required this.quantity,
    required this.unitPrice,
    required this.unitPriceWithTax,
    required this.linePriceWithTax,
    required this.discountedLinePriceWithTax,
    required this.productVariant,
    this.featuredAsset,
    required this.discounts,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      id: json['id'] ?? '',
      quantity: (json['quantity'] is int) 
          ? json['quantity'] 
          : (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] is int) 
          ? json['unitPrice'] 
          : (json['unitPrice'] as num?)?.toInt() ?? 0,
      unitPriceWithTax: (json['unitPriceWithTax'] is int) 
          ? json['unitPriceWithTax'] 
          : (json['unitPriceWithTax'] as num?)?.toInt() ?? 0,
      linePriceWithTax: (json['linePriceWithTax'] is int) 
          ? json['linePriceWithTax'] 
          : (json['linePriceWithTax'] as num?)?.toInt() ?? 0,
      discountedLinePriceWithTax: (json['discountedLinePriceWithTax'] is int) 
          ? json['discountedLinePriceWithTax'] 
          : (json['discountedLinePriceWithTax'] as num?)?.toInt() ?? 0,
      productVariant: ProductVariant.fromJson(json['productVariant'] ?? {}),
      featuredAsset: json['featuredAsset'] != null
          ? Asset.fromJson(json['featuredAsset'])
          : null,
      discounts: (json['discounts'] as List<dynamic>?)
              ?.map((d) => Discount.fromJson(d))
              .toList() ??
          [],
    );
  }
}

class ProductVariant {
  final String id;
  final String name;

  ProductVariant({
    required this.id,
    required this.name,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Asset {
  final String id;
  final String name;
  final String preview;
  final int? width;
  final int? height;

  Asset({
    required this.id,
    required this.name,
    required this.preview,
    this.width,
    this.height,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      preview: json['preview'] ?? '',
      width: json['width'] != null 
          ? ((json['width'] is int) ? json['width'] : (json['width'] as num).toInt())
          : null,
      height: json['height'] != null 
          ? ((json['height'] is int) ? json['height'] : (json['height'] as num).toInt())
          : null,
    );
  }
}

class Discount {
  final int amount;
  final int amountWithTax;
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
      amount: (json['amount'] is int) 
          ? json['amount'] 
          : (json['amount'] as num?)?.toInt() ?? 0,
      amountWithTax: (json['amountWithTax'] is int) 
          ? json['amountWithTax'] 
          : (json['amountWithTax'] as num?)?.toInt() ?? 0,
      description: json['description'] ?? '',
      adjustmentSource: json['adjustmentSource'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class ShippingLine {
  final int priceWithTax;
  final ShippingMethodInfo shippingMethod;

  ShippingLine({
    required this.priceWithTax,
    required this.shippingMethod,
  });

  factory ShippingLine.fromJson(Map<String, dynamic> json) {
    return ShippingLine(
      priceWithTax: (json['priceWithTax'] is int) 
          ? json['priceWithTax'] 
          : (json['priceWithTax'] as num?)?.toInt() ?? 0,
      shippingMethod: ShippingMethodInfo.fromJson(json['shippingMethod'] ?? {}),
    );
  }
}

class ShippingMethodInfo {
  final String id;
  final String code;
  final String name;
  final String description;

  ShippingMethodInfo({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
  });

  factory ShippingMethodInfo.fromJson(Map<String, dynamic> json) {
    return ShippingMethodInfo(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class ShippingMethod {
  final String id;
  final String name;
  final String code;
  final String description;
  final int price;
  final int priceWithTax;

  ShippingMethod({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.price,
    required this.priceWithTax,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) {
    return ShippingMethod(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] is int) 
          ? json['price'] 
          : (json['price'] as num?)?.toInt() ?? 0,
      priceWithTax: (json['priceWithTax'] is int) 
          ? json['priceWithTax'] 
          : (json['priceWithTax'] as num?)?.toInt() ?? 0,
    );
  }
}

class PaymentMethod {
  final String id;
  final String code;
  final String? eligibilityMessage;
  final bool isEligible;

  PaymentMethod({
    required this.id,
    required this.code,
    this.eligibilityMessage,
    required this.isEligible,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      eligibilityMessage: json['eligibilityMessage'],
      isEligible: json['isEligible'] ?? false,
    );
  }
}

class ErrorResult {
  final String errorCode;
  final String message;

  ErrorResult({
    required this.errorCode,
    required this.message,
  });

  factory ErrorResult.fromJson(Map<String, dynamic> json) {
    return ErrorResult(
      errorCode: json['errorCode'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class RazorpayOrderResponse {
  final String razorpayOrderId;
  final String keyId;
  final String keySecret;

  RazorpayOrderResponse({
    required this.razorpayOrderId,
    required this.keyId,
    required this.keySecret,
  });

  factory RazorpayOrderResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderResponse(
      razorpayOrderId: json['razorpayOrderId'] ?? '',
      keyId: json['keyId'] ?? '',
      keySecret: json['keySecret'] ?? '',
    );
  }
}

class OrderAddress {
  final String fullName;
  final String? company;
  final String streetLine1;
  final String? streetLine2;
  final String city;
  final String? province;
  final String postalCode;
  final String? phoneNumber;
  final String? country;

  OrderAddress({
    required this.fullName,
    this.company,
    required this.streetLine1,
    this.streetLine2,
    required this.city,
    this.province,
    required this.postalCode,
    this.phoneNumber,
    this.country,
  });

  factory OrderAddress.fromJson(Map<String, dynamic> json) {
    return OrderAddress(
      fullName: json['fullName'] ?? '',
      company: json['company'],
      streetLine1: json['streetLine1'] ?? '',
      streetLine2: json['streetLine2'],
      city: json['city'] ?? '',
      province: json['province'],
      postalCode: json['postalCode'] ?? '',
      phoneNumber: json['phoneNumber'],
      country: json['country'],
    );
  }
}

class Payment {
  final String state;
  final String? createdAt;
  final String method;
  final int amount;
  final String? transactionId;

  Payment({
    required this.state,
    this.createdAt,
    required this.method,
    required this.amount,
    this.transactionId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      state: json['state'] ?? '',
      createdAt: json['createdAt'],
      method: json['method'] ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      transactionId: json['transactionId'],
    );
  }
}

class OrderCustomFields {
  final int? loyaltyPointsEarned;
  final int? loyaltyPointsUsed;
  final String? razorpayOrderId;
  final String? otherInstructions;
  final int? clientRequestToCancel;

  OrderCustomFields({
    this.loyaltyPointsEarned,
    this.loyaltyPointsUsed,
    this.razorpayOrderId,
    this.otherInstructions,
    this.clientRequestToCancel,
  });

  factory OrderCustomFields.fromJson(Map<String, dynamic> json) {
    return OrderCustomFields(
      loyaltyPointsEarned: _parseInt(json['loyaltyPointsEarned']),
      loyaltyPointsUsed: _parseInt(json['loyaltyPointsUsed']),
      razorpayOrderId: json['razorpay_order_id'],
      otherInstructions: json['otherInstructions'],
      clientRequestToCancel: _parseInt(json['clientRequestToCancel']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

