import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilecalorietrackers/core/constants/macro_constants.dart';

class FoodItemCard extends StatelessWidget {
  final String name;
  final String calories;
  final String time;
  final Map<String, String> macros;

  const FoodItemCard({
    Key? key,
    required this.name,
    required this.calories,
    required this.time,
    required this.macros,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Food image placeholder
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(Icons.restaurant, color: Colors.grey[400]),
            ),
          ),
          SizedBox(width: 12.w),
          // Food details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  calories,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 8.h),
                // Macros
                Row(
                  children:
                      macros.entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: Row(
                            children: [
                              Text(
                                _getMacroIcon(entry.key),
                                style: TextStyle(
                                  fontSize: 12.r,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get appropriate icon for each macro
  String _getMacroIcon(String macroName) {
    // Convert to lowercase and remove trailing 's' if present
    final normalized = macroName.toLowerCase().replaceAll('s', '');
    
    switch (normalized) {
      case 'protein':
        return MacroConstants.proteinIcon;
      case 'carb':
        return MacroConstants.carbsIcon;
      case 'fat':
        return MacroConstants.fatsIcon;
      default:
        return '⚪'; // Default circle
    }
  }
}
