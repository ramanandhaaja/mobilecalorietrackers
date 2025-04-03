// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_food_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyFoodData _$WeeklyFoodDataFromJson(Map<String, dynamic> json) =>
    WeeklyFoodData(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      weeklyTotals:
          MacroTotals.fromJson(json['totalMacros'] as Map<String, dynamic>),
      totalCount: (json['totalCount'] as num).toInt(),
      dailyData: (json['dailyData'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, DailyData.fromJson(e as Map<String, dynamic>?)),
      ),
      dailyAverage: (json['dailyAverage'] as num).toInt(),
      calorieValues: (json['calorieValues'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$WeeklyFoodDataToJson(WeeklyFoodData instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'totalMacros': instance.weeklyTotals,
      'totalCount': instance.totalCount,
      'dailyData': instance.dailyData,
      'dailyAverage': instance.dailyAverage,
      'calorieValues': instance.calorieValues,
    };

DailyData _$DailyDataFromJson(Map<String, dynamic> json) => DailyData(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalMacros: json['totalMacros'] == null
          ? null
          : MacroTotals.fromJson(json['totalMacros'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DailyDataToJson(DailyData instance) => <String, dynamic>{
      'entries': instance.entries,
      'totalMacros': instance.totalMacros,
    };
