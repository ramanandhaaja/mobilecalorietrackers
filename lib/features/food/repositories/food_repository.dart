import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecalorietrackers/core/constants/api_constants.dart';
import 'package:mobilecalorietrackers/core/constants/storage_keys.dart';

import '../models/food_entry.dart';

abstract class IFoodRepository {
  Future<List<FoodEntry>> getTodayFoodEntries();
}

class FoodRepository implements IFoodRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  FoodRepository({Dio? dio, FlutterSecureStorage? storage})
      : _dio = dio ?? Dio(),
        _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<List<FoodEntry>> getTodayFoodEntries() async {
    try {
      final userId = await _storage.read(key: StorageKeys.userId);
      final token = await _storage.read(key: StorageKeys.authToken);

      if (userId == null || token == null) {
        throw Exception('User not authenticated');
      }

      _dio.options.validateStatus = (status) => true;
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/food-mobile',
        queryParameters: {'userId': userId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final entries = data['entries'] as List;
        return entries.map((entry) => FoodEntry.fromJson(entry)).toList();
      } else {
        print('Failed to load food entries: ${response.statusCode}');
        throw Exception('Failed to load food entries');
      }
    } catch (e) {
      print('Error loading food entries: $e');
      throw Exception('Failed to load food entries: $e');
    }
  }
}

final foodRepositoryProvider = Provider<IFoodRepository>((ref) {
  return FoodRepository();
});
