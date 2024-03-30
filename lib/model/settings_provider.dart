import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

final currentThemeMode = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final selectedThemeMode = ThemeMode.values.firstWhere(
      (element) => element.toString() == prefs.getString('themeMode'),
      orElse: () => ThemeMode.system);
  ref.listenSelf((previous, next) {
    prefs.setString('themeMode', next.toString());
  });
  return selectedThemeMode;
});

final useDynamicColor = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final usingDynamicColor = prefs.getBool("useDynamicColor") ?? false;
  ref.listenSelf((previous, next) {
    prefs.setBool("useDynamicColor", next.toString() == "true" ? true : false);
  });
  return usingDynamicColor;
});

final useCustomColor = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final usingCustomColor = prefs.getBool("useCustomColor") ?? false;
  ref.listenSelf((previous, next) {
    prefs.setBool("useCustomColor", next.toString() == "true" ? true : false);
  });
  return usingCustomColor;
});

final selectedCustomColor = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final customColor = prefs.getInt('customColor') ?? 16777215;
  ref.listenSelf((previous, next) {
    prefs.setInt('customColor', next as int);
  });
  return customColor;
});

final runSetup = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final runSetup = prefs.getBool("runSetup") ?? false;
  ref.listenSelf((previous, next) {
    prefs.setBool("runSetup", next.toString() == "true" ? true : false);
  });
  return runSetup;
});
