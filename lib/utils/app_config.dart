/// App configuration utility with hardcoded configuration values
class AppConfig {
  // Country Code
  static String get countryCode => '+91';
  
  // Currency
  static String get currencySymbol => 'Rs';
  static String get mrpLabel => 'M.R.P';
  
  // Phone Number (for phone calls)
  static String get phoneNumber => '7907816972';

  // Email ID
  static String get emailId => 'support@swadkerala.com';

  // WhatsApp Number
  static String get whatsappNumber => '7907816972';
  
  // Company Address
  static String get companyName => 'Galaxy Traders';
  static String get companyAddress => 'Karimannoor PO - 685581\nMannarathara - Kotta Road, Idukki Dist, Kerala';
  static String get companyAddressOneLine => 'Galaxy Traders, Karimannoor PO - 685581, Mannarathara - Kotta Road, Idukki Dist, Kerala';

  // Social Media Links
  static String get facebookUrl => 'https://www.facebook.com/profile.php?id=61584309481086';
  static String get instagramUrl => 'https://www.instagram.com/swadkerala.official/';
  static String get linkedinUrl => 'https://www.linkedin.com/company/kaaikani-official/';
  static String get youtubeUrl => 'https://www.youtube.com/@kaaikani?si=fJRcmofJI0oUJXx5';
  
  /// Format phone number with country code
  static String formatPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    
    // If phone already starts with country code, return as is
    if (phone.startsWith(countryCode)) {
      return phone;
    }
    
    // Remove any leading + or spaces
    String cleanedPhone = phone.replaceAll(RegExp(r'^[\+\s]+'), '');
    
    // Add country code if not present
    return '$countryCode $cleanedPhone';
  }
  
  /// Get phone number with country code for display
  static String get phoneNumberWithCode => formatPhoneNumber(phoneNumber);
}