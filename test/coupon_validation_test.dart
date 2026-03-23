import 'package:flutter_test/flutter_test.dart';
import 'package:recipe.app/utils/coupon_validation_helper.dart';
import 'package:recipe.app/graphql/banner.graphql.dart';
import 'package:recipe.app/graphql/cart.graphql.dart' as cart_graphql;

// ---------------------------------------------------------------------------
// Helpers — construct types directly (avoids fromJson strict null checks)
// ---------------------------------------------------------------------------

typedef _CouponItem  = Query$GetCouponCodeList$getCouponCodeList$items;
typedef _Promotion   = Query$GetCouponCodeList$getCouponCodeList$items$promotion;
typedef _Action      = Query$GetCouponCodeList$getCouponCodeList$items$promotion$actions;
typedef _ActionArg   = Query$GetCouponCodeList$getCouponCodeList$items$promotion$actions$args;
typedef _Condition   = Query$GetCouponCodeList$getCouponCodeList$items$promotion$conditions;
typedef _CondArg     = Query$GetCouponCodeList$getCouponCodeList$items$promotion$conditions$args;

_CouponItem _makeCoupon({
  List<_Action> actions = const [],
  List<_Condition> conditions = const [],
}) {
  final now = DateTime.now();
  return _CouponItem(
    customerGroup: null,
    productVariants: [],
    facetValues: [],
    promotion: _Promotion(
      id: '1',
      name: 'Test',
      couponCode: 'TEST10',
      description: '',
      enabled: true,
      createdAt: now,
      updatedAt: now,
      actions: actions,
      conditions: conditions,
    ),
  );
}

_Action _makeAction(String code, Map<String, String> args) {
  return _Action(
    code: code,
    args: args.entries.map((e) => _ActionArg(name: e.key, value: e.value)).toList(),
  );
}

_Condition _makeCondition(String code, Map<String, String> args) {
  return _Condition(
    code: code,
    args: args.entries.map((e) => _CondArg(name: e.key, value: e.value)).toList(),
  );
}

cart_graphql.Fragment$Cart _makeCart({
  double subTotalWithTax = 0,
  int totalQuantity = 0,
  List<cart_graphql.Fragment$Cart$lines> lines = const [],
}) {
  return cart_graphql.Fragment$Cart(
    id: '1',
    code: 'ORDER001',
    state: 'AddingItems',
    active: true,
    validationStatus: cart_graphql.Fragment$Cart$validationStatus(
      isValid: true,
      hasUnavailableItems: false,
      totalUnavailableItems: 0,
      unavailableItems: [],
    ),
    couponCodes: [],
    promotions: [],
    lines: lines,
    totalQuantity: totalQuantity,
    subTotal: subTotalWithTax,
    subTotalWithTax: subTotalWithTax,
    total: subTotalWithTax,
    totalWithTax: subTotalWithTax,
    shipping: 0,
    shippingWithTax: 0,
    shippingLines: [],
    discounts: [],
    quantityLimitStatus: cart_graphql.Fragment$Cart$quantityLimitStatus(
      isValid: true,
      hasViolations: false,
      totalViolations: 0,
      violations: [],
    ),
  );
}

