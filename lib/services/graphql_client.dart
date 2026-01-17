import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart' as http_io;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class GraphqlService {
  // Tokens
  static String _authToken = "";
  static String _channelToken = "";
  static final String _channelTokenKey =  'vendure-token';

  // Storage
  static final GetStorage _storage = GetStorage();

  // GraphQL client
  static ValueNotifier<GraphQLClient>? _client;
  
  // Reactive channel token observable for UI updates
  static final RxString channelTokenRx = ''.obs;

  static ValueNotifier<GraphQLClient> get client {
    _client ??= ValueNotifier(_createClient());
// print("📦 GraphQL Client created with channelToken: $_channelToken");
    return _client!;
  }

  static GraphQLClient _createClient() {
    final authLink = AuthLink(getToken: () async {
      final token = _authToken.isNotEmpty ? 'Bearer $_authToken' : null;
      if (token != null) {
      }
      // Always print channel token when auth header is accessed
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
    
    // Debug print channel token header prominently
    if (_channelToken.isNotEmpty) {
    } else {
    }
    // Debug print all headers
    headers.forEach((key, value) {
      if (key == _channelTokenKey) {
        // Highlight channel token header
      } else {
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
    await GetStorage.init();
    _authToken = _storage.read('auth_token') ?? "";
    _channelToken = _storage.read('channel_token') ?? "";
    channelTokenRx.value = _channelToken; // Initialize reactive observable
    _client ??= ValueNotifier(_createClient());
  }

  // Generic setter for token
  static Future<void> setToken({required String key, required String token}) async {
    if (key == 'auth') {
      if (_authToken != token) _authToken = token;
    } else if (key == 'channel') {
      if (_channelToken != token) {
        _channelToken = token;
        // Update reactive observable to trigger UI updates
        channelTokenRx.value = token;
      }
    }
    await _storage.write('${key}_token', token);
    _client?.value = _createClient();
    if (key == 'channel' && token.isNotEmpty) {
    }
  }

  // Generic clear token
  static Future<void> clearToken(String key) async {
// print("🗑️ clearToken called for $key");
    if (key == 'auth') _authToken = "";
    if (key == 'channel') {
      _channelToken = "";
      channelTokenRx.value = ""; // Update reactive observable
    }
    await _storage.remove('${key}_token');
    _client?.value = _createClient();
// print("✅ $key token cleared and client recreated");
  }

  // Getters
  static String get authToken => _authToken;
  static String get channelToken => _channelToken;
}