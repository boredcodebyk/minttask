import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/filehandle.dart';
import 'package:minttask/controller/permission_provider.dart';
import 'package:minttask/controller/router_provider.dart';
import 'package:minttask/controller/settings_provider.dart';
import 'package:minttask/controller/shared_preference_provider.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';
import 'package:minttask/model/default_color_scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isAndroid) {
      ref.read(permissionProvider.notifier).fetchPermissionStatus();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (Platform.isAndroid) {
        ref.read(permissionProvider.notifier).fetchPermissionStatus();
      }
      if (ref.watch(todotxtFilePathProvider).isNotEmpty) {
        ref.read(rawFileProvider.notifier).updateState();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    final customLightColorScheme =
        ColorScheme.fromSeed(seedColor: Color(ref.watch(selectedCustomColor)));

    final customDarkColorScheme = ColorScheme.fromSeed(
        seedColor: Color(ref.watch(selectedCustomColor)),
        brightness: Brightness.dark);
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp.router(
        title: 'Mint Task',
        theme: ThemeData(
          fontFamily: 'Manrope',
          colorScheme: ref.watch(useDynamicColor)
              ? lightColorScheme
              : ref.watch(useCustomColor)
                  ? customLightColorScheme
                  : defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          fontFamily: 'Manrope',
          colorScheme: ref.watch(useDynamicColor)
              ? darkColorScheme
              : ref.watch(useCustomColor)
                  ? customDarkColorScheme
                  : defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ref.watch(themeModeProvider),
        routerConfig: router,
      );
    });
  }
}
