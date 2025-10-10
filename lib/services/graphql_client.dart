import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;


import 'package:get_storage/get_storage.dart';

class GraphqlService {
  // Tokens
  static String _authToken = "";
  static String _channelToken = "";
  static String _channelTokenKey = dotenv.env['CHANNEL_TOKEN_KEY'] ?? 'vendure-token';

  // Storage
  static final GetStorage _storage = GetStorage();

  // GraphQL client
  static ValueNotifier<GraphQLClient>? _client;

  /// Get GraphQL client
  static ValueNotifier<GraphQLClient> get client {
    _client ??= ValueNotifier(_createClient());
    return _client!;
  }

  /// Create GraphQL client with current tokens
  static GraphQLClient _createClient() {
    final AuthLink authLink = AuthLink(
      getToken: () async => _authToken.isNotEmpty ? 'Bearer $_authToken' : null,
    );

    final HttpLink httpLink = HttpLink(
      dotenv.env['SHOP_API_URL'] ?? '',
      httpClient: http.Client(),
      defaultHeaders: {
        _channelTokenKey: _channelToken,
        'x-device-medium': 'android', // TODO: make dynamic for iOS
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
  }

  /// Initialize service from stored tokens
  static Future<void> initialize() async {
    await GetStorage.init();
    _authToken = _storage.read('auth_token') ?? "";
    _channelToken = _storage.read('channel_token') ?? "";
    _client ??= ValueNotifier(_createClient());
  }

  /// Set authentication token
  static Future<void> setAuthToken(String token) async {
    if (_authToken != token) {
      _authToken = token;
      await _storage.write('auth_token', token);
      _client?.value = _createClient();
    }
  }

  /// Set channel token
  static Future<void> setChannelToken(String token) async {
    if (_channelToken != token) {
      _channelToken = token;
      await _storage.write('channel_token', token);
      _client?.value = _createClient();
    }
  }

  /// Remove authentication token
  static Future<void> clearAuthToken() async {
    _authToken = "";
    await _storage.remove('auth_token');
    _client?.value = _createClient();
  }

  /// Remove channel token
  static Future<void> clearChannelToken() async {
    _channelToken = "";
    await _storage.remove('channel_token');
    _client?.value = _createClient();
  }

  /// Getters
  static String get authToken => _authToken;
  static String get channelToken => _channelToken;
}
