import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Query$LoyaltyPointsConfig {
  Query$LoyaltyPointsConfig({
    this.loyaltyPointsConfig,
    this.$__typename = 'Query',
  });

  factory Query$LoyaltyPointsConfig.fromJson(Map<String, dynamic> json) {
    final l$loyaltyPointsConfig = json['loyaltyPointsConfig'];
    final l$$__typename = json['__typename'];
    return Query$LoyaltyPointsConfig(
      loyaltyPointsConfig: l$loyaltyPointsConfig == null
          ? null
          : Query$LoyaltyPointsConfig$loyaltyPointsConfig.fromJson(
              (l$loyaltyPointsConfig as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$LoyaltyPointsConfig$loyaltyPointsConfig? loyaltyPointsConfig;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$loyaltyPointsConfig = loyaltyPointsConfig;
    _resultData['loyaltyPointsConfig'] = l$loyaltyPointsConfig?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$loyaltyPointsConfig = loyaltyPointsConfig;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$loyaltyPointsConfig,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$LoyaltyPointsConfig ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$loyaltyPointsConfig = loyaltyPointsConfig;
    final lOther$loyaltyPointsConfig = other.loyaltyPointsConfig;
    if (l$loyaltyPointsConfig != lOther$loyaltyPointsConfig) {
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

extension UtilityExtension$Query$LoyaltyPointsConfig
    on Query$LoyaltyPointsConfig {
  CopyWith$Query$LoyaltyPointsConfig<Query$LoyaltyPointsConfig> get copyWith =>
      CopyWith$Query$LoyaltyPointsConfig(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$LoyaltyPointsConfig<TRes> {
  factory CopyWith$Query$LoyaltyPointsConfig(
    Query$LoyaltyPointsConfig instance,
    TRes Function(Query$LoyaltyPointsConfig) then,
  ) = _CopyWithImpl$Query$LoyaltyPointsConfig;

  factory CopyWith$Query$LoyaltyPointsConfig.stub(TRes res) =
      _CopyWithStubImpl$Query$LoyaltyPointsConfig;

  TRes call({
    Query$LoyaltyPointsConfig$loyaltyPointsConfig? loyaltyPointsConfig,
    String? $__typename,
  });
  CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig<TRes>
      get loyaltyPointsConfig;
}

class _CopyWithImpl$Query$LoyaltyPointsConfig<TRes>
    implements CopyWith$Query$LoyaltyPointsConfig<TRes> {
  _CopyWithImpl$Query$LoyaltyPointsConfig(
    this._instance,
    this._then,
  );

  final Query$LoyaltyPointsConfig _instance;

  final TRes Function(Query$LoyaltyPointsConfig) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? loyaltyPointsConfig = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$LoyaltyPointsConfig(
        loyaltyPointsConfig: loyaltyPointsConfig == _undefined
            ? _instance.loyaltyPointsConfig
            : (loyaltyPointsConfig
                as Query$LoyaltyPointsConfig$loyaltyPointsConfig?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig<TRes>
      get loyaltyPointsConfig {
    final local$loyaltyPointsConfig = _instance.loyaltyPointsConfig;
    return local$loyaltyPointsConfig == null
        ? CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig.stub(
            _then(_instance))
        : CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig(
            local$loyaltyPointsConfig, (e) => call(loyaltyPointsConfig: e));
  }
}

class _CopyWithStubImpl$Query$LoyaltyPointsConfig<TRes>
    implements CopyWith$Query$LoyaltyPointsConfig<TRes> {
  _CopyWithStubImpl$Query$LoyaltyPointsConfig(this._res);

  TRes _res;

  call({
    Query$LoyaltyPointsConfig$loyaltyPointsConfig? loyaltyPointsConfig,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig<TRes>
      get loyaltyPointsConfig =>
          CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig.stub(_res);
}

const documentNodeQueryLoyaltyPointsConfig = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'LoyaltyPointsConfig'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'loyaltyPointsConfig'),
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
            name: NameNode(value: 'createdAt'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'updatedAt'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'rupeesPerPoint'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'pointsPerRupee'),
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
]);
Query$LoyaltyPointsConfig _parserFn$Query$LoyaltyPointsConfig(
        Map<String, dynamic> data) =>
    Query$LoyaltyPointsConfig.fromJson(data);
typedef OnQueryComplete$Query$LoyaltyPointsConfig = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$LoyaltyPointsConfig?,
);

class Options$Query$LoyaltyPointsConfig
    extends graphql.QueryOptions<Query$LoyaltyPointsConfig> {
  Options$Query$LoyaltyPointsConfig({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$LoyaltyPointsConfig? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$LoyaltyPointsConfig? onComplete,
    graphql.OnQueryError? onError,
  })  : onCompleteWithParsed = onComplete,
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
                        : _parserFn$Query$LoyaltyPointsConfig(data),
                  ),
          onError: onError,
          document: documentNodeQueryLoyaltyPointsConfig,
          parserFn: _parserFn$Query$LoyaltyPointsConfig,
        );

  final OnQueryComplete$Query$LoyaltyPointsConfig? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$LoyaltyPointsConfig
    extends graphql.WatchQueryOptions<Query$LoyaltyPointsConfig> {
  WatchOptions$Query$LoyaltyPointsConfig({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$LoyaltyPointsConfig? typedOptimisticResult,
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
          document: documentNodeQueryLoyaltyPointsConfig,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$LoyaltyPointsConfig,
        );
}

class FetchMoreOptions$Query$LoyaltyPointsConfig
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$LoyaltyPointsConfig(
      {required graphql.UpdateQuery updateQuery})
      : super(
          updateQuery: updateQuery,
          document: documentNodeQueryLoyaltyPointsConfig,
        );
}

extension ClientExtension$Query$LoyaltyPointsConfig on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$LoyaltyPointsConfig>>
      query$LoyaltyPointsConfig(
              [Options$Query$LoyaltyPointsConfig? options]) async =>
          await this.query(options ?? Options$Query$LoyaltyPointsConfig());

  graphql.ObservableQuery<Query$LoyaltyPointsConfig>
      watchQuery$LoyaltyPointsConfig(
              [WatchOptions$Query$LoyaltyPointsConfig? options]) =>
          this.watchQuery(options ?? WatchOptions$Query$LoyaltyPointsConfig());

  void writeQuery$LoyaltyPointsConfig({
    required Query$LoyaltyPointsConfig data,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
            operation: graphql.Operation(
                document: documentNodeQueryLoyaltyPointsConfig)),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$LoyaltyPointsConfig? readQuery$LoyaltyPointsConfig(
      {bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
          operation: graphql.Operation(
              document: documentNodeQueryLoyaltyPointsConfig)),
      optimistic: optimistic,
    );
    return result == null ? null : Query$LoyaltyPointsConfig.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$LoyaltyPointsConfig>
    useQuery$LoyaltyPointsConfig(
            [Options$Query$LoyaltyPointsConfig? options]) =>
        graphql_flutter
            .useQuery(options ?? Options$Query$LoyaltyPointsConfig());
graphql.ObservableQuery<Query$LoyaltyPointsConfig>
    useWatchQuery$LoyaltyPointsConfig(
            [WatchOptions$Query$LoyaltyPointsConfig? options]) =>
        graphql_flutter
            .useWatchQuery(options ?? WatchOptions$Query$LoyaltyPointsConfig());

class Query$LoyaltyPointsConfig$Widget
    extends graphql_flutter.Query<Query$LoyaltyPointsConfig> {
  Query$LoyaltyPointsConfig$Widget({
    widgets.Key? key,
    Options$Query$LoyaltyPointsConfig? options,
    required graphql_flutter.QueryBuilder<Query$LoyaltyPointsConfig> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$LoyaltyPointsConfig(),
          builder: builder,
        );
}

class Query$LoyaltyPointsConfig$loyaltyPointsConfig {
  Query$LoyaltyPointsConfig$loyaltyPointsConfig({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.rupeesPerPoint,
    required this.pointsPerRupee,
    this.$__typename = 'LoyaltyPointsConfig',
  });

  factory Query$LoyaltyPointsConfig$loyaltyPointsConfig.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$createdAt = json['createdAt'];
    final l$updatedAt = json['updatedAt'];
    final l$rupeesPerPoint = json['rupeesPerPoint'];
    final l$pointsPerRupee = json['pointsPerRupee'];
    final l$$__typename = json['__typename'];
    return Query$LoyaltyPointsConfig$loyaltyPointsConfig(
      id: (l$id as String),
      createdAt: DateTime.parse((l$createdAt as String)),
      updatedAt: DateTime.parse((l$updatedAt as String)),
      rupeesPerPoint: (l$rupeesPerPoint as int),
      pointsPerRupee: (l$pointsPerRupee as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final DateTime createdAt;

  final DateTime updatedAt;

  final int rupeesPerPoint;

  final int pointsPerRupee;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$updatedAt = updatedAt;
    _resultData['updatedAt'] = l$updatedAt.toIso8601String();
    final l$rupeesPerPoint = rupeesPerPoint;
    _resultData['rupeesPerPoint'] = l$rupeesPerPoint;
    final l$pointsPerRupee = pointsPerRupee;
    _resultData['pointsPerRupee'] = l$pointsPerRupee;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$createdAt = createdAt;
    final l$updatedAt = updatedAt;
    final l$rupeesPerPoint = rupeesPerPoint;
    final l$pointsPerRupee = pointsPerRupee;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$createdAt,
      l$updatedAt,
      l$rupeesPerPoint,
      l$pointsPerRupee,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$LoyaltyPointsConfig$loyaltyPointsConfig ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$updatedAt = updatedAt;
    final lOther$updatedAt = other.updatedAt;
    if (l$updatedAt != lOther$updatedAt) {
      return false;
    }
    final l$rupeesPerPoint = rupeesPerPoint;
    final lOther$rupeesPerPoint = other.rupeesPerPoint;
    if (l$rupeesPerPoint != lOther$rupeesPerPoint) {
      return false;
    }
    final l$pointsPerRupee = pointsPerRupee;
    final lOther$pointsPerRupee = other.pointsPerRupee;
    if (l$pointsPerRupee != lOther$pointsPerRupee) {
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

extension UtilityExtension$Query$LoyaltyPointsConfig$loyaltyPointsConfig
    on Query$LoyaltyPointsConfig$loyaltyPointsConfig {
  CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig<
          Query$LoyaltyPointsConfig$loyaltyPointsConfig>
      get copyWith => CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig<TRes> {
  factory CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig(
    Query$LoyaltyPointsConfig$loyaltyPointsConfig instance,
    TRes Function(Query$LoyaltyPointsConfig$loyaltyPointsConfig) then,
  ) = _CopyWithImpl$Query$LoyaltyPointsConfig$loyaltyPointsConfig;

  factory CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig.stub(
          TRes res) =
      _CopyWithStubImpl$Query$LoyaltyPointsConfig$loyaltyPointsConfig;

  TRes call({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? rupeesPerPoint,
    int? pointsPerRupee,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$LoyaltyPointsConfig$loyaltyPointsConfig<TRes>
    implements CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig<TRes> {
  _CopyWithImpl$Query$LoyaltyPointsConfig$loyaltyPointsConfig(
    this._instance,
    this._then,
  );

  final Query$LoyaltyPointsConfig$loyaltyPointsConfig _instance;

  final TRes Function(Query$LoyaltyPointsConfig$loyaltyPointsConfig) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? createdAt = _undefined,
    Object? updatedAt = _undefined,
    Object? rupeesPerPoint = _undefined,
    Object? pointsPerRupee = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$LoyaltyPointsConfig$loyaltyPointsConfig(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        updatedAt: updatedAt == _undefined || updatedAt == null
            ? _instance.updatedAt
            : (updatedAt as DateTime),
        rupeesPerPoint: rupeesPerPoint == _undefined || rupeesPerPoint == null
            ? _instance.rupeesPerPoint
            : (rupeesPerPoint as int),
        pointsPerRupee: pointsPerRupee == _undefined || pointsPerRupee == null
            ? _instance.pointsPerRupee
            : (pointsPerRupee as int),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$LoyaltyPointsConfig$loyaltyPointsConfig<TRes>
    implements CopyWith$Query$LoyaltyPointsConfig$loyaltyPointsConfig<TRes> {
  _CopyWithStubImpl$Query$LoyaltyPointsConfig$loyaltyPointsConfig(this._res);

  TRes _res;

  call({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? rupeesPerPoint,
    int? pointsPerRupee,
    String? $__typename,
  }) =>
      _res;
}
