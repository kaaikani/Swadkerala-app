import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/banner/bannercontroller.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/banner/bannermodels.dart';
import 'dart:async';

import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_container.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/responsive_icon.dart';

class BannerComponent extends StatefulWidget {
  const BannerComponent({super.key});

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  final BannerController bannerController = Get.find<BannerController>();
  late final PageController _pageController;
  Timer? _timer;
  static const int _initialPage = 1000;
  int _currentPage = _initialPage;
  final UtilityController utilityController = Get.find();

  @override
  void initState() {
    super.initState();

    _pageController =
        PageController(viewportFraction: 1.0, initialPage: _initialPage);

    // Schedule banner fetch after build phase to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bannerController.bannerList.isEmpty) {
        bannerController.getBannersForChannel();
      }
    });

    // Listen to manual scroll to update dots
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? _initialPage;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });

    // Auto-scroll timer
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || bannerController.bannerList.isEmpty) return;

      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
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
      if (banners.isEmpty) {
        return ResponsiveContainer(
          height: ResponsiveUtils.rp(200),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.zomatoRed.withValues(alpha: 0.3),
              AppColors.zomatoRed.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.zero,
          child: Center(
            child: ResponsiveIcon(
              Icons.image_outlined,
              size: 50,
              color: AppColors.textTertiary,
            ),
          ),
        );
      }

      return Skeletonizer(
        enabled: isLoading,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: ResponsiveUtils.rp(220),
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  // Safety check to prevent division by zero (defensive programming)
                  if (banners.isEmpty) {
                    return ResponsiveContainer(
                      gradient: LinearGradient(
                        colors: [AppColors.grey200, AppColors.grey300],
                      ),
                      borderRadius: BorderRadius.zero,
                      child: SizedBox.shrink(),
                    );
                  }

                  final BannerModel banner = banners[index % banners.length];
                  final String imageUrl = banner.assets.isNotEmpty
                      ? banner.assets.first.source
                      : '';

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(0),
                      vertical: ResponsiveUtils.rp(8),
                    ),
                    child: Stack(
                        fit: StackFit.expand,
                        children: [
                          imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Container(
                                      color: AppColors.grey200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.zomatoRed,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.grey200,
                                            AppColors.grey300
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.broken_image,
                                            size: ResponsiveUtils.rp(50),
                                            color: AppColors.textTertiary),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.grey200,
                                        AppColors.grey300
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.image,
                                        size: ResponsiveUtils.rp(50),
                                        color: AppColors.textTertiary),
                                  ),
                                ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.1),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ],
                      ),
                  );
                },
              ),
            ),
            ResponsiveSpacing.vertical(20),
            // Only show dots if banners exist
            if (banners.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  banners.length,
                  (index) {
                    // Calculate active dot (banners is guaranteed non-empty due to outer check)
                    bool isActive = (_currentPage % banners.length) == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      margin: ResponsiveSpacing.padding(horizontal: 5),
                      width: isActive
                          ? ResponsiveUtils.rp(32)
                          : ResponsiveUtils.rp(10),
                      height: ResponsiveUtils.rp(10),
                      decoration: BoxDecoration(
                        color:
                            isActive ? AppColors.zomatoRed : AppColors.grey300,
                        borderRadius:
                            BorderRadius.circular(ResponsiveUtils.rp(16)),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.zomatoRed
                                      .withValues(alpha: 0.5),
                                  blurRadius: ResponsiveUtils.rp(12),
                                  offset: Offset(0, ResponsiveUtils.rp(3)),
                                  spreadRadius: ResponsiveUtils.rp(2),
                                ),
                              ]
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ResponsiveSpacing.vertical(12),
          ],
        ),
      );
    });
  }
}
