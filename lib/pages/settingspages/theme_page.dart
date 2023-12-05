import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../model/settings_model.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  static const platform =
      MethodChannel('bored.codebyk.mint_task/androidversion');

  int av = 0;
  Future<int> androidVersion() async {
    final result = await platform.invokeMethod('getAndroidVersion');
    return await result;
  }

  void fetchVersion() async {
    final v = await androidVersion();
    setState(() {
      av = v;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchVersion();
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Display"),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SegmentedButton(
                    segments: const [
                      ButtonSegment(
                          value: ThemeMode.system, label: Text("System")),
                      ButtonSegment(
                          value: ThemeMode.light, label: Text("Light")),
                      ButtonSegment(value: ThemeMode.dark, label: Text("Dark")),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (p0) {
                      settings.themeMode = p0.first;
                    },
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    SwitchListTile(
                      value: settings.isSystemColor,
                      onChanged: av >= 31
                          ? (value) => settings.isSystemColor = value
                          : null,
                      title: const Text("Dynamic color"),
                      subtitle: Text(settings.isSystemColor
                          ? "Using dynamic color"
                          : "Using default color scheme"),
                    ),
                    SwitchListTile(
                      value: settings.useCustomColor,
                      onChanged: settings.isSystemColor
                          ? null
                          : (value) => settings.useCustomColor = value,
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
                                    child: const Text("Ok"),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        top: 0,
                                        right: 0,
                                        bottom: 24,
                                        child: Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        top: 24,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 24,
                                        right: 24,
                                        bottom: 0,
                                        child: Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
