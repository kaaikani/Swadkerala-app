import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Variables$Query$MyReferrals {
  factory Variables$Query$MyReferrals({
    int? take,
    int? skip,
    Enum$ReferralStatus? status,
  }) =>
      Variables$Query$MyReferrals._({
        if (take != null) r'take': take,
        if (skip != null) r'skip': skip,
        if (status != null) r'status': status,
      });

  Variables$Query$MyReferrals._(this._$data);

  factory Variables$Query$MyReferrals.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('take')) {
      final l$take = data['take'];
      result$data['take'] = (l$take as int?);
    }
    if (data.containsKey('skip')) {
      final l$skip = data['skip'];
      result$data['skip'] = (l$skip as int?);
    }
    if (data.containsKey('status')) {
      final l$status = data['status'];
      result$data['status'] = l$status == null
          ? null
          : fromJson$Enum$ReferralStatus((l$status as String));
    }
    return Variables$Query$MyReferrals._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get take => (_$data['take'] as int?);

  int? get skip => (_$data['skip'] as int?);

  Enum$ReferralStatus? get status => (_$data['status'] as Enum$ReferralStatus?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('take')) {
      final l$take = take;
      result$data['take'] = l$take;
    }
    if (_$data.containsKey('skip')) {
      final l$skip = skip;
      result$data['skip'] = l$skip;
    }
    if (_$data.containsKey('status')) {
      final l$status = status;
      result$data['status'] =
          l$status == null ? null : toJson$Enum$ReferralStatus(l$status);
    }
    return result$data;
  }

  CopyWith$Variables$Query$MyReferrals<Variables$Query$MyReferrals>
      get copyWith => CopyWith$Variables$Query$MyReferrals(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$MyReferrals ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$take = take;
    final lOther$take = other.take;
    if (_$data.containsKey('take') != other._$data.containsKey('take')) {
      return false;
    }
    if (l$take != lOther$take) {
      return false;
    }
    final l$skip = skip;
    final lOther$skip = other.skip;
    if (_$data.containsKey('skip') != other._$data.containsKey('skip')) {
      return false;
    }
    if (l$skip != lOther$skip) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (_$data.containsKey('status') != other._$data.containsKey('status')) {
      return false;
    }
    if (l$status != lOther$status) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$take = take;
    final l$skip = skip;
    final l$status = status;
    return Object.hashAll([
      _$data.containsKey('take') ? l$take : const {},
      _$data.containsKey('skip') ? l$skip : const {},
      _$data.containsKey('status') ? l$status : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$MyReferrals<TRes> {
  factory CopyWith$Variables$Query$MyReferrals(
    Variables$Query$MyReferrals instance,
    TRes Function(Variables$Query$MyReferrals) then,
  ) = _CopyWithImpl$Variables$Query$MyReferrals;

  factory CopyWith$Variables$Query$MyReferrals.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$MyReferrals;

  TRes call({
    int? take,
    int? skip,
    Enum$ReferralStatus? status,
  });
}

class _CopyWithImpl$Variables$Query$MyReferrals<TRes>
    implements CopyWith$Variables$Query$MyReferrals<TRes> {
  _CopyWithImpl$Variables$Query$MyReferrals(
    this._instance,
    this._then,
  );

  final Variables$Query$MyReferrals _instance;

  final TRes Function(Variables$Query$MyReferrals) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? take = _undefined,
    Object? skip = _undefined,
    Object? status = _undefined,
  }) =>
      _then(Variables$Query$MyReferrals._({
        ..._instance._$data,
        if (take != _undefined) 'take': (take as int?),
        if (skip != _undefined) 'skip': (skip as int?),
        if (status != _undefined) 'status': (status as Enum$ReferralStatus?),
      }));
}

class _CopyWithStubImpl$Variables$Query$MyReferrals<TRes>
    implements CopyWith$Variables$Query$MyReferrals<TRes> {
  _CopyWithStubImpl$Variables$Query$MyReferrals(this._res);

  TRes _res;

  call({
    int? take,
    int? skip,
    Enum$ReferralStatus? status,
  }) =>
      _res;
}

class Query$MyReferrals {
  Query$MyReferrals({
    required this.myReferrals,
    this.$__typename = 'Query',
  });

  factory Query$MyReferrals.fromJson(Map<String, dynamic> json) {
    final l$myReferrals = json['myReferrals'];
    final l$$__typename = json['__typename'];
    return Query$MyReferrals(
      myReferrals: Query$MyReferrals$myReferrals.fromJson(
          (l$myReferrals as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$MyReferrals$myReferrals myReferrals;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$myReferrals = myReferrals;
    _resultData['myReferrals'] = l$myReferrals.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$myReferrals = myReferrals;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$myReferrals,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MyReferrals || runtimeType != other.runtimeType) {
      return false;
    }
    final l$myReferrals = myReferrals;
    final lOther$myReferrals = other.myReferrals;
    if (l$myReferrals != lOther$myReferrals) {
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

extension UtilityExtension$Query$MyReferrals on Query$MyReferrals {
  CopyWith$Query$MyReferrals<Query$MyReferrals> get copyWith =>
      CopyWith$Query$MyReferrals(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$MyReferrals<TRes> {
  factory CopyWith$Query$MyReferrals(
    Query$MyReferrals instance,
    TRes Function(Query$MyReferrals) then,
  ) = _CopyWithImpl$Query$MyReferrals;

  factory CopyWith$Query$MyReferrals.stub(TRes res) =
      _CopyWithStubImpl$Query$MyReferrals;

  TRes call({
    Query$MyReferrals$myReferrals? myReferrals,
    String? $__typename,
  });
  CopyWith$Query$MyReferrals$myReferrals<TRes> get myReferrals;
}

class _CopyWithImpl$Query$MyReferrals<TRes>
    implements CopyWith$Query$MyReferrals<TRes> {
  _CopyWithImpl$Query$MyReferrals(
    this._instance,
    this._then,
  );

  final Query$MyReferrals _instance;

  final TRes Function(Query$MyReferrals) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? myReferrals = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$MyReferrals(
        myReferrals: myReferrals == _undefined || myReferrals == null
            ? _instance.myReferrals
            : (myReferrals as Query$MyReferrals$myReferrals),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$MyReferrals$myReferrals<TRes> get myReferrals {
    final local$myReferrals = _instance.myReferrals;
    return CopyWith$Query$MyReferrals$myReferrals(
        local$myReferrals, (e) => call(myReferrals: e));
  }
}

class _CopyWithStubImpl$Query$MyReferrals<TRes>
    implements CopyWith$Query$MyReferrals<TRes> {
  _CopyWithStubImpl$Query$MyReferrals(this._res);

  TRes _res;

  call({
    Query$MyReferrals$myReferrals? myReferrals,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$MyReferrals$myReferrals<TRes> get myReferrals =>
      CopyWith$Query$MyReferrals$myReferrals.stub(_res);
}

const documentNodeQueryMyReferrals = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'MyReferrals'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'take')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'skip')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'status')),
        type: NamedTypeNode(
          name: NameNode(value: 'ReferralStatus'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'myReferrals'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'take'),
            value: VariableNode(name: NameNode(value: 'take')),
          ),
          ArgumentNode(
            name: NameNode(value: 'skip'),
            value: VariableNode(name: NameNode(value: 'skip')),
          ),
          ArgumentNode(
            name: NameNode(value: 'status'),
            value: VariableNode(name: NameNode(value: 'status')),
          ),
        ],
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
                name: NameNode(value: 'referralNumber'),
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
                name: NameNode(value: 'referredCustomer'),
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
                    name: NameNode(value: 'firstName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'lastName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'emailAddress'),
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
                name: NameNode(value: 'order'),
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
                    name: NameNode(value: 'state'),
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
                name: NameNode(value: 'status'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'points'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'isScratched'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'note'),
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
]);
Query$MyReferrals _parserFn$Query$MyReferrals(Map<String, dynamic> data) =>
    Query$MyReferrals.fromJson(data);
typedef OnQueryComplete$Query$MyReferrals = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$MyReferrals?,
);

class Options$Query$MyReferrals
    extends graphql.QueryOptions<Query$MyReferrals> {
  Options$Query$MyReferrals({
    String? operationName,
    Variables$Query$MyReferrals? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$MyReferrals? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$MyReferrals? onComplete,
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
                    data == null ? null : _parserFn$Query$MyReferrals(data),
                  ),
          onError: onError,
          document: documentNodeQueryMyReferrals,
          parserFn: _parserFn$Query$MyReferrals,
        );

  final OnQueryComplete$Query$MyReferrals? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$MyReferrals
    extends graphql.WatchQueryOptions<Query$MyReferrals> {
  WatchOptions$Query$MyReferrals({
    String? operationName,
    Variables$Query$MyReferrals? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$MyReferrals? typedOptimisticResult,
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
          document: documentNodeQueryMyReferrals,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$MyReferrals,
        );
}

class FetchMoreOptions$Query$MyReferrals extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$MyReferrals({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$MyReferrals? variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables?.toJson() ?? {},
          document: documentNodeQueryMyReferrals,
        );
}

extension ClientExtension$Query$MyReferrals on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$MyReferrals>> query$MyReferrals(
          [Options$Query$MyReferrals? options]) async =>
      await this.query(options ?? Options$Query$MyReferrals());
  graphql.ObservableQuery<Query$MyReferrals> watchQuery$MyReferrals(
          [WatchOptions$Query$MyReferrals? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$MyReferrals());
  void writeQuery$MyReferrals({
    required Query$MyReferrals data,
    Variables$Query$MyReferrals? variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryMyReferrals),
          variables: variables?.toJson() ?? const {},
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$MyReferrals? readQuery$MyReferrals({
    Variables$Query$MyReferrals? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMyReferrals),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$MyReferrals.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$MyReferrals> useQuery$MyReferrals(
        [Options$Query$MyReferrals? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$MyReferrals());
graphql.ObservableQuery<Query$MyReferrals> useWatchQuery$MyReferrals(
        [WatchOptions$Query$MyReferrals? options]) =>
    graphql_flutter.useWatchQuery(options ?? WatchOptions$Query$MyReferrals());

class Query$MyReferrals$Widget
    extends graphql_flutter.Query<Query$MyReferrals> {
  Query$MyReferrals$Widget({
    widgets.Key? key,
    Options$Query$MyReferrals? options,
    required graphql_flutter.QueryBuilder<Query$MyReferrals> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$MyReferrals(),
          builder: builder,
        );
}

class Query$MyReferrals$myReferrals {
  Query$MyReferrals$myReferrals({
    required this.totalItems,
    required this.items,
    this.$__typename = 'ReferralList',
  });

  factory Query$MyReferrals$myReferrals.fromJson(Map<String, dynamic> json) {
    final l$totalItems = json['totalItems'];
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Query$MyReferrals$myReferrals(
      totalItems: (l$totalItems as int),
      items: (l$items as List<dynamic>)
          .map((e) => Query$MyReferrals$myReferrals$items.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int totalItems;

  final List<Query$MyReferrals$myReferrals$items> items;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$totalItems = totalItems;
    _resultData['totalItems'] = l$totalItems;
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$totalItems = totalItems;
    final l$items = items;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$totalItems,
      Object.hashAll(l$items.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MyReferrals$myReferrals ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$totalItems = totalItems;
    final lOther$totalItems = other.totalItems;
    if (l$totalItems != lOther$totalItems) {
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

extension UtilityExtension$Query$MyReferrals$myReferrals
    on Query$MyReferrals$myReferrals {
  CopyWith$Query$MyReferrals$myReferrals<Query$MyReferrals$myReferrals>
      get copyWith => CopyWith$Query$MyReferrals$myReferrals(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$MyReferrals$myReferrals<TRes> {
  factory CopyWith$Query$MyReferrals$myReferrals(
    Query$MyReferrals$myReferrals instance,
    TRes Function(Query$MyReferrals$myReferrals) then,
  ) = _CopyWithImpl$Query$MyReferrals$myReferrals;

  factory CopyWith$Query$MyReferrals$myReferrals.stub(TRes res) =
      _CopyWithStubImpl$Query$MyReferrals$myReferrals;

  TRes call({
    int? totalItems,
    List<Query$MyReferrals$myReferrals$items>? items,
    String? $__typename,
  });
  TRes items(
      Iterable<Query$MyReferrals$myReferrals$items> Function(
              Iterable<
                  CopyWith$Query$MyReferrals$myReferrals$items<
                      Query$MyReferrals$myReferrals$items>>)
          _fn);
}

class _CopyWithImpl$Query$MyReferrals$myReferrals<TRes>
    implements CopyWith$Query$MyReferrals$myReferrals<TRes> {
  _CopyWithImpl$Query$MyReferrals$myReferrals(
    this._instance,
    this._then,
  );

  final Query$MyReferrals$myReferrals _instance;

  final TRes Function(Query$MyReferrals$myReferrals) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? totalItems = _undefined,
    Object? items = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$MyReferrals$myReferrals(
        totalItems: totalItems == _undefined || totalItems == null
            ? _instance.totalItems
            : (totalItems as int),
        items: items == _undefined || items == null
            ? _instance.items
            : (items as List<Query$MyReferrals$myReferrals$items>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes items(
          Iterable<Query$MyReferrals$myReferrals$items> Function(
                  Iterable<
                      CopyWith$Query$MyReferrals$myReferrals$items<
                          Query$MyReferrals$myReferrals$items>>)
              _fn) =>
      call(
          items: _fn(_instance.items
              .map((e) => CopyWith$Query$MyReferrals$myReferrals$items(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$MyReferrals$myReferrals<TRes>
    implements CopyWith$Query$MyReferrals$myReferrals<TRes> {
  _CopyWithStubImpl$Query$MyReferrals$myReferrals(this._res);

  TRes _res;

  call({
    int? totalItems,
    List<Query$MyReferrals$myReferrals$items>? items,
    String? $__typename,
  }) =>
      _res;

  items(_fn) => _res;
}

class Query$MyReferrals$myReferrals$items {
  Query$MyReferrals$myReferrals$items({
    required this.id,
    required this.referralNumber,
    required this.createdAt,
    required this.referredCustomer,
    this.order,
    required this.status,
    required this.points,
    required this.isScratched,
    this.note,
    this.$__typename = 'Referral',
  });

  factory Query$MyReferrals$myReferrals$items.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$referralNumber = json['referralNumber'];
    final l$createdAt = json['createdAt'];
    final l$referredCustomer = json['referredCustomer'];
    final l$order = json['order'];
    final l$status = json['status'];
    final l$points = json['points'];
    final l$isScratched = json['isScratched'];
    final l$note = json['note'];
    final l$$__typename = json['__typename'];
    return Query$MyReferrals$myReferrals$items(
      id: (l$id as String),
      referralNumber: (l$referralNumber as int),
      createdAt: DateTime.parse((l$createdAt as String)),
      referredCustomer:
          Query$MyReferrals$myReferrals$items$referredCustomer.fromJson(
              (l$referredCustomer as Map<String, dynamic>)),
      order: l$order == null
          ? null
          : Query$MyReferrals$myReferrals$items$order.fromJson(
              (l$order as Map<String, dynamic>)),
      status: fromJson$Enum$ReferralStatus((l$status as String)),
      points: (l$points as int),
      isScratched: (l$isScratched as bool),
      note: (l$note as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int referralNumber;

  final DateTime createdAt;

  final Query$MyReferrals$myReferrals$items$referredCustomer referredCustomer;

  final Query$MyReferrals$myReferrals$items$order? order;

  final Enum$ReferralStatus status;

  final int points;

  final bool isScratched;

  final String? note;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$referralNumber = referralNumber;
    _resultData['referralNumber'] = l$referralNumber;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$referredCustomer = referredCustomer;
    _resultData['referredCustomer'] = l$referredCustomer.toJson();
    final l$order = order;
    _resultData['order'] = l$order?.toJson();
    final l$status = status;
    _resultData['status'] = toJson$Enum$ReferralStatus(l$status);
    final l$points = points;
    _resultData['points'] = l$points;
    final l$isScratched = isScratched;
    _resultData['isScratched'] = l$isScratched;
    final l$note = note;
    _resultData['note'] = l$note;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$referralNumber = referralNumber;
    final l$createdAt = createdAt;
    final l$referredCustomer = referredCustomer;
    final l$order = order;
    final l$status = status;
    final l$points = points;
    final l$isScratched = isScratched;
    final l$note = note;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$referralNumber,
      l$createdAt,
      l$referredCustomer,
      l$order,
      l$status,
      l$points,
      l$isScratched,
      l$note,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MyReferrals$myReferrals$items ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$referralNumber = referralNumber;
    final lOther$referralNumber = other.referralNumber;
    if (l$referralNumber != lOther$referralNumber) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$referredCustomer = referredCustomer;
    final lOther$referredCustomer = other.referredCustomer;
    if (l$referredCustomer != lOther$referredCustomer) {
      return false;
    }
    final l$order = order;
    final lOther$order = other.order;
    if (l$order != lOther$order) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$points = points;
    final lOther$points = other.points;
    if (l$points != lOther$points) {
      return false;
    }
    final l$isScratched = isScratched;
    final lOther$isScratched = other.isScratched;
    if (l$isScratched != lOther$isScratched) {
      return false;
    }
    final l$note = note;
    final lOther$note = other.note;
    if (l$note != lOther$note) {
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

extension UtilityExtension$Query$MyReferrals$myReferrals$items
    on Query$MyReferrals$myReferrals$items {
  CopyWith$Query$MyReferrals$myReferrals$items<
          Query$MyReferrals$myReferrals$items>
      get copyWith => CopyWith$Query$MyReferrals$myReferrals$items(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$MyReferrals$myReferrals$items<TRes> {
  factory CopyWith$Query$MyReferrals$myReferrals$items(
    Query$MyReferrals$myReferrals$items instance,
    TRes Function(Query$MyReferrals$myReferrals$items) then,
  ) = _CopyWithImpl$Query$MyReferrals$myReferrals$items;

  factory CopyWith$Query$MyReferrals$myReferrals$items.stub(TRes res) =
      _CopyWithStubImpl$Query$MyReferrals$myReferrals$items;

  TRes call({
    String? id,
    int? referralNumber,
    DateTime? createdAt,
    Query$MyReferrals$myReferrals$items$referredCustomer? referredCustomer,
    Query$MyReferrals$myReferrals$items$order? order,
    Enum$ReferralStatus? status,
    int? points,
    bool? isScratched,
    String? note,
    String? $__typename,
  });
  CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer<TRes>
      get referredCustomer;
  CopyWith$Query$MyReferrals$myReferrals$items$order<TRes> get order;
}

class _CopyWithImpl$Query$MyReferrals$myReferrals$items<TRes>
    implements CopyWith$Query$MyReferrals$myReferrals$items<TRes> {
  _CopyWithImpl$Query$MyReferrals$myReferrals$items(
    this._instance,
    this._then,
  );

  final Query$MyReferrals$myReferrals$items _instance;

  final TRes Function(Query$MyReferrals$myReferrals$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? referralNumber = _undefined,
    Object? createdAt = _undefined,
    Object? referredCustomer = _undefined,
    Object? order = _undefined,
    Object? status = _undefined,
    Object? points = _undefined,
    Object? isScratched = _undefined,
    Object? note = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$MyReferrals$myReferrals$items(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        referralNumber: referralNumber == _undefined || referralNumber == null
            ? _instance.referralNumber
            : (referralNumber as int),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        referredCustomer:
            referredCustomer == _undefined || referredCustomer == null
                ? _instance.referredCustomer
                : (referredCustomer
                    as Query$MyReferrals$myReferrals$items$referredCustomer),
        order: order == _undefined
            ? _instance.order
            : (order as Query$MyReferrals$myReferrals$items$order?),
        status: status == _undefined || status == null
            ? _instance.status
            : (status as Enum$ReferralStatus),
        points: points == _undefined || points == null
            ? _instance.points
            : (points as int),
        isScratched: isScratched == _undefined || isScratched == null
            ? _instance.isScratched
            : (isScratched as bool),
        note: note == _undefined ? _instance.note : (note as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer<TRes>
      get referredCustomer {
    final local$referredCustomer = _instance.referredCustomer;
    return CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer(
        local$referredCustomer, (e) => call(referredCustomer: e));
  }

  CopyWith$Query$MyReferrals$myReferrals$items$order<TRes> get order {
    final local$order = _instance.order;
    return local$order == null
        ? CopyWith$Query$MyReferrals$myReferrals$items$order.stub(
            _then(_instance))
        : CopyWith$Query$MyReferrals$myReferrals$items$order(
            local$order, (e) => call(order: e));
  }
}

class _CopyWithStubImpl$Query$MyReferrals$myReferrals$items<TRes>
    implements CopyWith$Query$MyReferrals$myReferrals$items<TRes> {
  _CopyWithStubImpl$Query$MyReferrals$myReferrals$items(this._res);

  TRes _res;

  call({
    String? id,
    int? referralNumber,
    DateTime? createdAt,
    Query$MyReferrals$myReferrals$items$referredCustomer? referredCustomer,
    Query$MyReferrals$myReferrals$items$order? order,
    Enum$ReferralStatus? status,
    int? points,
    bool? isScratched,
    String? note,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer<TRes>
      get referredCustomer =>
          CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer.stub(
              _res);

  CopyWith$Query$MyReferrals$myReferrals$items$order<TRes> get order =>
      CopyWith$Query$MyReferrals$myReferrals$items$order.stub(_res);
}

class Query$MyReferrals$myReferrals$items$referredCustomer {
  Query$MyReferrals$myReferrals$items$referredCustomer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    this.$__typename = 'Customer',
  });

  factory Query$MyReferrals$myReferrals$items$referredCustomer.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$emailAddress = json['emailAddress'];
    final l$$__typename = json['__typename'];
    return Query$MyReferrals$myReferrals$items$referredCustomer(
      id: (l$id as String),
      firstName: (l$firstName as String),
      lastName: (l$lastName as String),
      emailAddress: (l$emailAddress as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String firstName;

  final String lastName;

  final String emailAddress;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$firstName = firstName;
    _resultData['firstName'] = l$firstName;
    final l$lastName = lastName;
    _resultData['lastName'] = l$lastName;
    final l$emailAddress = emailAddress;
    _resultData['emailAddress'] = l$emailAddress;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$firstName = firstName;
    final l$lastName = lastName;
    final l$emailAddress = emailAddress;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$firstName,
      l$lastName,
      l$emailAddress,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MyReferrals$myReferrals$items$referredCustomer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$firstName = firstName;
    final lOther$firstName = other.firstName;
    if (l$firstName != lOther$firstName) {
      return false;
    }
    final l$lastName = lastName;
    final lOther$lastName = other.lastName;
    if (l$lastName != lOther$lastName) {
      return false;
    }
    final l$emailAddress = emailAddress;
    final lOther$emailAddress = other.emailAddress;
    if (l$emailAddress != lOther$emailAddress) {
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

extension UtilityExtension$Query$MyReferrals$myReferrals$items$referredCustomer
    on Query$MyReferrals$myReferrals$items$referredCustomer {
  CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer<
          Query$MyReferrals$myReferrals$items$referredCustomer>
      get copyWith =>
          CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer<
    TRes> {
  factory CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer(
    Query$MyReferrals$myReferrals$items$referredCustomer instance,
    TRes Function(Query$MyReferrals$myReferrals$items$referredCustomer) then,
  ) = _CopyWithImpl$Query$MyReferrals$myReferrals$items$referredCustomer;

  factory CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer.stub(
          TRes res) =
      _CopyWithStubImpl$Query$MyReferrals$myReferrals$items$referredCustomer;

  TRes call({
    String? id,
    String? firstName,
    String? lastName,
    String? emailAddress,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$MyReferrals$myReferrals$items$referredCustomer<TRes>
    implements
        CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer<TRes> {
  _CopyWithImpl$Query$MyReferrals$myReferrals$items$referredCustomer(
    this._instance,
    this._then,
  );

  final Query$MyReferrals$myReferrals$items$referredCustomer _instance;

  final TRes Function(Query$MyReferrals$myReferrals$items$referredCustomer)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? emailAddress = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$MyReferrals$myReferrals$items$referredCustomer(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        firstName: firstName == _undefined || firstName == null
            ? _instance.firstName
            : (firstName as String),
        lastName: lastName == _undefined || lastName == null
            ? _instance.lastName
            : (lastName as String),
        emailAddress: emailAddress == _undefined || emailAddress == null
            ? _instance.emailAddress
            : (emailAddress as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$MyReferrals$myReferrals$items$referredCustomer<
        TRes>
    implements
        CopyWith$Query$MyReferrals$myReferrals$items$referredCustomer<TRes> {
  _CopyWithStubImpl$Query$MyReferrals$myReferrals$items$referredCustomer(
      this._res);

  TRes _res;

  call({
    String? id,
    String? firstName,
    String? lastName,
    String? emailAddress,
    String? $__typename,
  }) =>
      _res;
}

class Query$MyReferrals$myReferrals$items$order {
  Query$MyReferrals$myReferrals$items$order({
    required this.id,
    required this.code,
    required this.state,
    this.$__typename = 'Order',
  });

  factory Query$MyReferrals$myReferrals$items$order.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$state = json['state'];
    final l$$__typename = json['__typename'];
    return Query$MyReferrals$myReferrals$items$order(
      id: (l$id as String),
      code: (l$code as String),
      state: (l$state as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String state;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$state = state;
    _resultData['state'] = l$state;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$state = state;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$state,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MyReferrals$myReferrals$items$order ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MyReferrals$myReferrals$items$order
    on Query$MyReferrals$myReferrals$items$order {
  CopyWith$Query$MyReferrals$myReferrals$items$order<
          Query$MyReferrals$myReferrals$items$order>
      get copyWith => CopyWith$Query$MyReferrals$myReferrals$items$order(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$MyReferrals$myReferrals$items$order<TRes> {
  factory CopyWith$Query$MyReferrals$myReferrals$items$order(
    Query$MyReferrals$myReferrals$items$order instance,
    TRes Function(Query$MyReferrals$myReferrals$items$order) then,
  ) = _CopyWithImpl$Query$MyReferrals$myReferrals$items$order;

  factory CopyWith$Query$MyReferrals$myReferrals$items$order.stub(TRes res) =
      _CopyWithStubImpl$Query$MyReferrals$myReferrals$items$order;

  TRes call({
    String? id,
    String? code,
    String? state,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$MyReferrals$myReferrals$items$order<TRes>
    implements CopyWith$Query$MyReferrals$myReferrals$items$order<TRes> {
  _CopyWithImpl$Query$MyReferrals$myReferrals$items$order(
    this._instance,
    this._then,
  );

  final Query$MyReferrals$myReferrals$items$order _instance;

  final TRes Function(Query$MyReferrals$myReferrals$items$order) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? state = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$MyReferrals$myReferrals$items$order(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        state: state == _undefined || state == null
            ? _instance.state
            : (state as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$MyReferrals$myReferrals$items$order<TRes>
    implements CopyWith$Query$MyReferrals$myReferrals$items$order<TRes> {
  _CopyWithStubImpl$Query$MyReferrals$myReferrals$items$order(this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    String? state,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Query$EarnedScratchCards {
  factory Variables$Query$EarnedScratchCards({
    int? take,
    int? skip,
  }) =>
      Variables$Query$EarnedScratchCards._({
        if (take != null) r'take': take,
        if (skip != null) r'skip': skip,
      });

  Variables$Query$EarnedScratchCards._(this._$data);

  factory Variables$Query$EarnedScratchCards.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('take')) {
      final l$take = data['take'];
      result$data['take'] = (l$take as int?);
    }
    if (data.containsKey('skip')) {
      final l$skip = data['skip'];
      result$data['skip'] = (l$skip as int?);
    }
    return Variables$Query$EarnedScratchCards._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get take => (_$data['take'] as int?);

  int? get skip => (_$data['skip'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('take')) {
      final l$take = take;
      result$data['take'] = l$take;
    }
    if (_$data.containsKey('skip')) {
      final l$skip = skip;
      result$data['skip'] = l$skip;
    }
    return result$data;
  }

  CopyWith$Variables$Query$EarnedScratchCards<
          Variables$Query$EarnedScratchCards>
      get copyWith => CopyWith$Variables$Query$EarnedScratchCards(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$EarnedScratchCards ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$take = take;
    final lOther$take = other.take;
    if (_$data.containsKey('take') != other._$data.containsKey('take')) {
      return false;
    }
    if (l$take != lOther$take) {
      return false;
    }
    final l$skip = skip;
    final lOther$skip = other.skip;
    if (_$data.containsKey('skip') != other._$data.containsKey('skip')) {
      return false;
    }
    if (l$skip != lOther$skip) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$take = take;
    final l$skip = skip;
    return Object.hashAll([
      _$data.containsKey('take') ? l$take : const {},
      _$data.containsKey('skip') ? l$skip : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$EarnedScratchCards<TRes> {
  factory CopyWith$Variables$Query$EarnedScratchCards(
    Variables$Query$EarnedScratchCards instance,
    TRes Function(Variables$Query$EarnedScratchCards) then,
  ) = _CopyWithImpl$Variables$Query$EarnedScratchCards;

  factory CopyWith$Variables$Query$EarnedScratchCards.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$EarnedScratchCards;

  TRes call({
    int? take,
    int? skip,
  });
}

class _CopyWithImpl$Variables$Query$EarnedScratchCards<TRes>
    implements CopyWith$Variables$Query$EarnedScratchCards<TRes> {
  _CopyWithImpl$Variables$Query$EarnedScratchCards(
    this._instance,
    this._then,
  );

  final Variables$Query$EarnedScratchCards _instance;

  final TRes Function(Variables$Query$EarnedScratchCards) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? take = _undefined,
    Object? skip = _undefined,
  }) =>
      _then(Variables$Query$EarnedScratchCards._({
        ..._instance._$data,
        if (take != _undefined) 'take': (take as int?),
        if (skip != _undefined) 'skip': (skip as int?),
      }));
}

class _CopyWithStubImpl$Variables$Query$EarnedScratchCards<TRes>
    implements CopyWith$Variables$Query$EarnedScratchCards<TRes> {
  _CopyWithStubImpl$Variables$Query$EarnedScratchCards(this._res);

  TRes _res;

  call({
    int? take,
    int? skip,
  }) =>
      _res;
}

class Query$EarnedScratchCards {
  Query$EarnedScratchCards({
    required this.earnedScratchCards,
    this.$__typename = 'Query',
  });

  factory Query$EarnedScratchCards.fromJson(Map<String, dynamic> json) {
    final l$earnedScratchCards = json['earnedScratchCards'];
    final l$$__typename = json['__typename'];
    return Query$EarnedScratchCards(
      earnedScratchCards: Query$EarnedScratchCards$earnedScratchCards.fromJson(
          (l$earnedScratchCards as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$EarnedScratchCards$earnedScratchCards earnedScratchCards;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$earnedScratchCards = earnedScratchCards;
    _resultData['earnedScratchCards'] = l$earnedScratchCards.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$earnedScratchCards = earnedScratchCards;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$earnedScratchCards,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$EarnedScratchCards ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$earnedScratchCards = earnedScratchCards;
    final lOther$earnedScratchCards = other.earnedScratchCards;
    if (l$earnedScratchCards != lOther$earnedScratchCards) {
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

extension UtilityExtension$Query$EarnedScratchCards
    on Query$EarnedScratchCards {
  CopyWith$Query$EarnedScratchCards<Query$EarnedScratchCards> get copyWith =>
      CopyWith$Query$EarnedScratchCards(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$EarnedScratchCards<TRes> {
  factory CopyWith$Query$EarnedScratchCards(
    Query$EarnedScratchCards instance,
    TRes Function(Query$EarnedScratchCards) then,
  ) = _CopyWithImpl$Query$EarnedScratchCards;

  factory CopyWith$Query$EarnedScratchCards.stub(TRes res) =
      _CopyWithStubImpl$Query$EarnedScratchCards;

  TRes call({
    Query$EarnedScratchCards$earnedScratchCards? earnedScratchCards,
    String? $__typename,
  });
  CopyWith$Query$EarnedScratchCards$earnedScratchCards<TRes>
      get earnedScratchCards;
}

class _CopyWithImpl$Query$EarnedScratchCards<TRes>
    implements CopyWith$Query$EarnedScratchCards<TRes> {
  _CopyWithImpl$Query$EarnedScratchCards(
    this._instance,
    this._then,
  );

  final Query$EarnedScratchCards _instance;

  final TRes Function(Query$EarnedScratchCards) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? earnedScratchCards = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$EarnedScratchCards(
        earnedScratchCards:
            earnedScratchCards == _undefined || earnedScratchCards == null
                ? _instance.earnedScratchCards
                : (earnedScratchCards
                    as Query$EarnedScratchCards$earnedScratchCards),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$EarnedScratchCards$earnedScratchCards<TRes>
      get earnedScratchCards {
    final local$earnedScratchCards = _instance.earnedScratchCards;
    return CopyWith$Query$EarnedScratchCards$earnedScratchCards(
        local$earnedScratchCards, (e) => call(earnedScratchCards: e));
  }
}

class _CopyWithStubImpl$Query$EarnedScratchCards<TRes>
    implements CopyWith$Query$EarnedScratchCards<TRes> {
  _CopyWithStubImpl$Query$EarnedScratchCards(this._res);

  TRes _res;

  call({
    Query$EarnedScratchCards$earnedScratchCards? earnedScratchCards,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$EarnedScratchCards$earnedScratchCards<TRes>
      get earnedScratchCards =>
          CopyWith$Query$EarnedScratchCards$earnedScratchCards.stub(_res);
}

const documentNodeQueryEarnedScratchCards = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'EarnedScratchCards'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'take')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'skip')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'earnedScratchCards'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'take'),
            value: VariableNode(name: NameNode(value: 'take')),
          ),
          ArgumentNode(
            name: NameNode(value: 'skip'),
            value: VariableNode(name: NameNode(value: 'skip')),
          ),
        ],
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
                name: NameNode(value: 'referralNumber'),
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
                name: NameNode(value: 'referredCustomer'),
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
                    name: NameNode(value: 'firstName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'lastName'),
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
                name: NameNode(value: 'status'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'points'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'isScratched'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'note'),
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
]);
Query$EarnedScratchCards _parserFn$Query$EarnedScratchCards(
        Map<String, dynamic> data) =>
    Query$EarnedScratchCards.fromJson(data);
typedef OnQueryComplete$Query$EarnedScratchCards = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$EarnedScratchCards?,
);

class Options$Query$EarnedScratchCards
    extends graphql.QueryOptions<Query$EarnedScratchCards> {
  Options$Query$EarnedScratchCards({
    String? operationName,
    Variables$Query$EarnedScratchCards? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$EarnedScratchCards? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$EarnedScratchCards? onComplete,
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
                    data == null
                        ? null
                        : _parserFn$Query$EarnedScratchCards(data),
                  ),
          onError: onError,
          document: documentNodeQueryEarnedScratchCards,
          parserFn: _parserFn$Query$EarnedScratchCards,
        );

  final OnQueryComplete$Query$EarnedScratchCards? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$EarnedScratchCards
    extends graphql.WatchQueryOptions<Query$EarnedScratchCards> {
  WatchOptions$Query$EarnedScratchCards({
    String? operationName,
    Variables$Query$EarnedScratchCards? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$EarnedScratchCards? typedOptimisticResult,
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
          document: documentNodeQueryEarnedScratchCards,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$EarnedScratchCards,
        );
}

class FetchMoreOptions$Query$EarnedScratchCards
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$EarnedScratchCards({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$EarnedScratchCards? variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables?.toJson() ?? {},
          document: documentNodeQueryEarnedScratchCards,
        );
}

extension ClientExtension$Query$EarnedScratchCards on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$EarnedScratchCards>>
      query$EarnedScratchCards(
              [Options$Query$EarnedScratchCards? options]) async =>
          await this.query(options ?? Options$Query$EarnedScratchCards());
  graphql.ObservableQuery<Query$EarnedScratchCards>
      watchQuery$EarnedScratchCards(
              [WatchOptions$Query$EarnedScratchCards? options]) =>
          this.watchQuery(options ?? WatchOptions$Query$EarnedScratchCards());
  void writeQuery$EarnedScratchCards({
    required Query$EarnedScratchCards data,
    Variables$Query$EarnedScratchCards? variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryEarnedScratchCards),
          variables: variables?.toJson() ?? const {},
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$EarnedScratchCards? readQuery$EarnedScratchCards({
    Variables$Query$EarnedScratchCards? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation:
            graphql.Operation(document: documentNodeQueryEarnedScratchCards),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$EarnedScratchCards.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$EarnedScratchCards>
    useQuery$EarnedScratchCards([Options$Query$EarnedScratchCards? options]) =>
        graphql_flutter.useQuery(options ?? Options$Query$EarnedScratchCards());
graphql.ObservableQuery<Query$EarnedScratchCards>
    useWatchQuery$EarnedScratchCards(
            [WatchOptions$Query$EarnedScratchCards? options]) =>
        graphql_flutter
            .useWatchQuery(options ?? WatchOptions$Query$EarnedScratchCards());

class Query$EarnedScratchCards$Widget
    extends graphql_flutter.Query<Query$EarnedScratchCards> {
  Query$EarnedScratchCards$Widget({
    widgets.Key? key,
    Options$Query$EarnedScratchCards? options,
    required graphql_flutter.QueryBuilder<Query$EarnedScratchCards> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$EarnedScratchCards(),
          builder: builder,
        );
}

class Query$EarnedScratchCards$earnedScratchCards {
  Query$EarnedScratchCards$earnedScratchCards({
    required this.totalItems,
    required this.items,
    this.$__typename = 'ReferralList',
  });

  factory Query$EarnedScratchCards$earnedScratchCards.fromJson(
      Map<String, dynamic> json) {
    final l$totalItems = json['totalItems'];
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Query$EarnedScratchCards$earnedScratchCards(
      totalItems: (l$totalItems as int),
      items: (l$items as List<dynamic>)
          .map((e) =>
              Query$EarnedScratchCards$earnedScratchCards$items.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int totalItems;

  final List<Query$EarnedScratchCards$earnedScratchCards$items> items;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$totalItems = totalItems;
    _resultData['totalItems'] = l$totalItems;
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$totalItems = totalItems;
    final l$items = items;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$totalItems,
      Object.hashAll(l$items.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$EarnedScratchCards$earnedScratchCards ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$totalItems = totalItems;
    final lOther$totalItems = other.totalItems;
    if (l$totalItems != lOther$totalItems) {
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

extension UtilityExtension$Query$EarnedScratchCards$earnedScratchCards
    on Query$EarnedScratchCards$earnedScratchCards {
  CopyWith$Query$EarnedScratchCards$earnedScratchCards<
          Query$EarnedScratchCards$earnedScratchCards>
      get copyWith => CopyWith$Query$EarnedScratchCards$earnedScratchCards(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$EarnedScratchCards$earnedScratchCards<TRes> {
  factory CopyWith$Query$EarnedScratchCards$earnedScratchCards(
    Query$EarnedScratchCards$earnedScratchCards instance,
    TRes Function(Query$EarnedScratchCards$earnedScratchCards) then,
  ) = _CopyWithImpl$Query$EarnedScratchCards$earnedScratchCards;

  factory CopyWith$Query$EarnedScratchCards$earnedScratchCards.stub(TRes res) =
      _CopyWithStubImpl$Query$EarnedScratchCards$earnedScratchCards;

  TRes call({
    int? totalItems,
    List<Query$EarnedScratchCards$earnedScratchCards$items>? items,
    String? $__typename,
  });
  TRes items(
      Iterable<Query$EarnedScratchCards$earnedScratchCards$items> Function(
              Iterable<
                  CopyWith$Query$EarnedScratchCards$earnedScratchCards$items<
                      Query$EarnedScratchCards$earnedScratchCards$items>>)
          _fn);
}

class _CopyWithImpl$Query$EarnedScratchCards$earnedScratchCards<TRes>
    implements CopyWith$Query$EarnedScratchCards$earnedScratchCards<TRes> {
  _CopyWithImpl$Query$EarnedScratchCards$earnedScratchCards(
    this._instance,
    this._then,
  );

  final Query$EarnedScratchCards$earnedScratchCards _instance;

  final TRes Function(Query$EarnedScratchCards$earnedScratchCards) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? totalItems = _undefined,
    Object? items = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$EarnedScratchCards$earnedScratchCards(
        totalItems: totalItems == _undefined || totalItems == null
            ? _instance.totalItems
            : (totalItems as int),
        items: items == _undefined || items == null
            ? _instance.items
            : (items
                as List<Query$EarnedScratchCards$earnedScratchCards$items>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes items(
          Iterable<Query$EarnedScratchCards$earnedScratchCards$items> Function(
                  Iterable<
                      CopyWith$Query$EarnedScratchCards$earnedScratchCards$items<
                          Query$EarnedScratchCards$earnedScratchCards$items>>)
              _fn) =>
      call(
          items: _fn(_instance.items.map(
              (e) => CopyWith$Query$EarnedScratchCards$earnedScratchCards$items(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$EarnedScratchCards$earnedScratchCards<TRes>
    implements CopyWith$Query$EarnedScratchCards$earnedScratchCards<TRes> {
  _CopyWithStubImpl$Query$EarnedScratchCards$earnedScratchCards(this._res);

  TRes _res;

  call({
    int? totalItems,
    List<Query$EarnedScratchCards$earnedScratchCards$items>? items,
    String? $__typename,
  }) =>
      _res;

  items(_fn) => _res;
}

class Query$EarnedScratchCards$earnedScratchCards$items {
  Query$EarnedScratchCards$earnedScratchCards$items({
    required this.id,
    required this.referralNumber,
    required this.createdAt,
    required this.referredCustomer,
    required this.status,
    required this.points,
    required this.isScratched,
    this.note,
    this.$__typename = 'Referral',
  });

  factory Query$EarnedScratchCards$earnedScratchCards$items.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$referralNumber = json['referralNumber'];
    final l$createdAt = json['createdAt'];
    final l$referredCustomer = json['referredCustomer'];
    final l$status = json['status'];
    final l$points = json['points'];
    final l$isScratched = json['isScratched'];
    final l$note = json['note'];
    final l$$__typename = json['__typename'];
    return Query$EarnedScratchCards$earnedScratchCards$items(
      id: (l$id as String),
      referralNumber: (l$referralNumber as int),
      createdAt: DateTime.parse((l$createdAt as String)),
      referredCustomer:
          Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer
              .fromJson((l$referredCustomer as Map<String, dynamic>)),
      status: fromJson$Enum$ReferralStatus((l$status as String)),
      points: (l$points as int),
      isScratched: (l$isScratched as bool),
      note: (l$note as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int referralNumber;

  final DateTime createdAt;

  final Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer
      referredCustomer;

  final Enum$ReferralStatus status;

  final int points;

  final bool isScratched;

  final String? note;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$referralNumber = referralNumber;
    _resultData['referralNumber'] = l$referralNumber;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$referredCustomer = referredCustomer;
    _resultData['referredCustomer'] = l$referredCustomer.toJson();
    final l$status = status;
    _resultData['status'] = toJson$Enum$ReferralStatus(l$status);
    final l$points = points;
    _resultData['points'] = l$points;
    final l$isScratched = isScratched;
    _resultData['isScratched'] = l$isScratched;
    final l$note = note;
    _resultData['note'] = l$note;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$referralNumber = referralNumber;
    final l$createdAt = createdAt;
    final l$referredCustomer = referredCustomer;
    final l$status = status;
    final l$points = points;
    final l$isScratched = isScratched;
    final l$note = note;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$referralNumber,
      l$createdAt,
      l$referredCustomer,
      l$status,
      l$points,
      l$isScratched,
      l$note,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$EarnedScratchCards$earnedScratchCards$items ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$referralNumber = referralNumber;
    final lOther$referralNumber = other.referralNumber;
    if (l$referralNumber != lOther$referralNumber) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$referredCustomer = referredCustomer;
    final lOther$referredCustomer = other.referredCustomer;
    if (l$referredCustomer != lOther$referredCustomer) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$points = points;
    final lOther$points = other.points;
    if (l$points != lOther$points) {
      return false;
    }
    final l$isScratched = isScratched;
    final lOther$isScratched = other.isScratched;
    if (l$isScratched != lOther$isScratched) {
      return false;
    }
    final l$note = note;
    final lOther$note = other.note;
    if (l$note != lOther$note) {
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

extension UtilityExtension$Query$EarnedScratchCards$earnedScratchCards$items
    on Query$EarnedScratchCards$earnedScratchCards$items {
  CopyWith$Query$EarnedScratchCards$earnedScratchCards$items<
          Query$EarnedScratchCards$earnedScratchCards$items>
      get copyWith =>
          CopyWith$Query$EarnedScratchCards$earnedScratchCards$items(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$EarnedScratchCards$earnedScratchCards$items<
    TRes> {
  factory CopyWith$Query$EarnedScratchCards$earnedScratchCards$items(
    Query$EarnedScratchCards$earnedScratchCards$items instance,
    TRes Function(Query$EarnedScratchCards$earnedScratchCards$items) then,
  ) = _CopyWithImpl$Query$EarnedScratchCards$earnedScratchCards$items;

  factory CopyWith$Query$EarnedScratchCards$earnedScratchCards$items.stub(
          TRes res) =
      _CopyWithStubImpl$Query$EarnedScratchCards$earnedScratchCards$items;

  TRes call({
    String? id,
    int? referralNumber,
    DateTime? createdAt,
    Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer?
        referredCustomer,
    Enum$ReferralStatus? status,
    int? points,
    bool? isScratched,
    String? note,
    String? $__typename,
  });
  CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer<
      TRes> get referredCustomer;
}

class _CopyWithImpl$Query$EarnedScratchCards$earnedScratchCards$items<TRes>
    implements
        CopyWith$Query$EarnedScratchCards$earnedScratchCards$items<TRes> {
  _CopyWithImpl$Query$EarnedScratchCards$earnedScratchCards$items(
    this._instance,
    this._then,
  );

  final Query$EarnedScratchCards$earnedScratchCards$items _instance;

  final TRes Function(Query$EarnedScratchCards$earnedScratchCards$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? referralNumber = _undefined,
    Object? createdAt = _undefined,
    Object? referredCustomer = _undefined,
    Object? status = _undefined,
    Object? points = _undefined,
    Object? isScratched = _undefined,
    Object? note = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$EarnedScratchCards$earnedScratchCards$items(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        referralNumber: referralNumber == _undefined || referralNumber == null
            ? _instance.referralNumber
            : (referralNumber as int),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        referredCustomer: referredCustomer == _undefined ||
                referredCustomer == null
            ? _instance.referredCustomer
            : (referredCustomer
                as Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer),
        status: status == _undefined || status == null
            ? _instance.status
            : (status as Enum$ReferralStatus),
        points: points == _undefined || points == null
            ? _instance.points
            : (points as int),
        isScratched: isScratched == _undefined || isScratched == null
            ? _instance.isScratched
            : (isScratched as bool),
        note: note == _undefined ? _instance.note : (note as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer<
      TRes> get referredCustomer {
    final local$referredCustomer = _instance.referredCustomer;
    return CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer(
        local$referredCustomer, (e) => call(referredCustomer: e));
  }
}

class _CopyWithStubImpl$Query$EarnedScratchCards$earnedScratchCards$items<TRes>
    implements
        CopyWith$Query$EarnedScratchCards$earnedScratchCards$items<TRes> {
  _CopyWithStubImpl$Query$EarnedScratchCards$earnedScratchCards$items(
      this._res);

  TRes _res;

  call({
    String? id,
    int? referralNumber,
    DateTime? createdAt,
    Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer?
        referredCustomer,
    Enum$ReferralStatus? status,
    int? points,
    bool? isScratched,
    String? note,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer<
          TRes>
      get referredCustomer =>
          CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer
              .stub(_res);
}

class Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer {
  Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.$__typename = 'Customer',
  });

  factory Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$$__typename = json['__typename'];
    return Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer(
      id: (l$id as String),
      firstName: (l$firstName as String),
      lastName: (l$lastName as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String firstName;

  final String lastName;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$firstName = firstName;
    _resultData['firstName'] = l$firstName;
    final l$lastName = lastName;
    _resultData['lastName'] = l$lastName;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$firstName = firstName;
    final l$lastName = lastName;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$firstName,
      l$lastName,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$firstName = firstName;
    final lOther$firstName = other.firstName;
    if (l$firstName != lOther$firstName) {
      return false;
    }
    final l$lastName = lastName;
    final lOther$lastName = other.lastName;
    if (l$lastName != lOther$lastName) {
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

extension UtilityExtension$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer
    on Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer {
  CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer<
          Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer>
      get copyWith =>
          CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer<
    TRes> {
  factory CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer(
    Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer instance,
    TRes Function(
            Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer)
        then,
  ) = _CopyWithImpl$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer;

  factory CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer.stub(
          TRes res) =
      _CopyWithStubImpl$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer;

  TRes call({
    String? id,
    String? firstName,
    String? lastName,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer<
        TRes>
    implements
        CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer<
            TRes> {
  _CopyWithImpl$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer(
    this._instance,
    this._then,
  );

  final Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer
      _instance;

  final TRes Function(
      Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        firstName: firstName == _undefined || firstName == null
            ? _instance.firstName
            : (firstName as String),
        lastName: lastName == _undefined || lastName == null
            ? _instance.lastName
            : (lastName as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer<
        TRes>
    implements
        CopyWith$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer<
            TRes> {
  _CopyWithStubImpl$Query$EarnedScratchCards$earnedScratchCards$items$referredCustomer(
      this._res);

  TRes _res;

  call({
    String? id,
    String? firstName,
    String? lastName,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Query$ScratchedCards {
  factory Variables$Query$ScratchedCards({
    int? take,
    int? skip,
  }) =>
      Variables$Query$ScratchedCards._({
        if (take != null) r'take': take,
        if (skip != null) r'skip': skip,
      });

  Variables$Query$ScratchedCards._(this._$data);

  factory Variables$Query$ScratchedCards.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('take')) {
      final l$take = data['take'];
      result$data['take'] = (l$take as int?);
    }
    if (data.containsKey('skip')) {
      final l$skip = data['skip'];
      result$data['skip'] = (l$skip as int?);
    }
    return Variables$Query$ScratchedCards._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get take => (_$data['take'] as int?);

  int? get skip => (_$data['skip'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('take')) {
      final l$take = take;
      result$data['take'] = l$take;
    }
    if (_$data.containsKey('skip')) {
      final l$skip = skip;
      result$data['skip'] = l$skip;
    }
    return result$data;
  }

  CopyWith$Variables$Query$ScratchedCards<Variables$Query$ScratchedCards>
      get copyWith => CopyWith$Variables$Query$ScratchedCards(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$ScratchedCards ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$take = take;
    final lOther$take = other.take;
    if (_$data.containsKey('take') != other._$data.containsKey('take')) {
      return false;
    }
    if (l$take != lOther$take) {
      return false;
    }
    final l$skip = skip;
    final lOther$skip = other.skip;
    if (_$data.containsKey('skip') != other._$data.containsKey('skip')) {
      return false;
    }
    if (l$skip != lOther$skip) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$take = take;
    final l$skip = skip;
    return Object.hashAll([
      _$data.containsKey('take') ? l$take : const {},
      _$data.containsKey('skip') ? l$skip : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$ScratchedCards<TRes> {
  factory CopyWith$Variables$Query$ScratchedCards(
    Variables$Query$ScratchedCards instance,
    TRes Function(Variables$Query$ScratchedCards) then,
  ) = _CopyWithImpl$Variables$Query$ScratchedCards;

  factory CopyWith$Variables$Query$ScratchedCards.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$ScratchedCards;

  TRes call({
    int? take,
    int? skip,
  });
}

class _CopyWithImpl$Variables$Query$ScratchedCards<TRes>
    implements CopyWith$Variables$Query$ScratchedCards<TRes> {
  _CopyWithImpl$Variables$Query$ScratchedCards(
    this._instance,
    this._then,
  );

  final Variables$Query$ScratchedCards _instance;

  final TRes Function(Variables$Query$ScratchedCards) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? take = _undefined,
    Object? skip = _undefined,
  }) =>
      _then(Variables$Query$ScratchedCards._({
        ..._instance._$data,
        if (take != _undefined) 'take': (take as int?),
        if (skip != _undefined) 'skip': (skip as int?),
      }));
}

class _CopyWithStubImpl$Variables$Query$ScratchedCards<TRes>
    implements CopyWith$Variables$Query$ScratchedCards<TRes> {
  _CopyWithStubImpl$Variables$Query$ScratchedCards(this._res);

  TRes _res;

  call({
    int? take,
    int? skip,
  }) =>
      _res;
}

class Query$ScratchedCards {
  Query$ScratchedCards({
    required this.scratchedCards,
    this.$__typename = 'Query',
  });

  factory Query$ScratchedCards.fromJson(Map<String, dynamic> json) {
    final l$scratchedCards = json['scratchedCards'];
    final l$$__typename = json['__typename'];
    return Query$ScratchedCards(
      scratchedCards: Query$ScratchedCards$scratchedCards.fromJson(
          (l$scratchedCards as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$ScratchedCards$scratchedCards scratchedCards;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$scratchedCards = scratchedCards;
    _resultData['scratchedCards'] = l$scratchedCards.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$scratchedCards = scratchedCards;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$scratchedCards,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ScratchedCards || runtimeType != other.runtimeType) {
      return false;
    }
    final l$scratchedCards = scratchedCards;
    final lOther$scratchedCards = other.scratchedCards;
    if (l$scratchedCards != lOther$scratchedCards) {
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

extension UtilityExtension$Query$ScratchedCards on Query$ScratchedCards {
  CopyWith$Query$ScratchedCards<Query$ScratchedCards> get copyWith =>
      CopyWith$Query$ScratchedCards(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$ScratchedCards<TRes> {
  factory CopyWith$Query$ScratchedCards(
    Query$ScratchedCards instance,
    TRes Function(Query$ScratchedCards) then,
  ) = _CopyWithImpl$Query$ScratchedCards;

  factory CopyWith$Query$ScratchedCards.stub(TRes res) =
      _CopyWithStubImpl$Query$ScratchedCards;

  TRes call({
    Query$ScratchedCards$scratchedCards? scratchedCards,
    String? $__typename,
  });
  CopyWith$Query$ScratchedCards$scratchedCards<TRes> get scratchedCards;
}

class _CopyWithImpl$Query$ScratchedCards<TRes>
    implements CopyWith$Query$ScratchedCards<TRes> {
  _CopyWithImpl$Query$ScratchedCards(
    this._instance,
    this._then,
  );

  final Query$ScratchedCards _instance;

  final TRes Function(Query$ScratchedCards) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? scratchedCards = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$ScratchedCards(
        scratchedCards: scratchedCards == _undefined || scratchedCards == null
            ? _instance.scratchedCards
            : (scratchedCards as Query$ScratchedCards$scratchedCards),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$ScratchedCards$scratchedCards<TRes> get scratchedCards {
    final local$scratchedCards = _instance.scratchedCards;
    return CopyWith$Query$ScratchedCards$scratchedCards(
        local$scratchedCards, (e) => call(scratchedCards: e));
  }
}

class _CopyWithStubImpl$Query$ScratchedCards<TRes>
    implements CopyWith$Query$ScratchedCards<TRes> {
  _CopyWithStubImpl$Query$ScratchedCards(this._res);

  TRes _res;

  call({
    Query$ScratchedCards$scratchedCards? scratchedCards,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$ScratchedCards$scratchedCards<TRes> get scratchedCards =>
      CopyWith$Query$ScratchedCards$scratchedCards.stub(_res);
}

const documentNodeQueryScratchedCards = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'ScratchedCards'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'take')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'skip')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'scratchedCards'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'take'),
            value: VariableNode(name: NameNode(value: 'take')),
          ),
          ArgumentNode(
            name: NameNode(value: 'skip'),
            value: VariableNode(name: NameNode(value: 'skip')),
          ),
        ],
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
                name: NameNode(value: 'referralNumber'),
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
                name: NameNode(value: 'referredCustomer'),
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
                    name: NameNode(value: 'firstName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'lastName'),
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
                name: NameNode(value: 'status'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'points'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'isScratched'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'note'),
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
]);
Query$ScratchedCards _parserFn$Query$ScratchedCards(
        Map<String, dynamic> data) =>
    Query$ScratchedCards.fromJson(data);
typedef OnQueryComplete$Query$ScratchedCards = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$ScratchedCards?,
);

class Options$Query$ScratchedCards
    extends graphql.QueryOptions<Query$ScratchedCards> {
  Options$Query$ScratchedCards({
    String? operationName,
    Variables$Query$ScratchedCards? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$ScratchedCards? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$ScratchedCards? onComplete,
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
                    data == null ? null : _parserFn$Query$ScratchedCards(data),
                  ),
          onError: onError,
          document: documentNodeQueryScratchedCards,
          parserFn: _parserFn$Query$ScratchedCards,
        );

  final OnQueryComplete$Query$ScratchedCards? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$ScratchedCards
    extends graphql.WatchQueryOptions<Query$ScratchedCards> {
  WatchOptions$Query$ScratchedCards({
    String? operationName,
    Variables$Query$ScratchedCards? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$ScratchedCards? typedOptimisticResult,
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
          document: documentNodeQueryScratchedCards,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$ScratchedCards,
        );
}

class FetchMoreOptions$Query$ScratchedCards extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$ScratchedCards({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$ScratchedCards? variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables?.toJson() ?? {},
          document: documentNodeQueryScratchedCards,
        );
}

extension ClientExtension$Query$ScratchedCards on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$ScratchedCards>> query$ScratchedCards(
          [Options$Query$ScratchedCards? options]) async =>
      await this.query(options ?? Options$Query$ScratchedCards());
  graphql.ObservableQuery<Query$ScratchedCards> watchQuery$ScratchedCards(
          [WatchOptions$Query$ScratchedCards? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$ScratchedCards());
  void writeQuery$ScratchedCards({
    required Query$ScratchedCards data,
    Variables$Query$ScratchedCards? variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryScratchedCards),
          variables: variables?.toJson() ?? const {},
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$ScratchedCards? readQuery$ScratchedCards({
    Variables$Query$ScratchedCards? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryScratchedCards),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$ScratchedCards.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$ScratchedCards> useQuery$ScratchedCards(
        [Options$Query$ScratchedCards? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$ScratchedCards());
graphql.ObservableQuery<Query$ScratchedCards> useWatchQuery$ScratchedCards(
        [WatchOptions$Query$ScratchedCards? options]) =>
    graphql_flutter
        .useWatchQuery(options ?? WatchOptions$Query$ScratchedCards());

class Query$ScratchedCards$Widget
    extends graphql_flutter.Query<Query$ScratchedCards> {
  Query$ScratchedCards$Widget({
    widgets.Key? key,
    Options$Query$ScratchedCards? options,
    required graphql_flutter.QueryBuilder<Query$ScratchedCards> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$ScratchedCards(),
          builder: builder,
        );
}

class Query$ScratchedCards$scratchedCards {
  Query$ScratchedCards$scratchedCards({
    required this.totalItems,
    required this.items,
    this.$__typename = 'ReferralList',
  });

  factory Query$ScratchedCards$scratchedCards.fromJson(
      Map<String, dynamic> json) {
    final l$totalItems = json['totalItems'];
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Query$ScratchedCards$scratchedCards(
      totalItems: (l$totalItems as int),
      items: (l$items as List<dynamic>)
          .map((e) => Query$ScratchedCards$scratchedCards$items.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int totalItems;

  final List<Query$ScratchedCards$scratchedCards$items> items;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$totalItems = totalItems;
    _resultData['totalItems'] = l$totalItems;
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$totalItems = totalItems;
    final l$items = items;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$totalItems,
      Object.hashAll(l$items.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ScratchedCards$scratchedCards ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$totalItems = totalItems;
    final lOther$totalItems = other.totalItems;
    if (l$totalItems != lOther$totalItems) {
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

extension UtilityExtension$Query$ScratchedCards$scratchedCards
    on Query$ScratchedCards$scratchedCards {
  CopyWith$Query$ScratchedCards$scratchedCards<
          Query$ScratchedCards$scratchedCards>
      get copyWith => CopyWith$Query$ScratchedCards$scratchedCards(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$ScratchedCards$scratchedCards<TRes> {
  factory CopyWith$Query$ScratchedCards$scratchedCards(
    Query$ScratchedCards$scratchedCards instance,
    TRes Function(Query$ScratchedCards$scratchedCards) then,
  ) = _CopyWithImpl$Query$ScratchedCards$scratchedCards;

  factory CopyWith$Query$ScratchedCards$scratchedCards.stub(TRes res) =
      _CopyWithStubImpl$Query$ScratchedCards$scratchedCards;

  TRes call({
    int? totalItems,
    List<Query$ScratchedCards$scratchedCards$items>? items,
    String? $__typename,
  });
  TRes items(
      Iterable<Query$ScratchedCards$scratchedCards$items> Function(
              Iterable<
                  CopyWith$Query$ScratchedCards$scratchedCards$items<
                      Query$ScratchedCards$scratchedCards$items>>)
          _fn);
}

class _CopyWithImpl$Query$ScratchedCards$scratchedCards<TRes>
    implements CopyWith$Query$ScratchedCards$scratchedCards<TRes> {
  _CopyWithImpl$Query$ScratchedCards$scratchedCards(
    this._instance,
    this._then,
  );

  final Query$ScratchedCards$scratchedCards _instance;

  final TRes Function(Query$ScratchedCards$scratchedCards) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? totalItems = _undefined,
    Object? items = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$ScratchedCards$scratchedCards(
        totalItems: totalItems == _undefined || totalItems == null
            ? _instance.totalItems
            : (totalItems as int),
        items: items == _undefined || items == null
            ? _instance.items
            : (items as List<Query$ScratchedCards$scratchedCards$items>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes items(
          Iterable<Query$ScratchedCards$scratchedCards$items> Function(
                  Iterable<
                      CopyWith$Query$ScratchedCards$scratchedCards$items<
                          Query$ScratchedCards$scratchedCards$items>>)
              _fn) =>
      call(
          items: _fn(_instance.items
              .map((e) => CopyWith$Query$ScratchedCards$scratchedCards$items(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$ScratchedCards$scratchedCards<TRes>
    implements CopyWith$Query$ScratchedCards$scratchedCards<TRes> {
  _CopyWithStubImpl$Query$ScratchedCards$scratchedCards(this._res);

  TRes _res;

  call({
    int? totalItems,
    List<Query$ScratchedCards$scratchedCards$items>? items,
    String? $__typename,
  }) =>
      _res;

  items(_fn) => _res;
}

class Query$ScratchedCards$scratchedCards$items {
  Query$ScratchedCards$scratchedCards$items({
    required this.id,
    required this.referralNumber,
    required this.createdAt,
    required this.referredCustomer,
    required this.status,
    required this.points,
    required this.isScratched,
    this.note,
    this.$__typename = 'Referral',
  });

  factory Query$ScratchedCards$scratchedCards$items.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$referralNumber = json['referralNumber'];
    final l$createdAt = json['createdAt'];
    final l$referredCustomer = json['referredCustomer'];
    final l$status = json['status'];
    final l$points = json['points'];
    final l$isScratched = json['isScratched'];
    final l$note = json['note'];
    final l$$__typename = json['__typename'];
    return Query$ScratchedCards$scratchedCards$items(
      id: (l$id as String),
      referralNumber: (l$referralNumber as int),
      createdAt: DateTime.parse((l$createdAt as String)),
      referredCustomer:
          Query$ScratchedCards$scratchedCards$items$referredCustomer.fromJson(
              (l$referredCustomer as Map<String, dynamic>)),
      status: fromJson$Enum$ReferralStatus((l$status as String)),
      points: (l$points as int),
      isScratched: (l$isScratched as bool),
      note: (l$note as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int referralNumber;

  final DateTime createdAt;

  final Query$ScratchedCards$scratchedCards$items$referredCustomer
      referredCustomer;

  final Enum$ReferralStatus status;

  final int points;

  final bool isScratched;

  final String? note;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$referralNumber = referralNumber;
    _resultData['referralNumber'] = l$referralNumber;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$referredCustomer = referredCustomer;
    _resultData['referredCustomer'] = l$referredCustomer.toJson();
    final l$status = status;
    _resultData['status'] = toJson$Enum$ReferralStatus(l$status);
    final l$points = points;
    _resultData['points'] = l$points;
    final l$isScratched = isScratched;
    _resultData['isScratched'] = l$isScratched;
    final l$note = note;
    _resultData['note'] = l$note;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$referralNumber = referralNumber;
    final l$createdAt = createdAt;
    final l$referredCustomer = referredCustomer;
    final l$status = status;
    final l$points = points;
    final l$isScratched = isScratched;
    final l$note = note;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$referralNumber,
      l$createdAt,
      l$referredCustomer,
      l$status,
      l$points,
      l$isScratched,
      l$note,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ScratchedCards$scratchedCards$items ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$referralNumber = referralNumber;
    final lOther$referralNumber = other.referralNumber;
    if (l$referralNumber != lOther$referralNumber) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$referredCustomer = referredCustomer;
    final lOther$referredCustomer = other.referredCustomer;
    if (l$referredCustomer != lOther$referredCustomer) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$points = points;
    final lOther$points = other.points;
    if (l$points != lOther$points) {
      return false;
    }
    final l$isScratched = isScratched;
    final lOther$isScratched = other.isScratched;
    if (l$isScratched != lOther$isScratched) {
      return false;
    }
    final l$note = note;
    final lOther$note = other.note;
    if (l$note != lOther$note) {
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

extension UtilityExtension$Query$ScratchedCards$scratchedCards$items
    on Query$ScratchedCards$scratchedCards$items {
  CopyWith$Query$ScratchedCards$scratchedCards$items<
          Query$ScratchedCards$scratchedCards$items>
      get copyWith => CopyWith$Query$ScratchedCards$scratchedCards$items(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$ScratchedCards$scratchedCards$items<TRes> {
  factory CopyWith$Query$ScratchedCards$scratchedCards$items(
    Query$ScratchedCards$scratchedCards$items instance,
    TRes Function(Query$ScratchedCards$scratchedCards$items) then,
  ) = _CopyWithImpl$Query$ScratchedCards$scratchedCards$items;

  factory CopyWith$Query$ScratchedCards$scratchedCards$items.stub(TRes res) =
      _CopyWithStubImpl$Query$ScratchedCards$scratchedCards$items;

  TRes call({
    String? id,
    int? referralNumber,
    DateTime? createdAt,
    Query$ScratchedCards$scratchedCards$items$referredCustomer?
        referredCustomer,
    Enum$ReferralStatus? status,
    int? points,
    bool? isScratched,
    String? note,
    String? $__typename,
  });
  CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer<TRes>
      get referredCustomer;
}

class _CopyWithImpl$Query$ScratchedCards$scratchedCards$items<TRes>
    implements CopyWith$Query$ScratchedCards$scratchedCards$items<TRes> {
  _CopyWithImpl$Query$ScratchedCards$scratchedCards$items(
    this._instance,
    this._then,
  );

  final Query$ScratchedCards$scratchedCards$items _instance;

  final TRes Function(Query$ScratchedCards$scratchedCards$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? referralNumber = _undefined,
    Object? createdAt = _undefined,
    Object? referredCustomer = _undefined,
    Object? status = _undefined,
    Object? points = _undefined,
    Object? isScratched = _undefined,
    Object? note = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$ScratchedCards$scratchedCards$items(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        referralNumber: referralNumber == _undefined || referralNumber == null
            ? _instance.referralNumber
            : (referralNumber as int),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        referredCustomer: referredCustomer == _undefined ||
                referredCustomer == null
            ? _instance.referredCustomer
            : (referredCustomer
                as Query$ScratchedCards$scratchedCards$items$referredCustomer),
        status: status == _undefined || status == null
            ? _instance.status
            : (status as Enum$ReferralStatus),
        points: points == _undefined || points == null
            ? _instance.points
            : (points as int),
        isScratched: isScratched == _undefined || isScratched == null
            ? _instance.isScratched
            : (isScratched as bool),
        note: note == _undefined ? _instance.note : (note as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer<TRes>
      get referredCustomer {
    final local$referredCustomer = _instance.referredCustomer;
    return CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer(
        local$referredCustomer, (e) => call(referredCustomer: e));
  }
}

class _CopyWithStubImpl$Query$ScratchedCards$scratchedCards$items<TRes>
    implements CopyWith$Query$ScratchedCards$scratchedCards$items<TRes> {
  _CopyWithStubImpl$Query$ScratchedCards$scratchedCards$items(this._res);

  TRes _res;

  call({
    String? id,
    int? referralNumber,
    DateTime? createdAt,
    Query$ScratchedCards$scratchedCards$items$referredCustomer?
        referredCustomer,
    Enum$ReferralStatus? status,
    int? points,
    bool? isScratched,
    String? note,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer<TRes>
      get referredCustomer =>
          CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer
              .stub(_res);
}

class Query$ScratchedCards$scratchedCards$items$referredCustomer {
  Query$ScratchedCards$scratchedCards$items$referredCustomer({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.$__typename = 'Customer',
  });

  factory Query$ScratchedCards$scratchedCards$items$referredCustomer.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$$__typename = json['__typename'];
    return Query$ScratchedCards$scratchedCards$items$referredCustomer(
      id: (l$id as String),
      firstName: (l$firstName as String),
      lastName: (l$lastName as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String firstName;

  final String lastName;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$firstName = firstName;
    _resultData['firstName'] = l$firstName;
    final l$lastName = lastName;
    _resultData['lastName'] = l$lastName;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$firstName = firstName;
    final l$lastName = lastName;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$firstName,
      l$lastName,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ScratchedCards$scratchedCards$items$referredCustomer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$firstName = firstName;
    final lOther$firstName = other.firstName;
    if (l$firstName != lOther$firstName) {
      return false;
    }
    final l$lastName = lastName;
    final lOther$lastName = other.lastName;
    if (l$lastName != lOther$lastName) {
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

extension UtilityExtension$Query$ScratchedCards$scratchedCards$items$referredCustomer
    on Query$ScratchedCards$scratchedCards$items$referredCustomer {
  CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer<
          Query$ScratchedCards$scratchedCards$items$referredCustomer>
      get copyWith =>
          CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer<
    TRes> {
  factory CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer(
    Query$ScratchedCards$scratchedCards$items$referredCustomer instance,
    TRes Function(Query$ScratchedCards$scratchedCards$items$referredCustomer)
        then,
  ) = _CopyWithImpl$Query$ScratchedCards$scratchedCards$items$referredCustomer;

  factory CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer.stub(
          TRes res) =
      _CopyWithStubImpl$Query$ScratchedCards$scratchedCards$items$referredCustomer;

  TRes call({
    String? id,
    String? firstName,
    String? lastName,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$ScratchedCards$scratchedCards$items$referredCustomer<
        TRes>
    implements
        CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer<
            TRes> {
  _CopyWithImpl$Query$ScratchedCards$scratchedCards$items$referredCustomer(
    this._instance,
    this._then,
  );

  final Query$ScratchedCards$scratchedCards$items$referredCustomer _instance;

  final TRes Function(
      Query$ScratchedCards$scratchedCards$items$referredCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$ScratchedCards$scratchedCards$items$referredCustomer(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        firstName: firstName == _undefined || firstName == null
            ? _instance.firstName
            : (firstName as String),
        lastName: lastName == _undefined || lastName == null
            ? _instance.lastName
            : (lastName as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$ScratchedCards$scratchedCards$items$referredCustomer<
        TRes>
    implements
        CopyWith$Query$ScratchedCards$scratchedCards$items$referredCustomer<
            TRes> {
  _CopyWithStubImpl$Query$ScratchedCards$scratchedCards$items$referredCustomer(
      this._res);

  TRes _res;

  call({
    String? id,
    String? firstName,
    String? lastName,
    String? $__typename,
  }) =>
      _res;
}

class Query$ReferralChannelPoints {
  Query$ReferralChannelPoints({
    this.referralChannelPoints,
    this.$__typename = 'Query',
  });

  factory Query$ReferralChannelPoints.fromJson(Map<String, dynamic> json) {
    final l$referralChannelPoints = json['referralChannelPoints'];
    final l$$__typename = json['__typename'];
    return Query$ReferralChannelPoints(
      referralChannelPoints: l$referralChannelPoints == null
          ? null
          : Query$ReferralChannelPoints$referralChannelPoints.fromJson(
              (l$referralChannelPoints as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$ReferralChannelPoints$referralChannelPoints?
      referralChannelPoints;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$referralChannelPoints = referralChannelPoints;
    _resultData['referralChannelPoints'] = l$referralChannelPoints?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$referralChannelPoints = referralChannelPoints;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$referralChannelPoints,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ReferralChannelPoints ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$referralChannelPoints = referralChannelPoints;
    final lOther$referralChannelPoints = other.referralChannelPoints;
    if (l$referralChannelPoints != lOther$referralChannelPoints) {
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

extension UtilityExtension$Query$ReferralChannelPoints
    on Query$ReferralChannelPoints {
  CopyWith$Query$ReferralChannelPoints<Query$ReferralChannelPoints>
      get copyWith => CopyWith$Query$ReferralChannelPoints(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$ReferralChannelPoints<TRes> {
  factory CopyWith$Query$ReferralChannelPoints(
    Query$ReferralChannelPoints instance,
    TRes Function(Query$ReferralChannelPoints) then,
  ) = _CopyWithImpl$Query$ReferralChannelPoints;

  factory CopyWith$Query$ReferralChannelPoints.stub(TRes res) =
      _CopyWithStubImpl$Query$ReferralChannelPoints;

  TRes call({
    Query$ReferralChannelPoints$referralChannelPoints? referralChannelPoints,
    String? $__typename,
  });
  CopyWith$Query$ReferralChannelPoints$referralChannelPoints<TRes>
      get referralChannelPoints;
}

class _CopyWithImpl$Query$ReferralChannelPoints<TRes>
    implements CopyWith$Query$ReferralChannelPoints<TRes> {
  _CopyWithImpl$Query$ReferralChannelPoints(
    this._instance,
    this._then,
  );

  final Query$ReferralChannelPoints _instance;

  final TRes Function(Query$ReferralChannelPoints) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? referralChannelPoints = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$ReferralChannelPoints(
        referralChannelPoints: referralChannelPoints == _undefined
            ? _instance.referralChannelPoints
            : (referralChannelPoints
                as Query$ReferralChannelPoints$referralChannelPoints?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$ReferralChannelPoints$referralChannelPoints<TRes>
      get referralChannelPoints {
    final local$referralChannelPoints = _instance.referralChannelPoints;
    return local$referralChannelPoints == null
        ? CopyWith$Query$ReferralChannelPoints$referralChannelPoints.stub(
            _then(_instance))
        : CopyWith$Query$ReferralChannelPoints$referralChannelPoints(
            local$referralChannelPoints, (e) => call(referralChannelPoints: e));
  }
}

class _CopyWithStubImpl$Query$ReferralChannelPoints<TRes>
    implements CopyWith$Query$ReferralChannelPoints<TRes> {
  _CopyWithStubImpl$Query$ReferralChannelPoints(this._res);

  TRes _res;

  call({
    Query$ReferralChannelPoints$referralChannelPoints? referralChannelPoints,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$ReferralChannelPoints$referralChannelPoints<TRes>
      get referralChannelPoints =>
          CopyWith$Query$ReferralChannelPoints$referralChannelPoints.stub(_res);
}

const documentNodeQueryReferralChannelPoints = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'ReferralChannelPoints'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'referralChannelPoints'),
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
            name: NameNode(value: 'points'),
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
Query$ReferralChannelPoints _parserFn$Query$ReferralChannelPoints(
        Map<String, dynamic> data) =>
    Query$ReferralChannelPoints.fromJson(data);
typedef OnQueryComplete$Query$ReferralChannelPoints = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$ReferralChannelPoints?,
);

class Options$Query$ReferralChannelPoints
    extends graphql.QueryOptions<Query$ReferralChannelPoints> {
  Options$Query$ReferralChannelPoints({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$ReferralChannelPoints? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$ReferralChannelPoints? onComplete,
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
                        : _parserFn$Query$ReferralChannelPoints(data),
                  ),
          onError: onError,
          document: documentNodeQueryReferralChannelPoints,
          parserFn: _parserFn$Query$ReferralChannelPoints,
        );

  final OnQueryComplete$Query$ReferralChannelPoints? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$ReferralChannelPoints
    extends graphql.WatchQueryOptions<Query$ReferralChannelPoints> {
  WatchOptions$Query$ReferralChannelPoints({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$ReferralChannelPoints? typedOptimisticResult,
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
          document: documentNodeQueryReferralChannelPoints,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$ReferralChannelPoints,
        );
}

class FetchMoreOptions$Query$ReferralChannelPoints
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$ReferralChannelPoints(
      {required graphql.UpdateQuery updateQuery})
      : super(
          updateQuery: updateQuery,
          document: documentNodeQueryReferralChannelPoints,
        );
}

extension ClientExtension$Query$ReferralChannelPoints on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$ReferralChannelPoints>>
      query$ReferralChannelPoints(
              [Options$Query$ReferralChannelPoints? options]) async =>
          await this.query(options ?? Options$Query$ReferralChannelPoints());
  graphql.ObservableQuery<
      Query$ReferralChannelPoints> watchQuery$ReferralChannelPoints(
          [WatchOptions$Query$ReferralChannelPoints? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$ReferralChannelPoints());
  void writeQuery$ReferralChannelPoints({
    required Query$ReferralChannelPoints data,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
            operation: graphql.Operation(
                document: documentNodeQueryReferralChannelPoints)),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$ReferralChannelPoints? readQuery$ReferralChannelPoints(
      {bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
          operation: graphql.Operation(
              document: documentNodeQueryReferralChannelPoints)),
      optimistic: optimistic,
    );
    return result == null ? null : Query$ReferralChannelPoints.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$ReferralChannelPoints>
    useQuery$ReferralChannelPoints(
            [Options$Query$ReferralChannelPoints? options]) =>
        graphql_flutter
            .useQuery(options ?? Options$Query$ReferralChannelPoints());
graphql.ObservableQuery<Query$ReferralChannelPoints>
    useWatchQuery$ReferralChannelPoints(
            [WatchOptions$Query$ReferralChannelPoints? options]) =>
        graphql_flutter.useWatchQuery(
            options ?? WatchOptions$Query$ReferralChannelPoints());

class Query$ReferralChannelPoints$Widget
    extends graphql_flutter.Query<Query$ReferralChannelPoints> {
  Query$ReferralChannelPoints$Widget({
    widgets.Key? key,
    Options$Query$ReferralChannelPoints? options,
    required graphql_flutter.QueryBuilder<Query$ReferralChannelPoints> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$ReferralChannelPoints(),
          builder: builder,
        );
}

class Query$ReferralChannelPoints$referralChannelPoints {
  Query$ReferralChannelPoints$referralChannelPoints({
    required this.id,
    required this.points,
    this.$__typename = 'ReferralChannelPoints',
  });

  factory Query$ReferralChannelPoints$referralChannelPoints.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$points = json['points'];
    final l$$__typename = json['__typename'];
    return Query$ReferralChannelPoints$referralChannelPoints(
      id: (l$id as String),
      points: (l$points as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int points;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$points = points;
    _resultData['points'] = l$points;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$points = points;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$points,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ReferralChannelPoints$referralChannelPoints ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$points = points;
    final lOther$points = other.points;
    if (l$points != lOther$points) {
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

extension UtilityExtension$Query$ReferralChannelPoints$referralChannelPoints
    on Query$ReferralChannelPoints$referralChannelPoints {
  CopyWith$Query$ReferralChannelPoints$referralChannelPoints<
          Query$ReferralChannelPoints$referralChannelPoints>
      get copyWith =>
          CopyWith$Query$ReferralChannelPoints$referralChannelPoints(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$ReferralChannelPoints$referralChannelPoints<
    TRes> {
  factory CopyWith$Query$ReferralChannelPoints$referralChannelPoints(
    Query$ReferralChannelPoints$referralChannelPoints instance,
    TRes Function(Query$ReferralChannelPoints$referralChannelPoints) then,
  ) = _CopyWithImpl$Query$ReferralChannelPoints$referralChannelPoints;

  factory CopyWith$Query$ReferralChannelPoints$referralChannelPoints.stub(
          TRes res) =
      _CopyWithStubImpl$Query$ReferralChannelPoints$referralChannelPoints;

  TRes call({
    String? id,
    int? points,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$ReferralChannelPoints$referralChannelPoints<TRes>
    implements
        CopyWith$Query$ReferralChannelPoints$referralChannelPoints<TRes> {
  _CopyWithImpl$Query$ReferralChannelPoints$referralChannelPoints(
    this._instance,
    this._then,
  );

  final Query$ReferralChannelPoints$referralChannelPoints _instance;

  final TRes Function(Query$ReferralChannelPoints$referralChannelPoints) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? points = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$ReferralChannelPoints$referralChannelPoints(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        points: points == _undefined || points == null
            ? _instance.points
            : (points as int),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$ReferralChannelPoints$referralChannelPoints<TRes>
    implements
        CopyWith$Query$ReferralChannelPoints$referralChannelPoints<TRes> {
  _CopyWithStubImpl$Query$ReferralChannelPoints$referralChannelPoints(
      this._res);

  TRes _res;

  call({
    String? id,
    int? points,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Mutation$RegisterReferral {
  factory Variables$Mutation$RegisterReferral({required String referrerId}) =>
      Variables$Mutation$RegisterReferral._({
        r'referrerId': referrerId,
      });

  Variables$Mutation$RegisterReferral._(this._$data);

  factory Variables$Mutation$RegisterReferral.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$referrerId = data['referrerId'];
    result$data['referrerId'] = (l$referrerId as String);
    return Variables$Mutation$RegisterReferral._(result$data);
  }

  Map<String, dynamic> _$data;

  String get referrerId => (_$data['referrerId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$referrerId = referrerId;
    result$data['referrerId'] = l$referrerId;
    return result$data;
  }

  CopyWith$Variables$Mutation$RegisterReferral<
          Variables$Mutation$RegisterReferral>
      get copyWith => CopyWith$Variables$Mutation$RegisterReferral(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RegisterReferral ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$referrerId = referrerId;
    final lOther$referrerId = other.referrerId;
    if (l$referrerId != lOther$referrerId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$referrerId = referrerId;
    return Object.hashAll([l$referrerId]);
  }
}

abstract class CopyWith$Variables$Mutation$RegisterReferral<TRes> {
  factory CopyWith$Variables$Mutation$RegisterReferral(
    Variables$Mutation$RegisterReferral instance,
    TRes Function(Variables$Mutation$RegisterReferral) then,
  ) = _CopyWithImpl$Variables$Mutation$RegisterReferral;

  factory CopyWith$Variables$Mutation$RegisterReferral.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RegisterReferral;

  TRes call({String? referrerId});
}

class _CopyWithImpl$Variables$Mutation$RegisterReferral<TRes>
    implements CopyWith$Variables$Mutation$RegisterReferral<TRes> {
  _CopyWithImpl$Variables$Mutation$RegisterReferral(
    this._instance,
    this._then,
  );

  final Variables$Mutation$RegisterReferral _instance;

  final TRes Function(Variables$Mutation$RegisterReferral) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? referrerId = _undefined}) =>
      _then(Variables$Mutation$RegisterReferral._({
        ..._instance._$data,
        if (referrerId != _undefined && referrerId != null)
          'referrerId': (referrerId as String),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$RegisterReferral<TRes>
    implements CopyWith$Variables$Mutation$RegisterReferral<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RegisterReferral(this._res);

  TRes _res;

  call({String? referrerId}) => _res;
}

class Mutation$RegisterReferral {
  Mutation$RegisterReferral({
    required this.registerReferral,
    this.$__typename = 'Mutation',
  });

  factory Mutation$RegisterReferral.fromJson(Map<String, dynamic> json) {
    final l$registerReferral = json['registerReferral'];
    final l$$__typename = json['__typename'];
    return Mutation$RegisterReferral(
      registerReferral: Mutation$RegisterReferral$registerReferral.fromJson(
          (l$registerReferral as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$RegisterReferral$registerReferral registerReferral;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$registerReferral = registerReferral;
    _resultData['registerReferral'] = l$registerReferral.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$registerReferral = registerReferral;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$registerReferral,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegisterReferral ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$registerReferral = registerReferral;
    final lOther$registerReferral = other.registerReferral;
    if (l$registerReferral != lOther$registerReferral) {
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

extension UtilityExtension$Mutation$RegisterReferral
    on Mutation$RegisterReferral {
  CopyWith$Mutation$RegisterReferral<Mutation$RegisterReferral> get copyWith =>
      CopyWith$Mutation$RegisterReferral(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$RegisterReferral<TRes> {
  factory CopyWith$Mutation$RegisterReferral(
    Mutation$RegisterReferral instance,
    TRes Function(Mutation$RegisterReferral) then,
  ) = _CopyWithImpl$Mutation$RegisterReferral;

  factory CopyWith$Mutation$RegisterReferral.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RegisterReferral;

  TRes call({
    Mutation$RegisterReferral$registerReferral? registerReferral,
    String? $__typename,
  });
  CopyWith$Mutation$RegisterReferral$registerReferral<TRes>
      get registerReferral;
}

class _CopyWithImpl$Mutation$RegisterReferral<TRes>
    implements CopyWith$Mutation$RegisterReferral<TRes> {
  _CopyWithImpl$Mutation$RegisterReferral(
    this._instance,
    this._then,
  );

  final Mutation$RegisterReferral _instance;

  final TRes Function(Mutation$RegisterReferral) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? registerReferral = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$RegisterReferral(
        registerReferral: registerReferral == _undefined ||
                registerReferral == null
            ? _instance.registerReferral
            : (registerReferral as Mutation$RegisterReferral$registerReferral),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$RegisterReferral$registerReferral<TRes>
      get registerReferral {
    final local$registerReferral = _instance.registerReferral;
    return CopyWith$Mutation$RegisterReferral$registerReferral(
        local$registerReferral, (e) => call(registerReferral: e));
  }
}

class _CopyWithStubImpl$Mutation$RegisterReferral<TRes>
    implements CopyWith$Mutation$RegisterReferral<TRes> {
  _CopyWithStubImpl$Mutation$RegisterReferral(this._res);

  TRes _res;

  call({
    Mutation$RegisterReferral$registerReferral? registerReferral,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$RegisterReferral$registerReferral<TRes>
      get registerReferral =>
          CopyWith$Mutation$RegisterReferral$registerReferral.stub(_res);
}

const documentNodeMutationRegisterReferral = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'RegisterReferral'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'referrerId')),
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
        name: NameNode(value: 'registerReferral'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'referrerId'),
            value: VariableNode(name: NameNode(value: 'referrerId')),
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
            name: NameNode(value: 'referralNumber'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'status'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'note'),
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
Mutation$RegisterReferral _parserFn$Mutation$RegisterReferral(
        Map<String, dynamic> data) =>
    Mutation$RegisterReferral.fromJson(data);
typedef OnMutationCompleted$Mutation$RegisterReferral = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$RegisterReferral?,
);

class Options$Mutation$RegisterReferral
    extends graphql.MutationOptions<Mutation$RegisterReferral> {
  Options$Mutation$RegisterReferral({
    String? operationName,
    required Variables$Mutation$RegisterReferral variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$RegisterReferral? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$RegisterReferral? onCompleted,
    graphql.OnMutationUpdate<Mutation$RegisterReferral>? update,
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
                    data == null
                        ? null
                        : _parserFn$Mutation$RegisterReferral(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationRegisterReferral,
          parserFn: _parserFn$Mutation$RegisterReferral,
        );

  final OnMutationCompleted$Mutation$RegisterReferral? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$RegisterReferral
    extends graphql.WatchQueryOptions<Mutation$RegisterReferral> {
  WatchOptions$Mutation$RegisterReferral({
    String? operationName,
    required Variables$Mutation$RegisterReferral variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$RegisterReferral? typedOptimisticResult,
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
          document: documentNodeMutationRegisterReferral,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$RegisterReferral,
        );
}

extension ClientExtension$Mutation$RegisterReferral on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$RegisterReferral>>
      mutate$RegisterReferral(
              Options$Mutation$RegisterReferral options) async =>
          await this.mutate(options);
  graphql.ObservableQuery<Mutation$RegisterReferral>
      watchMutation$RegisterReferral(
              WatchOptions$Mutation$RegisterReferral options) =>
          this.watchMutation(options);
}

class Mutation$RegisterReferral$HookResult {
  Mutation$RegisterReferral$HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation$Mutation$RegisterReferral runMutation;

  final graphql.QueryResult<Mutation$RegisterReferral> result;
}

Mutation$RegisterReferral$HookResult useMutation$RegisterReferral(
    [WidgetOptions$Mutation$RegisterReferral? options]) {
  final result = graphql_flutter
      .useMutation(options ?? WidgetOptions$Mutation$RegisterReferral());
  return Mutation$RegisterReferral$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
      variables.toJson(),
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$RegisterReferral>
    useWatchMutation$RegisterReferral(
            WatchOptions$Mutation$RegisterReferral options) =>
        graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$RegisterReferral
    extends graphql.MutationOptions<Mutation$RegisterReferral> {
  WidgetOptions$Mutation$RegisterReferral({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$RegisterReferral? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$RegisterReferral? onCompleted,
    graphql.OnMutationUpdate<Mutation$RegisterReferral>? update,
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
                    data == null
                        ? null
                        : _parserFn$Mutation$RegisterReferral(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationRegisterReferral,
          parserFn: _parserFn$Mutation$RegisterReferral,
        );

  final OnMutationCompleted$Mutation$RegisterReferral? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

typedef RunMutation$Mutation$RegisterReferral
    = graphql.MultiSourceResult<Mutation$RegisterReferral> Function(
  Variables$Mutation$RegisterReferral, {
  Object? optimisticResult,
  Mutation$RegisterReferral? typedOptimisticResult,
});
typedef Builder$Mutation$RegisterReferral = widgets.Widget Function(
  RunMutation$Mutation$RegisterReferral,
  graphql.QueryResult<Mutation$RegisterReferral>?,
);

class Mutation$RegisterReferral$Widget
    extends graphql_flutter.Mutation<Mutation$RegisterReferral> {
  Mutation$RegisterReferral$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$RegisterReferral? options,
    required Builder$Mutation$RegisterReferral builder,
  }) : super(
          key: key,
          options: options ?? WidgetOptions$Mutation$RegisterReferral(),
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

class Mutation$RegisterReferral$registerReferral {
  Mutation$RegisterReferral$registerReferral({
    required this.id,
    required this.referralNumber,
    required this.status,
    this.note,
    this.$__typename = 'Referral',
  });

  factory Mutation$RegisterReferral$registerReferral.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$referralNumber = json['referralNumber'];
    final l$status = json['status'];
    final l$note = json['note'];
    final l$$__typename = json['__typename'];
    return Mutation$RegisterReferral$registerReferral(
      id: (l$id as String),
      referralNumber: (l$referralNumber as int),
      status: fromJson$Enum$ReferralStatus((l$status as String)),
      note: (l$note as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int referralNumber;

  final Enum$ReferralStatus status;

  final String? note;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$referralNumber = referralNumber;
    _resultData['referralNumber'] = l$referralNumber;
    final l$status = status;
    _resultData['status'] = toJson$Enum$ReferralStatus(l$status);
    final l$note = note;
    _resultData['note'] = l$note;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$referralNumber = referralNumber;
    final l$status = status;
    final l$note = note;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$referralNumber,
      l$status,
      l$note,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegisterReferral$registerReferral ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$referralNumber = referralNumber;
    final lOther$referralNumber = other.referralNumber;
    if (l$referralNumber != lOther$referralNumber) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$note = note;
    final lOther$note = other.note;
    if (l$note != lOther$note) {
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

extension UtilityExtension$Mutation$RegisterReferral$registerReferral
    on Mutation$RegisterReferral$registerReferral {
  CopyWith$Mutation$RegisterReferral$registerReferral<
          Mutation$RegisterReferral$registerReferral>
      get copyWith => CopyWith$Mutation$RegisterReferral$registerReferral(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$RegisterReferral$registerReferral<TRes> {
  factory CopyWith$Mutation$RegisterReferral$registerReferral(
    Mutation$RegisterReferral$registerReferral instance,
    TRes Function(Mutation$RegisterReferral$registerReferral) then,
  ) = _CopyWithImpl$Mutation$RegisterReferral$registerReferral;

  factory CopyWith$Mutation$RegisterReferral$registerReferral.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RegisterReferral$registerReferral;

  TRes call({
    String? id,
    int? referralNumber,
    Enum$ReferralStatus? status,
    String? note,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$RegisterReferral$registerReferral<TRes>
    implements CopyWith$Mutation$RegisterReferral$registerReferral<TRes> {
  _CopyWithImpl$Mutation$RegisterReferral$registerReferral(
    this._instance,
    this._then,
  );

  final Mutation$RegisterReferral$registerReferral _instance;

  final TRes Function(Mutation$RegisterReferral$registerReferral) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? referralNumber = _undefined,
    Object? status = _undefined,
    Object? note = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$RegisterReferral$registerReferral(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        referralNumber: referralNumber == _undefined || referralNumber == null
            ? _instance.referralNumber
            : (referralNumber as int),
        status: status == _undefined || status == null
            ? _instance.status
            : (status as Enum$ReferralStatus),
        note: note == _undefined ? _instance.note : (note as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$RegisterReferral$registerReferral<TRes>
    implements CopyWith$Mutation$RegisterReferral$registerReferral<TRes> {
  _CopyWithStubImpl$Mutation$RegisterReferral$registerReferral(this._res);

  TRes _res;

  call({
    String? id,
    int? referralNumber,
    Enum$ReferralStatus? status,
    String? note,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Mutation$ScratchReferralCard {
  factory Variables$Mutation$ScratchReferralCard(
          {required int referralNumber}) =>
      Variables$Mutation$ScratchReferralCard._({
        r'referralNumber': referralNumber,
      });

  Variables$Mutation$ScratchReferralCard._(this._$data);

  factory Variables$Mutation$ScratchReferralCard.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$referralNumber = data['referralNumber'];
    result$data['referralNumber'] = (l$referralNumber as int);
    return Variables$Mutation$ScratchReferralCard._(result$data);
  }

  Map<String, dynamic> _$data;

  int get referralNumber => (_$data['referralNumber'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$referralNumber = referralNumber;
    result$data['referralNumber'] = l$referralNumber;
    return result$data;
  }

  CopyWith$Variables$Mutation$ScratchReferralCard<
          Variables$Mutation$ScratchReferralCard>
      get copyWith => CopyWith$Variables$Mutation$ScratchReferralCard(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ScratchReferralCard ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$referralNumber = referralNumber;
    final lOther$referralNumber = other.referralNumber;
    if (l$referralNumber != lOther$referralNumber) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$referralNumber = referralNumber;
    return Object.hashAll([l$referralNumber]);
  }
}

abstract class CopyWith$Variables$Mutation$ScratchReferralCard<TRes> {
  factory CopyWith$Variables$Mutation$ScratchReferralCard(
    Variables$Mutation$ScratchReferralCard instance,
    TRes Function(Variables$Mutation$ScratchReferralCard) then,
  ) = _CopyWithImpl$Variables$Mutation$ScratchReferralCard;

  factory CopyWith$Variables$Mutation$ScratchReferralCard.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ScratchReferralCard;

  TRes call({int? referralNumber});
}

class _CopyWithImpl$Variables$Mutation$ScratchReferralCard<TRes>
    implements CopyWith$Variables$Mutation$ScratchReferralCard<TRes> {
  _CopyWithImpl$Variables$Mutation$ScratchReferralCard(
    this._instance,
    this._then,
  );

  final Variables$Mutation$ScratchReferralCard _instance;

  final TRes Function(Variables$Mutation$ScratchReferralCard) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? referralNumber = _undefined}) =>
      _then(Variables$Mutation$ScratchReferralCard._({
        ..._instance._$data,
        if (referralNumber != _undefined && referralNumber != null)
          'referralNumber': (referralNumber as int),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$ScratchReferralCard<TRes>
    implements CopyWith$Variables$Mutation$ScratchReferralCard<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ScratchReferralCard(this._res);

  TRes _res;

  call({int? referralNumber}) => _res;
}

class Mutation$ScratchReferralCard {
  Mutation$ScratchReferralCard({
    required this.scratchReferralCard,
    this.$__typename = 'Mutation',
  });

  factory Mutation$ScratchReferralCard.fromJson(Map<String, dynamic> json) {
    final l$scratchReferralCard = json['scratchReferralCard'];
    final l$$__typename = json['__typename'];
    return Mutation$ScratchReferralCard(
      scratchReferralCard:
          Mutation$ScratchReferralCard$scratchReferralCard.fromJson(
              (l$scratchReferralCard as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$ScratchReferralCard$scratchReferralCard scratchReferralCard;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$scratchReferralCard = scratchReferralCard;
    _resultData['scratchReferralCard'] = l$scratchReferralCard.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$scratchReferralCard = scratchReferralCard;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$scratchReferralCard,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ScratchReferralCard ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scratchReferralCard = scratchReferralCard;
    final lOther$scratchReferralCard = other.scratchReferralCard;
    if (l$scratchReferralCard != lOther$scratchReferralCard) {
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

extension UtilityExtension$Mutation$ScratchReferralCard
    on Mutation$ScratchReferralCard {
  CopyWith$Mutation$ScratchReferralCard<Mutation$ScratchReferralCard>
      get copyWith => CopyWith$Mutation$ScratchReferralCard(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$ScratchReferralCard<TRes> {
  factory CopyWith$Mutation$ScratchReferralCard(
    Mutation$ScratchReferralCard instance,
    TRes Function(Mutation$ScratchReferralCard) then,
  ) = _CopyWithImpl$Mutation$ScratchReferralCard;

  factory CopyWith$Mutation$ScratchReferralCard.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ScratchReferralCard;

  TRes call({
    Mutation$ScratchReferralCard$scratchReferralCard? scratchReferralCard,
    String? $__typename,
  });
  CopyWith$Mutation$ScratchReferralCard$scratchReferralCard<TRes>
      get scratchReferralCard;
}

class _CopyWithImpl$Mutation$ScratchReferralCard<TRes>
    implements CopyWith$Mutation$ScratchReferralCard<TRes> {
  _CopyWithImpl$Mutation$ScratchReferralCard(
    this._instance,
    this._then,
  );

  final Mutation$ScratchReferralCard _instance;

  final TRes Function(Mutation$ScratchReferralCard) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? scratchReferralCard = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$ScratchReferralCard(
        scratchReferralCard:
            scratchReferralCard == _undefined || scratchReferralCard == null
                ? _instance.scratchReferralCard
                : (scratchReferralCard
                    as Mutation$ScratchReferralCard$scratchReferralCard),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$ScratchReferralCard$scratchReferralCard<TRes>
      get scratchReferralCard {
    final local$scratchReferralCard = _instance.scratchReferralCard;
    return CopyWith$Mutation$ScratchReferralCard$scratchReferralCard(
        local$scratchReferralCard, (e) => call(scratchReferralCard: e));
  }
}

class _CopyWithStubImpl$Mutation$ScratchReferralCard<TRes>
    implements CopyWith$Mutation$ScratchReferralCard<TRes> {
  _CopyWithStubImpl$Mutation$ScratchReferralCard(this._res);

  TRes _res;

  call({
    Mutation$ScratchReferralCard$scratchReferralCard? scratchReferralCard,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$ScratchReferralCard$scratchReferralCard<TRes>
      get scratchReferralCard =>
          CopyWith$Mutation$ScratchReferralCard$scratchReferralCard.stub(_res);
}

const documentNodeMutationScratchReferralCard = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'ScratchReferralCard'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'referralNumber')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'scratchReferralCard'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'referralNumber'),
            value: VariableNode(name: NameNode(value: 'referralNumber')),
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
            name: NameNode(value: 'referralNumber'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'status'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'points'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'isScratched'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'note'),
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
Mutation$ScratchReferralCard _parserFn$Mutation$ScratchReferralCard(
        Map<String, dynamic> data) =>
    Mutation$ScratchReferralCard.fromJson(data);
typedef OnMutationCompleted$Mutation$ScratchReferralCard = FutureOr<void>
    Function(
  Map<String, dynamic>?,
  Mutation$ScratchReferralCard?,
);

class Options$Mutation$ScratchReferralCard
    extends graphql.MutationOptions<Mutation$ScratchReferralCard> {
  Options$Mutation$ScratchReferralCard({
    String? operationName,
    required Variables$Mutation$ScratchReferralCard variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ScratchReferralCard? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$ScratchReferralCard? onCompleted,
    graphql.OnMutationUpdate<Mutation$ScratchReferralCard>? update,
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
                    data == null
                        ? null
                        : _parserFn$Mutation$ScratchReferralCard(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationScratchReferralCard,
          parserFn: _parserFn$Mutation$ScratchReferralCard,
        );

  final OnMutationCompleted$Mutation$ScratchReferralCard? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$ScratchReferralCard
    extends graphql.WatchQueryOptions<Mutation$ScratchReferralCard> {
  WatchOptions$Mutation$ScratchReferralCard({
    String? operationName,
    required Variables$Mutation$ScratchReferralCard variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ScratchReferralCard? typedOptimisticResult,
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
          document: documentNodeMutationScratchReferralCard,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$ScratchReferralCard,
        );
}

extension ClientExtension$Mutation$ScratchReferralCard
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$ScratchReferralCard>>
      mutate$ScratchReferralCard(
              Options$Mutation$ScratchReferralCard options) async =>
          await this.mutate(options);
  graphql.ObservableQuery<Mutation$ScratchReferralCard>
      watchMutation$ScratchReferralCard(
              WatchOptions$Mutation$ScratchReferralCard options) =>
          this.watchMutation(options);
}

class Mutation$ScratchReferralCard$HookResult {
  Mutation$ScratchReferralCard$HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation$Mutation$ScratchReferralCard runMutation;

  final graphql.QueryResult<Mutation$ScratchReferralCard> result;
}

Mutation$ScratchReferralCard$HookResult useMutation$ScratchReferralCard(
    [WidgetOptions$Mutation$ScratchReferralCard? options]) {
  final result = graphql_flutter
      .useMutation(options ?? WidgetOptions$Mutation$ScratchReferralCard());
  return Mutation$ScratchReferralCard$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
      variables.toJson(),
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$ScratchReferralCard>
    useWatchMutation$ScratchReferralCard(
            WatchOptions$Mutation$ScratchReferralCard options) =>
        graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$ScratchReferralCard
    extends graphql.MutationOptions<Mutation$ScratchReferralCard> {
  WidgetOptions$Mutation$ScratchReferralCard({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ScratchReferralCard? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$ScratchReferralCard? onCompleted,
    graphql.OnMutationUpdate<Mutation$ScratchReferralCard>? update,
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
                    data == null
                        ? null
                        : _parserFn$Mutation$ScratchReferralCard(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationScratchReferralCard,
          parserFn: _parserFn$Mutation$ScratchReferralCard,
        );

  final OnMutationCompleted$Mutation$ScratchReferralCard? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

typedef RunMutation$Mutation$ScratchReferralCard
    = graphql.MultiSourceResult<Mutation$ScratchReferralCard> Function(
  Variables$Mutation$ScratchReferralCard, {
  Object? optimisticResult,
  Mutation$ScratchReferralCard? typedOptimisticResult,
});
typedef Builder$Mutation$ScratchReferralCard = widgets.Widget Function(
  RunMutation$Mutation$ScratchReferralCard,
  graphql.QueryResult<Mutation$ScratchReferralCard>?,
);

class Mutation$ScratchReferralCard$Widget
    extends graphql_flutter.Mutation<Mutation$ScratchReferralCard> {
  Mutation$ScratchReferralCard$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$ScratchReferralCard? options,
    required Builder$Mutation$ScratchReferralCard builder,
  }) : super(
          key: key,
          options: options ?? WidgetOptions$Mutation$ScratchReferralCard(),
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

class Mutation$ScratchReferralCard$scratchReferralCard {
  Mutation$ScratchReferralCard$scratchReferralCard({
    required this.id,
    required this.referralNumber,
    required this.status,
    required this.points,
    required this.isScratched,
    this.note,
    this.$__typename = 'Referral',
  });

  factory Mutation$ScratchReferralCard$scratchReferralCard.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$referralNumber = json['referralNumber'];
    final l$status = json['status'];
    final l$points = json['points'];
    final l$isScratched = json['isScratched'];
    final l$note = json['note'];
    final l$$__typename = json['__typename'];
    return Mutation$ScratchReferralCard$scratchReferralCard(
      id: (l$id as String),
      referralNumber: (l$referralNumber as int),
      status: fromJson$Enum$ReferralStatus((l$status as String)),
      points: (l$points as int),
      isScratched: (l$isScratched as bool),
      note: (l$note as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int referralNumber;

  final Enum$ReferralStatus status;

  final int points;

  final bool isScratched;

  final String? note;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$referralNumber = referralNumber;
    _resultData['referralNumber'] = l$referralNumber;
    final l$status = status;
    _resultData['status'] = toJson$Enum$ReferralStatus(l$status);
    final l$points = points;
    _resultData['points'] = l$points;
    final l$isScratched = isScratched;
    _resultData['isScratched'] = l$isScratched;
    final l$note = note;
    _resultData['note'] = l$note;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$referralNumber = referralNumber;
    final l$status = status;
    final l$points = points;
    final l$isScratched = isScratched;
    final l$note = note;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$referralNumber,
      l$status,
      l$points,
      l$isScratched,
      l$note,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ScratchReferralCard$scratchReferralCard ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$referralNumber = referralNumber;
    final lOther$referralNumber = other.referralNumber;
    if (l$referralNumber != lOther$referralNumber) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$points = points;
    final lOther$points = other.points;
    if (l$points != lOther$points) {
      return false;
    }
    final l$isScratched = isScratched;
    final lOther$isScratched = other.isScratched;
    if (l$isScratched != lOther$isScratched) {
      return false;
    }
    final l$note = note;
    final lOther$note = other.note;
    if (l$note != lOther$note) {
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

extension UtilityExtension$Mutation$ScratchReferralCard$scratchReferralCard
    on Mutation$ScratchReferralCard$scratchReferralCard {
  CopyWith$Mutation$ScratchReferralCard$scratchReferralCard<
          Mutation$ScratchReferralCard$scratchReferralCard>
      get copyWith => CopyWith$Mutation$ScratchReferralCard$scratchReferralCard(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$ScratchReferralCard$scratchReferralCard<TRes> {
  factory CopyWith$Mutation$ScratchReferralCard$scratchReferralCard(
    Mutation$ScratchReferralCard$scratchReferralCard instance,
    TRes Function(Mutation$ScratchReferralCard$scratchReferralCard) then,
  ) = _CopyWithImpl$Mutation$ScratchReferralCard$scratchReferralCard;

  factory CopyWith$Mutation$ScratchReferralCard$scratchReferralCard.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$ScratchReferralCard$scratchReferralCard;

  TRes call({
    String? id,
    int? referralNumber,
    Enum$ReferralStatus? status,
    int? points,
    bool? isScratched,
    String? note,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$ScratchReferralCard$scratchReferralCard<TRes>
    implements CopyWith$Mutation$ScratchReferralCard$scratchReferralCard<TRes> {
  _CopyWithImpl$Mutation$ScratchReferralCard$scratchReferralCard(
    this._instance,
    this._then,
  );

  final Mutation$ScratchReferralCard$scratchReferralCard _instance;

  final TRes Function(Mutation$ScratchReferralCard$scratchReferralCard) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? referralNumber = _undefined,
    Object? status = _undefined,
    Object? points = _undefined,
    Object? isScratched = _undefined,
    Object? note = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$ScratchReferralCard$scratchReferralCard(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        referralNumber: referralNumber == _undefined || referralNumber == null
            ? _instance.referralNumber
            : (referralNumber as int),
        status: status == _undefined || status == null
            ? _instance.status
            : (status as Enum$ReferralStatus),
        points: points == _undefined || points == null
            ? _instance.points
            : (points as int),
        isScratched: isScratched == _undefined || isScratched == null
            ? _instance.isScratched
            : (isScratched as bool),
        note: note == _undefined ? _instance.note : (note as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$ScratchReferralCard$scratchReferralCard<TRes>
    implements CopyWith$Mutation$ScratchReferralCard$scratchReferralCard<TRes> {
  _CopyWithStubImpl$Mutation$ScratchReferralCard$scratchReferralCard(this._res);

  TRes _res;

  call({
    String? id,
    int? referralNumber,
    Enum$ReferralStatus? status,
    int? points,
    bool? isScratched,
    String? note,
    String? $__typename,
  }) =>
      _res;
}
