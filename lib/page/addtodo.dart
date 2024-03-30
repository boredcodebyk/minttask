import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
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
