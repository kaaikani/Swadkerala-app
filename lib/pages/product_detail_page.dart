import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../graphql/product.graphql.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../utils/price_formatter.dart';
import '../utils/app_strings.dart';
import '../utils/app_config.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/responsive_text.dart';
import '../widgets/responsive_icon.dart';
import '../widgets/shimmers.dart';
import '../widgets/snackbar.dart';
import '../widgets/cart_button_with_badge.dart';
import '../widgets/cached_app_image.dart';
import '../widgets/stock_level_label.dart';
import '../services/analytics_service.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  final String? productName;
  final String? selectedVariantId;

  const ProductDetailPage({
    Key? key,
    required this.productId,
    this.productName,
    this.selectedVariantId,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final BannerController bannerController = Get.find<BannerController>();
  final CartController cartController = Get.find<CartController>();
  final UtilityController utilityController = Get.find<UtilityController>();

  Query$GetProductDetail$product? productDetail;
  Query$GetProductDetail$product$variants? selectedVariant;
  /// Selected option per group (groupName -> optionName). Used for variant resolution when product has option groups.
  Map<String, String> _selectedOptionsByGroup = {};
  Map<String, dynamic>? _rawProductData; // Store raw JSON data for shadow price
  PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = false;
  int _selectedQuantity = 1;
  final GlobalKey _descriptionKey = GlobalKey();
  bool _hasFetchedData = false; // Track if we've attempted to fetch
  bool _hasInitialized = false; // Flag to prevent multiple initializations
  bool _isAddedToCart = false; // Track if item was successfully added to cart

  @override
  void initState() {
    super.initState();
    
    // Only initialize once
    if (_hasInitialized) {
      return;
    }
    
    _hasInitialized = true;
    
    // Set loading state immediately after first frame to show shimmer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      utilityController.setLoadingState(true);
    });
    // Fetch data after a microtask to ensure loading state is set first
    Future.microtask(() {
      _fetchProductDetail();
      cartController.getActiveOrder();
      bannerController.getCustomerFavorites();
      // Product view is tracked once via logViewItem (ViewContent) when data loads - no separate screen_view to avoid duplicate Meta outcome triggers
    });
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  /// Get display name from variant options, fallback to variant name
  String _getVariantDisplayName(Query$GetProductDetail$product$variants variant) {
    // Always prefer showing option names over variant name
    if (variant.options.isNotEmpty) {
      // Join all option names with comma and space
      final optionNames = variant.options
          .where((option) => option.name.isNotEmpty)
          .map((option) => option.name)
          .join(', ');
      if (optionNames.isNotEmpty) {
        return optionNames;
      }
    }
    // If no options, show variant name as fallback
    return variant.name;
  }

  /// Build selected-options map from a variant (group key -> option.name); uses inferred key when group is synthetic.
  Map<String, String> _selectedOptionsFromVariant(Query$GetProductDetail$product$variants variant) {
    final map = <String, String>{};
    for (final opt in variant.options) {
      map[_optionGroupKey(opt)] = opt.name;
    }
    return map;
  }

  /// Key for _selectedOptionsByGroup: use the group name from the API.
  String _optionGroupKey(Query$GetProductDetail$product$variants$options opt) {
    return opt.group.name;
  }

  /// Option groups derived from variants, using group names from the API.
  List<_OptionGroup> _getOptionGroups() {
    if (productDetail == null || productDetail!.variants.isEmpty) return [];
    final order = <String>[];
    final map = <String, Set<String>>{};
    for (final v in productDetail!.variants) {
      for (final opt in v.options) {
        final gn = opt.group.name;
        if (!order.contains(gn)) order.add(gn);
        map.putIfAbsent(gn, () => <String>{}).add(opt.name);
      }
    }
    return order.map((gn) {
      final names = (map[gn] ?? {}).toList()..sort();
      return _OptionGroup(gn, names);
    }).toList();
  }


  /// Find variant that matches current _selectedOptionsByGroup; null if no match.
  Query$GetProductDetail$product$variants? _findVariantBySelectedOptions() {
    if (productDetail == null) return null;
    for (final v in productDetail!.variants) {
      if (v.options.every((opt) => _selectedOptionsByGroup[_optionGroupKey(opt)] == opt.name)) {
        return v;
      }
    }
    return null;
  }

  /// True if choosing [optionName] for [groupName] (keeping other selections) would match an available variant.
  bool _isOptionAvailable(String groupName, String optionName) {
    if (productDetail == null) return false;
    final hypothetical = Map<String, String>.from(_selectedOptionsByGroup)..[groupName] = optionName;
    for (final v in productDetail!.variants) {
      if (v.options.every((opt) => hypothetical[_optionGroupKey(opt)] == opt.name)) return true;
    }
    return false;
  }

  /// True if product has option groups (multiple groups or multiple options in any group).
  bool get _hasOptionGroups {
    if (productDetail == null || productDetail!.variants.isEmpty) return false;
    final groups = _getOptionGroups();
    if (groups.isEmpty) return false;
    return groups.length > 1 || groups.any((g) => g.optionNames.length > 1);
  }

  /// Calculate discount percentage from shadow price - same logic as category product page
  double? _calculateDiscountPercent(Query$GetProductDetail$product$variants variant) {
    final shadowPriceMinor = _getShadowPriceFromRawData(variant);
    if (shadowPriceMinor == null) {
      return null;
    }

    // priceWithTax is in minor units (paise) as double
    // e.g., 12000.0 = 120 rupees = 12000 paise
    final currentPriceMinor = variant.priceWithTax.round();
    if (shadowPriceMinor <= currentPriceMinor) {
      return null;
    }

    final discount = ((shadowPriceMinor - currentPriceMinor) / shadowPriceMinor) * 100;
    if (discount <= 0) {
      return null;
    }
    return discount;
  }

  /// Format MRP price without "Rs" prefix
  String _formatMRPPrice(int priceInPaise) {
    final amount = priceInPaise / 100;
    final bool isWholeNumber = (amount % 1).abs() < 0.0001;
    final String value =
        isWholeNumber ? PriceFormatter.addCommas(amount.toInt().toString()) : PriceFormatter.addCommas(amount.toStringAsFixed(2));
    return value;
  }

  /// Clean product data: keep options, inject group from product-level optionGroups when API omits group on an option.
  Map<String, dynamic> _cleanProductData(Map<String, dynamic> data) {
    try {
      final cleaned = Map<String, dynamic>.from(data);

      // Build lookup from product-level optionGroups for fallback
      final optionGroups = (cleaned['optionGroups'] as List?)
          ?.whereType<Map<String, dynamic>>()
          .toList() ?? [];

      if (cleaned['variants'] != null && cleaned['variants'] is List) {
        final variants = (cleaned['variants'] as List).map((variant) {
          if (variant is! Map<String, dynamic>) return variant;
          final cleanedVariant = Map<String, dynamic>.from(variant);

          if (cleanedVariant['options'] != null && cleanedVariant['options'] is List) {
            final optionsList = (cleanedVariant['options'] as List)
                .where((o) => o != null && o is Map<String, dynamic>)
                .cast<Map<String, dynamic>>()
                .toList();
            for (var i = 0; i < optionsList.length; i++) {
              final optionMap = optionsList[i];
              final group = optionMap['group'];
              if (group == null || group is! Map<String, dynamic>) {
                // Use product-level optionGroups name if available, otherwise fallback
                final groupName = (i < optionGroups.length)
                    ? (optionGroups[i]['name'] as String? ?? 'Option ${i + 1}')
                    : 'Option ${i + 1}';
                optionMap['group'] = <String, dynamic>{
                  'name': groupName,
                  '__typename': 'ProductOptionGroup',
                };
              }
            }
            cleanedVariant['options'] = optionsList;
          }

          return cleanedVariant;
        }).toList();
        cleaned['variants'] = variants;
      }

      return cleaned;
    } catch (e) {
      return data;
    }
  }

  /// Get shadow price from raw data - same logic as category product page
  int? _getShadowPriceFromRawData(Query$GetProductDetail$product$variants variant) {
    try {
      if (_rawProductData == null) {
        return null;
      }

      // Find the variant in the raw data
      final variants = _rawProductData!['variants'] as List?;
      if (variants == null) {
        return null;
      }

      for (var variantData in variants) {
        final variantId = variantData['id'];
        
        if (variantId == variant.id) {
          // Access customFields - same way as category product page
          final customFields = variantData['customFields'];
          if (customFields == null) {
            return null;
          }

          final rawValue = customFields['shadowPrice'];
          if (rawValue == null || rawValue <= 0) {
            return null;
          }

          // priceWithTax is in minor units (paise) as double
          // e.g., 12000.0 = 120 rupees = 12000 paise
          final currentPriceMinor = variant.priceWithTax.round();

          // If the stored value already looks like minor units (>= current price), use it directly
          if (rawValue > currentPriceMinor) {
            return rawValue.toInt();
          }

          // Some catalog entries may store shadow price in rupees; scale up to paise
          final scaledValue = (rawValue as num) * 100;
          if (scaledValue > currentPriceMinor) {
            return scaledValue.toInt();
          }

          return null;
        }
      }
    } catch (e) {
    }
    return null;
  }

  Future<void> _fetchProductDetail() async {
    // getProductDetail handles loading state internally - sets it to true at start, false at end
    final data =
        await bannerController.getProductDetail(productId: widget.productId);

    if (mounted) {
      setState(() {
        _hasFetchedData = true; // Mark that we've completed the fetch attempt
        if (data != null) {
          _rawProductData = data; // Store raw data for shadow price access
          // Clean the data to filter out null options before parsing
          final cleanedData = _cleanProductData(data);
          productDetail = Query$GetProductDetail$product.fromJson(cleanedData);
          
          // Track product view
          if (productDetail!.variants.isNotEmpty) {
            final variant = productDetail!.variants.first;
            final price = variant.priceWithTax / 100.0;
            AnalyticsService().logViewItem(
              itemId: variant.id,
              itemName: widget.productName ?? productDetail!.name,
              itemCategory: productDetail!.name,
              price: price,
              currency: 'INR',
            );
          }
          
          if (productDetail!.variants.isNotEmpty) {
            // Pre-select the variant the user had chosen on the category page
            final preSelected = widget.selectedVariantId != null
                ? productDetail!.variants.firstWhere(
                    (v) => v.id == widget.selectedVariantId,
                    orElse: () => productDetail!.variants.first,
                  )
                : productDetail!.variants.first;
            selectedVariant = preSelected;
            _selectedOptionsByGroup = _selectedOptionsFromVariant(preSelected);
          }
        }
      });
    }
  }

  List<String> _getAllImageUrls() {
    if (productDetail == null) return [];

    List<String> urls = [];
    final bool variantHasImage = selectedVariant != null &&
        (selectedVariant!.featuredAsset != null || selectedVariant!.assets.isNotEmpty);

    if (variantHasImage) {
      if (selectedVariant!.featuredAsset != null) {
        urls.add(selectedVariant!.featuredAsset!.preview);
      }
      for (var asset in selectedVariant!.assets) {
        if (!urls.contains(asset.preview)) urls.add(asset.preview);
      }
    }

    // Product image: primary when variant has no image, else fallback
    if (productDetail!.featuredAsset != null) {
      final preview = productDetail!.featuredAsset!.preview;
      if (!urls.contains(preview)) urls.insert(0, preview);
    }
    for (var asset in productDetail!.assets) {
      if (!urls.contains(asset.preview)) urls.add(asset.preview);
    }

    return urls.isEmpty ? [''] : urls;
  }

  Widget _buildAppBar() {
    final images = _getAllImageUrls();

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = isLandscape ? screenHeight * 0.55 : ResponsiveUtils.rp(300);
    return SliverAppBar(
      expandedHeight: imageHeight,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: 0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: ResponsiveUtils.rp(8),
                offset: Offset(0, ResponsiveUtils.rp(2)),
              ),
            ],
          ),
          child: Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary, size: ResponsiveUtils.rp(18)),
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        // Share button
      /*  Padding(
          padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
          child: Container(
            width: ResponsiveUtils.rp(48),
            height: ResponsiveUtils.rp(48),
            decoration: BoxDecoration(
              color: AppColors.card.withOpacity(0.95),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: ResponsiveUtils.rp(12),
                  offset: Offset(0, ResponsiveUtils.rp(4)),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _shareProduct,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(24)),
                child: Icon(
                  Icons.share_rounded,
                  color: AppColors.icon,
                  size: ResponsiveUtils.rp(22),
                ),
              ),
            ),
          ),
        ),  */
        // Cart button
        CartButtonWithBadge(
          cartController: cartController,
          useIconButton: false,
        ),
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
                      return CachedAppImage(
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                        height: imageHeight,
                        width: double.infinity,
                        cacheWidth: 800,
                        cacheHeight: 600,
                        errorWidget: Container(
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
                height: imageHeight,
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
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: ResponsiveUtils.rp(12),
                offset: Offset(0, ResponsiveUtils.rp(4)),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product / variant name (product name when no variant selected)
              ResponsiveText(
                selectedVariant != null ? selectedVariant!.name : productDetail!.name,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: 0.3,
              ),
              ResponsiveSpacing.vertical(16),
              if (selectedVariant != null)
                Builder(
                  builder: (context) {
                    final shadowPrice = _getShadowPriceFromRawData(selectedVariant!);
                    final discountPercent = _calculateDiscountPercent(selectedVariant!);
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price Row - Price and Discount on Left, SKU on Right
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left side - Price, Discount, and MRP
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Current Price Row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Current Price
                                      ResponsiveText(
                                        PriceFormatter.formatPriceFromDouble(
                                            selectedVariant!.priceWithTax),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.button,
                                      ),
                                      // Discount badge
                                      if (discountPercent != null) ...[
                                        SizedBox(width: ResponsiveUtils.rp(12)),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ResponsiveUtils.rp(12),
                                            vertical: ResponsiveUtils.rp(6),
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.error,
                                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                                          ),
                                          child: Text(
                                            '${discountPercent.round()}% OFF',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: ResponsiveUtils.sp(16),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  // MRP (Shadow Price) with strike-through - below price
                                  if (shadowPrice != null) ...[
                                    SizedBox(height: ResponsiveUtils.rp(6)),
                                    Row(
                                      children: [
                                        Text(
                                          '${AppConfig.mrpLabel}: ',
                                          style: TextStyle(
                                            fontSize: ResponsiveUtils.sp(14),
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        Text(
                                          _formatMRPPrice(shadowPrice),
                                          style: TextStyle(
                                            fontSize: ResponsiveUtils.sp(16),
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textTertiary,
                                            decoration: TextDecoration.lineThrough,
                                            decorationColor: AppColors.textTertiary,
                                            decorationThickness: 2.0,
                                            decorationStyle: TextDecorationStyle.solid,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Right side - SKU Display alone
                            if (selectedVariant?.sku != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.rp(10),
                                  vertical: ResponsiveUtils.rp(6),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.inputFill,
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                                  border: Border.all(
                                    color: AppColors.border.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'SKU: ',
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.sp(11),
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      selectedVariant!.sku,
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.sp(11),
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              // Stock status (and favorite). When no variant selected, show short message in card.
              if (selectedVariant == null && _hasOptionGroups) ...[
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.error, size: ResponsiveUtils.rp(18)),
                    SizedBox(width: ResponsiveUtils.rp(8)),
                    ResponsiveText(
                      'This combination is unavailable',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ],
                ),
              ] else if (selectedVariant != null) ...[
                ResponsiveSpacing.vertical(12),
                Builder(
                  builder: (context) {
                    return Row(
                    children: [
                      StockLevelLabel(stockLevel: selectedVariant!.stockLevel),
                      Spacer(),
                      // Favorite Button at right end
                      Obx(() {
                        final isFavorite =
                            bannerController.isFavorite(productDetail?.id ?? '');
                        return GestureDetector(
                          onTap: () async {
                            if (productDetail != null) {
                              await bannerController.toggleFavorite(
                                  productId: productDetail!.id);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                            decoration: BoxDecoration(
                              color: isFavorite
                                  ? AppColors.error.withValues(alpha: 0.1)
                                  : AppColors.inputFill,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite ? AppColors.error : AppColors.textSecondary,
                              size: ResponsiveUtils.rp(28),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                  },
                ),
              ],
            ],
          ),
        ),

        // Variant / option selection
        if (productDetail!.variants.length > 1) ...[
          // X mark above box when combination unavailable (first choose first option, then second, etc.)
          if (selectedVariant == null && _hasOptionGroups)
            Padding(
              padding: EdgeInsets.only(left: ResponsiveUtils.rp(16), bottom: ResponsiveUtils.rp(6)),
              child: Row(
                children: [
                  Icon(Icons.cancel_rounded, color: AppColors.error, size: ResponsiveUtils.rp(22)),
                  SizedBox(width: ResponsiveUtils.rp(6)),
                  ResponsiveText(
                    'This combination is unavailable',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ],
              ),
            ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: ResponsiveUtils.rp(12),
                  offset: Offset(0, ResponsiveUtils.rp(4)),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_hasOptionGroups) ...[
                  // Header: "Select Variant" with icon
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                        decoration: BoxDecoration(
                          color: AppColors.button.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: AppColors.button,
                          size: ResponsiveUtils.rp(18),
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Expanded(
                        child: ResponsiveText(
                          'Select Variant',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSpacing.vertical(20),
                  // Option groups: group title then horizontal chips (first choose first option, then second, etc.)
                  ...() {
                    final groups = _getOptionGroups();
                    return groups.asMap().entries.map((entry) {
                      final group = entry.value;
                      final isLast = entry.key == groups.length - 1;
                      return Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : ResponsiveUtils.rp(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ResponsiveText(
                              group.displayName,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            ResponsiveSpacing.vertical(10),
                            Wrap(
                              spacing: ResponsiveUtils.rp(10),
                              runSpacing: ResponsiveUtils.rp(10),
                              children: group.optionNames.map((optionName) {
                                final isSelected = _selectedOptionsByGroup[group.groupName] == optionName;
                                final isAvailable = _isOptionAvailable(group.groupName, optionName);
                                return GestureDetector(
                                  onTap: isAvailable
                                      ? () {
                                          setState(() {
                                            _selectedOptionsByGroup = Map.from(_selectedOptionsByGroup)
                                              ..[group.groupName] = optionName;
                                            selectedVariant = _findVariantBySelectedOptions();
                                            _selectedQuantity = 1;
                                            _isAddedToCart = false;
                                          });
                                        }
                                      : null,
                                  child: !isAvailable
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: ResponsiveUtils.rp(14),
                                                vertical: ResponsiveUtils.rp(10),
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.inputFill.withValues(alpha: 0.8),
                                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                                border: Border.all(
                                                  color: AppColors.border.withValues(alpha: 0.6),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Text(
                                                optionName,
                                                style: TextStyle(
                                                  fontSize: ResponsiveUtils.sp(14),
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Center(
                                                child: Icon(
                                                  Icons.close,
                                                  size: ResponsiveUtils.rp(28),
                                                  color: AppColors.textSecondary.withValues(alpha: 0.9),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ResponsiveUtils.rp(14),
                                            vertical: ResponsiveUtils.rp(10),
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected ? AppColors.button : AppColors.inputFill,
                                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                            border: Border.all(
                                              color: isSelected ? AppColors.button : AppColors.border.withValues(alpha: 0.5),
                                              width: isSelected ? 2 : 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            optionName,
                                            style: TextStyle(
                                              fontSize: ResponsiveUtils.sp(14),
                                              fontWeight: FontWeight.w600,
                                              color: isSelected ? Colors.white : AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    });
                  }(),
                ] else ...[
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                        decoration: BoxDecoration(
                          color: AppColors.button.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: AppColors.button,
                          size: ResponsiveUtils.rp(18),
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Expanded(
                        child: ResponsiveText(
                          'Select Variant',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSpacing.vertical(20),
                  Wrap(
                    spacing: ResponsiveUtils.rp(12),
                    runSpacing: ResponsiveUtils.rp(12),
                    children: productDetail!.variants.map((variant) {
                      final displayName = _getVariantDisplayName(variant);
                      final isSelected = selectedVariant?.id == variant.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedVariant = variant;
                            _selectedQuantity = 1;
                            _isAddedToCart = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(16),
                            vertical: ResponsiveUtils.rp(12),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.button
                                : AppColors.inputFill,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.button
                                  : AppColors.border.withValues(alpha: 0.5),
                              width: isSelected ? 2 : 1.5,
                            ),
                          ),
                          child: Text(
                            displayName,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14),
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          ResponsiveSpacing.vertical(20),
        ],

        // Description
        if (productDetail!.description.isNotEmpty) ...[
          Container(
            key: _descriptionKey,
            margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: ResponsiveUtils.rp(12),
                  offset: Offset(0, ResponsiveUtils.rp(4)),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                      ),
                      child: Icon(Icons.description_rounded,
                          color: AppColors.info, size: ResponsiveUtils.rp(20)),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(12)),
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
                        data: productDetail!.description,
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
                                      data: productDetail!.description,
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
                                    AppColors.card.withValues(alpha: 0),
                                    AppColors.card,
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
        showErrorSnackbar(AppStrings.invalidVariantId);
      }
      return;
    }

    final qty = quantity ?? _selectedQuantity;
    final success = await cartController.addToCart(
        productVariantId: variantId, quantity: qty);

    if (!mounted) return; // Widget was disposed during async operation

    if (success) {
      setState(() {
        _selectedQuantity = 1;
        _isAddedToCart = true; // Set success state
      });
      
      // Reset the button text after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isAddedToCart = false;
          });
        }
      });
    } else {
      setState(() {
        _isAddedToCart = false; // Reset on failure
      });
    }
  }


  Future<void> _showQuantityDialog() async {
    const maxQuantity = 100;
    
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
    final stockLevel = selectedVariant!.stockLevel.toUpperCase();
    final isOutOfStock = stockLevel == 'OUT_OF_STOCK';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: ResponsiveUtils.rp(20),
            offset: Offset(0, -ResponsiveUtils.rp(2)),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.rp(16),
            vertical: ResponsiveUtils.rp(12),
          ),
          child: Row(
            children: [
              // Quantity Selector - Clean button style
              GestureDetector(
                onTap: isOutOfStock
                    ? null
                    : () async {
                        final result = await showModalBottomSheet<int>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => _buildQuantityBottomSheet(cartQuantity),
                        );
                        if (result != null && result > 0) {
                          setState(() {
                            _selectedQuantity = result;
                            _isAddedToCart = false; // Reset success state when quantity changes
                          });
                          await _addToCart(quantity: result);
                        }
                      },
                child: Container(
                  width: ResponsiveUtils.rp(70),
                  height: ResponsiveUtils.rp(50),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_selectedQuantity}',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(16),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(4)),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                        size: ResponsiveUtils.rp(18),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: ResponsiveUtils.rp(12)),

              // Add to Cart Button - Clean and modern
              Expanded(
                child: Container(
                  height: ResponsiveUtils.rp(50),
                  decoration: BoxDecoration(
                    gradient: isOutOfStock
                        ? null
                        : LinearGradient(
                            colors: [AppColors.button, AppColors.buttonLight],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                    color: isOutOfStock ? AppColors.grey300 : null,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isOutOfStock ? null : () => _addToCart(),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isAddedToCart
                                  ? Icons.check_circle_rounded
                                  : Icons.add_shopping_cart_rounded,
                              color: Colors.white,
                              size: ResponsiveUtils.rp(20),
                            ),
                            SizedBox(width: ResponsiveUtils.rp(8)),
                            Text(
                              _isAddedToCart
                                  ? 'Added to Cart Successfully'
                                  : AppStrings.addToCart,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityBottomSheet(int cartQuantity) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveUtils.rp(20)),
          topRight: Radius.circular(ResponsiveUtils.rp(20)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
            width: ResponsiveUtils.rp(40),
            height: ResponsiveUtils.rp(4),
            decoration: BoxDecoration(
              color: AppColors.border.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
            child: Text(
              'Select Quantity',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(18),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
              itemCount: 10,
              itemBuilder: (context, index) {
                final quantity = index + 1;
                final isSelected = quantity == _selectedQuantity;
                return InkWell(
                  onTap: () => Navigator.pop(context, quantity),
                  child: Container(
                    margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(16),
                      vertical: ResponsiveUtils.rp(16),
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.button.withValues(alpha: 0.1)
                          : AppColors.inputFill,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.button
                            : AppColors.border.withValues(alpha: 0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$quantity',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isSelected
                                ? AppColors.button
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.button,
                            size: ResponsiveUtils.rp(20),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            child: TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _showQuantityDialog();
              },
              child: Text(
                'Enter Custom Quantity',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.button,
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
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
                      child: Text(AppStrings.goBack, style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            // If productDetail is still null but we haven't checked properly, show shimmer as fallback
            if (productDetail == null) {
              return _buildShimmerLoading();
            }

            if (orientation == Orientation.landscape) {
              return _buildLandscapeLayout();
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
          bottomNavigationBar: orientation == Orientation.landscape
              ? null
              : _buildBottomBar(),
        );
      },
    );
  }

  /// Landscape layout: image on left (swipeable), content + add-to-cart on right
  Widget _buildLandscapeLayout() {
    final images = _getAllImageUrls();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary, size: ResponsiveUtils.rp(18)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          productDetail?.name ?? widget.productName ?? '',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(16),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          CartButtonWithBadge(cartController: cartController, useIconButton: false),
        ],
      ),
      body: Row(
        children: [
          // ── LEFT: swipeable image (50% width) ──────────────────────────
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _imagePageController,
                  itemCount: images.isEmpty ? 1 : images.length,
                  onPageChanged: (i) => setState(() => _currentImageIndex = i),
                  itemBuilder: (context, index) {
                    final url = images.isEmpty ? '' : images[index];
                    if (url.isEmpty) {
                      return Container(
                        color: AppColors.grey200,
                        child: Center(
                          child: Icon(Icons.image,
                              size: ResponsiveUtils.rp(60),
                              color: AppColors.textTertiary),
                        ),
                      );
                    }
                    return CachedAppImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      cacheWidth: 800,
                      cacheHeight: 600,
                      errorWidget: Container(
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
                // Page indicator dots
                if (images.length > 1)
                  Positioned(
                    bottom: ResponsiveUtils.rp(12),
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (i) => Container(
                        margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(3)),
                        width: ResponsiveUtils.rp(7),
                        height: ResponsiveUtils.rp(7),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == i
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      )),
                    ),
                  ),
              ],
            ),
          ),
          // ── RIGHT: scrollable content + bottom bar ──────────────────────
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _buildContent(),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        ],
      ),
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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = isLandscape ? screenHeight * 0.55 : ResponsiveUtils.rp(300);
    return SliverAppBar(
      expandedHeight: imageHeight,
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

/// One option group: group name from the API and list of option names.
class _OptionGroup {
  final String groupName;
  final List<String> optionNames;
  _OptionGroup(this.groupName, this.optionNames);
  String get displayName => groupName;
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
                hintText: AppStrings.replace(AppStrings.quantityMaxPlaceholder, {'max': widget.maxQuantity.toString()}),
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
          child: Text(AppStrings.cancel,
              style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            final qty = int.tryParse(_controller.text);
            if (qty != null && qty > 0) {
              if (qty > widget.maxQuantity) {
                // Use Get.snackbar to avoid context issues
                SnackBarWidget.showError('Maximum quantity is ${widget.maxQuantity}');
                return;
              }
              widget.onAdd(qty);
            } else {
              // Use Get.snackbar to avoid context issues
              SnackBarWidget.showError('Please enter a valid quantity');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.button,
          ),
          child: Text(AppStrings.add, style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}