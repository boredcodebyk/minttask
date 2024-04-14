import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/file_model.dart';
import 'package:minttask/model/todo_provider.dart';
import 'package:path/path.dart';

class CreateWorkspaceDir extends ConsumerStatefulWidget {
  const CreateWorkspaceDir({super.key});

  @override
  ConsumerState<CreateWorkspaceDir> createState() => _CreateWorkspaceDirState();
}

class _CreateWorkspaceDirState extends ConsumerState<CreateWorkspaceDir> {
  final TextEditingController _workspacePath = TextEditingController();
  String selectedPath = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Create Workspace"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MarkdownBody(data: """
## Steps:
 1. Pick a empty folder. This is make sure todo.txt is the only text file in the folder.
 2. Save
"""),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: TextField(
                      controller: _workspacePath,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Workspace Path"),
                      readOnly: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FilledButton(
                        onPressed: () async {
                          String? outputDir =
                              await FilePicker.platform.getDirectoryPath();
                          if (outputDir == null) {
                          } else {
                            setState(() {
                              selectedPath = outputDir;
                              _workspacePath.text = '$outputDir/';
                            });
                          }
                        },
                        child: const Text("Pick Folder"),
                      ),
                      FilledButton(
                        onPressed: _workspacePath.text.isEmpty
                            ? null
                            : () async {
                                //save and close dialog
                                if (await Directory(selectedPath).exists()) {
                                  File outputfile =
                                      File(join(selectedPath, "todo.txt"));
                                  File wsconf = File(
                                      join(selectedPath, "workspace.json"));
                                  if (await outputfile.exists()) {
                                    if (!mounted) return;
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Error"),
                                        content: const Text(
                                            "A todo.txt file already exist. Select a different folder or overwrite the existing todo.txt file."),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                await outputfile
                                                    .writeAsString("");
                                                ref
                                                        .read(filePathProvider
                                                            .notifier)
                                                        .state =
                                                    '$selectedPath/todo.txt';
                                                await wsconf.writeAsString(
                                                    WorkspaceConfig(
                                                  contexts: [],
                                                  projects: [],
                                                  metadatakeys: [],
                                                ).toRawJson());
                                                ref
                                                        .read(
                                                            configfilePathProvider
                                                                .notifier)
                                                        .state =
                                                    '$selectedPath/workspace.json';
                                                if (!mounted) return;
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Overwrite")),
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedPath = "";
                                                  _workspacePath.clear();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Try Again")),
                                        ],
                                      ),
                                    );
                                  } else {
                                    await outputfile.create();
                                    await outputfile.writeAsString("");
                                    ref.read(filePathProvider.notifier).state =
                                        '$selectedPath/todo.txt';
                                    await wsconf.create();

                                    await wsconf.writeAsString(WorkspaceConfig(
                                      contexts: [],
                                      projects: [],
                                      metadatakeys: [],
                                    ).toRawJson());
                                    ref
                                        .read(configfilePathProvider.notifier)
                                        .state = '$selectedPath/workspace.json';
                                    if (!mounted) return;
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                        child: const Text("Save"),
                      )
                    ],
                  ),
                  if (_workspacePath.text.isNotEmpty)
                    Text(
                        "Summery:\n - Workspace path: ${_workspacePath.text}\n - Files in Workspace:\n     - todo.txt ($selectedPath/todo.txt)")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
