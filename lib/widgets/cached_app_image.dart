import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import 'shimmers.dart';

/// Network image that loads from cache first. Use instead of Image.network
/// so images show instantly on refetch/query without re-downloading.
class CachedAppImage extends StatelessWidget {
  const CachedAppImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.placeholder,
    this.errorWidget,
    this.httpHeaders,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Map<String, String>? httpHeaders;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return errorWidget ?? _defaultError();
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      cacheKey: imageUrl,
      httpHeaders: httpHeaders,
      maxWidthDiskCache: cacheWidth != null ? cacheWidth! * 2 : null,
      maxHeightDiskCache: cacheHeight != null ? cacheHeight! * 2 : null,
      placeholder: (context, url) =>
          placeholder ?? Skeletons.imageRect(
                height: height ?? double.infinity,
                width: width ?? double.infinity,
                radius: 0,
              ),
      errorWidget: (context, url, error) => errorWidget ?? _defaultError(),
    );
  }

  Widget _defaultError() {
    return Container(
      color: AppColors.backgroundLight,
      child: Center(
        child: Icon(
          Icons.broken_image_rounded,
          size: ResponsiveUtils.rp(32),
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
