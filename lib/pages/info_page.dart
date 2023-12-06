import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minttask/model/db.dart';
import 'package:provider/provider.dart';

import '../model/db_model.dart';

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class InfoPage extends StatefulWidget {
  const InfoPage({super.key, required this.todoID});
  final int todoID;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool _isDone = false;
  String _title = "";
  Priority _selectedPriority = Priority.low;
  bool _hasReminder = false;
  DateTime _reminderValue = DateTime.now();
  DateTime _creationDate = DateTime.now();
  DateTime _modifiedDate = DateTime.now();
  void _getdata() async {
    final isarInstance = IsarHelper.instance;
    final updateTask = await isarInstance.getEachTaskData(id: widget.todoID);
    setState(() {
      _isDone = updateTask!.doneStatus!;
      _title = updateTask.title!;

      _selectedPriority = updateTask.priority ?? Priority.low;
      _reminderValue = updateTask.notifyTime!;
      _hasReminder = updateTask.doNotify ?? false;
      _creationDate = updateTask.dateCreated!;
      _modifiedDate = updateTask.dateModified!;
    });
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            _title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(_isDone ? "Done" : "Not Done"),
          Text("Priority: ${_selectedPriority.name.capitalize()}"),
          Text(_hasReminder
              ? "Reminder: ${DateFormat.yMMMMEEEEd().add_jms().format(_reminderValue).toString()}"
              : "No Reminder"),
          Text(
              "Date Modified: ${DateFormat.yMMMMEEEEd().add_jms().format(_modifiedDate).toString()}"),
          Text(
              "Date Created: ${DateFormat.yMMMMEEEEd().add_jms().format(_creationDate).toString()}"),
        ]),
      ),
    );
  }
}
