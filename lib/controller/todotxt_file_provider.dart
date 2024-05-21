import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/error_provider.dart';
import 'package:minttask/controller/filehandle.dart';
import 'package:minttask/controller/router_provider.dart';
import 'package:minttask/controller/shared_preference_provider.dart';
import 'package:minttask/controller/todotxt_parser.dart';
import 'package:minttask/model/task_model.dart';

final todotxtFilePathProvider = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  String filePath = prefs.getString("savedPath") ?? "";
  ref.listenSelf(
    (previous, next) => prefs.setString("savedPath", next.toString()),
  );
  return filePath;
});

// final todoProvider = StateProvider<List<TaskText>>((ref) {
//   List<TaskText> todoContent = [];
//   if (ref.watch(todotxtFilePathProvider).isNotEmpty) {
//     try {
//       String todotxt = ref.watch(rawFileProvider);
//       return todotxt.trim().isNotEmpty
//           ? todotxt
//               .trim()
//               .split('\n')
//               .map(
//                 (e) => TaskParser().parser(e),
//               )
//               .toList()
//           : todoContent;
//     } catch (e) {
//       ref.read(errorProvider.notifier).state = e.toString();
//       ref.read(routerProvider).push('/erroroccured');
//     }
//   } else {
//     return todoContent;
//   }
//   return todoContent;
// });

class TodoNotifier extends Notifier<List<TaskText>> {
  @override
  List<TaskText> build() {
    return [];
  }

  void addTodo(TaskText todo) {
    state = [todo, ...state];
    ref.read(rawFileProvider.notifier).saveFile(state);
  }

  void removeTodo(int todoIndex) {
    state.removeAt(todoIndex);
    ref.read(rawFileProvider.notifier).saveFile(state);
  }

  void toggle(int todoIndex, bool value) {
    state[todoIndex] = state[todoIndex].copyWith(
        completion: value, completionDate: value ? DateTime.now() : null);

    ref.read(rawFileProvider.notifier).saveFile(state);
  }

  void updateState(List<TaskText> list) {
    state = list;
  }
}

final todoListProvider =
    NotifierProvider<TodoNotifier, List<TaskText>>(() => TodoNotifier());
