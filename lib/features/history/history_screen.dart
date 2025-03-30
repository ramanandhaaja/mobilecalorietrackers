import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart';
import 'package:mobilecalorietrackers/features/dashboard/widgets/curved_wave_clipper.dart';
import 'package:mobilecalorietrackers/features/dashboard/widgets/dashboard_bottom_nav_bar.dart';
import './widgets/horizontal_calendar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobilecalorietrackers/features/history/widgets/weekly_calorie_chart.dart';

// Helper function to get the start of the week (assuming Monday is the first day)
DateTime _startOfWeek(DateTime date) {
  return date.subtract(Duration(days: date.weekday - 1));
}

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
    MealLog(
      mealType: 'Breakfast',
      foodName: 'Oatmeal',
      calories: 300,
      time: date.add(const Duration(hours: 8)),
    ),
    MealLog(
      mealType: 'Lunch',
      foodName: 'Chicken Salad',
      calories: 500,
      time: date.add(const Duration(hours: 13)),
    ),
    if (index % 2 == 0)
      MealLog(
        mealType: 'Dinner',
        foodName: 'Salmon & Veggies',
        calories: 600,
        time: date.add(const Duration(hours: 19)),
      ),
    if (index % 3 == 0)
      MealLog(
        mealType: 'Snack',
        foodName: 'Apple',
        calories: 95,
        time: date.add(const Duration(hours: 16)),
      ),
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
    // State for the selected date, initialized to today
    final selectedDate = useState(DateTime.now());

    final allDailyLogs = sampleDailyLogs;

    // Calculate the week to display based on the selected date
    final startOfWeek = _startOfWeek(selectedDate.value);
    final weekDates = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    // Filter logs to show only for the selected date
    final displayedLogs =
        allDailyLogs
            .where((log) => DateUtils.isSameDay(log.date, selectedDate.value))
            .toList();

    // Sample Data for the Chart (Replace with actual weekly data)
    final sampleWeeklyData = List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: 6 - index));
      // Generate somewhat realistic random calorie data
      final calories = 1500 + (date.weekday * 100) + (index * 50.0);
      return DailyCalorieData(date: date, calories: calories);
    });

    // Calculate a reasonable max Y value (e.g., 1.2 times the max calorie in the sample)
    final maxSampleCalories = sampleWeeklyData.map((d) => d.calories).reduce((a, b) => a > b ? a : b);
    final chartMaxY = (maxSampleCalories * 1.2).ceilToDouble();

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
                  colors: [
                    AppColors.primaryGreen,
                    AppColors.primaryGreen.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Use SafeArea to avoid overlap with status bar and notch
          SafeArea(
            bottom:
                false, // Don't apply safe area to bottom since we have a nav bar
            child: Padding(
              padding: EdgeInsets.only(top: 0), // Adjust top padding
              child: Column(
                children: [
                  SizedBox(height: 0), // Add some spacing
                  // Wrap HorizontalCalendar in a Card or Container for styling
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 0.h,
                    ), // Add margin
                    padding: EdgeInsets.symmetric(vertical: 0.h), // Add padding
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: HorizontalCalendar(
                      // Pass the full week instead of just dates with logs
                      availableDates: weekDates,
                      selectedDate: selectedDate.value,
                      onDateSelected: (date) {
                        selectedDate.value =
                            date; // Update state when a date is tapped
                      },
                    ),
                  ),
                  SizedBox(height: 20.h), // Spacing between calendar and chart

                  // --- Weekly Calorie Chart ---
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: WeeklyCalorieChart(
                      weeklyData: sampleWeeklyData, // Pass sample data
                      maxCalories: chartMaxY, // Pass calculated max Y
                    ),
                  ),

                  SizedBox(height: 20.h), // Spacing before logs
                  // If no logs for the selected date, show a message
                  if (displayedLogs.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          'No logs for ${DateFormat('MMM d, yyyy').format(selectedDate.value)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        // Use the filtered list
                        itemCount: displayedLogs.length,
                        itemBuilder: (context, index) {
                          // Should only be one log per date in this filtered list, but we loop just in case
                          return _buildDailyLogCard(
                            context,
                            displayedLogs[index],
                          );
                        },
                      ),
                    ),
                ],
              ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        leading: Icon(Icons.calendar_today, color: AppColors.primaryGreen),
        title: Text(
          isToday ? 'Today' : dateFormat.format(log.date),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${log.totalCaloriesConsumed} / ${log.calorieGoal} kcal',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        childrenPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        children:
            log.meals.map((meal) => _buildMealLogItem(context, meal)).toList(),
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
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${meal.mealType} • ${timeFormat.format(meal.time)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Text(
            '${meal.calories} kcal',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
