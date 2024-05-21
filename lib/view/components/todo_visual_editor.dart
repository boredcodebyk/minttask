import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';

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
                    label: Text("label"),
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
