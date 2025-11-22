import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/banner/bannercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/product/product_models.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../utils/price_formatter.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/responsive_text.dart';
import '../widgets/responsive_icon.dart';
import '../widgets/shimmers.dart';
import '../widgets/snackbar.dart';
import '../services/analytics_service.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  final String? productName;

  const ProductDetailPage({
    Key? key,
    required this.productId,
    this.productName,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final BannerController bannerController = Get.find<BannerController>();
  final CartController cartController = Get.find<CartController>();
  final UtilityController utilityController = Get.find<UtilityController>();

  ProductDetailModel? productDetail;
  ProductVariantDetailModel? selectedVariant;
  PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = false;
  int _selectedQuantity = 1;
  final GlobalKey _descriptionKey = GlobalKey();
  bool _hasFetchedData = false; // Track if we've attempted to fetch

  @override
  void initState() {
    super.initState();
    // Set loading state immediately after first frame to show shimmer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      utilityController.setLoadingState(true);
    });
    // Fetch data after a microtask to ensure loading state is set first
    Future.microtask(() {
      _fetchProductDetail();
      cartController.getActiveOrder();
      bannerController.getCustomerFavorites();
      
      // Track screen view
      AnalyticsService().logScreenView(screenName: 'ProductDetail');
    });
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  /// Get display name from variant options, fallback to variant name
  String _getVariantDisplayName(ProductVariantDetailModel variant) {
    // Always prefer showing option names over variant name
    if (variant.options.isNotEmpty) {
      // Join all option names with comma and space
      final optionNames = variant.options
          .where((option) => option.name != null && option.name!.isNotEmpty)
          .map((option) => option.name!)
          .join(', ');
      if (optionNames.isNotEmpty) {
        debugPrint(
            '[ProductDetailPage] Variant ID: ${variant.id}, Options: ${variant.options.length}, Option Names: $optionNames');
        return optionNames;
      }
    }
    // If no options, show variant name as fallback
    debugPrint(
        '[ProductDetailPage] Variant ID: ${variant.id}, No options found, using variant name: ${variant.name}');
    return variant.name;
  }

  Future<void> _fetchProductDetail() async {
    // getProductDetail handles loading state internally - sets it to true at start, false at end
    final data =
        await bannerController.getProductDetail(productId: widget.productId);

    if (mounted) {
      setState(() {
        _hasFetchedData = true; // Mark that we've completed the fetch attempt
        if (data != null) {
          productDetail = ProductDetailModel.fromJson(data);
          
          // Track product view
          if (productDetail!.variants.isNotEmpty) {
            final variant = productDetail!.variants.first;
            final price = variant.priceWithTax != null ? variant.priceWithTax! / 100.0 : 0.0;
            AnalyticsService().logViewItem(
              itemId: variant.id,
              itemName: widget.productName ?? productDetail!.name,
              itemCategory: productDetail!.name,
              price: price,
              currency: 'INR',
            );
          }
          
          if (productDetail!.variants.isNotEmpty) {
            selectedVariant = productDetail!.variants.first;
          }
        }
      });
    }
  }

  List<String> _getAllImageUrls() {
    if (productDetail == null) return [];

    List<String> urls = [];

    // Add variant images first if selected
    if (selectedVariant != null) {
      if (selectedVariant!.featuredAsset != null) {
        urls.add(selectedVariant!.featuredAsset!.preview);
      }
      for (var asset in selectedVariant!.assets) {
        if (!urls.contains(asset.preview)) {
          urls.add(asset.preview);
        }
      }
    }

    // Add product featured asset
    if (productDetail!.featuredAsset != null) {
      final preview = productDetail!.featuredAsset!.preview;
      if (!urls.contains(preview)) {
        urls.insert(0, preview);
      }
    }

    // Add other product assets
    for (var asset in productDetail!.assets) {
      if (!urls.contains(asset.preview)) {
        urls.add(asset.preview);
      }
    }

    return urls.isEmpty ? [''] : urls;
  }

  Widget _buildAppBar() {
    final images = _getAllImageUrls();

    return SliverAppBar(
      expandedHeight: ResponsiveUtils.rp(300),
      floating: false,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back,
              color: AppColors.textPrimary, size: ResponsiveUtils.rp(20)),
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        Obx(() {
          final isFavorite =
              bannerController.isFavorite(productDetail?.id ?? '');
          return IconButton(
            icon: Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppColors.error : AppColors.textPrimary,
                size: ResponsiveUtils.rp(20),
              ),
            ),
            onPressed: () async {
              if (productDetail != null) {
                await bannerController.toggleFavorite(
                    productId: productDetail!.id);
              }
            },
          );
        }),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: images.isNotEmpty && images.first.isNotEmpty
            ? Stack(
                children: [
                  PageView.builder(
                    controller: _imagePageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Skeletons.imageRect(
                            height: ResponsiveUtils.rp(300),
                            width: double.infinity,
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.grey200,
                          child: Center(
                            child: Icon(Icons.image,
                                size: ResponsiveUtils.rp(60),
                                color: AppColors.textTertiary),
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
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
                  // Image indicator dots
                  if (images.length > 1)
                    Positioned(
                      bottom: ResponsiveUtils.rp(16),
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(4)),
                            width: ResponsiveUtils.rp(8),
                            height: ResponsiveUtils.rp(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Skeletons.imageRect(
                height: ResponsiveUtils.rp(300),
                width: double.infinity,
              ),
      ),
    );
  }

  Widget _buildContent() {
    if (productDetail == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name and Price Card
        Container(
          margin: EdgeInsets.all(ResponsiveUtils.rp(16)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: ResponsiveUtils.rp(8),
                offset: Offset(0, ResponsiveUtils.rp(2)),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedVariant != null)
                ResponsiveText(
                  selectedVariant!.name,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              if (selectedVariant != null) ResponsiveSpacing.vertical(12),
              if (selectedVariant != null &&
                  selectedVariant!.priceWithTax != null)
                Row(
                  children: [
                    ResponsiveText(
                      PriceFormatter.formatPriceFromDouble(
                          selectedVariant!.priceWithTax!),
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.button,
                    ),
                    if (selectedVariant!.stockLevel > 0 ||
                        selectedVariant!.stockLevel >= 999) ...[
                      SizedBox(width: ResponsiveUtils.rp(16)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(10),
                          vertical: ResponsiveUtils.rp(6),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(ResponsiveUtils.rp(6)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle,
                                color: AppColors.success,
                                size: ResponsiveUtils.rp(14)),
                            SizedBox(width: ResponsiveUtils.rp(4)),
                            ResponsiveText(
                              'In Stock',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      SizedBox(width: ResponsiveUtils.rp(16)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(10),
                          vertical: ResponsiveUtils.rp(6),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(ResponsiveUtils.rp(6)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cancel,
                                color: AppColors.error,
                                size: ResponsiveUtils.rp(14)),
                            SizedBox(width: ResponsiveUtils.rp(4)),
                            ResponsiveText(
                              'Out of Stock',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),

        // Variant Selection - Dropdown
        if (productDetail!.variants.length > 1) ...[
          Container(
            margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: ResponsiveUtils.rp(4),
                  offset: Offset(0, ResponsiveUtils.rp(2)),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  'Select Variant',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                ResponsiveSpacing.vertical(12),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    border: Border.all(
                      color: AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ProductVariantDetailModel>(
                      value: selectedVariant,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.button,
                        size: ResponsiveUtils.rp(24),
                      ),
                      items: productDetail!.variants.map((variant) {
                        // Use option names instead of variant name
                        final displayName = _getVariantDisplayName(variant);

                        return DropdownMenuItem<ProductVariantDetailModel>(
                          value: variant,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  displayName,
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(15),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (variant.priceWithTax != null) ...[
                                SizedBox(width: ResponsiveUtils.rp(8)),
                                Text(
                                  PriceFormatter.formatPriceFromDouble(
                                      variant.priceWithTax!),
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(14),
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.button,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (variant) {
                        if (variant != null) {
                          setState(() {
                            selectedVariant = variant;
                            _selectedQuantity =
                                1; // Reset quantity when variant changes
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ResponsiveSpacing.vertical(20),
        ],

        // Description
        if (productDetail!.description != null &&
            productDetail!.description!.isNotEmpty) ...[
          Container(
            key: _descriptionKey,
            margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: ResponsiveUtils.rp(4),
                  offset: Offset(0, ResponsiveUtils.rp(2)),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.description,
                        color: AppColors.button, size: ResponsiveUtils.rp(20)),
                    SizedBox(width: ResponsiveUtils.rp(8)),
                    ResponsiveText(
                      'About Product',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
                ResponsiveSpacing.vertical(12),
                _isDescriptionExpanded
                    ? Html(
                        data: productDetail!.description ?? '',
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(ResponsiveUtils.sp(14)),
                            lineHeight: LineHeight(1.6),
                            color: AppColors.textSecondary,
                          ),
                          "p": Style(
                            margin: Margins.only(bottom: ResponsiveUtils.rp(8)),
                            padding: HtmlPaddings.zero,
                          ),
                          "h1": Style(
                            fontSize: FontSize(ResponsiveUtils.sp(20)),
                            fontWeight: FontWeight.w700,
                            margin:
                                Margins.only(bottom: ResponsiveUtils.rp(12)),
                          ),
                          "h2": Style(
                            fontSize: FontSize(ResponsiveUtils.sp(18)),
                            fontWeight: FontWeight.w700,
                            margin:
                                Margins.only(bottom: ResponsiveUtils.rp(10)),
                          ),
                          "h3": Style(
                            fontSize: FontSize(ResponsiveUtils.sp(16)),
                            fontWeight: FontWeight.w600,
                            margin: Margins.only(bottom: ResponsiveUtils.rp(8)),
                          ),
                          "ul": Style(
                            margin: Margins.only(
                                left: ResponsiveUtils.rp(16),
                                bottom: ResponsiveUtils.rp(8)),
                          ),
                          "ol": Style(
                            margin: Margins.only(
                                left: ResponsiveUtils.rp(16),
                                bottom: ResponsiveUtils.rp(8)),
                          ),
                          "li": Style(
                            margin: Margins.only(bottom: ResponsiveUtils.rp(4)),
                          ),
                          "strong": Style(
                            fontWeight: FontWeight.w700,
                          ),
                          "b": Style(
                            fontWeight: FontWeight.w700,
                          ),
                          "em": Style(
                            fontStyle: FontStyle.italic,
                          ),
                          "i": Style(
                            fontStyle: FontStyle.italic,
                          ),
                        },
                      )
                    : Stack(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // Calculate height for 3 lines: fontSize * lineHeight * 3
                              final fontSize = ResponsiveUtils.sp(14);
                              final lineHeight = 1.6;
                              final maxHeight = fontSize * lineHeight * 3;

                              return ClipRect(
                                child: SizedBox(
                                  height: maxHeight,
                                  child: SingleChildScrollView(
                                    physics: NeverScrollableScrollPhysics(),
                                    child: Html(
                                      data: productDetail!.description ?? '',
                                      style: {
                                        "body": Style(
                                          margin: Margins.zero,
                                          padding: HtmlPaddings.zero,
                                          fontSize:
                                              FontSize(ResponsiveUtils.sp(14)),
                                          lineHeight: LineHeight(1.6),
                                          color: AppColors.textSecondary,
                                        ),
                                        "p": Style(
                                          margin: Margins.only(
                                              bottom: ResponsiveUtils.rp(8)),
                                          padding: HtmlPaddings.zero,
                                        ),
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: ResponsiveUtils.rp(40),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withValues(alpha: 0),
                                    Colors.white,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                ResponsiveSpacing.vertical(8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isDescriptionExpanded = !_isDescriptionExpanded;
                    });
                  },
                  child: Text(
                    _isDescriptionExpanded ? 'Show Less' : 'Show More',
                    style: TextStyle(
                      color: AppColors.button,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ResponsiveSpacing.vertical(20),
        ],

        // Product Info Section
        Container(
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
          ),
          child: Column(
            children: [
              if (selectedVariant?.sku != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ResponsiveText(
                      'SKU',
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    ResponsiveText(
                      selectedVariant!.sku!,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              if (selectedVariant?.sku != null) ResponsiveSpacing.vertical(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResponsiveText(
                    'Stock Level',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  ResponsiveText(
                    selectedVariant!.stockLevel >= 999
                        ? 'Available'
                        : '${selectedVariant!.stockLevel}',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ],
          ),
        ),
        ResponsiveSpacing.vertical(80), // Space for bottom bar
      ],
    );
  }

  int _getCartQuantity() {
    if (selectedVariant == null) return 0;
    final variantId = int.tryParse(selectedVariant!.id);
    if (variantId == null) return 0;

    final orderLines = cartController.cart.value?.lines ?? [];
    for (var line in orderLines) {
      if (line.productVariant.id == variantId.toString()) {
        return line.quantity;
      }
    }
    return 0;
  }

  Future<void> _addToCart({int? quantity}) async {
    if (selectedVariant == null) return;

    final variantId = int.tryParse(selectedVariant!.id);
    if (variantId == null) {
      if (mounted) {
        showErrorSnackbar('Invalid variant ID');
      }
      return;
    }

    final qty = quantity ?? _selectedQuantity;
    final success = await cartController.addToCart(
        productVariantId: variantId, quantity: qty);

    if (!mounted) return; // Widget was disposed during async operation

    if (success) {
      final displayName = _getVariantDisplayName(selectedVariant!);
      showSuccessSnackbar('$displayName added to cart');
      setState(() {
        _selectedQuantity = 1;
      });
    } else {
      showErrorSnackbar('Failed to add to cart');
    }
  }

  /// Get the dropdown value, ensuring it's always valid and exists in the items list
  int? _getDropdownValue(int cartQuantity) {
    // Build the items list to check what values are available
    final items = _buildQuantityDropdownItems(cartQuantity);
    final availableValues = items.map((item) => item.value).toList();
    
    if (cartQuantity > 0) {
      // If cart quantity exists in the items list, use it
      if (availableValues.contains(cartQuantity)) {
        return cartQuantity;
      }
      // If cart quantity is 1, 2, or 3, use it (should always be in list)
      if (cartQuantity >= 1 && cartQuantity <= 3) {
        return cartQuantity;
      }
      // For custom quantities (> 3) that aren't in the list yet, default to 1
      // The items list will be rebuilt with cartQuantity on next build
      return 1;
    }
    
    // Ensure _selectedQuantity is valid and exists in the items list
    if (availableValues.contains(_selectedQuantity)) {
      return _selectedQuantity;
    }
    
    // Default to 1 if invalid (1 should always be in the list)
    return 1;
  }

  /// Build dropdown items, including cart quantity if it's custom (> 3)
  List<DropdownMenuItem<int>> _buildQuantityDropdownItems(int cartQuantity) {
    final items = <DropdownMenuItem<int>>[
      DropdownMenuItem<int>(
        value: 1,
        child: Center(
          child: Text(
            '1',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
      DropdownMenuItem<int>(
        value: 2,
        child: Center(
          child: Text(
            '2',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
      DropdownMenuItem<int>(
        value: 3,
        child: Center(
          child: Text(
            '3',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    ];

    // Add cart quantity if it's custom (> 3) and not already in the list
    if (cartQuantity > 3) {
      items.add(
        DropdownMenuItem<int>(
          value: cartQuantity,
          child: Center(
            child: Text(
              '$cartQuantity',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w700,
                color: AppColors.button,
              ),
            ),
          ),
        ),
      );
    }

    // Add "More" option
    items.add(
      DropdownMenuItem<int>(
        value: -1, // Special value for "More"
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'More',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.button,
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(4)),
              Icon(
                Icons.add_circle_outline,
                size: ResponsiveUtils.rp(16),
                color: AppColors.button,
              ),
            ],
          ),
        ),
      ),
    );

    return items;
  }

  Future<void> _showQuantityDialog() async {
    const maxQuantity = 20;
    
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return _QuantityDialogWidget(
          maxQuantity: maxQuantity,
          onAdd: (quantity) {
            Navigator.pop(dialogContext, quantity);
          },
        );
      },
    );
    
    // Handle the result after dialog is closed
    if (result != null && mounted) {
      // Wait a frame to ensure dialog is fully closed
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) {
        await _addToCart(quantity: result);
      }
    }
  }

  Widget _buildBottomBar() {
    if (selectedVariant == null) return SizedBox.shrink();

    final cartQuantity = _getCartQuantity();
    final isOutOfStock =
        selectedVariant!.stockLevel <= 0 && selectedVariant!.stockLevel < 999;

    // Zomato-style UI: Quantity dropdown + Add to Cart button
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, -ResponsiveUtils.rp(2)),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quantity dropdown - Zomato style
            Container(
              width: ResponsiveUtils.rp(80),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _getDropdownValue(cartQuantity),
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.button,
                    size: ResponsiveUtils.rp(20),
                  ),
                  items: _buildQuantityDropdownItems(cartQuantity),
                  onChanged: isOutOfStock
                      ? null
                      : (value) async {
                          if (value == -1) {
                            // Open dialog for custom quantity
                            await _showQuantityDialog();
                          } else if (value != null) {
                            setState(() {
                              _selectedQuantity = value;
                            });
                            await _addToCart(quantity: value);
                          }
                        },
                  selectedItemBuilder: (context) {
                    // selectedItemBuilder must return a list with the same length as items
                    // Each item corresponds to the item at that index in the items list
                    final items = _buildQuantityDropdownItems(cartQuantity);
                    return items.map((item) {
                      final isSelected = item.value == _getDropdownValue(cartQuantity);
                      final isCartQuantity = item.value == cartQuantity && cartQuantity > 0;
                      return DropdownMenuItem<int>(
                        value: item.value,
                        child: Center(
                          child: Text(
                            item.value == -1
                                ? 'More'
                                : '${item.value}',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(16),
                              fontWeight: isSelected || isCartQuantity
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: isSelected || isCartQuantity
                                  ? AppColors.button
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),

            SizedBox(width: ResponsiveUtils.rp(12)),

            // Add to Cart button - Zomato style
            Expanded(
              child: Container(
                height: ResponsiveUtils.rp(48),
                decoration: BoxDecoration(
                  color: isOutOfStock ? AppColors.grey300 : AppColors.button,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isOutOfStock ? null : () => _addToCart(),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cartQuantity > 0
                              ? Icons.shopping_cart
                              : Icons.add_shopping_cart,
                          color: Colors.white,
                          size: ResponsiveUtils.rp(20),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(8)),
                        Text(
                          cartQuantity > 0 ? 'Update Cart' : 'Add to Cart',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(15),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final isLoading = utilityController.isLoadingRx.value;

        // Show shimmer loading while fetching or when productDetail is null initially
        // This ensures shimmer shows immediately on page load (like Instagram/YouTube)
        // Only show "Product not found" after fetch completes AND productDetail is still null
        if (!_hasFetchedData || isLoading) {
          // Haven't fetched yet or currently loading - show shimmer
          return _buildShimmerLoading();
        }

        // If fetch completed but no product data, show error
        if (_hasFetchedData && productDetail == null && !isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ResponsiveIcon(Icons.error_outline,
                    size: 64, color: AppColors.error),
                ResponsiveSpacing.vertical(16),
                ResponsiveText(
                  'Product not found',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                ResponsiveSpacing.vertical(24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.rp(24),
                        vertical: ResponsiveUtils.rp(12)),
                  ),
                  child: Text('Go Back', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        // If productDetail is still null but we haven't checked properly, show shimmer as fallback
        if (productDetail == null) {
          return _buildShimmerLoading();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await _fetchProductDetail();
          },
          color: AppColors.refreshIndicator,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: _buildContent(),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildShimmerLoading() {
    return Skeletonizer(
      enabled: true,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          _buildAppBarShimmer(),
          SliverToBoxAdapter(
            child: _buildContentShimmer(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarShimmer() {
    return SliverAppBar(
      expandedHeight: ResponsiveUtils.rp(300),
      floating: false,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: Container(
        margin: EdgeInsets.all(ResponsiveUtils.rp(8)),
        padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_back,
            color: Colors.transparent, size: ResponsiveUtils.rp(20)),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(ResponsiveUtils.rp(8)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.favorite_border,
              color: Colors.transparent, size: ResponsiveUtils.rp(20)),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Skeletons.imageRect(
          height: ResponsiveUtils.rp(300),
          width: double.infinity,
          radius: 0,
        ),
      ),
    );
  }

  Widget _buildContentShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name and Price Card Shimmer
        Container(
          margin: EdgeInsets.all(ResponsiveUtils.rp(16)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product name shimmer
              Container(
                height: ResponsiveUtils.rp(28),
                width: ResponsiveUtils.rp(180),
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              // Price and stock status shimmer
              Row(
                children: [
                  Container(
                    height: ResponsiveUtils.rp(32),
                    width: ResponsiveUtils.rp(110),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(16)),
                  Container(
                    height: ResponsiveUtils.rp(28),
                    width: ResponsiveUtils.rp(85),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(6)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Variant Selection Dropdown Shimmer
        Container(
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Select Variant" label shimmer
              Container(
                height: ResponsiveUtils.rp(20),
                width: ResponsiveUtils.rp(120),
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              // Dropdown shimmer
              Container(
                height: ResponsiveUtils.rp(48),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(20)),

        // Description Section Shimmer
        Container(
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "About Product" header with icon shimmer
              Row(
                children: [
                  Container(
                    height: ResponsiveUtils.rp(20),
                    width: ResponsiveUtils.rp(20),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Container(
                    height: ResponsiveUtils.rp(20),
                    width: ResponsiveUtils.rp(140),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              // Description lines shimmer
              Container(
                height: ResponsiveUtils.rp(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(8)),
              Container(
                height: ResponsiveUtils.rp(16),
                width: ResponsiveUtils.rp(280),
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(8)),
              Container(
                height: ResponsiveUtils.rp(16),
                width: ResponsiveUtils.rp(200),
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(8)),
              Container(
                height: ResponsiveUtils.rp(16),
                width: ResponsiveUtils.rp(240),
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(8)),
              // "Show More" button shimmer
              Container(
                height: ResponsiveUtils.rp(36),
                width: ResponsiveUtils.rp(100),
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(20)),

        // Product Info Section Shimmer (SKU, Stock, Currency)
        Container(
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
          ),
          child: Column(
            children: [
              // SKU row shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: ResponsiveUtils.rp(16),
                    width: ResponsiveUtils.rp(50),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                  Container(
                    height: ResponsiveUtils.rp(16),
                    width: ResponsiveUtils.rp(70),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              // Stock row shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: ResponsiveUtils.rp(16),
                    width: ResponsiveUtils.rp(110),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                  Container(
                    height: ResponsiveUtils.rp(16),
                    width: ResponsiveUtils.rp(80),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              // Currency row shimmer
            ],
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(80)), // Space for bottom bar
      ],
    );
  }
}

/// Separate StatefulWidget for quantity dialog to properly manage TextEditingController lifecycle
class _QuantityDialogWidget extends StatefulWidget {
  final int maxQuantity;
  final Function(int) onAdd;

  const _QuantityDialogWidget({
    required this.maxQuantity,
    required this.onAdd,
  });

  @override
  State<_QuantityDialogWidget> createState() => _QuantityDialogWidgetState();
}

class _QuantityDialogWidgetState extends State<_QuantityDialogWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
      ),
      title: ResponsiveText(
        'Enter Quantity',
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Quantity (Max: ${widget.maxQuantity})',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                ),
              ),
              onChanged: (value) {
                // Limit input to maxQuantity
                final qty = int.tryParse(value);
                if (qty != null && qty > widget.maxQuantity) {
                  _controller.text = widget.maxQuantity.toString();
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length),
                  );
                }
              },
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
            Text(
              'Maximum quantity: ${widget.maxQuantity}',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(12),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            final qty = int.tryParse(_controller.text);
            if (qty != null && qty > 0) {
              if (qty > widget.maxQuantity) {
                // Use Get.snackbar to avoid context issues
                Get.snackbar(
                  'Error',
                  'Maximum quantity is ${widget.maxQuantity}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
                return;
              }
              widget.onAdd(qty);
            } else {
              // Use Get.snackbar to avoid context issues
              Get.snackbar(
                'Error',
                'Please enter a valid quantity',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.button,
          ),
          child: Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
