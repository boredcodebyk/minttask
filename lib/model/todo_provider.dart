import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_provider.dart';

final filePathProvider = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final savedPath = prefs.getString("savedPath") ?? "";
  ref.listenSelf((previous, next) {
    prefs.setString("savedPath", next.toString());
  });
  return savedPath;
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
  List<String> todoList = ref.watch(todoContentProvider).trim().split("\n");

  return todoList;
});

class TodoNotifier extends Notifier<List<String>> {
  List<String> todoList = [];
  @override
  build() {
    return todoList;
  }
}

final todoProvider =
    NotifierProvider<TodoNotifier, List<String>>(TodoNotifier.new);
