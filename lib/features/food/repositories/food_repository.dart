import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobilecalorietrackers/core/constants/api_constants.dart';
import 'package:mobilecalorietrackers/core/constants/storage_keys.dart';

import '../models/food_entry.dart';

abstract class IFoodRepository {
  Future<List<FoodEntry>> getTodayFoodEntries();
}

class FoodRepository implements IFoodRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  late Box<FoodEntry> _foodBox;
  static const String _boxName = 'food_entries';

  FoodRepository({Dio? dio, FlutterSecureStorage? storage})
    : _dio = dio ?? Dio(),
      _storage = storage ?? const FlutterSecureStorage() {
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      _foodBox = await Hive.openBox<FoodEntry>(_boxName);
    } catch (e) {
      debugPrint('Error initializing Hive box: $e');
    }
  }

  List<FoodEntry> _getCachedEntries() {
    try {
      // Use local time to determine the date range
      final now = DateTime.now();
      final localStartOfDay = DateTime(now.year, now.month, now.day);
      final localEndOfDay = localStartOfDay.add(const Duration(days: 1));

      // Convert to UTC for comparison
      final startOfDay = localStartOfDay.toUtc();
      final endOfDay = localEndOfDay.toUtc();

      return _foodBox.values
          .where(
            (entry) =>
                entry.date.isAfter(startOfDay) && entry.date.isBefore(endOfDay),
          )
          .toList();
    } catch (e) {
      debugPrint('Error getting cached entries: $e');
      return [];
    }
  }

  Future<void> _cacheEntries(List<FoodEntry> entries) async {
    try {
      await _foodBox.clear();
      for (var entry in entries) {
        await _foodBox.put(entry.id, entry);
      }
      debugPrint('Cached ${entries.length} entries');
    } catch (e) {
      debugPrint('Error caching entries: $e');
    }
  }

  @override
  Future<List<FoodEntry>> getTodayFoodEntries() async {
    try {
      // First, try to get cached entries
      final cachedEntries = _getCachedEntries();
      if (cachedEntries.isNotEmpty) {
        debugPrint('Returning ${cachedEntries.length} cached entries');
        // Fetch fresh data in background
        _fetchAndCacheEntries();
        return cachedEntries;
      }

      return await _fetchAndCacheEntries();
    } catch (e) {
      debugPrint('Error in getTodayFoodEntries: $e');
      rethrow;
    }
  }

  Future<List<FoodEntry>> _fetchAndCacheEntries() async {
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
        final foodEntries =
            entries.map((entry) => FoodEntry.fromJson(entry)).toList();

        // Cache the new entries
        await _cacheEntries(foodEntries);
        debugPrint('Fetched and cached ${foodEntries.length} entries');
        return foodEntries;
      } else {
        debugPrint('Failed to load food entries: ${response.statusCode}');
        throw Exception('Failed to load food entries');
      }
    } catch (e) {
      debugPrint('Error loading food entries: $e');
      throw Exception('Error loading food entries: $e');
    }
  }
}

final foodRepositoryProvider = Provider<IFoodRepository>((ref) {
  return FoodRepository();
});
