import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobilecalorietrackers/core/constants/api_constants.dart';
import 'package:mobilecalorietrackers/features/auth/models/login_response.dart';

abstract class IAuthRepository {
  Future<LoginResponse> login(String email, String password);
  Future<void> logout();
}

class AuthRepository implements IAuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepository({Dio? dio, FlutterSecureStorage? storage})
      : _dio = dio ?? Dio(),
        _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      _dio.options.validateStatus = (status) => true;

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/users/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 308) {
        // Handle redirect by updating the URL and retrying
        final redirectUrl = response.headers.value('location');
        if (redirectUrl != null) {
          final redirectResponse = await _dio.post(
            redirectUrl,
            data: {
              'email': email,
              'password': password,
            },
          );
          
          if (redirectResponse.statusCode == 200) {
            return LoginResponse.fromJson(redirectResponse.data);
          }
        }
        throw Exception('Redirect failed');
      }

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }

      throw Exception(response.data?['message'] ?? 'Login failed');
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'auth-token');
    await _storage.delete(key: 'user-name');
  }
}
