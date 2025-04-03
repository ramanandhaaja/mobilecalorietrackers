import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/food_entry.dart';
import '../models/macro_totals.dart';
import '../repositories/i_food_repository.dart';
import '../repositories/food_repository.dart';

class FoodState {
  final List<FoodEntry> entries;
  final bool isLoading;
  final String? error;

  const FoodState({
    required this.entries,
    required this.isLoading,
    this.error,
  });

  factory FoodState.initial() {
    return FoodState(entries: [], isLoading: false);
  }

  FoodState copyWith({
    List<FoodEntry>? entries,
    bool? isLoading,
    String? error,
  }) {
    return FoodState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FoodNotifier extends StateNotifier<FoodState> {
  final IFoodRepository _repository;

  FoodNotifier(this._repository) : super(FoodState.initial());

  Future<void> fetchTodayEntries() async {
    try {
      // Only show loading if we don't have any cached entries
      if (state.entries.isEmpty) {
        state = state.copyWith(isLoading: true, error: null);
      }

      final entries = await _repository.getTodayFoodEntries();
      state = state.copyWith(entries: entries, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  MacroTotals getTodayMacroTotals() {
    return state.entries.fold(
      MacroTotals.zero(),
      (totals, entry) => totals.add(
        protein: entry.protein,
        carbs: entry.carbs,
        fat: entry.fat,
      ),
    );
  }

  int getTodayTotalCalories() {
    return state.entries.fold(
      0,
      (total, entry) => total + entry.calories,
    );
  }
}

final foodStateProvider = StateNotifierProvider<FoodNotifier, FoodState>((ref) {
  final repository = ref.watch(foodRepositoryProvider);
  return FoodNotifier(repository);
});
