import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageGenService {
  static const String _endpoint =
      "https://generateimagefunc-bv6sqztnoq-uc.a.run.app";

  static Future<String?> generateImage({
    required String initImageUrl,
    required String prompt,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "init_image": initImageUrl,
          "prompt": prompt,
          "model_id": "seededit-i2i",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["output"] != null) {
          return data["output"][0];
        }
      }

      print("Generation error: ${response.body}");
      return null;
    } catch (e) {
      print("Exception during image generation: $e");
      return null;
    }
  }
}
