import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reads Google OAuth client IDs from .env (single place for all Google Sign-In call sites).
class GoogleAuthEnv {
  GoogleAuthEnv._();

  /// Web OAuth client ID (used as serverClientId for backend ID token verification).
  /// Required. Set GOOGLE_CLIENT_ID in .env.
  static String? get googleClientId => dotenv.env['GOOGLE_CLIENT_ID']?.trim().isEmpty == true
      ? null
      : dotenv.env['GOOGLE_CLIENT_ID'];

  /// iOS OAuth client ID. Required on iOS (Web client not allowed with custom URL scheme).
  /// Set GOOGLE_CLIENT_ID_IOS in .env for iOS.
  static String? get googleClientIdIos => dotenv.env['GOOGLE_CLIENT_ID_IOS']?.trim().isEmpty == true
      ? null
      : dotenv.env['GOOGLE_CLIENT_ID_IOS'];

  /// Client ID to use for the current platform: iOS uses GOOGLE_CLIENT_ID_IOS, Android uses null (google-services.json).
  static String? get clientIdForPlatform => Platform.isIOS ? googleClientIdIos : null;

  /// Whether iOS has required config (GOOGLE_CLIENT_ID_IOS must be set on iOS).
  static bool get isIosConfigValid => !Platform.isIOS || (googleClientIdIos != null && googleClientIdIos!.isNotEmpty);
}
