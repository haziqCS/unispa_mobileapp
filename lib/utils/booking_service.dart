import 'package:dio/dio.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:unispa_mobileapp/utils/auth_service.dart';

class BookingService {
  final Dio _dio = Dio();

  Future<List<dynamic>> getBookings() async {
    final token = await AuthService().getToken();
    final response = await _dio.get(
      '${Config.apiURL}bookings',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return response.data['bookings'];
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<Map<String, dynamic>> createBooking({
  required String bookingDate,
  required String paymentMethod,
  String? notes,
  required List<Map<String, dynamic>> items,
}) async {
  final token = await AuthService().getToken();
  final url = '${Config.apiURL}/bookings';

  print('===> [BookingService] POST $url');
  print('===> [BookingService] Authorization: Bearer $token');
  print('===> [BookingService] Data: booking_date=$bookingDate, payment_method=$paymentMethod, notes=$notes, items=$items');

  try {
    final response = await _dio.post(
      url,
      data: {
        'booking_date': bookingDate,
        'payment_method': paymentMethod,
        'notes': notes,
        'items': items,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    print('===> [BookingService] RESPONSE STATUS: ${response.statusCode}');
    print('===> [BookingService] RESPONSE DATA: ${response.data}');

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to create booking: Status ${response.statusCode} Data: ${response.data}');
    }
  } catch (e) {
    print('===> [BookingService] DioException: $e');
    rethrow;
  }
}

  Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    final token = await AuthService().getToken();
    final response = await _dio.put(
      '${Config.apiURL}/bookings/$bookingId/cancel',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to cancel booking');
    }
  }

  Future<Map<String, dynamic>> updateBooking({
    required int bookingId,
    required String bookingDate,
    required String paymentMethod,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    final token = await AuthService().getToken();
    final response = await _dio.put(
      '${Config.apiURL}/bookings/$bookingId',
      data: {
        'booking_date': bookingDate,
        'payment_method': paymentMethod,
        'notes': notes,
        'items': items,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to update booking');
    }
  }

  Future<Map<String, dynamic>> fetchPackages() async {
    // DO NOT send Authorization for /v1/packages
    final response = await _dio.get('${Config.apiURL}v1/packages');

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load packages');
    }
  }
}
