import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/pages/reorder_list.dart';
import 'package:minttask/pages/ui/category_ui.dart';
import 'package:minttask/utils/enum_utils.dart';
import 'package:minttask/utils/transition.dart';
import 'package:provider/provider.dart';

import 'package:minttask/model/db_model.dart';
import 'package:minttask/model/settings_model.dart';
import 'package:minttask/pages/ui/listbuilder_ui.dart';
import 'package:minttask/pages/ui/listitem_ui.dart';

class AllListView extends StatefulWidget {
  const AllListView({super.key});
  @override
  State<AllListView> createState() => _AllListViewState();
}

class _AllListViewState extends State<AllListView> {
  Map<int, bool> catSortList = {};
  late List<TaskData> taskListPinned;
  late List<TaskData> taskListUnpinned;
  late List<TaskData> completedTask;
  late List<TaskData> incompletedTaskUnpinned;
  List<int> tempCatList = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    taskListPinned = context.watch<TaskListProvider>().taskListPinned;
    taskListUnpinned = context.watch<TaskListProvider>().taskListUnpinned;
    completedTask = context.watch<TaskListProvider>().completedTaskList;
    incompletedTaskUnpinned =
        context.watch<TaskListProvider>().incompletedTaskUnpinnedList;
  }

  @override
  Widget build(BuildContext context) {
    TaskListProvider taskListProvider = context.read<TaskListProvider>();
    TodoListModel tdl = Provider.of<TodoListModel>(context);
    SettingsModel settingsModel = Provider.of<SettingsModel>(context);
    List<CategoryList> categoryListFilter =
        context.watch<TaskListProvider>().categoryList;

    print(taskListProvider.sortLabelSelection);
    print("object");
    if (tdl.sort == "id") {
      taskListPinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.id!.compareTo(b.orderID!)
            : b.id!.compareTo(a.orderID!),
      );
      taskListUnpinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.id!.compareTo(b.orderID!)
            : b.id!.compareTo(a.orderID!),
      );
      incompletedTaskUnpinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.id!.compareTo(b.orderID!)
            : b.id!.compareTo(a.orderID!),
      );
      completedTask.sort(
        (a, b) => tdl.filter == "asc"
            ? a.id!.compareTo(b.orderID!)
            : b.id!.compareTo(a.orderID!),
      );
    } else if (tdl.sort == "title") {
      taskListPinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.title!.compareTo(b.title!)
            : b.title!.compareTo(a.title!),
      );
      taskListUnpinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.title!.compareTo(b.title!)
            : b.title!.compareTo(a.title!),
      );
      incompletedTaskUnpinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.title!.compareTo(b.title!)
            : b.title!.compareTo(a.title!),
      );
      completedTask.sort(
        (a, b) => tdl.filter == "asc"
            ? a.title!.compareTo(b.title!)
            : b.title!.compareTo(a.title!),
      );
    } else if (tdl.sort == "date_created") {
      taskListPinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.dateCreated!.compareTo(b.dateCreated!)
            : b.dateCreated!.compareTo(a.dateCreated!),
      );
      taskListUnpinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.dateCreated!.compareTo(b.dateCreated!)
            : b.dateCreated!.compareTo(a.dateCreated!),
      );
      incompletedTaskUnpinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.dateCreated!.compareTo(b.dateCreated!)
            : b.dateCreated!.compareTo(a.dateCreated!),
      );
      completedTask.sort(
        (a, b) => tdl.filter == "asc"
            ? a.dateCreated!.compareTo(b.dateCreated!)
            : b.dateCreated!.compareTo(a.dateCreated!),
      );
    } else if (tdl.sort == "date_modified") {
      taskListPinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.dateModified!.compareTo(b.dateModified!)
            : b.dateModified!.compareTo(a.dateModified!),
      );
      taskListUnpinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.dateModified!.compareTo(b.dateModified!)
            : b.dateModified!.compareTo(a.dateModified!),
      );
      incompletedTaskUnpinned.sort(
        (a, b) => tdl.filter == "asc"
            ? a.dateModified!.compareTo(b.dateModified!)
            : b.dateModified!.compareTo(a.dateModified!),
      );
      completedTask.sort(
        (a, b) => tdl.filter == "asc"
            ? a.dateModified!.compareTo(b.dateModified!)
            : b.dateModified!.compareTo(a.dateModified!),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ActionChip(
                    label: const Text("Labels"),
                    avatar: tdl.useCategorySort
                        ? const Icon(Icons.label)
                        : const Icon(Icons.label_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        createRouteSharedAxisTransition(
                          const CategoryListUI(
                            mode: CategorySelectMode.sort,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FilterChip(
                    label: const Text("Show completed"),
                    selected: settingsModel.showCompletedTask,
                    onSelected: (val) => settingsModel.showCompletedTask = val,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ActionChip(
                    label: const Text("Reorder"),
                    avatar: const Icon(Icons.move_up),
                    onPressed: () => Navigator.push(
                        context,
                        createRouteSharedAxisTransition(
                            const ReorderListView())),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (taskListPinned.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Pinned - ${taskListPinned.length}"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListBuilder(
              itemCount: taskListPinned.length,
              itemBuilder: (context, index) {
                var task = taskListPinned[index];

                return _dismissableListBuilder(
                  context,
                  ListViewCard(
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
                  task.pinned!,
                );
              },
            ),
          ),
        ],
        if (taskListUnpinned.isNotEmpty) ...[
          if (tdl.useCategorySort)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskListProvider.sortLabelSelection.entries
                  .where((element) => element.value)
                  .map((e) => e.key)
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                var key = taskListProvider.sortLabelSelection.entries
                    .where((element) => element.value)
                    .map((e) => e.key)
                    .toList()[index];
                var selectedLabelName = taskListProvider.categoryList
                    .where((element) => element.id == key)
                    .map((e) => e.name)
                    .toList()
                    .first
                    .toString();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(selectedLabelName),
                    ),
                    ListBuilder(
                      itemCount: taskListUnpinned
                          .where((element) => element.labels!.contains(key))
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        var task = taskListUnpinned
                            .where((element) => element.labels!.contains(key))
                            .toList()[index];

                        return _dismissableListBuilder(
                          context,
                          ListViewCard(
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
                          task.pinned!,
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("..."),
                    ),
                  ],
                );
              },
            )
          else ...[
            if (settingsModel.showCompletedTask) ...[
              if (taskListPinned.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Others"),
                ),
              ListBuilder(
                itemCount: taskListUnpinned.length,
                itemBuilder: (context, index) {
                  var task = taskListUnpinned[index];

                  return _dismissableListBuilder(
                    context,
                    ListViewCard(
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
                    task.pinned!,
                  );
                },
              ),
            ] else ...[
              if (taskListPinned.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Others"),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ListBuilder(
                  itemCount: incompletedTaskUnpinned.length,
                  itemBuilder: (context, index) {
                    var task = incompletedTaskUnpinned[index];

                    return _dismissableListBuilder(
                      context,
                      ListViewCard(
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
                      task.pinned!,
                    );
                  },
                ),
              ),
              ExpansionTile(
                title: Text("Completed - ${completedTask.length}"),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ListBuilder(
                      itemCount: completedTask.length,
                      itemBuilder: (context, index) {
                        var task = completedTask[index];

                        return _dismissableListBuilder(
                          context,
                          ListViewCard(
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
                          task.pinned!,
                        );
                      },
                    ),
                  ),
                ],
              )
            ]
          ]
        ] else if (taskListProvider.taskListUnpinned.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("List is empty"),
          ),
      ],
    );
  }

  Widget _dismissableListBuilder(context, listviewwidget, id,
      TaskListProvider taskListProvider, bool pin) {
    SettingsModel settingsModel = Provider.of<SettingsModel>(context);
    return Dismissible(
        key: ValueKey(id),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            switch (settingsModel.leftSwipeAction) {
              case LeftSwipeAction.trash:
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

              case LeftSwipeAction.archive:
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

              case LeftSwipeAction.pin:
                if (pin) {
                  taskListProvider.pinToggle(id, false);
                } else {
                  taskListProvider.pinToggle(id, true);
                }
                break;
            }
          } else {
            switch (settingsModel.rightSwipeAction) {
              case RightSwipeAction.trash:
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

              case RightSwipeAction.archive:
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

              case RightSwipeAction.pin:
                if (pin) {
                  taskListProvider.pinToggle(id, false);
                } else {
                  taskListProvider.pinToggle(id, true);
                }
                break;
            }
          }
          return null;
        },
        onDismissed: (direction) {
          //_deleteTodo(todo['id']);
          if (direction == DismissDirection.startToEnd) {
            switch (settingsModel.leftSwipeAction) {
              case LeftSwipeAction.trash:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Moved to trash"),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () => taskListProvider.undoTrash(id),
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
                      onPressed: () => taskListProvider.undoArchive(id),
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
                        onPressed: () => taskListProvider.pinToggle(id, false),
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
                        onPressed: () => taskListProvider.pinToggle(id, true),
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
                    content: const Text("Moved to trash"),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () => taskListProvider.undoTrash(id),
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
                      onPressed: () => taskListProvider.undoArchive(id),
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
                        onPressed: () => taskListProvider.pinToggle(id, false),
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
                        onPressed: () => taskListProvider.pinToggle(id, true),
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
                Icons.delete,
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
                Icons.delete,
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
        child: listviewwidget);
  }
}
