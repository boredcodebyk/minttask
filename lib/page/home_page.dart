import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/components/createworkspace_dir.dart';
import 'package:minttask/components/listitemcard.dart';
import 'package:minttask/model/todo_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final demo =
      """Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
  Dignissim cras tincidunt lobortis feugiat vivamus at augue. 
  Dignissim enim sit amet venenatis urna cursus eget nunc scelerisque. 
  Eget aliquet nibh praesent tristique magna sit amet purus gravida. 
  Egestas tellus rutrum tellus pellentesque eu tincidunt tortor aliquam nulla. 
  Pretium lectus quam id leo in vitae turpis massa sed. 
  Auctor elit sed vulputate mi sit amet mauris commodo quis. 
  Felis donec et odio pellentesque diam volutpat commodo sed egestas. 
  Fringilla phasellus faucibus scelerisque eleifend donec pretium. 
  Tempor id eu nisl nunc. 
  Sed cras ornare arcu dui vivamus arcu felis bibendum. 
  At tempor commodo ullamcorper a lacus vestibulum sed. 
  Turpis tincidunt id aliquet risus feugiat in ante. 
  Suspendisse ultrices gravida dictum fusce ut placerat orci. 
  Pharetra diam sit amet nisl suscipit adipiscing bibendum.""";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ref.watch(filePathProvider).isNotEmpty
            ? ref.watch(todoListProvider).isNotEmpty
                ? Card(
                    elevation: 0,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                        return ListItemCard(
                            todo: todo, doneStatus: false, todoIndex: index);
                      },
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
                        if (await todotxtFile.exists()) {
                          ref.read(filePathProvider.notifier).state =
                              todotxtFile.path;
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
