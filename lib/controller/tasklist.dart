import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/customlist.dart';
import '../model/task.dart';
import 'pref.dart';

final taskListProvider = StateProvider<List<Task>>((ref) {
  List<Task> taskList = [];
  return taskList;
});

final customListProvider = StateProvider<List<CustomList>>((ref) {
  List<CustomList> customList = [];
  return customList;
});

final hideCompleted = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final hide = prefs.getBool("hideCompleted") ?? false;
  ref.listenSelf((previous, next) {
    prefs.setBool("hideCompleted", next);
  });
  return hide;
});
