import 'package:flutter/foundation.dart';

/// Utility helpers for working with HTML content returned from the API.
class HtmlUtils {
  HtmlUtils._();

  /// Removes HTML tags and decodes a handful of common entities.
  ///
  /// This avoids rendering raw markup snippets such as `<p>` in the UI.
  static String stripHtmlTags(String? html) {
    if (html == null || html.isEmpty) return '';

    // Remove all HTML tags.
    var text = html.replaceAll(RegExp(r'<[^>]*>', multiLine: true), ' ');

    // Decode a few common HTML entities manually.
    text = text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', '\'');

    // Collapse whitespace.
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    if (kDebugMode && text.isEmpty) {
      // Helpful when debugging unexpected blank strings coming from the API.
    }

    return text;
  }
}
