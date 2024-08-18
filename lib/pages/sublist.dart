import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/todosettings.dart';

import '../controller/db.dart';
import '../controller/tasklist.dart';
import '../model/task.dart';
import 'components/listview.dart';
import 'home.dart';

class SubListView extends ConsumerStatefulWidget {
  const SubListView({super.key, required this.taskID});

  final int taskID;

  @override
  ConsumerState<SubListView> createState() => _SubListViewState();
}

class _SubListViewState extends ConsumerState<SubListView> {
  String customListName = "";
  Future<void> getCustomListName() async {
    final dbHelper = DatabaseHelper.instance;

    var name = await dbHelper.getCustomListName(widget.taskID);
    setState(() {
      customListName = name ?? "";
    });
  }

  Future<void> updateTodos(sortbycol, filter) async {
    final dbHelper = DatabaseHelper.instance;
    final todolist = await dbHelper.getTodos(sortbycol, filter);

    ref.read(taskListProvider.notifier).state = todolist
        .map(
          (e) => Task.fromJson(e),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getCustomListName();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                customListName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.edit_outlined))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  avatar: const Icon(Icons.sort),
                  label: const Text("Sort"),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const SortDialog()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  avatar: const Icon(Icons.filter_alt_outlined),
                  label: const Text("Filter"),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const FilterDialog()),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ListViewCard(
              list: ref
                  .watch(taskListProvider)
                  .where((e) => e.customList!.contains(widget.taskID))
                  .toList()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 36,
          ),
          child: Text(
            ref
                    .watch(taskListProvider)
                    .where((e) => e.customList!.contains(widget.taskID))
                    .toList()
                    .isNotEmpty
                ? "That's all!"
                : "It's nononon here.",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.outline),
          ),
        )
      ],
    );
  }
}

class CustomListEditor extends StatefulWidget {
  const CustomListEditor({super.key});

  @override
  State<CustomListEditor> createState() => _CustomListEditorState();
}

class _CustomListEditorState extends State<CustomListEditor> {
  final TextEditingController editorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit"),
      content: TextField(
        controller: editorController,
        decoration: const InputDecoration.collapsed(hintText: "Name"),
      ),
    );
  }
}
