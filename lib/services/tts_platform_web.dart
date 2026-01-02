// lib/services/tts_platform_web.dart
// Web implementation using the browser's SpeechSynthesis API via dart:html.

import 'dart:html' as html;

// Cache a preferred voice to avoid repeated selection and voiceschanged timing issues
html.SpeechSynthesisVoice? _cachedFemaleVoice;

html.SpeechSynthesisVoice? _pickFemaleVoice(html.SpeechSynthesis synth, {String? lang}) {
  try {
    final voices = synth.getVoices();
    if (voices.isEmpty) return null;

    html.SpeechSynthesisVoice? best;
    var bestScore = -9999;
    const femaleHints = <String>[
      'female', 'samantha', 'victoria', 'karen', 'moira', 'serena', 'tessa',
      'aria', 'zira', 'joanna', 'emma', 'amy', 'olivia', 'linda', 'salli',
      'google uk english female',
    ];

    for (final v in voices) {
      final name = (v.name ?? '').toLowerCase();
      final vlang = (v.lang ?? '').toLowerCase();
      var score = 0;
      if (vlang.startsWith('en')) score += 10;
      if (lang != null && vlang.startsWith(lang.toLowerCase())) score += 8;
      if (vlang.contains('us')) score += 5;
      if (femaleHints.any((h) => name.contains(h))) score += 50;
      if (name.contains('google')) score += 3;
      if (score > bestScore) { best = v; bestScore = score; }
    }
    return best;
  } catch (_) {
    return null;
  }
}

Future<bool> ttsPlatformSpeak(String text, {String? lang, double? rate, double? pitch}) async {
  try {
    final synth = html.window.speechSynthesis;
    if (synth == null) return false;

    // Prepare utterance
    final u = html.SpeechSynthesisUtterance(text);
    if (lang != null) u.lang = lang;
    if (rate != null) u.rate = rate.clamp(0.1, 2.0).toDouble();
    if (pitch != null) u.pitch = pitch.clamp(0.1, 2.0).toDouble();

    // Cancel any ongoing speech before starting
    if (synth.speaking == true) synth.cancel();

    // Pick and cache a female voice if available
    _cachedFemaleVoice ??= _pickFemaleVoice(synth, lang: lang);
    if (_cachedFemaleVoice != null) {
      try {
        u.voice = _cachedFemaleVoice;
      } catch (_) {}
    }
    synth.speak(u);
    return true;
  } catch (_) {
    return false;
  }
}
