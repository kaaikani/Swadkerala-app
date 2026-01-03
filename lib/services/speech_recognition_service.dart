import 'package:flutter/material.dart';
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

  /// Initialize speech recognition
  Future<bool> initialize() async {
    try {
      _isAvailable = await _speech.initialize(
        onError: (error) {
          debugPrint('[SpeechRecognition] Error: ${error.errorMsg}');
        },
        onStatus: (status) {
          debugPrint('[SpeechRecognition] Status: $status');
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
          }
        },
      );
      debugPrint('[SpeechRecognition] Initialized: $_isAvailable');
      return _isAvailable;
    } catch (e) {
      debugPrint('[SpeechRecognition] Initialization error: $e');
      
      // Handle MissingPluginException - plugin not properly linked
      if (e.toString().contains('MissingPluginException')) {
        debugPrint('[SpeechRecognition] ⚠️ Plugin not found. Please rebuild the app:');
        debugPrint('[SpeechRecognition]   1. Stop the app completely');
        debugPrint('[SpeechRecognition]   2. Uninstall the old app from device');
        debugPrint('[SpeechRecognition]   3. Run: flutter clean && flutter pub get');
        debugPrint('[SpeechRecognition]   4. Rebuild and install: flutter run');
      }
      
      _isAvailable = false;
      return false;
    }
  }

  /// Check and request microphone permission
  Future<bool> checkAndRequestPermission() async {
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
      debugPrint('[SpeechRecognition] Permission error: $e');
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
      debugPrint('[SpeechRecognition] Microphone permission denied');
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
            debugPrint('[SpeechRecognition] Final result: $_lastWords');
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
      
      debugPrint('[SpeechRecognition] Started listening');
    } catch (e) {
      debugPrint('[SpeechRecognition] Error starting: $e');
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
        debugPrint('[SpeechRecognition] Stopped listening');
      } catch (e) {
        debugPrint('[SpeechRecognition] Error stopping: $e');
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
        debugPrint('[SpeechRecognition] Cancelled listening');
      } catch (e) {
        debugPrint('[SpeechRecognition] Error cancelling: $e');
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

