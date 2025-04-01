import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobilecalorietrackers/core/constants/api_constants.dart';
import 'package:mobilecalorietrackers/core/constants/storage_keys.dart';
import 'package:mobilecalorietrackers/core/utils/logger.dart';
import 'package:mobilecalorietrackers/features/auth/models/login_response.dart';

abstract class IAuthRepository {
  Future<LoginResponse> login(String email, String password);
  Future<void> logout();
  Future<String?> getStoredToken();
  Future<bool> hasValidToken();
}

class AuthRepository implements IAuthRepository {
  // Using centralized storage keys
  final _tokenKey = StorageKeys.authToken;
  final _userNameKey = StorageKeys.userName;
  final _userIdKey = StorageKeys.userId;
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
            final loginResponse = LoginResponse.fromJson(redirectResponse.data);
            await _storage.write(key: _tokenKey, value: loginResponse.token);
            await _storage.write(key: _userIdKey, value: loginResponse.user.id.toString());
            Logger.info('Auth', 'Login successful - User ID: ${loginResponse.user.id}');
            return loginResponse;
          }
        }
        throw Exception('Redirect failed');
      }

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        await _storage.write(key: _tokenKey, value: loginResponse.token);
        await _storage.write(key: _userIdKey, value: loginResponse.user.id.toString());
        Logger.info('Auth', 'Login successful - User ID: ${loginResponse.user.id}');
        return loginResponse;
      }

      throw Exception(response.data?['message'] ?? 'Login failed');
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userNameKey);
    await _storage.delete(key: _userIdKey);
    Logger.info('Auth', 'User logged out successfully');
  }

  @override
  Future<String?> getStoredToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<bool> hasValidToken() async {
    final token = await getStoredToken();
    if (token == null) return false;

    try {
      // Verify token with the server
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
