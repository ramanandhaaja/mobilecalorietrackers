import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart'; // Assuming AppColors exists
import 'package:mobilecalorietrackers/features/dashboard/widgets/dashboard_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart'; // For navigation
import 'package:mobilecalorietrackers/core/router/app_router.dart'; // For route names

// Placeholder Model for User Profile Data
class UserProfile {
  final String name; // Optional: Add if needed
  final int level;
  final int currentXp;
  final int xpToNextLevel;
  final int streakDays;
  final int challengesCompleted;

  UserProfile({
    this.name = "User", // Default name
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color headerColor = colorScheme.primaryContainer.withOpacity(
      0.3,
    ); // Light green header

    // TODO: Replace with actual user data from state/provider
    final UserProfile userProfile = sampleUserProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: headerColor,
        elevation: 0,
        automaticallyImplyLeading:
            false, // No back button needed on main tab screen
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- User Stats Section ---
            _buildUserStats(context, userProfile),
            SizedBox(height: 30.h),

            // --- Achievements Section ---
            _buildAchievements(context, userProfile),
            SizedBox(height: 30.h),

            // --- Settings Section ---
            _buildSettings(context),
            SizedBox(height: 40.h),

            // --- Log Out Button ---
            _buildLogoutButton(context),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      bottomNavigationBar: const DashboardBottomNavBar(
        currentIndex: 2,
      ), // Assuming Profile is index 2
    );
  }

  // Helper for User Stats UI
  Widget _buildUserStats(BuildContext context, UserProfile profile) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
          child: Icon(
            Icons.eco,
            size: 50.r,
            color: AppColors.primaryGreen,
          ), // Leaf icon placeholder
          // TODO: Replace with actual user image if available
        ),
        SizedBox(height: 16.h),
        Text(
          'Level ${profile.level} – ${profile.currentXp}/${profile.xpToNextLevel} XP to next level',
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          // AnimatedProgressIndicator might be better for UX
          child: LinearProgressIndicator(
            value: profile.xpProgress,
            minHeight: 10.h,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryGreen,
            ),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
      ],
    );
  }

  // Helper for Achievements UI
  Widget _buildAchievements(BuildContext context, UserProfile profile) {
    final ThemeData theme = Theme.of(context);
    final TextStyle statsStyle = theme.textTheme.bodyLarge ?? const TextStyle();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text('Streaks', style: theme.textTheme.titleSmall),
            SizedBox(height: 4.h),
            Text(
              '${profile.streakDays} days',
              style: statsStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(height: 40.h, width: 1, color: Colors.grey[300]), // Divider
        Column(
          children: [
            Text('Challenges', style: theme.textTheme.titleSmall),
            SizedBox(height: 4.h),
            Text(
              '${profile.challengesCompleted} completed',
              style: statsStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  // Helper for Settings UI
  Widget _buildSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSettingsItem(context, Icons.edit, 'Edit Calorie Goal', () {
          // TODO: Navigate to Edit Profile/Goal screen
          print('Navigate to Edit Calorie Goal');
        }),
        const Divider(),
        _buildSettingsItem(context, Icons.feedback, 'Give Feedback', () {
          // TODO: Navigate to Feedback screen/form
          print('Navigate to Give Feedback');
        }),
      ],
    );
  }

  // Helper for individual setting item
  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // Helper for Logout Button UI
  Widget _buildLogoutButton(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text('Log Out', style: TextStyle(color: Colors.red)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red),
        minimumSize: Size(double.infinity, 50.h),
      ),
      onPressed: () {
        // TODO: Implement logout logic (clear auth state, navigate to login)
        // Example using go_router:
        // ref.read(authNotifierProvider.notifier).logout();
        // context.go(AppRoutes.login);
        print('Log Out Pressed');
        context.go(AppRoutes.login); // Placeholder navigation
      },
    );
  }
}
