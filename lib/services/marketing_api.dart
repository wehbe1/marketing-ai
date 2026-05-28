import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketingApi {
  static const String _baseUrl = 'http://localhost:8000';

  static Future<Map<String, dynamic>> analyzeMarketing(
    Map<String, dynamic> marketingJson,
  ) async {
    final url = Uri.parse('$_baseUrl/analyze/marketing');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(marketingJson),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed: ${response.statusCode} ${response.body}');
    }
  }
}
