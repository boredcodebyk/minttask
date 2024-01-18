import 'package:flutter/material.dart';
import 'package:minttask/model/db_model.dart';
import 'package:minttask/model/settings_model.dart';
import 'package:minttask/utils/utils.dart';
import 'package:provider/provider.dart';

class LabelEditor extends StatefulWidget {
  const LabelEditor(
      {super.key, required this.selectedValue, required this.mode});
  final List<int> selectedValue;
  final CategorySelectMode mode;
  @override
  State<LabelEditor> createState() => _LabelEditorState();
}

class _LabelEditorState extends State<LabelEditor> {
  final TextEditingController _labelNameAddController = TextEditingController();
  final TextEditingController _labelNameEditController =
      TextEditingController();
  List<int> selectedValueTmp = [];
  @override
  void initState() {
    super.initState();
    if (widget.selectedValue.isNotEmpty) {
      for (var element in widget.selectedValue) {
        setState(() {
          selectedValueTmp.add(element);
        });
      }
    }
  }

  @override
  void dispose() {
    _labelNameAddController.dispose();
    _labelNameEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TodoListModel tdl = Provider.of<TodoListModel>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ElevationOverlay.applySurfaceTint(
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceTint,
            1),
        body: StreamBuilder(
          stream: IsarHelper.instance.listCategory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var categoryLabel = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.mode == CategorySelectMode.sort)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 0,
                        child: SwitchListTile(
                            title: const Text("Use category filter"),
                            value: tdl.useCategorySort,
                            onChanged: (value) => tdl.useCategorySort = value!),
                      ),
                    ),
                  if (widget.mode == CategorySelectMode.modify ||
                      (widget.mode == CategorySelectMode.sort &&
                          tdl.useCategorySort)) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 16,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          for (var eachLabel in categoryLabel!)
                            FilterChip(
                              label: Text("${eachLabel.name}"),
                              onSelected: (value) {
                                if (value) {
                                  setState(() {
                                    selectedValueTmp.add(eachLabel.id);
                                  });
                                } else {
                                  if (selectedValueTmp.contains(eachLabel.id)) {
                                    setState(() {
                                      selectedValueTmp.remove(eachLabel.id);
                                    });
                                  }
                                }
                              },
                              selected: selectedValueTmp.contains(eachLabel.id),
                            ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 16,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          for (var eachLabel in categoryLabel!)
                            ActionChip(
                              label: Text("${eachLabel.name}"),
                              onPressed: () async {
                                _labelNameEditController.text = eachLabel.name!;
                                return showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Edit"),
                                    content: TextField(
                                      controller: _labelNameEditController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder()),
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            IsarHelper.instance
                                                .deleteCategory(eachLabel.id);
                                          },
                                          icon:
                                              const Icon(Icons.delete_forever)),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text("Cancel")),
                                          TextButton(
                                              onPressed: () {
                                                IsarHelper.instance
                                                    .updateLabelTitle(
                                                        id: eachLabel.id,
                                                        title:
                                                            _labelNameEditController
                                                                .text);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Done"))
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                        ],
                      ),
                    ),
                  ]
                ],
              );
            }
            return const Text("Empty");
          },
        ),
        bottomSheet: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.label_outline_rounded),
              title: TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Add new label..."),
                controller: _labelNameAddController,
                onSubmitted: (value) {
                  IsarHelper.instance.addCategory(title: value);
                  _labelNameAddController.clear();
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  IsarHelper.instance
                      .addCategory(title: _labelNameAddController.text);
                  _labelNameAddController.clear();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton.tonal(
                      onPressed: () => Navigator.of(context).pop(<int>[]),
                      child: const Text("Cancel")),
                  FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pop(selectedValueTmp),
                    child: selectedValueTmp.isNotEmpty
                        ? Text("Add (${selectedValueTmp.length})")
                        : const Text("Add"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
