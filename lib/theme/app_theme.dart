import 'package:flutter/material.dart';
import 'colors.dart';
import 'sizes.dart';
import 'text_styles.dart';

/// Main theme configuration for the app - Zomato-inspired Theme
class AppTheme {
  // Light Theme - Zomato-inspired Theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme - Zomato Theme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.zomatoRed,
        brightness: Brightness.light,
        primary: AppColors.zomatoBackground,
        secondary: AppColors.zomatoOrange,
        error: AppColors.error,
        surface: AppColors.surface,
        background: AppColors.zomatoBackground,
      ),
      
      // Scaffold Background - Zomato tint
      scaffoldBackgroundColor: AppColors.zomatoBackground,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: AppSizes.elevationNone,
        backgroundColor: AppColors.transparent,
        foregroundColor: AppColors.textDark,
        titleTextStyle: AppTextStyles.appBarTitle,
        iconTheme: IconThemeData(
          color: AppColors.icon,
          size: AppSizes.iconMD,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        color: AppColors.card,
        margin: const EdgeInsets.all(AppSizes.paddingSM),
      ),
      
      // Elevated Button Theme - Red button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSizes.elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.buttonHorizontalPadding,
            vertical: AppSizes.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          ),
          textStyle: AppTextStyles.button,
          backgroundColor: AppColors.button,
          foregroundColor: AppColors.textLight,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLG,
            vertical: AppSizes.paddingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          ),
          textStyle: AppTextStyles.button.copyWith(
            color: AppColors.button,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.buttonHorizontalPadding,
            vertical: AppSizes.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          ),
          side: BorderSide(
            color: AppColors.button,
            width: AppSizes.borderWidthMD,
          ),
          textStyle: AppTextStyles.button.copyWith(
            color: AppColors.button,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.inputPadding,
          vertical: AppSizes.inputPadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide(
            color: AppColors.zomatoRed,
            width: AppSizes.borderWidthMD,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppSizes.borderWidthThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppSizes.borderWidthMD,
          ),
        ),
        labelStyle: AppTextStyles.inputLabel,
        hintStyle: AppTextStyles.inputHint,
        errorStyle: AppTextStyles.error,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: AppSizes.bottomNavElevation,
        selectedItemColor: AppColors.button,
        unselectedItemColor: AppColors.iconLight,
        backgroundColor: AppColors.surface,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppSizes.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.dialogRadius),
        ),
        titleTextStyle: AppTextStyles.titleLarge,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),
      
      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textDark,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.snackbarRadius),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppSizes.elevationMD,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: AppSizes.dividerThickness,
        space: AppSizes.paddingLG,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.icon,
        size: AppSizes.iconMD,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey100,
        disabledColor: AppColors.grey200,
        selectedColor: AppColors.zomatoRed,
        secondarySelectedColor: AppColors.zomatoBackground,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.chipPadding,
          vertical: AppSizes.paddingSM,
        ),
        labelStyle: AppTextStyles.chip,
        secondaryLabelStyle: AppTextStyles.chip.copyWith(
          color: AppColors.textLight,
        ),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.chipRadius),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.listItemPadding,
          vertical: AppSizes.paddingSM,
        ),
        titleTextStyle: AppTextStyles.titleSmall,
        subtitleTextStyle: AppTextStyles.bodySmall,
        iconColor: AppColors.icon,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.button,
        foregroundColor: AppColors.textLight,
        elevation: AppSizes.elevationMD,
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.button,
      ),
    );
  }
  
  // Dark Theme - Full Black Theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme - Dark/Black
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey[900]!,
        brightness: Brightness.dark,
        primary: Colors.grey[900]!,
        secondary: Colors.grey[800]!,
        error: AppColors.error,
        surface: Colors.grey[900]!,
        background: Colors.black,
      ),
      
      // Scaffold Background - Pure Black
      scaffoldBackgroundColor: Colors.black,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: AppSizes.elevationNone,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: AppSizes.iconMD,
        ),
      ),
      
      // Card Theme - Dark Grey
      cardTheme: CardThemeData(
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        color: Colors.grey[900]!,
        margin: const EdgeInsets.all(AppSizes.paddingSM),
      ),
      
      // Elevated Button Theme - Red button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSizes.elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.buttonHorizontalPadding,
            vertical: AppSizes.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          ),
          textStyle: AppTextStyles.button,
          backgroundColor: AppColors.button,
          foregroundColor: Colors.white,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLG,
            vertical: AppSizes.paddingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          ),
          textStyle: AppTextStyles.button.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.buttonHorizontalPadding,
            vertical: AppSizes.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          ),
          side: BorderSide(
            color: Colors.white,
            width: AppSizes.borderWidthMD,
          ),
          textStyle: AppTextStyles.button.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[900]!,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.inputPadding,
          vertical: AppSizes.inputPadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide(
            color: Colors.grey[700]!,
            width: AppSizes.borderWidthMD,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppSizes.borderWidthThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppSizes.borderWidthMD,
          ),
        ),
        labelStyle: AppTextStyles.inputLabel.copyWith(color: Colors.grey[400]),
        hintStyle: AppTextStyles.inputHint.copyWith(color: Colors.grey[500]),
        errorStyle: AppTextStyles.error,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: AppSizes.bottomNavElevation,
        selectedItemColor: AppColors.button,
        unselectedItemColor: Colors.grey[400]!,
        backgroundColor: Colors.grey[900]!,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.grey[900]!,
        elevation: AppSizes.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.dialogRadius),
        ),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: Colors.white),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[300]),
      ),
      
      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[800]!,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.snackbarRadius),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppSizes.elevationMD,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: Colors.grey[800]!,
        thickness: AppSizes.dividerThickness,
        space: AppSizes.paddingLG,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: Colors.white,
        size: AppSizes.iconMD,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[800]!,
        disabledColor: Colors.grey[900]!,
        selectedColor: Colors.grey[700]!,
        secondarySelectedColor: Colors.grey[800]!,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.chipPadding,
          vertical: AppSizes.paddingSM,
        ),
        labelStyle: AppTextStyles.chip.copyWith(color: Colors.white),
        secondaryLabelStyle: AppTextStyles.chip.copyWith(
          color: Colors.white,
        ),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.chipRadius),
        ),
      ),
      
      // Text Theme - White text
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: Colors.white),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: Colors.white),
        displaySmall: AppTextStyles.displaySmall.copyWith(color: Colors.white),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: Colors.white),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: Colors.grey[300]),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: Colors.grey[300]),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[200]),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[300]),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.grey[400]),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: Colors.white),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: Colors.grey[300]),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: Colors.grey[400]),
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.listItemPadding,
          vertical: AppSizes.paddingSM,
        ),
        titleTextStyle: AppTextStyles.titleSmall.copyWith(color: Colors.white),
        subtitleTextStyle: AppTextStyles.bodySmall.copyWith(color: Colors.grey[400]),
        iconColor: Colors.white,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.button,
        foregroundColor: Colors.white,
        elevation: AppSizes.elevationMD,
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.button,
      ),
    );
  }
}
