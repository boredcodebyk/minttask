import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';
import 'package:minttask/model/task_model.dart';
import 'package:minttask/view/components/todo_visual_editor.dart';

class NewTodoView extends ConsumerStatefulWidget {
  const NewTodoView({super.key});

  @override
  ConsumerState<NewTodoView> createState() => _NewTodoViewState();
}

class _NewTodoViewState extends ConsumerState<NewTodoView> {
  var task = TaskText(
    completion: false,
    priority: null,
    completionDate: null,
    creationDate: DateTime.now(),
    text: '',
    projectTag: [],
    contextTag: [],
    metadata: {},
  );

  void saveTask() {
    var newtask = ref.watch(todoItemProvider);
    ref.read(todoListProvider.notifier).addTodo(newtask);
  }

  Future<bool?> closeAlertDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text(
            "You have unsaved work. Save it or you will lose the changes made."),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Force Exit")),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Continue")),
              TextButton(
                  onPressed: () {
                    saveTask();
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Save and Exit")),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: (task.line() == ref.watch(todoItemProvider).line()),
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final bool closeEditor = await closeAlertDialog() ?? false;

        if (context.mounted && closeEditor) {
          context.pop();
          ref.read(todoItemProvider.notifier).clear();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: PopScope(
            canPop: task.line() == ref.watch(todoItemProvider).line(),
            onPopInvoked: (didPop) async {
              if (didPop) return;
              if (task.line() != ref.watch(todoItemProvider).line()) {
                final bool closeEditor = await closeAlertDialog() ?? false;

                if (context.mounted && closeEditor) {
                  context.pop();
                  ref.read(todoItemProvider.notifier).clear();
                }
              }
            },
            child: IconButton(
                onPressed: () async {
                  final bool closeEditor = await closeAlertDialog() ?? false;

                  if (context.mounted && closeEditor) {
                    context.pop();
                    ref.read(todoItemProvider.notifier).clear();
                  }
                },
                icon: const Icon(Icons.arrow_back)),
          ),
        ),
        body: const TodoVisualEditor(),
        floatingActionButton: task.line() == ref.watch(todoItemProvider).line()
            ? null
            : FloatingActionButton.extended(
                onPressed: () {
                  saveTask();
                  ref.read(todoItemProvider.notifier).clear();
                  Navigator.of(context).pop(false);
                },
                label: const Text('Save'),
                icon: const Icon(Icons.done),
              ),
      ),
    );
  }
}
