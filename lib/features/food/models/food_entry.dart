class FoodEntry {
  final String id;
  final String name;
  final String portion;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String mealType;
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
