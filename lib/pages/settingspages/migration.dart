import 'package:flutter/material.dart';
import 'package:minttask/model/db.old.dart';

class MigrationWidget extends StatefulWidget {
  const MigrationWidget({super.key});

  @override
  State<MigrationWidget> createState() => _MigrationWidgetState();
}

class _MigrationWidgetState extends State<MigrationWidget> {
  List<Map<String, dynamic>> _todoList = [];
  Map<String, String> filter_col = {"sortby": "", "filter": ""};
  Future<void> _listTodos(col, filter) async {
    final dbHelper = DatabaseHelper.instance;
    final todolist = await dbHelper.getTodos(col, filter);

    setState(() {
      _todoList = todolist;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      filter_col["sortby"] = "id";
      filter_col["filter"] = "asc";
    });

    _listTodos(filter_col["sortby"], filter_col["filter"]);
  }

  @override
  Widget build(BuildContext context) {
    print(_todoList);
    return Scaffold(
      body: Column(
        children: [
          const Text("Migrating data from old SQFlite database to Isar"),
          for (var e in _todoList) ...[
            Text(e.toString()),
          ]
        ],
      ),
    );
  }
}
