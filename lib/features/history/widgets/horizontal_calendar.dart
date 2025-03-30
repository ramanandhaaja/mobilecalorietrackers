import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart';

class HorizontalCalendar extends StatelessWidget {
  final List<DateTime> availableDates;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const HorizontalCalendar({
    Key? key,
    required this.availableDates,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  Widget _buildDateItem(
    BuildContext context,
    DateTime date,
    bool isSelected,
    bool isToday,
  ) {
    final theme = Theme.of(context);
    final dayNameFormat = DateFormat('E');
    final dayNumberFormat = DateFormat('d');

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          children: [
            Text(
              dayNameFormat.format(date).toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: InkWell(
                onTap: () => onDateSelected(date),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.cardColor,
                    border: Border.all(
                      color:
                          isSelected
                              ? AppColors.primaryGreen
                              : (isToday
                                  ? AppColors.primaryGreen
                                  : Colors.grey[300]!),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      dayNumberFormat.format(date),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            isSelected
                                ? AppColors.primaryGreen
                                : (isToday
                                    ? AppColors.primaryGreen
                                    : theme.textTheme.bodyLarge?.color),
                        fontWeight:
                            isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedDates =
        availableDates.toSet().toList()..sort((a, b) => a.compareTo(b));

    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final date = sortedDates[index];
          final isSelected = DateUtils.isSameDay(date, selectedDate);
          final isToday = DateUtils.isSameDay(date, DateTime.now());
          return _buildDateItem(context, date, isSelected, isToday);
        }),
      ),
    );
  }
}
