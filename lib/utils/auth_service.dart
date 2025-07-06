import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_client.dart';
import 'config.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
        //options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = response.data;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', data['token']);

      return {'success': true, 'user': data['user'], 'token': data['token']};
    } on DioException catch (e) {
      print('Dio error: ${e.response}');
      final message =
          e.response?.data is Map && e.response?.data['message'] != null
          ? e.response!.data['message']
          : e.message ?? 'Login failed';

      return {'success': false, 'message': message};
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? gender,
    String? phoneNo,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'gender': gender ?? '',
          'phone_no': phoneNo ?? '',
        },
      );

      final data = response.data;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', data['token']);

      return {'success': true, 'user': data['user'], 'token': data['token']};
    } on DioException catch (e) {
      print('Dio register error: ${e.response}');
      final message =
          e.response?.data is Map && e.response?.data['message'] != null
          ? e.response!.data['message']
          : e.message ?? 'Registration failed';

      return {'success': false, 'message': message};
    }
  }

  Future<bool> logout() async {
    try {
      await _dio.post('/logout');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final token = await getToken(); // your logic for token
    final response = await _dio.get(
      '${Config.apiURL}${Config.profileAPI}', // make sure this is your /v1/me
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['user'];
    }
    return null;
  }

  Future<bool> updateProfile({
    required String token,
    required String name,
    required String email,
    required String gender,
    required String phone,
  }) async {
    try {
      final response = await _dio.put(
        '${Config.apiURL}${Config.profileAPI}',
        data: {
          'name': name,
          'email': email,
          'gender': gender,
          'phone_no': phone,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Update profile failed: $e');
      return false;
    }
  }

  

}
