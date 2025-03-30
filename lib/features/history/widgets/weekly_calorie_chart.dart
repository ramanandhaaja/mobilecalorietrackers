import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart';

// Represents calorie data for one day
class DailyCalorieData {
  final DateTime date;
  final double calories;

  DailyCalorieData({required this.date, required this.calories});
}

class WeeklyCalorieChart extends StatelessWidget {
  // Expect a list of data for the week
  final List<DailyCalorieData> weeklyData;
  final double maxCalories; // To set the Y-axis maximum

  const WeeklyCalorieChart({
    super.key,
    required this.weeklyData,
    this.maxCalories = 3000, // Default max, adjust as needed
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Ensure we have exactly 7 days of data for the chart
    // If not, you might want to handle this case (e.g., pad with zeros)
    if (weeklyData.length != 7) {
      // Placeholder for missing data - replace with actual handling if needed
      return Container(
        height: 200.h,
        alignment: Alignment.center,
        child: Text(
          'Insufficient data for weekly chart.',
          style: theme.textTheme.bodySmall,
        ),
      );
    }

    return Container(
      height: 220.h, // Adjust height as needed
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: theme.cardColor, // Use card color for background
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
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxCalories,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final data = weeklyData[groupIndex];
                return BarTooltipItem(
                  '${DateFormat('E').format(data.date)}\n',
                  theme.textTheme.bodySmall!.copyWith(color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${data.calories.toStringAsFixed(0)} kcal',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
              getTooltipColor: (_) => Colors.black87,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < weeklyData.length) {
                    final dayLetter = DateFormat(
                      'E',
                    ).format(weeklyData[index].date);
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0), // Mimic space
                      child: Text(dayLetter, style: theme.textTheme.bodySmall),
                    );
                  }
                  return Container();
                },
                reservedSize: 20,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  // Show fewer labels to avoid clutter
                  if (value == 0 ||
                      value == meta.max / 2 ||
                      value == meta.max) {
                    return Text(
                      value.toInt().toString(),
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.left,
                    );
                  }
                  return Container();
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false, // Hide border
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            // Draw horizontal lines
            getDrawingHorizontalLine:
                (value) =>
                    FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
          ),
          barGroups:
              weeklyData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data.calories,
                      color: AppColors.primaryGreen,
                      width: 16.w, // Adjust bar width
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
