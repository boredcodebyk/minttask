import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/pagetransition.dart';
import 'package:minttask/model/todo_provider.dart';
import 'package:minttask/page/settings/theme.dart';
import 'package:minttask/page/settings/workspace.dart';
import 'package:provider/provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar.large(
            title: Text("Settings"),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.short_text_sharp),
                  title: const Text("Active workspace"),
                  subtitle: Text(ref.watch(filePathProvider)),
                  onTap: () => Navigator.push(
                      context,
                      createRouteSharedAxisTransition(
                          const WorkspaceSettings())),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: const Text("Theme"),
                  subtitle: const Text("Dark mode, dynamic colors..."),
                  onTap: () => Navigator.push(
                      context,
                      createRouteSharedAxisTransition(
                          const ThemeSettingsPage())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
