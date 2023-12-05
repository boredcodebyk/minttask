import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/pages/ui/category_ui.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:quick_settings/quick_settings.dart';
import 'package:timezone/data/latest.dart' as tz;

import './pages/pages.dart';
import 'pages/setup.dart';
import 'model/notification_model.dart';
import 'model/settings_model.dart';
import 'model/db_model.dart';
import 'pages/ui/addtask_ui.dart';
import 'utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationController.initializeLocalNotification();
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  tz.initializeTimeZones();
  QuickSettings.setup(
    onTileClicked: onTileClick,
    onTileAdded: onTileAdded,
  );
  final settingsmodel = SettingsModel();
  final tdl = TodoListModel();
  settingsmodel.load();
  tdl.load();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: settingsmodel),
    ChangeNotifierProvider.value(value: tdl),
    ChangeNotifierProvider(
      create: (context) => TaskListProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.msg});
  final String? msg;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ReceivedAction? receivedAction;

  @override
  void initState() {
    super.initState();
    NotificationController.startListeningNotificationEvents();
    receivedAction = NotificationController.initialAction;

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'add') {
        Navigator.of(context).push(
          createRouteSharedAxisTransition(
            const AddTaskBox(),
          ),
        );
      }
      quickActions.setShortcutItems(<ShortcutItem>[
        const ShortcutItem(
            type: 'add',
            localizedTitle: 'Add task',
            icon: '@drawable/baseline_add_24'),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);
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
        ColorScheme.fromSeed(seedColor: Color(settings.customColor));

    final customDarkColorScheme = ColorScheme.fromSeed(
        seedColor: Color(settings.customColor), brightness: Brightness.dark);

    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          navigatorKey: MyApp.navigatorKey,
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
              ? const SetupPage()
              : receivedAction?.payload != null
                  ? NotifyAction(
                      receivedAction: receivedAction,
                    )
                  : const HomePage(),
        );
      },
    );
  }
}

@pragma("vm:entry-point")
Tile onTileClick(Tile tile) {
  tile.label = "Add Task";
  tile.tileStatus = TileStatus.inactive;
  tile.stateDescription = "Mint Task";
  tile.drawableName = "baseline_add_24";
  MyApp.navigatorKey.currentState!
      .push(createRouteSharedAxisTransition(const AddTaskBox()));
  return tile;
}

@pragma("vm:entry-point")
Tile onTileAdded(Tile tile) {
  tile.label = "Add Task";
  tile.tileStatus = TileStatus.inactive;
  tile.stateDescription = "Mint Task";
  tile.drawableName = "baseline_add_24";

  return tile;
}
