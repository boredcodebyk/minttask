import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/model/db_model.dart';

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

class AddTaskBox extends StatefulWidget {
  const AddTaskBox({super.key});

  @override
  State<AddTaskBox> createState() => _AddTaskBoxState();
}

class _AddTaskBoxState extends State<AddTaskBox> {
  final TextEditingController _titleController = TextEditingController();
  final FleatherController _fleatherController = FleatherController();
  final TextEditingController _selectedCategoryLabelName =
      TextEditingController();

  Map<int, bool> selectedCategoryLabel = {};

  List<int> selectedLabels = [];

  DateTime? reminderValue;
  bool hasReminder = false;

  void _launchUrl(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    final canLaunch = await canLaunchUrl(uri);
    if (canLaunch) {
      await launchUrl(uri);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fleatherController.dispose();
    _selectedCategoryLabelName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            child: TextField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Title"),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ActionChip(
                    avatar: Icon(
                        reminderValue == null ? Icons.alarm : Icons.alarm_on),
                    label: Text(reminderValue == null
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
                                      enabled:
                                          reminderValue != null ? true : false,
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
                          isDismissible: false,
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
                                    seedColor:
                                        const Color.fromARGB(1, 223, 217, 255))
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
      floatingActionButton: FloatingActionButton(
        heroTag: "",
        onPressed: () {
          if (_titleController.text != '') {
            Navigator.pop(context);
            print(jsonEncode(_fleatherController.document.toJson()));
            IsarHelper.instance.addTask(
              title: _titleController.text,
              description: jsonEncode(_fleatherController.document.toJson()),
              labels: selectedLabels,
              doNotify: hasReminder,
              notifyTime: reminderValue ?? DateTime.now(),
              selectedPriority: _selectedPriority,
            );
          } else {
            null;
          }
        },
        child: const Icon(Icons.done_rounded),
      ),
    );
  }
}
