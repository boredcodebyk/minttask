import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/filehandle.dart';

class NewDialog extends ConsumerStatefulWidget {
  const NewDialog({super.key});

  @override
  ConsumerState<NewDialog> createState() => _NewDialogState();
}

class _NewDialogState extends ConsumerState<NewDialog> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New todo.txt"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), suffixText: '.txt'),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close")),
        TextButton(
            onPressed: () {
              ref
                  .read(rawFileProvider.notifier)
                  .createFile('${_controller.text}.txt');
              Navigator.of(context).pop();
            },
            child: const Text("Save"))
      ],
    );
  }
}
