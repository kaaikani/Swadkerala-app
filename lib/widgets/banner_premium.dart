import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'cached_app_image.dart';
import '../utils/responsive.dart';

/// Premium banner carousel with dots and smooth animations
class BannerPremium extends StatelessWidget {
  final List<String> imageUrls;
  final List<String>? titles;
  final List<String>? subtitles;
  final VoidCallback? onBannerTap;
  final double? height;
  final bool showDots;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const BannerPremium({
    Key? key,
    required this.imageUrls,
    this.titles,
    this.subtitles,
    this.onBannerTap,
    this.height,
    this.showDots = true,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return SizedBox(
        height: height ?? ResponsiveUtils.rp(200),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.button.withValues(alpha: 0.3),
                AppColors.button.withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
      );
    }

    return _BannerCarouselStateful(
      imageUrls: imageUrls,
      titles: titles,
      subtitles: subtitles,
      onBannerTap: onBannerTap,
      height: height,
      showDots: showDots,
      autoPlay: autoPlay,
      autoPlayInterval: autoPlayInterval,
    );
  }
}

class _BannerCarouselStateful extends StatefulWidget {
  final List<String> imageUrls;
  final List<String>? titles;
  final List<String>? subtitles;
  final VoidCallback? onBannerTap;
  final double? height;
  final bool showDots;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const _BannerCarouselStateful({
    required this.imageUrls,
    this.titles,
    this.subtitles,
    this.onBannerTap,
    this.height,
    required this.showDots,
    required this.autoPlay,
    required this.autoPlayInterval,
  });

  @override
  State<_BannerCarouselStateful> createState() =>
      _BannerCarouselStatefulState();
}

class _BannerCarouselStatefulState extends State<_BannerCarouselStateful> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % widget.imageUrls.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height ?? ResponsiveUtils.rp(200),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: widget.onBannerTap,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image
                    CachedAppImage(
                      imageUrl: widget.imageUrls[index],
                      fit: BoxFit.cover,
                      cacheWidth: 1920,
                      cacheHeight: 640,
                      errorWidget: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.button.withValues(alpha: 0.5),
                              AppColors.button.withValues(alpha: 0.2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                    // Title/Subtitle (if provided)
                    if (widget.titles != null || widget.subtitles != null)
                      Positioned(
                        bottom: ResponsiveUtils.rp(20),
                        left: ResponsiveUtils.rp(20),
                        right: ResponsiveUtils.rp(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.titles != null &&
                                index < widget.titles!.length)
                              Text(
                                widget.titles![index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveUtils.sp(20),
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                      blurRadius: ResponsiveUtils.rp(4),
                                    ),
                                  ],
                                ),
                              ),
                            if (widget.subtitles != null &&
                                index < widget.subtitles!.length) ...[
                              SizedBox(height: ResponsiveUtils.rp(4)),
                              Text(
                                widget.subtitles![index],
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: ResponsiveUtils.sp(14),
                                  shadows: [
                                    Shadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                      blurRadius: ResponsiveUtils.rp(4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        // Dots Indicator
        if (widget.showDots && widget.imageUrls.length > 1)
          Padding(
            padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrls.length,
                (index) => Container(
                  width: ResponsiveUtils.rp(_currentPage == index ? 24 : 8),
                  height: ResponsiveUtils.rp(8),
                  margin:
                      EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(4)),
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.button
                        : AppColors.button.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(4)),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
