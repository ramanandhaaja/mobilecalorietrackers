import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart';
import 'package:mobilecalorietrackers/features/profile/profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: Colors.white.withOpacity(0.8),
          child: Icon(Icons.eco, size: 50.r, color: AppColors.primaryGreen),
        ),
        SizedBox(height: 16.h),
        Text(
          'Level ${profile.level} – ${profile.currentXp}/${profile.xpToNextLevel} XP',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: LinearProgressIndicator(
            value: profile.xpProgress,
            minHeight: 10.h,
            backgroundColor: (theme.colorScheme.primary).withOpacity(0.4),
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
      ],
    );
  }
}
