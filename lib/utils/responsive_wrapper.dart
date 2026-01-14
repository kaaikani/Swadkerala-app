import 'package:flutter/material.dart';
import 'responsive.dart';

/// Wrapper utilities to ensure all UI elements use responsive sizing
class ResponsiveWrapper {
  /// Responsive EdgeInsets.all
  static EdgeInsets all(double value) {
    return EdgeInsets.all(ResponsiveUtils.rp(value));
  }

  /// Responsive EdgeInsets.symmetric
  static EdgeInsets symmetric({
    double? horizontal,
    double? vertical,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal != null ? ResponsiveUtils.rp(horizontal) : 0,
      vertical: vertical != null ? ResponsiveUtils.rp(vertical) : 0,
    );
  }

  /// Responsive EdgeInsets.only
  static EdgeInsets only({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsets.only(
      top: top != null ? ResponsiveUtils.rp(top) : 0,
      bottom: bottom != null ? ResponsiveUtils.rp(bottom) : 0,
      left: left != null ? ResponsiveUtils.rp(left) : 0,
      right: right != null ? ResponsiveUtils.rp(right) : 0,
    );
  }

  /// Responsive SizedBox
  static Widget sizedBox({
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width != null ? ResponsiveUtils.rp(width) : null,
      height: height != null ? ResponsiveUtils.rp(height) : null,
    );
  }

  /// Responsive BorderRadius
  static BorderRadius borderRadius(double radius) {
    return BorderRadius.circular(ResponsiveUtils.rp(radius));
  }

  /// Responsive BorderRadius.only
  static BorderRadius borderRadiusOnly({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft != null ? ResponsiveUtils.rp(topLeft) : 0),
      topRight: Radius.circular(topRight != null ? ResponsiveUtils.rp(topRight) : 0),
      bottomLeft: Radius.circular(bottomLeft != null ? ResponsiveUtils.rp(bottomLeft) : 0),
      bottomRight: Radius.circular(bottomRight != null ? ResponsiveUtils.rp(bottomRight) : 0),
    );
  }

  /// Responsive icon size
  static double iconSize(double size) {
    return ResponsiveUtils.rp(size);
  }

  /// Responsive font size
  static double fontSize(double size) {
    return ResponsiveUtils.sp(size);
  }

  /// Responsive width
  static double width(double width) {
    return ResponsiveUtils.rp(width);
  }

  /// Responsive height
  static double height(double height) {
    return ResponsiveUtils.rp(height);
  }

  /// Get responsive text style
  static TextStyle textStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize != null ? ResponsiveUtils.sp(fontSize) : null,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

