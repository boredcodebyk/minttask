import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controller/db.dart';
import '../controller/tasklist.dart';
import '../controller/todosettings.dart';
import '../model/customlist.dart';
import '../model/task.dart';

enum EditState { newTask, editTask }

class EditView extends ConsumerStatefulWidget {
  const EditView({super.key, required this.editState, this.taskID});

  final EditState editState;

  final int? taskID;

  @override
  ConsumerState<EditView> createState() => _EditViewState();
}

class _EditViewState extends ConsumerState<EditView> {
  Task task = Task();

  final TextEditingController _titleEditingController = TextEditingController();

  Future<void> updateTodos(sortbycol, filter) async {
    final dbHelper = DatabaseHelper.instance;
    final todolist = await dbHelper.getTodos(sortbycol, filter);
    final customlist = await dbHelper.getCustomList();

    ref.read(customListProvider.notifier).state = customlist
        .map(
          (e) => CustomList.fromJson(e),
        )
        .toList();

    ref.read(taskListProvider.notifier).state = todolist
        .map(
          (e) => Task.fromJson(e),
        )
        .toList();
  }

  void fetch() async {
    final dbHelper = DatabaseHelper.instance;
    Map<String, dynamic>? text = await dbHelper.getTextById(widget.taskID!);
    setState(() {
      task = Task.fromJson(text!);
      _titleEditingController.text = task.title ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.editState == EditState.editTask) {
      fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: widget.editState == EditState.newTask
                ? const Text("New")
                : const Text("Edit"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              child: Column(
                children: [
                  TextField(
                      controller: _titleEditingController,
                      autofocus: true,
                      decoration:
                          const InputDecoration.collapsed(hintText: "Title"))
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.editState == EditState.newTask) {
            if (_titleEditingController.text.trim().isNotEmpty) {
              final newTodo = {
                'title': _titleEditingController.text.trim(),
                'description': "",
                'is_done': 0,
                'date_created': DateTime.now().millisecondsSinceEpoch,
                'date_modified': DateTime.now().millisecondsSinceEpoch,
                "custom_list": <int>[]
              };
              final dbHelper = DatabaseHelper.instance;
              await dbHelper.insertTodo(newTodo);
              updateTodos(
                  ref.watch(filterProvider).name, ref.watch(sortProvider).name);
              if (mounted) {
                context.pop();
              }
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Title in empty"),
                behavior: SnackBarBehavior.floating,
              ));
            }
          } else {
            if (_titleEditingController.text.trim().isNotEmpty) {
              final dbHelper = DatabaseHelper.instance;
              await dbHelper.updateTodoTitle(
                  task.id!,
                  _titleEditingController.text.trim(),
                  DateTime.now().millisecondsSinceEpoch);
              updateTodos(
                  ref.watch(filterProvider).name, ref.watch(sortProvider).name);
              if (mounted) {
                context.pop();
              }
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Title in empty"),
                behavior: SnackBarBehavior.floating,
              ));
            }
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
