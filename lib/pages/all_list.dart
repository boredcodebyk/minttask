import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minttask/pages/reorder_list.dart';

import 'package:minttask/pages/ui/labeleditor_ui.dart';
import 'package:minttask/utils/enum_utils.dart';
import 'package:minttask/utils/transition.dart';
import 'package:provider/provider.dart';

import 'package:minttask/model/db_model.dart';
import 'package:minttask/model/settings_model.dart';
import 'package:minttask/pages/ui/listbuilder_ui.dart';
import 'package:minttask/pages/ui/listitem_ui.dart';

class MainListView extends StatefulWidget {
  const MainListView({super.key});

  @override
  State<MainListView> createState() => _MainListViewState();
}

class _MainListViewState extends State<MainListView> {
  List<int> selectedLabels = [];
  final isarInstance = IsarHelper.instance;
  @override
  Widget build(BuildContext context) {
    TodoListModel tdl = Provider.of<TodoListModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ActionChip(
                    label: const Text("Labels"),
                    avatar: tdl.useCategorySort
                        ? const Icon(Icons.label)
                        : const Icon(Icons.label_outline),
                    onPressed: () async {
                      final result = await showModalBottomSheet(
                        showDragHandle: true,
                        context: context,
                        builder: (context) => LabelEditor(
                          mode: CategorySelectMode.sort,
                          selectedValue: selectedLabels,
                        ),
                      );
                      if (!mounted) return;
                      setState(() {
                        selectedLabels = result ?? [];
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FilterChip(
                    label: const Text("Show completed"),
                    selected: tdl.showCompletedTask,
                    onSelected: (val) => tdl.showCompletedTask = val,
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
        if (tdl.useCategorySort) ...[
          if (selectedLabels.isEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Select category label to filter..."),
            ),
          ] else ...[
            listBuilderView(
              context: context,
              sort: tdl.sort,
              filter: tdl.filter,
              selectedLabels: selectedLabels,
            ),
          ],
        ] else ...[
          listBuilderView(
            context: context,
            sort: tdl.sort,
            filter: tdl.filter,
            selectedLabels: const [],
          ),
        ],
      ],
    );
  }

  Widget listBuilderView(
      {required BuildContext context,
      SortList? sort,
      FilterList? filter,
      List<int>? selectedLabels}) {
    TodoListModel tdl = Provider.of<TodoListModel>(context);
    return StreamBuilder(
      stream: isarInstance.listTasks(sort: sort, filter: filter),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var listTask = snapshot.data;
          if (listTask!.isNotEmpty) {
            var completedTask = listTask
                .where((element) => element.doneStatus == true)
                .toList();
            var taskListPinned =
                listTask.where((element) => element.pinned == true).toList();
            var taskListUnpinned =
                listTask.where((element) => element.pinned == false).toList();
            if (tdl.useCategorySort) {
              return StreamBuilder(
                stream: isarInstance.listCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var templistLabels = snapshot.data;
                    var listLabels = templistLabels!;
                    return DefaultTabController(
                      initialIndex: 0,
                      length: selectedLabels!.length + 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TabBar(
                            isScrollable: true,
                            tabs: [
                              const Tab(
                                child: Text("Uncategorized"),
                              ),
                              for (var e in selectedLabels) ...[
                                Tab(
                                  child: Text(listLabels
                                      .where((element) => element.id == e)
                                      .toList()
                                      .first
                                      .name!),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(
                              children: [
                                if (tdl.showCompletedTask) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (taskListPinned
                                            .where((element) =>
                                                element.labels!.isEmpty)
                                            .toList()
                                            .isNotEmpty) ...[
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                                "Pinned - ${taskListPinned.where((element) => element.labels!.isEmpty).toList().length}"),
                                          ),
                                          ListBuilder(
                                            itemCount: taskListPinned
                                                .where((element) =>
                                                    element.labels!.isEmpty)
                                                .toList()
                                                .length,
                                            itemBuilder: (context, index) {
                                              var task = taskListPinned
                                                  .where((element) =>
                                                      element.labels!.isEmpty)
                                                  .toList()[index];

                                              return ListViewCard(
                                                id: task.id!,
                                                taskTitle: task.title!,
                                                description: task.description!,
                                                doneStatus: task.doneStatus!,
                                                selectedPriority:
                                                    task.priority!,
                                                archive: task.archive!,
                                                trash: task.trash!,
                                                pinned: task.pinned!,
                                                subtext: task.doNotify ?? false
                                                    ? Text(
                                                        "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                                                    : const Text(""),
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                                "Others - ${taskListUnpinned.where((element) => element.labels!.isEmpty).toList().length}"),
                                          ),
                                        ],
                                        ListBuilder(
                                          itemCount: taskListUnpinned
                                              .where((element) =>
                                                  element.labels!.isEmpty)
                                              .toList()
                                              .length,
                                          itemBuilder: (context, index) {
                                            var task = taskListUnpinned
                                                .where((element) =>
                                                    element.labels!.isEmpty)
                                                .toList()[index];

                                            return ListViewCard(
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
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  for (var e in selectedLabels) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          if (taskListPinned
                                              .where((element) =>
                                                  element.labels!.contains(e))
                                              .toList()
                                              .isNotEmpty) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text(
                                                  "Pinned - ${taskListPinned.where((element) => element.labels!.contains(e)).toList().length}"),
                                            ),
                                            ListBuilder(
                                              itemCount: taskListPinned
                                                  .where((element) => element
                                                      .labels!
                                                      .contains(e))
                                                  .toList()
                                                  .length,
                                              itemBuilder: (context, index) {
                                                var task = taskListPinned
                                                    .where((element) => element
                                                        .labels!
                                                        .contains(e))
                                                    .toList()[index];

                                                return ListViewCard(
                                                  id: task.id!,
                                                  taskTitle: task.title!,
                                                  description:
                                                      task.description!,
                                                  doneStatus: task.doneStatus!,
                                                  selectedPriority:
                                                      task.priority!,
                                                  archive: task.archive!,
                                                  trash: task.trash!,
                                                  pinned: task.pinned!,
                                                  subtext: task.doNotify ??
                                                          false
                                                      ? Text(
                                                          "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                                                      : const Text(""),
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text(
                                                  "Others - ${taskListUnpinned.where((element) => element.labels!.contains(e)).toList().length}"),
                                            ),
                                          ],
                                          ListBuilder(
                                            itemCount: taskListUnpinned
                                                .where((element) =>
                                                    element.labels!.contains(e))
                                                .toList()
                                                .length,
                                            itemBuilder: (context, index) {
                                              var task = taskListUnpinned
                                                  .where((element) => element
                                                      .labels!
                                                      .contains(e))
                                                  .toList()[index];

                                              return ListViewCard(
                                                id: task.id!,
                                                taskTitle: task.title!,
                                                description: task.description!,
                                                doneStatus: task.doneStatus!,
                                                selectedPriority:
                                                    task.priority!,
                                                archive: task.archive!,
                                                trash: task.trash!,
                                                pinned: task.pinned!,
                                                subtext: task.doNotify ?? false
                                                    ? Text(
                                                        "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                                                    : const Text(""),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ] else ...[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (taskListPinned
                                            .where((element) =>
                                                element.labels!.isEmpty)
                                            .toList()
                                            .isNotEmpty) ...[
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                                "Pinned - ${taskListPinned.where((element) => element.labels!.isEmpty).toList().length}"),
                                          ),
                                          ListBuilder(
                                            itemCount: taskListPinned
                                                .where((element) =>
                                                    element.labels!.isEmpty)
                                                .toList()
                                                .length,
                                            itemBuilder: (context, index) {
                                              var task = taskListPinned
                                                  .where((element) =>
                                                      element.labels!.isEmpty)
                                                  .toList()[index];

                                              return ListViewCard(
                                                id: task.id!,
                                                taskTitle: task.title!,
                                                description: task.description!,
                                                doneStatus: task.doneStatus!,
                                                selectedPriority:
                                                    task.priority!,
                                                archive: task.archive!,
                                                trash: task.trash!,
                                                pinned: task.pinned!,
                                                subtext: task.doNotify ?? false
                                                    ? Text(
                                                        "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                                                    : const Text(""),
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                                "Others - ${taskListUnpinned.where((element) => element.labels!.isEmpty).toList().length}"),
                                          ),
                                        ],
                                        ListBuilder(
                                          itemCount: taskListUnpinned
                                              .where((element) =>
                                                  element.labels!.isEmpty)
                                              .toList()
                                              .length,
                                          itemBuilder: (context, index) {
                                            var task = taskListUnpinned
                                                .where((element) =>
                                                    element.labels!.isEmpty)
                                                .toList()[index];

                                            return ListViewCard(
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
                                            );
                                          },
                                        ),
                                        if (completedTask
                                            .where((element) =>
                                                element.labels!.isEmpty)
                                            .toList()
                                            .isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: ExpansionTile(
                                              title: Text(
                                                  "Completed - ${completedTask.where((element) => element.labels!.isEmpty).toList().length}"),
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: ListBuilder(
                                                    itemCount: completedTask
                                                        .where((element) =>
                                                            element.labels!
                                                                .isEmpty)
                                                        .toList()
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var task = completedTask
                                                          .where((element) =>
                                                              element.labels!
                                                                  .isEmpty)
                                                          .toList()[index];

                                                      return ListViewCard(
                                                        id: task.id!,
                                                        taskTitle: task.title!,
                                                        description:
                                                            task.description!,
                                                        doneStatus:
                                                            task.doneStatus!,
                                                        selectedPriority:
                                                            task.priority!,
                                                        archive: task.archive!,
                                                        trash: task.trash!,
                                                        pinned: task.pinned!,
                                                        subtext: task
                                                                    .doNotify ??
                                                                false
                                                            ? Text(
                                                                "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                                                            : const Text(""),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  for (var e in selectedLabels) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (taskListPinned
                                              .where((element) =>
                                                  element.labels!.contains(e))
                                              .toList()
                                              .isNotEmpty) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text(
                                                  "Pinned - ${taskListPinned.where((element) => element.labels!.contains(e)).toList().length}"),
                                            ),
                                            ListBuilder(
                                              itemCount: taskListPinned
                                                  .where((element) => element
                                                      .labels!
                                                      .contains(e))
                                                  .toList()
                                                  .length,
                                              itemBuilder: (context, index) {
                                                var task = taskListPinned
                                                    .where((element) => element
                                                        .labels!
                                                        .contains(e))
                                                    .toList()[index];

                                                return ListViewCard(
                                                  id: task.id!,
                                                  taskTitle: task.title!,
                                                  description:
                                                      task.description!,
                                                  doneStatus: task.doneStatus!,
                                                  selectedPriority:
                                                      task.priority!,
                                                  archive: task.archive!,
                                                  trash: task.trash!,
                                                  pinned: task.pinned!,
                                                  subtext: task.doNotify ??
                                                          false
                                                      ? Text(
                                                          "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                                                      : const Text(""),
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text(
                                                  "Others - ${taskListUnpinned.where((element) => element.labels!.contains(e)).toList().length}"),
                                            ),
                                          ],
                                          ListBuilder(
                                            itemCount: taskListUnpinned
                                                .where((element) =>
                                                    element.labels!.contains(e))
                                                .toList()
                                                .length,
                                            itemBuilder: (context, index) {
                                              var task = taskListUnpinned
                                                  .where((element) => element
                                                      .labels!
                                                      .contains(e))
                                                  .toList()[index];

                                              return ListViewCard(
                                                id: task.id!,
                                                taskTitle: task.title!,
                                                description: task.description!,
                                                doneStatus: task.doneStatus!,
                                                selectedPriority:
                                                    task.priority!,
                                                archive: task.archive!,
                                                trash: task.trash!,
                                                pinned: task.pinned!,
                                                subtext: task.doNotify ?? false
                                                    ? Text(
                                                        "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                                                    : const Text(""),
                                              );
                                            },
                                          ),
                                          if (completedTask
                                              .where((element) =>
                                                  element.labels!.contains(e))
                                              .toList()
                                              .isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16.0),
                                              child: ExpansionTile(
                                                title: Text(
                                                    "Completed - ${completedTask.where((element) => element.labels!.contains(e)).toList().length}"),
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 16.0),
                                                    child: ListBuilder(
                                                      itemCount: completedTask
                                                          .where((element) =>
                                                              element.labels!
                                                                  .contains(e))
                                                          .toList()
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var task = completedTask
                                                            .where((element) =>
                                                                element.labels!
                                                                    .contains(
                                                                        e))
                                                            .toList()[index];

                                                        return ListViewCard(
                                                          id: task.id!,
                                                          taskTitle:
                                                              task.title!,
                                                          description:
                                                              task.description!,
                                                          doneStatus:
                                                              task.doneStatus!,
                                                          selectedPriority:
                                                              task.priority!,
                                                          archive:
                                                              task.archive!,
                                                          trash: task.trash!,
                                                          pinned: task.pinned!,
                                                          subtext: task
                                                                      .doNotify ??
                                                                  false
                                                              ? Text(
                                                                  "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                                                              : const Text(""),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ]
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const Text("null");
                },
              );
            } else {
              if (tdl.showCompletedTask) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (taskListPinned.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Pinned - ${taskListPinned.length}"),
                      ),
                      ListBuilder(
                        itemCount: taskListPinned.length,
                        itemBuilder: (context, index) {
                          var task = taskListPinned[index];

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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Others - ${taskListUnpinned.length}"),
                      ),
                    ],
                    ListBuilder(
                      itemCount: taskListUnpinned.length,
                      itemBuilder: (context, index) {
                        var task = taskListUnpinned[index];

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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (taskListPinned.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Pinned - ${taskListPinned.length}"),
                      ),
                      ListBuilder(
                        itemCount: taskListPinned.length,
                        itemBuilder: (context, index) {
                          var task = taskListPinned[index];

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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Others - ${taskListUnpinned.length}"),
                      ),
                    ],
                    ListBuilder(
                      itemCount: taskListUnpinned
                          .where((element) => element.doneStatus == false)
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        var task = taskListUnpinned
                            .where((element) => element.doneStatus == false)
                            .toList()[index];

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
                    if (completedTask.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ExpansionTile(
                          title: Text("Completed - ${completedTask.length}"),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ListBuilder(
                                itemCount: completedTask.length,
                                itemBuilder: (context, index) {
                                  var task = completedTask[index];

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
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }
            }
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
                  content: const Text('Move to trash?'),
                  actions: [
                    TextButton(
                        child: const Text("Yes"),
                        onPressed: () {
                          Navigator.pop(context, true);
                          isarInstance.moveToTrash(taskid);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Moved to trash"),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  isarInstance.undoTrash(taskid);
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
                  content: const Text('Move to trash?'),
                  actions: [
                    TextButton(
                        child: const Text("Yes"),
                        onPressed: () {
                          Navigator.pop(context, true);
                          isarInstance.moveToTrash(taskid);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Moved to trash"),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  isarInstance.undoTrash(taskid);
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
                  content: const Text("Moved to trash"),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () => isarInstance.undoTrash(taskid),
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
                  content: const Text("Moved to trash"),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () => isarInstance.undoTrash(taskid),
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
      child: listItemView,
    );
  }
}
