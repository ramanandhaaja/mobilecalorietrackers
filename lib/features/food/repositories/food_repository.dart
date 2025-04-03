import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobilecalorietrackers/core/constants/api_constants.dart';
import 'package:mobilecalorietrackers/core/constants/storage_keys.dart';

import '../models/food_entry.dart';
import '../models/weekly_food_data.dart';
import 'i_food_repository.dart';

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

      // Get today's date range in local time
      final now = DateTime.now();
      final localStartOfDay = DateTime(now.year, now.month, now.day);
      final localEndOfDay = localStartOfDay.add(const Duration(days: 1));

      // Convert to UTC for API
      final startOfDay = localStartOfDay.toUtc();
      final endOfDay = localEndOfDay.toUtc().subtract(const Duration(milliseconds: 1));

      print('Today date range (local): ${{'now': now.toUtc().toIso8601String(), 'startOfDay': startOfDay.toIso8601String(), 'endOfDay': endOfDay.toIso8601String(), 'timezone': DateTime.now().timeZoneName}}');

      final queryParameters = {
        'userId': userId,
        'startDate': startOfDay.toIso8601String(),
        'endDate': endOfDay.toIso8601String(),
      };

      _dio.options.validateStatus = (status) => true;
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/food-mobile',
        queryParameters: queryParameters,
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

  @override
  Future<WeeklyFoodData> getWeekFoodEntries() async {
    try {
      // Get today's date (April 3, 2025)
      final now = DateTime.now();
      
      // Calculate last Monday (March 31, 2025)
      final lastMonday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
      
      // Set time to start of day for Monday in UTC (March 31, 2025 00:00:00 UTC)
      final startDate = DateTime.utc(
        lastMonday.year, 
        lastMonday.month, 
        lastMonday.day,
      );
      
      // Set end date to Sunday at end of day in UTC (April 6, 2025 23:59:59 UTC)
      final endDate = DateTime.utc(
        startDate.year,
        startDate.month,
        startDate.day + 6,
        23,
        59,
        59,
      );

      print('Date calculations:');
      print('- Today (local): ${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}');
      print('- Last Monday (local): ${DateFormat('yyyy-MM-dd HH:mm:ss').format(lastMonday)}');
      print('- Start date (UTC): ${startDate.toIso8601String()}');
      print('- End date (UTC): ${endDate.toIso8601String()}');

      final userId = await _storage.read(key: StorageKeys.userId);
      final token = await _storage.read(key: StorageKeys.authToken);

      if (userId == null || token == null) {
        throw Exception('User not authenticated');
      }

      final queryParameters = {
        'userId': userId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      print('API Request Parameters:');
      queryParameters.forEach((key, value) => print('- $key: $value'));

      _dio.options.validateStatus = (status) => true;
      
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/food-mobile',
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final weeklyData = WeeklyFoodData.fromJson(response.data);
        print('Weekly Data parsed successfully:');
        print('- Total entries: ${weeklyData.entries.length}');
        print('- Days with data: ${weeklyData.entries.map((e) => DateFormat('yyyy-MM-dd').format(e.date)).toSet().join(', ')}');
        print('- Weekly calories: ${weeklyData.entries.fold(0, (sum, entry) => sum + entry.calories)}');
        return weeklyData;
      }

      throw Exception('Failed to fetch weekly food entries');
    } catch (e) {
      print('Error fetching weekly food entries: $e');
      rethrow;
    }
  }
}

final foodRepositoryProvider = Provider<IFoodRepository>((ref) {
  return FoodRepository();
});
