import 'dart:async';
import 'order.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Fragment$Cart {
  Fragment$Cart({
    required this.id,
    required this.code,
    required this.state,
    required this.active,
    required this.validationStatus,
    required this.couponCodes,
    required this.promotions,
    required this.lines,
    required this.totalQuantity,
    required this.subTotal,
    required this.subTotalWithTax,
    required this.total,
    required this.totalWithTax,
    required this.shipping,
    required this.shippingWithTax,
    required this.shippingLines,
    required this.discounts,
    this.customFields,
    required this.quantityLimitStatus,
    this.$__typename = 'Order',
  });

  factory Fragment$Cart.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$state = json['state'];
    final l$active = json['active'];
    final l$validationStatus = json['validationStatus'];
    final l$couponCodes = json['couponCodes'];
    final l$promotions = json['promotions'];
    final l$lines = json['lines'];
    final l$totalQuantity = json['totalQuantity'];
    final l$subTotal = json['subTotal'];
    final l$subTotalWithTax = json['subTotalWithTax'];
    final l$total = json['total'];
    final l$totalWithTax = json['totalWithTax'];
    final l$shipping = json['shipping'];
    final l$shippingWithTax = json['shippingWithTax'];
    final l$shippingLines = json['shippingLines'];
    final l$discounts = json['discounts'];
    final l$customFields = json['customFields'];
    final l$quantityLimitStatus = json['quantityLimitStatus'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart(
      id: (l$id as String),
      code: (l$code as String),
      state: (l$state as String),
      active: (l$active as bool),
      validationStatus: Fragment$Cart$validationStatus.fromJson(
          (l$validationStatus as Map<String, dynamic>)),
      couponCodes:
          (l$couponCodes as List<dynamic>).map((e) => (e as String)).toList(),
      promotions: (l$promotions as List<dynamic>)
          .map((e) =>
              Fragment$Cart$promotions.fromJson((e as Map<String, dynamic>)))
          .toList(),
      lines: (l$lines as List<dynamic>)
          .map((e) => Fragment$Cart$lines.fromJson((e as Map<String, dynamic>)))
          .toList(),
      totalQuantity: (l$totalQuantity as int),
      subTotal: (l$subTotal as num).toDouble(),
      subTotalWithTax: (l$subTotalWithTax as num).toDouble(),
      total: (l$total as num).toDouble(),
      totalWithTax: (l$totalWithTax as num).toDouble(),
      shipping: (l$shipping as num).toDouble(),
      shippingWithTax: (l$shippingWithTax as num).toDouble(),
      shippingLines: (l$shippingLines as List<dynamic>)
          .map((e) =>
              Fragment$Cart$shippingLines.fromJson((e as Map<String, dynamic>)))
          .toList(),
      discounts: (l$discounts as List<dynamic>)
          .map((e) =>
              Fragment$Cart$discounts.fromJson((e as Map<String, dynamic>)))
          .toList(),
      customFields: l$customFields == null
          ? null
          : Fragment$Cart$customFields.fromJson(
              (l$customFields as Map<String, dynamic>)),
      quantityLimitStatus: Fragment$Cart$quantityLimitStatus.fromJson(
          (l$quantityLimitStatus as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String state;

  final bool active;

  final Fragment$Cart$validationStatus validationStatus;

  final List<String> couponCodes;

  final List<Fragment$Cart$promotions> promotions;

  final List<Fragment$Cart$lines> lines;

  final int totalQuantity;

  final double subTotal;

  final double subTotalWithTax;

  final double total;

  final double totalWithTax;

  final double shipping;

  final double shippingWithTax;

  final List<Fragment$Cart$shippingLines> shippingLines;

  final List<Fragment$Cart$discounts> discounts;

  final Fragment$Cart$customFields? customFields;

  final Fragment$Cart$quantityLimitStatus quantityLimitStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$state = state;
    _resultData['state'] = l$state;
    final l$active = active;
    _resultData['active'] = l$active;
    final l$validationStatus = validationStatus;
    _resultData['validationStatus'] = l$validationStatus.toJson();
    final l$couponCodes = couponCodes;
    _resultData['couponCodes'] = l$couponCodes.map((e) => e).toList();
    final l$promotions = promotions;
    _resultData['promotions'] = l$promotions.map((e) => e.toJson()).toList();
    final l$lines = lines;
    _resultData['lines'] = l$lines.map((e) => e.toJson()).toList();
    final l$totalQuantity = totalQuantity;
    _resultData['totalQuantity'] = l$totalQuantity;
    final l$subTotal = subTotal;
    _resultData['subTotal'] = l$subTotal;
    final l$subTotalWithTax = subTotalWithTax;
    _resultData['subTotalWithTax'] = l$subTotalWithTax;
    final l$total = total;
    _resultData['total'] = l$total;
    final l$totalWithTax = totalWithTax;
    _resultData['totalWithTax'] = l$totalWithTax;
    final l$shipping = shipping;
    _resultData['shipping'] = l$shipping;
    final l$shippingWithTax = shippingWithTax;
    _resultData['shippingWithTax'] = l$shippingWithTax;
    final l$shippingLines = shippingLines;
    _resultData['shippingLines'] =
        l$shippingLines.map((e) => e.toJson()).toList();
    final l$discounts = discounts;
    _resultData['discounts'] = l$discounts.map((e) => e.toJson()).toList();
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
    final l$quantityLimitStatus = quantityLimitStatus;
    _resultData['quantityLimitStatus'] = l$quantityLimitStatus.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$state = state;
    final l$active = active;
    final l$validationStatus = validationStatus;
    final l$couponCodes = couponCodes;
    final l$promotions = promotions;
    final l$lines = lines;
    final l$totalQuantity = totalQuantity;
    final l$subTotal = subTotal;
    final l$subTotalWithTax = subTotalWithTax;
    final l$total = total;
    final l$totalWithTax = totalWithTax;
    final l$shipping = shipping;
    final l$shippingWithTax = shippingWithTax;
    final l$shippingLines = shippingLines;
    final l$discounts = discounts;
    final l$customFields = customFields;
    final l$quantityLimitStatus = quantityLimitStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$state,
      l$active,
      l$validationStatus,
      Object.hashAll(l$couponCodes.map((v) => v)),
      Object.hashAll(l$promotions.map((v) => v)),
      Object.hashAll(l$lines.map((v) => v)),
      l$totalQuantity,
      l$subTotal,
      l$subTotalWithTax,
      l$total,
      l$totalWithTax,
      l$shipping,
      l$shippingWithTax,
      Object.hashAll(l$shippingLines.map((v) => v)),
      Object.hashAll(l$discounts.map((v) => v)),
      l$customFields,
      l$quantityLimitStatus,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$state = state;
    final lOther$state = other.state;
    if (l$state != lOther$state) {
      return false;
    }
    final l$active = active;
    final lOther$active = other.active;
    if (l$active != lOther$active) {
      return false;
    }
    final l$validationStatus = validationStatus;
    final lOther$validationStatus = other.validationStatus;
    if (l$validationStatus != lOther$validationStatus) {
      return false;
    }
    final l$couponCodes = couponCodes;
    final lOther$couponCodes = other.couponCodes;
    if (l$couponCodes.length != lOther$couponCodes.length) {
      return false;
    }
    for (int i = 0; i < l$couponCodes.length; i++) {
      final l$couponCodes$entry = l$couponCodes[i];
      final lOther$couponCodes$entry = lOther$couponCodes[i];
      if (l$couponCodes$entry != lOther$couponCodes$entry) {
        return false;
      }
    }
    final l$promotions = promotions;
    final lOther$promotions = other.promotions;
    if (l$promotions.length != lOther$promotions.length) {
      return false;
    }
    for (int i = 0; i < l$promotions.length; i++) {
      final l$promotions$entry = l$promotions[i];
      final lOther$promotions$entry = lOther$promotions[i];
      if (l$promotions$entry != lOther$promotions$entry) {
        return false;
      }
    }
    final l$lines = lines;
    final lOther$lines = other.lines;
    if (l$lines.length != lOther$lines.length) {
      return false;
    }
    for (int i = 0; i < l$lines.length; i++) {
      final l$lines$entry = l$lines[i];
      final lOther$lines$entry = lOther$lines[i];
      if (l$lines$entry != lOther$lines$entry) {
        return false;
      }
    }
    final l$totalQuantity = totalQuantity;
    final lOther$totalQuantity = other.totalQuantity;
    if (l$totalQuantity != lOther$totalQuantity) {
      return false;
    }
    final l$subTotal = subTotal;
    final lOther$subTotal = other.subTotal;
    if (l$subTotal != lOther$subTotal) {
      return false;
    }
    final l$subTotalWithTax = subTotalWithTax;
    final lOther$subTotalWithTax = other.subTotalWithTax;
    if (l$subTotalWithTax != lOther$subTotalWithTax) {
      return false;
    }
    final l$total = total;
    final lOther$total = other.total;
    if (l$total != lOther$total) {
      return false;
    }
    final l$totalWithTax = totalWithTax;
    final lOther$totalWithTax = other.totalWithTax;
    if (l$totalWithTax != lOther$totalWithTax) {
      return false;
    }
    final l$shipping = shipping;
    final lOther$shipping = other.shipping;
    if (l$shipping != lOther$shipping) {
      return false;
    }
    final l$shippingWithTax = shippingWithTax;
    final lOther$shippingWithTax = other.shippingWithTax;
    if (l$shippingWithTax != lOther$shippingWithTax) {
      return false;
    }
    final l$shippingLines = shippingLines;
    final lOther$shippingLines = other.shippingLines;
    if (l$shippingLines.length != lOther$shippingLines.length) {
      return false;
    }
    for (int i = 0; i < l$shippingLines.length; i++) {
      final l$shippingLines$entry = l$shippingLines[i];
      final lOther$shippingLines$entry = lOther$shippingLines[i];
      if (l$shippingLines$entry != lOther$shippingLines$entry) {
        return false;
      }
    }
    final l$discounts = discounts;
    final lOther$discounts = other.discounts;
    if (l$discounts.length != lOther$discounts.length) {
      return false;
    }
    for (int i = 0; i < l$discounts.length; i++) {
      final l$discounts$entry = l$discounts[i];
      final lOther$discounts$entry = lOther$discounts[i];
      if (l$discounts$entry != lOther$discounts$entry) {
        return false;
      }
    }
    final l$customFields = customFields;
    final lOther$customFields = other.customFields;
    if (l$customFields != lOther$customFields) {
      return false;
    }
    final l$quantityLimitStatus = quantityLimitStatus;
    final lOther$quantityLimitStatus = other.quantityLimitStatus;
    if (l$quantityLimitStatus != lOther$quantityLimitStatus) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart on Fragment$Cart {
  CopyWith$Fragment$Cart<Fragment$Cart> get copyWith => CopyWith$Fragment$Cart(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$Cart<TRes> {
  factory CopyWith$Fragment$Cart(
    Fragment$Cart instance,
    TRes Function(Fragment$Cart) then,
  ) = _CopyWithImpl$Fragment$Cart;

  factory CopyWith$Fragment$Cart.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart;

  TRes call({
    String? id,
    String? code,
    String? state,
    bool? active,
    Fragment$Cart$validationStatus? validationStatus,
    List<String>? couponCodes,
    List<Fragment$Cart$promotions>? promotions,
    List<Fragment$Cart$lines>? lines,
    int? totalQuantity,
    double? subTotal,
    double? subTotalWithTax,
    double? total,
    double? totalWithTax,
    double? shipping,
    double? shippingWithTax,
    List<Fragment$Cart$shippingLines>? shippingLines,
    List<Fragment$Cart$discounts>? discounts,
    Fragment$Cart$customFields? customFields,
    Fragment$Cart$quantityLimitStatus? quantityLimitStatus,
    String? $__typename,
  });
  CopyWith$Fragment$Cart$validationStatus<TRes> get validationStatus;
  TRes promotions(
      Iterable<Fragment$Cart$promotions> Function(
              Iterable<
                  CopyWith$Fragment$Cart$promotions<Fragment$Cart$promotions>>)
          _fn);
  TRes lines(
      Iterable<Fragment$Cart$lines> Function(
              Iterable<CopyWith$Fragment$Cart$lines<Fragment$Cart$lines>>)
          _fn);
  TRes shippingLines(
      Iterable<Fragment$Cart$shippingLines> Function(
              Iterable<
                  CopyWith$Fragment$Cart$shippingLines<
                      Fragment$Cart$shippingLines>>)
          _fn);
  TRes discounts(
      Iterable<Fragment$Cart$discounts> Function(
              Iterable<
                  CopyWith$Fragment$Cart$discounts<Fragment$Cart$discounts>>)
          _fn);
  CopyWith$Fragment$Cart$customFields<TRes> get customFields;
  CopyWith$Fragment$Cart$quantityLimitStatus<TRes> get quantityLimitStatus;
}

class _CopyWithImpl$Fragment$Cart<TRes>
    implements CopyWith$Fragment$Cart<TRes> {
  _CopyWithImpl$Fragment$Cart(
    this._instance,
    this._then,
  );

  final Fragment$Cart _instance;

  final TRes Function(Fragment$Cart) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? state = _undefined,
    Object? active = _undefined,
    Object? validationStatus = _undefined,
    Object? couponCodes = _undefined,
    Object? promotions = _undefined,
    Object? lines = _undefined,
    Object? totalQuantity = _undefined,
    Object? subTotal = _undefined,
    Object? subTotalWithTax = _undefined,
    Object? total = _undefined,
    Object? totalWithTax = _undefined,
    Object? shipping = _undefined,
    Object? shippingWithTax = _undefined,
    Object? shippingLines = _undefined,
    Object? discounts = _undefined,
    Object? customFields = _undefined,
    Object? quantityLimitStatus = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        state: state == _undefined || state == null
            ? _instance.state
            : (state as String),
        active: active == _undefined || active == null
            ? _instance.active
            : (active as bool),
        validationStatus:
            validationStatus == _undefined || validationStatus == null
                ? _instance.validationStatus
                : (validationStatus as Fragment$Cart$validationStatus),
        couponCodes: couponCodes == _undefined || couponCodes == null
            ? _instance.couponCodes
            : (couponCodes as List<String>),
        promotions: promotions == _undefined || promotions == null
            ? _instance.promotions
            : (promotions as List<Fragment$Cart$promotions>),
        lines: lines == _undefined || lines == null
            ? _instance.lines
            : (lines as List<Fragment$Cart$lines>),
        totalQuantity: totalQuantity == _undefined || totalQuantity == null
            ? _instance.totalQuantity
            : (totalQuantity as int),
        subTotal: subTotal == _undefined || subTotal == null
            ? _instance.subTotal
            : (subTotal as double),
        subTotalWithTax:
            subTotalWithTax == _undefined || subTotalWithTax == null
                ? _instance.subTotalWithTax
                : (subTotalWithTax as double),
        total: total == _undefined || total == null
            ? _instance.total
            : (total as double),
        totalWithTax: totalWithTax == _undefined || totalWithTax == null
            ? _instance.totalWithTax
            : (totalWithTax as double),
        shipping: shipping == _undefined || shipping == null
            ? _instance.shipping
            : (shipping as double),
        shippingWithTax:
            shippingWithTax == _undefined || shippingWithTax == null
                ? _instance.shippingWithTax
                : (shippingWithTax as double),
        shippingLines: shippingLines == _undefined || shippingLines == null
            ? _instance.shippingLines
            : (shippingLines as List<Fragment$Cart$shippingLines>),
        discounts: discounts == _undefined || discounts == null
            ? _instance.discounts
            : (discounts as List<Fragment$Cart$discounts>),
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields as Fragment$Cart$customFields?),
        quantityLimitStatus:
            quantityLimitStatus == _undefined || quantityLimitStatus == null
                ? _instance.quantityLimitStatus
                : (quantityLimitStatus as Fragment$Cart$quantityLimitStatus),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Fragment$Cart$validationStatus<TRes> get validationStatus {
    final local$validationStatus = _instance.validationStatus;
    return CopyWith$Fragment$Cart$validationStatus(
        local$validationStatus, (e) => call(validationStatus: e));
  }

  TRes promotions(
          Iterable<Fragment$Cart$promotions> Function(
                  Iterable<
                      CopyWith$Fragment$Cart$promotions<
                          Fragment$Cart$promotions>>)
              _fn) =>
      call(
          promotions: _fn(
              _instance.promotions.map((e) => CopyWith$Fragment$Cart$promotions(
                    e,
                    (i) => i,
                  ))).toList());

  TRes lines(
          Iterable<Fragment$Cart$lines> Function(
                  Iterable<CopyWith$Fragment$Cart$lines<Fragment$Cart$lines>>)
              _fn) =>
      call(
          lines: _fn(_instance.lines.map((e) => CopyWith$Fragment$Cart$lines(
                e,
                (i) => i,
              ))).toList());

  TRes shippingLines(
          Iterable<Fragment$Cart$shippingLines> Function(
                  Iterable<
                      CopyWith$Fragment$Cart$shippingLines<
                          Fragment$Cart$shippingLines>>)
              _fn) =>
      call(
          shippingLines: _fn(_instance.shippingLines
              .map((e) => CopyWith$Fragment$Cart$shippingLines(
                    e,
                    (i) => i,
                  ))).toList());

  TRes discounts(
          Iterable<Fragment$Cart$discounts> Function(
                  Iterable<
                      CopyWith$Fragment$Cart$discounts<
                          Fragment$Cart$discounts>>)
              _fn) =>
      call(
          discounts: _fn(
              _instance.discounts.map((e) => CopyWith$Fragment$Cart$discounts(
                    e,
                    (i) => i,
                  ))).toList());

  CopyWith$Fragment$Cart$customFields<TRes> get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Fragment$Cart$customFields.stub(_then(_instance))
        : CopyWith$Fragment$Cart$customFields(
            local$customFields, (e) => call(customFields: e));
  }

  CopyWith$Fragment$Cart$quantityLimitStatus<TRes> get quantityLimitStatus {
    final local$quantityLimitStatus = _instance.quantityLimitStatus;
    return CopyWith$Fragment$Cart$quantityLimitStatus(
        local$quantityLimitStatus, (e) => call(quantityLimitStatus: e));
  }
}

class _CopyWithStubImpl$Fragment$Cart<TRes>
    implements CopyWith$Fragment$Cart<TRes> {
  _CopyWithStubImpl$Fragment$Cart(this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    String? state,
    bool? active,
    Fragment$Cart$validationStatus? validationStatus,
    List<String>? couponCodes,
    List<Fragment$Cart$promotions>? promotions,
    List<Fragment$Cart$lines>? lines,
    int? totalQuantity,
    double? subTotal,
    double? subTotalWithTax,
    double? total,
    double? totalWithTax,
    double? shipping,
    double? shippingWithTax,
    List<Fragment$Cart$shippingLines>? shippingLines,
    List<Fragment$Cart$discounts>? discounts,
    Fragment$Cart$customFields? customFields,
    Fragment$Cart$quantityLimitStatus? quantityLimitStatus,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Fragment$Cart$validationStatus<TRes> get validationStatus =>
      CopyWith$Fragment$Cart$validationStatus.stub(_res);

  promotions(_fn) => _res;

  lines(_fn) => _res;

  shippingLines(_fn) => _res;

  discounts(_fn) => _res;

  CopyWith$Fragment$Cart$customFields<TRes> get customFields =>
      CopyWith$Fragment$Cart$customFields.stub(_res);

  CopyWith$Fragment$Cart$quantityLimitStatus<TRes> get quantityLimitStatus =>
      CopyWith$Fragment$Cart$quantityLimitStatus.stub(_res);
}

const fragmentDefinitionCart = FragmentDefinitionNode(
  name: NameNode(value: 'Cart'),
  typeCondition: TypeConditionNode(
      on: NamedTypeNode(
    name: NameNode(value: 'Order'),
    isNonNull: false,
  )),
  directives: [],
  selectionSet: SelectionSetNode(selections: [
    FieldNode(
      name: NameNode(value: 'id'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'code'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'state'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'active'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'validationStatus'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
          name: NameNode(value: 'isValid'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'hasUnavailableItems'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'totalUnavailableItems'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'unavailableItems'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: SelectionSetNode(selections: [
            FieldNode(
              name: NameNode(value: 'orderLineId'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'productName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'variantName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'reason'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ]),
        ),
        FieldNode(
          name: NameNode(value: '__typename'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
      ]),
    ),
    FieldNode(
      name: NameNode(value: 'couponCodes'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'promotions'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
          name: NameNode(value: 'couponCode'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'name'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'enabled'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'actions'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: SelectionSetNode(selections: [
            FieldNode(
              name: NameNode(value: 'args'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                  name: NameNode(value: 'value'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ]),
            ),
            FieldNode(
              name: NameNode(value: 'code'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ]),
        ),
        FieldNode(
          name: NameNode(value: 'conditions'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: SelectionSetNode(selections: [
            FieldNode(
              name: NameNode(value: 'code'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'args'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'value'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ]),
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ]),
        ),
        FieldNode(
          name: NameNode(value: '__typename'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
      ]),
    ),
    FieldNode(
      name: NameNode(value: 'lines'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
          name: NameNode(value: 'id'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'unitPrice'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'isAvailable'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'unavailableReason'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'featuredAsset'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: SelectionSetNode(selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'Asset'),
              directives: [],
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ]),
        ),
        FieldNode(
          name: NameNode(value: 'unitPriceWithTax'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'quantity'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'linePriceWithTax'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'discountedLinePriceWithTax'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'productVariant'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: SelectionSetNode(selections: [
            FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'stockLevel'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'price'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'product'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                  name: NameNode(value: 'enabled'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ]),
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ]),
        ),
        FieldNode(
          name: NameNode(value: 'discounts'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: SelectionSetNode(selections: [
            FieldNode(
              name: NameNode(value: 'amount'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'amountWithTax'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'description'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'adjustmentSource'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'type'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ]),
        ),
        FieldNode(
          name: NameNode(value: '__typename'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
      ]),
    ),
    FieldNode(
      name: NameNode(value: 'totalQuantity'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'subTotal'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'subTotalWithTax'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'total'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'totalWithTax'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'shipping'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'shippingWithTax'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'shippingLines'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
          name: NameNode(value: 'priceWithTax'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'shippingMethod'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: SelectionSetNode(selections: [
            FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'code'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'description'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ]),
        ),
        FieldNode(
          name: NameNode(value: '__typename'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
      ]),
    ),
    FieldNode(
      name: NameNode(value: 'discounts'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
          name: NameNode(value: 'amount'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'amountWithTax'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'description'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'adjustmentSource'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'type'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: '__typename'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
      ]),
    ),
    FieldNode(
      name: NameNode(value: 'customFields'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
          name: NameNode(value: 'loyaltyPointsEarned'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'loyaltyPointsUsed'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'otherInstructions'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: '__typename'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
      ]),
    ),
    FieldNode(
      name: NameNode(value: 'quantityLimitStatus'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
          name: NameNode(value: 'isValid'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'hasViolations'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'totalViolations'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'violations'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: SelectionSetNode(selections: [
            FieldNode(
              name: NameNode(value: 'orderLineId'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'productName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'variantName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'currentQuantity'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'maxQuantity'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'reason'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ]),
        ),
        FieldNode(
          name: NameNode(value: '__typename'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
      ]),
    ),
    FieldNode(
      name: NameNode(value: '__typename'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
  ]),
);
const documentNodeFragmentCart = DocumentNode(definitions: [
  fragmentDefinitionCart,
  fragmentDefinitionAsset,
]);

extension ClientExtension$Fragment$Cart on graphql.GraphQLClient {
  void writeFragment$Cart({
    required Fragment$Cart data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) =>
      this.writeFragment(
        graphql.FragmentRequest(
          idFields: idFields,
          fragment: const graphql.Fragment(
            fragmentName: 'Cart',
            document: documentNodeFragmentCart,
          ),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Fragment$Cart? readFragment$Cart({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'Cart',
          document: documentNodeFragmentCart,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$Cart.fromJson(result);
  }
}

class Fragment$Cart$validationStatus {
  Fragment$Cart$validationStatus({
    required this.isValid,
    required this.hasUnavailableItems,
    required this.totalUnavailableItems,
    required this.unavailableItems,
    this.$__typename = 'CartValidationStatus',
  });

  factory Fragment$Cart$validationStatus.fromJson(Map<String, dynamic> json) {
    final l$isValid = json['isValid'];
    final l$hasUnavailableItems = json['hasUnavailableItems'];
    final l$totalUnavailableItems = json['totalUnavailableItems'];
    final l$unavailableItems = json['unavailableItems'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$validationStatus(
      isValid: (l$isValid as bool),
      hasUnavailableItems: (l$hasUnavailableItems as bool),
      totalUnavailableItems: (l$totalUnavailableItems as int),
      unavailableItems: (l$unavailableItems as List<dynamic>)
          .map((e) => Fragment$Cart$validationStatus$unavailableItems.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final bool isValid;

  final bool hasUnavailableItems;

  final int totalUnavailableItems;

  final List<Fragment$Cart$validationStatus$unavailableItems> unavailableItems;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$isValid = isValid;
    _resultData['isValid'] = l$isValid;
    final l$hasUnavailableItems = hasUnavailableItems;
    _resultData['hasUnavailableItems'] = l$hasUnavailableItems;
    final l$totalUnavailableItems = totalUnavailableItems;
    _resultData['totalUnavailableItems'] = l$totalUnavailableItems;
    final l$unavailableItems = unavailableItems;
    _resultData['unavailableItems'] =
        l$unavailableItems.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$isValid = isValid;
    final l$hasUnavailableItems = hasUnavailableItems;
    final l$totalUnavailableItems = totalUnavailableItems;
    final l$unavailableItems = unavailableItems;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$isValid,
      l$hasUnavailableItems,
      l$totalUnavailableItems,
      Object.hashAll(l$unavailableItems.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$validationStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$isValid = isValid;
    final lOther$isValid = other.isValid;
    if (l$isValid != lOther$isValid) {
      return false;
    }
    final l$hasUnavailableItems = hasUnavailableItems;
    final lOther$hasUnavailableItems = other.hasUnavailableItems;
    if (l$hasUnavailableItems != lOther$hasUnavailableItems) {
      return false;
    }
    final l$totalUnavailableItems = totalUnavailableItems;
    final lOther$totalUnavailableItems = other.totalUnavailableItems;
    if (l$totalUnavailableItems != lOther$totalUnavailableItems) {
      return false;
    }
    final l$unavailableItems = unavailableItems;
    final lOther$unavailableItems = other.unavailableItems;
    if (l$unavailableItems.length != lOther$unavailableItems.length) {
      return false;
    }
    for (int i = 0; i < l$unavailableItems.length; i++) {
      final l$unavailableItems$entry = l$unavailableItems[i];
      final lOther$unavailableItems$entry = lOther$unavailableItems[i];
      if (l$unavailableItems$entry != lOther$unavailableItems$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$validationStatus
    on Fragment$Cart$validationStatus {
  CopyWith$Fragment$Cart$validationStatus<Fragment$Cart$validationStatus>
      get copyWith => CopyWith$Fragment$Cart$validationStatus(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$validationStatus<TRes> {
  factory CopyWith$Fragment$Cart$validationStatus(
    Fragment$Cart$validationStatus instance,
    TRes Function(Fragment$Cart$validationStatus) then,
  ) = _CopyWithImpl$Fragment$Cart$validationStatus;

  factory CopyWith$Fragment$Cart$validationStatus.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$validationStatus;

  TRes call({
    bool? isValid,
    bool? hasUnavailableItems,
    int? totalUnavailableItems,
    List<Fragment$Cart$validationStatus$unavailableItems>? unavailableItems,
    String? $__typename,
  });
  TRes unavailableItems(
      Iterable<Fragment$Cart$validationStatus$unavailableItems> Function(
              Iterable<
                  CopyWith$Fragment$Cart$validationStatus$unavailableItems<
                      Fragment$Cart$validationStatus$unavailableItems>>)
          _fn);
}

class _CopyWithImpl$Fragment$Cart$validationStatus<TRes>
    implements CopyWith$Fragment$Cart$validationStatus<TRes> {
  _CopyWithImpl$Fragment$Cart$validationStatus(
    this._instance,
    this._then,
  );

  final Fragment$Cart$validationStatus _instance;

  final TRes Function(Fragment$Cart$validationStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? isValid = _undefined,
    Object? hasUnavailableItems = _undefined,
    Object? totalUnavailableItems = _undefined,
    Object? unavailableItems = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$validationStatus(
        isValid: isValid == _undefined || isValid == null
            ? _instance.isValid
            : (isValid as bool),
        hasUnavailableItems:
            hasUnavailableItems == _undefined || hasUnavailableItems == null
                ? _instance.hasUnavailableItems
                : (hasUnavailableItems as bool),
        totalUnavailableItems:
            totalUnavailableItems == _undefined || totalUnavailableItems == null
                ? _instance.totalUnavailableItems
                : (totalUnavailableItems as int),
        unavailableItems:
            unavailableItems == _undefined || unavailableItems == null
                ? _instance.unavailableItems
                : (unavailableItems
                    as List<Fragment$Cart$validationStatus$unavailableItems>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes unavailableItems(
          Iterable<Fragment$Cart$validationStatus$unavailableItems> Function(
                  Iterable<
                      CopyWith$Fragment$Cart$validationStatus$unavailableItems<
                          Fragment$Cart$validationStatus$unavailableItems>>)
              _fn) =>
      call(
          unavailableItems: _fn(_instance.unavailableItems.map(
              (e) => CopyWith$Fragment$Cart$validationStatus$unavailableItems(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Fragment$Cart$validationStatus<TRes>
    implements CopyWith$Fragment$Cart$validationStatus<TRes> {
  _CopyWithStubImpl$Fragment$Cart$validationStatus(this._res);

  TRes _res;

  call({
    bool? isValid,
    bool? hasUnavailableItems,
    int? totalUnavailableItems,
    List<Fragment$Cart$validationStatus$unavailableItems>? unavailableItems,
    String? $__typename,
  }) =>
      _res;

  unavailableItems(_fn) => _res;
}

class Fragment$Cart$validationStatus$unavailableItems {
  Fragment$Cart$validationStatus$unavailableItems({
    required this.orderLineId,
    required this.productName,
    required this.variantName,
    required this.reason,
    this.$__typename = 'UnavailableCartItem',
  });

  factory Fragment$Cart$validationStatus$unavailableItems.fromJson(
      Map<String, dynamic> json) {
    final l$orderLineId = json['orderLineId'];
    final l$productName = json['productName'];
    final l$variantName = json['variantName'];
    final l$reason = json['reason'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$validationStatus$unavailableItems(
      orderLineId: (l$orderLineId as String),
      productName: (l$productName as String),
      variantName: (l$variantName as String),
      reason: (l$reason as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String orderLineId;

  final String productName;

  final String variantName;

  final String reason;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$orderLineId = orderLineId;
    _resultData['orderLineId'] = l$orderLineId;
    final l$productName = productName;
    _resultData['productName'] = l$productName;
    final l$variantName = variantName;
    _resultData['variantName'] = l$variantName;
    final l$reason = reason;
    _resultData['reason'] = l$reason;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$orderLineId = orderLineId;
    final l$productName = productName;
    final l$variantName = variantName;
    final l$reason = reason;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$orderLineId,
      l$productName,
      l$variantName,
      l$reason,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$validationStatus$unavailableItems ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$orderLineId = orderLineId;
    final lOther$orderLineId = other.orderLineId;
    if (l$orderLineId != lOther$orderLineId) {
      return false;
    }
    final l$productName = productName;
    final lOther$productName = other.productName;
    if (l$productName != lOther$productName) {
      return false;
    }
    final l$variantName = variantName;
    final lOther$variantName = other.variantName;
    if (l$variantName != lOther$variantName) {
      return false;
    }
    final l$reason = reason;
    final lOther$reason = other.reason;
    if (l$reason != lOther$reason) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$validationStatus$unavailableItems
    on Fragment$Cart$validationStatus$unavailableItems {
  CopyWith$Fragment$Cart$validationStatus$unavailableItems<
          Fragment$Cart$validationStatus$unavailableItems>
      get copyWith => CopyWith$Fragment$Cart$validationStatus$unavailableItems(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$validationStatus$unavailableItems<TRes> {
  factory CopyWith$Fragment$Cart$validationStatus$unavailableItems(
    Fragment$Cart$validationStatus$unavailableItems instance,
    TRes Function(Fragment$Cart$validationStatus$unavailableItems) then,
  ) = _CopyWithImpl$Fragment$Cart$validationStatus$unavailableItems;

  factory CopyWith$Fragment$Cart$validationStatus$unavailableItems.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$Cart$validationStatus$unavailableItems;

  TRes call({
    String? orderLineId,
    String? productName,
    String? variantName,
    String? reason,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Cart$validationStatus$unavailableItems<TRes>
    implements CopyWith$Fragment$Cart$validationStatus$unavailableItems<TRes> {
  _CopyWithImpl$Fragment$Cart$validationStatus$unavailableItems(
    this._instance,
    this._then,
  );

  final Fragment$Cart$validationStatus$unavailableItems _instance;

  final TRes Function(Fragment$Cart$validationStatus$unavailableItems) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? orderLineId = _undefined,
    Object? productName = _undefined,
    Object? variantName = _undefined,
    Object? reason = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$validationStatus$unavailableItems(
        orderLineId: orderLineId == _undefined || orderLineId == null
            ? _instance.orderLineId
            : (orderLineId as String),
        productName: productName == _undefined || productName == null
            ? _instance.productName
            : (productName as String),
        variantName: variantName == _undefined || variantName == null
            ? _instance.variantName
            : (variantName as String),
        reason: reason == _undefined || reason == null
            ? _instance.reason
            : (reason as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Cart$validationStatus$unavailableItems<TRes>
    implements CopyWith$Fragment$Cart$validationStatus$unavailableItems<TRes> {
  _CopyWithStubImpl$Fragment$Cart$validationStatus$unavailableItems(this._res);

  TRes _res;

  call({
    String? orderLineId,
    String? productName,
    String? variantName,
    String? reason,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$Cart$promotions {
  Fragment$Cart$promotions({
    this.couponCode,
    required this.name,
    required this.enabled,
    required this.actions,
    required this.conditions,
    this.$__typename = 'Promotion',
  });

  factory Fragment$Cart$promotions.fromJson(Map<String, dynamic> json) {
    final l$couponCode = json['couponCode'];
    final l$name = json['name'];
    final l$enabled = json['enabled'];
    final l$actions = json['actions'];
    final l$conditions = json['conditions'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$promotions(
      couponCode: (l$couponCode as String?),
      name: (l$name as String),
      enabled: (l$enabled as bool),
      actions: (l$actions as List<dynamic>)
          .map((e) => Fragment$Cart$promotions$actions.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      conditions: (l$conditions as List<dynamic>)
          .map((e) => Fragment$Cart$promotions$conditions.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String? couponCode;

  final String name;

  final bool enabled;

  final List<Fragment$Cart$promotions$actions> actions;

  final List<Fragment$Cart$promotions$conditions> conditions;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$couponCode = couponCode;
    _resultData['couponCode'] = l$couponCode;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
    final l$actions = actions;
    _resultData['actions'] = l$actions.map((e) => e.toJson()).toList();
    final l$conditions = conditions;
    _resultData['conditions'] = l$conditions.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$couponCode = couponCode;
    final l$name = name;
    final l$enabled = enabled;
    final l$actions = actions;
    final l$conditions = conditions;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$couponCode,
      l$name,
      l$enabled,
      Object.hashAll(l$actions.map((v) => v)),
      Object.hashAll(l$conditions.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$promotions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$couponCode = couponCode;
    final lOther$couponCode = other.couponCode;
    if (l$couponCode != lOther$couponCode) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$enabled = enabled;
    final lOther$enabled = other.enabled;
    if (l$enabled != lOther$enabled) {
      return false;
    }
    final l$actions = actions;
    final lOther$actions = other.actions;
    if (l$actions.length != lOther$actions.length) {
      return false;
    }
    for (int i = 0; i < l$actions.length; i++) {
      final l$actions$entry = l$actions[i];
      final lOther$actions$entry = lOther$actions[i];
      if (l$actions$entry != lOther$actions$entry) {
        return false;
      }
    }
    final l$conditions = conditions;
    final lOther$conditions = other.conditions;
    if (l$conditions.length != lOther$conditions.length) {
      return false;
    }
    for (int i = 0; i < l$conditions.length; i++) {
      final l$conditions$entry = l$conditions[i];
      final lOther$conditions$entry = lOther$conditions[i];
      if (l$conditions$entry != lOther$conditions$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$promotions
    on Fragment$Cart$promotions {
  CopyWith$Fragment$Cart$promotions<Fragment$Cart$promotions> get copyWith =>
      CopyWith$Fragment$Cart$promotions(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$Cart$promotions<TRes> {
  factory CopyWith$Fragment$Cart$promotions(
    Fragment$Cart$promotions instance,
    TRes Function(Fragment$Cart$promotions) then,
  ) = _CopyWithImpl$Fragment$Cart$promotions;

  factory CopyWith$Fragment$Cart$promotions.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$promotions;

  TRes call({
    String? couponCode,
    String? name,
    bool? enabled,
    List<Fragment$Cart$promotions$actions>? actions,
    List<Fragment$Cart$promotions$conditions>? conditions,
    String? $__typename,
  });
  TRes actions(
      Iterable<Fragment$Cart$promotions$actions> Function(
              Iterable<
                  CopyWith$Fragment$Cart$promotions$actions<
                      Fragment$Cart$promotions$actions>>)
          _fn);
  TRes conditions(
      Iterable<Fragment$Cart$promotions$conditions> Function(
              Iterable<
                  CopyWith$Fragment$Cart$promotions$conditions<
                      Fragment$Cart$promotions$conditions>>)
          _fn);
}

class _CopyWithImpl$Fragment$Cart$promotions<TRes>
    implements CopyWith$Fragment$Cart$promotions<TRes> {
  _CopyWithImpl$Fragment$Cart$promotions(
    this._instance,
    this._then,
  );

  final Fragment$Cart$promotions _instance;

  final TRes Function(Fragment$Cart$promotions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? couponCode = _undefined,
    Object? name = _undefined,
    Object? enabled = _undefined,
    Object? actions = _undefined,
    Object? conditions = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$promotions(
        couponCode: couponCode == _undefined
            ? _instance.couponCode
            : (couponCode as String?),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        enabled: enabled == _undefined || enabled == null
            ? _instance.enabled
            : (enabled as bool),
        actions: actions == _undefined || actions == null
            ? _instance.actions
            : (actions as List<Fragment$Cart$promotions$actions>),
        conditions: conditions == _undefined || conditions == null
            ? _instance.conditions
            : (conditions as List<Fragment$Cart$promotions$conditions>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes actions(
          Iterable<Fragment$Cart$promotions$actions> Function(
                  Iterable<
                      CopyWith$Fragment$Cart$promotions$actions<
                          Fragment$Cart$promotions$actions>>)
              _fn) =>
      call(
          actions: _fn(_instance.actions
              .map((e) => CopyWith$Fragment$Cart$promotions$actions(
                    e,
                    (i) => i,
                  ))).toList());

  TRes conditions(
          Iterable<Fragment$Cart$promotions$conditions> Function(
                  Iterable<
                      CopyWith$Fragment$Cart$promotions$conditions<
                          Fragment$Cart$promotions$conditions>>)
              _fn) =>
      call(
          conditions: _fn(_instance.conditions
              .map((e) => CopyWith$Fragment$Cart$promotions$conditions(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Fragment$Cart$promotions<TRes>
    implements CopyWith$Fragment$Cart$promotions<TRes> {
  _CopyWithStubImpl$Fragment$Cart$promotions(this._res);

  TRes _res;

  call({
    String? couponCode,
    String? name,
    bool? enabled,
    List<Fragment$Cart$promotions$actions>? actions,
    List<Fragment$Cart$promotions$conditions>? conditions,
    String? $__typename,
  }) =>
      _res;

  actions(_fn) => _res;

  conditions(_fn) => _res;
}

class Fragment$Cart$promotions$actions {
  Fragment$Cart$promotions$actions({
    required this.args,
    required this.code,
    this.$__typename = 'ConfigurableOperation',
  });

  factory Fragment$Cart$promotions$actions.fromJson(Map<String, dynamic> json) {
    final l$args = json['args'];
    final l$code = json['code'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$promotions$actions(
      args: (l$args as List<dynamic>)
          .map((e) => Fragment$Cart$promotions$actions$args.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      code: (l$code as String),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$Cart$promotions$actions$args> args;

  final String code;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$args = args;
    _resultData['args'] = l$args.map((e) => e.toJson()).toList();
    final l$code = code;
    _resultData['code'] = l$code;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$args = args;
    final l$code = code;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$args.map((v) => v)),
      l$code,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$promotions$actions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$args = args;
    final lOther$args = other.args;
    if (l$args.length != lOther$args.length) {
      return false;
    }
    for (int i = 0; i < l$args.length; i++) {
      final l$args$entry = l$args[i];
      final lOther$args$entry = lOther$args[i];
      if (l$args$entry != lOther$args$entry) {
        return false;
      }
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$promotions$actions
    on Fragment$Cart$promotions$actions {
  CopyWith$Fragment$Cart$promotions$actions<Fragment$Cart$promotions$actions>
      get copyWith => CopyWith$Fragment$Cart$promotions$actions(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$promotions$actions<TRes> {
  factory CopyWith$Fragment$Cart$promotions$actions(
    Fragment$Cart$promotions$actions instance,
    TRes Function(Fragment$Cart$promotions$actions) then,
  ) = _CopyWithImpl$Fragment$Cart$promotions$actions;

  factory CopyWith$Fragment$Cart$promotions$actions.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$promotions$actions;

  TRes call({
    List<Fragment$Cart$promotions$actions$args>? args,
    String? code,
    String? $__typename,
  });
  TRes args(
      Iterable<Fragment$Cart$promotions$actions$args> Function(
              Iterable<
                  CopyWith$Fragment$Cart$promotions$actions$args<
                      Fragment$Cart$promotions$actions$args>>)
          _fn);
}

class _CopyWithImpl$Fragment$Cart$promotions$actions<TRes>
    implements CopyWith$Fragment$Cart$promotions$actions<TRes> {
  _CopyWithImpl$Fragment$Cart$promotions$actions(
    this._instance,
    this._then,
  );

  final Fragment$Cart$promotions$actions _instance;

  final TRes Function(Fragment$Cart$promotions$actions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? args = _undefined,
    Object? code = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$promotions$actions(
        args: args == _undefined || args == null
            ? _instance.args
            : (args as List<Fragment$Cart$promotions$actions$args>),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes args(
          Iterable<Fragment$Cart$promotions$actions$args> Function(
                  Iterable<
                      CopyWith$Fragment$Cart$promotions$actions$args<
                          Fragment$Cart$promotions$actions$args>>)
              _fn) =>
      call(
          args: _fn(_instance.args
              .map((e) => CopyWith$Fragment$Cart$promotions$actions$args(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Fragment$Cart$promotions$actions<TRes>
    implements CopyWith$Fragment$Cart$promotions$actions<TRes> {
  _CopyWithStubImpl$Fragment$Cart$promotions$actions(this._res);

  TRes _res;

  call({
    List<Fragment$Cart$promotions$actions$args>? args,
    String? code,
    String? $__typename,
  }) =>
      _res;

  args(_fn) => _res;
}

class Fragment$Cart$promotions$actions$args {
  Fragment$Cart$promotions$actions$args({
    required this.value,
    required this.name,
    this.$__typename = 'ConfigArg',
  });

  factory Fragment$Cart$promotions$actions$args.fromJson(
      Map<String, dynamic> json) {
    final l$value = json['value'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$promotions$actions$args(
      value: (l$value as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String value;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$value = value;
    _resultData['value'] = l$value;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$value = value;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$value,
      l$name,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$promotions$actions$args ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$promotions$actions$args
    on Fragment$Cart$promotions$actions$args {
  CopyWith$Fragment$Cart$promotions$actions$args<
          Fragment$Cart$promotions$actions$args>
      get copyWith => CopyWith$Fragment$Cart$promotions$actions$args(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$promotions$actions$args<TRes> {
  factory CopyWith$Fragment$Cart$promotions$actions$args(
    Fragment$Cart$promotions$actions$args instance,
    TRes Function(Fragment$Cart$promotions$actions$args) then,
  ) = _CopyWithImpl$Fragment$Cart$promotions$actions$args;

  factory CopyWith$Fragment$Cart$promotions$actions$args.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$promotions$actions$args;

  TRes call({
    String? value,
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Cart$promotions$actions$args<TRes>
    implements CopyWith$Fragment$Cart$promotions$actions$args<TRes> {
  _CopyWithImpl$Fragment$Cart$promotions$actions$args(
    this._instance,
    this._then,
  );

  final Fragment$Cart$promotions$actions$args _instance;

  final TRes Function(Fragment$Cart$promotions$actions$args) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? value = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$promotions$actions$args(
        value: value == _undefined || value == null
            ? _instance.value
            : (value as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Cart$promotions$actions$args<TRes>
    implements CopyWith$Fragment$Cart$promotions$actions$args<TRes> {
  _CopyWithStubImpl$Fragment$Cart$promotions$actions$args(this._res);

  TRes _res;

  call({
    String? value,
    String? name,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$Cart$promotions$conditions {
  Fragment$Cart$promotions$conditions({
    required this.code,
    required this.args,
    this.$__typename = 'ConfigurableOperation',
  });

  factory Fragment$Cart$promotions$conditions.fromJson(
      Map<String, dynamic> json) {
    final l$code = json['code'];
    final l$args = json['args'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$promotions$conditions(
      code: (l$code as String),
      args: (l$args as List<dynamic>)
          .map((e) => Fragment$Cart$promotions$conditions$args.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String code;

  final List<Fragment$Cart$promotions$conditions$args> args;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$args = args;
    _resultData['args'] = l$args.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$args = args;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$code,
      Object.hashAll(l$args.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$promotions$conditions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$args = args;
    final lOther$args = other.args;
    if (l$args.length != lOther$args.length) {
      return false;
    }
    for (int i = 0; i < l$args.length; i++) {
      final l$args$entry = l$args[i];
      final lOther$args$entry = lOther$args[i];
      if (l$args$entry != lOther$args$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$promotions$conditions
    on Fragment$Cart$promotions$conditions {
  CopyWith$Fragment$Cart$promotions$conditions<
          Fragment$Cart$promotions$conditions>
      get copyWith => CopyWith$Fragment$Cart$promotions$conditions(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$promotions$conditions<TRes> {
  factory CopyWith$Fragment$Cart$promotions$conditions(
    Fragment$Cart$promotions$conditions instance,
    TRes Function(Fragment$Cart$promotions$conditions) then,
  ) = _CopyWithImpl$Fragment$Cart$promotions$conditions;

  factory CopyWith$Fragment$Cart$promotions$conditions.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$promotions$conditions;

  TRes call({
    String? code,
    List<Fragment$Cart$promotions$conditions$args>? args,
    String? $__typename,
  });
  TRes args(
      Iterable<Fragment$Cart$promotions$conditions$args> Function(
              Iterable<
                  CopyWith$Fragment$Cart$promotions$conditions$args<
                      Fragment$Cart$promotions$conditions$args>>)
          _fn);
}

class _CopyWithImpl$Fragment$Cart$promotions$conditions<TRes>
    implements CopyWith$Fragment$Cart$promotions$conditions<TRes> {
  _CopyWithImpl$Fragment$Cart$promotions$conditions(
    this._instance,
    this._then,
  );

  final Fragment$Cart$promotions$conditions _instance;

  final TRes Function(Fragment$Cart$promotions$conditions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? args = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$promotions$conditions(
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        args: args == _undefined || args == null
            ? _instance.args
            : (args as List<Fragment$Cart$promotions$conditions$args>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes args(
          Iterable<Fragment$Cart$promotions$conditions$args> Function(
                  Iterable<
                      CopyWith$Fragment$Cart$promotions$conditions$args<
                          Fragment$Cart$promotions$conditions$args>>)
              _fn) =>
      call(
          args: _fn(_instance.args
              .map((e) => CopyWith$Fragment$Cart$promotions$conditions$args(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Fragment$Cart$promotions$conditions<TRes>
    implements CopyWith$Fragment$Cart$promotions$conditions<TRes> {
  _CopyWithStubImpl$Fragment$Cart$promotions$conditions(this._res);

  TRes _res;

  call({
    String? code,
    List<Fragment$Cart$promotions$conditions$args>? args,
    String? $__typename,
  }) =>
      _res;

  args(_fn) => _res;
}

class Fragment$Cart$promotions$conditions$args {
  Fragment$Cart$promotions$conditions$args({
    required this.name,
    required this.value,
    this.$__typename = 'ConfigArg',
  });

  factory Fragment$Cart$promotions$conditions$args.fromJson(
      Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$promotions$conditions$args(
      name: (l$name as String),
      value: (l$value as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$value = value;
    _resultData['value'] = l$value;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$value,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$promotions$conditions$args ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$promotions$conditions$args
    on Fragment$Cart$promotions$conditions$args {
  CopyWith$Fragment$Cart$promotions$conditions$args<
          Fragment$Cart$promotions$conditions$args>
      get copyWith => CopyWith$Fragment$Cart$promotions$conditions$args(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$promotions$conditions$args<TRes> {
  factory CopyWith$Fragment$Cart$promotions$conditions$args(
    Fragment$Cart$promotions$conditions$args instance,
    TRes Function(Fragment$Cart$promotions$conditions$args) then,
  ) = _CopyWithImpl$Fragment$Cart$promotions$conditions$args;

  factory CopyWith$Fragment$Cart$promotions$conditions$args.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$promotions$conditions$args;

  TRes call({
    String? name,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Cart$promotions$conditions$args<TRes>
    implements CopyWith$Fragment$Cart$promotions$conditions$args<TRes> {
  _CopyWithImpl$Fragment$Cart$promotions$conditions$args(
    this._instance,
    this._then,
  );

  final Fragment$Cart$promotions$conditions$args _instance;

  final TRes Function(Fragment$Cart$promotions$conditions$args) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$promotions$conditions$args(
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        value: value == _undefined || value == null
            ? _instance.value
            : (value as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Cart$promotions$conditions$args<TRes>
    implements CopyWith$Fragment$Cart$promotions$conditions$args<TRes> {
  _CopyWithStubImpl$Fragment$Cart$promotions$conditions$args(this._res);

  TRes _res;

  call({
    String? name,
    String? value,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$Cart$lines {
  Fragment$Cart$lines({
    required this.id,
    required this.unitPrice,
    required this.isAvailable,
    this.unavailableReason,
    this.featuredAsset,
    required this.unitPriceWithTax,
    required this.quantity,
    required this.linePriceWithTax,
    required this.discountedLinePriceWithTax,
    required this.productVariant,
    required this.discounts,
    this.$__typename = 'OrderLine',
  });

  factory Fragment$Cart$lines.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$unitPrice = json['unitPrice'];
    final l$isAvailable = json['isAvailable'];
    final l$unavailableReason = json['unavailableReason'];
    final l$featuredAsset = json['featuredAsset'];
    final l$unitPriceWithTax = json['unitPriceWithTax'];
    final l$quantity = json['quantity'];
    final l$linePriceWithTax = json['linePriceWithTax'];
    final l$discountedLinePriceWithTax = json['discountedLinePriceWithTax'];
    final l$productVariant = json['productVariant'];
    final l$discounts = json['discounts'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$lines(
      id: (l$id as String),
      unitPrice: (l$unitPrice as num).toDouble(),
      isAvailable: (l$isAvailable as bool),
      unavailableReason: (l$unavailableReason as String?),
      featuredAsset: l$featuredAsset == null
          ? null
          : Fragment$Asset.fromJson((l$featuredAsset as Map<String, dynamic>)),
      unitPriceWithTax: (l$unitPriceWithTax as num).toDouble(),
      quantity: (l$quantity as int),
      linePriceWithTax: (l$linePriceWithTax as num).toDouble(),
      discountedLinePriceWithTax:
          (l$discountedLinePriceWithTax as num).toDouble(),
      productVariant: Fragment$Cart$lines$productVariant.fromJson(
          (l$productVariant as Map<String, dynamic>)),
      discounts: (l$discounts as List<dynamic>)
          .map((e) => Fragment$Cart$lines$discounts.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final double unitPrice;

  final bool isAvailable;

  final String? unavailableReason;

  final Fragment$Asset? featuredAsset;

  final double unitPriceWithTax;

  final int quantity;

  final double linePriceWithTax;

  final double discountedLinePriceWithTax;

  final Fragment$Cart$lines$productVariant productVariant;

  final List<Fragment$Cart$lines$discounts> discounts;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$unitPrice = unitPrice;
    _resultData['unitPrice'] = l$unitPrice;
    final l$isAvailable = isAvailable;
    _resultData['isAvailable'] = l$isAvailable;
    final l$unavailableReason = unavailableReason;
    _resultData['unavailableReason'] = l$unavailableReason;
    final l$featuredAsset = featuredAsset;
    _resultData['featuredAsset'] = l$featuredAsset?.toJson();
    final l$unitPriceWithTax = unitPriceWithTax;
    _resultData['unitPriceWithTax'] = l$unitPriceWithTax;
    final l$quantity = quantity;
    _resultData['quantity'] = l$quantity;
    final l$linePriceWithTax = linePriceWithTax;
    _resultData['linePriceWithTax'] = l$linePriceWithTax;
    final l$discountedLinePriceWithTax = discountedLinePriceWithTax;
    _resultData['discountedLinePriceWithTax'] = l$discountedLinePriceWithTax;
    final l$productVariant = productVariant;
    _resultData['productVariant'] = l$productVariant.toJson();
    final l$discounts = discounts;
    _resultData['discounts'] = l$discounts.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$unitPrice = unitPrice;
    final l$isAvailable = isAvailable;
    final l$unavailableReason = unavailableReason;
    final l$featuredAsset = featuredAsset;
    final l$unitPriceWithTax = unitPriceWithTax;
    final l$quantity = quantity;
    final l$linePriceWithTax = linePriceWithTax;
    final l$discountedLinePriceWithTax = discountedLinePriceWithTax;
    final l$productVariant = productVariant;
    final l$discounts = discounts;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$unitPrice,
      l$isAvailable,
      l$unavailableReason,
      l$featuredAsset,
      l$unitPriceWithTax,
      l$quantity,
      l$linePriceWithTax,
      l$discountedLinePriceWithTax,
      l$productVariant,
      Object.hashAll(l$discounts.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$lines || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$unitPrice = unitPrice;
    final lOther$unitPrice = other.unitPrice;
    if (l$unitPrice != lOther$unitPrice) {
      return false;
    }
    final l$isAvailable = isAvailable;
    final lOther$isAvailable = other.isAvailable;
    if (l$isAvailable != lOther$isAvailable) {
      return false;
    }
    final l$unavailableReason = unavailableReason;
    final lOther$unavailableReason = other.unavailableReason;
    if (l$unavailableReason != lOther$unavailableReason) {
      return false;
    }
    final l$featuredAsset = featuredAsset;
    final lOther$featuredAsset = other.featuredAsset;
    if (l$featuredAsset != lOther$featuredAsset) {
      return false;
    }
    final l$unitPriceWithTax = unitPriceWithTax;
    final lOther$unitPriceWithTax = other.unitPriceWithTax;
    if (l$unitPriceWithTax != lOther$unitPriceWithTax) {
      return false;
    }
    final l$quantity = quantity;
    final lOther$quantity = other.quantity;
    if (l$quantity != lOther$quantity) {
      return false;
    }
    final l$linePriceWithTax = linePriceWithTax;
    final lOther$linePriceWithTax = other.linePriceWithTax;
    if (l$linePriceWithTax != lOther$linePriceWithTax) {
      return false;
    }
    final l$discountedLinePriceWithTax = discountedLinePriceWithTax;
    final lOther$discountedLinePriceWithTax = other.discountedLinePriceWithTax;
    if (l$discountedLinePriceWithTax != lOther$discountedLinePriceWithTax) {
      return false;
    }
    final l$productVariant = productVariant;
    final lOther$productVariant = other.productVariant;
    if (l$productVariant != lOther$productVariant) {
      return false;
    }
    final l$discounts = discounts;
    final lOther$discounts = other.discounts;
    if (l$discounts.length != lOther$discounts.length) {
      return false;
    }
    for (int i = 0; i < l$discounts.length; i++) {
      final l$discounts$entry = l$discounts[i];
      final lOther$discounts$entry = lOther$discounts[i];
      if (l$discounts$entry != lOther$discounts$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$lines on Fragment$Cart$lines {
  CopyWith$Fragment$Cart$lines<Fragment$Cart$lines> get copyWith =>
      CopyWith$Fragment$Cart$lines(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$Cart$lines<TRes> {
  factory CopyWith$Fragment$Cart$lines(
    Fragment$Cart$lines instance,
    TRes Function(Fragment$Cart$lines) then,
  ) = _CopyWithImpl$Fragment$Cart$lines;

  factory CopyWith$Fragment$Cart$lines.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$lines;

  TRes call({
    String? id,
    double? unitPrice,
    bool? isAvailable,
    String? unavailableReason,
    Fragment$Asset? featuredAsset,
    double? unitPriceWithTax,
    int? quantity,
    double? linePriceWithTax,
    double? discountedLinePriceWithTax,
    Fragment$Cart$lines$productVariant? productVariant,
    List<Fragment$Cart$lines$discounts>? discounts,
    String? $__typename,
  });
  CopyWith$Fragment$Asset<TRes> get featuredAsset;
  CopyWith$Fragment$Cart$lines$productVariant<TRes> get productVariant;
  TRes discounts(
      Iterable<Fragment$Cart$lines$discounts> Function(
              Iterable<
                  CopyWith$Fragment$Cart$lines$discounts<
                      Fragment$Cart$lines$discounts>>)
          _fn);
}

class _CopyWithImpl$Fragment$Cart$lines<TRes>
    implements CopyWith$Fragment$Cart$lines<TRes> {
  _CopyWithImpl$Fragment$Cart$lines(
    this._instance,
    this._then,
  );

  final Fragment$Cart$lines _instance;

  final TRes Function(Fragment$Cart$lines) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? unitPrice = _undefined,
    Object? isAvailable = _undefined,
    Object? unavailableReason = _undefined,
    Object? featuredAsset = _undefined,
    Object? unitPriceWithTax = _undefined,
    Object? quantity = _undefined,
    Object? linePriceWithTax = _undefined,
    Object? discountedLinePriceWithTax = _undefined,
    Object? productVariant = _undefined,
    Object? discounts = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$lines(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        unitPrice: unitPrice == _undefined || unitPrice == null
            ? _instance.unitPrice
            : (unitPrice as double),
        isAvailable: isAvailable == _undefined || isAvailable == null
            ? _instance.isAvailable
            : (isAvailable as bool),
        unavailableReason: unavailableReason == _undefined
            ? _instance.unavailableReason
            : (unavailableReason as String?),
        featuredAsset: featuredAsset == _undefined
            ? _instance.featuredAsset
            : (featuredAsset as Fragment$Asset?),
        unitPriceWithTax:
            unitPriceWithTax == _undefined || unitPriceWithTax == null
                ? _instance.unitPriceWithTax
                : (unitPriceWithTax as double),
        quantity: quantity == _undefined || quantity == null
            ? _instance.quantity
            : (quantity as int),
        linePriceWithTax:
            linePriceWithTax == _undefined || linePriceWithTax == null
                ? _instance.linePriceWithTax
                : (linePriceWithTax as double),
        discountedLinePriceWithTax: discountedLinePriceWithTax == _undefined ||
                discountedLinePriceWithTax == null
            ? _instance.discountedLinePriceWithTax
            : (discountedLinePriceWithTax as double),
        productVariant: productVariant == _undefined || productVariant == null
            ? _instance.productVariant
            : (productVariant as Fragment$Cart$lines$productVariant),
        discounts: discounts == _undefined || discounts == null
            ? _instance.discounts
            : (discounts as List<Fragment$Cart$lines$discounts>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Fragment$Asset<TRes> get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Fragment$Asset.stub(_then(_instance))
        : CopyWith$Fragment$Asset(
            local$featuredAsset, (e) => call(featuredAsset: e));
  }

  CopyWith$Fragment$Cart$lines$productVariant<TRes> get productVariant {
    final local$productVariant = _instance.productVariant;
    return CopyWith$Fragment$Cart$lines$productVariant(
        local$productVariant, (e) => call(productVariant: e));
  }

  TRes discounts(
          Iterable<Fragment$Cart$lines$discounts> Function(
                  Iterable<
                      CopyWith$Fragment$Cart$lines$discounts<
                          Fragment$Cart$lines$discounts>>)
              _fn) =>
      call(
          discounts: _fn(_instance.discounts
              .map((e) => CopyWith$Fragment$Cart$lines$discounts(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Fragment$Cart$lines<TRes>
    implements CopyWith$Fragment$Cart$lines<TRes> {
  _CopyWithStubImpl$Fragment$Cart$lines(this._res);

  TRes _res;

  call({
    String? id,
    double? unitPrice,
    bool? isAvailable,
    String? unavailableReason,
    Fragment$Asset? featuredAsset,
    double? unitPriceWithTax,
    int? quantity,
    double? linePriceWithTax,
    double? discountedLinePriceWithTax,
    Fragment$Cart$lines$productVariant? productVariant,
    List<Fragment$Cart$lines$discounts>? discounts,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Fragment$Asset<TRes> get featuredAsset =>
      CopyWith$Fragment$Asset.stub(_res);

  CopyWith$Fragment$Cart$lines$productVariant<TRes> get productVariant =>
      CopyWith$Fragment$Cart$lines$productVariant.stub(_res);

  discounts(_fn) => _res;
}

class Fragment$Cart$lines$productVariant {
  Fragment$Cart$lines$productVariant({
    required this.id,
    required this.name,
    required this.stockLevel,
    required this.price,
    required this.product,
    this.$__typename = 'ProductVariant',
  });

  factory Fragment$Cart$lines$productVariant.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$stockLevel = json['stockLevel'];
    final l$price = json['price'];
    final l$product = json['product'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$lines$productVariant(
      id: (l$id as String),
      name: (l$name as String),
      stockLevel: (l$stockLevel as String),
      price: (l$price as num).toDouble(),
      product: Fragment$Cart$lines$productVariant$product.fromJson(
          (l$product as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String stockLevel;

  final double price;

  final Fragment$Cart$lines$productVariant$product product;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$stockLevel = stockLevel;
    _resultData['stockLevel'] = l$stockLevel;
    final l$price = price;
    _resultData['price'] = l$price;
    final l$product = product;
    _resultData['product'] = l$product.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$stockLevel = stockLevel;
    final l$price = price;
    final l$product = product;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$stockLevel,
      l$price,
      l$product,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$lines$productVariant ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$stockLevel = stockLevel;
    final lOther$stockLevel = other.stockLevel;
    if (l$stockLevel != lOther$stockLevel) {
      return false;
    }
    final l$price = price;
    final lOther$price = other.price;
    if (l$price != lOther$price) {
      return false;
    }
    final l$product = product;
    final lOther$product = other.product;
    if (l$product != lOther$product) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$lines$productVariant
    on Fragment$Cart$lines$productVariant {
  CopyWith$Fragment$Cart$lines$productVariant<
          Fragment$Cart$lines$productVariant>
      get copyWith => CopyWith$Fragment$Cart$lines$productVariant(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$lines$productVariant<TRes> {
  factory CopyWith$Fragment$Cart$lines$productVariant(
    Fragment$Cart$lines$productVariant instance,
    TRes Function(Fragment$Cart$lines$productVariant) then,
  ) = _CopyWithImpl$Fragment$Cart$lines$productVariant;

  factory CopyWith$Fragment$Cart$lines$productVariant.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$lines$productVariant;

  TRes call({
    String? id,
    String? name,
    String? stockLevel,
    double? price,
    Fragment$Cart$lines$productVariant$product? product,
    String? $__typename,
  });
  CopyWith$Fragment$Cart$lines$productVariant$product<TRes> get product;
}

class _CopyWithImpl$Fragment$Cart$lines$productVariant<TRes>
    implements CopyWith$Fragment$Cart$lines$productVariant<TRes> {
  _CopyWithImpl$Fragment$Cart$lines$productVariant(
    this._instance,
    this._then,
  );

  final Fragment$Cart$lines$productVariant _instance;

  final TRes Function(Fragment$Cart$lines$productVariant) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? stockLevel = _undefined,
    Object? price = _undefined,
    Object? product = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$lines$productVariant(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        stockLevel: stockLevel == _undefined || stockLevel == null
            ? _instance.stockLevel
            : (stockLevel as String),
        price: price == _undefined || price == null
            ? _instance.price
            : (price as double),
        product: product == _undefined || product == null
            ? _instance.product
            : (product as Fragment$Cart$lines$productVariant$product),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Fragment$Cart$lines$productVariant$product<TRes> get product {
    final local$product = _instance.product;
    return CopyWith$Fragment$Cart$lines$productVariant$product(
        local$product, (e) => call(product: e));
  }
}

class _CopyWithStubImpl$Fragment$Cart$lines$productVariant<TRes>
    implements CopyWith$Fragment$Cart$lines$productVariant<TRes> {
  _CopyWithStubImpl$Fragment$Cart$lines$productVariant(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? stockLevel,
    double? price,
    Fragment$Cart$lines$productVariant$product? product,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Fragment$Cart$lines$productVariant$product<TRes> get product =>
      CopyWith$Fragment$Cart$lines$productVariant$product.stub(_res);
}

class Fragment$Cart$lines$productVariant$product {
  Fragment$Cart$lines$productVariant$product({
    required this.enabled,
    this.$__typename = 'Product',
  });

  factory Fragment$Cart$lines$productVariant$product.fromJson(
      Map<String, dynamic> json) {
    final l$enabled = json['enabled'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$lines$productVariant$product(
      enabled: (l$enabled as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool enabled;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$enabled = enabled;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$enabled,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$lines$productVariant$product ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$enabled = enabled;
    final lOther$enabled = other.enabled;
    if (l$enabled != lOther$enabled) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$lines$productVariant$product
    on Fragment$Cart$lines$productVariant$product {
  CopyWith$Fragment$Cart$lines$productVariant$product<
          Fragment$Cart$lines$productVariant$product>
      get copyWith => CopyWith$Fragment$Cart$lines$productVariant$product(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$lines$productVariant$product<TRes> {
  factory CopyWith$Fragment$Cart$lines$productVariant$product(
    Fragment$Cart$lines$productVariant$product instance,
    TRes Function(Fragment$Cart$lines$productVariant$product) then,
  ) = _CopyWithImpl$Fragment$Cart$lines$productVariant$product;

  factory CopyWith$Fragment$Cart$lines$productVariant$product.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$lines$productVariant$product;

  TRes call({
    bool? enabled,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Cart$lines$productVariant$product<TRes>
    implements CopyWith$Fragment$Cart$lines$productVariant$product<TRes> {
  _CopyWithImpl$Fragment$Cart$lines$productVariant$product(
    this._instance,
    this._then,
  );

  final Fragment$Cart$lines$productVariant$product _instance;

  final TRes Function(Fragment$Cart$lines$productVariant$product) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? enabled = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$lines$productVariant$product(
        enabled: enabled == _undefined || enabled == null
            ? _instance.enabled
            : (enabled as bool),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Cart$lines$productVariant$product<TRes>
    implements CopyWith$Fragment$Cart$lines$productVariant$product<TRes> {
  _CopyWithStubImpl$Fragment$Cart$lines$productVariant$product(this._res);

  TRes _res;

  call({
    bool? enabled,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$Cart$lines$discounts {
  Fragment$Cart$lines$discounts({
    required this.amount,
    required this.amountWithTax,
    required this.description,
    required this.adjustmentSource,
    required this.type,
    this.$__typename = 'Discount',
  });

  factory Fragment$Cart$lines$discounts.fromJson(Map<String, dynamic> json) {
    final l$amount = json['amount'];
    final l$amountWithTax = json['amountWithTax'];
    final l$description = json['description'];
    final l$adjustmentSource = json['adjustmentSource'];
    final l$type = json['type'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$lines$discounts(
      amount: (l$amount as num).toDouble(),
      amountWithTax: (l$amountWithTax as num).toDouble(),
      description: (l$description as String),
      adjustmentSource: (l$adjustmentSource as String),
      type: fromJson$Enum$AdjustmentType((l$type as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final double amount;

  final double amountWithTax;

  final String description;

  final String adjustmentSource;

  final Enum$AdjustmentType type;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$amount = amount;
    _resultData['amount'] = l$amount;
    final l$amountWithTax = amountWithTax;
    _resultData['amountWithTax'] = l$amountWithTax;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$adjustmentSource = adjustmentSource;
    _resultData['adjustmentSource'] = l$adjustmentSource;
    final l$type = type;
    _resultData['type'] = toJson$Enum$AdjustmentType(l$type);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$amount = amount;
    final l$amountWithTax = amountWithTax;
    final l$description = description;
    final l$adjustmentSource = adjustmentSource;
    final l$type = type;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$amount,
      l$amountWithTax,
      l$description,
      l$adjustmentSource,
      l$type,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$lines$discounts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$amount = amount;
    final lOther$amount = other.amount;
    if (l$amount != lOther$amount) {
      return false;
    }
    final l$amountWithTax = amountWithTax;
    final lOther$amountWithTax = other.amountWithTax;
    if (l$amountWithTax != lOther$amountWithTax) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$adjustmentSource = adjustmentSource;
    final lOther$adjustmentSource = other.adjustmentSource;
    if (l$adjustmentSource != lOther$adjustmentSource) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$lines$discounts
    on Fragment$Cart$lines$discounts {
  CopyWith$Fragment$Cart$lines$discounts<Fragment$Cart$lines$discounts>
      get copyWith => CopyWith$Fragment$Cart$lines$discounts(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$lines$discounts<TRes> {
  factory CopyWith$Fragment$Cart$lines$discounts(
    Fragment$Cart$lines$discounts instance,
    TRes Function(Fragment$Cart$lines$discounts) then,
  ) = _CopyWithImpl$Fragment$Cart$lines$discounts;

  factory CopyWith$Fragment$Cart$lines$discounts.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$lines$discounts;

  TRes call({
    double? amount,
    double? amountWithTax,
    String? description,
    String? adjustmentSource,
    Enum$AdjustmentType? type,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Cart$lines$discounts<TRes>
    implements CopyWith$Fragment$Cart$lines$discounts<TRes> {
  _CopyWithImpl$Fragment$Cart$lines$discounts(
    this._instance,
    this._then,
  );

  final Fragment$Cart$lines$discounts _instance;

  final TRes Function(Fragment$Cart$lines$discounts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? amount = _undefined,
    Object? amountWithTax = _undefined,
    Object? description = _undefined,
    Object? adjustmentSource = _undefined,
    Object? type = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$lines$discounts(
        amount: amount == _undefined || amount == null
            ? _instance.amount
            : (amount as double),
        amountWithTax: amountWithTax == _undefined || amountWithTax == null
            ? _instance.amountWithTax
            : (amountWithTax as double),
        description: description == _undefined || description == null
            ? _instance.description
            : (description as String),
        adjustmentSource:
            adjustmentSource == _undefined || adjustmentSource == null
                ? _instance.adjustmentSource
                : (adjustmentSource as String),
        type: type == _undefined || type == null
            ? _instance.type
            : (type as Enum$AdjustmentType),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Cart$lines$discounts<TRes>
    implements CopyWith$Fragment$Cart$lines$discounts<TRes> {
  _CopyWithStubImpl$Fragment$Cart$lines$discounts(this._res);

  TRes _res;

  call({
    double? amount,
    double? amountWithTax,
    String? description,
    String? adjustmentSource,
    Enum$AdjustmentType? type,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$Cart$shippingLines {
  Fragment$Cart$shippingLines({
    required this.priceWithTax,
    required this.shippingMethod,
    this.$__typename = 'ShippingLine',
  });

  factory Fragment$Cart$shippingLines.fromJson(Map<String, dynamic> json) {
    final l$priceWithTax = json['priceWithTax'];
    final l$shippingMethod = json['shippingMethod'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$shippingLines(
      priceWithTax: (l$priceWithTax as num).toDouble(),
      shippingMethod: Fragment$Cart$shippingLines$shippingMethod.fromJson(
          (l$shippingMethod as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final double priceWithTax;

  final Fragment$Cart$shippingLines$shippingMethod shippingMethod;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$priceWithTax = priceWithTax;
    _resultData['priceWithTax'] = l$priceWithTax;
    final l$shippingMethod = shippingMethod;
    _resultData['shippingMethod'] = l$shippingMethod.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$priceWithTax = priceWithTax;
    final l$shippingMethod = shippingMethod;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$priceWithTax,
      l$shippingMethod,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$shippingLines ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$priceWithTax = priceWithTax;
    final lOther$priceWithTax = other.priceWithTax;
    if (l$priceWithTax != lOther$priceWithTax) {
      return false;
    }
    final l$shippingMethod = shippingMethod;
    final lOther$shippingMethod = other.shippingMethod;
    if (l$shippingMethod != lOther$shippingMethod) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$shippingLines
    on Fragment$Cart$shippingLines {
  CopyWith$Fragment$Cart$shippingLines<Fragment$Cart$shippingLines>
      get copyWith => CopyWith$Fragment$Cart$shippingLines(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$shippingLines<TRes> {
  factory CopyWith$Fragment$Cart$shippingLines(
    Fragment$Cart$shippingLines instance,
    TRes Function(Fragment$Cart$shippingLines) then,
  ) = _CopyWithImpl$Fragment$Cart$shippingLines;

  factory CopyWith$Fragment$Cart$shippingLines.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$shippingLines;

  TRes call({
    double? priceWithTax,
    Fragment$Cart$shippingLines$shippingMethod? shippingMethod,
    String? $__typename,
  });
  CopyWith$Fragment$Cart$shippingLines$shippingMethod<TRes> get shippingMethod;
}

class _CopyWithImpl$Fragment$Cart$shippingLines<TRes>
    implements CopyWith$Fragment$Cart$shippingLines<TRes> {
  _CopyWithImpl$Fragment$Cart$shippingLines(
    this._instance,
    this._then,
  );

  final Fragment$Cart$shippingLines _instance;

  final TRes Function(Fragment$Cart$shippingLines) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? priceWithTax = _undefined,
    Object? shippingMethod = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$shippingLines(
        priceWithTax: priceWithTax == _undefined || priceWithTax == null
            ? _instance.priceWithTax
            : (priceWithTax as double),
        shippingMethod: shippingMethod == _undefined || shippingMethod == null
            ? _instance.shippingMethod
            : (shippingMethod as Fragment$Cart$shippingLines$shippingMethod),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Fragment$Cart$shippingLines$shippingMethod<TRes> get shippingMethod {
    final local$shippingMethod = _instance.shippingMethod;
    return CopyWith$Fragment$Cart$shippingLines$shippingMethod(
        local$shippingMethod, (e) => call(shippingMethod: e));
  }
}

class _CopyWithStubImpl$Fragment$Cart$shippingLines<TRes>
    implements CopyWith$Fragment$Cart$shippingLines<TRes> {
  _CopyWithStubImpl$Fragment$Cart$shippingLines(this._res);

  TRes _res;

  call({
    double? priceWithTax,
    Fragment$Cart$shippingLines$shippingMethod? shippingMethod,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Fragment$Cart$shippingLines$shippingMethod<TRes>
      get shippingMethod =>
          CopyWith$Fragment$Cart$shippingLines$shippingMethod.stub(_res);
}

class Fragment$Cart$shippingLines$shippingMethod {
  Fragment$Cart$shippingLines$shippingMethod({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    this.$__typename = 'ShippingMethod',
  });

  factory Fragment$Cart$shippingLines$shippingMethod.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$name = json['name'];
    final l$description = json['description'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$shippingLines$shippingMethod(
      id: (l$id as String),
      code: (l$code as String),
      name: (l$name as String),
      description: (l$description as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String name;

  final String description;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$name = name;
    final l$description = description;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$name,
      l$description,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$shippingLines$shippingMethod ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$shippingLines$shippingMethod
    on Fragment$Cart$shippingLines$shippingMethod {
  CopyWith$Fragment$Cart$shippingLines$shippingMethod<
          Fragment$Cart$shippingLines$shippingMethod>
      get copyWith => CopyWith$Fragment$Cart$shippingLines$shippingMethod(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$shippingLines$shippingMethod<TRes> {
  factory CopyWith$Fragment$Cart$shippingLines$shippingMethod(
    Fragment$Cart$shippingLines$shippingMethod instance,
    TRes Function(Fragment$Cart$shippingLines$shippingMethod) then,
  ) = _CopyWithImpl$Fragment$Cart$shippingLines$shippingMethod;

  factory CopyWith$Fragment$Cart$shippingLines$shippingMethod.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$shippingLines$shippingMethod;

  TRes call({
    String? id,
    String? code,
    String? name,
    String? description,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Cart$shippingLines$shippingMethod<TRes>
    implements CopyWith$Fragment$Cart$shippingLines$shippingMethod<TRes> {
  _CopyWithImpl$Fragment$Cart$shippingLines$shippingMethod(
    this._instance,
    this._then,
  );

  final Fragment$Cart$shippingLines$shippingMethod _instance;

  final TRes Function(Fragment$Cart$shippingLines$shippingMethod) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? name = _undefined,
    Object? description = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$shippingLines$shippingMethod(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        description: description == _undefined || description == null
            ? _instance.description
            : (description as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Cart$shippingLines$shippingMethod<TRes>
    implements CopyWith$Fragment$Cart$shippingLines$shippingMethod<TRes> {
  _CopyWithStubImpl$Fragment$Cart$shippingLines$shippingMethod(this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    String? name,
    String? description,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$Cart$discounts {
  Fragment$Cart$discounts({
    required this.amount,
    required this.amountWithTax,
    required this.description,
    required this.adjustmentSource,
    required this.type,
    this.$__typename = 'Discount',
  });

  factory Fragment$Cart$discounts.fromJson(Map<String, dynamic> json) {
    final l$amount = json['amount'];
    final l$amountWithTax = json['amountWithTax'];
    final l$description = json['description'];
    final l$adjustmentSource = json['adjustmentSource'];
    final l$type = json['type'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$discounts(
      amount: (l$amount as num).toDouble(),
      amountWithTax: (l$amountWithTax as num).toDouble(),
      description: (l$description as String),
      adjustmentSource: (l$adjustmentSource as String),
      type: fromJson$Enum$AdjustmentType((l$type as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final double amount;

  final double amountWithTax;

  final String description;

  final String adjustmentSource;

  final Enum$AdjustmentType type;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$amount = amount;
    _resultData['amount'] = l$amount;
    final l$amountWithTax = amountWithTax;
    _resultData['amountWithTax'] = l$amountWithTax;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$adjustmentSource = adjustmentSource;
    _resultData['adjustmentSource'] = l$adjustmentSource;
    final l$type = type;
    _resultData['type'] = toJson$Enum$AdjustmentType(l$type);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$amount = amount;
    final l$amountWithTax = amountWithTax;
    final l$description = description;
    final l$adjustmentSource = adjustmentSource;
    final l$type = type;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$amount,
      l$amountWithTax,
      l$description,
      l$adjustmentSource,
      l$type,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$discounts || runtimeType != other.runtimeType) {
      return false;
    }
    final l$amount = amount;
    final lOther$amount = other.amount;
    if (l$amount != lOther$amount) {
      return false;
    }
    final l$amountWithTax = amountWithTax;
    final lOther$amountWithTax = other.amountWithTax;
    if (l$amountWithTax != lOther$amountWithTax) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$adjustmentSource = adjustmentSource;
    final lOther$adjustmentSource = other.adjustmentSource;
    if (l$adjustmentSource != lOther$adjustmentSource) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$discounts on Fragment$Cart$discounts {
  CopyWith$Fragment$Cart$discounts<Fragment$Cart$discounts> get copyWith =>
      CopyWith$Fragment$Cart$discounts(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$Cart$discounts<TRes> {
  factory CopyWith$Fragment$Cart$discounts(
    Fragment$Cart$discounts instance,
    TRes Function(Fragment$Cart$discounts) then,
  ) = _CopyWithImpl$Fragment$Cart$discounts;

  factory CopyWith$Fragment$Cart$discounts.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$discounts;

  TRes call({
    double? amount,
    double? amountWithTax,
    String? description,
    String? adjustmentSource,
    Enum$AdjustmentType? type,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Cart$discounts<TRes>
    implements CopyWith$Fragment$Cart$discounts<TRes> {
  _CopyWithImpl$Fragment$Cart$discounts(
    this._instance,
    this._then,
  );

  final Fragment$Cart$discounts _instance;

  final TRes Function(Fragment$Cart$discounts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? amount = _undefined,
    Object? amountWithTax = _undefined,
    Object? description = _undefined,
    Object? adjustmentSource = _undefined,
    Object? type = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$discounts(
        amount: amount == _undefined || amount == null
            ? _instance.amount
            : (amount as double),
        amountWithTax: amountWithTax == _undefined || amountWithTax == null
            ? _instance.amountWithTax
            : (amountWithTax as double),
        description: description == _undefined || description == null
            ? _instance.description
            : (description as String),
        adjustmentSource:
            adjustmentSource == _undefined || adjustmentSource == null
                ? _instance.adjustmentSource
                : (adjustmentSource as String),
        type: type == _undefined || type == null
            ? _instance.type
            : (type as Enum$AdjustmentType),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Cart$discounts<TRes>
    implements CopyWith$Fragment$Cart$discounts<TRes> {
  _CopyWithStubImpl$Fragment$Cart$discounts(this._res);

  TRes _res;

  call({
    double? amount,
    double? amountWithTax,
    String? description,
    String? adjustmentSource,
    Enum$AdjustmentType? type,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$Cart$customFields {
  Fragment$Cart$customFields({
    this.loyaltyPointsEarned,
    this.loyaltyPointsUsed,
    this.otherInstructions,
    this.$__typename = 'OrderCustomFields',
  });

  factory Fragment$Cart$customFields.fromJson(Map<String, dynamic> json) {
    final l$loyaltyPointsEarned = json['loyaltyPointsEarned'];
    final l$loyaltyPointsUsed = json['loyaltyPointsUsed'];
    final l$otherInstructions = json['otherInstructions'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$customFields(
      loyaltyPointsEarned: (l$loyaltyPointsEarned as int?),
      loyaltyPointsUsed: (l$loyaltyPointsUsed as int?),
      otherInstructions: (l$otherInstructions as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? loyaltyPointsEarned;

  final int? loyaltyPointsUsed;

  final String? otherInstructions;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    _resultData['loyaltyPointsEarned'] = l$loyaltyPointsEarned;
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    _resultData['loyaltyPointsUsed'] = l$loyaltyPointsUsed;
    final l$otherInstructions = otherInstructions;
    _resultData['otherInstructions'] = l$otherInstructions;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    final l$otherInstructions = otherInstructions;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$loyaltyPointsEarned,
      l$loyaltyPointsUsed,
      l$otherInstructions,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$customFields ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    final lOther$loyaltyPointsEarned = other.loyaltyPointsEarned;
    if (l$loyaltyPointsEarned != lOther$loyaltyPointsEarned) {
      return false;
    }
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    final lOther$loyaltyPointsUsed = other.loyaltyPointsUsed;
    if (l$loyaltyPointsUsed != lOther$loyaltyPointsUsed) {
      return false;
    }
    final l$otherInstructions = otherInstructions;
    final lOther$otherInstructions = other.otherInstructions;
    if (l$otherInstructions != lOther$otherInstructions) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$customFields
    on Fragment$Cart$customFields {
  CopyWith$Fragment$Cart$customFields<Fragment$Cart$customFields>
      get copyWith => CopyWith$Fragment$Cart$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$customFields<TRes> {
  factory CopyWith$Fragment$Cart$customFields(
    Fragment$Cart$customFields instance,
    TRes Function(Fragment$Cart$customFields) then,
  ) = _CopyWithImpl$Fragment$Cart$customFields;

  factory CopyWith$Fragment$Cart$customFields.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$customFields;

  TRes call({
    int? loyaltyPointsEarned,
    int? loyaltyPointsUsed,
    String? otherInstructions,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Cart$customFields<TRes>
    implements CopyWith$Fragment$Cart$customFields<TRes> {
  _CopyWithImpl$Fragment$Cart$customFields(
    this._instance,
    this._then,
  );

  final Fragment$Cart$customFields _instance;

  final TRes Function(Fragment$Cart$customFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? loyaltyPointsEarned = _undefined,
    Object? loyaltyPointsUsed = _undefined,
    Object? otherInstructions = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$customFields(
        loyaltyPointsEarned: loyaltyPointsEarned == _undefined
            ? _instance.loyaltyPointsEarned
            : (loyaltyPointsEarned as int?),
        loyaltyPointsUsed: loyaltyPointsUsed == _undefined
            ? _instance.loyaltyPointsUsed
            : (loyaltyPointsUsed as int?),
        otherInstructions: otherInstructions == _undefined
            ? _instance.otherInstructions
            : (otherInstructions as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Cart$customFields<TRes>
    implements CopyWith$Fragment$Cart$customFields<TRes> {
  _CopyWithStubImpl$Fragment$Cart$customFields(this._res);

  TRes _res;

  call({
    int? loyaltyPointsEarned,
    int? loyaltyPointsUsed,
    String? otherInstructions,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$Cart$quantityLimitStatus {
  Fragment$Cart$quantityLimitStatus({
    required this.isValid,
    required this.hasViolations,
    required this.totalViolations,
    required this.violations,
    this.$__typename = 'QuantityLimitValidationStatus',
  });

  factory Fragment$Cart$quantityLimitStatus.fromJson(
      Map<String, dynamic> json) {
    final l$isValid = json['isValid'];
    final l$hasViolations = json['hasViolations'];
    final l$totalViolations = json['totalViolations'];
    final l$violations = json['violations'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$quantityLimitStatus(
      isValid: (l$isValid as bool),
      hasViolations: (l$hasViolations as bool),
      totalViolations: (l$totalViolations as int),
      violations: (l$violations as List<dynamic>)
          .map((e) => Fragment$Cart$quantityLimitStatus$violations.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final bool isValid;

  final bool hasViolations;

  final int totalViolations;

  final List<Fragment$Cart$quantityLimitStatus$violations> violations;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$isValid = isValid;
    _resultData['isValid'] = l$isValid;
    final l$hasViolations = hasViolations;
    _resultData['hasViolations'] = l$hasViolations;
    final l$totalViolations = totalViolations;
    _resultData['totalViolations'] = l$totalViolations;
    final l$violations = violations;
    _resultData['violations'] = l$violations.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$isValid = isValid;
    final l$hasViolations = hasViolations;
    final l$totalViolations = totalViolations;
    final l$violations = violations;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$isValid,
      l$hasViolations,
      l$totalViolations,
      Object.hashAll(l$violations.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$quantityLimitStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$isValid = isValid;
    final lOther$isValid = other.isValid;
    if (l$isValid != lOther$isValid) {
      return false;
    }
    final l$hasViolations = hasViolations;
    final lOther$hasViolations = other.hasViolations;
    if (l$hasViolations != lOther$hasViolations) {
      return false;
    }
    final l$totalViolations = totalViolations;
    final lOther$totalViolations = other.totalViolations;
    if (l$totalViolations != lOther$totalViolations) {
      return false;
    }
    final l$violations = violations;
    final lOther$violations = other.violations;
    if (l$violations.length != lOther$violations.length) {
      return false;
    }
    for (int i = 0; i < l$violations.length; i++) {
      final l$violations$entry = l$violations[i];
      final lOther$violations$entry = lOther$violations[i];
      if (l$violations$entry != lOther$violations$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$quantityLimitStatus
    on Fragment$Cart$quantityLimitStatus {
  CopyWith$Fragment$Cart$quantityLimitStatus<Fragment$Cart$quantityLimitStatus>
      get copyWith => CopyWith$Fragment$Cart$quantityLimitStatus(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$quantityLimitStatus<TRes> {
  factory CopyWith$Fragment$Cart$quantityLimitStatus(
    Fragment$Cart$quantityLimitStatus instance,
    TRes Function(Fragment$Cart$quantityLimitStatus) then,
  ) = _CopyWithImpl$Fragment$Cart$quantityLimitStatus;

  factory CopyWith$Fragment$Cart$quantityLimitStatus.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$quantityLimitStatus;

  TRes call({
    bool? isValid,
    bool? hasViolations,
    int? totalViolations,
    List<Fragment$Cart$quantityLimitStatus$violations>? violations,
    String? $__typename,
  });
  TRes violations(
      Iterable<Fragment$Cart$quantityLimitStatus$violations> Function(
              Iterable<
                  CopyWith$Fragment$Cart$quantityLimitStatus$violations<
                      Fragment$Cart$quantityLimitStatus$violations>>)
          _fn);
}

class _CopyWithImpl$Fragment$Cart$quantityLimitStatus<TRes>
    implements CopyWith$Fragment$Cart$quantityLimitStatus<TRes> {
  _CopyWithImpl$Fragment$Cart$quantityLimitStatus(
    this._instance,
    this._then,
  );

  final Fragment$Cart$quantityLimitStatus _instance;

  final TRes Function(Fragment$Cart$quantityLimitStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? isValid = _undefined,
    Object? hasViolations = _undefined,
    Object? totalViolations = _undefined,
    Object? violations = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$quantityLimitStatus(
        isValid: isValid == _undefined || isValid == null
            ? _instance.isValid
            : (isValid as bool),
        hasViolations: hasViolations == _undefined || hasViolations == null
            ? _instance.hasViolations
            : (hasViolations as bool),
        totalViolations:
            totalViolations == _undefined || totalViolations == null
                ? _instance.totalViolations
                : (totalViolations as int),
        violations: violations == _undefined || violations == null
            ? _instance.violations
            : (violations
                as List<Fragment$Cart$quantityLimitStatus$violations>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes violations(
          Iterable<Fragment$Cart$quantityLimitStatus$violations> Function(
                  Iterable<
                      CopyWith$Fragment$Cart$quantityLimitStatus$violations<
                          Fragment$Cart$quantityLimitStatus$violations>>)
              _fn) =>
      call(
          violations: _fn(_instance.violations
              .map((e) => CopyWith$Fragment$Cart$quantityLimitStatus$violations(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Fragment$Cart$quantityLimitStatus<TRes>
    implements CopyWith$Fragment$Cart$quantityLimitStatus<TRes> {
  _CopyWithStubImpl$Fragment$Cart$quantityLimitStatus(this._res);

  TRes _res;

  call({
    bool? isValid,
    bool? hasViolations,
    int? totalViolations,
    List<Fragment$Cart$quantityLimitStatus$violations>? violations,
    String? $__typename,
  }) =>
      _res;

  violations(_fn) => _res;
}

class Fragment$Cart$quantityLimitStatus$violations {
  Fragment$Cart$quantityLimitStatus$violations({
    required this.orderLineId,
    required this.productName,
    required this.variantName,
    required this.currentQuantity,
    required this.maxQuantity,
    required this.reason,
    this.$__typename = 'QuantityLimitViolation',
  });

  factory Fragment$Cart$quantityLimitStatus$violations.fromJson(
      Map<String, dynamic> json) {
    final l$orderLineId = json['orderLineId'];
    final l$productName = json['productName'];
    final l$variantName = json['variantName'];
    final l$currentQuantity = json['currentQuantity'];
    final l$maxQuantity = json['maxQuantity'];
    final l$reason = json['reason'];
    final l$$__typename = json['__typename'];
    return Fragment$Cart$quantityLimitStatus$violations(
      orderLineId: (l$orderLineId as String),
      productName: (l$productName as String),
      variantName: (l$variantName as String),
      currentQuantity: (l$currentQuantity as int),
      maxQuantity: (l$maxQuantity as int),
      reason: (l$reason as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String orderLineId;

  final String productName;

  final String variantName;

  final int currentQuantity;

  final int maxQuantity;

  final String reason;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$orderLineId = orderLineId;
    _resultData['orderLineId'] = l$orderLineId;
    final l$productName = productName;
    _resultData['productName'] = l$productName;
    final l$variantName = variantName;
    _resultData['variantName'] = l$variantName;
    final l$currentQuantity = currentQuantity;
    _resultData['currentQuantity'] = l$currentQuantity;
    final l$maxQuantity = maxQuantity;
    _resultData['maxQuantity'] = l$maxQuantity;
    final l$reason = reason;
    _resultData['reason'] = l$reason;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$orderLineId = orderLineId;
    final l$productName = productName;
    final l$variantName = variantName;
    final l$currentQuantity = currentQuantity;
    final l$maxQuantity = maxQuantity;
    final l$reason = reason;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$orderLineId,
      l$productName,
      l$variantName,
      l$currentQuantity,
      l$maxQuantity,
      l$reason,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Cart$quantityLimitStatus$violations ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$orderLineId = orderLineId;
    final lOther$orderLineId = other.orderLineId;
    if (l$orderLineId != lOther$orderLineId) {
      return false;
    }
    final l$productName = productName;
    final lOther$productName = other.productName;
    if (l$productName != lOther$productName) {
      return false;
    }
    final l$variantName = variantName;
    final lOther$variantName = other.variantName;
    if (l$variantName != lOther$variantName) {
      return false;
    }
    final l$currentQuantity = currentQuantity;
    final lOther$currentQuantity = other.currentQuantity;
    if (l$currentQuantity != lOther$currentQuantity) {
      return false;
    }
    final l$maxQuantity = maxQuantity;
    final lOther$maxQuantity = other.maxQuantity;
    if (l$maxQuantity != lOther$maxQuantity) {
      return false;
    }
    final l$reason = reason;
    final lOther$reason = other.reason;
    if (l$reason != lOther$reason) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Cart$quantityLimitStatus$violations
    on Fragment$Cart$quantityLimitStatus$violations {
  CopyWith$Fragment$Cart$quantityLimitStatus$violations<
          Fragment$Cart$quantityLimitStatus$violations>
      get copyWith => CopyWith$Fragment$Cart$quantityLimitStatus$violations(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$Cart$quantityLimitStatus$violations<TRes> {
  factory CopyWith$Fragment$Cart$quantityLimitStatus$violations(
    Fragment$Cart$quantityLimitStatus$violations instance,
    TRes Function(Fragment$Cart$quantityLimitStatus$violations) then,
  ) = _CopyWithImpl$Fragment$Cart$quantityLimitStatus$violations;

  factory CopyWith$Fragment$Cart$quantityLimitStatus$violations.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Cart$quantityLimitStatus$violations;

  TRes call({
    String? orderLineId,
    String? productName,
    String? variantName,
    int? currentQuantity,
    int? maxQuantity,
    String? reason,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Cart$quantityLimitStatus$violations<TRes>
    implements CopyWith$Fragment$Cart$quantityLimitStatus$violations<TRes> {
  _CopyWithImpl$Fragment$Cart$quantityLimitStatus$violations(
    this._instance,
    this._then,
  );

  final Fragment$Cart$quantityLimitStatus$violations _instance;

  final TRes Function(Fragment$Cart$quantityLimitStatus$violations) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? orderLineId = _undefined,
    Object? productName = _undefined,
    Object? variantName = _undefined,
    Object? currentQuantity = _undefined,
    Object? maxQuantity = _undefined,
    Object? reason = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Cart$quantityLimitStatus$violations(
        orderLineId: orderLineId == _undefined || orderLineId == null
            ? _instance.orderLineId
            : (orderLineId as String),
        productName: productName == _undefined || productName == null
            ? _instance.productName
            : (productName as String),
        variantName: variantName == _undefined || variantName == null
            ? _instance.variantName
            : (variantName as String),
        currentQuantity:
            currentQuantity == _undefined || currentQuantity == null
                ? _instance.currentQuantity
                : (currentQuantity as int),
        maxQuantity: maxQuantity == _undefined || maxQuantity == null
            ? _instance.maxQuantity
            : (maxQuantity as int),
        reason: reason == _undefined || reason == null
            ? _instance.reason
            : (reason as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Cart$quantityLimitStatus$violations<TRes>
    implements CopyWith$Fragment$Cart$quantityLimitStatus$violations<TRes> {
  _CopyWithStubImpl$Fragment$Cart$quantityLimitStatus$violations(this._res);

  TRes _res;

  call({
    String? orderLineId,
    String? productName,
    String? variantName,
    int? currentQuantity,
    int? maxQuantity,
    String? reason,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$Asset {
  Fragment$Asset({
    required this.id,
    required this.width,
    required this.height,
    required this.name,
    required this.preview,
    this.focalPoint,
    this.$__typename = 'Asset',
  });

  factory Fragment$Asset.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$width = json['width'];
    final l$height = json['height'];
    final l$name = json['name'];
    final l$preview = json['preview'];
    final l$focalPoint = json['focalPoint'];
    final l$$__typename = json['__typename'];
    return Fragment$Asset(
      id: (l$id as String),
      width: (l$width as int),
      height: (l$height as int),
      name: (l$name as String),
      preview: (l$preview as String),
      focalPoint: l$focalPoint == null
          ? null
          : Fragment$Asset$focalPoint.fromJson(
              (l$focalPoint as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int width;

  final int height;

  final String name;

  final String preview;

  final Fragment$Asset$focalPoint? focalPoint;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$width = width;
    _resultData['width'] = l$width;
    final l$height = height;
    _resultData['height'] = l$height;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$preview = preview;
    _resultData['preview'] = l$preview;
    final l$focalPoint = focalPoint;
    _resultData['focalPoint'] = l$focalPoint?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$width = width;
    final l$height = height;
    final l$name = name;
    final l$preview = preview;
    final l$focalPoint = focalPoint;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$width,
      l$height,
      l$name,
      l$preview,
      l$focalPoint,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Asset || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$width = width;
    final lOther$width = other.width;
    if (l$width != lOther$width) {
      return false;
    }
    final l$height = height;
    final lOther$height = other.height;
    if (l$height != lOther$height) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$preview = preview;
    final lOther$preview = other.preview;
    if (l$preview != lOther$preview) {
      return false;
    }
    final l$focalPoint = focalPoint;
    final lOther$focalPoint = other.focalPoint;
    if (l$focalPoint != lOther$focalPoint) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Asset on Fragment$Asset {
  CopyWith$Fragment$Asset<Fragment$Asset> get copyWith =>
      CopyWith$Fragment$Asset(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$Asset<TRes> {
  factory CopyWith$Fragment$Asset(
    Fragment$Asset instance,
    TRes Function(Fragment$Asset) then,
  ) = _CopyWithImpl$Fragment$Asset;

  factory CopyWith$Fragment$Asset.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Asset;

  TRes call({
    String? id,
    int? width,
    int? height,
    String? name,
    String? preview,
    Fragment$Asset$focalPoint? focalPoint,
    String? $__typename,
  });
  CopyWith$Fragment$Asset$focalPoint<TRes> get focalPoint;
}

class _CopyWithImpl$Fragment$Asset<TRes>
    implements CopyWith$Fragment$Asset<TRes> {
  _CopyWithImpl$Fragment$Asset(
    this._instance,
    this._then,
  );

  final Fragment$Asset _instance;

  final TRes Function(Fragment$Asset) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? width = _undefined,
    Object? height = _undefined,
    Object? name = _undefined,
    Object? preview = _undefined,
    Object? focalPoint = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Asset(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        width: width == _undefined || width == null
            ? _instance.width
            : (width as int),
        height: height == _undefined || height == null
            ? _instance.height
            : (height as int),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        preview: preview == _undefined || preview == null
            ? _instance.preview
            : (preview as String),
        focalPoint: focalPoint == _undefined
            ? _instance.focalPoint
            : (focalPoint as Fragment$Asset$focalPoint?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Fragment$Asset$focalPoint<TRes> get focalPoint {
    final local$focalPoint = _instance.focalPoint;
    return local$focalPoint == null
        ? CopyWith$Fragment$Asset$focalPoint.stub(_then(_instance))
        : CopyWith$Fragment$Asset$focalPoint(
            local$focalPoint, (e) => call(focalPoint: e));
  }
}

class _CopyWithStubImpl$Fragment$Asset<TRes>
    implements CopyWith$Fragment$Asset<TRes> {
  _CopyWithStubImpl$Fragment$Asset(this._res);

  TRes _res;

  call({
    String? id,
    int? width,
    int? height,
    String? name,
    String? preview,
    Fragment$Asset$focalPoint? focalPoint,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Fragment$Asset$focalPoint<TRes> get focalPoint =>
      CopyWith$Fragment$Asset$focalPoint.stub(_res);
}

const fragmentDefinitionAsset = FragmentDefinitionNode(
  name: NameNode(value: 'Asset'),
  typeCondition: TypeConditionNode(
      on: NamedTypeNode(
    name: NameNode(value: 'Asset'),
    isNonNull: false,
  )),
  directives: [],
  selectionSet: SelectionSetNode(selections: [
    FieldNode(
      name: NameNode(value: 'id'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'width'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'height'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'name'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'preview'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'focalPoint'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
          name: NameNode(value: 'x'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: 'y'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        FieldNode(
          name: NameNode(value: '__typename'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
      ]),
    ),
    FieldNode(
      name: NameNode(value: '__typename'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
  ]),
);
const documentNodeFragmentAsset = DocumentNode(definitions: [
  fragmentDefinitionAsset,
]);

extension ClientExtension$Fragment$Asset on graphql.GraphQLClient {
  void writeFragment$Asset({
    required Fragment$Asset data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) =>
      this.writeFragment(
        graphql.FragmentRequest(
          idFields: idFields,
          fragment: const graphql.Fragment(
            fragmentName: 'Asset',
            document: documentNodeFragmentAsset,
          ),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Fragment$Asset? readFragment$Asset({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'Asset',
          document: documentNodeFragmentAsset,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$Asset.fromJson(result);
  }
}

class Fragment$Asset$focalPoint {
  Fragment$Asset$focalPoint({
    required this.x,
    required this.y,
    this.$__typename = 'Coordinate',
  });

  factory Fragment$Asset$focalPoint.fromJson(Map<String, dynamic> json) {
    final l$x = json['x'];
    final l$y = json['y'];
    final l$$__typename = json['__typename'];
    return Fragment$Asset$focalPoint(
      x: (l$x as num).toDouble(),
      y: (l$y as num).toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final double x;

  final double y;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$x = x;
    _resultData['x'] = l$x;
    final l$y = y;
    _resultData['y'] = l$y;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$x = x;
    final l$y = y;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$x,
      l$y,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Asset$focalPoint ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$x = x;
    final lOther$x = other.x;
    if (l$x != lOther$x) {
      return false;
    }
    final l$y = y;
    final lOther$y = other.y;
    if (l$y != lOther$y) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Asset$focalPoint
    on Fragment$Asset$focalPoint {
  CopyWith$Fragment$Asset$focalPoint<Fragment$Asset$focalPoint> get copyWith =>
      CopyWith$Fragment$Asset$focalPoint(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$Asset$focalPoint<TRes> {
  factory CopyWith$Fragment$Asset$focalPoint(
    Fragment$Asset$focalPoint instance,
    TRes Function(Fragment$Asset$focalPoint) then,
  ) = _CopyWithImpl$Fragment$Asset$focalPoint;

  factory CopyWith$Fragment$Asset$focalPoint.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Asset$focalPoint;

  TRes call({
    double? x,
    double? y,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Asset$focalPoint<TRes>
    implements CopyWith$Fragment$Asset$focalPoint<TRes> {
  _CopyWithImpl$Fragment$Asset$focalPoint(
    this._instance,
    this._then,
  );

  final Fragment$Asset$focalPoint _instance;

  final TRes Function(Fragment$Asset$focalPoint) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? x = _undefined,
    Object? y = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Asset$focalPoint(
        x: x == _undefined || x == null ? _instance.x : (x as double),
        y: y == _undefined || y == null ? _instance.y : (y as double),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Asset$focalPoint<TRes>
    implements CopyWith$Fragment$Asset$focalPoint<TRes> {
  _CopyWithStubImpl$Fragment$Asset$focalPoint(this._res);

  TRes _res;

  call({
    double? x,
    double? y,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult {
  Fragment$ErrorResult({
    required this.errorCode,
    required this.message,
    required this.$__typename,
  });

  factory Fragment$ErrorResult.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "AlreadyLoggedInError":
        return Fragment$ErrorResult$$AlreadyLoggedInError.fromJson(json);

      case "CartContainsUnavailableItemsError":
        return Fragment$ErrorResult$$CartContainsUnavailableItemsError.fromJson(
            json);

      case "CouponCodeExpiredError":
        return Fragment$ErrorResult$$CouponCodeExpiredError.fromJson(json);

      case "CouponCodeInvalidError":
        return Fragment$ErrorResult$$CouponCodeInvalidError.fromJson(json);

      case "CouponCodeLimitError":
        return Fragment$ErrorResult$$CouponCodeLimitError.fromJson(json);

      case "EmailAddressConflictError":
        return Fragment$ErrorResult$$EmailAddressConflictError.fromJson(json);

      case "GuestCheckoutError":
        return Fragment$ErrorResult$$GuestCheckoutError.fromJson(json);

      case "IdentifierChangeTokenExpiredError":
        return Fragment$ErrorResult$$IdentifierChangeTokenExpiredError.fromJson(
            json);

      case "IdentifierChangeTokenInvalidError":
        return Fragment$ErrorResult$$IdentifierChangeTokenInvalidError.fromJson(
            json);

      case "IneligiblePaymentMethodError":
        return Fragment$ErrorResult$$IneligiblePaymentMethodError.fromJson(
            json);

      case "IneligibleShippingMethodError":
        return Fragment$ErrorResult$$IneligibleShippingMethodError.fromJson(
            json);

      case "InsufficientStockError":
        return Fragment$ErrorResult$$InsufficientStockError.fromJson(json);

      case "InvalidCredentialsError":
        return Fragment$ErrorResult$$InvalidCredentialsError.fromJson(json);

      case "MissingPasswordError":
        return Fragment$ErrorResult$$MissingPasswordError.fromJson(json);

      case "NativeAuthStrategyError":
        return Fragment$ErrorResult$$NativeAuthStrategyError.fromJson(json);

      case "NegativeQuantityError":
        return Fragment$ErrorResult$$NegativeQuantityError.fromJson(json);

      case "NoActiveOrderError":
        return Fragment$ErrorResult$$NoActiveOrderError.fromJson(json);

      case "NotVerifiedError":
        return Fragment$ErrorResult$$NotVerifiedError.fromJson(json);

      case "OrderInterceptorError":
        return Fragment$ErrorResult$$OrderInterceptorError.fromJson(json);

      case "OrderLimitError":
        return Fragment$ErrorResult$$OrderLimitError.fromJson(json);

      case "OrderModificationError":
        return Fragment$ErrorResult$$OrderModificationError.fromJson(json);

      case "OrderPaymentStateError":
        return Fragment$ErrorResult$$OrderPaymentStateError.fromJson(json);

      case "OrderStateTransitionError":
        return Fragment$ErrorResult$$OrderStateTransitionError.fromJson(json);

      case "PasswordAlreadySetError":
        return Fragment$ErrorResult$$PasswordAlreadySetError.fromJson(json);

      case "PasswordResetTokenExpiredError":
        return Fragment$ErrorResult$$PasswordResetTokenExpiredError.fromJson(
            json);

      case "PasswordResetTokenInvalidError":
        return Fragment$ErrorResult$$PasswordResetTokenInvalidError.fromJson(
            json);

      case "PasswordValidationError":
        return Fragment$ErrorResult$$PasswordValidationError.fromJson(json);

      case "PaymentDeclinedError":
        return Fragment$ErrorResult$$PaymentDeclinedError.fromJson(json);

      case "PaymentFailedError":
        return Fragment$ErrorResult$$PaymentFailedError.fromJson(json);

      case "VerificationTokenExpiredError":
        return Fragment$ErrorResult$$VerificationTokenExpiredError.fromJson(
            json);

      case "VerificationTokenInvalidError":
        return Fragment$ErrorResult$$VerificationTokenInvalidError.fromJson(
            json);

      case "QuantityLimitError":
        return Fragment$ErrorResult$$QuantityLimitError.fromJson(json);

      default:
        final l$errorCode = json['errorCode'];
        final l$message = json['message'];
        final l$$__typename = json['__typename'];
        return Fragment$ErrorResult(
          errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
          message: (l$message as String),
          $__typename: (l$$__typename as String),
        );
    }
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult || runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult on Fragment$ErrorResult {
  CopyWith$Fragment$ErrorResult<Fragment$ErrorResult> get copyWith =>
      CopyWith$Fragment$ErrorResult(
        this,
        (i) => i,
      );
  _T when<_T>({
    required _T Function(Fragment$ErrorResult$$AlreadyLoggedInError)
        alreadyLoggedInError,
    required _T Function(
            Fragment$ErrorResult$$CartContainsUnavailableItemsError)
        cartContainsUnavailableItemsError,
    required _T Function(Fragment$ErrorResult$$CouponCodeExpiredError)
        couponCodeExpiredError,
    required _T Function(Fragment$ErrorResult$$CouponCodeInvalidError)
        couponCodeInvalidError,
    required _T Function(Fragment$ErrorResult$$CouponCodeLimitError)
        couponCodeLimitError,
    required _T Function(Fragment$ErrorResult$$EmailAddressConflictError)
        emailAddressConflictError,
    required _T Function(Fragment$ErrorResult$$GuestCheckoutError)
        guestCheckoutError,
    required _T Function(
            Fragment$ErrorResult$$IdentifierChangeTokenExpiredError)
        identifierChangeTokenExpiredError,
    required _T Function(
            Fragment$ErrorResult$$IdentifierChangeTokenInvalidError)
        identifierChangeTokenInvalidError,
    required _T Function(Fragment$ErrorResult$$IneligiblePaymentMethodError)
        ineligiblePaymentMethodError,
    required _T Function(Fragment$ErrorResult$$IneligibleShippingMethodError)
        ineligibleShippingMethodError,
    required _T Function(Fragment$ErrorResult$$InsufficientStockError)
        insufficientStockError,
    required _T Function(Fragment$ErrorResult$$InvalidCredentialsError)
        invalidCredentialsError,
    required _T Function(Fragment$ErrorResult$$MissingPasswordError)
        missingPasswordError,
    required _T Function(Fragment$ErrorResult$$NativeAuthStrategyError)
        nativeAuthStrategyError,
    required _T Function(Fragment$ErrorResult$$NegativeQuantityError)
        negativeQuantityError,
    required _T Function(Fragment$ErrorResult$$NoActiveOrderError)
        noActiveOrderError,
    required _T Function(Fragment$ErrorResult$$NotVerifiedError)
        notVerifiedError,
    required _T Function(Fragment$ErrorResult$$OrderInterceptorError)
        orderInterceptorError,
    required _T Function(Fragment$ErrorResult$$OrderLimitError) orderLimitError,
    required _T Function(Fragment$ErrorResult$$OrderModificationError)
        orderModificationError,
    required _T Function(Fragment$ErrorResult$$OrderPaymentStateError)
        orderPaymentStateError,
    required _T Function(Fragment$ErrorResult$$OrderStateTransitionError)
        orderStateTransitionError,
    required _T Function(Fragment$ErrorResult$$PasswordAlreadySetError)
        passwordAlreadySetError,
    required _T Function(Fragment$ErrorResult$$PasswordResetTokenExpiredError)
        passwordResetTokenExpiredError,
    required _T Function(Fragment$ErrorResult$$PasswordResetTokenInvalidError)
        passwordResetTokenInvalidError,
    required _T Function(Fragment$ErrorResult$$PasswordValidationError)
        passwordValidationError,
    required _T Function(Fragment$ErrorResult$$PaymentDeclinedError)
        paymentDeclinedError,
    required _T Function(Fragment$ErrorResult$$PaymentFailedError)
        paymentFailedError,
    required _T Function(Fragment$ErrorResult$$VerificationTokenExpiredError)
        verificationTokenExpiredError,
    required _T Function(Fragment$ErrorResult$$VerificationTokenInvalidError)
        verificationTokenInvalidError,
    required _T Function(Fragment$ErrorResult$$QuantityLimitError)
        quantityLimitError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "AlreadyLoggedInError":
        return alreadyLoggedInError(
            this as Fragment$ErrorResult$$AlreadyLoggedInError);

      case "CartContainsUnavailableItemsError":
        return cartContainsUnavailableItemsError(
            this as Fragment$ErrorResult$$CartContainsUnavailableItemsError);

      case "CouponCodeExpiredError":
        return couponCodeExpiredError(
            this as Fragment$ErrorResult$$CouponCodeExpiredError);

      case "CouponCodeInvalidError":
        return couponCodeInvalidError(
            this as Fragment$ErrorResult$$CouponCodeInvalidError);

      case "CouponCodeLimitError":
        return couponCodeLimitError(
            this as Fragment$ErrorResult$$CouponCodeLimitError);

      case "EmailAddressConflictError":
        return emailAddressConflictError(
            this as Fragment$ErrorResult$$EmailAddressConflictError);

      case "GuestCheckoutError":
        return guestCheckoutError(
            this as Fragment$ErrorResult$$GuestCheckoutError);

      case "IdentifierChangeTokenExpiredError":
        return identifierChangeTokenExpiredError(
            this as Fragment$ErrorResult$$IdentifierChangeTokenExpiredError);

      case "IdentifierChangeTokenInvalidError":
        return identifierChangeTokenInvalidError(
            this as Fragment$ErrorResult$$IdentifierChangeTokenInvalidError);

      case "IneligiblePaymentMethodError":
        return ineligiblePaymentMethodError(
            this as Fragment$ErrorResult$$IneligiblePaymentMethodError);

      case "IneligibleShippingMethodError":
        return ineligibleShippingMethodError(
            this as Fragment$ErrorResult$$IneligibleShippingMethodError);

      case "InsufficientStockError":
        return insufficientStockError(
            this as Fragment$ErrorResult$$InsufficientStockError);

      case "InvalidCredentialsError":
        return invalidCredentialsError(
            this as Fragment$ErrorResult$$InvalidCredentialsError);

      case "MissingPasswordError":
        return missingPasswordError(
            this as Fragment$ErrorResult$$MissingPasswordError);

      case "NativeAuthStrategyError":
        return nativeAuthStrategyError(
            this as Fragment$ErrorResult$$NativeAuthStrategyError);

      case "NegativeQuantityError":
        return negativeQuantityError(
            this as Fragment$ErrorResult$$NegativeQuantityError);

      case "NoActiveOrderError":
        return noActiveOrderError(
            this as Fragment$ErrorResult$$NoActiveOrderError);

      case "NotVerifiedError":
        return notVerifiedError(this as Fragment$ErrorResult$$NotVerifiedError);

      case "OrderInterceptorError":
        return orderInterceptorError(
            this as Fragment$ErrorResult$$OrderInterceptorError);

      case "OrderLimitError":
        return orderLimitError(this as Fragment$ErrorResult$$OrderLimitError);

      case "OrderModificationError":
        return orderModificationError(
            this as Fragment$ErrorResult$$OrderModificationError);

      case "OrderPaymentStateError":
        return orderPaymentStateError(
            this as Fragment$ErrorResult$$OrderPaymentStateError);

      case "OrderStateTransitionError":
        return orderStateTransitionError(
            this as Fragment$ErrorResult$$OrderStateTransitionError);

      case "PasswordAlreadySetError":
        return passwordAlreadySetError(
            this as Fragment$ErrorResult$$PasswordAlreadySetError);

      case "PasswordResetTokenExpiredError":
        return passwordResetTokenExpiredError(
            this as Fragment$ErrorResult$$PasswordResetTokenExpiredError);

      case "PasswordResetTokenInvalidError":
        return passwordResetTokenInvalidError(
            this as Fragment$ErrorResult$$PasswordResetTokenInvalidError);

      case "PasswordValidationError":
        return passwordValidationError(
            this as Fragment$ErrorResult$$PasswordValidationError);

      case "PaymentDeclinedError":
        return paymentDeclinedError(
            this as Fragment$ErrorResult$$PaymentDeclinedError);

      case "PaymentFailedError":
        return paymentFailedError(
            this as Fragment$ErrorResult$$PaymentFailedError);

      case "VerificationTokenExpiredError":
        return verificationTokenExpiredError(
            this as Fragment$ErrorResult$$VerificationTokenExpiredError);

      case "VerificationTokenInvalidError":
        return verificationTokenInvalidError(
            this as Fragment$ErrorResult$$VerificationTokenInvalidError);

      case "QuantityLimitError":
        return quantityLimitError(
            this as Fragment$ErrorResult$$QuantityLimitError);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Fragment$ErrorResult$$AlreadyLoggedInError)?
        alreadyLoggedInError,
    _T Function(Fragment$ErrorResult$$CartContainsUnavailableItemsError)?
        cartContainsUnavailableItemsError,
    _T Function(Fragment$ErrorResult$$CouponCodeExpiredError)?
        couponCodeExpiredError,
    _T Function(Fragment$ErrorResult$$CouponCodeInvalidError)?
        couponCodeInvalidError,
    _T Function(Fragment$ErrorResult$$CouponCodeLimitError)?
        couponCodeLimitError,
    _T Function(Fragment$ErrorResult$$EmailAddressConflictError)?
        emailAddressConflictError,
    _T Function(Fragment$ErrorResult$$GuestCheckoutError)? guestCheckoutError,
    _T Function(Fragment$ErrorResult$$IdentifierChangeTokenExpiredError)?
        identifierChangeTokenExpiredError,
    _T Function(Fragment$ErrorResult$$IdentifierChangeTokenInvalidError)?
        identifierChangeTokenInvalidError,
    _T Function(Fragment$ErrorResult$$IneligiblePaymentMethodError)?
        ineligiblePaymentMethodError,
    _T Function(Fragment$ErrorResult$$IneligibleShippingMethodError)?
        ineligibleShippingMethodError,
    _T Function(Fragment$ErrorResult$$InsufficientStockError)?
        insufficientStockError,
    _T Function(Fragment$ErrorResult$$InvalidCredentialsError)?
        invalidCredentialsError,
    _T Function(Fragment$ErrorResult$$MissingPasswordError)?
        missingPasswordError,
    _T Function(Fragment$ErrorResult$$NativeAuthStrategyError)?
        nativeAuthStrategyError,
    _T Function(Fragment$ErrorResult$$NegativeQuantityError)?
        negativeQuantityError,
    _T Function(Fragment$ErrorResult$$NoActiveOrderError)? noActiveOrderError,
    _T Function(Fragment$ErrorResult$$NotVerifiedError)? notVerifiedError,
    _T Function(Fragment$ErrorResult$$OrderInterceptorError)?
        orderInterceptorError,
    _T Function(Fragment$ErrorResult$$OrderLimitError)? orderLimitError,
    _T Function(Fragment$ErrorResult$$OrderModificationError)?
        orderModificationError,
    _T Function(Fragment$ErrorResult$$OrderPaymentStateError)?
        orderPaymentStateError,
    _T Function(Fragment$ErrorResult$$OrderStateTransitionError)?
        orderStateTransitionError,
    _T Function(Fragment$ErrorResult$$PasswordAlreadySetError)?
        passwordAlreadySetError,
    _T Function(Fragment$ErrorResult$$PasswordResetTokenExpiredError)?
        passwordResetTokenExpiredError,
    _T Function(Fragment$ErrorResult$$PasswordResetTokenInvalidError)?
        passwordResetTokenInvalidError,
    _T Function(Fragment$ErrorResult$$PasswordValidationError)?
        passwordValidationError,
    _T Function(Fragment$ErrorResult$$PaymentDeclinedError)?
        paymentDeclinedError,
    _T Function(Fragment$ErrorResult$$PaymentFailedError)? paymentFailedError,
    _T Function(Fragment$ErrorResult$$VerificationTokenExpiredError)?
        verificationTokenExpiredError,
    _T Function(Fragment$ErrorResult$$VerificationTokenInvalidError)?
        verificationTokenInvalidError,
    _T Function(Fragment$ErrorResult$$QuantityLimitError)? quantityLimitError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "AlreadyLoggedInError":
        if (alreadyLoggedInError != null) {
          return alreadyLoggedInError(
              this as Fragment$ErrorResult$$AlreadyLoggedInError);
        } else {
          return orElse();
        }

      case "CartContainsUnavailableItemsError":
        if (cartContainsUnavailableItemsError != null) {
          return cartContainsUnavailableItemsError(
              this as Fragment$ErrorResult$$CartContainsUnavailableItemsError);
        } else {
          return orElse();
        }

      case "CouponCodeExpiredError":
        if (couponCodeExpiredError != null) {
          return couponCodeExpiredError(
              this as Fragment$ErrorResult$$CouponCodeExpiredError);
        } else {
          return orElse();
        }

      case "CouponCodeInvalidError":
        if (couponCodeInvalidError != null) {
          return couponCodeInvalidError(
              this as Fragment$ErrorResult$$CouponCodeInvalidError);
        } else {
          return orElse();
        }

      case "CouponCodeLimitError":
        if (couponCodeLimitError != null) {
          return couponCodeLimitError(
              this as Fragment$ErrorResult$$CouponCodeLimitError);
        } else {
          return orElse();
        }

      case "EmailAddressConflictError":
        if (emailAddressConflictError != null) {
          return emailAddressConflictError(
              this as Fragment$ErrorResult$$EmailAddressConflictError);
        } else {
          return orElse();
        }

      case "GuestCheckoutError":
        if (guestCheckoutError != null) {
          return guestCheckoutError(
              this as Fragment$ErrorResult$$GuestCheckoutError);
        } else {
          return orElse();
        }

      case "IdentifierChangeTokenExpiredError":
        if (identifierChangeTokenExpiredError != null) {
          return identifierChangeTokenExpiredError(
              this as Fragment$ErrorResult$$IdentifierChangeTokenExpiredError);
        } else {
          return orElse();
        }

      case "IdentifierChangeTokenInvalidError":
        if (identifierChangeTokenInvalidError != null) {
          return identifierChangeTokenInvalidError(
              this as Fragment$ErrorResult$$IdentifierChangeTokenInvalidError);
        } else {
          return orElse();
        }

      case "IneligiblePaymentMethodError":
        if (ineligiblePaymentMethodError != null) {
          return ineligiblePaymentMethodError(
              this as Fragment$ErrorResult$$IneligiblePaymentMethodError);
        } else {
          return orElse();
        }

      case "IneligibleShippingMethodError":
        if (ineligibleShippingMethodError != null) {
          return ineligibleShippingMethodError(
              this as Fragment$ErrorResult$$IneligibleShippingMethodError);
        } else {
          return orElse();
        }

      case "InsufficientStockError":
        if (insufficientStockError != null) {
          return insufficientStockError(
              this as Fragment$ErrorResult$$InsufficientStockError);
        } else {
          return orElse();
        }

      case "InvalidCredentialsError":
        if (invalidCredentialsError != null) {
          return invalidCredentialsError(
              this as Fragment$ErrorResult$$InvalidCredentialsError);
        } else {
          return orElse();
        }

      case "MissingPasswordError":
        if (missingPasswordError != null) {
          return missingPasswordError(
              this as Fragment$ErrorResult$$MissingPasswordError);
        } else {
          return orElse();
        }

      case "NativeAuthStrategyError":
        if (nativeAuthStrategyError != null) {
          return nativeAuthStrategyError(
              this as Fragment$ErrorResult$$NativeAuthStrategyError);
        } else {
          return orElse();
        }

      case "NegativeQuantityError":
        if (negativeQuantityError != null) {
          return negativeQuantityError(
              this as Fragment$ErrorResult$$NegativeQuantityError);
        } else {
          return orElse();
        }

      case "NoActiveOrderError":
        if (noActiveOrderError != null) {
          return noActiveOrderError(
              this as Fragment$ErrorResult$$NoActiveOrderError);
        } else {
          return orElse();
        }

      case "NotVerifiedError":
        if (notVerifiedError != null) {
          return notVerifiedError(
              this as Fragment$ErrorResult$$NotVerifiedError);
        } else {
          return orElse();
        }

      case "OrderInterceptorError":
        if (orderInterceptorError != null) {
          return orderInterceptorError(
              this as Fragment$ErrorResult$$OrderInterceptorError);
        } else {
          return orElse();
        }

      case "OrderLimitError":
        if (orderLimitError != null) {
          return orderLimitError(this as Fragment$ErrorResult$$OrderLimitError);
        } else {
          return orElse();
        }

      case "OrderModificationError":
        if (orderModificationError != null) {
          return orderModificationError(
              this as Fragment$ErrorResult$$OrderModificationError);
        } else {
          return orElse();
        }

      case "OrderPaymentStateError":
        if (orderPaymentStateError != null) {
          return orderPaymentStateError(
              this as Fragment$ErrorResult$$OrderPaymentStateError);
        } else {
          return orElse();
        }

      case "OrderStateTransitionError":
        if (orderStateTransitionError != null) {
          return orderStateTransitionError(
              this as Fragment$ErrorResult$$OrderStateTransitionError);
        } else {
          return orElse();
        }

      case "PasswordAlreadySetError":
        if (passwordAlreadySetError != null) {
          return passwordAlreadySetError(
              this as Fragment$ErrorResult$$PasswordAlreadySetError);
        } else {
          return orElse();
        }

      case "PasswordResetTokenExpiredError":
        if (passwordResetTokenExpiredError != null) {
          return passwordResetTokenExpiredError(
              this as Fragment$ErrorResult$$PasswordResetTokenExpiredError);
        } else {
          return orElse();
        }

      case "PasswordResetTokenInvalidError":
        if (passwordResetTokenInvalidError != null) {
          return passwordResetTokenInvalidError(
              this as Fragment$ErrorResult$$PasswordResetTokenInvalidError);
        } else {
          return orElse();
        }

      case "PasswordValidationError":
        if (passwordValidationError != null) {
          return passwordValidationError(
              this as Fragment$ErrorResult$$PasswordValidationError);
        } else {
          return orElse();
        }

      case "PaymentDeclinedError":
        if (paymentDeclinedError != null) {
          return paymentDeclinedError(
              this as Fragment$ErrorResult$$PaymentDeclinedError);
        } else {
          return orElse();
        }

      case "PaymentFailedError":
        if (paymentFailedError != null) {
          return paymentFailedError(
              this as Fragment$ErrorResult$$PaymentFailedError);
        } else {
          return orElse();
        }

      case "VerificationTokenExpiredError":
        if (verificationTokenExpiredError != null) {
          return verificationTokenExpiredError(
              this as Fragment$ErrorResult$$VerificationTokenExpiredError);
        } else {
          return orElse();
        }

      case "VerificationTokenInvalidError":
        if (verificationTokenInvalidError != null) {
          return verificationTokenInvalidError(
              this as Fragment$ErrorResult$$VerificationTokenInvalidError);
        } else {
          return orElse();
        }

      case "QuantityLimitError":
        if (quantityLimitError != null) {
          return quantityLimitError(
              this as Fragment$ErrorResult$$QuantityLimitError);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Fragment$ErrorResult<TRes> {
  factory CopyWith$Fragment$ErrorResult(
    Fragment$ErrorResult instance,
    TRes Function(Fragment$ErrorResult) then,
  ) = _CopyWithImpl$Fragment$ErrorResult;

  factory CopyWith$Fragment$ErrorResult.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult<TRes>
    implements CopyWith$Fragment$ErrorResult<TRes> {
  _CopyWithImpl$Fragment$ErrorResult(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult _instance;

  final TRes Function(Fragment$ErrorResult) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult<TRes>
    implements CopyWith$Fragment$ErrorResult<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

const fragmentDefinitionErrorResult = FragmentDefinitionNode(
  name: NameNode(value: 'ErrorResult'),
  typeCondition: TypeConditionNode(
      on: NamedTypeNode(
    name: NameNode(value: 'ErrorResult'),
    isNonNull: false,
  )),
  directives: [],
  selectionSet: SelectionSetNode(selections: [
    FieldNode(
      name: NameNode(value: 'errorCode'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'message'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: '__typename'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
  ]),
);
const documentNodeFragmentErrorResult = DocumentNode(definitions: [
  fragmentDefinitionErrorResult,
]);

extension ClientExtension$Fragment$ErrorResult on graphql.GraphQLClient {
  void writeFragment$ErrorResult({
    required Fragment$ErrorResult data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) =>
      this.writeFragment(
        graphql.FragmentRequest(
          idFields: idFields,
          fragment: const graphql.Fragment(
            fragmentName: 'ErrorResult',
            document: documentNodeFragmentErrorResult,
          ),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Fragment$ErrorResult? readFragment$ErrorResult({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'ErrorResult',
          document: documentNodeFragmentErrorResult,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$ErrorResult.fromJson(result);
  }
}

class Fragment$ErrorResult$$AlreadyLoggedInError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$AlreadyLoggedInError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'AlreadyLoggedInError',
  });

  factory Fragment$ErrorResult$$AlreadyLoggedInError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$AlreadyLoggedInError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$AlreadyLoggedInError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$AlreadyLoggedInError
    on Fragment$ErrorResult$$AlreadyLoggedInError {
  CopyWith$Fragment$ErrorResult$$AlreadyLoggedInError<
          Fragment$ErrorResult$$AlreadyLoggedInError>
      get copyWith => CopyWith$Fragment$ErrorResult$$AlreadyLoggedInError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$AlreadyLoggedInError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$AlreadyLoggedInError(
    Fragment$ErrorResult$$AlreadyLoggedInError instance,
    TRes Function(Fragment$ErrorResult$$AlreadyLoggedInError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$AlreadyLoggedInError;

  factory CopyWith$Fragment$ErrorResult$$AlreadyLoggedInError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$AlreadyLoggedInError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$AlreadyLoggedInError<TRes>
    implements CopyWith$Fragment$ErrorResult$$AlreadyLoggedInError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$AlreadyLoggedInError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$AlreadyLoggedInError _instance;

  final TRes Function(Fragment$ErrorResult$$AlreadyLoggedInError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$AlreadyLoggedInError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$AlreadyLoggedInError<TRes>
    implements CopyWith$Fragment$ErrorResult$$AlreadyLoggedInError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$AlreadyLoggedInError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$CartContainsUnavailableItemsError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$CartContainsUnavailableItemsError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'CartContainsUnavailableItemsError',
  });

  factory Fragment$ErrorResult$$CartContainsUnavailableItemsError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$CartContainsUnavailableItemsError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$CartContainsUnavailableItemsError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$CartContainsUnavailableItemsError
    on Fragment$ErrorResult$$CartContainsUnavailableItemsError {
  CopyWith$Fragment$ErrorResult$$CartContainsUnavailableItemsError<
          Fragment$ErrorResult$$CartContainsUnavailableItemsError>
      get copyWith =>
          CopyWith$Fragment$ErrorResult$$CartContainsUnavailableItemsError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$CartContainsUnavailableItemsError<
    TRes> {
  factory CopyWith$Fragment$ErrorResult$$CartContainsUnavailableItemsError(
    Fragment$ErrorResult$$CartContainsUnavailableItemsError instance,
    TRes Function(Fragment$ErrorResult$$CartContainsUnavailableItemsError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$CartContainsUnavailableItemsError;

  factory CopyWith$Fragment$ErrorResult$$CartContainsUnavailableItemsError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$CartContainsUnavailableItemsError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$CartContainsUnavailableItemsError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$CartContainsUnavailableItemsError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$CartContainsUnavailableItemsError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$CartContainsUnavailableItemsError _instance;

  final TRes Function(Fragment$ErrorResult$$CartContainsUnavailableItemsError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$CartContainsUnavailableItemsError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$CartContainsUnavailableItemsError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$CartContainsUnavailableItemsError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$CartContainsUnavailableItemsError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$CouponCodeExpiredError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$CouponCodeExpiredError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'CouponCodeExpiredError',
  });

  factory Fragment$ErrorResult$$CouponCodeExpiredError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$CouponCodeExpiredError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$CouponCodeExpiredError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$CouponCodeExpiredError
    on Fragment$ErrorResult$$CouponCodeExpiredError {
  CopyWith$Fragment$ErrorResult$$CouponCodeExpiredError<
          Fragment$ErrorResult$$CouponCodeExpiredError>
      get copyWith => CopyWith$Fragment$ErrorResult$$CouponCodeExpiredError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$CouponCodeExpiredError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$CouponCodeExpiredError(
    Fragment$ErrorResult$$CouponCodeExpiredError instance,
    TRes Function(Fragment$ErrorResult$$CouponCodeExpiredError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$CouponCodeExpiredError;

  factory CopyWith$Fragment$ErrorResult$$CouponCodeExpiredError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$CouponCodeExpiredError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$CouponCodeExpiredError<TRes>
    implements CopyWith$Fragment$ErrorResult$$CouponCodeExpiredError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$CouponCodeExpiredError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$CouponCodeExpiredError _instance;

  final TRes Function(Fragment$ErrorResult$$CouponCodeExpiredError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$CouponCodeExpiredError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$CouponCodeExpiredError<TRes>
    implements CopyWith$Fragment$ErrorResult$$CouponCodeExpiredError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$CouponCodeExpiredError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$CouponCodeInvalidError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$CouponCodeInvalidError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'CouponCodeInvalidError',
  });

  factory Fragment$ErrorResult$$CouponCodeInvalidError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$CouponCodeInvalidError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$CouponCodeInvalidError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$CouponCodeInvalidError
    on Fragment$ErrorResult$$CouponCodeInvalidError {
  CopyWith$Fragment$ErrorResult$$CouponCodeInvalidError<
          Fragment$ErrorResult$$CouponCodeInvalidError>
      get copyWith => CopyWith$Fragment$ErrorResult$$CouponCodeInvalidError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$CouponCodeInvalidError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$CouponCodeInvalidError(
    Fragment$ErrorResult$$CouponCodeInvalidError instance,
    TRes Function(Fragment$ErrorResult$$CouponCodeInvalidError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$CouponCodeInvalidError;

  factory CopyWith$Fragment$ErrorResult$$CouponCodeInvalidError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$CouponCodeInvalidError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$CouponCodeInvalidError<TRes>
    implements CopyWith$Fragment$ErrorResult$$CouponCodeInvalidError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$CouponCodeInvalidError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$CouponCodeInvalidError _instance;

  final TRes Function(Fragment$ErrorResult$$CouponCodeInvalidError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$CouponCodeInvalidError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$CouponCodeInvalidError<TRes>
    implements CopyWith$Fragment$ErrorResult$$CouponCodeInvalidError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$CouponCodeInvalidError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$CouponCodeLimitError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$CouponCodeLimitError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'CouponCodeLimitError',
  });

  factory Fragment$ErrorResult$$CouponCodeLimitError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$CouponCodeLimitError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$CouponCodeLimitError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$CouponCodeLimitError
    on Fragment$ErrorResult$$CouponCodeLimitError {
  CopyWith$Fragment$ErrorResult$$CouponCodeLimitError<
          Fragment$ErrorResult$$CouponCodeLimitError>
      get copyWith => CopyWith$Fragment$ErrorResult$$CouponCodeLimitError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$CouponCodeLimitError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$CouponCodeLimitError(
    Fragment$ErrorResult$$CouponCodeLimitError instance,
    TRes Function(Fragment$ErrorResult$$CouponCodeLimitError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$CouponCodeLimitError;

  factory CopyWith$Fragment$ErrorResult$$CouponCodeLimitError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$CouponCodeLimitError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$CouponCodeLimitError<TRes>
    implements CopyWith$Fragment$ErrorResult$$CouponCodeLimitError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$CouponCodeLimitError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$CouponCodeLimitError _instance;

  final TRes Function(Fragment$ErrorResult$$CouponCodeLimitError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$CouponCodeLimitError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$CouponCodeLimitError<TRes>
    implements CopyWith$Fragment$ErrorResult$$CouponCodeLimitError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$CouponCodeLimitError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$EmailAddressConflictError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$EmailAddressConflictError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'EmailAddressConflictError',
  });

  factory Fragment$ErrorResult$$EmailAddressConflictError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$EmailAddressConflictError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$EmailAddressConflictError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$EmailAddressConflictError
    on Fragment$ErrorResult$$EmailAddressConflictError {
  CopyWith$Fragment$ErrorResult$$EmailAddressConflictError<
          Fragment$ErrorResult$$EmailAddressConflictError>
      get copyWith => CopyWith$Fragment$ErrorResult$$EmailAddressConflictError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$EmailAddressConflictError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$EmailAddressConflictError(
    Fragment$ErrorResult$$EmailAddressConflictError instance,
    TRes Function(Fragment$ErrorResult$$EmailAddressConflictError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$EmailAddressConflictError;

  factory CopyWith$Fragment$ErrorResult$$EmailAddressConflictError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$EmailAddressConflictError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$EmailAddressConflictError<TRes>
    implements CopyWith$Fragment$ErrorResult$$EmailAddressConflictError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$EmailAddressConflictError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$EmailAddressConflictError _instance;

  final TRes Function(Fragment$ErrorResult$$EmailAddressConflictError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$EmailAddressConflictError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$EmailAddressConflictError<TRes>
    implements CopyWith$Fragment$ErrorResult$$EmailAddressConflictError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$EmailAddressConflictError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$GuestCheckoutError implements Fragment$ErrorResult {
  Fragment$ErrorResult$$GuestCheckoutError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'GuestCheckoutError',
  });

  factory Fragment$ErrorResult$$GuestCheckoutError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$GuestCheckoutError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$GuestCheckoutError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$GuestCheckoutError
    on Fragment$ErrorResult$$GuestCheckoutError {
  CopyWith$Fragment$ErrorResult$$GuestCheckoutError<
          Fragment$ErrorResult$$GuestCheckoutError>
      get copyWith => CopyWith$Fragment$ErrorResult$$GuestCheckoutError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$GuestCheckoutError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$GuestCheckoutError(
    Fragment$ErrorResult$$GuestCheckoutError instance,
    TRes Function(Fragment$ErrorResult$$GuestCheckoutError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$GuestCheckoutError;

  factory CopyWith$Fragment$ErrorResult$$GuestCheckoutError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$GuestCheckoutError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$GuestCheckoutError<TRes>
    implements CopyWith$Fragment$ErrorResult$$GuestCheckoutError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$GuestCheckoutError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$GuestCheckoutError _instance;

  final TRes Function(Fragment$ErrorResult$$GuestCheckoutError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$GuestCheckoutError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$GuestCheckoutError<TRes>
    implements CopyWith$Fragment$ErrorResult$$GuestCheckoutError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$GuestCheckoutError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$IdentifierChangeTokenExpiredError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$IdentifierChangeTokenExpiredError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'IdentifierChangeTokenExpiredError',
  });

  factory Fragment$ErrorResult$$IdentifierChangeTokenExpiredError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$IdentifierChangeTokenExpiredError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$IdentifierChangeTokenExpiredError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError
    on Fragment$ErrorResult$$IdentifierChangeTokenExpiredError {
  CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError<
          Fragment$ErrorResult$$IdentifierChangeTokenExpiredError>
      get copyWith =>
          CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError<
    TRes> {
  factory CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError(
    Fragment$ErrorResult$$IdentifierChangeTokenExpiredError instance,
    TRes Function(Fragment$ErrorResult$$IdentifierChangeTokenExpiredError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError;

  factory CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$IdentifierChangeTokenExpiredError _instance;

  final TRes Function(Fragment$ErrorResult$$IdentifierChangeTokenExpiredError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$IdentifierChangeTokenExpiredError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$IdentifierChangeTokenExpiredError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$IdentifierChangeTokenInvalidError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$IdentifierChangeTokenInvalidError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'IdentifierChangeTokenInvalidError',
  });

  factory Fragment$ErrorResult$$IdentifierChangeTokenInvalidError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$IdentifierChangeTokenInvalidError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$IdentifierChangeTokenInvalidError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError
    on Fragment$ErrorResult$$IdentifierChangeTokenInvalidError {
  CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError<
          Fragment$ErrorResult$$IdentifierChangeTokenInvalidError>
      get copyWith =>
          CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError<
    TRes> {
  factory CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError(
    Fragment$ErrorResult$$IdentifierChangeTokenInvalidError instance,
    TRes Function(Fragment$ErrorResult$$IdentifierChangeTokenInvalidError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError;

  factory CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$IdentifierChangeTokenInvalidError _instance;

  final TRes Function(Fragment$ErrorResult$$IdentifierChangeTokenInvalidError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$IdentifierChangeTokenInvalidError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$IdentifierChangeTokenInvalidError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$IneligiblePaymentMethodError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$IneligiblePaymentMethodError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'IneligiblePaymentMethodError',
  });

  factory Fragment$ErrorResult$$IneligiblePaymentMethodError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$IneligiblePaymentMethodError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$IneligiblePaymentMethodError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$IneligiblePaymentMethodError
    on Fragment$ErrorResult$$IneligiblePaymentMethodError {
  CopyWith$Fragment$ErrorResult$$IneligiblePaymentMethodError<
          Fragment$ErrorResult$$IneligiblePaymentMethodError>
      get copyWith =>
          CopyWith$Fragment$ErrorResult$$IneligiblePaymentMethodError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$IneligiblePaymentMethodError<
    TRes> {
  factory CopyWith$Fragment$ErrorResult$$IneligiblePaymentMethodError(
    Fragment$ErrorResult$$IneligiblePaymentMethodError instance,
    TRes Function(Fragment$ErrorResult$$IneligiblePaymentMethodError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$IneligiblePaymentMethodError;

  factory CopyWith$Fragment$ErrorResult$$IneligiblePaymentMethodError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$IneligiblePaymentMethodError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$IneligiblePaymentMethodError<TRes>
    implements
        CopyWith$Fragment$ErrorResult$$IneligiblePaymentMethodError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$IneligiblePaymentMethodError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$IneligiblePaymentMethodError _instance;

  final TRes Function(Fragment$ErrorResult$$IneligiblePaymentMethodError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$IneligiblePaymentMethodError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$IneligiblePaymentMethodError<TRes>
    implements
        CopyWith$Fragment$ErrorResult$$IneligiblePaymentMethodError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$IneligiblePaymentMethodError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$IneligibleShippingMethodError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$IneligibleShippingMethodError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'IneligibleShippingMethodError',
  });

  factory Fragment$ErrorResult$$IneligibleShippingMethodError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$IneligibleShippingMethodError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$IneligibleShippingMethodError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$IneligibleShippingMethodError
    on Fragment$ErrorResult$$IneligibleShippingMethodError {
  CopyWith$Fragment$ErrorResult$$IneligibleShippingMethodError<
          Fragment$ErrorResult$$IneligibleShippingMethodError>
      get copyWith =>
          CopyWith$Fragment$ErrorResult$$IneligibleShippingMethodError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$IneligibleShippingMethodError<
    TRes> {
  factory CopyWith$Fragment$ErrorResult$$IneligibleShippingMethodError(
    Fragment$ErrorResult$$IneligibleShippingMethodError instance,
    TRes Function(Fragment$ErrorResult$$IneligibleShippingMethodError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$IneligibleShippingMethodError;

  factory CopyWith$Fragment$ErrorResult$$IneligibleShippingMethodError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$IneligibleShippingMethodError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$IneligibleShippingMethodError<TRes>
    implements
        CopyWith$Fragment$ErrorResult$$IneligibleShippingMethodError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$IneligibleShippingMethodError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$IneligibleShippingMethodError _instance;

  final TRes Function(Fragment$ErrorResult$$IneligibleShippingMethodError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$IneligibleShippingMethodError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$IneligibleShippingMethodError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$IneligibleShippingMethodError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$IneligibleShippingMethodError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$InsufficientStockError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$InsufficientStockError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'InsufficientStockError',
  });

  factory Fragment$ErrorResult$$InsufficientStockError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$InsufficientStockError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$InsufficientStockError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$InsufficientStockError
    on Fragment$ErrorResult$$InsufficientStockError {
  CopyWith$Fragment$ErrorResult$$InsufficientStockError<
          Fragment$ErrorResult$$InsufficientStockError>
      get copyWith => CopyWith$Fragment$ErrorResult$$InsufficientStockError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$InsufficientStockError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$InsufficientStockError(
    Fragment$ErrorResult$$InsufficientStockError instance,
    TRes Function(Fragment$ErrorResult$$InsufficientStockError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$InsufficientStockError;

  factory CopyWith$Fragment$ErrorResult$$InsufficientStockError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$InsufficientStockError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$InsufficientStockError<TRes>
    implements CopyWith$Fragment$ErrorResult$$InsufficientStockError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$InsufficientStockError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$InsufficientStockError _instance;

  final TRes Function(Fragment$ErrorResult$$InsufficientStockError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$InsufficientStockError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$InsufficientStockError<TRes>
    implements CopyWith$Fragment$ErrorResult$$InsufficientStockError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$InsufficientStockError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$InvalidCredentialsError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$InvalidCredentialsError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'InvalidCredentialsError',
  });

  factory Fragment$ErrorResult$$InvalidCredentialsError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$InvalidCredentialsError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$InvalidCredentialsError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$InvalidCredentialsError
    on Fragment$ErrorResult$$InvalidCredentialsError {
  CopyWith$Fragment$ErrorResult$$InvalidCredentialsError<
          Fragment$ErrorResult$$InvalidCredentialsError>
      get copyWith => CopyWith$Fragment$ErrorResult$$InvalidCredentialsError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$InvalidCredentialsError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$InvalidCredentialsError(
    Fragment$ErrorResult$$InvalidCredentialsError instance,
    TRes Function(Fragment$ErrorResult$$InvalidCredentialsError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$InvalidCredentialsError;

  factory CopyWith$Fragment$ErrorResult$$InvalidCredentialsError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$InvalidCredentialsError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$InvalidCredentialsError<TRes>
    implements CopyWith$Fragment$ErrorResult$$InvalidCredentialsError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$InvalidCredentialsError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$InvalidCredentialsError _instance;

  final TRes Function(Fragment$ErrorResult$$InvalidCredentialsError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$InvalidCredentialsError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$InvalidCredentialsError<TRes>
    implements CopyWith$Fragment$ErrorResult$$InvalidCredentialsError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$InvalidCredentialsError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$MissingPasswordError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$MissingPasswordError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'MissingPasswordError',
  });

  factory Fragment$ErrorResult$$MissingPasswordError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$MissingPasswordError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$MissingPasswordError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$MissingPasswordError
    on Fragment$ErrorResult$$MissingPasswordError {
  CopyWith$Fragment$ErrorResult$$MissingPasswordError<
          Fragment$ErrorResult$$MissingPasswordError>
      get copyWith => CopyWith$Fragment$ErrorResult$$MissingPasswordError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$MissingPasswordError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$MissingPasswordError(
    Fragment$ErrorResult$$MissingPasswordError instance,
    TRes Function(Fragment$ErrorResult$$MissingPasswordError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$MissingPasswordError;

  factory CopyWith$Fragment$ErrorResult$$MissingPasswordError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$MissingPasswordError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$MissingPasswordError<TRes>
    implements CopyWith$Fragment$ErrorResult$$MissingPasswordError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$MissingPasswordError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$MissingPasswordError _instance;

  final TRes Function(Fragment$ErrorResult$$MissingPasswordError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$MissingPasswordError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$MissingPasswordError<TRes>
    implements CopyWith$Fragment$ErrorResult$$MissingPasswordError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$MissingPasswordError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$NativeAuthStrategyError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$NativeAuthStrategyError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'NativeAuthStrategyError',
  });

  factory Fragment$ErrorResult$$NativeAuthStrategyError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$NativeAuthStrategyError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$NativeAuthStrategyError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$NativeAuthStrategyError
    on Fragment$ErrorResult$$NativeAuthStrategyError {
  CopyWith$Fragment$ErrorResult$$NativeAuthStrategyError<
          Fragment$ErrorResult$$NativeAuthStrategyError>
      get copyWith => CopyWith$Fragment$ErrorResult$$NativeAuthStrategyError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$NativeAuthStrategyError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$NativeAuthStrategyError(
    Fragment$ErrorResult$$NativeAuthStrategyError instance,
    TRes Function(Fragment$ErrorResult$$NativeAuthStrategyError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$NativeAuthStrategyError;

  factory CopyWith$Fragment$ErrorResult$$NativeAuthStrategyError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$NativeAuthStrategyError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$NativeAuthStrategyError<TRes>
    implements CopyWith$Fragment$ErrorResult$$NativeAuthStrategyError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$NativeAuthStrategyError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$NativeAuthStrategyError _instance;

  final TRes Function(Fragment$ErrorResult$$NativeAuthStrategyError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$NativeAuthStrategyError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$NativeAuthStrategyError<TRes>
    implements CopyWith$Fragment$ErrorResult$$NativeAuthStrategyError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$NativeAuthStrategyError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$NegativeQuantityError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$NegativeQuantityError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'NegativeQuantityError',
  });

  factory Fragment$ErrorResult$$NegativeQuantityError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$NegativeQuantityError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$NegativeQuantityError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$NegativeQuantityError
    on Fragment$ErrorResult$$NegativeQuantityError {
  CopyWith$Fragment$ErrorResult$$NegativeQuantityError<
          Fragment$ErrorResult$$NegativeQuantityError>
      get copyWith => CopyWith$Fragment$ErrorResult$$NegativeQuantityError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$NegativeQuantityError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$NegativeQuantityError(
    Fragment$ErrorResult$$NegativeQuantityError instance,
    TRes Function(Fragment$ErrorResult$$NegativeQuantityError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$NegativeQuantityError;

  factory CopyWith$Fragment$ErrorResult$$NegativeQuantityError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$NegativeQuantityError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$NegativeQuantityError<TRes>
    implements CopyWith$Fragment$ErrorResult$$NegativeQuantityError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$NegativeQuantityError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$NegativeQuantityError _instance;

  final TRes Function(Fragment$ErrorResult$$NegativeQuantityError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$NegativeQuantityError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$NegativeQuantityError<TRes>
    implements CopyWith$Fragment$ErrorResult$$NegativeQuantityError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$NegativeQuantityError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$NoActiveOrderError implements Fragment$ErrorResult {
  Fragment$ErrorResult$$NoActiveOrderError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'NoActiveOrderError',
  });

  factory Fragment$ErrorResult$$NoActiveOrderError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$NoActiveOrderError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$NoActiveOrderError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$NoActiveOrderError
    on Fragment$ErrorResult$$NoActiveOrderError {
  CopyWith$Fragment$ErrorResult$$NoActiveOrderError<
          Fragment$ErrorResult$$NoActiveOrderError>
      get copyWith => CopyWith$Fragment$ErrorResult$$NoActiveOrderError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$NoActiveOrderError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$NoActiveOrderError(
    Fragment$ErrorResult$$NoActiveOrderError instance,
    TRes Function(Fragment$ErrorResult$$NoActiveOrderError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$NoActiveOrderError;

  factory CopyWith$Fragment$ErrorResult$$NoActiveOrderError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$NoActiveOrderError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$NoActiveOrderError<TRes>
    implements CopyWith$Fragment$ErrorResult$$NoActiveOrderError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$NoActiveOrderError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$NoActiveOrderError _instance;

  final TRes Function(Fragment$ErrorResult$$NoActiveOrderError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$NoActiveOrderError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$NoActiveOrderError<TRes>
    implements CopyWith$Fragment$ErrorResult$$NoActiveOrderError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$NoActiveOrderError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$NotVerifiedError implements Fragment$ErrorResult {
  Fragment$ErrorResult$$NotVerifiedError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'NotVerifiedError',
  });

  factory Fragment$ErrorResult$$NotVerifiedError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$NotVerifiedError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$NotVerifiedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$NotVerifiedError
    on Fragment$ErrorResult$$NotVerifiedError {
  CopyWith$Fragment$ErrorResult$$NotVerifiedError<
          Fragment$ErrorResult$$NotVerifiedError>
      get copyWith => CopyWith$Fragment$ErrorResult$$NotVerifiedError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$NotVerifiedError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$NotVerifiedError(
    Fragment$ErrorResult$$NotVerifiedError instance,
    TRes Function(Fragment$ErrorResult$$NotVerifiedError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$NotVerifiedError;

  factory CopyWith$Fragment$ErrorResult$$NotVerifiedError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$NotVerifiedError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$NotVerifiedError<TRes>
    implements CopyWith$Fragment$ErrorResult$$NotVerifiedError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$NotVerifiedError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$NotVerifiedError _instance;

  final TRes Function(Fragment$ErrorResult$$NotVerifiedError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$NotVerifiedError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$NotVerifiedError<TRes>
    implements CopyWith$Fragment$ErrorResult$$NotVerifiedError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$NotVerifiedError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$OrderInterceptorError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$OrderInterceptorError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'OrderInterceptorError',
  });

  factory Fragment$ErrorResult$$OrderInterceptorError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$OrderInterceptorError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$OrderInterceptorError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$OrderInterceptorError
    on Fragment$ErrorResult$$OrderInterceptorError {
  CopyWith$Fragment$ErrorResult$$OrderInterceptorError<
          Fragment$ErrorResult$$OrderInterceptorError>
      get copyWith => CopyWith$Fragment$ErrorResult$$OrderInterceptorError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$OrderInterceptorError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$OrderInterceptorError(
    Fragment$ErrorResult$$OrderInterceptorError instance,
    TRes Function(Fragment$ErrorResult$$OrderInterceptorError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$OrderInterceptorError;

  factory CopyWith$Fragment$ErrorResult$$OrderInterceptorError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$OrderInterceptorError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$OrderInterceptorError<TRes>
    implements CopyWith$Fragment$ErrorResult$$OrderInterceptorError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$OrderInterceptorError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$OrderInterceptorError _instance;

  final TRes Function(Fragment$ErrorResult$$OrderInterceptorError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$OrderInterceptorError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$OrderInterceptorError<TRes>
    implements CopyWith$Fragment$ErrorResult$$OrderInterceptorError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$OrderInterceptorError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$OrderLimitError implements Fragment$ErrorResult {
  Fragment$ErrorResult$$OrderLimitError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'OrderLimitError',
  });

  factory Fragment$ErrorResult$$OrderLimitError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$OrderLimitError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$OrderLimitError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$OrderLimitError
    on Fragment$ErrorResult$$OrderLimitError {
  CopyWith$Fragment$ErrorResult$$OrderLimitError<
          Fragment$ErrorResult$$OrderLimitError>
      get copyWith => CopyWith$Fragment$ErrorResult$$OrderLimitError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$OrderLimitError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$OrderLimitError(
    Fragment$ErrorResult$$OrderLimitError instance,
    TRes Function(Fragment$ErrorResult$$OrderLimitError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$OrderLimitError;

  factory CopyWith$Fragment$ErrorResult$$OrderLimitError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$OrderLimitError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$OrderLimitError<TRes>
    implements CopyWith$Fragment$ErrorResult$$OrderLimitError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$OrderLimitError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$OrderLimitError _instance;

  final TRes Function(Fragment$ErrorResult$$OrderLimitError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$OrderLimitError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$OrderLimitError<TRes>
    implements CopyWith$Fragment$ErrorResult$$OrderLimitError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$OrderLimitError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$OrderModificationError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$OrderModificationError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'OrderModificationError',
  });

  factory Fragment$ErrorResult$$OrderModificationError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$OrderModificationError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$OrderModificationError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$OrderModificationError
    on Fragment$ErrorResult$$OrderModificationError {
  CopyWith$Fragment$ErrorResult$$OrderModificationError<
          Fragment$ErrorResult$$OrderModificationError>
      get copyWith => CopyWith$Fragment$ErrorResult$$OrderModificationError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$OrderModificationError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$OrderModificationError(
    Fragment$ErrorResult$$OrderModificationError instance,
    TRes Function(Fragment$ErrorResult$$OrderModificationError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$OrderModificationError;

  factory CopyWith$Fragment$ErrorResult$$OrderModificationError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$OrderModificationError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$OrderModificationError<TRes>
    implements CopyWith$Fragment$ErrorResult$$OrderModificationError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$OrderModificationError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$OrderModificationError _instance;

  final TRes Function(Fragment$ErrorResult$$OrderModificationError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$OrderModificationError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$OrderModificationError<TRes>
    implements CopyWith$Fragment$ErrorResult$$OrderModificationError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$OrderModificationError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$OrderPaymentStateError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$OrderPaymentStateError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'OrderPaymentStateError',
  });

  factory Fragment$ErrorResult$$OrderPaymentStateError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$OrderPaymentStateError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$OrderPaymentStateError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$OrderPaymentStateError
    on Fragment$ErrorResult$$OrderPaymentStateError {
  CopyWith$Fragment$ErrorResult$$OrderPaymentStateError<
          Fragment$ErrorResult$$OrderPaymentStateError>
      get copyWith => CopyWith$Fragment$ErrorResult$$OrderPaymentStateError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$OrderPaymentStateError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$OrderPaymentStateError(
    Fragment$ErrorResult$$OrderPaymentStateError instance,
    TRes Function(Fragment$ErrorResult$$OrderPaymentStateError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$OrderPaymentStateError;

  factory CopyWith$Fragment$ErrorResult$$OrderPaymentStateError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$OrderPaymentStateError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$OrderPaymentStateError<TRes>
    implements CopyWith$Fragment$ErrorResult$$OrderPaymentStateError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$OrderPaymentStateError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$OrderPaymentStateError _instance;

  final TRes Function(Fragment$ErrorResult$$OrderPaymentStateError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$OrderPaymentStateError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$OrderPaymentStateError<TRes>
    implements CopyWith$Fragment$ErrorResult$$OrderPaymentStateError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$OrderPaymentStateError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$OrderStateTransitionError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$OrderStateTransitionError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'OrderStateTransitionError',
  });

  factory Fragment$ErrorResult$$OrderStateTransitionError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$OrderStateTransitionError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$OrderStateTransitionError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$OrderStateTransitionError
    on Fragment$ErrorResult$$OrderStateTransitionError {
  CopyWith$Fragment$ErrorResult$$OrderStateTransitionError<
          Fragment$ErrorResult$$OrderStateTransitionError>
      get copyWith => CopyWith$Fragment$ErrorResult$$OrderStateTransitionError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$OrderStateTransitionError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$OrderStateTransitionError(
    Fragment$ErrorResult$$OrderStateTransitionError instance,
    TRes Function(Fragment$ErrorResult$$OrderStateTransitionError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$OrderStateTransitionError;

  factory CopyWith$Fragment$ErrorResult$$OrderStateTransitionError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$OrderStateTransitionError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$OrderStateTransitionError<TRes>
    implements CopyWith$Fragment$ErrorResult$$OrderStateTransitionError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$OrderStateTransitionError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$OrderStateTransitionError _instance;

  final TRes Function(Fragment$ErrorResult$$OrderStateTransitionError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$OrderStateTransitionError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$OrderStateTransitionError<TRes>
    implements CopyWith$Fragment$ErrorResult$$OrderStateTransitionError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$OrderStateTransitionError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$PasswordAlreadySetError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$PasswordAlreadySetError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'PasswordAlreadySetError',
  });

  factory Fragment$ErrorResult$$PasswordAlreadySetError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$PasswordAlreadySetError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$PasswordAlreadySetError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$PasswordAlreadySetError
    on Fragment$ErrorResult$$PasswordAlreadySetError {
  CopyWith$Fragment$ErrorResult$$PasswordAlreadySetError<
          Fragment$ErrorResult$$PasswordAlreadySetError>
      get copyWith => CopyWith$Fragment$ErrorResult$$PasswordAlreadySetError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$PasswordAlreadySetError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$PasswordAlreadySetError(
    Fragment$ErrorResult$$PasswordAlreadySetError instance,
    TRes Function(Fragment$ErrorResult$$PasswordAlreadySetError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$PasswordAlreadySetError;

  factory CopyWith$Fragment$ErrorResult$$PasswordAlreadySetError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$PasswordAlreadySetError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$PasswordAlreadySetError<TRes>
    implements CopyWith$Fragment$ErrorResult$$PasswordAlreadySetError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$PasswordAlreadySetError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$PasswordAlreadySetError _instance;

  final TRes Function(Fragment$ErrorResult$$PasswordAlreadySetError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$PasswordAlreadySetError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$PasswordAlreadySetError<TRes>
    implements CopyWith$Fragment$ErrorResult$$PasswordAlreadySetError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$PasswordAlreadySetError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$PasswordResetTokenExpiredError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$PasswordResetTokenExpiredError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'PasswordResetTokenExpiredError',
  });

  factory Fragment$ErrorResult$$PasswordResetTokenExpiredError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$PasswordResetTokenExpiredError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$PasswordResetTokenExpiredError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$PasswordResetTokenExpiredError
    on Fragment$ErrorResult$$PasswordResetTokenExpiredError {
  CopyWith$Fragment$ErrorResult$$PasswordResetTokenExpiredError<
          Fragment$ErrorResult$$PasswordResetTokenExpiredError>
      get copyWith =>
          CopyWith$Fragment$ErrorResult$$PasswordResetTokenExpiredError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$PasswordResetTokenExpiredError<
    TRes> {
  factory CopyWith$Fragment$ErrorResult$$PasswordResetTokenExpiredError(
    Fragment$ErrorResult$$PasswordResetTokenExpiredError instance,
    TRes Function(Fragment$ErrorResult$$PasswordResetTokenExpiredError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$PasswordResetTokenExpiredError;

  factory CopyWith$Fragment$ErrorResult$$PasswordResetTokenExpiredError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$PasswordResetTokenExpiredError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$PasswordResetTokenExpiredError<TRes>
    implements
        CopyWith$Fragment$ErrorResult$$PasswordResetTokenExpiredError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$PasswordResetTokenExpiredError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$PasswordResetTokenExpiredError _instance;

  final TRes Function(Fragment$ErrorResult$$PasswordResetTokenExpiredError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$PasswordResetTokenExpiredError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$PasswordResetTokenExpiredError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$PasswordResetTokenExpiredError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$PasswordResetTokenExpiredError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$PasswordResetTokenInvalidError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$PasswordResetTokenInvalidError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'PasswordResetTokenInvalidError',
  });

  factory Fragment$ErrorResult$$PasswordResetTokenInvalidError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$PasswordResetTokenInvalidError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$PasswordResetTokenInvalidError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$PasswordResetTokenInvalidError
    on Fragment$ErrorResult$$PasswordResetTokenInvalidError {
  CopyWith$Fragment$ErrorResult$$PasswordResetTokenInvalidError<
          Fragment$ErrorResult$$PasswordResetTokenInvalidError>
      get copyWith =>
          CopyWith$Fragment$ErrorResult$$PasswordResetTokenInvalidError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$PasswordResetTokenInvalidError<
    TRes> {
  factory CopyWith$Fragment$ErrorResult$$PasswordResetTokenInvalidError(
    Fragment$ErrorResult$$PasswordResetTokenInvalidError instance,
    TRes Function(Fragment$ErrorResult$$PasswordResetTokenInvalidError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$PasswordResetTokenInvalidError;

  factory CopyWith$Fragment$ErrorResult$$PasswordResetTokenInvalidError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$PasswordResetTokenInvalidError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$PasswordResetTokenInvalidError<TRes>
    implements
        CopyWith$Fragment$ErrorResult$$PasswordResetTokenInvalidError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$PasswordResetTokenInvalidError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$PasswordResetTokenInvalidError _instance;

  final TRes Function(Fragment$ErrorResult$$PasswordResetTokenInvalidError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$PasswordResetTokenInvalidError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$PasswordResetTokenInvalidError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$PasswordResetTokenInvalidError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$PasswordResetTokenInvalidError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$PasswordValidationError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$PasswordValidationError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'PasswordValidationError',
  });

  factory Fragment$ErrorResult$$PasswordValidationError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$PasswordValidationError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$PasswordValidationError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$PasswordValidationError
    on Fragment$ErrorResult$$PasswordValidationError {
  CopyWith$Fragment$ErrorResult$$PasswordValidationError<
          Fragment$ErrorResult$$PasswordValidationError>
      get copyWith => CopyWith$Fragment$ErrorResult$$PasswordValidationError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$PasswordValidationError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$PasswordValidationError(
    Fragment$ErrorResult$$PasswordValidationError instance,
    TRes Function(Fragment$ErrorResult$$PasswordValidationError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$PasswordValidationError;

  factory CopyWith$Fragment$ErrorResult$$PasswordValidationError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$PasswordValidationError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$PasswordValidationError<TRes>
    implements CopyWith$Fragment$ErrorResult$$PasswordValidationError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$PasswordValidationError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$PasswordValidationError _instance;

  final TRes Function(Fragment$ErrorResult$$PasswordValidationError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$PasswordValidationError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$PasswordValidationError<TRes>
    implements CopyWith$Fragment$ErrorResult$$PasswordValidationError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$PasswordValidationError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$PaymentDeclinedError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$PaymentDeclinedError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'PaymentDeclinedError',
  });

  factory Fragment$ErrorResult$$PaymentDeclinedError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$PaymentDeclinedError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$PaymentDeclinedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$PaymentDeclinedError
    on Fragment$ErrorResult$$PaymentDeclinedError {
  CopyWith$Fragment$ErrorResult$$PaymentDeclinedError<
          Fragment$ErrorResult$$PaymentDeclinedError>
      get copyWith => CopyWith$Fragment$ErrorResult$$PaymentDeclinedError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$PaymentDeclinedError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$PaymentDeclinedError(
    Fragment$ErrorResult$$PaymentDeclinedError instance,
    TRes Function(Fragment$ErrorResult$$PaymentDeclinedError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$PaymentDeclinedError;

  factory CopyWith$Fragment$ErrorResult$$PaymentDeclinedError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$PaymentDeclinedError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$PaymentDeclinedError<TRes>
    implements CopyWith$Fragment$ErrorResult$$PaymentDeclinedError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$PaymentDeclinedError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$PaymentDeclinedError _instance;

  final TRes Function(Fragment$ErrorResult$$PaymentDeclinedError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$PaymentDeclinedError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$PaymentDeclinedError<TRes>
    implements CopyWith$Fragment$ErrorResult$$PaymentDeclinedError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$PaymentDeclinedError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$PaymentFailedError implements Fragment$ErrorResult {
  Fragment$ErrorResult$$PaymentFailedError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'PaymentFailedError',
  });

  factory Fragment$ErrorResult$$PaymentFailedError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$PaymentFailedError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$PaymentFailedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$PaymentFailedError
    on Fragment$ErrorResult$$PaymentFailedError {
  CopyWith$Fragment$ErrorResult$$PaymentFailedError<
          Fragment$ErrorResult$$PaymentFailedError>
      get copyWith => CopyWith$Fragment$ErrorResult$$PaymentFailedError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$PaymentFailedError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$PaymentFailedError(
    Fragment$ErrorResult$$PaymentFailedError instance,
    TRes Function(Fragment$ErrorResult$$PaymentFailedError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$PaymentFailedError;

  factory CopyWith$Fragment$ErrorResult$$PaymentFailedError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$PaymentFailedError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$PaymentFailedError<TRes>
    implements CopyWith$Fragment$ErrorResult$$PaymentFailedError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$PaymentFailedError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$PaymentFailedError _instance;

  final TRes Function(Fragment$ErrorResult$$PaymentFailedError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$PaymentFailedError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$PaymentFailedError<TRes>
    implements CopyWith$Fragment$ErrorResult$$PaymentFailedError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$PaymentFailedError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$VerificationTokenExpiredError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$VerificationTokenExpiredError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'VerificationTokenExpiredError',
  });

  factory Fragment$ErrorResult$$VerificationTokenExpiredError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$VerificationTokenExpiredError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$VerificationTokenExpiredError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$VerificationTokenExpiredError
    on Fragment$ErrorResult$$VerificationTokenExpiredError {
  CopyWith$Fragment$ErrorResult$$VerificationTokenExpiredError<
          Fragment$ErrorResult$$VerificationTokenExpiredError>
      get copyWith =>
          CopyWith$Fragment$ErrorResult$$VerificationTokenExpiredError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$VerificationTokenExpiredError<
    TRes> {
  factory CopyWith$Fragment$ErrorResult$$VerificationTokenExpiredError(
    Fragment$ErrorResult$$VerificationTokenExpiredError instance,
    TRes Function(Fragment$ErrorResult$$VerificationTokenExpiredError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$VerificationTokenExpiredError;

  factory CopyWith$Fragment$ErrorResult$$VerificationTokenExpiredError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$VerificationTokenExpiredError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$VerificationTokenExpiredError<TRes>
    implements
        CopyWith$Fragment$ErrorResult$$VerificationTokenExpiredError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$VerificationTokenExpiredError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$VerificationTokenExpiredError _instance;

  final TRes Function(Fragment$ErrorResult$$VerificationTokenExpiredError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$VerificationTokenExpiredError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$VerificationTokenExpiredError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$VerificationTokenExpiredError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$VerificationTokenExpiredError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$VerificationTokenInvalidError
    implements Fragment$ErrorResult {
  Fragment$ErrorResult$$VerificationTokenInvalidError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'VerificationTokenInvalidError',
  });

  factory Fragment$ErrorResult$$VerificationTokenInvalidError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$VerificationTokenInvalidError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$VerificationTokenInvalidError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$VerificationTokenInvalidError
    on Fragment$ErrorResult$$VerificationTokenInvalidError {
  CopyWith$Fragment$ErrorResult$$VerificationTokenInvalidError<
          Fragment$ErrorResult$$VerificationTokenInvalidError>
      get copyWith =>
          CopyWith$Fragment$ErrorResult$$VerificationTokenInvalidError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$VerificationTokenInvalidError<
    TRes> {
  factory CopyWith$Fragment$ErrorResult$$VerificationTokenInvalidError(
    Fragment$ErrorResult$$VerificationTokenInvalidError instance,
    TRes Function(Fragment$ErrorResult$$VerificationTokenInvalidError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$VerificationTokenInvalidError;

  factory CopyWith$Fragment$ErrorResult$$VerificationTokenInvalidError.stub(
          TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$VerificationTokenInvalidError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$VerificationTokenInvalidError<TRes>
    implements
        CopyWith$Fragment$ErrorResult$$VerificationTokenInvalidError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$VerificationTokenInvalidError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$VerificationTokenInvalidError _instance;

  final TRes Function(Fragment$ErrorResult$$VerificationTokenInvalidError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$VerificationTokenInvalidError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$VerificationTokenInvalidError<
        TRes>
    implements
        CopyWith$Fragment$ErrorResult$$VerificationTokenInvalidError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$VerificationTokenInvalidError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Fragment$ErrorResult$$QuantityLimitError implements Fragment$ErrorResult {
  Fragment$ErrorResult$$QuantityLimitError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'QuantityLimitError',
  });

  factory Fragment$ErrorResult$$QuantityLimitError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorResult$$QuantityLimitError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ErrorResult$$QuantityLimitError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ErrorResult$$QuantityLimitError
    on Fragment$ErrorResult$$QuantityLimitError {
  CopyWith$Fragment$ErrorResult$$QuantityLimitError<
          Fragment$ErrorResult$$QuantityLimitError>
      get copyWith => CopyWith$Fragment$ErrorResult$$QuantityLimitError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Fragment$ErrorResult$$QuantityLimitError<TRes> {
  factory CopyWith$Fragment$ErrorResult$$QuantityLimitError(
    Fragment$ErrorResult$$QuantityLimitError instance,
    TRes Function(Fragment$ErrorResult$$QuantityLimitError) then,
  ) = _CopyWithImpl$Fragment$ErrorResult$$QuantityLimitError;

  factory CopyWith$Fragment$ErrorResult$$QuantityLimitError.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ErrorResult$$QuantityLimitError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$ErrorResult$$QuantityLimitError<TRes>
    implements CopyWith$Fragment$ErrorResult$$QuantityLimitError<TRes> {
  _CopyWithImpl$Fragment$ErrorResult$$QuantityLimitError(
    this._instance,
    this._then,
  );

  final Fragment$ErrorResult$$QuantityLimitError _instance;

  final TRes Function(Fragment$ErrorResult$$QuantityLimitError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$ErrorResult$$QuantityLimitError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$ErrorResult$$QuantityLimitError<TRes>
    implements CopyWith$Fragment$ErrorResult$$QuantityLimitError<TRes> {
  _CopyWithStubImpl$Fragment$ErrorResult$$QuantityLimitError(this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Mutation$AddToCart {
  factory Variables$Mutation$AddToCart({
    required String variantId,
    required int qty,
  }) =>
      Variables$Mutation$AddToCart._({
        r'variantId': variantId,
        r'qty': qty,
      });

  Variables$Mutation$AddToCart._(this._$data);

  factory Variables$Mutation$AddToCart.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$variantId = data['variantId'];
    result$data['variantId'] = (l$variantId as String);
    final l$qty = data['qty'];
    result$data['qty'] = (l$qty as int);
    return Variables$Mutation$AddToCart._(result$data);
  }

  Map<String, dynamic> _$data;

  String get variantId => (_$data['variantId'] as String);

  int get qty => (_$data['qty'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$variantId = variantId;
    result$data['variantId'] = l$variantId;
    final l$qty = qty;
    result$data['qty'] = l$qty;
    return result$data;
  }

  CopyWith$Variables$Mutation$AddToCart<Variables$Mutation$AddToCart>
      get copyWith => CopyWith$Variables$Mutation$AddToCart(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$AddToCart ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$variantId = variantId;
    final lOther$variantId = other.variantId;
    if (l$variantId != lOther$variantId) {
      return false;
    }
    final l$qty = qty;
    final lOther$qty = other.qty;
    if (l$qty != lOther$qty) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$variantId = variantId;
    final l$qty = qty;
    return Object.hashAll([
      l$variantId,
      l$qty,
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$AddToCart<TRes> {
  factory CopyWith$Variables$Mutation$AddToCart(
    Variables$Mutation$AddToCart instance,
    TRes Function(Variables$Mutation$AddToCart) then,
  ) = _CopyWithImpl$Variables$Mutation$AddToCart;

  factory CopyWith$Variables$Mutation$AddToCart.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$AddToCart;

  TRes call({
    String? variantId,
    int? qty,
  });
}

class _CopyWithImpl$Variables$Mutation$AddToCart<TRes>
    implements CopyWith$Variables$Mutation$AddToCart<TRes> {
  _CopyWithImpl$Variables$Mutation$AddToCart(
    this._instance,
    this._then,
  );

  final Variables$Mutation$AddToCart _instance;

  final TRes Function(Variables$Mutation$AddToCart) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? variantId = _undefined,
    Object? qty = _undefined,
  }) =>
      _then(Variables$Mutation$AddToCart._({
        ..._instance._$data,
        if (variantId != _undefined && variantId != null)
          'variantId': (variantId as String),
        if (qty != _undefined && qty != null) 'qty': (qty as int),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$AddToCart<TRes>
    implements CopyWith$Variables$Mutation$AddToCart<TRes> {
  _CopyWithStubImpl$Variables$Mutation$AddToCart(this._res);

  TRes _res;

  call({
    String? variantId,
    int? qty,
  }) =>
      _res;
}

class Mutation$AddToCart {
  Mutation$AddToCart({
    required this.addItemToOrder,
    this.$__typename = 'Mutation',
  });

  factory Mutation$AddToCart.fromJson(Map<String, dynamic> json) {
    final l$addItemToOrder = json['addItemToOrder'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart(
      addItemToOrder: Mutation$AddToCart$addItemToOrder.fromJson(
          (l$addItemToOrder as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$AddToCart$addItemToOrder addItemToOrder;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$addItemToOrder = addItemToOrder;
    _resultData['addItemToOrder'] = l$addItemToOrder.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$addItemToOrder = addItemToOrder;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$addItemToOrder,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart || runtimeType != other.runtimeType) {
      return false;
    }
    final l$addItemToOrder = addItemToOrder;
    final lOther$addItemToOrder = other.addItemToOrder;
    if (l$addItemToOrder != lOther$addItemToOrder) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart on Mutation$AddToCart {
  CopyWith$Mutation$AddToCart<Mutation$AddToCart> get copyWith =>
      CopyWith$Mutation$AddToCart(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$AddToCart<TRes> {
  factory CopyWith$Mutation$AddToCart(
    Mutation$AddToCart instance,
    TRes Function(Mutation$AddToCart) then,
  ) = _CopyWithImpl$Mutation$AddToCart;

  factory CopyWith$Mutation$AddToCart.stub(TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart;

  TRes call({
    Mutation$AddToCart$addItemToOrder? addItemToOrder,
    String? $__typename,
  });
  CopyWith$Mutation$AddToCart$addItemToOrder<TRes> get addItemToOrder;
}

class _CopyWithImpl$Mutation$AddToCart<TRes>
    implements CopyWith$Mutation$AddToCart<TRes> {
  _CopyWithImpl$Mutation$AddToCart(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart _instance;

  final TRes Function(Mutation$AddToCart) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? addItemToOrder = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart(
        addItemToOrder: addItemToOrder == _undefined || addItemToOrder == null
            ? _instance.addItemToOrder
            : (addItemToOrder as Mutation$AddToCart$addItemToOrder),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$AddToCart$addItemToOrder<TRes> get addItemToOrder {
    final local$addItemToOrder = _instance.addItemToOrder;
    return CopyWith$Mutation$AddToCart$addItemToOrder(
        local$addItemToOrder, (e) => call(addItemToOrder: e));
  }
}

class _CopyWithStubImpl$Mutation$AddToCart<TRes>
    implements CopyWith$Mutation$AddToCart<TRes> {
  _CopyWithStubImpl$Mutation$AddToCart(this._res);

  TRes _res;

  call({
    Mutation$AddToCart$addItemToOrder? addItemToOrder,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$AddToCart$addItemToOrder<TRes> get addItemToOrder =>
      CopyWith$Mutation$AddToCart$addItemToOrder.stub(_res);
}

const documentNodeMutationAddToCart = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'AddToCart'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'variantId')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'qty')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'addItemToOrder'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'productVariantId'),
            value: VariableNode(name: NameNode(value: 'variantId')),
          ),
          ArgumentNode(
            name: NameNode(value: 'quantity'),
            value: VariableNode(name: NameNode(value: 'qty')),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FragmentSpreadNode(
            name: NameNode(value: 'Cart'),
            directives: [],
          ),
          FragmentSpreadNode(
            name: NameNode(value: 'ErrorResult'),
            directives: [],
          ),
          InlineFragmentNode(
            typeCondition: TypeConditionNode(
                on: NamedTypeNode(
              name: NameNode(value: 'InsufficientStockError'),
              isNonNull: false,
            )),
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'order'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
                  FragmentSpreadNode(
                    name: NameNode(value: 'Cart'),
                    directives: [],
                  ),
                  FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ]),
              ),
              FieldNode(
                name: NameNode(value: '__typename'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
            ]),
          ),
          InlineFragmentNode(
            typeCondition: TypeConditionNode(
                on: NamedTypeNode(
              name: NameNode(value: 'OrderInterceptorError'),
              isNonNull: false,
            )),
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'interceptorError'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'errorCode'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'message'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: '__typename'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
            ]),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ]),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
  fragmentDefinitionCart,
  fragmentDefinitionErrorResult,
  fragmentDefinitionAsset,
]);
Mutation$AddToCart _parserFn$Mutation$AddToCart(Map<String, dynamic> data) =>
    Mutation$AddToCart.fromJson(data);
typedef OnMutationCompleted$Mutation$AddToCart = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$AddToCart?,
);

class Options$Mutation$AddToCart
    extends graphql.MutationOptions<Mutation$AddToCart> {
  Options$Mutation$AddToCart({
    String? operationName,
    required Variables$Mutation$AddToCart variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$AddToCart? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$AddToCart? onCompleted,
    graphql.OnMutationUpdate<Mutation$AddToCart>? update,
    graphql.OnError? onError,
  })  : onCompletedWithParsed = onCompleted,
        super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          onCompleted: onCompleted == null
              ? null
              : (data) => onCompleted(
                    data,
                    data == null ? null : _parserFn$Mutation$AddToCart(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationAddToCart,
          parserFn: _parserFn$Mutation$AddToCart,
        );

  final OnMutationCompleted$Mutation$AddToCart? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$AddToCart
    extends graphql.WatchQueryOptions<Mutation$AddToCart> {
  WatchOptions$Mutation$AddToCart({
    String? operationName,
    required Variables$Mutation$AddToCart variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$AddToCart? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          document: documentNodeMutationAddToCart,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$AddToCart,
        );
}

extension ClientExtension$Mutation$AddToCart on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$AddToCart>> mutate$AddToCart(
          Options$Mutation$AddToCart options) async =>
      await this.mutate(options);
  graphql.ObservableQuery<Mutation$AddToCart> watchMutation$AddToCart(
          WatchOptions$Mutation$AddToCart options) =>
      this.watchMutation(options);
}

class Mutation$AddToCart$HookResult {
  Mutation$AddToCart$HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation$Mutation$AddToCart runMutation;

  final graphql.QueryResult<Mutation$AddToCart> result;
}

Mutation$AddToCart$HookResult useMutation$AddToCart(
    [WidgetOptions$Mutation$AddToCart? options]) {
  final result = graphql_flutter
      .useMutation(options ?? WidgetOptions$Mutation$AddToCart());
  return Mutation$AddToCart$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
      variables.toJson(),
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$AddToCart> useWatchMutation$AddToCart(
        WatchOptions$Mutation$AddToCart options) =>
    graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$AddToCart
    extends graphql.MutationOptions<Mutation$AddToCart> {
  WidgetOptions$Mutation$AddToCart({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$AddToCart? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$AddToCart? onCompleted,
    graphql.OnMutationUpdate<Mutation$AddToCart>? update,
    graphql.OnError? onError,
  })  : onCompletedWithParsed = onCompleted,
        super(
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          onCompleted: onCompleted == null
              ? null
              : (data) => onCompleted(
                    data,
                    data == null ? null : _parserFn$Mutation$AddToCart(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationAddToCart,
          parserFn: _parserFn$Mutation$AddToCart,
        );

  final OnMutationCompleted$Mutation$AddToCart? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

typedef RunMutation$Mutation$AddToCart
    = graphql.MultiSourceResult<Mutation$AddToCart> Function(
  Variables$Mutation$AddToCart, {
  Object? optimisticResult,
  Mutation$AddToCart? typedOptimisticResult,
});
typedef Builder$Mutation$AddToCart = widgets.Widget Function(
  RunMutation$Mutation$AddToCart,
  graphql.QueryResult<Mutation$AddToCart>?,
);

class Mutation$AddToCart$Widget
    extends graphql_flutter.Mutation<Mutation$AddToCart> {
  Mutation$AddToCart$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$AddToCart? options,
    required Builder$Mutation$AddToCart builder,
  }) : super(
          key: key,
          options: options ?? WidgetOptions$Mutation$AddToCart(),
          builder: (
            run,
            result,
          ) =>
              builder(
            (
              variables, {
              optimisticResult,
              typedOptimisticResult,
            }) =>
                run(
              variables.toJson(),
              optimisticResult:
                  optimisticResult ?? typedOptimisticResult?.toJson(),
            ),
            result,
          ),
        );
}

class Mutation$AddToCart$addItemToOrder {
  Mutation$AddToCart$addItemToOrder({required this.$__typename});

  factory Mutation$AddToCart$addItemToOrder.fromJson(
      Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "InsufficientStockError":
        return Mutation$AddToCart$addItemToOrder$$InsufficientStockError
            .fromJson(json);

      case "OrderInterceptorError":
        return Mutation$AddToCart$addItemToOrder$$OrderInterceptorError
            .fromJson(json);

      case "Order":
        return Mutation$AddToCart$addItemToOrder$$Order.fromJson(json);

      case "OrderModificationError":
        return Mutation$AddToCart$addItemToOrder$$OrderModificationError
            .fromJson(json);

      case "OrderLimitError":
        return Mutation$AddToCart$addItemToOrder$$OrderLimitError.fromJson(
            json);

      case "NegativeQuantityError":
        return Mutation$AddToCart$addItemToOrder$$NegativeQuantityError
            .fromJson(json);

      default:
        final l$$__typename = json['__typename'];
        return Mutation$AddToCart$addItemToOrder(
            $__typename: (l$$__typename as String));
    }
  }

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    return Object.hashAll([l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder
    on Mutation$AddToCart$addItemToOrder {
  CopyWith$Mutation$AddToCart$addItemToOrder<Mutation$AddToCart$addItemToOrder>
      get copyWith => CopyWith$Mutation$AddToCart$addItemToOrder(
            this,
            (i) => i,
          );
  _T when<_T>({
    required _T Function(
            Mutation$AddToCart$addItemToOrder$$InsufficientStockError)
        insufficientStockError,
    required _T Function(
            Mutation$AddToCart$addItemToOrder$$OrderInterceptorError)
        orderInterceptorError,
    required _T Function(Mutation$AddToCart$addItemToOrder$$Order) order,
    required _T Function(
            Mutation$AddToCart$addItemToOrder$$OrderModificationError)
        orderModificationError,
    required _T Function(Mutation$AddToCart$addItemToOrder$$OrderLimitError)
        orderLimitError,
    required _T Function(
            Mutation$AddToCart$addItemToOrder$$NegativeQuantityError)
        negativeQuantityError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "InsufficientStockError":
        return insufficientStockError(
            this as Mutation$AddToCart$addItemToOrder$$InsufficientStockError);

      case "OrderInterceptorError":
        return orderInterceptorError(
            this as Mutation$AddToCart$addItemToOrder$$OrderInterceptorError);

      case "Order":
        return order(this as Mutation$AddToCart$addItemToOrder$$Order);

      case "OrderModificationError":
        return orderModificationError(
            this as Mutation$AddToCart$addItemToOrder$$OrderModificationError);

      case "OrderLimitError":
        return orderLimitError(
            this as Mutation$AddToCart$addItemToOrder$$OrderLimitError);

      case "NegativeQuantityError":
        return negativeQuantityError(
            this as Mutation$AddToCart$addItemToOrder$$NegativeQuantityError);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$AddToCart$addItemToOrder$$InsufficientStockError)?
        insufficientStockError,
    _T Function(Mutation$AddToCart$addItemToOrder$$OrderInterceptorError)?
        orderInterceptorError,
    _T Function(Mutation$AddToCart$addItemToOrder$$Order)? order,
    _T Function(Mutation$AddToCart$addItemToOrder$$OrderModificationError)?
        orderModificationError,
    _T Function(Mutation$AddToCart$addItemToOrder$$OrderLimitError)?
        orderLimitError,
    _T Function(Mutation$AddToCart$addItemToOrder$$NegativeQuantityError)?
        negativeQuantityError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "InsufficientStockError":
        if (insufficientStockError != null) {
          return insufficientStockError(this
              as Mutation$AddToCart$addItemToOrder$$InsufficientStockError);
        } else {
          return orElse();
        }

      case "OrderInterceptorError":
        if (orderInterceptorError != null) {
          return orderInterceptorError(
              this as Mutation$AddToCart$addItemToOrder$$OrderInterceptorError);
        } else {
          return orElse();
        }

      case "Order":
        if (order != null) {
          return order(this as Mutation$AddToCart$addItemToOrder$$Order);
        } else {
          return orElse();
        }

      case "OrderModificationError":
        if (orderModificationError != null) {
          return orderModificationError(this
              as Mutation$AddToCart$addItemToOrder$$OrderModificationError);
        } else {
          return orElse();
        }

      case "OrderLimitError":
        if (orderLimitError != null) {
          return orderLimitError(
              this as Mutation$AddToCart$addItemToOrder$$OrderLimitError);
        } else {
          return orElse();
        }

      case "NegativeQuantityError":
        if (negativeQuantityError != null) {
          return negativeQuantityError(
              this as Mutation$AddToCart$addItemToOrder$$NegativeQuantityError);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder<TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder(
    Mutation$AddToCart$addItemToOrder instance,
    TRes Function(Mutation$AddToCart$addItemToOrder) then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder;

  factory CopyWith$Mutation$AddToCart$addItemToOrder.stub(TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder<TRes>
    implements CopyWith$Mutation$AddToCart$addItemToOrder<TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) =>
      _then(Mutation$AddToCart$addItemToOrder(
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder<TRes>
    implements CopyWith$Mutation$AddToCart$addItemToOrder<TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation$AddToCart$addItemToOrder$$InsufficientStockError
    implements
        Fragment$ErrorResult$$InsufficientStockError,
        Mutation$AddToCart$addItemToOrder {
  Mutation$AddToCart$addItemToOrder$$InsufficientStockError({
    required this.order,
    this.$__typename = 'InsufficientStockError',
    required this.errorCode,
    required this.message,
  });

  factory Mutation$AddToCart$addItemToOrder$$InsufficientStockError.fromJson(
      Map<String, dynamic> json) {
    final l$order = json['order'];
    final l$$__typename = json['__typename'];
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    return Mutation$AddToCart$addItemToOrder$$InsufficientStockError(
      order: Fragment$Cart.fromJson((l$order as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
    );
  }

  final Fragment$Cart order;

  final String $__typename;

  final Enum$ErrorCode errorCode;

  final String message;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$order = order;
    _resultData['order'] = l$order.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$order = order;
    final l$$__typename = $__typename;
    final l$errorCode = errorCode;
    final l$message = message;
    return Object.hashAll([
      l$order,
      l$$__typename,
      l$errorCode,
      l$message,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$InsufficientStockError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$order = order;
    final lOther$order = other.order;
    if (l$order != lOther$order) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$InsufficientStockError
    on Mutation$AddToCart$addItemToOrder$$InsufficientStockError {
  CopyWith$Mutation$AddToCart$addItemToOrder$$InsufficientStockError<
          Mutation$AddToCart$addItemToOrder$$InsufficientStockError>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$InsufficientStockError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$InsufficientStockError<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$InsufficientStockError(
    Mutation$AddToCart$addItemToOrder$$InsufficientStockError instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$InsufficientStockError)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$InsufficientStockError;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$InsufficientStockError.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$InsufficientStockError;

  TRes call({
    Fragment$Cart? order,
    String? $__typename,
    Enum$ErrorCode? errorCode,
    String? message,
  });
  CopyWith$Fragment$Cart<TRes> get order;
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$InsufficientStockError<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$InsufficientStockError<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$InsufficientStockError(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$InsufficientStockError _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$InsufficientStockError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? order = _undefined,
    Object? $__typename = _undefined,
    Object? errorCode = _undefined,
    Object? message = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$InsufficientStockError(
        order: order == _undefined || order == null
            ? _instance.order
            : (order as Fragment$Cart),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
      ));

  CopyWith$Fragment$Cart<TRes> get order {
    final local$order = _instance.order;
    return CopyWith$Fragment$Cart(local$order, (e) => call(order: e));
  }
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$InsufficientStockError<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$InsufficientStockError<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$InsufficientStockError(
      this._res);

  TRes _res;

  call({
    Fragment$Cart? order,
    String? $__typename,
    Enum$ErrorCode? errorCode,
    String? message,
  }) =>
      _res;

  CopyWith$Fragment$Cart<TRes> get order => CopyWith$Fragment$Cart.stub(_res);
}

class Mutation$AddToCart$addItemToOrder$$OrderInterceptorError
    implements
        Fragment$ErrorResult$$OrderInterceptorError,
        Mutation$AddToCart$addItemToOrder {
  Mutation$AddToCart$addItemToOrder$$OrderInterceptorError({
    required this.interceptorError,
    required this.errorCode,
    required this.message,
    this.$__typename = 'OrderInterceptorError',
  });

  factory Mutation$AddToCart$addItemToOrder$$OrderInterceptorError.fromJson(
      Map<String, dynamic> json) {
    final l$interceptorError = json['interceptorError'];
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$OrderInterceptorError(
      interceptorError: (l$interceptorError as String),
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String interceptorError;

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$interceptorError = interceptorError;
    _resultData['interceptorError'] = l$interceptorError;
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$interceptorError = interceptorError;
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$interceptorError,
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$OrderInterceptorError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$interceptorError = interceptorError;
    final lOther$interceptorError = other.interceptorError;
    if (l$interceptorError != lOther$interceptorError) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError
    on Mutation$AddToCart$addItemToOrder$$OrderInterceptorError {
  CopyWith$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError<
          Mutation$AddToCart$addItemToOrder$$OrderInterceptorError>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError(
    Mutation$AddToCart$addItemToOrder$$OrderInterceptorError instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$OrderInterceptorError)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError;

  TRes call({
    String? interceptorError,
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$OrderInterceptorError _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$OrderInterceptorError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? interceptorError = _undefined,
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$OrderInterceptorError(
        interceptorError:
            interceptorError == _undefined || interceptorError == null
                ? _instance.interceptorError
                : (interceptorError as String),
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$OrderInterceptorError(
      this._res);

  TRes _res;

  call({
    String? interceptorError,
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$Order
    implements Fragment$Cart, Mutation$AddToCart$addItemToOrder {
  Mutation$AddToCart$addItemToOrder$$Order({
    required this.id,
    required this.code,
    required this.state,
    required this.active,
    required this.validationStatus,
    required this.couponCodes,
    required this.promotions,
    required this.lines,
    required this.totalQuantity,
    required this.subTotal,
    required this.subTotalWithTax,
    required this.total,
    required this.totalWithTax,
    required this.shipping,
    required this.shippingWithTax,
    required this.shippingLines,
    required this.discounts,
    this.customFields,
    required this.quantityLimitStatus,
    this.$__typename = 'Order',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$state = json['state'];
    final l$active = json['active'];
    final l$validationStatus = json['validationStatus'];
    final l$couponCodes = json['couponCodes'];
    final l$promotions = json['promotions'];
    final l$lines = json['lines'];
    final l$totalQuantity = json['totalQuantity'];
    final l$subTotal = json['subTotal'];
    final l$subTotalWithTax = json['subTotalWithTax'];
    final l$total = json['total'];
    final l$totalWithTax = json['totalWithTax'];
    final l$shipping = json['shipping'];
    final l$shippingWithTax = json['shippingWithTax'];
    final l$shippingLines = json['shippingLines'];
    final l$discounts = json['discounts'];
    final l$customFields = json['customFields'];
    final l$quantityLimitStatus = json['quantityLimitStatus'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order(
      id: (l$id as String),
      code: (l$code as String),
      state: (l$state as String),
      active: (l$active as bool),
      validationStatus:
          Mutation$AddToCart$addItemToOrder$$Order$validationStatus.fromJson(
              (l$validationStatus as Map<String, dynamic>)),
      couponCodes:
          (l$couponCodes as List<dynamic>).map((e) => (e as String)).toList(),
      promotions: (l$promotions as List<dynamic>)
          .map((e) =>
              Mutation$AddToCart$addItemToOrder$$Order$promotions.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      lines: (l$lines as List<dynamic>)
          .map((e) => Mutation$AddToCart$addItemToOrder$$Order$lines.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      totalQuantity: (l$totalQuantity as int),
      subTotal: (l$subTotal as num).toDouble(),
      subTotalWithTax: (l$subTotalWithTax as num).toDouble(),
      total: (l$total as num).toDouble(),
      totalWithTax: (l$totalWithTax as num).toDouble(),
      shipping: (l$shipping as num).toDouble(),
      shippingWithTax: (l$shippingWithTax as num).toDouble(),
      shippingLines: (l$shippingLines as List<dynamic>)
          .map((e) =>
              Mutation$AddToCart$addItemToOrder$$Order$shippingLines.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      discounts: (l$discounts as List<dynamic>)
          .map((e) =>
              Mutation$AddToCart$addItemToOrder$$Order$discounts.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      customFields: l$customFields == null
          ? null
          : Mutation$AddToCart$addItemToOrder$$Order$customFields.fromJson(
              (l$customFields as Map<String, dynamic>)),
      quantityLimitStatus:
          Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus.fromJson(
              (l$quantityLimitStatus as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String state;

  final bool active;

  final Mutation$AddToCart$addItemToOrder$$Order$validationStatus
      validationStatus;

  final List<String> couponCodes;

  final List<Mutation$AddToCart$addItemToOrder$$Order$promotions> promotions;

  final List<Mutation$AddToCart$addItemToOrder$$Order$lines> lines;

  final int totalQuantity;

  final double subTotal;

  final double subTotalWithTax;

  final double total;

  final double totalWithTax;

  final double shipping;

  final double shippingWithTax;

  final List<Mutation$AddToCart$addItemToOrder$$Order$shippingLines>
      shippingLines;

  final List<Mutation$AddToCart$addItemToOrder$$Order$discounts> discounts;

  final Mutation$AddToCart$addItemToOrder$$Order$customFields? customFields;

  final Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus
      quantityLimitStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$state = state;
    _resultData['state'] = l$state;
    final l$active = active;
    _resultData['active'] = l$active;
    final l$validationStatus = validationStatus;
    _resultData['validationStatus'] = l$validationStatus.toJson();
    final l$couponCodes = couponCodes;
    _resultData['couponCodes'] = l$couponCodes.map((e) => e).toList();
    final l$promotions = promotions;
    _resultData['promotions'] = l$promotions.map((e) => e.toJson()).toList();
    final l$lines = lines;
    _resultData['lines'] = l$lines.map((e) => e.toJson()).toList();
    final l$totalQuantity = totalQuantity;
    _resultData['totalQuantity'] = l$totalQuantity;
    final l$subTotal = subTotal;
    _resultData['subTotal'] = l$subTotal;
    final l$subTotalWithTax = subTotalWithTax;
    _resultData['subTotalWithTax'] = l$subTotalWithTax;
    final l$total = total;
    _resultData['total'] = l$total;
    final l$totalWithTax = totalWithTax;
    _resultData['totalWithTax'] = l$totalWithTax;
    final l$shipping = shipping;
    _resultData['shipping'] = l$shipping;
    final l$shippingWithTax = shippingWithTax;
    _resultData['shippingWithTax'] = l$shippingWithTax;
    final l$shippingLines = shippingLines;
    _resultData['shippingLines'] =
        l$shippingLines.map((e) => e.toJson()).toList();
    final l$discounts = discounts;
    _resultData['discounts'] = l$discounts.map((e) => e.toJson()).toList();
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
    final l$quantityLimitStatus = quantityLimitStatus;
    _resultData['quantityLimitStatus'] = l$quantityLimitStatus.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$state = state;
    final l$active = active;
    final l$validationStatus = validationStatus;
    final l$couponCodes = couponCodes;
    final l$promotions = promotions;
    final l$lines = lines;
    final l$totalQuantity = totalQuantity;
    final l$subTotal = subTotal;
    final l$subTotalWithTax = subTotalWithTax;
    final l$total = total;
    final l$totalWithTax = totalWithTax;
    final l$shipping = shipping;
    final l$shippingWithTax = shippingWithTax;
    final l$shippingLines = shippingLines;
    final l$discounts = discounts;
    final l$customFields = customFields;
    final l$quantityLimitStatus = quantityLimitStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$state,
      l$active,
      l$validationStatus,
      Object.hashAll(l$couponCodes.map((v) => v)),
      Object.hashAll(l$promotions.map((v) => v)),
      Object.hashAll(l$lines.map((v) => v)),
      l$totalQuantity,
      l$subTotal,
      l$subTotalWithTax,
      l$total,
      l$totalWithTax,
      l$shipping,
      l$shippingWithTax,
      Object.hashAll(l$shippingLines.map((v) => v)),
      Object.hashAll(l$discounts.map((v) => v)),
      l$customFields,
      l$quantityLimitStatus,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$Order ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$state = state;
    final lOther$state = other.state;
    if (l$state != lOther$state) {
      return false;
    }
    final l$active = active;
    final lOther$active = other.active;
    if (l$active != lOther$active) {
      return false;
    }
    final l$validationStatus = validationStatus;
    final lOther$validationStatus = other.validationStatus;
    if (l$validationStatus != lOther$validationStatus) {
      return false;
    }
    final l$couponCodes = couponCodes;
    final lOther$couponCodes = other.couponCodes;
    if (l$couponCodes.length != lOther$couponCodes.length) {
      return false;
    }
    for (int i = 0; i < l$couponCodes.length; i++) {
      final l$couponCodes$entry = l$couponCodes[i];
      final lOther$couponCodes$entry = lOther$couponCodes[i];
      if (l$couponCodes$entry != lOther$couponCodes$entry) {
        return false;
      }
    }
    final l$promotions = promotions;
    final lOther$promotions = other.promotions;
    if (l$promotions.length != lOther$promotions.length) {
      return false;
    }
    for (int i = 0; i < l$promotions.length; i++) {
      final l$promotions$entry = l$promotions[i];
      final lOther$promotions$entry = lOther$promotions[i];
      if (l$promotions$entry != lOther$promotions$entry) {
        return false;
      }
    }
    final l$lines = lines;
    final lOther$lines = other.lines;
    if (l$lines.length != lOther$lines.length) {
      return false;
    }
    for (int i = 0; i < l$lines.length; i++) {
      final l$lines$entry = l$lines[i];
      final lOther$lines$entry = lOther$lines[i];
      if (l$lines$entry != lOther$lines$entry) {
        return false;
      }
    }
    final l$totalQuantity = totalQuantity;
    final lOther$totalQuantity = other.totalQuantity;
    if (l$totalQuantity != lOther$totalQuantity) {
      return false;
    }
    final l$subTotal = subTotal;
    final lOther$subTotal = other.subTotal;
    if (l$subTotal != lOther$subTotal) {
      return false;
    }
    final l$subTotalWithTax = subTotalWithTax;
    final lOther$subTotalWithTax = other.subTotalWithTax;
    if (l$subTotalWithTax != lOther$subTotalWithTax) {
      return false;
    }
    final l$total = total;
    final lOther$total = other.total;
    if (l$total != lOther$total) {
      return false;
    }
    final l$totalWithTax = totalWithTax;
    final lOther$totalWithTax = other.totalWithTax;
    if (l$totalWithTax != lOther$totalWithTax) {
      return false;
    }
    final l$shipping = shipping;
    final lOther$shipping = other.shipping;
    if (l$shipping != lOther$shipping) {
      return false;
    }
    final l$shippingWithTax = shippingWithTax;
    final lOther$shippingWithTax = other.shippingWithTax;
    if (l$shippingWithTax != lOther$shippingWithTax) {
      return false;
    }
    final l$shippingLines = shippingLines;
    final lOther$shippingLines = other.shippingLines;
    if (l$shippingLines.length != lOther$shippingLines.length) {
      return false;
    }
    for (int i = 0; i < l$shippingLines.length; i++) {
      final l$shippingLines$entry = l$shippingLines[i];
      final lOther$shippingLines$entry = lOther$shippingLines[i];
      if (l$shippingLines$entry != lOther$shippingLines$entry) {
        return false;
      }
    }
    final l$discounts = discounts;
    final lOther$discounts = other.discounts;
    if (l$discounts.length != lOther$discounts.length) {
      return false;
    }
    for (int i = 0; i < l$discounts.length; i++) {
      final l$discounts$entry = l$discounts[i];
      final lOther$discounts$entry = lOther$discounts[i];
      if (l$discounts$entry != lOther$discounts$entry) {
        return false;
      }
    }
    final l$customFields = customFields;
    final lOther$customFields = other.customFields;
    if (l$customFields != lOther$customFields) {
      return false;
    }
    final l$quantityLimitStatus = quantityLimitStatus;
    final lOther$quantityLimitStatus = other.quantityLimitStatus;
    if (l$quantityLimitStatus != lOther$quantityLimitStatus) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order
    on Mutation$AddToCart$addItemToOrder$$Order {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order<
          Mutation$AddToCart$addItemToOrder$$Order>
      get copyWith => CopyWith$Mutation$AddToCart$addItemToOrder$$Order(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order<TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order(
    Mutation$AddToCart$addItemToOrder$$Order instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order) then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order.stub(TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order;

  TRes call({
    String? id,
    String? code,
    String? state,
    bool? active,
    Mutation$AddToCart$addItemToOrder$$Order$validationStatus? validationStatus,
    List<String>? couponCodes,
    List<Mutation$AddToCart$addItemToOrder$$Order$promotions>? promotions,
    List<Mutation$AddToCart$addItemToOrder$$Order$lines>? lines,
    int? totalQuantity,
    double? subTotal,
    double? subTotalWithTax,
    double? total,
    double? totalWithTax,
    double? shipping,
    double? shippingWithTax,
    List<Mutation$AddToCart$addItemToOrder$$Order$shippingLines>? shippingLines,
    List<Mutation$AddToCart$addItemToOrder$$Order$discounts>? discounts,
    Mutation$AddToCart$addItemToOrder$$Order$customFields? customFields,
    Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus?
        quantityLimitStatus,
    String? $__typename,
  });
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus<TRes>
      get validationStatus;
  TRes promotions(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$promotions> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions<
                      Mutation$AddToCart$addItemToOrder$$Order$promotions>>)
          _fn);
  TRes lines(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$lines> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines<
                      Mutation$AddToCart$addItemToOrder$$Order$lines>>)
          _fn);
  TRes shippingLines(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$shippingLines> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines<
                      Mutation$AddToCart$addItemToOrder$$Order$shippingLines>>)
          _fn);
  TRes discounts(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$discounts> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$discounts<
                      Mutation$AddToCart$addItemToOrder$$Order$discounts>>)
          _fn);
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields<TRes>
      get customFields;
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus<TRes>
      get quantityLimitStatus;
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order<TRes>
    implements CopyWith$Mutation$AddToCart$addItemToOrder$$Order<TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$Order) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? state = _undefined,
    Object? active = _undefined,
    Object? validationStatus = _undefined,
    Object? couponCodes = _undefined,
    Object? promotions = _undefined,
    Object? lines = _undefined,
    Object? totalQuantity = _undefined,
    Object? subTotal = _undefined,
    Object? subTotalWithTax = _undefined,
    Object? total = _undefined,
    Object? totalWithTax = _undefined,
    Object? shipping = _undefined,
    Object? shippingWithTax = _undefined,
    Object? shippingLines = _undefined,
    Object? discounts = _undefined,
    Object? customFields = _undefined,
    Object? quantityLimitStatus = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        state: state == _undefined || state == null
            ? _instance.state
            : (state as String),
        active: active == _undefined || active == null
            ? _instance.active
            : (active as bool),
        validationStatus: validationStatus == _undefined ||
                validationStatus == null
            ? _instance.validationStatus
            : (validationStatus
                as Mutation$AddToCart$addItemToOrder$$Order$validationStatus),
        couponCodes: couponCodes == _undefined || couponCodes == null
            ? _instance.couponCodes
            : (couponCodes as List<String>),
        promotions: promotions == _undefined || promotions == null
            ? _instance.promotions
            : (promotions
                as List<Mutation$AddToCart$addItemToOrder$$Order$promotions>),
        lines: lines == _undefined || lines == null
            ? _instance.lines
            : (lines as List<Mutation$AddToCart$addItemToOrder$$Order$lines>),
        totalQuantity: totalQuantity == _undefined || totalQuantity == null
            ? _instance.totalQuantity
            : (totalQuantity as int),
        subTotal: subTotal == _undefined || subTotal == null
            ? _instance.subTotal
            : (subTotal as double),
        subTotalWithTax:
            subTotalWithTax == _undefined || subTotalWithTax == null
                ? _instance.subTotalWithTax
                : (subTotalWithTax as double),
        total: total == _undefined || total == null
            ? _instance.total
            : (total as double),
        totalWithTax: totalWithTax == _undefined || totalWithTax == null
            ? _instance.totalWithTax
            : (totalWithTax as double),
        shipping: shipping == _undefined || shipping == null
            ? _instance.shipping
            : (shipping as double),
        shippingWithTax:
            shippingWithTax == _undefined || shippingWithTax == null
                ? _instance.shippingWithTax
                : (shippingWithTax as double),
        shippingLines: shippingLines == _undefined || shippingLines == null
            ? _instance.shippingLines
            : (shippingLines as List<
                Mutation$AddToCart$addItemToOrder$$Order$shippingLines>),
        discounts: discounts == _undefined || discounts == null
            ? _instance.discounts
            : (discounts
                as List<Mutation$AddToCart$addItemToOrder$$Order$discounts>),
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Mutation$AddToCart$addItemToOrder$$Order$customFields?),
        quantityLimitStatus: quantityLimitStatus == _undefined ||
                quantityLimitStatus == null
            ? _instance.quantityLimitStatus
            : (quantityLimitStatus
                as Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus<TRes>
      get validationStatus {
    final local$validationStatus = _instance.validationStatus;
    return CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus(
        local$validationStatus, (e) => call(validationStatus: e));
  }

  TRes promotions(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$promotions> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions<
                          Mutation$AddToCart$addItemToOrder$$Order$promotions>>)
              _fn) =>
      call(
          promotions: _fn(_instance.promotions.map((e) =>
              CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions(
                e,
                (i) => i,
              ))).toList());

  TRes lines(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$lines> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines<
                          Mutation$AddToCart$addItemToOrder$$Order$lines>>)
              _fn) =>
      call(
          lines: _fn(_instance.lines.map(
              (e) => CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines(
                    e,
                    (i) => i,
                  ))).toList());

  TRes shippingLines(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$shippingLines> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines<
                          Mutation$AddToCart$addItemToOrder$$Order$shippingLines>>)
              _fn) =>
      call(
          shippingLines: _fn(_instance.shippingLines.map((e) =>
              CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines(
                e,
                (i) => i,
              ))).toList());

  TRes discounts(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$discounts> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$discounts<
                          Mutation$AddToCart$addItemToOrder$$Order$discounts>>)
              _fn) =>
      call(
          discounts: _fn(_instance.discounts.map((e) =>
              CopyWith$Mutation$AddToCart$addItemToOrder$$Order$discounts(
                e,
                (i) => i,
              ))).toList());

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields<TRes>
      get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields.stub(
            _then(_instance))
        : CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields(
            local$customFields, (e) => call(customFields: e));
  }

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus<TRes>
      get quantityLimitStatus {
    final local$quantityLimitStatus = _instance.quantityLimitStatus;
    return CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus(
        local$quantityLimitStatus, (e) => call(quantityLimitStatus: e));
  }
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order<TRes>
    implements CopyWith$Mutation$AddToCart$addItemToOrder$$Order<TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order(this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    String? state,
    bool? active,
    Mutation$AddToCart$addItemToOrder$$Order$validationStatus? validationStatus,
    List<String>? couponCodes,
    List<Mutation$AddToCart$addItemToOrder$$Order$promotions>? promotions,
    List<Mutation$AddToCart$addItemToOrder$$Order$lines>? lines,
    int? totalQuantity,
    double? subTotal,
    double? subTotalWithTax,
    double? total,
    double? totalWithTax,
    double? shipping,
    double? shippingWithTax,
    List<Mutation$AddToCart$addItemToOrder$$Order$shippingLines>? shippingLines,
    List<Mutation$AddToCart$addItemToOrder$$Order$discounts>? discounts,
    Mutation$AddToCart$addItemToOrder$$Order$customFields? customFields,
    Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus?
        quantityLimitStatus,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus<TRes>
      get validationStatus =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus
              .stub(_res);

  promotions(_fn) => _res;

  lines(_fn) => _res;

  shippingLines(_fn) => _res;

  discounts(_fn) => _res;

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields<TRes>
      get customFields =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields.stub(
              _res);

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus<TRes>
      get quantityLimitStatus =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus
              .stub(_res);
}

class Mutation$AddToCart$addItemToOrder$$Order$validationStatus
    implements Fragment$Cart$validationStatus {
  Mutation$AddToCart$addItemToOrder$$Order$validationStatus({
    required this.isValid,
    required this.hasUnavailableItems,
    required this.totalUnavailableItems,
    required this.unavailableItems,
    this.$__typename = 'CartValidationStatus',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$validationStatus.fromJson(
      Map<String, dynamic> json) {
    final l$isValid = json['isValid'];
    final l$hasUnavailableItems = json['hasUnavailableItems'];
    final l$totalUnavailableItems = json['totalUnavailableItems'];
    final l$unavailableItems = json['unavailableItems'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$validationStatus(
      isValid: (l$isValid as bool),
      hasUnavailableItems: (l$hasUnavailableItems as bool),
      totalUnavailableItems: (l$totalUnavailableItems as int),
      unavailableItems: (l$unavailableItems as List<dynamic>)
          .map((e) =>
              Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final bool isValid;

  final bool hasUnavailableItems;

  final int totalUnavailableItems;

  final List<
          Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems>
      unavailableItems;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$isValid = isValid;
    _resultData['isValid'] = l$isValid;
    final l$hasUnavailableItems = hasUnavailableItems;
    _resultData['hasUnavailableItems'] = l$hasUnavailableItems;
    final l$totalUnavailableItems = totalUnavailableItems;
    _resultData['totalUnavailableItems'] = l$totalUnavailableItems;
    final l$unavailableItems = unavailableItems;
    _resultData['unavailableItems'] =
        l$unavailableItems.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$isValid = isValid;
    final l$hasUnavailableItems = hasUnavailableItems;
    final l$totalUnavailableItems = totalUnavailableItems;
    final l$unavailableItems = unavailableItems;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$isValid,
      l$hasUnavailableItems,
      l$totalUnavailableItems,
      Object.hashAll(l$unavailableItems.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$Order$validationStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$isValid = isValid;
    final lOther$isValid = other.isValid;
    if (l$isValid != lOther$isValid) {
      return false;
    }
    final l$hasUnavailableItems = hasUnavailableItems;
    final lOther$hasUnavailableItems = other.hasUnavailableItems;
    if (l$hasUnavailableItems != lOther$hasUnavailableItems) {
      return false;
    }
    final l$totalUnavailableItems = totalUnavailableItems;
    final lOther$totalUnavailableItems = other.totalUnavailableItems;
    if (l$totalUnavailableItems != lOther$totalUnavailableItems) {
      return false;
    }
    final l$unavailableItems = unavailableItems;
    final lOther$unavailableItems = other.unavailableItems;
    if (l$unavailableItems.length != lOther$unavailableItems.length) {
      return false;
    }
    for (int i = 0; i < l$unavailableItems.length; i++) {
      final l$unavailableItems$entry = l$unavailableItems[i];
      final lOther$unavailableItems$entry = lOther$unavailableItems[i];
      if (l$unavailableItems$entry != lOther$unavailableItems$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$validationStatus
    on Mutation$AddToCart$addItemToOrder$$Order$validationStatus {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus<
          Mutation$AddToCart$addItemToOrder$$Order$validationStatus>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus(
    Mutation$AddToCart$addItemToOrder$$Order$validationStatus instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order$validationStatus)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus;

  TRes call({
    bool? isValid,
    bool? hasUnavailableItems,
    int? totalUnavailableItems,
    List<Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems>?
        unavailableItems,
    String? $__typename,
  });
  TRes unavailableItems(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems<
                      Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems>>)
          _fn);
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$validationStatus _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$Order$validationStatus)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? isValid = _undefined,
    Object? hasUnavailableItems = _undefined,
    Object? totalUnavailableItems = _undefined,
    Object? unavailableItems = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$validationStatus(
        isValid: isValid == _undefined || isValid == null
            ? _instance.isValid
            : (isValid as bool),
        hasUnavailableItems:
            hasUnavailableItems == _undefined || hasUnavailableItems == null
                ? _instance.hasUnavailableItems
                : (hasUnavailableItems as bool),
        totalUnavailableItems:
            totalUnavailableItems == _undefined || totalUnavailableItems == null
                ? _instance.totalUnavailableItems
                : (totalUnavailableItems as int),
        unavailableItems: unavailableItems == _undefined ||
                unavailableItems == null
            ? _instance.unavailableItems
            : (unavailableItems as List<
                Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes unavailableItems(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems<
                          Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems>>)
              _fn) =>
      call(
          unavailableItems: _fn(_instance.unavailableItems.map((e) =>
              CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus(
      this._res);

  TRes _res;

  call({
    bool? isValid,
    bool? hasUnavailableItems,
    int? totalUnavailableItems,
    List<Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems>?
        unavailableItems,
    String? $__typename,
  }) =>
      _res;

  unavailableItems(_fn) => _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems
    implements Fragment$Cart$validationStatus$unavailableItems {
  Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems({
    required this.orderLineId,
    required this.productName,
    required this.variantName,
    required this.reason,
    this.$__typename = 'UnavailableCartItem',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems.fromJson(
      Map<String, dynamic> json) {
    final l$orderLineId = json['orderLineId'];
    final l$productName = json['productName'];
    final l$variantName = json['variantName'];
    final l$reason = json['reason'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems(
      orderLineId: (l$orderLineId as String),
      productName: (l$productName as String),
      variantName: (l$variantName as String),
      reason: (l$reason as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String orderLineId;

  final String productName;

  final String variantName;

  final String reason;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$orderLineId = orderLineId;
    _resultData['orderLineId'] = l$orderLineId;
    final l$productName = productName;
    _resultData['productName'] = l$productName;
    final l$variantName = variantName;
    _resultData['variantName'] = l$variantName;
    final l$reason = reason;
    _resultData['reason'] = l$reason;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$orderLineId = orderLineId;
    final l$productName = productName;
    final l$variantName = variantName;
    final l$reason = reason;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$orderLineId,
      l$productName,
      l$variantName,
      l$reason,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$orderLineId = orderLineId;
    final lOther$orderLineId = other.orderLineId;
    if (l$orderLineId != lOther$orderLineId) {
      return false;
    }
    final l$productName = productName;
    final lOther$productName = other.productName;
    if (l$productName != lOther$productName) {
      return false;
    }
    final l$variantName = variantName;
    final lOther$variantName = other.variantName;
    if (l$variantName != lOther$variantName) {
      return false;
    }
    final l$reason = reason;
    final lOther$reason = other.reason;
    if (l$reason != lOther$reason) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems
    on Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems<
          Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems(
    Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems
        instance,
    TRes Function(
            Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems;

  TRes call({
    String? orderLineId,
    String? productName,
    String? variantName,
    String? reason,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems
      _instance;

  final TRes Function(
          Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? orderLineId = _undefined,
    Object? productName = _undefined,
    Object? variantName = _undefined,
    Object? reason = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems(
        orderLineId: orderLineId == _undefined || orderLineId == null
            ? _instance.orderLineId
            : (orderLineId as String),
        productName: productName == _undefined || productName == null
            ? _instance.productName
            : (productName as String),
        variantName: variantName == _undefined || variantName == null
            ? _instance.variantName
            : (variantName as String),
        reason: reason == _undefined || reason == null
            ? _instance.reason
            : (reason as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$validationStatus$unavailableItems(
      this._res);

  TRes _res;

  call({
    String? orderLineId,
    String? productName,
    String? variantName,
    String? reason,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$promotions
    implements Fragment$Cart$promotions {
  Mutation$AddToCart$addItemToOrder$$Order$promotions({
    this.couponCode,
    required this.name,
    required this.enabled,
    required this.actions,
    required this.conditions,
    this.$__typename = 'Promotion',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$promotions.fromJson(
      Map<String, dynamic> json) {
    final l$couponCode = json['couponCode'];
    final l$name = json['name'];
    final l$enabled = json['enabled'];
    final l$actions = json['actions'];
    final l$conditions = json['conditions'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$promotions(
      couponCode: (l$couponCode as String?),
      name: (l$name as String),
      enabled: (l$enabled as bool),
      actions: (l$actions as List<dynamic>)
          .map((e) =>
              Mutation$AddToCart$addItemToOrder$$Order$promotions$actions
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      conditions: (l$conditions as List<dynamic>)
          .map((e) =>
              Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String? couponCode;

  final String name;

  final bool enabled;

  final List<Mutation$AddToCart$addItemToOrder$$Order$promotions$actions>
      actions;

  final List<Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions>
      conditions;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$couponCode = couponCode;
    _resultData['couponCode'] = l$couponCode;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
    final l$actions = actions;
    _resultData['actions'] = l$actions.map((e) => e.toJson()).toList();
    final l$conditions = conditions;
    _resultData['conditions'] = l$conditions.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$couponCode = couponCode;
    final l$name = name;
    final l$enabled = enabled;
    final l$actions = actions;
    final l$conditions = conditions;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$couponCode,
      l$name,
      l$enabled,
      Object.hashAll(l$actions.map((v) => v)),
      Object.hashAll(l$conditions.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$Order$promotions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$couponCode = couponCode;
    final lOther$couponCode = other.couponCode;
    if (l$couponCode != lOther$couponCode) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$enabled = enabled;
    final lOther$enabled = other.enabled;
    if (l$enabled != lOther$enabled) {
      return false;
    }
    final l$actions = actions;
    final lOther$actions = other.actions;
    if (l$actions.length != lOther$actions.length) {
      return false;
    }
    for (int i = 0; i < l$actions.length; i++) {
      final l$actions$entry = l$actions[i];
      final lOther$actions$entry = lOther$actions[i];
      if (l$actions$entry != lOther$actions$entry) {
        return false;
      }
    }
    final l$conditions = conditions;
    final lOther$conditions = other.conditions;
    if (l$conditions.length != lOther$conditions.length) {
      return false;
    }
    for (int i = 0; i < l$conditions.length; i++) {
      final l$conditions$entry = l$conditions[i];
      final lOther$conditions$entry = lOther$conditions[i];
      if (l$conditions$entry != lOther$conditions$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$promotions
    on Mutation$AddToCart$addItemToOrder$$Order$promotions {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions<
          Mutation$AddToCart$addItemToOrder$$Order$promotions>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions(
    Mutation$AddToCart$addItemToOrder$$Order$promotions instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order$promotions) then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions;

  TRes call({
    String? couponCode,
    String? name,
    bool? enabled,
    List<Mutation$AddToCart$addItemToOrder$$Order$promotions$actions>? actions,
    List<Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions>?
        conditions,
    String? $__typename,
  });
  TRes actions(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$promotions$actions> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions<
                      Mutation$AddToCart$addItemToOrder$$Order$promotions$actions>>)
          _fn);
  TRes conditions(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions<
                      Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions>>)
          _fn);
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions<TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions<TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$promotions _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$Order$promotions)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? couponCode = _undefined,
    Object? name = _undefined,
    Object? enabled = _undefined,
    Object? actions = _undefined,
    Object? conditions = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$promotions(
        couponCode: couponCode == _undefined
            ? _instance.couponCode
            : (couponCode as String?),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        enabled: enabled == _undefined || enabled == null
            ? _instance.enabled
            : (enabled as bool),
        actions: actions == _undefined || actions == null
            ? _instance.actions
            : (actions as List<
                Mutation$AddToCart$addItemToOrder$$Order$promotions$actions>),
        conditions: conditions == _undefined || conditions == null
            ? _instance.conditions
            : (conditions as List<
                Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes actions(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$promotions$actions> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions<
                          Mutation$AddToCart$addItemToOrder$$Order$promotions$actions>>)
              _fn) =>
      call(
          actions: _fn(_instance.actions.map((e) =>
              CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions(
                e,
                (i) => i,
              ))).toList());

  TRes conditions(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions<
                          Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions>>)
              _fn) =>
      call(
          conditions: _fn(_instance.conditions.map((e) =>
              CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions<TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions(
      this._res);

  TRes _res;

  call({
    String? couponCode,
    String? name,
    bool? enabled,
    List<Mutation$AddToCart$addItemToOrder$$Order$promotions$actions>? actions,
    List<Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions>?
        conditions,
    String? $__typename,
  }) =>
      _res;

  actions(_fn) => _res;

  conditions(_fn) => _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$promotions$actions
    implements Fragment$Cart$promotions$actions {
  Mutation$AddToCart$addItemToOrder$$Order$promotions$actions({
    required this.args,
    required this.code,
    this.$__typename = 'ConfigurableOperation',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$promotions$actions.fromJson(
      Map<String, dynamic> json) {
    final l$args = json['args'];
    final l$code = json['code'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$promotions$actions(
      args: (l$args as List<dynamic>)
          .map((e) =>
              Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      code: (l$code as String),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args>
      args;

  final String code;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$args = args;
    _resultData['args'] = l$args.map((e) => e.toJson()).toList();
    final l$code = code;
    _resultData['code'] = l$code;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$args = args;
    final l$code = code;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$args.map((v) => v)),
      l$code,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$Order$promotions$actions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$args = args;
    final lOther$args = other.args;
    if (l$args.length != lOther$args.length) {
      return false;
    }
    for (int i = 0; i < l$args.length; i++) {
      final l$args$entry = l$args[i];
      final lOther$args$entry = lOther$args[i];
      if (l$args$entry != lOther$args$entry) {
        return false;
      }
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions
    on Mutation$AddToCart$addItemToOrder$$Order$promotions$actions {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions<
          Mutation$AddToCart$addItemToOrder$$Order$promotions$actions>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions(
    Mutation$AddToCart$addItemToOrder$$Order$promotions$actions instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order$promotions$actions)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions;

  TRes call({
    List<Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args>?
        args,
    String? code,
    String? $__typename,
  });
  TRes args(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args<
                      Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args>>)
          _fn);
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$promotions$actions _instance;

  final TRes Function(
      Mutation$AddToCart$addItemToOrder$$Order$promotions$actions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? args = _undefined,
    Object? code = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$promotions$actions(
        args: args == _undefined || args == null
            ? _instance.args
            : (args as List<
                Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args>),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes args(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args<
                          Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args>>)
              _fn) =>
      call(
          args: _fn(_instance.args.map((e) =>
              CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions(
      this._res);

  TRes _res;

  call({
    List<Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args>?
        args,
    String? code,
    String? $__typename,
  }) =>
      _res;

  args(_fn) => _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args
    implements Fragment$Cart$promotions$actions$args {
  Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args({
    required this.value,
    required this.name,
    this.$__typename = 'ConfigArg',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args.fromJson(
      Map<String, dynamic> json) {
    final l$value = json['value'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args(
      value: (l$value as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String value;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$value = value;
    _resultData['value'] = l$value;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$value = value;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$value,
      l$name,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args
    on Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args<
          Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args(
    Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args instance,
    TRes Function(
            Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args;

  TRes call({
    String? value,
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args
      _instance;

  final TRes Function(
      Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? value = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args(
        value: value == _undefined || value == null
            ? _instance.value
            : (value as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$actions$args(
      this._res);

  TRes _res;

  call({
    String? value,
    String? name,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions
    implements Fragment$Cart$promotions$conditions {
  Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions({
    required this.code,
    required this.args,
    this.$__typename = 'ConfigurableOperation',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions.fromJson(
      Map<String, dynamic> json) {
    final l$code = json['code'];
    final l$args = json['args'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions(
      code: (l$code as String),
      args: (l$args as List<dynamic>)
          .map((e) =>
              Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String code;

  final List<
      Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args> args;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$args = args;
    _resultData['args'] = l$args.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$args = args;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$code,
      Object.hashAll(l$args.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$args = args;
    final lOther$args = other.args;
    if (l$args.length != lOther$args.length) {
      return false;
    }
    for (int i = 0; i < l$args.length; i++) {
      final l$args$entry = l$args[i];
      final lOther$args$entry = lOther$args[i];
      if (l$args$entry != lOther$args$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions
    on Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions<
          Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions(
    Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions instance,
    TRes Function(
            Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions;

  TRes call({
    String? code,
    List<Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args>?
        args,
    String? $__typename,
  });
  TRes args(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args<
                      Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args>>)
          _fn);
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions
      _instance;

  final TRes Function(
      Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? args = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions(
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        args: args == _undefined || args == null
            ? _instance.args
            : (args as List<
                Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes args(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args<
                          Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args>>)
              _fn) =>
      call(
          args: _fn(_instance.args.map((e) =>
              CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions(
      this._res);

  TRes _res;

  call({
    String? code,
    List<Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args>?
        args,
    String? $__typename,
  }) =>
      _res;

  args(_fn) => _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args
    implements Fragment$Cart$promotions$conditions$args {
  Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args({
    required this.name,
    required this.value,
    this.$__typename = 'ConfigArg',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args.fromJson(
      Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args(
      name: (l$name as String),
      value: (l$value as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$value = value;
    _resultData['value'] = l$value;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$value,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args
    on Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args<
          Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args(
    Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args
        instance,
    TRes Function(
            Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args;

  TRes call({
    String? name,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args
      _instance;

  final TRes Function(
          Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args(
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        value: value == _undefined || value == null
            ? _instance.value
            : (value as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$promotions$conditions$args(
      this._res);

  TRes _res;

  call({
    String? name,
    String? value,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$lines
    implements Fragment$Cart$lines {
  Mutation$AddToCart$addItemToOrder$$Order$lines({
    required this.id,
    required this.quantity,
    required this.isAvailable,
    this.unavailableReason,
    this.featuredAsset,
    required this.unitPrice,
    required this.unitPriceWithTax,
    required this.linePriceWithTax,
    required this.discountedLinePriceWithTax,
    required this.productVariant,
    required this.discounts,
    this.$__typename = 'OrderLine',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$lines.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$quantity = json['quantity'];
    final l$isAvailable = json['isAvailable'];
    final l$unavailableReason = json['unavailableReason'];
    final l$featuredAsset = json['featuredAsset'];
    final l$unitPrice = json['unitPrice'];
    final l$unitPriceWithTax = json['unitPriceWithTax'];
    final l$linePriceWithTax = json['linePriceWithTax'];
    final l$discountedLinePriceWithTax = json['discountedLinePriceWithTax'];
    final l$productVariant = json['productVariant'];
    final l$discounts = json['discounts'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$lines(
      id: (l$id as String),
      quantity: (l$quantity as int),
      isAvailable: (l$isAvailable as bool),
      unavailableReason: (l$unavailableReason as String?),
      featuredAsset: l$featuredAsset == null
          ? null
          : Fragment$Asset.fromJson((l$featuredAsset as Map<String, dynamic>)),
      unitPrice: (l$unitPrice as num).toDouble(),
      unitPriceWithTax: (l$unitPriceWithTax as num).toDouble(),
      linePriceWithTax: (l$linePriceWithTax as num).toDouble(),
      discountedLinePriceWithTax:
          (l$discountedLinePriceWithTax as num).toDouble(),
      productVariant:
          Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant
              .fromJson((l$productVariant as Map<String, dynamic>)),
      discounts: (l$discounts as List<dynamic>)
          .map((e) =>
              Mutation$AddToCart$addItemToOrder$$Order$lines$discounts.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int quantity;

  final bool isAvailable;

  final String? unavailableReason;

  final Fragment$Asset? featuredAsset;

  final double unitPrice;

  final double unitPriceWithTax;

  final double linePriceWithTax;

  final double discountedLinePriceWithTax;

  final Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant
      productVariant;

  final List<Mutation$AddToCart$addItemToOrder$$Order$lines$discounts>
      discounts;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$quantity = quantity;
    _resultData['quantity'] = l$quantity;
    final l$isAvailable = isAvailable;
    _resultData['isAvailable'] = l$isAvailable;
    final l$unavailableReason = unavailableReason;
    _resultData['unavailableReason'] = l$unavailableReason;
    final l$featuredAsset = featuredAsset;
    _resultData['featuredAsset'] = l$featuredAsset?.toJson();
    final l$unitPrice = unitPrice;
    _resultData['unitPrice'] = l$unitPrice;
    final l$unitPriceWithTax = unitPriceWithTax;
    _resultData['unitPriceWithTax'] = l$unitPriceWithTax;
    final l$linePriceWithTax = linePriceWithTax;
    _resultData['linePriceWithTax'] = l$linePriceWithTax;
    final l$discountedLinePriceWithTax = discountedLinePriceWithTax;
    _resultData['discountedLinePriceWithTax'] = l$discountedLinePriceWithTax;
    final l$productVariant = productVariant;
    _resultData['productVariant'] = l$productVariant.toJson();
    final l$discounts = discounts;
    _resultData['discounts'] = l$discounts.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$quantity = quantity;
    final l$isAvailable = isAvailable;
    final l$unavailableReason = unavailableReason;
    final l$featuredAsset = featuredAsset;
    final l$unitPrice = unitPrice;
    final l$unitPriceWithTax = unitPriceWithTax;
    final l$linePriceWithTax = linePriceWithTax;
    final l$discountedLinePriceWithTax = discountedLinePriceWithTax;
    final l$productVariant = productVariant;
    final l$discounts = discounts;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$quantity,
      l$isAvailable,
      l$unavailableReason,
      l$featuredAsset,
      l$unitPrice,
      l$unitPriceWithTax,
      l$linePriceWithTax,
      l$discountedLinePriceWithTax,
      l$productVariant,
      Object.hashAll(l$discounts.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$Order$lines ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$quantity = quantity;
    final lOther$quantity = other.quantity;
    if (l$quantity != lOther$quantity) {
      return false;
    }
    final l$isAvailable = isAvailable;
    final lOther$isAvailable = other.isAvailable;
    if (l$isAvailable != lOther$isAvailable) {
      return false;
    }
    final l$unavailableReason = unavailableReason;
    final lOther$unavailableReason = other.unavailableReason;
    if (l$unavailableReason != lOther$unavailableReason) {
      return false;
    }
    final l$featuredAsset = featuredAsset;
    final lOther$featuredAsset = other.featuredAsset;
    if (l$featuredAsset != lOther$featuredAsset) {
      return false;
    }
    final l$unitPrice = unitPrice;
    final lOther$unitPrice = other.unitPrice;
    if (l$unitPrice != lOther$unitPrice) {
      return false;
    }
    final l$unitPriceWithTax = unitPriceWithTax;
    final lOther$unitPriceWithTax = other.unitPriceWithTax;
    if (l$unitPriceWithTax != lOther$unitPriceWithTax) {
      return false;
    }
    final l$linePriceWithTax = linePriceWithTax;
    final lOther$linePriceWithTax = other.linePriceWithTax;
    if (l$linePriceWithTax != lOther$linePriceWithTax) {
      return false;
    }
    final l$discountedLinePriceWithTax = discountedLinePriceWithTax;
    final lOther$discountedLinePriceWithTax = other.discountedLinePriceWithTax;
    if (l$discountedLinePriceWithTax != lOther$discountedLinePriceWithTax) {
      return false;
    }
    final l$productVariant = productVariant;
    final lOther$productVariant = other.productVariant;
    if (l$productVariant != lOther$productVariant) {
      return false;
    }
    final l$discounts = discounts;
    final lOther$discounts = other.discounts;
    if (l$discounts.length != lOther$discounts.length) {
      return false;
    }
    for (int i = 0; i < l$discounts.length; i++) {
      final l$discounts$entry = l$discounts[i];
      final lOther$discounts$entry = lOther$discounts[i];
      if (l$discounts$entry != lOther$discounts$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$lines
    on Mutation$AddToCart$addItemToOrder$$Order$lines {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines<
          Mutation$AddToCart$addItemToOrder$$Order$lines>
      get copyWith => CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines<TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines(
    Mutation$AddToCart$addItemToOrder$$Order$lines instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order$lines) then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines;

  TRes call({
    String? id,
    int? quantity,
    bool? isAvailable,
    String? unavailableReason,
    Fragment$Asset? featuredAsset,
    double? unitPrice,
    double? unitPriceWithTax,
    double? linePriceWithTax,
    double? discountedLinePriceWithTax,
    Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant?
        productVariant,
    List<Mutation$AddToCart$addItemToOrder$$Order$lines$discounts>? discounts,
    String? $__typename,
  });
  CopyWith$Fragment$Asset<TRes> get featuredAsset;
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant<TRes>
      get productVariant;
  TRes discounts(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$lines$discounts> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts<
                      Mutation$AddToCart$addItemToOrder$$Order$lines$discounts>>)
          _fn);
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines<TRes>
    implements CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines<TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$lines _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$Order$lines) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? quantity = _undefined,
    Object? isAvailable = _undefined,
    Object? unavailableReason = _undefined,
    Object? featuredAsset = _undefined,
    Object? unitPrice = _undefined,
    Object? unitPriceWithTax = _undefined,
    Object? linePriceWithTax = _undefined,
    Object? discountedLinePriceWithTax = _undefined,
    Object? productVariant = _undefined,
    Object? discounts = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$lines(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        quantity: quantity == _undefined || quantity == null
            ? _instance.quantity
            : (quantity as int),
        isAvailable: isAvailable == _undefined || isAvailable == null
            ? _instance.isAvailable
            : (isAvailable as bool),
        unavailableReason: unavailableReason == _undefined
            ? _instance.unavailableReason
            : (unavailableReason as String?),
        featuredAsset: featuredAsset == _undefined
            ? _instance.featuredAsset
            : (featuredAsset as Fragment$Asset?),
        unitPrice: unitPrice == _undefined || unitPrice == null
            ? _instance.unitPrice
            : (unitPrice as double),
        unitPriceWithTax:
            unitPriceWithTax == _undefined || unitPriceWithTax == null
                ? _instance.unitPriceWithTax
                : (unitPriceWithTax as double),
        linePriceWithTax:
            linePriceWithTax == _undefined || linePriceWithTax == null
                ? _instance.linePriceWithTax
                : (linePriceWithTax as double),
        discountedLinePriceWithTax: discountedLinePriceWithTax == _undefined ||
                discountedLinePriceWithTax == null
            ? _instance.discountedLinePriceWithTax
            : (discountedLinePriceWithTax as double),
        productVariant: productVariant == _undefined || productVariant == null
            ? _instance.productVariant
            : (productVariant
                as Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant),
        discounts: discounts == _undefined || discounts == null
            ? _instance.discounts
            : (discounts as List<
                Mutation$AddToCart$addItemToOrder$$Order$lines$discounts>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Fragment$Asset<TRes> get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Fragment$Asset.stub(_then(_instance))
        : CopyWith$Fragment$Asset(
            local$featuredAsset, (e) => call(featuredAsset: e));
  }

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant<TRes>
      get productVariant {
    final local$productVariant = _instance.productVariant;
    return CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant(
        local$productVariant, (e) => call(productVariant: e));
  }

  TRes discounts(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$lines$discounts> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts<
                          Mutation$AddToCart$addItemToOrder$$Order$lines$discounts>>)
              _fn) =>
      call(
          discounts: _fn(_instance.discounts.map((e) =>
              CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines<TRes>
    implements CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines<TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines(this._res);

  TRes _res;

  call({
    String? id,
    int? quantity,
    bool? isAvailable,
    String? unavailableReason,
    Fragment$Asset? featuredAsset,
    double? unitPrice,
    double? unitPriceWithTax,
    double? linePriceWithTax,
    double? discountedLinePriceWithTax,
    Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant?
        productVariant,
    List<Mutation$AddToCart$addItemToOrder$$Order$lines$discounts>? discounts,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Fragment$Asset<TRes> get featuredAsset =>
      CopyWith$Fragment$Asset.stub(_res);

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant<TRes>
      get productVariant =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant
              .stub(_res);

  discounts(_fn) => _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant
    implements Fragment$Cart$lines$productVariant {
  Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant({
    required this.id,
    required this.name,
    required this.stockLevel,
    required this.price,
    required this.product,
    this.$__typename = 'ProductVariant',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$stockLevel = json['stockLevel'];
    final l$price = json['price'];
    final l$product = json['product'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant(
      id: (l$id as String),
      name: (l$name as String),
      stockLevel: (l$stockLevel as String),
      price: (l$price as num).toDouble(),
      product:
          Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product
              .fromJson((l$product as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String stockLevel;

  final double price;

  final Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product
      product;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$stockLevel = stockLevel;
    _resultData['stockLevel'] = l$stockLevel;
    final l$price = price;
    _resultData['price'] = l$price;
    final l$product = product;
    _resultData['product'] = l$product.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$stockLevel = stockLevel;
    final l$price = price;
    final l$product = product;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$stockLevel,
      l$price,
      l$product,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$stockLevel = stockLevel;
    final lOther$stockLevel = other.stockLevel;
    if (l$stockLevel != lOther$stockLevel) {
      return false;
    }
    final l$price = price;
    final lOther$price = other.price;
    if (l$price != lOther$price) {
      return false;
    }
    final l$product = product;
    final lOther$product = other.product;
    if (l$product != lOther$product) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant
    on Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant<
          Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant(
    Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant;

  TRes call({
    String? id,
    String? name,
    String? stockLevel,
    double? price,
    Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product?
        product,
    String? $__typename,
  });
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product<
      TRes> get product;
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant _instance;

  final TRes Function(
      Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? stockLevel = _undefined,
    Object? price = _undefined,
    Object? product = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        stockLevel: stockLevel == _undefined || stockLevel == null
            ? _instance.stockLevel
            : (stockLevel as String),
        price: price == _undefined || price == null
            ? _instance.price
            : (price as double),
        product: product == _undefined || product == null
            ? _instance.product
            : (product
                as Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product<
      TRes> get product {
    final local$product = _instance.product;
    return CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product(
        local$product, (e) => call(product: e));
  }
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant(
      this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? stockLevel,
    double? price,
    Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product?
        product,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product<
          TRes>
      get product =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product
              .stub(_res);
}

class Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product
    implements Fragment$Cart$lines$productVariant$product {
  Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product({
    required this.enabled,
    this.$__typename = 'Product',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product.fromJson(
      Map<String, dynamic> json) {
    final l$enabled = json['enabled'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product(
      enabled: (l$enabled as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool enabled;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$enabled = enabled;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$enabled,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$enabled = enabled;
    final lOther$enabled = other.enabled;
    if (l$enabled != lOther$enabled) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product
    on Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product<
          Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product(
    Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product
        instance,
    TRes Function(
            Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product;

  TRes call({
    bool? enabled,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product
      _instance;

  final TRes Function(
          Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? enabled = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product(
        enabled: enabled == _undefined || enabled == null
            ? _instance.enabled
            : (enabled as bool),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$productVariant$product(
      this._res);

  TRes _res;

  call({
    bool? enabled,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$lines$discounts
    implements Fragment$Cart$lines$discounts {
  Mutation$AddToCart$addItemToOrder$$Order$lines$discounts({
    required this.amount,
    required this.amountWithTax,
    required this.description,
    required this.adjustmentSource,
    required this.type,
    this.$__typename = 'Discount',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$lines$discounts.fromJson(
      Map<String, dynamic> json) {
    final l$amount = json['amount'];
    final l$amountWithTax = json['amountWithTax'];
    final l$description = json['description'];
    final l$adjustmentSource = json['adjustmentSource'];
    final l$type = json['type'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$lines$discounts(
      amount: (l$amount as num).toDouble(),
      amountWithTax: (l$amountWithTax as num).toDouble(),
      description: (l$description as String),
      adjustmentSource: (l$adjustmentSource as String),
      type: fromJson$Enum$AdjustmentType((l$type as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final double amount;

  final double amountWithTax;

  final String description;

  final String adjustmentSource;

  final Enum$AdjustmentType type;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$amount = amount;
    _resultData['amount'] = l$amount;
    final l$amountWithTax = amountWithTax;
    _resultData['amountWithTax'] = l$amountWithTax;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$adjustmentSource = adjustmentSource;
    _resultData['adjustmentSource'] = l$adjustmentSource;
    final l$type = type;
    _resultData['type'] = toJson$Enum$AdjustmentType(l$type);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$amount = amount;
    final l$amountWithTax = amountWithTax;
    final l$description = description;
    final l$adjustmentSource = adjustmentSource;
    final l$type = type;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$amount,
      l$amountWithTax,
      l$description,
      l$adjustmentSource,
      l$type,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$Order$lines$discounts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$amount = amount;
    final lOther$amount = other.amount;
    if (l$amount != lOther$amount) {
      return false;
    }
    final l$amountWithTax = amountWithTax;
    final lOther$amountWithTax = other.amountWithTax;
    if (l$amountWithTax != lOther$amountWithTax) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$adjustmentSource = adjustmentSource;
    final lOther$adjustmentSource = other.adjustmentSource;
    if (l$adjustmentSource != lOther$adjustmentSource) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts
    on Mutation$AddToCart$addItemToOrder$$Order$lines$discounts {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts<
          Mutation$AddToCart$addItemToOrder$$Order$lines$discounts>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts(
    Mutation$AddToCart$addItemToOrder$$Order$lines$discounts instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order$lines$discounts)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts;

  TRes call({
    double? amount,
    double? amountWithTax,
    String? description,
    String? adjustmentSource,
    Enum$AdjustmentType? type,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$lines$discounts _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$Order$lines$discounts)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? amount = _undefined,
    Object? amountWithTax = _undefined,
    Object? description = _undefined,
    Object? adjustmentSource = _undefined,
    Object? type = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$lines$discounts(
        amount: amount == _undefined || amount == null
            ? _instance.amount
            : (amount as double),
        amountWithTax: amountWithTax == _undefined || amountWithTax == null
            ? _instance.amountWithTax
            : (amountWithTax as double),
        description: description == _undefined || description == null
            ? _instance.description
            : (description as String),
        adjustmentSource:
            adjustmentSource == _undefined || adjustmentSource == null
                ? _instance.adjustmentSource
                : (adjustmentSource as String),
        type: type == _undefined || type == null
            ? _instance.type
            : (type as Enum$AdjustmentType),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$lines$discounts(
      this._res);

  TRes _res;

  call({
    double? amount,
    double? amountWithTax,
    String? description,
    String? adjustmentSource,
    Enum$AdjustmentType? type,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$shippingLines
    implements Fragment$Cart$shippingLines {
  Mutation$AddToCart$addItemToOrder$$Order$shippingLines({
    required this.priceWithTax,
    required this.shippingMethod,
    this.$__typename = 'ShippingLine',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$shippingLines.fromJson(
      Map<String, dynamic> json) {
    final l$priceWithTax = json['priceWithTax'];
    final l$shippingMethod = json['shippingMethod'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$shippingLines(
      priceWithTax: (l$priceWithTax as num).toDouble(),
      shippingMethod:
          Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod
              .fromJson((l$shippingMethod as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final double priceWithTax;

  final Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod
      shippingMethod;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$priceWithTax = priceWithTax;
    _resultData['priceWithTax'] = l$priceWithTax;
    final l$shippingMethod = shippingMethod;
    _resultData['shippingMethod'] = l$shippingMethod.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$priceWithTax = priceWithTax;
    final l$shippingMethod = shippingMethod;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$priceWithTax,
      l$shippingMethod,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$Order$shippingLines ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$priceWithTax = priceWithTax;
    final lOther$priceWithTax = other.priceWithTax;
    if (l$priceWithTax != lOther$priceWithTax) {
      return false;
    }
    final l$shippingMethod = shippingMethod;
    final lOther$shippingMethod = other.shippingMethod;
    if (l$shippingMethod != lOther$shippingMethod) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$shippingLines
    on Mutation$AddToCart$addItemToOrder$$Order$shippingLines {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines<
          Mutation$AddToCart$addItemToOrder$$Order$shippingLines>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines(
    Mutation$AddToCart$addItemToOrder$$Order$shippingLines instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order$shippingLines) then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines;

  TRes call({
    double? priceWithTax,
    Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod?
        shippingMethod,
    String? $__typename,
  });
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod<
      TRes> get shippingMethod;
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines<TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines<TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$shippingLines _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$Order$shippingLines)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? priceWithTax = _undefined,
    Object? shippingMethod = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$shippingLines(
        priceWithTax: priceWithTax == _undefined || priceWithTax == null
            ? _instance.priceWithTax
            : (priceWithTax as double),
        shippingMethod: shippingMethod == _undefined || shippingMethod == null
            ? _instance.shippingMethod
            : (shippingMethod
                as Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod<
      TRes> get shippingMethod {
    final local$shippingMethod = _instance.shippingMethod;
    return CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod(
        local$shippingMethod, (e) => call(shippingMethod: e));
  }
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines<TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines(
      this._res);

  TRes _res;

  call({
    double? priceWithTax,
    Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod?
        shippingMethod,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod<
          TRes>
      get shippingMethod =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod
              .stub(_res);
}

class Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod
    implements Fragment$Cart$shippingLines$shippingMethod {
  Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    this.$__typename = 'ShippingMethod',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$name = json['name'];
    final l$description = json['description'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod(
      id: (l$id as String),
      code: (l$code as String),
      name: (l$name as String),
      description: (l$description as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String name;

  final String description;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$name = name;
    final l$description = description;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$name,
      l$description,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod
    on Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod<
          Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod(
    Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod
        instance,
    TRes Function(
            Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod;

  TRes call({
    String? id,
    String? code,
    String? name,
    String? description,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod
      _instance;

  final TRes Function(
          Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? name = _undefined,
    Object? description = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        description: description == _undefined || description == null
            ? _instance.description
            : (description as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$shippingLines$shippingMethod(
      this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    String? name,
    String? description,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$discounts
    implements Fragment$Cart$discounts {
  Mutation$AddToCart$addItemToOrder$$Order$discounts({
    required this.amount,
    required this.amountWithTax,
    required this.description,
    required this.adjustmentSource,
    required this.type,
    this.$__typename = 'Discount',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$discounts.fromJson(
      Map<String, dynamic> json) {
    final l$amount = json['amount'];
    final l$amountWithTax = json['amountWithTax'];
    final l$description = json['description'];
    final l$adjustmentSource = json['adjustmentSource'];
    final l$type = json['type'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$discounts(
      amount: (l$amount as num).toDouble(),
      amountWithTax: (l$amountWithTax as num).toDouble(),
      description: (l$description as String),
      adjustmentSource: (l$adjustmentSource as String),
      type: fromJson$Enum$AdjustmentType((l$type as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final double amount;

  final double amountWithTax;

  final String description;

  final String adjustmentSource;

  final Enum$AdjustmentType type;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$amount = amount;
    _resultData['amount'] = l$amount;
    final l$amountWithTax = amountWithTax;
    _resultData['amountWithTax'] = l$amountWithTax;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$adjustmentSource = adjustmentSource;
    _resultData['adjustmentSource'] = l$adjustmentSource;
    final l$type = type;
    _resultData['type'] = toJson$Enum$AdjustmentType(l$type);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$amount = amount;
    final l$amountWithTax = amountWithTax;
    final l$description = description;
    final l$adjustmentSource = adjustmentSource;
    final l$type = type;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$amount,
      l$amountWithTax,
      l$description,
      l$adjustmentSource,
      l$type,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$Order$discounts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$amount = amount;
    final lOther$amount = other.amount;
    if (l$amount != lOther$amount) {
      return false;
    }
    final l$amountWithTax = amountWithTax;
    final lOther$amountWithTax = other.amountWithTax;
    if (l$amountWithTax != lOther$amountWithTax) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$adjustmentSource = adjustmentSource;
    final lOther$adjustmentSource = other.adjustmentSource;
    if (l$adjustmentSource != lOther$adjustmentSource) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$discounts
    on Mutation$AddToCart$addItemToOrder$$Order$discounts {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$discounts<
          Mutation$AddToCart$addItemToOrder$$Order$discounts>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$discounts(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$discounts<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$discounts(
    Mutation$AddToCart$addItemToOrder$$Order$discounts instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order$discounts) then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$discounts;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$discounts.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$discounts;

  TRes call({
    double? amount,
    double? amountWithTax,
    String? description,
    String? adjustmentSource,
    Enum$AdjustmentType? type,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$discounts<TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$discounts<TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$discounts(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$discounts _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$Order$discounts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? amount = _undefined,
    Object? amountWithTax = _undefined,
    Object? description = _undefined,
    Object? adjustmentSource = _undefined,
    Object? type = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$discounts(
        amount: amount == _undefined || amount == null
            ? _instance.amount
            : (amount as double),
        amountWithTax: amountWithTax == _undefined || amountWithTax == null
            ? _instance.amountWithTax
            : (amountWithTax as double),
        description: description == _undefined || description == null
            ? _instance.description
            : (description as String),
        adjustmentSource:
            adjustmentSource == _undefined || adjustmentSource == null
                ? _instance.adjustmentSource
                : (adjustmentSource as String),
        type: type == _undefined || type == null
            ? _instance.type
            : (type as Enum$AdjustmentType),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$discounts<TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$discounts<TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$discounts(
      this._res);

  TRes _res;

  call({
    double? amount,
    double? amountWithTax,
    String? description,
    String? adjustmentSource,
    Enum$AdjustmentType? type,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$customFields
    implements Fragment$Cart$customFields {
  Mutation$AddToCart$addItemToOrder$$Order$customFields({
    this.loyaltyPointsEarned,
    this.loyaltyPointsUsed,
    this.otherInstructions,
    this.$__typename = 'OrderCustomFields',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$loyaltyPointsEarned = json['loyaltyPointsEarned'];
    final l$loyaltyPointsUsed = json['loyaltyPointsUsed'];
    final l$otherInstructions = json['otherInstructions'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$customFields(
      loyaltyPointsEarned: (l$loyaltyPointsEarned as int?),
      loyaltyPointsUsed: (l$loyaltyPointsUsed as int?),
      otherInstructions: (l$otherInstructions as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? loyaltyPointsEarned;

  final int? loyaltyPointsUsed;

  final String? otherInstructions;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    _resultData['loyaltyPointsEarned'] = l$loyaltyPointsEarned;
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    _resultData['loyaltyPointsUsed'] = l$loyaltyPointsUsed;
    final l$otherInstructions = otherInstructions;
    _resultData['otherInstructions'] = l$otherInstructions;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    final l$otherInstructions = otherInstructions;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$loyaltyPointsEarned,
      l$loyaltyPointsUsed,
      l$otherInstructions,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$Order$customFields ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    final lOther$loyaltyPointsEarned = other.loyaltyPointsEarned;
    if (l$loyaltyPointsEarned != lOther$loyaltyPointsEarned) {
      return false;
    }
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    final lOther$loyaltyPointsUsed = other.loyaltyPointsUsed;
    if (l$loyaltyPointsUsed != lOther$loyaltyPointsUsed) {
      return false;
    }
    final l$otherInstructions = otherInstructions;
    final lOther$otherInstructions = other.otherInstructions;
    if (l$otherInstructions != lOther$otherInstructions) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$customFields
    on Mutation$AddToCart$addItemToOrder$$Order$customFields {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields<
          Mutation$AddToCart$addItemToOrder$$Order$customFields>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields(
    Mutation$AddToCart$addItemToOrder$$Order$customFields instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order$customFields) then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$customFields;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$customFields;

  TRes call({
    int? loyaltyPointsEarned,
    int? loyaltyPointsUsed,
    String? otherInstructions,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$customFields<TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields<TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$customFields(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$customFields _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$Order$customFields)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? loyaltyPointsEarned = _undefined,
    Object? loyaltyPointsUsed = _undefined,
    Object? otherInstructions = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$customFields(
        loyaltyPointsEarned: loyaltyPointsEarned == _undefined
            ? _instance.loyaltyPointsEarned
            : (loyaltyPointsEarned as int?),
        loyaltyPointsUsed: loyaltyPointsUsed == _undefined
            ? _instance.loyaltyPointsUsed
            : (loyaltyPointsUsed as int?),
        otherInstructions: otherInstructions == _undefined
            ? _instance.otherInstructions
            : (otherInstructions as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$customFields<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$customFields<TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$customFields(
      this._res);

  TRes _res;

  call({
    int? loyaltyPointsEarned,
    int? loyaltyPointsUsed,
    String? otherInstructions,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus
    implements Fragment$Cart$quantityLimitStatus {
  Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus({
    required this.isValid,
    required this.hasViolations,
    required this.totalViolations,
    required this.violations,
    this.$__typename = 'QuantityLimitValidationStatus',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus.fromJson(
      Map<String, dynamic> json) {
    final l$isValid = json['isValid'];
    final l$hasViolations = json['hasViolations'];
    final l$totalViolations = json['totalViolations'];
    final l$violations = json['violations'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus(
      isValid: (l$isValid as bool),
      hasViolations: (l$hasViolations as bool),
      totalViolations: (l$totalViolations as int),
      violations: (l$violations as List<dynamic>)
          .map((e) =>
              Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final bool isValid;

  final bool hasViolations;

  final int totalViolations;

  final List<
          Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations>
      violations;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$isValid = isValid;
    _resultData['isValid'] = l$isValid;
    final l$hasViolations = hasViolations;
    _resultData['hasViolations'] = l$hasViolations;
    final l$totalViolations = totalViolations;
    _resultData['totalViolations'] = l$totalViolations;
    final l$violations = violations;
    _resultData['violations'] = l$violations.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$isValid = isValid;
    final l$hasViolations = hasViolations;
    final l$totalViolations = totalViolations;
    final l$violations = violations;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$isValid,
      l$hasViolations,
      l$totalViolations,
      Object.hashAll(l$violations.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$isValid = isValid;
    final lOther$isValid = other.isValid;
    if (l$isValid != lOther$isValid) {
      return false;
    }
    final l$hasViolations = hasViolations;
    final lOther$hasViolations = other.hasViolations;
    if (l$hasViolations != lOther$hasViolations) {
      return false;
    }
    final l$totalViolations = totalViolations;
    final lOther$totalViolations = other.totalViolations;
    if (l$totalViolations != lOther$totalViolations) {
      return false;
    }
    final l$violations = violations;
    final lOther$violations = other.violations;
    if (l$violations.length != lOther$violations.length) {
      return false;
    }
    for (int i = 0; i < l$violations.length; i++) {
      final l$violations$entry = l$violations[i];
      final lOther$violations$entry = lOther$violations[i];
      if (l$violations$entry != lOther$violations$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus
    on Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus<
          Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus(
    Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus;

  TRes call({
    bool? isValid,
    bool? hasViolations,
    int? totalViolations,
    List<Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations>?
        violations,
    String? $__typename,
  });
  TRes violations(
      Iterable<Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations> Function(
              Iterable<
                  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations<
                      Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations>>)
          _fn);
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus _instance;

  final TRes Function(
      Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? isValid = _undefined,
    Object? hasViolations = _undefined,
    Object? totalViolations = _undefined,
    Object? violations = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus(
        isValid: isValid == _undefined || isValid == null
            ? _instance.isValid
            : (isValid as bool),
        hasViolations: hasViolations == _undefined || hasViolations == null
            ? _instance.hasViolations
            : (hasViolations as bool),
        totalViolations:
            totalViolations == _undefined || totalViolations == null
                ? _instance.totalViolations
                : (totalViolations as int),
        violations: violations == _undefined || violations == null
            ? _instance.violations
            : (violations as List<
                Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes violations(
          Iterable<Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations> Function(
                  Iterable<
                      CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations<
                          Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations>>)
              _fn) =>
      call(
          violations: _fn(_instance.violations.map((e) =>
              CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus(
      this._res);

  TRes _res;

  call({
    bool? isValid,
    bool? hasViolations,
    int? totalViolations,
    List<Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations>?
        violations,
    String? $__typename,
  }) =>
      _res;

  violations(_fn) => _res;
}

class Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations
    implements Fragment$Cart$quantityLimitStatus$violations {
  Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations({
    required this.orderLineId,
    required this.productName,
    required this.variantName,
    required this.currentQuantity,
    required this.maxQuantity,
    required this.reason,
    this.$__typename = 'QuantityLimitViolation',
  });

  factory Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations.fromJson(
      Map<String, dynamic> json) {
    final l$orderLineId = json['orderLineId'];
    final l$productName = json['productName'];
    final l$variantName = json['variantName'];
    final l$currentQuantity = json['currentQuantity'];
    final l$maxQuantity = json['maxQuantity'];
    final l$reason = json['reason'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations(
      orderLineId: (l$orderLineId as String),
      productName: (l$productName as String),
      variantName: (l$variantName as String),
      currentQuantity: (l$currentQuantity as int),
      maxQuantity: (l$maxQuantity as int),
      reason: (l$reason as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String orderLineId;

  final String productName;

  final String variantName;

  final int currentQuantity;

  final int maxQuantity;

  final String reason;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$orderLineId = orderLineId;
    _resultData['orderLineId'] = l$orderLineId;
    final l$productName = productName;
    _resultData['productName'] = l$productName;
    final l$variantName = variantName;
    _resultData['variantName'] = l$variantName;
    final l$currentQuantity = currentQuantity;
    _resultData['currentQuantity'] = l$currentQuantity;
    final l$maxQuantity = maxQuantity;
    _resultData['maxQuantity'] = l$maxQuantity;
    final l$reason = reason;
    _resultData['reason'] = l$reason;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$orderLineId = orderLineId;
    final l$productName = productName;
    final l$variantName = variantName;
    final l$currentQuantity = currentQuantity;
    final l$maxQuantity = maxQuantity;
    final l$reason = reason;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$orderLineId,
      l$productName,
      l$variantName,
      l$currentQuantity,
      l$maxQuantity,
      l$reason,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$orderLineId = orderLineId;
    final lOther$orderLineId = other.orderLineId;
    if (l$orderLineId != lOther$orderLineId) {
      return false;
    }
    final l$productName = productName;
    final lOther$productName = other.productName;
    if (l$productName != lOther$productName) {
      return false;
    }
    final l$variantName = variantName;
    final lOther$variantName = other.variantName;
    if (l$variantName != lOther$variantName) {
      return false;
    }
    final l$currentQuantity = currentQuantity;
    final lOther$currentQuantity = other.currentQuantity;
    if (l$currentQuantity != lOther$currentQuantity) {
      return false;
    }
    final l$maxQuantity = maxQuantity;
    final lOther$maxQuantity = other.maxQuantity;
    if (l$maxQuantity != lOther$maxQuantity) {
      return false;
    }
    final l$reason = reason;
    final lOther$reason = other.reason;
    if (l$reason != lOther$reason) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations
    on Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations {
  CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations<
          Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations(
    Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations
        instance,
    TRes Function(
            Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations;

  TRes call({
    String? orderLineId,
    String? productName,
    String? variantName,
    int? currentQuantity,
    int? maxQuantity,
    String? reason,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations
      _instance;

  final TRes Function(
          Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? orderLineId = _undefined,
    Object? productName = _undefined,
    Object? variantName = _undefined,
    Object? currentQuantity = _undefined,
    Object? maxQuantity = _undefined,
    Object? reason = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations(
        orderLineId: orderLineId == _undefined || orderLineId == null
            ? _instance.orderLineId
            : (orderLineId as String),
        productName: productName == _undefined || productName == null
            ? _instance.productName
            : (productName as String),
        variantName: variantName == _undefined || variantName == null
            ? _instance.variantName
            : (variantName as String),
        currentQuantity:
            currentQuantity == _undefined || currentQuantity == null
                ? _instance.currentQuantity
                : (currentQuantity as int),
        maxQuantity: maxQuantity == _undefined || maxQuantity == null
            ? _instance.maxQuantity
            : (maxQuantity as int),
        reason: reason == _undefined || reason == null
            ? _instance.reason
            : (reason as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$Order$quantityLimitStatus$violations(
      this._res);

  TRes _res;

  call({
    String? orderLineId,
    String? productName,
    String? variantName,
    int? currentQuantity,
    int? maxQuantity,
    String? reason,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$OrderModificationError
    implements
        Fragment$ErrorResult$$OrderModificationError,
        Mutation$AddToCart$addItemToOrder {
  Mutation$AddToCart$addItemToOrder$$OrderModificationError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'OrderModificationError',
  });

  factory Mutation$AddToCart$addItemToOrder$$OrderModificationError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$OrderModificationError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$OrderModificationError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$OrderModificationError
    on Mutation$AddToCart$addItemToOrder$$OrderModificationError {
  CopyWith$Mutation$AddToCart$addItemToOrder$$OrderModificationError<
          Mutation$AddToCart$addItemToOrder$$OrderModificationError>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$OrderModificationError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$OrderModificationError<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$OrderModificationError(
    Mutation$AddToCart$addItemToOrder$$OrderModificationError instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$OrderModificationError)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$OrderModificationError;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$OrderModificationError.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$OrderModificationError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$OrderModificationError<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$OrderModificationError<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$OrderModificationError(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$OrderModificationError _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$OrderModificationError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$OrderModificationError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$OrderModificationError<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$OrderModificationError<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$OrderModificationError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$OrderLimitError
    implements
        Fragment$ErrorResult$$OrderLimitError,
        Mutation$AddToCart$addItemToOrder {
  Mutation$AddToCart$addItemToOrder$$OrderLimitError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'OrderLimitError',
  });

  factory Mutation$AddToCart$addItemToOrder$$OrderLimitError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$OrderLimitError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$OrderLimitError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$OrderLimitError
    on Mutation$AddToCart$addItemToOrder$$OrderLimitError {
  CopyWith$Mutation$AddToCart$addItemToOrder$$OrderLimitError<
          Mutation$AddToCart$addItemToOrder$$OrderLimitError>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$OrderLimitError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$OrderLimitError<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$OrderLimitError(
    Mutation$AddToCart$addItemToOrder$$OrderLimitError instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$OrderLimitError) then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$OrderLimitError;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$OrderLimitError.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$OrderLimitError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$OrderLimitError<TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$OrderLimitError<TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$OrderLimitError(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$OrderLimitError _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$OrderLimitError) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$OrderLimitError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$OrderLimitError<TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$OrderLimitError<TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$OrderLimitError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}

class Mutation$AddToCart$addItemToOrder$$NegativeQuantityError
    implements
        Fragment$ErrorResult$$NegativeQuantityError,
        Mutation$AddToCart$addItemToOrder {
  Mutation$AddToCart$addItemToOrder$$NegativeQuantityError({
    required this.errorCode,
    required this.message,
    this.$__typename = 'NegativeQuantityError',
  });

  factory Mutation$AddToCart$addItemToOrder$$NegativeQuantityError.fromJson(
      Map<String, dynamic> json) {
    final l$errorCode = json['errorCode'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation$AddToCart$addItemToOrder$$NegativeQuantityError(
      errorCode: fromJson$Enum$ErrorCode((l$errorCode as String)),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ErrorCode errorCode;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$errorCode = errorCode;
    _resultData['errorCode'] = toJson$Enum$ErrorCode(l$errorCode);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$errorCode = errorCode;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$errorCode,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AddToCart$addItemToOrder$$NegativeQuantityError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$errorCode = errorCode;
    final lOther$errorCode = other.errorCode;
    if (l$errorCode != lOther$errorCode) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError
    on Mutation$AddToCart$addItemToOrder$$NegativeQuantityError {
  CopyWith$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError<
          Mutation$AddToCart$addItemToOrder$$NegativeQuantityError>
      get copyWith =>
          CopyWith$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError<
    TRes> {
  factory CopyWith$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError(
    Mutation$AddToCart$addItemToOrder$$NegativeQuantityError instance,
    TRes Function(Mutation$AddToCart$addItemToOrder$$NegativeQuantityError)
        then,
  ) = _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError;

  factory CopyWith$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError;

  TRes call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError<
            TRes> {
  _CopyWithImpl$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError(
    this._instance,
    this._then,
  );

  final Mutation$AddToCart$addItemToOrder$$NegativeQuantityError _instance;

  final TRes Function(Mutation$AddToCart$addItemToOrder$$NegativeQuantityError)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? errorCode = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$AddToCart$addItemToOrder$$NegativeQuantityError(
        errorCode: errorCode == _undefined || errorCode == null
            ? _instance.errorCode
            : (errorCode as Enum$ErrorCode),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError<
        TRes>
    implements
        CopyWith$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError<
            TRes> {
  _CopyWithStubImpl$Mutation$AddToCart$addItemToOrder$$NegativeQuantityError(
      this._res);

  TRes _res;

  call({
    Enum$ErrorCode? errorCode,
    String? message,
    String? $__typename,
  }) =>
      _res;
}
