import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/filehandle.dart';
import 'package:minttask/controller/shared_preference_provider.dart';
import 'package:minttask/model/task_model.dart';

final todotxtFilePathProvider = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  String filePath = prefs.getString("savedPath") ?? "";
  ref.listenSelf(
    (previous, next) => prefs.setString("savedPath", next.toString()),
  );
  return filePath;
});

class TodoListNotifier extends Notifier<List<TaskText>> {
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

  void updateTodo(int todoIndex, TaskText task) {
    state[todoIndex] = task;
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

  TaskText valueAt(int todoIndex) => state[todoIndex];
}

final todoListProvider = NotifierProvider<TodoListNotifier, List<TaskText>>(
    () => TodoListNotifier());

class TodoNotifier extends Notifier<TaskText> {
  @override
  TaskText build() {
    return TaskText(
      completion: false,
      priority: null,
      completionDate: null,
      creationDate: DateTime.now(),
      text: '',
      projectTag: [],
      contextTag: [],
      metadata: {},
    );
  }

  void updateFromTask(TaskText task) => state = task;

  TaskText taskValue() => state;

  void clear() => state = TaskText(
        completion: false,
        priority: null,
        completionDate: null,
        creationDate: DateTime.now(),
        text: '',
        projectTag: [],
        contextTag: [],
        metadata: {},
      );
}

final todoItemProvider =
    NotifierProvider<TodoNotifier, TaskText>(() => TodoNotifier());
