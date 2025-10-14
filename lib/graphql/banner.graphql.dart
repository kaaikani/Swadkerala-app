import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Query$customBanners {
  Query$customBanners({
    required this.customBanners,
    this.$__typename = 'Query',
  });

  factory Query$customBanners.fromJson(Map<String, dynamic> json) {
    final l$customBanners = json['customBanners'];
    final l$$__typename = json['__typename'];
    return Query$customBanners(
      customBanners: (l$customBanners as List<dynamic>)
          .map(
            (e) => Query$customBanners$customBanners.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$customBanners$customBanners> customBanners;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$customBanners = customBanners;
    _resultData['customBanners'] = l$customBanners
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$customBanners = customBanners;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$customBanners.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$customBanners || runtimeType != other.runtimeType) {
      return false;
    }
    final l$customBanners = customBanners;
    final lOther$customBanners = other.customBanners;
    if (l$customBanners.length != lOther$customBanners.length) {
      return false;
    }
    for (int i = 0; i < l$customBanners.length; i++) {
      final l$customBanners$entry = l$customBanners[i];
      final lOther$customBanners$entry = lOther$customBanners[i];
      if (l$customBanners$entry != lOther$customBanners$entry) {
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

extension UtilityExtension$Query$customBanners on Query$customBanners {
  CopyWith$Query$customBanners<Query$customBanners> get copyWith =>
      CopyWith$Query$customBanners(this, (i) => i);
}

abstract class CopyWith$Query$customBanners<TRes> {
  factory CopyWith$Query$customBanners(
    Query$customBanners instance,
    TRes Function(Query$customBanners) then,
  ) = _CopyWithImpl$Query$customBanners;

  factory CopyWith$Query$customBanners.stub(TRes res) =
      _CopyWithStubImpl$Query$customBanners;

  TRes call({
    List<Query$customBanners$customBanners>? customBanners,
    String? $__typename,
  });
  TRes customBanners(
    Iterable<Query$customBanners$customBanners> Function(
      Iterable<
        CopyWith$Query$customBanners$customBanners<
          Query$customBanners$customBanners
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$customBanners<TRes>
    implements CopyWith$Query$customBanners<TRes> {
  _CopyWithImpl$Query$customBanners(this._instance, this._then);

  final Query$customBanners _instance;

  final TRes Function(Query$customBanners) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? customBanners = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$customBanners(
      customBanners: customBanners == _undefined || customBanners == null
          ? _instance.customBanners
          : (customBanners as List<Query$customBanners$customBanners>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes customBanners(
    Iterable<Query$customBanners$customBanners> Function(
      Iterable<
        CopyWith$Query$customBanners$customBanners<
          Query$customBanners$customBanners
        >
      >,
    )
    _fn,
  ) => call(
    customBanners: _fn(
      _instance.customBanners.map(
        (e) => CopyWith$Query$customBanners$customBanners(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$customBanners<TRes>
    implements CopyWith$Query$customBanners<TRes> {
  _CopyWithStubImpl$Query$customBanners(this._res);

  TRes _res;

  call({
    List<Query$customBanners$customBanners>? customBanners,
    String? $__typename,
  }) => _res;

  customBanners(_fn) => _res;
}

const documentNodeQuerycustomBanners = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'customBanners'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'customBanners'),
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
                  name: NameNode(value: 'assets'),
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
                        name: NameNode(value: 'source'),
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
                  name: NameNode(value: 'channels'),
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
Query$customBanners _parserFn$Query$customBanners(Map<String, dynamic> data) =>
    Query$customBanners.fromJson(data);
typedef OnQueryComplete$Query$customBanners =
    FutureOr<void> Function(Map<String, dynamic>?, Query$customBanners?);

class Options$Query$customBanners
    extends graphql.QueryOptions<Query$customBanners> {
  Options$Query$customBanners({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$customBanners? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$customBanners? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
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
                 data == null ? null : _parserFn$Query$customBanners(data),
               ),
         onError: onError,
         document: documentNodeQuerycustomBanners,
         parserFn: _parserFn$Query$customBanners,
       );

  final OnQueryComplete$Query$customBanners? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$customBanners
    extends graphql.WatchQueryOptions<Query$customBanners> {
  WatchOptions$Query$customBanners({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$customBanners? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQuerycustomBanners,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$customBanners,
       );
}

class FetchMoreOptions$Query$customBanners extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$customBanners({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQuerycustomBanners,
       );
}

extension ClientExtension$Query$customBanners on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$customBanners>> query$customBanners([
    Options$Query$customBanners? options,
  ]) async => await this.query(options ?? Options$Query$customBanners());

  graphql.ObservableQuery<Query$customBanners> watchQuery$customBanners([
    WatchOptions$Query$customBanners? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$customBanners());

  void writeQuery$customBanners({
    required Query$customBanners data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerycustomBanners),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$customBanners? readQuery$customBanners({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQuerycustomBanners),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$customBanners.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$customBanners> useQuery$customBanners([
  Options$Query$customBanners? options,
]) => graphql_flutter.useQuery(options ?? Options$Query$customBanners());
graphql.ObservableQuery<Query$customBanners> useWatchQuery$customBanners([
  WatchOptions$Query$customBanners? options,
]) => graphql_flutter.useWatchQuery(
  options ?? WatchOptions$Query$customBanners(),
);

class Query$customBanners$Widget
    extends graphql_flutter.Query<Query$customBanners> {
  Query$customBanners$Widget({
    widgets.Key? key,
    Options$Query$customBanners? options,
    required graphql_flutter.QueryBuilder<Query$customBanners> builder,
  }) : super(
         key: key,
         options: options ?? Options$Query$customBanners(),
         builder: builder,
       );
}

class Query$customBanners$customBanners {
  Query$customBanners$customBanners({
    required this.id,
    required this.assets,
    required this.channels,
    this.$__typename = 'CustomBanner',
  });

  factory Query$customBanners$customBanners.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$assets = json['assets'];
    final l$channels = json['channels'];
    final l$$__typename = json['__typename'];
    return Query$customBanners$customBanners(
      id: (l$id as String),
      assets: (l$assets as List<dynamic>)
          .map(
            (e) => Query$customBanners$customBanners$assets.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      channels: (l$channels as List<dynamic>)
          .map(
            (e) => Query$customBanners$customBanners$channels.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Query$customBanners$customBanners$assets> assets;

  final List<Query$customBanners$customBanners$channels> channels;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$assets = assets;
    _resultData['assets'] = l$assets.map((e) => e.toJson()).toList();
    final l$channels = channels;
    _resultData['channels'] = l$channels.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$assets = assets;
    final l$channels = channels;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$assets.map((v) => v)),
      Object.hashAll(l$channels.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$customBanners$customBanners ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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
    final l$channels = channels;
    final lOther$channels = other.channels;
    if (l$channels.length != lOther$channels.length) {
      return false;
    }
    for (int i = 0; i < l$channels.length; i++) {
      final l$channels$entry = l$channels[i];
      final lOther$channels$entry = lOther$channels[i];
      if (l$channels$entry != lOther$channels$entry) {
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

extension UtilityExtension$Query$customBanners$customBanners
    on Query$customBanners$customBanners {
  CopyWith$Query$customBanners$customBanners<Query$customBanners$customBanners>
  get copyWith => CopyWith$Query$customBanners$customBanners(this, (i) => i);
}

abstract class CopyWith$Query$customBanners$customBanners<TRes> {
  factory CopyWith$Query$customBanners$customBanners(
    Query$customBanners$customBanners instance,
    TRes Function(Query$customBanners$customBanners) then,
  ) = _CopyWithImpl$Query$customBanners$customBanners;

  factory CopyWith$Query$customBanners$customBanners.stub(TRes res) =
      _CopyWithStubImpl$Query$customBanners$customBanners;

  TRes call({
    String? id,
    List<Query$customBanners$customBanners$assets>? assets,
    List<Query$customBanners$customBanners$channels>? channels,
    String? $__typename,
  });
  TRes assets(
    Iterable<Query$customBanners$customBanners$assets> Function(
      Iterable<
        CopyWith$Query$customBanners$customBanners$assets<
          Query$customBanners$customBanners$assets
        >
      >,
    )
    _fn,
  );
  TRes channels(
    Iterable<Query$customBanners$customBanners$channels> Function(
      Iterable<
        CopyWith$Query$customBanners$customBanners$channels<
          Query$customBanners$customBanners$channels
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$customBanners$customBanners<TRes>
    implements CopyWith$Query$customBanners$customBanners<TRes> {
  _CopyWithImpl$Query$customBanners$customBanners(this._instance, this._then);

  final Query$customBanners$customBanners _instance;

  final TRes Function(Query$customBanners$customBanners) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? assets = _undefined,
    Object? channels = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$customBanners$customBanners(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      assets: assets == _undefined || assets == null
          ? _instance.assets
          : (assets as List<Query$customBanners$customBanners$assets>),
      channels: channels == _undefined || channels == null
          ? _instance.channels
          : (channels as List<Query$customBanners$customBanners$channels>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes assets(
    Iterable<Query$customBanners$customBanners$assets> Function(
      Iterable<
        CopyWith$Query$customBanners$customBanners$assets<
          Query$customBanners$customBanners$assets
        >
      >,
    )
    _fn,
  ) => call(
    assets: _fn(
      _instance.assets.map(
        (e) => CopyWith$Query$customBanners$customBanners$assets(e, (i) => i),
      ),
    ).toList(),
  );

  TRes channels(
    Iterable<Query$customBanners$customBanners$channels> Function(
      Iterable<
        CopyWith$Query$customBanners$customBanners$channels<
          Query$customBanners$customBanners$channels
        >
      >,
    )
    _fn,
  ) => call(
    channels: _fn(
      _instance.channels.map(
        (e) => CopyWith$Query$customBanners$customBanners$channels(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$customBanners$customBanners<TRes>
    implements CopyWith$Query$customBanners$customBanners<TRes> {
  _CopyWithStubImpl$Query$customBanners$customBanners(this._res);

  TRes _res;

  call({
    String? id,
    List<Query$customBanners$customBanners$assets>? assets,
    List<Query$customBanners$customBanners$channels>? channels,
    String? $__typename,
  }) => _res;

  assets(_fn) => _res;

  channels(_fn) => _res;
}

class Query$customBanners$customBanners$assets {
  Query$customBanners$customBanners$assets({
    required this.id,
    required this.name,
    required this.source,
    this.$__typename = 'Asset',
  });

  factory Query$customBanners$customBanners$assets.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$source = json['source'];
    final l$$__typename = json['__typename'];
    return Query$customBanners$customBanners$assets(
      id: (l$id as String),
      name: (l$name as String),
      source: (l$source as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String source;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$source = source;
    _resultData['source'] = l$source;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$source = source;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$source, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$customBanners$customBanners$assets ||
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
    final l$source = source;
    final lOther$source = other.source;
    if (l$source != lOther$source) {
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

extension UtilityExtension$Query$customBanners$customBanners$assets
    on Query$customBanners$customBanners$assets {
  CopyWith$Query$customBanners$customBanners$assets<
    Query$customBanners$customBanners$assets
  >
  get copyWith =>
      CopyWith$Query$customBanners$customBanners$assets(this, (i) => i);
}

abstract class CopyWith$Query$customBanners$customBanners$assets<TRes> {
  factory CopyWith$Query$customBanners$customBanners$assets(
    Query$customBanners$customBanners$assets instance,
    TRes Function(Query$customBanners$customBanners$assets) then,
  ) = _CopyWithImpl$Query$customBanners$customBanners$assets;

  factory CopyWith$Query$customBanners$customBanners$assets.stub(TRes res) =
      _CopyWithStubImpl$Query$customBanners$customBanners$assets;

  TRes call({String? id, String? name, String? source, String? $__typename});
}

class _CopyWithImpl$Query$customBanners$customBanners$assets<TRes>
    implements CopyWith$Query$customBanners$customBanners$assets<TRes> {
  _CopyWithImpl$Query$customBanners$customBanners$assets(
    this._instance,
    this._then,
  );

  final Query$customBanners$customBanners$assets _instance;

  final TRes Function(Query$customBanners$customBanners$assets) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? source = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$customBanners$customBanners$assets(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      source: source == _undefined || source == null
          ? _instance.source
          : (source as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$customBanners$customBanners$assets<TRes>
    implements CopyWith$Query$customBanners$customBanners$assets<TRes> {
  _CopyWithStubImpl$Query$customBanners$customBanners$assets(this._res);

  TRes _res;

  call({String? id, String? name, String? source, String? $__typename}) => _res;
}

class Query$customBanners$customBanners$channels {
  Query$customBanners$customBanners$channels({
    required this.id,
    required this.code,
    this.$__typename = 'Channel',
  });

  factory Query$customBanners$customBanners$channels.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$$__typename = json['__typename'];
    return Query$customBanners$customBanners$channels(
      id: (l$id as String),
      code: (l$code as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$code, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$customBanners$customBanners$channels ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$customBanners$customBanners$channels
    on Query$customBanners$customBanners$channels {
  CopyWith$Query$customBanners$customBanners$channels<
    Query$customBanners$customBanners$channels
  >
  get copyWith =>
      CopyWith$Query$customBanners$customBanners$channels(this, (i) => i);
}

abstract class CopyWith$Query$customBanners$customBanners$channels<TRes> {
  factory CopyWith$Query$customBanners$customBanners$channels(
    Query$customBanners$customBanners$channels instance,
    TRes Function(Query$customBanners$customBanners$channels) then,
  ) = _CopyWithImpl$Query$customBanners$customBanners$channels;

  factory CopyWith$Query$customBanners$customBanners$channels.stub(TRes res) =
      _CopyWithStubImpl$Query$customBanners$customBanners$channels;

  TRes call({String? id, String? code, String? $__typename});
}

class _CopyWithImpl$Query$customBanners$customBanners$channels<TRes>
    implements CopyWith$Query$customBanners$customBanners$channels<TRes> {
  _CopyWithImpl$Query$customBanners$customBanners$channels(
    this._instance,
    this._then,
  );

  final Query$customBanners$customBanners$channels _instance;

  final TRes Function(Query$customBanners$customBanners$channels) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$customBanners$customBanners$channels(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$customBanners$customBanners$channels<TRes>
    implements CopyWith$Query$customBanners$customBanners$channels<TRes> {
  _CopyWithStubImpl$Query$customBanners$customBanners$channels(this._res);

  TRes _res;

  call({String? id, String? code, String? $__typename}) => _res;
}

class Variables$Query$Search {
  factory Variables$Query$Search({required Input$SearchInput input}) =>
      Variables$Query$Search._({r'input': input});

  Variables$Query$Search._(this._$data);

  factory Variables$Query$Search.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$SearchInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Query$Search._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$SearchInput get input => (_$data['input'] as Input$SearchInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Query$Search<Variables$Query$Search> get copyWith =>
      CopyWith$Variables$Query$Search(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$Search || runtimeType != other.runtimeType) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$input = input;
    return Object.hashAll([l$input]);
  }
}

abstract class CopyWith$Variables$Query$Search<TRes> {
  factory CopyWith$Variables$Query$Search(
    Variables$Query$Search instance,
    TRes Function(Variables$Query$Search) then,
  ) = _CopyWithImpl$Variables$Query$Search;

  factory CopyWith$Variables$Query$Search.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Search;

  TRes call({Input$SearchInput? input});
}

class _CopyWithImpl$Variables$Query$Search<TRes>
    implements CopyWith$Variables$Query$Search<TRes> {
  _CopyWithImpl$Variables$Query$Search(this._instance, this._then);

  final Variables$Query$Search _instance;

  final TRes Function(Variables$Query$Search) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Query$Search._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$SearchInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$Search<TRes>
    implements CopyWith$Variables$Query$Search<TRes> {
  _CopyWithStubImpl$Variables$Query$Search(this._res);

  TRes _res;

  call({Input$SearchInput? input}) => _res;
}

class Query$Search {
  Query$Search({required this.search, this.$__typename = 'Query'});

  factory Query$Search.fromJson(Map<String, dynamic> json) {
    final l$search = json['search'];
    final l$$__typename = json['__typename'];
    return Query$Search(
      search: Query$Search$search.fromJson((l$search as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$Search$search search;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$search = search;
    _resultData['search'] = l$search.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$search = search;
    final l$$__typename = $__typename;
    return Object.hashAll([l$search, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Search || runtimeType != other.runtimeType) {
      return false;
    }
    final l$search = search;
    final lOther$search = other.search;
    if (l$search != lOther$search) {
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

extension UtilityExtension$Query$Search on Query$Search {
  CopyWith$Query$Search<Query$Search> get copyWith =>
      CopyWith$Query$Search(this, (i) => i);
}

abstract class CopyWith$Query$Search<TRes> {
  factory CopyWith$Query$Search(
    Query$Search instance,
    TRes Function(Query$Search) then,
  ) = _CopyWithImpl$Query$Search;

  factory CopyWith$Query$Search.stub(TRes res) = _CopyWithStubImpl$Query$Search;

  TRes call({Query$Search$search? search, String? $__typename});
  CopyWith$Query$Search$search<TRes> get search;
}

class _CopyWithImpl$Query$Search<TRes> implements CopyWith$Query$Search<TRes> {
  _CopyWithImpl$Query$Search(this._instance, this._then);

  final Query$Search _instance;

  final TRes Function(Query$Search) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? search = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$Search(
          search: search == _undefined || search == null
              ? _instance.search
              : (search as Query$Search$search),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$Search$search<TRes> get search {
    final local$search = _instance.search;
    return CopyWith$Query$Search$search(local$search, (e) => call(search: e));
  }
}

class _CopyWithStubImpl$Query$Search<TRes>
    implements CopyWith$Query$Search<TRes> {
  _CopyWithStubImpl$Query$Search(this._res);

  TRes _res;

  call({Query$Search$search? search, String? $__typename}) => _res;

  CopyWith$Query$Search$search<TRes> get search =>
      CopyWith$Query$Search$search.stub(_res);
}

const documentNodeQuerySearch = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Search'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'SearchInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'search'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
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
                        name: NameNode(value: 'productVariantId'),
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
                        name: NameNode(value: 'slug'),
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
                        name: NameNode(value: 'productVariantName'),
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
                        name: NameNode(value: 'collectionIds'),
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
                        selectionSet: SelectionSetNode(
                          selections: [
                            InlineFragmentNode(
                              typeCondition: TypeConditionNode(
                                on: NamedTypeNode(
                                  name: NameNode(value: 'PriceRange'),
                                  isNonNull: false,
                                ),
                              ),
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FieldNode(
                                    name: NameNode(value: 'min'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                  FieldNode(
                                    name: NameNode(value: 'max'),
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
                        name: NameNode(value: 'productAsset'),
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
Query$Search _parserFn$Query$Search(Map<String, dynamic> data) =>
    Query$Search.fromJson(data);
typedef OnQueryComplete$Query$Search =
    FutureOr<void> Function(Map<String, dynamic>?, Query$Search?);

class Options$Query$Search extends graphql.QueryOptions<Query$Search> {
  Options$Query$Search({
    String? operationName,
    required Variables$Query$Search variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Search? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$Search? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
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
                 data == null ? null : _parserFn$Query$Search(data),
               ),
         onError: onError,
         document: documentNodeQuerySearch,
         parserFn: _parserFn$Query$Search,
       );

  final OnQueryComplete$Query$Search? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$Search
    extends graphql.WatchQueryOptions<Query$Search> {
  WatchOptions$Query$Search({
    String? operationName,
    required Variables$Query$Search variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Search? typedOptimisticResult,
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
         document: documentNodeQuerySearch,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$Search,
       );
}

class FetchMoreOptions$Query$Search extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Search({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$Search variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQuerySearch,
       );
}

extension ClientExtension$Query$Search on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Search>> query$Search(
    Options$Query$Search options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$Search> watchQuery$Search(
    WatchOptions$Query$Search options,
  ) => this.watchQuery(options);

  void writeQuery$Search({
    required Query$Search data,
    required Variables$Query$Search variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerySearch),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$Search? readQuery$Search({
    required Variables$Query$Search variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQuerySearch),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$Search.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$Search> useQuery$Search(
  Options$Query$Search options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$Search> useWatchQuery$Search(
  WatchOptions$Query$Search options,
) => graphql_flutter.useWatchQuery(options);

class Query$Search$Widget extends graphql_flutter.Query<Query$Search> {
  Query$Search$Widget({
    widgets.Key? key,
    required Options$Query$Search options,
    required graphql_flutter.QueryBuilder<Query$Search> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query$Search$search {
  Query$Search$search({
    required this.items,
    required this.totalItems,
    this.$__typename = 'SearchResponse',
  });

  factory Query$Search$search.fromJson(Map<String, dynamic> json) {
    final l$items = json['items'];
    final l$totalItems = json['totalItems'];
    final l$$__typename = json['__typename'];
    return Query$Search$search(
      items: (l$items as List<dynamic>)
          .map(
            (e) =>
                Query$Search$search$items.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      totalItems: (l$totalItems as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$Search$search$items> items;

  final int totalItems;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
    final l$totalItems = totalItems;
    _resultData['totalItems'] = l$totalItems;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$items = items;
    final l$totalItems = totalItems;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$items.map((v) => v)),
      l$totalItems,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Search$search || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$Search$search on Query$Search$search {
  CopyWith$Query$Search$search<Query$Search$search> get copyWith =>
      CopyWith$Query$Search$search(this, (i) => i);
}

abstract class CopyWith$Query$Search$search<TRes> {
  factory CopyWith$Query$Search$search(
    Query$Search$search instance,
    TRes Function(Query$Search$search) then,
  ) = _CopyWithImpl$Query$Search$search;

  factory CopyWith$Query$Search$search.stub(TRes res) =
      _CopyWithStubImpl$Query$Search$search;

  TRes call({
    List<Query$Search$search$items>? items,
    int? totalItems,
    String? $__typename,
  });
  TRes items(
    Iterable<Query$Search$search$items> Function(
      Iterable<CopyWith$Query$Search$search$items<Query$Search$search$items>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$Search$search<TRes>
    implements CopyWith$Query$Search$search<TRes> {
  _CopyWithImpl$Query$Search$search(this._instance, this._then);

  final Query$Search$search _instance;

  final TRes Function(Query$Search$search) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? totalItems = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Search$search(
      items: items == _undefined || items == null
          ? _instance.items
          : (items as List<Query$Search$search$items>),
      totalItems: totalItems == _undefined || totalItems == null
          ? _instance.totalItems
          : (totalItems as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes items(
    Iterable<Query$Search$search$items> Function(
      Iterable<CopyWith$Query$Search$search$items<Query$Search$search$items>>,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) => CopyWith$Query$Search$search$items(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$Search$search<TRes>
    implements CopyWith$Query$Search$search<TRes> {
  _CopyWithStubImpl$Query$Search$search(this._res);

  TRes _res;

  call({
    List<Query$Search$search$items>? items,
    int? totalItems,
    String? $__typename,
  }) => _res;

  items(_fn) => _res;
}

class Query$Search$search$items {
  Query$Search$search$items({
    required this.productVariantId,
    required this.productId,
    required this.slug,
    required this.productName,
    required this.productVariantName,
    required this.description,
    required this.collectionIds,
    required this.priceWithTax,
    this.productAsset,
    this.$__typename = 'SearchResult',
  });

  factory Query$Search$search$items.fromJson(Map<String, dynamic> json) {
    final l$productVariantId = json['productVariantId'];
    final l$productId = json['productId'];
    final l$slug = json['slug'];
    final l$productName = json['productName'];
    final l$productVariantName = json['productVariantName'];
    final l$description = json['description'];
    final l$collectionIds = json['collectionIds'];
    final l$priceWithTax = json['priceWithTax'];
    final l$productAsset = json['productAsset'];
    final l$$__typename = json['__typename'];
    return Query$Search$search$items(
      productVariantId: (l$productVariantId as String),
      productId: (l$productId as String),
      slug: (l$slug as String),
      productName: (l$productName as String),
      productVariantName: (l$productVariantName as String),
      description: (l$description as String),
      collectionIds: (l$collectionIds as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      priceWithTax: Query$Search$search$items$priceWithTax.fromJson(
        (l$priceWithTax as Map<String, dynamic>),
      ),
      productAsset: l$productAsset == null
          ? null
          : Query$Search$search$items$productAsset.fromJson(
              (l$productAsset as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String productVariantId;

  final String productId;

  final String slug;

  final String productName;

  final String productVariantName;

  final String description;

  final List<String> collectionIds;

  final Query$Search$search$items$priceWithTax priceWithTax;

  final Query$Search$search$items$productAsset? productAsset;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$productVariantId = productVariantId;
    _resultData['productVariantId'] = l$productVariantId;
    final l$productId = productId;
    _resultData['productId'] = l$productId;
    final l$slug = slug;
    _resultData['slug'] = l$slug;
    final l$productName = productName;
    _resultData['productName'] = l$productName;
    final l$productVariantName = productVariantName;
    _resultData['productVariantName'] = l$productVariantName;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$collectionIds = collectionIds;
    _resultData['collectionIds'] = l$collectionIds.map((e) => e).toList();
    final l$priceWithTax = priceWithTax;
    _resultData['priceWithTax'] = l$priceWithTax.toJson();
    final l$productAsset = productAsset;
    _resultData['productAsset'] = l$productAsset?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$productVariantId = productVariantId;
    final l$productId = productId;
    final l$slug = slug;
    final l$productName = productName;
    final l$productVariantName = productVariantName;
    final l$description = description;
    final l$collectionIds = collectionIds;
    final l$priceWithTax = priceWithTax;
    final l$productAsset = productAsset;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$productVariantId,
      l$productId,
      l$slug,
      l$productName,
      l$productVariantName,
      l$description,
      Object.hashAll(l$collectionIds.map((v) => v)),
      l$priceWithTax,
      l$productAsset,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Search$search$items ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$productVariantId = productVariantId;
    final lOther$productVariantId = other.productVariantId;
    if (l$productVariantId != lOther$productVariantId) {
      return false;
    }
    final l$productId = productId;
    final lOther$productId = other.productId;
    if (l$productId != lOther$productId) {
      return false;
    }
    final l$slug = slug;
    final lOther$slug = other.slug;
    if (l$slug != lOther$slug) {
      return false;
    }
    final l$productName = productName;
    final lOther$productName = other.productName;
    if (l$productName != lOther$productName) {
      return false;
    }
    final l$productVariantName = productVariantName;
    final lOther$productVariantName = other.productVariantName;
    if (l$productVariantName != lOther$productVariantName) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$collectionIds = collectionIds;
    final lOther$collectionIds = other.collectionIds;
    if (l$collectionIds.length != lOther$collectionIds.length) {
      return false;
    }
    for (int i = 0; i < l$collectionIds.length; i++) {
      final l$collectionIds$entry = l$collectionIds[i];
      final lOther$collectionIds$entry = lOther$collectionIds[i];
      if (l$collectionIds$entry != lOther$collectionIds$entry) {
        return false;
      }
    }
    final l$priceWithTax = priceWithTax;
    final lOther$priceWithTax = other.priceWithTax;
    if (l$priceWithTax != lOther$priceWithTax) {
      return false;
    }
    final l$productAsset = productAsset;
    final lOther$productAsset = other.productAsset;
    if (l$productAsset != lOther$productAsset) {
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

extension UtilityExtension$Query$Search$search$items
    on Query$Search$search$items {
  CopyWith$Query$Search$search$items<Query$Search$search$items> get copyWith =>
      CopyWith$Query$Search$search$items(this, (i) => i);
}

abstract class CopyWith$Query$Search$search$items<TRes> {
  factory CopyWith$Query$Search$search$items(
    Query$Search$search$items instance,
    TRes Function(Query$Search$search$items) then,
  ) = _CopyWithImpl$Query$Search$search$items;

  factory CopyWith$Query$Search$search$items.stub(TRes res) =
      _CopyWithStubImpl$Query$Search$search$items;

  TRes call({
    String? productVariantId,
    String? productId,
    String? slug,
    String? productName,
    String? productVariantName,
    String? description,
    List<String>? collectionIds,
    Query$Search$search$items$priceWithTax? priceWithTax,
    Query$Search$search$items$productAsset? productAsset,
    String? $__typename,
  });
  CopyWith$Query$Search$search$items$priceWithTax<TRes> get priceWithTax;
  CopyWith$Query$Search$search$items$productAsset<TRes> get productAsset;
}

class _CopyWithImpl$Query$Search$search$items<TRes>
    implements CopyWith$Query$Search$search$items<TRes> {
  _CopyWithImpl$Query$Search$search$items(this._instance, this._then);

  final Query$Search$search$items _instance;

  final TRes Function(Query$Search$search$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? productVariantId = _undefined,
    Object? productId = _undefined,
    Object? slug = _undefined,
    Object? productName = _undefined,
    Object? productVariantName = _undefined,
    Object? description = _undefined,
    Object? collectionIds = _undefined,
    Object? priceWithTax = _undefined,
    Object? productAsset = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Search$search$items(
      productVariantId:
          productVariantId == _undefined || productVariantId == null
          ? _instance.productVariantId
          : (productVariantId as String),
      productId: productId == _undefined || productId == null
          ? _instance.productId
          : (productId as String),
      slug: slug == _undefined || slug == null
          ? _instance.slug
          : (slug as String),
      productName: productName == _undefined || productName == null
          ? _instance.productName
          : (productName as String),
      productVariantName:
          productVariantName == _undefined || productVariantName == null
          ? _instance.productVariantName
          : (productVariantName as String),
      description: description == _undefined || description == null
          ? _instance.description
          : (description as String),
      collectionIds: collectionIds == _undefined || collectionIds == null
          ? _instance.collectionIds
          : (collectionIds as List<String>),
      priceWithTax: priceWithTax == _undefined || priceWithTax == null
          ? _instance.priceWithTax
          : (priceWithTax as Query$Search$search$items$priceWithTax),
      productAsset: productAsset == _undefined
          ? _instance.productAsset
          : (productAsset as Query$Search$search$items$productAsset?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$Search$search$items$priceWithTax<TRes> get priceWithTax {
    final local$priceWithTax = _instance.priceWithTax;
    return CopyWith$Query$Search$search$items$priceWithTax(
      local$priceWithTax,
      (e) => call(priceWithTax: e),
    );
  }

  CopyWith$Query$Search$search$items$productAsset<TRes> get productAsset {
    final local$productAsset = _instance.productAsset;
    return local$productAsset == null
        ? CopyWith$Query$Search$search$items$productAsset.stub(_then(_instance))
        : CopyWith$Query$Search$search$items$productAsset(
            local$productAsset,
            (e) => call(productAsset: e),
          );
  }
}

class _CopyWithStubImpl$Query$Search$search$items<TRes>
    implements CopyWith$Query$Search$search$items<TRes> {
  _CopyWithStubImpl$Query$Search$search$items(this._res);

  TRes _res;

  call({
    String? productVariantId,
    String? productId,
    String? slug,
    String? productName,
    String? productVariantName,
    String? description,
    List<String>? collectionIds,
    Query$Search$search$items$priceWithTax? priceWithTax,
    Query$Search$search$items$productAsset? productAsset,
    String? $__typename,
  }) => _res;

  CopyWith$Query$Search$search$items$priceWithTax<TRes> get priceWithTax =>
      CopyWith$Query$Search$search$items$priceWithTax.stub(_res);

  CopyWith$Query$Search$search$items$productAsset<TRes> get productAsset =>
      CopyWith$Query$Search$search$items$productAsset.stub(_res);
}

class Query$Search$search$items$priceWithTax {
  Query$Search$search$items$priceWithTax({required this.$__typename});

  factory Query$Search$search$items$priceWithTax.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "PriceRange":
        return Query$Search$search$items$priceWithTax$$PriceRange.fromJson(
          json,
        );

      case "SinglePrice":
        return Query$Search$search$items$priceWithTax$$SinglePrice.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Query$Search$search$items$priceWithTax(
          $__typename: (l$$__typename as String),
        );
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
    if (other is! Query$Search$search$items$priceWithTax ||
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

extension UtilityExtension$Query$Search$search$items$priceWithTax
    on Query$Search$search$items$priceWithTax {
  CopyWith$Query$Search$search$items$priceWithTax<
    Query$Search$search$items$priceWithTax
  >
  get copyWith =>
      CopyWith$Query$Search$search$items$priceWithTax(this, (i) => i);

  _T when<_T>({
    required _T Function(Query$Search$search$items$priceWithTax$$PriceRange)
    priceRange,
    required _T Function(Query$Search$search$items$priceWithTax$$SinglePrice)
    singlePrice,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "PriceRange":
        return priceRange(
          this as Query$Search$search$items$priceWithTax$$PriceRange,
        );

      case "SinglePrice":
        return singlePrice(
          this as Query$Search$search$items$priceWithTax$$SinglePrice,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query$Search$search$items$priceWithTax$$PriceRange)? priceRange,
    _T Function(Query$Search$search$items$priceWithTax$$SinglePrice)?
    singlePrice,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "PriceRange":
        if (priceRange != null) {
          return priceRange(
            this as Query$Search$search$items$priceWithTax$$PriceRange,
          );
        } else {
          return orElse();
        }

      case "SinglePrice":
        if (singlePrice != null) {
          return singlePrice(
            this as Query$Search$search$items$priceWithTax$$SinglePrice,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Query$Search$search$items$priceWithTax<TRes> {
  factory CopyWith$Query$Search$search$items$priceWithTax(
    Query$Search$search$items$priceWithTax instance,
    TRes Function(Query$Search$search$items$priceWithTax) then,
  ) = _CopyWithImpl$Query$Search$search$items$priceWithTax;

  factory CopyWith$Query$Search$search$items$priceWithTax.stub(TRes res) =
      _CopyWithStubImpl$Query$Search$search$items$priceWithTax;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Query$Search$search$items$priceWithTax<TRes>
    implements CopyWith$Query$Search$search$items$priceWithTax<TRes> {
  _CopyWithImpl$Query$Search$search$items$priceWithTax(
    this._instance,
    this._then,
  );

  final Query$Search$search$items$priceWithTax _instance;

  final TRes Function(Query$Search$search$items$priceWithTax) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Query$Search$search$items$priceWithTax(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Search$search$items$priceWithTax<TRes>
    implements CopyWith$Query$Search$search$items$priceWithTax<TRes> {
  _CopyWithStubImpl$Query$Search$search$items$priceWithTax(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Query$Search$search$items$priceWithTax$$PriceRange
    implements Query$Search$search$items$priceWithTax {
  Query$Search$search$items$priceWithTax$$PriceRange({
    required this.min,
    required this.max,
    this.$__typename = 'PriceRange',
  });

  factory Query$Search$search$items$priceWithTax$$PriceRange.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$min = json['min'];
    final l$max = json['max'];
    final l$$__typename = json['__typename'];
    return Query$Search$search$items$priceWithTax$$PriceRange(
      min: (l$min as num).toDouble(),
      max: (l$max as num).toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final double min;

  final double max;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$min = min;
    _resultData['min'] = l$min;
    final l$max = max;
    _resultData['max'] = l$max;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$min = min;
    final l$max = max;
    final l$$__typename = $__typename;
    return Object.hashAll([l$min, l$max, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Search$search$items$priceWithTax$$PriceRange ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$min = min;
    final lOther$min = other.min;
    if (l$min != lOther$min) {
      return false;
    }
    final l$max = max;
    final lOther$max = other.max;
    if (l$max != lOther$max) {
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

extension UtilityExtension$Query$Search$search$items$priceWithTax$$PriceRange
    on Query$Search$search$items$priceWithTax$$PriceRange {
  CopyWith$Query$Search$search$items$priceWithTax$$PriceRange<
    Query$Search$search$items$priceWithTax$$PriceRange
  >
  get copyWith => CopyWith$Query$Search$search$items$priceWithTax$$PriceRange(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$Search$search$items$priceWithTax$$PriceRange<
  TRes
> {
  factory CopyWith$Query$Search$search$items$priceWithTax$$PriceRange(
    Query$Search$search$items$priceWithTax$$PriceRange instance,
    TRes Function(Query$Search$search$items$priceWithTax$$PriceRange) then,
  ) = _CopyWithImpl$Query$Search$search$items$priceWithTax$$PriceRange;

  factory CopyWith$Query$Search$search$items$priceWithTax$$PriceRange.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$Search$search$items$priceWithTax$$PriceRange;

  TRes call({double? min, double? max, String? $__typename});
}

class _CopyWithImpl$Query$Search$search$items$priceWithTax$$PriceRange<TRes>
    implements
        CopyWith$Query$Search$search$items$priceWithTax$$PriceRange<TRes> {
  _CopyWithImpl$Query$Search$search$items$priceWithTax$$PriceRange(
    this._instance,
    this._then,
  );

  final Query$Search$search$items$priceWithTax$$PriceRange _instance;

  final TRes Function(Query$Search$search$items$priceWithTax$$PriceRange) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? min = _undefined,
    Object? max = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Search$search$items$priceWithTax$$PriceRange(
      min: min == _undefined || min == null ? _instance.min : (min as double),
      max: max == _undefined || max == null ? _instance.max : (max as double),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Search$search$items$priceWithTax$$PriceRange<TRes>
    implements
        CopyWith$Query$Search$search$items$priceWithTax$$PriceRange<TRes> {
  _CopyWithStubImpl$Query$Search$search$items$priceWithTax$$PriceRange(
    this._res,
  );

  TRes _res;

  call({double? min, double? max, String? $__typename}) => _res;
}

class Query$Search$search$items$priceWithTax$$SinglePrice
    implements Query$Search$search$items$priceWithTax {
  Query$Search$search$items$priceWithTax$$SinglePrice({
    this.$__typename = 'SinglePrice',
  });

  factory Query$Search$search$items$priceWithTax$$SinglePrice.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    return Query$Search$search$items$priceWithTax$$SinglePrice(
      $__typename: (l$$__typename as String),
    );
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
    if (other is! Query$Search$search$items$priceWithTax$$SinglePrice ||
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

extension UtilityExtension$Query$Search$search$items$priceWithTax$$SinglePrice
    on Query$Search$search$items$priceWithTax$$SinglePrice {
  CopyWith$Query$Search$search$items$priceWithTax$$SinglePrice<
    Query$Search$search$items$priceWithTax$$SinglePrice
  >
  get copyWith => CopyWith$Query$Search$search$items$priceWithTax$$SinglePrice(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$Search$search$items$priceWithTax$$SinglePrice<
  TRes
> {
  factory CopyWith$Query$Search$search$items$priceWithTax$$SinglePrice(
    Query$Search$search$items$priceWithTax$$SinglePrice instance,
    TRes Function(Query$Search$search$items$priceWithTax$$SinglePrice) then,
  ) = _CopyWithImpl$Query$Search$search$items$priceWithTax$$SinglePrice;

  factory CopyWith$Query$Search$search$items$priceWithTax$$SinglePrice.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$Search$search$items$priceWithTax$$SinglePrice;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Query$Search$search$items$priceWithTax$$SinglePrice<TRes>
    implements
        CopyWith$Query$Search$search$items$priceWithTax$$SinglePrice<TRes> {
  _CopyWithImpl$Query$Search$search$items$priceWithTax$$SinglePrice(
    this._instance,
    this._then,
  );

  final Query$Search$search$items$priceWithTax$$SinglePrice _instance;

  final TRes Function(Query$Search$search$items$priceWithTax$$SinglePrice)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Query$Search$search$items$priceWithTax$$SinglePrice(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Search$search$items$priceWithTax$$SinglePrice<
  TRes
>
    implements
        CopyWith$Query$Search$search$items$priceWithTax$$SinglePrice<TRes> {
  _CopyWithStubImpl$Query$Search$search$items$priceWithTax$$SinglePrice(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Query$Search$search$items$productAsset {
  Query$Search$search$items$productAsset({
    required this.id,
    required this.preview,
    this.focalPoint,
    this.$__typename = 'SearchResultAsset',
  });

  factory Query$Search$search$items$productAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$preview = json['preview'];
    final l$focalPoint = json['focalPoint'];
    final l$$__typename = json['__typename'];
    return Query$Search$search$items$productAsset(
      id: (l$id as String),
      preview: (l$preview as String),
      focalPoint: l$focalPoint == null
          ? null
          : Query$Search$search$items$productAsset$focalPoint.fromJson(
              (l$focalPoint as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String preview;

  final Query$Search$search$items$productAsset$focalPoint? focalPoint;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
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
    final l$preview = preview;
    final l$focalPoint = focalPoint;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$preview, l$focalPoint, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Search$search$items$productAsset ||
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

extension UtilityExtension$Query$Search$search$items$productAsset
    on Query$Search$search$items$productAsset {
  CopyWith$Query$Search$search$items$productAsset<
    Query$Search$search$items$productAsset
  >
  get copyWith =>
      CopyWith$Query$Search$search$items$productAsset(this, (i) => i);
}

abstract class CopyWith$Query$Search$search$items$productAsset<TRes> {
  factory CopyWith$Query$Search$search$items$productAsset(
    Query$Search$search$items$productAsset instance,
    TRes Function(Query$Search$search$items$productAsset) then,
  ) = _CopyWithImpl$Query$Search$search$items$productAsset;

  factory CopyWith$Query$Search$search$items$productAsset.stub(TRes res) =
      _CopyWithStubImpl$Query$Search$search$items$productAsset;

  TRes call({
    String? id,
    String? preview,
    Query$Search$search$items$productAsset$focalPoint? focalPoint,
    String? $__typename,
  });
  CopyWith$Query$Search$search$items$productAsset$focalPoint<TRes>
  get focalPoint;
}

class _CopyWithImpl$Query$Search$search$items$productAsset<TRes>
    implements CopyWith$Query$Search$search$items$productAsset<TRes> {
  _CopyWithImpl$Query$Search$search$items$productAsset(
    this._instance,
    this._then,
  );

  final Query$Search$search$items$productAsset _instance;

  final TRes Function(Query$Search$search$items$productAsset) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? preview = _undefined,
    Object? focalPoint = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Search$search$items$productAsset(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      preview: preview == _undefined || preview == null
          ? _instance.preview
          : (preview as String),
      focalPoint: focalPoint == _undefined
          ? _instance.focalPoint
          : (focalPoint as Query$Search$search$items$productAsset$focalPoint?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$Search$search$items$productAsset$focalPoint<TRes>
  get focalPoint {
    final local$focalPoint = _instance.focalPoint;
    return local$focalPoint == null
        ? CopyWith$Query$Search$search$items$productAsset$focalPoint.stub(
            _then(_instance),
          )
        : CopyWith$Query$Search$search$items$productAsset$focalPoint(
            local$focalPoint,
            (e) => call(focalPoint: e),
          );
  }
}

class _CopyWithStubImpl$Query$Search$search$items$productAsset<TRes>
    implements CopyWith$Query$Search$search$items$productAsset<TRes> {
  _CopyWithStubImpl$Query$Search$search$items$productAsset(this._res);

  TRes _res;

  call({
    String? id,
    String? preview,
    Query$Search$search$items$productAsset$focalPoint? focalPoint,
    String? $__typename,
  }) => _res;

  CopyWith$Query$Search$search$items$productAsset$focalPoint<TRes>
  get focalPoint =>
      CopyWith$Query$Search$search$items$productAsset$focalPoint.stub(_res);
}

class Query$Search$search$items$productAsset$focalPoint {
  Query$Search$search$items$productAsset$focalPoint({
    required this.x,
    required this.y,
    this.$__typename = 'Coordinate',
  });

  factory Query$Search$search$items$productAsset$focalPoint.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$x = json['x'];
    final l$y = json['y'];
    final l$$__typename = json['__typename'];
    return Query$Search$search$items$productAsset$focalPoint(
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
    if (other is! Query$Search$search$items$productAsset$focalPoint ||
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

extension UtilityExtension$Query$Search$search$items$productAsset$focalPoint
    on Query$Search$search$items$productAsset$focalPoint {
  CopyWith$Query$Search$search$items$productAsset$focalPoint<
    Query$Search$search$items$productAsset$focalPoint
  >
  get copyWith => CopyWith$Query$Search$search$items$productAsset$focalPoint(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$Search$search$items$productAsset$focalPoint<
  TRes
> {
  factory CopyWith$Query$Search$search$items$productAsset$focalPoint(
    Query$Search$search$items$productAsset$focalPoint instance,
    TRes Function(Query$Search$search$items$productAsset$focalPoint) then,
  ) = _CopyWithImpl$Query$Search$search$items$productAsset$focalPoint;

  factory CopyWith$Query$Search$search$items$productAsset$focalPoint.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$Search$search$items$productAsset$focalPoint;

  TRes call({double? x, double? y, String? $__typename});
}

class _CopyWithImpl$Query$Search$search$items$productAsset$focalPoint<TRes>
    implements
        CopyWith$Query$Search$search$items$productAsset$focalPoint<TRes> {
  _CopyWithImpl$Query$Search$search$items$productAsset$focalPoint(
    this._instance,
    this._then,
  );

  final Query$Search$search$items$productAsset$focalPoint _instance;

  final TRes Function(Query$Search$search$items$productAsset$focalPoint) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? x = _undefined,
    Object? y = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Search$search$items$productAsset$focalPoint(
      x: x == _undefined || x == null ? _instance.x : (x as double),
      y: y == _undefined || y == null ? _instance.y : (y as double),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Search$search$items$productAsset$focalPoint<TRes>
    implements
        CopyWith$Query$Search$search$items$productAsset$focalPoint<TRes> {
  _CopyWithStubImpl$Query$Search$search$items$productAsset$focalPoint(
    this._res,
  );

  TRes _res;

  call({double? x, double? y, String? $__typename}) => _res;
}
