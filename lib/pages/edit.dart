import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controller/db.dart';
import '../controller/tasklist.dart';
import '../controller/todosettings.dart';
import '../model/customlist.dart';
import '../model/task.dart';

enum EditState { newTask, editTask }

class EditView extends ConsumerStatefulWidget {
  const EditView({super.key, required this.editState, this.taskID});

  final EditState editState;

  final int? taskID;

  @override
  ConsumerState<EditView> createState() => _EditViewState();
}

class _EditViewState extends ConsumerState<EditView> {
  Task task = Task();

  final TextEditingController _titleEditingController = TextEditingController();

  EditorState editorState = EditorState.blank(withInitialText: true);

  late final EditorScrollController editorScrollController;

  Future<void> updateTodos(sortbycol, filter) async {
    final dbHelper = DatabaseHelper.instance;
    final todolist = await dbHelper.getTodos(sortbycol, filter);
    final customlist = await dbHelper.getCustomList();

    ref.read(customListProvider.notifier).state = customlist
        .map(
          (e) => CustomList.fromJson(e),
        )
        .toList();

    ref.read(taskListProvider.notifier).state = todolist
        .map(
          (e) => Task.fromJson(e),
        )
        .toList();
  }

  void fetch() async {
    final dbHelper = DatabaseHelper.instance;
    Map<String, dynamic>? text = await dbHelper.getTextById(widget.taskID!);
    var taskFromJson = Task.fromJson(text!);

    setState(() {
      task = taskFromJson;
      _titleEditingController.text = taskFromJson.title ?? "";
      editorState = (taskFromJson.description == null ||
              taskFromJson.description!.trim().isEmpty)
          ? EditorState.blank(withInitialText: true)
          : EditorState(
              document: markdownToDocument(taskFromJson.description!));
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.editState == EditState.editTask) {
      fetch();
    } else if (widget.editState == EditState.newTask) {}
    editorScrollController = EditorScrollController(editorState: editorState);
  }

  @override
  void dispose() {
    super.dispose();
    _titleEditingController.dispose();
    editorState.dispose();
  }

  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final map = {
      ...standardBlockComponentBuilderMap,
    };
    map[ParagraphBlockKeys.type] = ParagraphBlockComponentBuilder(
      configuration: BlockComponentConfiguration(
        placeholderText: (node) => 'Type something...',
      ),
    );
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.editState == EditState.newTask
            ? const Text("New")
            : const Text("Edit"),
      ),
      body: MobileToolbarV2(
        toolbarHeight: 48.0,
        toolbarItems: [
          textDecorationMobileToolbarItemV2,
          buildTextAndBackgroundColorMobileToolbarItem(),
          blocksMobileToolbarItem,
          linkMobileToolbarItem,
          dividerMobileToolbarItem,
        ],
        editorState: editorState,
        child: Column(
          children: [
            Expanded(
              child: MobileFloatingToolbar(
                editorScrollController: editorScrollController,
                editorState: editorState,
                toolbarBuilder: (context, anchor, closeToolbar) {
                  return AdaptiveTextSelectionToolbar.editable(
                    clipboardStatus: ClipboardStatus.pasteable,
                    onCopy: () {
                      copyCommand.execute(editorState);
                      closeToolbar();
                    },
                    onCut: () => cutCommand.execute(editorState),
                    onPaste: () => pasteCommand.execute(editorState),
                    onSelectAll: () => selectAllCommand.execute(editorState),
                    onLiveTextInput: null,
                    onLookUp: null,
                    onSearchWeb: null,
                    onShare: null,
                    anchors: TextSelectionToolbarAnchors(
                      primaryAnchor: anchor,
                    ),
                  );
                },
                child: AppFlowyEditor(
                  editorState: editorState,
                  blockComponentBuilders: _buildBlockComponentBuilders(),
                  editorStyle: EditorStyle.mobile(
                    textScaleFactor: 1.0,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    dragHandleColor: Theme.of(context).colorScheme.primary,
                    selectionColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    enableHapticFeedbackOnAndroid: true,
                    textStyleConfiguration: TextStyleConfiguration(
                      text: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      code: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontFamily: "Monoscape"),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    magnifierSize: Size(144, 96),
                    mobileDragHandleBallSize: Size(12, 12),
                  ),
                  showMagnifier: true,
                  editorScrollController:
                      EditorScrollController(editorState: editorState),
                  header: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                            controller: _titleEditingController,
                            autofocus: true,
                            decoration: const InputDecoration.collapsed(
                                hintText: "Title")),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          "Description",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.editState == EditState.newTask) {
            if (_titleEditingController.text.trim().isNotEmpty) {
              final newTodo = {
                'title': _titleEditingController.text.trim(),
                'description': documentToMarkdown(editorState.document),
                'is_done': 0,
                'date_created': DateTime.now().millisecondsSinceEpoch,
                'date_modified': DateTime.now().millisecondsSinceEpoch,
                "custom_list": <int>[],
                'trash': 0,
              };
              final dbHelper = DatabaseHelper.instance;
              await dbHelper.insertTodo(newTodo);
              updateTodos(
                  ref.watch(filterProvider).name, ref.watch(sortProvider).name);
              if (mounted) {
                context.pop();
              }
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Title in empty"),
                behavior: SnackBarBehavior.floating,
              ));
            }
          } else {
            if (_titleEditingController.text.trim().isNotEmpty) {
              final dbHelper = DatabaseHelper.instance;
              await dbHelper.updateTodoTitle(
                  task.id!,
                  _titleEditingController.text.trim(),
                  DateTime.now().millisecondsSinceEpoch);
              await dbHelper.updateTodoDescription(
                  task.id!,
                  documentToMarkdown(editorState.document),
                  DateTime.now().millisecondsSinceEpoch);
              updateTodos(
                  ref.watch(filterProvider).name, ref.watch(sortProvider).name);
              if (mounted) {
                context.pop();
              }
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Title in empty"),
                behavior: SnackBarBehavior.floating,
              ));
            }
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
