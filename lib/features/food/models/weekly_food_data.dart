import 'package:json_annotation/json_annotation.dart';
import 'food_entry.dart';
import 'macro_totals.dart';

part 'weekly_food_data.g.dart';

@JsonSerializable()
class WeeklyFoodData {
  @JsonKey(name: 'entries')
  final List<FoodEntry> entries;
  
  @JsonKey(name: 'totalMacros')
  final MacroTotals weeklyTotals;
  
  @JsonKey(name: 'totalCount')
  final int totalCount;
  
  // Computed fields
  final Map<String, DailyData> dailyData;
  final int dailyAverage;
  final List<int> calorieValues;

  const WeeklyFoodData({
    required this.entries,
    required this.weeklyTotals,
    required this.totalCount,
    required this.dailyData,
    required this.dailyAverage,
    required this.calorieValues,
  });

  factory WeeklyFoodData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return WeeklyFoodData(
        entries: [],
        weeklyTotals: MacroTotals(calories: 0, protein: 0, carbs: 0, fat: 0),
        totalCount: 0,
        dailyData: {},
        dailyAverage: 0,
        calorieValues: List.filled(7, 0),
      );
    }

    // Parse entries
    final List<dynamic> entriesList = json['entries'] as List<dynamic>? ?? [];
    final List<FoodEntry> entries = entriesList
        .map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
        .toList();

    // Parse total macros
    final MacroTotals totalMacros = json['totalMacros'] != null
        ? MacroTotals.fromJson(json['totalMacros'] as Map<String, dynamic>)
        : MacroTotals(calories: 0, protein: 0, carbs: 0, fat: 0);

    // Group entries by date
    final Map<String, List<FoodEntry>> entriesByDate = {};
    for (final entry in entries) {
      final dateKey = entry.date.toIso8601String().split('T')[0];
      entriesByDate.putIfAbsent(dateKey, () => []).add(entry);
    }

    // Create daily data
    final Map<String, DailyData> dailyData = {};
    entriesByDate.forEach((date, dateEntries) {
      final macros = dateEntries.fold(
        MacroTotals(calories: 0, protein: 0, carbs: 0, fat: 0),
        (MacroTotals acc, FoodEntry entry) => MacroTotals(
          calories: acc.calories + entry.calories,
          protein: acc.protein + entry.protein,
          carbs: acc.carbs + entry.carbs,
          fat: acc.fat + entry.fat,
        ),
      );
      dailyData[date] = DailyData(entries: dateEntries, totalMacros: macros);
    });

    // Calculate daily average
    final dailyAverage = entries.isEmpty 
        ? 0 
        : (totalMacros.calories / entries.length).round();

    // Create calorie history
    final now = DateTime.now();
    final List<int> calorieValues = List.filled(7, 0);
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = date.toIso8601String().split('T')[0];
      if (dailyData.containsKey(dateKey)) {
        calorieValues[6 - i] = dailyData[dateKey]!.totalMacros?.calories ?? 0;
      }
    }

    return WeeklyFoodData(
      entries: entries,
      weeklyTotals: totalMacros,
      totalCount: json['totalCount'] as int? ?? 0,
      dailyData: dailyData,
      dailyAverage: dailyAverage,
      calorieValues: calorieValues,
    );
  }

  Map<String, dynamic> toJson() => _$WeeklyFoodDataToJson(this);
}

@JsonSerializable()
class DailyData {
  final List<FoodEntry> entries;
  final MacroTotals? totalMacros;

  const DailyData({
    required this.entries,
    this.totalMacros,
  });

  factory DailyData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DailyData(entries: [], totalMacros: null);
    }

    return DailyData(
      entries: (json['entries'] as List<dynamic>?)
          ?.map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      totalMacros: json['macros'] != null
          ? MacroTotals.fromJson(json['macros'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$DailyDataToJson(this);
}
