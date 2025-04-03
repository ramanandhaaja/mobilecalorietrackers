import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobilecalorietrackers/core/constants/api_constants.dart';
import 'package:mobilecalorietrackers/core/constants/storage_keys.dart';
import 'package:mobilecalorietrackers/core/utils/logger.dart';
import 'package:mobilecalorietrackers/features/user/models/user_details.dart';

abstract class IUserRepository {
  Future<UserDetails?> getUserDetails();
  Future<void> saveUserDetailsLocally(UserDetails details);
  Future<UserDetails?> getLocalUserDetails();
  Future<void> clearLocalUserDetails();
}

class UserRepository implements IUserRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  // Using centralized storage keys
  final _tokenKey = StorageKeys.authToken;
  final _userIdKey = StorageKeys.userId;
  final _userDetailsKey = StorageKeys.userDetails;

  UserRepository({
    required Dio dio,
    required SharedPreferences prefs,
    required FlutterSecureStorage secureStorage,
  }) : _dio = dio,
       _prefs = prefs,
       _secureStorage = secureStorage;

  @override
  Future<UserDetails?> getUserDetails() async {
    try {
      // First try to get from local storage immediately
      final localDetails = await getLocalUserDetails();
      if (localDetails != null) {
        return localDetails;
      }

      final token = await _secureStorage.read(key: _tokenKey);
      final userId = await _secureStorage.read(key: _userIdKey);
      if (token == null || userId == null) {
        Logger.error('UserDetails', 'Missing token or userId');
        return null;
      }

      Logger.info('UserDetails', 'Fetching details for user ID: $userId');
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/user-details-mobile',
        queryParameters: {'userId': userId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        Logger.info('UserDetails', 'Successfully fetched user details');
        Logger.info(
          'UserDetails',
          'Raw response data: ${response.data.runtimeType} - ${response.data}',
        );

        try {
          final userDetails = UserDetails.fromJson(response.data);
          await saveUserDetailsLocally(userDetails);
          Logger.info('UserDetails', 'User details saved locally');
          return userDetails;
        } catch (e) {
          Logger.error('UserDetails', 'Error parsing user details', e);
          return null;
        }
      }
      Logger.error('UserDetails', 'No user details found in response');
      return null;
    } catch (e) {
      Logger.error('UserDetails', 'Error fetching user details', e);
      // If API fails, try to get from local storage
      return getLocalUserDetails();
    }
  }

  @override
  Future<void> saveUserDetailsLocally(UserDetails details) async {
    await _prefs.setString(_userDetailsKey, details.toJsonString());
  }

  @override
  Future<UserDetails?> getLocalUserDetails() async {
    final jsonString = _prefs.getString(_userDetailsKey);
    if (jsonString != null) {
      try {
        return UserDetails.fromJsonString(jsonString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearLocalUserDetails() async {
    await _prefs.remove(_userDetailsKey);
  }
}
