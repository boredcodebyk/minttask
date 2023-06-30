import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListModel extends ChangeNotifier {
  String _filter = "asc";
  String _sort = "id";

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

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('filter', _filter);
    prefs.setString('sort', _sort);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _filter = prefs.getString('filter') ?? "asc";
    _sort = prefs.getString('sort') ?? "id";
  }
}

class SettingsModel extends ChangeNotifier {
  bool _isSystemColor = false;
  ThemeMode _themeMode = ThemeMode.system;
  String _removeMethod = "button";
  bool _useCustomColor = false;
  int _customColor = 16777215;
  bool _firstLaunch = true;

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

  String get removeMethod => _removeMethod;
  set removeMethod(String value) {
    if (_removeMethod == value) return;
    _removeMethod = value;
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

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSystemColor', _isSystemColor);
    prefs.setString('themeMode', _themeMode.toString());
    prefs.setString('removeMethod', _removeMethod);
    prefs.setBool('useCustomColor', _useCustomColor);
    prefs.setInt('customColor', _customColor);
    prefs.setBool('firstLaunch', _firstLaunch);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isSystemColor = prefs.getBool('isSystemColor') ?? false;
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.toString() == prefs.getString('themeMode'),
      orElse: () => ThemeMode.system,
    );
    _removeMethod = prefs.getString('removeMethod') ?? "button";
    _useCustomColor = prefs.getBool('useCustomColor') ?? false;
    _customColor = prefs.getInt('customColor') ?? 16777215;
    _firstLaunch = prefs.getBool('firstLaunch') ?? true;
    notifyListeners();
  }
}
