import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/todo_provider.dart';
import 'package:minttask/model/todotxt_parser.dart';

class EditPage extends ConsumerStatefulWidget {
  const EditPage({super.key, required this.index});

  final int index;
  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  TextEditingController _titleController = TextEditingController();
  final TodoTXTPraser _praser = TodoTXTPraser();
  String activeTodo = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadTodo();
  }

  void loadTodo() {
    setState(() {
      activeTodo = ref.read(todoListProvider.notifier).state[widget.index];
      _titleController.text = _praser.getText(activeTodo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar.medium(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: Theme.of(context).textTheme.headlineLarge,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: InputBorder.none,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: _praser
                        .getContext(activeTodo)
                        .map((e) => Chip(label: Text(e)))
                        .toList(),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: _praser
                        .getTags(activeTodo)
                        .map((e) => Chip(label: Text(e)))
                        .toList(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.done),
      ),
    );
  }
}
