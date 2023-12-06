import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fleather/fleather.dart';
import 'package:intl/intl.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/model/db_model.dart';
import 'package:minttask/pages/ui/labeleditor_ui.dart';
import 'package:provider/provider.dart';

import 'package:flutter/scheduler.dart' as scd;
import 'package:url_launcher/url_launcher.dart';

import '../utils/utils.dart';
import 'ui/category_ui.dart';

Priority _selectedPriority = Priority.low;

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class EditPage extends StatefulWidget {
  const EditPage({
    super.key,
    required this.todoId,
  });
  final int todoId;
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _titleController = TextEditingController();
  FleatherController _fleatherController = FleatherController();
  List<int> selectedLabels = [];
  bool archive = false;
  bool trash = false;
  bool pinned = false;
  bool doneStatus = false;
  bool hasReminder = false;
  Priority selectedPriority = Priority.low;
  DateTime reminderValue = DateTime.now();

  void _getdata() async {
    final isarInstance = IsarHelper.instance;
    var updateTask = await isarInstance.getEachTaskData(id: widget.todoId);
    _titleController.text = updateTask!.title ?? "";
    _fleatherController = FleatherController(ParchmentDocument.fromJson(
        jsonDecode(updateTask.description ?? r"""[{"insert":"\n"}]""")));
    setState(() {
      archive = updateTask.archive!;
      trash = updateTask.trash!;
      pinned = updateTask.pinned!;
      doneStatus = updateTask.doneStatus!;
      hasReminder = updateTask.doNotify!;
      selectedPriority = updateTask.priority!;
      selectedLabels = updateTask.labels!;
      reminderValue = updateTask.notifyTime!;
    });
  }

  void _launchUrl(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    final canLaunch = await canLaunchUrl(uri);
    if (canLaunch) {
      await launchUrl(uri);
    }
  }
/*
  void saveTask(TaskListProvider taskListProvider) {
    List<int> tempCatList = [];
    tempSelection.forEach((key, value) {
      if (value) {
        tempCatList.add(key);
      }
    });
    print(tempSelection);
    print(tempCatList);
    taskListProvider.updateTodoTitle(widget.todoId, _titleController.text);
    taskListProvider.updateTodoDescription(widget.todoId,
        jsonEncode(_quillController.document.toDelta().toJson()));
    taskListProvider.markTaskDone(widget.todoId, isDone);
    taskListProvider.updatePriority(widget.todoId, _selectedPriority);
    taskListProvider.updateCategoryInTask(
        widget.todoId,
        taskListProvider.editLabelSelection.entries
            .where((element) => element.value)
            .map((e) => e.key)
            .toList());
    taskListProvider.updateReminder(widget.todoId, hasReminder, reminderValue);
    taskListProvider.editLabelSelection.forEach((key, value) {
      taskListProvider.editLabelSelection[key] = false;
    });
  }*/

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _fleatherController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          final isarInstance = IsarHelper.instance;
          isarInstance.updateDescription(
              id: widget.todoId,
              description: jsonEncode(_fleatherController.document.toJson()));
          isarInstance.updateTitle(
              id: widget.todoId, title: _titleController.text);
          isarInstance.updateLabels(id: widget.todoId, labels: selectedLabels);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Edit"),
          actions: [
            if (archive)
              IconButton(
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Move to archive'),
                      content: const Text('Are you sure to move to archive?'),
                      actions: [
                        TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              Navigator.pop(context, true);
                            }),
                        TextButton(
                            child: const Text("No"),
                            onPressed: () => Navigator.pop(context, false)),
                      ],
                    ),
                  );
                  if (!mounted) return;
                  if (result ?? false) {
                    Navigator.of(context).pop();
                    IsarHelper.instance.moveToArchive(widget.todoId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Moved to trash"),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            IsarHelper.instance.undoArchive(widget.todoId);
                          },
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.archive_outlined),
              )
            else
              IconButton(
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Unarchive'),
                      content: const Text('Are you sure to unarchive?'),
                      actions: [
                        TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              Navigator.pop(context, true);
                            }),
                        TextButton(
                            child: const Text("No"),
                            onPressed: () => Navigator.pop(context, false)),
                      ],
                    ),
                  );
                  if (!mounted) return;
                  if (result ?? false) {
                    Navigator.of(context).pop();
                    IsarHelper.instance.undoArchive(widget.todoId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Restored"),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            IsarHelper.instance.moveToArchive(widget.todoId);
                          },
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.unarchive_outlined),
              ),
            if (trash)
              IconButton(
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Move to trash'),
                      content: const Text('Are you sure to move to trash?'),
                      actions: [
                        TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              Navigator.pop(context, true);
                            }),
                        TextButton(
                            child: const Text("No"),
                            onPressed: () => Navigator.pop(context, false)),
                      ],
                    ),
                  );
                  if (!mounted) return;
                  if (result ?? false) {
                    Navigator.of(context).pop();
                    IsarHelper.instance.moveToTrash(widget.todoId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Moved to trash"),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            IsarHelper.instance.undoTrash(widget.todoId);
                          },
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete_outline),
              )
            else
              IconButton(
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Restore'),
                      content: const Text('Are you sure to restore?'),
                      actions: [
                        TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              Navigator.pop(context, true);
                            }),
                        TextButton(
                            child: const Text("No"),
                            onPressed: () => Navigator.pop(context, false)),
                      ],
                    ),
                  );
                  if (!mounted) return;
                  if (result ?? false) {
                    Navigator.of(context).pop();
                    IsarHelper.instance.undoTrash(widget.todoId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Restored"),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            IsarHelper.instance.moveToTrash(widget.todoId);
                          },
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.restore_from_trash_outlined),
              )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                trailing: Checkbox(
                  value: doneStatus,
                  onChanged: (value) async {
                    IsarHelper.instance
                        .markTaskDone(widget.todoId, value ?? false);
                  },
                ),
                title: TextField(
                  controller: _titleController,
                  onChanged: (value) {
                    setState(() {
                      _titleController.value = TextEditingValue(text: value);
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title",
                    errorText: _titleController.text.isEmpty
                        ? "Title can't be empty"
                        : null,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ActionChip(
                      avatar: Icon(hasReminder ? Icons.alarm : Icons.alarm_on),
                      label: Text(hasReminder
                          ? "No reminder"
                          : DateFormat("E d, h:mm a").format(reminderValue)),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: ListView(
                                    shrinkWrap: true,
                                    clipBehavior: Clip.antiAlias,
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                            Icons.watch_later_outlined),
                                        title: Text(
                                            "Today ${DateTime.now().hour > 7 ? "evening" : "morning"}"),
                                        trailing: Text(DateTime.now().hour > 7
                                            ? "6:00 PM"
                                            : "8:00 AM"),
                                        onTap: () {
                                          var today = DateTime.now();

                                          DateTime.now().hour > 7
                                              ? IsarHelper.instance
                                                  .updateReminder(
                                                      widget.todoId,
                                                      true,
                                                      DateTime(
                                                          today.year,
                                                          today.month,
                                                          today.day,
                                                          18,
                                                          0,
                                                          0,
                                                          0,
                                                          0))
                                              : IsarHelper.instance
                                                  .updateReminder(
                                                      widget.todoId,
                                                      true,
                                                      DateTime(
                                                          today.year,
                                                          today.month,
                                                          today.day,
                                                          8,
                                                          0,
                                                          0,
                                                          0,
                                                          0));

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.watch_later_outlined),
                                        title: const Text("Tomorrow"),
                                        trailing: const Text("8:00 AM"),
                                        onTap: () {
                                          var tomorrow = DateTime.now()
                                              .add(const Duration(days: 1));
                                          IsarHelper.instance.updateReminder(
                                            widget.todoId,
                                            true,
                                            DateTime(
                                                tomorrow.year,
                                                tomorrow.month,
                                                tomorrow.day,
                                                8,
                                                0,
                                                0,
                                                0,
                                                0),
                                          );

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.watch_later_outlined),
                                        title: Text(DateFormat.EEEE().format(
                                            DateTime.now()
                                                .add(const Duration(days: 2)))),
                                        trailing: const Text("8:00 AM"),
                                        onTap: () {
                                          var dayAfterTomorrow = DateTime.now()
                                              .add(const Duration(days: 2));
                                          IsarHelper.instance.updateReminder(
                                              widget.todoId,
                                              true,
                                              DateTime(
                                                  dayAfterTomorrow.year,
                                                  dayAfterTomorrow.month,
                                                  dayAfterTomorrow.day,
                                                  8,
                                                  0,
                                                  0,
                                                  0,
                                                  0));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.watch_later_outlined),
                                        title: const Text("Custom"),
                                        onTap: () async {
                                          var remindtime =
                                              await showDateTimePicker(
                                                  context: context);
                                          IsarHelper.instance.updateReminder(
                                              widget.todoId, true, remindtime);

                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.clear),
                                        title: const Text("Clear"),
                                        onTap: () {
                                          IsarHelper.instance.updateReminder(
                                              widget.todoId,
                                              false,
                                              DateTime.now());

                                          Navigator.of(context).pop();
                                        },
                                        enabled: hasReminder,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ActionChip(
                      avatar: selectedLabels.isEmpty
                          ? const Icon(Icons.label_outline)
                          : const Icon(Icons.label),
                      label: const Text("Labels"),
                      onPressed: () async {
                        final result = await showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                LabelEditor(selectedValue: selectedLabels));
                        if (!mounted) return;
                        setState(() {
                          selectedLabels = result ?? [];
                        });
                        print(result);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ActionChip(
                      avatar: Icon(Icons.circle,
                          color: _selectedPriority == Priority.low
                              ? ColorScheme.fromSeed(
                                      seedColor: const Color.fromARGB(
                                          1, 223, 217, 255))
                                  .primary
                              : _selectedPriority == Priority.moderate
                                  ? ColorScheme.fromSeed(
                                          seedColor: const Color.fromARGB(
                                              1, 223, 217, 255))
                                      .tertiary
                                  : ColorScheme.fromSeed(
                                          seedColor: const Color.fromARGB(
                                              1, 223, 217, 255))
                                      .error),
                      label: Text(
                          "Priority: ${_selectedPriority.name.toString().capitalize()}"),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Priority",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                ListView(
                                  shrinkWrap: true,
                                  children: [
                                    RadioListTile(
                                      value: Priority.low,
                                      groupValue: _selectedPriority,
                                      title: const Text("Low"),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedPriority = value!;
                                        });
                                        IsarHelper.instance.updatePriority(
                                            widget.todoId, value!);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    RadioListTile(
                                      value: Priority.moderate,
                                      groupValue: _selectedPriority,
                                      title: const Text("Moderate"),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedPriority = value!;
                                        });
                                        IsarHelper.instance.updatePriority(
                                            widget.todoId, value!);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    RadioListTile(
                                      value: Priority.high,
                                      groupValue: _selectedPriority,
                                      title: const Text("High"),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedPriority = value!;
                                        });
                                        IsarHelper.instance.updatePriority(
                                            widget.todoId, value!);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  FleatherToolbar.basic(controller: _fleatherController),
                  Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                  Expanded(
                    child: FleatherEditor(
                      controller: _fleatherController,
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                      onLaunchUrl: _launchUrl,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  /*
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: popPage,
      onPopInvoked: (bool didPop) async {
        if (_titleController.text.isEmpty) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(
              content: Text("Title cannot be blank"),
              behavior: SnackBarBehavior.floating,
            ));
          setState(() {
            popPage = false;
          });
        } else {
          setState(() {
            popPage = true;
          });
          print("object");
          saveTask(taskListProvider);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Edit"),
          actions: [
            if (!isTrash)
              IconButton(
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Move to trash'),
                      content: const Text('Are you sure to move to trash?'),
                      actions: [
                        TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              Navigator.pop(context, true);
                            }),
                        TextButton(
                            child: const Text("No"),
                            onPressed: () => Navigator.pop(context, false)),
                      ],
                    ),
                  );
                  if (!mounted) return;
                  if (result) {
                    taskListProvider.moveToTrash(widget.todoId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Moved to trash"),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            taskListProvider.undoTrash(widget.todoId);
                          },
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.delete_outline),
              )
            else
              IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Restore'),
                      content: const Text('Are you sure to restore?'),
                      actions: [
                        TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              taskListProvider.undoTrash(widget.todoId);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Restored"),
                                  behavior: SnackBarBehavior.floating,
                                  action: SnackBarAction(
                                    label: "Undo",
                                    onPressed: () {
                                      taskListProvider
                                          .moveToTrash(widget.todoId);
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
                icon: const Icon(Icons.restore_from_trash_outlined),
              )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                trailing: Checkbox(
                  value: isDone,
                  onChanged: (value) async {
                    setState(() {
                      isDone = value!;
                    });
                    taskListProvider.markTaskDone(widget.todoId, isDone);
                  },
                ),
                title: TextField(
                  controller: _titleController,
                  onChanged: (value) {
                    setState(() {
                      _titleController.value = TextEditingValue(text: value);
                    });
                    taskListProvider.updateTodoTitle(
                        widget.todoId, _titleController.text);
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Title"),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ActionChip(
                      avatar: Icon(reminderValue == null || !hasReminder!
                          ? Icons.alarm
                          : Icons.alarm_on),
                      label: Text(reminderValue == null || !hasReminder!
                          ? "No reminder"
                          : DateFormat("E d, h:mm a").format(reminderValue!)),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: ListView(
                                    shrinkWrap: true,
                                    clipBehavior: Clip.antiAlias,
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                            Icons.watch_later_outlined),
                                        title: Text(
                                            "Today ${DateTime.now().hour > 7 ? "evening" : "morning"}"),
                                        trailing: Text(DateTime.now().hour > 7
                                            ? "6:00 PM"
                                            : "8:00 AM"),
                                        onTap: () {
                                          var today = DateTime.now();
                                          setState(() {
                                            DateTime.now().hour > 7
                                                ? reminderValue = DateTime(
                                                    today.year,
                                                    today.month,
                                                    today.day,
                                                    18,
                                                    0,
                                                    0,
                                                    0,
                                                    0)
                                                : reminderValue = DateTime(
                                                    today.year,
                                                    today.month,
                                                    today.day,
                                                    8,
                                                    0,
                                                    0,
                                                    0,
                                                    0);
                                            hasReminder = true;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.watch_later_outlined),
                                        title: const Text("Tomorrow"),
                                        trailing: const Text("8:00 AM"),
                                        onTap: () {
                                          var tomorrow = DateTime.now()
                                              .add(const Duration(days: 1));
                                          setState(() {
                                            reminderValue = DateTime(
                                                tomorrow.year,
                                                tomorrow.month,
                                                tomorrow.day,
                                                8,
                                                0,
                                                0,
                                                0,
                                                0);
                                            hasReminder = true;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.watch_later_outlined),
                                        title: Text(DateFormat.EEEE().format(
                                            DateTime.now()
                                                .add(const Duration(days: 2)))),
                                        trailing: const Text("8:00 AM"),
                                        onTap: () {
                                          var dayAfterTomorrow = DateTime.now()
                                              .add(const Duration(days: 2));
                                          setState(() {
                                            reminderValue = DateTime(
                                                dayAfterTomorrow.year,
                                                dayAfterTomorrow.month,
                                                dayAfterTomorrow.day,
                                                8,
                                                0,
                                                0,
                                                0,
                                                0);
                                            hasReminder = true;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.watch_later_outlined),
                                        title: const Text("Custom"),
                                        onTap: () async {
                                          var remindtime =
                                              await showDateTimePicker(
                                                  context: context);
                                          setState(() {
                                            reminderValue = remindtime;
                                            hasReminder = true;
                                          });
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.clear),
                                        title: const Text("Clear"),
                                        onTap: () {
                                          if (reminderValue != null) {
                                            setState(() {
                                              reminderValue = null;
                                              hasReminder = false;
                                            });
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        enabled: reminderValue != null
                                            ? true
                                            : false,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ActionChip(
                      avatar: selectedCategoryLabel.isEmpty
                          ? const Icon(Icons.label_outline)
                          : const Icon(Icons.label),
                      label: const Text("Labels"),
                      onPressed: () async {
                        await showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          enableDrag: false,
                          isDismissible: false,
                          context: context,
                          builder: (context) => const CategoryListUI(
                            mode: CategorySelectMode.modify,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ActionChip(
                      avatar: Icon(Icons.circle,
                          color: _selectedPriority == Priority.low
                              ? ColorScheme.fromSeed(
                                      seedColor: const Color.fromARGB(
                                          1, 223, 217, 255))
                                  .primary
                              : _selectedPriority == Priority.moderate
                                  ? ColorScheme.fromSeed(
                                          seedColor: const Color.fromARGB(
                                              1, 223, 217, 255))
                                      .tertiary
                                  : ColorScheme.fromSeed(
                                          seedColor: const Color.fromARGB(
                                              1, 223, 217, 255))
                                      .error),
                      label: Text(
                          "Priority: ${_selectedPriority.name.toString().capitalize()}"),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Priority",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                ListView(
                                  shrinkWrap: true,
                                  children: [
                                    RadioListTile(
                                      value: Priority.low,
                                      groupValue: _selectedPriority,
                                      title: const Text("Low"),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedPriority = value!;
                                        });
                                        taskListProvider.updatePriority(
                                            widget.todoId, value!);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    RadioListTile(
                                      value: Priority.moderate,
                                      groupValue: _selectedPriority,
                                      title: const Text("Moderate"),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedPriority = value!;
                                        });
                                        taskListProvider.updatePriority(
                                            widget.todoId, value!);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    RadioListTile(
                                      value: Priority.high,
                                      groupValue: _selectedPriority,
                                      title: const Text("High"),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedPriority = value!;
                                        });
                                        taskListProvider.updatePriority(
                                            widget.todoId, value!);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: QuillProvider(
                configurations: QuillConfigurations(
                  controller: _quillController,
                ),
                child: Column(
                  children: [
                    const QuillToolbar(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: QuillEditor.basic(
                          configurations: const QuillEditorConfigurations(
                            readOnly: false,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  */
}
