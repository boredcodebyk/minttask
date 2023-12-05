import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/model/db_model.dart';
import 'package:minttask/utils/enum_utils.dart';
import 'package:provider/provider.dart';

import '../../model/settings_model.dart';
import 'listbuilder_ui.dart';

class CategoryListUI extends StatefulWidget {
  const CategoryListUI({super.key, required this.mode, this.todoID});
  final CategorySelectMode mode;
  final int? todoID;
  @override
  State<CategoryListUI> createState() => _CategoryListUIState();
}

class _CategoryListUIState extends State<CategoryListUI> {
  final TextEditingController _catLabelName = TextEditingController();

  //List<int> catLabel = []; //variable sent back to requested destination
  Map<int, bool> categoryCheckBox = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TodoListModel tdl = Provider.of<TodoListModel>(context);
    TaskListProvider categoryDataProvider = context.watch<TaskListProvider>();
    print(categoryDataProvider.sortLabelSelection);

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          if (widget.mode == CategorySelectMode.modify) {
            categoryDataProvider.updateCategoryInTask(
                widget.todoID!,
                categoryDataProvider.editLabelSelection.entries
                    .where((element) => element.value)
                    .map((e) => e.key)
                    .toList());
            categoryDataProvider.editLabelSelection.forEach((key, value) {
              categoryDataProvider.editLabelSelection[key] = false;
            });
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(CorePalette.of(
                  Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
          appBar: AppBar(
            backgroundColor: Color(
                CorePalette.of(Theme.of(context).colorScheme.primary.value)
                    .neutral
                    .get(Theme.of(context).brightness == Brightness.light
                        ? 92
                        : 10)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.mode == CategorySelectMode.sort) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Card(
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 0,
                        child: SwitchListTile(
                          title: const Text("Use category filter"),
                          value: tdl.useCategorySort,
                          onChanged: (value) {
                            setState(() {
                              tdl.useCategorySort = value;
                            });
                          },
                        ),
                      ),
                    ),
                    if (categoryDataProvider.categoryList.isNotEmpty) ...[
                      if (tdl.useCategorySort) ...[
                        ListBuilder(
                            itemCount:
                                categoryDataProvider.sortLabelSelection.length,
                            itemBuilder: (context, index) {
                              var key = categoryDataProvider
                                  .sortLabelSelection.keys
                                  .elementAt(index);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: CheckboxListTile(
                                  tristate: true,
                                  tileColor: Color(CorePalette.of(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .value)
                                      .neutral
                                      .get(Theme.of(context).brightness ==
                                              Brightness.light
                                          ? 98
                                          : 17)),
                                  title: Text(categoryDataProvider
                                      .categoryList[index].name!),
                                  value: categoryDataProvider
                                          .sortLabelSelection[key] ??
                                      false,
                                  onChanged: (value) {
                                    categoryDataProvider.saveCategoryState(
                                      key,
                                      value ?? false,
                                      CategorySelectMode.sort,
                                    );
                                  },
                                ),
                              );
                            })
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            clipBehavior: Clip.antiAlias,
                            child: ReorderableListView.builder(
                              itemCount:
                                  categoryDataProvider.categoryList.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              clipBehavior: Clip.antiAlias,
                              physics: const NeverScrollableScrollPhysics(),
                              onReorder: (int oldIndex, int newIndex) {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                categoryDataProvider.reorderCategoryLabels(
                                    categoryDataProvider
                                        .categoryList[oldIndex].orderID!,
                                    categoryDataProvider
                                        .categoryList[newIndex].orderID!);
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  key: Key("$index"),
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: ListTile(
                                    tileColor: Color(CorePalette.of(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .value)
                                        .neutral
                                        .get(Theme.of(context).brightness ==
                                                Brightness.light
                                            ? 98
                                            : 17)),
                                    title: Text(categoryDataProvider
                                        .categoryList[index].name!),
                                    trailing: const Icon(Icons.reorder),
                                    onTap: () async => await showDialog(
                                        context: context,
                                        builder: (context) {
                                          TextEditingController
                                              textEditingController =
                                              TextEditingController();

                                          textEditingController.text =
                                              categoryDataProvider
                                                  .categoryList[index].name!;

                                          return AlertDialog(
                                            title: const Text("Edit"),
                                            content: TextField(
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder()),
                                              controller: textEditingController,
                                              autofocus: true,
                                            ),
                                            actionsAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            actions: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    categoryDataProvider
                                                        .deleteCategory(
                                                      categoryDataProvider
                                                          .categoryList[index]
                                                          .id,
                                                    );
                                                  },
                                                  icon: const Icon(
                                                      Icons.delete_forever)),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child:
                                                          const Text("Cancel")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        categoryDataProvider
                                                            .updateCategoryTitle(
                                                                categoryDataProvider
                                                                    .categoryList[
                                                                        index]
                                                                    .id,
                                                                textEditingController
                                                                    .text);
                                                      },
                                                      child:
                                                          const Text("Save")),
                                                ],
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ] else
                      const Text("Empty"),
                  ] else if (widget.mode == CategorySelectMode.add) ...[
                    if (categoryDataProvider.categoryList.isNotEmpty) ...[
                      ListBuilder(
                        itemCount:
                            categoryDataProvider.addLabelSelection.length,
                        itemBuilder: (context, index) {
                          var key = categoryDataProvider.addLabelSelection.keys
                              .elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: CheckboxListTile(
                                tristate: true,
                                tileColor: Color(CorePalette.of(
                                        Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .value)
                                    .neutral
                                    .get(Theme.of(context).brightness ==
                                            Brightness.light
                                        ? 98
                                        : 17)),
                                title: Text(categoryDataProvider
                                    .categoryList[index].name!),
                                value: categoryDataProvider
                                        .addLabelSelection[key] ??
                                    false,
                                onChanged: (value) {
                                  categoryDataProvider.saveCategoryState(key,
                                      value ?? false, CategorySelectMode.add);
                                }),
                          );
                        },
                      )
                    ] else
                      const Text("Empty"),
                  ] else if (widget.mode == CategorySelectMode.modify) ...[
                    if (categoryDataProvider.categoryList.isNotEmpty) ...[
                      ListBuilder(
                        itemCount:
                            categoryDataProvider.editLabelSelection.length,
                        itemBuilder: (context, index) {
                          var key = categoryDataProvider.editLabelSelection.keys
                              .elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: CheckboxListTile(
                                tristate: true,
                                tileColor: Color(CorePalette.of(
                                        Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .value)
                                    .neutral
                                    .get(Theme.of(context).brightness ==
                                            Brightness.light
                                        ? 98
                                        : 17)),
                                title: Text(categoryDataProvider
                                    .categoryList[index].name!),
                                value: categoryDataProvider
                                        .editLabelSelection[key] ??
                                    false,
                                onChanged: (value) {
                                  categoryDataProvider.saveCategoryState(
                                      key,
                                      value ?? false,
                                      CategorySelectMode.modify);
                                }),
                          );
                        },
                      )
                    ] else
                      const Text("Empty"),
                  ],
                ],
              ),
            ),
          ),
          bottomSheet: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.label_outline_rounded),
                title: TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Add new label..."),
                  controller: _catLabelName,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context
                        .read<TaskListProvider>()
                        .addCategory(_catLabelName.text);
                    _catLabelName.clear();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
