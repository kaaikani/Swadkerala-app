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
                name: NameNode(value: 'title'),
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
    this.title,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.emailAddress,
    this.$__typename = 'Customer',
  });

  factory Mutation$UpdateCustomer$updateCustomer.fromJson(
      Map<String, dynamic> json) {
    final l$title = json['title'];
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$phoneNumber = json['phoneNumber'];
    final l$emailAddress = json['emailAddress'];
    final l$$__typename = json['__typename'];
    return Mutation$UpdateCustomer$updateCustomer(
      title: (l$title as String?),
      firstName: (l$firstName as String),
      lastName: (l$lastName as String),
      phoneNumber: (l$phoneNumber as String?),
      emailAddress: (l$emailAddress as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String? title;

  final String firstName;

  final String lastName;

  final String? phoneNumber;

  final String emailAddress;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$title = title;
    _resultData['title'] = l$title;
    final l$firstName = firstName;
    _resultData['firstName'] = l$firstName;
    final l$lastName = lastName;
    _resultData['lastName'] = l$lastName;
    final l$phoneNumber = phoneNumber;
    _resultData['phoneNumber'] = l$phoneNumber;
    final l$emailAddress = emailAddress;
    _resultData['emailAddress'] = l$emailAddress;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$title = title;
    final l$firstName = firstName;
    final l$lastName = lastName;
    final l$phoneNumber = phoneNumber;
    final l$emailAddress = emailAddress;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$title,
      l$firstName,
      l$lastName,
      l$phoneNumber,
      l$emailAddress,
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
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
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
    String? title,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? emailAddress,
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
    Object? title = _undefined,
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? phoneNumber = _undefined,
    Object? emailAddress = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$UpdateCustomer$updateCustomer(
        title: title == _undefined ? _instance.title : (title as String?),
        firstName: firstName == _undefined || firstName == null
            ? _instance.firstName
            : (firstName as String),
        lastName: lastName == _undefined || lastName == null
            ? _instance.lastName
            : (lastName as String),
        phoneNumber: phoneNumber == _undefined
            ? _instance.phoneNumber
            : (phoneNumber as String?),
        emailAddress: emailAddress == _undefined || emailAddress == null
            ? _instance.emailAddress
            : (emailAddress as String),
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
    String? title,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? emailAddress,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Mutation$UpdateProfileEmail {
  factory Variables$Mutation$UpdateProfileEmail({required String email}) =>
      Variables$Mutation$UpdateProfileEmail._({
        r'email': email,
      });

  Variables$Mutation$UpdateProfileEmail._(this._$data);

  factory Variables$Mutation$UpdateProfileEmail.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$email = data['email'];
    result$data['email'] = (l$email as String);
    return Variables$Mutation$UpdateProfileEmail._(result$data);
  }

  Map<String, dynamic> _$data;

  String get email => (_$data['email'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$email = email;
    result$data['email'] = l$email;
    return result$data;
  }

  CopyWith$Variables$Mutation$UpdateProfileEmail<
          Variables$Mutation$UpdateProfileEmail>
      get copyWith => CopyWith$Variables$Mutation$UpdateProfileEmail(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$UpdateProfileEmail ||
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

abstract class CopyWith$Variables$Mutation$UpdateProfileEmail<TRes> {
  factory CopyWith$Variables$Mutation$UpdateProfileEmail(
    Variables$Mutation$UpdateProfileEmail instance,
    TRes Function(Variables$Mutation$UpdateProfileEmail) then,
  ) = _CopyWithImpl$Variables$Mutation$UpdateProfileEmail;

  factory CopyWith$Variables$Mutation$UpdateProfileEmail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$UpdateProfileEmail;

  TRes call({String? email});
}

class _CopyWithImpl$Variables$Mutation$UpdateProfileEmail<TRes>
    implements CopyWith$Variables$Mutation$UpdateProfileEmail<TRes> {
  _CopyWithImpl$Variables$Mutation$UpdateProfileEmail(
    this._instance,
    this._then,
  );

  final Variables$Mutation$UpdateProfileEmail _instance;

  final TRes Function(Variables$Mutation$UpdateProfileEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? email = _undefined}) =>
      _then(Variables$Mutation$UpdateProfileEmail._({
        ..._instance._$data,
        if (email != _undefined && email != null) 'email': (email as String),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$UpdateProfileEmail<TRes>
    implements CopyWith$Variables$Mutation$UpdateProfileEmail<TRes> {
  _CopyWithStubImpl$Variables$Mutation$UpdateProfileEmail(this._res);

  TRes _res;

  call({String? email}) => _res;
}

class Mutation$UpdateProfileEmail {
  Mutation$UpdateProfileEmail({
    this.updateProfileEmail,
    this.$__typename = 'Mutation',
  });

  factory Mutation$UpdateProfileEmail.fromJson(Map<String, dynamic> json) {
    final l$updateProfileEmail = json['updateProfileEmail'];
    final l$$__typename = json['__typename'];
    return Mutation$UpdateProfileEmail(
      updateProfileEmail: l$updateProfileEmail == null
          ? null
          : Mutation$UpdateProfileEmail$updateProfileEmail.fromJson(
              (l$updateProfileEmail as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$UpdateProfileEmail$updateProfileEmail? updateProfileEmail;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateProfileEmail = updateProfileEmail;
    _resultData['updateProfileEmail'] = l$updateProfileEmail?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateProfileEmail = updateProfileEmail;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$updateProfileEmail,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UpdateProfileEmail ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateProfileEmail = updateProfileEmail;
    final lOther$updateProfileEmail = other.updateProfileEmail;
    if (l$updateProfileEmail != lOther$updateProfileEmail) {
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

extension UtilityExtension$Mutation$UpdateProfileEmail
    on Mutation$UpdateProfileEmail {
  CopyWith$Mutation$UpdateProfileEmail<Mutation$UpdateProfileEmail>
      get copyWith => CopyWith$Mutation$UpdateProfileEmail(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$UpdateProfileEmail<TRes> {
  factory CopyWith$Mutation$UpdateProfileEmail(
    Mutation$UpdateProfileEmail instance,
    TRes Function(Mutation$UpdateProfileEmail) then,
  ) = _CopyWithImpl$Mutation$UpdateProfileEmail;

  factory CopyWith$Mutation$UpdateProfileEmail.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UpdateProfileEmail;

  TRes call({
    Mutation$UpdateProfileEmail$updateProfileEmail? updateProfileEmail,
    String? $__typename,
  });
  CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail<TRes>
      get updateProfileEmail;
}

class _CopyWithImpl$Mutation$UpdateProfileEmail<TRes>
    implements CopyWith$Mutation$UpdateProfileEmail<TRes> {
  _CopyWithImpl$Mutation$UpdateProfileEmail(
    this._instance,
    this._then,
  );

  final Mutation$UpdateProfileEmail _instance;

  final TRes Function(Mutation$UpdateProfileEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updateProfileEmail = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$UpdateProfileEmail(
        updateProfileEmail: updateProfileEmail == _undefined
            ? _instance.updateProfileEmail
            : (updateProfileEmail
                as Mutation$UpdateProfileEmail$updateProfileEmail?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail<TRes>
      get updateProfileEmail {
    final local$updateProfileEmail = _instance.updateProfileEmail;
    return local$updateProfileEmail == null
        ? CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail.stub(
            _then(_instance))
        : CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail(
            local$updateProfileEmail, (e) => call(updateProfileEmail: e));
  }
}

class _CopyWithStubImpl$Mutation$UpdateProfileEmail<TRes>
    implements CopyWith$Mutation$UpdateProfileEmail<TRes> {
  _CopyWithStubImpl$Mutation$UpdateProfileEmail(this._res);

  TRes _res;

  call({
    Mutation$UpdateProfileEmail$updateProfileEmail? updateProfileEmail,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail<TRes>
      get updateProfileEmail =>
          CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail.stub(_res);
}

const documentNodeMutationUpdateProfileEmail = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'UpdateProfileEmail'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'email')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'updateProfileEmail'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'email'),
            value: VariableNode(name: NameNode(value: 'email')),
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
]);
Mutation$UpdateProfileEmail _parserFn$Mutation$UpdateProfileEmail(
        Map<String, dynamic> data) =>
    Mutation$UpdateProfileEmail.fromJson(data);
typedef OnMutationCompleted$Mutation$UpdateProfileEmail = FutureOr<void>
    Function(
  Map<String, dynamic>?,
  Mutation$UpdateProfileEmail?,
);

class Options$Mutation$UpdateProfileEmail
    extends graphql.MutationOptions<Mutation$UpdateProfileEmail> {
  Options$Mutation$UpdateProfileEmail({
    String? operationName,
    required Variables$Mutation$UpdateProfileEmail variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$UpdateProfileEmail? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$UpdateProfileEmail? onCompleted,
    graphql.OnMutationUpdate<Mutation$UpdateProfileEmail>? update,
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
                        : _parserFn$Mutation$UpdateProfileEmail(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationUpdateProfileEmail,
          parserFn: _parserFn$Mutation$UpdateProfileEmail,
        );

  final OnMutationCompleted$Mutation$UpdateProfileEmail? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$UpdateProfileEmail
    extends graphql.WatchQueryOptions<Mutation$UpdateProfileEmail> {
  WatchOptions$Mutation$UpdateProfileEmail({
    String? operationName,
    required Variables$Mutation$UpdateProfileEmail variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$UpdateProfileEmail? typedOptimisticResult,
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
          document: documentNodeMutationUpdateProfileEmail,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$UpdateProfileEmail,
        );
}

extension ClientExtension$Mutation$UpdateProfileEmail on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$UpdateProfileEmail>>
      mutate$UpdateProfileEmail(
              Options$Mutation$UpdateProfileEmail options) async =>
          await this.mutate(options);
  graphql.ObservableQuery<Mutation$UpdateProfileEmail>
      watchMutation$UpdateProfileEmail(
              WatchOptions$Mutation$UpdateProfileEmail options) =>
          this.watchMutation(options);
}

class Mutation$UpdateProfileEmail$HookResult {
  Mutation$UpdateProfileEmail$HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation$Mutation$UpdateProfileEmail runMutation;

  final graphql.QueryResult<Mutation$UpdateProfileEmail> result;
}

Mutation$UpdateProfileEmail$HookResult useMutation$UpdateProfileEmail(
    [WidgetOptions$Mutation$UpdateProfileEmail? options]) {
  final result = graphql_flutter
      .useMutation(options ?? WidgetOptions$Mutation$UpdateProfileEmail());
  return Mutation$UpdateProfileEmail$HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
      variables.toJson(),
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$UpdateProfileEmail>
    useWatchMutation$UpdateProfileEmail(
            WatchOptions$Mutation$UpdateProfileEmail options) =>
        graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$UpdateProfileEmail
    extends graphql.MutationOptions<Mutation$UpdateProfileEmail> {
  WidgetOptions$Mutation$UpdateProfileEmail({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$UpdateProfileEmail? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$UpdateProfileEmail? onCompleted,
    graphql.OnMutationUpdate<Mutation$UpdateProfileEmail>? update,
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
                        : _parserFn$Mutation$UpdateProfileEmail(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationUpdateProfileEmail,
          parserFn: _parserFn$Mutation$UpdateProfileEmail,
        );

  final OnMutationCompleted$Mutation$UpdateProfileEmail? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

typedef RunMutation$Mutation$UpdateProfileEmail
    = graphql.MultiSourceResult<Mutation$UpdateProfileEmail> Function(
  Variables$Mutation$UpdateProfileEmail, {
  Object? optimisticResult,
  Mutation$UpdateProfileEmail? typedOptimisticResult,
});
typedef Builder$Mutation$UpdateProfileEmail = widgets.Widget Function(
  RunMutation$Mutation$UpdateProfileEmail,
  graphql.QueryResult<Mutation$UpdateProfileEmail>?,
);

class Mutation$UpdateProfileEmail$Widget
    extends graphql_flutter.Mutation<Mutation$UpdateProfileEmail> {
  Mutation$UpdateProfileEmail$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$UpdateProfileEmail? options,
    required Builder$Mutation$UpdateProfileEmail builder,
  }) : super(
          key: key,
          options: options ?? WidgetOptions$Mutation$UpdateProfileEmail(),
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

class Mutation$UpdateProfileEmail$updateProfileEmail {
  Mutation$UpdateProfileEmail$updateProfileEmail({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.$__typename = 'Customer',
  });

  factory Mutation$UpdateProfileEmail$updateProfileEmail.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$$__typename = json['__typename'];
    return Mutation$UpdateProfileEmail$updateProfileEmail(
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
    if (other is! Mutation$UpdateProfileEmail$updateProfileEmail ||
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

extension UtilityExtension$Mutation$UpdateProfileEmail$updateProfileEmail
    on Mutation$UpdateProfileEmail$updateProfileEmail {
  CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail<
          Mutation$UpdateProfileEmail$updateProfileEmail>
      get copyWith => CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail<TRes> {
  factory CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail(
    Mutation$UpdateProfileEmail$updateProfileEmail instance,
    TRes Function(Mutation$UpdateProfileEmail$updateProfileEmail) then,
  ) = _CopyWithImpl$Mutation$UpdateProfileEmail$updateProfileEmail;

  factory CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$UpdateProfileEmail$updateProfileEmail;

  TRes call({
    String? id,
    String? firstName,
    String? lastName,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$UpdateProfileEmail$updateProfileEmail<TRes>
    implements CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail<TRes> {
  _CopyWithImpl$Mutation$UpdateProfileEmail$updateProfileEmail(
    this._instance,
    this._then,
  );

  final Mutation$UpdateProfileEmail$updateProfileEmail _instance;

  final TRes Function(Mutation$UpdateProfileEmail$updateProfileEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$UpdateProfileEmail$updateProfileEmail(
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

class _CopyWithStubImpl$Mutation$UpdateProfileEmail$updateProfileEmail<TRes>
    implements CopyWith$Mutation$UpdateProfileEmail$updateProfileEmail<TRes> {
  _CopyWithStubImpl$Mutation$UpdateProfileEmail$updateProfileEmail(this._res);

  TRes _res;

  call({
    String? id,
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
            name: NameNode(value: 'customFields'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'area'),
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
    this.customFields,
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
    final l$customFields = json['customFields'];
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
      customFields: l$customFields == null
          ? null
          : Mutation$CreateCustomerAddress$createCustomerAddress$customFields
              .fromJson((l$customFields as Map<String, dynamic>)),
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

  final Mutation$CreateCustomerAddress$createCustomerAddress$customFields?
      customFields;

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
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
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
    final l$customFields = customFields;
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
      l$customFields,
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
    Mutation$CreateCustomerAddress$createCustomerAddress$customFields?
        customFields,
    String? $__typename,
  });
  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country<TRes>
      get country;
  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields<
      TRes> get customFields;
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
    Object? customFields = _undefined,
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
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Mutation$CreateCustomerAddress$createCustomerAddress$customFields?),
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

  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields<
      TRes> get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields
            .stub(_then(_instance))
        : CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields(
            local$customFields, (e) => call(customFields: e));
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
    Mutation$CreateCustomerAddress$createCustomerAddress$customFields?
        customFields,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country<TRes>
      get country =>
          CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$country
              .stub(_res);

  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields<
          TRes>
      get customFields =>
          CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields
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

class Mutation$CreateCustomerAddress$createCustomerAddress$customFields {
  Mutation$CreateCustomerAddress$createCustomerAddress$customFields({
    this.area,
    this.$__typename = 'AddressCustomFields',
  });

  factory Mutation$CreateCustomerAddress$createCustomerAddress$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$area = json['area'];
    final l$$__typename = json['__typename'];
    return Mutation$CreateCustomerAddress$createCustomerAddress$customFields(
      area: (l$area as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? area;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$area = area;
    _resultData['area'] = l$area;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$area = area;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$area,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$CreateCustomerAddress$createCustomerAddress$customFields ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$area = area;
    final lOther$area = other.area;
    if (l$area != lOther$area) {
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

extension UtilityExtension$Mutation$CreateCustomerAddress$createCustomerAddress$customFields
    on Mutation$CreateCustomerAddress$createCustomerAddress$customFields {
  CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields<
          Mutation$CreateCustomerAddress$createCustomerAddress$customFields>
      get copyWith =>
          CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields<
    TRes> {
  factory CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields(
    Mutation$CreateCustomerAddress$createCustomerAddress$customFields instance,
    TRes Function(
            Mutation$CreateCustomerAddress$createCustomerAddress$customFields)
        then,
  ) = _CopyWithImpl$Mutation$CreateCustomerAddress$createCustomerAddress$customFields;

  factory CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$CreateCustomerAddress$createCustomerAddress$customFields;

  TRes call({
    String? area,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$CreateCustomerAddress$createCustomerAddress$customFields<
        TRes>
    implements
        CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields<
            TRes> {
  _CopyWithImpl$Mutation$CreateCustomerAddress$createCustomerAddress$customFields(
    this._instance,
    this._then,
  );

  final Mutation$CreateCustomerAddress$createCustomerAddress$customFields
      _instance;

  final TRes Function(
      Mutation$CreateCustomerAddress$createCustomerAddress$customFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? area = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$CreateCustomerAddress$createCustomerAddress$customFields(
        area: area == _undefined ? _instance.area : (area as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$CreateCustomerAddress$createCustomerAddress$customFields<
        TRes>
    implements
        CopyWith$Mutation$CreateCustomerAddress$createCustomerAddress$customFields<
            TRes> {
  _CopyWithStubImpl$Mutation$CreateCustomerAddress$createCustomerAddress$customFields(
      this._res);

  TRes _res;

  call({
    String? area,
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
            name: NameNode(value: 'customFields'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'area'),
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
    this.customFields,
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
    final l$customFields = json['customFields'];
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
      customFields: l$customFields == null
          ? null
          : Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields
              .fromJson((l$customFields as Map<String, dynamic>)),
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

  final Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields?
      customFields;

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
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
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
    final l$customFields = customFields;
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
      l$customFields,
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
    Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields?
        customFields,
    String? $__typename,
  });
  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<TRes>
      get country;
  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields<
      TRes> get customFields;
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
    Object? customFields = _undefined,
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
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields?),
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

  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields<
      TRes> get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields
            .stub(_then(_instance))
        : CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields(
            local$customFields, (e) => call(customFields: e));
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
    Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields?
        customFields,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country<TRes>
      get country =>
          CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$country
              .stub(_res);

  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields<
          TRes>
      get customFields =>
          CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields
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

class Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields {
  Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields({
    this.area,
    this.$__typename = 'AddressCustomFields',
  });

  factory Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$area = json['area'];
    final l$$__typename = json['__typename'];
    return Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields(
      area: (l$area as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? area;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$area = area;
    _resultData['area'] = l$area;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$area = area;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$area,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$area = area;
    final lOther$area = other.area;
    if (l$area != lOther$area) {
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

extension UtilityExtension$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields
    on Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields {
  CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields<
          Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields>
      get copyWith =>
          CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields<
    TRes> {
  factory CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields(
    Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields instance,
    TRes Function(
            Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields)
        then,
  ) = _CopyWithImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields;

  factory CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields;

  TRes call({
    String? area,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields<
        TRes>
    implements
        CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields<
            TRes> {
  _CopyWithImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields(
    this._instance,
    this._then,
  );

  final Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields
      _instance;

  final TRes Function(
      Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? area = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields(
        area: area == _undefined ? _instance.area : (area as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields<
        TRes>
    implements
        CopyWith$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields<
            TRes> {
  _CopyWithStubImpl$Mutation$UpdateCustomerAddress$updateCustomerAddress$customFields(
      this._res);

  TRes _res;

  call({
    String? area,
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

class Variables$Query$GetActiveCustomer {
  factory Variables$Query$GetActiveCustomer(
          {Input$OrderFilterParameter? orderStateFilter}) =>
      Variables$Query$GetActiveCustomer._({
        if (orderStateFilter != null) r'orderStateFilter': orderStateFilter,
      });

  Variables$Query$GetActiveCustomer._(this._$data);

  factory Variables$Query$GetActiveCustomer.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('orderStateFilter')) {
      final l$orderStateFilter = data['orderStateFilter'];
      result$data['orderStateFilter'] = l$orderStateFilter == null
          ? null
          : Input$OrderFilterParameter.fromJson(
              (l$orderStateFilter as Map<String, dynamic>));
    }
    return Variables$Query$GetActiveCustomer._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$OrderFilterParameter? get orderStateFilter =>
      (_$data['orderStateFilter'] as Input$OrderFilterParameter?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('orderStateFilter')) {
      final l$orderStateFilter = orderStateFilter;
      result$data['orderStateFilter'] = l$orderStateFilter?.toJson();
    }
    return result$data;
  }

  CopyWith$Variables$Query$GetActiveCustomer<Variables$Query$GetActiveCustomer>
      get copyWith => CopyWith$Variables$Query$GetActiveCustomer(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetActiveCustomer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$orderStateFilter = orderStateFilter;
    final lOther$orderStateFilter = other.orderStateFilter;
    if (_$data.containsKey('orderStateFilter') !=
        other._$data.containsKey('orderStateFilter')) {
      return false;
    }
    if (l$orderStateFilter != lOther$orderStateFilter) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$orderStateFilter = orderStateFilter;
    return Object.hashAll([
      _$data.containsKey('orderStateFilter') ? l$orderStateFilter : const {}
    ]);
  }
}

abstract class CopyWith$Variables$Query$GetActiveCustomer<TRes> {
  factory CopyWith$Variables$Query$GetActiveCustomer(
    Variables$Query$GetActiveCustomer instance,
    TRes Function(Variables$Query$GetActiveCustomer) then,
  ) = _CopyWithImpl$Variables$Query$GetActiveCustomer;

  factory CopyWith$Variables$Query$GetActiveCustomer.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetActiveCustomer;

  TRes call({Input$OrderFilterParameter? orderStateFilter});
}

class _CopyWithImpl$Variables$Query$GetActiveCustomer<TRes>
    implements CopyWith$Variables$Query$GetActiveCustomer<TRes> {
  _CopyWithImpl$Variables$Query$GetActiveCustomer(
    this._instance,
    this._then,
  );

  final Variables$Query$GetActiveCustomer _instance;

  final TRes Function(Variables$Query$GetActiveCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? orderStateFilter = _undefined}) =>
      _then(Variables$Query$GetActiveCustomer._({
        ..._instance._$data,
        if (orderStateFilter != _undefined)
          'orderStateFilter': (orderStateFilter as Input$OrderFilterParameter?),
      }));
}

class _CopyWithStubImpl$Variables$Query$GetActiveCustomer<TRes>
    implements CopyWith$Variables$Query$GetActiveCustomer<TRes> {
  _CopyWithStubImpl$Variables$Query$GetActiveCustomer(this._res);

  TRes _res;

  call({Input$OrderFilterParameter? orderStateFilter}) => _res;
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
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'orderStateFilter')),
        type: NamedTypeNode(
          name: NameNode(value: 'OrderFilterParameter'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
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
                name: NameNode(value: 'title'),
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
                name: NameNode(value: 'referredBy'),
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
                    name: NameNode(value: 'referrer'),
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
                    name: NameNode(value: 'createdAt'),
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
                    name: NameNode(value: 'location'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
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
                name: NameNode(value: 'groups'),
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
                    name: NameNode(value: 'province'),
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
                    name: NameNode(value: 'customFields'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                        name: NameNode(value: 'area'),
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
                name: NameNode(value: 'orders'),
                alias: null,
                arguments: [
                  ArgumentNode(
                    name: NameNode(value: 'options'),
                    value: ObjectValueNode(fields: [
                      ObjectFieldNode(
                        name: NameNode(value: 'take'),
                        value: IntValueNode(value: '10'),
                      ),
                      ObjectFieldNode(
                        name: NameNode(value: 'skip'),
                        value: IntValueNode(value: '0'),
                      ),
                      ObjectFieldNode(
                        name: NameNode(value: 'sort'),
                        value: ObjectValueNode(fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'orderPlacedAt'),
                            value: EnumValueNode(name: NameNode(value: 'DESC')),
                          )
                        ]),
                      ),
                      ObjectFieldNode(
                        name: NameNode(value: 'filter'),
                        value: VariableNode(
                            name: NameNode(value: 'orderStateFilter')),
                      ),
                    ]),
                  )
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
    Variables$Query$GetActiveCustomer? variables,
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
    Variables$Query$GetActiveCustomer? variables,
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
          variables: variables?.toJson() ?? {},
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
  FetchMoreOptions$Query$GetActiveCustomer({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$GetActiveCustomer? variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables?.toJson() ?? {},
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
    Variables$Query$GetActiveCustomer? variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryGetActiveCustomer),
          variables: variables?.toJson() ?? const {},
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$GetActiveCustomer? readQuery$GetActiveCustomer({
    Variables$Query$GetActiveCustomer? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation:
            graphql.Operation(document: documentNodeQueryGetActiveCustomer),
        variables: variables?.toJson() ?? const {},
      ),
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
    this.title,
    required this.createdAt,
    required this.emailAddress,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.referredBy,
    this.customFields,
    required this.groups,
    this.addresses,
    required this.orders,
  });

  factory Query$GetActiveCustomer$activeCustomer.fromJson(
      Map<String, dynamic> json) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$title = json['title'];
    final l$createdAt = json['createdAt'];
    final l$emailAddress = json['emailAddress'];
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$phoneNumber = json['phoneNumber'];
    final l$referredBy = json['referredBy'];
    final l$customFields = json['customFields'];
    final l$groups = json['groups'];
    final l$addresses = json['addresses'];
    final l$orders = json['orders'];
    return Query$GetActiveCustomer$activeCustomer(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      title: (l$title as String?),
      createdAt: DateTime.parse((l$createdAt as String)),
      emailAddress: (l$emailAddress as String),
      firstName: (l$firstName as String),
      lastName: (l$lastName as String),
      phoneNumber: (l$phoneNumber as String?),
      referredBy: l$referredBy == null
          ? null
          : Query$GetActiveCustomer$activeCustomer$referredBy.fromJson(
              (l$referredBy as Map<String, dynamic>)),
      customFields: l$customFields == null
          ? null
          : Query$GetActiveCustomer$activeCustomer$customFields.fromJson(
              (l$customFields as Map<String, dynamic>)),
      groups: (l$groups as List<dynamic>)
          .map((e) => Query$GetActiveCustomer$activeCustomer$groups.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
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

  final String? title;

  final DateTime createdAt;

  final String emailAddress;

  final String firstName;

  final String lastName;

  final String? phoneNumber;

  final Query$GetActiveCustomer$activeCustomer$referredBy? referredBy;

  final Query$GetActiveCustomer$activeCustomer$customFields? customFields;

  final List<Query$GetActiveCustomer$activeCustomer$groups> groups;

  final List<Query$GetActiveCustomer$activeCustomer$addresses>? addresses;

  final Query$GetActiveCustomer$activeCustomer$orders orders;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$emailAddress = emailAddress;
    _resultData['emailAddress'] = l$emailAddress;
    final l$firstName = firstName;
    _resultData['firstName'] = l$firstName;
    final l$lastName = lastName;
    _resultData['lastName'] = l$lastName;
    final l$phoneNumber = phoneNumber;
    _resultData['phoneNumber'] = l$phoneNumber;
    final l$referredBy = referredBy;
    _resultData['referredBy'] = l$referredBy?.toJson();
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
    final l$groups = groups;
    _resultData['groups'] = l$groups.map((e) => e.toJson()).toList();
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
    final l$title = title;
    final l$createdAt = createdAt;
    final l$emailAddress = emailAddress;
    final l$firstName = firstName;
    final l$lastName = lastName;
    final l$phoneNumber = phoneNumber;
    final l$referredBy = referredBy;
    final l$customFields = customFields;
    final l$groups = groups;
    final l$addresses = addresses;
    final l$orders = orders;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$title,
      l$createdAt,
      l$emailAddress,
      l$firstName,
      l$lastName,
      l$phoneNumber,
      l$referredBy,
      l$customFields,
      Object.hashAll(l$groups.map((v) => v)),
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
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
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
    final l$referredBy = referredBy;
    final lOther$referredBy = other.referredBy;
    if (l$referredBy != lOther$referredBy) {
      return false;
    }
    final l$customFields = customFields;
    final lOther$customFields = other.customFields;
    if (l$customFields != lOther$customFields) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (l$groups.length != lOther$groups.length) {
      return false;
    }
    for (int i = 0; i < l$groups.length; i++) {
      final l$groups$entry = l$groups[i];
      final lOther$groups$entry = lOther$groups[i];
      if (l$groups$entry != lOther$groups$entry) {
        return false;
      }
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
    String? title,
    DateTime? createdAt,
    String? emailAddress,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Query$GetActiveCustomer$activeCustomer$referredBy? referredBy,
    Query$GetActiveCustomer$activeCustomer$customFields? customFields,
    List<Query$GetActiveCustomer$activeCustomer$groups>? groups,
    List<Query$GetActiveCustomer$activeCustomer$addresses>? addresses,
    Query$GetActiveCustomer$activeCustomer$orders? orders,
  });
  CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy<TRes>
      get referredBy;
  CopyWith$Query$GetActiveCustomer$activeCustomer$customFields<TRes>
      get customFields;
  TRes groups(
      Iterable<Query$GetActiveCustomer$activeCustomer$groups> Function(
              Iterable<
                  CopyWith$Query$GetActiveCustomer$activeCustomer$groups<
                      Query$GetActiveCustomer$activeCustomer$groups>>)
          _fn);
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
    Object? title = _undefined,
    Object? createdAt = _undefined,
    Object? emailAddress = _undefined,
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? phoneNumber = _undefined,
    Object? referredBy = _undefined,
    Object? customFields = _undefined,
    Object? groups = _undefined,
    Object? addresses = _undefined,
    Object? orders = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer(
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
        id: id == _undefined || id == null ? _instance.id : (id as String),
        title: title == _undefined ? _instance.title : (title as String?),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
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
        referredBy: referredBy == _undefined
            ? _instance.referredBy
            : (referredBy
                as Query$GetActiveCustomer$activeCustomer$referredBy?),
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Query$GetActiveCustomer$activeCustomer$customFields?),
        groups: groups == _undefined || groups == null
            ? _instance.groups
            : (groups as List<Query$GetActiveCustomer$activeCustomer$groups>),
        addresses: addresses == _undefined
            ? _instance.addresses
            : (addresses
                as List<Query$GetActiveCustomer$activeCustomer$addresses>?),
        orders: orders == _undefined || orders == null
            ? _instance.orders
            : (orders as Query$GetActiveCustomer$activeCustomer$orders),
      ));

  CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy<TRes>
      get referredBy {
    final local$referredBy = _instance.referredBy;
    return local$referredBy == null
        ? CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy.stub(
            _then(_instance))
        : CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy(
            local$referredBy, (e) => call(referredBy: e));
  }

  CopyWith$Query$GetActiveCustomer$activeCustomer$customFields<TRes>
      get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Query$GetActiveCustomer$activeCustomer$customFields.stub(
            _then(_instance))
        : CopyWith$Query$GetActiveCustomer$activeCustomer$customFields(
            local$customFields, (e) => call(customFields: e));
  }

  TRes groups(
          Iterable<Query$GetActiveCustomer$activeCustomer$groups> Function(
                  Iterable<
                      CopyWith$Query$GetActiveCustomer$activeCustomer$groups<
                          Query$GetActiveCustomer$activeCustomer$groups>>)
              _fn) =>
      call(
          groups: _fn(_instance.groups.map(
              (e) => CopyWith$Query$GetActiveCustomer$activeCustomer$groups(
                    e,
                    (i) => i,
                  ))).toList());

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
    String? title,
    DateTime? createdAt,
    String? emailAddress,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Query$GetActiveCustomer$activeCustomer$referredBy? referredBy,
    Query$GetActiveCustomer$activeCustomer$customFields? customFields,
    List<Query$GetActiveCustomer$activeCustomer$groups>? groups,
    List<Query$GetActiveCustomer$activeCustomer$addresses>? addresses,
    Query$GetActiveCustomer$activeCustomer$orders? orders,
  }) =>
      _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy<TRes>
      get referredBy =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy.stub(_res);

  CopyWith$Query$GetActiveCustomer$activeCustomer$customFields<TRes>
      get customFields =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$customFields.stub(
              _res);

  groups(_fn) => _res;

  addresses(_fn) => _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer$orders<TRes> get orders =>
      CopyWith$Query$GetActiveCustomer$activeCustomer$orders.stub(_res);
}

class Query$GetActiveCustomer$activeCustomer$referredBy {
  Query$GetActiveCustomer$activeCustomer$referredBy({
    required this.id,
    required this.referrer,
    required this.status,
    required this.points,
    required this.createdAt,
    this.$__typename = 'Referral',
  });

  factory Query$GetActiveCustomer$activeCustomer$referredBy.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$referrer = json['referrer'];
    final l$status = json['status'];
    final l$points = json['points'];
    final l$createdAt = json['createdAt'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$referredBy(
      id: (l$id as String),
      referrer:
          Query$GetActiveCustomer$activeCustomer$referredBy$referrer.fromJson(
              (l$referrer as Map<String, dynamic>)),
      status: fromJson$Enum$ReferralStatus((l$status as String)),
      points: (l$points as int),
      createdAt: DateTime.parse((l$createdAt as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query$GetActiveCustomer$activeCustomer$referredBy$referrer referrer;

  final Enum$ReferralStatus status;

  final int points;

  final DateTime createdAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$referrer = referrer;
    _resultData['referrer'] = l$referrer.toJson();
    final l$status = status;
    _resultData['status'] = toJson$Enum$ReferralStatus(l$status);
    final l$points = points;
    _resultData['points'] = l$points;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$referrer = referrer;
    final l$status = status;
    final l$points = points;
    final l$createdAt = createdAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$referrer,
      l$status,
      l$points,
      l$createdAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetActiveCustomer$activeCustomer$referredBy ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$referrer = referrer;
    final lOther$referrer = other.referrer;
    if (l$referrer != lOther$referrer) {
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
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$referredBy
    on Query$GetActiveCustomer$activeCustomer$referredBy {
  CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy<
          Query$GetActiveCustomer$activeCustomer$referredBy>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy(
    Query$GetActiveCustomer$activeCustomer$referredBy instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$referredBy) then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$referredBy;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$referredBy;

  TRes call({
    String? id,
    Query$GetActiveCustomer$activeCustomer$referredBy$referrer? referrer,
    Enum$ReferralStatus? status,
    int? points,
    DateTime? createdAt,
    String? $__typename,
  });
  CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer<TRes>
      get referrer;
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$referredBy<TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy<TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$referredBy(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$referredBy _instance;

  final TRes Function(Query$GetActiveCustomer$activeCustomer$referredBy) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? referrer = _undefined,
    Object? status = _undefined,
    Object? points = _undefined,
    Object? createdAt = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$referredBy(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        referrer: referrer == _undefined || referrer == null
            ? _instance.referrer
            : (referrer
                as Query$GetActiveCustomer$activeCustomer$referredBy$referrer),
        status: status == _undefined || status == null
            ? _instance.status
            : (status as Enum$ReferralStatus),
        points: points == _undefined || points == null
            ? _instance.points
            : (points as int),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer<TRes>
      get referrer {
    final local$referrer = _instance.referrer;
    return CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer(
        local$referrer, (e) => call(referrer: e));
  }
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$referredBy<TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy<TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$referredBy(
      this._res);

  TRes _res;

  call({
    String? id,
    Query$GetActiveCustomer$activeCustomer$referredBy$referrer? referrer,
    Enum$ReferralStatus? status,
    int? points,
    DateTime? createdAt,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer<TRes>
      get referrer =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer
              .stub(_res);
}

class Query$GetActiveCustomer$activeCustomer$referredBy$referrer {
  Query$GetActiveCustomer$activeCustomer$referredBy$referrer({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.$__typename = 'Customer',
  });

  factory Query$GetActiveCustomer$activeCustomer$referredBy$referrer.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$referredBy$referrer(
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
    if (other is! Query$GetActiveCustomer$activeCustomer$referredBy$referrer ||
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$referredBy$referrer
    on Query$GetActiveCustomer$activeCustomer$referredBy$referrer {
  CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer<
          Query$GetActiveCustomer$activeCustomer$referredBy$referrer>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer(
    Query$GetActiveCustomer$activeCustomer$referredBy$referrer instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$referredBy$referrer)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$referredBy$referrer;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$referredBy$referrer;

  TRes call({
    String? id,
    String? firstName,
    String? lastName,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$referredBy$referrer<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$referredBy$referrer(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$referredBy$referrer _instance;

  final TRes Function(
      Query$GetActiveCustomer$activeCustomer$referredBy$referrer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$referredBy$referrer(
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

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$referredBy$referrer<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$referredBy$referrer<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$referredBy$referrer(
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

class Query$GetActiveCustomer$activeCustomer$customFields {
  Query$GetActiveCustomer$activeCustomer$customFields({
    this.location,
    this.loyaltyPointsAvailable,
    this.$__typename = 'CustomerCustomFields',
  });

  factory Query$GetActiveCustomer$activeCustomer$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$location = json['location'];
    final l$loyaltyPointsAvailable = json['loyaltyPointsAvailable'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$customFields(
      location: (l$location as String?),
      loyaltyPointsAvailable: (l$loyaltyPointsAvailable as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? location;

  final int? loyaltyPointsAvailable;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$location = location;
    _resultData['location'] = l$location;
    final l$loyaltyPointsAvailable = loyaltyPointsAvailable;
    _resultData['loyaltyPointsAvailable'] = l$loyaltyPointsAvailable;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$location = location;
    final l$loyaltyPointsAvailable = loyaltyPointsAvailable;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$location,
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
    final l$location = location;
    final lOther$location = other.location;
    if (l$location != lOther$location) {
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
    String? location,
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
    Object? location = _undefined,
    Object? loyaltyPointsAvailable = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$customFields(
        location:
            location == _undefined ? _instance.location : (location as String?),
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
    String? location,
    int? loyaltyPointsAvailable,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetActiveCustomer$activeCustomer$groups {
  Query$GetActiveCustomer$activeCustomer$groups({
    required this.id,
    required this.name,
    this.$__typename = 'CustomerGroup',
  });

  factory Query$GetActiveCustomer$activeCustomer$groups.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$groups(
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
    if (other is! Query$GetActiveCustomer$activeCustomer$groups ||
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$groups
    on Query$GetActiveCustomer$activeCustomer$groups {
  CopyWith$Query$GetActiveCustomer$activeCustomer$groups<
          Query$GetActiveCustomer$activeCustomer$groups>
      get copyWith => CopyWith$Query$GetActiveCustomer$activeCustomer$groups(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$groups<TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$groups(
    Query$GetActiveCustomer$activeCustomer$groups instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$groups) then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$groups;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$groups.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$groups;

  TRes call({
    String? id,
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$groups<TRes>
    implements CopyWith$Query$GetActiveCustomer$activeCustomer$groups<TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$groups(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$groups _instance;

  final TRes Function(Query$GetActiveCustomer$activeCustomer$groups) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$groups(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$groups<TRes>
    implements CopyWith$Query$GetActiveCustomer$activeCustomer$groups<TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$groups(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
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
    this.province,
    this.defaultShippingAddress,
    this.defaultBillingAddress,
    this.customFields,
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
    final l$province = json['province'];
    final l$defaultShippingAddress = json['defaultShippingAddress'];
    final l$defaultBillingAddress = json['defaultBillingAddress'];
    final l$customFields = json['customFields'];
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
      province: (l$province as String?),
      defaultShippingAddress: (l$defaultShippingAddress as bool?),
      defaultBillingAddress: (l$defaultBillingAddress as bool?),
      customFields: l$customFields == null
          ? null
          : Query$GetActiveCustomer$activeCustomer$addresses$customFields
              .fromJson((l$customFields as Map<String, dynamic>)),
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

  final String? province;

  final bool? defaultShippingAddress;

  final bool? defaultBillingAddress;

  final Query$GetActiveCustomer$activeCustomer$addresses$customFields?
      customFields;

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
    final l$province = province;
    _resultData['province'] = l$province;
    final l$defaultShippingAddress = defaultShippingAddress;
    _resultData['defaultShippingAddress'] = l$defaultShippingAddress;
    final l$defaultBillingAddress = defaultBillingAddress;
    _resultData['defaultBillingAddress'] = l$defaultBillingAddress;
    final l$customFields = customFields;
    _resultData['customFields'] = l$customFields?.toJson();
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
    final l$province = province;
    final l$defaultShippingAddress = defaultShippingAddress;
    final l$defaultBillingAddress = defaultBillingAddress;
    final l$customFields = customFields;
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
      l$province,
      l$defaultShippingAddress,
      l$defaultBillingAddress,
      l$customFields,
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
    final l$province = province;
    final lOther$province = other.province;
    if (l$province != lOther$province) {
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
    String? province,
    bool? defaultShippingAddress,
    bool? defaultBillingAddress,
    Query$GetActiveCustomer$activeCustomer$addresses$customFields? customFields,
    String? $__typename,
  });
  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country<TRes>
      get country;
  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields<TRes>
      get customFields;
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
    Object? province = _undefined,
    Object? defaultShippingAddress = _undefined,
    Object? defaultBillingAddress = _undefined,
    Object? customFields = _undefined,
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
        province:
            province == _undefined ? _instance.province : (province as String?),
        defaultShippingAddress: defaultShippingAddress == _undefined
            ? _instance.defaultShippingAddress
            : (defaultShippingAddress as bool?),
        defaultBillingAddress: defaultBillingAddress == _undefined
            ? _instance.defaultBillingAddress
            : (defaultBillingAddress as bool?),
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Query$GetActiveCustomer$activeCustomer$addresses$customFields?),
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

  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields<TRes>
      get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields
            .stub(_then(_instance))
        : CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields(
            local$customFields, (e) => call(customFields: e));
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
    String? province,
    bool? defaultShippingAddress,
    bool? defaultBillingAddress,
    Query$GetActiveCustomer$activeCustomer$addresses$customFields? customFields,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country<TRes>
      get country =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$country
              .stub(_res);

  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields<TRes>
      get customFields =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields
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

class Query$GetActiveCustomer$activeCustomer$addresses$customFields {
  Query$GetActiveCustomer$activeCustomer$addresses$customFields({
    this.area,
    this.$__typename = 'AddressCustomFields',
  });

  factory Query$GetActiveCustomer$activeCustomer$addresses$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$area = json['area'];
    final l$$__typename = json['__typename'];
    return Query$GetActiveCustomer$activeCustomer$addresses$customFields(
      area: (l$area as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? area;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$area = area;
    _resultData['area'] = l$area;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$area = area;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$area,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetActiveCustomer$activeCustomer$addresses$customFields ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$area = area;
    final lOther$area = other.area;
    if (l$area != lOther$area) {
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

extension UtilityExtension$Query$GetActiveCustomer$activeCustomer$addresses$customFields
    on Query$GetActiveCustomer$activeCustomer$addresses$customFields {
  CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields<
          Query$GetActiveCustomer$activeCustomer$addresses$customFields>
      get copyWith =>
          CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields<
    TRes> {
  factory CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields(
    Query$GetActiveCustomer$activeCustomer$addresses$customFields instance,
    TRes Function(Query$GetActiveCustomer$activeCustomer$addresses$customFields)
        then,
  ) = _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$addresses$customFields;

  factory CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$addresses$customFields;

  TRes call({
    String? area,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$addresses$customFields<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields<
            TRes> {
  _CopyWithImpl$Query$GetActiveCustomer$activeCustomer$addresses$customFields(
    this._instance,
    this._then,
  );

  final Query$GetActiveCustomer$activeCustomer$addresses$customFields _instance;

  final TRes Function(
      Query$GetActiveCustomer$activeCustomer$addresses$customFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? area = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetActiveCustomer$activeCustomer$addresses$customFields(
        area: area == _undefined ? _instance.area : (area as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$addresses$customFields<
        TRes>
    implements
        CopyWith$Query$GetActiveCustomer$activeCustomer$addresses$customFields<
            TRes> {
  _CopyWithStubImpl$Query$GetActiveCustomer$activeCustomer$addresses$customFields(
      this._res);

  TRes _res;

  call({
    String? area,
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

class Variables$Query$GetCustomerOrders {
  factory Variables$Query$GetCustomerOrders({
    required int skip,
    required int take,
    Input$OrderFilterParameter? orderStateFilter,
  }) =>
      Variables$Query$GetCustomerOrders._({
        r'skip': skip,
        r'take': take,
        if (orderStateFilter != null) r'orderStateFilter': orderStateFilter,
      });

  Variables$Query$GetCustomerOrders._(this._$data);

  factory Variables$Query$GetCustomerOrders.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$skip = data['skip'];
    result$data['skip'] = (l$skip as int);
    final l$take = data['take'];
    result$data['take'] = (l$take as int);
    if (data.containsKey('orderStateFilter')) {
      final l$orderStateFilter = data['orderStateFilter'];
      result$data['orderStateFilter'] = l$orderStateFilter == null
          ? null
          : Input$OrderFilterParameter.fromJson(
              (l$orderStateFilter as Map<String, dynamic>));
    }
    return Variables$Query$GetCustomerOrders._(result$data);
  }

  Map<String, dynamic> _$data;

  int get skip => (_$data['skip'] as int);

  int get take => (_$data['take'] as int);

  Input$OrderFilterParameter? get orderStateFilter =>
      (_$data['orderStateFilter'] as Input$OrderFilterParameter?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$skip = skip;
    result$data['skip'] = l$skip;
    final l$take = take;
    result$data['take'] = l$take;
    if (_$data.containsKey('orderStateFilter')) {
      final l$orderStateFilter = orderStateFilter;
      result$data['orderStateFilter'] = l$orderStateFilter?.toJson();
    }
    return result$data;
  }

  CopyWith$Variables$Query$GetCustomerOrders<Variables$Query$GetCustomerOrders>
      get copyWith => CopyWith$Variables$Query$GetCustomerOrders(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetCustomerOrders ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$skip = skip;
    final lOther$skip = other.skip;
    if (l$skip != lOther$skip) {
      return false;
    }
    final l$take = take;
    final lOther$take = other.take;
    if (l$take != lOther$take) {
      return false;
    }
    final l$orderStateFilter = orderStateFilter;
    final lOther$orderStateFilter = other.orderStateFilter;
    if (_$data.containsKey('orderStateFilter') !=
        other._$data.containsKey('orderStateFilter')) {
      return false;
    }
    if (l$orderStateFilter != lOther$orderStateFilter) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$skip = skip;
    final l$take = take;
    final l$orderStateFilter = orderStateFilter;
    return Object.hashAll([
      l$skip,
      l$take,
      _$data.containsKey('orderStateFilter') ? l$orderStateFilter : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$GetCustomerOrders<TRes> {
  factory CopyWith$Variables$Query$GetCustomerOrders(
    Variables$Query$GetCustomerOrders instance,
    TRes Function(Variables$Query$GetCustomerOrders) then,
  ) = _CopyWithImpl$Variables$Query$GetCustomerOrders;

  factory CopyWith$Variables$Query$GetCustomerOrders.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetCustomerOrders;

  TRes call({
    int? skip,
    int? take,
    Input$OrderFilterParameter? orderStateFilter,
  });
}

class _CopyWithImpl$Variables$Query$GetCustomerOrders<TRes>
    implements CopyWith$Variables$Query$GetCustomerOrders<TRes> {
  _CopyWithImpl$Variables$Query$GetCustomerOrders(
    this._instance,
    this._then,
  );

  final Variables$Query$GetCustomerOrders _instance;

  final TRes Function(Variables$Query$GetCustomerOrders) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? skip = _undefined,
    Object? take = _undefined,
    Object? orderStateFilter = _undefined,
  }) =>
      _then(Variables$Query$GetCustomerOrders._({
        ..._instance._$data,
        if (skip != _undefined && skip != null) 'skip': (skip as int),
        if (take != _undefined && take != null) 'take': (take as int),
        if (orderStateFilter != _undefined)
          'orderStateFilter': (orderStateFilter as Input$OrderFilterParameter?),
      }));
}

class _CopyWithStubImpl$Variables$Query$GetCustomerOrders<TRes>
    implements CopyWith$Variables$Query$GetCustomerOrders<TRes> {
  _CopyWithStubImpl$Variables$Query$GetCustomerOrders(this._res);

  TRes _res;

  call({
    int? skip,
    int? take,
    Input$OrderFilterParameter? orderStateFilter,
  }) =>
      _res;
}

class Query$GetCustomerOrders {
  Query$GetCustomerOrders({
    this.activeCustomer,
    this.$__typename = 'Query',
  });

  factory Query$GetCustomerOrders.fromJson(Map<String, dynamic> json) {
    final l$activeCustomer = json['activeCustomer'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders(
      activeCustomer: l$activeCustomer == null
          ? null
          : Query$GetCustomerOrders$activeCustomer.fromJson(
              (l$activeCustomer as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GetCustomerOrders$activeCustomer? activeCustomer;

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
    if (other is! Query$GetCustomerOrders || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$GetCustomerOrders on Query$GetCustomerOrders {
  CopyWith$Query$GetCustomerOrders<Query$GetCustomerOrders> get copyWith =>
      CopyWith$Query$GetCustomerOrders(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetCustomerOrders<TRes> {
  factory CopyWith$Query$GetCustomerOrders(
    Query$GetCustomerOrders instance,
    TRes Function(Query$GetCustomerOrders) then,
  ) = _CopyWithImpl$Query$GetCustomerOrders;

  factory CopyWith$Query$GetCustomerOrders.stub(TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders;

  TRes call({
    Query$GetCustomerOrders$activeCustomer? activeCustomer,
    String? $__typename,
  });
  CopyWith$Query$GetCustomerOrders$activeCustomer<TRes> get activeCustomer;
}

class _CopyWithImpl$Query$GetCustomerOrders<TRes>
    implements CopyWith$Query$GetCustomerOrders<TRes> {
  _CopyWithImpl$Query$GetCustomerOrders(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders _instance;

  final TRes Function(Query$GetCustomerOrders) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? activeCustomer = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCustomerOrders(
        activeCustomer: activeCustomer == _undefined
            ? _instance.activeCustomer
            : (activeCustomer as Query$GetCustomerOrders$activeCustomer?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetCustomerOrders$activeCustomer<TRes> get activeCustomer {
    final local$activeCustomer = _instance.activeCustomer;
    return local$activeCustomer == null
        ? CopyWith$Query$GetCustomerOrders$activeCustomer.stub(_then(_instance))
        : CopyWith$Query$GetCustomerOrders$activeCustomer(
            local$activeCustomer, (e) => call(activeCustomer: e));
  }
}

class _CopyWithStubImpl$Query$GetCustomerOrders<TRes>
    implements CopyWith$Query$GetCustomerOrders<TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders(this._res);

  TRes _res;

  call({
    Query$GetCustomerOrders$activeCustomer? activeCustomer,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetCustomerOrders$activeCustomer<TRes> get activeCustomer =>
      CopyWith$Query$GetCustomerOrders$activeCustomer.stub(_res);
}

const documentNodeQueryGetCustomerOrders = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetCustomerOrders'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'skip')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'take')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'orderStateFilter')),
        type: NamedTypeNode(
          name: NameNode(value: 'OrderFilterParameter'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
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
                arguments: [
                  ArgumentNode(
                    name: NameNode(value: 'options'),
                    value: ObjectValueNode(fields: [
                      ObjectFieldNode(
                        name: NameNode(value: 'skip'),
                        value: VariableNode(name: NameNode(value: 'skip')),
                      ),
                      ObjectFieldNode(
                        name: NameNode(value: 'take'),
                        value: VariableNode(name: NameNode(value: 'take')),
                      ),
                      ObjectFieldNode(
                        name: NameNode(value: 'sort'),
                        value: ObjectValueNode(fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'orderPlacedAt'),
                            value: EnumValueNode(name: NameNode(value: 'DESC')),
                          )
                        ]),
                      ),
                      ObjectFieldNode(
                        name: NameNode(value: 'filter'),
                        value: VariableNode(
                            name: NameNode(value: 'orderStateFilter')),
                      ),
                    ]),
                  )
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
Query$GetCustomerOrders _parserFn$Query$GetCustomerOrders(
        Map<String, dynamic> data) =>
    Query$GetCustomerOrders.fromJson(data);
typedef OnQueryComplete$Query$GetCustomerOrders = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GetCustomerOrders?,
);

class Options$Query$GetCustomerOrders
    extends graphql.QueryOptions<Query$GetCustomerOrders> {
  Options$Query$GetCustomerOrders({
    String? operationName,
    required Variables$Query$GetCustomerOrders variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetCustomerOrders? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetCustomerOrders? onComplete,
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
                        : _parserFn$Query$GetCustomerOrders(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetCustomerOrders,
          parserFn: _parserFn$Query$GetCustomerOrders,
        );

  final OnQueryComplete$Query$GetCustomerOrders? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetCustomerOrders
    extends graphql.WatchQueryOptions<Query$GetCustomerOrders> {
  WatchOptions$Query$GetCustomerOrders({
    String? operationName,
    required Variables$Query$GetCustomerOrders variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetCustomerOrders? typedOptimisticResult,
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
          document: documentNodeQueryGetCustomerOrders,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetCustomerOrders,
        );
}

class FetchMoreOptions$Query$GetCustomerOrders
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetCustomerOrders({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetCustomerOrders variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryGetCustomerOrders,
        );
}

extension ClientExtension$Query$GetCustomerOrders on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetCustomerOrders>> query$GetCustomerOrders(
          Options$Query$GetCustomerOrders options) async =>
      await this.query(options);
  graphql.ObservableQuery<Query$GetCustomerOrders> watchQuery$GetCustomerOrders(
          WatchOptions$Query$GetCustomerOrders options) =>
      this.watchQuery(options);
  void writeQuery$GetCustomerOrders({
    required Query$GetCustomerOrders data,
    required Variables$Query$GetCustomerOrders variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryGetCustomerOrders),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$GetCustomerOrders? readQuery$GetCustomerOrders({
    required Variables$Query$GetCustomerOrders variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation:
            graphql.Operation(document: documentNodeQueryGetCustomerOrders),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetCustomerOrders.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetCustomerOrders>
    useQuery$GetCustomerOrders(Options$Query$GetCustomerOrders options) =>
        graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$GetCustomerOrders>
    useWatchQuery$GetCustomerOrders(
            WatchOptions$Query$GetCustomerOrders options) =>
        graphql_flutter.useWatchQuery(options);

class Query$GetCustomerOrders$Widget
    extends graphql_flutter.Query<Query$GetCustomerOrders> {
  Query$GetCustomerOrders$Widget({
    widgets.Key? key,
    required Options$Query$GetCustomerOrders options,
    required graphql_flutter.QueryBuilder<Query$GetCustomerOrders> builder,
  }) : super(
          key: key,
          options: options,
          builder: builder,
        );
}

class Query$GetCustomerOrders$activeCustomer {
  Query$GetCustomerOrders$activeCustomer({
    this.$__typename = 'Customer',
    required this.orders,
  });

  factory Query$GetCustomerOrders$activeCustomer.fromJson(
      Map<String, dynamic> json) {
    final l$$__typename = json['__typename'];
    final l$orders = json['orders'];
    return Query$GetCustomerOrders$activeCustomer(
      $__typename: (l$$__typename as String),
      orders: Query$GetCustomerOrders$activeCustomer$orders.fromJson(
          (l$orders as Map<String, dynamic>)),
    );
  }

  final String $__typename;

  final Query$GetCustomerOrders$activeCustomer$orders orders;

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
    if (other is! Query$GetCustomerOrders$activeCustomer ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer
    on Query$GetCustomerOrders$activeCustomer {
  CopyWith$Query$GetCustomerOrders$activeCustomer<
          Query$GetCustomerOrders$activeCustomer>
      get copyWith => CopyWith$Query$GetCustomerOrders$activeCustomer(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer<TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer(
    Query$GetCustomerOrders$activeCustomer instance,
    TRes Function(Query$GetCustomerOrders$activeCustomer) then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer.stub(TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer;

  TRes call({
    String? $__typename,
    Query$GetCustomerOrders$activeCustomer$orders? orders,
  });
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders<TRes> get orders;
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer<TRes>
    implements CopyWith$Query$GetCustomerOrders$activeCustomer<TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer _instance;

  final TRes Function(Query$GetCustomerOrders$activeCustomer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? orders = _undefined,
  }) =>
      _then(Query$GetCustomerOrders$activeCustomer(
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
        orders: orders == _undefined || orders == null
            ? _instance.orders
            : (orders as Query$GetCustomerOrders$activeCustomer$orders),
      ));

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders<TRes> get orders {
    final local$orders = _instance.orders;
    return CopyWith$Query$GetCustomerOrders$activeCustomer$orders(
        local$orders, (e) => call(orders: e));
  }
}

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer<TRes>
    implements CopyWith$Query$GetCustomerOrders$activeCustomer<TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer(this._res);

  TRes _res;

  call({
    String? $__typename,
    Query$GetCustomerOrders$activeCustomer$orders? orders,
  }) =>
      _res;

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders<TRes> get orders =>
      CopyWith$Query$GetCustomerOrders$activeCustomer$orders.stub(_res);
}

class Query$GetCustomerOrders$activeCustomer$orders {
  Query$GetCustomerOrders$activeCustomer$orders({
    required this.totalItems,
    required this.items,
    this.$__typename = 'OrderList',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders.fromJson(
      Map<String, dynamic> json) {
    final l$totalItems = json['totalItems'];
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders(
      totalItems: (l$totalItems as int),
      items: (l$items as List<dynamic>)
          .map((e) =>
              Query$GetCustomerOrders$activeCustomer$orders$items.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int totalItems;

  final List<Query$GetCustomerOrders$activeCustomer$orders$items> items;

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
    if (other is! Query$GetCustomerOrders$activeCustomer$orders ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders
    on Query$GetCustomerOrders$activeCustomer$orders {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders<
          Query$GetCustomerOrders$activeCustomer$orders>
      get copyWith => CopyWith$Query$GetCustomerOrders$activeCustomer$orders(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders<TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders(
    Query$GetCustomerOrders$activeCustomer$orders instance,
    TRes Function(Query$GetCustomerOrders$activeCustomer$orders) then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders;

  TRes call({
    int? totalItems,
    List<Query$GetCustomerOrders$activeCustomer$orders$items>? items,
    String? $__typename,
  });
  TRes items(
      Iterable<Query$GetCustomerOrders$activeCustomer$orders$items> Function(
              Iterable<
                  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items<
                      Query$GetCustomerOrders$activeCustomer$orders$items>>)
          _fn);
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders<TRes>
    implements CopyWith$Query$GetCustomerOrders$activeCustomer$orders<TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders _instance;

  final TRes Function(Query$GetCustomerOrders$activeCustomer$orders) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? totalItems = _undefined,
    Object? items = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCustomerOrders$activeCustomer$orders(
        totalItems: totalItems == _undefined || totalItems == null
            ? _instance.totalItems
            : (totalItems as int),
        items: items == _undefined || items == null
            ? _instance.items
            : (items
                as List<Query$GetCustomerOrders$activeCustomer$orders$items>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes items(
          Iterable<Query$GetCustomerOrders$activeCustomer$orders$items> Function(
                  Iterable<
                      CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items<
                          Query$GetCustomerOrders$activeCustomer$orders$items>>)
              _fn) =>
      call(
          items: _fn(_instance.items.map((e) =>
              CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders<TRes>
    implements CopyWith$Query$GetCustomerOrders$activeCustomer$orders<TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders(this._res);

  TRes _res;

  call({
    int? totalItems,
    List<Query$GetCustomerOrders$activeCustomer$orders$items>? items,
    String? $__typename,
  }) =>
      _res;

  items(_fn) => _res;
}

class Query$GetCustomerOrders$activeCustomer$orders$items {
  Query$GetCustomerOrders$activeCustomer$orders$items({
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

  factory Query$GetCustomerOrders$activeCustomer$orders$items.fromJson(
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
    return Query$GetCustomerOrders$activeCustomer$orders$items(
      id: (l$id as String),
      currencyCode: fromJson$Enum$CurrencyCode((l$currencyCode as String)),
      orderPlacedAt: l$orderPlacedAt == null
          ? null
          : DateTime.parse((l$orderPlacedAt as String)),
      lines: (l$lines as List<dynamic>)
          .map((e) => Query$GetCustomerOrders$activeCustomer$orders$items$lines
              .fromJson((e as Map<String, dynamic>)))
          .toList(),
      active: (l$active as bool),
      discounts: (l$discounts as List<dynamic>)
          .map((e) =>
              Query$GetCustomerOrders$activeCustomer$orders$items$discounts
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      code: (l$code as String),
      state: (l$state as String),
      customer: l$customer == null
          ? null
          : Query$GetCustomerOrders$activeCustomer$orders$items$customer
              .fromJson((l$customer as Map<String, dynamic>)),
      shippingAddress: l$shippingAddress == null
          ? null
          : Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress
              .fromJson((l$shippingAddress as Map<String, dynamic>)),
      surcharges: (l$surcharges as List<dynamic>)
          .map((e) =>
              Query$GetCustomerOrders$activeCustomer$orders$items$surcharges
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      couponCodes:
          (l$couponCodes as List<dynamic>).map((e) => (e as String)).toList(),
      payments: (l$payments as List<dynamic>?)
          ?.map((e) =>
              Query$GetCustomerOrders$activeCustomer$orders$items$payments
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      totalQuantity: (l$totalQuantity as int),
      totalWithTax: (l$totalWithTax as num).toDouble(),
      billingAddress: l$billingAddress == null
          ? null
          : Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress
              .fromJson((l$billingAddress as Map<String, dynamic>)),
      customFields: l$customFields == null
          ? null
          : Query$GetCustomerOrders$activeCustomer$orders$items$customFields
              .fromJson((l$customFields as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$CurrencyCode currencyCode;

  final DateTime? orderPlacedAt;

  final List<Query$GetCustomerOrders$activeCustomer$orders$items$lines> lines;

  final bool active;

  final List<Query$GetCustomerOrders$activeCustomer$orders$items$discounts>
      discounts;

  final String code;

  final String state;

  final Query$GetCustomerOrders$activeCustomer$orders$items$customer? customer;

  final Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress?
      shippingAddress;

  final List<Query$GetCustomerOrders$activeCustomer$orders$items$surcharges>
      surcharges;

  final List<String> couponCodes;

  final List<Query$GetCustomerOrders$activeCustomer$orders$items$payments>?
      payments;

  final int totalQuantity;

  final double totalWithTax;

  final Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress?
      billingAddress;

  final Query$GetCustomerOrders$activeCustomer$orders$items$customFields?
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
    if (other is! Query$GetCustomerOrders$activeCustomer$orders$items ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items
    on Query$GetCustomerOrders$activeCustomer$orders$items {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items<
          Query$GetCustomerOrders$activeCustomer$orders$items>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items(
    Query$GetCustomerOrders$activeCustomer$orders$items instance,
    TRes Function(Query$GetCustomerOrders$activeCustomer$orders$items) then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items;

  TRes call({
    String? id,
    Enum$CurrencyCode? currencyCode,
    DateTime? orderPlacedAt,
    List<Query$GetCustomerOrders$activeCustomer$orders$items$lines>? lines,
    bool? active,
    List<Query$GetCustomerOrders$activeCustomer$orders$items$discounts>?
        discounts,
    String? code,
    String? state,
    Query$GetCustomerOrders$activeCustomer$orders$items$customer? customer,
    Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress?
        shippingAddress,
    List<Query$GetCustomerOrders$activeCustomer$orders$items$surcharges>?
        surcharges,
    List<String>? couponCodes,
    List<Query$GetCustomerOrders$activeCustomer$orders$items$payments>?
        payments,
    int? totalQuantity,
    double? totalWithTax,
    Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress?
        billingAddress,
    Query$GetCustomerOrders$activeCustomer$orders$items$customFields?
        customFields,
    String? $__typename,
  });
  TRes lines(
      Iterable<Query$GetCustomerOrders$activeCustomer$orders$items$lines> Function(
              Iterable<
                  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines<
                      Query$GetCustomerOrders$activeCustomer$orders$items$lines>>)
          _fn);
  TRes discounts(
      Iterable<Query$GetCustomerOrders$activeCustomer$orders$items$discounts> Function(
              Iterable<
                  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$discounts<
                      Query$GetCustomerOrders$activeCustomer$orders$items$discounts>>)
          _fn);
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer<TRes>
      get customer;
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress<
      TRes> get shippingAddress;
  TRes surcharges(
      Iterable<Query$GetCustomerOrders$activeCustomer$orders$items$surcharges> Function(
              Iterable<
                  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges<
                      Query$GetCustomerOrders$activeCustomer$orders$items$surcharges>>)
          _fn);
  TRes payments(
      Iterable<Query$GetCustomerOrders$activeCustomer$orders$items$payments>? Function(
              Iterable<
                  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$payments<
                      Query$GetCustomerOrders$activeCustomer$orders$items$payments>>?)
          _fn);
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress<
      TRes> get billingAddress;
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields<
      TRes> get customFields;
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items<TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items<TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items _instance;

  final TRes Function(Query$GetCustomerOrders$activeCustomer$orders$items)
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
      _then(Query$GetCustomerOrders$activeCustomer$orders$items(
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
                Query$GetCustomerOrders$activeCustomer$orders$items$lines>),
        active: active == _undefined || active == null
            ? _instance.active
            : (active as bool),
        discounts: discounts == _undefined || discounts == null
            ? _instance.discounts
            : (discounts as List<
                Query$GetCustomerOrders$activeCustomer$orders$items$discounts>),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        state: state == _undefined || state == null
            ? _instance.state
            : (state as String),
        customer: customer == _undefined
            ? _instance.customer
            : (customer
                as Query$GetCustomerOrders$activeCustomer$orders$items$customer?),
        shippingAddress: shippingAddress == _undefined
            ? _instance.shippingAddress
            : (shippingAddress
                as Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress?),
        surcharges: surcharges == _undefined || surcharges == null
            ? _instance.surcharges
            : (surcharges as List<
                Query$GetCustomerOrders$activeCustomer$orders$items$surcharges>),
        couponCodes: couponCodes == _undefined || couponCodes == null
            ? _instance.couponCodes
            : (couponCodes as List<String>),
        payments: payments == _undefined
            ? _instance.payments
            : (payments as List<
                Query$GetCustomerOrders$activeCustomer$orders$items$payments>?),
        totalQuantity: totalQuantity == _undefined || totalQuantity == null
            ? _instance.totalQuantity
            : (totalQuantity as int),
        totalWithTax: totalWithTax == _undefined || totalWithTax == null
            ? _instance.totalWithTax
            : (totalWithTax as double),
        billingAddress: billingAddress == _undefined
            ? _instance.billingAddress
            : (billingAddress
                as Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress?),
        customFields: customFields == _undefined
            ? _instance.customFields
            : (customFields
                as Query$GetCustomerOrders$activeCustomer$orders$items$customFields?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes lines(
          Iterable<Query$GetCustomerOrders$activeCustomer$orders$items$lines> Function(
                  Iterable<
                      CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines<
                          Query$GetCustomerOrders$activeCustomer$orders$items$lines>>)
              _fn) =>
      call(
          lines: _fn(_instance.lines.map((e) =>
              CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines(
                e,
                (i) => i,
              ))).toList());

  TRes discounts(
          Iterable<Query$GetCustomerOrders$activeCustomer$orders$items$discounts> Function(
                  Iterable<
                      CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$discounts<
                          Query$GetCustomerOrders$activeCustomer$orders$items$discounts>>)
              _fn) =>
      call(
          discounts: _fn(_instance.discounts.map((e) =>
              CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$discounts(
                e,
                (i) => i,
              ))).toList());

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer<TRes>
      get customer {
    final local$customer = _instance.customer;
    return local$customer == null
        ? CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer
            .stub(_then(_instance))
        : CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer(
            local$customer, (e) => call(customer: e));
  }

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress<
      TRes> get shippingAddress {
    final local$shippingAddress = _instance.shippingAddress;
    return local$shippingAddress == null
        ? CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress
            .stub(_then(_instance))
        : CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress(
            local$shippingAddress, (e) => call(shippingAddress: e));
  }

  TRes surcharges(
          Iterable<Query$GetCustomerOrders$activeCustomer$orders$items$surcharges> Function(
                  Iterable<
                      CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges<
                          Query$GetCustomerOrders$activeCustomer$orders$items$surcharges>>)
              _fn) =>
      call(
          surcharges: _fn(_instance.surcharges.map((e) =>
              CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges(
                e,
                (i) => i,
              ))).toList());

  TRes payments(
          Iterable<Query$GetCustomerOrders$activeCustomer$orders$items$payments>? Function(
                  Iterable<
                      CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$payments<
                          Query$GetCustomerOrders$activeCustomer$orders$items$payments>>?)
              _fn) =>
      call(
          payments: _fn(_instance.payments?.map((e) =>
              CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$payments(
                e,
                (i) => i,
              )))?.toList());

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress<
      TRes> get billingAddress {
    final local$billingAddress = _instance.billingAddress;
    return local$billingAddress == null
        ? CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress
            .stub(_then(_instance))
        : CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress(
            local$billingAddress, (e) => call(billingAddress: e));
  }

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields<
      TRes> get customFields {
    final local$customFields = _instance.customFields;
    return local$customFields == null
        ? CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields
            .stub(_then(_instance))
        : CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields(
            local$customFields, (e) => call(customFields: e));
  }
}

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items<TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items(
      this._res);

  TRes _res;

  call({
    String? id,
    Enum$CurrencyCode? currencyCode,
    DateTime? orderPlacedAt,
    List<Query$GetCustomerOrders$activeCustomer$orders$items$lines>? lines,
    bool? active,
    List<Query$GetCustomerOrders$activeCustomer$orders$items$discounts>?
        discounts,
    String? code,
    String? state,
    Query$GetCustomerOrders$activeCustomer$orders$items$customer? customer,
    Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress?
        shippingAddress,
    List<Query$GetCustomerOrders$activeCustomer$orders$items$surcharges>?
        surcharges,
    List<String>? couponCodes,
    List<Query$GetCustomerOrders$activeCustomer$orders$items$payments>?
        payments,
    int? totalQuantity,
    double? totalWithTax,
    Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress?
        billingAddress,
    Query$GetCustomerOrders$activeCustomer$orders$items$customFields?
        customFields,
    String? $__typename,
  }) =>
      _res;

  lines(_fn) => _res;

  discounts(_fn) => _res;

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer<TRes>
      get customer =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer
              .stub(_res);

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress<
          TRes>
      get shippingAddress =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress
              .stub(_res);

  surcharges(_fn) => _res;

  payments(_fn) => _res;

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress<
          TRes>
      get billingAddress =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress
              .stub(_res);

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields<
          TRes>
      get customFields =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields
              .stub(_res);
}

class Query$GetCustomerOrders$activeCustomer$orders$items$lines {
  Query$GetCustomerOrders$activeCustomer$orders$items$lines({
    required this.id,
    required this.quantity,
    required this.productVariant,
    this.featuredAsset,
    this.$__typename = 'OrderLine',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders$items$lines.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$quantity = json['quantity'];
    final l$productVariant = json['productVariant'];
    final l$featuredAsset = json['featuredAsset'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders$items$lines(
      id: (l$id as String),
      quantity: (l$quantity as int),
      productVariant:
          Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant
              .fromJson((l$productVariant as Map<String, dynamic>)),
      featuredAsset: l$featuredAsset == null
          ? null
          : Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset
              .fromJson((l$featuredAsset as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int quantity;

  final Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant
      productVariant;

  final Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset?
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
    if (other is! Query$GetCustomerOrders$activeCustomer$orders$items$lines ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items$lines
    on Query$GetCustomerOrders$activeCustomer$orders$items$lines {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines<
          Query$GetCustomerOrders$activeCustomer$orders$items$lines>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines(
    Query$GetCustomerOrders$activeCustomer$orders$items$lines instance,
    TRes Function(Query$GetCustomerOrders$activeCustomer$orders$items$lines)
        then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines;

  TRes call({
    String? id,
    int? quantity,
    Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant?
        productVariant,
    Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset?
        featuredAsset,
    String? $__typename,
  });
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant<
      TRes> get productVariant;
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset<
      TRes> get featuredAsset;
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines<
            TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items$lines _instance;

  final TRes Function(Query$GetCustomerOrders$activeCustomer$orders$items$lines)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? quantity = _undefined,
    Object? productVariant = _undefined,
    Object? featuredAsset = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCustomerOrders$activeCustomer$orders$items$lines(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        quantity: quantity == _undefined || quantity == null
            ? _instance.quantity
            : (quantity as int),
        productVariant: productVariant == _undefined || productVariant == null
            ? _instance.productVariant
            : (productVariant
                as Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant),
        featuredAsset: featuredAsset == _undefined
            ? _instance.featuredAsset
            : (featuredAsset
                as Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant<
      TRes> get productVariant {
    final local$productVariant = _instance.productVariant;
    return CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant(
        local$productVariant, (e) => call(productVariant: e));
  }

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset<
      TRes> get featuredAsset {
    final local$featuredAsset = _instance.featuredAsset;
    return local$featuredAsset == null
        ? CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset
            .stub(_then(_instance))
        : CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset(
            local$featuredAsset, (e) => call(featuredAsset: e));
  }
}

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines<
            TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines(
      this._res);

  TRes _res;

  call({
    String? id,
    int? quantity,
    Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant?
        productVariant,
    Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset?
        featuredAsset,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant<
          TRes>
      get productVariant =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant
              .stub(_res);

  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset<
          TRes>
      get featuredAsset =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset
              .stub(_res);
}

class Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant {
  Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant({
    required this.name,
    this.$__typename = 'ProductVariant',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant.fromJson(
      Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant(
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
            is! Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant
    on Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant<
          Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant(
    Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant
        instance,
    TRes Function(
            Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant)
        then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant;

  TRes call({
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant<
            TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant
      _instance;

  final TRes Function(
          Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant(
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant<
            TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$productVariant(
      this._res);

  TRes _res;

  call({
    String? name,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset {
  Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset({
    required this.name,
    required this.preview,
    this.$__typename = 'Asset',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset.fromJson(
      Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$preview = json['preview'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset(
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
            is! Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset
    on Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset<
          Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset(
    Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset
        instance,
    TRes Function(
            Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset)
        then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset;

  TRes call({
    String? name,
    String? preview,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset<
            TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset
      _instance;

  final TRes Function(
          Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? preview = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset(
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

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset<
            TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$lines$featuredAsset(
      this._res);

  TRes _res;

  call({
    String? name,
    String? preview,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetCustomerOrders$activeCustomer$orders$items$discounts {
  Query$GetCustomerOrders$activeCustomer$orders$items$discounts({
    required this.amount,
    this.$__typename = 'Discount',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders$items$discounts.fromJson(
      Map<String, dynamic> json) {
    final l$amount = json['amount'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders$items$discounts(
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
            is! Query$GetCustomerOrders$activeCustomer$orders$items$discounts ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items$discounts
    on Query$GetCustomerOrders$activeCustomer$orders$items$discounts {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$discounts<
          Query$GetCustomerOrders$activeCustomer$orders$items$discounts>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$discounts(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$discounts<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$discounts(
    Query$GetCustomerOrders$activeCustomer$orders$items$discounts instance,
    TRes Function(Query$GetCustomerOrders$activeCustomer$orders$items$discounts)
        then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$discounts;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$discounts.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$discounts;

  TRes call({
    double? amount,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$discounts<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$discounts<
            TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$discounts(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items$discounts _instance;

  final TRes Function(
      Query$GetCustomerOrders$activeCustomer$orders$items$discounts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? amount = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCustomerOrders$activeCustomer$orders$items$discounts(
        amount: amount == _undefined || amount == null
            ? _instance.amount
            : (amount as double),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$discounts<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$discounts<
            TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$discounts(
      this._res);

  TRes _res;

  call({
    double? amount,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetCustomerOrders$activeCustomer$orders$items$customer {
  Query$GetCustomerOrders$activeCustomer$orders$items$customer({
    required this.firstName,
    required this.lastName,
    this.$__typename = 'Customer',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders$items$customer.fromJson(
      Map<String, dynamic> json) {
    final l$firstName = json['firstName'];
    final l$lastName = json['lastName'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders$items$customer(
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
            is! Query$GetCustomerOrders$activeCustomer$orders$items$customer ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items$customer
    on Query$GetCustomerOrders$activeCustomer$orders$items$customer {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer<
          Query$GetCustomerOrders$activeCustomer$orders$items$customer>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer(
    Query$GetCustomerOrders$activeCustomer$orders$items$customer instance,
    TRes Function(Query$GetCustomerOrders$activeCustomer$orders$items$customer)
        then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customer;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customer;

  TRes call({
    String? firstName,
    String? lastName,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customer<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer<
            TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customer(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items$customer _instance;

  final TRes Function(
      Query$GetCustomerOrders$activeCustomer$orders$items$customer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? firstName = _undefined,
    Object? lastName = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCustomerOrders$activeCustomer$orders$items$customer(
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

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customer<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customer<
            TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customer(
      this._res);

  TRes _res;

  call({
    String? firstName,
    String? lastName,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress {
  Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress({
    this.country,
    this.city,
    this.phoneNumber,
    this.streetLine1,
    this.streetLine2,
    this.postalCode,
    this.fullName,
    this.$__typename = 'OrderAddress',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress.fromJson(
      Map<String, dynamic> json) {
    final l$country = json['country'];
    final l$city = json['city'];
    final l$phoneNumber = json['phoneNumber'];
    final l$streetLine1 = json['streetLine1'];
    final l$streetLine2 = json['streetLine2'];
    final l$postalCode = json['postalCode'];
    final l$fullName = json['fullName'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress(
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
            is! Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress
    on Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress<
          Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress(
    Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress
        instance,
    TRes Function(
            Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress)
        then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress;

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

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress<
            TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress
      _instance;

  final TRes Function(
          Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress)
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
      _then(Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress(
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

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress<
            TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$shippingAddress(
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

class Query$GetCustomerOrders$activeCustomer$orders$items$surcharges {
  Query$GetCustomerOrders$activeCustomer$orders$items$surcharges({
    required this.price,
    required this.priceWithTax,
    this.$__typename = 'Surcharge',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders$items$surcharges.fromJson(
      Map<String, dynamic> json) {
    final l$price = json['price'];
    final l$priceWithTax = json['priceWithTax'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders$items$surcharges(
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
            is! Query$GetCustomerOrders$activeCustomer$orders$items$surcharges ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges
    on Query$GetCustomerOrders$activeCustomer$orders$items$surcharges {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges<
          Query$GetCustomerOrders$activeCustomer$orders$items$surcharges>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges(
    Query$GetCustomerOrders$activeCustomer$orders$items$surcharges instance,
    TRes Function(
            Query$GetCustomerOrders$activeCustomer$orders$items$surcharges)
        then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges;

  TRes call({
    double? price,
    double? priceWithTax,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges<
            TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items$surcharges
      _instance;

  final TRes Function(
      Query$GetCustomerOrders$activeCustomer$orders$items$surcharges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? price = _undefined,
    Object? priceWithTax = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCustomerOrders$activeCustomer$orders$items$surcharges(
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

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges<
            TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$surcharges(
      this._res);

  TRes _res;

  call({
    double? price,
    double? priceWithTax,
    String? $__typename,
  }) =>
      _res;
}

class Query$GetCustomerOrders$activeCustomer$orders$items$payments {
  Query$GetCustomerOrders$activeCustomer$orders$items$payments({
    required this.state,
    required this.createdAt,
    required this.method,
    required this.amount,
    this.transactionId,
    this.$__typename = 'Payment',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders$items$payments.fromJson(
      Map<String, dynamic> json) {
    final l$state = json['state'];
    final l$createdAt = json['createdAt'];
    final l$method = json['method'];
    final l$amount = json['amount'];
    final l$transactionId = json['transactionId'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders$items$payments(
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
            is! Query$GetCustomerOrders$activeCustomer$orders$items$payments ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items$payments
    on Query$GetCustomerOrders$activeCustomer$orders$items$payments {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$payments<
          Query$GetCustomerOrders$activeCustomer$orders$items$payments>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$payments(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$payments<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$payments(
    Query$GetCustomerOrders$activeCustomer$orders$items$payments instance,
    TRes Function(Query$GetCustomerOrders$activeCustomer$orders$items$payments)
        then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$payments;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$payments.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$payments;

  TRes call({
    String? state,
    DateTime? createdAt,
    String? method,
    double? amount,
    String? transactionId,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$payments<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$payments<
            TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$payments(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items$payments _instance;

  final TRes Function(
      Query$GetCustomerOrders$activeCustomer$orders$items$payments) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? state = _undefined,
    Object? createdAt = _undefined,
    Object? method = _undefined,
    Object? amount = _undefined,
    Object? transactionId = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCustomerOrders$activeCustomer$orders$items$payments(
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

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$payments<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$payments<
            TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$payments(
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

class Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress {
  Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress({
    this.postalCode,
    this.streetLine2,
    this.fullName,
    this.city,
    this.phoneNumber,
    this.streetLine1,
    this.$__typename = 'OrderAddress',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress.fromJson(
      Map<String, dynamic> json) {
    final l$postalCode = json['postalCode'];
    final l$streetLine2 = json['streetLine2'];
    final l$fullName = json['fullName'];
    final l$city = json['city'];
    final l$phoneNumber = json['phoneNumber'];
    final l$streetLine1 = json['streetLine1'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress(
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
            is! Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress
    on Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress<
          Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress(
    Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress instance,
    TRes Function(
            Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress)
        then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress;

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

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress<
            TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress
      _instance;

  final TRes Function(
      Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress) _then;

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
      _then(Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress(
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

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress<
            TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$billingAddress(
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

class Query$GetCustomerOrders$activeCustomer$orders$items$customFields {
  Query$GetCustomerOrders$activeCustomer$orders$items$customFields({
    this.loyaltyPointsUsed,
    this.loyaltyPointsEarned,
    this.otherInstructions,
    this.$__typename = 'OrderCustomFields',
  });

  factory Query$GetCustomerOrders$activeCustomer$orders$items$customFields.fromJson(
      Map<String, dynamic> json) {
    final l$loyaltyPointsUsed = json['loyaltyPointsUsed'];
    final l$loyaltyPointsEarned = json['loyaltyPointsEarned'];
    final l$otherInstructions = json['otherInstructions'];
    final l$$__typename = json['__typename'];
    return Query$GetCustomerOrders$activeCustomer$orders$items$customFields(
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
            is! Query$GetCustomerOrders$activeCustomer$orders$items$customFields ||
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

extension UtilityExtension$Query$GetCustomerOrders$activeCustomer$orders$items$customFields
    on Query$GetCustomerOrders$activeCustomer$orders$items$customFields {
  CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields<
          Query$GetCustomerOrders$activeCustomer$orders$items$customFields>
      get copyWith =>
          CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields<
    TRes> {
  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields(
    Query$GetCustomerOrders$activeCustomer$orders$items$customFields instance,
    TRes Function(
            Query$GetCustomerOrders$activeCustomer$orders$items$customFields)
        then,
  ) = _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customFields;

  factory CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customFields;

  TRes call({
    int? loyaltyPointsUsed,
    int? loyaltyPointsEarned,
    String? otherInstructions,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customFields<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields<
            TRes> {
  _CopyWithImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customFields(
    this._instance,
    this._then,
  );

  final Query$GetCustomerOrders$activeCustomer$orders$items$customFields
      _instance;

  final TRes Function(
      Query$GetCustomerOrders$activeCustomer$orders$items$customFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? loyaltyPointsUsed = _undefined,
    Object? loyaltyPointsEarned = _undefined,
    Object? otherInstructions = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetCustomerOrders$activeCustomer$orders$items$customFields(
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

class _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customFields<
        TRes>
    implements
        CopyWith$Query$GetCustomerOrders$activeCustomer$orders$items$customFields<
            TRes> {
  _CopyWithStubImpl$Query$GetCustomerOrders$activeCustomer$orders$items$customFields(
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

class Variables$Query$GetChannelsByPostalCode {
  factory Variables$Query$GetChannelsByPostalCode(
          {required String postalCode}) =>
      Variables$Query$GetChannelsByPostalCode._({
        r'postalCode': postalCode,
      });

  Variables$Query$GetChannelsByPostalCode._(this._$data);

  factory Variables$Query$GetChannelsByPostalCode.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postalCode = data['postalCode'];
    result$data['postalCode'] = (l$postalCode as String);
    return Variables$Query$GetChannelsByPostalCode._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postalCode => (_$data['postalCode'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postalCode = postalCode;
    result$data['postalCode'] = l$postalCode;
    return result$data;
  }

  CopyWith$Variables$Query$GetChannelsByPostalCode<
          Variables$Query$GetChannelsByPostalCode>
      get copyWith => CopyWith$Variables$Query$GetChannelsByPostalCode(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetChannelsByPostalCode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$postalCode = postalCode;
    final lOther$postalCode = other.postalCode;
    if (l$postalCode != lOther$postalCode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postalCode = postalCode;
    return Object.hashAll([l$postalCode]);
  }
}

abstract class CopyWith$Variables$Query$GetChannelsByPostalCode<TRes> {
  factory CopyWith$Variables$Query$GetChannelsByPostalCode(
    Variables$Query$GetChannelsByPostalCode instance,
    TRes Function(Variables$Query$GetChannelsByPostalCode) then,
  ) = _CopyWithImpl$Variables$Query$GetChannelsByPostalCode;

  factory CopyWith$Variables$Query$GetChannelsByPostalCode.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetChannelsByPostalCode;

  TRes call({String? postalCode});
}

class _CopyWithImpl$Variables$Query$GetChannelsByPostalCode<TRes>
    implements CopyWith$Variables$Query$GetChannelsByPostalCode<TRes> {
  _CopyWithImpl$Variables$Query$GetChannelsByPostalCode(
    this._instance,
    this._then,
  );

  final Variables$Query$GetChannelsByPostalCode _instance;

  final TRes Function(Variables$Query$GetChannelsByPostalCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postalCode = _undefined}) =>
      _then(Variables$Query$GetChannelsByPostalCode._({
        ..._instance._$data,
        if (postalCode != _undefined && postalCode != null)
          'postalCode': (postalCode as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$GetChannelsByPostalCode<TRes>
    implements CopyWith$Variables$Query$GetChannelsByPostalCode<TRes> {
  _CopyWithStubImpl$Variables$Query$GetChannelsByPostalCode(this._res);

  TRes _res;

  call({String? postalCode}) => _res;
}

class Query$GetChannelsByPostalCode {
  Query$GetChannelsByPostalCode({
    required this.getChannelsByPostalCode,
    this.$__typename = 'Query',
  });

  factory Query$GetChannelsByPostalCode.fromJson(Map<String, dynamic> json) {
    final l$getChannelsByPostalCode = json['getChannelsByPostalCode'];
    final l$$__typename = json['__typename'];
    return Query$GetChannelsByPostalCode(
      getChannelsByPostalCode: (l$getChannelsByPostalCode as List<dynamic>)
          .map((e) =>
              Query$GetChannelsByPostalCode$getChannelsByPostalCode.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$GetChannelsByPostalCode$getChannelsByPostalCode>
      getChannelsByPostalCode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$getChannelsByPostalCode = getChannelsByPostalCode;
    _resultData['getChannelsByPostalCode'] =
        l$getChannelsByPostalCode.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$getChannelsByPostalCode = getChannelsByPostalCode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$getChannelsByPostalCode.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetChannelsByPostalCode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$getChannelsByPostalCode = getChannelsByPostalCode;
    final lOther$getChannelsByPostalCode = other.getChannelsByPostalCode;
    if (l$getChannelsByPostalCode.length !=
        lOther$getChannelsByPostalCode.length) {
      return false;
    }
    for (int i = 0; i < l$getChannelsByPostalCode.length; i++) {
      final l$getChannelsByPostalCode$entry = l$getChannelsByPostalCode[i];
      final lOther$getChannelsByPostalCode$entry =
          lOther$getChannelsByPostalCode[i];
      if (l$getChannelsByPostalCode$entry !=
          lOther$getChannelsByPostalCode$entry) {
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

extension UtilityExtension$Query$GetChannelsByPostalCode
    on Query$GetChannelsByPostalCode {
  CopyWith$Query$GetChannelsByPostalCode<Query$GetChannelsByPostalCode>
      get copyWith => CopyWith$Query$GetChannelsByPostalCode(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetChannelsByPostalCode<TRes> {
  factory CopyWith$Query$GetChannelsByPostalCode(
    Query$GetChannelsByPostalCode instance,
    TRes Function(Query$GetChannelsByPostalCode) then,
  ) = _CopyWithImpl$Query$GetChannelsByPostalCode;

  factory CopyWith$Query$GetChannelsByPostalCode.stub(TRes res) =
      _CopyWithStubImpl$Query$GetChannelsByPostalCode;

  TRes call({
    List<Query$GetChannelsByPostalCode$getChannelsByPostalCode>?
        getChannelsByPostalCode,
    String? $__typename,
  });
  TRes getChannelsByPostalCode(
      Iterable<Query$GetChannelsByPostalCode$getChannelsByPostalCode> Function(
              Iterable<
                  CopyWith$Query$GetChannelsByPostalCode$getChannelsByPostalCode<
                      Query$GetChannelsByPostalCode$getChannelsByPostalCode>>)
          _fn);
}

class _CopyWithImpl$Query$GetChannelsByPostalCode<TRes>
    implements CopyWith$Query$GetChannelsByPostalCode<TRes> {
  _CopyWithImpl$Query$GetChannelsByPostalCode(
    this._instance,
    this._then,
  );

  final Query$GetChannelsByPostalCode _instance;

  final TRes Function(Query$GetChannelsByPostalCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? getChannelsByPostalCode = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetChannelsByPostalCode(
        getChannelsByPostalCode: getChannelsByPostalCode == _undefined ||
                getChannelsByPostalCode == null
            ? _instance.getChannelsByPostalCode
            : (getChannelsByPostalCode
                as List<Query$GetChannelsByPostalCode$getChannelsByPostalCode>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes getChannelsByPostalCode(
          Iterable<Query$GetChannelsByPostalCode$getChannelsByPostalCode> Function(
                  Iterable<
                      CopyWith$Query$GetChannelsByPostalCode$getChannelsByPostalCode<
                          Query$GetChannelsByPostalCode$getChannelsByPostalCode>>)
              _fn) =>
      call(
          getChannelsByPostalCode: _fn(_instance.getChannelsByPostalCode.map(
              (e) =>
                  CopyWith$Query$GetChannelsByPostalCode$getChannelsByPostalCode(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$GetChannelsByPostalCode<TRes>
    implements CopyWith$Query$GetChannelsByPostalCode<TRes> {
  _CopyWithStubImpl$Query$GetChannelsByPostalCode(this._res);

  TRes _res;

  call({
    List<Query$GetChannelsByPostalCode$getChannelsByPostalCode>?
        getChannelsByPostalCode,
    String? $__typename,
  }) =>
      _res;

  getChannelsByPostalCode(_fn) => _res;
}

const documentNodeQueryGetChannelsByPostalCode = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetChannelsByPostalCode'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'postalCode')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'getChannelsByPostalCode'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'postalCode'),
            value: VariableNode(name: NameNode(value: 'postalCode')),
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
            name: NameNode(value: 'name'),
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
]);
Query$GetChannelsByPostalCode _parserFn$Query$GetChannelsByPostalCode(
        Map<String, dynamic> data) =>
    Query$GetChannelsByPostalCode.fromJson(data);
typedef OnQueryComplete$Query$GetChannelsByPostalCode = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GetChannelsByPostalCode?,
);

class Options$Query$GetChannelsByPostalCode
    extends graphql.QueryOptions<Query$GetChannelsByPostalCode> {
  Options$Query$GetChannelsByPostalCode({
    String? operationName,
    required Variables$Query$GetChannelsByPostalCode variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetChannelsByPostalCode? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetChannelsByPostalCode? onComplete,
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
                        : _parserFn$Query$GetChannelsByPostalCode(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetChannelsByPostalCode,
          parserFn: _parserFn$Query$GetChannelsByPostalCode,
        );

  final OnQueryComplete$Query$GetChannelsByPostalCode? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetChannelsByPostalCode
    extends graphql.WatchQueryOptions<Query$GetChannelsByPostalCode> {
  WatchOptions$Query$GetChannelsByPostalCode({
    String? operationName,
    required Variables$Query$GetChannelsByPostalCode variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetChannelsByPostalCode? typedOptimisticResult,
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
          document: documentNodeQueryGetChannelsByPostalCode,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetChannelsByPostalCode,
        );
}

class FetchMoreOptions$Query$GetChannelsByPostalCode
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetChannelsByPostalCode({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetChannelsByPostalCode variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryGetChannelsByPostalCode,
        );
}

extension ClientExtension$Query$GetChannelsByPostalCode
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetChannelsByPostalCode>>
      query$GetChannelsByPostalCode(
              Options$Query$GetChannelsByPostalCode options) async =>
          await this.query(options);
  graphql.ObservableQuery<Query$GetChannelsByPostalCode>
      watchQuery$GetChannelsByPostalCode(
              WatchOptions$Query$GetChannelsByPostalCode options) =>
          this.watchQuery(options);
  void writeQuery$GetChannelsByPostalCode({
    required Query$GetChannelsByPostalCode data,
    required Variables$Query$GetChannelsByPostalCode variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(
              document: documentNodeQueryGetChannelsByPostalCode),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$GetChannelsByPostalCode? readQuery$GetChannelsByPostalCode({
    required Variables$Query$GetChannelsByPostalCode variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
            document: documentNodeQueryGetChannelsByPostalCode),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query$GetChannelsByPostalCode.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetChannelsByPostalCode>
    useQuery$GetChannelsByPostalCode(
            Options$Query$GetChannelsByPostalCode options) =>
        graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$GetChannelsByPostalCode>
    useWatchQuery$GetChannelsByPostalCode(
            WatchOptions$Query$GetChannelsByPostalCode options) =>
        graphql_flutter.useWatchQuery(options);

class Query$GetChannelsByPostalCode$Widget
    extends graphql_flutter.Query<Query$GetChannelsByPostalCode> {
  Query$GetChannelsByPostalCode$Widget({
    widgets.Key? key,
    required Options$Query$GetChannelsByPostalCode options,
    required graphql_flutter.QueryBuilder<Query$GetChannelsByPostalCode>
        builder,
  }) : super(
          key: key,
          options: options,
          builder: builder,
        );
}

class Query$GetChannelsByPostalCode$getChannelsByPostalCode {
  Query$GetChannelsByPostalCode$getChannelsByPostalCode({
    required this.id,
    required this.code,
    required this.token,
    required this.name,
    required this.type,
    this.$__typename = 'CustomerChannel',
  });

  factory Query$GetChannelsByPostalCode$getChannelsByPostalCode.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$token = json['token'];
    final l$name = json['name'];
    final l$type = json['type'];
    final l$$__typename = json['__typename'];
    return Query$GetChannelsByPostalCode$getChannelsByPostalCode(
      id: (l$id as String),
      code: (l$code as String),
      token: (l$token as String),
      name: (l$name as String),
      type: fromJson$Enum$ChannelTypeEnum((l$type as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String token;

  final String name;

  final Enum$ChannelTypeEnum type;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$token = token;
    _resultData['token'] = l$token;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$type = type;
    _resultData['type'] = toJson$Enum$ChannelTypeEnum(l$type);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$token = token;
    final l$name = name;
    final l$type = type;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$token,
      l$name,
      l$type,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetChannelsByPostalCode$getChannelsByPostalCode ||
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
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
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

extension UtilityExtension$Query$GetChannelsByPostalCode$getChannelsByPostalCode
    on Query$GetChannelsByPostalCode$getChannelsByPostalCode {
  CopyWith$Query$GetChannelsByPostalCode$getChannelsByPostalCode<
          Query$GetChannelsByPostalCode$getChannelsByPostalCode>
      get copyWith =>
          CopyWith$Query$GetChannelsByPostalCode$getChannelsByPostalCode(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetChannelsByPostalCode$getChannelsByPostalCode<
    TRes> {
  factory CopyWith$Query$GetChannelsByPostalCode$getChannelsByPostalCode(
    Query$GetChannelsByPostalCode$getChannelsByPostalCode instance,
    TRes Function(Query$GetChannelsByPostalCode$getChannelsByPostalCode) then,
  ) = _CopyWithImpl$Query$GetChannelsByPostalCode$getChannelsByPostalCode;

  factory CopyWith$Query$GetChannelsByPostalCode$getChannelsByPostalCode.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetChannelsByPostalCode$getChannelsByPostalCode;

  TRes call({
    String? id,
    String? code,
    String? token,
    String? name,
    Enum$ChannelTypeEnum? type,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetChannelsByPostalCode$getChannelsByPostalCode<TRes>
    implements
        CopyWith$Query$GetChannelsByPostalCode$getChannelsByPostalCode<TRes> {
  _CopyWithImpl$Query$GetChannelsByPostalCode$getChannelsByPostalCode(
    this._instance,
    this._then,
  );

  final Query$GetChannelsByPostalCode$getChannelsByPostalCode _instance;

  final TRes Function(Query$GetChannelsByPostalCode$getChannelsByPostalCode)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? token = _undefined,
    Object? name = _undefined,
    Object? type = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetChannelsByPostalCode$getChannelsByPostalCode(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        token: token == _undefined || token == null
            ? _instance.token
            : (token as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        type: type == _undefined || type == null
            ? _instance.type
            : (type as Enum$ChannelTypeEnum),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetChannelsByPostalCode$getChannelsByPostalCode<
        TRes>
    implements
        CopyWith$Query$GetChannelsByPostalCode$getChannelsByPostalCode<TRes> {
  _CopyWithStubImpl$Query$GetChannelsByPostalCode$getChannelsByPostalCode(
      this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    String? token,
    String? name,
    Enum$ChannelTypeEnum? type,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Query$GetChannelsByCustomerPhoneNumber {
  factory Variables$Query$GetChannelsByCustomerPhoneNumber(
          {required String phoneNumber}) =>
      Variables$Query$GetChannelsByCustomerPhoneNumber._({
        r'phoneNumber': phoneNumber,
      });

  Variables$Query$GetChannelsByCustomerPhoneNumber._(this._$data);

  factory Variables$Query$GetChannelsByCustomerPhoneNumber.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$phoneNumber = data['phoneNumber'];
    result$data['phoneNumber'] = (l$phoneNumber as String);
    return Variables$Query$GetChannelsByCustomerPhoneNumber._(result$data);
  }

  Map<String, dynamic> _$data;

  String get phoneNumber => (_$data['phoneNumber'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$phoneNumber = phoneNumber;
    result$data['phoneNumber'] = l$phoneNumber;
    return result$data;
  }

  CopyWith$Variables$Query$GetChannelsByCustomerPhoneNumber<
          Variables$Query$GetChannelsByCustomerPhoneNumber>
      get copyWith => CopyWith$Variables$Query$GetChannelsByCustomerPhoneNumber(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetChannelsByCustomerPhoneNumber ||
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

abstract class CopyWith$Variables$Query$GetChannelsByCustomerPhoneNumber<TRes> {
  factory CopyWith$Variables$Query$GetChannelsByCustomerPhoneNumber(
    Variables$Query$GetChannelsByCustomerPhoneNumber instance,
    TRes Function(Variables$Query$GetChannelsByCustomerPhoneNumber) then,
  ) = _CopyWithImpl$Variables$Query$GetChannelsByCustomerPhoneNumber;

  factory CopyWith$Variables$Query$GetChannelsByCustomerPhoneNumber.stub(
          TRes res) =
      _CopyWithStubImpl$Variables$Query$GetChannelsByCustomerPhoneNumber;

  TRes call({String? phoneNumber});
}

class _CopyWithImpl$Variables$Query$GetChannelsByCustomerPhoneNumber<TRes>
    implements CopyWith$Variables$Query$GetChannelsByCustomerPhoneNumber<TRes> {
  _CopyWithImpl$Variables$Query$GetChannelsByCustomerPhoneNumber(
    this._instance,
    this._then,
  );

  final Variables$Query$GetChannelsByCustomerPhoneNumber _instance;

  final TRes Function(Variables$Query$GetChannelsByCustomerPhoneNumber) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? phoneNumber = _undefined}) =>
      _then(Variables$Query$GetChannelsByCustomerPhoneNumber._({
        ..._instance._$data,
        if (phoneNumber != _undefined && phoneNumber != null)
          'phoneNumber': (phoneNumber as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$GetChannelsByCustomerPhoneNumber<TRes>
    implements CopyWith$Variables$Query$GetChannelsByCustomerPhoneNumber<TRes> {
  _CopyWithStubImpl$Variables$Query$GetChannelsByCustomerPhoneNumber(this._res);

  TRes _res;

  call({String? phoneNumber}) => _res;
}

class Query$GetChannelsByCustomerPhoneNumber {
  Query$GetChannelsByCustomerPhoneNumber({
    required this.getChannelsByCustomerPhoneNumber,
    this.$__typename = 'Query',
  });

  factory Query$GetChannelsByCustomerPhoneNumber.fromJson(
      Map<String, dynamic> json) {
    final l$getChannelsByCustomerPhoneNumber =
        json['getChannelsByCustomerPhoneNumber'];
    final l$$__typename = json['__typename'];
    return Query$GetChannelsByCustomerPhoneNumber(
      getChannelsByCustomerPhoneNumber: (l$getChannelsByCustomerPhoneNumber
              as List<dynamic>)
          .map((e) =>
              Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<
          Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber>
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
    if (other is! Query$GetChannelsByCustomerPhoneNumber ||
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

extension UtilityExtension$Query$GetChannelsByCustomerPhoneNumber
    on Query$GetChannelsByCustomerPhoneNumber {
  CopyWith$Query$GetChannelsByCustomerPhoneNumber<
          Query$GetChannelsByCustomerPhoneNumber>
      get copyWith => CopyWith$Query$GetChannelsByCustomerPhoneNumber(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetChannelsByCustomerPhoneNumber<TRes> {
  factory CopyWith$Query$GetChannelsByCustomerPhoneNumber(
    Query$GetChannelsByCustomerPhoneNumber instance,
    TRes Function(Query$GetChannelsByCustomerPhoneNumber) then,
  ) = _CopyWithImpl$Query$GetChannelsByCustomerPhoneNumber;

  factory CopyWith$Query$GetChannelsByCustomerPhoneNumber.stub(TRes res) =
      _CopyWithStubImpl$Query$GetChannelsByCustomerPhoneNumber;

  TRes call({
    List<Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber>?
        getChannelsByCustomerPhoneNumber,
    String? $__typename,
  });
  TRes getChannelsByCustomerPhoneNumber(
      Iterable<Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber> Function(
              Iterable<
                  CopyWith$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber<
                      Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber>>)
          _fn);
}

class _CopyWithImpl$Query$GetChannelsByCustomerPhoneNumber<TRes>
    implements CopyWith$Query$GetChannelsByCustomerPhoneNumber<TRes> {
  _CopyWithImpl$Query$GetChannelsByCustomerPhoneNumber(
    this._instance,
    this._then,
  );

  final Query$GetChannelsByCustomerPhoneNumber _instance;

  final TRes Function(Query$GetChannelsByCustomerPhoneNumber) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? getChannelsByCustomerPhoneNumber = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetChannelsByCustomerPhoneNumber(
        getChannelsByCustomerPhoneNumber: getChannelsByCustomerPhoneNumber ==
                    _undefined ||
                getChannelsByCustomerPhoneNumber == null
            ? _instance.getChannelsByCustomerPhoneNumber
            : (getChannelsByCustomerPhoneNumber as List<
                Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes getChannelsByCustomerPhoneNumber(
          Iterable<Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber> Function(
                  Iterable<
                      CopyWith$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber<
                          Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber>>)
              _fn) =>
      call(
          getChannelsByCustomerPhoneNumber: _fn(
              _instance.getChannelsByCustomerPhoneNumber.map((e) =>
                  CopyWith$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$GetChannelsByCustomerPhoneNumber<TRes>
    implements CopyWith$Query$GetChannelsByCustomerPhoneNumber<TRes> {
  _CopyWithStubImpl$Query$GetChannelsByCustomerPhoneNumber(this._res);

  TRes _res;

  call({
    List<Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber>?
        getChannelsByCustomerPhoneNumber,
    String? $__typename,
  }) =>
      _res;

  getChannelsByCustomerPhoneNumber(_fn) => _res;
}

const documentNodeQueryGetChannelsByCustomerPhoneNumber =
    DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetChannelsByCustomerPhoneNumber'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'phoneNumber')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'getChannelsByCustomerPhoneNumber'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'phoneNumber'),
            value: VariableNode(name: NameNode(value: 'phoneNumber')),
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
            name: NameNode(value: 'name'),
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
]);
Query$GetChannelsByCustomerPhoneNumber
    _parserFn$Query$GetChannelsByCustomerPhoneNumber(
            Map<String, dynamic> data) =>
        Query$GetChannelsByCustomerPhoneNumber.fromJson(data);
typedef OnQueryComplete$Query$GetChannelsByCustomerPhoneNumber = FutureOr<void>
    Function(
  Map<String, dynamic>?,
  Query$GetChannelsByCustomerPhoneNumber?,
);

class Options$Query$GetChannelsByCustomerPhoneNumber
    extends graphql.QueryOptions<Query$GetChannelsByCustomerPhoneNumber> {
  Options$Query$GetChannelsByCustomerPhoneNumber({
    String? operationName,
    required Variables$Query$GetChannelsByCustomerPhoneNumber variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetChannelsByCustomerPhoneNumber? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetChannelsByCustomerPhoneNumber? onComplete,
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
                        : _parserFn$Query$GetChannelsByCustomerPhoneNumber(
                            data),
                  ),
          onError: onError,
          document: documentNodeQueryGetChannelsByCustomerPhoneNumber,
          parserFn: _parserFn$Query$GetChannelsByCustomerPhoneNumber,
        );

  final OnQueryComplete$Query$GetChannelsByCustomerPhoneNumber?
      onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetChannelsByCustomerPhoneNumber
    extends graphql.WatchQueryOptions<Query$GetChannelsByCustomerPhoneNumber> {
  WatchOptions$Query$GetChannelsByCustomerPhoneNumber({
    String? operationName,
    required Variables$Query$GetChannelsByCustomerPhoneNumber variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetChannelsByCustomerPhoneNumber? typedOptimisticResult,
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
          document: documentNodeQueryGetChannelsByCustomerPhoneNumber,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetChannelsByCustomerPhoneNumber,
        );
}

class FetchMoreOptions$Query$GetChannelsByCustomerPhoneNumber
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetChannelsByCustomerPhoneNumber({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetChannelsByCustomerPhoneNumber variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryGetChannelsByCustomerPhoneNumber,
        );
}

extension ClientExtension$Query$GetChannelsByCustomerPhoneNumber
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetChannelsByCustomerPhoneNumber>>
      query$GetChannelsByCustomerPhoneNumber(
              Options$Query$GetChannelsByCustomerPhoneNumber options) async =>
          await this.query(options);
  graphql.ObservableQuery<Query$GetChannelsByCustomerPhoneNumber>
      watchQuery$GetChannelsByCustomerPhoneNumber(
              WatchOptions$Query$GetChannelsByCustomerPhoneNumber options) =>
          this.watchQuery(options);
  void writeQuery$GetChannelsByCustomerPhoneNumber({
    required Query$GetChannelsByCustomerPhoneNumber data,
    required Variables$Query$GetChannelsByCustomerPhoneNumber variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(
              document: documentNodeQueryGetChannelsByCustomerPhoneNumber),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$GetChannelsByCustomerPhoneNumber?
      readQuery$GetChannelsByCustomerPhoneNumber({
    required Variables$Query$GetChannelsByCustomerPhoneNumber variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
            document: documentNodeQueryGetChannelsByCustomerPhoneNumber),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query$GetChannelsByCustomerPhoneNumber.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetChannelsByCustomerPhoneNumber>
    useQuery$GetChannelsByCustomerPhoneNumber(
            Options$Query$GetChannelsByCustomerPhoneNumber options) =>
        graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$GetChannelsByCustomerPhoneNumber>
    useWatchQuery$GetChannelsByCustomerPhoneNumber(
            WatchOptions$Query$GetChannelsByCustomerPhoneNumber options) =>
        graphql_flutter.useWatchQuery(options);

class Query$GetChannelsByCustomerPhoneNumber$Widget
    extends graphql_flutter.Query<Query$GetChannelsByCustomerPhoneNumber> {
  Query$GetChannelsByCustomerPhoneNumber$Widget({
    widgets.Key? key,
    required Options$Query$GetChannelsByCustomerPhoneNumber options,
    required graphql_flutter
        .QueryBuilder<Query$GetChannelsByCustomerPhoneNumber>
        builder,
  }) : super(
          key: key,
          options: options,
          builder: builder,
        );
}

class Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber {
  Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber({
    required this.id,
    required this.code,
    required this.token,
    required this.name,
    required this.type,
    this.$__typename = 'CustomerChannel',
  });

  factory Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$token = json['token'];
    final l$name = json['name'];
    final l$type = json['type'];
    final l$$__typename = json['__typename'];
    return Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber(
      id: (l$id as String),
      code: (l$code as String),
      token: (l$token as String),
      name: (l$name as String),
      type: fromJson$Enum$ChannelTypeEnum((l$type as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String token;

  final String name;

  final Enum$ChannelTypeEnum type;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$token = token;
    _resultData['token'] = l$token;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$type = type;
    _resultData['type'] = toJson$Enum$ChannelTypeEnum(l$type);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$token = token;
    final l$name = name;
    final l$type = type;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$token,
      l$name,
      l$type,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber ||
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
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
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

extension UtilityExtension$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber
    on Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber {
  CopyWith$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber<
          Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber>
      get copyWith =>
          CopyWith$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber<
    TRes> {
  factory CopyWith$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber(
    Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber
        instance,
    TRes Function(
            Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber)
        then,
  ) = _CopyWithImpl$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber;

  factory CopyWith$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber;

  TRes call({
    String? id,
    String? code,
    String? token,
    String? name,
    Enum$ChannelTypeEnum? type,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber<
        TRes>
    implements
        CopyWith$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber<
            TRes> {
  _CopyWithImpl$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber(
    this._instance,
    this._then,
  );

  final Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber
      _instance;

  final TRes Function(
          Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? token = _undefined,
    Object? name = _undefined,
    Object? type = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        token: token == _undefined || token == null
            ? _instance.token
            : (token as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        type: type == _undefined || type == null
            ? _instance.type
            : (type as Enum$ChannelTypeEnum),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber<
        TRes>
    implements
        CopyWith$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber<
            TRes> {
  _CopyWithStubImpl$Query$GetChannelsByCustomerPhoneNumber$getChannelsByCustomerPhoneNumber(
      this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    String? token,
    String? name,
    Enum$ChannelTypeEnum? type,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Query$GetAvailableChannels {
  factory Variables$Query$GetAvailableChannels({required String postalCode}) =>
      Variables$Query$GetAvailableChannels._({
        r'postalCode': postalCode,
      });

  Variables$Query$GetAvailableChannels._(this._$data);

  factory Variables$Query$GetAvailableChannels.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postalCode = data['postalCode'];
    result$data['postalCode'] = (l$postalCode as String);
    return Variables$Query$GetAvailableChannels._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postalCode => (_$data['postalCode'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postalCode = postalCode;
    result$data['postalCode'] = l$postalCode;
    return result$data;
  }

  CopyWith$Variables$Query$GetAvailableChannels<
          Variables$Query$GetAvailableChannels>
      get copyWith => CopyWith$Variables$Query$GetAvailableChannels(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetAvailableChannels ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$postalCode = postalCode;
    final lOther$postalCode = other.postalCode;
    if (l$postalCode != lOther$postalCode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postalCode = postalCode;
    return Object.hashAll([l$postalCode]);
  }
}

abstract class CopyWith$Variables$Query$GetAvailableChannels<TRes> {
  factory CopyWith$Variables$Query$GetAvailableChannels(
    Variables$Query$GetAvailableChannels instance,
    TRes Function(Variables$Query$GetAvailableChannels) then,
  ) = _CopyWithImpl$Variables$Query$GetAvailableChannels;

  factory CopyWith$Variables$Query$GetAvailableChannels.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetAvailableChannels;

  TRes call({String? postalCode});
}

class _CopyWithImpl$Variables$Query$GetAvailableChannels<TRes>
    implements CopyWith$Variables$Query$GetAvailableChannels<TRes> {
  _CopyWithImpl$Variables$Query$GetAvailableChannels(
    this._instance,
    this._then,
  );

  final Variables$Query$GetAvailableChannels _instance;

  final TRes Function(Variables$Query$GetAvailableChannels) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postalCode = _undefined}) =>
      _then(Variables$Query$GetAvailableChannels._({
        ..._instance._$data,
        if (postalCode != _undefined && postalCode != null)
          'postalCode': (postalCode as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$GetAvailableChannels<TRes>
    implements CopyWith$Variables$Query$GetAvailableChannels<TRes> {
  _CopyWithStubImpl$Variables$Query$GetAvailableChannels(this._res);

  TRes _res;

  call({String? postalCode}) => _res;
}

class Query$GetAvailableChannels {
  Query$GetAvailableChannels({
    required this.getAvailableChannels,
    this.$__typename = 'Query',
  });

  factory Query$GetAvailableChannels.fromJson(Map<String, dynamic> json) {
    final l$getAvailableChannels = json['getAvailableChannels'];
    final l$$__typename = json['__typename'];
    return Query$GetAvailableChannels(
      getAvailableChannels: (l$getAvailableChannels as List<dynamic>)
          .map((e) => Query$GetAvailableChannels$getAvailableChannels.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$GetAvailableChannels$getAvailableChannels>
      getAvailableChannels;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$getAvailableChannels = getAvailableChannels;
    _resultData['getAvailableChannels'] =
        l$getAvailableChannels.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$getAvailableChannels = getAvailableChannels;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$getAvailableChannels.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetAvailableChannels ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$getAvailableChannels = getAvailableChannels;
    final lOther$getAvailableChannels = other.getAvailableChannels;
    if (l$getAvailableChannels.length != lOther$getAvailableChannels.length) {
      return false;
    }
    for (int i = 0; i < l$getAvailableChannels.length; i++) {
      final l$getAvailableChannels$entry = l$getAvailableChannels[i];
      final lOther$getAvailableChannels$entry = lOther$getAvailableChannels[i];
      if (l$getAvailableChannels$entry != lOther$getAvailableChannels$entry) {
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

extension UtilityExtension$Query$GetAvailableChannels
    on Query$GetAvailableChannels {
  CopyWith$Query$GetAvailableChannels<Query$GetAvailableChannels>
      get copyWith => CopyWith$Query$GetAvailableChannels(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetAvailableChannels<TRes> {
  factory CopyWith$Query$GetAvailableChannels(
    Query$GetAvailableChannels instance,
    TRes Function(Query$GetAvailableChannels) then,
  ) = _CopyWithImpl$Query$GetAvailableChannels;

  factory CopyWith$Query$GetAvailableChannels.stub(TRes res) =
      _CopyWithStubImpl$Query$GetAvailableChannels;

  TRes call({
    List<Query$GetAvailableChannels$getAvailableChannels>? getAvailableChannels,
    String? $__typename,
  });
  TRes getAvailableChannels(
      Iterable<Query$GetAvailableChannels$getAvailableChannels> Function(
              Iterable<
                  CopyWith$Query$GetAvailableChannels$getAvailableChannels<
                      Query$GetAvailableChannels$getAvailableChannels>>)
          _fn);
}

class _CopyWithImpl$Query$GetAvailableChannels<TRes>
    implements CopyWith$Query$GetAvailableChannels<TRes> {
  _CopyWithImpl$Query$GetAvailableChannels(
    this._instance,
    this._then,
  );

  final Query$GetAvailableChannels _instance;

  final TRes Function(Query$GetAvailableChannels) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? getAvailableChannels = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetAvailableChannels(
        getAvailableChannels:
            getAvailableChannels == _undefined || getAvailableChannels == null
                ? _instance.getAvailableChannels
                : (getAvailableChannels
                    as List<Query$GetAvailableChannels$getAvailableChannels>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes getAvailableChannels(
          Iterable<Query$GetAvailableChannels$getAvailableChannels> Function(
                  Iterable<
                      CopyWith$Query$GetAvailableChannels$getAvailableChannels<
                          Query$GetAvailableChannels$getAvailableChannels>>)
              _fn) =>
      call(
          getAvailableChannels: _fn(_instance.getAvailableChannels.map(
              (e) => CopyWith$Query$GetAvailableChannels$getAvailableChannels(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$GetAvailableChannels<TRes>
    implements CopyWith$Query$GetAvailableChannels<TRes> {
  _CopyWithStubImpl$Query$GetAvailableChannels(this._res);

  TRes _res;

  call({
    List<Query$GetAvailableChannels$getAvailableChannels>? getAvailableChannels,
    String? $__typename,
  }) =>
      _res;

  getAvailableChannels(_fn) => _res;
}

const documentNodeQueryGetAvailableChannels = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetAvailableChannels'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'postalCode')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'getAvailableChannels'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'postalCode'),
            value: VariableNode(name: NameNode(value: 'postalCode')),
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
            name: NameNode(value: 'name'),
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
            name: NameNode(value: 'message'),
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
]);
Query$GetAvailableChannels _parserFn$Query$GetAvailableChannels(
        Map<String, dynamic> data) =>
    Query$GetAvailableChannels.fromJson(data);
typedef OnQueryComplete$Query$GetAvailableChannels = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GetAvailableChannels?,
);

class Options$Query$GetAvailableChannels
    extends graphql.QueryOptions<Query$GetAvailableChannels> {
  Options$Query$GetAvailableChannels({
    String? operationName,
    required Variables$Query$GetAvailableChannels variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetAvailableChannels? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetAvailableChannels? onComplete,
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
                        : _parserFn$Query$GetAvailableChannels(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetAvailableChannels,
          parserFn: _parserFn$Query$GetAvailableChannels,
        );

  final OnQueryComplete$Query$GetAvailableChannels? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetAvailableChannels
    extends graphql.WatchQueryOptions<Query$GetAvailableChannels> {
  WatchOptions$Query$GetAvailableChannels({
    String? operationName,
    required Variables$Query$GetAvailableChannels variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetAvailableChannels? typedOptimisticResult,
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
          document: documentNodeQueryGetAvailableChannels,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetAvailableChannels,
        );
}

class FetchMoreOptions$Query$GetAvailableChannels
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetAvailableChannels({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetAvailableChannels variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryGetAvailableChannels,
        );
}

extension ClientExtension$Query$GetAvailableChannels on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetAvailableChannels>>
      query$GetAvailableChannels(
              Options$Query$GetAvailableChannels options) async =>
          await this.query(options);
  graphql.ObservableQuery<Query$GetAvailableChannels>
      watchQuery$GetAvailableChannels(
              WatchOptions$Query$GetAvailableChannels options) =>
          this.watchQuery(options);
  void writeQuery$GetAvailableChannels({
    required Query$GetAvailableChannels data,
    required Variables$Query$GetAvailableChannels variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(
              document: documentNodeQueryGetAvailableChannels),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$GetAvailableChannels? readQuery$GetAvailableChannels({
    required Variables$Query$GetAvailableChannels variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation:
            graphql.Operation(document: documentNodeQueryGetAvailableChannels),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetAvailableChannels.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetAvailableChannels>
    useQuery$GetAvailableChannels(Options$Query$GetAvailableChannels options) =>
        graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$GetAvailableChannels>
    useWatchQuery$GetAvailableChannels(
            WatchOptions$Query$GetAvailableChannels options) =>
        graphql_flutter.useWatchQuery(options);

class Query$GetAvailableChannels$Widget
    extends graphql_flutter.Query<Query$GetAvailableChannels> {
  Query$GetAvailableChannels$Widget({
    widgets.Key? key,
    required Options$Query$GetAvailableChannels options,
    required graphql_flutter.QueryBuilder<Query$GetAvailableChannels> builder,
  }) : super(
          key: key,
          options: options,
          builder: builder,
        );
}

class Query$GetAvailableChannels$getAvailableChannels {
  Query$GetAvailableChannels$getAvailableChannels({
    required this.id,
    required this.code,
    this.token,
    required this.name,
    required this.isAvailable,
    this.message,
    required this.type,
    this.$__typename = 'ChannelAvailability',
  });

  factory Query$GetAvailableChannels$getAvailableChannels.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$token = json['token'];
    final l$name = json['name'];
    final l$isAvailable = json['isAvailable'];
    final l$message = json['message'];
    final l$type = json['type'];
    final l$$__typename = json['__typename'];
    return Query$GetAvailableChannels$getAvailableChannels(
      id: (l$id as String),
      code: (l$code as String),
      token: (l$token as String?),
      name: (l$name as String),
      isAvailable: (l$isAvailable as bool),
      message: (l$message as String?),
      type: fromJson$Enum$ChannelType((l$type as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final String? token;

  final String name;

  final bool isAvailable;

  final String? message;

  final Enum$ChannelType type;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$token = token;
    _resultData['token'] = l$token;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$isAvailable = isAvailable;
    _resultData['isAvailable'] = l$isAvailable;
    final l$message = message;
    _resultData['message'] = l$message;
    final l$type = type;
    _resultData['type'] = toJson$Enum$ChannelType(l$type);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$token = token;
    final l$name = name;
    final l$isAvailable = isAvailable;
    final l$message = message;
    final l$type = type;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$token,
      l$name,
      l$isAvailable,
      l$message,
      l$type,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetAvailableChannels$getAvailableChannels ||
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
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$isAvailable = isAvailable;
    final lOther$isAvailable = other.isAvailable;
    if (l$isAvailable != lOther$isAvailable) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension$Query$GetAvailableChannels$getAvailableChannels
    on Query$GetAvailableChannels$getAvailableChannels {
  CopyWith$Query$GetAvailableChannels$getAvailableChannels<
          Query$GetAvailableChannels$getAvailableChannels>
      get copyWith => CopyWith$Query$GetAvailableChannels$getAvailableChannels(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetAvailableChannels$getAvailableChannels<TRes> {
  factory CopyWith$Query$GetAvailableChannels$getAvailableChannels(
    Query$GetAvailableChannels$getAvailableChannels instance,
    TRes Function(Query$GetAvailableChannels$getAvailableChannels) then,
  ) = _CopyWithImpl$Query$GetAvailableChannels$getAvailableChannels;

  factory CopyWith$Query$GetAvailableChannels$getAvailableChannels.stub(
          TRes res) =
      _CopyWithStubImpl$Query$GetAvailableChannels$getAvailableChannels;

  TRes call({
    String? id,
    String? code,
    String? token,
    String? name,
    bool? isAvailable,
    String? message,
    Enum$ChannelType? type,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetAvailableChannels$getAvailableChannels<TRes>
    implements CopyWith$Query$GetAvailableChannels$getAvailableChannels<TRes> {
  _CopyWithImpl$Query$GetAvailableChannels$getAvailableChannels(
    this._instance,
    this._then,
  );

  final Query$GetAvailableChannels$getAvailableChannels _instance;

  final TRes Function(Query$GetAvailableChannels$getAvailableChannels) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? token = _undefined,
    Object? name = _undefined,
    Object? isAvailable = _undefined,
    Object? message = _undefined,
    Object? type = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetAvailableChannels$getAvailableChannels(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        token: token == _undefined ? _instance.token : (token as String?),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        isAvailable: isAvailable == _undefined || isAvailable == null
            ? _instance.isAvailable
            : (isAvailable as bool),
        message:
            message == _undefined ? _instance.message : (message as String?),
        type: type == _undefined || type == null
            ? _instance.type
            : (type as Enum$ChannelType),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetAvailableChannels$getAvailableChannels<TRes>
    implements CopyWith$Query$GetAvailableChannels$getAvailableChannels<TRes> {
  _CopyWithStubImpl$Query$GetAvailableChannels$getAvailableChannels(this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    String? token,
    String? name,
    bool? isAvailable,
    String? message,
    Enum$ChannelType? type,
    String? $__typename,
  }) =>
      _res;
}

class Query$PostalCodes {
  Query$PostalCodes({
    required this.postalCodes,
    this.$__typename = 'Query',
  });

  factory Query$PostalCodes.fromJson(Map<String, dynamic> json) {
    final l$postalCodes = json['postalCodes'];
    final l$$__typename = json['__typename'];
    return Query$PostalCodes(
      postalCodes: (l$postalCodes as List<dynamic>)
          .map((e) => Query$PostalCodes$postalCodes.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$PostalCodes$postalCodes> postalCodes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$postalCodes = postalCodes;
    _resultData['postalCodes'] = l$postalCodes.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$postalCodes = postalCodes;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$postalCodes.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PostalCodes || runtimeType != other.runtimeType) {
      return false;
    }
    final l$postalCodes = postalCodes;
    final lOther$postalCodes = other.postalCodes;
    if (l$postalCodes.length != lOther$postalCodes.length) {
      return false;
    }
    for (int i = 0; i < l$postalCodes.length; i++) {
      final l$postalCodes$entry = l$postalCodes[i];
      final lOther$postalCodes$entry = lOther$postalCodes[i];
      if (l$postalCodes$entry != lOther$postalCodes$entry) {
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

extension UtilityExtension$Query$PostalCodes on Query$PostalCodes {
  CopyWith$Query$PostalCodes<Query$PostalCodes> get copyWith =>
      CopyWith$Query$PostalCodes(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$PostalCodes<TRes> {
  factory CopyWith$Query$PostalCodes(
    Query$PostalCodes instance,
    TRes Function(Query$PostalCodes) then,
  ) = _CopyWithImpl$Query$PostalCodes;

  factory CopyWith$Query$PostalCodes.stub(TRes res) =
      _CopyWithStubImpl$Query$PostalCodes;

  TRes call({
    List<Query$PostalCodes$postalCodes>? postalCodes,
    String? $__typename,
  });
  TRes postalCodes(
      Iterable<Query$PostalCodes$postalCodes> Function(
              Iterable<
                  CopyWith$Query$PostalCodes$postalCodes<
                      Query$PostalCodes$postalCodes>>)
          _fn);
}

class _CopyWithImpl$Query$PostalCodes<TRes>
    implements CopyWith$Query$PostalCodes<TRes> {
  _CopyWithImpl$Query$PostalCodes(
    this._instance,
    this._then,
  );

  final Query$PostalCodes _instance;

  final TRes Function(Query$PostalCodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? postalCodes = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$PostalCodes(
        postalCodes: postalCodes == _undefined || postalCodes == null
            ? _instance.postalCodes
            : (postalCodes as List<Query$PostalCodes$postalCodes>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes postalCodes(
          Iterable<Query$PostalCodes$postalCodes> Function(
                  Iterable<
                      CopyWith$Query$PostalCodes$postalCodes<
                          Query$PostalCodes$postalCodes>>)
              _fn) =>
      call(
          postalCodes: _fn(_instance.postalCodes
              .map((e) => CopyWith$Query$PostalCodes$postalCodes(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$PostalCodes<TRes>
    implements CopyWith$Query$PostalCodes<TRes> {
  _CopyWithStubImpl$Query$PostalCodes(this._res);

  TRes _res;

  call({
    List<Query$PostalCodes$postalCodes>? postalCodes,
    String? $__typename,
  }) =>
      _res;

  postalCodes(_fn) => _res;
}

const documentNodeQueryPostalCodes = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'PostalCodes'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'postalCodes'),
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
            name: NameNode(value: 'isAnywhere'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'areas'),
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
Query$PostalCodes _parserFn$Query$PostalCodes(Map<String, dynamic> data) =>
    Query$PostalCodes.fromJson(data);
typedef OnQueryComplete$Query$PostalCodes = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$PostalCodes?,
);

class Options$Query$PostalCodes
    extends graphql.QueryOptions<Query$PostalCodes> {
  Options$Query$PostalCodes({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$PostalCodes? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$PostalCodes? onComplete,
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
                    data == null ? null : _parserFn$Query$PostalCodes(data),
                  ),
          onError: onError,
          document: documentNodeQueryPostalCodes,
          parserFn: _parserFn$Query$PostalCodes,
        );

  final OnQueryComplete$Query$PostalCodes? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$PostalCodes
    extends graphql.WatchQueryOptions<Query$PostalCodes> {
  WatchOptions$Query$PostalCodes({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$PostalCodes? typedOptimisticResult,
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
          document: documentNodeQueryPostalCodes,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$PostalCodes,
        );
}

class FetchMoreOptions$Query$PostalCodes extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$PostalCodes({required graphql.UpdateQuery updateQuery})
      : super(
          updateQuery: updateQuery,
          document: documentNodeQueryPostalCodes,
        );
}

extension ClientExtension$Query$PostalCodes on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$PostalCodes>> query$PostalCodes(
          [Options$Query$PostalCodes? options]) async =>
      await this.query(options ?? Options$Query$PostalCodes());
  graphql.ObservableQuery<Query$PostalCodes> watchQuery$PostalCodes(
          [WatchOptions$Query$PostalCodes? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$PostalCodes());
  void writeQuery$PostalCodes({
    required Query$PostalCodes data,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
            operation:
                graphql.Operation(document: documentNodeQueryPostalCodes)),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$PostalCodes? readQuery$PostalCodes({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryPostalCodes)),
      optimistic: optimistic,
    );
    return result == null ? null : Query$PostalCodes.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$PostalCodes> useQuery$PostalCodes(
        [Options$Query$PostalCodes? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$PostalCodes());
graphql.ObservableQuery<Query$PostalCodes> useWatchQuery$PostalCodes(
        [WatchOptions$Query$PostalCodes? options]) =>
    graphql_flutter.useWatchQuery(options ?? WatchOptions$Query$PostalCodes());

class Query$PostalCodes$Widget
    extends graphql_flutter.Query<Query$PostalCodes> {
  Query$PostalCodes$Widget({
    widgets.Key? key,
    Options$Query$PostalCodes? options,
    required graphql_flutter.QueryBuilder<Query$PostalCodes> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$PostalCodes(),
          builder: builder,
        );
}

class Query$PostalCodes$postalCodes {
  Query$PostalCodes$postalCodes({
    required this.id,
    required this.code,
    required this.isAnywhere,
    required this.areas,
    this.$__typename = 'PostalCode',
  });

  factory Query$PostalCodes$postalCodes.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$code = json['code'];
    final l$isAnywhere = json['isAnywhere'];
    final l$areas = json['areas'];
    final l$$__typename = json['__typename'];
    return Query$PostalCodes$postalCodes(
      id: (l$id as String),
      code: (l$code as String),
      isAnywhere: (l$isAnywhere as bool),
      areas: (l$areas as List<dynamic>)
          .map((e) => Query$PostalCodes$postalCodes$areas.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String code;

  final bool isAnywhere;

  final List<Query$PostalCodes$postalCodes$areas> areas;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$code = code;
    _resultData['code'] = l$code;
    final l$isAnywhere = isAnywhere;
    _resultData['isAnywhere'] = l$isAnywhere;
    final l$areas = areas;
    _resultData['areas'] = l$areas.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$code = code;
    final l$isAnywhere = isAnywhere;
    final l$areas = areas;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$code,
      l$isAnywhere,
      Object.hashAll(l$areas.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PostalCodes$postalCodes ||
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
    final l$isAnywhere = isAnywhere;
    final lOther$isAnywhere = other.isAnywhere;
    if (l$isAnywhere != lOther$isAnywhere) {
      return false;
    }
    final l$areas = areas;
    final lOther$areas = other.areas;
    if (l$areas.length != lOther$areas.length) {
      return false;
    }
    for (int i = 0; i < l$areas.length; i++) {
      final l$areas$entry = l$areas[i];
      final lOther$areas$entry = lOther$areas[i];
      if (l$areas$entry != lOther$areas$entry) {
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

extension UtilityExtension$Query$PostalCodes$postalCodes
    on Query$PostalCodes$postalCodes {
  CopyWith$Query$PostalCodes$postalCodes<Query$PostalCodes$postalCodes>
      get copyWith => CopyWith$Query$PostalCodes$postalCodes(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$PostalCodes$postalCodes<TRes> {
  factory CopyWith$Query$PostalCodes$postalCodes(
    Query$PostalCodes$postalCodes instance,
    TRes Function(Query$PostalCodes$postalCodes) then,
  ) = _CopyWithImpl$Query$PostalCodes$postalCodes;

  factory CopyWith$Query$PostalCodes$postalCodes.stub(TRes res) =
      _CopyWithStubImpl$Query$PostalCodes$postalCodes;

  TRes call({
    String? id,
    String? code,
    bool? isAnywhere,
    List<Query$PostalCodes$postalCodes$areas>? areas,
    String? $__typename,
  });
  TRes areas(
      Iterable<Query$PostalCodes$postalCodes$areas> Function(
              Iterable<
                  CopyWith$Query$PostalCodes$postalCodes$areas<
                      Query$PostalCodes$postalCodes$areas>>)
          _fn);
}

class _CopyWithImpl$Query$PostalCodes$postalCodes<TRes>
    implements CopyWith$Query$PostalCodes$postalCodes<TRes> {
  _CopyWithImpl$Query$PostalCodes$postalCodes(
    this._instance,
    this._then,
  );

  final Query$PostalCodes$postalCodes _instance;

  final TRes Function(Query$PostalCodes$postalCodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? code = _undefined,
    Object? isAnywhere = _undefined,
    Object? areas = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$PostalCodes$postalCodes(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        code: code == _undefined || code == null
            ? _instance.code
            : (code as String),
        isAnywhere: isAnywhere == _undefined || isAnywhere == null
            ? _instance.isAnywhere
            : (isAnywhere as bool),
        areas: areas == _undefined || areas == null
            ? _instance.areas
            : (areas as List<Query$PostalCodes$postalCodes$areas>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes areas(
          Iterable<Query$PostalCodes$postalCodes$areas> Function(
                  Iterable<
                      CopyWith$Query$PostalCodes$postalCodes$areas<
                          Query$PostalCodes$postalCodes$areas>>)
              _fn) =>
      call(
          areas: _fn(_instance.areas
              .map((e) => CopyWith$Query$PostalCodes$postalCodes$areas(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$PostalCodes$postalCodes<TRes>
    implements CopyWith$Query$PostalCodes$postalCodes<TRes> {
  _CopyWithStubImpl$Query$PostalCodes$postalCodes(this._res);

  TRes _res;

  call({
    String? id,
    String? code,
    bool? isAnywhere,
    List<Query$PostalCodes$postalCodes$areas>? areas,
    String? $__typename,
  }) =>
      _res;

  areas(_fn) => _res;
}

class Query$PostalCodes$postalCodes$areas {
  Query$PostalCodes$postalCodes$areas({
    required this.id,
    required this.name,
    this.$__typename = 'PostalCodeArea',
  });

  factory Query$PostalCodes$postalCodes$areas.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$PostalCodes$postalCodes$areas(
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
    if (other is! Query$PostalCodes$postalCodes$areas ||
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

extension UtilityExtension$Query$PostalCodes$postalCodes$areas
    on Query$PostalCodes$postalCodes$areas {
  CopyWith$Query$PostalCodes$postalCodes$areas<
          Query$PostalCodes$postalCodes$areas>
      get copyWith => CopyWith$Query$PostalCodes$postalCodes$areas(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$PostalCodes$postalCodes$areas<TRes> {
  factory CopyWith$Query$PostalCodes$postalCodes$areas(
    Query$PostalCodes$postalCodes$areas instance,
    TRes Function(Query$PostalCodes$postalCodes$areas) then,
  ) = _CopyWithImpl$Query$PostalCodes$postalCodes$areas;

  factory CopyWith$Query$PostalCodes$postalCodes$areas.stub(TRes res) =
      _CopyWithStubImpl$Query$PostalCodes$postalCodes$areas;

  TRes call({
    String? id,
    String? name,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$PostalCodes$postalCodes$areas<TRes>
    implements CopyWith$Query$PostalCodes$postalCodes$areas<TRes> {
  _CopyWithImpl$Query$PostalCodes$postalCodes$areas(
    this._instance,
    this._then,
  );

  final Query$PostalCodes$postalCodes$areas _instance;

  final TRes Function(Query$PostalCodes$postalCodes$areas) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$PostalCodes$postalCodes$areas(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$PostalCodes$postalCodes$areas<TRes>
    implements CopyWith$Query$PostalCodes$postalCodes$areas<TRes> {
  _CopyWithStubImpl$Query$PostalCodes$postalCodes$areas(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Query$AreasForPostalCode {
  factory Variables$Query$AreasForPostalCode({required String code}) =>
      Variables$Query$AreasForPostalCode._({
        r'code': code,
      });

  Variables$Query$AreasForPostalCode._(this._$data);

  factory Variables$Query$AreasForPostalCode.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$code = data['code'];
    result$data['code'] = (l$code as String);
    return Variables$Query$AreasForPostalCode._(result$data);
  }

  Map<String, dynamic> _$data;

  String get code => (_$data['code'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$code = code;
    result$data['code'] = l$code;
    return result$data;
  }

  CopyWith$Variables$Query$AreasForPostalCode<
          Variables$Query$AreasForPostalCode>
      get copyWith => CopyWith$Variables$Query$AreasForPostalCode(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$AreasForPostalCode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$code = code;
    return Object.hashAll([l$code]);
  }
}

abstract class CopyWith$Variables$Query$AreasForPostalCode<TRes> {
  factory CopyWith$Variables$Query$AreasForPostalCode(
    Variables$Query$AreasForPostalCode instance,
    TRes Function(Variables$Query$AreasForPostalCode) then,
  ) = _CopyWithImpl$Variables$Query$AreasForPostalCode;

  factory CopyWith$Variables$Query$AreasForPostalCode.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$AreasForPostalCode;

  TRes call({String? code});
}

class _CopyWithImpl$Variables$Query$AreasForPostalCode<TRes>
    implements CopyWith$Variables$Query$AreasForPostalCode<TRes> {
  _CopyWithImpl$Variables$Query$AreasForPostalCode(
    this._instance,
    this._then,
  );

  final Variables$Query$AreasForPostalCode _instance;

  final TRes Function(Variables$Query$AreasForPostalCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? code = _undefined}) =>
      _then(Variables$Query$AreasForPostalCode._({
        ..._instance._$data,
        if (code != _undefined && code != null) 'code': (code as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$AreasForPostalCode<TRes>
    implements CopyWith$Variables$Query$AreasForPostalCode<TRes> {
  _CopyWithStubImpl$Variables$Query$AreasForPostalCode(this._res);

  TRes _res;

  call({String? code}) => _res;
}

class Query$AreasForPostalCode {
  Query$AreasForPostalCode({
    required this.areasForPostalCode,
    this.$__typename = 'Query',
  });

  factory Query$AreasForPostalCode.fromJson(Map<String, dynamic> json) {
    final l$areasForPostalCode = json['areasForPostalCode'];
    final l$$__typename = json['__typename'];
    return Query$AreasForPostalCode(
      areasForPostalCode: (l$areasForPostalCode as List<dynamic>)
          .map((e) => Query$AreasForPostalCode$areasForPostalCode.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$AreasForPostalCode$areasForPostalCode> areasForPostalCode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$areasForPostalCode = areasForPostalCode;
    _resultData['areasForPostalCode'] =
        l$areasForPostalCode.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$areasForPostalCode = areasForPostalCode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$areasForPostalCode.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AreasForPostalCode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$areasForPostalCode = areasForPostalCode;
    final lOther$areasForPostalCode = other.areasForPostalCode;
    if (l$areasForPostalCode.length != lOther$areasForPostalCode.length) {
      return false;
    }
    for (int i = 0; i < l$areasForPostalCode.length; i++) {
      final l$areasForPostalCode$entry = l$areasForPostalCode[i];
      final lOther$areasForPostalCode$entry = lOther$areasForPostalCode[i];
      if (l$areasForPostalCode$entry != lOther$areasForPostalCode$entry) {
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

extension UtilityExtension$Query$AreasForPostalCode
    on Query$AreasForPostalCode {
  CopyWith$Query$AreasForPostalCode<Query$AreasForPostalCode> get copyWith =>
      CopyWith$Query$AreasForPostalCode(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$AreasForPostalCode<TRes> {
  factory CopyWith$Query$AreasForPostalCode(
    Query$AreasForPostalCode instance,
    TRes Function(Query$AreasForPostalCode) then,
  ) = _CopyWithImpl$Query$AreasForPostalCode;

  factory CopyWith$Query$AreasForPostalCode.stub(TRes res) =
      _CopyWithStubImpl$Query$AreasForPostalCode;

  TRes call({
    List<Query$AreasForPostalCode$areasForPostalCode>? areasForPostalCode,
    String? $__typename,
  });
  TRes areasForPostalCode(
      Iterable<Query$AreasForPostalCode$areasForPostalCode> Function(
              Iterable<
                  CopyWith$Query$AreasForPostalCode$areasForPostalCode<
                      Query$AreasForPostalCode$areasForPostalCode>>)
          _fn);
}

class _CopyWithImpl$Query$AreasForPostalCode<TRes>
    implements CopyWith$Query$AreasForPostalCode<TRes> {
  _CopyWithImpl$Query$AreasForPostalCode(
    this._instance,
    this._then,
  );

  final Query$AreasForPostalCode _instance;

  final TRes Function(Query$AreasForPostalCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? areasForPostalCode = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$AreasForPostalCode(
        areasForPostalCode:
            areasForPostalCode == _undefined || areasForPostalCode == null
                ? _instance.areasForPostalCode
                : (areasForPostalCode
                    as List<Query$AreasForPostalCode$areasForPostalCode>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes areasForPostalCode(
          Iterable<Query$AreasForPostalCode$areasForPostalCode> Function(
                  Iterable<
                      CopyWith$Query$AreasForPostalCode$areasForPostalCode<
                          Query$AreasForPostalCode$areasForPostalCode>>)
              _fn) =>
      call(
          areasForPostalCode: _fn(_instance.areasForPostalCode
              .map((e) => CopyWith$Query$AreasForPostalCode$areasForPostalCode(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$AreasForPostalCode<TRes>
    implements CopyWith$Query$AreasForPostalCode<TRes> {
  _CopyWithStubImpl$Query$AreasForPostalCode(this._res);

  TRes _res;

  call({
    List<Query$AreasForPostalCode$areasForPostalCode>? areasForPostalCode,
    String? $__typename,
  }) =>
      _res;

  areasForPostalCode(_fn) => _res;
}

const documentNodeQueryAreasForPostalCode = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'AreasForPostalCode'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'code')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'areasForPostalCode'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'code'),
            value: VariableNode(name: NameNode(value: 'code')),
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
]);
Query$AreasForPostalCode _parserFn$Query$AreasForPostalCode(
        Map<String, dynamic> data) =>
    Query$AreasForPostalCode.fromJson(data);
typedef OnQueryComplete$Query$AreasForPostalCode = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$AreasForPostalCode?,
);

class Options$Query$AreasForPostalCode
    extends graphql.QueryOptions<Query$AreasForPostalCode> {
  Options$Query$AreasForPostalCode({
    String? operationName,
    required Variables$Query$AreasForPostalCode variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$AreasForPostalCode? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$AreasForPostalCode? onComplete,
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
                        : _parserFn$Query$AreasForPostalCode(data),
                  ),
          onError: onError,
          document: documentNodeQueryAreasForPostalCode,
          parserFn: _parserFn$Query$AreasForPostalCode,
        );

  final OnQueryComplete$Query$AreasForPostalCode? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$AreasForPostalCode
    extends graphql.WatchQueryOptions<Query$AreasForPostalCode> {
  WatchOptions$Query$AreasForPostalCode({
    String? operationName,
    required Variables$Query$AreasForPostalCode variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$AreasForPostalCode? typedOptimisticResult,
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
          document: documentNodeQueryAreasForPostalCode,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$AreasForPostalCode,
        );
}

class FetchMoreOptions$Query$AreasForPostalCode
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$AreasForPostalCode({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$AreasForPostalCode variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryAreasForPostalCode,
        );
}

extension ClientExtension$Query$AreasForPostalCode on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$AreasForPostalCode>>
      query$AreasForPostalCode(
              Options$Query$AreasForPostalCode options) async =>
          await this.query(options);
  graphql.ObservableQuery<Query$AreasForPostalCode>
      watchQuery$AreasForPostalCode(
              WatchOptions$Query$AreasForPostalCode options) =>
          this.watchQuery(options);
  void writeQuery$AreasForPostalCode({
    required Query$AreasForPostalCode data,
    required Variables$Query$AreasForPostalCode variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryAreasForPostalCode),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$AreasForPostalCode? readQuery$AreasForPostalCode({
    required Variables$Query$AreasForPostalCode variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation:
            graphql.Operation(document: documentNodeQueryAreasForPostalCode),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$AreasForPostalCode.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$AreasForPostalCode>
    useQuery$AreasForPostalCode(Options$Query$AreasForPostalCode options) =>
        graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$AreasForPostalCode>
    useWatchQuery$AreasForPostalCode(
            WatchOptions$Query$AreasForPostalCode options) =>
        graphql_flutter.useWatchQuery(options);

class Query$AreasForPostalCode$Widget
    extends graphql_flutter.Query<Query$AreasForPostalCode> {
  Query$AreasForPostalCode$Widget({
    widgets.Key? key,
    required Options$Query$AreasForPostalCode options,
    required graphql_flutter.QueryBuilder<Query$AreasForPostalCode> builder,
  }) : super(
          key: key,
          options: options,
          builder: builder,
        );
}

class Query$AreasForPostalCode$areasForPostalCode {
  Query$AreasForPostalCode$areasForPostalCode({
    required this.id,
    required this.name,
    required this.enabled,
    this.$__typename = 'PostalCodeArea',
  });

  factory Query$AreasForPostalCode$areasForPostalCode.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$enabled = json['enabled'];
    final l$$__typename = json['__typename'];
    return Query$AreasForPostalCode$areasForPostalCode(
      id: (l$id as String),
      name: (l$name as String),
      enabled: (l$enabled as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final bool enabled;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$enabled = enabled;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$enabled,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AreasForPostalCode$areasForPostalCode ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$AreasForPostalCode$areasForPostalCode
    on Query$AreasForPostalCode$areasForPostalCode {
  CopyWith$Query$AreasForPostalCode$areasForPostalCode<
          Query$AreasForPostalCode$areasForPostalCode>
      get copyWith => CopyWith$Query$AreasForPostalCode$areasForPostalCode(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$AreasForPostalCode$areasForPostalCode<TRes> {
  factory CopyWith$Query$AreasForPostalCode$areasForPostalCode(
    Query$AreasForPostalCode$areasForPostalCode instance,
    TRes Function(Query$AreasForPostalCode$areasForPostalCode) then,
  ) = _CopyWithImpl$Query$AreasForPostalCode$areasForPostalCode;

  factory CopyWith$Query$AreasForPostalCode$areasForPostalCode.stub(TRes res) =
      _CopyWithStubImpl$Query$AreasForPostalCode$areasForPostalCode;

  TRes call({
    String? id,
    String? name,
    bool? enabled,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$AreasForPostalCode$areasForPostalCode<TRes>
    implements CopyWith$Query$AreasForPostalCode$areasForPostalCode<TRes> {
  _CopyWithImpl$Query$AreasForPostalCode$areasForPostalCode(
    this._instance,
    this._then,
  );

  final Query$AreasForPostalCode$areasForPostalCode _instance;

  final TRes Function(Query$AreasForPostalCode$areasForPostalCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? enabled = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$AreasForPostalCode$areasForPostalCode(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        enabled: enabled == _undefined || enabled == null
            ? _instance.enabled
            : (enabled as bool),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$AreasForPostalCode$areasForPostalCode<TRes>
    implements CopyWith$Query$AreasForPostalCode$areasForPostalCode<TRes> {
  _CopyWithStubImpl$Query$AreasForPostalCode$areasForPostalCode(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    bool? enabled,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Mutation$RequestAccountDeletion {
  factory Variables$Mutation$RequestAccountDeletion({String? reason}) =>
      Variables$Mutation$RequestAccountDeletion._({
        if (reason != null) r'reason': reason,
      });

  Variables$Mutation$RequestAccountDeletion._(this._$data);

  factory Variables$Mutation$RequestAccountDeletion.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('reason')) {
      final l$reason = data['reason'];
      result$data['reason'] = (l$reason as String?);
    }
    return Variables$Mutation$RequestAccountDeletion._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get reason => (_$data['reason'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('reason')) {
      final l$reason = reason;
      result$data['reason'] = l$reason;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$RequestAccountDeletion<
          Variables$Mutation$RequestAccountDeletion>
      get copyWith => CopyWith$Variables$Mutation$RequestAccountDeletion(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RequestAccountDeletion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$reason = reason;
    final lOther$reason = other.reason;
    if (_$data.containsKey('reason') != other._$data.containsKey('reason')) {
      return false;
    }
    if (l$reason != lOther$reason) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$reason = reason;
    return Object.hashAll([_$data.containsKey('reason') ? l$reason : const {}]);
  }
}

abstract class CopyWith$Variables$Mutation$RequestAccountDeletion<TRes> {
  factory CopyWith$Variables$Mutation$RequestAccountDeletion(
    Variables$Mutation$RequestAccountDeletion instance,
    TRes Function(Variables$Mutation$RequestAccountDeletion) then,
  ) = _CopyWithImpl$Variables$Mutation$RequestAccountDeletion;

  factory CopyWith$Variables$Mutation$RequestAccountDeletion.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RequestAccountDeletion;

  TRes call({String? reason});
}

class _CopyWithImpl$Variables$Mutation$RequestAccountDeletion<TRes>
    implements CopyWith$Variables$Mutation$RequestAccountDeletion<TRes> {
  _CopyWithImpl$Variables$Mutation$RequestAccountDeletion(
    this._instance,
    this._then,
  );

  final Variables$Mutation$RequestAccountDeletion _instance;

  final TRes Function(Variables$Mutation$RequestAccountDeletion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? reason = _undefined}) =>
      _then(Variables$Mutation$RequestAccountDeletion._({
        ..._instance._$data,
        if (reason != _undefined) 'reason': (reason as String?),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$RequestAccountDeletion<TRes>
    implements CopyWith$Variables$Mutation$RequestAccountDeletion<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RequestAccountDeletion(this._res);

  TRes _res;

  call({String? reason}) => _res;
}

class Mutation$RequestAccountDeletion {
  Mutation$RequestAccountDeletion({
    required this.requestAccountDeletion,
    this.$__typename = 'Mutation',
  });

  factory Mutation$RequestAccountDeletion.fromJson(Map<String, dynamic> json) {
    final l$requestAccountDeletion = json['requestAccountDeletion'];
    final l$$__typename = json['__typename'];
    return Mutation$RequestAccountDeletion(
      requestAccountDeletion:
          Mutation$RequestAccountDeletion$requestAccountDeletion.fromJson(
              (l$requestAccountDeletion as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$RequestAccountDeletion$requestAccountDeletion
      requestAccountDeletion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$requestAccountDeletion = requestAccountDeletion;
    _resultData['requestAccountDeletion'] = l$requestAccountDeletion.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$requestAccountDeletion = requestAccountDeletion;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$requestAccountDeletion,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RequestAccountDeletion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$requestAccountDeletion = requestAccountDeletion;
    final lOther$requestAccountDeletion = other.requestAccountDeletion;
    if (l$requestAccountDeletion != lOther$requestAccountDeletion) {
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

extension UtilityExtension$Mutation$RequestAccountDeletion
    on Mutation$RequestAccountDeletion {
  CopyWith$Mutation$RequestAccountDeletion<Mutation$RequestAccountDeletion>
      get copyWith => CopyWith$Mutation$RequestAccountDeletion(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$RequestAccountDeletion<TRes> {
  factory CopyWith$Mutation$RequestAccountDeletion(
    Mutation$RequestAccountDeletion instance,
    TRes Function(Mutation$RequestAccountDeletion) then,
  ) = _CopyWithImpl$Mutation$RequestAccountDeletion;

  factory CopyWith$Mutation$RequestAccountDeletion.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RequestAccountDeletion;

  TRes call({
    Mutation$RequestAccountDeletion$requestAccountDeletion?
        requestAccountDeletion,
    String? $__typename,
  });
  CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion<TRes>
      get requestAccountDeletion;
}

class _CopyWithImpl$Mutation$RequestAccountDeletion<TRes>
    implements CopyWith$Mutation$RequestAccountDeletion<TRes> {
  _CopyWithImpl$Mutation$RequestAccountDeletion(
    this._instance,
    this._then,
  );

  final Mutation$RequestAccountDeletion _instance;

  final TRes Function(Mutation$RequestAccountDeletion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? requestAccountDeletion = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$RequestAccountDeletion(
        requestAccountDeletion: requestAccountDeletion == _undefined ||
                requestAccountDeletion == null
            ? _instance.requestAccountDeletion
            : (requestAccountDeletion
                as Mutation$RequestAccountDeletion$requestAccountDeletion),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion<TRes>
      get requestAccountDeletion {
    final local$requestAccountDeletion = _instance.requestAccountDeletion;
    return CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion(
        local$requestAccountDeletion, (e) => call(requestAccountDeletion: e));
  }
}

class _CopyWithStubImpl$Mutation$RequestAccountDeletion<TRes>
    implements CopyWith$Mutation$RequestAccountDeletion<TRes> {
  _CopyWithStubImpl$Mutation$RequestAccountDeletion(this._res);

  TRes _res;

  call({
    Mutation$RequestAccountDeletion$requestAccountDeletion?
        requestAccountDeletion,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion<TRes>
      get requestAccountDeletion =>
          CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion.stub(
              _res);
}

const documentNodeMutationRequestAccountDeletion = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'RequestAccountDeletion'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'reason')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'requestAccountDeletion'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'reason'),
            value: VariableNode(name: NameNode(value: 'reason')),
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
]);
Mutation$RequestAccountDeletion _parserFn$Mutation$RequestAccountDeletion(
        Map<String, dynamic> data) =>
    Mutation$RequestAccountDeletion.fromJson(data);
typedef OnMutationCompleted$Mutation$RequestAccountDeletion = FutureOr<void>
    Function(
  Map<String, dynamic>?,
  Mutation$RequestAccountDeletion?,
);

class Options$Mutation$RequestAccountDeletion
    extends graphql.MutationOptions<Mutation$RequestAccountDeletion> {
  Options$Mutation$RequestAccountDeletion({
    String? operationName,
    Variables$Mutation$RequestAccountDeletion? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$RequestAccountDeletion? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$RequestAccountDeletion? onCompleted,
    graphql.OnMutationUpdate<Mutation$RequestAccountDeletion>? update,
    graphql.OnError? onError,
  })  : onCompletedWithParsed = onCompleted,
        super(
          variables: variables?.toJson() ?? {},
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
                        : _parserFn$Mutation$RequestAccountDeletion(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationRequestAccountDeletion,
          parserFn: _parserFn$Mutation$RequestAccountDeletion,
        );

  final OnMutationCompleted$Mutation$RequestAccountDeletion?
      onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$RequestAccountDeletion
    extends graphql.WatchQueryOptions<Mutation$RequestAccountDeletion> {
  WatchOptions$Mutation$RequestAccountDeletion({
    String? operationName,
    Variables$Mutation$RequestAccountDeletion? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$RequestAccountDeletion? typedOptimisticResult,
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
          document: documentNodeMutationRequestAccountDeletion,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$RequestAccountDeletion,
        );
}

extension ClientExtension$Mutation$RequestAccountDeletion
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$RequestAccountDeletion>>
      mutate$RequestAccountDeletion(
              [Options$Mutation$RequestAccountDeletion? options]) async =>
          await this
              .mutate(options ?? Options$Mutation$RequestAccountDeletion());
  graphql.ObservableQuery<Mutation$RequestAccountDeletion>
      watchMutation$RequestAccountDeletion(
              [WatchOptions$Mutation$RequestAccountDeletion? options]) =>
          this.watchMutation(
              options ?? WatchOptions$Mutation$RequestAccountDeletion());
}

class Mutation$RequestAccountDeletion$HookResult {
  Mutation$RequestAccountDeletion$HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation$Mutation$RequestAccountDeletion runMutation;

  final graphql.QueryResult<Mutation$RequestAccountDeletion> result;
}

Mutation$RequestAccountDeletion$HookResult useMutation$RequestAccountDeletion(
    [WidgetOptions$Mutation$RequestAccountDeletion? options]) {
  final result = graphql_flutter
      .useMutation(options ?? WidgetOptions$Mutation$RequestAccountDeletion());
  return Mutation$RequestAccountDeletion$HookResult(
    ({variables, optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
      variables?.toJson() ?? const {},
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$RequestAccountDeletion>
    useWatchMutation$RequestAccountDeletion(
            [WatchOptions$Mutation$RequestAccountDeletion? options]) =>
        graphql_flutter.useWatchMutation(
            options ?? WatchOptions$Mutation$RequestAccountDeletion());

class WidgetOptions$Mutation$RequestAccountDeletion
    extends graphql.MutationOptions<Mutation$RequestAccountDeletion> {
  WidgetOptions$Mutation$RequestAccountDeletion({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$RequestAccountDeletion? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$RequestAccountDeletion? onCompleted,
    graphql.OnMutationUpdate<Mutation$RequestAccountDeletion>? update,
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
                        : _parserFn$Mutation$RequestAccountDeletion(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationRequestAccountDeletion,
          parserFn: _parserFn$Mutation$RequestAccountDeletion,
        );

  final OnMutationCompleted$Mutation$RequestAccountDeletion?
      onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

typedef RunMutation$Mutation$RequestAccountDeletion
    = graphql.MultiSourceResult<Mutation$RequestAccountDeletion> Function({
  Variables$Mutation$RequestAccountDeletion? variables,
  Object? optimisticResult,
  Mutation$RequestAccountDeletion? typedOptimisticResult,
});
typedef Builder$Mutation$RequestAccountDeletion = widgets.Widget Function(
  RunMutation$Mutation$RequestAccountDeletion,
  graphql.QueryResult<Mutation$RequestAccountDeletion>?,
);

class Mutation$RequestAccountDeletion$Widget
    extends graphql_flutter.Mutation<Mutation$RequestAccountDeletion> {
  Mutation$RequestAccountDeletion$Widget({
    widgets.Key? key,
    WidgetOptions$Mutation$RequestAccountDeletion? options,
    required Builder$Mutation$RequestAccountDeletion builder,
  }) : super(
          key: key,
          options: options ?? WidgetOptions$Mutation$RequestAccountDeletion(),
          builder: (
            run,
            result,
          ) =>
              builder(
            ({
              variables,
              optimisticResult,
              typedOptimisticResult,
            }) =>
                run(
              variables?.toJson() ?? const {},
              optimisticResult:
                  optimisticResult ?? typedOptimisticResult?.toJson(),
            ),
            result,
          ),
        );
}

class Mutation$RequestAccountDeletion$requestAccountDeletion {
  Mutation$RequestAccountDeletion$requestAccountDeletion({
    required this.success,
    required this.message,
    this.$__typename = 'AccountDeletionResponse',
  });

  factory Mutation$RequestAccountDeletion$requestAccountDeletion.fromJson(
      Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation$RequestAccountDeletion$requestAccountDeletion(
      success: (l$success as bool),
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final bool success;

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$success,
      l$message,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RequestAccountDeletion$requestAccountDeletion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$success = success;
    final lOther$success = other.success;
    if (l$success != lOther$success) {
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

extension UtilityExtension$Mutation$RequestAccountDeletion$requestAccountDeletion
    on Mutation$RequestAccountDeletion$requestAccountDeletion {
  CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion<
          Mutation$RequestAccountDeletion$requestAccountDeletion>
      get copyWith =>
          CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion<
    TRes> {
  factory CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion(
    Mutation$RequestAccountDeletion$requestAccountDeletion instance,
    TRes Function(Mutation$RequestAccountDeletion$requestAccountDeletion) then,
  ) = _CopyWithImpl$Mutation$RequestAccountDeletion$requestAccountDeletion;

  factory CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$RequestAccountDeletion$requestAccountDeletion;

  TRes call({
    bool? success,
    String? message,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$RequestAccountDeletion$requestAccountDeletion<TRes>
    implements
        CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion<TRes> {
  _CopyWithImpl$Mutation$RequestAccountDeletion$requestAccountDeletion(
    this._instance,
    this._then,
  );

  final Mutation$RequestAccountDeletion$requestAccountDeletion _instance;

  final TRes Function(Mutation$RequestAccountDeletion$requestAccountDeletion)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$RequestAccountDeletion$requestAccountDeletion(
        success: success == _undefined || success == null
            ? _instance.success
            : (success as bool),
        message: message == _undefined || message == null
            ? _instance.message
            : (message as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$RequestAccountDeletion$requestAccountDeletion<
        TRes>
    implements
        CopyWith$Mutation$RequestAccountDeletion$requestAccountDeletion<TRes> {
  _CopyWithStubImpl$Mutation$RequestAccountDeletion$requestAccountDeletion(
      this._res);

  TRes _res;

  call({
    bool? success,
    String? message,
    String? $__typename,
  }) =>
      _res;
}
