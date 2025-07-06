import 'package:dio/dio.dart';
import 'config.dart'; // your config.dart with apiURL

class InvoiceService {
  final Dio _dio = Dio();

  // Fetch invoices for current user (needs auth token)
  Future<List<dynamic>> fetchInvoices(String token) async {
    try {
      final response = await _dio.get(
        '${Config.apiURL}invoices',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return response.data['invoices'] as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch invoices: $e');
    }
  }

  // Fetch single invoice by id (optional)
  Future<Map<String, dynamic>> fetchInvoiceById(String token, int id) async {
    try {
      final response = await _dio.get(
        '${Config.apiURL}invoices/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return response.data['invoice'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch invoice $id: $e');
    }
  }
}
