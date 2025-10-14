import 'dart:async';
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
              (l$focalPoint as Map<String, dynamic>),
            ),
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
      CopyWith$Fragment$Asset(this, (i) => i);
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
  _CopyWithImpl$Fragment$Asset(this._instance, this._then);

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
  }) => _then(
    Fragment$Asset(
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
    ),
  );

  CopyWith$Fragment$Asset$focalPoint<TRes> get focalPoint {
    final local$focalPoint = _instance.focalPoint;
    return local$focalPoint == null
        ? CopyWith$Fragment$Asset$focalPoint.stub(_then(_instance))
        : CopyWith$Fragment$Asset$focalPoint(
            local$focalPoint,
            (e) => call(focalPoint: e),
          );
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
  }) => _res;

  CopyWith$Fragment$Asset$focalPoint<TRes> get focalPoint =>
      CopyWith$Fragment$Asset$focalPoint.stub(_res);
}

const fragmentDefinitionAsset = FragmentDefinitionNode(
  name: NameNode(value: 'Asset'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Asset'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
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
        selectionSet: SelectionSetNode(
          selections: [
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
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentAsset = DocumentNode(
  definitions: [fragmentDefinitionAsset],
);

extension ClientExtension$Fragment$Asset on graphql.GraphQLClient {
  void writeFragment$Asset({
    required Fragment$Asset data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
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
    return Object.hashAll([l$x, l$y, l$$__typename]);
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
      CopyWith$Fragment$Asset$focalPoint(this, (i) => i);
}

abstract class CopyWith$Fragment$Asset$focalPoint<TRes> {
  factory CopyWith$Fragment$Asset$focalPoint(
    Fragment$Asset$focalPoint instance,
    TRes Function(Fragment$Asset$focalPoint) then,
  ) = _CopyWithImpl$Fragment$Asset$focalPoint;

  factory CopyWith$Fragment$Asset$focalPoint.stub(TRes res) =
      _CopyWithStubImpl$Fragment$Asset$focalPoint;

  TRes call({double? x, double? y, String? $__typename});
}

class _CopyWithImpl$Fragment$Asset$focalPoint<TRes>
    implements CopyWith$Fragment$Asset$focalPoint<TRes> {
  _CopyWithImpl$Fragment$Asset$focalPoint(this._instance, this._then);

  final Fragment$Asset$focalPoint _instance;

  final TRes Function(Fragment$Asset$focalPoint) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? x = _undefined,
    Object? y = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$Asset$focalPoint(
      x: x == _undefined || x == null ? _instance.x : (x as double),
      y: y == _undefined || y == null ? _instance.y : (y as double),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$Asset$focalPoint<TRes>
    implements CopyWith$Fragment$Asset$focalPoint<TRes> {
  _CopyWithStubImpl$Fragment$Asset$focalPoint(this._res);

  TRes _res;

  call({double? x, double? y, String? $__typename}) => _res;
}

class Variables$Query$Collections {
  factory Variables$Query$Collections({Input$CollectionListOptions? options}) =>
      Variables$Query$Collections._({if (options != null) r'options': options});

  Variables$Query$Collections._(this._$data);

  factory Variables$Query$Collections.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('options')) {
      final l$options = data['options'];
      result$data['options'] = l$options == null
          ? null
          : Input$CollectionListOptions.fromJson(
              (l$options as Map<String, dynamic>),
            );
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
  get copyWith => CopyWith$Variables$Query$Collections(this, (i) => i);

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
    return Object.hashAll([
      _$data.containsKey('options') ? l$options : const {},
    ]);
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
  _CopyWithImpl$Variables$Query$Collections(this._instance, this._then);

  final Variables$Query$Collections _instance;

  final TRes Function(Variables$Query$Collections) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? options = _undefined}) => _then(
    Variables$Query$Collections._({
      ..._instance._$data,
      if (options != _undefined)
        'options': (options as Input$CollectionListOptions?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$Collections<TRes>
    implements CopyWith$Variables$Query$Collections<TRes> {
  _CopyWithStubImpl$Variables$Query$Collections(this._res);

  TRes _res;

  call({Input$CollectionListOptions? options}) => _res;
}

class Query$Collections {
  Query$Collections({required this.collections, this.$__typename = 'Query'});

  factory Query$Collections.fromJson(Map<String, dynamic> json) {
    final l$collections = json['collections'];
    final l$$__typename = json['__typename'];
    return Query$Collections(
      collections: Query$Collections$collections.fromJson(
        (l$collections as Map<String, dynamic>),
      ),
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
    return Object.hashAll([l$collections, l$$__typename]);
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
      CopyWith$Query$Collections(this, (i) => i);
}

abstract class CopyWith$Query$Collections<TRes> {
  factory CopyWith$Query$Collections(
    Query$Collections instance,
    TRes Function(Query$Collections) then,
  ) = _CopyWithImpl$Query$Collections;

  factory CopyWith$Query$Collections.stub(TRes res) =
      _CopyWithStubImpl$Query$Collections;

  TRes call({Query$Collections$collections? collections, String? $__typename});
  CopyWith$Query$Collections$collections<TRes> get collections;
}

class _CopyWithImpl$Query$Collections<TRes>
    implements CopyWith$Query$Collections<TRes> {
  _CopyWithImpl$Query$Collections(this._instance, this._then);

  final Query$Collections _instance;

  final TRes Function(Query$Collections) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? collections = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Collections(
      collections: collections == _undefined || collections == null
          ? _instance.collections
          : (collections as Query$Collections$collections),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$Collections$collections<TRes> get collections {
    final local$collections = _instance.collections;
    return CopyWith$Query$Collections$collections(
      local$collections,
      (e) => call(collections: e),
    );
  }
}

class _CopyWithStubImpl$Query$Collections<TRes>
    implements CopyWith$Query$Collections<TRes> {
  _CopyWithStubImpl$Query$Collections(this._res);

  TRes _res;

  call({Query$Collections$collections? collections, String? $__typename}) =>
      _res;

  CopyWith$Query$Collections$collections<TRes> get collections =>
      CopyWith$Query$Collections$collections.stub(_res);
}

const documentNodeQueryCollections = DocumentNode(
  definitions: [
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
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'collections'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'options'),
                value: VariableNode(name: NameNode(value: 'options')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'items'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
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
                        selectionSet: SelectionSetNode(
                          selections: [
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
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: 'productVariants'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
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
                          ],
                        ),
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
                        selectionSet: SelectionSetNode(
                          selections: [
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
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: 'featuredAsset'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
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
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
  ],
);
Query$Collections _parserFn$Query$Collections(Map<String, dynamic> data) =>
    Query$Collections.fromJson(data);
typedef OnQueryComplete$Query$Collections =
    FutureOr<void> Function(Map<String, dynamic>?, Query$Collections?);

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
  }) : onCompleteWithParsed = onComplete,
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
  Future<graphql.QueryResult<Query$Collections>> query$Collections([
    Options$Query$Collections? options,
  ]) async => await this.query(options ?? Options$Query$Collections());

  graphql.ObservableQuery<Query$Collections> watchQuery$Collections([
    WatchOptions$Query$Collections? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$Collections());

  void writeQuery$Collections({
    required Query$Collections data,
    Variables$Query$Collections? variables,
    bool broadcast = true,
  }) => this.writeQuery(
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

graphql_flutter.QueryHookResult<Query$Collections> useQuery$Collections([
  Options$Query$Collections? options,
]) => graphql_flutter.useQuery(options ?? Options$Query$Collections());
graphql.ObservableQuery<Query$Collections> useWatchQuery$Collections([
  WatchOptions$Query$Collections? options,
]) =>
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
          .map(
            (e) => Query$Collections$collections$items.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
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
  get copyWith => CopyWith$Query$Collections$collections(this, (i) => i);
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
          Query$Collections$collections$items
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$Collections$collections<TRes>
    implements CopyWith$Query$Collections$collections<TRes> {
  _CopyWithImpl$Query$Collections$collections(this._instance, this._then);

  final Query$Collections$collections _instance;

  final TRes Function(Query$Collections$collections) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? items = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$Collections$collections(
          items: items == _undefined || items == null
              ? _instance.items
              : (items as List<Query$Collections$collections$items>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes items(
    Iterable<Query$Collections$collections$items> Function(
      Iterable<
        CopyWith$Query$Collections$collections$items<
          Query$Collections$collections$items
        >
      >,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) => CopyWith$Query$Collections$collections$items(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$Collections$collections<TRes>
    implements CopyWith$Query$Collections$collections<TRes> {
  _CopyWithStubImpl$Query$Collections$collections(this._res);

  TRes _res;

  call({
    List<Query$Collections$collections$items>? items,
    String? $__typename,
  }) => _res;

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
    Map<String, dynamic> json,
  ) {
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
          ?.map(
            (e) => Query$Collections$collections$items$children.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      productVariants:
          Query$Collections$collections$items$productVariants.fromJson(
            (l$productVariants as Map<String, dynamic>),
          ),
      slug: (l$slug as String),
      parent: l$parent == null
          ? null
          : Query$Collections$collections$items$parent.fromJson(
              (l$parent as Map<String, dynamic>),
            ),
      featuredAsset: l$featuredAsset == null
          ? null
          : Query$Collections$collections$items$featuredAsset.fromJson(
              (l$featuredAsset as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Query$Collections$collections$items$children>? children;

  final Query$Collections$collections$items$productVariants productVariants;

  final String slug;

  final Query$Collections$collections$items$parent? parent;

  final Query$Collections$collections$items$featuredAsset? featuredAsset;

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
    Query$Collections$collections$items
  >
  get copyWith => CopyWith$Query$Collections$collections$items(this, (i) => i);
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
    Query$Collections$collections$items$featuredAsset? featuredAsset,
    String? $__typename,
  });
  TRes children(
    Iterable<Query$Collections$collections$items$children>? Function(
      Iterable<
        CopyWith$Query$Collections$collections$items$children<
          Query$Collections$collections$items$children
        >
      >?,
    )
    _fn,
  );
  CopyWith$Query$Collections$collections$items$productVariants<TRes>
  get productVariants;
  CopyWith$Query$Collections$collections$items$parent<TRes> get parent;
  CopyWith$Query$Collections$collections$items$featuredAsset<TRes>
  get featuredAsset;
}

class _CopyWithImpl$Query$Collections$collections$items<TRes>
    implements CopyWith$Query$Collections$collections$items<TRes> {
  _CopyWithImpl$Query$Collections$collections$items(this._instance, this._then);

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
  }) => _then(
    Query$Collections$collections$items(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      children: children == _undefined
          ? _instance.children
          : (children as List<Query$Collections$collections$items$children>?),
      productVariants: productVariants == _undefined || productVariants == null
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
          : (featuredAsset
                as Query$Collections$collections$items$featuredAsset?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes children(
    Iterable<Query$Collections$collections$items$children>? Function(
      Iterable<
        CopyWith$Query$Collections$collections$items$children<
          Query$Collections$collections$items$children
        >
      >?,
    )
    _fn,
  ) => call(
    children: _fn(
      _instance.children?.map(
        (e) =>
            CopyWith$Query$Collections$collections$items$children(e, (i) => i),
      ),
    )?.toList(),
  );

  CopyWith$Query$Collections$collections$items$productVariants<TRes>
  get productVariants {
    final local$productVariants = _instance.productVariants;
    return CopyWith$Query$Collections$collections$items$productVariants(
      local$productVariants,
      (e) => call(productVariants: e),
    );
  }

  CopyWith$Query$Collections$collections$items$parent<TRes> get parent {
    final local$parent = _instance.parent;
    return local$parent == null
        ? CopyWith$Query$Collections$collections$items$parent.stub(
            _then(_instance),
          )
        : CopyWith$Query$Collections$collections$items$parent(
            local$parent,
            (e) => call(parent: e),
          );
  }

  CopyWith$Query$Collections$collections$items$featuredAsset<TRes>
  get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Query$Collections$collections$items$featuredAsset.stub(
            _then(_instance),
          )
        : CopyWith$Query$Collections$collections$items$featuredAsset(
            local$featuredAsset,
            (e) => call(featuredAsset: e),
          );
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
    Query$Collections$collections$items$featuredAsset? featuredAsset,
    String? $__typename,
  }) => _res;

  children(_fn) => _res;

  CopyWith$Query$Collections$collections$items$productVariants<TRes>
  get productVariants =>
      CopyWith$Query$Collections$collections$items$productVariants.stub(_res);

  CopyWith$Query$Collections$collections$items$parent<TRes> get parent =>
      CopyWith$Query$Collections$collections$items$parent.stub(_res);

  CopyWith$Query$Collections$collections$items$featuredAsset<TRes>
  get featuredAsset =>
      CopyWith$Query$Collections$collections$items$featuredAsset.stub(_res);
}

class Query$Collections$collections$items$children {
  Query$Collections$collections$items$children({
    required this.id,
    required this.slug,
    required this.name,
    this.$__typename = 'Collection',
  });

  factory Query$Collections$collections$items$children.fromJson(
    Map<String, dynamic> json,
  ) {
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
    return Object.hashAll([l$id, l$slug, l$name, l$$__typename]);
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
    Query$Collections$collections$items$children
  >
  get copyWith =>
      CopyWith$Query$Collections$collections$items$children(this, (i) => i);
}

abstract class CopyWith$Query$Collections$collections$items$children<TRes> {
  factory CopyWith$Query$Collections$collections$items$children(
    Query$Collections$collections$items$children instance,
    TRes Function(Query$Collections$collections$items$children) then,
  ) = _CopyWithImpl$Query$Collections$collections$items$children;

  factory CopyWith$Query$Collections$collections$items$children.stub(TRes res) =
      _CopyWithStubImpl$Query$Collections$collections$items$children;

  TRes call({String? id, String? slug, String? name, String? $__typename});
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
  }) => _then(
    Query$Collections$collections$items$children(
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
    ),
  );
}

class _CopyWithStubImpl$Query$Collections$collections$items$children<TRes>
    implements CopyWith$Query$Collections$collections$items$children<TRes> {
  _CopyWithStubImpl$Query$Collections$collections$items$children(this._res);

  TRes _res;

  call({String? id, String? slug, String? name, String? $__typename}) => _res;
}

class Query$Collections$collections$items$productVariants {
  Query$Collections$collections$items$productVariants({
    required this.totalItems,
    this.$__typename = 'ProductVariantList',
  });

  factory Query$Collections$collections$items$productVariants.fromJson(
    Map<String, dynamic> json,
  ) {
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
    return Object.hashAll([l$totalItems, l$$__typename]);
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
    Query$Collections$collections$items$productVariants
  >
  get copyWith => CopyWith$Query$Collections$collections$items$productVariants(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$Collections$collections$items$productVariants<
  TRes
> {
  factory CopyWith$Query$Collections$collections$items$productVariants(
    Query$Collections$collections$items$productVariants instance,
    TRes Function(Query$Collections$collections$items$productVariants) then,
  ) = _CopyWithImpl$Query$Collections$collections$items$productVariants;

  factory CopyWith$Query$Collections$collections$items$productVariants.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$Collections$collections$items$productVariants;

  TRes call({int? totalItems, String? $__typename});
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
  }) => _then(
    Query$Collections$collections$items$productVariants(
      totalItems: totalItems == _undefined || totalItems == null
          ? _instance.totalItems
          : (totalItems as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Collections$collections$items$productVariants<
  TRes
>
    implements
        CopyWith$Query$Collections$collections$items$productVariants<TRes> {
  _CopyWithStubImpl$Query$Collections$collections$items$productVariants(
    this._res,
  );

  TRes _res;

  call({int? totalItems, String? $__typename}) => _res;
}

class Query$Collections$collections$items$parent {
  Query$Collections$collections$items$parent({
    required this.name,
    this.$__typename = 'Collection',
  });

  factory Query$Collections$collections$items$parent.fromJson(
    Map<String, dynamic> json,
  ) {
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
    return Object.hashAll([l$name, l$$__typename]);
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
    Query$Collections$collections$items$parent
  >
  get copyWith =>
      CopyWith$Query$Collections$collections$items$parent(this, (i) => i);
}

abstract class CopyWith$Query$Collections$collections$items$parent<TRes> {
  factory CopyWith$Query$Collections$collections$items$parent(
    Query$Collections$collections$items$parent instance,
    TRes Function(Query$Collections$collections$items$parent) then,
  ) = _CopyWithImpl$Query$Collections$collections$items$parent;

  factory CopyWith$Query$Collections$collections$items$parent.stub(TRes res) =
      _CopyWithStubImpl$Query$Collections$collections$items$parent;

  TRes call({String? name, String? $__typename});
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

  TRes call({Object? name = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$Collections$collections$items$parent(
          name: name == _undefined || name == null
              ? _instance.name
              : (name as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$Collections$collections$items$parent<TRes>
    implements CopyWith$Query$Collections$collections$items$parent<TRes> {
  _CopyWithStubImpl$Query$Collections$collections$items$parent(this._res);

  TRes _res;

  call({String? name, String? $__typename}) => _res;
}

class Query$Collections$collections$items$featuredAsset {
  Query$Collections$collections$items$featuredAsset({
    required this.id,
    required this.preview,
    this.$__typename = 'Asset',
  });

  factory Query$Collections$collections$items$featuredAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$preview = json['preview'];
    final l$$__typename = json['__typename'];
    return Query$Collections$collections$items$featuredAsset(
      id: (l$id as String),
      preview: (l$preview as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String preview;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$preview = preview;
    _resultData['preview'] = l$preview;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$preview = preview;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$preview, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Collections$collections$items$featuredAsset ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Query$Collections$collections$items$featuredAsset
    on Query$Collections$collections$items$featuredAsset {
  CopyWith$Query$Collections$collections$items$featuredAsset<
    Query$Collections$collections$items$featuredAsset
  >
  get copyWith => CopyWith$Query$Collections$collections$items$featuredAsset(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$Collections$collections$items$featuredAsset<
  TRes
> {
  factory CopyWith$Query$Collections$collections$items$featuredAsset(
    Query$Collections$collections$items$featuredAsset instance,
    TRes Function(Query$Collections$collections$items$featuredAsset) then,
  ) = _CopyWithImpl$Query$Collections$collections$items$featuredAsset;

  factory CopyWith$Query$Collections$collections$items$featuredAsset.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$Collections$collections$items$featuredAsset;

  TRes call({String? id, String? preview, String? $__typename});
}

class _CopyWithImpl$Query$Collections$collections$items$featuredAsset<TRes>
    implements
        CopyWith$Query$Collections$collections$items$featuredAsset<TRes> {
  _CopyWithImpl$Query$Collections$collections$items$featuredAsset(
    this._instance,
    this._then,
  );

  final Query$Collections$collections$items$featuredAsset _instance;

  final TRes Function(Query$Collections$collections$items$featuredAsset) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? preview = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Collections$collections$items$featuredAsset(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      preview: preview == _undefined || preview == null
          ? _instance.preview
          : (preview as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Collections$collections$items$featuredAsset<TRes>
    implements
        CopyWith$Query$Collections$collections$items$featuredAsset<TRes> {
  _CopyWithStubImpl$Query$Collections$collections$items$featuredAsset(
    this._res,
  );

  TRes _res;

  call({String? id, String? preview, String? $__typename}) => _res;
}

class Variables$Query$Products {
  factory Variables$Query$Products({String? slug, String? id}) =>
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
      CopyWith$Variables$Query$Products(this, (i) => i);

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

  TRes call({String? slug, String? id});
}

class _CopyWithImpl$Variables$Query$Products<TRes>
    implements CopyWith$Variables$Query$Products<TRes> {
  _CopyWithImpl$Variables$Query$Products(this._instance, this._then);

  final Variables$Query$Products _instance;

  final TRes Function(Variables$Query$Products) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? slug = _undefined, Object? id = _undefined}) => _then(
    Variables$Query$Products._({
      ..._instance._$data,
      if (slug != _undefined) 'slug': (slug as String?),
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$Products<TRes>
    implements CopyWith$Variables$Query$Products<TRes> {
  _CopyWithStubImpl$Variables$Query$Products(this._res);

  TRes _res;

  call({String? slug, String? id}) => _res;
}

class Query$Products {
  Query$Products({this.collection, this.$__typename = 'Query'});

  factory Query$Products.fromJson(Map<String, dynamic> json) {
    final l$collection = json['collection'];
    final l$$__typename = json['__typename'];
    return Query$Products(
      collection: l$collection == null
          ? null
          : Query$Products$collection.fromJson(
              (l$collection as Map<String, dynamic>),
            ),
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
    return Object.hashAll([l$collection, l$$__typename]);
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
      CopyWith$Query$Products(this, (i) => i);
}

abstract class CopyWith$Query$Products<TRes> {
  factory CopyWith$Query$Products(
    Query$Products instance,
    TRes Function(Query$Products) then,
  ) = _CopyWithImpl$Query$Products;

  factory CopyWith$Query$Products.stub(TRes res) =
      _CopyWithStubImpl$Query$Products;

  TRes call({Query$Products$collection? collection, String? $__typename});
  CopyWith$Query$Products$collection<TRes> get collection;
}

class _CopyWithImpl$Query$Products<TRes>
    implements CopyWith$Query$Products<TRes> {
  _CopyWithImpl$Query$Products(this._instance, this._then);

  final Query$Products _instance;

  final TRes Function(Query$Products) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? collection = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Products(
      collection: collection == _undefined
          ? _instance.collection
          : (collection as Query$Products$collection?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$Products$collection<TRes> get collection {
    final local$collection = _instance.collection;
    return local$collection == null
        ? CopyWith$Query$Products$collection.stub(_then(_instance))
        : CopyWith$Query$Products$collection(
            local$collection,
            (e) => call(collection: e),
          );
  }
}

class _CopyWithStubImpl$Query$Products<TRes>
    implements CopyWith$Query$Products<TRes> {
  _CopyWithStubImpl$Query$Products(this._res);

  TRes _res;

  call({Query$Products$collection? collection, String? $__typename}) => _res;

  CopyWith$Query$Products$collection<TRes> get collection =>
      CopyWith$Query$Products$collection.stub(_res);
}

const documentNodeQueryProducts = DocumentNode(
  definitions: [
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
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
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
            selectionSet: SelectionSetNode(
              selections: [
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
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'items'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'product'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
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
                                    selectionSet: SelectionSetNode(
                                      selections: [
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
                                      ],
                                    ),
                                  ),
                                  FieldNode(
                                    name: NameNode(value: '__typename'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                ],
                              ),
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
                              name: NameNode(value: '__typename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionAsset,
  ],
);
Query$Products _parserFn$Query$Products(Map<String, dynamic> data) =>
    Query$Products.fromJson(data);
typedef OnQueryComplete$Query$Products =
    FutureOr<void> Function(Map<String, dynamic>?, Query$Products?);

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
  }) : onCompleteWithParsed = onComplete,
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
  Future<graphql.QueryResult<Query$Products>> query$Products([
    Options$Query$Products? options,
  ]) async => await this.query(options ?? Options$Query$Products());

  graphql.ObservableQuery<Query$Products> watchQuery$Products([
    WatchOptions$Query$Products? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$Products());

  void writeQuery$Products({
    required Query$Products data,
    Variables$Query$Products? variables,
    bool broadcast = true,
  }) => this.writeQuery(
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

graphql_flutter.QueryHookResult<Query$Products> useQuery$Products([
  Options$Query$Products? options,
]) => graphql_flutter.useQuery(options ?? Options$Query$Products());
graphql.ObservableQuery<Query$Products> useWatchQuery$Products([
  WatchOptions$Query$Products? options,
]) => graphql_flutter.useWatchQuery(options ?? WatchOptions$Query$Products());

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
        (l$productVariants as Map<String, dynamic>),
      ),
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
    return Object.hashAll([l$id, l$name, l$productVariants, l$$__typename]);
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
      CopyWith$Query$Products$collection(this, (i) => i);
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
  _CopyWithImpl$Query$Products$collection(this._instance, this._then);

  final Query$Products$collection _instance;

  final TRes Function(Query$Products$collection) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? productVariants = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Products$collection(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      productVariants: productVariants == _undefined || productVariants == null
          ? _instance.productVariants
          : (productVariants as Query$Products$collection$productVariants),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$Products$collection$productVariants<TRes> get productVariants {
    final local$productVariants = _instance.productVariants;
    return CopyWith$Query$Products$collection$productVariants(
      local$productVariants,
      (e) => call(productVariants: e),
    );
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
  }) => _res;

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
    Map<String, dynamic> json,
  ) {
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection$productVariants(
      items: (l$items as List<dynamic>)
          .map(
            (e) => Query$Products$collection$productVariants$items.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
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
    Query$Products$collection$productVariants
  >
  get copyWith =>
      CopyWith$Query$Products$collection$productVariants(this, (i) => i);
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
          Query$Products$collection$productVariants$items
        >
      >,
    )
    _fn,
  );
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

  TRes call({Object? items = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$Products$collection$productVariants(
          items: items == _undefined || items == null
              ? _instance.items
              : (items
                    as List<Query$Products$collection$productVariants$items>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes items(
    Iterable<Query$Products$collection$productVariants$items> Function(
      Iterable<
        CopyWith$Query$Products$collection$productVariants$items<
          Query$Products$collection$productVariants$items
        >
      >,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) => CopyWith$Query$Products$collection$productVariants$items(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$Products$collection$productVariants<TRes>
    implements CopyWith$Query$Products$collection$productVariants<TRes> {
  _CopyWithStubImpl$Query$Products$collection$productVariants(this._res);

  TRes _res;

  call({
    List<Query$Products$collection$productVariants$items>? items,
    String? $__typename,
  }) => _res;

  items(_fn) => _res;
}

class Query$Products$collection$productVariants$items {
  Query$Products$collection$productVariants$items({
    required this.product,
    required this.priceWithTax,
    required this.stockLevel,
    required this.productId,
    required this.name,
    this.$__typename = 'ProductVariant',
  });

  factory Query$Products$collection$productVariants$items.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$product = json['product'];
    final l$priceWithTax = json['priceWithTax'];
    final l$stockLevel = json['stockLevel'];
    final l$productId = json['productId'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection$productVariants$items(
      product: Query$Products$collection$productVariants$items$product.fromJson(
        (l$product as Map<String, dynamic>),
      ),
      priceWithTax: (l$priceWithTax as num).toDouble(),
      stockLevel: (l$stockLevel as String),
      productId: (l$productId as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$Products$collection$productVariants$items$product product;

  final double priceWithTax;

  final String stockLevel;

  final String productId;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$product = product;
    _resultData['product'] = l$product.toJson();
    final l$priceWithTax = priceWithTax;
    _resultData['priceWithTax'] = l$priceWithTax;
    final l$stockLevel = stockLevel;
    _resultData['stockLevel'] = l$stockLevel;
    final l$productId = productId;
    _resultData['productId'] = l$productId;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$product = product;
    final l$priceWithTax = priceWithTax;
    final l$stockLevel = stockLevel;
    final l$productId = productId;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$product,
      l$priceWithTax,
      l$stockLevel,
      l$productId,
      l$name,
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
    final l$product = product;
    final lOther$product = other.product;
    if (l$product != lOther$product) {
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
    Query$Products$collection$productVariants$items
  >
  get copyWith =>
      CopyWith$Query$Products$collection$productVariants$items(this, (i) => i);
}

abstract class CopyWith$Query$Products$collection$productVariants$items<TRes> {
  factory CopyWith$Query$Products$collection$productVariants$items(
    Query$Products$collection$productVariants$items instance,
    TRes Function(Query$Products$collection$productVariants$items) then,
  ) = _CopyWithImpl$Query$Products$collection$productVariants$items;

  factory CopyWith$Query$Products$collection$productVariants$items.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$Products$collection$productVariants$items;

  TRes call({
    Query$Products$collection$productVariants$items$product? product,
    double? priceWithTax,
    String? stockLevel,
    String? productId,
    String? name,
    String? $__typename,
  });
  CopyWith$Query$Products$collection$productVariants$items$product<TRes>
  get product;
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
    Object? product = _undefined,
    Object? priceWithTax = _undefined,
    Object? stockLevel = _undefined,
    Object? productId = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Products$collection$productVariants$items(
      product: product == _undefined || product == null
          ? _instance.product
          : (product
                as Query$Products$collection$productVariants$items$product),
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
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$Products$collection$productVariants$items$product<TRes>
  get product {
    final local$product = _instance.product;
    return CopyWith$Query$Products$collection$productVariants$items$product(
      local$product,
      (e) => call(product: e),
    );
  }
}

class _CopyWithStubImpl$Query$Products$collection$productVariants$items<TRes>
    implements CopyWith$Query$Products$collection$productVariants$items<TRes> {
  _CopyWithStubImpl$Query$Products$collection$productVariants$items(this._res);

  TRes _res;

  call({
    Query$Products$collection$productVariants$items$product? product,
    double? priceWithTax,
    String? stockLevel,
    String? productId,
    String? name,
    String? $__typename,
  }) => _res;

  CopyWith$Query$Products$collection$productVariants$items$product<TRes>
  get product =>
      CopyWith$Query$Products$collection$productVariants$items$product.stub(
        _res,
      );
}

class Query$Products$collection$productVariants$items$product {
  Query$Products$collection$productVariants$items$product({
    required this.id,
    required this.name,
    required this.enabled,
    this.featuredAsset,
    this.$__typename = 'Product',
  });

  factory Query$Products$collection$productVariants$items$product.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$enabled = json['enabled'];
    final l$featuredAsset = json['featuredAsset'];
    final l$$__typename = json['__typename'];
    return Query$Products$collection$productVariants$items$product(
      id: (l$id as String),
      name: (l$name as String),
      enabled: (l$enabled as bool),
      featuredAsset: l$featuredAsset == null
          ? null
          : Fragment$Asset.fromJson((l$featuredAsset as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final bool enabled;

  final Fragment$Asset? featuredAsset;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
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
    final l$enabled = enabled;
    final l$featuredAsset = featuredAsset;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$enabled,
      l$featuredAsset,
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
    Query$Products$collection$productVariants$items$product
  >
  get copyWith =>
      CopyWith$Query$Products$collection$productVariants$items$product(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$Products$collection$productVariants$items$product<
  TRes
> {
  factory CopyWith$Query$Products$collection$productVariants$items$product(
    Query$Products$collection$productVariants$items$product instance,
    TRes Function(Query$Products$collection$productVariants$items$product) then,
  ) = _CopyWithImpl$Query$Products$collection$productVariants$items$product;

  factory CopyWith$Query$Products$collection$productVariants$items$product.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$Products$collection$productVariants$items$product;

  TRes call({
    String? id,
    String? name,
    bool? enabled,
    Fragment$Asset? featuredAsset,
    String? $__typename,
  });
  CopyWith$Fragment$Asset<TRes> get featuredAsset;
}

class _CopyWithImpl$Query$Products$collection$productVariants$items$product<
  TRes
>
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
    Object? enabled = _undefined,
    Object? featuredAsset = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Products$collection$productVariants$items$product(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      enabled: enabled == _undefined || enabled == null
          ? _instance.enabled
          : (enabled as bool),
      featuredAsset: featuredAsset == _undefined
          ? _instance.featuredAsset
          : (featuredAsset as Fragment$Asset?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$Asset<TRes> get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Fragment$Asset.stub(_then(_instance))
        : CopyWith$Fragment$Asset(
            local$featuredAsset,
            (e) => call(featuredAsset: e),
          );
  }
}

class _CopyWithStubImpl$Query$Products$collection$productVariants$items$product<
  TRes
>
    implements
        CopyWith$Query$Products$collection$productVariants$items$product<TRes> {
  _CopyWithStubImpl$Query$Products$collection$productVariants$items$product(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    bool? enabled,
    Fragment$Asset? featuredAsset,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$Asset<TRes> get featuredAsset =>
      CopyWith$Fragment$Asset.stub(_res);
}