cart_graphql.Fragment$Cart$lines _makeCartLine({
  required String variantId,
  required int quantity,
  double unitPrice = 10000,
}) {
  return cart_graphql.Fragment$Cart$lines(
    id: 'line_$variantId',
    quantity: quantity,
    isAvailable: true,
    unitPrice: unitPrice,
    unitPriceWithTax: unitPrice,
    linePriceWithTax: unitPrice * quantity,
    discountedLinePriceWithTax: unitPrice * quantity,
    productVariant: cart_graphql.Fragment$Cart$lines$productVariant(
      id: variantId,
      name: 'Variant $variantId',
      stockLevel: 'IN_STOCK',
      price: unitPrice,
      product: cart_graphql.Fragment$Cart$lines$productVariant$product(
        enabled: true,
      ),
    ),
    discounts: [],
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // =========================================================================
  // 1. CONDITION: minimum_order_amount
  // =========================================================================
  group('minimum_order_amount', () {
    test('MET — cart >= required', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '50000'}),
      ]);
      final cart = _makeCart(subTotalWithTax: 60000);
      final r = CouponValidationHelper.evaluateConditions(c, cart);
      expect(r[0].isMet, true);
      expect(r[0].canValidate, true);
    });

    test('NOT MET — cart < required', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '50000'}),
      ]);
      final cart = _makeCart(subTotalWithTax: 30000);
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, false);
    });

    test('MET — exact boundary', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '50000'}),
      ]);
      final cart = _makeCart(subTotalWithTax: 50000);
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, true);
    });

    test('NOT MET — null cart', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '50000'}),
      ]);
      expect(CouponValidationHelper.evaluateConditions(c, null)[0].isMet, false);
    });

    test('effective subtotal — excludes contains_products free items', () {
      // Cart subtotal is 60000 but free product (variant 100) worth 20000 is in cart
      // Effective subtotal = 60000 - 20000 = 40000 < 50000 → NOT MET
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '50000'}),
        _makeCondition('contains_products', {
          'productVariantIds': '[100]',
          'minimum': '1',
        }),
      ]);
      final cart = _makeCart(
        subTotalWithTax: 60000,
        totalQuantity: 3,
        lines: [
          _makeCartLine(variantId: '100', quantity: 1, unitPrice: 20000),
          _makeCartLine(variantId: '200', quantity: 2, unitPrice: 20000),
        ],
      );
      final r = CouponValidationHelper.evaluateConditions(c, cart);
      // minimum_order_amount should use effective subtotal (60000 - 20000 = 40000)
      final minCond = r.firstWhere((c) => c.code == 'minimum_order_amount');
      expect(minCond.isMet, false, reason: 'effective subtotal 40000 < required 50000');
    });

    test('effective subtotal — excludes buy_x_get_y_free Y items', () {
      // Cart subtotal is 70000 but BXGY free product (variant 300) worth 15000
      // Effective subtotal = 70000 - 15000 = 55000 >= 50000 → MET
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '50000'}),
        _makeCondition('buy_x_get_y_free', {
          'amountX': '2',
          'amountY': '1',
          'variantIdsX': '[200]',
          'variantIdsY': '[300]',
        }),
      ]);
      final cart = _makeCart(
        subTotalWithTax: 70000,
        totalQuantity: 3,
        lines: [
          _makeCartLine(variantId: '200', quantity: 2, unitPrice: 27500),
          _makeCartLine(variantId: '300', quantity: 1, unitPrice: 15000),
        ],
      );
      final r = CouponValidationHelper.evaluateConditions(c, cart);
      final minCond = r.firstWhere((c) => c.code == 'minimum_order_amount');
      expect(minCond.isMet, true, reason: 'effective subtotal 55000 >= required 50000');
    });

    test('effective subtotal — no free products, uses raw subtotal', () {
      // No contains_products or BXGY → effective subtotal = raw subtotal
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '50000'}),
      ]);
      final cart = _makeCart(subTotalWithTax: 60000);
      final r = CouponValidationHelper.evaluateConditions(c, cart);
      expect(r[0].isMet, true, reason: 'no free products, raw subtotal 60000 >= 50000');
    });
  });

  // =========================================================================
  // 2. CONDITION: contains_products
  //    Always isMet: true (free product benefit, auto-added to cart)
  // =========================================================================
  group('contains_products', () {
    test('MET — required product in cart with enough quantity', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('contains_products', {
          'productVariantIds': '[100,101]',
          'minimum': '1',
        }),
      ]);
      final cart = _makeCart(
        totalQuantity: 2,
        lines: [_makeCartLine(variantId: '100', quantity: 2)],
      );
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, true);
    });

    test('NOT MET — required product NOT in cart (will be auto-added)', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('contains_products', {
          'productVariantIds': '[100]',
          'minimum': '1',
        }),
      ]);
      final cart = _makeCart(
        totalQuantity: 1,
        lines: [_makeCartLine(variantId: '999', quantity: 1)],
      );
      // contains_products checks if product is in cart; if not, it will be auto-added during apply
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, false);
    });

    test('NOT MET — quantity below minimum', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('contains_products', {
          'productVariantIds': '[100]',
          'minimum': '3',
        }),
      ]);
      final cart = _makeCart(
        totalQuantity: 2,
        lines: [_makeCartLine(variantId: '100', quantity: 2)],
      );
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, false);
    });

    test('displayText shows "Buy at least" when not met', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('contains_products', {
          'productVariantIds': '[100]',
          'minimum': '2',
        }),
      ]);
      final r = CouponValidationHelper.evaluateConditions(c, _makeCart());
      expect(r[0].displayText, contains('Buy at least'));
      expect(r[0].displayText, contains('2'));
    });

    test('displayText shows action discount when met', () {
      final c = _makeCoupon(
        conditions: [
          _makeCondition('contains_products', {
            'productVariantIds': '[100]',
            'minimum': '1',
          }),
        ],
        actions: [
          _makeAction('order_percentage_discount', {'discount': '10'}),
        ],
      );
      final cart = _makeCart(
        totalQuantity: 1,
        lines: [_makeCartLine(variantId: '100', quantity: 1)],
      );
      final r = CouponValidationHelper.evaluateConditions(c, cart);
      expect(r[0].isMet, true);
      expect(r[0].displayText, contains('10% off'));
    });

    test('canValidate false when empty variant IDs', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('contains_products', {
          'productVariantIds': '',
          'minimum': '1',
        }),
      ]);
      expect(CouponValidationHelper.evaluateConditions(c, _makeCart())[0].canValidate, false);
    });
  });

  // =========================================================================
  // 3. CONDITION: buy_x_get_y_free
  // =========================================================================
  group('buy_x_get_y_free', () {
    test('MET — quantity >= X', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('buy_x_get_y_free', {'amountX': '3'}),
      ]);
      final cart = _makeCart(totalQuantity: 5);
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, true);
    });

    test('NOT MET — quantity < X', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('buy_x_get_y_free', {'amountX': '3'}),
      ]);
      final cart = _makeCart(totalQuantity: 2);
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, false);
    });

    test('MET — exact boundary', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('buy_x_get_y_free', {'amountX': '3'}),
      ]);
      final cart = _makeCart(totalQuantity: 3);
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, true);
    });

    test('MET — specific variantIdsX matched', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('buy_x_get_y_free', {
          'amountX': '2',
          'variantIdsX': '[10,11]',
        }),
      ]);
      final cart = _makeCart(
        totalQuantity: 3,
        lines: [
          _makeCartLine(variantId: '10', quantity: 2),
          _makeCartLine(variantId: '99', quantity: 1),
        ],
      );
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, true);
    });

    test('NOT MET — specific variantIdsX not in cart', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('buy_x_get_y_free', {
          'amountX': '2',
          'variantIdsX': '[10,11]',
        }),
      ]);
      final cart = _makeCart(
        totalQuantity: 3,
        lines: [_makeCartLine(variantId: '99', quantity: 3)],
      );
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, false);
    });
  });

  // =========================================================================
  // 4. CONDITION: at_least_n_items
  // =========================================================================
  group('at_least_n_items', () {
    test('MET — totalQuantity >= minimum', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('at_least_n_items', {'minimum': '3'}),
      ]);
      final cart = _makeCart(totalQuantity: 5);
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, true);
    });

    test('NOT MET — totalQuantity < minimum', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('at_least_n_items', {'minimum': '3'}),
      ]);
      final cart = _makeCart(totalQuantity: 2);
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, false);
    });

    test('MET — exact boundary', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('at_least_n_items', {'minimum': '3'}),
      ]);
      final cart = _makeCart(totalQuantity: 3);
      expect(CouponValidationHelper.evaluateConditions(c, cart)[0].isMet, true);
    });

    test('NOT MET — null cart', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('at_least_n_items', {'minimum': '1'}),
      ]);
      expect(CouponValidationHelper.evaluateConditions(c, null)[0].isMet, false);
    });

    test('canValidate true', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('at_least_n_items', {'minimum': '2'}),
      ]);
      expect(CouponValidationHelper.evaluateConditions(c, _makeCart())[0].canValidate, true);
    });

    test('displayText contains minimum count', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('at_least_n_items', {'minimum': '4'}),
      ]);
      final r = CouponValidationHelper.evaluateConditions(c, _makeCart());
      expect(r[0].displayText, contains('4'));
    });
  });

  // =========================================================================
  // 5. CONDITION: has_active_customer
  // =========================================================================
  group('has_active_customer', () {
    test('MET — cart is not null (logged in)', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('has_active_customer', {}),
      ]);
      expect(CouponValidationHelper.evaluateConditions(c, _makeCart())[0].isMet, true);
    });

    test('NOT MET — null cart (not logged in)', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('has_active_customer', {}),
      ]);
      expect(CouponValidationHelper.evaluateConditions(c, null)[0].isMet, false);
    });

    test('canValidate true', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('has_active_customer', {}),
      ]);
      expect(CouponValidationHelper.evaluateConditions(c, _makeCart())[0].canValidate, true);
    });
  });

  // =========================================================================
  // 6. CONDITION: at_least_n_with_facets (server-only)
  // =========================================================================
  group('at_least_n_with_facets', () {
    test('canValidate false (server-side only)', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('at_least_n_with_facets', {'minimum': '2', 'facets': '[1]'}),
      ]);
      final r = CouponValidationHelper.evaluateConditions(c, _makeCart());
      expect(r[0].canValidate, false);
      expect(r[0].displayText, contains('2'));
    });
  });

  // =========================================================================
  // 7. CONDITION: customer_group (server-only)
  // =========================================================================
  group('customer_group', () {
    test('canValidate false (server-side only)', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('customer_group', {'customerGroupId': '5'}),
      ]);
      expect(CouponValidationHelper.evaluateConditions(c, _makeCart())[0].canValidate, false);
    });
  });

  // =========================================================================
  // 7b. CONDITION: shouldApplyCouponcode (server-only)
  // =========================================================================
  group('shouldApplyCouponcode', () {
    test('canValidate false (server-side only)', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('shouldApplyCouponcode', {}),
      ]);
      final r = CouponValidationHelper.evaluateConditions(c, _makeCart());
      expect(r[0].canValidate, false);
      expect(r[0].code, 'shouldApplyCouponcode');
      expect(r[0].displayText, 'Coupon code required');
    });

    test('does not block areAllConditionsMet', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('shouldApplyCouponcode', {}),
        _makeCondition('minimum_order_amount', {'amount': '1000'}),
      ]);
      final cart = _makeCart(subTotalWithTax: 5000);
      expect(CouponValidationHelper.areAllConditionsMet(c, cart), true);
    });
  });

  // =========================================================================
  // 8. Unknown condition
  // =========================================================================
  group('unknown condition', () {
    test('canValidate false for unknown code', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('some_future_condition', {}),
      ]);
      final r = CouponValidationHelper.evaluateConditions(c, _makeCart());
      expect(r[0].canValidate, false);
      expect(r[0].displayText, 'Special condition applies');
    });
  });

  // =========================================================================
  // 9. Multiple conditions combined
  // =========================================================================
  group('multiple conditions', () {
    test('ALL MET — minimum + at_least_n_items', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '20000'}),
        _makeCondition('at_least_n_items', {'minimum': '2'}),
      ]);
      final cart = _makeCart(subTotalWithTax: 30000, totalQuantity: 3);
      expect(CouponValidationHelper.areAllConditionsMet(c, cart), true);
      expect(CouponValidationHelper.getFirstUnmetConditionMessage(c, cart), isNull);
    });

    test('PARTIAL — minimum met, at_least_n_items not', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '20000'}),
        _makeCondition('at_least_n_items', {'minimum': '5'}),
      ]);
      final cart = _makeCart(subTotalWithTax: 30000, totalQuantity: 2);
      expect(CouponValidationHelper.areAllConditionsMet(c, cart), false);
      expect(CouponValidationHelper.getFirstUnmetConditionMessage(c, cart), isNotNull);
    });

    test('PARTIAL — minimum not met, at_least_n_items met', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '50000'}),
        _makeCondition('at_least_n_items', {'minimum': '1'}),
      ]);
      final cart = _makeCart(subTotalWithTax: 10000, totalQuantity: 2);
      expect(CouponValidationHelper.areAllConditionsMet(c, cart), false);
    });

    test('contains_products MET when product in cart — does not block areAllConditionsMet', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '20000'}),
        _makeCondition('contains_products', {
          'productVariantIds': '[100]',
          'minimum': '1',
        }),
      ]);
      // Cart has enough total AND the specific product
      final cart = _makeCart(
        subTotalWithTax: 30000,
        totalQuantity: 1,
        lines: [_makeCartLine(variantId: '100', quantity: 1)],
      );
      expect(CouponValidationHelper.areAllConditionsMet(c, cart), true);
    });

    test('contains_products NOT MET when product not in cart', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '20000'}),
        _makeCondition('contains_products', {
          'productVariantIds': '[100]',
          'minimum': '1',
        }),
      ]);
      // Cart has enough total but NOT the specific product
      final cart = _makeCart(
        subTotalWithTax: 30000,
        totalQuantity: 1,
        lines: [_makeCartLine(variantId: '999', quantity: 1)],
      );
      expect(CouponValidationHelper.areAllConditionsMet(c, cart), false);
    });

    test('getFirstUnmetNonProductConditionMessage skips contains_products', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('contains_products', {
          'productVariantIds': '[100]',
          'minimum': '1',
        }),
        _makeCondition('minimum_order_amount', {'amount': '50000'}),
      ]);
      final cart = _makeCart(subTotalWithTax: 10000);
      final msg = CouponValidationHelper.getFirstUnmetNonProductConditionMessage(c, cart);
      expect(msg, contains('Minimum order'));
    });

    test('server-side conditions ignored in areAllConditionsMet', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '1000'}),
        _makeCondition('customer_group', {'customerGroupId': '99'}),
      ]);
      final cart = _makeCart(subTotalWithTax: 5000);
      // customer_group has canValidate=false so it doesn't block
      expect(CouponValidationHelper.areAllConditionsMet(c, cart), true);
    });
  });

  // =========================================================================
  // 10. No conditions
  // =========================================================================
  group('no conditions', () {
    test('areAllConditionsMet true with empty conditions', () {
      final c = _makeCoupon();
      expect(CouponValidationHelper.areAllConditionsMet(c, _makeCart()), true);
    });
  });

  // =========================================================================
  // 11. ACTION parsing
  // =========================================================================
  group('actions', () {
    test('order_percentage_discount', () {
      final c = _makeCoupon(actions: [
        _makeAction('order_percentage_discount', {'discount': '10'}),
      ]);
      final a = CouponValidationHelper.parseActions(c);
      expect(a[0].displayText, '10% off your order');
    });

    test('order_fixed_discount', () {
      final c = _makeCoupon(actions: [
        _makeAction('order_fixed_discount', {'discount': '10000'}),
      ]);
      final a = CouponValidationHelper.parseActions(c);
      expect(a[0].displayText, contains('off your order'));
    });

    test('facet_based_discount', () {
      final c = _makeCoupon(actions: [
        _makeAction('facet_based_discount', {'discount': '15'}),
      ]);
      expect(CouponValidationHelper.parseActions(c)[0].displayText, '15% off selected items');
    });

    test('products_percentage_discount', () {
      final c = _makeCoupon(actions: [
        _makeAction('products_percentage_discount', {'discount': '20'}),
      ]);
      expect(CouponValidationHelper.parseActions(c)[0].displayText, '20% off specific products');
    });

    test('free_shipping', () {
      final c = _makeCoupon(actions: [
        _makeAction('free_shipping', {}),
      ]);
      expect(CouponValidationHelper.parseActions(c)[0].displayText, 'Free shipping');
    });

    test('buy_x_get_y_free', () {
      final c = _makeCoupon(actions: [
        _makeAction('buy_x_get_y_free', {'amountX': '3', 'amountY': '1'}),
      ]);
      expect(CouponValidationHelper.parseActions(c)[0].displayText, 'Buy 3 get 1 free');
    });

    test('order_line_fixed_discount', () {
      final c = _makeCoupon(actions: [
        _makeAction('order_line_fixed_discount', {'discount': '5000'}),
      ]);
      final a = CouponValidationHelper.parseActions(c);
      expect(a[0].displayText, contains('off each item'));
    });

    test('unknown action', () {
      final c = _makeCoupon(actions: [
        _makeAction('some_new_action', {}),
      ]);
      expect(CouponValidationHelper.parseActions(c)[0].displayText, 'Special discount');
    });

    test('hasPriceDiscountActions true for non-shipping action', () {
      final c = _makeCoupon(actions: [
        _makeAction('order_percentage_discount', {'discount': '10'}),
      ]);
      expect(CouponValidationHelper.hasPriceDiscountActions(c), true);
    });

    test('hasPriceDiscountActions false for free_shipping only', () {
      final c = _makeCoupon(actions: [
        _makeAction('free_shipping', {}),
      ]);
      expect(CouponValidationHelper.hasPriceDiscountActions(c), false);
    });

    test('hasPriceDiscountActions true when mixed shipping + discount', () {
      final c = _makeCoupon(actions: [
        _makeAction('free_shipping', {}),
        _makeAction('order_fixed_discount', {'discount': '5000'}),
      ]);
      expect(CouponValidationHelper.hasPriceDiscountActions(c), true);
    });
  });

  // =========================================================================
  // 12. hasContainsProductsCondition
  // =========================================================================
  group('hasContainsProductsCondition', () {
    test('true when condition exists', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('contains_products', {
          'productVariantIds': '[100]',
          'minimum': '1',
        }),
      ]);
      expect(CouponValidationHelper.hasContainsProductsCondition(c), true);
    });

    test('false when condition missing', () {
      final c = _makeCoupon(conditions: [
        _makeCondition('minimum_order_amount', {'amount': '10000'}),
      ]);
      expect(CouponValidationHelper.hasContainsProductsCondition(c), false);
    });

    test('false when no conditions', () {
      expect(CouponValidationHelper.hasContainsProductsCondition(_makeCoupon()), false);
    });
  });

  // =========================================================================
  // 13. ALL 42 CONDITION × ACTION COMBINATIONS
  //     6 conditions × 7 actions = 42 combos
  //     Verifies that evaluateConditions + parseActions work correctly
  //     when a coupon has BOTH a condition and an action together.
  // =========================================================================

  // --- Helper lists for the matrix ---
  // These match the EXACT 6 conditions available in the admin API
  final allConditions = <String, Map<String, String>>{
    'minimum_order_amount':    {'amount': '50000'},
    'contains_products':       {'productVariantIds': '[100,101]', 'minimum': '1'},
    'at_least_n_with_facets':  {'minimum': '2', 'facets': '[1,2]'},
    'customer_group':          {'customerGroupId': '5'},
    'buy_x_get_y_free':        {'amountX': '3', 'amountY': '1'},
    'shouldApplyCouponcode':   {},
  };

  final allActions = <String, Map<String, String>>{
    'order_percentage_discount':  {'discount': '10'},
    'order_fixed_discount':       {'discount': '10000'},
    'facet_based_discount':       {'discount': '15'},
    'products_percentage_discount': {'discount': '20', 'productVariantIds': '[100]'},
    'free_shipping':              {},
    'buy_x_get_y_free':           {'amountX': '3', 'amountY': '1'},
    'order_line_fixed_discount':  {'discount': '5000'},
  };

  // ---------------------------------------------------------------------------
  // 1. minimum_order_amount × all 7 actions
  // ---------------------------------------------------------------------------
  group('COMBO: minimum_order_amount ×', () {
    for (final actionEntry in allActions.entries) {
      test('${actionEntry.key} — MET', () {
        final c = _makeCoupon(
          conditions: [_makeCondition('minimum_order_amount', allConditions['minimum_order_amount']!)],
          actions: [_makeAction(actionEntry.key, actionEntry.value)],
        );
        final cart = _makeCart(subTotalWithTax: 60000, totalQuantity: 5);
        final conds = CouponValidationHelper.evaluateConditions(c, cart);
        final acts = CouponValidationHelper.parseActions(c);
        expect(conds.length, 1);
        expect(conds[0].isMet, true);
        expect(conds[0].code, 'minimum_order_amount');
        expect(acts.length, 1);
        expect(acts[0].code, actionEntry.key);
        expect(acts[0].displayText.isNotEmpty, true);
        expect(CouponValidationHelper.areAllConditionsMet(c, cart), true);
      });

      test('${actionEntry.key} — NOT MET', () {
        final c = _makeCoupon(
          conditions: [_makeCondition('minimum_order_amount', allConditions['minimum_order_amount']!)],
          actions: [_makeAction(actionEntry.key, actionEntry.value)],
        );
        final cart = _makeCart(subTotalWithTax: 20000, totalQuantity: 1);
        final conds = CouponValidationHelper.evaluateConditions(c, cart);
        expect(conds[0].isMet, false);
        expect(CouponValidationHelper.areAllConditionsMet(c, cart), false);
        expect(CouponValidationHelper.getFirstUnmetConditionMessage(c, cart), isNotNull);
      });
    }
  });

  // ---------------------------------------------------------------------------
  // 2. contains_products × all 7 actions
  // ---------------------------------------------------------------------------
  group('COMBO: contains_products ×', () {
    for (final actionEntry in allActions.entries) {
      test('${actionEntry.key} — always MET (free benefit)', () {
        final c = _makeCoupon(
          conditions: [_makeCondition('contains_products', allConditions['contains_products']!)],
          actions: [_makeAction(actionEntry.key, actionEntry.value)],
        );
        final cart = _makeCart(
          subTotalWithTax: 30000,
          totalQuantity: 2,
          lines: [_makeCartLine(variantId: '100', quantity: 2)],
        );
        final conds = CouponValidationHelper.evaluateConditions(c, cart);
        final acts = CouponValidationHelper.parseActions(c);
        expect(conds.length, 1);
        expect(conds[0].isMet, true, reason: 'contains_products met — product 100 is in cart with qty 2 >= minimum 1');
        expect(conds[0].code, 'contains_products');
        expect(acts.length, 1);
        expect(acts[0].code, actionEntry.key);
        expect(acts[0].displayText.isNotEmpty, true);
        expect(CouponValidationHelper.areAllConditionsMet(c, cart), true);
      });
    }
  });

  // ---------------------------------------------------------------------------
  // 3. at_least_n_with_facets × all 7 actions
  // ---------------------------------------------------------------------------
  group('COMBO: at_least_n_with_facets ×', () {
    for (final actionEntry in allActions.entries) {
      test('${actionEntry.key} — server-only, canValidate false', () {
        final c = _makeCoupon(
          conditions: [_makeCondition('at_least_n_with_facets', allConditions['at_least_n_with_facets']!)],
          actions: [_makeAction(actionEntry.key, actionEntry.value)],
        );
        final cart = _makeCart(subTotalWithTax: 60000, totalQuantity: 5);
        final conds = CouponValidationHelper.evaluateConditions(c, cart);
        final acts = CouponValidationHelper.parseActions(c);
        expect(conds.length, 1);
        expect(conds[0].canValidate, false, reason: 'at_least_n_with_facets is server-only');
        expect(conds[0].code, 'at_least_n_with_facets');
        expect(acts.length, 1);
        expect(acts[0].code, actionEntry.key);
        expect(acts[0].displayText.isNotEmpty, true);
        // Server-only conditions don't block areAllConditionsMet
        expect(CouponValidationHelper.areAllConditionsMet(c, cart), true);
      });
    }
  });

  // ---------------------------------------------------------------------------
  // 4. customer_group × all 7 actions
  // ---------------------------------------------------------------------------
  group('COMBO: customer_group ×', () {
    for (final actionEntry in allActions.entries) {
      test('${actionEntry.key} — server-only, canValidate false', () {
        final c = _makeCoupon(
          conditions: [_makeCondition('customer_group', allConditions['customer_group']!)],
          actions: [_makeAction(actionEntry.key, actionEntry.value)],
        );
        final cart = _makeCart(subTotalWithTax: 60000, totalQuantity: 5);
        final conds = CouponValidationHelper.evaluateConditions(c, cart);
        final acts = CouponValidationHelper.parseActions(c);
        expect(conds.length, 1);
        expect(conds[0].canValidate, false, reason: 'customer_group is server-only');
        expect(conds[0].code, 'customer_group');
        expect(acts.length, 1);
        expect(acts[0].code, actionEntry.key);
        expect(acts[0].displayText.isNotEmpty, true);
        // Server-only conditions don't block areAllConditionsMet
        expect(CouponValidationHelper.areAllConditionsMet(c, cart), true);
      });
    }
  });

  // ---------------------------------------------------------------------------
  // 5. buy_x_get_y_free × all 7 actions
  // ---------------------------------------------------------------------------
  group('COMBO: buy_x_get_y_free ×', () {
    for (final actionEntry in allActions.entries) {
      test('${actionEntry.key} — MET (qty >= X)', () {
        final c = _makeCoupon(
          conditions: [_makeCondition('buy_x_get_y_free', allConditions['buy_x_get_y_free']!)],
          actions: [_makeAction(actionEntry.key, actionEntry.value)],
        );
        final cart = _makeCart(subTotalWithTax: 60000, totalQuantity: 5);
        final conds = CouponValidationHelper.evaluateConditions(c, cart);
        final acts = CouponValidationHelper.parseActions(c);
        expect(conds.length, 1);
        expect(conds[0].isMet, true);
        expect(conds[0].code, 'buy_x_get_y_free');
        expect(acts.length, 1);
        expect(acts[0].code, actionEntry.key);
        expect(acts[0].displayText.isNotEmpty, true);
        expect(CouponValidationHelper.areAllConditionsMet(c, cart), true);
      });

      test('${actionEntry.key} — NOT MET (qty < X)', () {
        final c = _makeCoupon(
          conditions: [_makeCondition('buy_x_get_y_free', allConditions['buy_x_get_y_free']!)],
          actions: [_makeAction(actionEntry.key, actionEntry.value)],
        );
        final cart = _makeCart(subTotalWithTax: 10000, totalQuantity: 1);
        final conds = CouponValidationHelper.evaluateConditions(c, cart);
        expect(conds[0].isMet, false);
        expect(CouponValidationHelper.areAllConditionsMet(c, cart), false);
        expect(CouponValidationHelper.getFirstUnmetConditionMessage(c, cart), isNotNull);
      });
    }
  });

  // ---------------------------------------------------------------------------
  // 6. shouldApplyCouponcode × all 7 actions
  // ---------------------------------------------------------------------------
  group('COMBO: shouldApplyCouponcode ×', () {
    for (final actionEntry in allActions.entries) {
      test('${actionEntry.key} — server-only, canValidate false', () {
        final c = _makeCoupon(
          conditions: [_makeCondition('shouldApplyCouponcode', allConditions['shouldApplyCouponcode']!)],
          actions: [_makeAction(actionEntry.key, actionEntry.value)],
        );
        final cart = _makeCart(subTotalWithTax: 60000, totalQuantity: 5);
        final conds = CouponValidationHelper.evaluateConditions(c, cart);
        final acts = CouponValidationHelper.parseActions(c);
        expect(conds.length, 1);
        expect(conds[0].canValidate, false, reason: 'shouldApplyCouponcode is server-only');
        expect(conds[0].code, 'shouldApplyCouponcode');
        expect(acts.length, 1);
        expect(acts[0].code, actionEntry.key);
        expect(acts[0].displayText.isNotEmpty, true);
        // Server-only conditions don't block areAllConditionsMet
        expect(CouponValidationHelper.areAllConditionsMet(c, cart), true);
      });
    }
  });
}
