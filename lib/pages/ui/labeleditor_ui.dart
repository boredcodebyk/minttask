import 'package:flutter/material.dart';
import 'package:minttask/model/db_model.dart';

class LabelEditor extends StatefulWidget {
  const LabelEditor({super.key, required this.selectedValue});
  final List<int> selectedValue;
  @override
  State<LabelEditor> createState() => _LabelEditorState();
}

class _LabelEditorState extends State<LabelEditor> {
  final TextEditingController _labelNameController = TextEditingController();
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: IsarHelper.instance.listCategory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var categoryLabel = snapshot.data;
              return Wrap(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoryLabel?.length,
                    itemBuilder: (context, index) {
                      var eachLabel = categoryLabel![index];
                      return FilterChip(
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
                      );
                    },
                  ),
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
                controller: _labelNameController,
                onSubmitted: (value) {
                  IsarHelper.instance.addCategory(title: value);
                  _labelNameController.clear();
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  IsarHelper.instance
                      .addCategory(title: _labelNameController.text);
                  _labelNameController.clear();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pop(selectedValueTmp),
                    child: const Text("Add")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
