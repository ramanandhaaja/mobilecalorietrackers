import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WeightAndBMICard extends StatelessWidget {
  const WeightAndBMICard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // TODO: Replace with actual data providers
    const targetWeight = 185.0;
    const currentWeight = 198.0;
    const bmi = 26.0;
    // Removed unused 'progress' variable

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Card(
        margin: EdgeInsets.only(bottom: 16.h),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Target Weight Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Weight',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$targetWeight',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          Text(
                            ' lbs',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement update functionality
                    },
                    child: Text('Update'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Current Weight Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Weight',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$currentWeight',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' lbs',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement update functionality
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text('Update'),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'Remember to update this at least once a week\nso we can adjust your plan to hit your goal',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24.h),
               // BMI Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your BMI',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$bmi',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' BMI',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: bmi < 18.5 ? Colors.blue[100] : (bmi < 25 ? Colors.green[100] : (bmi < 30 ? Colors.orange[100] : Colors.red[100])),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    child: Text(
                       bmi < 18.5 ? 'Underweight' : (bmi < 25 ? 'Normal' : (bmi < 30 ? 'Overweight' : 'Obese')),
                      style: theme.textTheme.bodyMedium?.copyWith(
                         color: bmi < 18.5 ? Colors.blue[700] : (bmi < 25 ? AppColors.primaryGreen : (bmi < 30 ? Colors.orange[700] : Colors.red[700])),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
               // BMI Indicator
              LinearPercentIndicator(
                percent: (bmi / 40).clamp(0.0, 1.0), // Normalize BMI to 0-1 range (assuming max relevant BMI is 40)
                backgroundColor: Colors.grey[200],
                progressColor: bmi < 18.5 ? Colors.blue : (bmi < 25 ? AppColors.primaryGreen : (bmi < 30 ? Colors.orange : Colors.red)),
                barRadius: Radius.circular(4.r),
                padding: EdgeInsets.zero,
                animation: true,
                lineHeight: 8.h,
              ),
              SizedBox(height: 8.h),
               // BMI Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Underweight',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: bmi >= 18.5 ? Colors.grey[600] : Colors.blue[700],
                      fontWeight: bmi < 18.5 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  Text(
                    'Normal',
                    style: theme.textTheme.bodySmall?.copyWith(
                       color: bmi >= 18.5 && bmi < 25 ? AppColors.primaryGreen : Colors.grey[600],
                       fontWeight: bmi >= 18.5 && bmi < 25 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                   Text(
                    'Overweight',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: bmi >= 25 && bmi < 30 ? Colors.orange[700] : Colors.grey[600],
                      fontWeight: bmi >= 25 && bmi < 30 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                   Text(
                    'Obese',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: bmi >= 30 ? Colors.red[700] : Colors.grey[600],
                       fontWeight: bmi >= 30 ? FontWeight.bold : FontWeight.normal,

                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
