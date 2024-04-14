import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/components/createworkspace_dir.dart';
import 'package:minttask/components/listitemcard.dart';
import 'package:minttask/model/file_model.dart';
import 'package:minttask/model/todo_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    FileModel().loadFile(ref.watch(filePathProvider),
        ref.read(todoContentProvider.notifier).state);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ref.watch(filePathProvider).isNotEmpty
            ? ref.watch(todoListProvider).isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 96),
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        clipBehavior: Clip.antiAlias,
                        padding: EdgeInsets.zero,
                        itemCount: ref.watch(todoListProvider).length,
                        itemBuilder: (context, index) {
                          var todo = ref.watch(todoListProvider)[index];
                          return Column(
                            children: [
                              ListItemCard(todo: todo, todoIndex: index),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : const Text("Empty")
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => const Dialog.fullscreen(
                            child: CreateWorkspaceDir()),
                      );
                    },
                    child: const Text("Create New todo.txt File"),
                  ),
                  FilledButton(
                    onPressed: () async {
                      String? selectedDirectory =
                          await FilePicker.platform.getDirectoryPath();

                      if (selectedDirectory == null) {
                        // User canceled the picker
                      } else {
                        File todotxtFile = File("$selectedDirectory/todo.txt");
                        File wsconf = File("$selectedDirectory/workspace.json");
                        if (await todotxtFile.exists()) {
                          ref.read(filePathProvider.notifier).state =
                              todotxtFile.path;
                          if (!(await wsconf.exists())) {
                            await wsconf.create();

                            await wsconf.writeAsString(WorkspaceConfig(
                              contexts: [],
                              projects: [],
                              metadatakeys: [],
                            ).toRawJson());
                            ref.read(configfilePathProvider.notifier).state =
                                '$selectedDirectory/workspace.json';
                          } else {
                            ref.read(configfilePathProvider.notifier).state =
                                '$selectedDirectory/workspace.json';
                          }
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Folder does not contain \"todo.txt\" file")));
                        }
                      }
                    },
                    child: const Text("Open todo.txt File"),
                  ),
                ],
              )
      ],
    );
  }
}
