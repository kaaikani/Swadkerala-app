import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// A widget that adapts its layout based on device orientation
/// 
/// Usage:
/// ```dart
/// OrientationAwareWidget(
///   portrait: Column(children: [...]),
///   landscape: Row(children: [...]),
/// )
/// ```
class OrientationAwareWidget extends StatelessWidget {
  final Widget portrait;
  final Widget? landscape;
  final bool useMediaQuery;

  const OrientationAwareWidget({
    Key? key,
    required this.portrait,
    this.landscape,
    this.useMediaQuery = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (useMediaQuery) {
      return OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          if (isPortrait) {
            return portrait;
          }
          return landscape ?? portrait;
        },
      );
    } else {
      // Use ResponsiveUtils for orientation detection
      return ResponsiveUtils.isPortrait
          ? portrait
          : (landscape ?? portrait);
    }
  }
}

/// A mixin that provides orientation-aware helper methods
mixin OrientationAwareMixin {
  /// Get responsive padding based on orientation
  EdgeInsets getOrientationPadding({
    double? portraitHorizontal,
    double? portraitVertical,
    double? landscapeHorizontal,
    double? landscapeVertical,
  }) {
    final isPortrait = ResponsiveUtils.isPortrait;
    return EdgeInsets.symmetric(
      horizontal: isPortrait
          ? (portraitHorizontal ?? ResponsiveUtils.rp(16))
          : (landscapeHorizontal ?? ResponsiveUtils.rp(24)),
      vertical: isPortrait
          ? (portraitVertical ?? ResponsiveUtils.rp(12))
          : (landscapeVertical ?? ResponsiveUtils.rp(16)),
    );
  }

  /// Get responsive grid columns based on orientation
  int getOrientationGridColumns({
    int? portraitColumns,
    int? landscapeColumns,
  }) {
    final isPortrait = ResponsiveUtils.isPortrait;
    if (isPortrait) {
      return portraitColumns ?? ResponsiveUtils.gridCrossAxisCount;
    }
    return landscapeColumns ?? ResponsiveUtils.gridCrossAxisCount;
  }

  /// Get responsive spacing based on orientation
  double getOrientationSpacing({
    double? portraitSpacing,
    double? landscapeSpacing,
  }) {
    final isPortrait = ResponsiveUtils.isPortrait;
    return isPortrait
        ? (portraitSpacing ?? ResponsiveUtils.rp(16))
        : (landscapeSpacing ?? ResponsiveUtils.rp(24));
  }
}

