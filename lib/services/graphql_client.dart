import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart' as http_io;
import 'package:get_storage/get_storage.dart';

class GraphqlService {
  // Tokens
  static String _authToken = "";
  static String _channelToken = "";
  static final String _channelTokenKey =  'vendure-token';

  // Storage
  static final GetStorage _storage = GetStorage();

  // GraphQL client
  static ValueNotifier<GraphQLClient>? _client;

  static ValueNotifier<GraphQLClient> get client {
    _client ??= ValueNotifier(_createClient());
// print("📦 GraphQL Client created with channelToken: $_channelToken");
    return _client!;
  }

  static GraphQLClient _createClient() {
    debugPrint("🔧 [GraphQL Client] Creating client with tokens:");
    debugPrint("   - Vendure Token (auth): ${_authToken.isNotEmpty ? 'Bearer $_authToken' : 'NOT SET'}");
    debugPrint("   - Channel Token: ${_channelToken.isNotEmpty ? _channelToken : 'NOT SET'}");

    final authLink = AuthLink(getToken: () async {
      final token = _authToken.isNotEmpty ? 'Bearer $_authToken' : null;
      if (token != null) {
        debugPrint("🔑 [GraphQL Client] Authorization header: $token");
      }
      return token;
    });

    // Create HTTP client with improved timeout and connection settings
    // Configure HttpClient for better connection handling and stability
    final httpClientInstance = HttpClient()
      ..connectionTimeout = const Duration(seconds: 30)
      ..idleTimeout = const Duration(seconds: 30)
      ..autoUncompress = true // Enable automatic decompression
      ..maxConnectionsPerHost = 10 // Allow multiple connections per host for better concurrency
      ..userAgent = 'Unified-EcomApp/1.0';
    
    final httpClient = http_io.IOClient(httpClientInstance);
    
    // Prepare headers
    final headers = <String, String>{
      if (_channelToken.isNotEmpty) _channelTokenKey: _channelToken,
      'x-device-medium': 'android',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'keep-alive', // Keep connection alive for reuse
      'Accept-Encoding': 'gzip, deflate', // Enable compression
    };
    
    // Debug print headers
    debugPrint("📋 [GraphQL Client] HTTP Headers:");
    headers.forEach((key, value) {
      if (key == _channelTokenKey) {
        debugPrint("   - $key: $value");
      } else {
        debugPrint("   - $key: $value");
      }
    });
    
    final httpLink = HttpLink(
      dotenv.env['SHOP_API_URL'] ?? '',
      httpClient: httpClient,
      defaultHeaders: headers,
    );

    // Chain: auth -> http
    final link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: null), // fully disabled cache
      defaultPolicies: DefaultPolicies(
        watchQuery: Policies(fetch: FetchPolicy.networkOnly),
        query: Policies(fetch: FetchPolicy.networkOnly),
        mutate: Policies(fetch: FetchPolicy.networkOnly),
      ),
    );
  }

  // Initialize from storage
  static Future<void> initialize() async {
    debugPrint("⚡ [GraphQL Client] Initializing GraphqlService...");
    await GetStorage.init();
    _authToken = _storage.read('auth_token') ?? "";
    _channelToken = _storage.read('channel_token') ?? "";
    debugPrint("✅ [GraphQL Client] Tokens loaded from storage:");
    debugPrint("   - Vendure Token (auth_token): ${_authToken.isNotEmpty ? '${_authToken.substring(0, _authToken.length > 20 ? 20 : _authToken.length)}...' : 'NOT SET'}");
    debugPrint("   - Channel Token (channel_token): ${_channelToken.isNotEmpty ? '${_channelToken.substring(0, _channelToken.length > 20 ? 20 : _channelToken.length)}...' : 'NOT SET'}");
    _client ??= ValueNotifier(_createClient());
  }

  // Generic setter for token
  static Future<void> setToken({required String key, required String token}) async {
    debugPrint("📝 [GraphQL Client] setToken called for $key");
    debugPrint("   - Token value: ${token.length > 20 ? '${token.substring(0, 20)}...' : token}");
    if (key == 'auth') {
      if (_authToken != token) _authToken = token;
    } else if (key == 'channel') {
      if (_channelToken != token) _channelToken = token;
    }
    await _storage.write('${key}_token', token);
    _client?.value = _createClient();
    debugPrint("✅ [GraphQL Client] $key token updated and client recreated");
  }

  // Generic clear token
  static Future<void> clearToken(String key) async {
// print("🗑️ clearToken called for $key");
    if (key == 'auth') _authToken = "";
    if (key == 'channel') _channelToken = "";
    await _storage.remove('${key}_token');
    _client?.value = _createClient();
// print("✅ $key token cleared and client recreated");
  }

  // Getters
  static String get authToken => _authToken;
  static String get channelToken => _channelToken;
}