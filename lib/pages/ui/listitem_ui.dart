import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/model/settings_model.dart';
import 'package:minttask/pages/info_page.dart';
import 'package:minttask/utils/transition.dart';
import 'package:provider/provider.dart';

import '../../model/db_model.dart';
import '../pages.dart';

class ListViewCard extends ListTile {
  ListViewCard({
    super.key,
    required this.id,
    required this.taskTitle,
    required this.description,
    required this.doneStatus,
    required this.selectedPriority,
    required this.archive,
    required this.trash,
    required this.pinned,
    required this.subtext,
  });
  final int id;
  final String taskTitle;
  final String description;
  final bool doneStatus;
  final Priority selectedPriority;
  final bool archive;
  final bool trash;
  final bool pinned;
  final Widget subtext;
  final isarInstance = IsarHelper.instance;
  @override
  Widget build(BuildContext context) {
    TodoListModel tdl = Provider.of<TodoListModel>(context);
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
          onLongPress: () => _bottomSheet(context: context),
          tileColor: Color(CorePalette.of(
                  Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 98 : 17)),
          onTap: () async {
            action();
          },
          leading: Checkbox(
            value: doneStatus,
            onChanged: (value) => isarInstance.markTaskDone(id, value!),
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

  Future _bottomSheet({context}) {
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
              if (archive) ...[
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
                    leading: const Icon(Icons.unarchive_outlined),
                    title: const Text("Unarchive"),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Unarchive'),
                          content: const Text('Are you sure to undo archive?'),
                          actions: [
                            TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  isarInstance.undoArchive(id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Unarchived"),
                                      behavior: SnackBarBehavior.floating,
                                      action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          isarInstance.moveToArchive(id);
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
              ] else ...[
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
                          content:
                              const Text('Are you sure to move to archive?'),
                          actions: [
                            TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  isarInstance.moveToArchive(id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Moved to archive"),
                                      behavior: SnackBarBehavior.floating,
                                      action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          isarInstance.undoArchive(id);
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
              ],
              if (trash) ...[
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
                    leading: const Icon(Icons.restore_from_trash),
                    title: const Text("Restore"),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Restore'),
                          content: const Text('Are you sure to restore?'),
                          actions: [
                            TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  isarInstance.undoTrash(id);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Restored"),
                                      behavior: SnackBarBehavior.floating,
                                      action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          isarInstance.moveToTrash(id);
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
                    leading: const Icon(Icons.delete_forever_outlined),
                    title: const Text("Delete forever"),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text('This task will delete forever'),
                          actions: [
                            TextButton(
                                child: const Text("Proceed"),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  isarInstance.deleteTask(id);
                                }),
                            TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.pop(context, false)),
                          ],
                        ),
                      );

                      if (context.mounted) Navigator.of(context).pop();
                    },
                  ),
                ),
              ] else ...[
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
                                  isarInstance.moveToTrash(id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Moved to trash"),
                                      behavior: SnackBarBehavior.floating,
                                      action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          isarInstance.undoTrash(id);
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
              ],
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
                  leading: pinned
                      ? const Icon(Icons.push_pin)
                      : const Icon(Icons.push_pin_outlined),
                  title: pinned ? const Text("Unpin") : const Text("Pin"),
                  onTap: () async {
                    Navigator.of(context).pop();
                    if (pinned) {
                      isarInstance.pinToggle(id, false);
                    } else {
                      isarInstance.pinToggle(id, true);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: pinned
                            ? const Text("Unpinned")
                            : archive
                                ? const Text("Unarchived and pinned")
                                : trash
                                    ? const Text("Restored and pinned")
                                    : const Text("Pinned"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
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
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Overview"),
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
