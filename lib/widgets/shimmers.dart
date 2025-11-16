// ignore: uri_does_not_exist
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart' as sk;

import '../theme/colors.dart';

class Skeletons {
  static Widget fullScreen({double? padding}) {
    return sk.Skeletonizer(
      effect: _effect(),
      containersColor: _baseColor(),
      child: Padding(
        padding: EdgeInsets.all(padding ?? 16.0),
        child: Column(
          children: [
            _block(height: 24, width: 180),
            const SizedBox(height: 16),
            _block(height: 44),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, __) => Row(
                  children: [
                    _block(height: 72, width: 72, radius: 12),
                    const SizedBox(width: 12),
                    Expanded(child: _block(height: 72, radius: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _block({double? height, double? width, double radius = 8}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: _baseColor(),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  static Widget smallBox({double size = 20, double radius = 6}) {
    return sk.Skeletonizer(
      effect: _effect(),
      containersColor: _baseColor(),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: _baseColor(),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  static Widget imageRect({double? height, double? width, double radius = 12}) {
    return sk.Skeletonizer(
      effect: _effect(),
      containersColor: _baseColor(),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: _baseColor(),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  static Widget textLine(
      {double height = 14, double? width, double radius = 6}) {
    return sk.Skeletonizer(
      effect: _effect(),
      containersColor: _highlightColor(),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: _highlightColor(),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  static Color _baseColor() =>
      Get.isDarkMode ? AppColors.shimmerBaseDark : AppColors.shimmerBase;

  static Color _highlightColor() => Get.isDarkMode
      ? AppColors.shimmerHighlightDark
      : AppColors.shimmerHighlight;

  static sk.ShimmerEffect _effect() => sk.ShimmerEffect(
        baseColor: _baseColor(),
        highlightColor: _highlightColor(),
        duration: const Duration(milliseconds: 1600),
      );
}
