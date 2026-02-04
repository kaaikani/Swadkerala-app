import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'graphql_client.dart';

/// Centralized service for managing channel information
/// Handles channel token, code, name, type, and postal code
/// Examples: "ind-snacks", "ind-non-veg", etc.
class ChannelService {
  static final GetStorage _storage = GetStorage();
  
  // Storage keys
  static const String _channelTokenKey = 'channel_token';
  static const String _channelCodeKey = 'channel_code';
  static const String _channelNameKey = 'channel_name';
  static const String _channelTypeKey = 'channel_type';
  static const String _postalCodeKey = 'postal_code';

  /// Get channel token
  static String? getChannelToken() {
    return _storage.read(_channelTokenKey);
  }

  /// Get channel code (e.g., "ind-snacks", "ind-non-veg")
  static String? getChannelCode() {
    return _storage.read(_channelCodeKey);
  }

  /// Get channel name
  static String? getChannelName() {
    return _storage.read(_channelNameKey);
  }

  /// Get channel type
  static String? getChannelType() {
    return _storage.read(_channelTypeKey);
  }

  /// Get postal code
  static String? getPostalCode() {
    return _storage.read(_postalCodeKey);
  }

  /// Set channel information
  /// This also updates the GraphQL service with the channel token
  static Future<void> setChannelInfo({
    String? token,
    String? code,
    String? name,
    String? type,
    String? postalCode,
  }) async {
    debugPrint('[UpdateLocation] ChannelService.setChannelInfo called: code=$code, name=$name, type=$type, postalCode=$postalCode, token=${token != null ? "***" : null}');
    if (token != null) {
      await _storage.write(_channelTokenKey, token);
      await GraphqlService.setToken(key: 'channel', token: token);
      debugPrint('[UpdateLocation] ChannelService: channel_token and GraphQL token written');
    }
    if (code != null) {
      await _storage.write(_channelCodeKey, code);
      debugPrint('[UpdateLocation] ChannelService: channel_code=$code written');
    }
    if (name != null) {
      await _storage.write(_channelNameKey, name);
      debugPrint('[UpdateLocation] ChannelService: channel_name=$name written');
    }
    if (type != null) {
      await _storage.write(_channelTypeKey, type);
      debugPrint('[UpdateLocation] ChannelService: channel_type=$type written');
    }
    if (postalCode != null) {
      await _storage.write(_postalCodeKey, postalCode);
      debugPrint('[UpdateLocation] ChannelService: postal_code=$postalCode written');
    }
    debugPrint('[UpdateLocation] ChannelService.setChannelInfo done');
  }

  /// Check if channel is set (has token)
  static bool hasChannel() {
    final token = getChannelToken();
    return token != null && token.toString().isNotEmpty;
  }

  /// Check if a specific channel code is active
  /// Examples: isChannelActive('ind-snacks'), isChannelActive('ind-non-veg')
  static bool isChannelActive(String channelCode) {
    final currentCode = getChannelCode();
    return currentCode != null && 
           currentCode.toString().toLowerCase() == channelCode.toLowerCase();
  }

  /// Clear all channel information
  static Future<void> clearChannel() async {
    await _storage.remove(_channelTokenKey);
    await _storage.remove(_channelCodeKey);
    await _storage.remove(_channelNameKey);
    await _storage.remove(_channelTypeKey);
    await _storage.remove(_postalCodeKey);
    await GraphqlService.clearToken('channel');
  }

  /// Get all channel information as a map
  static Map<String, dynamic> getAllChannelInfo() {
    return {
      'token': getChannelToken(),
      'code': getChannelCode(),
      'name': getChannelName(),
      'type': getChannelType(),
      'postalCode': getPostalCode(),
    };
  }
}

