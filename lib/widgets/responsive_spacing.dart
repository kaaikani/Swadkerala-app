import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// Reusable spacing widgets
class ResponsiveSpacing {
  static Widget vertical(double height) =>
      SizedBox(height: ResponsiveUtils.rp(height));
  static Widget horizontal(double width) =>
      SizedBox(width: ResponsiveUtils.rp(width));

  // Common spacing sizes
  static Widget get xs => vertical(4);
  static Widget get sm => vertical(8);
  static Widget get md => vertical(12);
  static Widget get lg => vertical(16);
  static Widget get xl => vertical(24);
  static Widget get xxl => vertical(32);

  // Responsive padding
  static EdgeInsets padding(
      {double? all,
      double? horizontal,
      double? vertical,
      double? top,
      double? bottom,
      double? left,
      double? right}) {
    if (all != null) {
      return EdgeInsets.all(ResponsiveUtils.rp(all));
    }
    return EdgeInsets.only(
      top: ResponsiveUtils.rp(top ?? vertical ?? 0),
      bottom: ResponsiveUtils.rp(bottom ?? vertical ?? 0),
      left: ResponsiveUtils.rp(left ?? horizontal ?? 0),
      right: ResponsiveUtils.rp(right ?? horizontal ?? 0),
    );
  }

  // Screen padding
  static EdgeInsets get screenPadding => ResponsiveUtils.screenPadding();
}
