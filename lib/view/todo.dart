import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/controller/todotxt_parser.dart';
import 'package:minttask/model/dummy.dart';
import 'package:minttask/model/task_model.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key, required this.todoIndex});
  final int todoIndex;

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  late final TaskText task;

  @override
  void initState() {
    super.initState();
    setState(() {
      task = TaskParser().parser(textList[widget.todoIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: Text(task.text),
    );
  }
}
