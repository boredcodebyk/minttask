import 'package:flutter/material.dart';

import '../models/db.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.todoId});
  final Future<int> todoId;
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();
  bool isDone = false;

  Future<void> _getdata(id) async {
    final dbHelper = DatabaseHelper.instance;
    Map<String, dynamic>? text = await dbHelper.getTextById(await id);
    if (text!.isNotEmpty) {
      setState(() {
        isDone = text['is_done'] == 1;
        _titleController.text = text['title'];
        _contentController.text = text['description'];
      });
    } else {
      setState(() {
        isDone = text['is_done'] == 1;
        _titleController.text = "";
        _contentController.text = "";
      });
    }
  }

  Future<void> _updateTodoTitle(int id, String title) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateTodoTitle(
        id, title, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _updateTodoDescription(int id, String desc) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateTodoDescription(
        id, desc, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _toggleTodoStatus(int id, int isDone) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateTodoStauts(
        id, isDone, DateTime.now().millisecondsSinceEpoch);
    await _getdata(id);
  }

  Future<void> _deleteTodo() async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteTodo(await widget.todoId);
  }

  @override
  void initState() {
    super.initState();
    _getdata(widget.todoId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_titleController.text.isEmpty) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(
              content: Text("Title cannot be blank"),
              behavior: SnackBarBehavior.floating,
            ));
          return false;
        }
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit"),
          actions: [
            IconButton(
              onPressed: () async {
                final result = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("You sure?"),
                    content: const Text("This action is irreversible."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
                if (!mounted) return;
                if (result ?? false) {
                  _deleteTodo();
                  Navigator.pop(context, true);
                }
              },
              icon: const Icon(Icons.delete_outline),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Checkbox(
                  value: isDone,
                  onChanged: (value) async =>
                      _toggleTodoStatus(await widget.todoId, value! ? 1 : 0),
                ),
                title: TextField(
                  controller: _titleController,
                  onChanged: (value) async =>
                      _updateTodoTitle(await widget.todoId, value),
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Title"),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    onChanged: (value) async =>
                        _updateTodoDescription(await widget.todoId, value),
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Description"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
