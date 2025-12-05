import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Variables$Mutation$UpdateCustomer {
  factory Variables$Mutation$UpdateCustomer(
          {required Input$UpdateCustomerInput input}) =>
      Variables$Mutation$UpdateCustomer._({
        r'input': input,
      });

  Variables$Mutation$UpdateCustomer._(this._$data);

  factory Variables$Mutation$UpdateCustomer.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] =
        Input$UpdateCustomerInput.fromJson((l$input as Map<String, dynamic>));
    return Variables$Mutation$UpdateCustomer._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$UpdateCustomerInput get input =>
      (_$data['input'] as Input$UpdateCustomerInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$UpdateCustomer<Variables$Mutation$UpdateCustomer>
      get copyWith => CopyWith$Variables$Mutation$UpdateCustomer(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$UpdateCustomer ||
        runtimeType != other.runtimeType) {
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

abstract class CopyWith$Variables$Mutation$UpdateCustomer<TRes> {
  factory CopyWith$Variables$Mutation$UpdateCustomer(
    Variables$Mutation$UpdateCustomer instance,
    TRes Function(Variables$Mutation$UpdateCustomer) then,
  ) = _CopyWithImpl$Variables$Mutation$UpdateCustomer;

  factory CopyWith$Variables$Mutation$UpdateCustomer.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$UpdateCustomer;

  TRes call({Input$UpdateCustomerInput? input});
}

class _CopyWithImpl$Variables$Mutation$UpdateCustomer<TRes>
    implements CopyWith$Variables$Mutation$UpdateCustomer<TRes> {
  _CopyWithImpl$Variables$Mutation$UpdateCustomer(
    this._instance,
    this._then,
  );

  final Variables$Mutation$UpdateCustomer _instance;

  final TRes Function(Variables$Mutation$UpdateCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) =>
      _then(Variables$Mutation$UpdateCustomer._({
        ..._instance._$data,
        if (input != _undefined && input != null)
          'input': (input as Input$UpdateCustomerInput),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$UpdateCustomer<TRes>
    implements CopyWith$Variables$Mutation$UpdateCustomer<TRes> {
  _CopyWithStubImpl$Variables$Mutation$UpdateCustomer(this._res);

  TRes _res;

  call({Input$UpdateCustomerInput? input}) => _res;
}

class Mutation$UpdateCustomer {
  Mutation$UpdateCustomer({
    required this.updateCustomer,
    this.$__typename = 'Mutation',
  });

  factory Mutation$UpdateCustomer.fromJson(Map<String, dynamic> json) {
    final l$updateCustomer = json['updateCustomer'];
    final l$$__typename = json['__typename'];
    return Mutation$UpdateCustomer(
      updateCustomer: Mutation$UpdateCustomer$updateCustomer.fromJson(
          (l$updateCustomer as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$UpdateCustomer$updateCustomer updateCustomer;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateCustomer = updateCustomer;
    _resultData['updateCustomer'] = l$updateCustomer.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateCustomer = updateCustomer;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$updateCustomer,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UpdateCustomer || runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateCustomer = updateCustomer;
    final lOther$updateCustomer = other.updateCustomer;
    if (l$updateCustomer != lOther$updateCustomer) {
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

extension UtilityExtension$Mutation$UpdateCustomer on Mutation$UpdateCustomer {
  CopyWith$Mutation$UpdateCustomer<Mutation$UpdateCustomer> get copyWith =>
      CopyWith$Mutation$UpdateCustomer(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$UpdateCustomer<TRes> {
  factory CopyWith$Mutation$UpdateCustomer(
    Mutation$UpdateCustomer instance,
    TRes Function(Mutation$UpdateCustomer) then,
  ) = _CopyWithImpl$Mutation$UpdateCustomer;

  factory CopyWith$Mutation$UpdateCustomer.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UpdateCustomer;

  TRes call({
    Mutation$UpdateCustomer$updateCustomer? updateCustomer,
    String? $__typename,
  });
  CopyWith$Mutation$UpdateCustomer$updateCustomer<TRes> get updateCustomer;
}

class _CopyWithImpl$Mutation$UpdateCustomer<TRes>
    implements CopyWith$Mutation$UpdateCustomer<TRes> {
  _CopyWithImpl$Mutation$UpdateCustomer(
    this._instance,
    this._then,
  );

  final Mutation$UpdateCustomer _instance;

  final TRes Function(Mutation$UpdateCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updateCustomer = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$UpdateCustomer(
        updateCustomer: updateCustomer == _undefined || updateCustomer == null
            ? _instance.updateCustomer
            : (updateCustomer as Mutation$UpdateCustomer$updateCustomer),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$UpdateCustomer$updateCustomer<TRes> get updateCustomer {
    final local$updateCustomer = _instance.updateCustomer;
    return CopyWith$Mutation$UpdateCustomer$updateCustomer(
        local$updateCustomer, (e) => call(updateCustomer: e));
  }
}

class _CopyWithStubImpl$Mutation$UpdateCustomer<TRes>
    implements CopyWith$Mutation$UpdateCustomer<TRes> {
  _CopyWithStubImpl$Mutation$UpdateCustomer(this._res);

  TRes _res;

  call({
    Mutation$UpdateCustomer$updateCustomer? updateCustomer,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$UpdateCustomer$updateCustomer<TRes> get updateCustomer =>
      CopyWith$Mutation$UpdateCustomer$updateCustomer.stub(_res);
}

const documentNodeMutationUpdateCustomer = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'UpdateCustomer'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'input')),
        type: NamedTypeNode(
          name: NameNode(value: 'UpdateCustomerInput'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'updateCustomer'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'input'),
            value: VariableNode(name: NameNode(value: 'input')),
          )
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          InlineFragmentNode(
            typeCondition: TypeConditionNode(
                on: NamedTypeNode(
              name: NameNode(value: 'Customer'),
              isNonNull: false,
            )),
            directives: [],
            selectionSet: SelectionSetNode(selections: [
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
Mutation$UpdateCustomer _parserFn$Mutation$UpdateCustomer(
        Map<String, dynamic> data) =>
    Mutation$UpdateCustomer.fromJson(data);
typedef OnMutationCompleted$Mutation$UpdateCustomer = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$UpdateCustomer?,
);

class Options$Mutation$UpdateCustomer
    extends graphql.MutationOptions<Mutation$UpdateCustomer> {
  Options$Mutation$UpdateCustomer({
    String? operationName,
    required Variables$Mutation$UpdateCustomer variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$UpdateCustomer? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$UpdateCustomer? onCompleted,
    graphql.OnMutationUpdate<Mutation$UpdateCustomer>? update,
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
                        : _parserFn$Mutation$UpdateCustomer(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationUpdateCustomer,
          parserFn: _parserFn$Mutation$UpdateCustomer,
        );

  final OnMutationCompleted$Mutation$UpdateCustomer? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$UpdateCustomer
    extends graphql.WatchQueryOptions<Mutation$UpdateCustomer> {
  WatchOptions$Mutation$UpdateCustomer({
    String? operationName,
    required Variables$Mutation$UpdateCustomer variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$UpdateCustomer? typedOptimisticResult,
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
          document: documentNodeMutationUpdateCustomer,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$UpdateCustomer,
        );
}

extension ClientExtension$Mutation$UpdateCustomer on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$UpdateCustomer>> mutate$UpdateCustomer(
          Options$Mutation$UpdateCustomer options) async =>
      await this.mutate(options);
  graphql.ObservableQuery<Mutation$UpdateCustomer> watchMutation$UpdateCustomer(
          WatchOptions$Mutation$UpdateCustomer options) =>
      this.watchMutation(options);
}

class Mutation$UpdateCustomer$HookResult {
  Mutation$UpdateCustomer$HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation$Mutation$UpdateCustomer runMutation;

  final graphql.QueryResult<Mutation$UpdateCustomer> result;
}

Mutation$UpdateCustomer$HookResult useMutation$UpdateCustomer(
    [WidgetOptions$Mutation$UpdateCustomer? options]) {
  final result = graphql_flutter
      .useMutation(options ?? WidgetOptions$Mutation$UpdateCustomer());
  return Mutation$UpdateCustomer$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
      variables.toJson(),
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$UpdateCustomer>
    useWatchMutation$UpdateCustomer(
            WatchOptions$Mutation$UpdateCustomer options) =>
        graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$UpdateCustomer
    extends graphql.MutationOptions<Mutation$UpdateCustomer> {
  WidgetOptions$Mutation$UpdateCustomer({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$UpdateCustomer? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$UpdateCustomer? onCompleted,
    graphql.OnMutationUpdate<Mutation$UpdateCustomer>? update,
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
                        : _parserFn$Mutation$UpdateCustomer(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationUpdateCustomer,
          parserFn: _parserFn$Mutation$UpdateCustomer,
        );

  final OnMutationCompleted$Mutation$UpdateCustomer? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

typedef RunMutation$Mutation$UpdateCustomer
    = graphql.MultiSourceResult<Mutation$UpdateCustomer> Function(
  Variables$Mutation$UpdateCustomer, {
  Object? optimisticResult,
  Mutation$UpdateCustomer? typedOptimisticResult,
});
typedef Builder$Mutation$UpdateCustomer = widgets.Widget Function(
  RunMutation$Mutation$UpdateCustomer,
  graphql.QueryResult<Mutation$UpdateCustomer>?,
);

class Mutation$UpdateCustomer$Widget
    extends graphql_flutter.Mutation<Mutation$UpdateCustomer> {
  Mutation$UpdateCustomer$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$UpdateCustomer? options,
    required Builder$Mutation$UpdateCustomer builder,
  }) : super(
          key: key,
          options: options ?? WidgetOptions$Mutation$UpdateCustomer(),
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

class Mutation$UpdateCustomer$updateCustomer {
  Mutation$UpdateCustomer$updateCustomer({
    required this.firstName,
    required this.lastName,
    this.$__typename = 'Customer',
  });

  factory Mutation$UpdateCustomer$updateCustomer.fromJson(
      Map<String, dynamic> json) {
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$$__typename = json['__typename'];
    return Mutation$UpdateCustomer$updateCustomer(
      firstName: (l$firstName as String),
      lastName: (l$lastName as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String firstName;

  final String lastName;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
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
    final l$firstName = firstName;
    final l$lastName = lastName;
    final l$$__typename = $__typename;
    return Object.hashAll([
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
    if (other is! Mutation$UpdateCustomer$updateCustomer ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Mutation$UpdateCustomer$updateCustomer
    on Mutation$UpdateCustomer$updateCustomer {
  CopyWith$Mutation$UpdateCustomer$updateCustomer<
          Mutation$UpdateCustomer$updateCustomer>
      get copyWith => CopyWith$Mutation$UpdateCustomer$updateCustomer(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$UpdateCustomer$updateCustomer<TRes> {
  factory CopyWith$Mutation$UpdateCustomer$updateCustomer(
    Mutation$UpdateCustomer$updateCustomer instance,
    TRes Function(Mutation$UpdateCustomer$updateCustomer) then,
  ) = _CopyWithImpl$Mutation$UpdateCustomer$updateCustomer;

  factory CopyWith$Mutation$UpdateCustomer$updateCustomer.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UpdateCustomer$updateCustomer;

  TRes call({
    String? firstName,
    String? lastName,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$UpdateCustomer$updateCustomer<TRes>
    implements CopyWith$Mutation$UpdateCustomer$updateCustomer<TRes> {
  _CopyWithImpl$Mutation$UpdateCustomer$updateCustomer(
    this._instance,
    this._then,
  );

  final Mutation$UpdateCustomer$updateCustomer _instance;

  final TRes Function(Mutation$UpdateCustomer$updateCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$UpdateCustomer$updateCustomer(
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

class _CopyWithStubImpl$Mutation$UpdateCustomer$updateCustomer<TRes>
    implements CopyWith$Mutation$UpdateCustomer$updateCustomer<TRes> {
  _CopyWithStubImpl$Mutation$UpdateCustomer$updateCustomer(this._res);

  TRes _res;

  call({
    String? firstName,
    String? lastName,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Mutation$CreateCustomerAddress {
  factory Variables$Mutation$CreateCustomerAddress(
          {required Input$CreateAddressInput input}) =>
      Variables$Mutation$CreateCustomerAddress._({
        r'input': input,
      });

  Variables$Mutation$CreateCustomerAddress._(this._$data);

  factory Variables$Mutation$CreateCustomerAddress.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] =
        Input$CreateAddressInput.fromJson((l$input as Map<String, dynamic>));
    return Variables$Mutation$CreateCustomerAddress._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$CreateAddressInput get input =>
      (_$data['input'] as Input$CreateAddressInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$CreateCustomerAddress<
          Variables$Mutation$CreateCustomerAddress>
      get copyWith => CopyWith$Variables$Mutation$CreateCustomerAddress(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CreateCustomerAddress ||
        runtimeType != other.runtimeType) {
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

abstract class CopyWith$Variables$Mutation$CreateCustomerAddress<TRes> {
  factory CopyWith$Variables$Mutation$CreateCustomerAddress(
    Variables$Mutation$CreateCustomerAddress instance,
    TRes Function(Variables$Mutation$CreateCustomerAddress) then,
  ) = _CopyWithImpl$Variables$Mutation$CreateCustomerAddress;

  factory CopyWith$Variables$Mutation$CreateCustomerAddress.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CreateCustomerAddress;

  TRes call({Input$CreateAddressInput? input});
}

class _CopyWithImpl$Variables$Mutation$CreateCustomerAddress<TRes>
    implements CopyWith$Variables$Mutation$CreateCustomerAddress<TRes> {
  _CopyWithImpl$Variables$Mutation$CreateCustomerAddress(
    this._instance,
    this._then,
  );

  final Variables$Mutation$CreateCustomerAddress _instance;

  final TRes Function(Variables$Mutation$CreateCustomerAddress) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) =>
      _then(Variables$Mutation$CreateCustomerAddress._({
        ..._instance._$data,
        if (input != _undefined && input != null)
          'input': (input as Input$CreateAddressInput),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$CreateCustomerAddress<TRes>
    implements CopyWith$Variables$Mutation$CreateCustomerAddress<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreateCustomerAddress(this._res);

  TRes _res;

  call({Input$CreateAddressInput? input}) => _res;
}

class Mutation$CreateCustomerAddress {
  Mutation$CreateCustomerAddress({
    required this.createCustomerAddress,
    this.$__typename = 'Mutation',
  });

  factory Mutation$CreateCustomerAddress.fromJson(Map<String, dynamic> json) {
    final l$createCustomerAddress = json['createCustomerAddress'];
    final l$$__typename = json['__typename'];
    return Mutation$CreateCustomerAddress(
      createCustomerAddress:
          Mutation$CreateCustomerAddress$createCustomerAddress.fromJson(
              (l$createCustomerAddress as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$CreateCustomerAddress$createCustomerAddress
      createCustomerAddress;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createCustomerAddress = createCustomerAddress;
    _resultData['createCustomerAddress'] = l$createCustomerAddress.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createCustomerAddress = createCustomerAddress;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$createCustomerAddress,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateCustomerAddress ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createCustomerAddress = createCustomerAddress;
    final lOther$createCustomerAddress = other.createCustomerAddress;
    if (l$createCustomerAddress != lOther$createCustomerAddress) {
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

extension UtilityExtension$Mutation$CreateCustomerAddress
    on Mutation$CreateCustomerAddress {
  CopyWith$Mutation$CreateCustomerAddress<Mutation$CreateCustomerAddress>
      get copyWith => CopyWith$Mutation$CreateCustomerAddress(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$CreateCustomerAddress<TRes> {
  factory CopyWith$Mutation$CreateCustomerAddress(
    Mutation$CreateCustomerAddress instance,
    TRes Function(Mutation$CreateCustomerAddress) then,
  ) = _CopyWithImpl$Mutation$CreateCustomerAddress;

  factory CopyWith$Mutation$CreateCustomerAddress.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateCustomerAddress;

  TRes call({
    Mutation$CreateCustomerAddress$createCustomerAddress? createCustomerAddress,
    String? $__typename,
  });
  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress<TRes>
      get createCustomerAddress;
}

class _CopyWithImpl$Mutation$CreateCustomerAddress<TRes>
    implements CopyWith$Mutation$CreateCustomerAddress<TRes> {
  _CopyWithImpl$Mutation$CreateCustomerAddress(
    this._instance,
    this._then,
  );

  final Mutation$CreateCustomerAddress _instance;

  final TRes Function(Mutation$CreateCustomerAddress) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createCustomerAddress = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$CreateCustomerAddress(
        createCustomerAddress:
            createCustomerAddress == _undefined || createCustomerAddress == null
                ? _instance.createCustomerAddress
                : (createCustomerAddress
                    as Mutation$CreateCustomerAddress$createCustomerAddress),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress<TRes>
      get createCustomerAddress {
    final local$createCustomerAddress = _instance.createCustomerAddress;
    return CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress(
        local$createCustomerAddress, (e) => call(createCustomerAddress: e));
  }
}

class _CopyWithStubImpl$Mutation$CreateCustomerAddress<TRes>
    implements CopyWith$Mutation$CreateCustomerAddress<TRes> {
  _CopyWithStubImpl$Mutation$CreateCustomerAddress(this._res);

  TRes _res;

  call({
    Mutation$CreateCustomerAddress$createCustomerAddress? createCustomerAddress,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress<TRes>
      get createCustomerAddress =>
          CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress.stub(
              _res);
}

const documentNodeMutationCreateCustomerAddress = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'CreateCustomerAddress'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'input')),
        type: NamedTypeNode(
          name: NameNode(value: 'CreateAddressInput'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'createCustomerAddress'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'input'),
            value: VariableNode(name: NameNode(value: 'input')),
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
            name: NameNode(value: 'fullName'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'company'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'streetLine1'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'streetLine2'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'city'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'province'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'postalCode'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'phoneNumber'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'defaultShippingAddress'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'defaultBillingAddress'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'country'),
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
]);
Mutation$CreateCustomerAddress _parserFn$Mutation$CreateCustomerAddress(
        Map<String, dynamic> data) =>
    Mutation$CreateCustomerAddress.fromJson(data);
typedef OnMutationCompleted$Mutation$CreateCustomerAddress = FutureOr<void>
    Function(
  Map<String, dynamic>?,
  Mutation$CreateCustomerAddress?,
);

class Options$Mutation$CreateCustomerAddress
    extends graphql.MutationOptions<Mutation$CreateCustomerAddress> {
  Options$Mutation$CreateCustomerAddress({
    String? operationName,
    required Variables$Mutation$CreateCustomerAddress variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$CreateCustomerAddress? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$CreateCustomerAddress? onCompleted,
    graphql.OnMutationUpdate<Mutation$CreateCustomerAddress>? update,
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
                        : _parserFn$Mutation$CreateCustomerAddress(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationCreateCustomerAddress,
          parserFn: _parserFn$Mutation$CreateCustomerAddress,
        );

  final OnMutationCompleted$Mutation$CreateCustomerAddress?
      onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$CreateCustomerAddress
    extends graphql.WatchQueryOptions<Mutation$CreateCustomerAddress> {
  WatchOptions$Mutation$CreateCustomerAddress({
    String? operationName,
    required Variables$Mutation$CreateCustomerAddress variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$CreateCustomerAddress? typedOptimisticResult,
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
          document: documentNodeMutationCreateCustomerAddress,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$CreateCustomerAddress,
        );
}

extension ClientExtension$Mutation$CreateCustomerAddress
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$CreateCustomerAddress>>
      mutate$CreateCustomerAddress(
              Options$Mutation$CreateCustomerAddress options) async =>
          await this.mutate(options);
  graphql.ObservableQuery<Mutation$CreateCustomerAddress>
      watchMutation$CreateCustomerAddress(
              WatchOptions$Mutation$CreateCustomerAddress options) =>
          this.watchMutation(options);
}

class Mutation$CreateCustomerAddress$HookResult {
  Mutation$CreateCustomerAddress$HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation$Mutation$CreateCustomerAddress runMutation;

  final graphql.QueryResult<Mutation$CreateCustomerAddress> result;
}

Mutation$CreateCustomerAddress$HookResult useMutation$CreateCustomerAddress(
    [WidgetOptions$Mutation$CreateCustomerAddress? options]) {
  final result = graphql_flutter
      .useMutation(options ?? WidgetOptions$Mutation$CreateCustomerAddress());
  return Mutation$CreateCustomerAddress$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
      variables.toJson(),
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$CreateCustomerAddress>
    useWatchMutation$CreateCustomerAddress(
            WatchOptions$Mutation$CreateCustomerAddress options) =>
        graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$CreateCustomerAddress
    extends graphql.MutationOptions<Mutation$CreateCustomerAddress> {
  WidgetOptions$Mutation$CreateCustomerAddress({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$CreateCustomerAddress? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$CreateCustomerAddress? onCompleted,
    graphql.OnMutationUpdate<Mutation$CreateCustomerAddress>? update,
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
                        : _parserFn$Mutation$CreateCustomerAddress(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationCreateCustomerAddress,
          parserFn: _parserFn$Mutation$CreateCustomerAddress,
        );

  final OnMutationCompleted$Mutation$CreateCustomerAddress?
      onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

typedef RunMutation$Mutation$CreateCustomerAddress
    = graphql.MultiSourceResult<Mutation$CreateCustomerAddress> Function(
  Variables$Mutation$CreateCustomerAddress, {
  Object? optimisticResult,
  Mutation$CreateCustomerAddress? typedOptimisticResult,
});
typedef Builder$Mutation$CreateCustomerAddress = widgets.Widget Function(
  RunMutation$Mutation$CreateCustomerAddress,
  graphql.QueryResult<Mutation$CreateCustomerAddress>?,
);

class Mutation$CreateCustomerAddress$Widget
    extends graphql_flutter.Mutation<Mutation$CreateCustomerAddress> {
  Mutation$CreateCustomerAddress$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$CreateCustomerAddress? options,
    required Builder$Mutation$CreateCustomerAddress builder,
  }) : super(
          key: key,
          options: options ?? WidgetOptions$Mutation$CreateCustomerAddress(),
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

class Mutation$CreateCustomerAddress$createCustomerAddress {
  Mutation$CreateCustomerAddress$createCustomerAddress({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.fullName,
    this.company,
    required this.streetLine1,
    this.streetLine2,
    this.city,
    this.province,
    this.postalCode,
    this.phoneNumber,
    this.defaultShippingAddress,
    this.defaultBillingAddress,
    required this.country,
    this.$__typename = 'Address',
  });

  factory Mutation$CreateCustomerAddress$createCustomerAddress.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$createdAt = json['createdAt'];
    final l$updatedAt = json['updatedAt'];
    final l$fullName = json['fullName'];
    final l$company = json['company'];
    final l$streetLine1 = json['streetLine1'];
    final l$streetLine2 = json['streetLine2'];
    final l$city = json['city'];
    final l$province = json['province'];
    final l$postalCode = json['postalCode'];
    final l$phoneNumber = json['phoneNumber'];
    final l$defaultShippingAddress = json['defaultShippingAddress'];
    final l$defaultBillingAddress = json['defaultBillingAddress'];
    final l$country = json['country'];
    final l$$__typename = json['__typename'];
    return Mutation$CreateCustomerAddress$createCustomerAddress(
      id: (l$id as String),
      createdAt: DateTime.parse((l$createdAt as String)),
      updatedAt: DateTime.parse((l$updatedAt as String)),
      fullName: (l$fullName as String?),
      company: (l$company as String?),
      streetLine1: (l$streetLine1 as String),
      streetLine2: (l$streetLine2 as String?),
      city: (l$city as String?),
      province: (l$province as String?),
      postalCode: (l$postalCode as String?),
      phoneNumber: (l$phoneNumber as String?),
      defaultShippingAddress: (l$defaultShippingAddress as bool?),
      defaultBillingAddress: (l$defaultBillingAddress as bool?),
      country:
          Mutation$CreateCustomerAddress$createCustomerAddress$country.fromJson(
              (l$country as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String? fullName;

  final String? company;

  final String streetLine1;

  final String? streetLine2;

  final String? city;

  final String? province;

  final String? postalCode;

  final String? phoneNumber;

  final bool? defaultShippingAddress;

  final bool? defaultBillingAddress;

  final Mutation$CreateCustomerAddress$createCustomerAddress$country country;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$updatedAt = updatedAt;
    _resultData['updatedAt'] = l$updatedAt.toIso8601String();
    final l$fullName = fullName;
    _resultData['fullName'] = l$fullName;
    final l$company = company;
    _resultData['company'] = l$company;
    final l$streetLine1 = streetLine1;
    _resultData['streetLine1'] = l$streetLine1;
    final l$streetLine2 = streetLine2;
    _resultData['streetLine2'] = l$streetLine2;
    final l$city = city;
    _resultData['city'] = l$city;
    final l$province = province;
    _resultData['province'] = l$province;
    final l$postalCode = postalCode;
    _resultData['postalCode'] = l$postalCode;
    final l$phoneNumber = phoneNumber;
    _resultData['phoneNumber'] = l$phoneNumber;
    final l$defaultShippingAddress = defaultShippingAddress;
    _resultData['defaultShippingAddress'] = l$defaultShippingAddress;
    final l$defaultBillingAddress = defaultBillingAddress;
    _resultData['defaultBillingAddress'] = l$defaultBillingAddress;
    final l$country = country;
    _resultData['country'] = l$country.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$createdAt = createdAt;
    final l$updatedAt = updatedAt;
    final l$fullName = fullName;
    final l$company = company;
    final l$streetLine1 = streetLine1;
    final l$streetLine2 = streetLine2;
    final l$city = city;
    final l$province = province;
    final l$postalCode = postalCode;
    final l$phoneNumber = phoneNumber;
    final l$defaultShippingAddress = defaultShippingAddress;
    final l$defaultBillingAddress = defaultBillingAddress;
    final l$country = country;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$createdAt,
      l$updatedAt,
      l$fullName,
      l$company,
      l$streetLine1,
      l$streetLine2,
      l$city,
      l$province,
      l$postalCode,
      l$phoneNumber,
      l$defaultShippingAddress,
      l$defaultBillingAddress,
      l$country,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateCustomerAddress$createCustomerAddress ||
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
    final l$fullName = fullName;
    final lOther$fullName = other.fullName;
    if (l$fullName != lOther$fullName) {
      return false;
    }
    final l$company = company;
    final lOther$company = other.company;
    if (l$company != lOther$company) {
      return false;
    }
    final l$streetLine1 = streetLine1;
    final lOther$streetLine1 = other.streetLine1;
    if (l$streetLine1 != lOther$streetLine1) {
      return false;
    }
    final l$streetLine2 = streetLine2;
    final lOther$streetLine2 = other.streetLine2;
    if (l$streetLine2 != lOther$streetLine2) {
      return false;
    }
    final l$city = city;
    final lOther$city = other.city;
    if (l$city != lOther$city) {
      return false;
    }
    final l$province = province;
    final lOther$province = other.province;
    if (l$province != lOther$province) {
      return false;
    }
    final l$postalCode = postalCode;
    final lOther$postalCode = other.postalCode;
    if (l$postalCode != lOther$postalCode) {
      return false;
    }
    final l$phoneNumber = phoneNumber;
    final lOther$phoneNumber = other.phoneNumber;
    if (l$phoneNumber != lOther$phoneNumber) {
      return false;
    }
    final l$defaultShippingAddress = defaultShippingAddress;
    final lOther$defaultShippingAddress = other.defaultShippingAddress;
    if (l$defaultShippingAddress != lOther$defaultShippingAddress) {
      return false;
    }
    final l$defaultBillingAddress = defaultBillingAddress;
    final lOther$defaultBillingAddress = other.defaultBillingAddress;
    if (l$defaultBillingAddress != lOther$defaultBillingAddress) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (l$country != lOther$country) {
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

extension UtilityExtension$Mutation$CreateCustomerAddress$createCustomerAddress
    on Mutation$CreateCustomerAddress$createCustomerAddress {
  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress<
          Mutation$CreateCustomerAddress$createCustomerAddress>
      get copyWith =>
          CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress<
    TRes> {
  factory CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress(
    Mutation$CreateCustomerAddress$createCustomerAddress instance,
    TRes Function(Mutation$CreateCustomerAddress$createCustomerAddress) then,
  ) = _CopyWithImpl$Mutation$CreateCustomerAddress$createCustomerAddress;

  factory CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$CreateCustomerAddress$createCustomerAddress;

  TRes call({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fullName,
    String? company,
    String? streetLine1,
    String? streetLine2,
    String? city,
    String? province,
    String? postalCode,
    String? phoneNumber,
    bool? defaultShippingAddress,
    bool? defaultBillingAddress,
    Mutation$CreateCustomerAddress$createCustomerAddress$country? country,
    String? $__typename,
  });
  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country<TRes>
      get country;
}

class _CopyWithImpl$Mutation$CreateCustomerAddress$createCustomerAddress<TRes>
    implements
        CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress<TRes> {
  _CopyWithImpl$Mutation$CreateCustomerAddress$createCustomerAddress(
    this._instance,
    this._then,
  );

  final Mutation$CreateCustomerAddress$createCustomerAddress _instance;

  final TRes Function(Mutation$CreateCustomerAddress$createCustomerAddress)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? createdAt = _undefined,
    Object? updatedAt = _undefined,
    Object? fullName = _undefined,
    Object? company = _undefined,
    Object? streetLine1 = _undefined,
    Object? streetLine2 = _undefined,
    Object? city = _undefined,
    Object? province = _undefined,
    Object? postalCode = _undefined,
    Object? phoneNumber = _undefined,
    Object? defaultShippingAddress = _undefined,
    Object? defaultBillingAddress = _undefined,
    Object? country = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$CreateCustomerAddress$createCustomerAddress(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        updatedAt: updatedAt == _undefined || updatedAt == null
            ? _instance.updatedAt
            : (updatedAt as DateTime),
        fullName:
            fullName == _undefined ? _instance.fullName : (fullName as String?),
        company:
            company == _undefined ? _instance.company : (company as String?),
        streetLine1: streetLine1 == _undefined || streetLine1 == null
            ? _instance.streetLine1
            : (streetLine1 as String),
        streetLine2: streetLine2 == _undefined
            ? _instance.streetLine2
            : (streetLine2 as String?),
        city: city == _undefined ? _instance.city : (city as String?),
        province:
            province == _undefined ? _instance.province : (province as String?),
        postalCode: postalCode == _undefined
            ? _instance.postalCode
            : (postalCode as String?),
        phoneNumber: phoneNumber == _undefined
            ? _instance.phoneNumber
            : (phoneNumber as String?),
        defaultShippingAddress: defaultShippingAddress == _undefined
            ? _instance.defaultShippingAddress
            : (defaultShippingAddress as bool?),
        defaultBillingAddress: defaultBillingAddress == _undefined
            ? _instance.defaultBillingAddress
            : (defaultBillingAddress as bool?),
        country: country == _undefined || country == null
            ? _instance.country
            : (country
                as Mutation$CreateCustomerAddress$createCustomerAddress$country),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country<TRes>
      get country {
    final local$country = _instance.country;
    return CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country(
        local$country, (e) => call(country: e));
  }
}

class _CopyWithStubImpl$Mutation$CreateCustomerAddress$createCustomerAddress<
        TRes>
    implements
        CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress<TRes> {
  _CopyWithStubImpl$Mutation$CreateCustomerAddress$createCustomerAddress(
      this._res);

  TRes _res;

  call({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fullName,
    String? company,
    String? streetLine1,
    String? streetLine2,
    String? city,
    String? province,
    String? postalCode,
    String? phoneNumber,
    bool? defaultShippingAddress,
    bool? defaultBillingAddress,
    Mutation$CreateCustomerAddress$createCustomerAddress$country? country,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country<TRes>
      get country =>
          CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country
              .stub(_res);
}

class Mutation$CreateCustomerAddress$createCustomerAddress$country {
  Mutation$CreateCustomerAddress$createCustomerAddress$country({
    required this.id,
    required this.name,
    this.$__typename = 'Country',
  });

  factory Mutation$CreateCustomerAddress$createCustomerAddress$country.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Mutation$CreateCustomerAddress$createCustomerAddress$country(
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
            is! Mutation$CreateCustomerAddress$createCustomerAddress$country ||
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

extension UtilityExtension$Mutation$CreateCustomerAddress$createCustomerAddress$country
    on Mutation$CreateCustomerAddress$createCustomerAddress$country {
  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country<
          Mutation$CreateCustomerAddress$createCustomerAddress$country>
      get copyWith =>
          CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country<
    TRes> {
  factory CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country(
    Mutation$CreateCustomerAddress$createCustomerAddress$country instance,
    TRes Function(Mutation$CreateCustomerAddress$createCustomerAddress$country)
        then,
  ) = _CopyWithImpl$Mutation$CreateCustomerAddress$createCustomerAddress$country;

  factory CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$CreateCustomerAddress$createCustomerAddress$country;

  TRes call({
    String? id,
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$CreateCustomerAddress$createCustomerAddress$country<
        TRes>
    implements
        CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country<
            TRes> {
  _CopyWithImpl$Mutation$CreateCustomerAddress$createCustomerAddress$country(
    this._instance,
    this._then,
  );

  final Mutation$CreateCustomerAddress$createCustomerAddress$country _instance;

  final TRes Function(
      Mutation$CreateCustomerAddress$createCustomerAddress$country) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$CreateCustomerAddress$createCustomerAddress$country(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$CreateCustomerAddress$createCustomerAddress$country<
        TRes>
    implements
        CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country<
            TRes> {
  _CopyWithStubImpl$Mutation$CreateCustomerAddress$createCustomerAddress$country(
      this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Mutation$UpdateCustomerAddress {
  factory Variables$Mutation$UpdateCustomerAddress(
          {required Input$UpdateAddressInput input}) =>
      Variables$Mutation$UpdateCustomerAddress._({
        r'input': input,
      });

  Variables$Mutation$UpdateCustomerAddress._(this._$data);

  factory Variables$Mutation$UpdateCustomerAddress.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] =
        Input$UpdateAddressInput.fromJson((l$input as Map<String, dynamic>));
    return Variables$Mutation$UpdateCustomerAddress._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$UpdateAddressInput get input =>
      (_$data['input'] as Input$UpdateAddressInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$UpdateCustomerAddress<
          Variables$Mutation$UpdateCustomerAddress>
      get copyWith => CopyWith$Variables$Mutation$UpdateCustomerAddress(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$UpdateCustomerAddress ||
        runtimeType != other.runtimeType) {
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

abstract class CopyWith$Variables$Mutation$UpdateCustomerAddress<TRes> {
  factory CopyWith$Variables$Mutation$UpdateCustomerAddress(
    Variables$Mutation$UpdateCustomerAddress instance,
    TRes Function(Variables$Mutation$UpdateCustomerAddress) then,
  ) = _CopyWithImpl$Variables$Mutation$UpdateCustomerAddress;

  factory CopyWith$Variables$Mutation$UpdateCustomerAddress.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$UpdateCustomerAddress;

  TRes call({Input$UpdateAddressInput? input});
}

class _CopyWithImpl$Variables$Mutation$UpdateCustomerAddress<TRes>
    implements CopyWith$Variables$Mutation$UpdateCustomerAddress<TRes> {
  _CopyWithImpl$Variables$Mutation$UpdateCustomerAddress(
    this._instance,
    this._then,
  );

  final Variables$Mutation$UpdateCustomerAddress _instance;

  final TRes Function(Variables$Mutation$UpdateCustomerAddress) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) =>
      _then(Variables$Mutation$UpdateCustomerAddress._({
        ..._instance._$data,
        if (input != _undefined && input != null)
          'input': (input as Input$UpdateAddressInput),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$UpdateCustomerAddress<TRes>
    implements CopyWith$Variables$Mutation$UpdateCustomerAddress<TRes> {
  _CopyWithStubImpl$Variables$Mutation$UpdateCustomerAddress(this._res);

  TRes _res;

  call({Input$UpdateAddressInput? input}) => _res;
}

class Mutation$UpdateCustomerAddress {
  Mutation$UpdateCustomerAddress({
    required this.updateCustomerAddress,
    this.$__typename = 'Mutation',
  });

  factory Mutation$UpdateCustomerAddress.fromJson(Map<String, dynamic> json) {
    final l$updateCustomerAddress = json['updateCustomerAddress'];
    final l$$__typename = json['__typename'];
    return Mutation$UpdateCustomerAddress(
      updateCustomerAddress:
          Mutation$UpdateCustomerAddress$updateCustomerAddress.fromJson(
              (l$updateCustomerAddress as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$UpdateCustomerAddress$updateCustomerAddress
      updateCustomerAddress;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateCustomerAddress = updateCustomerAddress;
    _resultData['updateCustomerAddress'] = l$updateCustomerAddress.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateCustomerAddress = updateCustomerAddress;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$updateCustomerAddress,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UpdateCustomerAddress ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateCustomerAddress = updateCustomerAddress;
    final lOther$updateCustomerAddress = other.updateCustomerAddress;
    if (l$updateCustomerAddress != lOther$updateCustomerAddress) {
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

extension UtilityExtension$Mutation$UpdateCustomerAddress
    on Mutation$UpdateCustomerAddress {
  CopyWith$Mutation$UpdateCustomerAddress<Mutation$UpdateCustomerAddress>
      get copyWith => CopyWith$Mutation$UpdateCustomerAddress(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$UpdateCustomerAddress<TRes> {
  factory CopyWith$Mutation$UpdateCustomerAddress(
    Mutation$UpdateCustomerAddress instance,
    TRes Function(Mutation$UpdateCustomerAddress) then,
  ) = _CopyWithImpl$Mutation$UpdateCustomerAddress;

  factory CopyWith$Mutation$UpdateCustomerAddress.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UpdateCustomerAddress;

  TRes call({
    Mutation$UpdateCustomerAddress$updateCustomerAddress? updateCustomerAddress,
    String? $__typename,
  });
  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress<TRes>
      get updateCustomerAddress;
}

class _CopyWithImpl$Mutation$UpdateCustomerAddress<TRes>
    implements CopyWith$Mutation$UpdateCustomerAddress<TRes> {
  _CopyWithImpl$Mutation$UpdateCustomerAddress(
    this._instance,
    this._then,
  );

  final Mutation$UpdateCustomerAddress _instance;

  final TRes Function(Mutation$UpdateCustomerAddress) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updateCustomerAddress = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$UpdateCustomerAddress(
        updateCustomerAddress:
            updateCustomerAddress == _undefined || updateCustomerAddress == null
                ? _instance.updateCustomerAddress
                : (updateCustomerAddress
                    as Mutation$UpdateCustomerAddress$updateCustomerAddress),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress<TRes>
      get updateCustomerAddress {
    final local$updateCustomerAddress = _instance.updateCustomerAddress;
    return CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress(
        local$updateCustomerAddress, (e) => call(updateCustomerAddress: e));
  }
}

class _CopyWithStubImpl$Mutation$UpdateCustomerAddress<TRes>
    implements CopyWith$Mutation$UpdateCustomerAddress<TRes> {
  _CopyWithStubImpl$Mutation$UpdateCustomerAddress(this._res);

  TRes _res;

  call({
    Mutation$UpdateCustomerAddress$updateCustomerAddress? updateCustomerAddress,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress<TRes>
      get updateCustomerAddress =>
          CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress.stub(
              _res);
}

const documentNodeMutationUpdateCustomerAddress = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'UpdateCustomerAddress'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'input')),
        type: NamedTypeNode(
          name: NameNode(value: 'UpdateAddressInput'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'updateCustomerAddress'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'input'),
            value: VariableNode(name: NameNode(value: 'input')),
          )
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'createdAt'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'city'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'country'),
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
                name: NameNode(value: 'code'),
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
                name: NameNode(value: 'languageCode'),
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
            name: NameNode(value: 'id'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'company'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'defaultBillingAddress'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'defaultShippingAddress'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'fullName'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'phoneNumber'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'streetLine1'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'streetLine2'),
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
Mutation$UpdateCustomerAddress _parserFn$Mutation$UpdateCustomerAddress(
        Map<String, dynamic> data) =>
    Mutation$UpdateCustomerAddress.fromJson(data);
typedef OnMutationCompleted$Mutation$UpdateCustomerAddress = FutureOr<void>
    Function(
  Map<String, dynamic>?,
  Mutation$UpdateCustomerAddress?,
);

class Options$Mutation$UpdateCustomerAddress
    extends graphql.MutationOptions<Mutation$UpdateCustomerAddress> {
  Options$Mutation$UpdateCustomerAddress({
    String? operationName,
    required Variables$Mutation$UpdateCustomerAddress variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$UpdateCustomerAddress? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$UpdateCustomerAddress? onCompleted,
    graphql.OnMutationUpdate<Mutation$UpdateCustomerAddress>? update,
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
                        : _parserFn$Mutation$UpdateCustomerAddress(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationUpdateCustomerAddress,
          parserFn: _parserFn$Mutation$UpdateCustomerAddress,
        );

  final OnMutationCompleted$Mutation$UpdateCustomerAddress?
      onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$UpdateCustomerAddress
    extends graphql.WatchQueryOptions<Mutation$UpdateCustomerAddress> {
  WatchOptions$Mutation$UpdateCustomerAddress({
    String? operationName,
    required Variables$Mutation$UpdateCustomerAddress variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$UpdateCustomerAddress? typedOptimisticResult,
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
          document: documentNodeMutationUpdateCustomerAddress,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$UpdateCustomerAddress,
        );
}

extension ClientExtension$Mutation$UpdateCustomerAddress
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$UpdateCustomerAddress>>
      mutate$UpdateCustomerAddress(
              Options$Mutation$UpdateCustomerAddress options) async =>
          await this.mutate(options);
  graphql.ObservableQuery<Mutation$UpdateCustomerAddress>
      watchMutation$UpdateCustomerAddress(
              WatchOptions$Mutation$UpdateCustomerAddress options) =>
          this.watchMutation(options);
}

class Mutation$UpdateCustomerAddress$HookResult {
  Mutation$UpdateCustomerAddress$HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation$Mutation$UpdateCustomerAddress runMutation;

  final graphql.QueryResult<Mutation$UpdateCustomerAddress> result;
}

Mutation$UpdateCustomerAddress$HookResult useMutation$UpdateCustomerAddress(
    [WidgetOptions$Mutation$UpdateCustomerAddress? options]) {
  final result = graphql_flutter
      .useMutation(options ?? WidgetOptions$Mutation$UpdateCustomerAddress());
  return Mutation$UpdateCustomerAddress$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
      variables.toJson(),
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$UpdateCustomerAddress>
    useWatchMutation$UpdateCustomerAddress(
            WatchOptions$Mutation$UpdateCustomerAddress options) =>
        graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$UpdateCustomerAddress
    extends graphql.MutationOptions<Mutation$UpdateCustomerAddress> {
  WidgetOptions$Mutation$UpdateCustomerAddress({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$UpdateCustomerAddress? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$UpdateCustomerAddress? onCompleted,
    graphql.OnMutationUpdate<Mutation$UpdateCustomerAddress>? update,
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
                        : _parserFn$Mutation$UpdateCustomerAddress(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationUpdateCustomerAddress,
          parserFn: _parserFn$Mutation$UpdateCustomerAddress,
        );

  final OnMutationCompleted$Mutation$UpdateCustomerAddress?
      onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

typedef RunMutation$Mutation$UpdateCustomerAddress
    = graphql.MultiSourceResult<Mutation$UpdateCustomerAddress> Function(
  Variables$Mutation$UpdateCustomerAddress, {
  Object? optimisticResult,
  Mutation$UpdateCustomerAddress? typedOptimisticResult,
});
typedef Builder$Mutation$UpdateCustomerAddress = widgets.Widget Function(
  RunMutation$Mutation$UpdateCustomerAddress,
  graphql.QueryResult<Mutation$UpdateCustomerAddress>?,
);

class Mutation$UpdateCustomerAddress$Widget
    extends graphql_flutter.Mutation<Mutation$UpdateCustomerAddress> {
  Mutation$UpdateCustomerAddress$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$UpdateCustomerAddress? options,
    required Builder$Mutation$UpdateCustomerAddress builder,
  }) : super(
          key: key,
          options: options ?? WidgetOptions$Mutation$UpdateCustomerAddress(),
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

class Mutation$UpdateCustomerAddress$updateCustomerAddress {
  Mutation$UpdateCustomerAddress$updateCustomerAddress({
    required this.createdAt,
    this.city,
    required this.country,
    required this.id,
    this.company,
    this.defaultBillingAddress,
    this.defaultShippingAddress,
    this.fullName,
    this.phoneNumber,
    required this.streetLine1,
    this.streetLine2,
    this.$__typename = 'Address',
  });

  factory Mutation$UpdateCustomerAddress$updateCustomerAddress.fromJson(
      Map<String, dynamic> json) {
    final l$createdAt = json['createdAt'];
    final l$city = json['city'];
    final l$country = json['country'];
    final l$id = json['id'];
    final l$company = json['company'];
    final l$defaultBillingAddress = json['defaultBillingAddress'];
    final l$defaultShippingAddress = json['defaultShippingAddress'];
    final l$fullName = json['fullName'];
    final l$phoneNumber = json['phoneNumber'];
    final l$streetLine1 = json['streetLine1'];
    final l$streetLine2 = json['streetLine2'];
    final l$$__typename = json['__typename'];
    return Mutation$UpdateCustomerAddress$updateCustomerAddress(
      createdAt: DateTime.parse((l$createdAt as String)),
      city: (l$city as String?),
      country:
          Mutation$UpdateCustomerAddress$updateCustomerAddress$country.fromJson(
              (l$country as Map<String, dynamic>)),
      id: (l$id as String),
      company: (l$company as String?),
      defaultBillingAddress: (l$defaultBillingAddress as bool?),
      defaultShippingAddress: (l$defaultShippingAddress as bool?),
      fullName: (l$fullName as String?),
      phoneNumber: (l$phoneNumber as String?),
      streetLine1: (l$streetLine1 as String),
      streetLine2: (l$streetLine2 as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final DateTime createdAt;

  final String? city;

  final Mutation$UpdateCustomerAddress$updateCustomerAddress$country country;

  final String id;

  final String? company;

  final bool? defaultBillingAddress;

  final bool? defaultShippingAddress;

  final String? fullName;

  final String? phoneNumber;

  final String streetLine1;

  final String? streetLine2;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$city = city;
    _resultData['city'] = l$city;
    final l$country = country;
    _resultData['country'] = l$country.toJson();
    final l$id = id;
    _resultData['id'] = l$id;
    final l$company = company;
    _resultData['company'] = l$company;
    final l$defaultBillingAddress = defaultBillingAddress;
    _resultData['defaultBillingAddress'] = l$defaultBillingAddress;
    final l$defaultShippingAddress = defaultShippingAddress;
    _resultData['defaultShippingAddress'] = l$defaultShippingAddress;
    final l$fullName = fullName;
    _resultData['fullName'] = l$fullName;
    final l$phoneNumber = phoneNumber;
    _resultData['phoneNumber'] = l$phoneNumber;
    final l$streetLine1 = streetLine1;
    _resultData['streetLine1'] = l$streetLine1;
    final l$streetLine2 = streetLine2;
    _resultData['streetLine2'] = l$streetLine2;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createdAt = createdAt;
    final l$city = city;
    final l$country = country;
    final l$id = id;
    final l$company = company;
    final l$defaultBillingAddress = defaultBillingAddress;
    final l$defaultShippingAddress = defaultShippingAddress;
    final l$fullName = fullName;
    final l$phoneNumber = phoneNumber;
    final l$streetLine1 = streetLine1;
    final l$streetLine2 = streetLine2;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$createdAt,
      l$city,
      l$country,
      l$id,
      l$company,
      l$defaultBillingAddress,
      l$defaultShippingAddress,
      l$fullName,
      l$phoneNumber,
      l$streetLine1,
      l$streetLine2,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UpdateCustomerAddress$updateCustomerAddress ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$city = city;
    final lOther$city = other.city;
    if (l$city != lOther$city) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (l$country != lOther$country) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$company = company;
    final lOther$company = other.company;
    if (l$company != lOther$company) {
      return false;
    }
    final l$defaultBillingAddress = defaultBillingAddress;
    final lOther$defaultBillingAddress = other.defaultBillingAddress;
    if (l$defaultBillingAddress != lOther$defaultBillingAddress) {
      return false;
    }
    final l$defaultShippingAddress = defaultShippingAddress;
    final lOther$defaultShippingAddress = other.defaultShippingAddress;
    if (l$defaultShippingAddress != lOther$defaultShippingAddress) {
      return false;
    }
    final l$fullName = fullName;
    final lOther$fullName = other.fullName;
    if (l$fullName != lOther$fullName) {
      return false;
    }
    final l$phoneNumber = phoneNumber;
    final lOther$phoneNumber = other.phoneNumber;
    if (l$phoneNumber != lOther$phoneNumber) {
      return false;
    }
    final l$streetLine1 = streetLine1;
    final lOther$streetLine1 = other.streetLine1;
    if (l$streetLine1 != lOther$streetLine1) {
      return false;
    }
    final l$streetLine2 = streetLine2;
    final lOther$streetLine2 = other.streetLine2;
    if (l$streetLine2 != lOther$streetLine2) {
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

extension UtilityExtension$Mutation$UpdateCustomerAddress$updateCustomerAddress
    on Mutation$UpdateCustomerAddress$updateCustomerAddress {
  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress<
          Mutation$UpdateCustomerAddress$updateCustomerAddress>
      get copyWith =>
          CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress<
    TRes> {
  factory CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress(
    Mutation$UpdateCustomerAddress$updateCustomerAddress instance,
    TRes Function(Mutation$UpdateCustomerAddress$updateCustomerAddress) then,
  ) = _CopyWithImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress;

  factory CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress;

  TRes call({
    DateTime? createdAt,
    String? city,
    Mutation$UpdateCustomerAddress$updateCustomerAddress$country? country,
    String? id,
    String? company,
    bool? defaultBillingAddress,
    bool? defaultShippingAddress,
    String? fullName,
    String? phoneNumber,
    String? streetLine1,
    String? streetLine2,
    String? $__typename,
  });
  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<TRes>
      get country;
}

class _CopyWithImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress<TRes>
    implements
        CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress<TRes> {
  _CopyWithImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress(
    this._instance,
    this._then,
  );

  final Mutation$UpdateCustomerAddress$updateCustomerAddress _instance;

  final TRes Function(Mutation$UpdateCustomerAddress$updateCustomerAddress)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createdAt = _undefined,
    Object? city = _undefined,
    Object? country = _undefined,
    Object? id = _undefined,
    Object? company = _undefined,
    Object? defaultBillingAddress = _undefined,
    Object? defaultShippingAddress = _undefined,
    Object? fullName = _undefined,
    Object? phoneNumber = _undefined,
    Object? streetLine1 = _undefined,
    Object? streetLine2 = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$UpdateCustomerAddress$updateCustomerAddress(
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        city: city == _undefined ? _instance.city : (city as String?),
        country: country == _undefined || country == null
            ? _instance.country
            : (country
                as Mutation$UpdateCustomerAddress$updateCustomerAddress$country),
        id: id == _undefined || id == null ? _instance.id : (id as String),
        company:
            company == _undefined ? _instance.company : (company as String?),
        defaultBillingAddress: defaultBillingAddress == _undefined
            ? _instance.defaultBillingAddress
            : (defaultBillingAddress as bool?),
        defaultShippingAddress: defaultShippingAddress == _undefined
            ? _instance.defaultShippingAddress
            : (defaultShippingAddress as bool?),
        fullName:
            fullName == _undefined ? _instance.fullName : (fullName as String?),
        phoneNumber: phoneNumber == _undefined
            ? _instance.phoneNumber
            : (phoneNumber as String?),
        streetLine1: streetLine1 == _undefined || streetLine1 == null
            ? _instance.streetLine1
            : (streetLine1 as String),
        streetLine2: streetLine2 == _undefined
            ? _instance.streetLine2
            : (streetLine2 as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<TRes>
      get country {
    final local$country = _instance.country;
    return CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country(
        local$country, (e) => call(country: e));
  }
}

class _CopyWithStubImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress<
        TRes>
    implements
        CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress<TRes> {
  _CopyWithStubImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress(
      this._res);

  TRes _res;

  call({
    DateTime? createdAt,
    String? city,
    Mutation$UpdateCustomerAddress$updateCustomerAddress$country? country,
    String? id,
    String? company,
    bool? defaultBillingAddress,
    bool? defaultShippingAddress,
    String? fullName,
    String? phoneNumber,
    String? streetLine1,
    String? streetLine2,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<TRes>
      get country =>
          CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country
              .stub(_res);
}

class Mutation$UpdateCustomerAddress$updateCustomerAddress$country {
  Mutation$UpdateCustomerAddress$updateCustomerAddress$country({
    required this.name,
    required this.code,
    required this.id,
    required this.languageCode,
    this.$__typename = 'Country',
  });

  factory Mutation$UpdateCustomerAddress$updateCustomerAddress$country.fromJson(
      Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$code = json['code'];
    final l$id = json['id'];
    final l$languageCode = json['languageCode'];
    final l$$__typename = json['__typename'];
    return Mutation$UpdateCustomerAddress$updateCustomerAddress$country(
      name: (l$name as String),
      code: (l$code as String),
      id: (l$id as String),
      languageCode: fromJson$Enum$LanguageCode((l$languageCode as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String code;

  final String id;

  final Enum$LanguageCode languageCode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$languageCode = languageCode;
    _resultData['languageCode'] = toJson$Enum$LanguageCode(l$languageCode);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$code = code;
    final l$id = id;
    final l$languageCode = languageCode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$code,
      l$id,
      l$languageCode,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$UpdateCustomerAddress$updateCustomerAddress$country ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$languageCode = languageCode;
    final lOther$languageCode = other.languageCode;
    if (l$languageCode != lOther$languageCode) {
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

extension UtilityExtension$Mutation$UpdateCustomerAddress$updateCustomerAddress$country
    on Mutation$UpdateCustomerAddress$updateCustomerAddress$country {
  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<
          Mutation$UpdateCustomerAddress$updateCustomerAddress$country>
      get copyWith =>
          CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<
    TRes> {
  factory CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country(
    Mutation$UpdateCustomerAddress$updateCustomerAddress$country instance,
    TRes Function(Mutation$UpdateCustomerAddress$updateCustomerAddress$country)
        then,
  ) = _CopyWithImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$country;

  factory CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$country;

  TRes call({
    String? name,
    String? code,
    String? id,
    Enum$LanguageCode? languageCode,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<
        TRes>
    implements
        CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<
            TRes> {
  _CopyWithImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$country(
    this._instance,
    this._then,
  );

  final Mutation$UpdateCustomerAddress$updateCustomerAddress$country _instance;

  final TRes Function(
      Mutation$UpdateCustomerAddress$updateCustomerAddress$country) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? code = _undefined,
    Object? id = _undefined,
    Object? languageCode = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$UpdateCustomerAddress$updateCustomerAddress$country(
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        id: id == _undefined || id == null ? _instance.id : (id as String),
        languageCode: languageCode == _undefined || languageCode == null
            ? _instance.languageCode
            : (languageCode as Enum$LanguageCode),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<
        TRes>
    implements
        CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<
            TRes> {
  _CopyWithStubImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$country(
      this._res);

  TRes _res;

  call({
    String? name,
    String? code,
    String? id,
    Enum$LanguageCode? languageCode,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Mutation$DeleteCustomerAddress {
  factory Variables$Mutation$DeleteCustomerAddress({required String id}) =>
      Variables$Mutation$DeleteCustomerAddress._({
        r'id': id,
      });

  Variables$Mutation$DeleteCustomerAddress._(this._$data);

  factory Variables$Mutation$DeleteCustomerAddress.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Mutation$DeleteCustomerAddress._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Mutation$DeleteCustomerAddress<
          Variables$Mutation$DeleteCustomerAddress>
      get copyWith => CopyWith$Variables$Mutation$DeleteCustomerAddress(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$DeleteCustomerAddress ||
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

abstract class CopyWith$Variables$Mutation$DeleteCustomerAddress<TRes> {
  factory CopyWith$Variables$Mutation$DeleteCustomerAddress(
    Variables$Mutation$DeleteCustomerAddress instance,
    TRes Function(Variables$Mutation$DeleteCustomerAddress) then,
  ) = _CopyWithImpl$Variables$Mutation$DeleteCustomerAddress;

  factory CopyWith$Variables$Mutation$DeleteCustomerAddress.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$DeleteCustomerAddress;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Mutation$DeleteCustomerAddress<TRes>
    implements CopyWith$Variables$Mutation$DeleteCustomerAddress<TRes> {
  _CopyWithImpl$Variables$Mutation$DeleteCustomerAddress(
    this._instance,
    this._then,
  );

  final Variables$Mutation$DeleteCustomerAddress _instance;

  final TRes Function(Variables$Mutation$DeleteCustomerAddress) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) =>
      _then(Variables$Mutation$DeleteCustomerAddress._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$DeleteCustomerAddress<TRes>
    implements CopyWith$Variables$Mutation$DeleteCustomerAddress<TRes> {
  _CopyWithStubImpl$Variables$Mutation$DeleteCustomerAddress(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Mutation$DeleteCustomerAddress {
  Mutation$DeleteCustomerAddress({
    required this.deleteCustomerAddress,
    this.$__typename = 'Mutation',
  });

  factory Mutation$DeleteCustomerAddress.fromJson(Map<String, dynamic> json) {
    final l$deleteCustomerAddress = json['deleteCustomerAddress'];
    final l$$__typename = json['__typename'];
    return Mutation$DeleteCustomerAddress(
      deleteCustomerAddress:
          Mutation$DeleteCustomerAddress$deleteCustomerAddress.fromJson(
              (l$deleteCustomerAddress as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$DeleteCustomerAddress$deleteCustomerAddress
      deleteCustomerAddress;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deleteCustomerAddress = deleteCustomerAddress;
    _resultData['deleteCustomerAddress'] = l$deleteCustomerAddress.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deleteCustomerAddress = deleteCustomerAddress;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$deleteCustomerAddress,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeleteCustomerAddress ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteCustomerAddress = deleteCustomerAddress;
    final lOther$deleteCustomerAddress = other.deleteCustomerAddress;
    if (l$deleteCustomerAddress != lOther$deleteCustomerAddress) {
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

extension UtilityExtension$Mutation$DeleteCustomerAddress
    on Mutation$DeleteCustomerAddress {
  CopyWith$Mutation$DeleteCustomerAddress<Mutation$DeleteCustomerAddress>
      get copyWith => CopyWith$Mutation$DeleteCustomerAddress(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$DeleteCustomerAddress<TRes> {
  factory CopyWith$Mutation$DeleteCustomerAddress(
    Mutation$DeleteCustomerAddress instance,
    TRes Function(Mutation$DeleteCustomerAddress) then,
  ) = _CopyWithImpl$Mutation$DeleteCustomerAddress;

  factory CopyWith$Mutation$DeleteCustomerAddress.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeleteCustomerAddress;

  TRes call({
    Mutation$DeleteCustomerAddress$deleteCustomerAddress? deleteCustomerAddress,
    String? $__typename,
  });
  CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress<TRes>
      get deleteCustomerAddress;
}

class _CopyWithImpl$Mutation$DeleteCustomerAddress<TRes>
    implements CopyWith$Mutation$DeleteCustomerAddress<TRes> {
  _CopyWithImpl$Mutation$DeleteCustomerAddress(
    this._instance,
    this._then,
  );

  final Mutation$DeleteCustomerAddress _instance;

  final TRes Function(Mutation$DeleteCustomerAddress) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deleteCustomerAddress = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$DeleteCustomerAddress(
        deleteCustomerAddress:
            deleteCustomerAddress == _undefined || deleteCustomerAddress == null
                ? _instance.deleteCustomerAddress
                : (deleteCustomerAddress
                    as Mutation$DeleteCustomerAddress$deleteCustomerAddress),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress<TRes>
      get deleteCustomerAddress {
    final local$deleteCustomerAddress = _instance.deleteCustomerAddress;
    return CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress(
        local$deleteCustomerAddress, (e) => call(deleteCustomerAddress: e));
  }
}

class _CopyWithStubImpl$Mutation$DeleteCustomerAddress<TRes>
    implements CopyWith$Mutation$DeleteCustomerAddress<TRes> {
  _CopyWithStubImpl$Mutation$DeleteCustomerAddress(this._res);

  TRes _res;

  call({
    Mutation$DeleteCustomerAddress$deleteCustomerAddress? deleteCustomerAddress,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress<TRes>
      get deleteCustomerAddress =>
          CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress.stub(
              _res);
}

const documentNodeMutationDeleteCustomerAddress = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'DeleteCustomerAddress'),
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
        name: NameNode(value: 'deleteCustomerAddress'),
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
Mutation$DeleteCustomerAddress _parserFn$Mutation$DeleteCustomerAddress(
        Map<String, dynamic> data) =>
    Mutation$DeleteCustomerAddress.fromJson(data);
typedef OnMutationCompleted$Mutation$DeleteCustomerAddress = FutureOr<void>
    Function(
  Map<String, dynamic>?,
  Mutation$DeleteCustomerAddress?,
);

class Options$Mutation$DeleteCustomerAddress
    extends graphql.MutationOptions<Mutation$DeleteCustomerAddress> {
  Options$Mutation$DeleteCustomerAddress({
    String? operationName,
    required Variables$Mutation$DeleteCustomerAddress variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$DeleteCustomerAddress? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$DeleteCustomerAddress? onCompleted,
    graphql.OnMutationUpdate<Mutation$DeleteCustomerAddress>? update,
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
                        : _parserFn$Mutation$DeleteCustomerAddress(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationDeleteCustomerAddress,
          parserFn: _parserFn$Mutation$DeleteCustomerAddress,
        );

  final OnMutationCompleted$Mutation$DeleteCustomerAddress?
      onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$DeleteCustomerAddress
    extends graphql.WatchQueryOptions<Mutation$DeleteCustomerAddress> {
  WatchOptions$Mutation$DeleteCustomerAddress({
    String? operationName,
    required Variables$Mutation$DeleteCustomerAddress variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$DeleteCustomerAddress? typedOptimisticResult,
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
          document: documentNodeMutationDeleteCustomerAddress,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$DeleteCustomerAddress,
        );
}

extension ClientExtension$Mutation$DeleteCustomerAddress
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$DeleteCustomerAddress>>
      mutate$DeleteCustomerAddress(
              Options$Mutation$DeleteCustomerAddress options) async =>
          await this.mutate(options);
  graphql.ObservableQuery<Mutation$DeleteCustomerAddress>
      watchMutation$DeleteCustomerAddress(
              WatchOptions$Mutation$DeleteCustomerAddress options) =>
          this.watchMutation(options);
}

class Mutation$DeleteCustomerAddress$HookResult {
  Mutation$DeleteCustomerAddress$HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation$Mutation$DeleteCustomerAddress runMutation;

  final graphql.QueryResult<Mutation$DeleteCustomerAddress> result;
}

Mutation$DeleteCustomerAddress$HookResult useMutation$DeleteCustomerAddress(
    [WidgetOptions$Mutation$DeleteCustomerAddress? options]) {
  final result = graphql_flutter
      .useMutation(options ?? WidgetOptions$Mutation$DeleteCustomerAddress());
  return Mutation$DeleteCustomerAddress$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
      variables.toJson(),
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$DeleteCustomerAddress>
    useWatchMutation$DeleteCustomerAddress(
            WatchOptions$Mutation$DeleteCustomerAddress options) =>
        graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$DeleteCustomerAddress
    extends graphql.MutationOptions<Mutation$DeleteCustomerAddress> {
  WidgetOptions$Mutation$DeleteCustomerAddress({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$DeleteCustomerAddress? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$DeleteCustomerAddress? onCompleted,
    graphql.OnMutationUpdate<Mutation$DeleteCustomerAddress>? update,
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
                        : _parserFn$Mutation$DeleteCustomerAddress(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationDeleteCustomerAddress,
          parserFn: _parserFn$Mutation$DeleteCustomerAddress,
        );

  final OnMutationCompleted$Mutation$DeleteCustomerAddress?
      onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

typedef RunMutation$Mutation$DeleteCustomerAddress
    = graphql.MultiSourceResult<Mutation$DeleteCustomerAddress> Function(
  Variables$Mutation$DeleteCustomerAddress, {
  Object? optimisticResult,
  Mutation$DeleteCustomerAddress? typedOptimisticResult,
});
typedef Builder$Mutation$DeleteCustomerAddress = widgets.Widget Function(
  RunMutation$Mutation$DeleteCustomerAddress,
  graphql.QueryResult<Mutation$DeleteCustomerAddress>?,
);

class Mutation$DeleteCustomerAddress$Widget
    extends graphql_flutter.Mutation<Mutation$DeleteCustomerAddress> {
  Mutation$DeleteCustomerAddress$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$DeleteCustomerAddress? options,
    required Builder$Mutation$DeleteCustomerAddress builder,
  }) : super(
          key: key,
          options: options ?? WidgetOptions$Mutation$DeleteCustomerAddress(),
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

class Mutation$DeleteCustomerAddress$deleteCustomerAddress {
  Mutation$DeleteCustomerAddress$deleteCustomerAddress({
    required this.success,
    this.$__typename = 'Success',
  });

  factory Mutation$DeleteCustomerAddress$deleteCustomerAddress.fromJson(
      Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$$__typename = json['__typename'];
    return Mutation$DeleteCustomerAddress$deleteCustomerAddress(
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
    return Object.hashAll([
      l$success,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeleteCustomerAddress$deleteCustomerAddress ||
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

extension UtilityExtension$Mutation$DeleteCustomerAddress$deleteCustomerAddress
    on Mutation$DeleteCustomerAddress$deleteCustomerAddress {
  CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress<
          Mutation$DeleteCustomerAddress$deleteCustomerAddress>
      get copyWith =>
          CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress<
    TRes> {
  factory CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress(
    Mutation$DeleteCustomerAddress$deleteCustomerAddress instance,
    TRes Function(Mutation$DeleteCustomerAddress$deleteCustomerAddress) then,
  ) = _CopyWithImpl$Mutation$DeleteCustomerAddress$deleteCustomerAddress;

  factory CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$DeleteCustomerAddress$deleteCustomerAddress;

  TRes call({
    bool? success,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$DeleteCustomerAddress$deleteCustomerAddress<TRes>
    implements
        CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress<TRes> {
  _CopyWithImpl$Mutation$DeleteCustomerAddress$deleteCustomerAddress(
    this._instance,
    this._then,
  );

  final Mutation$DeleteCustomerAddress$deleteCustomerAddress _instance;

  final TRes Function(Mutation$DeleteCustomerAddress$deleteCustomerAddress)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$DeleteCustomerAddress$deleteCustomerAddress(
        success: success == _undefined || success == null
            ? _instance.success
            : (success as bool),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$DeleteCustomerAddress$deleteCustomerAddress<
        TRes>
    implements
        CopyWith$Mutation$DeleteCustomerAddress$deleteCustomerAddress<TRes> {
  _CopyWithStubImpl$Mutation$DeleteCustomerAddress$deleteCustomerAddress(
      this._res);

  TRes _res;

  call({
    bool? success,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetCurrentUser {
  Query$GetCurrentUser({
    this.me,
    this.$__typename = 'Query',
  });

  factory Query$GetCurrentUser.fromJson(Map<String, dynamic> json) {
    final l$me = json['me'];
    final l$$__typename = json['__typename'];
    return Query$GetCurrentUser(
      me: l$me == null
          ? null
          : Query$GetCurrentUser$me.fromJson((l$me as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GetCurrentUser$me? me;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$me = me;
    _resultData['me'] = l$me?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$me = me;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$me,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetCurrentUser || runtimeType != other.runtimeType) {
      return false;
    }
    final l$me = me;
    final lOther$me = other.me;
    if (l$me != lOther$me) {
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

extension UtilityExtension$Query$GetCurrentUser on Query$GetCurrentUser {
  CopyWith$Query$GetCurrentUser<Query$GetCurrentUser> get copyWith =>
      CopyWith$Query$GetCurrentUser(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetCurrentUser<TRes> {
  factory CopyWith$Query$GetCurrentUser(
    Query$GetCurrentUser instance,
    TRes Function(Query$GetCurrentUser) then,
  ) = _CopyWithImpl$Query$GetCurrentUser;

  factory CopyWith$Query$GetCurrentUser.stub(TRes res) =
      _CopyWithStubImpl$Query$GetCurrentUser;

  TRes call({
    Query$GetCurrentUser$me? me,
    String? $__typename,
  });
  CopyWith$Query$GetCurrentUser$me<TRes> get me;
}

class _CopyWithImpl$Query$GetCurrentUser<TRes>
    implements CopyWith$Query$GetCurrentUser<TRes> {
  _CopyWithImpl$Query$GetCurrentUser(
    this._instance,
    this._then,
  );

  final Query$GetCurrentUser _instance;

  final TRes Function(Query$GetCurrentUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? me = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCurrentUser(
        me: me == _undefined ? _instance.me : (me as Query$GetCurrentUser$me?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetCurrentUser$me<TRes> get me {
    final local$me = _instance.me;
    return local$me == null
        ? CopyWith$Query$GetCurrentUser$me.stub(_then(_instance))
        : CopyWith$Query$GetCurrentUser$me(local$me, (e) => call(me: e));
  }
}

class _CopyWithStubImpl$Query$GetCurrentUser<TRes>
    implements CopyWith$Query$GetCurrentUser<TRes> {
  _CopyWithStubImpl$Query$GetCurrentUser(this._res);

  TRes _res;

  call({
    Query$GetCurrentUser$me? me,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetCurrentUser$me<TRes> get me =>
      CopyWith$Query$GetCurrentUser$me.stub(_res);
}

const documentNodeQueryGetCurrentUser = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetCurrentUser'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'me'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          InlineFragmentNode(
            typeCondition: TypeConditionNode(
                on: NamedTypeNode(
              name: NameNode(value: 'CurrentUser'),
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
                name: NameNode(value: 'identifier'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'channels'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
                  InlineFragmentNode(
                    typeCondition: TypeConditionNode(
                        on: NamedTypeNode(
                      name: NameNode(value: 'CurrentUserChannel'),
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
                        name: NameNode(value: 'permissions'),
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
]);
Query$GetCurrentUser _parserFn$Query$GetCurrentUser(
        Map<String, dynamic> data) =>
    Query$GetCurrentUser.fromJson(data);
typedef OnQueryComplete$Query$GetCurrentUser = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GetCurrentUser?,
);

class Options$Query$GetCurrentUser
    extends graphql.QueryOptions<Query$GetCurrentUser> {
  Options$Query$GetCurrentUser({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetCurrentUser? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetCurrentUser? onComplete,
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
                    data == null ? null : _parserFn$Query$GetCurrentUser(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetCurrentUser,
          parserFn: _parserFn$Query$GetCurrentUser,
        );

  final OnQueryComplete$Query$GetCurrentUser? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetCurrentUser
    extends graphql.WatchQueryOptions<Query$GetCurrentUser> {
  WatchOptions$Query$GetCurrentUser({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetCurrentUser? typedOptimisticResult,
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
          document: documentNodeQueryGetCurrentUser,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetCurrentUser,
        );
}

class FetchMoreOptions$Query$GetCurrentUser extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetCurrentUser(
      {required graphql.UpdateQuery updateQuery})
      : super(
          updateQuery: updateQuery,
          document: documentNodeQueryGetCurrentUser,
        );
}

extension ClientExtension$Query$GetCurrentUser on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetCurrentUser>> query$GetCurrentUser(
          [Options$Query$GetCurrentUser? options]) async =>
      await this.query(options ?? Options$Query$GetCurrentUser());
  graphql.ObservableQuery<Query$GetCurrentUser> watchQuery$GetCurrentUser(
          [WatchOptions$Query$GetCurrentUser? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$GetCurrentUser());
  void writeQuery$GetCurrentUser({
    required Query$GetCurrentUser data,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
            operation:
                graphql.Operation(document: documentNodeQueryGetCurrentUser)),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$GetCurrentUser? readQuery$GetCurrentUser({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryGetCurrentUser)),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetCurrentUser.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetCurrentUser> useQuery$GetCurrentUser(
        [Options$Query$GetCurrentUser? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$GetCurrentUser());
graphql.ObservableQuery<Query$GetCurrentUser> useWatchQuery$GetCurrentUser(
        [WatchOptions$Query$GetCurrentUser? options]) =>
    graphql_flutter
        .useWatchQuery(options ?? WatchOptions$Query$GetCurrentUser());

class Query$GetCurrentUser$Widget
    extends graphql_flutter.Query<Query$GetCurrentUser> {
  Query$GetCurrentUser$Widget({
    widgets.Key? key,
    Options$Query$GetCurrentUser? options,
    required graphql_flutter.QueryBuilder<Query$GetCurrentUser> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$GetCurrentUser(),
          builder: builder,
        );
}

class Query$GetCurrentUser$me {
  Query$GetCurrentUser$me({
    required this.id,
    required this.identifier,
    required this.channels,
    this.$__typename = 'CurrentUser',
  });

  factory Query$GetCurrentUser$me.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$identifier = json['identifier'];
    final l$channels = json['channels'];
    final l$$__typename = json['__typename'];
    return Query$GetCurrentUser$me(
      id: (l$id as String),
      identifier: (l$identifier as String),
      channels: (l$channels as List<dynamic>)
          .map((e) => Query$GetCurrentUser$me$channels.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String identifier;

  final List<Query$GetCurrentUser$me$channels> channels;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$identifier = identifier;
    _resultData['identifier'] = l$identifier;
    final l$channels = channels;
    _resultData['channels'] = l$channels.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$identifier = identifier;
    final l$channels = channels;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$identifier,
      Object.hashAll(l$channels.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetCurrentUser$me || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$GetCurrentUser$me on Query$GetCurrentUser$me {
  CopyWith$Query$GetCurrentUser$me<Query$GetCurrentUser$me> get copyWith =>
      CopyWith$Query$GetCurrentUser$me(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetCurrentUser$me<TRes> {
  factory CopyWith$Query$GetCurrentUser$me(
    Query$GetCurrentUser$me instance,
    TRes Function(Query$GetCurrentUser$me) then,
  ) = _CopyWithImpl$Query$GetCurrentUser$me;

  factory CopyWith$Query$GetCurrentUser$me.stub(TRes res) =
      _CopyWithStubImpl$Query$GetCurrentUser$me;

  TRes call({
    String? id,
    String? identifier,
    List<Query$GetCurrentUser$me$channels>? channels,
    String? $__typename,
  });
  TRes channels(
      Iterable<Query$GetCurrentUser$me$channels> Function(
              Iterable<
                  CopyWith$Query$GetCurrentUser$me$channels<
                      Query$GetCurrentUser$me$channels>>)
          _fn);
}

class _CopyWithImpl$Query$GetCurrentUser$me<TRes>
    implements CopyWith$Query$GetCurrentUser$me<TRes> {
  _CopyWithImpl$Query$GetCurrentUser$me(
    this._instance,
    this._then,
  );

  final Query$GetCurrentUser$me _instance;

  final TRes Function(Query$GetCurrentUser$me) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? identifier = _undefined,
    Object? channels = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCurrentUser$me(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        identifier: identifier == _undefined || identifier == null
            ? _instance.identifier
            : (identifier as String),
        channels: channels == _undefined || channels == null
            ? _instance.channels
            : (channels as List<Query$GetCurrentUser$me$channels>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes channels(
          Iterable<Query$GetCurrentUser$me$channels> Function(
                  Iterable<
                      CopyWith$Query$GetCurrentUser$me$channels<
                          Query$GetCurrentUser$me$channels>>)
              _fn) =>
      call(
          channels: _fn(_instance.channels
              .map((e) => CopyWith$Query$GetCurrentUser$me$channels(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$GetCurrentUser$me<TRes>
    implements CopyWith$Query$GetCurrentUser$me<TRes> {
  _CopyWithStubImpl$Query$GetCurrentUser$me(this._res);

  TRes _res;

  call({
    String? id,
    String? identifier,
    List<Query$GetCurrentUser$me$channels>? channels,
    String? $__typename,
  }) =>
      _res;

  channels(_fn) => _res;
}

class Query$GetCurrentUser$me$channels {
  Query$GetCurrentUser$me$channels({
    required this.id,
    required this.permissions,
    required this.token,
    this.$__typename = 'CurrentUserChannel',
  });

  factory Query$GetCurrentUser$me$channels.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$permissions = json['permissions'];
    final l$token = json['token'];
    final l$$__typename = json['__typename'];
    return Query$GetCurrentUser$me$channels(
      id: (l$id as String),
      permissions: (l$permissions as List<dynamic>)
          .map((e) => fromJson$Enum$Permission((e as String)))
          .toList(),
      token: (l$token as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Enum$Permission> permissions;

  final String token;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$permissions = permissions;
    _resultData['permissions'] =
        l$permissions.map((e) => toJson$Enum$Permission(e)).toList();
    final l$token = token;
    _resultData['token'] = l$token;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$permissions = permissions;
    final l$token = token;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$permissions.map((v) => v)),
      l$token,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetCurrentUser$me$channels ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$permissions = permissions;
    final lOther$permissions = other.permissions;
    if (l$permissions.length != lOther$permissions.length) {
      return false;
    }
    for (int i = 0; i < l$permissions.length; i++) {
      final l$permissions$entry = l$permissions[i];
      final lOther$permissions$entry = lOther$permissions[i];
      if (l$permissions$entry != lOther$permissions$entry) {
        return false;
      }
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

extension UtilityExtension$Query$GetCurrentUser$me$channels
    on Query$GetCurrentUser$me$channels {
  CopyWith$Query$GetCurrentUser$me$channels<Query$GetCurrentUser$me$channels>
      get copyWith => CopyWith$Query$GetCurrentUser$me$channels(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCurrentUser$me$channels<TRes> {
  factory CopyWith$Query$GetCurrentUser$me$channels(
    Query$GetCurrentUser$me$channels instance,
    TRes Function(Query$GetCurrentUser$me$channels) then,
  ) = _CopyWithImpl$Query$GetCurrentUser$me$channels;

  factory CopyWith$Query$GetCurrentUser$me$channels.stub(TRes res) =
      _CopyWithStubImpl$Query$GetCurrentUser$me$channels;

  TRes call({
    String? id,
    List<Enum$Permission>? permissions,
    String? token,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetCurrentUser$me$channels<TRes>
    implements CopyWith$Query$GetCurrentUser$me$channels<TRes> {
  _CopyWithImpl$Query$GetCurrentUser$me$channels(
    this._instance,
    this._then,
  );

  final Query$GetCurrentUser$me$channels _instance;

  final TRes Function(Query$GetCurrentUser$me$channels) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? permissions = _undefined,
    Object? token = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCurrentUser$me$channels(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        permissions: permissions == _undefined || permissions == null
            ? _instance.permissions
            : (permissions as List<Enum$Permission>),
        token: token == _undefined || token == null
            ? _instance.token
            : (token as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetCurrentUser$me$channels<TRes>
    implements CopyWith$Query$GetCurrentUser$me$channels<TRes> {
  _CopyWithStubImpl$Query$GetCurrentUser$me$channels(this._res);

  TRes _res;

  call({
    String? id,
    List<Enum$Permission>? permissions,
    String? token,
    String? $__typename,
  }) =>
      _res;
}

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

class Query$GetActiveCustomer {
  Query$GetActiveCustomer({
    this.activeCustomer,
    this.$__typename = 'Query',
  });

  factory Query$GetActiveCustomer.fromJson(Map<String, dynamic> json) {
    final l$activeCustomer = json['activeCustomer'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer(
      activeCustomer: l$activeCustomer == null
          ? null
          : Query$GetActiveCustomer$activeCustomer.fromJson(
              (l$activeCustomer as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GetActiveCustomer$activeCustomer? activeCustomer;

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
    return Object.hashAll([
      l$activeCustomer,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetActiveCustomer || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$GetActiveCustomer on Query$GetActiveCustomer {
  CopyWith$Query$GetActiveCustomer<Query$GetActiveCustomer> get copyWith =>
      CopyWith$Query$GetActiveCustomer(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetActiveCustomer<TRes> {
  factory CopyWith$Query$GetActiveCustomer(
    Query$GetActiveCustomer instance,
    TRes Function(Query$GetActiveCustomer) then,
  ) = _CopyWithImpl$Query$GetActiveCustomer;

  factory CopyWith$Query$GetActiveCustomer.stub(TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer;

  TRes call({
    Query$GetActiveCustomer$activeCustomer? activeCustomer,
    String? $__typename,
  });
  CopyWith$Query$GetActiveCustomer$activeCustomer<TRes> get activeCustomer;
}

class _CopyWithImpl$Query$GetActiveCustomer<TRes>
    implements CopyWith$Query$GetActiveCustomer<TRes> {
  _CopyWithImpl$Query$GetActiveCustomer(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer _instance;

  final TRes Function(Query$GetActiveCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? activeCustomer = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer(
        activeCustomer: activeCustomer == _undefined
            ? _instance.activeCustomer
            : (activeCustomer as Query$GetActiveCustomer$activeCustomer?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetActiveCustomer$activeCustomer<TRes> get activeCustomer {
    final local$activeCustomer = _instance.activeCustomer;
    return local$activeCustomer == null
        ? CopyWith$Query$GetActiveCustomer$activeCustomer.stub(_then(_instance))
        : CopyWith$Query$GetActiveCustomer$activeCustomer(
            local$activeCustomer, (e) => call(activeCustomer: e));
  }
}

class _CopyWithStubImpl$Query$GetActiveCustomer<TRes>
    implements CopyWith$Query$GetActiveCustomer<TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer(this._res);

  TRes _res;

  call({
    Query$GetActiveCustomer$activeCustomer? activeCustomer,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer<TRes> get activeCustomer =>
      CopyWith$Query$GetActiveCustomer$activeCustomer.stub(_res);
}

const documentNodeQueryGetActiveCustomer = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetActiveCustomer'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'activeCustomer'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
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
                name: NameNode(value: 'emailAddress'),
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
                name: NameNode(value: 'phoneNumber'),
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
                    name: NameNode(value: 'loyaltyPointsAvailable'),
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
                name: NameNode(value: 'addresses'),
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
                    name: NameNode(value: 'postalCode'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'streetLine1'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'streetLine2'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'fullName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'country'),
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
                        name: NameNode(value: 'code'),
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
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ]),
                  ),
                  FieldNode(
                    name: NameNode(value: 'phoneNumber'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'company'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'city'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'streetLine2'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'streetLine1'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'fullName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'postalCode'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'defaultShippingAddress'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'defaultBillingAddress'),
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
                name: NameNode(value: 'orders'),
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
                        name: NameNode(value: 'currencyCode'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'orderPlacedAt'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
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
                            name: NameNode(value: 'quantity'),
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
                            name: NameNode(value: '__typename'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                        ]),
                      ),
                      FieldNode(
                        name: NameNode(value: 'active'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
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
                        name: NameNode(value: 'state'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'customer'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
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
                        name: NameNode(value: 'shippingAddress'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                            name: NameNode(value: 'country'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'city'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'phoneNumber'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'streetLine1'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'streetLine2'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'postalCode'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'fullName'),
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
                        name: NameNode(value: 'surcharges'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
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
                        name: NameNode(value: 'payments'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                            name: NameNode(value: 'state'),
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
                            name: NameNode(value: 'method'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'amount'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'transactionId'),
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
                        name: NameNode(value: 'totalQuantity'),
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
                        name: NameNode(value: 'billingAddress'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                            name: NameNode(value: 'postalCode'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'streetLine2'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'fullName'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'city'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'phoneNumber'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'streetLine1'),
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
                            name: NameNode(value: 'loyaltyPointsUsed'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null,
                          ),
                          FieldNode(
                            name: NameNode(value: 'loyaltyPointsEarned'),
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
Query$GetActiveCustomer _parserFn$Query$GetActiveCustomer(
        Map<String, dynamic> data) =>
    Query$GetActiveCustomer.fromJson(data);
typedef OnQueryComplete$Query$GetActiveCustomer = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GetActiveCustomer?,
);

class Options$Query$GetActiveCustomer
    extends graphql.QueryOptions<Query$GetActiveCustomer> {
  Options$Query$GetActiveCustomer({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetActiveCustomer? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetActiveCustomer? onComplete,
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
                        : _parserFn$Query$GetActiveCustomer(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetActiveCustomer,
          parserFn: _parserFn$Query$GetActiveCustomer,
        );

  final OnQueryComplete$Query$GetActiveCustomer? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetActiveCustomer
    extends graphql.WatchQueryOptions<Query$GetActiveCustomer> {
  WatchOptions$Query$GetActiveCustomer({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetActiveCustomer? typedOptimisticResult,
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
          document: documentNodeQueryGetActiveCustomer,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetActiveCustomer,
        );
}

class FetchMoreOptions$Query$GetActiveCustomer
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetActiveCustomer(
      {required graphql.UpdateQuery updateQuery})
      : super(
          updateQuery: updateQuery,
          document: documentNodeQueryGetActiveCustomer,
        );
}

extension ClientExtension$Query$GetActiveCustomer on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetActiveCustomer>> query$GetActiveCustomer(
          [Options$Query$GetActiveCustomer? options]) async =>
      await this.query(options ?? Options$Query$GetActiveCustomer());
  graphql.ObservableQuery<Query$GetActiveCustomer> watchQuery$GetActiveCustomer(
          [WatchOptions$Query$GetActiveCustomer? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$GetActiveCustomer());
  void writeQuery$GetActiveCustomer({
    required Query$GetActiveCustomer data,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
            operation: graphql.Operation(
                document: documentNodeQueryGetActiveCustomer)),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$GetActiveCustomer? readQuery$GetActiveCustomer(
      {bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryGetActiveCustomer)),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetActiveCustomer.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetActiveCustomer>
    useQuery$GetActiveCustomer([Options$Query$GetActiveCustomer? options]) =>
        graphql_flutter.useQuery(options ?? Options$Query$GetActiveCustomer());
graphql.ObservableQuery<Query$GetActiveCustomer>
    useWatchQuery$GetActiveCustomer(
            [WatchOptions$Query$GetActiveCustomer? options]) =>
        graphql_flutter
            .useWatchQuery(options ?? WatchOptions$Query$GetActiveCustomer());

class Query$GetActiveCustomer$Widget
    extends graphql_flutter.Query<Query$GetActiveCustomer> {
  Query$GetActiveCustomer$Widget({
    widgets.Key? key,
    Options$Query$GetActiveCustomer? options,
    required graphql_flutter.QueryBuilder<Query$GetActiveCustomer> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$GetActiveCustomer(),
          builder: builder,
        );
}

class Query$GetActiveCustomer$activeCustomer {
  Query$GetActiveCustomer$activeCustomer({
    this.$__typename = 'Customer',
    required this.id,
    required this.emailAddress,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.customFields,
    this.addresses,
    required this.orders,
  });

  factory Query$GetActiveCustomer$activeCustomer.fromJson(
      Map<String, dynamic> json) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$emailAddress = json['emailAddress'];
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$phoneNumber = json['phoneNumber'];
    final l$customFields = json['customFields'];
    final l$addresses = json['addresses'];
    final l$orders = json['orders'];
    return Query$GetActiveCustomer$activeCustomer(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      emailAddress: (l$emailAddress as String),
      firstName: (l$firstName as String),
      lastName: (l$lastName as String),
      phoneNumber: (l$phoneNumber as String?),
      customFields: l$customFields == null
          ? null
          : Query$GetActiveCustomer$activeCustomer$customFields.fromJson(
              (l$customFields as Map<String, dynamic>)),
      addresses: (l$addresses as List<dynamic>?)
          ?.map((e) =>
              Query$GetActiveCustomer$activeCustomer$addresses.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      orders: Query$GetActiveCustomer$activeCustomer$orders.fromJson(
          (l$orders as Map<String, dynamic>)),
    );
  }

  final String $__typename;

  final String id;

  final String emailAddress;

  final String firstName;

  final String lastName;

  final String? phoneNumber;

  final Query$GetActiveCustomer$activeCustomer$customFields? customFields;

  final List<Query$GetActiveCustomer$activeCustomer$addresses>? addresses;

  final Query$GetActiveCustomer$activeCustomer$orders orders;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$emailAddress = emailAddress;
    _resultData['emailAddress'] = l$emailAddress;
    final l$firstName = firstName;
    _resultData['firstName'] = l$firstName;
    final l$lastName = lastName;
    _resultData['lastName'] = l$lastName;
    final l$phoneNumber = phoneNumber;
    _resultData['phoneNumber'] = l$phoneNumber;
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
    final l$addresses = addresses;
    _resultData['addresses'] = l$addresses?.map((e) => e.toJson()).toList();
    final l$orders = orders;
    _resultData['orders'] = l$orders.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$emailAddress = emailAddress;
    final l$firstName = firstName;
    final l$lastName = lastName;
    final l$phoneNumber = phoneNumber;
    final l$customFields = customFields;
    final l$addresses = addresses;
    final l$orders = orders;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$emailAddress,
      l$firstName,
      l$lastName,
      l$phoneNumber,
      l$customFields,
      l$addresses == null ? null : Object.hashAll(l$addresses.map((v) => v)),
      l$orders,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetActiveCustomer$activeCustomer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$emailAddress = emailAddress;
    final lOther$emailAddress = other.emailAddress;
    if (l$emailAddress != lOther$emailAddress) {
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
    final l$phoneNumber = phoneNumber;
    final lOther$phoneNumber = other.phoneNumber;
    if (l$phoneNumber != lOther$phoneNumber) {
      return false;
    }
    final l$customFields = customFields;
    final lOther$customFields = other.customFields;
    if (l$customFields != lOther$customFields) {
      return false;
    }
    final l$addresses = addresses;
    final lOther$addresses = other.addresses;
    if (l$addresses != null && lOther$addresses != null) {
      if (l$addresses.length != lOther$addresses.length) {
        return false;
      }
      for (int i = 0; i < l$addresses.length; i++) {
        final l$addresses$entry = l$addresses[i];
        final lOther$addresses$entry = lOther$addresses[i];
        if (l$addresses$entry != lOther$addresses$entry) {
          return false;
        }
      }
    } else if (l$addresses != lOther$addresses) {
      return false;
    }
    final l$orders = orders;
    final lOther$orders = other.orders;
    if (l$orders != lOther$orders) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer
    on Query$GetActiveCustomer$activeCustomer {
  CopyWith$Query$GetActiveCustomer$activeCustomer<
          Query$GetActiveCustomer$activeCustomer>
      get copyWith => CopyWith$Query$GetActiveCustomer$activeCustomer(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer<TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer(
    Query$GetActiveCustomer$activeCustomer instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer) then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer.stub(TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer;

  TRes call({
    String? $__typename,
    String? id,
    String? emailAddress,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Query$GetActiveCustomer$activeCustomer$customFields? customFields,
    List<Query$GetActiveCustomer$activeCustomer$addresses>? addresses,
    Query$GetActiveCustomer$activeCustomer$orders? orders,
  });
  CopyWith$Query$GetActiveCustomer$activeCustomer$customFields<TRes>
      get customFields;
  TRes addresses(
      Iterable<Query$GetActiveCustomer$activeCustomer$addresses>? Function(
              Iterable<
                  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses<
                      Query$GetActiveCustomer$activeCustomer$addresses>>?)
          _fn);
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders<TRes> get orders;
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer<TRes>
    implements CopyWith$Query$GetActiveCustomer$activeCustomer<TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer _instance;

  final TRes Function(Query$GetActiveCustomer$activeCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? emailAddress = _undefined,
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? phoneNumber = _undefined,
    Object? customFields = _undefined,
    Object? addresses = _undefined,
    Object? orders = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer(
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
        id: id == _undefined || id == null ? _instance.id : (id as String),
        emailAddress: emailAddress == _undefined || emailAddress == null
            ? _instance.emailAddress
            : (emailAddress as String),
        firstName: firstName == _undefined || firstName == null
            ? _instance.firstName
            : (firstName as String),
        lastName: lastName == _undefined || lastName == null
            ? _instance.lastName
            : (lastName as String),
        phoneNumber: phoneNumber == _undefined
            ? _instance.phoneNumber
            : (phoneNumber as String?),
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Query$GetActiveCustomer$activeCustomer$customFields?),
        addresses: addresses == _undefined
            ? _instance.addresses
            : (addresses
                as List<Query$GetActiveCustomer$activeCustomer$addresses>?),
        orders: orders == _undefined || orders == null
            ? _instance.orders
            : (orders as Query$GetActiveCustomer$activeCustomer$orders),
      ));

  CopyWith$Query$GetActiveCustomer$activeCustomer$customFields<TRes>
      get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Query$GetActiveCustomer$activeCustomer$customFields.stub(
            _then(_instance))
        : CopyWith$Query$GetActiveCustomer$activeCustomer$customFields(
            local$customFields, (e) => call(customFields: e));
  }

  TRes addresses(
          Iterable<Query$GetActiveCustomer$activeCustomer$addresses>? Function(
                  Iterable<
                      CopyWith$Query$GetActiveCustomer$activeCustomer$addresses<
                          Query$GetActiveCustomer$activeCustomer$addresses>>?)
              _fn) =>
      call(
          addresses: _fn(_instance.addresses?.map(
              (e) => CopyWith$Query$GetActiveCustomer$activeCustomer$addresses(
                    e,
                    (i) => i,
                  )))?.toList());

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders<TRes> get orders {
    final local$orders = _instance.orders;
    return CopyWith$Query$GetActiveCustomer$activeCustomer$orders(
        local$orders, (e) => call(orders: e));
  }
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer<TRes>
    implements CopyWith$Query$GetActiveCustomer$activeCustomer<TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer(this._res);

  TRes _res;

  call({
    String? $__typename,
    String? id,
    String? emailAddress,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Query$GetActiveCustomer$activeCustomer$customFields? customFields,
    List<Query$GetActiveCustomer$activeCustomer$addresses>? addresses,
    Query$GetActiveCustomer$activeCustomer$orders? orders,
  }) =>
      _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer$customFields<TRes>
      get customFields =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$customFields.stub(
              _res);

  addresses(_fn) => _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders<TRes> get orders =>
      CopyWith$Query$GetActiveCustomer$activeCustomer$orders.stub(_res);
}

class Query$GetActiveCustomer$activeCustomer$customFields {
  Query$GetActiveCustomer$activeCustomer$customFields({
    this.loyaltyPointsAvailable,
    this.$__typename = 'CustomerCustomFields',
  });

  factory Query$GetActiveCustomer$activeCustomer$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$loyaltyPointsAvailable = json['loyaltyPointsAvailable'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$customFields(
      loyaltyPointsAvailable: (l$loyaltyPointsAvailable as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? loyaltyPointsAvailable;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$loyaltyPointsAvailable = loyaltyPointsAvailable;
    _resultData['loyaltyPointsAvailable'] = l$loyaltyPointsAvailable;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$loyaltyPointsAvailable = loyaltyPointsAvailable;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$loyaltyPointsAvailable,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetActiveCustomer$activeCustomer$customFields ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$loyaltyPointsAvailable = loyaltyPointsAvailable;
    final lOther$loyaltyPointsAvailable = other.loyaltyPointsAvailable;
    if (l$loyaltyPointsAvailable != lOther$loyaltyPointsAvailable) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$customFields
    on Query$GetActiveCustomer$activeCustomer$customFields {
  CopyWith$Query$GetActiveCustomer$activeCustomer$customFields<
          Query$GetActiveCustomer$activeCustomer$customFields>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$customFields<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$customFields(
    Query$GetActiveCustomer$activeCustomer$customFields instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$customFields) then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$customFields;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$customFields.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$customFields;

  TRes call({
    int? loyaltyPointsAvailable,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$customFields<TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$customFields<TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$customFields(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$customFields _instance;

  final TRes Function(Query$GetActiveCustomer$activeCustomer$customFields)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? loyaltyPointsAvailable = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$customFields(
        loyaltyPointsAvailable: loyaltyPointsAvailable == _undefined
            ? _instance.loyaltyPointsAvailable
            : (loyaltyPointsAvailable as int?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$customFields<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$customFields<TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$customFields(
      this._res);

  TRes _res;

  call({
    int? loyaltyPointsAvailable,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$addresses {
  Query$GetActiveCustomer$activeCustomer$addresses({
    required this.id,
    this.postalCode,
    required this.streetLine1,
    this.streetLine2,
    this.fullName,
    required this.country,
    this.phoneNumber,
    this.company,
    this.city,
    this.defaultShippingAddress,
    this.defaultBillingAddress,
    this.$__typename = 'Address',
  });

  factory Query$GetActiveCustomer$activeCustomer$addresses.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$postalCode = json['postalCode'];
    final l$streetLine1 = json['streetLine1'];
    final l$streetLine2 = json['streetLine2'];
    final l$fullName = json['fullName'];
    final l$country = json['country'];
    final l$phoneNumber = json['phoneNumber'];
    final l$company = json['company'];
    final l$city = json['city'];
    final l$defaultShippingAddress = json['defaultShippingAddress'];
    final l$defaultBillingAddress = json['defaultBillingAddress'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$addresses(
      id: (l$id as String),
      postalCode: (l$postalCode as String?),
      streetLine1: (l$streetLine1 as String),
      streetLine2: (l$streetLine2 as String?),
      fullName: (l$fullName as String?),
      country:
          Query$GetActiveCustomer$activeCustomer$addresses$country.fromJson(
              (l$country as Map<String, dynamic>)),
      phoneNumber: (l$phoneNumber as String?),
      company: (l$company as String?),
      city: (l$city as String?),
      defaultShippingAddress: (l$defaultShippingAddress as bool?),
      defaultBillingAddress: (l$defaultBillingAddress as bool?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? postalCode;

  final String streetLine1;

  final String? streetLine2;

  final String? fullName;

  final Query$GetActiveCustomer$activeCustomer$addresses$country country;

  final String? phoneNumber;

  final String? company;

  final String? city;

  final bool? defaultShippingAddress;

  final bool? defaultBillingAddress;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$postalCode = postalCode;
    _resultData['postalCode'] = l$postalCode;
    final l$streetLine1 = streetLine1;
    _resultData['streetLine1'] = l$streetLine1;
    final l$streetLine2 = streetLine2;
    _resultData['streetLine2'] = l$streetLine2;
    final l$fullName = fullName;
    _resultData['fullName'] = l$fullName;
    final l$country = country;
    _resultData['country'] = l$country.toJson();
    final l$phoneNumber = phoneNumber;
    _resultData['phoneNumber'] = l$phoneNumber;
    final l$company = company;
    _resultData['company'] = l$company;
    final l$city = city;
    _resultData['city'] = l$city;
    final l$defaultShippingAddress = defaultShippingAddress;
    _resultData['defaultShippingAddress'] = l$defaultShippingAddress;
    final l$defaultBillingAddress = defaultBillingAddress;
    _resultData['defaultBillingAddress'] = l$defaultBillingAddress;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$postalCode = postalCode;
    final l$streetLine1 = streetLine1;
    final l$streetLine2 = streetLine2;
    final l$fullName = fullName;
    final l$country = country;
    final l$phoneNumber = phoneNumber;
    final l$company = company;
    final l$city = city;
    final l$defaultShippingAddress = defaultShippingAddress;
    final l$defaultBillingAddress = defaultBillingAddress;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$postalCode,
      l$streetLine1,
      l$streetLine2,
      l$fullName,
      l$country,
      l$phoneNumber,
      l$company,
      l$city,
      l$defaultShippingAddress,
      l$defaultBillingAddress,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetActiveCustomer$activeCustomer$addresses ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$postalCode = postalCode;
    final lOther$postalCode = other.postalCode;
    if (l$postalCode != lOther$postalCode) {
      return false;
    }
    final l$streetLine1 = streetLine1;
    final lOther$streetLine1 = other.streetLine1;
    if (l$streetLine1 != lOther$streetLine1) {
      return false;
    }
    final l$streetLine2 = streetLine2;
    final lOther$streetLine2 = other.streetLine2;
    if (l$streetLine2 != lOther$streetLine2) {
      return false;
    }
    final l$fullName = fullName;
    final lOther$fullName = other.fullName;
    if (l$fullName != lOther$fullName) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (l$country != lOther$country) {
      return false;
    }
    final l$phoneNumber = phoneNumber;
    final lOther$phoneNumber = other.phoneNumber;
    if (l$phoneNumber != lOther$phoneNumber) {
      return false;
    }
    final l$company = company;
    final lOther$company = other.company;
    if (l$company != lOther$company) {
      return false;
    }
    final l$city = city;
    final lOther$city = other.city;
    if (l$city != lOther$city) {
      return false;
    }
    final l$defaultShippingAddress = defaultShippingAddress;
    final lOther$defaultShippingAddress = other.defaultShippingAddress;
    if (l$defaultShippingAddress != lOther$defaultShippingAddress) {
      return false;
    }
    final l$defaultBillingAddress = defaultBillingAddress;
    final lOther$defaultBillingAddress = other.defaultBillingAddress;
    if (l$defaultBillingAddress != lOther$defaultBillingAddress) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$addresses
    on Query$GetActiveCustomer$activeCustomer$addresses {
  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses<
          Query$GetActiveCustomer$activeCustomer$addresses>
      get copyWith => CopyWith$Query$GetActiveCustomer$activeCustomer$addresses(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$addresses<TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$addresses(
    Query$GetActiveCustomer$activeCustomer$addresses instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$addresses) then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$addresses;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$addresses.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$addresses;

  TRes call({
    String? id,
    String? postalCode,
    String? streetLine1,
    String? streetLine2,
    String? fullName,
    Query$GetActiveCustomer$activeCustomer$addresses$country? country,
    String? phoneNumber,
    String? company,
    String? city,
    bool? defaultShippingAddress,
    bool? defaultBillingAddress,
    String? $__typename,
  });
  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country<TRes>
      get country;
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$addresses<TRes>
    implements CopyWith$Query$GetActiveCustomer$activeCustomer$addresses<TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$addresses(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$addresses _instance;

  final TRes Function(Query$GetActiveCustomer$activeCustomer$addresses) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? postalCode = _undefined,
    Object? streetLine1 = _undefined,
    Object? streetLine2 = _undefined,
    Object? fullName = _undefined,
    Object? country = _undefined,
    Object? phoneNumber = _undefined,
    Object? company = _undefined,
    Object? city = _undefined,
    Object? defaultShippingAddress = _undefined,
    Object? defaultBillingAddress = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$addresses(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        postalCode: postalCode == _undefined
            ? _instance.postalCode
            : (postalCode as String?),
        streetLine1: streetLine1 == _undefined || streetLine1 == null
            ? _instance.streetLine1
            : (streetLine1 as String),
        streetLine2: streetLine2 == _undefined
            ? _instance.streetLine2
            : (streetLine2 as String?),
        fullName:
            fullName == _undefined ? _instance.fullName : (fullName as String?),
        country: country == _undefined || country == null
            ? _instance.country
            : (country
                as Query$GetActiveCustomer$activeCustomer$addresses$country),
        phoneNumber: phoneNumber == _undefined
            ? _instance.phoneNumber
            : (phoneNumber as String?),
        company:
            company == _undefined ? _instance.company : (company as String?),
        city: city == _undefined ? _instance.city : (city as String?),
        defaultShippingAddress: defaultShippingAddress == _undefined
            ? _instance.defaultShippingAddress
            : (defaultShippingAddress as bool?),
        defaultBillingAddress: defaultBillingAddress == _undefined
            ? _instance.defaultBillingAddress
            : (defaultBillingAddress as bool?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country<TRes>
      get country {
    final local$country = _instance.country;
    return CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country(
        local$country, (e) => call(country: e));
  }
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$addresses<TRes>
    implements CopyWith$Query$GetActiveCustomer$activeCustomer$addresses<TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$addresses(this._res);

  TRes _res;

  call({
    String? id,
    String? postalCode,
    String? streetLine1,
    String? streetLine2,
    String? fullName,
    Query$GetActiveCustomer$activeCustomer$addresses$country? country,
    String? phoneNumber,
    String? company,
    String? city,
    bool? defaultShippingAddress,
    bool? defaultBillingAddress,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country<TRes>
      get country =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country
              .stub(_res);
}

class Query$GetActiveCustomer$activeCustomer$addresses$country {
  Query$GetActiveCustomer$activeCustomer$addresses$country({
    required this.id,
    required this.name,
    required this.code,
    required this.languageCode,
    this.$__typename = 'Country',
  });

  factory Query$GetActiveCustomer$activeCustomer$addresses$country.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$code = json['code'];
    final l$languageCode = json['languageCode'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$addresses$country(
      id: (l$id as String),
      name: (l$name as String),
      code: (l$code as String),
      languageCode: fromJson$Enum$LanguageCode((l$languageCode as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String code;

  final Enum$LanguageCode languageCode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$languageCode = languageCode;
    _resultData['languageCode'] = toJson$Enum$LanguageCode(l$languageCode);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$code = code;
    final l$languageCode = languageCode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$code,
      l$languageCode,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetActiveCustomer$activeCustomer$addresses$country ||
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
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$languageCode = languageCode;
    final lOther$languageCode = other.languageCode;
    if (l$languageCode != lOther$languageCode) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$addresses$country
    on Query$GetActiveCustomer$activeCustomer$addresses$country {
  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country<
          Query$GetActiveCustomer$activeCustomer$addresses$country>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country(
    Query$GetActiveCustomer$activeCustomer$addresses$country instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$addresses$country)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$addresses$country;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$addresses$country;

  TRes call({
    String? id,
    String? name,
    String? code,
    Enum$LanguageCode? languageCode,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$addresses$country<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$addresses$country(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$addresses$country _instance;

  final TRes Function(Query$GetActiveCustomer$activeCustomer$addresses$country)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? code = _undefined,
    Object? languageCode = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$addresses$country(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        languageCode: languageCode == _undefined || languageCode == null
            ? _instance.languageCode
            : (languageCode as Enum$LanguageCode),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$addresses$country<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$addresses$country(
      this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? code,
    Enum$LanguageCode? languageCode,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$orders {
  Query$GetActiveCustomer$activeCustomer$orders({
    required this.totalItems,
    required this.items,
    this.$__typename = 'OrderList',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders.fromJson(
      Map<String, dynamic> json) {
    final l$totalItems = json['totalItems'];
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders(
      totalItems: (l$totalItems as int),
      items: (l$items as List<dynamic>)
          .map((e) =>
              Query$GetActiveCustomer$activeCustomer$orders$items.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int totalItems;

  final List<Query$GetActiveCustomer$activeCustomer$orders$items> items;

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
    if (other is! Query$GetActiveCustomer$activeCustomer$orders ||
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders
    on Query$GetActiveCustomer$activeCustomer$orders {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders<
          Query$GetActiveCustomer$activeCustomer$orders>
      get copyWith => CopyWith$Query$GetActiveCustomer$activeCustomer$orders(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders<TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders(
    Query$GetActiveCustomer$activeCustomer$orders instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$orders) then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders;

  TRes call({
    int? totalItems,
    List<Query$GetActiveCustomer$activeCustomer$orders$items>? items,
    String? $__typename,
  });
  TRes items(
      Iterable<Query$GetActiveCustomer$activeCustomer$orders$items> Function(
              Iterable<
                  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items<
                      Query$GetActiveCustomer$activeCustomer$orders$items>>)
          _fn);
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders<TRes>
    implements CopyWith$Query$GetActiveCustomer$activeCustomer$orders<TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders _instance;

  final TRes Function(Query$GetActiveCustomer$activeCustomer$orders) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? totalItems = _undefined,
    Object? items = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$orders(
        totalItems: totalItems == _undefined || totalItems == null
            ? _instance.totalItems
            : (totalItems as int),
        items: items == _undefined || items == null
            ? _instance.items
            : (items
                as List<Query$GetActiveCustomer$activeCustomer$orders$items>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes items(
          Iterable<Query$GetActiveCustomer$activeCustomer$orders$items> Function(
                  Iterable<
                      CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items<
                          Query$GetActiveCustomer$activeCustomer$orders$items>>)
              _fn) =>
      call(
          items: _fn(_instance.items.map((e) =>
              CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders<TRes>
    implements CopyWith$Query$GetActiveCustomer$activeCustomer$orders<TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders(this._res);

  TRes _res;

  call({
    int? totalItems,
    List<Query$GetActiveCustomer$activeCustomer$orders$items>? items,
    String? $__typename,
  }) =>
      _res;

  items(_fn) => _res;
}

class Query$GetActiveCustomer$activeCustomer$orders$items {
  Query$GetActiveCustomer$activeCustomer$orders$items({
    required this.id,
    required this.currencyCode,
    this.orderPlacedAt,
    required this.lines,
    required this.active,
    required this.discounts,
    required this.code,
    required this.state,
    this.customer,
    this.shippingAddress,
    required this.surcharges,
    required this.couponCodes,
    this.payments,
    required this.totalQuantity,
    required this.totalWithTax,
    this.billingAddress,
    this.customFields,
    this.$__typename = 'Order',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$currencyCode = json['currencyCode'];
    final l$orderPlacedAt = json['orderPlacedAt'];
    final l$lines = json['lines'];
    final l$active = json['active'];
    final l$discounts = json['discounts'];
    final l$code = json['code'];
    final l$state = json['state'];
    final l$customer = json['customer'];
    final l$shippingAddress = json['shippingAddress'];
    final l$surcharges = json['surcharges'];
    final l$couponCodes = json['couponCodes'];
    final l$payments = json['payments'];
    final l$totalQuantity = json['totalQuantity'];
    final l$totalWithTax = json['totalWithTax'];
    final l$billingAddress = json['billingAddress'];
    final l$customFields = json['customFields'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items(
      id: (l$id as String),
      currencyCode: fromJson$Enum$CurrencyCode((l$currencyCode as String)),
      orderPlacedAt: l$orderPlacedAt == null
          ? null
          : DateTime.parse((l$orderPlacedAt as String)),
      lines: (l$lines as List<dynamic>)
          .map((e) => Query$GetActiveCustomer$activeCustomer$orders$items$lines
              .fromJson((e as Map<String, dynamic>)))
          .toList(),
      active: (l$active as bool),
      discounts: (l$discounts as List<dynamic>)
          .map((e) =>
              Query$GetActiveCustomer$activeCustomer$orders$items$discounts
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      code: (l$code as String),
      state: (l$state as String),
      customer: l$customer == null
          ? null
          : Query$GetActiveCustomer$activeCustomer$orders$items$customer
              .fromJson((l$customer as Map<String, dynamic>)),
      shippingAddress: l$shippingAddress == null
          ? null
          : Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress
              .fromJson((l$shippingAddress as Map<String, dynamic>)),
      surcharges: (l$surcharges as List<dynamic>)
          .map((e) =>
              Query$GetActiveCustomer$activeCustomer$orders$items$surcharges
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      couponCodes:
          (l$couponCodes as List<dynamic>).map((e) => (e as String)).toList(),
      payments: (l$payments as List<dynamic>?)
          ?.map((e) =>
              Query$GetActiveCustomer$activeCustomer$orders$items$payments
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      totalQuantity: (l$totalQuantity as int),
      totalWithTax: (l$totalWithTax as num).toDouble(),
      billingAddress: l$billingAddress == null
          ? null
          : Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress
              .fromJson((l$billingAddress as Map<String, dynamic>)),
      customFields: l$customFields == null
          ? null
          : Query$GetActiveCustomer$activeCustomer$orders$items$customFields
              .fromJson((l$customFields as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$CurrencyCode currencyCode;

  final DateTime? orderPlacedAt;

  final List<Query$GetActiveCustomer$activeCustomer$orders$items$lines> lines;

  final bool active;

  final List<Query$GetActiveCustomer$activeCustomer$orders$items$discounts>
      discounts;

  final String code;

  final String state;

  final Query$GetActiveCustomer$activeCustomer$orders$items$customer? customer;

  final Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress?
      shippingAddress;

  final List<Query$GetActiveCustomer$activeCustomer$orders$items$surcharges>
      surcharges;

  final List<String> couponCodes;

  final List<Query$GetActiveCustomer$activeCustomer$orders$items$payments>?
      payments;

  final int totalQuantity;

  final double totalWithTax;

  final Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress?
      billingAddress;

  final Query$GetActiveCustomer$activeCustomer$orders$items$customFields?
      customFields;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$currencyCode = currencyCode;
    _resultData['currencyCode'] = toJson$Enum$CurrencyCode(l$currencyCode);
    final l$orderPlacedAt = orderPlacedAt;
    _resultData['orderPlacedAt'] = l$orderPlacedAt?.toIso8601String();
    final l$lines = lines;
    _resultData['lines'] = l$lines.map((e) => e.toJson()).toList();
    final l$active = active;
    _resultData['active'] = l$active;
    final l$discounts = discounts;
    _resultData['discounts'] = l$discounts.map((e) => e.toJson()).toList();
    final l$code = code;
    _resultData['code'] = l$code;
    final l$state = state;
    _resultData['state'] = l$state;
    final l$customer = customer;
    _resultData['customer'] = l$customer?.toJson();
    final l$shippingAddress = shippingAddress;
    _resultData['shippingAddress'] = l$shippingAddress?.toJson();
    final l$surcharges = surcharges;
    _resultData['surcharges'] = l$surcharges.map((e) => e.toJson()).toList();
    final l$couponCodes = couponCodes;
    _resultData['couponCodes'] = l$couponCodes.map((e) => e).toList();
    final l$payments = payments;
    _resultData['payments'] = l$payments?.map((e) => e.toJson()).toList();
    final l$totalQuantity = totalQuantity;
    _resultData['totalQuantity'] = l$totalQuantity;
    final l$totalWithTax = totalWithTax;
    _resultData['totalWithTax'] = l$totalWithTax;
    final l$billingAddress = billingAddress;
    _resultData['billingAddress'] = l$billingAddress?.toJson();
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$currencyCode = currencyCode;
    final l$orderPlacedAt = orderPlacedAt;
    final l$lines = lines;
    final l$active = active;
    final l$discounts = discounts;
    final l$code = code;
    final l$state = state;
    final l$customer = customer;
    final l$shippingAddress = shippingAddress;
    final l$surcharges = surcharges;
    final l$couponCodes = couponCodes;
    final l$payments = payments;
    final l$totalQuantity = totalQuantity;
    final l$totalWithTax = totalWithTax;
    final l$billingAddress = billingAddress;
    final l$customFields = customFields;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$currencyCode,
      l$orderPlacedAt,
      Object.hashAll(l$lines.map((v) => v)),
      l$active,
      Object.hashAll(l$discounts.map((v) => v)),
      l$code,
      l$state,
      l$customer,
      l$shippingAddress,
      Object.hashAll(l$surcharges.map((v) => v)),
      Object.hashAll(l$couponCodes.map((v) => v)),
      l$payments == null ? null : Object.hashAll(l$payments.map((v) => v)),
      l$totalQuantity,
      l$totalWithTax,
      l$billingAddress,
      l$customFields,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetActiveCustomer$activeCustomer$orders$items ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$currencyCode = currencyCode;
    final lOther$currencyCode = other.currencyCode;
    if (l$currencyCode != lOther$currencyCode) {
      return false;
    }
    final l$orderPlacedAt = orderPlacedAt;
    final lOther$orderPlacedAt = other.orderPlacedAt;
    if (l$orderPlacedAt != lOther$orderPlacedAt) {
      return false;
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
    final l$active = active;
    final lOther$active = other.active;
    if (l$active != lOther$active) {
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
    final l$customer = customer;
    final lOther$customer = other.customer;
    if (l$customer != lOther$customer) {
      return false;
    }
    final l$shippingAddress = shippingAddress;
    final lOther$shippingAddress = other.shippingAddress;
    if (l$shippingAddress != lOther$shippingAddress) {
      return false;
    }
    final l$surcharges = surcharges;
    final lOther$surcharges = other.surcharges;
    if (l$surcharges.length != lOther$surcharges.length) {
      return false;
    }
    for (int i = 0; i < l$surcharges.length; i++) {
      final l$surcharges$entry = l$surcharges[i];
      final lOther$surcharges$entry = lOther$surcharges[i];
      if (l$surcharges$entry != lOther$surcharges$entry) {
        return false;
      }
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
    final l$payments = payments;
    final lOther$payments = other.payments;
    if (l$payments != null && lOther$payments != null) {
      if (l$payments.length != lOther$payments.length) {
        return false;
      }
      for (int i = 0; i < l$payments.length; i++) {
        final l$payments$entry = l$payments[i];
        final lOther$payments$entry = lOther$payments[i];
        if (l$payments$entry != lOther$payments$entry) {
          return false;
        }
      }
    } else if (l$payments != lOther$payments) {
      return false;
    }
    final l$totalQuantity = totalQuantity;
    final lOther$totalQuantity = other.totalQuantity;
    if (l$totalQuantity != lOther$totalQuantity) {
      return false;
    }
    final l$totalWithTax = totalWithTax;
    final lOther$totalWithTax = other.totalWithTax;
    if (l$totalWithTax != lOther$totalWithTax) {
      return false;
    }
    final l$billingAddress = billingAddress;
    final lOther$billingAddress = other.billingAddress;
    if (l$billingAddress != lOther$billingAddress) {
      return false;
    }
    final l$customFields = customFields;
    final lOther$customFields = other.customFields;
    if (l$customFields != lOther$customFields) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items
    on Query$GetActiveCustomer$activeCustomer$orders$items {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items<
          Query$GetActiveCustomer$activeCustomer$orders$items>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items(
    Query$GetActiveCustomer$activeCustomer$orders$items instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$orders$items) then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items;

  TRes call({
    String? id,
    Enum$CurrencyCode? currencyCode,
    DateTime? orderPlacedAt,
    List<Query$GetActiveCustomer$activeCustomer$orders$items$lines>? lines,
    bool? active,
    List<Query$GetActiveCustomer$activeCustomer$orders$items$discounts>?
        discounts,
    String? code,
    String? state,
    Query$GetActiveCustomer$activeCustomer$orders$items$customer? customer,
    Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress?
        shippingAddress,
    List<Query$GetActiveCustomer$activeCustomer$orders$items$surcharges>?
        surcharges,
    List<String>? couponCodes,
    List<Query$GetActiveCustomer$activeCustomer$orders$items$payments>?
        payments,
    int? totalQuantity,
    double? totalWithTax,
    Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress?
        billingAddress,
    Query$GetActiveCustomer$activeCustomer$orders$items$customFields?
        customFields,
    String? $__typename,
  });
  TRes lines(
      Iterable<Query$GetActiveCustomer$activeCustomer$orders$items$lines> Function(
              Iterable<
                  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines<
                      Query$GetActiveCustomer$activeCustomer$orders$items$lines>>)
          _fn);
  TRes discounts(
      Iterable<Query$GetActiveCustomer$activeCustomer$orders$items$discounts> Function(
              Iterable<
                  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$discounts<
                      Query$GetActiveCustomer$activeCustomer$orders$items$discounts>>)
          _fn);
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer<TRes>
      get customer;
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress<
      TRes> get shippingAddress;
  TRes surcharges(
      Iterable<Query$GetActiveCustomer$activeCustomer$orders$items$surcharges> Function(
              Iterable<
                  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges<
                      Query$GetActiveCustomer$activeCustomer$orders$items$surcharges>>)
          _fn);
  TRes payments(
      Iterable<Query$GetActiveCustomer$activeCustomer$orders$items$payments>? Function(
              Iterable<
                  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$payments<
                      Query$GetActiveCustomer$activeCustomer$orders$items$payments>>?)
          _fn);
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress<
      TRes> get billingAddress;
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields<
      TRes> get customFields;
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items<TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items<TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items _instance;

  final TRes Function(Query$GetActiveCustomer$activeCustomer$orders$items)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? currencyCode = _undefined,
    Object? orderPlacedAt = _undefined,
    Object? lines = _undefined,
    Object? active = _undefined,
    Object? discounts = _undefined,
    Object? code = _undefined,
    Object? state = _undefined,
    Object? customer = _undefined,
    Object? shippingAddress = _undefined,
    Object? surcharges = _undefined,
    Object? couponCodes = _undefined,
    Object? payments = _undefined,
    Object? totalQuantity = _undefined,
    Object? totalWithTax = _undefined,
    Object? billingAddress = _undefined,
    Object? customFields = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$orders$items(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        currencyCode: currencyCode == _undefined || currencyCode == null
            ? _instance.currencyCode
            : (currencyCode as Enum$CurrencyCode),
        orderPlacedAt: orderPlacedAt == _undefined
            ? _instance.orderPlacedAt
            : (orderPlacedAt as DateTime?),
        lines: lines == _undefined || lines == null
            ? _instance.lines
            : (lines as List<
                Query$GetActiveCustomer$activeCustomer$orders$items$lines>),
        active: active == _undefined || active == null
            ? _instance.active
            : (active as bool),
        discounts: discounts == _undefined || discounts == null
            ? _instance.discounts
            : (discounts as List<
                Query$GetActiveCustomer$activeCustomer$orders$items$discounts>),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        state: state == _undefined || state == null
            ? _instance.state
            : (state as String),
        customer: customer == _undefined
            ? _instance.customer
            : (customer
                as Query$GetActiveCustomer$activeCustomer$orders$items$customer?),
        shippingAddress: shippingAddress == _undefined
            ? _instance.shippingAddress
            : (shippingAddress
                as Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress?),
        surcharges: surcharges == _undefined || surcharges == null
            ? _instance.surcharges
            : (surcharges as List<
                Query$GetActiveCustomer$activeCustomer$orders$items$surcharges>),
        couponCodes: couponCodes == _undefined || couponCodes == null
            ? _instance.couponCodes
            : (couponCodes as List<String>),
        payments: payments == _undefined
            ? _instance.payments
            : (payments as List<
                Query$GetActiveCustomer$activeCustomer$orders$items$payments>?),
        totalQuantity: totalQuantity == _undefined || totalQuantity == null
            ? _instance.totalQuantity
            : (totalQuantity as int),
        totalWithTax: totalWithTax == _undefined || totalWithTax == null
            ? _instance.totalWithTax
            : (totalWithTax as double),
        billingAddress: billingAddress == _undefined
            ? _instance.billingAddress
            : (billingAddress
                as Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress?),
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Query$GetActiveCustomer$activeCustomer$orders$items$customFields?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes lines(
          Iterable<Query$GetActiveCustomer$activeCustomer$orders$items$lines> Function(
                  Iterable<
                      CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines<
                          Query$GetActiveCustomer$activeCustomer$orders$items$lines>>)
              _fn) =>
      call(
          lines: _fn(_instance.lines.map((e) =>
              CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines(
                e,
                (i) => i,
              ))).toList());

  TRes discounts(
          Iterable<Query$GetActiveCustomer$activeCustomer$orders$items$discounts> Function(
                  Iterable<
                      CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$discounts<
                          Query$GetActiveCustomer$activeCustomer$orders$items$discounts>>)
              _fn) =>
      call(
          discounts: _fn(_instance.discounts.map((e) =>
              CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$discounts(
                e,
                (i) => i,
              ))).toList());

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer<TRes>
      get customer {
    final local$customer = _instance.customer;
    return local$customer == null
        ? CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer
            .stub(_then(_instance))
        : CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer(
            local$customer, (e) => call(customer: e));
  }

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress<
      TRes> get shippingAddress {
    final local$shippingAddress = _instance.shippingAddress;
    return local$shippingAddress == null
        ? CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress
            .stub(_then(_instance))
        : CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress(
            local$shippingAddress, (e) => call(shippingAddress: e));
  }

  TRes surcharges(
          Iterable<Query$GetActiveCustomer$activeCustomer$orders$items$surcharges> Function(
                  Iterable<
                      CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges<
                          Query$GetActiveCustomer$activeCustomer$orders$items$surcharges>>)
              _fn) =>
      call(
          surcharges: _fn(_instance.surcharges.map((e) =>
              CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges(
                e,
                (i) => i,
              ))).toList());

  TRes payments(
          Iterable<Query$GetActiveCustomer$activeCustomer$orders$items$payments>? Function(
                  Iterable<
                      CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$payments<
                          Query$GetActiveCustomer$activeCustomer$orders$items$payments>>?)
              _fn) =>
      call(
          payments: _fn(_instance.payments?.map((e) =>
              CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$payments(
                e,
                (i) => i,
              )))?.toList());

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress<
      TRes> get billingAddress {
    final local$billingAddress = _instance.billingAddress;
    return local$billingAddress == null
        ? CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress
            .stub(_then(_instance))
        : CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress(
            local$billingAddress, (e) => call(billingAddress: e));
  }

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields<
      TRes> get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields
            .stub(_then(_instance))
        : CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields(
            local$customFields, (e) => call(customFields: e));
  }
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items<TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items(
      this._res);

  TRes _res;

  call({
    String? id,
    Enum$CurrencyCode? currencyCode,
    DateTime? orderPlacedAt,
    List<Query$GetActiveCustomer$activeCustomer$orders$items$lines>? lines,
    bool? active,
    List<Query$GetActiveCustomer$activeCustomer$orders$items$discounts>?
        discounts,
    String? code,
    String? state,
    Query$GetActiveCustomer$activeCustomer$orders$items$customer? customer,
    Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress?
        shippingAddress,
    List<Query$GetActiveCustomer$activeCustomer$orders$items$surcharges>?
        surcharges,
    List<String>? couponCodes,
    List<Query$GetActiveCustomer$activeCustomer$orders$items$payments>?
        payments,
    int? totalQuantity,
    double? totalWithTax,
    Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress?
        billingAddress,
    Query$GetActiveCustomer$activeCustomer$orders$items$customFields?
        customFields,
    String? $__typename,
  }) =>
      _res;

  lines(_fn) => _res;

  discounts(_fn) => _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer<TRes>
      get customer =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer
              .stub(_res);

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress<
          TRes>
      get shippingAddress =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress
              .stub(_res);

  surcharges(_fn) => _res;

  payments(_fn) => _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress<
          TRes>
      get billingAddress =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress
              .stub(_res);

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields<
          TRes>
      get customFields =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields
              .stub(_res);
}

class Query$GetActiveCustomer$activeCustomer$orders$items$lines {
  Query$GetActiveCustomer$activeCustomer$orders$items$lines({
    required this.id,
    required this.quantity,
    required this.productVariant,
    this.featuredAsset,
    this.$__typename = 'OrderLine',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items$lines.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$quantity = json['quantity'];
    final l$productVariant = json['productVariant'];
    final l$featuredAsset = json['featuredAsset'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items$lines(
      id: (l$id as String),
      quantity: (l$quantity as int),
      productVariant:
          Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant
              .fromJson((l$productVariant as Map<String, dynamic>)),
      featuredAsset: l$featuredAsset == null
          ? null
          : Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset
              .fromJson((l$featuredAsset as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int quantity;

  final Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant
      productVariant;

  final Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset?
      featuredAsset;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$quantity = quantity;
    _resultData['quantity'] = l$quantity;
    final l$productVariant = productVariant;
    _resultData['productVariant'] = l$productVariant.toJson();
    final l$featuredAsset = featuredAsset;
    _resultData['featuredAsset'] = l$featuredAsset?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$quantity = quantity;
    final l$productVariant = productVariant;
    final l$featuredAsset = featuredAsset;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$quantity,
      l$productVariant,
      l$featuredAsset,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetActiveCustomer$activeCustomer$orders$items$lines ||
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
    final l$productVariant = productVariant;
    final lOther$productVariant = other.productVariant;
    if (l$productVariant != lOther$productVariant) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items$lines
    on Query$GetActiveCustomer$activeCustomer$orders$items$lines {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines<
          Query$GetActiveCustomer$activeCustomer$orders$items$lines>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines(
    Query$GetActiveCustomer$activeCustomer$orders$items$lines instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$orders$items$lines)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines;

  TRes call({
    String? id,
    int? quantity,
    Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant?
        productVariant,
    Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset?
        featuredAsset,
    String? $__typename,
  });
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant<
      TRes> get productVariant;
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset<
      TRes> get featuredAsset;
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items$lines _instance;

  final TRes Function(Query$GetActiveCustomer$activeCustomer$orders$items$lines)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? quantity = _undefined,
    Object? productVariant = _undefined,
    Object? featuredAsset = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$orders$items$lines(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        quantity: quantity == _undefined || quantity == null
            ? _instance.quantity
            : (quantity as int),
        productVariant: productVariant == _undefined || productVariant == null
            ? _instance.productVariant
            : (productVariant
                as Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant),
        featuredAsset: featuredAsset == _undefined
            ? _instance.featuredAsset
            : (featuredAsset
                as Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant<
      TRes> get productVariant {
    final local$productVariant = _instance.productVariant;
    return CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant(
        local$productVariant, (e) => call(productVariant: e));
  }

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset<
      TRes> get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset
            .stub(_then(_instance))
        : CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset(
            local$featuredAsset, (e) => call(featuredAsset: e));
  }
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines(
      this._res);

  TRes _res;

  call({
    String? id,
    int? quantity,
    Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant?
        productVariant,
    Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset?
        featuredAsset,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant<
          TRes>
      get productVariant =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant
              .stub(_res);

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset<
          TRes>
      get featuredAsset =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset
              .stub(_res);
}

class Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant {
  Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant({
    required this.name,
    this.$__typename = 'ProductVariant',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant.fromJson(
      Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant(
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
    if (other
            is! Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant ||
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant
    on Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant<
          Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant(
    Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant
        instance,
    TRes Function(
            Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant;

  TRes call({
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant
      _instance;

  final TRes Function(
          Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant(
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$productVariant(
      this._res);

  TRes _res;

  call({
    String? name,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset {
  Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset({
    required this.name,
    required this.preview,
    this.$__typename = 'Asset',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset.fromJson(
      Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$preview = json['preview'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset(
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
    if (other
            is! Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset ||
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset
    on Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset<
          Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset(
    Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset
        instance,
    TRes Function(
            Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset;

  TRes call({
    String? name,
    String? preview,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset
      _instance;

  final TRes Function(
          Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? preview = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset(
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

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$lines$featuredAsset(
      this._res);

  TRes _res;

  call({
    String? name,
    String? preview,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$orders$items$discounts {
  Query$GetActiveCustomer$activeCustomer$orders$items$discounts({
    required this.amount,
    this.$__typename = 'Discount',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items$discounts.fromJson(
      Map<String, dynamic> json) {
    final l$amount = json['amount'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items$discounts(
      amount: (l$amount as num).toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final double amount;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$amount = amount;
    _resultData['amount'] = l$amount;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$amount = amount;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$amount,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetActiveCustomer$activeCustomer$orders$items$discounts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$amount = amount;
    final lOther$amount = other.amount;
    if (l$amount != lOther$amount) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items$discounts
    on Query$GetActiveCustomer$activeCustomer$orders$items$discounts {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$discounts<
          Query$GetActiveCustomer$activeCustomer$orders$items$discounts>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$discounts(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$discounts<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$discounts(
    Query$GetActiveCustomer$activeCustomer$orders$items$discounts instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$orders$items$discounts)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$discounts;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$discounts.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$discounts;

  TRes call({
    double? amount,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$discounts<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$discounts<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$discounts(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items$discounts _instance;

  final TRes Function(
      Query$GetActiveCustomer$activeCustomer$orders$items$discounts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? amount = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$orders$items$discounts(
        amount: amount == _undefined || amount == null
            ? _instance.amount
            : (amount as double),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$discounts<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$discounts<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$discounts(
      this._res);

  TRes _res;

  call({
    double? amount,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$orders$items$customer {
  Query$GetActiveCustomer$activeCustomer$orders$items$customer({
    required this.firstName,
    required this.lastName,
    this.$__typename = 'Customer',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items$customer.fromJson(
      Map<String, dynamic> json) {
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items$customer(
      firstName: (l$firstName as String),
      lastName: (l$lastName as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String firstName;

  final String lastName;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
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
    final l$firstName = firstName;
    final l$lastName = lastName;
    final l$$__typename = $__typename;
    return Object.hashAll([
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
            is! Query$GetActiveCustomer$activeCustomer$orders$items$customer ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items$customer
    on Query$GetActiveCustomer$activeCustomer$orders$items$customer {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer<
          Query$GetActiveCustomer$activeCustomer$orders$items$customer>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer(
    Query$GetActiveCustomer$activeCustomer$orders$items$customer instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$orders$items$customer)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customer;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customer;

  TRes call({
    String? firstName,
    String? lastName,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customer<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customer(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items$customer _instance;

  final TRes Function(
      Query$GetActiveCustomer$activeCustomer$orders$items$customer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$orders$items$customer(
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

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customer<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customer<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customer(
      this._res);

  TRes _res;

  call({
    String? firstName,
    String? lastName,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress {
  Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress({
    this.country,
    this.city,
    this.phoneNumber,
    this.streetLine1,
    this.streetLine2,
    this.postalCode,
    this.fullName,
    this.$__typename = 'OrderAddress',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress.fromJson(
      Map<String, dynamic> json) {
    final l$country = json['country'];
    final l$city = json['city'];
    final l$phoneNumber = json['phoneNumber'];
    final l$streetLine1 = json['streetLine1'];
    final l$streetLine2 = json['streetLine2'];
    final l$postalCode = json['postalCode'];
    final l$fullName = json['fullName'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress(
      country: (l$country as String?),
      city: (l$city as String?),
      phoneNumber: (l$phoneNumber as String?),
      streetLine1: (l$streetLine1 as String?),
      streetLine2: (l$streetLine2 as String?),
      postalCode: (l$postalCode as String?),
      fullName: (l$fullName as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? country;

  final String? city;

  final String? phoneNumber;

  final String? streetLine1;

  final String? streetLine2;

  final String? postalCode;

  final String? fullName;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$country = country;
    _resultData['country'] = l$country;
    final l$city = city;
    _resultData['city'] = l$city;
    final l$phoneNumber = phoneNumber;
    _resultData['phoneNumber'] = l$phoneNumber;
    final l$streetLine1 = streetLine1;
    _resultData['streetLine1'] = l$streetLine1;
    final l$streetLine2 = streetLine2;
    _resultData['streetLine2'] = l$streetLine2;
    final l$postalCode = postalCode;
    _resultData['postalCode'] = l$postalCode;
    final l$fullName = fullName;
    _resultData['fullName'] = l$fullName;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$country = country;
    final l$city = city;
    final l$phoneNumber = phoneNumber;
    final l$streetLine1 = streetLine1;
    final l$streetLine2 = streetLine2;
    final l$postalCode = postalCode;
    final l$fullName = fullName;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$country,
      l$city,
      l$phoneNumber,
      l$streetLine1,
      l$streetLine2,
      l$postalCode,
      l$fullName,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (l$country != lOther$country) {
      return false;
    }
    final l$city = city;
    final lOther$city = other.city;
    if (l$city != lOther$city) {
      return false;
    }
    final l$phoneNumber = phoneNumber;
    final lOther$phoneNumber = other.phoneNumber;
    if (l$phoneNumber != lOther$phoneNumber) {
      return false;
    }
    final l$streetLine1 = streetLine1;
    final lOther$streetLine1 = other.streetLine1;
    if (l$streetLine1 != lOther$streetLine1) {
      return false;
    }
    final l$streetLine2 = streetLine2;
    final lOther$streetLine2 = other.streetLine2;
    if (l$streetLine2 != lOther$streetLine2) {
      return false;
    }
    final l$postalCode = postalCode;
    final lOther$postalCode = other.postalCode;
    if (l$postalCode != lOther$postalCode) {
      return false;
    }
    final l$fullName = fullName;
    final lOther$fullName = other.fullName;
    if (l$fullName != lOther$fullName) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress
    on Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress<
          Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress(
    Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress
        instance,
    TRes Function(
            Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress;

  TRes call({
    String? country,
    String? city,
    String? phoneNumber,
    String? streetLine1,
    String? streetLine2,
    String? postalCode,
    String? fullName,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress
      _instance;

  final TRes Function(
          Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? country = _undefined,
    Object? city = _undefined,
    Object? phoneNumber = _undefined,
    Object? streetLine1 = _undefined,
    Object? streetLine2 = _undefined,
    Object? postalCode = _undefined,
    Object? fullName = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress(
        country:
            country == _undefined ? _instance.country : (country as String?),
        city: city == _undefined ? _instance.city : (city as String?),
        phoneNumber: phoneNumber == _undefined
            ? _instance.phoneNumber
            : (phoneNumber as String?),
        streetLine1: streetLine1 == _undefined
            ? _instance.streetLine1
            : (streetLine1 as String?),
        streetLine2: streetLine2 == _undefined
            ? _instance.streetLine2
            : (streetLine2 as String?),
        postalCode: postalCode == _undefined
            ? _instance.postalCode
            : (postalCode as String?),
        fullName:
            fullName == _undefined ? _instance.fullName : (fullName as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$shippingAddress(
      this._res);

  TRes _res;

  call({
    String? country,
    String? city,
    String? phoneNumber,
    String? streetLine1,
    String? streetLine2,
    String? postalCode,
    String? fullName,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$orders$items$surcharges {
  Query$GetActiveCustomer$activeCustomer$orders$items$surcharges({
    required this.price,
    required this.priceWithTax,
    this.$__typename = 'Surcharge',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items$surcharges.fromJson(
      Map<String, dynamic> json) {
    final l$price = json['price'];
    final l$priceWithTax = json['priceWithTax'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items$surcharges(
      price: (l$price as num).toDouble(),
      priceWithTax: (l$priceWithTax as num).toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final double price;

  final double priceWithTax;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$price = price;
    _resultData['price'] = l$price;
    final l$priceWithTax = priceWithTax;
    _resultData['priceWithTax'] = l$priceWithTax;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$price = price;
    final l$priceWithTax = priceWithTax;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$price,
      l$priceWithTax,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetActiveCustomer$activeCustomer$orders$items$surcharges ||
        runtimeType != other.runtimeType) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges
    on Query$GetActiveCustomer$activeCustomer$orders$items$surcharges {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges<
          Query$GetActiveCustomer$activeCustomer$orders$items$surcharges>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges(
    Query$GetActiveCustomer$activeCustomer$orders$items$surcharges instance,
    TRes Function(
            Query$GetActiveCustomer$activeCustomer$orders$items$surcharges)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges;

  TRes call({
    double? price,
    double? priceWithTax,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items$surcharges
      _instance;

  final TRes Function(
      Query$GetActiveCustomer$activeCustomer$orders$items$surcharges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? price = _undefined,
    Object? priceWithTax = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$orders$items$surcharges(
        price: price == _undefined || price == null
            ? _instance.price
            : (price as double),
        priceWithTax: priceWithTax == _undefined || priceWithTax == null
            ? _instance.priceWithTax
            : (priceWithTax as double),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$surcharges(
      this._res);

  TRes _res;

  call({
    double? price,
    double? priceWithTax,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$orders$items$payments {
  Query$GetActiveCustomer$activeCustomer$orders$items$payments({
    required this.state,
    required this.createdAt,
    required this.method,
    required this.amount,
    this.transactionId,
    this.$__typename = 'Payment',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items$payments.fromJson(
      Map<String, dynamic> json) {
    final l$state = json['state'];
    final l$createdAt = json['createdAt'];
    final l$method = json['method'];
    final l$amount = json['amount'];
    final l$transactionId = json['transactionId'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items$payments(
      state: (l$state as String),
      createdAt: DateTime.parse((l$createdAt as String)),
      method: (l$method as String),
      amount: (l$amount as num).toDouble(),
      transactionId: (l$transactionId as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String state;

  final DateTime createdAt;

  final String method;

  final double amount;

  final String? transactionId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$state = state;
    _resultData['state'] = l$state;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$method = method;
    _resultData['method'] = l$method;
    final l$amount = amount;
    _resultData['amount'] = l$amount;
    final l$transactionId = transactionId;
    _resultData['transactionId'] = l$transactionId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$state = state;
    final l$createdAt = createdAt;
    final l$method = method;
    final l$amount = amount;
    final l$transactionId = transactionId;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$state,
      l$createdAt,
      l$method,
      l$amount,
      l$transactionId,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetActiveCustomer$activeCustomer$orders$items$payments ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$state = state;
    final lOther$state = other.state;
    if (l$state != lOther$state) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$method = method;
    final lOther$method = other.method;
    if (l$method != lOther$method) {
      return false;
    }
    final l$amount = amount;
    final lOther$amount = other.amount;
    if (l$amount != lOther$amount) {
      return false;
    }
    final l$transactionId = transactionId;
    final lOther$transactionId = other.transactionId;
    if (l$transactionId != lOther$transactionId) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items$payments
    on Query$GetActiveCustomer$activeCustomer$orders$items$payments {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$payments<
          Query$GetActiveCustomer$activeCustomer$orders$items$payments>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$payments(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$payments<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$payments(
    Query$GetActiveCustomer$activeCustomer$orders$items$payments instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$orders$items$payments)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$payments;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$payments.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$payments;

  TRes call({
    String? state,
    DateTime? createdAt,
    String? method,
    double? amount,
    String? transactionId,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$payments<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$payments<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$payments(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items$payments _instance;

  final TRes Function(
      Query$GetActiveCustomer$activeCustomer$orders$items$payments) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? state = _undefined,
    Object? createdAt = _undefined,
    Object? method = _undefined,
    Object? amount = _undefined,
    Object? transactionId = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$orders$items$payments(
        state: state == _undefined || state == null
            ? _instance.state
            : (state as String),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        method: method == _undefined || method == null
            ? _instance.method
            : (method as String),
        amount: amount == _undefined || amount == null
            ? _instance.amount
            : (amount as double),
        transactionId: transactionId == _undefined
            ? _instance.transactionId
            : (transactionId as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$payments<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$payments<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$payments(
      this._res);

  TRes _res;

  call({
    String? state,
    DateTime? createdAt,
    String? method,
    double? amount,
    String? transactionId,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress {
  Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress({
    this.postalCode,
    this.streetLine2,
    this.fullName,
    this.city,
    this.phoneNumber,
    this.streetLine1,
    this.$__typename = 'OrderAddress',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress.fromJson(
      Map<String, dynamic> json) {
    final l$postalCode = json['postalCode'];
    final l$streetLine2 = json['streetLine2'];
    final l$fullName = json['fullName'];
    final l$city = json['city'];
    final l$phoneNumber = json['phoneNumber'];
    final l$streetLine1 = json['streetLine1'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress(
      postalCode: (l$postalCode as String?),
      streetLine2: (l$streetLine2 as String?),
      fullName: (l$fullName as String?),
      city: (l$city as String?),
      phoneNumber: (l$phoneNumber as String?),
      streetLine1: (l$streetLine1 as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? postalCode;

  final String? streetLine2;

  final String? fullName;

  final String? city;

  final String? phoneNumber;

  final String? streetLine1;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$postalCode = postalCode;
    _resultData['postalCode'] = l$postalCode;
    final l$streetLine2 = streetLine2;
    _resultData['streetLine2'] = l$streetLine2;
    final l$fullName = fullName;
    _resultData['fullName'] = l$fullName;
    final l$city = city;
    _resultData['city'] = l$city;
    final l$phoneNumber = phoneNumber;
    _resultData['phoneNumber'] = l$phoneNumber;
    final l$streetLine1 = streetLine1;
    _resultData['streetLine1'] = l$streetLine1;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$postalCode = postalCode;
    final l$streetLine2 = streetLine2;
    final l$fullName = fullName;
    final l$city = city;
    final l$phoneNumber = phoneNumber;
    final l$streetLine1 = streetLine1;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$postalCode,
      l$streetLine2,
      l$fullName,
      l$city,
      l$phoneNumber,
      l$streetLine1,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$postalCode = postalCode;
    final lOther$postalCode = other.postalCode;
    if (l$postalCode != lOther$postalCode) {
      return false;
    }
    final l$streetLine2 = streetLine2;
    final lOther$streetLine2 = other.streetLine2;
    if (l$streetLine2 != lOther$streetLine2) {
      return false;
    }
    final l$fullName = fullName;
    final lOther$fullName = other.fullName;
    if (l$fullName != lOther$fullName) {
      return false;
    }
    final l$city = city;
    final lOther$city = other.city;
    if (l$city != lOther$city) {
      return false;
    }
    final l$phoneNumber = phoneNumber;
    final lOther$phoneNumber = other.phoneNumber;
    if (l$phoneNumber != lOther$phoneNumber) {
      return false;
    }
    final l$streetLine1 = streetLine1;
    final lOther$streetLine1 = other.streetLine1;
    if (l$streetLine1 != lOther$streetLine1) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress
    on Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress<
          Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress(
    Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress instance,
    TRes Function(
            Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress;

  TRes call({
    String? postalCode,
    String? streetLine2,
    String? fullName,
    String? city,
    String? phoneNumber,
    String? streetLine1,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress
      _instance;

  final TRes Function(
      Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? postalCode = _undefined,
    Object? streetLine2 = _undefined,
    Object? fullName = _undefined,
    Object? city = _undefined,
    Object? phoneNumber = _undefined,
    Object? streetLine1 = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress(
        postalCode: postalCode == _undefined
            ? _instance.postalCode
            : (postalCode as String?),
        streetLine2: streetLine2 == _undefined
            ? _instance.streetLine2
            : (streetLine2 as String?),
        fullName:
            fullName == _undefined ? _instance.fullName : (fullName as String?),
        city: city == _undefined ? _instance.city : (city as String?),
        phoneNumber: phoneNumber == _undefined
            ? _instance.phoneNumber
            : (phoneNumber as String?),
        streetLine1: streetLine1 == _undefined
            ? _instance.streetLine1
            : (streetLine1 as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$billingAddress(
      this._res);

  TRes _res;

  call({
    String? postalCode,
    String? streetLine2,
    String? fullName,
    String? city,
    String? phoneNumber,
    String? streetLine1,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$orders$items$customFields {
  Query$GetActiveCustomer$activeCustomer$orders$items$customFields({
    this.loyaltyPointsUsed,
    this.loyaltyPointsEarned,
    this.otherInstructions,
    this.$__typename = 'OrderCustomFields',
  });

  factory Query$GetActiveCustomer$activeCustomer$orders$items$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$loyaltyPointsUsed = json['loyaltyPointsUsed'];
    final l$loyaltyPointsEarned = json['loyaltyPointsEarned'];
    final l$otherInstructions = json['otherInstructions'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$orders$items$customFields(
      loyaltyPointsUsed: (l$loyaltyPointsUsed as int?),
      loyaltyPointsEarned: (l$loyaltyPointsEarned as int?),
      otherInstructions: (l$otherInstructions as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? loyaltyPointsUsed;

  final int? loyaltyPointsEarned;

  final String? otherInstructions;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    _resultData['loyaltyPointsUsed'] = l$loyaltyPointsUsed;
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    _resultData['loyaltyPointsEarned'] = l$loyaltyPointsEarned;
    final l$otherInstructions = otherInstructions;
    _resultData['otherInstructions'] = l$otherInstructions;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    final l$otherInstructions = otherInstructions;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$loyaltyPointsUsed,
      l$loyaltyPointsEarned,
      l$otherInstructions,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetActiveCustomer$activeCustomer$orders$items$customFields ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    final lOther$loyaltyPointsUsed = other.loyaltyPointsUsed;
    if (l$loyaltyPointsUsed != lOther$loyaltyPointsUsed) {
      return false;
    }
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    final lOther$loyaltyPointsEarned = other.loyaltyPointsEarned;
    if (l$loyaltyPointsEarned != lOther$loyaltyPointsEarned) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$orders$items$customFields
    on Query$GetActiveCustomer$activeCustomer$orders$items$customFields {
  CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields<
          Query$GetActiveCustomer$activeCustomer$orders$items$customFields>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields(
    Query$GetActiveCustomer$activeCustomer$orders$items$customFields instance,
    TRes Function(
            Query$GetActiveCustomer$activeCustomer$orders$items$customFields)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customFields;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customFields;

  TRes call({
    int? loyaltyPointsUsed,
    int? loyaltyPointsEarned,
    String? otherInstructions,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customFields<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customFields(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$orders$items$customFields
      _instance;

  final TRes Function(
      Query$GetActiveCustomer$activeCustomer$orders$items$customFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? loyaltyPointsUsed = _undefined,
    Object? loyaltyPointsEarned = _undefined,
    Object? otherInstructions = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$orders$items$customFields(
        loyaltyPointsUsed: loyaltyPointsUsed == _undefined
            ? _instance.loyaltyPointsUsed
            : (loyaltyPointsUsed as int?),
        loyaltyPointsEarned: loyaltyPointsEarned == _undefined
            ? _instance.loyaltyPointsEarned
            : (loyaltyPointsEarned as int?),
        otherInstructions: otherInstructions == _undefined
            ? _instance.otherInstructions
            : (otherInstructions as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customFields<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$orders$items$customFields<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$orders$items$customFields(
      this._res);

  TRes _res;

  call({
    int? loyaltyPointsUsed,
    int? loyaltyPointsEarned,
    String? otherInstructions,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetLoyaltyPointTransactions {
  Query$GetLoyaltyPointTransactions({
    this.activeCustomer,
    this.$__typename = 'Query',
  });

  factory Query$GetLoyaltyPointTransactions.fromJson(
      Map<String, dynamic> json) {
    final l$activeCustomer = json['activeCustomer'];
    final l$$__typename = json['__typename'];
    return Query$GetLoyaltyPointTransactions(
      activeCustomer: l$activeCustomer == null
          ? null
          : Query$GetLoyaltyPointTransactions$activeCustomer.fromJson(
              (l$activeCustomer as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GetLoyaltyPointTransactions$activeCustomer? activeCustomer;

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
    return Object.hashAll([
      l$activeCustomer,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetLoyaltyPointTransactions ||
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

extension UtilityExtension$Query$GetLoyaltyPointTransactions
    on Query$GetLoyaltyPointTransactions {
  CopyWith$Query$GetLoyaltyPointTransactions<Query$GetLoyaltyPointTransactions>
      get copyWith => CopyWith$Query$GetLoyaltyPointTransactions(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetLoyaltyPointTransactions<TRes> {
  factory CopyWith$Query$GetLoyaltyPointTransactions(
    Query$GetLoyaltyPointTransactions instance,
    TRes Function(Query$GetLoyaltyPointTransactions) then,
  ) = _CopyWithImpl$Query$GetLoyaltyPointTransactions;

  factory CopyWith$Query$GetLoyaltyPointTransactions.stub(TRes res) =
      _CopyWithStubImpl$Query$GetLoyaltyPointTransactions;

  TRes call({
    Query$GetLoyaltyPointTransactions$activeCustomer? activeCustomer,
    String? $__typename,
  });
  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer<TRes>
      get activeCustomer;
}

class _CopyWithImpl$Query$GetLoyaltyPointTransactions<TRes>
    implements CopyWith$Query$GetLoyaltyPointTransactions<TRes> {
  _CopyWithImpl$Query$GetLoyaltyPointTransactions(
    this._instance,
    this._then,
  );

  final Query$GetLoyaltyPointTransactions _instance;

  final TRes Function(Query$GetLoyaltyPointTransactions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? activeCustomer = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetLoyaltyPointTransactions(
        activeCustomer: activeCustomer == _undefined
            ? _instance.activeCustomer
            : (activeCustomer
                as Query$GetLoyaltyPointTransactions$activeCustomer?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer<TRes>
      get activeCustomer {
    final local$activeCustomer = _instance.activeCustomer;
    return local$activeCustomer == null
        ? CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer.stub(
            _then(_instance))
        : CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer(
            local$activeCustomer, (e) => call(activeCustomer: e));
  }
}

class _CopyWithStubImpl$Query$GetLoyaltyPointTransactions<TRes>
    implements CopyWith$Query$GetLoyaltyPointTransactions<TRes> {
  _CopyWithStubImpl$Query$GetLoyaltyPointTransactions(this._res);

  TRes _res;

  call({
    Query$GetLoyaltyPointTransactions$activeCustomer? activeCustomer,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer<TRes>
      get activeCustomer =>
          CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer.stub(_res);
}

const documentNodeQueryGetLoyaltyPointTransactions = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetLoyaltyPointTransactions'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'activeCustomer'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
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
            )),
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'orders'),
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
                        name: NameNode(value: 'orderPlacedAt'),
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
Query$GetLoyaltyPointTransactions _parserFn$Query$GetLoyaltyPointTransactions(
        Map<String, dynamic> data) =>
    Query$GetLoyaltyPointTransactions.fromJson(data);
typedef OnQueryComplete$Query$GetLoyaltyPointTransactions = FutureOr<void>
    Function(
  Map<String, dynamic>?,
  Query$GetLoyaltyPointTransactions?,
);

class Options$Query$GetLoyaltyPointTransactions
    extends graphql.QueryOptions<Query$GetLoyaltyPointTransactions> {
  Options$Query$GetLoyaltyPointTransactions({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetLoyaltyPointTransactions? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetLoyaltyPointTransactions? onComplete,
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
                        : _parserFn$Query$GetLoyaltyPointTransactions(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetLoyaltyPointTransactions,
          parserFn: _parserFn$Query$GetLoyaltyPointTransactions,
        );

  final OnQueryComplete$Query$GetLoyaltyPointTransactions? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetLoyaltyPointTransactions
    extends graphql.WatchQueryOptions<Query$GetLoyaltyPointTransactions> {
  WatchOptions$Query$GetLoyaltyPointTransactions({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetLoyaltyPointTransactions? typedOptimisticResult,
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
          document: documentNodeQueryGetLoyaltyPointTransactions,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetLoyaltyPointTransactions,
        );
}

class FetchMoreOptions$Query$GetLoyaltyPointTransactions
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetLoyaltyPointTransactions(
      {required graphql.UpdateQuery updateQuery})
      : super(
          updateQuery: updateQuery,
          document: documentNodeQueryGetLoyaltyPointTransactions,
        );
}

extension ClientExtension$Query$GetLoyaltyPointTransactions
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetLoyaltyPointTransactions>>
      query$GetLoyaltyPointTransactions(
              [Options$Query$GetLoyaltyPointTransactions? options]) async =>
          await this
              .query(options ?? Options$Query$GetLoyaltyPointTransactions());
  graphql.ObservableQuery<Query$GetLoyaltyPointTransactions>
      watchQuery$GetLoyaltyPointTransactions(
              [WatchOptions$Query$GetLoyaltyPointTransactions? options]) =>
          this.watchQuery(
              options ?? WatchOptions$Query$GetLoyaltyPointTransactions());
  void writeQuery$GetLoyaltyPointTransactions({
    required Query$GetLoyaltyPointTransactions data,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
            operation: graphql.Operation(
                document: documentNodeQueryGetLoyaltyPointTransactions)),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$GetLoyaltyPointTransactions? readQuery$GetLoyaltyPointTransactions(
      {bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
          operation: graphql.Operation(
              document: documentNodeQueryGetLoyaltyPointTransactions)),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query$GetLoyaltyPointTransactions.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetLoyaltyPointTransactions>
    useQuery$GetLoyaltyPointTransactions(
            [Options$Query$GetLoyaltyPointTransactions? options]) =>
        graphql_flutter
            .useQuery(options ?? Options$Query$GetLoyaltyPointTransactions());
graphql.ObservableQuery<Query$GetLoyaltyPointTransactions>
    useWatchQuery$GetLoyaltyPointTransactions(
            [WatchOptions$Query$GetLoyaltyPointTransactions? options]) =>
        graphql_flutter.useWatchQuery(
            options ?? WatchOptions$Query$GetLoyaltyPointTransactions());

class Query$GetLoyaltyPointTransactions$Widget
    extends graphql_flutter.Query<Query$GetLoyaltyPointTransactions> {
  Query$GetLoyaltyPointTransactions$Widget({
    widgets.Key? key,
    Options$Query$GetLoyaltyPointTransactions? options,
    required graphql_flutter.QueryBuilder<Query$GetLoyaltyPointTransactions>
        builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$GetLoyaltyPointTransactions(),
          builder: builder,
        );
}

class Query$GetLoyaltyPointTransactions$activeCustomer {
  Query$GetLoyaltyPointTransactions$activeCustomer({
    this.$__typename = 'Customer',
    required this.orders,
  });

  factory Query$GetLoyaltyPointTransactions$activeCustomer.fromJson(
      Map<String, dynamic> json) {
    final l$$__typename = json['__typename'];
    final l$orders = json['orders'];
    return Query$GetLoyaltyPointTransactions$activeCustomer(
      $__typename: (l$$__typename as String),
      orders: Query$GetLoyaltyPointTransactions$activeCustomer$orders.fromJson(
          (l$orders as Map<String, dynamic>)),
    );
  }

  final String $__typename;

  final Query$GetLoyaltyPointTransactions$activeCustomer$orders orders;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$orders = orders;
    _resultData['orders'] = l$orders.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$orders = orders;
    return Object.hashAll([
      l$$__typename,
      l$orders,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetLoyaltyPointTransactions$activeCustomer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$orders = orders;
    final lOther$orders = other.orders;
    if (l$orders != lOther$orders) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetLoyaltyPointTransactions$activeCustomer
    on Query$GetLoyaltyPointTransactions$activeCustomer {
  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer<
          Query$GetLoyaltyPointTransactions$activeCustomer>
      get copyWith => CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer<TRes> {
  factory CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer(
    Query$GetLoyaltyPointTransactions$activeCustomer instance,
    TRes Function(Query$GetLoyaltyPointTransactions$activeCustomer) then,
  ) = _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer;

  factory CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer;

  TRes call({
    String? $__typename,
    Query$GetLoyaltyPointTransactions$activeCustomer$orders? orders,
  });
  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders<TRes>
      get orders;
}

class _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer<TRes>
    implements CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer<TRes> {
  _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer(
    this._instance,
    this._then,
  );

  final Query$GetLoyaltyPointTransactions$activeCustomer _instance;

  final TRes Function(Query$GetLoyaltyPointTransactions$activeCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? orders = _undefined,
  }) =>
      _then(Query$GetLoyaltyPointTransactions$activeCustomer(
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
        orders: orders == _undefined || orders == null
            ? _instance.orders
            : (orders
                as Query$GetLoyaltyPointTransactions$activeCustomer$orders),
      ));

  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders<TRes>
      get orders {
    final local$orders = _instance.orders;
    return CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders(
        local$orders, (e) => call(orders: e));
  }
}

class _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer<TRes>
    implements CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer<TRes> {
  _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer(this._res);

  TRes _res;

  call({
    String? $__typename,
    Query$GetLoyaltyPointTransactions$activeCustomer$orders? orders,
  }) =>
      _res;

  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders<TRes>
      get orders =>
          CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders.stub(
              _res);
}

class Query$GetLoyaltyPointTransactions$activeCustomer$orders {
  Query$GetLoyaltyPointTransactions$activeCustomer$orders({
    required this.items,
    this.$__typename = 'OrderList',
  });

  factory Query$GetLoyaltyPointTransactions$activeCustomer$orders.fromJson(
      Map<String, dynamic> json) {
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Query$GetLoyaltyPointTransactions$activeCustomer$orders(
      items: (l$items as List<dynamic>)
          .map((e) =>
              Query$GetLoyaltyPointTransactions$activeCustomer$orders$items
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$GetLoyaltyPointTransactions$activeCustomer$orders$items>
      items;

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
    if (other is! Query$GetLoyaltyPointTransactions$activeCustomer$orders ||
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

extension UtilityExtension$Query$GetLoyaltyPointTransactions$activeCustomer$orders
    on Query$GetLoyaltyPointTransactions$activeCustomer$orders {
  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders<
          Query$GetLoyaltyPointTransactions$activeCustomer$orders>
      get copyWith =>
          CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders<
    TRes> {
  factory CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders(
    Query$GetLoyaltyPointTransactions$activeCustomer$orders instance,
    TRes Function(Query$GetLoyaltyPointTransactions$activeCustomer$orders) then,
  ) = _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders;

  factory CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders;

  TRes call({
    List<Query$GetLoyaltyPointTransactions$activeCustomer$orders$items>? items,
    String? $__typename,
  });
  TRes items(
      Iterable<Query$GetLoyaltyPointTransactions$activeCustomer$orders$items> Function(
              Iterable<
                  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items<
                      Query$GetLoyaltyPointTransactions$activeCustomer$orders$items>>)
          _fn);
}

class _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders<
        TRes>
    implements
        CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders<TRes> {
  _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders(
    this._instance,
    this._then,
  );

  final Query$GetLoyaltyPointTransactions$activeCustomer$orders _instance;

  final TRes Function(Query$GetLoyaltyPointTransactions$activeCustomer$orders)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetLoyaltyPointTransactions$activeCustomer$orders(
        items: items == _undefined || items == null
            ? _instance.items
            : (items as List<
                Query$GetLoyaltyPointTransactions$activeCustomer$orders$items>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes items(
          Iterable<Query$GetLoyaltyPointTransactions$activeCustomer$orders$items> Function(
                  Iterable<
                      CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items<
                          Query$GetLoyaltyPointTransactions$activeCustomer$orders$items>>)
              _fn) =>
      call(
          items: _fn(_instance.items.map((e) =>
              CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders<
        TRes>
    implements
        CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders<TRes> {
  _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders(
      this._res);

  TRes _res;

  call({
    List<Query$GetLoyaltyPointTransactions$activeCustomer$orders$items>? items,
    String? $__typename,
  }) =>
      _res;

  items(_fn) => _res;
}

class Query$GetLoyaltyPointTransactions$activeCustomer$orders$items {
  Query$GetLoyaltyPointTransactions$activeCustomer$orders$items({
    required this.code,
    required this.state,
    this.orderPlacedAt,
    this.customFields,
    this.$__typename = 'Order',
  });

  factory Query$GetLoyaltyPointTransactions$activeCustomer$orders$items.fromJson(
      Map<String, dynamic> json) {
    final l$code = json['code'];
    final l$state = json['state'];
    final l$orderPlacedAt = json['orderPlacedAt'];
    final l$customFields = json['customFields'];
    final l$$__typename = json['__typename'];
    return Query$GetLoyaltyPointTransactions$activeCustomer$orders$items(
      code: (l$code as String),
      state: (l$state as String),
      orderPlacedAt: l$orderPlacedAt == null
          ? null
          : DateTime.parse((l$orderPlacedAt as String)),
      customFields: l$customFields == null
          ? null
          : Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields
              .fromJson((l$customFields as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String code;

  final String state;

  final DateTime? orderPlacedAt;

  final Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields?
      customFields;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$state = state;
    _resultData['state'] = l$state;
    final l$orderPlacedAt = orderPlacedAt;
    _resultData['orderPlacedAt'] = l$orderPlacedAt?.toIso8601String();
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$state = state;
    final l$orderPlacedAt = orderPlacedAt;
    final l$customFields = customFields;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$code,
      l$state,
      l$orderPlacedAt,
      l$customFields,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetLoyaltyPointTransactions$activeCustomer$orders$items ||
        runtimeType != other.runtimeType) {
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
    final l$orderPlacedAt = orderPlacedAt;
    final lOther$orderPlacedAt = other.orderPlacedAt;
    if (l$orderPlacedAt != lOther$orderPlacedAt) {
      return false;
    }
    final l$customFields = customFields;
    final lOther$customFields = other.customFields;
    if (l$customFields != lOther$customFields) {
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

extension UtilityExtension$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items
    on Query$GetLoyaltyPointTransactions$activeCustomer$orders$items {
  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items<
          Query$GetLoyaltyPointTransactions$activeCustomer$orders$items>
      get copyWith =>
          CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items<
    TRes> {
  factory CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items(
    Query$GetLoyaltyPointTransactions$activeCustomer$orders$items instance,
    TRes Function(Query$GetLoyaltyPointTransactions$activeCustomer$orders$items)
        then,
  ) = _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items;

  factory CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items;

  TRes call({
    String? code,
    String? state,
    DateTime? orderPlacedAt,
    Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields?
        customFields,
    String? $__typename,
  });
  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields<
      TRes> get customFields;
}

class _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items<
        TRes>
    implements
        CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items<
            TRes> {
  _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items(
    this._instance,
    this._then,
  );

  final Query$GetLoyaltyPointTransactions$activeCustomer$orders$items _instance;

  final TRes Function(
      Query$GetLoyaltyPointTransactions$activeCustomer$orders$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? state = _undefined,
    Object? orderPlacedAt = _undefined,
    Object? customFields = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetLoyaltyPointTransactions$activeCustomer$orders$items(
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        state: state == _undefined || state == null
            ? _instance.state
            : (state as String),
        orderPlacedAt: orderPlacedAt == _undefined
            ? _instance.orderPlacedAt
            : (orderPlacedAt as DateTime?),
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields<
      TRes> get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields
            .stub(_then(_instance))
        : CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields(
            local$customFields, (e) => call(customFields: e));
  }
}

class _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items<
        TRes>
    implements
        CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items<
            TRes> {
  _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items(
      this._res);

  TRes _res;

  call({
    String? code,
    String? state,
    DateTime? orderPlacedAt,
    Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields?
        customFields,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields<
          TRes>
      get customFields =>
          CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields
              .stub(_res);
}

class Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields {
  Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields({
    this.loyaltyPointsEarned,
    this.loyaltyPointsUsed,
    this.$__typename = 'OrderCustomFields',
  });

  factory Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$loyaltyPointsEarned = json['loyaltyPointsEarned'];
    final l$loyaltyPointsUsed = json['loyaltyPointsUsed'];
    final l$$__typename = json['__typename'];
    return Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields(
      loyaltyPointsEarned: (l$loyaltyPointsEarned as int?),
      loyaltyPointsUsed: (l$loyaltyPointsUsed as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? loyaltyPointsEarned;

  final int? loyaltyPointsUsed;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    _resultData['loyaltyPointsEarned'] = l$loyaltyPointsEarned;
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    _resultData['loyaltyPointsUsed'] = l$loyaltyPointsUsed;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$loyaltyPointsEarned = loyaltyPointsEarned;
    final l$loyaltyPointsUsed = loyaltyPointsUsed;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$loyaltyPointsEarned,
      l$loyaltyPointsUsed,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields
    on Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields {
  CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields<
          Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields>
      get copyWith =>
          CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields<
    TRes> {
  factory CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields(
    Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields
        instance,
    TRes Function(
            Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields)
        then,
  ) = _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields;

  factory CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields;

  TRes call({
    int? loyaltyPointsEarned,
    int? loyaltyPointsUsed,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields<
        TRes>
    implements
        CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields<
            TRes> {
  _CopyWithImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields(
    this._instance,
    this._then,
  );

  final Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields
      _instance;

  final TRes Function(
          Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? loyaltyPointsEarned = _undefined,
    Object? loyaltyPointsUsed = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields(
        loyaltyPointsEarned: loyaltyPointsEarned == _undefined
            ? _instance.loyaltyPointsEarned
            : (loyaltyPointsEarned as int?),
        loyaltyPointsUsed: loyaltyPointsUsed == _undefined
            ? _instance.loyaltyPointsUsed
            : (loyaltyPointsUsed as int?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields<
        TRes>
    implements
        CopyWith$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields<
            TRes> {
  _CopyWithStubImpl$Query$GetLoyaltyPointTransactions$activeCustomer$orders$items$customFields(
      this._res);

  TRes _res;

  call({
    int? loyaltyPointsEarned,
    int? loyaltyPointsUsed,
    String? $__typename,
  }) =>
      _res;
}
