import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../models/settings_model.dart';

class FirstTimeLaunch extends StatefulWidget {
  const FirstTimeLaunch({super.key});

  @override
  State<FirstTimeLaunch> createState() => _FirstTimeLaunchState();
}

class _FirstTimeLaunchState extends State<FirstTimeLaunch> {
  final _controller = PageController(
    initialPage: 0,
  );
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
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          welcome(),
          colorful(av),
          dismissMethod(),
          allDone(),
        ],
      ),
    );
  }

  Widget welcome() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Mint Task", style: Theme.of(context).textTheme.headlineLarge),
          Text(
            "Simple todo manager",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 48,
          ),
          FilledButton(
            onPressed: () => _controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease),
            child: const Text("Setup"),
          )
        ],
      ),
    );
  }

  Widget colorful(av) {
    SettingsModel settings = Provider.of<SettingsModel>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: ButtonBar(
              children: [
                FilledButton.tonal(
                    onPressed: () => _controller.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease),
                    child: const Text("Back")),
                FilledButton(
                    onPressed: () => _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease),
                    child: const Text("Next")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dismissMethod() {
    SettingsModel settings = Provider.of<SettingsModel>(context);
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Text("How do you wish to remove todo?",
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                RadioListTile.adaptive(
                  value: "button",
                  title: const Text("Button"),
                  groupValue: settings.removeMethod,
                  onChanged: (value) => settings.removeMethod = value!,
                ),
                RadioListTile.adaptive(
                  value: "gesture",
                  title: const Text("Gesture"),
                  groupValue: settings.removeMethod,
                  onChanged: (value) => settings.removeMethod = value!,
                ),
              ],
            ),
            const SizedBox(
              height: 48,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: ButtonBar(
                children: [
                  FilledButton.tonal(
                      onPressed: () => _controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease),
                      child: const Text("Back")),
                  FilledButton(
                      onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease),
                      child: const Text("Next")),
                ],
              ),
            )
          ]),
    );
  }

  Widget allDone() {
    SettingsModel settings = Provider.of<SettingsModel>(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Alright, we are ready to go!",
                style: Theme.of(context).textTheme.headlineMedium),
            Text(
              "Dont worry, you can always change your preference from settings.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 48,
            ),
            FilledButton(
              onPressed: () {
                settings.firstLaunch = false;
              },
              child: const Text("Done!"),
            )
          ],
        ),
      ),
    );
  }
}
