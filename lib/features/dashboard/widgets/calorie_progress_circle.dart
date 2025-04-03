import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart';
import 'package:mobilecalorietrackers/features/food/providers/food_provider.dart';

class CalorieProgressCircle extends ConsumerWidget {
  final int goal;

  const CalorieProgressCircle({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodState = ref.watch(foodStateProvider);

    // Show loading state
    if (foodState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error state
    if (foodState.error != null) {
      return Center(child: Text('Error: ${foodState.error}'));
    }

    final consumed =
        ref.read(foodStateProvider.notifier).getTodayTotalCalories();
    final progressPercent = consumed / goal;

    // Progress color based on consumption percentage
    final Color progressColor =
        progressPercent > 0.75
            ? Colors.red
            : progressPercent > 0.5
            ? Colors.orange
            : AppColors.primaryGreen;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Calories Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Calories left',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$consumed/$goal',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Kcal',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right side - Progress Circle
          SizedBox(
            width: 80.w,
            height: 80.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(80.w, 80.w),
                  painter: _CirclePainter(
                    progress: progressPercent,
                    progressColor: progressColor,
                    backgroundColor: Colors.grey[200]!,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.r),
                  child: Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 24.r,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;

  _CirclePainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 8.0; // Thinner stroke to match design
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint =
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round; // Rounded ends

    final double sweepAngle =
        2 * math.pi * progress; // Progress represents percentage complete

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start at the top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
