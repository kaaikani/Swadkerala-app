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

class Variables$Mutation$ToggleFavorite {
  factory Variables$Mutation$ToggleFavorite({required String productId}) =>
      Variables$Mutation$ToggleFavorite._({r'productId': productId});

  Variables$Mutation$ToggleFavorite._(this._$data);

  factory Variables$Mutation$ToggleFavorite.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$productId = data['productId'];
    result$data['productId'] = (l$productId as String);
    return Variables$Mutation$ToggleFavorite._(result$data);
  }

  Map<String, dynamic> _$data;

  String get productId => (_$data['productId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$productId = productId;
    result$data['productId'] = l$productId;
    return result$data;
  }

  CopyWith$Variables$Mutation$ToggleFavorite<Variables$Mutation$ToggleFavorite>
  get copyWith => CopyWith$Variables$Mutation$ToggleFavorite(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ToggleFavorite ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$productId = productId;
    final lOther$productId = other.productId;
    if (l$productId != lOther$productId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$productId = productId;
    return Object.hashAll([l$productId]);
  }
}

abstract class CopyWith$Variables$Mutation$ToggleFavorite<TRes> {
  factory CopyWith$Variables$Mutation$ToggleFavorite(
    Variables$Mutation$ToggleFavorite instance,
    TRes Function(Variables$Mutation$ToggleFavorite) then,
  ) = _CopyWithImpl$Variables$Mutation$ToggleFavorite;

  factory CopyWith$Variables$Mutation$ToggleFavorite.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ToggleFavorite;

  TRes call({String? productId});
}

class _CopyWithImpl$Variables$Mutation$ToggleFavorite<TRes>
    implements CopyWith$Variables$Mutation$ToggleFavorite<TRes> {
  _CopyWithImpl$Variables$Mutation$ToggleFavorite(this._instance, this._then);

  final Variables$Mutation$ToggleFavorite _instance;

  final TRes Function(Variables$Mutation$ToggleFavorite) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? productId = _undefined}) => _then(
    Variables$Mutation$ToggleFavorite._({
      ..._instance._$data,
      if (productId != _undefined && productId != null)
        'productId': (productId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ToggleFavorite<TRes>
    implements CopyWith$Variables$Mutation$ToggleFavorite<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ToggleFavorite(this._res);

  TRes _res;

  call({String? productId}) => _res;
}

class Mutation$ToggleFavorite {
  Mutation$ToggleFavorite({
    required this.toggleFavorite,
    this.$__typename = 'Mutation',
  });

  factory Mutation$ToggleFavorite.fromJson(Map<String, dynamic> json) {
    final l$toggleFavorite = json['toggleFavorite'];
    final l$$__typename = json['__typename'];
    return Mutation$ToggleFavorite(
      toggleFavorite: Mutation$ToggleFavorite$toggleFavorite.fromJson(
        (l$toggleFavorite as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$ToggleFavorite$toggleFavorite toggleFavorite;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$toggleFavorite = toggleFavorite;
    _resultData['toggleFavorite'] = l$toggleFavorite.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$toggleFavorite = toggleFavorite;
    final l$$__typename = $__typename;
    return Object.hashAll([l$toggleFavorite, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ToggleFavorite || runtimeType != other.runtimeType) {
      return false;
    }
    final l$toggleFavorite = toggleFavorite;
    final lOther$toggleFavorite = other.toggleFavorite;
    if (l$toggleFavorite != lOther$toggleFavorite) {
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

extension UtilityExtension$Mutation$ToggleFavorite on Mutation$ToggleFavorite {
  CopyWith$Mutation$ToggleFavorite<Mutation$ToggleFavorite> get copyWith =>
      CopyWith$Mutation$ToggleFavorite(this, (i) => i);
}

abstract class CopyWith$Mutation$ToggleFavorite<TRes> {
  factory CopyWith$Mutation$ToggleFavorite(
    Mutation$ToggleFavorite instance,
    TRes Function(Mutation$ToggleFavorite) then,
  ) = _CopyWithImpl$Mutation$ToggleFavorite;

  factory CopyWith$Mutation$ToggleFavorite.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ToggleFavorite;

  TRes call({
    Mutation$ToggleFavorite$toggleFavorite? toggleFavorite,
    String? $__typename,
  });
  CopyWith$Mutation$ToggleFavorite$toggleFavorite<TRes> get toggleFavorite;
}

class _CopyWithImpl$Mutation$ToggleFavorite<TRes>
    implements CopyWith$Mutation$ToggleFavorite<TRes> {
  _CopyWithImpl$Mutation$ToggleFavorite(this._instance, this._then);

  final Mutation$ToggleFavorite _instance;

  final TRes Function(Mutation$ToggleFavorite) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? toggleFavorite = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ToggleFavorite(
      toggleFavorite: toggleFavorite == _undefined || toggleFavorite == null
          ? _instance.toggleFavorite
          : (toggleFavorite as Mutation$ToggleFavorite$toggleFavorite),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$ToggleFavorite$toggleFavorite<TRes> get toggleFavorite {
    final local$toggleFavorite = _instance.toggleFavorite;
    return CopyWith$Mutation$ToggleFavorite$toggleFavorite(
      local$toggleFavorite,
      (e) => call(toggleFavorite: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ToggleFavorite<TRes>
    implements CopyWith$Mutation$ToggleFavorite<TRes> {
  _CopyWithStubImpl$Mutation$ToggleFavorite(this._res);

  TRes _res;

  call({
    Mutation$ToggleFavorite$toggleFavorite? toggleFavorite,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$ToggleFavorite$toggleFavorite<TRes> get toggleFavorite =>
      CopyWith$Mutation$ToggleFavorite$toggleFavorite.stub(_res);
}

const documentNodeMutationToggleFavorite = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ToggleFavorite'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'productId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'toggleFavorite'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'productId'),
                value: VariableNode(name: NameNode(value: 'productId')),
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
Mutation$ToggleFavorite _parserFn$Mutation$ToggleFavorite(
  Map<String, dynamic> data,
) => Mutation$ToggleFavorite.fromJson(data);
typedef OnMutationCompleted$Mutation$ToggleFavorite =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation$ToggleFavorite?);

class Options$Mutation$ToggleFavorite
    extends graphql.MutationOptions<Mutation$ToggleFavorite> {
  Options$Mutation$ToggleFavorite({
    String? operationName,
    required Variables$Mutation$ToggleFavorite variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ToggleFavorite? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$ToggleFavorite? onCompleted,
    graphql.OnMutationUpdate<Mutation$ToggleFavorite>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
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
                 data == null ? null : _parserFn$Mutation$ToggleFavorite(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationToggleFavorite,
         parserFn: _parserFn$Mutation$ToggleFavorite,
       );

  final OnMutationCompleted$Mutation$ToggleFavorite? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$ToggleFavorite
    extends graphql.WatchQueryOptions<Mutation$ToggleFavorite> {
  WatchOptions$Mutation$ToggleFavorite({
    String? operationName,
    required Variables$Mutation$ToggleFavorite variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ToggleFavorite? typedOptimisticResult,
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
         document: documentNodeMutationToggleFavorite,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$ToggleFavorite,
       );
}

extension ClientExtension$Mutation$ToggleFavorite on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$ToggleFavorite>> mutate$ToggleFavorite(
    Options$Mutation$ToggleFavorite options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$ToggleFavorite> watchMutation$ToggleFavorite(
    WatchOptions$Mutation$ToggleFavorite options,
  ) => this.watchMutation(options);
}

class Mutation$ToggleFavorite$HookResult {
  Mutation$ToggleFavorite$HookResult(this.runMutation, this.result);

  final RunMutation$Mutation$ToggleFavorite runMutation;

  final graphql.QueryResult<Mutation$ToggleFavorite> result;
}

Mutation$ToggleFavorite$HookResult useMutation$ToggleFavorite([
  WidgetOptions$Mutation$ToggleFavorite? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions$Mutation$ToggleFavorite(),
  );
  return Mutation$ToggleFavorite$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$ToggleFavorite>
useWatchMutation$ToggleFavorite(WatchOptions$Mutation$ToggleFavorite options) =>
    graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$ToggleFavorite
    extends graphql.MutationOptions<Mutation$ToggleFavorite> {
  WidgetOptions$Mutation$ToggleFavorite({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ToggleFavorite? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$ToggleFavorite? onCompleted,
    graphql.OnMutationUpdate<Mutation$ToggleFavorite>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
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
                 data == null ? null : _parserFn$Mutation$ToggleFavorite(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationToggleFavorite,
         parserFn: _parserFn$Mutation$ToggleFavorite,
       );

  final OnMutationCompleted$Mutation$ToggleFavorite? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation$Mutation$ToggleFavorite =
    graphql.MultiSourceResult<Mutation$ToggleFavorite> Function(
      Variables$Mutation$ToggleFavorite, {
      Object? optimisticResult,
      Mutation$ToggleFavorite? typedOptimisticResult,
    });
typedef Builder$Mutation$ToggleFavorite =
    widgets.Widget Function(
      RunMutation$Mutation$ToggleFavorite,
      graphql.QueryResult<Mutation$ToggleFavorite>?,
    );

class Mutation$ToggleFavorite$Widget
    extends graphql_flutter.Mutation<Mutation$ToggleFavorite> {
  Mutation$ToggleFavorite$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$ToggleFavorite? options,
    required Builder$Mutation$ToggleFavorite builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions$Mutation$ToggleFavorite(),
         builder: (run, result) => builder(
           (variables, {optimisticResult, typedOptimisticResult}) => run(
             variables.toJson(),
             optimisticResult:
                 optimisticResult ?? typedOptimisticResult?.toJson(),
           ),
           result,
         ),
       );
}

class Mutation$ToggleFavorite$toggleFavorite {
  Mutation$ToggleFavorite$toggleFavorite({
    required this.items,
    required this.totalItems,
    this.$__typename = 'FavoriteList',
  });

  factory Mutation$ToggleFavorite$toggleFavorite.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$items = json['items'];
    final l$totalItems = json['totalItems'];
    final l$$__typename = json['__typename'];
    return Mutation$ToggleFavorite$toggleFavorite(
      items: (l$items as List<dynamic>)
          .map(
            (e) => Mutation$ToggleFavorite$toggleFavorite$items.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      totalItems: (l$totalItems as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Mutation$ToggleFavorite$toggleFavorite$items> items;

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
    if (other is! Mutation$ToggleFavorite$toggleFavorite ||
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

extension UtilityExtension$Mutation$ToggleFavorite$toggleFavorite
    on Mutation$ToggleFavorite$toggleFavorite {
  CopyWith$Mutation$ToggleFavorite$toggleFavorite<
    Mutation$ToggleFavorite$toggleFavorite
  >
  get copyWith =>
      CopyWith$Mutation$ToggleFavorite$toggleFavorite(this, (i) => i);
}

abstract class CopyWith$Mutation$ToggleFavorite$toggleFavorite<TRes> {
  factory CopyWith$Mutation$ToggleFavorite$toggleFavorite(
    Mutation$ToggleFavorite$toggleFavorite instance,
    TRes Function(Mutation$ToggleFavorite$toggleFavorite) then,
  ) = _CopyWithImpl$Mutation$ToggleFavorite$toggleFavorite;

  factory CopyWith$Mutation$ToggleFavorite$toggleFavorite.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ToggleFavorite$toggleFavorite;

  TRes call({
    List<Mutation$ToggleFavorite$toggleFavorite$items>? items,
    int? totalItems,
    String? $__typename,
  });
  TRes items(
    Iterable<Mutation$ToggleFavorite$toggleFavorite$items> Function(
      Iterable<
        CopyWith$Mutation$ToggleFavorite$toggleFavorite$items<
          Mutation$ToggleFavorite$toggleFavorite$items
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ToggleFavorite$toggleFavorite<TRes>
    implements CopyWith$Mutation$ToggleFavorite$toggleFavorite<TRes> {
  _CopyWithImpl$Mutation$ToggleFavorite$toggleFavorite(
    this._instance,
    this._then,
  );

  final Mutation$ToggleFavorite$toggleFavorite _instance;

  final TRes Function(Mutation$ToggleFavorite$toggleFavorite) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? totalItems = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ToggleFavorite$toggleFavorite(
      items: items == _undefined || items == null
          ? _instance.items
          : (items as List<Mutation$ToggleFavorite$toggleFavorite$items>),
      totalItems: totalItems == _undefined || totalItems == null
          ? _instance.totalItems
          : (totalItems as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes items(
    Iterable<Mutation$ToggleFavorite$toggleFavorite$items> Function(
      Iterable<
        CopyWith$Mutation$ToggleFavorite$toggleFavorite$items<
          Mutation$ToggleFavorite$toggleFavorite$items
        >
      >,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) =>
            CopyWith$Mutation$ToggleFavorite$toggleFavorite$items(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ToggleFavorite$toggleFavorite<TRes>
    implements CopyWith$Mutation$ToggleFavorite$toggleFavorite<TRes> {
  _CopyWithStubImpl$Mutation$ToggleFavorite$toggleFavorite(this._res);

  TRes _res;

  call({
    List<Mutation$ToggleFavorite$toggleFavorite$items>? items,
    int? totalItems,
    String? $__typename,
  }) => _res;

  items(_fn) => _res;
}

class Mutation$ToggleFavorite$toggleFavorite$items {
  Mutation$ToggleFavorite$toggleFavorite$items({
    required this.id,
    this.product,
    this.$__typename = 'Favorite',
  });

  factory Mutation$ToggleFavorite$toggleFavorite$items.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$product = json['product'];
    final l$$__typename = json['__typename'];
    return Mutation$ToggleFavorite$toggleFavorite$items(
      id: (l$id as String),
      product: l$product == null
          ? null
          : Mutation$ToggleFavorite$toggleFavorite$items$product.fromJson(
              (l$product as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Mutation$ToggleFavorite$toggleFavorite$items$product? product;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$product = product;
    _resultData['product'] = l$product?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$product = product;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$product, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ToggleFavorite$toggleFavorite$items ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ToggleFavorite$toggleFavorite$items
    on Mutation$ToggleFavorite$toggleFavorite$items {
  CopyWith$Mutation$ToggleFavorite$toggleFavorite$items<
    Mutation$ToggleFavorite$toggleFavorite$items
  >
  get copyWith =>
      CopyWith$Mutation$ToggleFavorite$toggleFavorite$items(this, (i) => i);
}

abstract class CopyWith$Mutation$ToggleFavorite$toggleFavorite$items<TRes> {
  factory CopyWith$Mutation$ToggleFavorite$toggleFavorite$items(
    Mutation$ToggleFavorite$toggleFavorite$items instance,
    TRes Function(Mutation$ToggleFavorite$toggleFavorite$items) then,
  ) = _CopyWithImpl$Mutation$ToggleFavorite$toggleFavorite$items;

  factory CopyWith$Mutation$ToggleFavorite$toggleFavorite$items.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ToggleFavorite$toggleFavorite$items;

  TRes call({
    String? id,
    Mutation$ToggleFavorite$toggleFavorite$items$product? product,
    String? $__typename,
  });
  CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product<TRes>
  get product;
}

class _CopyWithImpl$Mutation$ToggleFavorite$toggleFavorite$items<TRes>
    implements CopyWith$Mutation$ToggleFavorite$toggleFavorite$items<TRes> {
  _CopyWithImpl$Mutation$ToggleFavorite$toggleFavorite$items(
    this._instance,
    this._then,
  );

  final Mutation$ToggleFavorite$toggleFavorite$items _instance;

  final TRes Function(Mutation$ToggleFavorite$toggleFavorite$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? product = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ToggleFavorite$toggleFavorite$items(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      product: product == _undefined
          ? _instance.product
          : (product as Mutation$ToggleFavorite$toggleFavorite$items$product?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product<TRes>
  get product {
    final local$product = _instance.product;
    return local$product == null
        ? CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product.stub(
            _then(_instance),
          )
        : CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product(
            local$product,
            (e) => call(product: e),
          );
  }
}

class _CopyWithStubImpl$Mutation$ToggleFavorite$toggleFavorite$items<TRes>
    implements CopyWith$Mutation$ToggleFavorite$toggleFavorite$items<TRes> {
  _CopyWithStubImpl$Mutation$ToggleFavorite$toggleFavorite$items(this._res);

  TRes _res;

  call({
    String? id,
    Mutation$ToggleFavorite$toggleFavorite$items$product? product,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product<TRes>
  get product =>
      CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product.stub(_res);
}

class Mutation$ToggleFavorite$toggleFavorite$items$product {
  Mutation$ToggleFavorite$toggleFavorite$items$product({
    required this.id,
    required this.name,
    this.$__typename = 'Product',
  });

  factory Mutation$ToggleFavorite$toggleFavorite$items$product.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Mutation$ToggleFavorite$toggleFavorite$items$product(
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
    return Object.hashAll([l$id, l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ToggleFavorite$toggleFavorite$items$product ||
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

extension UtilityExtension$Mutation$ToggleFavorite$toggleFavorite$items$product
    on Mutation$ToggleFavorite$toggleFavorite$items$product {
  CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product<
    Mutation$ToggleFavorite$toggleFavorite$items$product
  >
  get copyWith => CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product<
  TRes
> {
  factory CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product(
    Mutation$ToggleFavorite$toggleFavorite$items$product instance,
    TRes Function(Mutation$ToggleFavorite$toggleFavorite$items$product) then,
  ) = _CopyWithImpl$Mutation$ToggleFavorite$toggleFavorite$items$product;

  factory CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ToggleFavorite$toggleFavorite$items$product;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Mutation$ToggleFavorite$toggleFavorite$items$product<TRes>
    implements
        CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product<TRes> {
  _CopyWithImpl$Mutation$ToggleFavorite$toggleFavorite$items$product(
    this._instance,
    this._then,
  );

  final Mutation$ToggleFavorite$toggleFavorite$items$product _instance;

  final TRes Function(Mutation$ToggleFavorite$toggleFavorite$items$product)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ToggleFavorite$toggleFavorite$items$product(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ToggleFavorite$toggleFavorite$items$product<
  TRes
>
    implements
        CopyWith$Mutation$ToggleFavorite$toggleFavorite$items$product<TRes> {
  _CopyWithStubImpl$Mutation$ToggleFavorite$toggleFavorite$items$product(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$GetCustomerFavorites {
  Query$GetCustomerFavorites({this.activeCustomer, this.$__typename = 'Query'});

  factory Query$GetCustomerFavorites.fromJson(Map<String, dynamic> json) {
    final l$activeCustomer = json['activeCustomer'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerFavorites(
      activeCustomer: l$activeCustomer == null
          ? null
          : Query$GetCustomerFavorites$activeCustomer.fromJson(
              (l$activeCustomer as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GetCustomerFavorites$activeCustomer? activeCustomer;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$activeCustomer = activeCustomer;
    _resultData['activeCustomer'] = l$activeCustomer?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$activeCustomer = activeCustomer;
    final l$$__typename = $__typename;
    return Object.hashAll([l$activeCustomer, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetCustomerFavorites ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$activeCustomer = activeCustomer;
    final lOther$activeCustomer = other.activeCustomer;
    if (l$activeCustomer != lOther$activeCustomer) {
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

extension UtilityExtension$Query$GetCustomerFavorites
    on Query$GetCustomerFavorites {
  CopyWith$Query$GetCustomerFavorites<Query$GetCustomerFavorites>
  get copyWith => CopyWith$Query$GetCustomerFavorites(this, (i) => i);
}

abstract class CopyWith$Query$GetCustomerFavorites<TRes> {
  factory CopyWith$Query$GetCustomerFavorites(
    Query$GetCustomerFavorites instance,
    TRes Function(Query$GetCustomerFavorites) then,
  ) = _CopyWithImpl$Query$GetCustomerFavorites;

  factory CopyWith$Query$GetCustomerFavorites.stub(TRes res) =
      _CopyWithStubImpl$Query$GetCustomerFavorites;

  TRes call({
    Query$GetCustomerFavorites$activeCustomer? activeCustomer,
    String? $__typename,
  });
  CopyWith$Query$GetCustomerFavorites$activeCustomer<TRes> get activeCustomer;
}

class _CopyWithImpl$Query$GetCustomerFavorites<TRes>
    implements CopyWith$Query$GetCustomerFavorites<TRes> {
  _CopyWithImpl$Query$GetCustomerFavorites(this._instance, this._then);

  final Query$GetCustomerFavorites _instance;

  final TRes Function(Query$GetCustomerFavorites) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? activeCustomer = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetCustomerFavorites(
      activeCustomer: activeCustomer == _undefined
          ? _instance.activeCustomer
          : (activeCustomer as Query$GetCustomerFavorites$activeCustomer?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$GetCustomerFavorites$activeCustomer<TRes> get activeCustomer {
    final local$activeCustomer = _instance.activeCustomer;
    return local$activeCustomer == null
        ? CopyWith$Query$GetCustomerFavorites$activeCustomer.stub(
            _then(_instance),
          )
        : CopyWith$Query$GetCustomerFavorites$activeCustomer(
            local$activeCustomer,
            (e) => call(activeCustomer: e),
          );
  }
}

class _CopyWithStubImpl$Query$GetCustomerFavorites<TRes>
    implements CopyWith$Query$GetCustomerFavorites<TRes> {
  _CopyWithStubImpl$Query$GetCustomerFavorites(this._res);

  TRes _res;

  call({
    Query$GetCustomerFavorites$activeCustomer? activeCustomer,
    String? $__typename,
  }) => _res;

  CopyWith$Query$GetCustomerFavorites$activeCustomer<TRes> get activeCustomer =>
      CopyWith$Query$GetCustomerFavorites$activeCustomer.stub(_res);
}

const documentNodeQueryGetCustomerFavorites = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GetCustomerFavorites'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'activeCustomer'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'Customer'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'favorites'),
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
                                          name: NameNode(
                                            value: 'featuredAsset',
                                          ),
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
                                                name: NameNode(
                                                  value: 'preview',
                                                ),
                                                alias: null,
                                                arguments: [],
                                                directives: [],
                                                selectionSet: null,
                                              ),
                                              FieldNode(
                                                name: NameNode(
                                                  value: '__typename',
                                                ),
                                                alias: null,
                                                arguments: [],
                                                directives: [],
                                                selectionSet: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                        FieldNode(
                                          name: NameNode(value: 'enabled'),
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
                                                name: NameNode(
                                                  value: '__typename',
                                                ),
                                                alias: null,
                                                arguments: [],
                                                directives: [],
                                                selectionSet: null,
                                              ),
                                            ],
                                          ),
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
Query$GetCustomerFavorites _parserFn$Query$GetCustomerFavorites(
  Map<String, dynamic> data,
) => Query$GetCustomerFavorites.fromJson(data);
typedef OnQueryComplete$Query$GetCustomerFavorites =
    FutureOr<void> Function(Map<String, dynamic>?, Query$GetCustomerFavorites?);

class Options$Query$GetCustomerFavorites
    extends graphql.QueryOptions<Query$GetCustomerFavorites> {
  Options$Query$GetCustomerFavorites({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetCustomerFavorites? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetCustomerFavorites? onComplete,
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
                 data == null
                     ? null
                     : _parserFn$Query$GetCustomerFavorites(data),
               ),
         onError: onError,
         document: documentNodeQueryGetCustomerFavorites,
         parserFn: _parserFn$Query$GetCustomerFavorites,
       );

  final OnQueryComplete$Query$GetCustomerFavorites? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$GetCustomerFavorites
    extends graphql.WatchQueryOptions<Query$GetCustomerFavorites> {
  WatchOptions$Query$GetCustomerFavorites({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetCustomerFavorites? typedOptimisticResult,
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
         document: documentNodeQueryGetCustomerFavorites,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$GetCustomerFavorites,
       );
}

class FetchMoreOptions$Query$GetCustomerFavorites
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetCustomerFavorites({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQueryGetCustomerFavorites,
       );
}

extension ClientExtension$Query$GetCustomerFavorites on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetCustomerFavorites>>
  query$GetCustomerFavorites([
    Options$Query$GetCustomerFavorites? options,
  ]) async => await this.query(options ?? Options$Query$GetCustomerFavorites());

  graphql.ObservableQuery<Query$GetCustomerFavorites>
  watchQuery$GetCustomerFavorites([
    WatchOptions$Query$GetCustomerFavorites? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$GetCustomerFavorites());

  void writeQuery$GetCustomerFavorites({
    required Query$GetCustomerFavorites data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryGetCustomerFavorites,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$GetCustomerFavorites? readQuery$GetCustomerFavorites({
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryGetCustomerFavorites,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetCustomerFavorites.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetCustomerFavorites>
useQuery$GetCustomerFavorites([Options$Query$GetCustomerFavorites? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$GetCustomerFavorites());
graphql.ObservableQuery<Query$GetCustomerFavorites>
useWatchQuery$GetCustomerFavorites([
  WatchOptions$Query$GetCustomerFavorites? options,
]) => graphql_flutter.useWatchQuery(
  options ?? WatchOptions$Query$GetCustomerFavorites(),
);

class Query$GetCustomerFavorites$Widget
    extends graphql_flutter.Query<Query$GetCustomerFavorites> {
  Query$GetCustomerFavorites$Widget({
    widgets.Key? key,
    Options$Query$GetCustomerFavorites? options,
    required graphql_flutter.QueryBuilder<Query$GetCustomerFavorites> builder,
  }) : super(
         key: key,
         options: options ?? Options$Query$GetCustomerFavorites(),
         builder: builder,
       );
}

class Query$GetCustomerFavorites$activeCustomer {
  Query$GetCustomerFavorites$activeCustomer({
    this.$__typename = 'Customer',
    required this.favorites,
  });

  factory Query$GetCustomerFavorites$activeCustomer.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$favorites = json['favorites'];
    return Query$GetCustomerFavorites$activeCustomer(
      $__typename: (l$$__typename as String),
      favorites: Query$GetCustomerFavorites$activeCustomer$favorites.fromJson(
        (l$favorites as Map<String, dynamic>),
      ),
    );
  }

  final String $__typename;

  final Query$GetCustomerFavorites$activeCustomer$favorites favorites;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$favorites = favorites;
    _resultData['favorites'] = l$favorites.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$favorites = favorites;
    return Object.hashAll([l$$__typename, l$favorites]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetCustomerFavorites$activeCustomer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$favorites = favorites;
    final lOther$favorites = other.favorites;
    if (l$favorites != lOther$favorites) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetCustomerFavorites$activeCustomer
    on Query$GetCustomerFavorites$activeCustomer {
  CopyWith$Query$GetCustomerFavorites$activeCustomer<
    Query$GetCustomerFavorites$activeCustomer
  >
  get copyWith =>
      CopyWith$Query$GetCustomerFavorites$activeCustomer(this, (i) => i);
}

abstract class CopyWith$Query$GetCustomerFavorites$activeCustomer<TRes> {
  factory CopyWith$Query$GetCustomerFavorites$activeCustomer(
    Query$GetCustomerFavorites$activeCustomer instance,
    TRes Function(Query$GetCustomerFavorites$activeCustomer) then,
  ) = _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer;

  factory CopyWith$Query$GetCustomerFavorites$activeCustomer.stub(TRes res) =
      _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer;

  TRes call({
    String? $__typename,
    Query$GetCustomerFavorites$activeCustomer$favorites? favorites,
  });
  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites<TRes>
  get favorites;
}

class _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer<TRes>
    implements CopyWith$Query$GetCustomerFavorites$activeCustomer<TRes> {
  _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer(
    this._instance,
    this._then,
  );

  final Query$GetCustomerFavorites$activeCustomer _instance;

  final TRes Function(Query$GetCustomerFavorites$activeCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? favorites = _undefined,
  }) => _then(
    Query$GetCustomerFavorites$activeCustomer(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      favorites: favorites == _undefined || favorites == null
          ? _instance.favorites
          : (favorites as Query$GetCustomerFavorites$activeCustomer$favorites),
    ),
  );

  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites<TRes>
  get favorites {
    final local$favorites = _instance.favorites;
    return CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites(
      local$favorites,
      (e) => call(favorites: e),
    );
  }
}

class _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer<TRes>
    implements CopyWith$Query$GetCustomerFavorites$activeCustomer<TRes> {
  _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer(this._res);

  TRes _res;

  call({
    String? $__typename,
    Query$GetCustomerFavorites$activeCustomer$favorites? favorites,
  }) => _res;

  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites<TRes>
  get favorites =>
      CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites.stub(_res);
}

class Query$GetCustomerFavorites$activeCustomer$favorites {
  Query$GetCustomerFavorites$activeCustomer$favorites({
    required this.items,
    required this.totalItems,
    this.$__typename = 'FavoriteList',
  });

  factory Query$GetCustomerFavorites$activeCustomer$favorites.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$items = json['items'];
    final l$totalItems = json['totalItems'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerFavorites$activeCustomer$favorites(
      items: (l$items as List<dynamic>)
          .map(
            (e) =>
                Query$GetCustomerFavorites$activeCustomer$favorites$items.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      totalItems: (l$totalItems as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$GetCustomerFavorites$activeCustomer$favorites$items> items;

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
    if (other is! Query$GetCustomerFavorites$activeCustomer$favorites ||
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

extension UtilityExtension$Query$GetCustomerFavorites$activeCustomer$favorites
    on Query$GetCustomerFavorites$activeCustomer$favorites {
  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites<
    Query$GetCustomerFavorites$activeCustomer$favorites
  >
  get copyWith => CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites<
  TRes
> {
  factory CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites(
    Query$GetCustomerFavorites$activeCustomer$favorites instance,
    TRes Function(Query$GetCustomerFavorites$activeCustomer$favorites) then,
  ) = _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites;

  factory CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites;

  TRes call({
    List<Query$GetCustomerFavorites$activeCustomer$favorites$items>? items,
    int? totalItems,
    String? $__typename,
  });
  TRes items(
    Iterable<Query$GetCustomerFavorites$activeCustomer$favorites$items>
    Function(
      Iterable<
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items<
          Query$GetCustomerFavorites$activeCustomer$favorites$items
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites<TRes>
    implements
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites<TRes> {
  _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites(
    this._instance,
    this._then,
  );

  final Query$GetCustomerFavorites$activeCustomer$favorites _instance;

  final TRes Function(Query$GetCustomerFavorites$activeCustomer$favorites)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? totalItems = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetCustomerFavorites$activeCustomer$favorites(
      items: items == _undefined || items == null
          ? _instance.items
          : (items
                as List<
                  Query$GetCustomerFavorites$activeCustomer$favorites$items
                >),
      totalItems: totalItems == _undefined || totalItems == null
          ? _instance.totalItems
          : (totalItems as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes items(
    Iterable<Query$GetCustomerFavorites$activeCustomer$favorites$items>
    Function(
      Iterable<
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items<
          Query$GetCustomerFavorites$activeCustomer$favorites$items
        >
      >,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) =>
            CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites<
  TRes
>
    implements
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites<TRes> {
  _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites(
    this._res,
  );

  TRes _res;

  call({
    List<Query$GetCustomerFavorites$activeCustomer$favorites$items>? items,
    int? totalItems,
    String? $__typename,
  }) => _res;

  items(_fn) => _res;
}

class Query$GetCustomerFavorites$activeCustomer$favorites$items {
  Query$GetCustomerFavorites$activeCustomer$favorites$items({
    required this.id,
    this.product,
    this.$__typename = 'Favorite',
  });

  factory Query$GetCustomerFavorites$activeCustomer$favorites$items.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$product = json['product'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerFavorites$activeCustomer$favorites$items(
      id: (l$id as String),
      product: l$product == null
          ? null
          : Query$GetCustomerFavorites$activeCustomer$favorites$items$product.fromJson(
              (l$product as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query$GetCustomerFavorites$activeCustomer$favorites$items$product?
  product;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$product = product;
    _resultData['product'] = l$product?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$product = product;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$product, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetCustomerFavorites$activeCustomer$favorites$items ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetCustomerFavorites$activeCustomer$favorites$items
    on Query$GetCustomerFavorites$activeCustomer$favorites$items {
  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items<
    Query$GetCustomerFavorites$activeCustomer$favorites$items
  >
  get copyWith =>
      CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items<
  TRes
> {
  factory CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items(
    Query$GetCustomerFavorites$activeCustomer$favorites$items instance,
    TRes Function(Query$GetCustomerFavorites$activeCustomer$favorites$items)
    then,
  ) = _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items;

  factory CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items;

  TRes call({
    String? id,
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product? product,
    String? $__typename,
  });
  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product<
    TRes
  >
  get product;
}

class _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items<
  TRes
>
    implements
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items<
          TRes
        > {
  _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items(
    this._instance,
    this._then,
  );

  final Query$GetCustomerFavorites$activeCustomer$favorites$items _instance;

  final TRes Function(Query$GetCustomerFavorites$activeCustomer$favorites$items)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? product = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetCustomerFavorites$activeCustomer$favorites$items(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      product: product == _undefined
          ? _instance.product
          : (product
                as Query$GetCustomerFavorites$activeCustomer$favorites$items$product?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product<
    TRes
  >
  get product {
    final local$product = _instance.product;
    return local$product == null
        ? CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product.stub(
            _then(_instance),
          )
        : CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product(
            local$product,
            (e) => call(product: e),
          );
  }
}

class _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items<
  TRes
>
    implements
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items<
          TRes
        > {
  _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product? product,
    String? $__typename,
  }) => _res;

  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product<
    TRes
  >
  get product =>
      CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product.stub(
        _res,
      );
}

class Query$GetCustomerFavorites$activeCustomer$favorites$items$product {
  Query$GetCustomerFavorites$activeCustomer$favorites$items$product({
    required this.id,
    this.featuredAsset,
    required this.enabled,
    required this.variants,
    required this.name,
    this.$__typename = 'Product',
  });

  factory Query$GetCustomerFavorites$activeCustomer$favorites$items$product.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$featuredAsset = json['featuredAsset'];
    final l$enabled = json['enabled'];
    final l$variants = json['variants'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerFavorites$activeCustomer$favorites$items$product(
      id: (l$id as String),
      featuredAsset: l$featuredAsset == null
          ? null
          : Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset.fromJson(
              (l$featuredAsset as Map<String, dynamic>),
            ),
      enabled: (l$enabled as bool),
      variants: (l$variants as List<dynamic>)
          .map(
            (e) =>
                Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset?
  featuredAsset;

  final bool enabled;

  final List<
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
  >
  variants;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$featuredAsset = featuredAsset;
    _resultData['featuredAsset'] = l$featuredAsset?.toJson();
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
    final l$variants = variants;
    _resultData['variants'] = l$variants.map((e) => e.toJson()).toList();
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$featuredAsset = featuredAsset;
    final l$enabled = enabled;
    final l$variants = variants;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$featuredAsset,
      l$enabled,
      Object.hashAll(l$variants.map((v) => v)),
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
            is! Query$GetCustomerFavorites$activeCustomer$favorites$items$product ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$featuredAsset = featuredAsset;
    final lOther$featuredAsset = other.featuredAsset;
    if (l$featuredAsset != lOther$featuredAsset) {
      return false;
    }
    final l$enabled = enabled;
    final lOther$enabled = other.enabled;
    if (l$enabled != lOther$enabled) {
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

extension UtilityExtension$Query$GetCustomerFavorites$activeCustomer$favorites$items$product
    on Query$GetCustomerFavorites$activeCustomer$favorites$items$product {
  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product<
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product
  >
  get copyWith =>
      CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product<
  TRes
> {
  factory CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product(
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product instance,
    TRes Function(
      Query$GetCustomerFavorites$activeCustomer$favorites$items$product,
    )
    then,
  ) = _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product;

  factory CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product;

  TRes call({
    String? id,
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset?
    featuredAsset,
    bool? enabled,
    List<
      Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
    >?
    variants,
    String? name,
    String? $__typename,
  });
  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset<
    TRes
  >
  get featuredAsset;
  TRes variants(
    Iterable<
      Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
    >
    Function(
      Iterable<
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants<
          Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product<
  TRes
>
    implements
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product<
          TRes
        > {
  _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product(
    this._instance,
    this._then,
  );

  final Query$GetCustomerFavorites$activeCustomer$favorites$items$product
  _instance;

  final TRes Function(
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? featuredAsset = _undefined,
    Object? enabled = _undefined,
    Object? variants = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      featuredAsset: featuredAsset == _undefined
          ? _instance.featuredAsset
          : (featuredAsset
                as Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset?),
      enabled: enabled == _undefined || enabled == null
          ? _instance.enabled
          : (enabled as bool),
      variants: variants == _undefined || variants == null
          ? _instance.variants
          : (variants
                as List<
                  Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
                >),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset<
    TRes
  >
  get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset.stub(
            _then(_instance),
          )
        : CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset(
            local$featuredAsset,
            (e) => call(featuredAsset: e),
          );
  }

  TRes variants(
    Iterable<
      Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
    >
    Function(
      Iterable<
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants<
          Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
        >
      >,
    )
    _fn,
  ) => call(
    variants: _fn(
      _instance.variants.map(
        (e) =>
            CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product<
  TRes
>
    implements
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product<
          TRes
        > {
  _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset?
    featuredAsset,
    bool? enabled,
    List<
      Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
    >?
    variants,
    String? name,
    String? $__typename,
  }) => _res;

  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset<
    TRes
  >
  get featuredAsset =>
      CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset.stub(
        _res,
      );

  variants(_fn) => _res;
}

class Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset {
  Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset({
    required this.name,
    required this.preview,
    this.$__typename = 'Asset',
  });

  factory Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$preview = json['preview'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset(
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
    return Object.hashAll([l$name, l$preview, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset ||
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

extension UtilityExtension$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset
    on
        Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset {
  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset<
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset
  >
  get copyWith =>
      CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset<
  TRes
> {
  factory CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset(
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset
    instance,
    TRes Function(
      Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset,
    )
    then,
  ) = _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset;

  factory CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset;

  TRes call({String? name, String? preview, String? $__typename});
}

class _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset<
  TRes
>
    implements
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset<
          TRes
        > {
  _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset(
    this._instance,
    this._then,
  );

  final Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset
  _instance;

  final TRes Function(
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? preview = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      preview: preview == _undefined || preview == null
          ? _instance.preview
          : (preview as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset<
  TRes
>
    implements
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset<
          TRes
        > {
  _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$featuredAsset(
    this._res,
  );

  TRes _res;

  call({String? name, String? preview, String? $__typename}) => _res;
}

class Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants {
  Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants({
    required this.id,
    this.$__typename = 'ProductVariant',
  });

  factory Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
    on Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants {
  CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants<
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
  >
  get copyWith =>
      CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants<
  TRes
> {
  factory CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants(
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
    instance,
    TRes Function(
      Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants,
    )
    then,
  ) = _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants;

  factory CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants<
  TRes
>
    implements
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants<
          TRes
        > {
  _CopyWithImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants(
    this._instance,
    this._then,
  );

  final Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants
  _instance;

  final TRes Function(
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants<
  TRes
>
    implements
        CopyWith$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants<
          TRes
        > {
  _CopyWithStubImpl$Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants(
    this._res,
  );

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query$GetFrequentlyOrderedProducts {
  Query$GetFrequentlyOrderedProducts({
    required this.frequentlyOrderedProducts,
    this.$__typename = 'Query',
  });

  factory Query$GetFrequentlyOrderedProducts.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$frequentlyOrderedProducts = json['frequentlyOrderedProducts'];
    final l$$__typename = json['__typename'];
    return Query$GetFrequentlyOrderedProducts(
      frequentlyOrderedProducts: (l$frequentlyOrderedProducts as List<dynamic>)
          .map(
            (e) =>
                Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts>
  frequentlyOrderedProducts;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$frequentlyOrderedProducts = frequentlyOrderedProducts;
    _resultData['frequentlyOrderedProducts'] = l$frequentlyOrderedProducts
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$frequentlyOrderedProducts = frequentlyOrderedProducts;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$frequentlyOrderedProducts.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetFrequentlyOrderedProducts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$frequentlyOrderedProducts = frequentlyOrderedProducts;
    final lOther$frequentlyOrderedProducts = other.frequentlyOrderedProducts;
    if (l$frequentlyOrderedProducts.length !=
        lOther$frequentlyOrderedProducts.length) {
      return false;
    }
    for (int i = 0; i < l$frequentlyOrderedProducts.length; i++) {
      final l$frequentlyOrderedProducts$entry = l$frequentlyOrderedProducts[i];
      final lOther$frequentlyOrderedProducts$entry =
          lOther$frequentlyOrderedProducts[i];
      if (l$frequentlyOrderedProducts$entry !=
          lOther$frequentlyOrderedProducts$entry) {
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

extension UtilityExtension$Query$GetFrequentlyOrderedProducts
    on Query$GetFrequentlyOrderedProducts {
  CopyWith$Query$GetFrequentlyOrderedProducts<
    Query$GetFrequentlyOrderedProducts
  >
  get copyWith => CopyWith$Query$GetFrequentlyOrderedProducts(this, (i) => i);
}

abstract class CopyWith$Query$GetFrequentlyOrderedProducts<TRes> {
  factory CopyWith$Query$GetFrequentlyOrderedProducts(
    Query$GetFrequentlyOrderedProducts instance,
    TRes Function(Query$GetFrequentlyOrderedProducts) then,
  ) = _CopyWithImpl$Query$GetFrequentlyOrderedProducts;

  factory CopyWith$Query$GetFrequentlyOrderedProducts.stub(TRes res) =
      _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts;

  TRes call({
    List<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts>?
    frequentlyOrderedProducts,
    String? $__typename,
  });
  TRes frequentlyOrderedProducts(
    Iterable<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts>
    Function(
      Iterable<
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts<
          Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$GetFrequentlyOrderedProducts<TRes>
    implements CopyWith$Query$GetFrequentlyOrderedProducts<TRes> {
  _CopyWithImpl$Query$GetFrequentlyOrderedProducts(this._instance, this._then);

  final Query$GetFrequentlyOrderedProducts _instance;

  final TRes Function(Query$GetFrequentlyOrderedProducts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? frequentlyOrderedProducts = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetFrequentlyOrderedProducts(
      frequentlyOrderedProducts:
          frequentlyOrderedProducts == _undefined ||
              frequentlyOrderedProducts == null
          ? _instance.frequentlyOrderedProducts
          : (frequentlyOrderedProducts
                as List<
                  Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes frequentlyOrderedProducts(
    Iterable<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts>
    Function(
      Iterable<
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts<
          Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts
        >
      >,
    )
    _fn,
  ) => call(
    frequentlyOrderedProducts: _fn(
      _instance.frequentlyOrderedProducts.map(
        (e) =>
            CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts<TRes>
    implements CopyWith$Query$GetFrequentlyOrderedProducts<TRes> {
  _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts(this._res);

  TRes _res;

  call({
    List<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts>?
    frequentlyOrderedProducts,
    String? $__typename,
  }) => _res;

  frequentlyOrderedProducts(_fn) => _res;
}

const documentNodeQueryGetFrequentlyOrderedProducts = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GetFrequentlyOrderedProducts'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'frequentlyOrderedProducts'),
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
                        name: NameNode(value: 'enabled'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
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
                        name: NameNode(value: 'variants'),
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
                  name: NameNode(value: 'orderCount'),
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
Query$GetFrequentlyOrderedProducts _parserFn$Query$GetFrequentlyOrderedProducts(
  Map<String, dynamic> data,
) => Query$GetFrequentlyOrderedProducts.fromJson(data);
typedef OnQueryComplete$Query$GetFrequentlyOrderedProducts =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query$GetFrequentlyOrderedProducts?,
    );

class Options$Query$GetFrequentlyOrderedProducts
    extends graphql.QueryOptions<Query$GetFrequentlyOrderedProducts> {
  Options$Query$GetFrequentlyOrderedProducts({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetFrequentlyOrderedProducts? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetFrequentlyOrderedProducts? onComplete,
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
                 data == null
                     ? null
                     : _parserFn$Query$GetFrequentlyOrderedProducts(data),
               ),
         onError: onError,
         document: documentNodeQueryGetFrequentlyOrderedProducts,
         parserFn: _parserFn$Query$GetFrequentlyOrderedProducts,
       );

  final OnQueryComplete$Query$GetFrequentlyOrderedProducts?
  onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$GetFrequentlyOrderedProducts
    extends graphql.WatchQueryOptions<Query$GetFrequentlyOrderedProducts> {
  WatchOptions$Query$GetFrequentlyOrderedProducts({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetFrequentlyOrderedProducts? typedOptimisticResult,
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
         document: documentNodeQueryGetFrequentlyOrderedProducts,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$GetFrequentlyOrderedProducts,
       );
}

class FetchMoreOptions$Query$GetFrequentlyOrderedProducts
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetFrequentlyOrderedProducts({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQueryGetFrequentlyOrderedProducts,
       );
}

extension ClientExtension$Query$GetFrequentlyOrderedProducts
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetFrequentlyOrderedProducts>>
  query$GetFrequentlyOrderedProducts([
    Options$Query$GetFrequentlyOrderedProducts? options,
  ]) async =>
      await this.query(options ?? Options$Query$GetFrequentlyOrderedProducts());

  graphql.ObservableQuery<Query$GetFrequentlyOrderedProducts>
  watchQuery$GetFrequentlyOrderedProducts([
    WatchOptions$Query$GetFrequentlyOrderedProducts? options,
  ]) => this.watchQuery(
    options ?? WatchOptions$Query$GetFrequentlyOrderedProducts(),
  );

  void writeQuery$GetFrequentlyOrderedProducts({
    required Query$GetFrequentlyOrderedProducts data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryGetFrequentlyOrderedProducts,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$GetFrequentlyOrderedProducts? readQuery$GetFrequentlyOrderedProducts({
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryGetFrequentlyOrderedProducts,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query$GetFrequentlyOrderedProducts.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetFrequentlyOrderedProducts>
useQuery$GetFrequentlyOrderedProducts([
  Options$Query$GetFrequentlyOrderedProducts? options,
]) => graphql_flutter.useQuery(
  options ?? Options$Query$GetFrequentlyOrderedProducts(),
);
graphql.ObservableQuery<Query$GetFrequentlyOrderedProducts>
useWatchQuery$GetFrequentlyOrderedProducts([
  WatchOptions$Query$GetFrequentlyOrderedProducts? options,
]) => graphql_flutter.useWatchQuery(
  options ?? WatchOptions$Query$GetFrequentlyOrderedProducts(),
);

class Query$GetFrequentlyOrderedProducts$Widget
    extends graphql_flutter.Query<Query$GetFrequentlyOrderedProducts> {
  Query$GetFrequentlyOrderedProducts$Widget({
    widgets.Key? key,
    Options$Query$GetFrequentlyOrderedProducts? options,
    required graphql_flutter.QueryBuilder<Query$GetFrequentlyOrderedProducts>
    builder,
  }) : super(
         key: key,
         options: options ?? Options$Query$GetFrequentlyOrderedProducts(),
         builder: builder,
       );
}

class Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts {
  Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts({
    required this.product,
    required this.orderCount,
    this.$__typename = 'FrequentlyOrderedProduct',
  });

  factory Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$product = json['product'];
    final l$orderCount = json['orderCount'];
    final l$$__typename = json['__typename'];
    return Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts(
      product:
          Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product.fromJson(
            (l$product as Map<String, dynamic>),
          ),
      orderCount: (l$orderCount as int),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product
  product;

  final int orderCount;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$product = product;
    _resultData['product'] = l$product.toJson();
    final l$orderCount = orderCount;
    _resultData['orderCount'] = l$orderCount;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$product = product;
    final l$orderCount = orderCount;
    final l$$__typename = $__typename;
    return Object.hashAll([l$product, l$orderCount, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$product = product;
    final lOther$product = other.product;
    if (l$product != lOther$product) {
      return false;
    }
    final l$orderCount = orderCount;
    final lOther$orderCount = other.orderCount;
    if (l$orderCount != lOther$orderCount) {
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

extension UtilityExtension$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts
    on Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts {
  CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts<
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts
  >
  get copyWith =>
      CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts<
  TRes
> {
  factory CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts instance,
    TRes Function(Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts)
    then,
  ) = _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts;

  factory CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts;

  TRes call({
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product?
    product,
    int? orderCount,
    String? $__typename,
  });
  CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product<
    TRes
  >
  get product;
}

class _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts<
  TRes
>
    implements
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts<
          TRes
        > {
  _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts(
    this._instance,
    this._then,
  );

  final Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts _instance;

  final TRes Function(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? product = _undefined,
    Object? orderCount = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts(
      product: product == _undefined || product == null
          ? _instance.product
          : (product
                as Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product),
      orderCount: orderCount == _undefined || orderCount == null
          ? _instance.orderCount
          : (orderCount as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product<
    TRes
  >
  get product {
    final local$product = _instance.product;
    return CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product(
      local$product,
      (e) => call(product: e),
    );
  }
}

class _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts<
  TRes
>
    implements
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts<
          TRes
        > {
  _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts(
    this._res,
  );

  TRes _res;

  call({
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product?
    product,
    int? orderCount,
    String? $__typename,
  }) => _res;

  CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product<
    TRes
  >
  get product =>
      CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product.stub(
        _res,
      );
}

class Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product {
  Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product({
    required this.enabled,
    required this.id,
    required this.name,
    required this.slug,
    required this.variants,
    this.featuredAsset,
    this.$__typename = 'Product',
  });

  factory Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$enabled = json['enabled'];
    final l$id = json['id'];
    final l$name = json['name'];
    final l$slug = json['slug'];
    final l$variants = json['variants'];
    final l$featuredAsset = json['featuredAsset'];
    final l$$__typename = json['__typename'];
    return Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product(
      enabled: (l$enabled as bool),
      id: (l$id as String),
      name: (l$name as String),
      slug: (l$slug as String),
      variants: (l$variants as List<dynamic>)
          .map(
            (e) =>
                Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      featuredAsset: l$featuredAsset == null
          ? null
          : Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset.fromJson(
              (l$featuredAsset as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final bool enabled;

  final String id;

  final String name;

  final String slug;

  final List<
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
  >
  variants;

  final Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset?
  featuredAsset;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$slug = slug;
    _resultData['slug'] = l$slug;
    final l$variants = variants;
    _resultData['variants'] = l$variants.map((e) => e.toJson()).toList();
    final l$featuredAsset = featuredAsset;
    _resultData['featuredAsset'] = l$featuredAsset?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$enabled = enabled;
    final l$id = id;
    final l$name = name;
    final l$slug = slug;
    final l$variants = variants;
    final l$featuredAsset = featuredAsset;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$enabled,
      l$id,
      l$name,
      l$slug,
      Object.hashAll(l$variants.map((v) => v)),
      l$featuredAsset,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$enabled = enabled;
    final lOther$enabled = other.enabled;
    if (l$enabled != lOther$enabled) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product
    on Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product {
  CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product<
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product
  >
  get copyWith =>
      CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product<
  TRes
> {
  factory CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product
    instance,
    TRes Function(
      Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product,
    )
    then,
  ) = _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product;

  factory CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product;

  TRes call({
    bool? enabled,
    String? id,
    String? name,
    String? slug,
    List<
      Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
    >?
    variants,
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset?
    featuredAsset,
    String? $__typename,
  });
  TRes variants(
    Iterable<
      Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
    >
    Function(
      Iterable<
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants<
          Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset<
    TRes
  >
  get featuredAsset;
}

class _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product<
  TRes
>
    implements
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product<
          TRes
        > {
  _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product(
    this._instance,
    this._then,
  );

  final Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product
  _instance;

  final TRes Function(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? enabled = _undefined,
    Object? id = _undefined,
    Object? name = _undefined,
    Object? slug = _undefined,
    Object? variants = _undefined,
    Object? featuredAsset = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product(
      enabled: enabled == _undefined || enabled == null
          ? _instance.enabled
          : (enabled as bool),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      slug: slug == _undefined || slug == null
          ? _instance.slug
          : (slug as String),
      variants: variants == _undefined || variants == null
          ? _instance.variants
          : (variants
                as List<
                  Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
                >),
      featuredAsset: featuredAsset == _undefined
          ? _instance.featuredAsset
          : (featuredAsset
                as Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes variants(
    Iterable<
      Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
    >
    Function(
      Iterable<
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants<
          Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
        >
      >,
    )
    _fn,
  ) => call(
    variants: _fn(
      _instance.variants.map(
        (e) =>
            CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset<
    TRes
  >
  get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset.stub(
            _then(_instance),
          )
        : CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset(
            local$featuredAsset,
            (e) => call(featuredAsset: e),
          );
  }
}

class _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product<
  TRes
>
    implements
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product<
          TRes
        > {
  _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product(
    this._res,
  );

  TRes _res;

  call({
    bool? enabled,
    String? id,
    String? name,
    String? slug,
    List<
      Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
    >?
    variants,
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset?
    featuredAsset,
    String? $__typename,
  }) => _res;

  variants(_fn) => _res;

  CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset<
    TRes
  >
  get featuredAsset =>
      CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset.stub(
        _res,
      );
}

class Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants {
  Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants({
    required this.id,
    required this.name,
    required this.price,
    required this.priceWithTax,
    required this.currencyCode,
    this.$__typename = 'ProductVariant',
  });

  factory Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$price = json['price'];
    final l$priceWithTax = json['priceWithTax'];
    final l$currencyCode = json['currencyCode'];
    final l$$__typename = json['__typename'];
    return Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants(
      id: (l$id as String),
      name: (l$name as String),
      price: (l$price as num).toDouble(),
      priceWithTax: (l$priceWithTax as num).toDouble(),
      currencyCode: fromJson$Enum$CurrencyCode((l$currencyCode as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final double price;

  final double priceWithTax;

  final Enum$CurrencyCode currencyCode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$price = price;
    _resultData['price'] = l$price;
    final l$priceWithTax = priceWithTax;
    _resultData['priceWithTax'] = l$priceWithTax;
    final l$currencyCode = currencyCode;
    _resultData['currencyCode'] = toJson$Enum$CurrencyCode(l$currencyCode);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$price = price;
    final l$priceWithTax = priceWithTax;
    final l$currencyCode = currencyCode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$price,
      l$priceWithTax,
      l$currencyCode,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
    on Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants {
  CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants<
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
  >
  get copyWith =>
      CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants<
  TRes
> {
  factory CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
    instance,
    TRes Function(
      Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants,
    )
    then,
  ) = _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants;

  factory CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants;

  TRes call({
    String? id,
    String? name,
    double? price,
    double? priceWithTax,
    Enum$CurrencyCode? currencyCode,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants<
  TRes
>
    implements
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants<
          TRes
        > {
  _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants(
    this._instance,
    this._then,
  );

  final Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants
  _instance;

  final TRes Function(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? price = _undefined,
    Object? priceWithTax = _undefined,
    Object? currencyCode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      price: price == _undefined || price == null
          ? _instance.price
          : (price as double),
      priceWithTax: priceWithTax == _undefined || priceWithTax == null
          ? _instance.priceWithTax
          : (priceWithTax as double),
      currencyCode: currencyCode == _undefined || currencyCode == null
          ? _instance.currencyCode
          : (currencyCode as Enum$CurrencyCode),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants<
  TRes
>
    implements
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants<
          TRes
        > {
  _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    double? price,
    double? priceWithTax,
    Enum$CurrencyCode? currencyCode,
    String? $__typename,
  }) => _res;
}

class Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset {
  Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset({
    required this.preview,
    this.$__typename = 'Asset',
  });

  factory Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$preview = json['preview'];
    final l$$__typename = json['__typename'];
    return Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset(
      preview: (l$preview as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String preview;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$preview = preview;
    _resultData['preview'] = l$preview;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$preview = preview;
    final l$$__typename = $__typename;
    return Object.hashAll([l$preview, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset
    on
        Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset {
  CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset<
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset
  >
  get copyWith =>
      CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset<
  TRes
> {
  factory CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset
    instance,
    TRes Function(
      Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset,
    )
    then,
  ) = _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset;

  factory CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset;

  TRes call({String? preview, String? $__typename});
}

class _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset<
  TRes
>
    implements
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset<
          TRes
        > {
  _CopyWithImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset(
    this._instance,
    this._then,
  );

  final Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset
  _instance;

  final TRes Function(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? preview = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset(
      preview: preview == _undefined || preview == null
          ? _instance.preview
          : (preview as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset<
  TRes
>
    implements
        CopyWith$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset<
          TRes
        > {
  _CopyWithStubImpl$Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$featuredAsset(
    this._res,
  );

  TRes _res;

  call({String? preview, String? $__typename}) => _res;
}
