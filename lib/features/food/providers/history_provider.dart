import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/food_entry.dart';
import '../models/macro_totals.dart';
import '../repositories/food_repository.dart';
import '../repositories/i_food_repository.dart';

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  final repository = ref.watch(foodRepositoryProvider);
  return HistoryNotifier(repository);
});

@immutable
class HistoryState {
  final Map<String, List<FoodEntry>> entriesByDate;
  final bool isLoading;
  final String? error;

  const HistoryState({
    required this.entriesByDate,
    this.isLoading = false,
    this.error,
  });

  HistoryState copyWith({
    Map<String, List<FoodEntry>>? entriesByDate,
    bool? isLoading,
    String? error,
  }) {
    return HistoryState(
      entriesByDate: entriesByDate ?? this.entriesByDate,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  MacroTotals getDailyTotals(String date) {
    final entries = entriesByDate[date] ?? [];
    return entries.fold(
      MacroTotals(calories: 0, protein: 0, carbs: 0, fat: 0),
      (total, entry) => MacroTotals(
        calories: total.calories + entry.calories,
        protein: total.protein + entry.protein,
        carbs: total.carbs + entry.carbs,
        fat: total.fat + entry.fat,
      ),
    );
  }

  List<FoodEntry> getFilteredEntries(String date, String? mealType) {
    final entries = entriesByDate[date] ?? [];
    if (mealType == null) return entries;
    return entries.where((e) => e.mealType.toLowerCase() == mealType.toLowerCase()).toList();
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  final IFoodRepository _repository;
  DateTime _selectedDate = DateTime.now();

  HistoryNotifier(this._repository)
      : super(const HistoryState(entriesByDate: {}));

  DateTime get selectedDate => _selectedDate;

  Future<void> fetchWeeklyData({DateTime? date}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // Update selected date if provided
      if (date != null) {
        _selectedDate = date;
      }

      final weeklyData = await _repository.getWeekFoodEntries();
      
      // Group entries by date
      final entriesByDate = <String, List<FoodEntry>>{};
      for (final entry in weeklyData.entries) {
        final dateStr = DateFormat('yyyy-MM-dd').format(entry.date);
        entriesByDate.putIfAbsent(dateStr, () => []).add(entry);
      }

      state = state.copyWith(
        entriesByDate: entriesByDate,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> selectDate(DateTime date) async {
    if (date != _selectedDate) {
      _selectedDate = date;
      await fetchWeeklyData(date: date);
    }
  }
}
