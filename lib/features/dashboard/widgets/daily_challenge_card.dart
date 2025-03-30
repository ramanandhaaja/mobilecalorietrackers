import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyChallengeCard extends StatelessWidget {
  final String challengeText;
  final String rewardText;
  final int currentProgress;
  final int totalProgress;

  const DailyChallengeCard({
    Key? key,
    required this.challengeText,
    required this.rewardText,
    required this.currentProgress,
    required this.totalProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = totalProgress > 0 ? currentProgress / totalProgress : 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daily Challenge', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text(challengeText, style: TextStyle(fontSize: 14.sp)),
            SizedBox(height: 4.h),
            Text(rewardText, style: TextStyle(fontSize: 12.sp, color: Colors.green)),
            SizedBox(height: 12.h),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 4.h),
            Text('$currentProgress / $totalProgress', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
