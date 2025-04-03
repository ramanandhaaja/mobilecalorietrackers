import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobilecalorietrackers/core/constants/macro_constants.dart';
import 'package:mobilecalorietrackers/features/food/providers/food_provider.dart';
import 'dart:math'; // Import math for max function

class MacronutrientInfoSection extends ConsumerWidget {
  final int proteinGoal;
  final int carbsGoal;
  final int fatGoal;

  const MacronutrientInfoSection({
    Key? key,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodState = ref.watch(foodStateProvider);
    final macroTotals = ref.read(foodStateProvider.notifier).getTodayMacroTotals();

    if (foodState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (foodState.error != null) {
      return Center(child: Text('Error: ${foodState.error}'));
    }

    // Calculate remaining/over and status for each macro
    final proteinData = _calculateMacroData(macroTotals.protein, proteinGoal);
    final carbsData = _calculateMacroData(macroTotals.carbs, carbsGoal);
    final fatData = _calculateMacroData(macroTotals.fat, fatGoal);

    // Add Card styling similar to CalorieProgressCircle
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MacroCircle(
            valueText:
                proteinData['valueText']!, // Pass the value text (e.g., "45g")
            percentageValue:
                proteinData['percentageValue']!, // Pass double value for circle
            name: 'Protein',
            status: proteinData['status']!,
            color: MacroConstants.proteinColor,
          ),
          _MacroCircle(
            valueText: carbsData['valueText']!,
            percentageValue: carbsData['percentageValue']!,
            name: 'Carbs',
            status: carbsData['status']!,
            color: MacroConstants.carbsColor,
          ),
          _MacroCircle(
            valueText: fatData['valueText']!,
            percentageValue: fatData['percentageValue']!,
            name: 'Fats',
            status: fatData['status']!,
            color: MacroConstants.fatsColor,
          ),
        ],
      ),
    );
  }

  // Helper to calculate the display value and status
  Map<String, dynamic> _calculateMacroData(int consumed, int goal) {
    if (goal <= 0) {
      return {
        'valueText': '0/0g',
        'percentageValue': 0.0,
        'status': 'N/A',
      };
    }

    // Calculate progress (0.0 to 1.0) - represents amount CONSUMED
    double progressValue = max(0.0, min(1.0, consumed / goal));
    String status;

    if (consumed < goal) {
      status = 'left';
    } else if (consumed == goal) {
      status = 'met';
    } else {
      status = 'over';
      progressValue = 1.0; // Show full circle if over
    }

    return {
      'valueText': '$consumed/${goal}g',
      'percentageValue': progressValue,
      'status': status,
    };
  }
}

// Private widget for the individual circle display
class _MacroCircle extends StatelessWidget {
  final String valueText; // The value text (e.g., "45g")
  final double percentageValue; // For progress indicator (0.0 to 1.0)
  final String name;
  final String status;
  final Color color;

  const _MacroCircle({
    required this.valueText,
    required this.percentageValue,
    required this.name,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double circleSize = 45.w;
    final double strokeWidth = 4.0; // Adjusted stroke width

    return Column(
      children: [
        // Display Value Text (e.g., "45g")
        Text(
          valueText,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        // Display Macro Name and Status (left/over/met)
        Text(
          '$name $status',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 8.h),
        // --- Circle Indicator ---
        SizedBox(
          width: circleSize,
          height: circleSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background track
              CircularProgressIndicator(
                value: 1.0, // Full circle
                strokeWidth: strokeWidth,
                backgroundColor: Colors.grey[300], // Light grey background
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[300]!),
              ),
              // Progress arc
              CircularProgressIndicator(
                value: percentageValue, // Use the double value
                strokeWidth: strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color,
                ), // Use the macro color
                backgroundColor:
                    Colors.transparent, // Make background transparent
              ),
              // Icon inside the circle (optional)
              Center(
                child: Text(
                  _getIconForMacro(name),
                  style: TextStyle(fontSize: 16.w),
                ),
              ),
            ],
          ),
        ),
        // --- End Circle Indicator ---
      ],
    );
  }

  // Helper to get appropriate icon for each macro
  String _getIconForMacro(String macroName) {
    switch (macroName.toLowerCase()) {
      case 'protein':
        return MacroConstants.proteinIcon;
      case 'carbs':
        return MacroConstants.carbsIcon;
      case 'fats':
        return MacroConstants.fatsIcon;
      default:
        return '⚪'; // Default circle
    }
  }
}
