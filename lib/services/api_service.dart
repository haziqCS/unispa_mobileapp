import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> fetchPackages() async {
    final response = await http.get(Uri.parse('$baseUrl/v1/packages'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['packages'];
    } else {
      throw Exception('Failed to load packages');
    }
  }
}
