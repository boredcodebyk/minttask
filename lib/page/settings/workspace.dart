import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/components/createworkspace_dir.dart';
import 'package:minttask/model/pagetransition.dart';
import 'package:minttask/model/todo_provider.dart';
import 'package:minttask/page/settings/savedtags.dart';

class WorkspaceSettings extends ConsumerStatefulWidget {
  const WorkspaceSettings({super.key});

  @override
  ConsumerState<WorkspaceSettings> createState() => _WorkspaceSettingsState();
}

class _WorkspaceSettingsState extends ConsumerState<WorkspaceSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar.large(
            title: Text("Active workspace"),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.file_open_outlined),
                  title: Text(
                    "File Path:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ref.watch(filePathProvider)),
                      Text("Lines: ${ref.watch(todoListProvider).length}"),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_applications_outlined),
                  title: Text(
                    "Workspace Config Path:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(ref.watch(configfilePathProvider)),
                ),
                ListTile(
                  leading: const Icon(Icons.tag_rounded),
                  title: const Text("Saved Tags"),
                  subtitle: const Text("Project, Context and Metadata"),
                  trailing: const Icon(Icons.chevron_right_outlined),
                  onTap: () => Navigator.push(context,
                      createRouteSharedAxisTransition(const SavedTags())),
                )
              ],
            ),
          )
        ],
      ),
      bottomSheet: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilledButton.tonal(
                  onPressed: () {
                    ref.read(filePathProvider.notifier).state = "";
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content:
                            Text("Folder does not contain \"todo.txt\" file")));
                  },
                  child: const Text("Close")),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilledButton(
                  onPressed: () async {
                    String? selectedDirectory =
                        await FilePicker.platform.getDirectoryPath();

                    if (selectedDirectory == null) {
                      // User canceled the picker
                    } else {
                      File todotxtFile = File("$selectedDirectory/todo.txt");
                      if (await todotxtFile.exists()) {
                        ref.read(filePathProvider.notifier).state =
                            todotxtFile.path;
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            behavior: SnackBarBehavior.fixed,
                            content: Text(
                                "Folder does not contain \"todo.txt\" file")));
                      }
                    }
                  },
                  child: const Text("Open")),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilledButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const Dialog.fullscreen(child: CreateWorkspaceDir()),
                    );
                  },
                  child: const Text("New")),
            ),
          ],
        ),
      ),
    );
  }
}
