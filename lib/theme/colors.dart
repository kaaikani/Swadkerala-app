import 'package:flutter/material.dart';

/// Centralized color palette for the entire app
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFF11D15); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  
  // Secondary Colors
  static const Color secondary = Colors.red;
  static const Color secondaryLight = Colors.redAccent;
  static const Color accent = Color(0xFFFFA000);
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textLight = Colors.white;
  static const Color textDark = Colors.black87;
  static const Color textBlack = Colors.black;
  
  // Icon Colors
  static const Color icon = Colors.black;
  static const Color iconLight = Color(0xFF9CA3AF);
  static const Color iconDark = Colors.black87;
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // UI Element Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFE5E7EB);
  
  // Interactive Colors
  static const Color heartActive = Colors.redAccent;
  static const Color heartInactive = Colors.black;
  static const Color buttonText = Colors.white;
  static const Color link = Color(0xFF3B82F6);
  
  // Specific UI Colors
  static const Color inputFill = Color(0xFFF9FAFB);
  static const Color inputBorder = Color(0xFFE5E7EB);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowMedium = Color(0x1A000000);
  
  // Gradient Colors
  static const Color gradientStart = Color(0xFF6366F1);
  static const Color gradientEnd = Color(0xFF8B5CF6);
  
  // Special Colors
  static const Color transparent = Colors.transparent;
  static const Color overlay = Color(0x80000000);
  
  // Grey Shades
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);
  
  // Additional Colors for specific use cases
  static const Color blue = Colors.blue;
  static const Color blueLight = Color(0xFF60A5FA);
  static const Color green = Colors.green;
  static const Color greenLight = Color(0xFF34D399);
  static const Color orange = Colors.orange;
  static const Color orangeLight = Color(0xFFFB923C);
  static const Color purple = Colors.purple;
  static const Color purpleLight = Color(0xFFA78BFA);
  static const Color pink = Colors.pink;
  static const Color pinkLight = Color(0xFFF472B6);
  static const Color yellow = Colors.yellow;
  static const Color yellowLight = Color(0xFFFBBF24);
  
  // Method to get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
