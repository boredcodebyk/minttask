import 'package:flutter/material.dart';

class TagEditorDialog extends StatefulWidget {
  const TagEditorDialog({super.key});

  @override
  State<TagEditorDialog> createState() => _TagEditorDialogState();
}

class _TagEditorDialogState extends State<TagEditorDialog> {
  final TextEditingController _tagController = TextEditingController();
  List<String> tagsValue = [];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Tags",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tagsValue
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(e),
                          deleteIcon: const Icon(Icons.close),
                        ),
                      ))
                  .toList(),
            ),
          ),
          TextField(
            controller: _tagController,
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: "Add tags..."),
            onChanged: (value) {
              var previousText0 = '';
              final previousText = previousText0;
              previousText0 = value;
              if (value.length == 1 && [" ", ","].contains(value)) {
                _tagController.clear();
                return;
              } else if (value.length > previousText.length) {
                // Add case
                final newChar = value[value.length - 1];
                if ([" ", ","].contains(newChar)) {
                  final targetString = value.substring(0, value.length - 1);
                  if (targetString.isNotEmpty) {
                    setState(() {
                      tagsValue.add(targetString);
                    });
                    _tagController.clear();
                  }
                }
              }
              //print(tagsValue);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              tagsValue.clear();
              Navigator.of(context).pop(tagsValue);
            },
            child: const Text("Close"))
      ],
    );
  }
}
