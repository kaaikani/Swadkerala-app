import 'dart:async';
import 'order.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

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

class Fragment$Options {
  Fragment$Options({
    required this.id,
    required this.code,
    required this.name,
    this.$__typename = 'ProductOption',
  });

  factory Fragment$Options.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$Options(
      id: (l$id as String),
      code: (l$code as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$name,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$Options || runtimeType != other.runtimeType) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$Options on Fragment$Options {
  CopyWith$Fragment$Options<Fragment$Options> get copyWith =>
      CopyWith$Fragment$Options(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$Options<TRes> {
  factory CopyWith$Fragment$Options(
    Fragment$Options instance,
    TRes Function(Fragment$Options) then,
  ) = _CopyWithImpl$Fragment$Options;

  factory CopyWith$Fragment$Options.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Options;

  TRes call({
    String? id,
    String? code,
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$Options<TRes>
    implements CopyWith$Fragment$Options<TRes> {
  _CopyWithImpl$Fragment$Options(
    this._instance,
    this._then,
  );

  final Fragment$Options _instance;

  final TRes Function(Fragment$Options) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$Options(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$Options<TRes>
    implements CopyWith$Fragment$Options<TRes> {
  _CopyWithStubImpl$Fragment$Options(this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    String? name,
    String? $__typename,
  }) =>
      _res;
}

const fragmentDefinitionOptions = FragmentDefinitionNode(
  name: NameNode(value: 'Options'),
  typeCondition: TypeConditionNode(
      on: NamedTypeNode(
    name: NameNode(value: 'ProductOption'),
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
);
const documentNodeFragmentOptions = DocumentNode(definitions: [
  fragmentDefinitionOptions,
]);

extension ClientExtension$Fragment$Options on graphql.GraphQLClient {
  void writeFragment$Options({
    required Fragment$Options data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) =>
      this.writeFragment(
        graphql.FragmentRequest(
          idFields: idFields,
          fragment: const graphql.Fragment(
            fragmentName: 'Options',
            document: documentNodeFragmentOptions,
          ),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Fragment$Options? readFragment$Options({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'Options',
          document: documentNodeFragmentOptions,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$Options.fromJson(result);
  }
}

class Variables$Query$GetProductDetail {
  factory Variables$Query$GetProductDetail({required String id}) =>
      Variables$Query$GetProductDetail._({
        r'id': id,
      });

  Variables$Query$GetProductDetail._(this._$data);

  factory Variables$Query$GetProductDetail.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$GetProductDetail._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Query$GetProductDetail<Variables$Query$GetProductDetail>
      get copyWith => CopyWith$Variables$Query$GetProductDetail(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetProductDetail ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Variables$Query$GetProductDetail<TRes> {
  factory CopyWith$Variables$Query$GetProductDetail(
    Variables$Query$GetProductDetail instance,
    TRes Function(Variables$Query$GetProductDetail) then,
  ) = _CopyWithImpl$Variables$Query$GetProductDetail;

  factory CopyWith$Variables$Query$GetProductDetail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetProductDetail;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$GetProductDetail<TRes>
    implements CopyWith$Variables$Query$GetProductDetail<TRes> {
  _CopyWithImpl$Variables$Query$GetProductDetail(
    this._instance,
    this._then,
  );

  final Variables$Query$GetProductDetail _instance;

  final TRes Function(Variables$Query$GetProductDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) =>
      _then(Variables$Query$GetProductDetail._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$GetProductDetail<TRes>
    implements CopyWith$Variables$Query$GetProductDetail<TRes> {
  _CopyWithStubImpl$Variables$Query$GetProductDetail(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$GetProductDetail {
  Query$GetProductDetail({
    this.product,
    this.$__typename = 'Query',
  });

  factory Query$GetProductDetail.fromJson(Map<String, dynamic> json) {
    final l$product = json['product'];
    final l$$__typename = json['__typename'];
    return Query$GetProductDetail(
      product: l$product == null
          ? null
          : Query$GetProductDetail$product.fromJson(
              (l$product as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GetProductDetail$product? product;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$product = product;
    _resultData['product'] = l$product?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$product = product;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$product,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetProductDetail || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$GetProductDetail on Query$GetProductDetail {
  CopyWith$Query$GetProductDetail<Query$GetProductDetail> get copyWith =>
      CopyWith$Query$GetProductDetail(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetProductDetail<TRes> {
  factory CopyWith$Query$GetProductDetail(
    Query$GetProductDetail instance,
    TRes Function(Query$GetProductDetail) then,
  ) = _CopyWithImpl$Query$GetProductDetail;

  factory CopyWith$Query$GetProductDetail.stub(TRes res) =
      _CopyWithStubImpl$Query$GetProductDetail;

  TRes call({
    Query$GetProductDetail$product? product,
    String? $__typename,
  });
  CopyWith$Query$GetProductDetail$product<TRes> get product;
}

class _CopyWithImpl$Query$GetProductDetail<TRes>
    implements CopyWith$Query$GetProductDetail<TRes> {
  _CopyWithImpl$Query$GetProductDetail(
    this._instance,
    this._then,
  );

  final Query$GetProductDetail _instance;

  final TRes Function(Query$GetProductDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? product = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetProductDetail(
        product: product == _undefined
            ? _instance.product
            : (product as Query$GetProductDetail$product?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetProductDetail$product<TRes> get product {
    final local$product = _instance.product;
    return local$product == null
        ? CopyWith$Query$GetProductDetail$product.stub(_then(_instance))
        : CopyWith$Query$GetProductDetail$product(
            local$product, (e) => call(product: e));
  }
}

class _CopyWithStubImpl$Query$GetProductDetail<TRes>
    implements CopyWith$Query$GetProductDetail<TRes> {
  _CopyWithStubImpl$Query$GetProductDetail(this._res);

  TRes _res;

  call({
    Query$GetProductDetail$product? product,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetProductDetail$product<TRes> get product =>
      CopyWith$Query$GetProductDetail$product.stub(_res);
}

const documentNodeQueryGetProductDetail = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetProductDetail'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'id')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'product'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'id'),
            value: VariableNode(name: NameNode(value: 'id')),
          )
        ],
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
            name: NameNode(value: 'description'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'variants'),
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
                name: NameNode(value: 'options'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
                  FragmentSpreadNode(
                    name: NameNode(value: 'Options'),
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
                name: NameNode(value: 'price'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'priceWithTax'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'currencyCode'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'languageCode'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'assets'),
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
                    name: NameNode(value: 'preview'),
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
                name: NameNode(value: 'options'),
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
                    name: NameNode(value: 'group'),
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
                name: NameNode(value: 'sku'),
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
              FieldNode(
                name: NameNode(value: 'customFields'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
                  FieldNode(
                    name: NameNode(value: 'shadowPrice'),
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
            ]),
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
            name: NameNode(value: 'assets'),
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
            name: NameNode(value: 'collections'),
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
                name: NameNode(value: 'slug'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'breadcrumbs'),
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
                    name: NameNode(value: 'slug'),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
  fragmentDefinitionOptions,
  fragmentDefinitionAsset,
]);
Query$GetProductDetail _parserFn$Query$GetProductDetail(
        Map<String, dynamic> data) =>
    Query$GetProductDetail.fromJson(data);
typedef OnQueryComplete$Query$GetProductDetail = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GetProductDetail?,
);

class Options$Query$GetProductDetail
    extends graphql.QueryOptions<Query$GetProductDetail> {
  Options$Query$GetProductDetail({
    String? operationName,
    required Variables$Query$GetProductDetail variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetProductDetail? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetProductDetail? onComplete,
    graphql.OnQueryError? onError,
  })  : onCompleteWithParsed = onComplete,
        super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          pollInterval: pollInterval,
          context: context,
          onComplete: onComplete == null
              ? null
              : (data) => onComplete(
                    data,
                    data == null
                        ? null
                        : _parserFn$Query$GetProductDetail(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetProductDetail,
          parserFn: _parserFn$Query$GetProductDetail,
        );

  final OnQueryComplete$Query$GetProductDetail? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetProductDetail
    extends graphql.WatchQueryOptions<Query$GetProductDetail> {
  WatchOptions$Query$GetProductDetail({
    String? operationName,
    required Variables$Query$GetProductDetail variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetProductDetail? typedOptimisticResult,
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
          document: documentNodeQueryGetProductDetail,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetProductDetail,
        );
}

class FetchMoreOptions$Query$GetProductDetail extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetProductDetail({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetProductDetail variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryGetProductDetail,
        );
}

extension ClientExtension$Query$GetProductDetail on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetProductDetail>> query$GetProductDetail(
          Options$Query$GetProductDetail options) async =>
      await this.query(options);

  graphql.ObservableQuery<Query$GetProductDetail> watchQuery$GetProductDetail(
          WatchOptions$Query$GetProductDetail options) =>
      this.watchQuery(options);

  void writeQuery$GetProductDetail({
    required Query$GetProductDetail data,
    required Variables$Query$GetProductDetail variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryGetProductDetail),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$GetProductDetail? readQuery$GetProductDetail({
    required Variables$Query$GetProductDetail variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation:
            graphql.Operation(document: documentNodeQueryGetProductDetail),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetProductDetail.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetProductDetail>
    useQuery$GetProductDetail(Options$Query$GetProductDetail options) =>
        graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$GetProductDetail> useWatchQuery$GetProductDetail(
        WatchOptions$Query$GetProductDetail options) =>
    graphql_flutter.useWatchQuery(options);

class Query$GetProductDetail$Widget
    extends graphql_flutter.Query<Query$GetProductDetail> {
  Query$GetProductDetail$Widget({
    widgets.Key? key,
    required Options$Query$GetProductDetail options,
    required graphql_flutter.QueryBuilder<Query$GetProductDetail> builder,
  }) : super(
          key: key,
          options: options,
          builder: builder,
        );
}

class Query$GetProductDetail$product {
  Query$GetProductDetail$product({
    required this.id,
    required this.name,
    required this.description,
    required this.variants,
    this.featuredAsset,
    required this.assets,
    required this.collections,
    this.$__typename = 'Product',
  });

  factory Query$GetProductDetail$product.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$description = json['description'];
    final l$variants = json['variants'];
    final l$featuredAsset = json['featuredAsset'];
    final l$assets = json['assets'];
    final l$collections = json['collections'];
    final l$$__typename = json['__typename'];
    return Query$GetProductDetail$product(
      id: (l$id as String),
      name: (l$name as String),
      description: (l$description as String),
      variants: (l$variants as List<dynamic>)
          .map((e) => Query$GetProductDetail$product$variants.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      featuredAsset: l$featuredAsset == null
          ? null
          : Fragment$Asset.fromJson((l$featuredAsset as Map<String, dynamic>)),
      assets: (l$assets as List<dynamic>)
          .map((e) => Fragment$Asset.fromJson((e as Map<String, dynamic>)))
          .toList(),
      collections: (l$collections as List<dynamic>)
          .map((e) => Query$GetProductDetail$product$collections.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String description;

  final List<Query$GetProductDetail$product$variants> variants;

  final Fragment$Asset? featuredAsset;

  final List<Fragment$Asset> assets;

  final List<Query$GetProductDetail$product$collections> collections;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$variants = variants;
    _resultData['variants'] = l$variants.map((e) => e.toJson()).toList();
    final l$featuredAsset = featuredAsset;
    _resultData['featuredAsset'] = l$featuredAsset?.toJson();
    final l$assets = assets;
    _resultData['assets'] = l$assets.map((e) => e.toJson()).toList();
    final l$collections = collections;
    _resultData['collections'] = l$collections.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$description = description;
    final l$variants = variants;
    final l$featuredAsset = featuredAsset;
    final l$assets = assets;
    final l$collections = collections;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$description,
      Object.hashAll(l$variants.map((v) => v)),
      l$featuredAsset,
      Object.hashAll(l$assets.map((v) => v)),
      Object.hashAll(l$collections.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetProductDetail$product ||
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
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$variants = variants;
    final lOther$variants = other.variants;
    if (l$variants.length != lOther$variants.length) {
      return false;
    }
    for (int i = 0; i < l$variants.length; i++) {
      final l$variants$entry = l$variants[i];
      final lOther$variants$entry = lOther$variants[i];
      if (l$variants$entry != lOther$variants$entry) {
        return false;
      }
    }
    final l$featuredAsset = featuredAsset;
    final lOther$featuredAsset = other.featuredAsset;
    if (l$featuredAsset != lOther$featuredAsset) {
      return false;
    }
    final l$assets = assets;
    final lOther$assets = other.assets;
    if (l$assets.length != lOther$assets.length) {
      return false;
    }
    for (int i = 0; i < l$assets.length; i++) {
      final l$assets$entry = l$assets[i];
      final lOther$assets$entry = lOther$assets[i];
      if (l$assets$entry != lOther$assets$entry) {
        return false;
      }
    }
    final l$collections = collections;
    final lOther$collections = other.collections;
    if (l$collections.length != lOther$collections.length) {
      return false;
    }
    for (int i = 0; i < l$collections.length; i++) {
      final l$collections$entry = l$collections[i];
      final lOther$collections$entry = lOther$collections[i];
      if (l$collections$entry != lOther$collections$entry) {
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

extension UtilityExtension$Query$GetProductDetail$product
    on Query$GetProductDetail$product {
  CopyWith$Query$GetProductDetail$product<Query$GetProductDetail$product>
      get copyWith => CopyWith$Query$GetProductDetail$product(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetProductDetail$product<TRes> {
  factory CopyWith$Query$GetProductDetail$product(
    Query$GetProductDetail$product instance,
    TRes Function(Query$GetProductDetail$product) then,
  ) = _CopyWithImpl$Query$GetProductDetail$product;

  factory CopyWith$Query$GetProductDetail$product.stub(TRes res) =
      _CopyWithStubImpl$Query$GetProductDetail$product;

  TRes call({
    String? id,
    String? name,
    String? description,
    List<Query$GetProductDetail$product$variants>? variants,
    Fragment$Asset? featuredAsset,
    List<Fragment$Asset>? assets,
    List<Query$GetProductDetail$product$collections>? collections,
    String? $__typename,
  });
  TRes variants(
      Iterable<Query$GetProductDetail$product$variants> Function(
              Iterable<
                  CopyWith$Query$GetProductDetail$product$variants<
                      Query$GetProductDetail$product$variants>>)
          _fn);
  CopyWith$Fragment$Asset<TRes> get featuredAsset;
  TRes assets(
      Iterable<Fragment$Asset> Function(
              Iterable<CopyWith$Fragment$Asset<Fragment$Asset>>)
          _fn);
  TRes collections(
      Iterable<Query$GetProductDetail$product$collections> Function(
              Iterable<
                  CopyWith$Query$GetProductDetail$product$collections<
                      Query$GetProductDetail$product$collections>>)
          _fn);
}

class _CopyWithImpl$Query$GetProductDetail$product<TRes>
    implements CopyWith$Query$GetProductDetail$product<TRes> {
  _CopyWithImpl$Query$GetProductDetail$product(
    this._instance,
    this._then,
  );

  final Query$GetProductDetail$product _instance;

  final TRes Function(Query$GetProductDetail$product) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? description = _undefined,
    Object? variants = _undefined,
    Object? featuredAsset = _undefined,
    Object? assets = _undefined,
    Object? collections = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetProductDetail$product(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        description: description == _undefined || description == null
            ? _instance.description
            : (description as String),
        variants: variants == _undefined || variants == null
            ? _instance.variants
            : (variants as List<Query$GetProductDetail$product$variants>),
        featuredAsset: featuredAsset == _undefined
            ? _instance.featuredAsset
            : (featuredAsset as Fragment$Asset?),
        assets: assets == _undefined || assets == null
            ? _instance.assets
            : (assets as List<Fragment$Asset>),
        collections: collections == _undefined || collections == null
            ? _instance.collections
            : (collections as List<Query$GetProductDetail$product$collections>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes variants(
          Iterable<Query$GetProductDetail$product$variants> Function(
                  Iterable<
                      CopyWith$Query$GetProductDetail$product$variants<
                          Query$GetProductDetail$product$variants>>)
              _fn) =>
      call(
          variants: _fn(_instance.variants
              .map((e) => CopyWith$Query$GetProductDetail$product$variants(
                    e,
                    (i) => i,
                  ))).toList());

  CopyWith$Fragment$Asset<TRes> get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Fragment$Asset.stub(_then(_instance))
        : CopyWith$Fragment$Asset(
            local$featuredAsset, (e) => call(featuredAsset: e));
  }

  TRes assets(
          Iterable<Fragment$Asset> Function(
                  Iterable<CopyWith$Fragment$Asset<Fragment$Asset>>)
              _fn) =>
      call(
          assets: _fn(_instance.assets.map((e) => CopyWith$Fragment$Asset(
                e,
                (i) => i,
              ))).toList());

  TRes collections(
          Iterable<Query$GetProductDetail$product$collections> Function(
                  Iterable<
                      CopyWith$Query$GetProductDetail$product$collections<
                          Query$GetProductDetail$product$collections>>)
              _fn) =>
      call(
          collections: _fn(_instance.collections
              .map((e) => CopyWith$Query$GetProductDetail$product$collections(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$GetProductDetail$product<TRes>
    implements CopyWith$Query$GetProductDetail$product<TRes> {
  _CopyWithStubImpl$Query$GetProductDetail$product(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? description,
    List<Query$GetProductDetail$product$variants>? variants,
    Fragment$Asset? featuredAsset,
    List<Fragment$Asset>? assets,
    List<Query$GetProductDetail$product$collections>? collections,
    String? $__typename,
  }) =>
      _res;

  variants(_fn) => _res;

  CopyWith$Fragment$Asset<TRes> get featuredAsset =>
      CopyWith$Fragment$Asset.stub(_res);

  assets(_fn) => _res;

  collections(_fn) => _res;
}

class Query$GetProductDetail$product$variants {
  Query$GetProductDetail$product$variants({
    required this.id,
    required this.name,
    required this.stockLevel,
    required this.options,
    this.featuredAsset,
    required this.price,
    required this.priceWithTax,
    required this.currencyCode,
    required this.languageCode,
    required this.assets,
    required this.sku,
    this.$__typename = 'ProductVariant',
    this.customFields,
  });

  factory Query$GetProductDetail$product$variants.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$stockLevel = json['stockLevel'];
    final l$options = json['options'];
    final l$featuredAsset = json['featuredAsset'];
    final l$price = json['price'];
    final l$priceWithTax = json['priceWithTax'];
    final l$currencyCode = json['currencyCode'];
    final l$languageCode = json['languageCode'];
    final l$assets = json['assets'];
    final l$sku = json['sku'];
    final l$$__typename = json['__typename'];
    final l$customFields = json['customFields'];
    return Query$GetProductDetail$product$variants(
      id: (l$id as String),
      name: (l$name as String),
      stockLevel: (l$stockLevel as String),
      options: (l$options as List<dynamic>)
          .map((e) => Query$GetProductDetail$product$variants$options.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      featuredAsset: l$featuredAsset == null
          ? null
          : Fragment$Asset.fromJson((l$featuredAsset as Map<String, dynamic>)),
      price: (l$price as num).toDouble(),
      priceWithTax: (l$priceWithTax as num).toDouble(),
      currencyCode: fromJson$Enum$CurrencyCode((l$currencyCode as String)),
      languageCode: fromJson$Enum$LanguageCode((l$languageCode as String)),
      assets: (l$assets as List<dynamic>)
          .map((e) => Query$GetProductDetail$product$variants$assets.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      sku: (l$sku as String),
      $__typename: (l$$__typename as String),
      customFields: l$customFields == null
          ? null
          : Query$GetProductDetail$product$variants$customFields.fromJson(
              (l$customFields as Map<String, dynamic>)),
    );
  }

  final String id;

  final String name;

  final String stockLevel;

  final List<Query$GetProductDetail$product$variants$options> options;

  final Fragment$Asset? featuredAsset;

  final double price;

  final double priceWithTax;

  final Enum$CurrencyCode currencyCode;

  final Enum$LanguageCode languageCode;

  final List<Query$GetProductDetail$product$variants$assets> assets;

  final String sku;

  final String $__typename;

  final Query$GetProductDetail$product$variants$customFields? customFields;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$stockLevel = stockLevel;
    _resultData['stockLevel'] = l$stockLevel;
    final l$options = options;
    _resultData['options'] = l$options.map((e) => e.toJson()).toList();
    final l$featuredAsset = featuredAsset;
    _resultData['featuredAsset'] = l$featuredAsset?.toJson();
    final l$price = price;
    _resultData['price'] = l$price;
    final l$priceWithTax = priceWithTax;
    _resultData['priceWithTax'] = l$priceWithTax;
    final l$currencyCode = currencyCode;
    _resultData['currencyCode'] = toJson$Enum$CurrencyCode(l$currencyCode);
    final l$languageCode = languageCode;
    _resultData['languageCode'] = toJson$Enum$LanguageCode(l$languageCode);
    final l$assets = assets;
    _resultData['assets'] = l$assets.map((e) => e.toJson()).toList();
    final l$sku = sku;
    _resultData['sku'] = l$sku;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$stockLevel = stockLevel;
    final l$options = options;
    final l$featuredAsset = featuredAsset;
    final l$price = price;
    final l$priceWithTax = priceWithTax;
    final l$currencyCode = currencyCode;
    final l$languageCode = languageCode;
    final l$assets = assets;
    final l$sku = sku;
    final l$$__typename = $__typename;
    final l$customFields = customFields;
    return Object.hashAll([
      l$id,
      l$name,
      l$stockLevel,
      Object.hashAll(l$options.map((v) => v)),
      l$featuredAsset,
      l$price,
      l$priceWithTax,
      l$currencyCode,
      l$languageCode,
      Object.hashAll(l$assets.map((v) => v)),
      l$sku,
      l$$__typename,
      l$customFields,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetProductDetail$product$variants ||
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
    final l$options = options;
    final lOther$options = other.options;
    if (l$options.length != lOther$options.length) {
      return false;
    }
    for (int i = 0; i < l$options.length; i++) {
      final l$options$entry = l$options[i];
      final lOther$options$entry = lOther$options[i];
      if (l$options$entry != lOther$options$entry) {
        return false;
      }
    }
    final l$featuredAsset = featuredAsset;
    final lOther$featuredAsset = other.featuredAsset;
    if (l$featuredAsset != lOther$featuredAsset) {
      return false;
    }
    final l$price = price;
    final lOther$price = other.price;
    if (l$price != lOther$price) {
      return false;
    }
    final l$priceWithTax = priceWithTax;
    final lOther$priceWithTax = other.priceWithTax;
    if (l$priceWithTax != lOther$priceWithTax) {
      return false;
    }
    final l$currencyCode = currencyCode;
    final lOther$currencyCode = other.currencyCode;
    if (l$currencyCode != lOther$currencyCode) {
      return false;
    }
    final l$languageCode = languageCode;
    final lOther$languageCode = other.languageCode;
    if (l$languageCode != lOther$languageCode) {
      return false;
    }
    final l$assets = assets;
    final lOther$assets = other.assets;
    if (l$assets.length != lOther$assets.length) {
      return false;
    }
    for (int i = 0; i < l$assets.length; i++) {
      final l$assets$entry = l$assets[i];
      final lOther$assets$entry = lOther$assets[i];
      if (l$assets$entry != lOther$assets$entry) {
        return false;
      }
    }
    final l$sku = sku;
    final lOther$sku = other.sku;
    if (l$sku != lOther$sku) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$customFields = customFields;
    final lOther$customFields = other.customFields;
    if (l$customFields != lOther$customFields) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetProductDetail$product$variants
    on Query$GetProductDetail$product$variants {
  CopyWith$Query$GetProductDetail$product$variants<
          Query$GetProductDetail$product$variants>
      get copyWith => CopyWith$Query$GetProductDetail$product$variants(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetProductDetail$product$variants<TRes> {
  factory CopyWith$Query$GetProductDetail$product$variants(
    Query$GetProductDetail$product$variants instance,
    TRes Function(Query$GetProductDetail$product$variants) then,
  ) = _CopyWithImpl$Query$GetProductDetail$product$variants;

  factory CopyWith$Query$GetProductDetail$product$variants.stub(TRes res) =
      _CopyWithStubImpl$Query$GetProductDetail$product$variants;

  TRes call({
    String? id,
    String? name,
    String? stockLevel,
    List<Query$GetProductDetail$product$variants$options>? options,
    Fragment$Asset? featuredAsset,
    double? price,
    double? priceWithTax,
    Enum$CurrencyCode? currencyCode,
    Enum$LanguageCode? languageCode,
    List<Query$GetProductDetail$product$variants$assets>? assets,
    String? sku,
    String? $__typename,
    Query$GetProductDetail$product$variants$customFields? customFields,
  });
  TRes options(
      Iterable<Query$GetProductDetail$product$variants$options> Function(
              Iterable<
                  CopyWith$Query$GetProductDetail$product$variants$options<
                      Query$GetProductDetail$product$variants$options>>)
          _fn);
  CopyWith$Fragment$Asset<TRes> get featuredAsset;
  TRes assets(
      Iterable<Query$GetProductDetail$product$variants$assets> Function(
              Iterable<
                  CopyWith$Query$GetProductDetail$product$variants$assets<
                      Query$GetProductDetail$product$variants$assets>>)
          _fn);
  CopyWith$Query$GetProductDetail$product$variants$customFields<TRes>
      get customFields;
}

class _CopyWithImpl$Query$GetProductDetail$product$variants<TRes>
    implements CopyWith$Query$GetProductDetail$product$variants<TRes> {
  _CopyWithImpl$Query$GetProductDetail$product$variants(
    this._instance,
    this._then,
  );

  final Query$GetProductDetail$product$variants _instance;

  final TRes Function(Query$GetProductDetail$product$variants) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? stockLevel = _undefined,
    Object? options = _undefined,
    Object? featuredAsset = _undefined,
    Object? price = _undefined,
    Object? priceWithTax = _undefined,
    Object? currencyCode = _undefined,
    Object? languageCode = _undefined,
    Object? assets = _undefined,
    Object? sku = _undefined,
    Object? $__typename = _undefined,
    Object? customFields = _undefined,
  }) =>
      _then(Query$GetProductDetail$product$variants(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        stockLevel: stockLevel == _undefined || stockLevel == null
            ? _instance.stockLevel
            : (stockLevel as String),
        options: options == _undefined || options == null
            ? _instance.options
            : (options
                as List<Query$GetProductDetail$product$variants$options>),
        featuredAsset: featuredAsset == _undefined
            ? _instance.featuredAsset
            : (featuredAsset as Fragment$Asset?),
        price: price == _undefined || price == null
            ? _instance.price
            : (price as double),
        priceWithTax: priceWithTax == _undefined || priceWithTax == null
            ? _instance.priceWithTax
            : (priceWithTax as double),
        currencyCode: currencyCode == _undefined || currencyCode == null
            ? _instance.currencyCode
            : (currencyCode as Enum$CurrencyCode),
        languageCode: languageCode == _undefined || languageCode == null
            ? _instance.languageCode
            : (languageCode as Enum$LanguageCode),
        assets: assets == _undefined || assets == null
            ? _instance.assets
            : (assets as List<Query$GetProductDetail$product$variants$assets>),
        sku: sku == _undefined || sku == null ? _instance.sku : (sku as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Query$GetProductDetail$product$variants$customFields?),
      ));

  TRes options(
          Iterable<Query$GetProductDetail$product$variants$options> Function(
                  Iterable<
                      CopyWith$Query$GetProductDetail$product$variants$options<
                          Query$GetProductDetail$product$variants$options>>)
              _fn) =>
      call(
          options: _fn(_instance.options.map(
              (e) => CopyWith$Query$GetProductDetail$product$variants$options(
                    e,
                    (i) => i,
                  ))).toList());

  CopyWith$Fragment$Asset<TRes> get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Fragment$Asset.stub(_then(_instance))
        : CopyWith$Fragment$Asset(
            local$featuredAsset, (e) => call(featuredAsset: e));
  }

  TRes assets(
          Iterable<Query$GetProductDetail$product$variants$assets> Function(
                  Iterable<
                      CopyWith$Query$GetProductDetail$product$variants$assets<
                          Query$GetProductDetail$product$variants$assets>>)
              _fn) =>
      call(
          assets: _fn(_instance.assets.map(
              (e) => CopyWith$Query$GetProductDetail$product$variants$assets(
                    e,
                    (i) => i,
                  ))).toList());

  CopyWith$Query$GetProductDetail$product$variants$customFields<TRes>
      get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Query$GetProductDetail$product$variants$customFields.stub(
            _then(_instance))
        : CopyWith$Query$GetProductDetail$product$variants$customFields(
            local$customFields, (e) => call(customFields: e));
  }
}

class _CopyWithStubImpl$Query$GetProductDetail$product$variants<TRes>
    implements CopyWith$Query$GetProductDetail$product$variants<TRes> {
  _CopyWithStubImpl$Query$GetProductDetail$product$variants(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? stockLevel,
    List<Query$GetProductDetail$product$variants$options>? options,
    Fragment$Asset? featuredAsset,
    double? price,
    double? priceWithTax,
    Enum$CurrencyCode? currencyCode,
    Enum$LanguageCode? languageCode,
    List<Query$GetProductDetail$product$variants$assets>? assets,
    String? sku,
    String? $__typename,
    Query$GetProductDetail$product$variants$customFields? customFields,
  }) =>
      _res;

  options(_fn) => _res;

  CopyWith$Fragment$Asset<TRes> get featuredAsset =>
      CopyWith$Fragment$Asset.stub(_res);

  assets(_fn) => _res;

  CopyWith$Query$GetProductDetail$product$variants$customFields<TRes>
      get customFields =>
          CopyWith$Query$GetProductDetail$product$variants$customFields.stub(
              _res);
}

class Query$GetProductDetail$product$variants$options
    implements Fragment$Options {
  Query$GetProductDetail$product$variants$options({
    required this.id,
    required this.code,
    required this.name,
    this.$__typename = 'ProductOption',
    required this.group,
  });

  factory Query$GetProductDetail$product$variants$options.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    final l$group = json['group'];
    return Query$GetProductDetail$product$variants$options(
      id: (l$id as String),
      code: (l$code as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
      group: Query$GetProductDetail$product$variants$options$group.fromJson(
          (l$group as Map<String, dynamic>)),
    );
  }

  final String id;

  final String code;

  final String name;

  final String $__typename;

  final Query$GetProductDetail$product$variants$options$group group;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$group = group;
    _resultData['group'] = l$group.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$name = name;
    final l$$__typename = $__typename;
    final l$group = group;
    return Object.hashAll([
      l$id,
      l$code,
      l$name,
      l$$__typename,
      l$group,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetProductDetail$product$variants$options ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$group = group;
    final lOther$group = other.group;
    if (l$group != lOther$group) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetProductDetail$product$variants$options
    on Query$GetProductDetail$product$variants$options {
  CopyWith$Query$GetProductDetail$product$variants$options<
          Query$GetProductDetail$product$variants$options>
      get copyWith => CopyWith$Query$GetProductDetail$product$variants$options(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetProductDetail$product$variants$options<TRes> {
  factory CopyWith$Query$GetProductDetail$product$variants$options(
    Query$GetProductDetail$product$variants$options instance,
    TRes Function(Query$GetProductDetail$product$variants$options) then,
  ) = _CopyWithImpl$Query$GetProductDetail$product$variants$options;

  factory CopyWith$Query$GetProductDetail$product$variants$options.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetProductDetail$product$variants$options;

  TRes call({
    String? id,
    String? code,
    String? name,
    String? $__typename,
    Query$GetProductDetail$product$variants$options$group? group,
  });
  CopyWith$Query$GetProductDetail$product$variants$options$group<TRes>
      get group;
}

class _CopyWithImpl$Query$GetProductDetail$product$variants$options<TRes>
    implements CopyWith$Query$GetProductDetail$product$variants$options<TRes> {
  _CopyWithImpl$Query$GetProductDetail$product$variants$options(
    this._instance,
    this._then,
  );

  final Query$GetProductDetail$product$variants$options _instance;

  final TRes Function(Query$GetProductDetail$product$variants$options) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
    Object? group = _undefined,
  }) =>
      _then(Query$GetProductDetail$product$variants$options(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
        group: group == _undefined || group == null
            ? _instance.group
            : (group as Query$GetProductDetail$product$variants$options$group),
      ));

  CopyWith$Query$GetProductDetail$product$variants$options$group<TRes>
      get group {
    final local$group = _instance.group;
    return CopyWith$Query$GetProductDetail$product$variants$options$group(
        local$group, (e) => call(group: e));
  }
}

class _CopyWithStubImpl$Query$GetProductDetail$product$variants$options<TRes>
    implements CopyWith$Query$GetProductDetail$product$variants$options<TRes> {
  _CopyWithStubImpl$Query$GetProductDetail$product$variants$options(this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    String? name,
    String? $__typename,
    Query$GetProductDetail$product$variants$options$group? group,
  }) =>
      _res;

  CopyWith$Query$GetProductDetail$product$variants$options$group<TRes>
      get group =>
          CopyWith$Query$GetProductDetail$product$variants$options$group.stub(
              _res);
}

class Query$GetProductDetail$product$variants$assets {
  Query$GetProductDetail$product$variants$assets({
    required this.name,
    required this.preview,
    this.$__typename = 'Asset',
  });

  factory Query$GetProductDetail$product$variants$assets.fromJson(
      Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$preview = json['preview'];
    final l$$__typename = json['__typename'];
    return Query$GetProductDetail$product$variants$assets(
      name: (l$name as String),
      preview: (l$preview as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String preview;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$preview = preview;
    _resultData['preview'] = l$preview;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$preview = preview;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$preview,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetProductDetail$product$variants$assets ||
        runtimeType != other.runtimeType) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetProductDetail$product$variants$assets
    on Query$GetProductDetail$product$variants$assets {
  CopyWith$Query$GetProductDetail$product$variants$assets<
          Query$GetProductDetail$product$variants$assets>
      get copyWith => CopyWith$Query$GetProductDetail$product$variants$assets(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetProductDetail$product$variants$assets<TRes> {
  factory CopyWith$Query$GetProductDetail$product$variants$assets(
    Query$GetProductDetail$product$variants$assets instance,
    TRes Function(Query$GetProductDetail$product$variants$assets) then,
  ) = _CopyWithImpl$Query$GetProductDetail$product$variants$assets;

  factory CopyWith$Query$GetProductDetail$product$variants$assets.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetProductDetail$product$variants$assets;

  TRes call({
    String? name,
    String? preview,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetProductDetail$product$variants$assets<TRes>
    implements CopyWith$Query$GetProductDetail$product$variants$assets<TRes> {
  _CopyWithImpl$Query$GetProductDetail$product$variants$assets(
    this._instance,
    this._then,
  );

  final Query$GetProductDetail$product$variants$assets _instance;

  final TRes Function(Query$GetProductDetail$product$variants$assets) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? preview = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetProductDetail$product$variants$assets(
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        preview: preview == _undefined || preview == null
            ? _instance.preview
            : (preview as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetProductDetail$product$variants$assets<TRes>
    implements CopyWith$Query$GetProductDetail$product$variants$assets<TRes> {
  _CopyWithStubImpl$Query$GetProductDetail$product$variants$assets(this._res);

  TRes _res;

  call({
    String? name,
    String? preview,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetProductDetail$product$variants$options$group {
  Query$GetProductDetail$product$variants$options$group({
    required this.name,
    this.$__typename = 'ProductOptionGroup',
  });

  factory Query$GetProductDetail$product$variants$options$group.fromJson(
      Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$GetProductDetail$product$variants$options$group(
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetProductDetail$product$variants$options$group ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$GetProductDetail$product$variants$options$group
    on Query$GetProductDetail$product$variants$options$group {
  CopyWith$Query$GetProductDetail$product$variants$options$group<
          Query$GetProductDetail$product$variants$options$group>
      get copyWith =>
          CopyWith$Query$GetProductDetail$product$variants$options$group(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetProductDetail$product$variants$options$group<
    TRes> {
  factory CopyWith$Query$GetProductDetail$product$variants$options$group(
    Query$GetProductDetail$product$variants$options$group instance,
    TRes Function(Query$GetProductDetail$product$variants$options$group) then,
  ) = _CopyWithImpl$Query$GetProductDetail$product$variants$options$group;

  factory CopyWith$Query$GetProductDetail$product$variants$options$group.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetProductDetail$product$variants$options$group;

  TRes call({
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetProductDetail$product$variants$options$group<TRes>
    implements
        CopyWith$Query$GetProductDetail$product$variants$options$group<TRes> {
  _CopyWithImpl$Query$GetProductDetail$product$variants$options$group(
    this._instance,
    this._then,
  );

  final Query$GetProductDetail$product$variants$options$group _instance;

  final TRes Function(Query$GetProductDetail$product$variants$options$group)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetProductDetail$product$variants$options$group(
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetProductDetail$product$variants$options$group<
        TRes>
    implements
        CopyWith$Query$GetProductDetail$product$variants$options$group<TRes> {
  _CopyWithStubImpl$Query$GetProductDetail$product$variants$options$group(
      this._res);

  TRes _res;

  call({
    String? name,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetProductDetail$product$variants$customFields {
  Query$GetProductDetail$product$variants$customFields({
    this.shadowPrice,
    this.$__typename = 'ProductVariantCustomFields',
  });

  factory Query$GetProductDetail$product$variants$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$shadowPrice = json['shadowPrice'];
    final l$$__typename = json['__typename'];
    return Query$GetProductDetail$product$variants$customFields(
      shadowPrice: (l$shadowPrice as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? shadowPrice;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$shadowPrice = shadowPrice;
    _resultData['shadowPrice'] = l$shadowPrice;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$shadowPrice = shadowPrice;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$shadowPrice,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetProductDetail$product$variants$customFields ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$shadowPrice = shadowPrice;
    final lOther$shadowPrice = other.shadowPrice;
    if (l$shadowPrice != lOther$shadowPrice) {
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

extension UtilityExtension$Query$GetProductDetail$product$variants$customFields
    on Query$GetProductDetail$product$variants$customFields {
  CopyWith$Query$GetProductDetail$product$variants$customFields<
          Query$GetProductDetail$product$variants$customFields>
      get copyWith =>
          CopyWith$Query$GetProductDetail$product$variants$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetProductDetail$product$variants$customFields<
    TRes> {
  factory CopyWith$Query$GetProductDetail$product$variants$customFields(
    Query$GetProductDetail$product$variants$customFields instance,
    TRes Function(Query$GetProductDetail$product$variants$customFields) then,
  ) = _CopyWithImpl$Query$GetProductDetail$product$variants$customFields;

  factory CopyWith$Query$GetProductDetail$product$variants$customFields.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetProductDetail$product$variants$customFields;

  TRes call({
    int? shadowPrice,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetProductDetail$product$variants$customFields<TRes>
    implements
        CopyWith$Query$GetProductDetail$product$variants$customFields<TRes> {
  _CopyWithImpl$Query$GetProductDetail$product$variants$customFields(
    this._instance,
    this._then,
  );

  final Query$GetProductDetail$product$variants$customFields _instance;

  final TRes Function(Query$GetProductDetail$product$variants$customFields)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? shadowPrice = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetProductDetail$product$variants$customFields(
        shadowPrice: shadowPrice == _undefined
            ? _instance.shadowPrice
            : (shadowPrice as int?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetProductDetail$product$variants$customFields<
        TRes>
    implements
        CopyWith$Query$GetProductDetail$product$variants$customFields<TRes> {
  _CopyWithStubImpl$Query$GetProductDetail$product$variants$customFields(
      this._res);

  TRes _res;

  call({
    int? shadowPrice,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetProductDetail$product$collections {
  Query$GetProductDetail$product$collections({
    required this.id,
    required this.slug,
    required this.breadcrumbs,
    this.$__typename = 'Collection',
  });

  factory Query$GetProductDetail$product$collections.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$slug = json['slug'];
    final l$breadcrumbs = json['breadcrumbs'];
    final l$$__typename = json['__typename'];
    return Query$GetProductDetail$product$collections(
      id: (l$id as String),
      slug: (l$slug as String),
      breadcrumbs: (l$breadcrumbs as List<dynamic>)
          .map((e) =>
              Query$GetProductDetail$product$collections$breadcrumbs.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String slug;

  final List<Query$GetProductDetail$product$collections$breadcrumbs>
      breadcrumbs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slug = slug;
    _resultData['slug'] = l$slug;
    final l$breadcrumbs = breadcrumbs;
    _resultData['breadcrumbs'] = l$breadcrumbs.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$slug = slug;
    final l$breadcrumbs = breadcrumbs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$slug,
      Object.hashAll(l$breadcrumbs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetProductDetail$product$collections ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$slug = slug;
    final lOther$slug = other.slug;
    if (l$slug != lOther$slug) {
      return false;
    }
    final l$breadcrumbs = breadcrumbs;
    final lOther$breadcrumbs = other.breadcrumbs;
    if (l$breadcrumbs.length != lOther$breadcrumbs.length) {
      return false;
    }
    for (int i = 0; i < l$breadcrumbs.length; i++) {
      final l$breadcrumbs$entry = l$breadcrumbs[i];
      final lOther$breadcrumbs$entry = lOther$breadcrumbs[i];
      if (l$breadcrumbs$entry != lOther$breadcrumbs$entry) {
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

extension UtilityExtension$Query$GetProductDetail$product$collections
    on Query$GetProductDetail$product$collections {
  CopyWith$Query$GetProductDetail$product$collections<
          Query$GetProductDetail$product$collections>
      get copyWith => CopyWith$Query$GetProductDetail$product$collections(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetProductDetail$product$collections<TRes> {
  factory CopyWith$Query$GetProductDetail$product$collections(
    Query$GetProductDetail$product$collections instance,
    TRes Function(Query$GetProductDetail$product$collections) then,
  ) = _CopyWithImpl$Query$GetProductDetail$product$collections;

  factory CopyWith$Query$GetProductDetail$product$collections.stub(TRes res) =
      _CopyWithStubImpl$Query$GetProductDetail$product$collections;

  TRes call({
    String? id,
    String? slug,
    List<Query$GetProductDetail$product$collections$breadcrumbs>? breadcrumbs,
    String? $__typename,
  });
  TRes breadcrumbs(
      Iterable<Query$GetProductDetail$product$collections$breadcrumbs> Function(
              Iterable<
                  CopyWith$Query$GetProductDetail$product$collections$breadcrumbs<
                      Query$GetProductDetail$product$collections$breadcrumbs>>)
          _fn);
}

class _CopyWithImpl$Query$GetProductDetail$product$collections<TRes>
    implements CopyWith$Query$GetProductDetail$product$collections<TRes> {
  _CopyWithImpl$Query$GetProductDetail$product$collections(
    this._instance,
    this._then,
  );

  final Query$GetProductDetail$product$collections _instance;

  final TRes Function(Query$GetProductDetail$product$collections) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? slug = _undefined,
    Object? breadcrumbs = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetProductDetail$product$collections(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        slug: slug == _undefined || slug == null
            ? _instance.slug
            : (slug as String),
        breadcrumbs: breadcrumbs == _undefined || breadcrumbs == null
            ? _instance.breadcrumbs
            : (breadcrumbs as List<
                Query$GetProductDetail$product$collections$breadcrumbs>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes breadcrumbs(
          Iterable<Query$GetProductDetail$product$collections$breadcrumbs> Function(
                  Iterable<
                      CopyWith$Query$GetProductDetail$product$collections$breadcrumbs<
                          Query$GetProductDetail$product$collections$breadcrumbs>>)
              _fn) =>
      call(
          breadcrumbs: _fn(_instance.breadcrumbs.map((e) =>
              CopyWith$Query$GetProductDetail$product$collections$breadcrumbs(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Query$GetProductDetail$product$collections<TRes>
    implements CopyWith$Query$GetProductDetail$product$collections<TRes> {
  _CopyWithStubImpl$Query$GetProductDetail$product$collections(this._res);

  TRes _res;

  call({
    String? id,
    String? slug,
    List<Query$GetProductDetail$product$collections$breadcrumbs>? breadcrumbs,
    String? $__typename,
  }) =>
      _res;

  breadcrumbs(_fn) => _res;
}

class Query$GetProductDetail$product$collections$breadcrumbs {
  Query$GetProductDetail$product$collections$breadcrumbs({
    required this.id,
    required this.name,
    required this.slug,
    this.$__typename = 'CollectionBreadcrumb',
  });

  factory Query$GetProductDetail$product$collections$breadcrumbs.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$slug = json['slug'];
    final l$$__typename = json['__typename'];
    return Query$GetProductDetail$product$collections$breadcrumbs(
      id: (l$id as String),
      name: (l$name as String),
      slug: (l$slug as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String slug;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$slug = slug;
    _resultData['slug'] = l$slug;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$slug = slug;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$slug,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetProductDetail$product$collections$breadcrumbs ||
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
    final l$slug = slug;
    final lOther$slug = other.slug;
    if (l$slug != lOther$slug) {
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

extension UtilityExtension$Query$GetProductDetail$product$collections$breadcrumbs
    on Query$GetProductDetail$product$collections$breadcrumbs {
  CopyWith$Query$GetProductDetail$product$collections$breadcrumbs<
          Query$GetProductDetail$product$collections$breadcrumbs>
      get copyWith =>
          CopyWith$Query$GetProductDetail$product$collections$breadcrumbs(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetProductDetail$product$collections$breadcrumbs<
    TRes> {
  factory CopyWith$Query$GetProductDetail$product$collections$breadcrumbs(
    Query$GetProductDetail$product$collections$breadcrumbs instance,
    TRes Function(Query$GetProductDetail$product$collections$breadcrumbs) then,
  ) = _CopyWithImpl$Query$GetProductDetail$product$collections$breadcrumbs;

  factory CopyWith$Query$GetProductDetail$product$collections$breadcrumbs.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetProductDetail$product$collections$breadcrumbs;

  TRes call({
    String? id,
    String? name,
    String? slug,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetProductDetail$product$collections$breadcrumbs<TRes>
    implements
        CopyWith$Query$GetProductDetail$product$collections$breadcrumbs<TRes> {
  _CopyWithImpl$Query$GetProductDetail$product$collections$breadcrumbs(
    this._instance,
    this._then,
  );

  final Query$GetProductDetail$product$collections$breadcrumbs _instance;

  final TRes Function(Query$GetProductDetail$product$collections$breadcrumbs)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? slug = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetProductDetail$product$collections$breadcrumbs(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        slug: slug == _undefined || slug == null
            ? _instance.slug
            : (slug as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetProductDetail$product$collections$breadcrumbs<
        TRes>
    implements
        CopyWith$Query$GetProductDetail$product$collections$breadcrumbs<TRes> {
  _CopyWithStubImpl$Query$GetProductDetail$product$collections$breadcrumbs(
      this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? slug,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Query$Collections {
  factory Variables$Query$Collections({Input$CollectionListOptions? options}) =>
      Variables$Query$Collections._({
        if (options != null) r'options': options,
      });

  Variables$Query$Collections._(this._$data);

  factory Variables$Query$Collections.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('options')) {
      final l$options = data['options'];
      result$data['options'] = l$options == null
          ? null
          : Input$CollectionListOptions.fromJson(
              (l$options as Map<String, dynamic>));
    }
    return Variables$Query$Collections._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$CollectionListOptions? get options =>
      (_$data['options'] as Input$CollectionListOptions?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('options')) {
      final l$options = options;
      result$data['options'] = l$options?.toJson();
    }
    return result$data;
  }

  CopyWith$Variables$Query$Collections<Variables$Query$Collections>
      get copyWith => CopyWith$Variables$Query$Collections(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$Collections ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$options = options;
    final lOther$options = other.options;
    if (_$data.containsKey('options') != other._$data.containsKey('options')) {
      return false;
    }
    if (l$options != lOther$options) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$options = options;
    return Object.hashAll(
        [_$data.containsKey('options') ? l$options : const {}]);
  }
}

abstract class CopyWith$Variables$Query$Collections<TRes> {
  factory CopyWith$Variables$Query$Collections(
    Variables$Query$Collections instance,
    TRes Function(Variables$Query$Collections) then,
  ) = _CopyWithImpl$Variables$Query$Collections;

  factory CopyWith$Variables$Query$Collections.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Collections;

  TRes call({Input$CollectionListOptions? options});
}

class _CopyWithImpl$Variables$Query$Collections<TRes>
    implements CopyWith$Variables$Query$Collections<TRes> {
  _CopyWithImpl$Variables$Query$Collections(
    this._instance,
    this._then,
  );

  final Variables$Query$Collections _instance;

  final TRes Function(Variables$Query$Collections) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? options = _undefined}) =>
      _then(Variables$Query$Collections._({
        ..._instance._$data,
        if (options != _undefined)
          'options': (options as Input$CollectionListOptions?),
      }));
}

class _CopyWithStubImpl$Variables$Query$Collections<TRes>
    implements CopyWith$Variables$Query$Collections<TRes> {
  _CopyWithStubImpl$Variables$Query$Collections(this._res);

  TRes _res;

  call({Input$CollectionListOptions? options}) => _res;
}

class Query$Collections {
  Query$Collections({
    required this.collections,
    this.$__typename = 'Query',
  });

  factory Query$Collections.fromJson(Map<String, dynamic> json) {
    final l$collections = json['collections'];
    final l$$__typename = json['__typename'];
    return Query$Collections(
      collections: Query$Collections$collections.fromJson(
          (l$collections as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$Collections$collections collections;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$collections = collections;
    _resultData['collections'] = l$collections.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$collections = collections;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$collections,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Collections || runtimeType != other.runtimeType) {
      return false;
    }
    final l$collections = collections;
    final lOther$collections = other.collections;
    if (l$collections != lOther$collections) {
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

extension UtilityExtension$Query$Collections on Query$Collections {
  CopyWith$Query$Collections<Query$Collections> get copyWith =>
      CopyWith$Query$Collections(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$Collections<TRes> {
  factory CopyWith$Query$Collections(
    Query$Collections instance,
    TRes Function(Query$Collections) then,
  ) = _CopyWithImpl$Query$Collections;

  factory CopyWith$Query$Collections.stub(TRes res) =
      _CopyWithStubImpl$Query$Collections;

  TRes call({
    Query$Collections$collections? collections,
    String? $__typename,
  });
  CopyWith$Query$Collections$collections<TRes> get collections;
}

class _CopyWithImpl$Query$Collections<TRes>
    implements CopyWith$Query$Collections<TRes> {
  _CopyWithImpl$Query$Collections(
    this._instance,
    this._then,
  );

  final Query$Collections _instance;

  final TRes Function(Query$Collections) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? collections = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Collections(
        collections: collections == _undefined || collections == null
            ? _instance.collections
            : (collections as Query$Collections$collections),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$Collections$collections<TRes> get collections {
    final local$collections = _instance.collections;
    return CopyWith$Query$Collections$collections(
        local$collections, (e) => call(collections: e));
  }
}

class _CopyWithStubImpl$Query$Collections<TRes>
    implements CopyWith$Query$Collections<TRes> {
  _CopyWithStubImpl$Query$Collections(this._res);

  TRes _res;

  call({
    Query$Collections$collections? collections,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$Collections$collections<TRes> get collections =>
      CopyWith$Query$Collections$collections.stub(_res);
}

const documentNodeQueryCollections = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'Collections'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'options')),
        type: NamedTypeNode(
          name: NameNode(value: 'CollectionListOptions'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'collections'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'options'),
            value: VariableNode(name: NameNode(value: 'options')),
          )
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'items'),
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
                name: NameNode(value: 'children'),
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
                    name: NameNode(value: 'slug'),
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
                name: NameNode(value: 'productVariants'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
                  FieldNode(
                    name: NameNode(value: 'totalItems'),
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
                name: NameNode(value: 'slug'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'parent'),
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
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ]),
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
  fragmentDefinitionAsset,
]);
Query$Collections _parserFn$Query$Collections(Map<String, dynamic> data) =>
    Query$Collections.fromJson(data);
typedef OnQueryComplete$Query$Collections = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$Collections?,
);

class Options$Query$Collections
    extends graphql.QueryOptions<Query$Collections> {
  Options$Query$Collections({
    String? operationName,
    Variables$Query$Collections? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Collections? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$Collections? onComplete,
    graphql.OnQueryError? onError,
  })  : onCompleteWithParsed = onComplete,
        super(
          variables: variables?.toJson() ?? {},
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          pollInterval: pollInterval,
          context: context,
          onComplete: onComplete == null
              ? null
              : (data) => onComplete(
                    data,
                    data == null ? null : _parserFn$Query$Collections(data),
                  ),
          onError: onError,
          document: documentNodeQueryCollections,
          parserFn: _parserFn$Query$Collections,
        );

  final OnQueryComplete$Query$Collections? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$Collections
    extends graphql.WatchQueryOptions<Query$Collections> {
  WatchOptions$Query$Collections({
    String? operationName,
    Variables$Query$Collections? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Collections? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
          variables: variables?.toJson() ?? {},
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          document: documentNodeQueryCollections,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$Collections,
        );
}

class FetchMoreOptions$Query$Collections extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Collections({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$Collections? variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables?.toJson() ?? {},
          document: documentNodeQueryCollections,
        );
}

extension ClientExtension$Query$Collections on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Collections>> query$Collections(
          [Options$Query$Collections? options]) async =>
      await this.query(options ?? Options$Query$Collections());

  graphql.ObservableQuery<Query$Collections> watchQuery$Collections(
          [WatchOptions$Query$Collections? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$Collections());

  void writeQuery$Collections({
    required Query$Collections data,
    Variables$Query$Collections? variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryCollections),
          variables: variables?.toJson() ?? const {},
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$Collections? readQuery$Collections({
    Variables$Query$Collections? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryCollections),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$Collections.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$Collections> useQuery$Collections(
        [Options$Query$Collections? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$Collections());
graphql.ObservableQuery<Query$Collections> useWatchQuery$Collections(
        [WatchOptions$Query$Collections? options]) =>
    graphql_flutter.useWatchQuery(options ?? WatchOptions$Query$Collections());

class Query$Collections$Widget
    extends graphql_flutter.Query<Query$Collections> {
  Query$Collections$Widget({
    widgets.Key? key,
    Options$Query$Collections? options,
    required graphql_flutter.QueryBuilder<Query$Collections> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$Collections(),
          builder: builder,
        );
}

class Query$Collections$collections {
  Query$Collections$collections({
    required this.items,
    this.$__typename = 'CollectionList',
  });

  factory Query$Collections$collections.fromJson(Map<String, dynamic> json) {
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Query$Collections$collections(
      items: (l$items as List<dynamic>)
          .map((e) => Query$Collections$collections$items.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$Collections$collections$items> items;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$items = items;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$items.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Collections$collections ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$items = items;
    final lOther$items = other.items;
    if (l$items.length != lOther$items.length) {
      return false;
    }
    for (int i = 0; i < l$items.length; i++) {
      final l$items$entry = l$items[i];
      final lOther$items$entry = lOther$items[i];
      if (l$items$entry != lOther$items$entry) {
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

extension UtilityExtension$Query$Collections$collections
    on Query$Collections$collections {
  CopyWith$Query$Collections$collections<Query$Collections$collections>
      get copyWith => CopyWith$Query$Collections$collections(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Collections$collections<TRes> {
  factory CopyWith$Query$Collections$collections(
    Query$Collections$collections instance,
    TRes Function(Query$Collections$collections) then,
  ) = _CopyWithImpl$Query$Collections$collections;

  factory CopyWith$Query$Collections$collections.stub(TRes res) =
      _CopyWithStubImpl$Query$Collections$collections;

  TRes call({
    List<Query$Collections$collections$items>? items,
    String? $__typename,
  });
  TRes items(
      Iterable<Query$Collections$collections$items> Function(
              Iterable<
                  CopyWith$Query$Collections$collections$items<
                      Query$Collections$collections$items>>)
          _fn);
}

class _CopyWithImpl$Query$Collections$collections<TRes>
    implements CopyWith$Query$Collections$collections<TRes> {
  _CopyWithImpl$Query$Collections$collections(
    this._instance,
    this._then,
  );

  final Query$Collections$collections _instance;

  final TRes Function(Query$Collections$collections) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Collections$collections(
        items: items == _undefined || items == null
            ? _instance.items
            : (items as List<Query$Collections$collections$items>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes items(
          Iterable<Query$Collections$collections$items> Function(
                  Iterable<
                      CopyWith$Query$Collections$collections$items<
                          Query$Collections$collections$items>>)
              _fn) =>
      call(
          items: _fn(_instance.items
              .map((e) => CopyWith$Query$Collections$collections$items(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$Collections$collections<TRes>
    implements CopyWith$Query$Collections$collections<TRes> {
  _CopyWithStubImpl$Query$Collections$collections(this._res);

  TRes _res;

  call({
    List<Query$Collections$collections$items>? items,
    String? $__typename,
  }) =>
      _res;

  items(_fn) => _res;
}

class Query$Collections$collections$items {
  Query$Collections$collections$items({
    required this.id,
    required this.name,
    this.children,
    required this.productVariants,
    required this.slug,
    this.parent,
    this.featuredAsset,
    this.$__typename = 'Collection',
  });

  factory Query$Collections$collections$items.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$children = json['children'];
    final l$productVariants = json['productVariants'];
    final l$slug = json['slug'];
    final l$parent = json['parent'];
    final l$featuredAsset = json['featuredAsset'];
    final l$$__typename = json['__typename'];
    return Query$Collections$collections$items(
      id: (l$id as String),
      name: (l$name as String),
      children: (l$children as List<dynamic>?)
          ?.map((e) => Query$Collections$collections$items$children.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      productVariants:
          Query$Collections$collections$items$productVariants.fromJson(
              (l$productVariants as Map<String, dynamic>)),
      slug: (l$slug as String),
      parent: l$parent == null
          ? null
          : Query$Collections$collections$items$parent.fromJson(
              (l$parent as Map<String, dynamic>)),
      featuredAsset: l$featuredAsset == null
          ? null
          : Fragment$Asset.fromJson((l$featuredAsset as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Query$Collections$collections$items$children>? children;

  final Query$Collections$collections$items$productVariants productVariants;

  final String slug;

  final Query$Collections$collections$items$parent? parent;

  final Fragment$Asset? featuredAsset;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$children = children;
    _resultData['children'] = l$children?.map((e) => e.toJson()).toList();
    final l$productVariants = productVariants;
    _resultData['productVariants'] = l$productVariants.toJson();
    final l$slug = slug;
    _resultData['slug'] = l$slug;
    final l$parent = parent;
    _resultData['parent'] = l$parent?.toJson();
    final l$featuredAsset = featuredAsset;
    _resultData['featuredAsset'] = l$featuredAsset?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$children = children;
    final l$productVariants = productVariants;
    final l$slug = slug;
    final l$parent = parent;
    final l$featuredAsset = featuredAsset;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$children == null ? null : Object.hashAll(l$children.map((v) => v)),
      l$productVariants,
      l$slug,
      l$parent,
      l$featuredAsset,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Collections$collections$items ||
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
    final l$children = children;
    final lOther$children = other.children;
    if (l$children != null && lOther$children != null) {
      if (l$children.length != lOther$children.length) {
        return false;
      }
      for (int i = 0; i < l$children.length; i++) {
        final l$children$entry = l$children[i];
        final lOther$children$entry = lOther$children[i];
        if (l$children$entry != lOther$children$entry) {
          return false;
        }
      }
    } else if (l$children != lOther$children) {
      return false;
    }
    final l$productVariants = productVariants;
    final lOther$productVariants = other.productVariants;
    if (l$productVariants != lOther$productVariants) {
      return false;
    }
    final l$slug = slug;
    final lOther$slug = other.slug;
    if (l$slug != lOther$slug) {
      return false;
    }
    final l$parent = parent;
    final lOther$parent = other.parent;
    if (l$parent != lOther$parent) {
      return false;
    }
    final l$featuredAsset = featuredAsset;
    final lOther$featuredAsset = other.featuredAsset;
    if (l$featuredAsset != lOther$featuredAsset) {
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

extension UtilityExtension$Query$Collections$collections$items
    on Query$Collections$collections$items {
  CopyWith$Query$Collections$collections$items<
          Query$Collections$collections$items>
      get copyWith => CopyWith$Query$Collections$collections$items(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Collections$collections$items<TRes> {
  factory CopyWith$Query$Collections$collections$items(
    Query$Collections$collections$items instance,
    TRes Function(Query$Collections$collections$items) then,
  ) = _CopyWithImpl$Query$Collections$collections$items;

  factory CopyWith$Query$Collections$collections$items.stub(TRes res) =
      _CopyWithStubImpl$Query$Collections$collections$items;

  TRes call({
    String? id,
    String? name,
    List<Query$Collections$collections$items$children>? children,
    Query$Collections$collections$items$productVariants? productVariants,
    String? slug,
    Query$Collections$collections$items$parent? parent,
    Fragment$Asset? featuredAsset,
    String? $__typename,
  });
  TRes children(
      Iterable<Query$Collections$collections$items$children>? Function(
              Iterable<
                  CopyWith$Query$Collections$collections$items$children<
                      Query$Collections$collections$items$children>>?)
          _fn);
  CopyWith$Query$Collections$collections$items$productVariants<TRes>
      get productVariants;
  CopyWith$Query$Collections$collections$items$parent<TRes> get parent;
  CopyWith$Fragment$Asset<TRes> get featuredAsset;
}

class _CopyWithImpl$Query$Collections$collections$items<TRes>
    implements CopyWith$Query$Collections$collections$items<TRes> {
  _CopyWithImpl$Query$Collections$collections$items(
    this._instance,
    this._then,
  );

  final Query$Collections$collections$items _instance;

  final TRes Function(Query$Collections$collections$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? children = _undefined,
    Object? productVariants = _undefined,
    Object? slug = _undefined,
    Object? parent = _undefined,
    Object? featuredAsset = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Collections$collections$items(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        children: children == _undefined
            ? _instance.children
            : (children as List<Query$Collections$collections$items$children>?),
        productVariants:
            productVariants == _undefined || productVariants == null
                ? _instance.productVariants
                : (productVariants
                    as Query$Collections$collections$items$productVariants),
        slug: slug == _undefined || slug == null
            ? _instance.slug
            : (slug as String),
        parent: parent == _undefined
            ? _instance.parent
            : (parent as Query$Collections$collections$items$parent?),
        featuredAsset: featuredAsset == _undefined
            ? _instance.featuredAsset
            : (featuredAsset as Fragment$Asset?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes children(
          Iterable<Query$Collections$collections$items$children>? Function(
                  Iterable<
                      CopyWith$Query$Collections$collections$items$children<
                          Query$Collections$collections$items$children>>?)
              _fn) =>
      call(
          children: _fn(_instance.children?.map(
              (e) => CopyWith$Query$Collections$collections$items$children(
                    e,
                    (i) => i,
                  )))?.toList());

  CopyWith$Query$Collections$collections$items$productVariants<TRes>
      get productVariants {
    final local$productVariants = _instance.productVariants;
    return CopyWith$Query$Collections$collections$items$productVariants(
        local$productVariants, (e) => call(productVariants: e));
  }

  CopyWith$Query$Collections$collections$items$parent<TRes> get parent {
    final local$parent = _instance.parent;
    return local$parent == null
        ? CopyWith$Query$Collections$collections$items$parent.stub(
            _then(_instance))
        : CopyWith$Query$Collections$collections$items$parent(
            local$parent, (e) => call(parent: e));
  }

  CopyWith$Fragment$Asset<TRes> get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Fragment$Asset.stub(_then(_instance))
        : CopyWith$Fragment$Asset(
            local$featuredAsset, (e) => call(featuredAsset: e));
  }
}

class _CopyWithStubImpl$Query$Collections$collections$items<TRes>
    implements CopyWith$Query$Collections$collections$items<TRes> {
  _CopyWithStubImpl$Query$Collections$collections$items(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Query$Collections$collections$items$children>? children,
    Query$Collections$collections$items$productVariants? productVariants,
    String? slug,
    Query$Collections$collections$items$parent? parent,
    Fragment$Asset? featuredAsset,
    String? $__typename,
  }) =>
      _res;

  children(_fn) => _res;

  CopyWith$Query$Collections$collections$items$productVariants<TRes>
      get productVariants =>
          CopyWith$Query$Collections$collections$items$productVariants.stub(
              _res);

  CopyWith$Query$Collections$collections$items$parent<TRes> get parent =>
      CopyWith$Query$Collections$collections$items$parent.stub(_res);

  CopyWith$Fragment$Asset<TRes> get featuredAsset =>
      CopyWith$Fragment$Asset.stub(_res);
}

class Query$Collections$collections$items$children {
  Query$Collections$collections$items$children({
    required this.id,
    required this.slug,
    required this.name,
    this.$__typename = 'Collection',
  });

  factory Query$Collections$collections$items$children.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$slug = json['slug'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$Collections$collections$items$children(
      id: (l$id as String),
      slug: (l$slug as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String slug;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slug = slug;
    _resultData['slug'] = l$slug;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$slug = slug;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$slug,
      l$name,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Collections$collections$items$children ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$slug = slug;
    final lOther$slug = other.slug;
    if (l$slug != lOther$slug) {
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

extension UtilityExtension$Query$Collections$collections$items$children
    on Query$Collections$collections$items$children {
  CopyWith$Query$Collections$collections$items$children<
          Query$Collections$collections$items$children>
      get copyWith => CopyWith$Query$Collections$collections$items$children(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Collections$collections$items$children<TRes> {
  factory CopyWith$Query$Collections$collections$items$children(
    Query$Collections$collections$items$children instance,
    TRes Function(Query$Collections$collections$items$children) then,
  ) = _CopyWithImpl$Query$Collections$collections$items$children;

  factory CopyWith$Query$Collections$collections$items$children.stub(TRes res) =
      _CopyWithStubImpl$Query$Collections$collections$items$children;

  TRes call({
    String? id,
    String? slug,
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Collections$collections$items$children<TRes>
    implements CopyWith$Query$Collections$collections$items$children<TRes> {
  _CopyWithImpl$Query$Collections$collections$items$children(
    this._instance,
    this._then,
  );

  final Query$Collections$collections$items$children _instance;

  final TRes Function(Query$Collections$collections$items$children) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? slug = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Collections$collections$items$children(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        slug: slug == _undefined || slug == null
            ? _instance.slug
            : (slug as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Collections$collections$items$children<TRes>
    implements CopyWith$Query$Collections$collections$items$children<TRes> {
  _CopyWithStubImpl$Query$Collections$collections$items$children(this._res);

  TRes _res;

  call({
    String? id,
    String? slug,
    String? name,
    String? $__typename,
  }) =>
      _res;
}

class Query$Collections$collections$items$productVariants {
  Query$Collections$collections$items$productVariants({
    required this.totalItems,
    this.$__typename = 'ProductVariantList',
  });

  factory Query$Collections$collections$items$productVariants.fromJson(
      Map<String, dynamic> json) {
    final l$totalItems = json['totalItems'];
    final l$$__typename = json['__typename'];
    return Query$Collections$collections$items$productVariants(
      totalItems: (l$totalItems as int),
      $__typename: (l$$__typename as String),
    );
  }

  final int totalItems;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$totalItems = totalItems;
    _resultData['totalItems'] = l$totalItems;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$totalItems = totalItems;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$totalItems,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Collections$collections$items$productVariants ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$totalItems = totalItems;
    final lOther$totalItems = other.totalItems;
    if (l$totalItems != lOther$totalItems) {
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

extension UtilityExtension$Query$Collections$collections$items$productVariants
    on Query$Collections$collections$items$productVariants {
  CopyWith$Query$Collections$collections$items$productVariants<
          Query$Collections$collections$items$productVariants>
      get copyWith =>
          CopyWith$Query$Collections$collections$items$productVariants(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Collections$collections$items$productVariants<
    TRes> {
  factory CopyWith$Query$Collections$collections$items$productVariants(
    Query$Collections$collections$items$productVariants instance,
    TRes Function(Query$Collections$collections$items$productVariants) then,
  ) = _CopyWithImpl$Query$Collections$collections$items$productVariants;

  factory CopyWith$Query$Collections$collections$items$productVariants.stub(
          TRes res) =
      _CopyWithStubImpl$Query$Collections$collections$items$productVariants;

  TRes call({
    int? totalItems,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Collections$collections$items$productVariants<TRes>
    implements
        CopyWith$Query$Collections$collections$items$productVariants<TRes> {
  _CopyWithImpl$Query$Collections$collections$items$productVariants(
    this._instance,
    this._then,
  );

  final Query$Collections$collections$items$productVariants _instance;

  final TRes Function(Query$Collections$collections$items$productVariants)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? totalItems = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Collections$collections$items$productVariants(
        totalItems: totalItems == _undefined || totalItems == null
            ? _instance.totalItems
            : (totalItems as int),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Collections$collections$items$productVariants<
        TRes>
    implements
        CopyWith$Query$Collections$collections$items$productVariants<TRes> {
  _CopyWithStubImpl$Query$Collections$collections$items$productVariants(
      this._res);

  TRes _res;

  call({
    int? totalItems,
    String? $__typename,
  }) =>
      _res;
}

class Query$Collections$collections$items$parent {
  Query$Collections$collections$items$parent({
    required this.name,
    this.$__typename = 'Collection',
  });

  factory Query$Collections$collections$items$parent.fromJson(
      Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$Collections$collections$items$parent(
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Collections$collections$items$parent ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$Collections$collections$items$parent
    on Query$Collections$collections$items$parent {
  CopyWith$Query$Collections$collections$items$parent<
          Query$Collections$collections$items$parent>
      get copyWith => CopyWith$Query$Collections$collections$items$parent(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Collections$collections$items$parent<TRes> {
  factory CopyWith$Query$Collections$collections$items$parent(
    Query$Collections$collections$items$parent instance,
    TRes Function(Query$Collections$collections$items$parent) then,
  ) = _CopyWithImpl$Query$Collections$collections$items$parent;

  factory CopyWith$Query$Collections$collections$items$parent.stub(TRes res) =
      _CopyWithStubImpl$Query$Collections$collections$items$parent;

  TRes call({
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Collections$collections$items$parent<TRes>
    implements CopyWith$Query$Collections$collections$items$parent<TRes> {
  _CopyWithImpl$Query$Collections$collections$items$parent(
    this._instance,
    this._then,
  );

  final Query$Collections$collections$items$parent _instance;

  final TRes Function(Query$Collections$collections$items$parent) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Collections$collections$items$parent(
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Collections$collections$items$parent<TRes>
    implements CopyWith$Query$Collections$collections$items$parent<TRes> {
  _CopyWithStubImpl$Query$Collections$collections$items$parent(this._res);

  TRes _res;

  call({
    String? name,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Query$Products {
  factory Variables$Query$Products({
    String? slug,
    String? id,
  }) =>
      Variables$Query$Products._({
        if (slug != null) r'slug': slug,
        if (id != null) r'id': id,
      });

  Variables$Query$Products._(this._$data);

  factory Variables$Query$Products.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('slug')) {
      final l$slug = data['slug'];
      result$data['slug'] = (l$slug as String?);
    }
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$Products._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get slug => (_$data['slug'] as String?);

  String? get id => (_$data['id'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('slug')) {
      final l$slug = slug;
      result$data['slug'] = l$slug;
    }
    if (_$data.containsKey('id')) {
      final l$id = id;
      result$data['id'] = l$id;
    }
    return result$data;
  }

  CopyWith$Variables$Query$Products<Variables$Query$Products> get copyWith =>
      CopyWith$Variables$Query$Products(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$Products ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$slug = slug;
    final lOther$slug = other.slug;
    if (_$data.containsKey('slug') != other._$data.containsKey('slug')) {
      return false;
    }
    if (l$slug != lOther$slug) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (_$data.containsKey('id') != other._$data.containsKey('id')) {
      return false;
    }
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$slug = slug;
    final l$id = id;
    return Object.hashAll([
      _$data.containsKey('slug') ? l$slug : const {},
      _$data.containsKey('id') ? l$id : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$Products<TRes> {
  factory CopyWith$Variables$Query$Products(
    Variables$Query$Products instance,
    TRes Function(Variables$Query$Products) then,
  ) = _CopyWithImpl$Variables$Query$Products;

  factory CopyWith$Variables$Query$Products.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Products;

  TRes call({
    String? slug,
    String? id,
  });
}

class _CopyWithImpl$Variables$Query$Products<TRes>
    implements CopyWith$Variables$Query$Products<TRes> {
  _CopyWithImpl$Variables$Query$Products(
    this._instance,
    this._then,
  );

  final Variables$Query$Products _instance;

  final TRes Function(Variables$Query$Products) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? slug = _undefined,
    Object? id = _undefined,
  }) =>
      _then(Variables$Query$Products._({
        ..._instance._$data,
        if (slug != _undefined) 'slug': (slug as String?),
        if (id != _undefined) 'id': (id as String?),
      }));
}

class _CopyWithStubImpl$Variables$Query$Products<TRes>
    implements CopyWith$Variables$Query$Products<TRes> {
  _CopyWithStubImpl$Variables$Query$Products(this._res);

  TRes _res;

  call({
    String? slug,
    String? id,
  }) =>
      _res;
}

class Query$Products {
  Query$Products({
    this.collection,
    this.$__typename = 'Query',
  });

  factory Query$Products.fromJson(Map<String, dynamic> json) {
    final l$collection = json['collection'];
    final l$$__typename = json['__typename'];
    return Query$Products(
      collection: l$collection == null
          ? null
          : Query$Products$collection.fromJson(
              (l$collection as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$Products$collection? collection;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$collection = collection;
    _resultData['collection'] = l$collection?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$collection = collection;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$collection,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Products || runtimeType != other.runtimeType) {
      return false;
    }
    final l$collection = collection;
    final lOther$collection = other.collection;
    if (l$collection != lOther$collection) {
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

extension UtilityExtension$Query$Products on Query$Products {
  CopyWith$Query$Products<Query$Products> get copyWith =>
      CopyWith$Query$Products(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$Products<TRes> {
  factory CopyWith$Query$Products(
    Query$Products instance,
    TRes Function(Query$Products) then,
  ) = _CopyWithImpl$Query$Products;

  factory CopyWith$Query$Products.stub(TRes res) =
      _CopyWithStubImpl$Query$Products;

  TRes call({
    Query$Products$collection? collection,
    String? $__typename,
  });
  CopyWith$Query$Products$collection<TRes> get collection;
}

class _CopyWithImpl$Query$Products<TRes>
    implements CopyWith$Query$Products<TRes> {
  _CopyWithImpl$Query$Products(
    this._instance,
    this._then,
  );

  final Query$Products _instance;

  final TRes Function(Query$Products) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? collection = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Products(
        collection: collection == _undefined
            ? _instance.collection
            : (collection as Query$Products$collection?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$Products$collection<TRes> get collection {
    final local$collection = _instance.collection;
    return local$collection == null
        ? CopyWith$Query$Products$collection.stub(_then(_instance))
        : CopyWith$Query$Products$collection(
            local$collection, (e) => call(collection: e));
  }
}

class _CopyWithStubImpl$Query$Products<TRes>
    implements CopyWith$Query$Products<TRes> {
  _CopyWithStubImpl$Query$Products(this._res);

  TRes _res;

  call({
    Query$Products$collection? collection,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$Products$collection<TRes> get collection =>
      CopyWith$Query$Products$collection.stub(_res);
}

const documentNodeQueryProducts = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'Products'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'slug')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'id')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'collection'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'slug'),
            value: VariableNode(name: NameNode(value: 'slug')),
          ),
          ArgumentNode(
            name: NameNode(value: 'id'),
            value: VariableNode(name: NameNode(value: 'id')),
          ),
        ],
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
            name: NameNode(value: 'productVariants'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'items'),
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
                    name: NameNode(value: 'product'),
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
                        name: NameNode(value: 'slug'),
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
                        name: NameNode(value: 'optionGroups'),
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
                    name: NameNode(value: 'customFields'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                        name: NameNode(value: 'shadowPrice'),
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
                    name: NameNode(value: 'priceWithTax'),
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
                    name: NameNode(value: 'productId'),
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
                    name: NameNode(value: 'options'),
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
                        name: NameNode(value: 'group'),
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
  fragmentDefinitionAsset,
]);
Query$Products _parserFn$Query$Products(Map<String, dynamic> data) =>
    Query$Products.fromJson(data);
typedef OnQueryComplete$Query$Products = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$Products?,
);

class Options$Query$Products extends graphql.QueryOptions<Query$Products> {
  Options$Query$Products({
    String? operationName,
    Variables$Query$Products? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Products? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$Products? onComplete,
    graphql.OnQueryError? onError,
  })  : onCompleteWithParsed = onComplete,
        super(
          variables: variables?.toJson() ?? {},
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          pollInterval: pollInterval,
          context: context,
          onComplete: onComplete == null
              ? null
              : (data) => onComplete(
                    data,
                    data == null ? null : _parserFn$Query$Products(data),
                  ),
          onError: onError,
          document: documentNodeQueryProducts,
          parserFn: _parserFn$Query$Products,
        );

  final OnQueryComplete$Query$Products? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$Products
    extends graphql.WatchQueryOptions<Query$Products> {
  WatchOptions$Query$Products({
    String? operationName,
    Variables$Query$Products? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Products? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
          variables: variables?.toJson() ?? {},
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          document: documentNodeQueryProducts,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$Products,
        );
}

class FetchMoreOptions$Query$Products extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Products({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$Products? variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables?.toJson() ?? {},
          document: documentNodeQueryProducts,
        );
}

extension ClientExtension$Query$Products on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Products>> query$Products(
          [Options$Query$Products? options]) async =>
      await this.query(options ?? Options$Query$Products());

  graphql.ObservableQuery<Query$Products> watchQuery$Products(
          [WatchOptions$Query$Products? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$Products());

  void writeQuery$Products({
    required Query$Products data,
    Variables$Query$Products? variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryProducts),
          variables: variables?.toJson() ?? const {},
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$Products? readQuery$Products({
    Variables$Query$Products? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryProducts),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$Products.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$Products> useQuery$Products(
        [Options$Query$Products? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$Products());
graphql.ObservableQuery<Query$Products> useWatchQuery$Products(
        [WatchOptions$Query$Products? options]) =>
    graphql_flutter.useWatchQuery(options ?? WatchOptions$Query$Products());

class Query$Products$Widget extends graphql_flutter.Query<Query$Products> {
  Query$Products$Widget({
    widgets.Key? key,
    Options$Query$Products? options,
    required graphql_flutter.QueryBuilder<Query$Products> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$Products(),
          builder: builder,
        );
}

class Query$Products$collection {
  Query$Products$collection({
    required this.id,
    required this.name,
    required this.productVariants,
    this.$__typename = 'Collection',
  });

  factory Query$Products$collection.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$productVariants = json['productVariants'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection(
      id: (l$id as String),
      name: (l$name as String),
      productVariants: Query$Products$collection$productVariants.fromJson(
          (l$productVariants as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final Query$Products$collection$productVariants productVariants;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$productVariants = productVariants;
    _resultData['productVariants'] = l$productVariants.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$productVariants = productVariants;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$productVariants,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Products$collection ||
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
    final l$productVariants = productVariants;
    final lOther$productVariants = other.productVariants;
    if (l$productVariants != lOther$productVariants) {
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

extension UtilityExtension$Query$Products$collection
    on Query$Products$collection {
  CopyWith$Query$Products$collection<Query$Products$collection> get copyWith =>
      CopyWith$Query$Products$collection(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$Products$collection<TRes> {
  factory CopyWith$Query$Products$collection(
    Query$Products$collection instance,
    TRes Function(Query$Products$collection) then,
  ) = _CopyWithImpl$Query$Products$collection;

  factory CopyWith$Query$Products$collection.stub(TRes res) =
      _CopyWithStubImpl$Query$Products$collection;

  TRes call({
    String? id,
    String? name,
    Query$Products$collection$productVariants? productVariants,
    String? $__typename,
  });
  CopyWith$Query$Products$collection$productVariants<TRes> get productVariants;
}

class _CopyWithImpl$Query$Products$collection<TRes>
    implements CopyWith$Query$Products$collection<TRes> {
  _CopyWithImpl$Query$Products$collection(
    this._instance,
    this._then,
  );

  final Query$Products$collection _instance;

  final TRes Function(Query$Products$collection) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? productVariants = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Products$collection(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        productVariants: productVariants == _undefined ||
                productVariants == null
            ? _instance.productVariants
            : (productVariants as Query$Products$collection$productVariants),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$Products$collection$productVariants<TRes> get productVariants {
    final local$productVariants = _instance.productVariants;
    return CopyWith$Query$Products$collection$productVariants(
        local$productVariants, (e) => call(productVariants: e));
  }
}

class _CopyWithStubImpl$Query$Products$collection<TRes>
    implements CopyWith$Query$Products$collection<TRes> {
  _CopyWithStubImpl$Query$Products$collection(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Query$Products$collection$productVariants? productVariants,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$Products$collection$productVariants<TRes>
      get productVariants =>
          CopyWith$Query$Products$collection$productVariants.stub(_res);
}

class Query$Products$collection$productVariants {
  Query$Products$collection$productVariants({
    required this.items,
    this.$__typename = 'ProductVariantList',
  });

  factory Query$Products$collection$productVariants.fromJson(
      Map<String, dynamic> json) {
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection$productVariants(
      items: (l$items as List<dynamic>)
          .map((e) => Query$Products$collection$productVariants$items.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$Products$collection$productVariants$items> items;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$items = items;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$items.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Products$collection$productVariants ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$items = items;
    final lOther$items = other.items;
    if (l$items.length != lOther$items.length) {
      return false;
    }
    for (int i = 0; i < l$items.length; i++) {
      final l$items$entry = l$items[i];
      final lOther$items$entry = lOther$items[i];
      if (l$items$entry != lOther$items$entry) {
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

extension UtilityExtension$Query$Products$collection$productVariants
    on Query$Products$collection$productVariants {
  CopyWith$Query$Products$collection$productVariants<
          Query$Products$collection$productVariants>
      get copyWith => CopyWith$Query$Products$collection$productVariants(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Products$collection$productVariants<TRes> {
  factory CopyWith$Query$Products$collection$productVariants(
    Query$Products$collection$productVariants instance,
    TRes Function(Query$Products$collection$productVariants) then,
  ) = _CopyWithImpl$Query$Products$collection$productVariants;

  factory CopyWith$Query$Products$collection$productVariants.stub(TRes res) =
      _CopyWithStubImpl$Query$Products$collection$productVariants;

  TRes call({
    List<Query$Products$collection$productVariants$items>? items,
    String? $__typename,
  });
  TRes items(
      Iterable<Query$Products$collection$productVariants$items> Function(
              Iterable<
                  CopyWith$Query$Products$collection$productVariants$items<
                      Query$Products$collection$productVariants$items>>)
          _fn);
}

class _CopyWithImpl$Query$Products$collection$productVariants<TRes>
    implements CopyWith$Query$Products$collection$productVariants<TRes> {
  _CopyWithImpl$Query$Products$collection$productVariants(
    this._instance,
    this._then,
  );

  final Query$Products$collection$productVariants _instance;

  final TRes Function(Query$Products$collection$productVariants) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Products$collection$productVariants(
        items: items == _undefined || items == null
            ? _instance.items
            : (items as List<Query$Products$collection$productVariants$items>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes items(
          Iterable<Query$Products$collection$productVariants$items> Function(
                  Iterable<
                      CopyWith$Query$Products$collection$productVariants$items<
                          Query$Products$collection$productVariants$items>>)
              _fn) =>
      call(
          items: _fn(_instance.items.map(
              (e) => CopyWith$Query$Products$collection$productVariants$items(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$Products$collection$productVariants<TRes>
    implements CopyWith$Query$Products$collection$productVariants<TRes> {
  _CopyWithStubImpl$Query$Products$collection$productVariants(this._res);

  TRes _res;

  call({
    List<Query$Products$collection$productVariants$items>? items,
    String? $__typename,
  }) =>
      _res;

  items(_fn) => _res;
}

class Query$Products$collection$productVariants$items {
  Query$Products$collection$productVariants$items({
    required this.id,
    required this.product,
    this.customFields,
    required this.priceWithTax,
    required this.stockLevel,
    required this.productId,
    required this.name,
    required this.options,
    this.$__typename = 'ProductVariant',
  });

  factory Query$Products$collection$productVariants$items.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$product = json['product'];
    final l$customFields = json['customFields'];
    final l$priceWithTax = json['priceWithTax'];
    final l$stockLevel = json['stockLevel'];
    final l$productId = json['productId'];
    final l$name = json['name'];
    final l$options = json['options'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection$productVariants$items(
      id: (l$id as String),
      product: Query$Products$collection$productVariants$items$product.fromJson(
          (l$product as Map<String, dynamic>)),
      customFields: l$customFields == null
          ? null
          : Query$Products$collection$productVariants$items$customFields
              .fromJson((l$customFields as Map<String, dynamic>)),
      priceWithTax: (l$priceWithTax as num).toDouble(),
      stockLevel: (l$stockLevel as String),
      productId: (l$productId as String),
      name: (l$name as String),
      options: (l$options as List<dynamic>)
          .map((e) =>
              Query$Products$collection$productVariants$items$options.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query$Products$collection$productVariants$items$product product;

  final Query$Products$collection$productVariants$items$customFields?
      customFields;

  final double priceWithTax;

  final String stockLevel;

  final String productId;

  final String name;

  final List<Query$Products$collection$productVariants$items$options> options;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$product = product;
    _resultData['product'] = l$product.toJson();
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
    final l$priceWithTax = priceWithTax;
    _resultData['priceWithTax'] = l$priceWithTax;
    final l$stockLevel = stockLevel;
    _resultData['stockLevel'] = l$stockLevel;
    final l$productId = productId;
    _resultData['productId'] = l$productId;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$options = options;
    _resultData['options'] = l$options.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$product = product;
    final l$customFields = customFields;
    final l$priceWithTax = priceWithTax;
    final l$stockLevel = stockLevel;
    final l$productId = productId;
    final l$name = name;
    final l$options = options;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$product,
      l$customFields,
      l$priceWithTax,
      l$stockLevel,
      l$productId,
      l$name,
      Object.hashAll(l$options.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Products$collection$productVariants$items ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$product = product;
    final lOther$product = other.product;
    if (l$product != lOther$product) {
      return false;
    }
    final l$customFields = customFields;
    final lOther$customFields = other.customFields;
    if (l$customFields != lOther$customFields) {
      return false;
    }
    final l$priceWithTax = priceWithTax;
    final lOther$priceWithTax = other.priceWithTax;
    if (l$priceWithTax != lOther$priceWithTax) {
      return false;
    }
    final l$stockLevel = stockLevel;
    final lOther$stockLevel = other.stockLevel;
    if (l$stockLevel != lOther$stockLevel) {
      return false;
    }
    final l$productId = productId;
    final lOther$productId = other.productId;
    if (l$productId != lOther$productId) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$options = options;
    final lOther$options = other.options;
    if (l$options.length != lOther$options.length) {
      return false;
    }
    for (int i = 0; i < l$options.length; i++) {
      final l$options$entry = l$options[i];
      final lOther$options$entry = lOther$options[i];
      if (l$options$entry != lOther$options$entry) {
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

extension UtilityExtension$Query$Products$collection$productVariants$items
    on Query$Products$collection$productVariants$items {
  CopyWith$Query$Products$collection$productVariants$items<
          Query$Products$collection$productVariants$items>
      get copyWith => CopyWith$Query$Products$collection$productVariants$items(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Products$collection$productVariants$items<TRes> {
  factory CopyWith$Query$Products$collection$productVariants$items(
    Query$Products$collection$productVariants$items instance,
    TRes Function(Query$Products$collection$productVariants$items) then,
  ) = _CopyWithImpl$Query$Products$collection$productVariants$items;

  factory CopyWith$Query$Products$collection$productVariants$items.stub(
          TRes res) =
      _CopyWithStubImpl$Query$Products$collection$productVariants$items;

  TRes call({
    String? id,
    Query$Products$collection$productVariants$items$product? product,
    Query$Products$collection$productVariants$items$customFields? customFields,
    double? priceWithTax,
    String? stockLevel,
    String? productId,
    String? name,
    List<Query$Products$collection$productVariants$items$options>? options,
    String? $__typename,
  });
  CopyWith$Query$Products$collection$productVariants$items$product<TRes>
      get product;
  CopyWith$Query$Products$collection$productVariants$items$customFields<TRes>
      get customFields;
  TRes options(
      Iterable<Query$Products$collection$productVariants$items$options> Function(
              Iterable<
                  CopyWith$Query$Products$collection$productVariants$items$options<
                      Query$Products$collection$productVariants$items$options>>)
          _fn);
}

class _CopyWithImpl$Query$Products$collection$productVariants$items<TRes>
    implements CopyWith$Query$Products$collection$productVariants$items<TRes> {
  _CopyWithImpl$Query$Products$collection$productVariants$items(
    this._instance,
    this._then,
  );

  final Query$Products$collection$productVariants$items _instance;

  final TRes Function(Query$Products$collection$productVariants$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? product = _undefined,
    Object? customFields = _undefined,
    Object? priceWithTax = _undefined,
    Object? stockLevel = _undefined,
    Object? productId = _undefined,
    Object? name = _undefined,
    Object? options = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Products$collection$productVariants$items(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        product: product == _undefined || product == null
            ? _instance.product
            : (product
                as Query$Products$collection$productVariants$items$product),
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Query$Products$collection$productVariants$items$customFields?),
        priceWithTax: priceWithTax == _undefined || priceWithTax == null
            ? _instance.priceWithTax
            : (priceWithTax as double),
        stockLevel: stockLevel == _undefined || stockLevel == null
            ? _instance.stockLevel
            : (stockLevel as String),
        productId: productId == _undefined || productId == null
            ? _instance.productId
            : (productId as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        options: options == _undefined || options == null
            ? _instance.options
            : (options as List<
                Query$Products$collection$productVariants$items$options>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$Products$collection$productVariants$items$product<TRes>
      get product {
    final local$product = _instance.product;
    return CopyWith$Query$Products$collection$productVariants$items$product(
        local$product, (e) => call(product: e));
  }

  CopyWith$Query$Products$collection$productVariants$items$customFields<TRes>
      get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Query$Products$collection$productVariants$items$customFields
            .stub(_then(_instance))
        : CopyWith$Query$Products$collection$productVariants$items$customFields(
            local$customFields, (e) => call(customFields: e));
  }

  TRes options(
          Iterable<Query$Products$collection$productVariants$items$options> Function(
                  Iterable<
                      CopyWith$Query$Products$collection$productVariants$items$options<
                          Query$Products$collection$productVariants$items$options>>)
              _fn) =>
      call(
          options: _fn(_instance.options.map((e) =>
              CopyWith$Query$Products$collection$productVariants$items$options(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Query$Products$collection$productVariants$items<TRes>
    implements CopyWith$Query$Products$collection$productVariants$items<TRes> {
  _CopyWithStubImpl$Query$Products$collection$productVariants$items(this._res);

  TRes _res;

  call({
    String? id,
    Query$Products$collection$productVariants$items$product? product,
    Query$Products$collection$productVariants$items$customFields? customFields,
    double? priceWithTax,
    String? stockLevel,
    String? productId,
    String? name,
    List<Query$Products$collection$productVariants$items$options>? options,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$Products$collection$productVariants$items$product<TRes>
      get product =>
          CopyWith$Query$Products$collection$productVariants$items$product.stub(
              _res);

  CopyWith$Query$Products$collection$productVariants$items$customFields<TRes>
      get customFields =>
          CopyWith$Query$Products$collection$productVariants$items$customFields
              .stub(_res);

  options(_fn) => _res;
}

class Query$Products$collection$productVariants$items$product {
  Query$Products$collection$productVariants$items$product({
    required this.id,
    required this.name,
    required this.slug,
    required this.enabled,
    this.featuredAsset,
    required this.optionGroups,
    this.$__typename = 'Product',
  });

  factory Query$Products$collection$productVariants$items$product.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$slug = json['slug'];
    final l$enabled = json['enabled'];
    final l$featuredAsset = json['featuredAsset'];
    final l$optionGroups = json['optionGroups'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection$productVariants$items$product(
      id: (l$id as String),
      name: (l$name as String),
      slug: (l$slug as String),
      enabled: (l$enabled as bool),
      featuredAsset: l$featuredAsset == null
          ? null
          : Fragment$Asset.fromJson((l$featuredAsset as Map<String, dynamic>)),
      optionGroups: (l$optionGroups as List<dynamic>)
          .map((e) =>
              Query$Products$collection$productVariants$items$product$optionGroups
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String slug;

  final bool enabled;

  final Fragment$Asset? featuredAsset;

  final List<
          Query$Products$collection$productVariants$items$product$optionGroups>
      optionGroups;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$slug = slug;
    _resultData['slug'] = l$slug;
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
    final l$featuredAsset = featuredAsset;
    _resultData['featuredAsset'] = l$featuredAsset?.toJson();
    final l$optionGroups = optionGroups;
    _resultData['optionGroups'] =
        l$optionGroups.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$slug = slug;
    final l$enabled = enabled;
    final l$featuredAsset = featuredAsset;
    final l$optionGroups = optionGroups;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$slug,
      l$enabled,
      l$featuredAsset,
      Object.hashAll(l$optionGroups.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Products$collection$productVariants$items$product ||
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
    final l$slug = slug;
    final lOther$slug = other.slug;
    if (l$slug != lOther$slug) {
      return false;
    }
    final l$enabled = enabled;
    final lOther$enabled = other.enabled;
    if (l$enabled != lOther$enabled) {
      return false;
    }
    final l$featuredAsset = featuredAsset;
    final lOther$featuredAsset = other.featuredAsset;
    if (l$featuredAsset != lOther$featuredAsset) {
      return false;
    }
    final l$optionGroups = optionGroups;
    final lOther$optionGroups = other.optionGroups;
    if (l$optionGroups.length != lOther$optionGroups.length) {
      return false;
    }
    for (int i = 0; i < l$optionGroups.length; i++) {
      final l$optionGroups$entry = l$optionGroups[i];
      final lOther$optionGroups$entry = lOther$optionGroups[i];
      if (l$optionGroups$entry != lOther$optionGroups$entry) {
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

extension UtilityExtension$Query$Products$collection$productVariants$items$product
    on Query$Products$collection$productVariants$items$product {
  CopyWith$Query$Products$collection$productVariants$items$product<
          Query$Products$collection$productVariants$items$product>
      get copyWith =>
          CopyWith$Query$Products$collection$productVariants$items$product(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Products$collection$productVariants$items$product<
    TRes> {
  factory CopyWith$Query$Products$collection$productVariants$items$product(
    Query$Products$collection$productVariants$items$product instance,
    TRes Function(Query$Products$collection$productVariants$items$product) then,
  ) = _CopyWithImpl$Query$Products$collection$productVariants$items$product;

  factory CopyWith$Query$Products$collection$productVariants$items$product.stub(
          TRes res) =
      _CopyWithStubImpl$Query$Products$collection$productVariants$items$product;

  TRes call({
    String? id,
    String? name,
    String? slug,
    bool? enabled,
    Fragment$Asset? featuredAsset,
    List<Query$Products$collection$productVariants$items$product$optionGroups>?
        optionGroups,
    String? $__typename,
  });
  CopyWith$Fragment$Asset<TRes> get featuredAsset;
  TRes optionGroups(
      Iterable<Query$Products$collection$productVariants$items$product$optionGroups> Function(
              Iterable<
                  CopyWith$Query$Products$collection$productVariants$items$product$optionGroups<
                      Query$Products$collection$productVariants$items$product$optionGroups>>)
          _fn);
}

class _CopyWithImpl$Query$Products$collection$productVariants$items$product<
        TRes>
    implements
        CopyWith$Query$Products$collection$productVariants$items$product<TRes> {
  _CopyWithImpl$Query$Products$collection$productVariants$items$product(
    this._instance,
    this._then,
  );

  final Query$Products$collection$productVariants$items$product _instance;

  final TRes Function(Query$Products$collection$productVariants$items$product)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? slug = _undefined,
    Object? enabled = _undefined,
    Object? featuredAsset = _undefined,
    Object? optionGroups = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Products$collection$productVariants$items$product(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        slug: slug == _undefined || slug == null
            ? _instance.slug
            : (slug as String),
        enabled: enabled == _undefined || enabled == null
            ? _instance.enabled
            : (enabled as bool),
        featuredAsset: featuredAsset == _undefined
            ? _instance.featuredAsset
            : (featuredAsset as Fragment$Asset?),
        optionGroups: optionGroups == _undefined || optionGroups == null
            ? _instance.optionGroups
            : (optionGroups as List<
                Query$Products$collection$productVariants$items$product$optionGroups>),
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

  TRes optionGroups(
          Iterable<Query$Products$collection$productVariants$items$product$optionGroups> Function(
                  Iterable<
                      CopyWith$Query$Products$collection$productVariants$items$product$optionGroups<
                          Query$Products$collection$productVariants$items$product$optionGroups>>)
              _fn) =>
      call(
          optionGroups: _fn(_instance.optionGroups.map((e) =>
              CopyWith$Query$Products$collection$productVariants$items$product$optionGroups(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Query$Products$collection$productVariants$items$product<
        TRes>
    implements
        CopyWith$Query$Products$collection$productVariants$items$product<TRes> {
  _CopyWithStubImpl$Query$Products$collection$productVariants$items$product(
      this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? slug,
    bool? enabled,
    Fragment$Asset? featuredAsset,
    List<Query$Products$collection$productVariants$items$product$optionGroups>?
        optionGroups,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Fragment$Asset<TRes> get featuredAsset =>
      CopyWith$Fragment$Asset.stub(_res);

  optionGroups(_fn) => _res;
}

class Query$Products$collection$productVariants$items$product$optionGroups {
  Query$Products$collection$productVariants$items$product$optionGroups({
    required this.id,
    required this.name,
    this.$__typename = 'ProductOptionGroup',
  });

  factory Query$Products$collection$productVariants$items$product$optionGroups.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection$productVariants$items$product$optionGroups(
      id: (l$id as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
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
            is! Query$Products$collection$productVariants$items$product$optionGroups ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Products$collection$productVariants$items$product$optionGroups
    on Query$Products$collection$productVariants$items$product$optionGroups {
  CopyWith$Query$Products$collection$productVariants$items$product$optionGroups<
          Query$Products$collection$productVariants$items$product$optionGroups>
      get copyWith =>
          CopyWith$Query$Products$collection$productVariants$items$product$optionGroups(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Products$collection$productVariants$items$product$optionGroups<
    TRes> {
  factory CopyWith$Query$Products$collection$productVariants$items$product$optionGroups(
    Query$Products$collection$productVariants$items$product$optionGroups
        instance,
    TRes Function(
            Query$Products$collection$productVariants$items$product$optionGroups)
        then,
  ) = _CopyWithImpl$Query$Products$collection$productVariants$items$product$optionGroups;

  factory CopyWith$Query$Products$collection$productVariants$items$product$optionGroups.stub(
          TRes res) =
      _CopyWithStubImpl$Query$Products$collection$productVariants$items$product$optionGroups;

  TRes call({
    String? id,
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Products$collection$productVariants$items$product$optionGroups<
        TRes>
    implements
        CopyWith$Query$Products$collection$productVariants$items$product$optionGroups<
            TRes> {
  _CopyWithImpl$Query$Products$collection$productVariants$items$product$optionGroups(
    this._instance,
    this._then,
  );

  final Query$Products$collection$productVariants$items$product$optionGroups
      _instance;

  final TRes Function(
          Query$Products$collection$productVariants$items$product$optionGroups)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Query$Products$collection$productVariants$items$product$optionGroups(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Products$collection$productVariants$items$product$optionGroups<
        TRes>
    implements
        CopyWith$Query$Products$collection$productVariants$items$product$optionGroups<
            TRes> {
  _CopyWithStubImpl$Query$Products$collection$productVariants$items$product$optionGroups(
      this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? $__typename,
  }) =>
      _res;
}

class Query$Products$collection$productVariants$items$customFields {
  Query$Products$collection$productVariants$items$customFields({
    this.shadowPrice,
    this.$__typename = 'ProductVariantCustomFields',
  });

  factory Query$Products$collection$productVariants$items$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$shadowPrice = json['shadowPrice'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection$productVariants$items$customFields(
      shadowPrice: (l$shadowPrice as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? shadowPrice;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$shadowPrice = shadowPrice;
    _resultData['shadowPrice'] = l$shadowPrice;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$shadowPrice = shadowPrice;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$shadowPrice,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$Products$collection$productVariants$items$customFields ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$shadowPrice = shadowPrice;
    final lOther$shadowPrice = other.shadowPrice;
    if (l$shadowPrice != lOther$shadowPrice) {
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

extension UtilityExtension$Query$Products$collection$productVariants$items$customFields
    on Query$Products$collection$productVariants$items$customFields {
  CopyWith$Query$Products$collection$productVariants$items$customFields<
          Query$Products$collection$productVariants$items$customFields>
      get copyWith =>
          CopyWith$Query$Products$collection$productVariants$items$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Products$collection$productVariants$items$customFields<
    TRes> {
  factory CopyWith$Query$Products$collection$productVariants$items$customFields(
    Query$Products$collection$productVariants$items$customFields instance,
    TRes Function(Query$Products$collection$productVariants$items$customFields)
        then,
  ) = _CopyWithImpl$Query$Products$collection$productVariants$items$customFields;

  factory CopyWith$Query$Products$collection$productVariants$items$customFields.stub(
          TRes res) =
      _CopyWithStubImpl$Query$Products$collection$productVariants$items$customFields;

  TRes call({
    int? shadowPrice,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Products$collection$productVariants$items$customFields<
        TRes>
    implements
        CopyWith$Query$Products$collection$productVariants$items$customFields<
            TRes> {
  _CopyWithImpl$Query$Products$collection$productVariants$items$customFields(
    this._instance,
    this._then,
  );

  final Query$Products$collection$productVariants$items$customFields _instance;

  final TRes Function(
      Query$Products$collection$productVariants$items$customFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? shadowPrice = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Products$collection$productVariants$items$customFields(
        shadowPrice: shadowPrice == _undefined
            ? _instance.shadowPrice
            : (shadowPrice as int?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Products$collection$productVariants$items$customFields<
        TRes>
    implements
        CopyWith$Query$Products$collection$productVariants$items$customFields<
            TRes> {
  _CopyWithStubImpl$Query$Products$collection$productVariants$items$customFields(
      this._res);

  TRes _res;

  call({
    int? shadowPrice,
    String? $__typename,
  }) =>
      _res;
}

class Query$Products$collection$productVariants$items$options {
  Query$Products$collection$productVariants$items$options({
    required this.id,
    required this.name,
    required this.group,
    this.$__typename = 'ProductOption',
  });

  factory Query$Products$collection$productVariants$items$options.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$group = json['group'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection$productVariants$items$options(
      id: (l$id as String),
      name: (l$name as String),
      group: Query$Products$collection$productVariants$items$options$group
          .fromJson((l$group as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final Query$Products$collection$productVariants$items$options$group group;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$group = group;
    _resultData['group'] = l$group.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$group = group;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$group,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Products$collection$productVariants$items$options ||
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
    final l$group = group;
    final lOther$group = other.group;
    if (l$group != lOther$group) {
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

extension UtilityExtension$Query$Products$collection$productVariants$items$options
    on Query$Products$collection$productVariants$items$options {
  CopyWith$Query$Products$collection$productVariants$items$options<
          Query$Products$collection$productVariants$items$options>
      get copyWith =>
          CopyWith$Query$Products$collection$productVariants$items$options(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Products$collection$productVariants$items$options<
    TRes> {
  factory CopyWith$Query$Products$collection$productVariants$items$options(
    Query$Products$collection$productVariants$items$options instance,
    TRes Function(Query$Products$collection$productVariants$items$options) then,
  ) = _CopyWithImpl$Query$Products$collection$productVariants$items$options;

  factory CopyWith$Query$Products$collection$productVariants$items$options.stub(
          TRes res) =
      _CopyWithStubImpl$Query$Products$collection$productVariants$items$options;

  TRes call({
    String? id,
    String? name,
    Query$Products$collection$productVariants$items$options$group? group,
    String? $__typename,
  });
  CopyWith$Query$Products$collection$productVariants$items$options$group<TRes>
      get group;
}

class _CopyWithImpl$Query$Products$collection$productVariants$items$options<
        TRes>
    implements
        CopyWith$Query$Products$collection$productVariants$items$options<TRes> {
  _CopyWithImpl$Query$Products$collection$productVariants$items$options(
    this._instance,
    this._then,
  );

  final Query$Products$collection$productVariants$items$options _instance;

  final TRes Function(Query$Products$collection$productVariants$items$options)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? group = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Products$collection$productVariants$items$options(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        group: group == _undefined || group == null
            ? _instance.group
            : (group
                as Query$Products$collection$productVariants$items$options$group),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$Products$collection$productVariants$items$options$group<TRes>
      get group {
    final local$group = _instance.group;
    return CopyWith$Query$Products$collection$productVariants$items$options$group(
        local$group, (e) => call(group: e));
  }
}

class _CopyWithStubImpl$Query$Products$collection$productVariants$items$options<
        TRes>
    implements
        CopyWith$Query$Products$collection$productVariants$items$options<TRes> {
  _CopyWithStubImpl$Query$Products$collection$productVariants$items$options(
      this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Query$Products$collection$productVariants$items$options$group? group,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$Products$collection$productVariants$items$options$group<TRes>
      get group =>
          CopyWith$Query$Products$collection$productVariants$items$options$group
              .stub(_res);
}

class Query$Products$collection$productVariants$items$options$group {
  Query$Products$collection$productVariants$items$options$group({
    required this.id,
    required this.name,
    this.$__typename = 'ProductOptionGroup',
  });

  factory Query$Products$collection$productVariants$items$options$group.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection$productVariants$items$options$group(
      id: (l$id as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
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
            is! Query$Products$collection$productVariants$items$options$group ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Products$collection$productVariants$items$options$group
    on Query$Products$collection$productVariants$items$options$group {
  CopyWith$Query$Products$collection$productVariants$items$options$group<
          Query$Products$collection$productVariants$items$options$group>
      get copyWith =>
          CopyWith$Query$Products$collection$productVariants$items$options$group(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Products$collection$productVariants$items$options$group<
    TRes> {
  factory CopyWith$Query$Products$collection$productVariants$items$options$group(
    Query$Products$collection$productVariants$items$options$group instance,
    TRes Function(Query$Products$collection$productVariants$items$options$group)
        then,
  ) = _CopyWithImpl$Query$Products$collection$productVariants$items$options$group;

  factory CopyWith$Query$Products$collection$productVariants$items$options$group.stub(
          TRes res) =
      _CopyWithStubImpl$Query$Products$collection$productVariants$items$options$group;

  TRes call({
    String? id,
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Products$collection$productVariants$items$options$group<
        TRes>
    implements
        CopyWith$Query$Products$collection$productVariants$items$options$group<
            TRes> {
  _CopyWithImpl$Query$Products$collection$productVariants$items$options$group(
    this._instance,
    this._then,
  );

  final Query$Products$collection$productVariants$items$options$group _instance;

  final TRes Function(
      Query$Products$collection$productVariants$items$options$group) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Products$collection$productVariants$items$options$group(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Products$collection$productVariants$items$options$group<
        TRes>
    implements
        CopyWith$Query$Products$collection$productVariants$items$options$group<
            TRes> {
  _CopyWithStubImpl$Query$Products$collection$productVariants$items$options$group(
      this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? $__typename,
  }) =>
      _res;
}
