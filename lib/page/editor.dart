import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/todo_provider.dart';

class BulkEditor extends ConsumerStatefulWidget {
  const BulkEditor({super.key});

  @override
  ConsumerState<BulkEditor> createState() => _BulkEditorState();
}

class _BulkEditorState extends ConsumerState<BulkEditor> {
  CodeController _codeController = CodeController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadTodo();
  }

  void loadTodo() async {
    setState(() {
      _codeController.text = ref.watch(todoContentProvider);
    });
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
    return Flexible(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: CodeField(
              background: Colors.transparent,
              cursorColor: Theme.of(context).colorScheme.onSurface,
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
              controller: _codeController,
              wrap: true,
              gutterStyle: const GutterStyle(margin: 0, width: 40),
            ),
          ),
          Padding(
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.map),
            ),
            padding: EdgeInsets.only(bottom: 16, right: 16),
          ),
        ],
      ),
    );
  }
}
