import 'dart:io';
import 'dart:async';
import 'dart:convert';
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
  /// Guest session token from Vendure (returned in response headers when guest adds to cart / getActiveOrder).
  /// Must be sent with authenticate() so Vendure can merge guest cart with logged-in customer.
  static String _guestToken = "";
  static String _channelToken = "";
  static final String _channelTokenKey =  'vendure-token';

  // Storage
  static final GetStorage _storage = GetStorage();

  // GraphQL client
  static ValueNotifier<GraphQLClient>? _client;
  
  // Reactive channel token observable for UI updates
  static final RxString channelTokenRx = ''.obs;

  /// Current platform for API header (android, ios, web, windows, macos, linux).
  static String get _deviceMedium {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
      default:
        return 'unknown';
    }
  }

  static ValueNotifier<GraphQLClient> get client {
    _client ??= ValueNotifier(_createClient());
// print("📦 GraphQL Client created with channelToken: $_channelToken");
    return _client!;
  }

  static GraphQLClient _createClient() {
    final authLink = AuthLink(getToken: () async {
      // Use auth token if logged in; else use guest token so login request carries same session for cart merge
      if (_authToken.isNotEmpty) return 'Bearer $_authToken';
      if (_guestToken.isNotEmpty) return 'Bearer $_guestToken';
      return null;
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

    // Always use the enforced default channel token
    final channelTokenForHeaders = _defaultChannelToken;

    // Prepare headers - use actual platform where app is running
    final headers = <String, String>{
      if (channelTokenForHeaders.isNotEmpty) _channelTokenKey: channelTokenForHeaders,
      'x-device-medium': _deviceMedium,
      'x-platform': 'SwadKerala',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'keep-alive', // Keep connection alive for reuse
      'Accept-Encoding': 'gzip, deflate', // Enable compression
    };
    
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
  static const String _defaultChannelToken = 'ind-Swadkerala';

  static Future<void> initialize() async {
    await GetStorage.init();
    _authToken = _storage.read('auth_token') ?? "";
    // Always enforce default channel token
    _channelToken = _defaultChannelToken;
    await _storage.write('channel_token', _defaultChannelToken);
    channelTokenRx.value = _channelToken;
    if (_authToken.isEmpty && _channelToken.isNotEmpty) {
      final map = _readGuestTokensByChannel();
      _guestToken = map[_channelToken] ?? '';
    }
    _client ??= ValueNotifier(_createClient());
  }

  /// Guest tokens per channel so switching A→B→A restores channel A's cart (guest mode).
  static const String _guestTokensByChannelKey = 'guest_tokens_by_channel';

  static Map<String, String> _readGuestTokensByChannel() {
    try {
      final raw = _storage.read(_guestTokensByChannelKey);
      if (raw == null) return {};
      final map = jsonDecode(raw.toString()) as Map<dynamic, dynamic>?;
      if (map == null) return {};
      return map.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
    } catch (_) {
      return {};
    }
  }

  static Future<void> _writeGuestTokensByChannel(Map<String, String> map) async {
    await _storage.write(_guestTokensByChannelKey, jsonEncode(map));
  }

  /// Ensures the guest token is in the client before calling authenticate, so the server can merge
  /// the guest cart with the logged-in customer (no ClaimGuestOrder needed). Call before OTP/Google/Apple login.
  static Future<void> ensureGuestSessionForLogin() async {
    if (_authToken.isNotEmpty) return; // Already logged in
    final channel = _channelToken.isNotEmpty ? _channelToken : (_storage.read('channel_token')?.toString() ?? '');
    if (channel.isEmpty) return;
    final map = _readGuestTokensByChannel();
    final stored = map[channel] ?? '';
    if (stored.isNotEmpty && _guestToken != stored) {
      _guestToken = stored;
      _client?.value = _createClient();
    }
  }

  /// Call after any shop-api response when user is guest: saves vendure-auth-token so login sends it for cart merge.
  /// Also stores guest token per channel so cart persists when app is closed/reopened and when switching A→B→A.
  static Future<void> captureGuestTokenFromResponse(dynamic response) async {
    if (_authToken.isNotEmpty) return; // Already logged in
    try {
      final ctx = response.context.entry<HttpLinkResponseContext>();
      final token = ctx?.headers?['vendure-auth-token']?.trim();
      if (token != null && token.isNotEmpty && _guestToken != token) {
        _guestToken = token;
        final channel = _channelToken.isNotEmpty ? _channelToken : (_storage.read('channel_token')?.toString() ?? '');
        if (channel.isNotEmpty) {
          final map = _readGuestTokensByChannel();
          map[channel] = token;
          await _writeGuestTokensByChannel(map); // Await so token is persisted before app may close
        }
        _client?.value = _createClient();
      }
    } catch (_) {}
  }

  // Generic setter for token
  static Future<void> setToken({required String key, required String token}) async {
    if (key == 'auth') {
      if (_authToken != token) _authToken = token;
      _guestToken = ''; // Clear guest token after successful login
    } else if (key == 'channel') {
      // Force channel token to always be the default (ind-Swadkerala)
      final enforced = _defaultChannelToken;
      if (_channelToken != enforced) {
        _channelToken = enforced;
        channelTokenRx.value = enforced;
        // Restore guest token for this channel so A→B→A shows channel A's cart (guest mode)
        if (_authToken.isEmpty && token.isNotEmpty) {
          final map = _readGuestTokensByChannel();
          _guestToken = map[token] ?? '';
        }
      }
    }
    await _storage.write('${key}_token', token);
    _client?.value = _createClient();
  }

  // Generic clear token
  static Future<void> clearToken(String key) async {
// print("🗑️ clearToken called for $key");
    if (key == 'auth') {
      _authToken = "";
      // Do not clear _guestToken here: login page clears auth to show form, but we must keep
      // guest session so the authenticate() request carries it and the shop API can merge guest cart.
    }
    if (key == 'channel') {
      // Reset to default channel instead of clearing
      _channelToken = _defaultChannelToken;
      channelTokenRx.value = _defaultChannelToken;
    }
    if (key != 'channel') {
      await _storage.remove('${key}_token');
    }
    _client?.value = _createClient();
// print("✅ $key token cleared and client recreated");
  }

  /// Guest order code (from getActiveOrder when not logged in). Claimed after login via claimGuestOrder.
  static const String _guestOrderCodeKey = 'guest_order_code';
  static String get guestOrderCode => _storage.read(_guestOrderCodeKey)?.toString() ?? '';
  static Future<void> setGuestOrderCode(String code) async {
    if (code.trim().isEmpty) {
      await _storage.remove(_guestOrderCodeKey);
      // debugPrint('[GuestOrderCode] cleared (empty)');
    } else {
      await _storage.write(_guestOrderCodeKey, code.trim());
      // debugPrint('[GuestOrderCode] saved code="${code.trim()}"');
    }
  }
  static Future<void> clearGuestOrderCode() async => _storage.remove(_guestOrderCodeKey);

  /// Clear all guest session data (token + order code + per-channel tokens).
  /// Call on logout to ensure no stale guest state remains.
  static Future<void> clearGuestSession() async {
    _guestToken = '';
    await _storage.remove(_guestTokensByChannelKey);
    await clearGuestOrderCode();
    _client?.value = _createClient();
  }

  // Getters
  static String get authToken => _authToken;
  /// Channel token — always returns the default (ind-Swadkerala).
  static String get channelToken => _defaultChannelToken;
  static String get guestToken => _guestToken;
}