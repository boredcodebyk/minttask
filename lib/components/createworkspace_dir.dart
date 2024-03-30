import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/settings_provider.dart';
import 'package:minttask/model/todo_provider.dart';

class CreateWorkspaceDir extends ConsumerStatefulWidget {
  const CreateWorkspaceDir({super.key});

  @override
  ConsumerState<CreateWorkspaceDir> createState() => _CreateWorkspaceDirState();
}

class _CreateWorkspaceDirState extends ConsumerState<CreateWorkspaceDir> {
  final TextEditingController _workspaceName = TextEditingController();
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextField(
                      controller: _workspaceName,
                      onChanged: (value) {
                        setState(() {
                          selectedPath = '${_workspacePath.text}/$value';
                        });
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Workspace Name"),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r"\s"))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _workspacePath,
                      onChanged: (value) {
                        setState(() {
                          selectedPath = '$value${_workspaceName.text}';
                        });
                      },
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
                            if (_workspaceName.text.isEmpty) {
                              setState(() {
                                selectedPath = outputDir;
                                _workspacePath.text = '$outputDir/';
                              });
                            } else {
                              setState(() {
                                selectedPath =
                                    '$outputDir/${_workspaceName.text}';
                                _workspacePath.text =
                                    '$outputDir/${_workspaceName.text}';
                              });
                            }
                          }
                        },
                        child: const Text("Pick Folder"),
                      ),
                      FilledButton(
                        onPressed: _workspacePath.text.isEmpty
                            ? null
                            : () {
                                //save and close dialog
                                File outputfile = File(selectedPath);
                                outputfile.writeAsString("");
                                ref.read(filePathProvider.notifier).state =
                                    '$selectedPath/todo.txt';
                                Navigator.of(context).pop();
                              },
                        child: const Text("Save"),
                      )
                    ],
                  ),
                  if (_workspacePath.text.isNotEmpty)
                    Text(
                        "Summery:\n - Workspace name: ${_workspaceName.text}\n - Workspace path: ${_workspacePath.text}\n - Files in Workspace:\n     - todo.txt ($selectedPath/todo.txt)")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
