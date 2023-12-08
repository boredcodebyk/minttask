import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/model/db.old.dart';
import 'package:minttask/model/db_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../model/settings_model.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _controller = PageController(
    initialPage: 0,
  );
  final List<Widget> _pages = [
    const PageOne(),
    const PageTwoTheme(),
    const PageThreeMigration(),
    const PageFour()
  ];
  static const platform =
      MethodChannel('bored.codebyk.mint_task/androidversion');

  int av = 0;
  Future<int> androidVersion() async {
    final result = await platform.invokeMethod('getAndroidVersion');
    return await result;
  }

  void fetchVersion() async {
    final v = await androidVersion();
    if (mounted) {
      setState(() {
        av = v;
      });
    }
  }

  int currentPage = 0;

  List<Map<String, dynamic>> _todoList = [];
  Map<String, String> filter_col = {"sortby": "", "filter": ""};
  void _listTodos(col, filter) async {
    final dbHelper = DatabaseHelper.instance;
    final todolist = await dbHelper.getTodos(col, filter);

    _todoList = todolist;
  }

  @override
  void initState() {
    super.initState();

    _listTodos("id", "asc");

    fetchVersion();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(CorePalette.of(
                Theme.of(context).colorScheme.primary.value)
            .neutral
            .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120,
                    height: 60,
                    child: FilledButton.tonal(
                        onPressed: currentPage != 0
                            ? () {
                                _controller.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              }
                            : null,
                        child: const Icon(Icons.arrow_back)),
                  ),
                  if (currentPage != 3) ...[
                    SizedBox(
                      width: 120,
                      height: 60,
                      child: FilledButton(
                          onPressed: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          },
                          child: const Icon(Icons.arrow_forward)),
                    ),
                  ] else ...[
                    SizedBox(
                      width: 120,
                      height: 60,
                      child: FilledButton(
                          onPressed: () {
                            settings.firstLaunch = false;
                          },
                          child: const Icon(Icons.done)),
                    ),
                  ],
                  if (currentPage == 2) ...[
                    SizedBox(
                      width: 120,
                      height: 60,
                      child: FilledButton(
                          onPressed: () async {
                            if (_todoList.isNotEmpty) {
                              print("migrating");
                              for (var element in _todoList) {
                                print(element.toString());
                                IsarHelper.instance.restoreFromJson(
                                    element["title"],
                                    jsonEncode([
                                      {"insert": "${element["description"]}\n"}
                                    ]),
                                    element["is_done"] == 0 ? false : true,
                                    DateTime.fromMillisecondsSinceEpoch(
                                        element["date_created"]),
                                    DateTime.fromMillisecondsSinceEpoch(
                                        element["date_modified"]),
                                    [],
                                    false,
                                    false,
                                    false,
                                    element["id"],
                                    DateTime.now(),
                                    "low",
                                    false);
                              }
                            }
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          },
                          child: const Text("Migrate")),
                    ),
                  ],
                ],
              ),
            ),
            LinearProgressIndicator(
              value: (currentPage / 3),
            ),
          ],
        ),
      ),
    );
  }
}

class PageOne extends StatefulWidget {
  const PageOne({super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  String _appVersion = "";

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    setState(() {
      _appVersion = appVersion;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getVersion());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Welcome to\nMint Task",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Text(
            "Let's get started.",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            "v$_appVersion",
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}

class PageTwoTheme extends StatefulWidget {
  const PageTwoTheme({super.key});

  @override
  State<PageTwoTheme> createState() => _PageTwoThemeState();
}

class _PageTwoThemeState extends State<PageTwoTheme> {
  static const platform =
      MethodChannel('bored.codebyk.mint_task/androidversion');

  int av = 0;
  Future<int> androidVersion() async {
    final result = await platform.invokeMethod('getAndroidVersion');
    return await result;
  }

  void fetchVersion() async {
    final v = await androidVersion();
    if (mounted) {
      setState(() {
        av = v;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVersion();
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child:
                Text("Theme", style: Theme.of(context).textTheme.headlineLarge),
          ),
          ListView(
            padding: const EdgeInsets.all(12.0),
            shrinkWrap: true,
            children: [
              if (av >= 31)
                SwitchListTile(
                  value: settings.isSystemColor,
                  onChanged: (value) {
                    settings.isSystemColor = value;
                  },
                  title: const Text("Use system color scheme"),
                  subtitle: Text(settings.isSystemColor
                      ? "Using system dynamic color"
                      : "Using default color scheme"),
                ),
              if (settings.isSystemColor == false)
                SwitchListTile(
                  value: settings.useCustomColor,
                  onChanged: (value) => settings.useCustomColor = value,
                  title: const Text("Use custom color"),
                ),
              if (settings.useCustomColor == true)
                SizedBox(
                  height: 100,
                  width: 100,
                  child: InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: ColorPicker(
                            pickerColor: Color(settings.customColor),
                            onColorChanged: (value) {
                              settings.customColor = value.value;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                settings.useCustomColor = false;
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    ),
                    child: Card(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      elevation: 0,
                      child: Center(
                        child: ClipOval(
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Stack(
                              clipBehavior: Clip.hardEdge,
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  right: 24,
                                  bottom: 24,
                                  child: Container(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Positioned(
                                  left: 24,
                                  top: 0,
                                  right: 0,
                                  bottom: 24,
                                  child: Container(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Positioned(
                                  left: 24,
                                  top: 24,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 24,
                                  right: 24,
                                  bottom: 0,
                                  child: Container(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

class PageThreeMigration extends StatefulWidget {
  const PageThreeMigration({super.key});

  @override
  State<PageThreeMigration> createState() => _PageThreeMigrationState();
}

class _PageThreeMigrationState extends State<PageThreeMigration> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child:
              Text("Theme", style: Theme.of(context).textTheme.headlineLarge),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
              "From v1.1.0 I'm using Isar instead of SQFLite. So if any task added any version prior to v1.1.0 will be migrated. Read changelog for more."),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
              onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => const WhatsNewPage.changelog(
                      title: Text(
                        "What's New",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buttonText: Text(
                        'Close',
                      ),
                    ),
                  ),
              child: const Text("Changelog")),
        )
      ],
    );
  }
}

class PageFour extends StatelessWidget {
  const PageFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Let's get started.",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
