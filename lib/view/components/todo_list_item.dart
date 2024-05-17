import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:minttask/controller/todotxt_parser.dart';
import 'package:minttask/model/dummy.dart';
import 'package:minttask/model/task_model.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.todoIndex,
    required this.listItem,
  });
  final int todoIndex;
  final TaskText listItem;
  final pri = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        tileColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surfaceContainerHigh
            : Theme.of(context).colorScheme.surfaceContainerLowest,
        leading: Checkbox(
          value: TaskParser().parser(textList[todoIndex]).completion,
          onChanged: (value) {},
        ),
        title: Text(listItem.text),
        subtitle: Wrap(
          direction: Axis.horizontal,
          spacing: 8,
          children: [
            if (!(listItem.priority == 0 || listItem.priority == null)) ...[
              Chip(
                color: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerHighest),
                side: BorderSide.none,
                avatar: const Icon(
                  Icons.priority_high,
                  size: 12,
                ),
                label: (listItem.priority == null || listItem.priority == 0)
                    ? const Text("")
                    : Text(pri.split("")[listItem.priority! - 1]),
                labelStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ],
            if (listItem.completion)
              Chip(
                color: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerHighest),
                side: BorderSide.none,
                avatar: const Icon(
                  Icons.done,
                  size: 16,
                ),
                label: Text(DateFormat.yMMMMd('en_US')
                    .format(listItem.completionDate!)),
                labelStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ...listItem.contextTag!.map((e) => Chip(
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
            ...listItem.projectTag!.map((e) => Chip(
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
        onTap: () => context.push('/todo/$todoIndex'),
      ),
    );
  }
}
