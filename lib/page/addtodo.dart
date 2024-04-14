import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/todo_provider.dart';

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void loadFile() async {
    try {
      final todotxt = File(ref.read(filePathProvider.notifier).state);
      ref.read(todoContentProvider.notifier).state =
          await todotxt.readAsString();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    style: Theme.of(context).textTheme.headlineLarge,
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: InputBorder.none,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
