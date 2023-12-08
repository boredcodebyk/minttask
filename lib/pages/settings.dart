import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import '../model/settings_model.dart';
import '../utils/utils.dart';
import 'pages.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Settings"),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: const Icon(Icons.settings_applications_rounded),
                  title: const Text("General"),
                  subtitle: const Text("Gesture, Backup and restore"),
                  onTap: () => Navigator.push(context,
                      createRouteSharedAxisTransition(const GeneralSettings())),
                ),
                ListTile(
                  leading: const Icon(Icons.design_services_outlined),
                  title: const Text("Display"),
                  subtitle: const Text("Dynamic color, Dark theme"),
                  onTap: () => Navigator.push(context,
                      createRouteSharedAxisTransition(const ThemePage())),
                ),
                ListTile(
                  leading: const Icon(Icons.app_settings_alt_outlined),
                  title: const Text("Run setup"),
                  onTap: () {
                    settings.firstLaunch = true;
                    Restart.restartApp();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("About"),
                  subtitle: const Text("Version, Changelog, Licenses"),
                  onTap: () => Navigator.push(context,
                      createRouteSharedAxisTransition(const AboutPage())),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar.large(
            title: Text("General"),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.swipe_rounded),
                  title: const Text("Swipe actions"),
                  onTap: () => Navigator.push(context,
                      createRouteSharedAxisTransition(const SwipeActionPage())),
                ),
                ListTile(
                  leading: const Icon(Icons.backup_outlined),
                  title: const Text("Backup"),
                  onTap: () => Navigator.push(context,
                      createRouteSharedAxisTransition(const BackupPage())),
                ),
                ListTile(
                  leading: const Icon(Icons.restore),
                  title: const Text("Restore"),
                  onTap: () => Navigator.push(context,
                      createRouteSharedAxisTransition(const RestorePage())),
                ),
                ListTile(
                  leading: const Icon(Icons.warning),
                  title: const Text("Reset"),
                  subtitle: const Text(
                      "Warning, this will erase the entire database. "),
                  onTap: () => Navigator.push(context,
                      createRouteSharedAxisTransition(const ResetPage())),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
