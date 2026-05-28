import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants.dart';
import '../models/post_generator_models.dart';

class PostGeneratorService {
  static Future<PostGeneratorResponse> generatePost(
    PostGeneratorRequest request,
  ) async {
    final url = Uri.parse(ApiConstants.generatePost);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return PostGeneratorResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        "Failed to generate post: ${response.statusCode} ${response.body}",
      );
    }
  }
}
