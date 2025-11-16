import 'package:flutter/material.dart';
import 'colors.dart';

/// Centralized text styles for the entire app
class AppTextStyles {
  // Display Styles (Very Large)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryConst,
    height: 1.2,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryConst,
    height: 1.2,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryConst,
    height: 1.2,
  );
  
  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryConst,
    height: 1.3,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryConst,
    height: 1.3,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryConst,
    height: 1.3,
  );
  
  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryConst,
    height: 1.4,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryConst,
    height: 1.4,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryConst,
    height: 1.4,
  );
  
  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryConst,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryConst,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryConst,
    height: 1.5,
  );
  
  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryConst,
    height: 1.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryConst,
    height: 1.4,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiaryConst,
    height: 1.4,
  );
  
  // Button Styles
  static const TextStyle button = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
    height: 1.2,
  );
  
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
    height: 1.2,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
    height: 1.2,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
    height: 1.2,
  );
  
  // Caption Styles
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryConst,
    height: 1.4,
  );
  
  static const TextStyle captionBold = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondaryConst,
    height: 1.4,
  );
  
  // Overline Style
  static const TextStyle overline = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiaryConst,
    letterSpacing: 1.5,
    height: 1.6,
  );
  
  // AppBar Title
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textDarkConst,
    height: 1.2,
  );
  
  // Price Styles
  static const TextStyle priceLarge = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryConst,
    height: 1.2,
  );
  
  static const TextStyle priceMedium = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryConst,
    height: 1.2,
  );
  
  static const TextStyle priceSmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryConst,
    height: 1.2,
  );
  
  // Link Style
  static const TextStyle link = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.link,
    decoration: TextDecoration.underline,
    height: 1.4,
  );
  
  // Error Style
  static const TextStyle error = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
    height: 1.4,
  );
  
  // Success Style
  static const TextStyle success = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.success,
    height: 1.4,
  );
  
  // Specific Component Styles
  static const TextStyle productTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryConst,
    height: 1.3,
  );
  
  static const TextStyle productDescription = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryConst,
    height: 1.5,
  );
  
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryConst,
    height: 1.3,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryConst,
    height: 1.4,
  );
  
  static const TextStyle inputLabel = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryConst,
    height: 1.4,
  );
  
  static const TextStyle inputText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryConst,
    height: 1.4,
  );
  
  static const TextStyle inputHint = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiaryConst,
    height: 1.4,
  );
  
  // Badge/Chip Styles
  static const TextStyle badge = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    height: 1.2,
  );
  
  static const TextStyle chip = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryConst,
    height: 1.2,
  );
  
  // Stat/Number Styles
  static const TextStyle statLarge = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryConst,
    height: 1.2,
  );
  
  static const TextStyle statMedium = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryConst,
    height: 1.2,
  );
  
  static const TextStyle statSmall = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryConst,
    height: 1.2,
  );
}

