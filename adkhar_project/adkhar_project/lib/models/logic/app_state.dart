class AppState {
  final int completedDhikrCount;
  final int streakDays;

  const AppState({
    required this.completedDhikrCount,
    required this.streakDays,
  });

  factory AppState.initial() => const AppState(completedDhikrCount: 0, streakDays: 0);

  AppState copyWith({int? completedDhikrCount, int? streakDays}) {
    return AppState(
      completedDhikrCount: completedDhikrCount ?? this.completedDhikrCount,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}


