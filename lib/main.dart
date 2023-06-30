import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './pages/pages.dart';
import './pages/first_launch.dart';
import 'models/settings_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsmodel = SettingsModel();
  final tdl = TodoListModel();
  settingsmodel.load();
  tdl.load();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: settingsmodel),
    ChangeNotifierProvider.value(value: tdl),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);
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
        ColorScheme.fromSeed(seedColor: Color(settings.customColor));

    final customDarkColorScheme = ColorScheme.fromSeed(
        seedColor: Color(settings.customColor), brightness: Brightness.dark);

    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: 'Mint Task',
          theme: ThemeData(
            colorScheme: settings.isSystemColor
                ? lightColorScheme
                : settings.useCustomColor
                    ? customLightColorScheme
                    : defaultLightColorScheme,
            fontFamily: 'Manrope',
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: settings.isSystemColor
                ? darkColorScheme
                : settings.useCustomColor
                    ? customDarkColorScheme
                    : defaultDarkColorScheme,
            fontFamily: 'Manrope',
            useMaterial3: true,
          ),
          themeMode: settings.themeMode,
          home: settings.firstLaunch
              ? const FirstTimeLaunch()
              : const MyHomePage(),
        );
      },
    );
  }
}
