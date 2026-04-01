import 'dart:async';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart'
    show FetchPolicy, QueryResult;
import 'package:flutter/foundation.dart';
import '../../graphql/banner.graphql.dart';
import '../../graphql/cart.graphql.dart' as cart_graphql;
import '../../graphql/order.graphql.dart';
import '../../services/graphql_client.dart';
import '../../utils/coupon_validation_helper.dart';
import '../../widgets/error_dialog.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../base_controller.dart';
import '../cart/Cartcontroller.dart';
import '../order/ordercontroller.dart';
import '../customer/customer_controller.dart';
import '../../utils/logger.dart';

class CouponController extends BaseController {
  // ============================================================================
  // DEPENDENCIES
  // ============================================================================
  final GraphqlService graphqlService = GraphqlService();
  final UtilityController utilityController = Get.find<UtilityController>();

  // Lazy controller accessors to avoid repeated Get.find calls
  CartController get _cartController => Get.find<CartController>();
  OrderController get _orderController => Get.find<OrderController>();

  /// Refresh cart and order from server
  Future<void> _refreshCartAndOrder() async {
    try {
      await Future.wait([
        _cartController.getActiveOrder(),
        _orderController.getActiveOrder(skipLoading: true),
      ], eagerError: false);
    } catch (_) {}
  }

  /// Update cart and order from a parsed order JSON response
  void _updateControllersFromJson(Map<String, dynamic> json, dynamic orderResult) {
    try {
      if (json.containsKey('id')) {
        _cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(json);
        _orderController.currentOrder.value = orderResult;
      }
    } catch (_) {}
  }

  // ============================================================================
  // COUPON CODE FUNCTIONALITY
  // ============================================================================
  final RxList<Query$GetCouponCodeList$getCouponCodeList$items> availableCouponCodes = <Query$GetCouponCodeList$getCouponCodeList$items>[].obs;
  final RxList<String> appliedCouponCodes = <String>[].obs;
  final RxBool couponCodesLoaded = false.obs;
  final RxBool isLoadingMoreCoupons = false.obs;
  final RxBool hasMoreCoupons = true.obs;
  final RxInt totalCouponCount = 0.obs;
  static const int couponsPerPage = 10;
  bool _isFetchingCoupons = false;
  /// Cached map of facet value ID → name, fetched alongside coupons.
  /// Used to show human-readable category names in at_least_n_with_facets conditions.
  final Map<String, String> _facetValueNames = {};

  /// Cached map of product variant ID → name, fetched alongside coupons.
  /// Used to show human-readable product names in buy_x_get_y_free conditions.
  final Map<String, String> _variantNames = {};

  /// Cached map of customer group ID → name, fetched alongside coupons.
  /// Used to show human-readable group names in customer_group conditions.
  final Map<String, String> _customerGroupNames = {};

  /// Group IDs the currently logged-in customer belongs to.
  /// Populated from activeCustomer.groups after fetching coupons.
  /// Empty if not logged in or backend doesn't expose groups yet.
  final Set<String> _myGroupIds = {};

  // Track products added by each coupon: Map<couponCode, Map<variantId, quantity>>
  final RxMap<String, Map<String, int>> couponAddedProducts =
      <String, Map<String, int>>{}.obs;

  // Track original cart quantities before adding coupon products
  // Map<couponCode, Map<variantId, originalQuantity>>
  final RxMap<String, Map<String, int>> originalCartQuantities =
      <String, Map<String, int>>{}.obs;

  // Flag to suppress coupon validation during auto-removal (prevents double dialogs)
  bool _suppressCouponValidation = false;

  // Track whether coupon products were already in cart (true) or auto-added (false)
  // Map<couponCode, Map<variantId, wasAlreadyInCart>>
  // true = product was manually added by user, don't remove on coupon removal
  // false = product was auto-added by coupon, remove on coupon removal
  final RxMap<String, Map<String, bool>> couponProductPreExisting =
      <String, Map<String, bool>>{}.obs;

  // Flag to prevent duplicate addToCart calls when order is complete
  bool _isAddingItems = false;

  // All coupons fetched from server (may be limited by server default)
  final RxList<Query$GetCouponCodeList$getCouponCodeList$items> _allFetchedCoupons = <Query$GetCouponCodeList$getCouponCodeList$items>[].obs;

  // ============================================================================
  // COUPON CODE METHODS
  // ============================================================================

  // Static mapping of coupon codes to their associated products
  /// Parse a value that could be a List, stringified JSON list, or CSV into List<String>
  static List<String> _parseIdList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    final s = value.toString().trim().replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
    return s.isEmpty ? [] : s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Build a product map entry for coupon tracking
  Map<String, dynamic> _buildProductEntry(String variantId, String couponName, {int quantity = 1, String? name}) {
    return {
      'id': variantId,
      'name': name ?? _variantNames[variantId] ?? 'Product from $couponName',
      'productVariantId': variantId,
      'price': 0.0,
      'priceWithTax': 0.0,
      'quantity': quantity,
      'description': 'Product from coupon: $couponName',
    };
  }

