import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/error_provider.dart';
import 'package:minttask/controller/router_provider.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';
import 'package:minttask/controller/todotxt_parser.dart';
import 'package:minttask/model/task_model.dart';
import 'package:path/path.dart';

class RawFileNotifier extends Notifier<String> {
  @override
  build() {
    return "";
  }

  List<TaskText> toList() {
    return state.trim().isNotEmpty
        ? state
            .trim()
            .split('\n')
            .map(
              (e) => TaskParser().parser(e),
            )
            .toList()
        : <TaskText>[];
  }

  void updateState() async {
    File file = File(ref.watch(todotxtFilePathProvider));
    state = (await file.readAsString()).trim();
    ref.read(todoListProvider.notifier).updateState(toList());
  }

  void createFile(String fileName) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // User canceled the picker
    } else {
      File newFile = File(join(selectedDirectory, fileName));
      if (await newFile.exists()) {
      } else {
        await newFile.create();
        await newFile.writeAsString("");
        ref.read(todotxtFilePathProvider.notifier).state = newFile.path;
      }
    }
  }

  void saveFile(List<TaskText> list) async {
    String listToRawText = list
        .map(
          (e) => e.line().trim(),
        )
        .toList()
        .join('\n');
    try {
      File activeFile = File(ref.watch(todotxtFilePathProvider));
      await activeFile.writeAsString(listToRawText);
      state = listToRawText;
      ref.read(todoListProvider.notifier).updateState(toList());
    } catch (e) {
      ref.read(errorProvider.notifier).state = e.toString();
      ref.read(routerProvider).push('/erroroccured');
    }
  }

  void openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      ref.read(todotxtFilePathProvider.notifier).state = file.path;
      state = (await file.readAsString()).trim();
    } else {
      // Canceled
    }
  }
}

final rawFileProvider =
    NotifierProvider<RawFileNotifier, String>(() => RawFileNotifier());
