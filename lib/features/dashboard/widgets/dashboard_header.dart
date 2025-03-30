import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using SafeArea to handle potential notches/status bars
    // and adding symmetric padding for a balanced look.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Vertically center items
        children: [
          // Logo on the left
          Text(
            'FitCount',
            style: TextStyle(fontSize: 24.sp, color: Colors.white),
          ),

          // Level badge and text on the right
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center items vertically
            children: [
              SvgPicture.asset('assets/svg/level_badge.svg', height: 32.h),
              SizedBox(width: 8.w), // Increased spacing
              Text(
                'Level 2', // Replace with dynamic user level
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Consider using theme color
                ),
              ),
            ],
          ),
          // TODO: Make notification icon functional or remove if not needed
          // Icon(Icons.notifications_outlined, color: Colors.white),
          // Placeholder for now if needed, or remove completely if header background changes
          SizedBox(width: 24.w), // Maintain spacing if icon removed
        ],
      ),
    );
  }
}
