import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pref.dart';

final themeModeProvider = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final selectedThemeMode = ThemeMode.values.firstWhere(
      (element) => element.toString() == prefs.getString('themeMode'),
      orElse: () => ThemeMode.system);
  ref.listenSelf((previous, next) {
    prefs.setString('themeMode', next.toString());
  });
  return selectedThemeMode;
});

final useDynamicColor = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final usingDynamicColor = prefs.getBool("useDynamicColor") ?? false;
  ref.listenSelf((previous, next) {
    prefs.setBool("useDynamicColor", next);
  });
  return usingDynamicColor;
});

final useCustomColor = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final usingCustomColor = prefs.getBool("useCustomColor") ?? false;
  ref.listenSelf((previous, next) {
    prefs.setBool("useCustomColor", next);
  });
  return usingCustomColor;
});

final selectedCustomColor = StateProvider<int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final customColor = prefs.getInt('customColor') ?? 16777215;
  ref.listenSelf((previous, next) {
    prefs.setInt('customColor', next);
  });
  return customColor;
});

final runSetup = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final runSetup = prefs.getBool("runSetup") ?? false;
  ref.listenSelf((previous, next) {
    prefs.setBool("runSetup", next);
  });
  return runSetup;
});

final minimalView = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final mini = prefs.getBool("minimalView") ?? false;
  ref.listenSelf(
    (previous, next) {
      prefs.setBool("minimalView", next);
    },
  );
  return mini;
});
