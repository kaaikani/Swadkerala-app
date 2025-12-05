
class CustomerModel {
  final String id;
  final String emailAddress;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final CustomerCustomFields? customFields;
  final List<AddressModel> addresses;
  final OrderListModel? orders;

  CustomerModel({
    required this.id,
    required this.emailAddress,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.customFields,
    required this.addresses,
    this.orders,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    try {
      return CustomerModel(
        id: json['id']?.toString() ?? '',
        emailAddress: json['emailAddress']?.toString() ?? '',
        firstName: json['firstName']?.toString() ?? '',
        lastName: json['lastName']?.toString() ?? '',
        phoneNumber: json['phoneNumber']?.toString(),
        customFields: json['customFields'] != null && json['customFields'] is Map<String, dynamic>
          ? CustomerCustomFields.fromJson(json['customFields']) 
          : null,
        addresses: (json['addresses'] as List<dynamic>?)
          ?.map((address) => AddressModel.fromJson(address is Map<String, dynamic> 
              ? address 
              : {}))
          .toList() ?? [],
        orders: json['orders'] != null && json['orders'] is Map<String, dynamic>
          ? OrderListModel.fromJson(json['orders']) 
          : null,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class CustomerCustomFields {
  final int? loyaltyPointsAvailable;

  CustomerCustomFields({
    this.loyaltyPointsAvailable,
  });

  factory CustomerCustomFields.fromJson(Map<String, dynamic> json) {
    return CustomerCustomFields(
      loyaltyPointsAvailable: json['loyaltyPointsAvailable'],
    );
  }
}

class AddressModel {
  final String id;
  final String fullName;
  final String streetLine1;
  final String streetLine2;
  final String city;
  final String province;
  final String postalCode;
  final String phoneNumber;
  final String company;
  final bool defaultShippingAddress;
  final bool defaultBillingAddress;
  final CountryModel country;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.streetLine1,
    required this.streetLine2,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.phoneNumber,
    required this.company,
    required this.defaultShippingAddress,
    required this.defaultBillingAddress,
    required this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      streetLine1: json['streetLine1'] ?? '',
      streetLine2: json['streetLine2'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      postalCode: json['postalCode'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      company: json['company'] ?? '',
      defaultShippingAddress: json['defaultShippingAddress'] ?? false,
      defaultBillingAddress: json['defaultBillingAddress'] ?? false,
      country: CountryModel.fromJson(json['country'] ?? {}),
    );
  }

  String get fullAddress {
    final parts = <String>[];
    if (streetLine1.isNotEmpty) parts.add(streetLine1);
    if (streetLine2.isNotEmpty) parts.add(streetLine2);
    if (city.isNotEmpty) parts.add(city);
    if (province.isNotEmpty) parts.add(province);
    if (postalCode.isNotEmpty) parts.add(postalCode);
    if (country.name.isNotEmpty) parts.add(country.name);
    return parts.join(', ');
  }
}

class CountryModel {
  final String id;
  final String name;
  final String code;
  final String languageCode;

  CountryModel({
    required this.id,
    required this.name,
    required this.code,
    required this.languageCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      languageCode: json['languageCode'] ?? '',
    );
  }
}

class OrderListModel {
  final int totalItems;
  final List<OrderModel> items;

  OrderListModel({
    required this.totalItems,
    required this.items,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderListModel(
        totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
        items: (json['items'] as List<dynamic>?)
          ?.map((order) => OrderModel.fromJson(order is Map<String, dynamic> 
              ? order 
              : {}))
          .toList() ?? [],
      );
    } catch (e) {
      rethrow;
    }
  }
}

class OrderModel {
  final String id;
  final String code;
  final String currencyCode;
  final DateTime orderPlacedAt;
  final bool active;
  final String state;
  final int totalQuantity;
  final double totalWithTax;
  final List<OrderLineModel> lines;
  final List<DiscountModel> discounts;
  final List<SurchargeModel> surcharges;
  final List<String> couponCodes;
  final List<PaymentModel> payments;
  final CustomerModel? customer;
  final AddressModel? shippingAddress;
  final AddressModel? billingAddress;
  final OrderCustomFields? customFields;

  OrderModel({
    required this.id,
    required this.code,
    required this.currencyCode,
    required this.orderPlacedAt,
    required this.active,
    required this.state,
    required this.totalQuantity,
    required this.totalWithTax,
    required this.lines,
    required this.discounts,
    required this.surcharges,
    required this.couponCodes,
    required this.payments,
    this.customer,
    this.shippingAddress,
    this.billingAddress,
    this.customFields,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    try {

      // Parse basic fields
      final id = json['id']?.toString() ?? '';
      final code = json['code']?.toString() ?? '';
      final currencyCode = json['currencyCode']?.toString() ?? '';
      final orderPlacedAt = DateTime.tryParse(json['orderPlacedAt']?.toString() ?? '') ?? DateTime.now();
      final active = json['active'] ?? false;
      final state = json['state']?.toString() ?? '';
      final totalQuantity = (json['totalQuantity'] as num?)?.toInt() ?? 0;
      final totalWithTax = (json['totalWithTax'] as num?)?.toDouble() ?? 0.0;
      

      // Parse lines
      List<OrderLineModel> lines = [];
      try {
        lines = (json['lines'] as List<dynamic>?)
          ?.map((line) => OrderLineModel.fromJson(line is Map<String, dynamic> 
              ? line 
              : {}))
          .toList() ?? [];
      } catch (e) {
        lines = [];
      }
      
      // Parse discounts
      List<DiscountModel> discounts = [];
      try {
        discounts = (json['discounts'] as List<dynamic>?)
          ?.map((discount) => DiscountModel.fromJson(discount is Map<String, dynamic> 
              ? discount 
              : {}))
          .toList() ?? [];
      } catch (e) {
        discounts = [];
      }
      
      // Parse surcharges
      List<SurchargeModel> surcharges = [];
      try {
        surcharges = (json['surcharges'] as List<dynamic>?)
          ?.map((surcharge) => SurchargeModel.fromJson(surcharge is Map<String, dynamic> 
              ? surcharge 
              : {}))
          .toList() ?? [];
      } catch (e) {
        surcharges = [];
      }
      
      // Parse coupon codes
      List<String> couponCodes = [];
      try {
        couponCodes = (json['couponCodes'] as List<dynamic>?)
          ?.map((code) => code.toString())
          .toList() ?? [];
      } catch (e) {
        couponCodes = [];
      }
      
      // Parse payments
      List<PaymentModel> payments = [];
      try {
        payments = (json['payments'] as List<dynamic>?)
          ?.map((payment) => PaymentModel.fromJson(payment is Map<String, dynamic> 
              ? payment 
              : {}))
          .toList() ?? [];
      } catch (e) {
        payments = [];
      }
      
      // Parse customer
      CustomerModel? customer;
      try {
        customer = json['customer'] != null && json['customer'] is Map<String, dynamic>
          ? CustomerModel.fromJson(json['customer']) 
          : null;

      } catch (e) {
        customer = null;
      }
      
      // Parse shipping address
      AddressModel? shippingAddress;
      try {
        if (json['shippingAddress'] != null) {
          if (json['shippingAddress'] is Map<String, dynamic>) {
            shippingAddress = AddressModel.fromJson(json['shippingAddress']);
          } else {
            shippingAddress = null;
          }
        } else {
          shippingAddress = null;
        }
      } catch (e) {
        shippingAddress = null;
      }
      
      // Parse billing address
      AddressModel? billingAddress;
      try {
        if (json['billingAddress'] != null) {
          if (json['billingAddress'] is Map<String, dynamic>) {
            billingAddress = AddressModel.fromJson(json['billingAddress']);
          } else {
            billingAddress = null;
          }
        } else {
          billingAddress = null;
        }
      } catch (e) {
        billingAddress = null;
      }
      
      // Parse custom fields
      OrderCustomFields? customFields;
      try {
        if (json['customFields'] != null) {
          if (json['customFields'] is Map<String, dynamic>) {
            customFields = OrderCustomFields.fromJson(json['customFields']);
          } else {
            customFields = null;
          }
        } else {
          customFields = null;
        }
      } catch (e) {
        customFields = null;
      }
      
      return OrderModel(
        id: id,
        code: code,
        currencyCode: currencyCode,
        orderPlacedAt: orderPlacedAt,
        active: active,
        state: state,
        totalQuantity: totalQuantity,
        totalWithTax: totalWithTax,
        lines: lines,
        discounts: discounts,
        surcharges: surcharges,
        couponCodes: couponCodes,
        payments: payments,
        customer: customer,
        shippingAddress: shippingAddress,
        billingAddress: billingAddress,
        customFields: customFields,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class OrderLineModel {
  final String id;
  final int quantity;
  final ProductVariantModel productVariant;
  final AssetModel? featuredAsset;

  OrderLineModel({
    required this.id,
    required this.quantity,
    required this.productVariant,
    this.featuredAsset,
  });

  factory OrderLineModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderLineModel(
        id: json['id']?.toString() ?? '',
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        productVariant: json['productVariant'] != null && json['productVariant'] is Map<String, dynamic>
          ? ProductVariantModel.fromJson(json['productVariant']) 
          : ProductVariantModel(name: ''),
        featuredAsset: json['featuredAsset'] != null && json['featuredAsset'] is Map<String, dynamic>
          ? AssetModel.fromJson(json['featuredAsset']) 
          : null,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class ProductVariantModel {
  final String name;

  ProductVariantModel({
    required this.name,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    try {
      return ProductVariantModel(
        name: json['name']?.toString() ?? '',
      );
    } catch (e) {
      return ProductVariantModel(name: '');
    }
  }
}

class AssetModel {
  final String name;
  final String preview;

  AssetModel({
    required this.name,
    required this.preview,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    try {
      return AssetModel(
        name: json['name']?.toString() ?? '',
        preview: json['preview']?.toString() ?? '',
      );
    } catch (e) {
      return AssetModel(name: '', preview: '');
    }
  }
}

class DiscountModel {
  final double amount;

  DiscountModel({
    required this.amount,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    try {
      return DiscountModel(
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      return DiscountModel(amount: 0.0);
    }
  }
}

class SurchargeModel {
  final double price;
  final double priceWithTax;

  SurchargeModel({
    required this.price,
    required this.priceWithTax,
  });

  factory SurchargeModel.fromJson(Map<String, dynamic> json) {
    try {
      return SurchargeModel(
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        priceWithTax: (json['priceWithTax'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      return SurchargeModel(price: 0.0, priceWithTax: 0.0);
    }
  }
}

class PaymentModel {
  final String state;
  final DateTime createdAt;
  final String method;
  final double amount;
  final String? transactionId;

  PaymentModel({
    required this.state,
    required this.createdAt,
    required this.method,
    required this.amount,
    this.transactionId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    try {
      return PaymentModel(
        state: json['state']?.toString() ?? '',
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
        method: json['method']?.toString() ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        transactionId: json['transactionId']?.toString(),
      );
    } catch (e) {
      return PaymentModel(
        state: '',
        createdAt: DateTime.now(),
        method: '',
        amount: 0.0,
        transactionId: null,
      );
    }
  }
}

class OrderCustomFields {
  final int? loyaltyPointsUsed;
  final int? loyaltyPointsEarned;
  final String? otherInstructions;

  OrderCustomFields({
    this.loyaltyPointsUsed,
    this.loyaltyPointsEarned,
    this.otherInstructions,
  });

  factory OrderCustomFields.fromJson(Map<String, dynamic> json) {
    try {
      return OrderCustomFields(
        loyaltyPointsUsed: _parseIntField(json['loyaltyPointsUsed']),
        loyaltyPointsEarned: _parseIntField(json['loyaltyPointsEarned']),
        otherInstructions: json['otherInstructions']?.toString(),
      );
    } catch (e) {
      return OrderCustomFields();
    }
  }

  static int? _parseIntField(dynamic value) {
    if (value == null) return null;
    
    try {
      if (value is int) {
        return value;
      } else if (value is num) {
        return value.toInt();
      } else if (value is String) {
        return int.tryParse(value);
      } else if (value is bool) {
        return value ? 1 : 0;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
