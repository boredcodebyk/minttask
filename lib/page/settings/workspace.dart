import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/components/createworkspace_dir.dart';
import 'package:minttask/model/todo_provider.dart';

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
              children: [
                Text(ref.watch(filePathProvider)),
                Text("Lines: ${ref.watch(todoListProvider).length}")
              ],
            ),
          )
        ],
      ),
      bottomSheet: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton.tonal(
                onPressed: () {
                  ref.read(filePathProvider.notifier).state = "";
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("Folder does not contain \"todo.txt\" file")));
                },
                child: const Text("Close")),
            FilledButton(
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
                          content: Text(
                              "Folder does not contain \"todo.txt\" file")));
                    }
                  }
                },
                child: const Text("Open")),
            FilledButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        const Dialog.fullscreen(child: CreateWorkspaceDir()),
                  );
                },
                child: const Text("New")),
          ],
        ),
      ),
    );
  }
}
