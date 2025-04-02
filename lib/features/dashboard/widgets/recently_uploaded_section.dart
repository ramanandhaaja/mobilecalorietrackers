import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../features/food/providers/food_provider.dart';
import 'food_item_card.dart';

class RecentlyUploadedSection extends ConsumerStatefulWidget {
  const RecentlyUploadedSection({super.key});

  @override
  ConsumerState<RecentlyUploadedSection> createState() =>
      _RecentlyUploadedSectionState();
}

class _RecentlyUploadedSectionState
    extends ConsumerState<RecentlyUploadedSection> {
  @override
  void initState() {
    super.initState();
    // Fetch food entries when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(foodStateProvider.notifier).fetchTodayEntries();
    });
  }

  String _formatTime(DateTime date) {
    // Convert UTC to local time for display
    final localDate = date.toLocal();
    return DateFormat('h:mma').format(localDate).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final foodState = ref.watch(foodStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today Entries',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        if (foodState.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (foodState.error != null)
          Center(child: Text('Error: ${foodState.error}'))
        else if (foodState.entries.isEmpty)
          const Center(child: Text('No food entries for today'))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foodState.entries.length,
            itemBuilder: (context, index) {
              // Sort entries by date in descending order (latest first)
              final sortedEntries =
                  foodState.entries.toList()
                    ..sort((a, b) => b.date.compareTo(a.date));
              final entry = sortedEntries[index];
              return FoodItemCard(
                name: entry.name,
                calories: entry.calories.toString(),
                time: _formatTime(entry.date),
                macros: {
                  'Protein': entry.protein.toString(),
                  'Carbs': entry.carbs.toString(),
                  'Fat': entry.fat.toString(),
                },
              );
            },
          ),
      ],
    );
  }
}
