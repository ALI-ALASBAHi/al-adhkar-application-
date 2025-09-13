class AppUiModel {
  final String currentTab; // 'home', 'dhikr', 'favorites', 'settings', etc.
  final bool isDrawerOpen;

  const AppUiModel({
    required this.currentTab,
    required this.isDrawerOpen,
  });

  AppUiModel copyWith({String? currentTab, bool? isDrawerOpen}) {
    return AppUiModel(
      currentTab: currentTab ?? this.currentTab,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
    );
  }
}


