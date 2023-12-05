import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/utils.dart';

class TodoListModel extends ChangeNotifier {
  String _filter = "desc";
  String _sort = "id";
  bool _showCompleted = true;
  bool _useCategorySort = false;
  bool _detailedView = true;

  String get filter => _filter;
  set filter(String value) {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
    save();
  }

  String get sort => _sort;
  set sort(String value) {
    if (_sort == value) return;
    _sort = value;
    notifyListeners();
    save();
  }

  bool get showCompleted => _showCompleted;
  set showCompleted(bool value) {
    if (_showCompleted == value) return;
    _showCompleted = value;
    notifyListeners();
    save();
  }

  bool get useCategorySort => _useCategorySort;
  set useCategorySort(bool value) {
    if (_useCategorySort == value) return;
    _useCategorySort = value;
    notifyListeners();
    save();
  }

  bool get detailedView => _detailedView;
  set detailedView(bool value) {
    if (_detailedView == value) return;
    _detailedView = value;
    notifyListeners();
    save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('filter', _filter);
    prefs.setString('sort', _sort);
    prefs.setBool('showCompleted', _showCompleted);
    prefs.setBool('useCategorySort', _useCategorySort);
    prefs.setBool('detailedView', _detailedView);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _filter = prefs.getString('filter') ?? "asc";
    _sort = prefs.getString('sort') ?? "id";
    _showCompleted = prefs.getBool('showCompleted') ?? true;
    _useCategorySort = prefs.getBool('useCategorySort') ?? false;
    _detailedView = prefs.getBool('detailedView') ?? true;
  }
}

class SettingsModel extends ChangeNotifier {
  bool _isSystemColor = false;
  ThemeMode _themeMode = ThemeMode.system;
  LeftSwipeAction _leftSwipeAction = LeftSwipeAction.trash;
  RightSwipeAction _rightSwipeAction = RightSwipeAction.archive;
  bool _useCustomColor = false;
  int _customColor = 16777215;
  bool _firstLaunch = true;
  bool _showCompletedTask = false;

  bool get isSystemColor => _isSystemColor;
  set isSystemColor(bool value) {
    if (_isSystemColor == value) return;
    _isSystemColor = value;
    notifyListeners();
    save();
  }

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    if (_themeMode == value) return;
    _themeMode = value;
    notifyListeners();
    save();
  }

  bool get useCustomColor => _useCustomColor;
  set useCustomColor(bool value) {
    if (_useCustomColor == value) return;
    _useCustomColor = value;
    notifyListeners();
    save();
  }

  int get customColor => _customColor;
  set customColor(int value) {
    if (_customColor == value) return;
    _customColor = value;
    notifyListeners();
    save();
  }

  bool get firstLaunch => _firstLaunch;
  set firstLaunch(bool value) {
    if (_firstLaunch == value) return;
    _firstLaunch = value;
    notifyListeners();
    save();
  }

  LeftSwipeAction get leftSwipeAction => _leftSwipeAction;
  set leftSwipeAction(LeftSwipeAction value) {
    if (_leftSwipeAction == value) return;
    _leftSwipeAction = value;
    notifyListeners();
    save();
  }

  RightSwipeAction get rightSwipeAction => _rightSwipeAction;
  set rightSwipeAction(RightSwipeAction value) {
    if (_rightSwipeAction == value) return;
    _rightSwipeAction = value;
    notifyListeners();
    save();
  }

  bool get showCompletedTask => _showCompletedTask;
  set showCompletedTask(bool value) {
    if (_showCompletedTask == value) return;
    _showCompletedTask = value;
    notifyListeners();
    save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSystemColor', _isSystemColor);
    prefs.setString('themeMode', _themeMode.toString());
    prefs.setString('leftSwipeAction', _leftSwipeAction.toString());
    prefs.setString('rightSwipeAction', _rightSwipeAction.toString());
    prefs.setBool('useCustomColor', _useCustomColor);
    prefs.setInt('customColor', _customColor);
    prefs.setBool('firstLaunch', _firstLaunch);
    prefs.setBool('showCompletedTask', _showCompletedTask);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isSystemColor = prefs.getBool('isSystemColor') ?? false;
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.toString() == prefs.getString('themeMode'),
      orElse: () => ThemeMode.system,
    );
    _leftSwipeAction = LeftSwipeAction.values.firstWhere(
        (e) => e.toString() == prefs.getString('leftSwipeAction'),
        orElse: () => LeftSwipeAction.trash);
    _rightSwipeAction = RightSwipeAction.values.firstWhere(
        (e) => e.toString() == prefs.getString('rightSwipeAction'),
        orElse: () => RightSwipeAction.archive);
    _useCustomColor = prefs.getBool('useCustomColor') ?? false;
    _customColor = prefs.getInt('customColor') ?? 16777215;
    _firstLaunch = prefs.getBool('firstLaunch') ?? true;
    _showCompletedTask = prefs.getBool('showCompletedTask') ?? false;
    notifyListeners();
  }
}
