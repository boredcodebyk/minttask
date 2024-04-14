import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/settings_provider.dart';

class ThemeSettingsPage extends ConsumerStatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  ConsumerState<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends ConsumerState<ThemeSettingsPage> {
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
                    selected: {ref.watch(currentThemeMode)},
                    onSelectionChanged: (p0) {
                      ref.read(currentThemeMode.notifier).state = p0.first;
                    },
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    SwitchListTile(
                      value: ref.watch(useDynamicColor),
                      onChanged: av >= 31
                          ? (value) =>
                              ref.read(useDynamicColor.notifier).state = value
                          : null,
                      title: const Text("Dynamic color"),
                      subtitle: Text(ref.watch(useDynamicColor)
                          ? "Using dynamic color"
                          : "Using default color scheme"),
                    ),
                    SwitchListTile(
                      value: ref.watch(useCustomColor),
                      onChanged: ref.watch(useDynamicColor)
                          ? null
                          : (value) =>
                              ref.read(useCustomColor.notifier).state = value,
                      title: const Text("Use custom color"),
                    ),
                    if (ref.watch(useCustomColor) == true)
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: ColorPicker(
                                  pickerColor:
                                      Color(ref.watch(selectedCustomColor)),
                                  onColorChanged: (value) {
                                    ref
                                        .read(selectedCustomColor.notifier)
                                        .state = value.value;
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      ref.read(useCustomColor.notifier).state =
                                          false;
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
