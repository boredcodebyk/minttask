import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/model/settings_provider.dart';
import 'package:minttask/page/pages.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(
          CorePalette.of(Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
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
        return MaterialApp(
          title: 'Mint Task',
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
          themeMode: ref.watch(currentThemeMode),
          home: const BasePage(),
          // ref.watch(runSetup) ? const SetupPage() :
        );
      },
    );
  }
}
