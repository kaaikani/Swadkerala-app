import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/banner/bannercontroller.dart';




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
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Colors.black54),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hintText,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
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
                  ? Image.network(item.previewImage!, width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 50),
              title: Text(item.productVariantName ?? item.productName),
            );
          },
        );
      }),
    );
  }
}
