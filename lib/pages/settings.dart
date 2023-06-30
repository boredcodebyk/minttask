import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/settings_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Route _createRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("Settings"),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: const Text("Theme"),
                  onTap: () =>
                      Navigator.push(context, _createRoute(const ThemePage())),
                ),
                ListTile(
                  leading: const Icon(Icons.playlist_remove),
                  title: const Text("Todo remove method"),
                  onTap: () => Navigator.push(
                      context, _createRoute(const DismissTodo())),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("About"),
                  onTap: () =>
                      Navigator.push(context, _createRoute(const Abouts())),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  static const platform =
      MethodChannel('bored.codebyk.minttask/androidversion');

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
          SliverAppBar.large(
            title: const Text("Theme"),
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
                      title: const Text("Use system color scheme"),
                      subtitle: Text(settings.isSystemColor
                          ? "Using system dynamic color"
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

class DismissTodo extends StatelessWidget {
  const DismissTodo({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("Todo remove method"),
          ),
          SliverToBoxAdapter(
            child: Column(children: [
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
              )
            ]),
          )
        ],
      ),
    );
  }
}

class Abouts extends StatefulWidget {
  const Abouts({super.key});

  @override
  State<Abouts> createState() => _AboutsState();
}

class _AboutsState extends State<Abouts> {
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
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar.large(
          title: const Text("About"),
        ),
        SliverToBoxAdapter(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("App Version"),
                subtitle: Text(_appVersion),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("Licenses"),
                onTap: () => showLicensePage(
                    context: context,
                    applicationName: "Mint Task",
                    applicationVersion: _appVersion),
              ),
              ListTile(
                leading: SvgPicture.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? "assets/github-mark.svg"
                      : "assets/github-mark-white.svg",
                  semanticsLabel: 'Github',
                  height: 24,
                  width: 24,
                ),
                title: const Text("Github"),
                onTap: () async {
                  const url = 'https://github.com/boredcodebyk';
                  if (!await launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication)) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
