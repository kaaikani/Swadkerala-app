import '../graphql/Customer.graphql.dart';

/// Extension methods for generated GraphQL types to add computed properties
/// that existed in manual models.

extension AddressExtensions on Query$GetActiveCustomer$activeCustomer$addresses {
  /// Returns a formatted full address string combining all address components.
  String get fullAddress {
    final parts = <String>[];
    if (streetLine1.isNotEmpty) parts.add(streetLine1);
    if (streetLine2 != null && streetLine2!.isNotEmpty) parts.add(streetLine2!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (postalCode != null && postalCode!.isNotEmpty) parts.add(postalCode!);
    if (country.name.isNotEmpty) parts.add(country.name);
    return parts.join(', ');
  }
}
