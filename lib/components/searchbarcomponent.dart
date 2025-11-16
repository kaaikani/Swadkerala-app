import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/banner/bannercontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_widgets.dart';

class SearchComponent extends StatelessWidget {
  const SearchComponent({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search products...',
  }) : super(key: key);

  final Function(String) onSearch;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/search');
      },
      child: ResponsiveContainer(
        height: ResponsiveUtils.rp(44),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(14.0)),
        backgroundColor: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
          ),
        ],
        child: Row(
          children: [
            ResponsiveIcon(Icons.search,
                color: AppColors.textSecondary, size: 20),
            ResponsiveSpacing.horizontal(10),
            Expanded(
              child: ResponsiveText(
                hintText,
                style: ResponsiveTextStyles.bodyMedium(
                    color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenSearchPage extends StatefulWidget {
  const FullScreenSearchPage({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search products...',
  }) : super(key: key);

  final Function(String) onSearch;
  final String hintText;

  @override
  State<FullScreenSearchPage> createState() => _FullScreenSearchPageState();
}

class _FullScreenSearchPageState extends State<FullScreenSearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final text = _controller.text.trim();
      widget.onSearch(text); // trigger BannerController search
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BannerController bannerController = Get.find<BannerController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      bannerController.searchResults.clear(); // reset results
                    },
                  )
                : null,
          ),
        ),
      ),
      body: Obx(() {
        final results = bannerController.searchResults;

        if (results.isEmpty) {
          return const Center(child: Text('No results'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return ListTile(
              leading: item.previewImage != null
                  ? Image.network(item.previewImage!,
                      width: ResponsiveUtils.rp(50),
                      height: ResponsiveUtils.rp(50),
                      fit: BoxFit.cover)
                  : Icon(Icons.image, size: ResponsiveUtils.rp(50)),
              title: Text(item.productVariantName ?? item.productName,
                  style: TextStyle(fontSize: ResponsiveUtils.sp(14))),
            );
          },
        );
      }),
    );
  }
}
