import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechRecognitionService {
  static final SpeechRecognitionService _instance = SpeechRecognitionService._internal();
  factory SpeechRecognitionService() => _instance;
  SpeechRecognitionService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isAvailable = false;
  String _lastWords = '';

  /// Initialize speech recognition. On iOS we disable voice search (no mic permission or UI).
  Future<bool> initialize() async {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS) {
      _isAvailable = false;
      return false;
    }
    try {
      _isAvailable = await _speech.initialize(
        onError: (error) {
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
          }
        },
      );
      return _isAvailable;
    } catch (e) {
      
      // Handle MissingPluginException - plugin not properly linked
      if (e.toString().contains('MissingPluginException')) {
      }
      
      _isAvailable = false;
      return false;
    }
  }

  /// Check and request microphone permission. Not used on iOS (voice search disabled).
  Future<bool> checkAndRequestPermission() async {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS) return false;
    try {
      final status = await Permission.microphone.status;
      if (status.isGranted) {
        return true;
      }

      if (status.isDenied) {
        final result = await Permission.microphone.request();
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        // Open app settings
        await openAppSettings();
        return false;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Start listening for speech
  Future<void> startListening({
    required Function(String) onResult,
    Function()? onError,
  }) async {
    if (!_isAvailable) {
      final initialized = await initialize();
      if (!initialized) {
        onError?.call();
        return;
      }
    }

    // Check permission
    final hasPermission = await checkAndRequestPermission();
    if (!hasPermission) {
      onError?.call();
      return;
    }

    if (_isListening) {
      await stopListening();
    }

    try {
      _lastWords = '';
      _isListening = true;
      
      await _speech.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          if (result.finalResult) {
            _isListening = false;
            onResult(_lastWords);
          } else {
            // Update in real-time as user speaks
            onResult(_lastWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_IN', // Indian English locale
        cancelOnError: true,
        partialResults: true,
      );
      
    } catch (e) {
      _isListening = false;
      onError?.call();
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (_isListening) {
      try {
        await _speech.stop();
        _isListening = false;
      } catch (e) {
      }
    }
  }

  /// Cancel listening
  Future<void> cancelListening() async {
    if (_isListening) {
      try {
        await _speech.cancel();
        _isListening = false;
        _lastWords = '';
      } catch (e) {
      }
    }
  }

  /// Check if currently listening
  bool get isListening => _isListening;

  /// Check if speech recognition is available
  bool get isAvailable => _isAvailable;

  /// Get last recognized words
  String get lastWords => _lastWords;
}

