import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controllers/banner/bannercontroller.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:async';

import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_icon.dart';
import '../graphql/banner.graphql.dart';
import '../widgets/cached_app_image.dart';

class BannerComponent extends StatefulWidget {
  const BannerComponent({super.key});

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  final BannerController bannerController = Get.find<BannerController>();
  final CarouselSliderController _carouselController = CarouselSliderController();
  final ScrollController _dotScrollController = ScrollController();
  int _currentIndex = 0;
  Timer? _timer;
  final UtilityController utilityController = Get.find();
  bool _isCarouselReady = false;

  @override
  void initState() {
    super.initState();

    // Schedule banner fetch after build phase to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bannerController.bannerList.isEmpty) {
        bannerController.getBannersForChannel();
      }
    });
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || bannerController.bannerList.isEmpty || !_isCarouselReady) return;
      
      // Use addPostFrameCallback to ensure we're not in the middle of a layout
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_isCarouselReady) return;
        
      try {
      _carouselController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      } catch (e) {
        // Controller not ready or disposed, stop autoplay
        _stopAutoPlay();
      }
      });
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    // Mark carousel as ready after first page change
    if (!_isCarouselReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isCarouselReady = true;
          });
          // Start autoplay now that carousel is ready
          _startAutoPlay();
        }
      });
    }
    
    // Use addPostFrameCallback to avoid setState during layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
    setState(() {
      _currentIndex = index;
    });
    // Scroll dots to keep active dot visible
    _scrollDotsToActive(index);
      }
    });
  }

  void _scrollDotsToActive(int activeIndex) {
    if (!mounted || !_dotScrollController.hasClients) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_dotScrollController.hasClients) return;
      
      // Calculate scroll position to center the active dot
      final dotWidth = ResponsiveUtils.rp(6); // Inactive dot width
      final activeDotWidth = ResponsiveUtils.rp(20); // Active dot width
      final dotSpacing = ResponsiveUtils.rp(3) * 2; // Margin on both sides
      final totalDotWidth = dotWidth + dotSpacing;
      
      // Get screen width from context
      final screenWidth = MediaQuery.of(context).size.width;
      
      // Calculate position to center the active dot
      final scrollPosition = (activeIndex * totalDotWidth) - 
                            (screenWidth / 2) + 
                            (activeDotWidth / 2);
      
      final maxScroll = _dotScrollController.position.maxScrollExtent;
      final clampedPosition = scrollPosition.clamp(0.0, maxScroll > 0 ? maxScroll : 0.0);
      
      _dotScrollController.animateTo(
        clampedPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dotScrollController.dispose();
    super.dispose();
  }

  void _handleBannerTap(Query$customBanners$customBanners banner) {
    // Handle banner tap - navigate based on banner link or custom fields
    // TODO: Implement navigation based on banner custom fields
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = utilityController.isLoadingRx.value;
      final banners = bannerController.bannerList;

      if (banners.isEmpty && !isLoading) {
        Future.microtask(() {
          if (!utilityController.isLoadingRx.value) {
            bannerController.getBannersForChannel();
          }
        });
      }

      // Handle empty banners case
      if (banners.isEmpty && !isLoading) {
        return Container(
          height: ResponsiveUtils.rp(200),
          // No margin - full width banner
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.button.withValues(alpha: 0.3),
                AppColors.button.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Center(
            child: ResponsiveIcon(
              Icons.image_outlined,
              size: ResponsiveUtils.rp(50),
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      if (banners.isEmpty) {
        // Show skeleton while loading
        return Skeletonizer(
          enabled: true,
          child: Container(
            height: ResponsiveUtils.rp(200),
            // No margin - full width banner
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.zero,
            ),
          ),
        );
      }

      // Start autoplay when banners are available and carousel is ready
      if ((_timer == null || !_timer!.isActive) && _isCarouselReady) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isCarouselReady) {
          _startAutoPlay();
          }
        });
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Carousel Slider - Full width without curves
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: ResponsiveUtils.rp(12),
                  offset: Offset(0, ResponsiveUtils.rp(4)),
                  spreadRadius: ResponsiveUtils.rp(1),
                ),
              ],
            ),
            child: GestureDetector(
              onTapDown: (_) => _stopAutoPlay(),
              onTapUp: (_) {
                if (_isCarouselReady) {
                  _startAutoPlay();
                }
              },
              onTapCancel: () {
                if (_isCarouselReady) {
                  _startAutoPlay();
                }
              },
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: banners.length,
                itemBuilder: (context, index, realIndex) {
                  final banner = banners[index];
                  final imageUrl = banner.assets.isNotEmpty
                      ? banner.assets.first.source
                      : '';

                  return Container(
                    width: double.infinity,
                    color: AppColors.background,
                    child: GestureDetector(
                      onTap: () => _handleBannerTap(banner),
                      child: imageUrl.isNotEmpty
                          ? CachedAppImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              cacheWidth: 1080,
                              cacheHeight: 607,
                              errorWidget: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.grey200,
                                      AppColors.grey300,
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: ResponsiveUtils.rp(50),
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.grey200,
                                    AppColors.grey300,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: ResponsiveUtils.rp(50),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                    ),
                  );
                },
                options: CarouselOptions(
                  aspectRatio: 1080 / 607, // banner ratio (1080x607)
                  viewportFraction: 1.0,
                  autoPlay: false, // Disable built-in autoplay, use custom timer
                  enlargeCenterPage: false,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  enableInfiniteScroll: banners.length > 1,
                  onPageChanged: _onPageChanged,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),
          
          SizedBox(height: ResponsiveUtils.rp(16)),
          
          // Scrolling Dot Indicators with smooth animation
          if (banners.length > 1)
            SizedBox(
              height: ResponsiveUtils.rp(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _dotScrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        banners.length,
                        (index) {
                          final isActive = _currentIndex == index;
                          return GestureDetector(
                            onTap: () {
                              _carouselController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(3)),
                              width: isActive ? ResponsiveUtils.rp(20) : ResponsiveUtils.rp(6),
                              height: ResponsiveUtils.rp(6),
                              decoration: BoxDecoration(
                                color: isActive 
                                    ? AppColors.button 
                                    : AppColors.grey300.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(3)),
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: AppColors.button.withValues(alpha: 0.6),
                                          blurRadius: ResponsiveUtils.rp(6),
                                          offset: Offset(0, ResponsiveUtils.rp(2)),
                                          spreadRadius: ResponsiveUtils.rp(1),
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          
          SizedBox(height: ResponsiveUtils.rp(12)),
        ],
      );
    });
  }
}
