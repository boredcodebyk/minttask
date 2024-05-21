import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: const Text("Settings"),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.file_copy_outlined),
                      title: const Text("Active todo.txt file"),
                      subtitle: const Text("Close, Open, Create new..."),
                      onTap: () => context.push('/settingsview/activefile'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.color_lens_outlined),
                      title: const Text("Theme"),
                      subtitle: const Text("Dark mode, Dynamic color..."),
                      onTap: () => context.push('/settingsview/theme'),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
