import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/theme_controller.dart';
import '../services/graphql_client.dart';

/// Green-inspired Theme - Fresh green & lime palette
/// With channel-based theming:
/// - Default: Green theme
/// - Ind-Snacks: Brown/Orange theme
/// - ind (Non-Veg): Red theme
class AppColors {
  // Get current channel token
  static String get _currentChannelToken {
    try {
      final channelToken = GraphqlService.channelTokenRx.value.isNotEmpty
          ? GraphqlService.channelTokenRx.value
          : (GraphqlService.channelToken.isNotEmpty
              ? GraphqlService.channelToken
              : (GetStorage().read('channel_token')?.toString() ?? ''));
      return channelToken.toLowerCase();
    } catch (e) {
      return '';
    }
  }

  // Channel-based color scheme - use reactive observable
  static bool get _isIndSnacksChannel {
    final token = _currentChannelToken;
    return token == 'ind-snacks';
  }

  // Non-Veg channel (ind / ind-non veg) - Red theme
  static bool get _isIndNonVegChannel {
    final token = _currentChannelToken;
    return token == 'ind' || token == 'ind-non veg';
  }

  // Ind-Snacks Brand Colors (Brown, Beige, Orange theme)
  static const Color indSnacksBrown = Color(0xFF5D4037); // Dark brown for headers
  static const Color indSnacksBrownDark = Color(0xFF3E2723); // Darker brown
  static const Color indSnacksBrownLight = Color(0xFF8D6E63); // Lighter brown

  static const Color indSnacksBeige = Color(0xFFF5F1E8); // Light beige/cream background
  static const Color indSnacksBeigeLight = Color(0xFFFAF8F3); // Lighter beige
  static const Color indSnacksBeigeDark = Color(0xFFE8E0D3); // Darker beige

  static const Color indSnacksOrange = Color(0xFFFF6B35); // Orange accent (from image)
  static const Color indSnacksOrangeLight = Color(0xFFFF8C5A); // Lighter orange
  static const Color indSnacksOrangeDark = Color(0xFFE55A2B); // Darker orange
  static const Color indSnacksAccent = Color(0xFFF2A23A); // Accent color for dropdowns and outlines

  // Ind Non-Veg Brand Colors (Red theme for non-vegetarian)
  static const Color indNonVegRed = Color(0xFFD32F2F); // Primary red
  static const Color indNonVegRedDark = Color(0xFFB71C1C); // Darker red
  static const Color indNonVegRedLight = Color(0xFFEF5350); // Lighter red

  static const Color indNonVegBackground = Color(0xFFFFF5F5); // Light red-tinted background
  static const Color indNonVegBackgroundLight = Color(0xFFFFFAFA); // Very light red tint
  static const Color indNonVegBackgroundDark = Color(0xFFFFEBEE); // Slightly darker red tint

  static const Color indNonVegAccent = Color(0xFFFF5252); // Accent red
  static const Color indNonVegAccentLight = Color(0xFFFF8A80); // Light accent red

  static const Color indNonVegMaroon = Color(0xFF880E4F); // Deep maroon for contrast
  static const Color indNonVegCoral = Color(0xFFFF6B6B); // Coral accent

  // New Brand Green Colors (default)
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
  static Color get primary {
    if (_isDarkMode) return Colors.grey[900]!;
    if (_isIndNonVegChannel) return indNonVegBackground;
    if (_isIndSnacksChannel) return Color(0xFFFFEDC7);
    return greenBackground;
  }
  static Color get primaryLight {
    if (_isDarkMode) return Colors.grey[800]!;
    if (_isIndNonVegChannel) return indNonVegBackgroundLight;
    if (_isIndSnacksChannel) return Color(0xFFFFF4E0);
    return Color(0xFFF8FFF9);
  }
  static Color get primaryDark {
    if (_isDarkMode) return Colors.grey[700]!;
    if (_isIndNonVegChannel) return indNonVegBackgroundDark;
    if (_isIndSnacksChannel) return Color(0xFFFFE5B4);
    return Color(0xFFE8FFF0);
  }

  // CONSTANT TEXT COLORS
  static const Color textPrimaryConst = Colors.black;
  static const Color textSecondaryConst = Colors.black87;
  static const Color textTertiaryConst = Colors.black54;
  static const Color textDarkConst = Colors.black;
  static const Color primaryConst = greenBackground;

