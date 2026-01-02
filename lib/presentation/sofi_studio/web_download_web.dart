import 'dart:typed_data';
import 'package:web/web.dart' as web;
import 'dart:convert';
import 'package:flutter/foundation.dart';

// Uses DOM APIs to trigger a client-side download.
void downloadImageBytesImpl(Uint8List bytes, String name) {
  try {
    final b64 = base64Encode(bytes);
    final url = 'data:image/png;base64,$b64';

    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..download = name
      ..style.display = 'none';

    web.document.body?.appendChild(anchor);
    anchor.click();
    anchor.remove();
  } catch (e) {
    debugPrint('[WebDownload] Failed to trigger download: $e');
  }
}