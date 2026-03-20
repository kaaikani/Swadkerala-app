import '../graphql/banner.graphql.dart';
import '../graphql/cart.graphql.dart' as cart_graphql;
import 'price_formatter.dart';

/// Info about a single coupon condition with client-side validation status
class CouponConditionInfo {
  final String code;
  final String displayText;
  final bool isMet;
  final bool canValidate; // false if we can't check client-side

  CouponConditionInfo({
    required this.code,
    required this.displayText,
    required this.isMet,
    this.canValidate = true,
  });
}

/// Info about a single coupon action for display
class CouponActionInfo {
  final String code;
  final String displayText;

  CouponActionInfo({required this.code, required this.displayText});
}

class CouponValidationHelper {
  /// Parse all conditions for a coupon and check which are met against current cart.
  /// [facetValueNames] is an optional map of facet value ID → display name for
  /// showing human-readable category names in `at_least_n_with_facets` conditions.
  static List<CouponConditionInfo> evaluateConditions(
    Query$GetCouponCodeList$getCouponCodeList$items coupon,
    cart_graphql.Fragment$Cart? cart, {
    Map<String, String>? facetValueNames,
    Map<String, String>? variantNames,
    Map<String, String>? customerGroupNames,
  }) {
    final results = <CouponConditionInfo>[];

    for (final condition in coupon.promotion.conditions) {
      final argsMap = {for (var a in condition.args) a.name: a.value};

      switch (condition.code) {
        case 'minimum_order_amount':
          results.add(_evaluateMinimumOrderAmount(argsMap, cart));
          break;
        case 'contains_products':
          results.add(_evaluateContainsProducts(argsMap, cart, variantNames));
          break;
        case 'at_least_n_with_facets':
          results.add(_evaluateAtLeastNWithFacets(argsMap, facetValueNames));
          break;
        case 'customer_group':
          results.add(_evaluateCustomerGroup(argsMap, customerGroupNames));
          break;
        case 'buy_x_get_y_free':
          results.add(_evaluateBuyXGetYCondition(argsMap, cart, variantNames));
          break;
        case 'at_least_n_items':
          results.add(_evaluateAtLeastNItems(argsMap, cart));
          break;
        case 'has_active_customer':
          results.add(_evaluateHasActiveCustomer(cart));
          break;
        default:
          results.add(CouponConditionInfo(
            code: condition.code,
            displayText: 'Special condition applies',
            isMet: false,
            canValidate: false,
          ));
      }
    }

    return results;
  }

  /// Parse all actions for display
  static List<CouponActionInfo> parseActions(
    Query$GetCouponCodeList$getCouponCodeList$items coupon, {
    Map<String, String>? variantNames,
  }) {
    final results = <CouponActionInfo>[];

    for (final action in coupon.promotion.actions) {
      final argsMap = {for (var a in action.args) a.name: a.value};

      switch (action.code) {
        case 'order_percentage_discount':
          final discount = argsMap['discount'] ?? '0';
          results.add(CouponActionInfo(
            code: action.code,
            displayText: '$discount% off your order',
          ));
          break;
        case 'order_fixed_discount':
          final amount = int.tryParse(argsMap['discount'] ?? '0') ?? 0;
          results.add(CouponActionInfo(
            code: action.code,
            displayText: '${PriceFormatter.formatPrice(amount)} off your order',
          ));
          break;
        case 'facet_based_discount':
          final discount = argsMap['discount'] ?? '0';
          results.add(CouponActionInfo(
            code: action.code,
            displayText: '$discount% off selected items',
          ));
          break;
        case 'products_percentage_discount':
          final discount = argsMap['discount'] ?? '0';
          final variantIds = _parseIdList(argsMap['productVariantIds'] ?? '');
          String productText = 'specific products';
          if (variantNames != null && variantIds.isNotEmpty) {
            final names = variantIds
                .map((id) => variantNames[id] ?? 'Product #$id')
                .toList();
            productText = names.join(', ');
          }
          results.add(CouponActionInfo(
            code: action.code,
            displayText: '$discount% off $productText',
          ));
          break;
        case 'free_shipping':
          results.add(CouponActionInfo(
            code: action.code,
            displayText: 'Free shipping',
          ));
          break;
        case 'buy_x_get_y_free':
          final x = argsMap['amountX'] ?? '0';
          final y = argsMap['amountY'] ?? '1';
          results.add(CouponActionInfo(
            code: action.code,
            displayText: 'Buy $x get $y free',
          ));
          break;
        case 'order_line_fixed_discount':
          final amount = int.tryParse(argsMap['discount'] ?? '0') ?? 0;
          results.add(CouponActionInfo(
            code: action.code,
            displayText: '${PriceFormatter.formatPrice(amount)} off each item',
          ));
          break;
        default:
          results.add(CouponActionInfo(
            code: action.code,
            displayText: 'Special discount',
          ));
      }
    }

    return results;
  }