  // Secondary Colors
  static Color get secondary {
    if (_isDarkMode) return Colors.grey[800]!;
    if (_isIndNonVegChannel) return indNonVegRedDark;
    if (_isIndSnacksChannel) return indSnacksBrown;
    return greenAccent;
  }
  static Color get secondaryLight {
    if (_isDarkMode) return Colors.grey[700]!;
    if (_isIndNonVegChannel) return indNonVegRedLight;
    if (_isIndSnacksChannel) return indSnacksBrownLight;
    return greenAccentLight;
  }
  static Color get accent {
    if (_isIndNonVegChannel) return indNonVegAccent;
    if (_isIndSnacksChannel) return indSnacksOrange;
    return greenPrimary;
  }
  static Color get promoCard {
    if (_isDarkMode) return Colors.grey[800]!;
    if (_isIndNonVegChannel) return Color(0xFFFFE8E8);
    return Color(0xFFEFFFF2);
  }

  // Background Colors
  static Color get background {
    if (_isDarkMode) return Colors.black;
    if (_isIndNonVegChannel) return indNonVegBackground;
    if (_isIndSnacksChannel) return Color(0xFFFFEDC7);
    return Colors.white;
  }
  static Color get backgroundLight {
    if (_isDarkMode) return Colors.grey[900]!;
    if (_isIndNonVegChannel) return indNonVegBackgroundLight;
    if (_isIndSnacksChannel) return Color(0xFFFFEDC7);
    return greenBackground;
  }
  static Color get surface {
    if (_isDarkMode) return Colors.grey[900]!;
    if (_isIndNonVegChannel) return indNonVegBackgroundLight;
    if (_isIndSnacksChannel) return Color(0xFFFFEDC7);
    return Colors.white;
  }

  static Color get card {
    if (_isDarkMode) return const Color(0xFF1A1A1A);
    if (_isIndNonVegChannel) return Colors.white;
    if (_isIndSnacksChannel) return Color(0xFFFFEDC7);
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
  static Color get heartActive {
    if (_isIndNonVegChannel) return indNonVegRed;
    if (_isIndSnacksChannel) return Color(0xFF92400E);
    return greenPrimary;
  }
  static Color get heartInactive => _isDarkMode ? Colors.grey[400]! : Colors.black;

  static const Color buttonText = Colors.white;
  static Color get button {
    if (_isIndNonVegChannel) return indNonVegRed;
    if (_isIndSnacksChannel) return Color(0xFF92400E);
    return greenPrimary;
  }
  static Color get buttonLight {
    if (_isIndNonVegChannel) return indNonVegRedLight;
    if (_isIndSnacksChannel) return Color(0xFFB85C1A);
    return greenPrimaryLight;
  }
  static Color get buttonDark {
    if (_isIndNonVegChannel) return indNonVegRedDark;
    if (_isIndSnacksChannel) return Color(0xFF6B2F0A);
    return greenPrimaryDark;
  }

  static const Color link = Color(0xFF3B82F6);

  // Refresh Indicator
  static Color get refreshIndicator {
    if (_isIndNonVegChannel) return indNonVegRed;
    if (_isIndSnacksChannel) return Color(0xFF92400E);
    return greenPrimary;
  }

  // Inputs & Shadows
  static Color get inputFill {
    if (_isDarkMode) return Colors.grey[900]!;
    if (_isIndNonVegChannel) return Color(0xFFFFF8F8);
    if (_isIndSnacksChannel) return indSnacksBeige;
    return Color(0xFFF9FAFB);
  }
  static Color get inputBorder => _isDarkMode ? Colors.grey[700]! : Color(0xFFE5E7EB);

  static Color get shadowLight =>
      _isDarkMode ? Color(0x1AFFFFFF) : Color(0x0D000000);
  static Color get shadowMedium =>
      _isDarkMode ? Color(0x2AFFFFFF) : Color(0x1A000000);

  // Gradients
  static Color get gradientStart {
    if (_isDarkMode) return Colors.grey[900]!;
    if (_isIndNonVegChannel) return indNonVegRed;
    if (_isIndSnacksChannel) return indSnacksBrown;
    return greenPrimary;
  }
  static Color get gradientEnd {
    if (_isDarkMode) return Colors.grey[800]!;
    if (_isIndNonVegChannel) return indNonVegCoral;
    if (_isIndSnacksChannel) return indSnacksOrange;
    return greenAccent;
  }

  // Special
  static const Color transparent = Colors.transparent;
  static const Color black = Colors.black;
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
