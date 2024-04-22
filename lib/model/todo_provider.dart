import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/file_model.dart';

import 'settings_provider.dart';

final filePathProvider = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final savedPath = prefs.getString("savedPath") ?? "";
  ref.listenSelf((previous, next) {
    prefs.setString("savedPath", next.toString());
  });
  return savedPath;
});

final configfilePathProvider = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final savedConfigPath = prefs.getString("savedConfigPath") ?? "";
  ref.listenSelf((previous, next) {
    prefs.setString("savedConfigPath", next.toString());
  });
  return savedConfigPath;
});

final todoContentProvider = StateProvider((ref) {
  String todoContent = "";
  if (ref.watch(filePathProvider).isNotEmpty) {
    File todotxt = File(ref.watch(filePathProvider));
    var val = todotxt.readAsStringSync();
    return val;
  } else {
    return todoContent;
  }
});

final todoListProvider = StateProvider((ref) {
  List<String> todoList = ref.watch(todoContentProvider).trim().isNotEmpty
      ? ref.watch(todoContentProvider).trim().split("\n")
      : [];

  return todoList;
});

final contextTagsInWorkspaceProvider = StateProvider((ref) {
  List<ContextTag> allContextTags = [];
  return allContextTags;
});

final projectTagsInWorkspaceProvider = StateProvider((ref) {
  List<String> allProjectTags = [];
  return allProjectTags;
});

final metadatakeysInWorkspaceProvider = StateProvider((ref) {
  List<String> allmetadatakeys = [];
  return allmetadatakeys;
});

final selectedItem = StateProvider((ref) {
  List<int> selectedIndex = [];
  return selectedIndex;
});

final workspaceConfigStateProvider = StateProvider((ref) => WorkspaceConfig());
