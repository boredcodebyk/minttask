import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/controller/settings_provider.dart';

class ThemeView extends ConsumerStatefulWidget {
  const ThemeView({super.key});

  @override
  ConsumerState<ThemeView> createState() => ThemeViewState();
}

class ThemeViewState extends ConsumerState<ThemeView> {
  int androidVersion = 0;

  void fetchVersion() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((onValue) {
        setState(() {
          androidVersion = onValue.version.sdkInt;
        });
      });
    }
  }

  void switchDynamicColor(bool value) {
    if (Platform.isAndroid) {
      if (androidVersion > 31) {
        ref.read(useDynamicColor.notifier).state = value;
      } else {
        null;
      }
    } else {
      ref.read(useDynamicColor.notifier).state = value;
    }
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
          SliverAppBar.large(
            title: const Text("Theme"),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
            ),
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
                    selected: {ref.watch(themeModeProvider)},
                    onSelectionChanged: (p0) {
                      ref.read(themeModeProvider.notifier).state = p0.first;
                    },
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    SwitchListTile(
                      value: ref.watch(useDynamicColor),
                      onChanged: switchDynamicColor,
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
                                content: ColorBox(),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Close"),
                                  ),
                                ],
                              );
                            },
                          ),
                          child: Card(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
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

class ColorBox extends ConsumerWidget {
  ColorBox({super.key});
  final List<Color> colorPalatte = [
    Colors.deepPurpleAccent,
    Colors.redAccent,
    Colors.deepOrange,
    Colors.greenAccent,
    Colors.tealAccent,
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Selected Color"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 84,
              height: 48,
              child: Container(
                color: Color(ref.watch(selectedCustomColor)),
              ),
            ),
          ),
        ),
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: [
            ...colorPalatte.map(
              (e) => InkWell(
                onTap: () =>
                    ref.read(selectedCustomColor.notifier).state = e.value,
                child: ClipOval(
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Container(
                      color: e,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
