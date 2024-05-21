import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';
import 'package:minttask/model/task_model.dart';

class TodoListItem extends ConsumerStatefulWidget {
  const TodoListItem({
    super.key,
    required this.todoIndex,
    required this.listItem,
  });
  final int todoIndex;
  final TaskText listItem;

  @override
  ConsumerState<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends ConsumerState<TodoListItem> {
  final pri = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  @override
  Widget build(BuildContext context) {
    final todoItem = ref.watch(todoListProvider)[widget.todoIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        tileColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surfaceContainerHigh
            : Theme.of(context).colorScheme.surfaceContainerLowest,
        leading: Checkbox(
          value: todoItem.completion,
          onChanged: (value) {
            ref
                .read(todoListProvider.notifier)
                .toggle(widget.todoIndex, value!);
          },
        ),
        title: Text(widget.listItem.text),
        subtitle: Wrap(
          direction: Axis.horizontal,
          spacing: 8,
          children: [
            if (!(widget.listItem.priority == 0 ||
                widget.listItem.priority == null)) ...[
              Chip(
                color: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerHighest),
                side: BorderSide.none,
                avatar: const Icon(
                  Icons.priority_high,
                  size: 12,
                ),
                label: (widget.listItem.priority == null ||
                        widget.listItem.priority == 0)
                    ? const Text("")
                    : Text(pri.split("")[widget.listItem.priority! - 1]),
                labelStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ],
            if (widget.listItem.completion)
              Chip(
                color: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerHighest),
                side: BorderSide.none,
                avatar: const Icon(
                  Icons.done,
                  size: 16,
                ),
                label: Text(DateFormat.yMMMMd('en_US')
                    .format(widget.listItem.completionDate!)),
                labelStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ...widget.listItem.contextTag!.map((e) => Chip(
                  color: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.surfaceContainerHighest),
                  side: BorderSide.none,
                  avatar: const Icon(
                    Icons.alternate_email,
                    size: 16,
                  ),
                  label: Text(e),
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                )),
            ...widget.listItem.projectTag!.map((e) => Chip(
                  color: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.surfaceContainerHighest),
                  side: BorderSide.none,
                  avatar: const Icon(
                    Icons.add,
                    size: 16,
                  ),
                  label: Text(e),
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                )),
          ],
        ),
        onTap: () {
          ref.read(todoItemProvider.notifier).updateFromTask(widget.listItem);
          context.push('/todo/${widget.todoIndex}');
        },
      ),
    );
  }
}
