import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minttask/model/settings_model.dart';
import 'package:minttask/pages/ui/listitem_ui.dart';
import 'package:minttask/utils/utils.dart';
import 'package:provider/provider.dart';

import '../model/db_model.dart';
import 'ui/listbuilder_ui.dart';

class TrashCan extends StatefulWidget {
  const TrashCan({super.key});

  @override
  State<TrashCan> createState() => _TrashCanState();
}

class _TrashCanState extends State<TrashCan> {
  final isarInstance = IsarHelper.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: isarInstance.listTrash(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var listTask = snapshot.data;
          if (listTask!.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      "Trash items are automatically deleted forever after 30 days."),
                ),
                ListBuilder(
                  itemCount: listTask.length,
                  itemBuilder: (context, index) {
                    var task = listTask[index];

                    return _dismissableListBuilder(
                      context: context,
                      listItemView: ListViewCard(
                        id: task.id!,
                        taskTitle: task.title!,
                        description: task.description!,
                        doneStatus: task.doneStatus!,
                        selectedPriority: task.priority!,
                        archive: task.archive!,
                        trash: task.trash!,
                        pinned: task.pinned!,
                        subtext: task.doNotify ?? false
                            ? Text(
                                "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                            : const Text(""),
                      ),
                      taskid: task.id!,
                      pin: task.pinned!,
                    );
                  },
                ),
              ],
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Empty"),
            );
          }
        }
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Empty"),
        );
      },
    );
  }

  Widget _dismissableListBuilder(
      {context, listItemView, required int taskid, required bool pin}) {
    SettingsModel settingsModel = Provider.of<SettingsModel>(context);
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          switch (settingsModel.leftSwipeAction) {
            case LeftSwipeAction.trash:
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: const Text('Restore?'),
                  actions: [
                    TextButton(
                        child: const Text("Yes"),
                        onPressed: () {
                          Navigator.pop(context, true);
                          isarInstance.undoTrash(taskid);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Restored"),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  isarInstance.moveToTrash(taskid);
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

            case LeftSwipeAction.archive:
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: const Text('Move to archive?'),
                  actions: [
                    TextButton(
                        child: const Text("Yes"),
                        onPressed: () {
                          Navigator.pop(context, true);
                          isarInstance.moveToArchive(taskid);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Moved to archive"),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  isarInstance.undoArchive(taskid);
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

            case LeftSwipeAction.pin:
              if (pin) {
                isarInstance.pinToggle(taskid, false);
              } else {
                isarInstance.pinToggle(taskid, true);
              }
              break;
          }
        } else {
          switch (settingsModel.rightSwipeAction) {
            case RightSwipeAction.trash:
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: const Text('Restore?'),
                  actions: [
                    TextButton(
                        child: const Text("Yes"),
                        onPressed: () {
                          Navigator.pop(context, true);
                          isarInstance.undoTrash(taskid);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Restored"),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  isarInstance.moveToTrash(taskid);
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

            case RightSwipeAction.archive:
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: const Text('Move to archive?'),
                  actions: [
                    TextButton(
                        child: const Text("Yes"),
                        onPressed: () {
                          Navigator.pop(context, true);
                          isarInstance.moveToArchive(taskid);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Moved to archive"),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  isarInstance.undoArchive(taskid);
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

            case RightSwipeAction.pin:
              if (pin) {
                isarInstance.pinToggle(taskid, false);
              } else {
                isarInstance.pinToggle(taskid, true);
              }
              break;
          }
        }
        return null;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          switch (settingsModel.leftSwipeAction) {
            case LeftSwipeAction.trash:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Restored"),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () => isarInstance.moveToTrash(taskid),
                  ),
                ),
              );
              break;
            case LeftSwipeAction.archive:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Moved to archive"),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () => isarInstance.undoArchive(taskid),
                  ),
                ),
              );
              break;

            case LeftSwipeAction.pin:
              if (pin) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Pinned"),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () => isarInstance.pinToggle(taskid, false),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Unpinned"),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () => isarInstance.pinToggle(taskid, true),
                    ),
                  ),
                );
              }

              break;
          }
        } else {
          switch (settingsModel.rightSwipeAction) {
            case RightSwipeAction.trash:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Restored"),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () => isarInstance.moveToTrash(taskid),
                  ),
                ),
              );
              break;
            case RightSwipeAction.archive:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Moved to archive"),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () => isarInstance.undoArchive(taskid),
                  ),
                ),
              );
              break;

            case RightSwipeAction.pin:
              if (pin) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Pinned"),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () => isarInstance.pinToggle(taskid, false),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Unpinned"),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () => isarInstance.pinToggle(taskid, true),
                    ),
                  ),
                );
              }

              break;
          }
        }
      },
      background: switch (settingsModel.leftSwipeAction) {
        LeftSwipeAction.trash => Container(
            color: Theme.of(context).colorScheme.error,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.restore,
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
        LeftSwipeAction.archive => Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.archive,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        LeftSwipeAction.pin => pin
            ? Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.push_pin,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )
            : Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.push_pin_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
      },
      secondaryBackground: switch (settingsModel.rightSwipeAction) {
        RightSwipeAction.trash => Container(
            color: Theme.of(context).colorScheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.restore,
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
        RightSwipeAction.archive => Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.archive,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        RightSwipeAction.pin => pin
            ? Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.push_pin,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )
            : Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.push_pin_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
      },
      child: listItemView,
    );
  }
}
