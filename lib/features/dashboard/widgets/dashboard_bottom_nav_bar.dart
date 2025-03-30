import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart'; // Import go_router
import 'package:mobilecalorietrackers/core/router/app_router.dart'; // Import app routes
import 'package:mobilecalorietrackers/core/theme/app_colors.dart'; // Corrected import path

class DashboardBottomNavBar extends StatelessWidget {
  final int currentIndex; // Add this to know which tab is active

  const DashboardBottomNavBar({Key? key, required this.currentIndex})
    : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    // Use go_router to navigate based on index
    switch (index) {
      case 0: // Home/Dashboard
        context.go(AppRoutes.dashboard);
        break;
      case 1: // History
        context.go(AppRoutes.history);
        break;
      case 2: // Profile
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h, // Standard height
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(context, 0, 'assets/svg/home_icon.svg', 'Home'),
          _buildNavItem(
            context,
            1,
            'assets/svg/history_icon.svg',
            'History',
          ), // Assuming history icon
          _buildNavItem(
            context,
            2,
            'assets/svg/profile_icon.svg',
            'Profile',
          ), // Assuming profile icon
        ],
      ),
    );
  }

  // Helper widget to build individual navigation items
  Widget _buildNavItem(
    BuildContext context,
    int index,
    String iconPath,
    String label,
  ) {
    final bool isSelected = currentIndex == index;
    final Color color = isSelected ? AppColors.primaryGreen : Colors.grey;

    return InkWell(
      onTap: () => _onItemTapped(context, index), // Call navigation function
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            height: 24.h,
            width: 24.h,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
