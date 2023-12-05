import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/model/settings_model.dart';
import 'package:minttask/pages/info_page.dart';
import 'package:minttask/utils/transition.dart';
import 'package:provider/provider.dart';

import '../../model/db_model.dart';
import '../pages.dart';

class ListViewCard extends ListTile {
  const ListViewCard({
    super.key,
    required this.id,
    required this.taskTitle,
    required this.description,
    required this.doneStatus,
    required this.selectedPriority,
    required this.subtext,
  });
  final int id;
  final String taskTitle;
  final String description;
  final bool doneStatus;
  final Priority selectedPriority;
  final Widget subtext;

  @override
  Widget build(BuildContext context) {
    TodoListModel tdl = Provider.of<TodoListModel>(context);
    TaskListProvider taskListProvider = context.read<TaskListProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
      child: OpenContainer(
        closedElevation: 0,
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
        closedBuilder: (context, action) => ListTile(
          subtitle: tdl.detailedView ? subtext : null,
          onLongPress: () => _bottomSheet(context, id, taskListProvider),
          tileColor: Color(CorePalette.of(
                  Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 98 : 17)),
          onTap: () async {
            action();
          },
          leading: Checkbox(
            value: doneStatus,
            onChanged: (value) => taskListProvider.markTaskDone(id, value!),
          ),
          title: Text(
            taskTitle,
            style: TextStyle(
                decoration: doneStatus ? TextDecoration.lineThrough : null),
          ),
          trailing: Icon(Icons.circle,
              color: selectedPriority == Priority.low
                  ? ColorScheme.fromSeed(
                          seedColor: const Color.fromARGB(1, 223, 217, 255))
                      .primary
                  : selectedPriority == Priority.moderate
                      ? ColorScheme.fromSeed(
                              seedColor: const Color.fromARGB(1, 223, 217, 255))
                          .tertiary
                      : ColorScheme.fromSeed(
                              seedColor: const Color.fromARGB(1, 223, 217, 255))
                          .error),
        ),
        openBuilder: (context, action) => EditPage(todoId: id),
      ),
    );
  }

  Future _bottomSheet(context, int id, TaskListProvider taskListProvider) {
    return showModalBottomSheet(
      backgroundColor: Color(
          CorePalette.of(Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
      elevation: 0,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: ListView(
            clipBehavior: Clip.antiAlias,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: ListTile(
                  tileColor: Color(CorePalette.of(
                          Theme.of(context).colorScheme.primary.value)
                      .neutral
                      .get(Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? 98
                          : 17)),
                  leading: const Icon(Icons.archive_outlined),
                  title: const Text("Archive"),
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Move to archive'),
                        content: const Text('Are you sure to move to archive?'),
                        actions: [
                          TextButton(
                              child: const Text("Yes"),
                              onPressed: () {
                                Navigator.pop(context, true);
                                taskListProvider.moveToArchive(id);
                                //_deleteTodo(todo["id"]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Moved to archive"),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: "Undo",
                                      onPressed: () {
                                        taskListProvider.undoArchive(id);
                                      },
                                    ),
                                  ),
                                );
                              }),
                          TextButton(
                              child: const Text("No"),
                              onPressed: () => Navigator.pop(context, false)),
                        ],
                      ),
                    );

                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: ListTile(
                  tileColor: Color(CorePalette.of(
                          Theme.of(context).colorScheme.primary.value)
                      .neutral
                      .get(Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? 98
                          : 17)),
                  leading: const Icon(Icons.delete_outline_outlined),
                  title: const Text("Trash"),
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Move to trash'),
                        content: const Text('Are you sure to move to trash?'),
                        actions: [
                          TextButton(
                              child: const Text("Yes"),
                              onPressed: () {
                                Navigator.pop(context, true);
                                taskListProvider.moveToTrash(id);
                                //_deleteTodo(todo["id"]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Moved to trash"),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: "Undo",
                                      onPressed: () {
                                        taskListProvider.undoTrash(id);
                                      },
                                    ),
                                  ),
                                );
                              }),
                          TextButton(
                              child: const Text("No"),
                              onPressed: () => Navigator.pop(context, false)),
                        ],
                      ),
                    );
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: ListTile(
                  tileColor: Color(CorePalette.of(
                          Theme.of(context).colorScheme.primary.value)
                      .neutral
                      .get(Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? 98
                          : 17)),
                  leading: const Icon(Icons.more_horiz),
                  title: const Text("More"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        createRouteSharedAxisTransition(InfoPage(
                          todoID: id,
                        )));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
