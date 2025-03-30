import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StreakCounter extends StatelessWidget {
  final int streakDays;

  const StreakCounter({Key? key, required this.streakDays}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.2), // Example color
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Fit content
        children: [
          Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            '$streakDays Day Streak!',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.deepOrange),
          ),
        ],
      ),
    );
  }
}
