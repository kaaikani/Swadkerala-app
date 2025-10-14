import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Variables$Mutation$Authenticate {
  factory Variables$Mutation$Authenticate({
    required String phoneNumber,
    required String code,
    String? firstName,
    String? lastName,
  }) => Variables$Mutation$Authenticate._({
    r'phoneNumber': phoneNumber,
    r'code': code,
    if (firstName != null) r'firstName': firstName,
    if (lastName != null) r'lastName': lastName,
  });

  Variables$Mutation$Authenticate._(this._$data);

  factory Variables$Mutation$Authenticate.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$phoneNumber = data['phoneNumber'];
    result$data['phoneNumber'] = (l$phoneNumber as String);
    final l$code = data['code'];
    result$data['code'] = (l$code as String);
    if (data.containsKey('firstName')) {
      final l$firstName = data['firstName'];
      result$data['firstName'] = (l$firstName as String?);
    }
    if (data.containsKey('lastName')) {
      final l$lastName = data['lastName'];
      result$data['lastName'] = (l$lastName as String?);
    }
    return Variables$Mutation$Authenticate._(result$data);
  }

  Map<String, dynamic> _$data;

  String get phoneNumber => (_$data['phoneNumber'] as String);

  String get code => (_$data['code'] as String);

  String? get firstName => (_$data['firstName'] as String?);

  String? get lastName => (_$data['lastName'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$phoneNumber = phoneNumber;
    result$data['phoneNumber'] = l$phoneNumber;
    final l$code = code;
    result$data['code'] = l$code;
    if (_$data.containsKey('firstName')) {
      final l$firstName = firstName;
      result$data['firstName'] = l$firstName;
    }
    if (_$data.containsKey('lastName')) {
      final l$lastName = lastName;
      result$data['lastName'] = l$lastName;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$Authenticate<Variables$Mutation$Authenticate>
  get copyWith => CopyWith$Variables$Mutation$Authenticate(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$Authenticate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$phoneNumber = phoneNumber;
    final lOther$phoneNumber = other.phoneNumber;
    if (l$phoneNumber != lOther$phoneNumber) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$firstName = firstName;
    final lOther$firstName = other.firstName;
    if (_$data.containsKey('firstName') !=
        other._$data.containsKey('firstName')) {
      return false;
    }
    if (l$firstName != lOther$firstName) {
      return false;
    }
    final l$lastName = lastName;
    final lOther$lastName = other.lastName;
    if (_$data.containsKey('lastName') !=
        other._$data.containsKey('lastName')) {
      return false;
    }
    if (l$lastName != lOther$lastName) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$phoneNumber = phoneNumber;
    final l$code = code;
    final l$firstName = firstName;
    final l$lastName = lastName;
    return Object.hashAll([
      l$phoneNumber,
      l$code,
      _$data.containsKey('firstName') ? l$firstName : const {},
      _$data.containsKey('lastName') ? l$lastName : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$Authenticate<TRes> {
  factory CopyWith$Variables$Mutation$Authenticate(
    Variables$Mutation$Authenticate instance,
    TRes Function(Variables$Mutation$Authenticate) then,
  ) = _CopyWithImpl$Variables$Mutation$Authenticate;

  factory CopyWith$Variables$Mutation$Authenticate.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$Authenticate;

  TRes call({
    String? phoneNumber,
    String? code,
    String? firstName,
    String? lastName,
  });
}

class _CopyWithImpl$Variables$Mutation$Authenticate<TRes>
    implements CopyWith$Variables$Mutation$Authenticate<TRes> {
  _CopyWithImpl$Variables$Mutation$Authenticate(this._instance, this._then);

  final Variables$Mutation$Authenticate _instance;

  final TRes Function(Variables$Mutation$Authenticate) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? phoneNumber = _undefined,
    Object? code = _undefined,
    Object? firstName = _undefined,
    Object? lastName = _undefined,
  }) => _then(
    Variables$Mutation$Authenticate._({
      ..._instance._$data,
      if (phoneNumber != _undefined && phoneNumber != null)
        'phoneNumber': (phoneNumber as String),
      if (code != _undefined && code != null) 'code': (code as String),
      if (firstName != _undefined) 'firstName': (firstName as String?),
      if (lastName != _undefined) 'lastName': (lastName as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$Authenticate<TRes>
    implements CopyWith$Variables$Mutation$Authenticate<TRes> {
  _CopyWithStubImpl$Variables$Mutation$Authenticate(this._res);

  TRes _res;

  call({
    String? phoneNumber,
    String? code,
    String? firstName,
    String? lastName,
  }) => _res;
}

class Mutation$Authenticate {
  Mutation$Authenticate({
    required this.authenticate,
    this.$__typename = 'Mutation',
  });

  factory Mutation$Authenticate.fromJson(Map<String, dynamic> json) {
    final l$authenticate = json['authenticate'];
    final l$$__typename = json['__typename'];
    return Mutation$Authenticate(
      authenticate: Mutation$Authenticate$authenticate.fromJson(
        (l$authenticate as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$Authenticate$authenticate authenticate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$authenticate = authenticate;
    _resultData['authenticate'] = l$authenticate.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$authenticate = authenticate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$authenticate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$Authenticate || runtimeType != other.runtimeType) {
      return false;
    }
    final l$authenticate = authenticate;
    final lOther$authenticate = other.authenticate;
    if (l$authenticate != lOther$authenticate) {
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

extension UtilityExtension$Mutation$Authenticate on Mutation$Authenticate {
  CopyWith$Mutation$Authenticate<Mutation$Authenticate> get copyWith =>
      CopyWith$Mutation$Authenticate(this, (i) => i);
}

abstract class CopyWith$Mutation$Authenticate<TRes> {
  factory CopyWith$Mutation$Authenticate(
    Mutation$Authenticate instance,
    TRes Function(Mutation$Authenticate) then,
  ) = _CopyWithImpl$Mutation$Authenticate;

  factory CopyWith$Mutation$Authenticate.stub(TRes res) =
      _CopyWithStubImpl$Mutation$Authenticate;

  TRes call({
    Mutation$Authenticate$authenticate? authenticate,
    String? $__typename,
  });
  CopyWith$Mutation$Authenticate$authenticate<TRes> get authenticate;
}

class _CopyWithImpl$Mutation$Authenticate<TRes>
    implements CopyWith$Mutation$Authenticate<TRes> {
  _CopyWithImpl$Mutation$Authenticate(this._instance, this._then);

  final Mutation$Authenticate _instance;

  final TRes Function(Mutation$Authenticate) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? authenticate = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$Authenticate(
      authenticate: authenticate == _undefined || authenticate == null
          ? _instance.authenticate
          : (authenticate as Mutation$Authenticate$authenticate),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$Authenticate$authenticate<TRes> get authenticate {
    final local$authenticate = _instance.authenticate;
    return CopyWith$Mutation$Authenticate$authenticate(
      local$authenticate,
      (e) => call(authenticate: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$Authenticate<TRes>
    implements CopyWith$Mutation$Authenticate<TRes> {
  _CopyWithStubImpl$Mutation$Authenticate(this._res);

  TRes _res;

  call({
    Mutation$Authenticate$authenticate? authenticate,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$Authenticate$authenticate<TRes> get authenticate =>
      CopyWith$Mutation$Authenticate$authenticate.stub(_res);
}

const documentNodeMutationAuthenticate = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'Authenticate'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'phoneNumber')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'code')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'firstName')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'lastName')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
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
            name: NameNode(value: 'authenticate'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'phoneOtp'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'phoneNumber'),
                            value: VariableNode(
                              name: NameNode(value: 'phoneNumber'),
                            ),
                          ),
                          ObjectFieldNode(
                            name: NameNode(value: 'code'),
                            value: VariableNode(name: NameNode(value: 'code')),
                          ),
                          ObjectFieldNode(
                            name: NameNode(value: 'firstName'),
                            value: VariableNode(
                              name: NameNode(value: 'firstName'),
                            ),
                          ),
                          ObjectFieldNode(
                            name: NameNode(value: 'lastName'),
                            value: VariableNode(
                              name: NameNode(value: 'lastName'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                      name: NameNode(value: 'CurrentUser'),
                      isNonNull: false,
                    ),
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
                        name: NameNode(value: 'identifier'),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'InvalidCredentialsError'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
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
Mutation$Authenticate _parserFn$Mutation$Authenticate(
  Map<String, dynamic> data,
) => Mutation$Authenticate.fromJson(data);
typedef OnMutationCompleted$Mutation$Authenticate =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation$Authenticate?);

class Options$Mutation$Authenticate
    extends graphql.MutationOptions<Mutation$Authenticate> {
  Options$Mutation$Authenticate({
    String? operationName,
    required Variables$Mutation$Authenticate variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$Authenticate? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$Authenticate? onCompleted,
    graphql.OnMutationUpdate<Mutation$Authenticate>? update,
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
                 data == null ? null : _parserFn$Mutation$Authenticate(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationAuthenticate,
         parserFn: _parserFn$Mutation$Authenticate,
       );

  final OnMutationCompleted$Mutation$Authenticate? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$Authenticate
    extends graphql.WatchQueryOptions<Mutation$Authenticate> {
  WatchOptions$Mutation$Authenticate({
    String? operationName,
    required Variables$Mutation$Authenticate variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$Authenticate? typedOptimisticResult,
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
         document: documentNodeMutationAuthenticate,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$Authenticate,
       );
}

extension ClientExtension$Mutation$Authenticate on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$Authenticate>> mutate$Authenticate(
    Options$Mutation$Authenticate options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$Authenticate> watchMutation$Authenticate(
    WatchOptions$Mutation$Authenticate options,
  ) => this.watchMutation(options);
}

class Mutation$Authenticate$HookResult {
  Mutation$Authenticate$HookResult(this.runMutation, this.result);

  final RunMutation$Mutation$Authenticate runMutation;

  final graphql.QueryResult<Mutation$Authenticate> result;
}

Mutation$Authenticate$HookResult useMutation$Authenticate([
  WidgetOptions$Mutation$Authenticate? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions$Mutation$Authenticate(),
  );
  return Mutation$Authenticate$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$Authenticate> useWatchMutation$Authenticate(
  WatchOptions$Mutation$Authenticate options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$Authenticate
    extends graphql.MutationOptions<Mutation$Authenticate> {
  WidgetOptions$Mutation$Authenticate({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$Authenticate? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$Authenticate? onCompleted,
    graphql.OnMutationUpdate<Mutation$Authenticate>? update,
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
                 data == null ? null : _parserFn$Mutation$Authenticate(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationAuthenticate,
         parserFn: _parserFn$Mutation$Authenticate,
       );

  final OnMutationCompleted$Mutation$Authenticate? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation$Mutation$Authenticate =
    graphql.MultiSourceResult<Mutation$Authenticate> Function(
      Variables$Mutation$Authenticate, {
      Object? optimisticResult,
      Mutation$Authenticate? typedOptimisticResult,
    });
typedef Builder$Mutation$Authenticate =
    widgets.Widget Function(
      RunMutation$Mutation$Authenticate,
      graphql.QueryResult<Mutation$Authenticate>?,
    );

class Mutation$Authenticate$Widget
    extends graphql_flutter.Mutation<Mutation$Authenticate> {
  Mutation$Authenticate$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$Authenticate? options,
    required Builder$Mutation$Authenticate builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions$Mutation$Authenticate(),
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

class Mutation$Authenticate$authenticate {
  Mutation$Authenticate$authenticate({required this.$__typename});

  factory Mutation$Authenticate$authenticate.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "CurrentUser":
        return Mutation$Authenticate$authenticate$$CurrentUser.fromJson(json);

      case "InvalidCredentialsError":
        return Mutation$Authenticate$authenticate$$InvalidCredentialsError.fromJson(
          json,
        );

      case "NotVerifiedError":
        return Mutation$Authenticate$authenticate$$NotVerifiedError.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$Authenticate$authenticate(
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
    if (other is! Mutation$Authenticate$authenticate ||
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

extension UtilityExtension$Mutation$Authenticate$authenticate
    on Mutation$Authenticate$authenticate {
  CopyWith$Mutation$Authenticate$authenticate<
    Mutation$Authenticate$authenticate
  >
  get copyWith => CopyWith$Mutation$Authenticate$authenticate(this, (i) => i);

  _T when<_T>({
    required _T Function(Mutation$Authenticate$authenticate$$CurrentUser)
    currentUser,
    required _T Function(
      Mutation$Authenticate$authenticate$$InvalidCredentialsError,
    )
    invalidCredentialsError,
    required _T Function(Mutation$Authenticate$authenticate$$NotVerifiedError)
    notVerifiedError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CurrentUser":
        return currentUser(
          this as Mutation$Authenticate$authenticate$$CurrentUser,
        );

      case "InvalidCredentialsError":
        return invalidCredentialsError(
          this as Mutation$Authenticate$authenticate$$InvalidCredentialsError,
        );

      case "NotVerifiedError":
        return notVerifiedError(
          this as Mutation$Authenticate$authenticate$$NotVerifiedError,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$Authenticate$authenticate$$CurrentUser)? currentUser,
    _T Function(Mutation$Authenticate$authenticate$$InvalidCredentialsError)?
    invalidCredentialsError,
    _T Function(Mutation$Authenticate$authenticate$$NotVerifiedError)?
    notVerifiedError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CurrentUser":
        if (currentUser != null) {
          return currentUser(
            this as Mutation$Authenticate$authenticate$$CurrentUser,
          );
        } else {
          return orElse();
        }

      case "InvalidCredentialsError":
        if (invalidCredentialsError != null) {
          return invalidCredentialsError(
            this as Mutation$Authenticate$authenticate$$InvalidCredentialsError,
          );
        } else {
          return orElse();
        }

      case "NotVerifiedError":
        if (notVerifiedError != null) {
          return notVerifiedError(
            this as Mutation$Authenticate$authenticate$$NotVerifiedError,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Mutation$Authenticate$authenticate<TRes> {
  factory CopyWith$Mutation$Authenticate$authenticate(
    Mutation$Authenticate$authenticate instance,
    TRes Function(Mutation$Authenticate$authenticate) then,
  ) = _CopyWithImpl$Mutation$Authenticate$authenticate;

  factory CopyWith$Mutation$Authenticate$authenticate.stub(TRes res) =
      _CopyWithStubImpl$Mutation$Authenticate$authenticate;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Mutation$Authenticate$authenticate<TRes>
    implements CopyWith$Mutation$Authenticate$authenticate<TRes> {
  _CopyWithImpl$Mutation$Authenticate$authenticate(this._instance, this._then);

  final Mutation$Authenticate$authenticate _instance;

  final TRes Function(Mutation$Authenticate$authenticate) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation$Authenticate$authenticate(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$Authenticate$authenticate<TRes>
    implements CopyWith$Mutation$Authenticate$authenticate<TRes> {
  _CopyWithStubImpl$Mutation$Authenticate$authenticate(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation$Authenticate$authenticate$$CurrentUser
    implements Mutation$Authenticate$authenticate {
  Mutation$Authenticate$authenticate$$CurrentUser({
    required this.id,
    required this.identifier,
    this.$__typename = 'CurrentUser',
  });

  factory Mutation$Authenticate$authenticate$$CurrentUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$identifier = json['identifier'];
    final l$$__typename = json['__typename'];
    return Mutation$Authenticate$authenticate$$CurrentUser(
      id: (l$id as String),
      identifier: (l$identifier as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String identifier;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$identifier = identifier;
    _resultData['identifier'] = l$identifier;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$identifier = identifier;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$identifier, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$Authenticate$authenticate$$CurrentUser ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$identifier = identifier;
    final lOther$identifier = other.identifier;
    if (l$identifier != lOther$identifier) {
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

extension UtilityExtension$Mutation$Authenticate$authenticate$$CurrentUser
    on Mutation$Authenticate$authenticate$$CurrentUser {
  CopyWith$Mutation$Authenticate$authenticate$$CurrentUser<
    Mutation$Authenticate$authenticate$$CurrentUser
  >
  get copyWith =>
      CopyWith$Mutation$Authenticate$authenticate$$CurrentUser(this, (i) => i);
}

abstract class CopyWith$Mutation$Authenticate$authenticate$$CurrentUser<TRes> {
  factory CopyWith$Mutation$Authenticate$authenticate$$CurrentUser(
    Mutation$Authenticate$authenticate$$CurrentUser instance,
    TRes Function(Mutation$Authenticate$authenticate$$CurrentUser) then,
  ) = _CopyWithImpl$Mutation$Authenticate$authenticate$$CurrentUser;

  factory CopyWith$Mutation$Authenticate$authenticate$$CurrentUser.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$Authenticate$authenticate$$CurrentUser;

  TRes call({String? id, String? identifier, String? $__typename});
}

class _CopyWithImpl$Mutation$Authenticate$authenticate$$CurrentUser<TRes>
    implements CopyWith$Mutation$Authenticate$authenticate$$CurrentUser<TRes> {
  _CopyWithImpl$Mutation$Authenticate$authenticate$$CurrentUser(
    this._instance,
    this._then,
  );

  final Mutation$Authenticate$authenticate$$CurrentUser _instance;

  final TRes Function(Mutation$Authenticate$authenticate$$CurrentUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? identifier = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$Authenticate$authenticate$$CurrentUser(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      identifier: identifier == _undefined || identifier == null
          ? _instance.identifier
          : (identifier as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$Authenticate$authenticate$$CurrentUser<TRes>
    implements CopyWith$Mutation$Authenticate$authenticate$$CurrentUser<TRes> {
  _CopyWithStubImpl$Mutation$Authenticate$authenticate$$CurrentUser(this._res);

  TRes _res;

  call({String? id, String? identifier, String? $__typename}) => _res;
}

class Mutation$Authenticate$authenticate$$InvalidCredentialsError
    implements Mutation$Authenticate$authenticate {
  Mutation$Authenticate$authenticate$$InvalidCredentialsError({
    required this.message,
    this.$__typename = 'InvalidCredentialsError',
  });

  factory Mutation$Authenticate$authenticate$$InvalidCredentialsError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation$Authenticate$authenticate$$InvalidCredentialsError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$Authenticate$authenticate$$InvalidCredentialsError ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Mutation$Authenticate$authenticate$$InvalidCredentialsError
    on Mutation$Authenticate$authenticate$$InvalidCredentialsError {
  CopyWith$Mutation$Authenticate$authenticate$$InvalidCredentialsError<
    Mutation$Authenticate$authenticate$$InvalidCredentialsError
  >
  get copyWith =>
      CopyWith$Mutation$Authenticate$authenticate$$InvalidCredentialsError(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$Authenticate$authenticate$$InvalidCredentialsError<
  TRes
> {
  factory CopyWith$Mutation$Authenticate$authenticate$$InvalidCredentialsError(
    Mutation$Authenticate$authenticate$$InvalidCredentialsError instance,
    TRes Function(Mutation$Authenticate$authenticate$$InvalidCredentialsError)
    then,
  ) = _CopyWithImpl$Mutation$Authenticate$authenticate$$InvalidCredentialsError;

  factory CopyWith$Mutation$Authenticate$authenticate$$InvalidCredentialsError.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$Authenticate$authenticate$$InvalidCredentialsError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl$Mutation$Authenticate$authenticate$$InvalidCredentialsError<
  TRes
>
    implements
        CopyWith$Mutation$Authenticate$authenticate$$InvalidCredentialsError<
          TRes
        > {
  _CopyWithImpl$Mutation$Authenticate$authenticate$$InvalidCredentialsError(
    this._instance,
    this._then,
  );

  final Mutation$Authenticate$authenticate$$InvalidCredentialsError _instance;

  final TRes Function(
    Mutation$Authenticate$authenticate$$InvalidCredentialsError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? message = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation$Authenticate$authenticate$$InvalidCredentialsError(
          message: message == _undefined || message == null
              ? _instance.message
              : (message as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Mutation$Authenticate$authenticate$$InvalidCredentialsError<
  TRes
>
    implements
        CopyWith$Mutation$Authenticate$authenticate$$InvalidCredentialsError<
          TRes
        > {
  _CopyWithStubImpl$Mutation$Authenticate$authenticate$$InvalidCredentialsError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation$Authenticate$authenticate$$NotVerifiedError
    implements Mutation$Authenticate$authenticate {
  Mutation$Authenticate$authenticate$$NotVerifiedError({
    this.$__typename = 'NotVerifiedError',
  });

  factory Mutation$Authenticate$authenticate$$NotVerifiedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    return Mutation$Authenticate$authenticate$$NotVerifiedError(
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
    if (other is! Mutation$Authenticate$authenticate$$NotVerifiedError ||
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

extension UtilityExtension$Mutation$Authenticate$authenticate$$NotVerifiedError
    on Mutation$Authenticate$authenticate$$NotVerifiedError {
  CopyWith$Mutation$Authenticate$authenticate$$NotVerifiedError<
    Mutation$Authenticate$authenticate$$NotVerifiedError
  >
  get copyWith => CopyWith$Mutation$Authenticate$authenticate$$NotVerifiedError(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$Authenticate$authenticate$$NotVerifiedError<
  TRes
> {
  factory CopyWith$Mutation$Authenticate$authenticate$$NotVerifiedError(
    Mutation$Authenticate$authenticate$$NotVerifiedError instance,
    TRes Function(Mutation$Authenticate$authenticate$$NotVerifiedError) then,
  ) = _CopyWithImpl$Mutation$Authenticate$authenticate$$NotVerifiedError;

  factory CopyWith$Mutation$Authenticate$authenticate$$NotVerifiedError.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$Authenticate$authenticate$$NotVerifiedError;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Mutation$Authenticate$authenticate$$NotVerifiedError<TRes>
    implements
        CopyWith$Mutation$Authenticate$authenticate$$NotVerifiedError<TRes> {
  _CopyWithImpl$Mutation$Authenticate$authenticate$$NotVerifiedError(
    this._instance,
    this._then,
  );

  final Mutation$Authenticate$authenticate$$NotVerifiedError _instance;

  final TRes Function(Mutation$Authenticate$authenticate$$NotVerifiedError)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation$Authenticate$authenticate$$NotVerifiedError(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$Authenticate$authenticate$$NotVerifiedError<
  TRes
>
    implements
        CopyWith$Mutation$Authenticate$authenticate$$NotVerifiedError<TRes> {
  _CopyWithStubImpl$Mutation$Authenticate$authenticate$$NotVerifiedError(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Variables$Mutation$SendPhoneOtp {
  factory Variables$Mutation$SendPhoneOtp({required String phoneNumber}) =>
      Variables$Mutation$SendPhoneOtp._({r'phoneNumber': phoneNumber});

  Variables$Mutation$SendPhoneOtp._(this._$data);

  factory Variables$Mutation$SendPhoneOtp.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$phoneNumber = data['phoneNumber'];
    result$data['phoneNumber'] = (l$phoneNumber as String);
    return Variables$Mutation$SendPhoneOtp._(result$data);
  }

  Map<String, dynamic> _$data;

  String get phoneNumber => (_$data['phoneNumber'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$phoneNumber = phoneNumber;
    result$data['phoneNumber'] = l$phoneNumber;
    return result$data;
  }

  CopyWith$Variables$Mutation$SendPhoneOtp<Variables$Mutation$SendPhoneOtp>
  get copyWith => CopyWith$Variables$Mutation$SendPhoneOtp(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$SendPhoneOtp ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$phoneNumber = phoneNumber;
    final lOther$phoneNumber = other.phoneNumber;
    if (l$phoneNumber != lOther$phoneNumber) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$phoneNumber = phoneNumber;
    return Object.hashAll([l$phoneNumber]);
  }
}

abstract class CopyWith$Variables$Mutation$SendPhoneOtp<TRes> {
  factory CopyWith$Variables$Mutation$SendPhoneOtp(
    Variables$Mutation$SendPhoneOtp instance,
    TRes Function(Variables$Mutation$SendPhoneOtp) then,
  ) = _CopyWithImpl$Variables$Mutation$SendPhoneOtp;

  factory CopyWith$Variables$Mutation$SendPhoneOtp.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$SendPhoneOtp;

  TRes call({String? phoneNumber});
}

class _CopyWithImpl$Variables$Mutation$SendPhoneOtp<TRes>
    implements CopyWith$Variables$Mutation$SendPhoneOtp<TRes> {
  _CopyWithImpl$Variables$Mutation$SendPhoneOtp(this._instance, this._then);

  final Variables$Mutation$SendPhoneOtp _instance;

  final TRes Function(Variables$Mutation$SendPhoneOtp) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? phoneNumber = _undefined}) => _then(
    Variables$Mutation$SendPhoneOtp._({
      ..._instance._$data,
      if (phoneNumber != _undefined && phoneNumber != null)
        'phoneNumber': (phoneNumber as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$SendPhoneOtp<TRes>
    implements CopyWith$Variables$Mutation$SendPhoneOtp<TRes> {
  _CopyWithStubImpl$Variables$Mutation$SendPhoneOtp(this._res);

  TRes _res;

  call({String? phoneNumber}) => _res;
}

class Mutation$SendPhoneOtp {
  Mutation$SendPhoneOtp({this.sendPhoneOtp, this.$__typename = 'Mutation'});

  factory Mutation$SendPhoneOtp.fromJson(Map<String, dynamic> json) {
    final l$sendPhoneOtp = json['sendPhoneOtp'];
    final l$$__typename = json['__typename'];
    return Mutation$SendPhoneOtp(
      sendPhoneOtp: (l$sendPhoneOtp as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? sendPhoneOtp;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sendPhoneOtp = sendPhoneOtp;
    _resultData['sendPhoneOtp'] = l$sendPhoneOtp;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sendPhoneOtp = sendPhoneOtp;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sendPhoneOtp, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SendPhoneOtp || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sendPhoneOtp = sendPhoneOtp;
    final lOther$sendPhoneOtp = other.sendPhoneOtp;
    if (l$sendPhoneOtp != lOther$sendPhoneOtp) {
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

extension UtilityExtension$Mutation$SendPhoneOtp on Mutation$SendPhoneOtp {
  CopyWith$Mutation$SendPhoneOtp<Mutation$SendPhoneOtp> get copyWith =>
      CopyWith$Mutation$SendPhoneOtp(this, (i) => i);
}

abstract class CopyWith$Mutation$SendPhoneOtp<TRes> {
  factory CopyWith$Mutation$SendPhoneOtp(
    Mutation$SendPhoneOtp instance,
    TRes Function(Mutation$SendPhoneOtp) then,
  ) = _CopyWithImpl$Mutation$SendPhoneOtp;

  factory CopyWith$Mutation$SendPhoneOtp.stub(TRes res) =
      _CopyWithStubImpl$Mutation$SendPhoneOtp;

  TRes call({String? sendPhoneOtp, String? $__typename});
}

class _CopyWithImpl$Mutation$SendPhoneOtp<TRes>
    implements CopyWith$Mutation$SendPhoneOtp<TRes> {
  _CopyWithImpl$Mutation$SendPhoneOtp(this._instance, this._then);

  final Mutation$SendPhoneOtp _instance;

  final TRes Function(Mutation$SendPhoneOtp) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sendPhoneOtp = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$SendPhoneOtp(
      sendPhoneOtp: sendPhoneOtp == _undefined
          ? _instance.sendPhoneOtp
          : (sendPhoneOtp as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$SendPhoneOtp<TRes>
    implements CopyWith$Mutation$SendPhoneOtp<TRes> {
  _CopyWithStubImpl$Mutation$SendPhoneOtp(this._res);

  TRes _res;

  call({String? sendPhoneOtp, String? $__typename}) => _res;
}

const documentNodeMutationSendPhoneOtp = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SendPhoneOtp'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'phoneNumber')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'sendPhoneOtp'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'phoneNumber'),
                value: VariableNode(name: NameNode(value: 'phoneNumber')),
              ),
            ],
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
  ],
);
Mutation$SendPhoneOtp _parserFn$Mutation$SendPhoneOtp(
  Map<String, dynamic> data,
) => Mutation$SendPhoneOtp.fromJson(data);
typedef OnMutationCompleted$Mutation$SendPhoneOtp =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation$SendPhoneOtp?);

class Options$Mutation$SendPhoneOtp
    extends graphql.MutationOptions<Mutation$SendPhoneOtp> {
  Options$Mutation$SendPhoneOtp({
    String? operationName,
    required Variables$Mutation$SendPhoneOtp variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SendPhoneOtp? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SendPhoneOtp? onCompleted,
    graphql.OnMutationUpdate<Mutation$SendPhoneOtp>? update,
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
                 data == null ? null : _parserFn$Mutation$SendPhoneOtp(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSendPhoneOtp,
         parserFn: _parserFn$Mutation$SendPhoneOtp,
       );

  final OnMutationCompleted$Mutation$SendPhoneOtp? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SendPhoneOtp
    extends graphql.WatchQueryOptions<Mutation$SendPhoneOtp> {
  WatchOptions$Mutation$SendPhoneOtp({
    String? operationName,
    required Variables$Mutation$SendPhoneOtp variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SendPhoneOtp? typedOptimisticResult,
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
         document: documentNodeMutationSendPhoneOtp,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SendPhoneOtp,
       );
}

extension ClientExtension$Mutation$SendPhoneOtp on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SendPhoneOtp>> mutate$SendPhoneOtp(
    Options$Mutation$SendPhoneOtp options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$SendPhoneOtp> watchMutation$SendPhoneOtp(
    WatchOptions$Mutation$SendPhoneOtp options,
  ) => this.watchMutation(options);
}

class Mutation$SendPhoneOtp$HookResult {
  Mutation$SendPhoneOtp$HookResult(this.runMutation, this.result);

  final RunMutation$Mutation$SendPhoneOtp runMutation;

  final graphql.QueryResult<Mutation$SendPhoneOtp> result;
}

Mutation$SendPhoneOtp$HookResult useMutation$SendPhoneOtp([
  WidgetOptions$Mutation$SendPhoneOtp? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions$Mutation$SendPhoneOtp(),
  );
  return Mutation$SendPhoneOtp$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$SendPhoneOtp> useWatchMutation$SendPhoneOtp(
  WatchOptions$Mutation$SendPhoneOtp options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$SendPhoneOtp
    extends graphql.MutationOptions<Mutation$SendPhoneOtp> {
  WidgetOptions$Mutation$SendPhoneOtp({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SendPhoneOtp? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SendPhoneOtp? onCompleted,
    graphql.OnMutationUpdate<Mutation$SendPhoneOtp>? update,
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
                 data == null ? null : _parserFn$Mutation$SendPhoneOtp(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSendPhoneOtp,
         parserFn: _parserFn$Mutation$SendPhoneOtp,
       );

  final OnMutationCompleted$Mutation$SendPhoneOtp? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation$Mutation$SendPhoneOtp =
    graphql.MultiSourceResult<Mutation$SendPhoneOtp> Function(
      Variables$Mutation$SendPhoneOtp, {
      Object? optimisticResult,
      Mutation$SendPhoneOtp? typedOptimisticResult,
    });
typedef Builder$Mutation$SendPhoneOtp =
    widgets.Widget Function(
      RunMutation$Mutation$SendPhoneOtp,
      graphql.QueryResult<Mutation$SendPhoneOtp>?,
    );

class Mutation$SendPhoneOtp$Widget
    extends graphql_flutter.Mutation<Mutation$SendPhoneOtp> {
  Mutation$SendPhoneOtp$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$SendPhoneOtp? options,
    required Builder$Mutation$SendPhoneOtp builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions$Mutation$SendPhoneOtp(),
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

class Variables$Mutation$ResendPhoneOtp {
  factory Variables$Mutation$ResendPhoneOtp({required String phoneNumber}) =>
      Variables$Mutation$ResendPhoneOtp._({r'phoneNumber': phoneNumber});

  Variables$Mutation$ResendPhoneOtp._(this._$data);

  factory Variables$Mutation$ResendPhoneOtp.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$phoneNumber = data['phoneNumber'];
    result$data['phoneNumber'] = (l$phoneNumber as String);
    return Variables$Mutation$ResendPhoneOtp._(result$data);
  }

  Map<String, dynamic> _$data;

  String get phoneNumber => (_$data['phoneNumber'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$phoneNumber = phoneNumber;
    result$data['phoneNumber'] = l$phoneNumber;
    return result$data;
  }

  CopyWith$Variables$Mutation$ResendPhoneOtp<Variables$Mutation$ResendPhoneOtp>
  get copyWith => CopyWith$Variables$Mutation$ResendPhoneOtp(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ResendPhoneOtp ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$phoneNumber = phoneNumber;
    final lOther$phoneNumber = other.phoneNumber;
    if (l$phoneNumber != lOther$phoneNumber) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$phoneNumber = phoneNumber;
    return Object.hashAll([l$phoneNumber]);
  }
}

abstract class CopyWith$Variables$Mutation$ResendPhoneOtp<TRes> {
  factory CopyWith$Variables$Mutation$ResendPhoneOtp(
    Variables$Mutation$ResendPhoneOtp instance,
    TRes Function(Variables$Mutation$ResendPhoneOtp) then,
  ) = _CopyWithImpl$Variables$Mutation$ResendPhoneOtp;

  factory CopyWith$Variables$Mutation$ResendPhoneOtp.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ResendPhoneOtp;

  TRes call({String? phoneNumber});
}

class _CopyWithImpl$Variables$Mutation$ResendPhoneOtp<TRes>
    implements CopyWith$Variables$Mutation$ResendPhoneOtp<TRes> {
  _CopyWithImpl$Variables$Mutation$ResendPhoneOtp(this._instance, this._then);

  final Variables$Mutation$ResendPhoneOtp _instance;

  final TRes Function(Variables$Mutation$ResendPhoneOtp) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? phoneNumber = _undefined}) => _then(
    Variables$Mutation$ResendPhoneOtp._({
      ..._instance._$data,
      if (phoneNumber != _undefined && phoneNumber != null)
        'phoneNumber': (phoneNumber as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ResendPhoneOtp<TRes>
    implements CopyWith$Variables$Mutation$ResendPhoneOtp<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ResendPhoneOtp(this._res);

  TRes _res;

  call({String? phoneNumber}) => _res;
}

class Mutation$ResendPhoneOtp {
  Mutation$ResendPhoneOtp({this.resendPhoneOtp, this.$__typename = 'Mutation'});

  factory Mutation$ResendPhoneOtp.fromJson(Map<String, dynamic> json) {
    final l$resendPhoneOtp = json['resendPhoneOtp'];
    final l$$__typename = json['__typename'];
    return Mutation$ResendPhoneOtp(
      resendPhoneOtp: (l$resendPhoneOtp as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? resendPhoneOtp;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$resendPhoneOtp = resendPhoneOtp;
    _resultData['resendPhoneOtp'] = l$resendPhoneOtp;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$resendPhoneOtp = resendPhoneOtp;
    final l$$__typename = $__typename;
    return Object.hashAll([l$resendPhoneOtp, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ResendPhoneOtp || runtimeType != other.runtimeType) {
      return false;
    }
    final l$resendPhoneOtp = resendPhoneOtp;
    final lOther$resendPhoneOtp = other.resendPhoneOtp;
    if (l$resendPhoneOtp != lOther$resendPhoneOtp) {
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

extension UtilityExtension$Mutation$ResendPhoneOtp on Mutation$ResendPhoneOtp {
  CopyWith$Mutation$ResendPhoneOtp<Mutation$ResendPhoneOtp> get copyWith =>
      CopyWith$Mutation$ResendPhoneOtp(this, (i) => i);
}

abstract class CopyWith$Mutation$ResendPhoneOtp<TRes> {
  factory CopyWith$Mutation$ResendPhoneOtp(
    Mutation$ResendPhoneOtp instance,
    TRes Function(Mutation$ResendPhoneOtp) then,
  ) = _CopyWithImpl$Mutation$ResendPhoneOtp;

  factory CopyWith$Mutation$ResendPhoneOtp.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ResendPhoneOtp;

  TRes call({String? resendPhoneOtp, String? $__typename});
}

class _CopyWithImpl$Mutation$ResendPhoneOtp<TRes>
    implements CopyWith$Mutation$ResendPhoneOtp<TRes> {
  _CopyWithImpl$Mutation$ResendPhoneOtp(this._instance, this._then);

  final Mutation$ResendPhoneOtp _instance;

  final TRes Function(Mutation$ResendPhoneOtp) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? resendPhoneOtp = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ResendPhoneOtp(
      resendPhoneOtp: resendPhoneOtp == _undefined
          ? _instance.resendPhoneOtp
          : (resendPhoneOtp as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ResendPhoneOtp<TRes>
    implements CopyWith$Mutation$ResendPhoneOtp<TRes> {
  _CopyWithStubImpl$Mutation$ResendPhoneOtp(this._res);

  TRes _res;

  call({String? resendPhoneOtp, String? $__typename}) => _res;
}

const documentNodeMutationResendPhoneOtp = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ResendPhoneOtp'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'phoneNumber')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'resendPhoneOtp'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'phoneNumber'),
                value: VariableNode(name: NameNode(value: 'phoneNumber')),
              ),
            ],
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
  ],
);
Mutation$ResendPhoneOtp _parserFn$Mutation$ResendPhoneOtp(
  Map<String, dynamic> data,
) => Mutation$ResendPhoneOtp.fromJson(data);
typedef OnMutationCompleted$Mutation$ResendPhoneOtp =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation$ResendPhoneOtp?);

class Options$Mutation$ResendPhoneOtp
    extends graphql.MutationOptions<Mutation$ResendPhoneOtp> {
  Options$Mutation$ResendPhoneOtp({
    String? operationName,
    required Variables$Mutation$ResendPhoneOtp variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ResendPhoneOtp? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$ResendPhoneOtp? onCompleted,
    graphql.OnMutationUpdate<Mutation$ResendPhoneOtp>? update,
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
                 data == null ? null : _parserFn$Mutation$ResendPhoneOtp(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationResendPhoneOtp,
         parserFn: _parserFn$Mutation$ResendPhoneOtp,
       );

  final OnMutationCompleted$Mutation$ResendPhoneOtp? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$ResendPhoneOtp
    extends graphql.WatchQueryOptions<Mutation$ResendPhoneOtp> {
  WatchOptions$Mutation$ResendPhoneOtp({
    String? operationName,
    required Variables$Mutation$ResendPhoneOtp variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ResendPhoneOtp? typedOptimisticResult,
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
         document: documentNodeMutationResendPhoneOtp,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$ResendPhoneOtp,
       );
}

extension ClientExtension$Mutation$ResendPhoneOtp on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$ResendPhoneOtp>> mutate$ResendPhoneOtp(
    Options$Mutation$ResendPhoneOtp options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$ResendPhoneOtp> watchMutation$ResendPhoneOtp(
    WatchOptions$Mutation$ResendPhoneOtp options,
  ) => this.watchMutation(options);
}

class Mutation$ResendPhoneOtp$HookResult {
  Mutation$ResendPhoneOtp$HookResult(this.runMutation, this.result);

  final RunMutation$Mutation$ResendPhoneOtp runMutation;

  final graphql.QueryResult<Mutation$ResendPhoneOtp> result;
}

Mutation$ResendPhoneOtp$HookResult useMutation$ResendPhoneOtp([
  WidgetOptions$Mutation$ResendPhoneOtp? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions$Mutation$ResendPhoneOtp(),
  );
  return Mutation$ResendPhoneOtp$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$ResendPhoneOtp>
useWatchMutation$ResendPhoneOtp(WatchOptions$Mutation$ResendPhoneOtp options) =>
    graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$ResendPhoneOtp
    extends graphql.MutationOptions<Mutation$ResendPhoneOtp> {
  WidgetOptions$Mutation$ResendPhoneOtp({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ResendPhoneOtp? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$ResendPhoneOtp? onCompleted,
    graphql.OnMutationUpdate<Mutation$ResendPhoneOtp>? update,
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
                 data == null ? null : _parserFn$Mutation$ResendPhoneOtp(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationResendPhoneOtp,
         parserFn: _parserFn$Mutation$ResendPhoneOtp,
       );

  final OnMutationCompleted$Mutation$ResendPhoneOtp? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation$Mutation$ResendPhoneOtp =
    graphql.MultiSourceResult<Mutation$ResendPhoneOtp> Function(
      Variables$Mutation$ResendPhoneOtp, {
      Object? optimisticResult,
      Mutation$ResendPhoneOtp? typedOptimisticResult,
    });
typedef Builder$Mutation$ResendPhoneOtp =
    widgets.Widget Function(
      RunMutation$Mutation$ResendPhoneOtp,
      graphql.QueryResult<Mutation$ResendPhoneOtp>?,
    );

class Mutation$ResendPhoneOtp$Widget
    extends graphql_flutter.Mutation<Mutation$ResendPhoneOtp> {
  Mutation$ResendPhoneOtp$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$ResendPhoneOtp? options,
    required Builder$Mutation$ResendPhoneOtp builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions$Mutation$ResendPhoneOtp(),
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

class Variables$Query$GetChannelsByCustomerEmail {
  factory Variables$Query$GetChannelsByCustomerEmail({required String email}) =>
      Variables$Query$GetChannelsByCustomerEmail._({r'email': email});

  Variables$Query$GetChannelsByCustomerEmail._(this._$data);

  factory Variables$Query$GetChannelsByCustomerEmail.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$email = data['email'];
    result$data['email'] = (l$email as String);
    return Variables$Query$GetChannelsByCustomerEmail._(result$data);
  }

  Map<String, dynamic> _$data;

  String get email => (_$data['email'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$email = email;
    result$data['email'] = l$email;
    return result$data;
  }

  CopyWith$Variables$Query$GetChannelsByCustomerEmail<
    Variables$Query$GetChannelsByCustomerEmail
  >
  get copyWith =>
      CopyWith$Variables$Query$GetChannelsByCustomerEmail(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetChannelsByCustomerEmail ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$email = email;
    return Object.hashAll([l$email]);
  }
}

abstract class CopyWith$Variables$Query$GetChannelsByCustomerEmail<TRes> {
  factory CopyWith$Variables$Query$GetChannelsByCustomerEmail(
    Variables$Query$GetChannelsByCustomerEmail instance,
    TRes Function(Variables$Query$GetChannelsByCustomerEmail) then,
  ) = _CopyWithImpl$Variables$Query$GetChannelsByCustomerEmail;

  factory CopyWith$Variables$Query$GetChannelsByCustomerEmail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetChannelsByCustomerEmail;

  TRes call({String? email});
}

class _CopyWithImpl$Variables$Query$GetChannelsByCustomerEmail<TRes>
    implements CopyWith$Variables$Query$GetChannelsByCustomerEmail<TRes> {
  _CopyWithImpl$Variables$Query$GetChannelsByCustomerEmail(
    this._instance,
    this._then,
  );

  final Variables$Query$GetChannelsByCustomerEmail _instance;

  final TRes Function(Variables$Query$GetChannelsByCustomerEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? email = _undefined}) => _then(
    Variables$Query$GetChannelsByCustomerEmail._({
      ..._instance._$data,
      if (email != _undefined && email != null) 'email': (email as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$GetChannelsByCustomerEmail<TRes>
    implements CopyWith$Variables$Query$GetChannelsByCustomerEmail<TRes> {
  _CopyWithStubImpl$Variables$Query$GetChannelsByCustomerEmail(this._res);

  TRes _res;

  call({String? email}) => _res;
}

class Query$GetChannelsByCustomerEmail {
  Query$GetChannelsByCustomerEmail({
    required this.getChannelsByCustomerEmail,
    this.$__typename = 'Query',
  });

  factory Query$GetChannelsByCustomerEmail.fromJson(Map<String, dynamic> json) {
    final l$getChannelsByCustomerEmail = json['getChannelsByCustomerEmail'];
    final l$$__typename = json['__typename'];
    return Query$GetChannelsByCustomerEmail(
      getChannelsByCustomerEmail: (l$getChannelsByCustomerEmail as List<dynamic>)
          .map(
            (e) =>
                Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail>
  getChannelsByCustomerEmail;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$getChannelsByCustomerEmail = getChannelsByCustomerEmail;
    _resultData['getChannelsByCustomerEmail'] = l$getChannelsByCustomerEmail
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$getChannelsByCustomerEmail = getChannelsByCustomerEmail;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$getChannelsByCustomerEmail.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetChannelsByCustomerEmail ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$getChannelsByCustomerEmail = getChannelsByCustomerEmail;
    final lOther$getChannelsByCustomerEmail = other.getChannelsByCustomerEmail;
    if (l$getChannelsByCustomerEmail.length !=
        lOther$getChannelsByCustomerEmail.length) {
      return false;
    }
    for (int i = 0; i < l$getChannelsByCustomerEmail.length; i++) {
      final l$getChannelsByCustomerEmail$entry =
          l$getChannelsByCustomerEmail[i];
      final lOther$getChannelsByCustomerEmail$entry =
          lOther$getChannelsByCustomerEmail[i];
      if (l$getChannelsByCustomerEmail$entry !=
          lOther$getChannelsByCustomerEmail$entry) {
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

extension UtilityExtension$Query$GetChannelsByCustomerEmail
    on Query$GetChannelsByCustomerEmail {
  CopyWith$Query$GetChannelsByCustomerEmail<Query$GetChannelsByCustomerEmail>
  get copyWith => CopyWith$Query$GetChannelsByCustomerEmail(this, (i) => i);
}

abstract class CopyWith$Query$GetChannelsByCustomerEmail<TRes> {
  factory CopyWith$Query$GetChannelsByCustomerEmail(
    Query$GetChannelsByCustomerEmail instance,
    TRes Function(Query$GetChannelsByCustomerEmail) then,
  ) = _CopyWithImpl$Query$GetChannelsByCustomerEmail;

  factory CopyWith$Query$GetChannelsByCustomerEmail.stub(TRes res) =
      _CopyWithStubImpl$Query$GetChannelsByCustomerEmail;

  TRes call({
    List<Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail>?
    getChannelsByCustomerEmail,
    String? $__typename,
  });
  TRes getChannelsByCustomerEmail(
    Iterable<Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail>
    Function(
      Iterable<
        CopyWith$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail<
          Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$GetChannelsByCustomerEmail<TRes>
    implements CopyWith$Query$GetChannelsByCustomerEmail<TRes> {
  _CopyWithImpl$Query$GetChannelsByCustomerEmail(this._instance, this._then);

  final Query$GetChannelsByCustomerEmail _instance;

  final TRes Function(Query$GetChannelsByCustomerEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? getChannelsByCustomerEmail = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetChannelsByCustomerEmail(
      getChannelsByCustomerEmail:
          getChannelsByCustomerEmail == _undefined ||
              getChannelsByCustomerEmail == null
          ? _instance.getChannelsByCustomerEmail
          : (getChannelsByCustomerEmail
                as List<
                  Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes getChannelsByCustomerEmail(
    Iterable<Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail>
    Function(
      Iterable<
        CopyWith$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail<
          Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail
        >
      >,
    )
    _fn,
  ) => call(
    getChannelsByCustomerEmail: _fn(
      _instance.getChannelsByCustomerEmail.map(
        (e) =>
            CopyWith$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$GetChannelsByCustomerEmail<TRes>
    implements CopyWith$Query$GetChannelsByCustomerEmail<TRes> {
  _CopyWithStubImpl$Query$GetChannelsByCustomerEmail(this._res);

  TRes _res;

  call({
    List<Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail>?
    getChannelsByCustomerEmail,
    String? $__typename,
  }) => _res;

  getChannelsByCustomerEmail(_fn) => _res;
}

const documentNodeQueryGetChannelsByCustomerEmail = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GetChannelsByCustomerEmail'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'email')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'getChannelsByCustomerEmail'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'email'),
                value: VariableNode(name: NameNode(value: 'email')),
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
                  name: NameNode(value: 'code'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'token'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'defaultCurrencyCode'),
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
Query$GetChannelsByCustomerEmail _parserFn$Query$GetChannelsByCustomerEmail(
  Map<String, dynamic> data,
) => Query$GetChannelsByCustomerEmail.fromJson(data);
typedef OnQueryComplete$Query$GetChannelsByCustomerEmail =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query$GetChannelsByCustomerEmail?,
    );

class Options$Query$GetChannelsByCustomerEmail
    extends graphql.QueryOptions<Query$GetChannelsByCustomerEmail> {
  Options$Query$GetChannelsByCustomerEmail({
    String? operationName,
    required Variables$Query$GetChannelsByCustomerEmail variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetChannelsByCustomerEmail? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetChannelsByCustomerEmail? onComplete,
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
                 data == null
                     ? null
                     : _parserFn$Query$GetChannelsByCustomerEmail(data),
               ),
         onError: onError,
         document: documentNodeQueryGetChannelsByCustomerEmail,
         parserFn: _parserFn$Query$GetChannelsByCustomerEmail,
       );

  final OnQueryComplete$Query$GetChannelsByCustomerEmail? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$GetChannelsByCustomerEmail
    extends graphql.WatchQueryOptions<Query$GetChannelsByCustomerEmail> {
  WatchOptions$Query$GetChannelsByCustomerEmail({
    String? operationName,
    required Variables$Query$GetChannelsByCustomerEmail variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetChannelsByCustomerEmail? typedOptimisticResult,
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
         document: documentNodeQueryGetChannelsByCustomerEmail,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$GetChannelsByCustomerEmail,
       );
}

class FetchMoreOptions$Query$GetChannelsByCustomerEmail
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetChannelsByCustomerEmail({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetChannelsByCustomerEmail variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryGetChannelsByCustomerEmail,
       );
}

extension ClientExtension$Query$GetChannelsByCustomerEmail
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetChannelsByCustomerEmail>>
  query$GetChannelsByCustomerEmail(
    Options$Query$GetChannelsByCustomerEmail options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$GetChannelsByCustomerEmail>
  watchQuery$GetChannelsByCustomerEmail(
    WatchOptions$Query$GetChannelsByCustomerEmail options,
  ) => this.watchQuery(options);

  void writeQuery$GetChannelsByCustomerEmail({
    required Query$GetChannelsByCustomerEmail data,
    required Variables$Query$GetChannelsByCustomerEmail variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryGetChannelsByCustomerEmail,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$GetChannelsByCustomerEmail? readQuery$GetChannelsByCustomerEmail({
    required Variables$Query$GetChannelsByCustomerEmail variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryGetChannelsByCustomerEmail,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query$GetChannelsByCustomerEmail.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetChannelsByCustomerEmail>
useQuery$GetChannelsByCustomerEmail(
  Options$Query$GetChannelsByCustomerEmail options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$GetChannelsByCustomerEmail>
useWatchQuery$GetChannelsByCustomerEmail(
  WatchOptions$Query$GetChannelsByCustomerEmail options,
) => graphql_flutter.useWatchQuery(options);

class Query$GetChannelsByCustomerEmail$Widget
    extends graphql_flutter.Query<Query$GetChannelsByCustomerEmail> {
  Query$GetChannelsByCustomerEmail$Widget({
    widgets.Key? key,
    required Options$Query$GetChannelsByCustomerEmail options,
    required graphql_flutter.QueryBuilder<Query$GetChannelsByCustomerEmail>
    builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail {
  Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail({
    required this.id,
    required this.code,
    required this.token,
    required this.defaultCurrencyCode,
    this.$__typename = 'Channel',
  });

  factory Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$token = json['token'];
    final l$defaultCurrencyCode = json['defaultCurrencyCode'];
    final l$$__typename = json['__typename'];
    return Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail(
      id: (l$id as String),
      code: (l$code as String),
      token: (l$token as String),
      defaultCurrencyCode: fromJson$Enum$CurrencyCode(
        (l$defaultCurrencyCode as String),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String token;

  final Enum$CurrencyCode defaultCurrencyCode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$token = token;
    _resultData['token'] = l$token;
    final l$defaultCurrencyCode = defaultCurrencyCode;
    _resultData['defaultCurrencyCode'] = toJson$Enum$CurrencyCode(
      l$defaultCurrencyCode,
    );
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$token = token;
    final l$defaultCurrencyCode = defaultCurrencyCode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$token,
      l$defaultCurrencyCode,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail ||
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
    final l$token = token;
    final lOther$token = other.token;
    if (l$token != lOther$token) {
      return false;
    }
    final l$defaultCurrencyCode = defaultCurrencyCode;
    final lOther$defaultCurrencyCode = other.defaultCurrencyCode;
    if (l$defaultCurrencyCode != lOther$defaultCurrencyCode) {
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

extension UtilityExtension$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail
    on Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail {
  CopyWith$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail<
    Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail
  >
  get copyWith =>
      CopyWith$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail<
  TRes
> {
  factory CopyWith$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail(
    Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail instance,
    TRes Function(Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail)
    then,
  ) = _CopyWithImpl$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail;

  factory CopyWith$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail;

  TRes call({
    String? id,
    String? code,
    String? token,
    Enum$CurrencyCode? defaultCurrencyCode,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail<
  TRes
>
    implements
        CopyWith$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail<
          TRes
        > {
  _CopyWithImpl$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail(
    this._instance,
    this._then,
  );

  final Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail _instance;

  final TRes Function(
    Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? token = _undefined,
    Object? defaultCurrencyCode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      token: token == _undefined || token == null
          ? _instance.token
          : (token as String),
      defaultCurrencyCode:
          defaultCurrencyCode == _undefined || defaultCurrencyCode == null
          ? _instance.defaultCurrencyCode
          : (defaultCurrencyCode as Enum$CurrencyCode),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail<
  TRes
>
    implements
        CopyWith$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail<
          TRes
        > {
  _CopyWithStubImpl$Query$GetChannelsByCustomerEmail$getChannelsByCustomerEmail(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? code,
    String? token,
    Enum$CurrencyCode? defaultCurrencyCode,
    String? $__typename,
  }) => _res;
}

class Variables$Query$GetChannelsByPhoneNumber {
  factory Variables$Query$GetChannelsByPhoneNumber({
    required String phoneNumber,
  }) =>
      Variables$Query$GetChannelsByPhoneNumber._({r'phoneNumber': phoneNumber});

  Variables$Query$GetChannelsByPhoneNumber._(this._$data);

  factory Variables$Query$GetChannelsByPhoneNumber.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$phoneNumber = data['phoneNumber'];
    result$data['phoneNumber'] = (l$phoneNumber as String);
    return Variables$Query$GetChannelsByPhoneNumber._(result$data);
  }

  Map<String, dynamic> _$data;

  String get phoneNumber => (_$data['phoneNumber'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$phoneNumber = phoneNumber;
    result$data['phoneNumber'] = l$phoneNumber;
    return result$data;
  }

  CopyWith$Variables$Query$GetChannelsByPhoneNumber<
    Variables$Query$GetChannelsByPhoneNumber
  >
  get copyWith =>
      CopyWith$Variables$Query$GetChannelsByPhoneNumber(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetChannelsByPhoneNumber ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$phoneNumber = phoneNumber;
    final lOther$phoneNumber = other.phoneNumber;
    if (l$phoneNumber != lOther$phoneNumber) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$phoneNumber = phoneNumber;
    return Object.hashAll([l$phoneNumber]);
  }
}

abstract class CopyWith$Variables$Query$GetChannelsByPhoneNumber<TRes> {
  factory CopyWith$Variables$Query$GetChannelsByPhoneNumber(
    Variables$Query$GetChannelsByPhoneNumber instance,
    TRes Function(Variables$Query$GetChannelsByPhoneNumber) then,
  ) = _CopyWithImpl$Variables$Query$GetChannelsByPhoneNumber;

  factory CopyWith$Variables$Query$GetChannelsByPhoneNumber.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetChannelsByPhoneNumber;

  TRes call({String? phoneNumber});
}

class _CopyWithImpl$Variables$Query$GetChannelsByPhoneNumber<TRes>
    implements CopyWith$Variables$Query$GetChannelsByPhoneNumber<TRes> {
  _CopyWithImpl$Variables$Query$GetChannelsByPhoneNumber(
    this._instance,
    this._then,
  );

  final Variables$Query$GetChannelsByPhoneNumber _instance;

  final TRes Function(Variables$Query$GetChannelsByPhoneNumber) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? phoneNumber = _undefined}) => _then(
    Variables$Query$GetChannelsByPhoneNumber._({
      ..._instance._$data,
      if (phoneNumber != _undefined && phoneNumber != null)
        'phoneNumber': (phoneNumber as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$GetChannelsByPhoneNumber<TRes>
    implements CopyWith$Variables$Query$GetChannelsByPhoneNumber<TRes> {
  _CopyWithStubImpl$Variables$Query$GetChannelsByPhoneNumber(this._res);

  TRes _res;

  call({String? phoneNumber}) => _res;
}

class Query$GetChannelsByPhoneNumber {
  Query$GetChannelsByPhoneNumber({
    required this.getChannelsByCustomerPhoneNumber,
    this.$__typename = 'Query',
  });

  factory Query$GetChannelsByPhoneNumber.fromJson(Map<String, dynamic> json) {
    final l$getChannelsByCustomerPhoneNumber =
        json['getChannelsByCustomerPhoneNumber'];
    final l$$__typename = json['__typename'];
    return Query$GetChannelsByPhoneNumber(
      getChannelsByCustomerPhoneNumber:
          (l$getChannelsByCustomerPhoneNumber as List<dynamic>)
              .map(
                (e) =>
                    Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber.fromJson(
                      (e as Map<String, dynamic>),
                    ),
              )
              .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber>
  getChannelsByCustomerPhoneNumber;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$getChannelsByCustomerPhoneNumber = getChannelsByCustomerPhoneNumber;
    _resultData['getChannelsByCustomerPhoneNumber'] =
        l$getChannelsByCustomerPhoneNumber.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$getChannelsByCustomerPhoneNumber = getChannelsByCustomerPhoneNumber;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$getChannelsByCustomerPhoneNumber.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetChannelsByPhoneNumber ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$getChannelsByCustomerPhoneNumber = getChannelsByCustomerPhoneNumber;
    final lOther$getChannelsByCustomerPhoneNumber =
        other.getChannelsByCustomerPhoneNumber;
    if (l$getChannelsByCustomerPhoneNumber.length !=
        lOther$getChannelsByCustomerPhoneNumber.length) {
      return false;
    }
    for (int i = 0; i < l$getChannelsByCustomerPhoneNumber.length; i++) {
      final l$getChannelsByCustomerPhoneNumber$entry =
          l$getChannelsByCustomerPhoneNumber[i];
      final lOther$getChannelsByCustomerPhoneNumber$entry =
          lOther$getChannelsByCustomerPhoneNumber[i];
      if (l$getChannelsByCustomerPhoneNumber$entry !=
          lOther$getChannelsByCustomerPhoneNumber$entry) {
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

extension UtilityExtension$Query$GetChannelsByPhoneNumber
    on Query$GetChannelsByPhoneNumber {
  CopyWith$Query$GetChannelsByPhoneNumber<Query$GetChannelsByPhoneNumber>
  get copyWith => CopyWith$Query$GetChannelsByPhoneNumber(this, (i) => i);
}

abstract class CopyWith$Query$GetChannelsByPhoneNumber<TRes> {
  factory CopyWith$Query$GetChannelsByPhoneNumber(
    Query$GetChannelsByPhoneNumber instance,
    TRes Function(Query$GetChannelsByPhoneNumber) then,
  ) = _CopyWithImpl$Query$GetChannelsByPhoneNumber;

  factory CopyWith$Query$GetChannelsByPhoneNumber.stub(TRes res) =
      _CopyWithStubImpl$Query$GetChannelsByPhoneNumber;

  TRes call({
    List<Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber>?
    getChannelsByCustomerPhoneNumber,
    String? $__typename,
  });
  TRes getChannelsByCustomerPhoneNumber(
    Iterable<Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber>
    Function(
      Iterable<
        CopyWith$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber<
          Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$GetChannelsByPhoneNumber<TRes>
    implements CopyWith$Query$GetChannelsByPhoneNumber<TRes> {
  _CopyWithImpl$Query$GetChannelsByPhoneNumber(this._instance, this._then);

  final Query$GetChannelsByPhoneNumber _instance;

  final TRes Function(Query$GetChannelsByPhoneNumber) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? getChannelsByCustomerPhoneNumber = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetChannelsByPhoneNumber(
      getChannelsByCustomerPhoneNumber:
          getChannelsByCustomerPhoneNumber == _undefined ||
              getChannelsByCustomerPhoneNumber == null
          ? _instance.getChannelsByCustomerPhoneNumber
          : (getChannelsByCustomerPhoneNumber
                as List<
                  Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes getChannelsByCustomerPhoneNumber(
    Iterable<Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber>
    Function(
      Iterable<
        CopyWith$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber<
          Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber
        >
      >,
    )
    _fn,
  ) => call(
    getChannelsByCustomerPhoneNumber: _fn(
      _instance.getChannelsByCustomerPhoneNumber.map(
        (e) =>
            CopyWith$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$GetChannelsByPhoneNumber<TRes>
    implements CopyWith$Query$GetChannelsByPhoneNumber<TRes> {
  _CopyWithStubImpl$Query$GetChannelsByPhoneNumber(this._res);

  TRes _res;

  call({
    List<Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber>?
    getChannelsByCustomerPhoneNumber,
    String? $__typename,
  }) => _res;

  getChannelsByCustomerPhoneNumber(_fn) => _res;
}

const documentNodeQueryGetChannelsByPhoneNumber = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GetChannelsByPhoneNumber'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'phoneNumber')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'getChannelsByCustomerPhoneNumber'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'phoneNumber'),
                value: VariableNode(name: NameNode(value: 'phoneNumber')),
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
                  name: NameNode(value: 'code'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'token'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'defaultCurrencyCode'),
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
Query$GetChannelsByPhoneNumber _parserFn$Query$GetChannelsByPhoneNumber(
  Map<String, dynamic> data,
) => Query$GetChannelsByPhoneNumber.fromJson(data);
typedef OnQueryComplete$Query$GetChannelsByPhoneNumber =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query$GetChannelsByPhoneNumber?,
    );

class Options$Query$GetChannelsByPhoneNumber
    extends graphql.QueryOptions<Query$GetChannelsByPhoneNumber> {
  Options$Query$GetChannelsByPhoneNumber({
    String? operationName,
    required Variables$Query$GetChannelsByPhoneNumber variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetChannelsByPhoneNumber? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetChannelsByPhoneNumber? onComplete,
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
                 data == null
                     ? null
                     : _parserFn$Query$GetChannelsByPhoneNumber(data),
               ),
         onError: onError,
         document: documentNodeQueryGetChannelsByPhoneNumber,
         parserFn: _parserFn$Query$GetChannelsByPhoneNumber,
       );

  final OnQueryComplete$Query$GetChannelsByPhoneNumber? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$GetChannelsByPhoneNumber
    extends graphql.WatchQueryOptions<Query$GetChannelsByPhoneNumber> {
  WatchOptions$Query$GetChannelsByPhoneNumber({
    String? operationName,
    required Variables$Query$GetChannelsByPhoneNumber variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetChannelsByPhoneNumber? typedOptimisticResult,
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
         document: documentNodeQueryGetChannelsByPhoneNumber,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$GetChannelsByPhoneNumber,
       );
}

class FetchMoreOptions$Query$GetChannelsByPhoneNumber
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetChannelsByPhoneNumber({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetChannelsByPhoneNumber variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryGetChannelsByPhoneNumber,
       );
}

extension ClientExtension$Query$GetChannelsByPhoneNumber
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetChannelsByPhoneNumber>>
  query$GetChannelsByPhoneNumber(
    Options$Query$GetChannelsByPhoneNumber options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$GetChannelsByPhoneNumber>
  watchQuery$GetChannelsByPhoneNumber(
    WatchOptions$Query$GetChannelsByPhoneNumber options,
  ) => this.watchQuery(options);

  void writeQuery$GetChannelsByPhoneNumber({
    required Query$GetChannelsByPhoneNumber data,
    required Variables$Query$GetChannelsByPhoneNumber variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryGetChannelsByPhoneNumber,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$GetChannelsByPhoneNumber? readQuery$GetChannelsByPhoneNumber({
    required Variables$Query$GetChannelsByPhoneNumber variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryGetChannelsByPhoneNumber,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query$GetChannelsByPhoneNumber.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetChannelsByPhoneNumber>
useQuery$GetChannelsByPhoneNumber(
  Options$Query$GetChannelsByPhoneNumber options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$GetChannelsByPhoneNumber>
useWatchQuery$GetChannelsByPhoneNumber(
  WatchOptions$Query$GetChannelsByPhoneNumber options,
) => graphql_flutter.useWatchQuery(options);

class Query$GetChannelsByPhoneNumber$Widget
    extends graphql_flutter.Query<Query$GetChannelsByPhoneNumber> {
  Query$GetChannelsByPhoneNumber$Widget({
    widgets.Key? key,
    required Options$Query$GetChannelsByPhoneNumber options,
    required graphql_flutter.QueryBuilder<Query$GetChannelsByPhoneNumber>
    builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber {
  Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber({
    required this.id,
    required this.code,
    required this.token,
    required this.defaultCurrencyCode,
    this.$__typename = 'Channel',
  });

  factory Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$token = json['token'];
    final l$defaultCurrencyCode = json['defaultCurrencyCode'];
    final l$$__typename = json['__typename'];
    return Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber(
      id: (l$id as String),
      code: (l$code as String),
      token: (l$token as String),
      defaultCurrencyCode: fromJson$Enum$CurrencyCode(
        (l$defaultCurrencyCode as String),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String token;

  final Enum$CurrencyCode defaultCurrencyCode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$token = token;
    _resultData['token'] = l$token;
    final l$defaultCurrencyCode = defaultCurrencyCode;
    _resultData['defaultCurrencyCode'] = toJson$Enum$CurrencyCode(
      l$defaultCurrencyCode,
    );
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$token = token;
    final l$defaultCurrencyCode = defaultCurrencyCode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$token,
      l$defaultCurrencyCode,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber ||
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
    final l$token = token;
    final lOther$token = other.token;
    if (l$token != lOther$token) {
      return false;
    }
    final l$defaultCurrencyCode = defaultCurrencyCode;
    final lOther$defaultCurrencyCode = other.defaultCurrencyCode;
    if (l$defaultCurrencyCode != lOther$defaultCurrencyCode) {
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

extension UtilityExtension$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber
    on Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber {
  CopyWith$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber<
    Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber
  >
  get copyWith =>
      CopyWith$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber<
  TRes
> {
  factory CopyWith$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber(
    Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber instance,
    TRes Function(
      Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber,
    )
    then,
  ) = _CopyWithImpl$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber;

  factory CopyWith$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber;

  TRes call({
    String? id,
    String? code,
    String? token,
    Enum$CurrencyCode? defaultCurrencyCode,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber<
  TRes
>
    implements
        CopyWith$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber<
          TRes
        > {
  _CopyWithImpl$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber(
    this._instance,
    this._then,
  );

  final Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber
  _instance;

  final TRes Function(
    Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? token = _undefined,
    Object? defaultCurrencyCode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      token: token == _undefined || token == null
          ? _instance.token
          : (token as String),
      defaultCurrencyCode:
          defaultCurrencyCode == _undefined || defaultCurrencyCode == null
          ? _instance.defaultCurrencyCode
          : (defaultCurrencyCode as Enum$CurrencyCode),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber<
  TRes
>
    implements
        CopyWith$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber<
          TRes
        > {
  _CopyWithStubImpl$Query$GetChannelsByPhoneNumber$getChannelsByCustomerPhoneNumber(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? code,
    String? token,
    Enum$CurrencyCode? defaultCurrencyCode,
    String? $__typename,
  }) => _res;
}

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

class Query$GetChannelList {
  Query$GetChannelList({
    required this.getChannelList,
    this.$__typename = 'Query',
  });

  factory Query$GetChannelList.fromJson(Map<String, dynamic> json) {
    final l$getChannelList = json['getChannelList'];
    final l$$__typename = json['__typename'];
    return Query$GetChannelList(
      getChannelList: (l$getChannelList as List<dynamic>)
          .map(
            (e) => Query$GetChannelList$getChannelList.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$GetChannelList$getChannelList> getChannelList;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$getChannelList = getChannelList;
    _resultData['getChannelList'] = l$getChannelList
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$getChannelList = getChannelList;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$getChannelList.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetChannelList || runtimeType != other.runtimeType) {
      return false;
    }
    final l$getChannelList = getChannelList;
    final lOther$getChannelList = other.getChannelList;
    if (l$getChannelList.length != lOther$getChannelList.length) {
      return false;
    }
    for (int i = 0; i < l$getChannelList.length; i++) {
      final l$getChannelList$entry = l$getChannelList[i];
      final lOther$getChannelList$entry = lOther$getChannelList[i];
      if (l$getChannelList$entry != lOther$getChannelList$entry) {
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

extension UtilityExtension$Query$GetChannelList on Query$GetChannelList {
  CopyWith$Query$GetChannelList<Query$GetChannelList> get copyWith =>
      CopyWith$Query$GetChannelList(this, (i) => i);
}

abstract class CopyWith$Query$GetChannelList<TRes> {
  factory CopyWith$Query$GetChannelList(
    Query$GetChannelList instance,
    TRes Function(Query$GetChannelList) then,
  ) = _CopyWithImpl$Query$GetChannelList;

  factory CopyWith$Query$GetChannelList.stub(TRes res) =
      _CopyWithStubImpl$Query$GetChannelList;

  TRes call({
    List<Query$GetChannelList$getChannelList>? getChannelList,
    String? $__typename,
  });
  TRes getChannelList(
    Iterable<Query$GetChannelList$getChannelList> Function(
      Iterable<
        CopyWith$Query$GetChannelList$getChannelList<
          Query$GetChannelList$getChannelList
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$GetChannelList<TRes>
    implements CopyWith$Query$GetChannelList<TRes> {
  _CopyWithImpl$Query$GetChannelList(this._instance, this._then);

  final Query$GetChannelList _instance;

  final TRes Function(Query$GetChannelList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? getChannelList = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetChannelList(
      getChannelList: getChannelList == _undefined || getChannelList == null
          ? _instance.getChannelList
          : (getChannelList as List<Query$GetChannelList$getChannelList>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes getChannelList(
    Iterable<Query$GetChannelList$getChannelList> Function(
      Iterable<
        CopyWith$Query$GetChannelList$getChannelList<
          Query$GetChannelList$getChannelList
        >
      >,
    )
    _fn,
  ) => call(
    getChannelList: _fn(
      _instance.getChannelList.map(
        (e) => CopyWith$Query$GetChannelList$getChannelList(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$GetChannelList<TRes>
    implements CopyWith$Query$GetChannelList<TRes> {
  _CopyWithStubImpl$Query$GetChannelList(this._res);

  TRes _res;

  call({
    List<Query$GetChannelList$getChannelList>? getChannelList,
    String? $__typename,
  }) => _res;

  getChannelList(_fn) => _res;
}

const documentNodeQueryGetChannelList = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GetChannelList'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'getChannelList'),
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
                  name: NameNode(value: 'token'),
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
Query$GetChannelList _parserFn$Query$GetChannelList(
  Map<String, dynamic> data,
) => Query$GetChannelList.fromJson(data);
typedef OnQueryComplete$Query$GetChannelList =
    FutureOr<void> Function(Map<String, dynamic>?, Query$GetChannelList?);

class Options$Query$GetChannelList
    extends graphql.QueryOptions<Query$GetChannelList> {
  Options$Query$GetChannelList({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetChannelList? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetChannelList? onComplete,
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
                 data == null ? null : _parserFn$Query$GetChannelList(data),
               ),
         onError: onError,
         document: documentNodeQueryGetChannelList,
         parserFn: _parserFn$Query$GetChannelList,
       );

  final OnQueryComplete$Query$GetChannelList? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$GetChannelList
    extends graphql.WatchQueryOptions<Query$GetChannelList> {
  WatchOptions$Query$GetChannelList({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetChannelList? typedOptimisticResult,
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
         document: documentNodeQueryGetChannelList,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$GetChannelList,
       );
}

class FetchMoreOptions$Query$GetChannelList extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetChannelList({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQueryGetChannelList,
       );
}

extension ClientExtension$Query$GetChannelList on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetChannelList>> query$GetChannelList([
    Options$Query$GetChannelList? options,
  ]) async => await this.query(options ?? Options$Query$GetChannelList());

  graphql.ObservableQuery<Query$GetChannelList> watchQuery$GetChannelList([
    WatchOptions$Query$GetChannelList? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$GetChannelList());

  void writeQuery$GetChannelList({
    required Query$GetChannelList data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryGetChannelList),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$GetChannelList? readQuery$GetChannelList({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryGetChannelList),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetChannelList.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetChannelList> useQuery$GetChannelList([
  Options$Query$GetChannelList? options,
]) => graphql_flutter.useQuery(options ?? Options$Query$GetChannelList());
graphql.ObservableQuery<Query$GetChannelList> useWatchQuery$GetChannelList([
  WatchOptions$Query$GetChannelList? options,
]) => graphql_flutter.useWatchQuery(
  options ?? WatchOptions$Query$GetChannelList(),
);

class Query$GetChannelList$Widget
    extends graphql_flutter.Query<Query$GetChannelList> {
  Query$GetChannelList$Widget({
    widgets.Key? key,
    Options$Query$GetChannelList? options,
    required graphql_flutter.QueryBuilder<Query$GetChannelList> builder,
  }) : super(
         key: key,
         options: options ?? Options$Query$GetChannelList(),
         builder: builder,
       );
}

class Query$GetChannelList$getChannelList {
  Query$GetChannelList$getChannelList({
    required this.id,
    required this.code,
    required this.token,
    this.$__typename = 'Channel',
  });

  factory Query$GetChannelList$getChannelList.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$token = json['token'];
    final l$$__typename = json['__typename'];
    return Query$GetChannelList$getChannelList(
      id: (l$id as String),
      code: (l$code as String),
      token: (l$token as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String token;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$token = token;
    _resultData['token'] = l$token;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$token = token;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$code, l$token, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetChannelList$getChannelList ||
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
    final l$token = token;
    final lOther$token = other.token;
    if (l$token != lOther$token) {
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

extension UtilityExtension$Query$GetChannelList$getChannelList
    on Query$GetChannelList$getChannelList {
  CopyWith$Query$GetChannelList$getChannelList<
    Query$GetChannelList$getChannelList
  >
  get copyWith => CopyWith$Query$GetChannelList$getChannelList(this, (i) => i);
}

abstract class CopyWith$Query$GetChannelList$getChannelList<TRes> {
  factory CopyWith$Query$GetChannelList$getChannelList(
    Query$GetChannelList$getChannelList instance,
    TRes Function(Query$GetChannelList$getChannelList) then,
  ) = _CopyWithImpl$Query$GetChannelList$getChannelList;

  factory CopyWith$Query$GetChannelList$getChannelList.stub(TRes res) =
      _CopyWithStubImpl$Query$GetChannelList$getChannelList;

  TRes call({String? id, String? code, String? token, String? $__typename});
}

class _CopyWithImpl$Query$GetChannelList$getChannelList<TRes>
    implements CopyWith$Query$GetChannelList$getChannelList<TRes> {
  _CopyWithImpl$Query$GetChannelList$getChannelList(this._instance, this._then);

  final Query$GetChannelList$getChannelList _instance;

  final TRes Function(Query$GetChannelList$getChannelList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? token = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetChannelList$getChannelList(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      token: token == _undefined || token == null
          ? _instance.token
          : (token as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$GetChannelList$getChannelList<TRes>
    implements CopyWith$Query$GetChannelList$getChannelList<TRes> {
  _CopyWithStubImpl$Query$GetChannelList$getChannelList(this._res);

  TRes _res;

  call({String? id, String? code, String? token, String? $__typename}) => _res;
}
