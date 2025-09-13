import 'package:flutter/foundation.dart';
import '../models/ui/app_ui_model.dart';

class NavigationViewModel extends ChangeNotifier {
  AppUiModel _ui = const AppUiModel(currentTab: 'home', isDrawerOpen: false);
  AppUiModel get ui => _ui;

  void setTab(String tab) {
    if (_ui.currentTab == tab) return;
    _ui = _ui.copyWith(currentTab: tab);
    notifyListeners();
  }

  void openDrawer() {
    if (_ui.isDrawerOpen) return;
    _ui = _ui.copyWith(isDrawerOpen: true);
    notifyListeners();
  }

  void closeDrawer() {
    if (!_ui.isDrawerOpen) return;
    _ui = _ui.copyWith(isDrawerOpen: false);
    notifyListeners();
  }
}


