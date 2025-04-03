import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_entry.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class FoodEntry extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id', fromJson: _idFromJson, toJson: _idToJson)
  final String id;
  
  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;
  
  @HiveField(2)
  @JsonKey(name: 'portion')
  final String portion;
  
  @HiveField(3)
  @JsonKey(name: 'calories')
  final int calories;
  
  @HiveField(4)
  @JsonKey(name: 'protein')
  final int protein;
  
  @HiveField(5)
  @JsonKey(name: 'carbs')
  final int carbs;
  
  @HiveField(6)
  @JsonKey(name: 'fat')
  final int fat;
  
  @HiveField(7)
  @JsonKey(name: 'mealType')
  final String mealType;
  
  @HiveField(8)
  @JsonKey(name: 'date', fromJson: _dateFromJson, toJson: _dateToJson)
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
    // Handle both integer and string IDs
    final dynamic rawId = json['id'];
    final String id = rawId is int ? rawId.toString() : rawId as String;
    
    return FoodEntry(
      id: id,
      name: json['name'] as String,
      portion: json['portion'] as String,
      calories: json['calories'] as int,
      protein: json['protein'] as int,
      carbs: json['carbs'] as int,
      fat: json['fat'] as int,
      mealType: json['mealType'] as String,
      date: _dateFromJson(json['date'] as String),
    );
  }
  
  Map<String, dynamic> toJson() => _$FoodEntryToJson(this);

  static DateTime _dateFromJson(String date) => DateTime.parse(date);
  static String _dateToJson(DateTime date) => date.toIso8601String();
  
  static String _idFromJson(dynamic id) => id is int ? id.toString() : id as String;
  static String _idToJson(String id) => id;
}
