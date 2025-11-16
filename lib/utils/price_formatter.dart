/// Utility class for formatting prices consistently across the app.
/// GraphQL responses already return prices in base currency units (rupees).
/// Always prefix amounts with `Rs`.
class PriceFormatter {
  /// Formats a monetary amount represented as an integer (Vendure returns paise).
  /// Example: 12000 -> Rs 120
  static String formatPrice(int price) {
    return _format(price / 100);
  }

  /// Formats a monetary amount represented as a double (Vendure returns paise as double).
  static String formatPriceFromDouble(double price) {
    return _format(price / 100);
  }

  static String _format(double amount) {
    final bool isWholeNumber = (amount % 1).abs() < 0.0001;
    final String value =
        isWholeNumber ? amount.toInt().toString() : amount.toStringAsFixed(2);
    return 'Rs $value';
  }
}
