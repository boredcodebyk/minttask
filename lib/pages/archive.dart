import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/db_model.dart';
import 'ui/listbuilder_ui.dart';
import 'ui/archiveitem_ui.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  Widget build(BuildContext context) {
    TaskListProvider taskListProvider = context.read<TaskListProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (context.watch<TaskListProvider>().archiveList.isNotEmpty) ...[
          ListBuilder(
            itemCount: context.watch<TaskListProvider>().archiveList.length,
            itemBuilder: (context, index) {
              var task = context.watch<TaskListProvider>().archiveList[index];
              return _dismissableListBuilder(
                context,
                ArchiveListViewCard(
                  id: task.id!,
                  taskTitle: task.title!,
                  description: task.description!,
                  doneStatus: task.doneStatus!,
                  selectedPriority: task.priority!,
                  subtext: task.doNotify!
                      ? Text(
                          "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                      : const Text(""),
                ),
                task.id,
                context.read<TaskListProvider>(),
              );
            },
          ),
        ] else if (taskListProvider.archiveList.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Archive is empty"),
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
          } else {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Unarchive'),
                content: const Text('Are you sure to undo archive?'),
                actions: [
                  TextButton(
                      child: const Text("Yes"),
                      onPressed: () {
                        Navigator.pop(context, true);
                        taskListProvider.undoArchive(id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Unarchive"),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () {
                                taskListProvider.moveToArchive(id);
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
                content: const Text("Moved to trash"),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () => taskListProvider.undoArchive(id),
                ),
              ),
            );
          } else {
            taskListProvider.moveToArchive(id);
          }
        },
        background: Container(
          color: Theme.of(context).colorScheme.error,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
        secondaryBackground: Container(
          color: Theme.of(context).colorScheme.secondaryContainer,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            Icons.unarchive,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        child: listviewwidget);
  }
}
