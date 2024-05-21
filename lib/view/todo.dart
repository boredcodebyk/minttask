import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';
import 'package:minttask/model/task_model.dart';

import 'components/todo_visual_editor.dart';

class TodoView extends ConsumerStatefulWidget {
  const TodoView({super.key, required this.todoIndex});
  final int todoIndex;

  @override
  ConsumerState<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends ConsumerState<TodoView> {
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
    var updateTask = ref.watch(todoItemProvider);
    ref
        .read(todoListProvider.notifier)
        .updateTodo(widget.todoIndex, updateTask);
  }

  Future<bool?> closeAlertDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text(
            "You may have unsaved work. Save it or you will lose the changes made."),
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
                    Navigator.of(context).pop(true);
                    saveTask();
                  },
                  child: const Text("Save and Exit")),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      task = ref.read(todoItemProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (task.line() != ref.watch(todoItemProvider).line()) {
          final bool closeEditor = await closeAlertDialog() ?? false;

          if (context.mounted && closeEditor) {
            context.pop();
            ref.read(todoItemProvider.notifier).clear();
          }
        } else {
          context.pop();
          ref.read(todoItemProvider.notifier).clear();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (didPop) return;
              if (task.line() != ref.watch(todoItemProvider).line()) {
                final bool closeEditor = await closeAlertDialog() ?? false;

                if (context.mounted && closeEditor) {
                  context.pop();
                  ref.read(todoItemProvider.notifier).clear();
                }
              } else {
                context.pop();
                ref.read(todoItemProvider.notifier).clear();
              }
            },
            child: IconButton(
                onPressed: () async {
                  if (task.line() != ref.watch(todoItemProvider).line()) {
                    final bool closeEditor = await closeAlertDialog() ?? false;

                    if (context.mounted && closeEditor) {
                      context.pop();
                      ref.read(todoItemProvider.notifier).clear();
                    }
                  } else {
                    context.pop();
                    ref.read(todoItemProvider.notifier).clear();
                  }
                },
                icon: const Icon(Icons.arrow_back)),
          ),
        ),
        body: const TodoVisualEditor(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            saveTask();
            ref.read(todoItemProvider.notifier).clear();
            context.pop();
          },
          label: const Text('Save'),
          icon: const Icon(Icons.done),
        ),
      ),
    );
  }
}
