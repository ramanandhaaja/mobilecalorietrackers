import 'package:json_annotation/json_annotation.dart';

part 'macro_totals.g.dart';

@JsonSerializable()
class MacroTotals {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const MacroTotals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MacroTotals.zero() => const MacroTotals(
        calories: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
      );

  factory MacroTotals.fromJson(Map<String, dynamic> json) => 
      _$MacroTotalsFromJson(json);
  
  Map<String, dynamic> toJson() => _$MacroTotalsToJson(this);

  MacroTotals add({
    int calories = 0,
    int protein = 0,
    int carbs = 0,
    int fat = 0,
  }) {
    return MacroTotals(
      calories: this.calories + calories,
      protein: this.protein + protein,
      carbs: this.carbs + carbs,
      fat: this.fat + fat,
    );
  }
}
