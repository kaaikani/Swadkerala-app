
/// Customer profile model
class CustomerProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String phoneNumber;
  final bool verified;
  final int? loyaltyPoints;

  CustomerProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.verified,
    this.loyaltyPoints,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {

    final phone = json['phoneNumber'];

    // Extract loyalty points safely from customFields
    int? loyaltyPoints;
    if (json['customFields'] != null && json['customFields'] is Map<String, dynamic>) {
      loyaltyPoints = json['customFields']['loyaltyPointsAvailable'] as int?;
    }

    return CustomerProfile(
      id: json['id'] as String? ?? '', // fallback to empty string if null
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      emailAddress: json['emailAddress'] as String? ?? '',
      phoneNumber: phone is String
          ? phone
          : phone is Map<String, dynamic>
          ? phone['number'] ?? ''
          : '',
      verified: json['verified'] as bool? ?? false,
      loyaltyPoints: loyaltyPoints,
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'verified': verified,
      if (loyaltyPoints != null) 'loyaltyPoints': loyaltyPoints,
    };
  }

  String get fullName => '$firstName $lastName'.trim();

  @override
  String toString() => 'CustomerProfile(name: $fullName, phone: $phoneNumber, points: $loyaltyPoints)';
}

/// Address model
class CustomerAddress {
  final String? id;
  final String fullName;
  final String streetLine1;
  final String? streetLine2;
  final String city;
  final String? province;
  final String postalCode;
  final String country;
  final String? phoneNumber;
  final bool defaultShippingAddress;
  final bool defaultBillingAddress;

  CustomerAddress({
    this.id,
    required this.fullName,
    required this.streetLine1,
    this.streetLine2,
    required this.city,
    this.province,
    required this.postalCode,
    required this.country,
    this.phoneNumber,
    this.defaultShippingAddress = false,
    this.defaultBillingAddress = false,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    // Handle country safely
    String countryName = 'India';
    if (json['country'] != null) {
      if (json['country'] is String) {
        countryName = json['country'];
      } else if (json['country'] is Map<String, dynamic>) {
        countryName = json['country']['name']?.toString() ?? 'India';
      }
    }

    return CustomerAddress(
      id: json['id']?.toString(),                           // safe conversion
      fullName: json['fullName']?.toString() ?? '',         // default empty string
      streetLine1: json['streetLine1']?.toString() ?? '',   // default empty string
      streetLine2: json['streetLine2']?.toString(),         // nullable
      city: json['city']?.toString() ?? '',                 // default empty string
      province: json['province']?.toString(),               // nullable
      postalCode: json['postalCode']?.toString() ?? '',     // default empty string
      country: countryName,
      phoneNumber: json['phoneNumber']?.toString(),         // nullable
      defaultShippingAddress: json['defaultShippingAddress'] as bool? ?? false,
      defaultBillingAddress: json['defaultBillingAddress'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    String safeString(String? value) => value ?? '';

    return {
      'id': safeString(id),                 // send empty string if null
      'fullName': fullName,
      'streetLine1': streetLine1,
      'streetLine2': safeString(streetLine2),
      'city': city,
      'province': safeString(province),
      'postalCode': postalCode,
      'country': country,
      'phoneNumber': safeString(phoneNumber),
      'defaultShippingAddress': defaultShippingAddress,
      'defaultBillingAddress': defaultBillingAddress,
    };
  }

  CustomerAddress copyWith({
    String? id,
    String? fullName,
    String? streetLine1,
    String? streetLine2,
    String? city,
    String? province,
    String? postalCode,
    String? country,
    String? phoneNumber,
    bool? defaultShippingAddress,
    bool? defaultBillingAddress,
  }) {
    return CustomerAddress(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      streetLine1: streetLine1 ?? this.streetLine1,
      streetLine2: streetLine2 ?? this.streetLine2,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      defaultShippingAddress: defaultShippingAddress ?? this.defaultShippingAddress,
      defaultBillingAddress: defaultBillingAddress ?? this.defaultBillingAddress,
    );
  }

  @override
  String toString() => 'Address($city, $postalCode)';
}

