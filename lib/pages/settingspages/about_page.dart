import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
        const SliverAppBar.large(
          title: Text("About"),
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
                leading: const Icon(Icons.notes_rounded),
                title: const Text("Licenses"),
                onTap: () => showLicensePage(
                    context: context,
                    applicationName: "Mint Task",
                    applicationVersion: _appVersion),
              ),
              ListTile(
                leading: const Icon(Icons.access_time_outlined),
                title: const Text('Changelog'),
                onTap: () => showModalBottomSheet(
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
