import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

/// Zomato-inspired Theme - Vibrant red and orange palette
class AppColors {
  // Zomato Brand Colors
  static const Color zomatoRed = Color(0xFFE23744); // Zomato's signature red #E23744
  static const Color zomatoRedLight = Color(0xFFE85A63); // Lighter red for hover states
  static const Color zomatoRedDark = Color(0xFFCB2D3A); // Darker red for pressed states
  static const Color zomatoOrange = Color(0xFFFF6B35); // Zomato orange accent
  static const Color zomatoOrangeLight = Color(0xFFFF8C5A); // Light orange
  static const Color zomatoBackground = Color(0xFFFFFAFA); // Very light red/pink tint for backgrounds
  
  // Primary Colors (Zomato-inspired)
  static Color get primary => _isDarkMode ? Colors.grey[900]! : zomatoBackground;
  static Color get primaryLight => _isDarkMode ? Colors.grey[800]! : Color(0xFFFFFAFA);
  static Color get primaryDark => _isDarkMode ? Colors.grey[700]! : Color(0xFFFFE5E8);
  
  // Constant colors for text styles (always return these, not getters) - All black
  static const Color textPrimaryConst = Colors.black;
  static const Color textSecondaryConst = Colors.black87;
  static const Color textTertiaryConst = Colors.black54;
  static const Color textDarkConst = Colors.black;
  static const Color primaryConst = Color(0xFFFFFAFA);
  
  // Secondary Colors (Zomato-inspired)
  static Color get secondary => _isDarkMode ? Colors.grey[800]! : zomatoOrange;
  static Color get secondaryLight => _isDarkMode ? Colors.grey[700]! : zomatoOrangeLight;
  static Color get accent => _isDarkMode ? zomatoRed : zomatoRed;
  static Color get promoCard => _isDarkMode ? Colors.grey[800]! : Color(0xFFFFF0F2);
  
  // Background Colors
  static Color get background => _isDarkMode ? Colors.black : Colors.white; // Pure white like Zomato
  static Color get backgroundLight => _isDarkMode ? Colors.grey[900]! : zomatoBackground;
  static Color get surface => _isDarkMode ? Colors.grey[900]! : Colors.white;
  static Color get card {
    if (_isDarkMode) {
      return const Color(0xFF1A1A1A); // grey850 equivalent
    }
    return Colors.white;
  }
  
  // Text Colors - All black in light mode
  static Color get textPrimary => _isDarkMode ? Colors.white : Colors.black;
  static Color get textSecondary => _isDarkMode ? Colors.grey[400]! : Colors.black87;
  static Color get textTertiary => _isDarkMode ? Colors.grey[500]! : Colors.black54;
  static const Color textLight = Colors.white;
  static Color get textDark => _isDarkMode ? Colors.white : Colors.black;
  static Color get textBlack => _isDarkMode ? Colors.white : Colors.black;
  
  // Icon Colors
  static Color get icon => _isDarkMode ? Colors.white : Colors.black;
  static Color get iconLight => _isDarkMode ? Colors.grey[400]! : Color(0xFF9CA3AF);
  static Color get iconDark => _isDarkMode ? Colors.white : Colors.black87;
  
  // Status Colors (same for both modes)
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // UI Element Colors
  static Color get border => _isDarkMode ? Colors.grey[800]! : Color(0xFFE5E7EB);
  static Color get borderLight => _isDarkMode ? Colors.grey[700]! : Color(0xFFF3F4F6);
  static Color get divider => _isDarkMode ? Colors.grey[800]! : Color(0xFFE5E7EB);
  
  // Interactive Colors (Zomato-inspired)
  static Color get heartActive => zomatoRed;
  static Color get heartInactive => _isDarkMode ? Colors.grey[400]! : Colors.black;
  static const Color buttonText = Colors.white;
  static const Color button = zomatoRed; // Zomato red button
  static const Color buttonLight = zomatoRedLight; // Lighter red for hover
  static const Color buttonDark = zomatoRedDark; // Darker red for pressed
  static const Color link = Color(0xFF3B82F6);
  
  // Specific UI Colors
  static Color get inputFill => _isDarkMode ? Colors.grey[900]! : Color(0xFFF9FAFB);
  static Color get inputBorder => _isDarkMode ? Colors.grey[700]! : Color(0xFFE5E7EB);
  static Color get shadowLight => _isDarkMode ? Color(0x1AFFFFFF) : Color(0x0D000000);
  static Color get shadowMedium => _isDarkMode ? Color(0x2AFFFFFF) : Color(0x1A000000);
  
  // Gradient Colors (Zomato-inspired)
  static Color get gradientStart => _isDarkMode ? Colors.grey[900]! : zomatoRed;
  static Color get gradientEnd => _isDarkMode ? Colors.grey[800]! : zomatoOrange;
  
  // Special Colors
  static const Color transparent = Colors.transparent;
  static Color get overlay => _isDarkMode ? Color(0x80000000) : Color(0x80000000);
  
  // Grey Shades for Shimmer (same in both modes)
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
  
  // Shimmer Colors (Always Grey)
  static Color get shimmerBase => grey200;
  static Color get shimmerHighlight => grey100;
  static Color get shimmerBaseDark => grey800;
  static Color get shimmerHighlightDark => grey700;
  
  // Helper to check dark mode
  static bool get _isDarkMode {
    try {
      final themeController = Get.find<ThemeController>();
      return themeController.isDarkMode;
    } catch (e) {
      return false;
    }
  }
  
  // Method to get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}

// Extension for Colors.grey indexing (for grey[850])
extension GreyColors on Color {
  static Color grey850() => Color(0xFF1A1A1A);
}
