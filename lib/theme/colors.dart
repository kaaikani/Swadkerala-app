import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

/// Green-inspired Theme - Fresh green & lime palette
class AppColors {
  // New Brand Green Colors
  static const Color greenPrimary = Color(0xFF22A45D); // Fresh green
  static const Color greenPrimaryLight = Color(0xFF4CCB84); // Lighter green
  static const Color greenPrimaryDark = Color(0xFF1C8A4E); // Darker green

  static const Color greenAccent = Color(0xFF40C057); // Accent green
  static const Color greenAccentLight = Color(0xFF69DB7C); // Light accent green

  static const Color greenBackground = Color(0xFFF6FFF8); // Soft green tint

  // ============================================================
  // 🔥 BACKWARD-COMPATIBILITY FOR OLD VARIABLES (NO ERRORS)
  // ============================================================
  static const Color zomatoRed = greenPrimary;
  static const Color zomatoRedLight = greenPrimaryLight;
  static const Color zomatoRedDark = greenPrimaryDark;

  static const Color zomatoOrange = greenAccent;
  static const Color zomatoOrangeLight = greenAccentLight;

  static const Color zomatoBackground = greenBackground;

  // Primary Colors
  static Color get primary => _isDarkMode ? Colors.grey[900]! : greenBackground;
  static Color get primaryLight => _isDarkMode ? Colors.grey[800]! : Color(0xFFF8FFF9);
  static Color get primaryDark => _isDarkMode ? Colors.grey[700]! : Color(0xFFE8FFF0);

  // CONSTANT TEXT COLORS
  static const Color textPrimaryConst = Colors.black;
  static const Color textSecondaryConst = Colors.black87;
  static const Color textTertiaryConst = Colors.black54;
  static const Color textDarkConst = Colors.black;
  static const Color primaryConst = greenBackground;

  // Secondary Colors
  static Color get secondary => _isDarkMode ? Colors.grey[800]! : greenAccent;
  static Color get secondaryLight => _isDarkMode ? Colors.grey[700]! : greenAccentLight;
  static Color get accent => greenPrimary;
  static Color get promoCard => _isDarkMode ? Colors.grey[800]! : Color(0xFFEFFFF2);

  // Background Colors
  static Color get background => _isDarkMode ? Colors.black : Colors.white;
  static Color get backgroundLight => _isDarkMode ? Colors.grey[900]! : greenBackground;
  static Color get surface => _isDarkMode ? Colors.grey[900]! : Colors.white;

  static Color get card {
    if (_isDarkMode) return const Color(0xFF1A1A1A);
    return Colors.white;
  }

  // Text Colors
  static Color get textPrimary => _isDarkMode ? Colors.white : Colors.black;
  static Color get textSecondary => _isDarkMode ? Colors.grey[400]! : Colors.black87;
  static Color get textTertiary => _isDarkMode ? Colors.grey[500]! : Colors.black54;
  static const Color textLight = Colors.white;
  static Color get textDark => _isDarkMode ? Colors.white : Colors.black;
  static Color get textBlack => _isDarkMode ? Colors.white : Colors.black;

  // Icons
  static Color get icon => _isDarkMode ? Colors.white : Colors.black;
  static Color get iconLight => _isDarkMode ? Colors.grey[400]! : Color(0xFF9CA3AF);
  static Color get iconDark => _isDarkMode ? Colors.white : Colors.black87;

  // Status Colors
  static const Color success = Color(0xFF22A45D);
  static const Color successLight = Color(0xFF4CCB84);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Borders & Dividers
  static Color get border => _isDarkMode ? Colors.grey[800]! : Color(0xFFE5E7EB);
  static Color get borderLight => _isDarkMode ? Colors.grey[700]! : Color(0xFFF3F4F6);
  static Color get divider => _isDarkMode ? Colors.grey[800]! : Color(0xFFE5E7EB);

  // Interactive
  static Color get heartActive => greenPrimary;
  static Color get heartInactive => _isDarkMode ? Colors.grey[400]! : Colors.black;

  static const Color buttonText = Colors.white;
  static const Color button = greenPrimary;
  static const Color buttonLight = greenPrimaryLight;
  static const Color buttonDark = greenPrimaryDark;

  static const Color link = Color(0xFF3B82F6);

  // Refresh Indicator
  static const Color refreshIndicator = greenPrimary;

  // Inputs & Shadows
  static Color get inputFill => _isDarkMode ? Colors.grey[900]! : Color(0xFFF9FAFB);
  static Color get inputBorder => _isDarkMode ? Colors.grey[700]! : Color(0xFFE5E7EB);

  static Color get shadowLight =>
      _isDarkMode ? Color(0x1AFFFFFF) : Color(0x0D000000);
  static Color get shadowMedium =>
      _isDarkMode ? Color(0x2AFFFFFF) : Color(0x1A000000);

  // Gradients
  static Color get gradientStart => _isDarkMode ? Colors.grey[900]! : greenPrimary;
  static Color get gradientEnd => _isDarkMode ? Colors.grey[800]! : greenAccent;

  // Special
  static const Color transparent = Colors.transparent;
  static Color get overlay => Color(0x80000000);

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

  // Shimmer
  static Color get shimmerBase => grey200;
  static Color get shimmerHighlight => grey100;
  static Color get shimmerBaseDark => grey800;
  static Color get shimmerHighlightDark => grey700;

  // Dark Mode Helper
  static bool get _isDarkMode {
    try {
      final themeController = Get.find<ThemeController>();
      return themeController.isDarkMode;
    } catch (e) {
      return false;
    }
  }

  // Opacity Helper
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}

// Grey 850 extension
extension GreyColors on Color {
  static Color grey850() => Color(0xFF1A1A1A);
}
