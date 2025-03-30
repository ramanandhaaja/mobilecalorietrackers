import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilecalorietrackers/features/profile/profile_screen.dart'; // For UserProfile

class AchievementsSection extends StatelessWidget {
  final UserProfile profile;

  const AchievementsSection({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Container(height: 40.h, width: 1, color: Colors.grey[300]),
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
}
