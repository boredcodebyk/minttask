import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/todo_provider.dart';

class SavedTags extends ConsumerWidget {
  const SavedTags({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar.large(
            title: Text("Saved Tags"),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text("Project tags"),
                  subtitle: Text(
                      "${ref.watch(projectTagsInWorkspaceProvider).length}"),
                ),
                ListTile(
                  title: const Text("Context tags"),
                  subtitle: Text(
                      "${ref.watch(contextTagsInWorkspaceProvider).length}"),
                ),
                ListTile(
                  title: const Text("Metadata tags"),
                  subtitle: Text(
                      "${ref.watch(metadatakeysInWorkspaceProvider).length}"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