  /// Check if all client-validatable conditions are met
  static bool areAllConditionsMet(
    Query$GetCouponCodeList$getCouponCodeList$items coupon,
    cart_graphql.Fragment$Cart? cart, {
    Map<String, String>? facetValueNames,
    Map<String, String>? variantNames,
    Map<String, String>? customerGroupNames,
  }) {
    final conditions = evaluateConditions(coupon, cart,
        facetValueNames: facetValueNames,
        variantNames: variantNames,
        customerGroupNames: customerGroupNames);
    return conditions.every((c) => !c.canValidate || c.isMet);
  }

  /// Get a failure message for the first unmet condition
  static String? getFirstUnmetConditionMessage(
    Query$GetCouponCodeList$getCouponCodeList$items coupon,
    cart_graphql.Fragment$Cart? cart, {
    Map<String, String>? facetValueNames,
    Map<String, String>? variantNames,
    Map<String, String>? customerGroupNames,
  }) {
    final conditions = evaluateConditions(coupon, cart,
        facetValueNames: facetValueNames,
        variantNames: variantNames,
        customerGroupNames: customerGroupNames);
    for (final c in conditions) {
      if (c.canValidate && !c.isMet) return c.displayText;
    }
    return null;
  }

  /// Get a failure message for the first unmet NON-product condition.
  /// Skips 'contains_products' since those products will be auto-added to cart.
  static String? getFirstUnmetNonProductConditionMessage(
    Query$GetCouponCodeList$getCouponCodeList$items coupon,
    cart_graphql.Fragment$Cart? cart, {
    Map<String, String>? facetValueNames,
    Map<String, String>? variantNames,
    Map<String, String>? customerGroupNames,
  }) {
    final conditions = evaluateConditions(coupon, cart,
        facetValueNames: facetValueNames,
        variantNames: variantNames,
        customerGroupNames: customerGroupNames);
    for (final c in conditions) {
      if (c.code == 'contains_products') continue;
      if (c.canValidate && !c.isMet) return c.displayText;
    }
    return null;
  }

  /// Check if coupon has a 'contains_products' condition
  static bool hasContainsProductsCondition(
    Query$GetCouponCodeList$getCouponCodeList$items coupon,
  ) {
    return coupon.promotion.conditions.any((c) => c.code == 'contains_products');
  }

  /// Returns true if the coupon has at least one price-reducing action
  /// (anything other than free_shipping). Used for post-apply discount check:
  /// if no discounts appear in the order after apply, the conditions weren't met.
  static bool hasPriceDiscountActions(
    Query$GetCouponCodeList$getCouponCodeList$items coupon,
  ) {
    return coupon.promotion.actions.any((a) => a.code != 'free_shipping');
  }

  // ---------------------------------------------------------------------------
  // Private condition evaluators
  // ---------------------------------------------------------------------------

  static CouponConditionInfo _evaluateMinimumOrderAmount(
    Map<String, String> args,
    cart_graphql.Fragment$Cart? cart,
  ) {
    final requiredAmount = int.tryParse(args['amount'] ?? '0') ?? 0;
    final cartSubTotal = cart?.subTotalWithTax.toInt() ?? 0;
    final isMet = cartSubTotal >= requiredAmount;

    return CouponConditionInfo(
      code: 'minimum_order_amount',
      displayText:
          'Minimum order ${PriceFormatter.formatPrice(requiredAmount)}',
      isMet: isMet,
    );
  }

  static CouponConditionInfo _evaluateContainsProducts(
    Map<String, String> args,
    cart_graphql.Fragment$Cart? cart,
    Map<String, String>? variantNames,
  ) {
    final variantIds = _parseIdList(args['productVariantIds'] ?? '');
    final minimum = int.tryParse(args['minimum'] ?? '1') ?? 1;

    if (variantIds.isEmpty) {
      return CouponConditionInfo(
        code: 'contains_products',
        displayText: 'Requires specific products in cart',
        isMet: false,
        canValidate: false,
      );
    }

    // Count how many of the required variants are in cart
    int matchCount = 0;
    if (cart != null) {
      for (final line in cart.lines) {
        if (variantIds.contains(line.productVariant.id)) {
          matchCount += line.quantity;
        }
      }
    }

    // Build product name list
    String productText;
    if (variantNames != null && variantIds.isNotEmpty) {
      final names = variantIds.map((id) => variantNames[id] ?? 'Product #$id').toList();
      productText = names.join(', ');
    } else {
      productText = 'required product(s)';
    }

    // Show as a free product benefit — always green, never red
    return CouponConditionInfo(
      code: 'contains_products',
      displayText: 'Free: $minimum × $productText',
      isMet: true,
    );
  }

