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

  Future<List<dynamic>> fetchAllPackagesFlat() async {
    final response = await http.get(Uri.parse('$baseUrl/v1/packages'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final groupedPackages = jsonData['packages'];

      if (groupedPackages == null) {
        throw Exception('No packages found');
      }

      final flatList = groupedPackages.values
          .where((element) => element is List)
          .expand((list) => list as List)
          .toList();

      print('Fetched packages: $flatList');

      return flatList;
    } else {
      throw Exception('Failed to load packages');
    }
  }
}
