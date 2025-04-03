class MacroTotals {
  final int protein;
  final int carbs;
  final int fat;

  const MacroTotals({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MacroTotals.zero() {
    return const MacroTotals(
      protein: 0,
      carbs: 0,
      fat: 0,
    );
  }

  MacroTotals add({
    required int protein,
    required int carbs,
    required int fat,
  }) {
    return MacroTotals(
      protein: this.protein + protein,
      carbs: this.carbs + carbs,
      fat: this.fat + fat,
    );
  }
}
