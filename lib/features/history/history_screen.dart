import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart'; 
import 'package:mobilecalorietrackers/features/dashboard/widgets/curved_wave_clipper.dart'; 
import 'package:mobilecalorietrackers/features/dashboard/widgets/dashboard_bottom_nav_bar.dart';

// --- Data Models (Keep as is for now) ---
class MealLog {
  final String mealType; 
  final String foodName;
  final int calories;
  final DateTime time;

  MealLog({
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.time,
  });
}

class DailyLog {
  final DateTime date;
  final List<MealLog> meals;
  final int totalCaloriesConsumed;
  final int calorieGoal;

  DailyLog({
    required this.date,
    required this.meals,
    required this.totalCaloriesConsumed,
    required this.calorieGoal,
  });
}

// --- Sample Data (Keep as is for now) ---
final List<DailyLog> sampleDailyLogs = List.generate(7, (index) {
  final date = DateTime.now().subtract(Duration(days: index));
  final meals = [
    MealLog(mealType: 'Breakfast', foodName: 'Oatmeal', calories: 300, time: date.add(const Duration(hours: 8))),
    MealLog(mealType: 'Lunch', foodName: 'Chicken Salad', calories: 500, time: date.add(const Duration(hours: 13))),
    if (index % 2 == 0) 
      MealLog(mealType: 'Dinner', foodName: 'Salmon & Veggies', calories: 600, time: date.add(const Duration(hours: 19))),
    if (index % 3 == 0) 
      MealLog(mealType: 'Snack', foodName: 'Apple', calories: 95, time: date.add(const Duration(hours: 16))),
  ];
  final totalCalories = meals.fold(0, (sum, meal) => sum + meal.calories);
  return DailyLog(
    date: date,
    meals: meals,
    totalCaloriesConsumed: totalCalories,
    calorieGoal: 2000,
  );
});

// --- History Screen Widget ---
class HistoryScreen extends HookConsumerWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final dailyLogs = sampleDailyLogs;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        backgroundColor: Colors.transparent, 
        elevation: 0,
        foregroundColor: Colors.white, 
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: CurvedWaveClipper(),
            child: Container(
              height: 180.h, 
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.primaryGreen.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: kToolbarHeight + 60.h), 
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: dailyLogs.length,
              itemBuilder: (context, index) {
                return _buildDailyLogCard(context, dailyLogs[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const DashboardBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildDailyLogCard(BuildContext context, DailyLog log) {
    final theme = Theme.of(context);
    final bool isToday = DateUtils.isSameDay(log.date, DateTime.now());
    final dateFormat = DateFormat('EEEE, MMM d'); 

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ExpansionTile(
        key: PageStorageKey(log.date.toString()), 
        backgroundColor: theme.colorScheme.surface.withOpacity(0.5), 
        collapsedBackgroundColor: theme.colorScheme.surface, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)), 
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        leading: Icon(Icons.calendar_today, color: AppColors.primaryGreen),
        title: Text(
          isToday ? 'Today' : dateFormat.format(log.date),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${log.totalCaloriesConsumed} / ${log.calorieGoal} kcal',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        childrenPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        children: log.meals.map((meal) => _buildMealLogItem(context, meal)).toList(),
      ),
    );
  }

  Widget _buildMealLogItem(BuildContext context, MealLog meal) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h:mm a'); 

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.foodName,
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 2.h),
              Text(
                '${meal.mealType} • ${timeFormat.format(meal.time)}',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          Text(
            '${meal.calories} kcal',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
          ),
        ],
      ),
    );
  }
}
