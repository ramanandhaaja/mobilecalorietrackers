// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'macro_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MacroTotals _$MacroTotalsFromJson(Map<String, dynamic> json) => MacroTotals(
      calories: (json['calories'] as num).toInt(),
      protein: (json['protein'] as num).toInt(),
      carbs: (json['carbs'] as num).toInt(),
      fat: (json['fat'] as num).toInt(),
    );

Map<String, dynamic> _$MacroTotalsToJson(MacroTotals instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
    };
