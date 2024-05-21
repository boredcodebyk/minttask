import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';

import '../../controller/todotxt_parser.dart';

class TodoVisualEditor extends ConsumerStatefulWidget {
  const TodoVisualEditor({super.key});

  @override
  ConsumerState<TodoVisualEditor> createState() => _TodoVisualEditorState();
}

class _TodoVisualEditorState extends ConsumerState<TodoVisualEditor> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      _controller.text = ref.read(todoItemProvider).text;
    });
  }

  Future<int?> priorityPicker() async {
    return await showDialog(
      context: context,
      builder: (context) {
        var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        int selectedOption = 1;
        return AlertDialog(
          title: const Text("Priority"),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          content: StatefulBuilder(builder: (context, StateSetter setState) {
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
                onPressed: () => Navigator.of(context).pop(null),
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
  }

  Future<List<String>> contextTagPicker() async {
    return await showModalBottomSheet(
      useRootNavigator: true,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Column(
          children: [],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 96.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 480,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Title'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _controller,
                  onChanged: (value) => ref
                      .read(todoItemProvider.notifier)
                      .updateFromTask(
                          ref.watch(todoItemProvider).copyWith(text: value)),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny('\n'),
                  ],
                  style: Theme.of(context).textTheme.headlineMedium,
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
                    side: (ref.watch(todoItemProvider).priority == null ||
                            ref.watch(todoItemProvider).priority == 0)
                        ? null
                        : BorderSide.none,
                    color: (ref.watch(todoItemProvider).priority == null ||
                            ref.watch(todoItemProvider).priority == 0)
                        ? const WidgetStatePropertyAll(Colors.transparent)
                        : WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.surfaceVariant),
                    avatar: (ref.watch(todoItemProvider).priority == null ||
                            ref.watch(todoItemProvider).priority == 0)
                        ? null
                        : const Icon(
                            Icons.priority_high_rounded,
                            size: 18,
                          ),
                    label: Text(
                      (ref.watch(todoItemProvider).priority == null ||
                              ref.watch(todoItemProvider).priority == 0)
                          ? "None"
                          : indexToLetters(
                              ref.watch(todoItemProvider).priority!),
                    ),
                    deleteIcon: (ref.watch(todoItemProvider).priority == null ||
                            ref.watch(todoItemProvider).priority == 0)
                        ? null
                        : const Icon(
                            Icons.close,
                            size: 18,
                          ),
                    onDeleted: (ref.watch(todoItemProvider).priority == null ||
                            ref.watch(todoItemProvider).priority == 0)
                        ? null
                        : () => setState(() => ref
                            .read(todoItemProvider.notifier)
                            .updateFromTask(ref
                                .watch(todoItemProvider)
                                .copyWith(priority: null))),
                    onPressed: () async {
                      int? selectedPriority = await priorityPicker();
                      if (selectedPriority != null) {
                        ref.read(todoItemProvider.notifier).updateFromTask(ref
                            .watch(todoItemProvider)
                            .copyWith(priority: selectedPriority));
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Context Tag",
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
                      InputChip(label: Text("A")),
                      InputChip(label: Text("B")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Project Tag",
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
                      InputChip(label: Text("A")),
                      InputChip(label: Text("B")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
