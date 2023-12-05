import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/db_model.dart';
import 'ui/listbuilder_ui.dart';
import 'ui/trashitem_ui.dart';

class TrashCan extends StatefulWidget {
  const TrashCan({super.key});

  @override
  State<TrashCan> createState() => _TrashCanState();
}

class _TrashCanState extends State<TrashCan> {
  @override
  Widget build(BuildContext context) {
    TaskListProvider taskListProvider = context.read<TaskListProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
              "Deleted items will stay in trash can for 30 days. After that it will be removed forever."),
        ),
        if (context.watch<TaskListProvider>().trashList.isNotEmpty) ...[
          ListBuilder(
            itemCount: context.watch<TaskListProvider>().trashList.length,
            itemBuilder: (context, index) {
              var task = context.watch<TaskListProvider>().trashList[index];
              return _dismissableListBuilder(
                context,
                TrashListViewCard(
                  id: task.id!,
                  taskTitle: task.title!,
                  description: task.description!,
                  doneStatus: task.doneStatus!,
                  selectedPriority: task.priority!,
                  subtext: task.doNotify ?? false
                      ? Text(
                          "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                      : const Text(""),
                ),
                task.id,
                context.read<TaskListProvider>(),
              );
            },
          ),
        ] else if (taskListProvider.trashList.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Trash is empty"),
          ),
      ],
    );
  }

  Widget _dismissableListBuilder(
      context, listviewwidget, id, TaskListProvider taskListProvider) {
    return Dismissible(
        key: ValueKey(id),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Restore'),
                content: const Text('Are you sure to restore?'),
                actions: [
                  TextButton(
                      child: const Text("Yes"),
                      onPressed: () {
                        Navigator.pop(context, true);
                        taskListProvider.undoTrash(id);
                        //_deleteTodo(todo["id"]);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Restored"),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () {
                                taskListProvider.moveToTrash(id);
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
          } else {
            return await showDialog(
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
          }
        },
        onDismissed: (direction) {
          //_deleteTodo(todo['id']);
          if (direction == DismissDirection.startToEnd) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Restored"),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () => taskListProvider.moveToTrash(id),
                ),
              ),
            );
          } else {
            taskListProvider.moveToArchive(id);
          }
        },
        background: Container(
          color: Theme.of(context).colorScheme.primary,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            Icons.restore_from_trash_rounded,
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
        secondaryBackground: Container(
          color: Theme.of(context).colorScheme.secondaryContainer,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            Icons.archive,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        child: listviewwidget);
  }
}
