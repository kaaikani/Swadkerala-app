import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/banner/bannermodels.dart';
import 'dart:async';

import '../controllers/utilitycontroller/utilitycontroller.dart';




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

    _pageController = PageController(viewportFraction: 0.85, initialPage: _initialPage);

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
      if (utilityController.isLoadingRx.value) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final banners = bannerController.bannerList;

      if (banners.isEmpty) {
        // Trigger fetch again when no banners present
        Future.microtask(() {
          if (!utilityController.isLoadingRx.value) {
            bannerController.getBannersForChannel();
          }
        });

        return const SizedBox(
          height: 200,

        );

      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                final BannerModel banner = banners[index % banners.length];
                final String imageUrl =
                banner.assets.isNotEmpty ? banner.assets.first.source : '';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.black38,
                    child: ClipRRect(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 50),
                                ),
                              );
                            },
                          )
                              : Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image, size: 50),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.25),
                                  Colors.transparent
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
                  (index) {
                bool isActive = (_currentPage % banners.length) == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.blueAccent : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

