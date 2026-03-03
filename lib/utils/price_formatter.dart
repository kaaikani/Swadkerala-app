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
        isWholeNumber ? _addCommas(amount.toInt().toString()) : _addCommas(amount.toStringAsFixed(2));
    return '₹ $value';
  }

  /// Adds comma separators to a number string (e.g. 1000 -> 1,000, 20000 -> 20,000)
  static String _addCommas(String number) {
    final parts = number.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return parts.length > 1 ? '$intPart.${parts[1]}' : intPart;
  }

  /// Public helper to add commas to any number string
  static String addCommas(String number) => _addCommas(number);
}
