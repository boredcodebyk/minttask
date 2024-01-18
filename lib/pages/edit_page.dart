import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fleather/fleather.dart';
import 'package:intl/intl.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/model/db_model.dart';
import 'package:minttask/model/settings_model.dart';
import 'package:minttask/pages/ui/labeleditor_ui.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import '../utils/utils.dart';

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
  final TextEditingController _subListTitleController = TextEditingController();

  List<int> selectedLabels = [];
  bool archive = false;
  bool trash = false;
  bool pinned = false;
  bool doneStatus = false;
  bool hasReminder = false;
  Priority selectedPriority = Priority.low;
  DateTime reminderValue = DateTime.now();
  DateTime datemodified = DateTime.now();
  List<SubList> subList = [];
  bool readMode = false;
  bool sublistreorder = false;
  bool subListAddMode = false;

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
      datemodified = updateTask.dateModified!;
      for (var element in updateTask.subList!) {
        subList.add(element);
      }
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
    _subListTitleController.dispose();
    _fleatherController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel settingsModel = Provider.of<SettingsModel>(context);
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
          isarInstance.markTaskDone(widget.todoId, doneStatus);
          isarInstance.pinToggle(widget.todoId, pinned);
          isarInstance.updateSubList(id: widget.todoId, subList: subList);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: pinned
                  ? const Icon(Icons.push_pin)
                  : const Icon(Icons.push_pin_outlined),
              onPressed: trash
                  ? null
                  : () {
                      setState(() {
                        if (pinned) {
                          pinned = false;
                        } else {
                          pinned = true;
                        }
                      });
                    },
            ),
            IconButton(
              onPressed: archive
                  ? () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text('Unarchive?'),
                          actions: [
                            TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    archive = false;
                                  });
                                  IsarHelper.instance
                                      .undoArchive(widget.todoId);
                                }),
                            TextButton(
                                child: const Text("No"),
                                onPressed: () => Navigator.of(context).pop()),
                          ],
                        ),
                      );
                    }
                  : () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text('Archive?'),
                          actions: [
                            TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    archive = true;
                                  });
                                  IsarHelper.instance
                                      .moveToArchive(widget.todoId);
                                }),
                            TextButton(
                              child: const Text("No"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    },
              icon: archive
                  ? const Icon(Icons.unarchive_outlined)
                  : const Icon(Icons.archive_outlined),
            ),
            IconButton(
              onPressed: trash
                  ? () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text('Restore?'),
                          actions: [
                            TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    trash = false;
                                  });
                                  IsarHelper.instance.undoTrash(widget.todoId);
                                }),
                            TextButton(
                              child: const Text("No"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    }
                  : () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text('Move to trash?'),
                          actions: [
                            TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    trash = true;
                                  });
                                  IsarHelper.instance
                                      .moveToTrash(widget.todoId);
                                  Navigator.of(context).pop();
                                }),
                            TextButton(
                                child: const Text("No"),
                                onPressed: () => Navigator.of(context).pop()),
                          ],
                        ),
                      );
                    },
              icon: trash
                  ? const Icon(Icons.restore_from_trash_outlined)
                  : const Icon(Icons.delete_outline),
            )
          ],
        ),
        body: Column(
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              leading: settingsModel.checkBoxPosition == CheckboxPosition.left
                  ? Checkbox(
                      value: doneStatus,
                      onChanged: trash
                          ? null
                          : (value) async {
                              setState(() {
                                doneStatus = value ?? false;
                              });
                            },
                    )
                  : null,
              trailing: settingsModel.checkBoxPosition == CheckboxPosition.right
                  ? Checkbox(
                      value: doneStatus,
                      onChanged: trash
                          ? null
                          : (value) async {
                              setState(() {
                                doneStatus = value ?? false;
                              });
                            },
                    )
                  : null,
              title: TextField(
                readOnly: trash ? true : readMode,
                controller: _titleController,
                onChanged: (value) {
                  setState(() {
                    _titleController.value = TextEditingValue(text: value);
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: "Title",
                  errorText: _titleController.text.isEmpty
                      ? "Title can't be empty"
                      : null,
                ),
              ),
            ),
            ExpansionTile(
              initiallyExpanded: false,
              title: Text("Sub List - ${subList.length}"),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subList.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FilterChip(
                      label: const Text("Reorder"),
                      selected: sublistreorder,
                      onSelected: (val) => setState(() {
                        sublistreorder = val;
                      }),
                    ),
                  ),
                  sublistreorder
                      ? ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          buildDefaultDragHandles: true,
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final item = subList.removeAt(oldIndex);
                              subList.insert(newIndex, item);
                            });
                          },
                          itemCount: subList.length,
                          itemBuilder: (context, index) {
                            var eachListItem = subList[index];

                            return ListTile(
                              key: UniqueKey(),
                              leading: Checkbox(
                                value: eachListItem.subListDoneStatus,
                                onChanged: (val) {
                                  setState(() {
                                    eachListItem.subListDoneStatus = val!;
                                  });
                                },
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              title: Text(eachListItem.subListtitle!),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.circle,
                                    color: eachListItem.subListpriority ==
                                            Priority.low
                                        ? ColorScheme.fromSeed(
                                                seedColor: const Color.fromARGB(
                                                    1, 223, 217, 255))
                                            .primary
                                        : eachListItem.subListpriority ==
                                                Priority.moderate
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
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subList.length,
                          itemBuilder: (context, index) {
                            var eachListItem = subList[index];

                            return ListTile(
                              key: UniqueKey(),
                              leading: Checkbox(
                                value: eachListItem.subListDoneStatus,
                                onChanged: (val) {
                                  setState(() {
                                    eachListItem.subListDoneStatus = val!;
                                  });
                                },
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              title: TextFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none, isDense: true),
                                initialValue: eachListItem.subListtitle,
                                onChanged: (val) {
                                  setState(() {
                                    eachListItem.subListtitle = val;
                                  });
                                },
                              ),
                              trailing: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    icon: Icon(Icons.circle,
                                        color: eachListItem.subListpriority ==
                                                Priority.low
                                            ? ColorScheme.fromSeed(
                                                    seedColor:
                                                        const Color.fromARGB(
                                                            1, 223, 217, 255))
                                                .primary
                                            : eachListItem.subListpriority ==
                                                    Priority.moderate
                                                ? ColorScheme.fromSeed(
                                                        seedColor:
                                                            const Color.fromARGB(
                                                                1, 223, 217, 255))
                                                    .tertiary
                                                : ColorScheme.fromSeed(
                                                        seedColor:
                                                            const Color.fromARGB(
                                                                1,
                                                                223,
                                                                217,
                                                                255))
                                                    .error),
                                    onPressed: trash
                                        ? null
                                        : () => showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(24),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Priority",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge,
                                                      ),
                                                      ListView(
                                                        shrinkWrap: true,
                                                        children: [
                                                          RadioListTile(
                                                            value: Priority.low,
                                                            groupValue: eachListItem
                                                                .subListpriority,
                                                            title: const Text(
                                                                "Low"),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                eachListItem
                                                                        .subListpriority =
                                                                    value!;
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          RadioListTile(
                                                            value: Priority
                                                                .moderate,
                                                            groupValue: eachListItem
                                                                .subListpriority,
                                                            title: const Text(
                                                                "Moderate"),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                eachListItem
                                                                        .subListpriority =
                                                                    value!;
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          RadioListTile(
                                                            value:
                                                                Priority.high,
                                                            groupValue: eachListItem
                                                                .subListpriority,
                                                            title: const Text(
                                                                "High"),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                eachListItem
                                                                        .subListpriority =
                                                                    value!;
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                  )),
                            );
                          },
                        )
                ] else
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Sub list empty"),
                  ),
                ListTile(
                  leading: subListAddMode
                      ? IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              subListAddMode = false;
                            });
                          },
                          icon: const Icon(Icons.arrow_back_rounded))
                      : const Icon(Icons.add),
                  title: subListAddMode
                      ? TextField(
                          autofocus: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none, isDense: true),
                          controller: _subListTitleController,
                          onSubmitted: (val) {
                            setState(() {
                              subList.add(SubList(
                                  subListDoneStatus: false,
                                  subListtitle: val,
                                  subListContent: r"""[{"insert":"\n"}]""",
                                  subListpriority: Priority.low));
                              _subListTitleController.clear();
                            });
                          },
                        )
                      : const Text("Add"),
                  onTap: subListAddMode
                      ? null
                      : () {
                          setState(() {
                            subListAddMode = true;
                          });
                        },
                  trailing: subListAddMode
                      ? IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              subList.add(SubList(
                                  subListDoneStatus: false,
                                  subListtitle: _subListTitleController.text,
                                  subListContent: r"""[{"insert":"\n"}]""",
                                  subListpriority: Priority.low));
                              _subListTitleController.clear();
                            });
                          },
                        )
                      : null,
                )
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ActionChip(
                      avatar: Icon(hasReminder ? Icons.alarm_on : Icons.alarm),
                      label: Text(hasReminder
                          ? DateFormat("E d, h:mm a").format(reminderValue)
                          : "No reminder"),
                      onPressed: trash
                          ? null
                          : () => showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                trailing: Text(
                                                    DateTime.now().hour > 7
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
                                                  setState(() {
                                                    hasReminder = true;
                                                    reminderValue =
                                                        DateTime.now().hour > 7
                                                            ? DateTime(
                                                                today.year,
                                                                today.month,
                                                                today.day,
                                                                18,
                                                                0,
                                                                0,
                                                                0,
                                                                0)
                                                            : DateTime(
                                                                today.year,
                                                                today.month,
                                                                today.day,
                                                                8,
                                                                0,
                                                                0,
                                                                0,
                                                                0);
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
                                                      .add(const Duration(
                                                          days: 1));
                                                  IsarHelper.instance
                                                      .updateReminder(
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
                                                  setState(() {
                                                    hasReminder = true;
                                                    reminderValue = DateTime(
                                                        tomorrow.year,
                                                        tomorrow.month,
                                                        tomorrow.day,
                                                        8,
                                                        0,
                                                        0,
                                                        0,
                                                        0);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.watch_later_outlined),
                                                title: Text(DateFormat.EEEE()
                                                    .format(DateTime.now().add(
                                                        const Duration(
                                                            days: 2)))),
                                                trailing: const Text("8:00 AM"),
                                                onTap: () {
                                                  var dayAfterTomorrow =
                                                      DateTime.now().add(
                                                          const Duration(
                                                              days: 2));
                                                  IsarHelper.instance
                                                      .updateReminder(
                                                          widget.todoId,
                                                          true,
                                                          DateTime(
                                                              dayAfterTomorrow
                                                                  .year,
                                                              dayAfterTomorrow
                                                                  .month,
                                                              dayAfterTomorrow
                                                                  .day,
                                                              8,
                                                              0,
                                                              0,
                                                              0,
                                                              0));
                                                  setState(() {
                                                    hasReminder = true;
                                                    reminderValue = DateTime(
                                                        dayAfterTomorrow.year,
                                                        dayAfterTomorrow.month,
                                                        dayAfterTomorrow.day,
                                                        8,
                                                        0,
                                                        0,
                                                        0,
                                                        0);
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
                                                  IsarHelper.instance
                                                      .updateReminder(
                                                          widget.todoId,
                                                          true,
                                                          remindtime!);
                                                  setState(() {
                                                    hasReminder = true;
                                                    reminderValue = remindtime;
                                                  });
                                                  if (context.mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.clear),
                                                title: const Text("Clear"),
                                                onTap: () {
                                                  IsarHelper.instance
                                                      .updateReminder(
                                                          widget.todoId,
                                                          false,
                                                          DateTime.now());
                                                  setState(() {
                                                    hasReminder = false;
                                                  });
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
                      onPressed: trash
                          ? null
                          : () async {
                              final result = await showModalBottomSheet(
                                  showDragHandle: true,
                                  context: context,
                                  builder: (context) => LabelEditor(
                                        selectedValue: selectedLabels,
                                        mode: CategorySelectMode.modify,
                                      ));
                              if (!mounted) return;
                              setState(() {
                                selectedLabels = result ?? [];
                              });
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
                      onPressed: trash
                          ? null
                          : () => showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Priority",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
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
                                                IsarHelper.instance
                                                    .updatePriority(
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
                                                IsarHelper.instance
                                                    .updatePriority(
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
                                                IsarHelper.instance
                                                    .updatePriority(
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
                  FleatherToolbar.basic(
                    controller: _fleatherController,
                    hideListBullets: true,
                    hideListChecks: true,
                    hideListNumbers: true,
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                  Expanded(
                    child: FleatherEditor(
                      readOnly: trash ? true : readMode,
                      controller: _fleatherController,
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
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
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Last edited: ${DateFormat('d MMM').format(datemodified)}")
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(Icons.done),
        ),
      ),
    );
  }
}