  static CouponConditionInfo _evaluateAtLeastNWithFacets(
    Map<String, String> args,
    Map<String, String>? facetValueNames,
  ) {
    final minimum = args['minimum'] ?? '1';
    final facetIds = _parseIdList(args['facets'] ?? '');

    String categoryText = 'specific categories';
    if (facetValueNames != null && facetIds.isNotEmpty) {
      final names = facetIds
          .map((id) => facetValueNames[id])
          .where((name) => name != null)
          .cast<String>()
          .toList();
      if (names.isNotEmpty) categoryText = names.join(', ');
    }

    return CouponConditionInfo(
      code: 'at_least_n_with_facets',
      displayText: 'Add at least $minimum item(s) from: $categoryText',
      isMet: false,
      canValidate: false,
    );
  }

  static CouponConditionInfo _evaluateCustomerGroup(
    Map<String, String> args,
    Map<String, String>? customerGroupNames,
  ) {
    final groupId = args['customerGroupId'] ?? '';
    final groupName = customerGroupNames?[groupId];
    final label = groupName != null ? '"$groupName" members' : 'specific customer group';
    return CouponConditionInfo(
      code: 'customer_group',
      displayText: 'Only for $label',
      isMet: false,
      canValidate: false,
    );
  }

  static CouponConditionInfo _evaluateBuyXGetYCondition(
    Map<String, String> args,
    cart_graphql.Fragment$Cart? cart,
    Map<String, String>? variantNames,
  ) {
    final amountX = int.tryParse(args['amountX'] ?? '0') ?? 0;
    final amountY = int.tryParse(args['amountY'] ?? '1') ?? 1;
    final variantIdsX = _parseIdList(args['variantIdsX'] ?? '');
    final variantIdsY = _parseIdList(args['variantIdsY'] ?? '');

    int quantity;
    if (variantIdsX.isNotEmpty && cart != null) {
      quantity = 0;
      for (final line in cart.lines) {
        if (variantIdsX.contains(line.productVariant.id)) {
          quantity += line.quantity;
        }
      }
    } else {
      quantity = cart?.totalQuantity ?? 0;
    }

    final isMet = quantity >= amountX;

    // Build human-readable product names
    String buyText;
    String getFreeText;

    if (variantNames != null && variantIdsX.isNotEmpty) {
      final names = variantIdsX
          .map((id) => variantNames[id] ?? 'Product #$id')
          .toList();
      buyText = 'Buy $amountX × ${names.join(' / ')}';
    } else {
      buyText = 'Buy $amountX item(s)';
    }

    if (variantNames != null && variantIdsY.isNotEmpty) {
      final names = variantIdsY
          .map((id) => variantNames[id] ?? 'Product #$id')
          .toList();
      getFreeText = 'Get $amountY × ${names.join(' / ')} free';
    } else {
      getFreeText = 'Get $amountY item(s) free';
    }

    return CouponConditionInfo(
      code: 'buy_x_get_y_free',
      displayText: '$buyText → $getFreeText',
      isMet: isMet,
    );
  }

  static CouponConditionInfo _evaluateAtLeastNItems(
    Map<String, String> args,
    cart_graphql.Fragment$Cart? cart,
  ) {
    final minimum = int.tryParse(args['minimum'] ?? '1') ?? 1;
    final totalQty = cart?.totalQuantity ?? 0;
    final isMet = totalQty >= minimum;
    return CouponConditionInfo(
      code: 'at_least_n_items',
      displayText: 'Add at least $minimum item(s) to cart',
      isMet: isMet,
    );
  }

  static CouponConditionInfo _evaluateHasActiveCustomer(
    cart_graphql.Fragment$Cart? cart,
  ) {
    // Customer is active if cart exists (logged-in user has an active order)
    final isMet = cart != null;
    return CouponConditionInfo(
      code: 'has_active_customer',
      displayText: 'Must be logged in',
      isMet: isMet,
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Parse a string like "[542,543]" or "542,543" or "542" into a list of IDs
  static List<String> _parseIdList(String value) {
    if (value.isEmpty) return [];
    String cleaned = value.trim();
    if (cleaned.startsWith('[') && cleaned.endsWith(']')) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }
    if (cleaned.isEmpty) return [];
    return cleaned.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
}
