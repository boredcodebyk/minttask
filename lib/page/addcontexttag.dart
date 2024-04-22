import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/model/file_model.dart';
import 'package:minttask/model/todo_provider.dart';

class AddContextTagPage extends ConsumerStatefulWidget {
  const AddContextTagPage({super.key});

  @override
  ConsumerState<AddContextTagPage> createState() => _AddContextTagPageState();
}

class _AddContextTagPageState extends ConsumerState<AddContextTagPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool doesExist = false;

  void saveContextTag() {
    ContextTag contextTag = ContextTag(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim());

    ref.read(contextTagsInWorkspaceProvider.notifier).state.add(contextTag);
    FileManagementModel().saveConfigFile(
        path: ref.watch(configfilePathProvider),
        content: WorkspaceConfig(
                contexts: ref.watch(contextTagsInWorkspaceProvider),
                projects: ref.watch(projectTagsInWorkspaceProvider),
                metadatakeys: ref.watch(metadatakeysInWorkspaceProvider))
            .toRawJson());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar.large(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onChanged: (value) {
                      if (ref
                          .watch(contextTagsInWorkspaceProvider)
                          .any((element) => element.title! == value)) {
                        setState(() => doesExist = true);
                      } else {
                        setState(() => doesExist = false);
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Title",
                        border: InputBorder.none,
                        errorText: doesExist
                            ? "Already Exist! Try a different name."
                            : null),
                  ),
                  TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.done),
          onPressed: () => doesExist
              ? null
              : _titleController.text.isNotEmpty
                  ? saveContextTag()
                  : null),
    );
  }
}
