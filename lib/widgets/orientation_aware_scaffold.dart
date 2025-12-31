import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// A Scaffold wrapper that automatically adapts to orientation changes
/// 
/// This widget ensures all pages respond dynamically to orientation changes
/// by rebuilding when orientation changes.
/// 
/// Usage:
/// ```dart
/// OrientationAwareScaffold(
///   appBar: AppBar(title: Text('My Page')),
///   body: YourContent(),
/// )
/// ```
class OrientationAwareScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Key? scaffoldKey;

  const OrientationAwareScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // Force rebuild when orientation changes
        return Scaffold(
          key: scaffoldKey,
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: bottomNavigationBar,
          drawer: drawer,
          endDrawer: endDrawer,
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
        );
      },
    );
  }
}

/// Extension methods for easier orientation-aware layouts
extension OrientationExtensions on BuildContext {
  /// Check if current orientation is portrait
  bool get isPortrait {
    return MediaQuery.of(this).orientation == Orientation.portrait;
  }

  /// Check if current orientation is landscape
  bool get isLandscape {
    return MediaQuery.of(this).orientation == Orientation.landscape;
  }

  /// Get screen width (updates on orientation change)
  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }

  /// Get screen height (updates on orientation change)
  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  /// Get responsive padding based on orientation
  EdgeInsets getOrientationPadding({
    double? portraitHorizontal,
    double? portraitVertical,
    double? landscapeHorizontal,
    double? landscapeVertical,
  }) {
    final isPortrait = this.isPortrait;
    return EdgeInsets.symmetric(
      horizontal: isPortrait
          ? (portraitHorizontal ?? ResponsiveUtils.rp(16))
          : (landscapeHorizontal ?? ResponsiveUtils.rp(24)),
      vertical: isPortrait
          ? (portraitVertical ?? ResponsiveUtils.rp(12))
          : (landscapeVertical ?? ResponsiveUtils.rp(16)),
    );
  }
}

