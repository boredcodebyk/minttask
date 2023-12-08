import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/model/db.dart';

import 'package:minttask/utils/enum_utils.dart';
import 'package:provider/provider.dart';

import 'package:minttask/model/db_model.dart';
import 'package:minttask/model/settings_model.dart';

class ReorderListView extends StatefulWidget {
  const ReorderListView({super.key});
  @override
  State<ReorderListView> createState() => _ReorderListViewState();
}

class _ReorderListViewState extends State<ReorderListView> {
  Map<int, bool> catSortList = {};
  late List<TaskData> taskListPinned;
  late List<TaskData> taskListUnpinned;
  late List<TaskData> completedTask;
  late List<TaskData> incompletedTaskUnpinned;
  List<int> tempCatList = [];
  final isarInstance = IsarHelper.instance;
  FilterList _filter = FilterList.asc;

  @override
  Widget build(BuildContext context) {
    TodoListModel tdl = Provider.of<TodoListModel>(context);
    return Scaffold(
      backgroundColor: Color(
          CorePalette.of(Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
      appBar: AppBar(
        title: const Text("Reorder"),
        backgroundColor: Color(CorePalette.of(
                Theme.of(context).colorScheme.primary.value)
            .neutral
            .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
        actions: [
          IconButton(
              onPressed: () {
                if (_filter == FilterList.asc) {
                  setState(() {
                    _filter = FilterList.desc;
                  });
                } else {
                  setState(() {
                    _filter = FilterList.asc;
                  });
                }
              },
              icon: const Icon(Icons.sort_by_alpha))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream:
                  isarInstance.listTasks(sort: SortList.id, filter: _filter),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var listTask = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 0,
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        child: ReorderableListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          physics: const NeverScrollableScrollPhysics(),
                          onReorder: (int oldIndex, int newIndex) {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            isarInstance.reorderTasks(
                              listTask[oldIndex].orderID!,
                              listTask[newIndex].orderID!,
                            );
                          },
                          itemCount: listTask!.length,
                          itemBuilder: (context, index) {
                            var task = listTask[index];
                            return Padding(
                              key: UniqueKey(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 1),
                              child: ListTile(
                                subtitle: tdl.detailedView
                                    ? task.doNotify ?? false
                                        ? Text(
                                            "Due on ${DateFormat("hh:mm EEE, M/d/y").format(task.notifyTime!)} ")
                                        : const Text("")
                                    : null,
                                tileColor: Color(CorePalette.of(
                                        Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .value)
                                    .neutral
                                    .get(Theme.of(context).brightness ==
                                            Brightness.light
                                        ? 98
                                        : 17)),
                                title: Text(
                                  task.title!,
                                  style: TextStyle(
                                      decoration: task.doneStatus!
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                trailing: Icon(Icons.circle,
                                    color: task.priority! == Priority.low
                                        ? ColorScheme.fromSeed(
                                                seedColor: const Color.fromARGB(
                                                    1, 223, 217, 255))
                                            .primary
                                        : task.priority! == Priority.moderate
                                            ? ColorScheme.fromSeed(
                                                    seedColor:
                                                        const Color.fromARGB(
                                                            1, 223, 217, 255))
                                                .tertiary
                                            : ColorScheme.fromSeed(
                                                    seedColor:
                                                        const Color.fromARGB(
                                                            1, 223, 217, 255))
                                                .error),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Empty"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