  /// Find coupon by code in the fetched list
  Query$GetCouponCodeList$getCouponCodeList$items? findCoupon(String couponCode) {
    try {
      return _allFetchedCoupons.firstWhere(
        (c) => (c.promotion.couponCode ?? '').toUpperCase() == couponCode.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Get argument value by name from a list of args
  static String? _getArgValue(List<dynamic> args, String name) {
    for (final arg in args) {
      if (arg.name == name) return arg.value.toString();
    }
    return null;
  }

  /// Get products for a specific coupon code from the actual coupon data
  List<Map<String, dynamic>> getCouponProducts(String couponCode) {
    try {
      final coupon = findCoupon(couponCode);
      if (coupon == null) return [];

      final products = <Map<String, dynamic>>[];
      final promoName = coupon.promotion.name;

      // Actions: only 'add_products' auto-adds
      for (final action in coupon.promotion.actions) {
        if (action.code == 'add_products') {
          final ids = _parseIdList(_getArgValue(action.args, 'productVariantIds') ?? '');
          products.addAll(ids.map((id) => _buildProductEntry(id, promoName)));
        }
      }

      // Conditions
      for (final condition in coupon.promotion.conditions) {
        // contains_products: auto-add when different variants, skip when same variant needs qty > 1
        if (condition.code == 'contains_products') {
          final minimum = int.tryParse(_getArgValue(condition.args, 'minimum') ?? '1') ?? 1;
          final ids = _parseIdList(_getArgValue(condition.args, 'productVariantIds') ?? '');
          final variantIds = ids.isNotEmpty
              ? ids
              : _parseIdList(_getArgValue(condition.args, 'productIds') ?? '');

          if (variantIds.isEmpty) continue;

          // If minimum <= number of unique variants, each variant needs qty 1 → auto-add
          // If minimum > number of unique variants, same variant needs qty > 1 → don't auto-add
          if (minimum > variantIds.length) continue;

          products.addAll(variantIds.map((id) => _buildProductEntry(id, promoName)));
        }

        // buy_x_get_y_free: auto-add Y (free) products only when X (buy) products are in cart
        if (condition.code == 'buy_x_get_y_free') {
          final amountX = int.tryParse(_getArgValue(condition.args, 'amountX') ?? '1') ?? 1;
          final variantIdsX = _parseIdList(_getArgValue(condition.args, 'variantIdsX') ?? '');
          final amountY = int.tryParse(_getArgValue(condition.args, 'amountY') ?? '1') ?? 1;
          final variantIdsY = _parseIdList(_getArgValue(condition.args, 'variantIdsY') ?? '');

          if (variantIdsY.isEmpty) continue;

          // Check if X products are already in cart with required quantity
          final cart = _cartController.cart.value;
          if (cart != null) {
            bool xSatisfied = true;
            for (final xId in variantIdsX) {
              final line = cart.lines.firstWhereOrNull((l) => l.productVariant.id == xId);
              if (line == null || line.quantity < amountX) {
                xSatisfied = false;
                break;
              }
            }
            // Only auto-add Y products if X condition is met
            if (xSatisfied) {
              for (final yId in variantIdsY) {
                products.add(_buildProductEntry(yId, promoName,
                    quantity: amountY,
                    name: _variantNames[yId] ?? 'Free product'));
              }
            }
          }
        }
      }

      return products;
    } catch (e) {
      return [];
    }
  }

  /// Check if a coupon has associated products
  bool hasCouponProducts(String couponCode) {
    final products = getCouponProducts(couponCode);
    if (products.isNotEmpty) {
    }
    return products.isNotEmpty;
  }

  /// Check if a product variant is from a coupon-added product
  /// Returns the coupon code if it's a coupon product with quantity > 0, null otherwise
  String? isCouponAddedProduct(String variantId) {
    for (final entry in couponAddedProducts.entries) {
      final couponCode = entry.key;
      final products = entry.value;
      // Only return coupon code if the variant exists AND has quantity > 0
      final quantity = products[variantId];
      if (quantity != null && quantity > 0) {
        return couponCode;
      }
    }
    return null;
  }

  /// Get the coupon-added quantity for a variant
  /// Returns the quantity that was added by coupon, or 0 if not added by coupon
  int getCouponAddedQuantity(String variantId, String? couponCode) {
    if (couponCode == null) return 0;
    return couponAddedProducts[couponCode]?[variantId] ?? 0;
  }

  /// Get the original quantity (before coupon was applied) for a variant
  /// Returns the original quantity, or 0 if not found
  int getOriginalQuantity(String variantId, String? couponCode) {
    if (couponCode == null) return 0;
    return originalCartQuantities[couponCode]?[variantId] ?? 0;
  }

  Future<void> getCouponCodeList() async {
    // Prevent concurrent calls — a second call would clear data from the first
    if (_isFetchingCoupons) {
      return;
    }
    _isFetchingCoupons = true;
    try {
      utilityController.setLoadingState(false);
      _allFetchedCoupons.clear();
      availableCouponCodes.clear();
      hasMoreCoupons.value = true;
      totalCouponCount.value = 0;
      couponCodesLoaded.value = false;

      QueryResult<Query$GetCouponCodeList>? res;
      int retryCount = 0;
      const maxRetries = 3;

      while (retryCount < maxRetries) {
        try {
          res = await Future.any([
            GraphqlService.client.value.query$GetCouponCodeList(
              Options$Query$GetCouponCodeList(
                fetchPolicy: FetchPolicy.networkOnly,
              ),
            ),
            Future.delayed(Duration(seconds: 15)).then((_) =>
                throw TimeoutException(
                    'Query timeout after 15 seconds', Duration(seconds: 15))),
          ]);
          break;
        } catch (e) {
          retryCount++;
          if (retryCount >= maxRetries) rethrow;
          await Future.delayed(Duration(seconds: 2));
        }
      }

      if (res == null) {
        throw Exception('Failed to get coupon codes after $maxRetries attempts');
      }

      if (res.hasException) {
        // Only abort if there's no usable data — some exceptions (cache miss)
        // can occur alongside valid network data
        if (res.parsedData?.getCouponCodeList == null) {
          couponCodesLoaded.value = true;
          utilityController.setLoadingState(false);
          return;
        }
      }

      final couponData = res.parsedData?.getCouponCodeList;
      if (couponData != null) {
        totalCouponCount.value = couponData.totalItems;
        final items = couponData.items;

        // Build facet value names, variant names, and customer group names from items
        _facetValueNames.clear();
        _variantNames.clear();
        _customerGroupNames.clear();
        for (final item in items) {
          for (final fv in item.facetValues) {
            _facetValueNames[fv.id] = fv.name;
          }
          for (final variant in item.productVariants) {
            _variantNames[variant.id] = variant.name;
          }
          final cg = item.customerGroup;
          if (cg != null) {
            _customerGroupNames[cg.id] = cg.name;
          }
        }


        // Populate customer's own group IDs from activeCustomer
        _myGroupIds.clear();
        try {
          final customerController = Get.find<CustomerController>();
          final customer = customerController.activeCustomer.value;
          if (customer != null) {
            for (final g in customer.groups) {
              _myGroupIds.add(g.id);
            }
          }
        } catch (_) {
          // CustomerController not available
        }

        final fetchedCoupons = items.toList();

        // Filter group-restricted coupons based on login state
        // If not logged in: show all coupons
        // If logged in: hide group-restricted coupons unless customer is in that group
        final isLoggedIn = GraphqlService.authToken.isNotEmpty;
        final filteredCoupons = !isLoggedIn
            ? fetchedCoupons
            : fetchedCoupons.where((coupon) {
                final groupConditions = coupon.promotion.conditions
                    .where((c) => c.code == 'customer_group')
                    .toList();
                if (groupConditions.isEmpty) return true; // no group restriction
                // Has group restriction — show only if customer is in the required group
                return groupConditions.any((c) {
                  final argsMap = {for (var a in c.args) a.name: a.value};
                  final requiredGroupId = argsMap['customerGroupId'] ?? '';
                  return _myGroupIds.contains(requiredGroupId);
                });
              }).toList();

        _allFetchedCoupons.assignAll(filteredCoupons);

        // Show first batch
        final firstBatch = filteredCoupons.take(couponsPerPage).toList();
        availableCouponCodes.assignAll(firstBatch);
        hasMoreCoupons.value = availableCouponCodes.length < _allFetchedCoupons.length;
      }

      couponCodesLoaded.value = true;
      utilityController.setLoadingState(false);
    } catch (e) {
      couponCodesLoaded.value = true;
      utilityController.setLoadingState(false);
    } finally {
      _isFetchingCoupons = false;
    }
  }

  /// Load more coupons for lazy loading (client-side pagination)
  Future<void> loadMoreCoupons() async {
    if (isLoadingMoreCoupons.value || !hasMoreCoupons.value) return;

    isLoadingMoreCoupons.value = true;

    // Small delay for smooth UX
    await Future.delayed(Duration(milliseconds: 300));

    final currentCount = availableCouponCodes.length;
    final nextBatch = _allFetchedCoupons.skip(currentCount).take(couponsPerPage).toList();
    availableCouponCodes.addAll(nextBatch);
    hasMoreCoupons.value = availableCouponCodes.length < _allFetchedCoupons.length;

    isLoadingMoreCoupons.value = false;
  }

  /// Common coupon validation logic. Returns error map or null if valid.
  Map<String, dynamic>? _validateCouponBasics(Query$GetCouponCodeList$getCouponCodeList$items coupon, String couponCode) {
    if (!coupon.promotion.enabled) return {'message': 'Coupon code is disabled', 'error': 'COUPON_DISABLED'};
    if (coupon.promotion.endsAt != null && DateTime.now().isAfter(coupon.promotion.endsAt!)) {
      return {'message': 'Coupon code has expired', 'error': 'COUPON_EXPIRED'};
    }
    if (coupon.promotion.startsAt != null && DateTime.now().isBefore(coupon.promotion.startsAt!)) {
      return {'message': 'Coupon code is not yet active', 'error': 'COUPON_NOT_ACTIVE'};
    }
    if (appliedCouponCodes.contains(couponCode)) return {'message': 'Coupon code already applied', 'error': 'COUPON_ALREADY_APPLIED'};
    if (appliedCouponCodes.isNotEmpty) return {'message': 'Only one coupon code can be applied per order.', 'error': 'ANOTHER_COUPON_APPLIED'};
    return null;
  }

  /// Validate coupon code before applying
  Future<Map<String, dynamic>> validateCouponCode(String couponCode) async {
    try {
      final coupon = findCoupon(couponCode);
      if (coupon == null) return {'valid': false, 'message': 'Coupon code not found', 'error': 'COUPON_NOT_FOUND'};

      final basicError = _validateCouponBasics(coupon, couponCode);
      if (basicError != null) return {'valid': false, ...basicError};

      final unmetMessage = CouponValidationHelper.getFirstUnmetConditionMessage(
          coupon, _cartController.cart.value,
          facetValueNames: _facetValueNames, variantNames: _variantNames,
          customerGroupNames: _customerGroupNames);
      if (unmetMessage != null) return {'valid': false, 'message': unmetMessage, 'error': 'CONDITION_NOT_MET'};

      return {'valid': true, 'message': 'Coupon code is valid', 'coupon': coupon};
    } catch (e) {
      return {'valid': false, 'message': 'Error validating coupon code', 'error': 'VALIDATION_ERROR'};
    }
  }


  /// Get current cart total from active order
  /// Uses orderController to get total from already-loaded active order
  /// If not available, calls getActiveOrder to load it

  /// Get minimum order amount from coupon conditions
  int? _getCouponMinimumAmount(Query$GetCouponCodeList$getCouponCodeList$items coupon) {
    try {
      for (final condition in coupon.promotion.conditions) {
        if (condition.code == 'minimum_order_amount') {
          for (final arg in condition.args) {
            if (arg.name == 'amount') {
              final value = arg.value; // value is always String in generated type
              return int.tryParse(value);
            }
          }
        }
      }
    } catch (e) {
      // Error getting coupon minimum amount
    }
    return null;
  }

  /// Get eligible coupons that are close to being applicable
  /// Returns coupons where (requiredAmount - subTotal) > 0 && < 40000
  List<Query$GetCouponCodeList$getCouponCodeList$items> getEligibleCoupons(int subTotalInPaise) {
    final eligibleCoupons = <Query$GetCouponCodeList$getCouponCodeList$items>[];

    for (final coupon in _allFetchedCoupons) {
      if (!coupon.promotion.enabled) continue;

      final requiredAmount = _getCouponMinimumAmount(coupon);
      if (requiredAmount == null) continue;

      final difference = requiredAmount - subTotalInPaise;

      // If difference is between 1-40000 (₹0.01 to ₹400), coupon is close to eligible
      if (difference > 0 && difference < 40000) {
        eligibleCoupons.add(coupon);
      }
    }

    return eligibleCoupons;
  }

  /// Get required amount for a coupon in paise
  int getRequiredAmount(Query$GetCouponCodeList$getCouponCodeList$items coupon) {
    final minimumAmount = _getCouponMinimumAmount(coupon);
    return minimumAmount ?? 0;
  }

  /// Get parsed condition info with met/unmet status for a coupon
  List<CouponConditionInfo> getCouponConditionStatus(
      Query$GetCouponCodeList$getCouponCodeList$items coupon) {
    final cartController = _cartController;
    return CouponValidationHelper.evaluateConditions(
        coupon, cartController.cart.value,
        facetValueNames: _facetValueNames,
        variantNames: _variantNames,
        customerGroupNames: _customerGroupNames);
  }

  /// Get parsed action info for display
  List<CouponActionInfo> getCouponActionInfo(
      Query$GetCouponCodeList$getCouponCodeList$items coupon) {
    return CouponValidationHelper.parseActions(coupon,
        variantNames: _variantNames);
  }

  /// Check if all client-validatable conditions are met for a coupon
  bool areAllConditionsMet(
      Query$GetCouponCodeList$getCouponCodeList$items coupon) {
    final cartController = _cartController;
    return CouponValidationHelper.areAllConditionsMet(
        coupon, cartController.cart.value,
        facetValueNames: _facetValueNames,
        variantNames: _variantNames,
        customerGroupNames: _customerGroupNames);
  }

  /// Apply coupon code to active order with proper validation
  /// This method checks ALL conditions FIRST, then applies coupon
  Future<Map<String, dynamic>> applyCouponCode(String couponCode) async {
    try {
      utilityController.setLoadingState(true);

      // Step 1: Find the coupon
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = _allFetchedCoupons.firstWhere(
          (c) => (c.promotion.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
        );
      } catch (e) {
        utilityController.setLoadingState(false);
        ErrorDialog.showWarning(message: 'Coupon code not found');
        _refreshCartAfterCouponError();
        return {
          'success': false,
          'message': 'Coupon code not found',
          'error': 'COUPON_NOT_FOUND'
        };
      }

      // Step 2: Refresh cart to ensure we validate against latest data
      final cartController = _cartController;
      try {
        await cartController.refreshCartData();
      } catch (_) {
        // Continue with current cart data if refresh fails
      }

      // Step 3: Check ALL client-validatable conditions
      final unmetMessage = CouponValidationHelper.getFirstUnmetConditionMessage(
          coupon, cartController.cart.value,
          facetValueNames: _facetValueNames, variantNames: _variantNames,
          customerGroupNames: _customerGroupNames);

      if (unmetMessage != null) {
        utilityController.setLoadingState(false);
        ErrorDialog.showWarning(message: unmetMessage);
        _refreshCartAfterCouponError();
        return {
          'success': false,
          'message': unmetMessage,
          'error': 'CONDITION_NOT_MET',
        };
      }
      // Step 4: Now apply the coupon (conditions validated)
      return await _applyCouponCodeWithoutMinimumCheck(couponCode);
    } catch (e) {
      utilityController.setLoadingState(false);
      handleException(e, customErrorMessage: 'Failed to apply coupon code');
      _refreshCartAfterCouponError();
      return {
        'success': false,
        'message': 'Error applying coupon code',
        'error': 'EXCEPTION'
      };
    }
  }

  /// Internal method to apply coupon code without minimum validation check
  /// (used when minimum has already been validated in applyCouponCodeWithProducts)
  Future<Map<String, dynamic>> _applyCouponCodeWithoutMinimumCheck(String couponCode) async {
    Logger.logFunction(functionName: '_applyCouponCodeWithoutMinimumCheck', mutationName: 'ApplyCouponCode');

    try {
      utilityController.setLoadingState(true);

      final coupon = findCoupon(couponCode);
      if (coupon == null) {
        utilityController.setLoadingState(false);
        return {'success': false, 'message': 'Coupon code not found', 'error': 'COUPON_NOT_FOUND'};
      }

      final basicError = _validateCouponBasics(coupon, couponCode);
      if (basicError != null) {
        utilityController.setLoadingState(false);
        return {'success': false, ...basicError};
      }

      // Apply coupon
      final res = await GraphqlService.client.value.mutate$ApplyCouponCode(
        Options$Mutation$ApplyCouponCode(
          variables: Variables$Mutation$ApplyCouponCode(input: couponCode),
        ),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to apply coupon code')) {
        utilityController.setLoadingState(false);
        _refreshCartAfterCouponError();
        return {
          'success': false,
          'message': 'Network error occurred',
          'error': 'NETWORK_ERROR'
        };
      }

      final result = res.parsedData?.applyCouponCode;

      debugPrint('[CouponApply] result type: ${result.runtimeType}');
      if (result != null && result is Mutation$ApplyCouponCode$applyCouponCode$$Order) {
        appliedCouponCodes.clear();
        appliedCouponCodes.add(couponCode);

        debugPrint('[CouponApply] Applied "$couponCode" - couponCodes in order: ${result.couponCodes}');
        debugPrint('[CouponApply] order discounts: ${result.discounts.map((d) => '${d.type}:${d.amountWithTax}').join(', ')}');
        debugPrint('[CouponApply] line discounts: ${result.lines.map((l) => '${l.productVariant.id}:${l.discounts.map((d) => '${d.amountWithTax}').join(',')}').join(' | ')}');
        debugPrint('[CouponApply] totalQuantity=${result.totalQuantity}, total=${result.total}, totalWithTax=${result.totalWithTax}');

        // Update controllers: set cart immediately from response, then do full refresh
        try {
          _updateControllersFromJson(result.toJson(), result);
        } catch (_) {}
        // Suppress validation during refresh to prevent race condition
        // where validateAndRemoveCouponsIfNeeded() removes the just-applied coupon
        _suppressCouponValidation = true;
        // Always do a full refresh to ensure UI is fully in sync
        await _refreshCartAndOrder();
        try { await restoreCouponTrackingFromCart(); } catch (_) {}
        _suppressCouponValidation = false;

        // Verify coupon is actually in the order's couponCodes list
        final couponActuallyApplied = result.couponCodes.any(
          (c) => c.toString().toUpperCase() == couponCode.toUpperCase());
        debugPrint('[CouponApply] couponActuallyApplied=$couponActuallyApplied');

        if (!couponActuallyApplied) {
          // Server silently rejected the coupon — it's not in the order
          appliedCouponCodes.remove(couponCode);
          utilityController.setLoadingState(false);
          await _refreshCartAndOrder();
          return {
            'success': false,
            'message': 'Coupon code could not be applied',
            'error': 'COUPON_NOT_IN_ORDER',
          };
        }

        // Post-apply check: Vendure silently accepts coupons even if conditions aren't met
        final hasOrderDiscount = result.discounts.any((d) => d.amountWithTax != 0);
        final hasLineDiscount = result.lines.any((line) =>
            line.discounts.any((d) => d.amountWithTax != 0));
        final hasPriceActions = CouponValidationHelper.hasPriceDiscountActions(coupon);
        debugPrint('[CouponApply] hasPriceActions=$hasPriceActions, hasOrderDiscount=$hasOrderDiscount, hasLineDiscount=$hasLineDiscount');

        if (hasPriceActions && !hasOrderDiscount && !hasLineDiscount &&
            result.totalQuantity > 0) {
          // Auto-remove the coupon silently since it produced no discount
          // Suppress validation to prevent double dialogs
          _suppressCouponValidation = true;
          try {
            await removeCouponCode(couponCode);
          } catch (_) {}
          _suppressCouponValidation = false;
          utilityController.setLoadingState(false);

          // Show only ONE dialog for the conditions not met
          final cartVariantIds = result.lines.map((l) => l.productVariant.id).toSet();
          final actionMessage = CouponValidationHelper.getNoDiscountReason(coupon, cartVariantIds);
          if (actionMessage != null) {
            ErrorDialog.showWarning(message: actionMessage);
          } else {
            final cartController = _cartController;
            final conditions = CouponValidationHelper.evaluateConditions(
              coupon,
              cartController.cart.value,
              facetValueNames: _facetValueNames,
              variantNames: _variantNames,
              customerGroupNames: _customerGroupNames,
            );
            ErrorDialog.showConditionsNotMet(
              couponCode: couponCode,
              conditions: conditions,
            );
          }
          return {
            'success': false,
            'message': actionMessage ?? 'Coupon conditions not satisfied',
            'error': 'CONDITIONS_NOT_MET',
            'dialogShown': true,
          };
        }

        utilityController.setLoadingState(false);
        return {
          'success': true,
          'message': 'Coupon code applied successfully',
          'couponCode': couponCode,
          'orderTotal': result.total,
          'totalWithTax': result.totalWithTax,
        };
      }

      // Handle API error types (CouponCodeInvalidError, CouponCodeExpiredError, CouponCodeLimitError) – show their message
      utilityController.setLoadingState(false);
      _refreshCartAfterCouponError();
      String apiMessage = 'Failed to apply coupon code';
      if (result != null) {
        if (result is Mutation$ApplyCouponCode$applyCouponCode$$CouponCodeInvalidError) {
          apiMessage = result.message;
        } else if (result is Mutation$ApplyCouponCode$applyCouponCode$$CouponCodeExpiredError) {
          apiMessage = result.message;
        } else if (result is Mutation$ApplyCouponCode$applyCouponCode$$CouponCodeLimitError) {
          apiMessage = result.message;
        }
      }
      return {
        'success': false,
        'message': apiMessage,
        'error': 'APPLICATION_ERROR'
      };
    } catch (e) {
      utilityController.setLoadingState(false);
      handleException(e, customErrorMessage: 'Failed to apply coupon code');
      _refreshCartAfterCouponError();
      return {
        'success': false,
        'message': 'Error applying coupon code',
        'error': 'EXCEPTION'
      };
    }
  }

  /// Refresh cart after coupon error (best-effort)
  Future<void> _refreshCartAfterCouponError() async => _refreshCartAndOrder();

  /// Remove products added by a specific coupon
  Future<bool> removeCouponProducts(String couponCode) async {
    try {
      if (!couponAddedProducts.containsKey(couponCode) ||
          couponAddedProducts[couponCode]!.isEmpty) {
        couponAddedProducts.remove(couponCode);
        originalCartQuantities.remove(couponCode);
        couponProductPreExisting.remove(couponCode);
        return true;
      }

      final productsToRemove = couponAddedProducts[couponCode]!;
      final preExisting = couponProductPreExisting[couponCode] ?? {};

      for (final entry in productsToRemove.entries) {
        if (preExisting[entry.key] == true) continue;

        // Get fresh cart each iteration — previous removal changes line IDs
        final currentCart = _cartController.cart.value;
        if (currentCart == null) break;

        final line = currentCart.lines.firstWhereOrNull((l) => l.productVariant.id == entry.key);
        if (line == null) continue;

        final newQty = line.quantity - entry.value;
        if (newQty <= 0) {
          await _removeOrderLineById(line.id);
        } else {
          await _cartController.adjustOrderLine(orderLineId: line.id, quantity: newQty);
        }
        await _refreshCartAndOrder();
      }

      couponAddedProducts.remove(couponCode);
      originalCartQuantities.remove(couponCode);
      couponProductPreExisting.remove(couponCode);
      return true;
    } catch (e) {
      return true;
    }
  }

  /// Get current cart

  /// Remove order line by ID
  Future<bool> _removeOrderLineById(String orderLineId) async {
    try {
      final response = await GraphqlService.client.value.mutate$RemoveOrderLine(
        Options$Mutation$RemoveOrderLine(
          variables: Variables$Mutation$RemoveOrderLine(
            orderLineId: orderLineId,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to remove item from cart')) {
        return false;
      }

      final result = response.parsedData?.removeOrderLine;
      if (result != null) {
        if (result is Mutation$RemoveOrderLine$removeOrderLine$$Order) {
          // Update both controllers after removal
          try {
            final cartController = _cartController;
            final orderController = _orderController;
            final resultJson = result.toJson();

            // Update CartController
            cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(resultJson);
            // Update OrderController
            // Note: result is from data, need to parse it properly
            // For now, refresh the order instead
            await orderController.getActiveOrder(skipLoading: true);
          } catch (e) {
            // Fallback: refresh controllers
            try {
              final cartController = _cartController;
              final orderController = _orderController;
              await cartController.getActiveOrder();
              await orderController.getActiveOrder(skipLoading: true);
            } catch (refreshError) {
            }
          }

          return true;
        } else {
          // Handle error cases - this is not an Order, so it's likely an error
          // Try to extract message if available
          try {
            final resultJson = result.toJson();
            final message = resultJson['message'] as String?;
            if (message != null) {
            }
          } catch (e) {
          }
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to remove item from cart');
      return false;
    }
  }

  /// Remove coupon code from active order
  Future<bool> removeCouponCode(String couponCode) async {
    try {
      utilityController.setLoadingState(true);

      // Check if coupon has products that need to be removed
      final hasProducts = hasCouponProducts(couponCode) ||
                         couponAddedProducts.containsKey(couponCode);
      // If coupon has products, remove them from cart first
      if (hasProducts) {
        final productsRemoved = await removeCouponProducts(couponCode);

        // If removing products fails, don't remove coupon
        if (!productsRemoved) {
          utilityController.setLoadingState(false);
          return false;
        }
      }
      final res = await GraphqlService.client.value.mutate$RemoveCouponCode(
        Options$Mutation$RemoveCouponCode(
          variables:
              Variables$Mutation$RemoveCouponCode(couponCode: couponCode),
        ),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to remove coupon code')) {
        utilityController.setLoadingState(false);
        return false;
      }

      final result = res.parsedData?.removeCouponCode;

      if (result != null) {
        appliedCouponCodes.remove(couponCode);
        couponAddedProducts.remove(couponCode);
        originalCartQuantities.remove(couponCode);
        couponProductPreExisting.remove(couponCode);

        try {
          _updateControllersFromJson(result.toJson(), result);
        } catch (_) {}
        // Always do a full refresh to ensure UI is fully in sync
        await _refreshCartAndOrder();

        utilityController.setLoadingState(false);
        return true;
      }

      utilityController.setLoadingState(false);
      return false;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to remove coupon code');
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Toggle coupon code (apply if not applied, remove if applied)
  Future<Map<String, dynamic>> toggleCouponCode(String couponCode) async {
    if (appliedCouponCodes.contains(couponCode)) {
      final success = await removeCouponCode(couponCode);
      return {
        'success': success,
        'message': success
            ? 'Coupon code removed successfully'
            : 'Failed to remove coupon code',
        'action': 'removed'
      };
    } else {
      // Use the new method that adds products first, then applies coupon
      return await applyCouponCodeWithProducts(couponCode);
    }
  }

  /// Check if coupon code is applied
  bool isCouponCodeApplied(String couponCode) {
    return appliedCouponCodes.contains(couponCode);
  }

  /// Check if any coupon is currently applied (for one coupon per order policy)
  bool isAnyCouponApplied() {
    return appliedCouponCodes.isNotEmpty;
  }

  /// Get the currently applied coupon code (for one coupon per order policy)
  String? getCurrentlyAppliedCoupon() {
    return appliedCouponCodes.isNotEmpty ? appliedCouponCodes.first : null;
  }

  /// Reset coupon codes state
  void resetCouponCodes() {
    appliedCouponCodes.clear();
    couponAddedProducts.clear();
    couponProductPreExisting.clear();
  }

  /// Restore coupon tracking state from cart
  /// This is called when cart is loaded to reconstruct couponAddedProducts and originalCartQuantities
  Future<void> restoreCouponTrackingFromCart() async {
    try {
      // Get current cart
      final orderController = _orderController;
      final currentOrder = orderController.currentOrder.value;
      if (currentOrder == null) {
        return;
      }

      // Get applied coupon codes from cart
      final cartCouponCodes = currentOrder.couponCodes.map((e) => e.toString()).toList();
      if (cartCouponCodes.isEmpty) {
        appliedCouponCodes.clear();
        couponAddedProducts.clear();
        originalCartQuantities.clear();
        couponProductPreExisting.clear();
        return;
      }

      // Update appliedCouponCodes to match cart
      appliedCouponCodes.value = cartCouponCodes;

      // Get current cart lines
      final cartController = _cartController;
      final cart = cartController.cart.value;
      if (cart == null) {
        return;
      }

      final cartLines = cart.lines;
      final currentQuantities = <String, int>{};
      for (final line in cartLines) {
        final variantId = line.productVariant.id;
        final quantity = line.quantity;
        currentQuantities[variantId] = quantity;
      }

      // For each applied coupon, try to reconstruct tracking
      // Load coupon codes list if not already loaded
      if (!couponCodesLoaded.value) {
        await getCouponCodeList();
      }

      // Save existing pre-existing tracking from fresh apply (don't overwrite)
      final savedPreExisting = Map<String, Map<String, bool>>.from(couponProductPreExisting);
      final savedAddedProducts = Map<String, Map<String, int>>.from(couponAddedProducts);
      final savedOriginalQuantities = Map<String, Map<String, int>>.from(originalCartQuantities);

      couponAddedProducts.clear();
      originalCartQuantities.clear();
      couponProductPreExisting.clear();

      for (final couponCode in cartCouponCodes) {
        // Skip restore for coupons that already have fresh tracking
        if (savedPreExisting.containsKey(couponCode)) {
          couponAddedProducts[couponCode] = savedAddedProducts[couponCode] ?? {};
          originalCartQuantities[couponCode] = savedOriginalQuantities[couponCode] ?? {};
          couponProductPreExisting[couponCode] = savedPreExisting[couponCode]!;
          continue;
        }
        // Find the coupon in available coupons
        // ignore: unused_local_variable
        Query$GetCouponCodeList$getCouponCodeList$items? coupon;
        try {
          coupon = _allFetchedCoupons.firstWhere(
            (c) => (c.promotion.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
          );
        } catch (e) {
          continue;
        }

        // Get products that should be added by this coupon
        // Note: getCouponProducts will also find the coupon, but we already found it above for early validation
        final couponProducts = getCouponProducts(couponCode);
        if (couponProducts.isEmpty) {
          continue;
        }

        // Try to identify which products in cart match the coupon products
        final addedQuantities = <String, int>{};
        final originalQuantities = <String, int>{};

        for (final couponProduct in couponProducts) {
          final variantId = couponProduct['productVariantId']?.toString();
          final expectedQuantity = couponProduct['quantity'] as int? ?? 1;

          if (variantId == null) continue;

          final currentQty = currentQuantities[variantId] ?? 0;

          if (currentQty >= expectedQuantity) {
            // Product exists in cart with at least the expected quantity
            // We assume the coupon-added quantity is the expected quantity
            // and the rest (if any) is original
            addedQuantities[variantId] = expectedQuantity;
            originalQuantities[variantId] = currentQty - expectedQuantity;
          } else if (currentQty > 0) {
            // Product exists but with less quantity than expected (maybe user removed some)
            // Assume all current quantity is from coupon
            addedQuantities[variantId] = currentQty;
            originalQuantities[variantId] = 0;
          }
        }

        if (addedQuantities.isNotEmpty) {
          couponAddedProducts[couponCode] = addedQuantities;
          originalCartQuantities[couponCode] = originalQuantities;
          // On restore, assume products were auto-added (false) so they can be removed
          final restoredPreExisting = <String, bool>{};
          for (final variantId in addedQuantities.keys) {
            restoredPreExisting[variantId] = false;
          }
          couponProductPreExisting[couponCode] = restoredPreExisting;
        } else {
        }
      }
    } catch (e) {
      // Don't throw - this is best-effort restoration
    }
  }

  /// Check and remove coupons if cart total is below their minimum requirement
  /// Called automatically when cart is cleared or cart total decreases
  Future<void> validateAndRemoveCouponsIfNeeded() async {
    if (_suppressCouponValidation) return;
    try {
      // First, restore coupon tracking from cart if appliedCouponCodes is empty but cart has coupons
      final orderController = _orderController;
      final currentOrder = orderController.currentOrder.value;
      if (currentOrder != null) {
        final cartCouponCodes = currentOrder.couponCodes.map((e) => e.toString()).toList();
        if (appliedCouponCodes.isEmpty && cartCouponCodes.isNotEmpty) {
          await restoreCouponTrackingFromCart();
        } else if (appliedCouponCodes.isNotEmpty && cartCouponCodes.isEmpty) {
          // Cart has no coupons but we have applied coupons - clear them
          resetCouponCodes();
        }
      }

      // If no coupons applied, nothing to check
      if (appliedCouponCodes.isEmpty) {
        return;
      }

      // Get current cart subtotal from active order (subtotal = line items, not total with shipping)
      // Try to get from already-loaded order first
      double? cartSubTotal = orderController.currentOrder.value?.subTotalWithTax;

      // If not available, load active order
      if (cartSubTotal == null) {
        final loaded = await orderController.getActiveOrder(skipLoading: true);
        if (loaded) {
          cartSubTotal = orderController.currentOrder.value?.subTotalWithTax;
        }
      }

      if (cartSubTotal == null) {
        return;
      }
      // Check each applied coupon against ALL conditions
      final couponsToRemove = <String>[];
      final cartController = _cartController;

      for (final couponCode in appliedCouponCodes.toList()) {
        // Find the coupon in available coupons
        Query$GetCouponCodeList$getCouponCodeList$items? coupon;
        try {
          coupon = _allFetchedCoupons.firstWhere(
            (c) => (c.promotion.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
          );
        } catch (e) {
          // Remove it from applied list if not found
          couponsToRemove.add(couponCode);
          continue;
        }

        // Check if all client-validatable conditions are still met
        if (!CouponValidationHelper.areAllConditionsMet(
            coupon, cartController.cart.value,
            facetValueNames: _facetValueNames,
            variantNames: _variantNames,
            customerGroupNames: _customerGroupNames)) {
          couponsToRemove.add(couponCode);
        }
      }

      // Remove coupons that don't meet conditions
      if (couponsToRemove.isNotEmpty) {
        for (final couponCode in couponsToRemove) {
          await removeCouponCode(couponCode);
        }
      } else {
      }
    } catch (e) {
      // Don't throw - this is a background validation
    }
  }

  /// Get coupon validation status for UI display
  Future<Map<String, dynamic>> getCouponValidationStatus(
      String couponCode) async {
    return await validateCouponCode(couponCode);
  }

  /// Check if cart has products for coupon validation
  Future<bool> hasProductsInCart() async {
    try {
      // This would typically check the current cart/order
      // For now, we'll assume there are products if we have an active order
      return true; // This should be implemented based on your cart logic
    } catch (e) {
      return false;
    }
  }

  /// Add coupon products to cart
  Future<Map<String, dynamic>> addCouponProductsToCart(
      String couponCode) async {
    try {
      // Prevent duplicate calls - if already adding items, return early
      if (_isAddingItems) {
        return {
          'success': false,
          'message': 'Items are already being added to cart',
          'error': 'ALREADY_ADDING_ITEMS'
        };
      }

      // Set flag to prevent duplicate calls
      _isAddingItems = true;
      // Get products from the actual coupon data
      final couponProducts = getCouponProducts(couponCode);

      if (couponProducts.isEmpty) {
        return {
          'success': false,
          'message': 'No products found for this coupon',
          'error': 'NO_PRODUCTS_DEFINED'
        };
      }

      utilityController.setLoadingState(true);

      // Step 1: Get current cart state BEFORE adding to track original quantities
      final cartController = _cartController;
      final cartBefore = cartController.cart.value;
      final originalQuantities = <String, int>{};
      if (cartBefore != null) {
        final cartLines = cartBefore.lines;
        for (final line in cartLines) {
          final variantId = line.productVariant.id;
          final quantity = line.quantity;
          originalQuantities[variantId] = quantity;
        }
      }
      // Store original quantities for this coupon
      originalCartQuantities[couponCode] = Map<String, int>.from(originalQuantities);

      // Add each product from the coupon to cart (skip if already present)
      final addedProducts = <Map<String, dynamic>>[];
      final failedProducts = <Map<String, dynamic>>[];
      final preExistingMap = <String, bool>{};

      // Build set of variant IDs already in cart to avoid duplicate adds
      final existingVariantIds = <String>{};
      if (cartBefore != null) {
        for (final line in cartBefore.lines) {
          existingVariantIds.add(line.productVariant.id);
        }
      }

      for (final product in couponProducts) {
        try {
          final productName = product['name'] as String;
          final productVariantId = product['productVariantId'] as String;
          final quantity = product['quantity'] as int;
          final priceWithTax = product['priceWithTax'] as double;

          // Skip if this product is already in the cart
          if (existingVariantIds.contains(productVariantId)) {
            // Product was manually added by user — mark as pre-existing (true)
            preExistingMap[productVariantId] = true;
            addedProducts.add({
              'product': productName,
              'quantity': quantity,
              'price': priceWithTax,
              'productVariantId': productVariantId,
              'alreadyInCart': true,
            });
            continue;
          }
          // Product not in cart — will be auto-added, mark as not pre-existing (false)
          preExistingMap[productVariantId] = false;


          final res = await GraphqlService.client.value.mutate$AddToCart(
            cart_graphql.Options$Mutation$AddToCart(
              variables: cart_graphql.Variables$Mutation$AddToCart(
                variantId: productVariantId,
                qty: quantity,
              ),
            ),
          );

          if (res.hasException) {
            // Extract error message from GraphQL errors
            String errorMessage = 'Failed to add product to cart';
            if (res.exception?.graphqlErrors.isNotEmpty == true) {
              errorMessage = res.exception!.graphqlErrors.first.message;
            } else if (res.exception?.linkException != null) {
              errorMessage =
                  'Network error. Please check your internet connection.';
            } else {
              errorMessage = res.exception.toString();
            }

            // Show error dialog with the specific error message
            ErrorDialog.showError(errorMessage);

            failedProducts.add({'product': productName, 'error': errorMessage});
            continue;
          }

          final result = res.parsedData?.addItemToOrder;
          if (result != null) {
            if (result is cart_graphql.Mutation$AddToCart$addItemToOrder$$Order) {
              // Update both controllers immediately after each product is added
              // This prevents the "cart is empty" UI issue
              try {
                final cartController = _cartController;
                final orderController = _orderController;
                final resultJson = result.toJson();

                // Update CartController
                cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(resultJson);
                // Update OrderController - refresh to get proper Fragment$Cart type
                await orderController.getActiveOrder(skipLoading: true);
              } catch (e) {
              }

              addedProducts.add({
                'product': productName,
                'quantity': quantity,
                'price': priceWithTax,
                'productVariantId': productVariantId,
              });
            } else if (result
                is cart_graphql.Mutation$AddToCart$addItemToOrder$$InsufficientStockError) {
              failedProducts
                  .add({'product': productName, 'error': 'Insufficient stock'});
            } else {
              failedProducts
                  .add({'product': productName, 'error': 'Unknown error'});
            }
          } else {
            failedProducts.add({
              'product': productName,
              'error': 'No result returned from server'
            });
          }
        } catch (e) {
          handleException(e,
              customErrorMessage: 'Failed to add product to cart');
          failedProducts.add({
            'product': product['name'],
            'error': 'Error adding product: $e'
          });
        }
      }

      utilityController.setLoadingState(false);
      if (addedProducts.isNotEmpty) {
        final addedProductIds = <String>[];
        for (final product in addedProducts) {
          // Track the product variant ID for removal later
          if (product['productVariantId'] != null) {
            addedProductIds.add(product['productVariantId'].toString());
          }
        }

        // Step 2: Get cart state AFTER all products have been added to calculate what was actually added
        // Refresh cart first to get the latest state
        try {
          final cartController = _cartController;
          final orderController = _orderController;
          await Future.wait([
            cartController.getActiveOrder(),
            orderController.getActiveOrder(skipLoading: true),
          ], eagerError: false);
        } catch (e) {
        }

        final cartAfter = cartController.cart.value;
        final actualAddedQuantities = <String, int>{};
        if (cartAfter != null) {
          final cartLines = cartAfter.lines;

          // Only track products that were actually supposed to be added by this coupon
          final couponProductVariantIds = addedProducts.map((p) => p['productVariantId']?.toString()).whereType<String>().toSet();

          for (final line in cartLines) {
            final variantId = line.productVariant.id;

            // Only calculate difference for products that were intended to be added by this coupon
            if (couponProductVariantIds.contains(variantId)) {
              final quantityAfter = line.quantity;
              final quantityBefore = originalQuantities[variantId] ?? 0;
              final quantityAdded = quantityAfter - quantityBefore;

              if (quantityAdded > 0) {
                actualAddedQuantities[variantId] = quantityAdded;
              } else {
          }
        }
          }
        }

        // Store the actual quantities added/tracked by this coupon
        couponAddedProducts[couponCode] = actualAddedQuantities;
        // Store pre-existing status for each product
        couponProductPreExisting[couponCode] = preExistingMap;
      }

      if (failedProducts.isNotEmpty) {
        for (final _ in failedProducts) {
          // Logging is commented out, so variable is unused
        }
      }

      // If ANY product failed, rollback all added products and return failure
      if (failedProducts.isNotEmpty) {
        // Rollback: Remove all successfully added products
        for (final addedProduct in addedProducts) {
          try {
            final productVariantId = addedProduct['productVariantId'] as String;

            // Find the order line for this product variant
            final cartController = _cartController;
            final cart = cartController.cart.value;
            if (cart != null) {
              final cartLines = cart.lines;
              for (final line in cartLines) {
                final lineId = line.id;
                final variantIdFromCart = line.productVariant.id;

                if (variantIdFromCart == productVariantId) {
                  final success = await _removeOrderLineById(lineId);
                  if (success) {
                  } else {
                  }
                  break;
                }
              }
            }
          } catch (e) {
          }
        }

        // Clear tracked products for this coupon
        couponAddedProducts.remove(couponCode);
        couponProductPreExisting.remove(couponCode);
        return {
          'success': false,
          'message': 'Failed to add all coupon products. Added products have been removed.',
          'addedProducts': [],
          'failedProducts': failedProducts,
          'totalAdded': 0,
          'totalFailed': failedProducts.length,
          'rollbackPerformed': true,
          'suppressSnackbar': true,
        };
      }

      // Only return success if ALL products were added successfully
      // If any product failed, success should be false (already handled above with rollback)
      final allProductsAdded = failedProducts.isEmpty && addedProducts.isNotEmpty;

      return {
        'success': allProductsAdded,
        'message': allProductsAdded
            ? 'Added ${addedProducts.length} products to cart'
            : 'Failed to add all products to cart',
        'addedProducts': addedProducts,
        'failedProducts': failedProducts,
        'totalAdded': addedProducts.length,
        'totalFailed': failedProducts.length,
        if (!allProductsAdded) 'suppressSnackbar': true,
      };
    } catch (e) {
      handleException(e,
          customErrorMessage: 'Failed to add coupon products to cart');
      utilityController.setLoadingState(false);
      // Refresh cart to ensure state is up to date after error
      _refreshCartAfterCouponError();
      return {
        'success': false,
        'message': 'Error adding coupon products to cart: $e',
        'error': 'ADD_PRODUCTS_ERROR'
      };
    } finally {
      // Reset flag to allow future calls
      _isAddingItems = false;
    }
  }

  /// Apply coupon code with products: apply coupon first, then add products.
  /// If coupon apply fails, return error (nothing to rollback).
  /// If products add fails, remove the applied coupon and return error.
  Future<Map<String, dynamic>> applyCouponCodeWithProducts(
      String couponCode) async {
    Logger.logFunction(functionName: 'applyCouponCodeWithProducts', mutationName: 'ApplyCouponCode');

    try {
      // Step 1: Find the coupon
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = _allFetchedCoupons.firstWhere(
          (c) => (c.promotion.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
        );
      } catch (e) {
        return {
          'success': false,
          'message': 'Coupon code not found',
          'error': 'COUPON_NOT_FOUND'
        };
      }

      // Step 2: Refresh cart to ensure we validate against latest data
      final cartController = _cartController;
      try {
        await cartController.refreshCartData();
      } catch (_) {
        // Continue with current cart data if refresh fails
      }

      // Step 3: Check only NON-product conditions (minimum_order, etc.)
      // Skip 'contains_products' validation since we will auto-add those products
      final hasProductCondition = CouponValidationHelper.hasContainsProductsCondition(coupon);
      final unmetMessage = hasProductCondition
          ? CouponValidationHelper.getFirstUnmetNonProductConditionMessage(
              coupon, cartController.cart.value,
              facetValueNames: _facetValueNames,
              variantNames: _variantNames,
              customerGroupNames: _customerGroupNames)
          : CouponValidationHelper.getFirstUnmetConditionMessage(
              coupon, cartController.cart.value,
              facetValueNames: _facetValueNames,
              variantNames: _variantNames,
              customerGroupNames: _customerGroupNames);

      Map<String, dynamic>? addResult;

      if (unmetMessage != null) {
        ErrorDialog.showWarning(message: unmetMessage);
        return {
          'success': false,
          'message': unmetMessage,
          'error': 'CONDITION_NOT_MET',
          'dialogShown': true,
        };
      }

      // Step 3: If coupon has 'contains_products' condition, add those products FIRST
      final hasProducts = hasCouponProducts(couponCode);
      if (hasProducts) {
        addResult = await addCouponProductsToCart(couponCode);
        if (!addResult['success']) {
          // Adding products failed - rollback added products and abort
          await removeCouponProducts(couponCode);
          _refreshCartAfterCouponError();
          String errorMsg = addResult['message'] as String? ?? 'Failed to add coupon products to cart.';
          final failedProducts = addResult['failedProducts'] as List<dynamic>? ?? [];
          if (failedProducts.isNotEmpty) {
            final details = failedProducts.map((f) {
              final p = f as Map<String, dynamic>?;
              final name = p?['product'] ?? 'Product';
              final err = p?['error'] ?? 'Unknown error';
              return '$name: $err';
            }).join('\n');
            if (details.isNotEmpty) errorMsg = '$errorMsg\n\n$details';
          }
          ErrorDialog.showWarning(message: errorMsg);
          return {
            'success': false,
            'message': errorMsg,
            'error': 'PRODUCT_ADDITION_FAILED',
            'addResult': addResult,
            'dialogShown': true,
          };
        }
      }

      // Step 4: Apply coupon code (products are now in cart, server validates contains_products)
      final couponResult = await _applyCouponCodeWithoutMinimumCheck(couponCode);

      if (!couponResult['success']) {
        // Coupon apply failed - rollback products we just added
        if (hasProducts) {
          await removeCouponProducts(couponCode);
        }
        final errorMessage = couponResult['message'] as String? ?? 'Failed to apply coupon code';
        ErrorDialog.showWarning(message: errorMessage);
        await _refreshCartAfterCouponError();
        return {
          'success': false,
          'message': errorMessage,
          'couponApplied': false,
          'couponError': couponResult['error'],
          'productsRolledBack': hasProducts,
          'dialogShown': true,
        };
      }

      // Success: products added (if any) and coupon applied
      try {
        final cartCtrl = Get.find<CartController>();
        await cartCtrl.getActiveOrder();
      } catch (e) {
      }
      try {
        await restoreCouponTrackingFromCart();
      } catch (e) {
      }
      return {
        'success': true,
        'message': hasProducts
            ? 'Coupon products added and coupon applied successfully'
            : 'Coupon applied successfully',
        'addedProducts': addResult?['addedProducts'] ?? [],
        'couponApplied': true,
        'orderTotal': couponResult['orderTotal'],
      };
    } catch (e) {
      // On error: remove coupon if applied, and any coupon-added products
      bool rollbackPerformed = false;
      try {
        await removeCouponCode(couponCode);
        if (couponAddedProducts.containsKey(couponCode)) {
          rollbackPerformed = await removeCouponProducts(couponCode);
        }
        originalCartQuantities.remove(couponCode);
        couponProductPreExisting.remove(couponCode);
        await _refreshCartAfterCouponError();
      } catch (_) {
        await _refreshCartAfterCouponError();
      }
      return {
        'success': false,
        'message': 'Error applying coupon. Please try again.',
        'error': 'APPLY_COUPON_WITH_PRODUCTS_ERROR',
        'rollbackPerformed': rollbackPerformed,
      };
    }
  }

  /// Rollback added products when coupon application fails (kept for optional use; currently we do not remove products on apply failure).
  // ignore: unused_element
  Future<Map<String, dynamic>> _rollbackAddedProducts(String couponCode) async {
    try {
      // Check if we have tracked products for this coupon
      if (!couponAddedProducts.containsKey(couponCode)) {
        return {
          'success': true,
          'message': 'No products to rollback',
          'removedCount': 0
        };
      }

      final productsToRemove = couponAddedProducts[couponCode]!;
      // Get current cart to find order line IDs for these products
      final cartController = _cartController;
      final cart = cartController.cart.value;
      if (cart == null) {
        return {
          'success': false,
          'message': 'No active cart found',
          'removedCount': 0
        };
      }

      final cartLines = cart.lines;
      int removedCount = 0;
      final failedRemovals = <String>[];

      for (final entry in productsToRemove.entries) {
        final variantId = entry.key;
        final quantityToRemove = entry.value;
        bool found = false;

        // Find order lines that match this variant ID
        for (final line in cartLines) {
          final lineId = line.id;
          final currentQuantity = line.quantity;
          final variantIdFromCart = line.productVariant.id;
          if (variantIdFromCart == variantId) {
            found = true;
            // Calculate new quantity after removing coupon-added quantity
            final newQuantity = currentQuantity - quantityToRemove;

            if (newQuantity <= 0) {
              // Remove the entire line if quantity becomes 0 or negative
              // This happens when: currentQuantity <= quantityToRemove
              final success = await _removeOrderLineById(lineId);
              if (success) {
                removedCount++;
                // Update controllers after removal
                try {
                  final orderController = _orderController;
                  await orderController.getActiveOrder(skipLoading: true);
                } catch (e) {
                }
              } else {
                failedRemovals.add('Line $lineId for variant $variantId');
              }
            } else {
              // Decrease quantity instead of removing the line
              // This happens when: currentQuantity > quantityToRemove
              final success = await cartController.adjustOrderLine(
                orderLineId: lineId,
                quantity: newQuantity,
              );
              if (success) {
                removedCount++;
                // Update controllers after quantity adjustment
                try {
                  final orderController = _orderController;
                  await orderController.getActiveOrder(skipLoading: true);
                } catch (e) {
                }
              } else {
                failedRemovals.add('Line $lineId for variant $variantId');
              }
            }
            break; // Process only one instance per variant ID
          }
        }

        if (!found) {
        }
      }
      // Clear the tracked products for this coupon
      couponAddedProducts.remove(couponCode);
      couponProductPreExisting.remove(couponCode);
      return {
        'success': removedCount > 0 || failedRemovals.isEmpty,
        'message': removedCount > 0
            ? 'Successfully rolled back $removedCount products'
            : 'No products were removed during rollback',
        'removedCount': removedCount,
        'failedRemovals': failedRemovals,
        'totalExpected': productsToRemove.length
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error during rollback: $e',
        'removedCount': 0
      };
    }
  }
}
