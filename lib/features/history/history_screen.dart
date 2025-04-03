import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart';
import 'package:mobilecalorietrackers/features/dashboard/widgets/curved_wave_clipper.dart';
import 'package:mobilecalorietrackers/features/dashboard/widgets/dashboard_bottom_nav_bar.dart';
import 'package:mobilecalorietrackers/features/food/providers/history_provider.dart';
import './widgets/horizontal_calendar.dart';
import './widgets/weekly_calorie_chart.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String? selectedMealType;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    Future.microtask(() {
      ref.read(historyProvider.notifier).fetchWeeklyData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyProvider);
    final theme = Theme.of(context);

    // Get the week dates for the calendar
    final startOfWeek = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1),
    );
    final weekDates = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    if (state.isLoading && state.entriesByDate.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Create chart data from history state
    final chartData =
        weekDates.map((date) {
          final dateStr = DateFormat('yyyy-MM-dd').format(date);
          final total = state.getDailyTotals(dateStr);
          return DailyCalorieData(
            date: date,
            calories: total.calories.toDouble(),
          );
        }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String?>(
            initialValue: selectedMealType,
            onSelected: (value) {
              setState(() {
                selectedMealType = value;
              });
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: null, child: Text('All Meals')),
                  const PopupMenuItem(
                    value: 'breakfast',
                    child: Text('Breakfast'),
                  ),
                  const PopupMenuItem(value: 'lunch', child: Text('Lunch')),
                  const PopupMenuItem(value: 'dinner', child: Text('Dinner')),
                  const PopupMenuItem(value: 'snack', child: Text('Snack')),
                ],
          ),
        ],
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
          RefreshIndicator(
            onRefresh: () async {
              await ref.read(historyProvider.notifier).fetchWeeklyData();
            },
            child: ListView(
              children: [
                // Horizontal Calendar
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                  padding: EdgeInsets.symmetric(vertical: 0.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: HorizontalCalendar(
                    availableDates: weekDates,
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                      ref.read(historyProvider.notifier).selectDate(date);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Weekly Chart
                      WeeklyCalorieChart(data: chartData),
                      SizedBox(height: 24.h),
                      // Daily Entries
                      ...state.entriesByDate.entries.map((entry) {
                        final date = DateTime.parse(entry.key);
                        final isSelected = DateUtils.isSameDay(
                          date,
                          selectedDate,
                        );
                        final entries = state.getFilteredEntries(
                          entry.key,
                          selectedMealType,
                        );

                        if (!isSelected) return const SizedBox.shrink();

                        return Column(
                          children: [
                            Card(
                              margin: EdgeInsets.only(bottom: 16.h),
                              elevation: 2,
                              child: Padding(
                                padding: EdgeInsets.all(16.r),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateUtils.isSameDay(date, DateTime.now())
                                          ? 'Today'
                                          : DateFormat(
                                            'EEEE, MMM d',
                                          ).format(date),
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Total: ${state.getDailyTotals(entry.key).calories} calories',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: AppColors.primaryGreen,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const Divider(),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: entries.length,
                                      itemBuilder: (context, index) {
                                        final entry = entries[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(entry.name),
                                          subtitle: Text(entry.mealType),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${entry.calories} cal',
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors
                                                              .primaryGreen,
                                                    ),
                                              ),
                                              Text(
                                                '${entry.protein}g P • ${entry.carbs}g C • ${entry.fat}g F',
                                                style:
                                                    theme.textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const DashboardBottomNavBar(currentIndex: 1),
    );
  }
}
