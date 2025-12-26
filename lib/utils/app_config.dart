/// App configuration utility with hardcoded configuration values
class AppConfig {
  // Country Code
  static String get countryCode => '+91';
  
  // Currency
  static String get currencySymbol => 'Rs';
  static String get mrpLabel => 'M.R.P';
  
  // Phone Number (for phone calls)
  static String get phoneNumber => '1800 309 4983';
  
  // Email ID
  static String get emailId => 'kaaikanionline@gmail.com';
  
  // WhatsApp Number
  static String get whatsappNumber => '9894681385';
  
  // Social Media Links
  static String get facebookUrl => 'https://www.facebook.com/photo/?fbid=340348715422431&set=a.157658850358086';
  static String get instagramUrl => 'https://www.instagram.com/kaaikani.official/?hl=en';
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