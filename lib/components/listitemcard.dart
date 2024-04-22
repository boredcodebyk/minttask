import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/model/file_model.dart';
import 'package:minttask/model/todo_provider.dart';
import 'package:minttask/model/todotxt_parser.dart';
import 'package:minttask/page/editpage.dart';

class ListItemCard extends ConsumerStatefulWidget {
  const ListItemCard(
      {super.key,
      required this.todo,
      required this.todoIndex,
      required this.isSelected});

  final String todo;
  final int todoIndex;
  final bool isSelected;

  @override
  ConsumerState<ListItemCard> createState() => _ListItemCardState();
}

class _ListItemCardState extends ConsumerState<ListItemCard> {
  String getCurrentDate() {
    var date = DateTime.now();
    var formated = DateFormat("yyyy-MM-dd").format(date);
    return formated;
  }

  var pri = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
      child: OpenContainer(
        closedElevation: 0,
        transitionDuration: const Duration(milliseconds: 300),
        transitionType: ContainerTransitionType.fadeThrough,
        closedColor: Color(
            CorePalette.of(Theme.of(context).colorScheme.primary.value)
                .neutral
                .get(
                    Theme.of(context).colorScheme.brightness == Brightness.light
                        ? 98
                        : 17)),
        clipBehavior: Clip.antiAlias,
        middleColor: Color(
            CorePalette.of(Theme.of(context).colorScheme.primary.value)
                .neutral
                .get(
                    Theme.of(context).colorScheme.brightness == Brightness.light
                        ? 98
                        : 17)),
        closedBuilder: (context, action) {
          return ListTile(
            selected: widget.isSelected,
            onLongPress: () {
              widget.isSelected
                  ? ref
                      .read(selectedItem.notifier)
                      .state
                      .removeWhere((item) => item == widget.todoIndex)
                  : ref.read(selectedItem.notifier).state.add(widget.todoIndex);
            },
            isThreeLine: true,
            tileColor: Color(
                CorePalette.of(Theme.of(context).colorScheme.primary.value)
                    .neutral
                    .get(Theme.of(context).brightness == Brightness.light
                        ? 98
                        : 17)),
            onTap: () async {
              action();
            },
            leading: Checkbox(
                value: TaskParser().parser(widget.todo).completion,
                onChanged: (value) async {
                  if (TaskParser().parser(widget.todo).completion) {
                    (ref.read(todoListProvider.notifier).state)[
                        widget
                            .todoIndex] = TaskParser().lineConstructor(TaskText(
                        completion: false,
                        creationDate:
                            TaskParser().parser(widget.todo).creationDate,
                        text: TaskParser().parser(widget.todo).text,
                        completionDate: null,
                        contextTag: TaskParser().parser(widget.todo).contextTag,
                        projectTag: TaskParser().parser(widget.todo).projectTag,
                        metadata: TaskParser().parser(widget.todo).metadata,
                        priority: TaskParser().parser(widget.todo).priority));
                    ref.read(todoContentProvider.notifier).state =
                        ref.watch(todoListProvider).join("\n");

                    await FileManagementModel().saveTextFile(
                        path: ref.watch(filePathProvider),
                        content: ref.watch(todoContentProvider));
                    var r = await FileManagementModel()
                        .readTextFile(path: ref.watch(filePathProvider));
                    if (r.result!.isNotEmpty) {
                      ref.read(todoContentProvider.notifier).state = r.result!;
                    }
                  } else {
                    ref.read(todoListProvider.notifier).state[
                        widget
                            .todoIndex] = TaskParser().lineConstructor(TaskText(
                        completion: true,
                        creationDate:
                            TaskParser().parser(widget.todo).creationDate,
                        text: TaskParser().parser(widget.todo).text,
                        completionDate: DateTime.now(),
                        contextTag: TaskParser().parser(widget.todo).contextTag,
                        projectTag: TaskParser().parser(widget.todo).projectTag,
                        metadata: TaskParser().parser(widget.todo).metadata,
                        priority: TaskParser().parser(widget.todo).priority));
                    ref.read(todoContentProvider.notifier).state =
                        ref.watch(todoListProvider).join("\n");
                    await FileManagementModel().saveTextFile(
                        path: ref.watch(filePathProvider),
                        content: ref.watch(todoContentProvider));
                    var r = await FileManagementModel()
                        .readTextFile(path: ref.watch(filePathProvider));
                    if (r.result!.isNotEmpty) {
                      ref.read(todoContentProvider.notifier).state = r.result!;
                    }
                  }
                }),
            title: Text(
              TaskParser().parser(widget.todo).text,
              style: TextStyle(
                  decoration: TaskParser().parser(widget.todo).completion
                      ? TextDecoration.lineThrough
                      : null),
            ),
            subtitle: Wrap(
              direction: Axis.horizontal,
              spacing: 8,
              children: [
                if (!(TaskParser().parser(widget.todo).priority == 0 ||
                    TaskParser().parser(widget.todo).priority == null)) ...[
                  Chip(
                    color: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.surfaceVariant),
                    side: BorderSide.none,
                    avatar: const Icon(
                      Icons.priority_high,
                      size: 12,
                    ),
                    label: (TaskParser().parser(widget.todo).priority == null ||
                            TaskParser().parser(widget.todo).priority == 0)
                        ? const Text("")
                        : Text(pri.split("")[
                            TaskParser().parser(widget.todo).priority! - 1]),
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
                if (TaskParser().parser(widget.todo).completion)
                  Chip(
                    color: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.surfaceVariant),
                    side: BorderSide.none,
                    avatar: const Icon(
                      Icons.done,
                      size: 16,
                    ),
                    label: Text(DateFormat.yMMMMd('en_US').format(
                        TaskParser().parser(widget.todo).completionDate!)),
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                  ),
                ...TaskParser().parser(widget.todo).contextTag!.map((e) => Chip(
                      color: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.surfaceVariant),
                      side: BorderSide.none,
                      avatar: const Icon(
                        Icons.alternate_email,
                        size: 16,
                      ),
                      label: Text(e),
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                    )),
                ...TaskParser().parser(widget.todo).projectTag!.map((e) => Chip(
                      color: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.surfaceVariant),
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
          );
        },
        openBuilder: (context, action) => EditPage(index: widget.todoIndex),
      ),
    );
  }
}
