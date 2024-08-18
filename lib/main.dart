import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/pref.dart';
import 'controller/settings_model.dart';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
    ));

    final defaultLightColorScheme = ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 217, 229, 129));

    final defaultDarkColorScheme = ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 217, 229, 129),
        brightness: Brightness.dark);
    final customLightColorScheme =
        ColorScheme.fromSeed(seedColor: Color(ref.watch(selectedCustomColor)));

    final customDarkColorScheme = ColorScheme.fromSeed(
        seedColor: Color(ref.watch(selectedCustomColor)),
        brightness: Brightness.dark);

    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp.router(
          title: 'Mint Task',
          routerConfig: ref.watch(routerProvider),
          theme: ThemeData(
            colorScheme: ref.watch(useDynamicColor)
                ? lightColorScheme
                : ref.watch(useCustomColor)
                    ? customLightColorScheme
                    : defaultLightColorScheme,
            fontFamily: 'Manrope',
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ref.watch(useDynamicColor)
                ? darkColorScheme
                : ref.watch(useCustomColor)
                    ? customDarkColorScheme
                    : defaultDarkColorScheme,
            fontFamily: 'Manrope',
            useMaterial3: true,
          ),
          themeMode: ref.watch(themeModeProvider),
        );
      },
    );
  }
}
