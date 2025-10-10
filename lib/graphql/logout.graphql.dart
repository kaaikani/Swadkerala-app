import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Mutation$LogoutUser {
  Mutation$LogoutUser({required this.logout, this.$__typename = 'Mutation'});

  factory Mutation$LogoutUser.fromJson(Map<String, dynamic> json) {
    final l$logout = json['logout'];
    final l$$__typename = json['__typename'];
    return Mutation$LogoutUser(
      logout: Mutation$LogoutUser$logout.fromJson(
        (l$logout as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$LogoutUser$logout logout;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$logout = logout;
    _resultData['logout'] = l$logout.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$logout = logout;
    final l$$__typename = $__typename;
    return Object.hashAll([l$logout, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$LogoutUser || runtimeType != other.runtimeType) {
      return false;
    }
    final l$logout = logout;
    final lOther$logout = other.logout;
    if (l$logout != lOther$logout) {
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

extension UtilityExtension$Mutation$LogoutUser on Mutation$LogoutUser {
  CopyWith$Mutation$LogoutUser<Mutation$LogoutUser> get copyWith =>
      CopyWith$Mutation$LogoutUser(this, (i) => i);
}

abstract class CopyWith$Mutation$LogoutUser<TRes> {
  factory CopyWith$Mutation$LogoutUser(
    Mutation$LogoutUser instance,
    TRes Function(Mutation$LogoutUser) then,
  ) = _CopyWithImpl$Mutation$LogoutUser;

  factory CopyWith$Mutation$LogoutUser.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LogoutUser;

  TRes call({Mutation$LogoutUser$logout? logout, String? $__typename});
  CopyWith$Mutation$LogoutUser$logout<TRes> get logout;
}

class _CopyWithImpl$Mutation$LogoutUser<TRes>
    implements CopyWith$Mutation$LogoutUser<TRes> {
  _CopyWithImpl$Mutation$LogoutUser(this._instance, this._then);

  final Mutation$LogoutUser _instance;

  final TRes Function(Mutation$LogoutUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? logout = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation$LogoutUser(
          logout: logout == _undefined || logout == null
              ? _instance.logout
              : (logout as Mutation$LogoutUser$logout),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Mutation$LogoutUser$logout<TRes> get logout {
    final local$logout = _instance.logout;
    return CopyWith$Mutation$LogoutUser$logout(
      local$logout,
      (e) => call(logout: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$LogoutUser<TRes>
    implements CopyWith$Mutation$LogoutUser<TRes> {
  _CopyWithStubImpl$Mutation$LogoutUser(this._res);

  TRes _res;

  call({Mutation$LogoutUser$logout? logout, String? $__typename}) => _res;

  CopyWith$Mutation$LogoutUser$logout<TRes> get logout =>
      CopyWith$Mutation$LogoutUser$logout.stub(_res);
}

const documentNodeMutationLogoutUser = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'LogoutUser'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'logout'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'success'),
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
Mutation$LogoutUser _parserFn$Mutation$LogoutUser(Map<String, dynamic> data) =>
    Mutation$LogoutUser.fromJson(data);
typedef OnMutationCompleted$Mutation$LogoutUser =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation$LogoutUser?);

class Options$Mutation$LogoutUser
    extends graphql.MutationOptions<Mutation$LogoutUser> {
  Options$Mutation$LogoutUser({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$LogoutUser? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$LogoutUser? onCompleted,
    graphql.OnMutationUpdate<Mutation$LogoutUser>? update,
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
                 data == null ? null : _parserFn$Mutation$LogoutUser(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationLogoutUser,
         parserFn: _parserFn$Mutation$LogoutUser,
       );

  final OnMutationCompleted$Mutation$LogoutUser? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$LogoutUser
    extends graphql.WatchQueryOptions<Mutation$LogoutUser> {
  WatchOptions$Mutation$LogoutUser({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$LogoutUser? typedOptimisticResult,
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
         document: documentNodeMutationLogoutUser,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$LogoutUser,
       );
}

extension ClientExtension$Mutation$LogoutUser on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$LogoutUser>> mutate$LogoutUser([
    Options$Mutation$LogoutUser? options,
  ]) async => await this.mutate(options ?? Options$Mutation$LogoutUser());

  graphql.ObservableQuery<Mutation$LogoutUser> watchMutation$LogoutUser([
    WatchOptions$Mutation$LogoutUser? options,
  ]) => this.watchMutation(options ?? WatchOptions$Mutation$LogoutUser());
}

class Mutation$LogoutUser$HookResult {
  Mutation$LogoutUser$HookResult(this.runMutation, this.result);

  final RunMutation$Mutation$LogoutUser runMutation;

  final graphql.QueryResult<Mutation$LogoutUser> result;
}

Mutation$LogoutUser$HookResult useMutation$LogoutUser([
  WidgetOptions$Mutation$LogoutUser? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions$Mutation$LogoutUser(),
  );
  return Mutation$LogoutUser$HookResult(
    ({optimisticResult, typedOptimisticResult}) => result.runMutation(
      const {},
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$LogoutUser> useWatchMutation$LogoutUser([
  WatchOptions$Mutation$LogoutUser? options,
]) => graphql_flutter.useWatchMutation(
  options ?? WatchOptions$Mutation$LogoutUser(),
);

class WidgetOptions$Mutation$LogoutUser
    extends graphql.MutationOptions<Mutation$LogoutUser> {
  WidgetOptions$Mutation$LogoutUser({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$LogoutUser? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$LogoutUser? onCompleted,
    graphql.OnMutationUpdate<Mutation$LogoutUser>? update,
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
                 data == null ? null : _parserFn$Mutation$LogoutUser(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationLogoutUser,
         parserFn: _parserFn$Mutation$LogoutUser,
       );

  final OnMutationCompleted$Mutation$LogoutUser? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation$Mutation$LogoutUser =
    graphql.MultiSourceResult<Mutation$LogoutUser> Function({
      Object? optimisticResult,
      Mutation$LogoutUser? typedOptimisticResult,
    });
typedef Builder$Mutation$LogoutUser =
    widgets.Widget Function(
      RunMutation$Mutation$LogoutUser,
      graphql.QueryResult<Mutation$LogoutUser>?,
    );

class Mutation$LogoutUser$Widget
    extends graphql_flutter.Mutation<Mutation$LogoutUser> {
  Mutation$LogoutUser$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$LogoutUser? options,
    required Builder$Mutation$LogoutUser builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions$Mutation$LogoutUser(),
         builder: (run, result) => builder(
           ({optimisticResult, typedOptimisticResult}) => run(
             const {},
             optimisticResult:
                 optimisticResult ?? typedOptimisticResult?.toJson(),
           ),
           result,
         ),
       );
}

class Mutation$LogoutUser$logout {
  Mutation$LogoutUser$logout({
    required this.success,
    this.$__typename = 'Success',
  });

  factory Mutation$LogoutUser$logout.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$$__typename = json['__typename'];
    return Mutation$LogoutUser$logout(
      success: (l$success as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool success;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$$__typename = $__typename;
    return Object.hashAll([l$success, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$LogoutUser$logout ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$success = success;
    final lOther$success = other.success;
    if (l$success != lOther$success) {
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

extension UtilityExtension$Mutation$LogoutUser$logout
    on Mutation$LogoutUser$logout {
  CopyWith$Mutation$LogoutUser$logout<Mutation$LogoutUser$logout>
  get copyWith => CopyWith$Mutation$LogoutUser$logout(this, (i) => i);
}

abstract class CopyWith$Mutation$LogoutUser$logout<TRes> {
  factory CopyWith$Mutation$LogoutUser$logout(
    Mutation$LogoutUser$logout instance,
    TRes Function(Mutation$LogoutUser$logout) then,
  ) = _CopyWithImpl$Mutation$LogoutUser$logout;

  factory CopyWith$Mutation$LogoutUser$logout.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LogoutUser$logout;

  TRes call({bool? success, String? $__typename});
}

class _CopyWithImpl$Mutation$LogoutUser$logout<TRes>
    implements CopyWith$Mutation$LogoutUser$logout<TRes> {
  _CopyWithImpl$Mutation$LogoutUser$logout(this._instance, this._then);

  final Mutation$LogoutUser$logout _instance;

  final TRes Function(Mutation$LogoutUser$logout) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation$LogoutUser$logout(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Mutation$LogoutUser$logout<TRes>
    implements CopyWith$Mutation$LogoutUser$logout<TRes> {
  _CopyWithStubImpl$Mutation$LogoutUser$logout(this._res);

  TRes _res;

  call({bool? success, String? $__typename}) => _res;
}
