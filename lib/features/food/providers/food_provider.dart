import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_entry.dart';
import '../repositories/food_repository.dart';

class FoodState {
  final List<FoodEntry> entries;
  final bool isLoading;
  final String? error;

  FoodState({
    required this.entries,
    required this.isLoading,
    this.error,
  });

  factory FoodState.initial() {
    return FoodState(
      entries: [],
      isLoading: false,
    );
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
      state = state.copyWith(isLoading: true, error: null);
      final entries = await _repository.getTodayFoodEntries();
      state = state.copyWith(
        entries: entries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final foodStateProvider = StateNotifierProvider<FoodNotifier, FoodState>((ref) {
  final repository = ref.watch(foodRepositoryProvider);
  return FoodNotifier(repository);
});
