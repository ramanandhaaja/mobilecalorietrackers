import 'package:hive/hive.dart';

part 'food_entry.g.dart';

@HiveType(typeId: 0)
class FoodEntry extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String portion;
  
  @HiveField(3)
  final int calories;
  
  @HiveField(4)
  final int protein;
  
  @HiveField(5)
  final int carbs;
  
  @HiveField(6)
  final int fat;
  
  @HiveField(7)
  final String mealType;
  
  @HiveField(8)
  final DateTime date;

  FoodEntry({
    required this.id,
    required this.name,
    required this.portion,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.mealType,
    required this.date,
  });

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['id'].toString(),
      name: json['name'] as String,
      portion: json['portion'] as String,
      calories: json['calories'] as int,
      protein: json['protein'] as int,
      carbs: json['carbs'] as int,
      fat: json['fat'] as int,
      mealType: json['mealType'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
