import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart';
import 'package:mobilecalorietrackers/features/dashboard/widgets/dashboard_bottom_nav_bar.dart';
import 'package:mobilecalorietrackers/features/profile/widgets/weight_bmi_card.dart';
import 'package:mobilecalorietrackers/features/profile/widgets/profile_header.dart';
import 'package:mobilecalorietrackers/features/profile/widgets/achievements_section.dart';
import 'package:mobilecalorietrackers/features/profile/widgets/settings_section.dart';
import 'package:mobilecalorietrackers/features/profile/widgets/logout_button.dart';
import 'package:mobilecalorietrackers/features/dashboard/widgets/curved_wave_clipper.dart';

// Placeholder Model for User Profile Data
class UserProfile {
  final String name;
  final int level;
  final int currentXp;
  final int xpToNextLevel;
  final int streakDays;
  final int challengesCompleted;

  UserProfile({
    this.name = "User",
    required this.level,
    required this.currentXp,
    required this.xpToNextLevel,
    required this.streakDays,
    required this.challengesCompleted,
  });

  double get xpProgress => currentXp / xpToNextLevel;
}

// Sample Data (Replace with actual data fetching/state management)
final sampleUserProfile = UserProfile(
  level: 2,
  currentXp: 150,
  xpToNextLevel: 200,
  streakDays: 3,
  challengesCompleted: 4,
);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual user data from state/provider
    final UserProfile userProfile = sampleUserProfile;

    // Define the gradient similar to HistoryScreen
    final headerGradient = LinearGradient(
      colors: [
        AppColors.primaryGreen, // Use theme primary or specific green
        AppColors.primaryGreen.withOpacity(0.7),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      body: Stack(
        // Use Stack for layering
        children: [
          // --- Background Curved Header ---
          ClipPath(
            clipper: CurvedWaveClipper(),
            child: Container(
              height: 180.h, // Adjust height as needed for the background wave
              decoration: BoxDecoration(gradient: headerGradient),
            ),
          ),

          // --- Foreground Content ---
          SafeArea(
            bottom: false, // Avoid bottom system intrusions
            child: Column(
              children: [
                // --- Fixed Profile Header ---
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                  ), // Adjust top padding for header positioning
                  child: Column(
                    children: [
                      ProfileHeader(profile: userProfile),
                      SizedBox(height: 30.h),
                      // --- Achievements Section (using new widget) ---
                      AchievementsSection(profile: userProfile),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),

                // --- Scrollable Content Area ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: 20.h,
                      left: 16.w,
                      right: 16.w,
                      bottom: 16.h,
                    ), // Add padding around scrollable content
                    child: Column(
                      children: [
                        // --- Weight & BMI Card ---
                        const WeightAndBMICard(),
                        SizedBox(height: 20.h),

                        // --- Settings Section (using new widget) ---
                        const SettingsSection(),
                        SizedBox(height: 40.h),

                        // --- Log Out Button (using new widget) ---
                        const LogoutButton(),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const DashboardBottomNavBar(currentIndex: 2),
    );
  }
}
