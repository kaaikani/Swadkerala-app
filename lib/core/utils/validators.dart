/// Utility class for common validation functions
class Validators {
  /// Validate email address
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate phone number (Indian format)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and special characters
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length != 10) {
      return 'Phone number must be 10 digits';
    }

    if (!cleaned.startsWith(RegExp(r'[6-9]'))) {
      return 'Phone number must start with 6, 7, 8, or 9';
    }

    return null;
  }

  /// Validate required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }
    return null;
  }

  /// Validate password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validate confirm password
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate PIN code (Indian format)
  static String? pinCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN code is required';
    }

    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length != 6) {
      return 'PIN code must be 6 digits';
    }

    return null;
  }

  /// Validate numeric value
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a number';
    }

    return null;
  }

  /// Validate positive number
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numericError = numeric(value, fieldName: fieldName);
    if (numericError != null) return numericError;

    final num = double.parse(value!);
    if (num <= 0) {
      return '${fieldName ?? 'This field'} must be greater than 0';
    }

    return null;
  }

  /// Validate loyalty points input
  static String? loyaltyPoints(String? value, int maxPoints) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final numericError = numeric(value, fieldName: 'Loyalty points');
    if (numericError != null) return numericError;

    final points = int.parse(value);
    if (points < 0) {
      return 'Loyalty points cannot be negative';
    }

    if (points > maxPoints) {
      return 'You can only use up to $maxPoints points';
    }

    return null;
  }

  /// Validate address fields
  static String? addressLine(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address line is required';
    }

    if (value.trim().length < 10) {
      return 'Address must be at least 10 characters';
    }

    return null;
  }

  /// Validate city name
  static String? city(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }

    if (value.trim().length < 2) {
      return 'City name must be at least 2 characters';
    }

    return null;
  }

  /// Validate state name
  static String? state(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'State is required';
    }

    if (value.trim().length < 2) {
      return 'State name must be at least 2 characters';
    }

    return null;
  }

  /// Combine multiple validators
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) return error;
    }
    return null;
  }
}








