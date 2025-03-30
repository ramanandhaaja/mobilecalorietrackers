import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'food_item_card.dart'; // Import the new FoodItemCard

class RecentlyUploadedSection extends StatelessWidget {
  const RecentlyUploadedSection({Key? key}) : super(key: key);

  // TODO: Replace with actual data fetching logic
  final List<Map<String, dynamic>> recentFoods = const [
    {
      'name': 'Fattoush Salad',
      'calories': '153 calories',
      'time': '12:57pm',
      'macros': {'Protein': '12g', 'Carbs': '10g', 'Fat': '5g'}
    },
    {
      'name': 'Sweet Corn paneer bowl',
      'calories': '455 kcal',
      'time': '11:31am',
      'macros': {'Protein': '25g', 'Carbs': '55g', 'Fat': '15g'}
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently uploaded',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15.h),
        ListView.separated(
          shrinkWrap: true, // Important to prevent infinite height error in Column
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling within the list
          itemCount: recentFoods.length,
          itemBuilder: (context, index) {
            final food = recentFoods[index];
            return FoodItemCard(
              name: food['name'],
              calories: food['calories'],
              time: food['time'],
              macros: food['macros'],
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 15.h),
        ),
      ],
    );
  }
}
