import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;


import 'package:get_storage/get_storage.dart';

class GraphqlService {
  // Tokens
  static String _authToken = "";
  static String _channelToken = "";
  static final String _channelTokenKey = dotenv.env['CHANNEL_TOKEN_KEY'] ?? 'vendure-token';

  // Storage
  static final GetStorage _storage = GetStorage();

  // GraphQL client
  static ValueNotifier<GraphQLClient>? _client;

  static ValueNotifier<GraphQLClient> get client {
    _client ??= ValueNotifier(_createClient());
    print("📦 GraphQL Client created with channelToken: $_channelToken");
    return _client!;
  }

  static GraphQLClient _createClient() {
    print("🔧 _createClient called with authToken: $_authToken, channelToken: $_channelToken");

    final authLink = AuthLink(getToken: () async => _authToken.isNotEmpty ? 'Bearer $_authToken' : null);
    // Only include channelToken if it's not empty
    final httpLink = HttpLink(
      dotenv.env['SHOP_API_URL'] ?? '',
      httpClient: http.Client(),
      defaultHeaders: {
        if (_channelToken.isNotEmpty) _channelTokenKey: _channelToken,
        'x-device-medium': 'android',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );



    return GraphQLClient(link: authLink.concat(httpLink), cache: GraphQLCache());
  }

  // Initialize from storage
  static Future<void> initialize() async {
    print("⚡ Initializing GraphqlService...");
    await GetStorage.init();
    _authToken = _storage.read('auth_token') ?? "";
    _channelToken = _storage.read('channel_token') ?? "";
    print("✅ Tokens loaded - authToken: $_authToken, channelToken: $_channelToken");
    _client ??= ValueNotifier(_createClient());
  }

  // Generic setter for token
  static Future<void> setToken({required String key, required String token}) async {
    print("📝 setToken called for $key: $token");
    if (key == 'auth') {
      if (_authToken != token) _authToken = token;
    } else if (key == 'channel') {
      if (_channelToken != token) _channelToken = token;
    }
    await _storage.write('${key}_token', token);
    _client?.value = _createClient();
    print("✅ $key token updated and client recreated");
  }

  // Generic clear token
  static Future<void> clearToken(String key) async {
    print("🗑️ clearToken called for $key");
    if (key == 'auth') _authToken = "";
    if (key == 'channel') _channelToken = "";
    await _storage.remove('${key}_token');
    _client?.value = _createClient();
    print("✅ $key token cleared and client recreated");
  }

  // Getters
  static String get authToken => _authToken;
  static String get channelToken => _channelToken;
}
