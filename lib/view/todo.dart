import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';
import 'package:minttask/model/task_model.dart';

class TodoView extends ConsumerStatefulWidget {
  const TodoView({super.key, required this.todoIndex});
  final int todoIndex;

  @override
  ConsumerState<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends ConsumerState<TodoView> {
  late final TaskText task;

  @override
  void initState() {
    super.initState();
    setState(() {
      task = ref.watch(todoListProvider)[widget.todoIndex];
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
