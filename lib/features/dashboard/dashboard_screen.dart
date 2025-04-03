import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/calorie_progress_circle.dart';
import 'widgets/curved_wave_clipper.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/recently_uploaded_section.dart';
import 'widgets/dashboard_bottom_nav_bar.dart';
import 'widgets/streak_counter.dart';
import 'widgets/daily_challenge_card.dart';
import 'widgets/macronutrient_info_section.dart';
import '../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilecalorietrackers/core/router/app_router.dart';
import 'package:mobilecalorietrackers/features/food/providers/food_provider.dart';
import 'package:mobilecalorietrackers/features/user/providers/user_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch food state and user details for updates
    ref.watch(foodStateProvider);
    final userDetails = ref.watch(userDetailsProvider);

    return userDetails.when(
      data: (details) {
        if (details == null) {
          return const Center(child: Text('User details not found'));
        }

        return Scaffold(
      backgroundColor: AppColors.background, // Use defined background color
      body: Stack(
        children: [
          // Curved Wave Background
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
          SafeArea(
            child: Column(
              children: [
                const DashboardHeader(), // Use extracted header
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Calorie Progress Circle
                          CalorieProgressCircle(
                            goal: details.dailyCalorieTarget.toInt(),
                          ),
                          SizedBox(height: 25.h),

                          // Macronutrient Info
                          MacronutrientInfoSection(
                            proteinGoal: details.dailyProtein.toInt(),
                            carbsGoal: details.dailyCarbs.toInt(),
                            fatGoal: details.dailyFat.toInt(),
                          ),
                          SizedBox(height: 25.h),

                          // Streak Counter
                          const StreakCounter(streakDays: 3), // Example value
                          SizedBox(height: 15.h),

                          // Daily Challenge Card
                          const DailyChallengeCard(
                            challengeText: 'Log all 3 meals today!', // Example
                            rewardText: 'Reward: 20 XP', // Example
                            currentProgress: 1, // Example
                            totalProgress: 3, // Example
                          ),
                          SizedBox(height: 25.h),

                          // Recently uploaded section
                          const RecentlyUploadedSection(),

                          SizedBox(height: 90.h), // Space for bottom nav bar
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Log Meal screen using go_router
          //context.push(AppRoutes.logMeal);
          context.push(AppRoutes.logMeal);
        },
        backgroundColor: AppColors.primaryGreen, // Use theme color
        shape: CircleBorder(), // Explicitly set the shape to be circular
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Log Food', // Accessibility feature
      ),

      // Pass the current index (0 for Dashboard)
      bottomNavigationBar: const DashboardBottomNavBar(currentIndex: 0),
    );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
