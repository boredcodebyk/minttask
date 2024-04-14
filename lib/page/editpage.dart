import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/file_model.dart';
import 'package:minttask/model/todo_provider.dart';
import 'package:minttask/model/todotxt_parser.dart';

class EditPage extends ConsumerStatefulWidget {
  const EditPage({super.key, required this.index});
  final int index;
  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TaskParser _parser = TaskParser();
  String activeTodo = "";
  List<String> projectTags = [];
  List<String> contextTags = [];
  bool completion = false;
  Map<String, String>? metadata = {};
  int? priority;
  DateTime? completionDate;
  late DateTime creationDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadTodo();
  }

  void loadTodo() {
    setState(() {
      TaskText activeTodo = _parser
          .parser(ref.read(todoListProvider.notifier).state[widget.index]);
      _titleController.text = activeTodo.text;
      projectTags = activeTodo.projectTag ?? [];
      contextTags = activeTodo.contextTag ?? [];
      completion = activeTodo.completion;
      metadata = activeTodo.metadata;
      priority = activeTodo.priority;
      completionDate = activeTodo.completionDate;
      creationDate = activeTodo.creationDate;
    });
  }

  void saveTodo() {
    var task = TaskText(
      completion: completion,
      priority: priority,
      completionDate: completionDate,
      creationDate: creationDate,
      text: _titleController.text,
      projectTag: projectTags,
      contextTag: contextTags,
      metadata: metadata,
    );
    String taskString = _parser.lineConstructor(task);
    ref.read(todoListProvider.notifier).state[widget.index] = taskString;
    ref.read(todoContentProvider.notifier).state =
        ref.watch(todoListProvider).join("\n");
    FileModel()
        .saveFile(ref.watch(filePathProvider), ref.watch(todoContentProvider));
    FileModel().loadFile(ref.watch(filePathProvider),
        ref.read(todoContentProvider.notifier).state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChoiceChip(label: const Text("Mark Done"), selected: completion),
            TextField(
              controller: _titleController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: const InputDecoration(
                labelText: "Title",
                border: InputBorder.none,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "Priority",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: InputChip(
                color: (priority == null || priority == 0)
                    ? const MaterialStatePropertyAll(Colors.transparent)
                    : MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.surfaceVariant),
                avatar: (priority == null || priority == 0)
                    ? null
                    : const Icon(
                        Icons.priority_high,
                        size: 18,
                      ),
                label: Text(
                  (priority == null || priority == 0)
                      ? "None"
                      : TaskParser().indexToLetters(priority!),
                ),
                deleteIcon: (priority == null || priority == 0)
                    ? null
                    : const Icon(
                        Icons.close,
                        size: 18,
                      ),
                onDeleted: (priority == null || priority == 0)
                    ? null
                    : () => setState(() => priority = null),
                onPressed: () async {
                  int? getPriority = await showDialog(
                    context: context,
                    builder: (context) {
                      var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                      int selectedOption = 1;
                      return AlertDialog(
                        title: const Text("Priority"),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 16),
                        content: StatefulBuilder(
                            builder: (context, StateSetter setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(),
                              SizedBox(
                                width: 560,
                                height: 280,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: letters.split("").length,
                                  itemBuilder: (context, index) {
                                    var letter = letters.split("")[index];
                                    return RadioListTile(
                                      title: Text(letter),
                                      value: index + 1,
                                      groupValue: selectedOption,
                                      onChanged: (value) => setState(() {
                                        selectedOption = value!;
                                      }),
                                    );
                                  },
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        }),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(selectedOption);
                              },
                              child: const Text("OK")),
                        ],
                      );
                    },
                  );
                  setState(() {
                    priority = getPriority;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "Context",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (contextTags.isNotEmpty) ...[
                    ...contextTags.map((e) => InputChip(
                          avatar: const Icon(
                            Icons.alternate_email,
                            size: 18,
                          ),
                          label: Text(e),
                        ))
                  ] else
                    const InputChip(
                      label: Text("None"),
                    ),
                  const ActionChip(
                      label: Icon(
                    Icons.edit,
                    size: 18,
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "Project",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                runSpacing: 8,
                children: [
                  InputChip(
                    label: Text((priority == null || priority == 0)
                        ? "None"
                        : "(${TaskParser().indexToLetters(priority!)})"),
                  ),
                  const ActionChip(
                      label: Icon(
                    Icons.edit,
                    size: 18,
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveTodo();
          Navigator.of(context).pop();
        },
        child: Icon(Icons.done),
      ),
    );
  }
}
