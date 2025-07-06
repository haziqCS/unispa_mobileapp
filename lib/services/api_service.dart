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
      final groupedPackages = jsonData['packages'] as Map<String, dynamic>?;

      if (groupedPackages == null) {
        throw Exception('No packages found');
      }

      final flatPackages = groupedPackages.values
          .whereType<List<dynamic>>()
          .expand((list) => list)
          .toList();

      print('Fetched packages: $flatPackages');

      return flatPackages;
    } else {
      throw Exception('Failed to load packages');
    }
  }

  Future<bool> deletePackage(int packageId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/v1/packages/$packageId'),
      headers: {'Accept': 'application/json'},
    );

    return response.statusCode == 200;
  }

  Future<bool> addPackage({
    required String packageName,
    required String description,
    required double packagePrice,
    required String duration,
    required int capacity,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/packages'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'package_name': packageName,
        'package_desc': description,
        'package_price': packagePrice,
        'duration': duration,
        'capacity': capacity,
      }),
    );

    return response.statusCode == 201;
  }

  Future<bool> updatePackage({
    required int packageId,
    required String packageName,
    required String packageDesc, // <-- packageDesc param here
    required List<Map<String, dynamic>> options, // <-- options list here
  }) async {
    final url = '$baseUrl/v1/packages/$packageId';
    final body = {
      'package_name': packageName,
      'description':
          packageDesc, // <-- use package_desc as expected by backend
      'options': options, // <-- send options array
    };

    print('📤 PUT $url');
    print('📤 Body: ${json.encode(body)}');

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    print('🔵 Status: ${response.statusCode}');
    print('🔵 Response: ${response.body}');

    return response.statusCode == 200;
  }
}
