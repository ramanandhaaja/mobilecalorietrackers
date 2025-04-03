import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/macro_totals.dart';

class MacroSummaryCard extends StatelessWidget {
  final MacroTotals macros;
  final String title;

  const MacroSummaryCard({
    super.key,
    required this.macros,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MacroItem(
                  label: 'Calories',
                  value: macros.calories,
                  color: theme.colorScheme.primary,
                ),
                _MacroItem(
                  label: 'Protein',
                  value: macros.protein,
                  color: theme.colorScheme.secondary,
                  unit: 'g',
                ),
                _MacroItem(
                  label: 'Carbs',
                  value: macros.carbs,
                  color: theme.colorScheme.tertiary,
                  unit: 'g',
                ),
                _MacroItem(
                  label: 'Fat',
                  value: macros.fat,
                  color: theme.colorScheme.error,
                  unit: 'g',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final String unit;

  const _MacroItem({
    required this.label,
    required this.value,
    required this.color,
    this.unit = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(height: 4.h),
        Text(
          '$value${unit.isNotEmpty ? unit : ''}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
