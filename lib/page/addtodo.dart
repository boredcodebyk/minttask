import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:minttask/model/file_model.dart';
import 'package:minttask/model/todo_provider.dart';
import 'package:minttask/model/todotxt_parser.dart';

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  final TextEditingController _titleController = TextEditingController();
  final TaskParser _parser = TaskParser();
  String activeTodo = "";
  List<String> projectTags = [];
  List<String> contextTags = [];
  bool completion = false;
  Map<String, String>? metadata = {};
  int? priority;
  DateTime? completionDate;
  late DateTime creationDate = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String genSmallUUID() {
    var uuid = "";
    var random = Random();
    var charlist =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for (int i = 0; i < 11; i++) {
      final index = random.nextInt(charlist.length);
      uuid += charlist[index];
    }
    return uuid;
  }

  void saveTodo() async {
    metadata?.addAll({"id": genSmallUUID()});
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
    ref.read(todoListProvider.notifier).state.insert(0, taskString);
    ref.read(todoContentProvider.notifier).state =
        ref.watch(todoListProvider).join("\n");
    await FileManagementModel().saveTextFile(
        path: ref.watch(filePathProvider),
        content: ref.watch(todoContentProvider));
    ref.read(todoContentProvider.notifier).state = (await FileManagementModel()
            .readTextFile(path: ref.watch(filePathProvider)))
        .result!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChoiceChip(
                label: const Text("Mark Done"),
                selected: completion,
                onSelected: (value) => setState(() {
                  if (completion) {
                    completion = false;
                    completionDate = null;
                  } else {
                    completion = true;
                    completionDate = DateTime.now();
                  }
                }),
              ),
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
                  side: (priority == null || priority == 0)
                      ? null
                      : BorderSide.none,
                  color: (priority == null || priority == 0)
                      ? const MaterialStatePropertyAll(Colors.transparent)
                      : MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.surfaceVariant),
                  avatar: (priority == null || priority == 0)
                      ? null
                      : const Icon(
                          Icons.priority_high_rounded,
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
                      ...contextTags.map((e) => Chip(
                            side: BorderSide.none,
                            color: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.surfaceVariant),
                            avatar: const Icon(
                              Icons.alternate_email,
                              size: 18,
                            ),
                            label: Text(e),
                          ))
                    ] else
                      const Chip(
                        label: Text("None"),
                      ),
                    ActionChip(
                      label: const Icon(
                        Icons.edit,
                        size: 18,
                      ),
                      onPressed: () async {
                        var r = await showModalBottomSheet(
                          useRootNavigator: true,
                          useSafeArea: true,
                          showDragHandle: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            TextEditingController _tagController =
                                TextEditingController();
                            List<String> tagList = [];
                            List<ContextTag>? tagListState = ref
                                .watch(workspaceConfigStateProvider)
                                .contexts;
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  setState(() => tagList = contextTags);
                                  setState(() => tagListState = ref
                                      .watch(workspaceConfigStateProvider)
                                      .contexts);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: TextField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .deny(RegExp(r'\s')),
                                              ],
                                              controller: _tagController,
                                              decoration: const InputDecoration(
                                                  hintText: "tag2,tag2,tag2...",
                                                  border: InputBorder.none),
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  if (_tagController.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                    List<String> uniqueList =
                                                        _tagController.text
                                                            .split(",")
                                                            .toSet()
                                                            .toList();
                                                    var tempList = ref
                                                        .watch(
                                                            workspaceConfigStateProvider)
                                                        .contexts;
                                                    tempList!.addAll(uniqueList
                                                        .map((e) => ContextTag(
                                                            title: e,
                                                            description: ""))
                                                        .toList());
                                                    ref
                                                            .read(workspaceConfigStateProvider
                                                                .notifier)
                                                            .state
                                                            .contexts =
                                                        tempList.toSet().toList().fold(
                                                            <ContextTag>[],
                                                            (List<ContextTag>?
                                                                        previousValue,
                                                                    element) =>
                                                                previousValue!.any((e) =>
                                                                        e.title ==
                                                                        element
                                                                            .title)
                                                                    ? previousValue
                                                                    : [
                                                                        ...previousValue,
                                                                        ContextTag(
                                                                            title:
                                                                                element.title,
                                                                            description: "")
                                                                      ]);
                                                    FileManagementModel()
                                                        .saveConfigFile(
                                                            path: ref.watch(
                                                                configfilePathProvider),
                                                            content:
                                                                WorkspaceConfig(
                                                              contexts: tempList.toList().fold(
                                                                  <ContextTag>[],
                                                                  (List<ContextTag>?
                                                                              previousValue,
                                                                          element) =>
                                                                      previousValue!.any((e) =>
                                                                              e.title ==
                                                                              element
                                                                                  .title)
                                                                          ? previousValue
                                                                          : [
                                                                              ...previousValue,
                                                                              ContextTag(title: element.title, description: "")
                                                                            ]).toList(),
                                                              projects: ref
                                                                  .watch(
                                                                      workspaceConfigStateProvider)
                                                                  .projects,
                                                              metadatakeys: ref
                                                                  .watch(
                                                                      workspaceConfigStateProvider)
                                                                  .metadatakeys,
                                                            ).toRawJson());
                                                    setState(() =>
                                                        tagListState = ref
                                                            .watch(
                                                                workspaceConfigStateProvider)
                                                            .contexts);
                                                  }
                                                  _tagController.clear();
                                                },
                                                icon: const Icon(Icons.add)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              direction: Axis.horizontal,
                                              spacing: 8,
                                              children: [
                                                ...(tagListState ?? []).map(
                                                  (e) => FilterChip(
                                                    label: Text(e.title!),
                                                    selected: tagList
                                                        .contains(e.title),
                                                    onSelected: (selected) {
                                                      setState(
                                                        () {
                                                          if (selected) {
                                                            tagList
                                                                .add(e.title!);
                                                          } else {
                                                            tagList.remove(
                                                                e.title!);
                                                          }
                                                        },
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: FilledButton.tonal(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(tagList);
                                              },
                                              child: const Text("Apply")),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );

                        if (r != null) {
                          setState(() {
                            contextTags = r;
                          });
                        }
                      },
                    )
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
                    if (projectTags.isNotEmpty) ...[
                      ...projectTags.map((e) => Chip(
                            side: BorderSide.none,
                            color: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.surfaceVariant),
                            avatar: const Icon(
                              Icons.add,
                              size: 18,
                            ),
                            label: Text(e),
                          ))
                    ] else
                      const Chip(
                        label: Text("None"),
                      ),
                    ActionChip(
                      label: const Icon(
                        Icons.edit,
                        size: 18,
                      ),
                      onPressed: () async {
                        var r = await showModalBottomSheet(
                          useRootNavigator: true,
                          useSafeArea: true,
                          showDragHandle: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            TextEditingController _tagController =
                                TextEditingController();
                            List<String> tagList = [];
                            List<String>? tagListState = ref
                                .watch(workspaceConfigStateProvider)
                                .projects;
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  setState(() => tagList = projectTags);
                                  setState(() => tagListState = ref
                                      .watch(workspaceConfigStateProvider)
                                      .projects);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: TextField(
                                              controller: _tagController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .deny(RegExp(r'\s')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: "tag2,tag2,tag2...",
                                                  border: InputBorder.none),
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  if (_tagController.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                    List<String> uniqueList =
                                                        _tagController.text
                                                            .trim()
                                                            .split(",")
                                                            .toSet()
                                                            .toList();
                                                    var tempList = ref
                                                        .watch(
                                                            workspaceConfigStateProvider)
                                                        .projects;
                                                    tempList!
                                                        .addAll(uniqueList);
                                                    ref
                                                            .read(
                                                                workspaceConfigStateProvider
                                                                    .notifier)
                                                            .state
                                                            .projects =
                                                        tempList
                                                            .toSet()
                                                            .toList();
                                                    FileManagementModel()
                                                        .saveConfigFile(
                                                            path: ref.watch(
                                                                configfilePathProvider),
                                                            content:
                                                                WorkspaceConfig(
                                                              contexts: ref
                                                                  .watch(
                                                                      workspaceConfigStateProvider)
                                                                  .contexts,
                                                              projects: tempList
                                                                  .toSet()
                                                                  .toList(),
                                                              metadatakeys: ref
                                                                  .watch(
                                                                      workspaceConfigStateProvider)
                                                                  .metadatakeys,
                                                            ).toRawJson());
                                                    setState(() =>
                                                        tagListState = ref
                                                            .watch(
                                                                workspaceConfigStateProvider)
                                                            .projects);
                                                  }
                                                  _tagController.clear();
                                                },
                                                icon: const Icon(Icons.add)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              direction: Axis.horizontal,
                                              spacing: 8,
                                              children: [
                                                ...(tagListState ?? []).map(
                                                  (e) => FilterChip(
                                                    label: Text(e),
                                                    selected:
                                                        tagList.contains(e),
                                                    onSelected: (selected) {
                                                      setState(
                                                        () {
                                                          if (selected) {
                                                            tagList.add(e);
                                                          } else {
                                                            tagList.remove(e);
                                                          }
                                                        },
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: FilledButton.tonal(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(tagList);
                                              },
                                              child: const Text("Apply")),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );

                        if (r != null) {
                          setState(() {
                            projectTags = r;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Metadata",
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
                    if (metadata!.entries.isNotEmpty) ...[
                      ...metadata!.entries.map((e) => Chip(
                            side: BorderSide.none,
                            color: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.surfaceVariant),
                            avatar: const Icon(
                              Icons.tag,
                              size: 18,
                            ),
                            label: Text("${e.key}:${e.value}"),
                          ))
                    ] else
                      const Chip(
                        label: Text("None"),
                      ),
                    ActionChip(
                      label: const Icon(
                        Icons.edit,
                        size: 18,
                      ),
                      onPressed: () async {
                        var r = await showModalBottomSheet(
                          useRootNavigator: true,
                          useSafeArea: true,
                          showDragHandle: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            Map<String, String> metadataList = {};
                            TextEditingController _keyController =
                                TextEditingController();
                            TextEditingController _valueController =
                                TextEditingController();
                            FocusNode _valueFieldFocus = FocusNode();
                            List<String>? metadataListState = ref
                                .watch(workspaceConfigStateProvider)
                                .metadatakeys;
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  setState(() => metadataList = metadata!);
                                  setState(() => metadataListState = ref
                                      .watch(workspaceConfigStateProvider)
                                      .metadatakeys);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: DataTable(
                                          columns: const [
                                            DataColumn(
                                                label: Expanded(
                                                    child: Text("Key"))),
                                            DataColumn(
                                                label: Expanded(
                                                    child: Text("Value"))),
                                            DataColumn(
                                                label: Expanded(
                                              child: Text(""),
                                            ))
                                          ],
                                          rows: [
                                            ...metadataList.entries.map(
                                              (e) => DataRow(
                                                cells: [
                                                  DataCell(
                                                    TextField(
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .deny(
                                                                RegExp(r'\s')),
                                                      ],
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                      controller:
                                                          TextEditingController
                                                              .fromValue(
                                                                  TextEditingValue(
                                                                      text: e
                                                                          .key)),
                                                      onSubmitted: (v) {
                                                        setState(
                                                          () {
                                                            metadataList
                                                                .remove(e.key);
                                                            metadataList.addAll(
                                                                {v: e.value});
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  ...[
                                                    e.key == "due"
                                                        ? DataCell(
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                var picked = await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    firstDate: DateTime(
                                                                        DateTime.now().year -
                                                                            1),
                                                                    lastDate: DateTime(
                                                                        DateTime.now().year +
                                                                            10),
                                                                    currentDate:
                                                                        DateTime.tryParse(
                                                                            e.value));
                                                                if (picked !=
                                                                        null &&
                                                                    picked !=
                                                                        DateTime.tryParse(
                                                                            e.value)) {
                                                                  setState(() {
                                                                    metadataList.update(
                                                                        e.key,
                                                                        (value) =>
                                                                            "${picked.year}-${picked.month <= 9 ? "0${picked.month}" : picked.month}-${picked.day}");
                                                                  });
                                                                }
                                                              },
                                                              style: const ButtonStyle(
                                                                  padding: MaterialStatePropertyAll(
                                                                      EdgeInsets
                                                                          .zero)),
                                                              child: Text(
                                                                e.value,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge,
                                                              ),
                                                            ),
                                                          )
                                                        : e.key == "id"
                                                            ? DataCell(
                                                                Text(e.value))
                                                            : DataCell(
                                                                TextField(
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .deny(RegExp(
                                                                            r'\s')),
                                                                  ],
                                                                  decoration:
                                                                      const InputDecoration(
                                                                          border:
                                                                              InputBorder.none),
                                                                  controller:
                                                                      TextEditingController
                                                                          .fromValue(
                                                                    TextEditingValue(
                                                                        text: e
                                                                            .value,
                                                                        selection:
                                                                            TextSelection.collapsed(offset: e.value.length)),
                                                                  ),
                                                                  onSubmitted:
                                                                      (value) {
                                                                    setState(
                                                                      () {
                                                                        metadataList.update(
                                                                            e.key,
                                                                            (v) => value);
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                  ],
                                                  DataCell(
                                                    e.key == "id"
                                                        ? const Text("")
                                                        : IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                  content: Text(
                                                                      "Delete \"${e.key}\" column?"),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          "No"),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(() =>
                                                                            metadataList.remove(e.key));
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          "Yes"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              size: 16,
                                                            ),
                                                          ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  controller: _keyController,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .deny(RegExp(r'\s')),
                                                  ],
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onSubmitted: (value) {
                                                    value.trim().isNotEmpty
                                                        ? _valueFieldFocus
                                                            .hasFocus
                                                        : null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText: "Key"),
                                                ),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .deny(RegExp(r'\s')),
                                                  ],
                                                  focusNode: _valueFieldFocus,
                                                  controller: _valueController,
                                                  onSubmitted: (val) {
                                                    setState(() {
                                                      if (_keyController.text
                                                          .trim()
                                                          .isNotEmpty) {
                                                        for (var element
                                                            in metadataListState!) {
                                                          if (_keyController
                                                                  .text !=
                                                              element) {
                                                            var temp = {
                                                              _keyController
                                                                  .text: val
                                                            };
                                                            metadataList
                                                                .addAll(temp);
                                                            print(metadataList);
                                                            ref
                                                                    .read(workspaceConfigStateProvider
                                                                        .notifier)
                                                                    .state
                                                                    .metadatakeys =
                                                                metadataList
                                                                    .keys
                                                                    .toList();
                                                            FileManagementModel()
                                                                .saveConfigFile(
                                                                    path: ref.watch(
                                                                        configfilePathProvider),
                                                                    content:
                                                                        WorkspaceConfig(
                                                                      contexts: ref
                                                                          .watch(
                                                                              workspaceConfigStateProvider)
                                                                          .contexts,
                                                                      projects: ref
                                                                          .watch(
                                                                              workspaceConfigStateProvider)
                                                                          .projects,
                                                                      metadatakeys: metadataList
                                                                          .keys
                                                                          .toList(),
                                                                    ).toRawJson());
                                                            setState(() =>
                                                                metadataListState = ref
                                                                    .watch(
                                                                        workspaceConfigStateProvider)
                                                                    .metadatakeys);

                                                            _keyController
                                                                .clear();
                                                            _valueController
                                                                .clear();
                                                          }
                                                        }
                                                      } else {}
                                                    });
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText: "Value"),
                                                ),
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (_keyController.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                    for (var element
                                                        in metadataListState!) {
                                                      if (_keyController.text !=
                                                          element) {
                                                        var temp = {
                                                          _keyController.text:
                                                              _valueController
                                                                  .text
                                                        };
                                                        metadataList
                                                            .addAll(temp);
                                                        print(metadataList);
                                                        ref
                                                                .read(workspaceConfigStateProvider
                                                                    .notifier)
                                                                .state
                                                                .metadatakeys =
                                                            metadataList.keys
                                                                .toList();
                                                        FileManagementModel()
                                                            .saveConfigFile(
                                                                path: ref.watch(
                                                                    configfilePathProvider),
                                                                content:
                                                                    WorkspaceConfig(
                                                                  contexts: ref
                                                                      .watch(
                                                                          workspaceConfigStateProvider)
                                                                      .contexts,
                                                                  projects: ref
                                                                      .watch(
                                                                          workspaceConfigStateProvider)
                                                                      .projects,
                                                                  metadatakeys:
                                                                      metadataList
                                                                          .keys
                                                                          .toList(),
                                                                ).toRawJson());
                                                        setState(() =>
                                                            metadataListState = ref
                                                                .watch(
                                                                    workspaceConfigStateProvider)
                                                                .metadatakeys);

                                                        _keyController.clear();
                                                        _valueController
                                                            .clear();
                                                      }
                                                    }
                                                  } else {}
                                                });
                                              },
                                              icon: const Icon(Icons.add)),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: FilledButton.tonal(
                                              onPressed: () {
                                                setState(
                                                  () =>
                                                      metadataList.removeWhere(
                                                          (key, value) =>
                                                              key == ""),
                                                );
                                                Navigator.of(context)
                                                    .pop(metadataList);
                                              },
                                              child: const Text("Apply")),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );

                        if (r != null) {
                          setState(() {
                            metadata = r;
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text(
                    "Other",
                  ),
                  expandedAlignment: Alignment.topLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (completion) ...[
                      Text(
                          "Completion Date - ${DateFormat.yMMMMd('en_US').format(completionDate!)}"),
                    ],
                    Text(
                        "Creation Date - ${DateFormat.yMMMMd('en_US').format(creationDate)}"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_titleController.text.isNotEmpty) {
            saveTodo();
            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
