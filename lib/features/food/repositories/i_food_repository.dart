import '../models/food_entry.dart';
import '../models/weekly_food_data.dart';

abstract class IFoodRepository {
  Future<List<FoodEntry>> getTodayFoodEntries();
  Future<WeeklyFoodData> getWeekFoodEntries();
}
