// Enhanced ResponsiveUtils for all devices and orientations
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveUtils {
  // Design reference dimensions (iPhone 13 - commonly used standard)
  static const double _designWidth = 390.0; // Standard phone width
  static const double _designHeight = 844.0; // Standard phone height

  // Device breakpoints
  static const double _smallPhoneMax = 360.0;
  static const double _mediumPhoneMax = 400.0;
  static const double _tabletMin = 600.0;
  static const double _largeTabletMin = 900.0;

  // Get screen dimensions (updates on orientation change)
  static double get screenWidth {
    final context = Get.context;
    if (context != null) {
      return MediaQuery.of(context).size.width;
    }
    return Get.width;
  }

  static double get screenHeight {
    final context = Get.context;
    if (context != null) {
      return MediaQuery.of(context).size.height;
    }
    return Get.height;
  }

  // Orientation detection
  static bool get isPortrait => screenHeight > screenWidth;
  static bool get isLandscape => screenWidth > screenHeight;

  // Device type detection (based on shortest side to handle orientation)
  static double get _shortestSide {
    return screenWidth < screenHeight ? screenWidth : screenHeight;
  }

  // Enhanced device type checks
  static bool get isSmallPhone => _shortestSide < _smallPhoneMax;
  static bool get isMediumPhone =>
      _shortestSide >= _smallPhoneMax && _shortestSide < _mediumPhoneMax;
  static bool get isLargePhone =>
      _shortestSide >= _mediumPhoneMax && _shortestSide < _tabletMin;
  static bool get isTablet =>
      _shortestSide >= _tabletMin && _shortestSide < _largeTabletMin;
  static bool get isLargeTablet => _shortestSide >= _largeTabletMin;

  // Scale factor that adapts to orientation
  static double get scaleFactor {
    // Use width in portrait, height in landscape for better scaling
    if (isPortrait) {
      return screenWidth / _designWidth;
    } else {
      // In landscape, use height as reference for better vertical scaling
      return (screenHeight / _designHeight) *
          1.2; // Slightly increase for landscape
    }
  }

  // Adaptive scale factor (more conservative to prevent extreme sizes)
  static double get _adaptiveScaleFactor {
    double baseScale = scaleFactor;

    // Clamp scale factor to prevent too small or too large
    if (isSmallPhone) {
      baseScale = baseScale.clamp(0.85, 1.15); // Small phones: 85%-115%
    } else if (isTablet || isLargeTablet) {
      baseScale = baseScale.clamp(0.9, 1.5); // Tablets: 90%-150%
    } else {
      baseScale = baseScale.clamp(0.9, 1.3); // Normal phones: 90%-130%
    }

    // Landscape adjustment
    if (isLandscape && !isTablet) {
      baseScale = baseScale * 0.95; // Slightly reduce in landscape for phones
    }

    return baseScale;
  }

  // Responsive font size (scales with device and orientation)
  static double sp(double fontSize) {
    return fontSize * _adaptiveScaleFactor;
  }

  // Responsive padding/margin/size (scales with device and orientation)
  static double rp(double size) {
    return size * _adaptiveScaleFactor;
  }

  // Responsive width percentage
  static double wp(double percent) => screenWidth * (percent / 100);

  // Responsive height percentage
  static double hp(double percent) => screenHeight * (percent / 100);

  // Grid layout - responsive to device type and orientation
  static int get gridCrossAxisCount {
    if (isLargeTablet) {
      return isPortrait ? 4 : 6; // Large tablets: 4 portrait, 6 landscape
    }
    if (isTablet) {
      return isPortrait ? 3 : 5; // Tablets: 3 portrait, 5 landscape
    }
    if (isLargePhone) {
      return isPortrait ? 2 : 4; // Large phones: 2 portrait, 4 landscape
    }
    // Small and medium phones
    return isPortrait ? 2 : 3; // Phones: 2 portrait, 3 landscape
  }

  // Category grid columns (for category sections)
  static int get categoryGridColumns {
    if (isLargeTablet) {
      return isPortrait ? 8 : 10;
    }
    if (isTablet) {
      return isPortrait ? 6 : 8;
    }
    // Phones: standard 5 columns
    return isPortrait ? 5 : 7;
  }

  // Responsive spacing multiplier
  static double get spacingMultiplier {
    if (isTablet || isLargeTablet) {
      return isPortrait ? 1.2 : 1.0; // More spacing on tablets in portrait
    }
    return 1.0;
  }

  // Get responsive EdgeInsets for common padding
  static EdgeInsets screenPadding() {
    if (isLargeTablet) {
      return EdgeInsets.symmetric(
        horizontal: isPortrait ? rp(40) : rp(60),
        vertical: rp(20),
      );
    }
    if (isTablet) {
      return EdgeInsets.symmetric(
        horizontal: isPortrait ? rp(30) : rp(40),
        vertical: rp(16),
      );
    }
    // Phones
    return EdgeInsets.symmetric(
      horizontal: rp(16),
      vertical: rp(12),
    );
  }

  // Responsive card height
  static double cardHeight(double baseHeight) {
    if (isTablet || isLargeTablet) {
      return baseHeight * (isPortrait ? 1.1 : 0.9);
    }
    return baseHeight;
  }

  // Responsive icon size
  static double iconSize(double baseSize) {
    if (isTablet || isLargeTablet) {
      return rp(baseSize) * 1.15;
    }
    return rp(baseSize);
  }

  // Check if device is in landscape
  static bool get inLandscape => isLandscape;

  // Check if device is in portrait
  static bool get inPortrait => isPortrait;

  // Get device category for debugging
  static String get deviceCategory {
    if (isLargeTablet) return 'Large Tablet';
    if (isTablet) return 'Tablet';
    if (isLargePhone) return 'Large Phone';
    if (isMediumPhone) return 'Medium Phone';
    if (isSmallPhone) return 'Small Phone';
    return 'Unknown';
  }

  // Responsive text scale factor (for accessibility)
  static double get textScaleFactor {
    final context = Get.context;
    if (context != null) {
      return MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    }
    return 1.0;
  }
}
