import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controller/db.dart';
import '../../controller/tasklist.dart';
import '../../controller/todosettings.dart';
import '../../model/task.dart';

class ListItemCard extends ConsumerStatefulWidget {
  const ListItemCard({super.key, required this.task});
  final Task task;

  @override
  ConsumerState<ListItemCard> createState() => _ListItemCardState();
}

class _ListItemCardState extends ConsumerState<ListItemCard> {
  Future<void> updateTodos(sortbycol, filter) async {
    final dbHelper = DatabaseHelper.instance;
    final todolist = await dbHelper.getTodos(sortbycol, filter);

    ref.read(taskListProvider.notifier).state = todolist
        .map(
          (e) => Task.fromJson(e),
        )
        .toList();
  }

  Future<void> _toggleTodoStatus(int id, int isDone) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateTodoStauts(
        id, isDone, DateTime.now().millisecondsSinceEpoch);
    updateTodos(ref.watch(filterProvider).name, ref.watch(sortProvider).name);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surfaceContainerHigh
          : Theme.of(context).colorScheme.surfaceContainerLowest,
      leading: Checkbox(
          value: widget.task.isDone,
          onChanged: (value) {
            _toggleTodoStatus(widget.task.id!, value! ? 1 : 0);
          }),
      title: Text(
        widget.task.title ?? "",
        style: TextStyle(
            decoration: widget.task.isDone!
                ? TextDecoration.lineThrough
                : TextDecoration.none),
      ),
      onTap: () => context.push("/task/${widget.task.id}"),
    );
  }
}
