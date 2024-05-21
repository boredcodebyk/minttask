import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';

class TestView extends ConsumerStatefulWidget {
  const TestView({super.key});

  @override
  ConsumerState<TestView> createState() => _TestViewState();
}

class _TestViewState extends ConsumerState<TestView> {
  var details = "";
  var jsondummy = {
    "name": "abc",
    "Asd": "dfbds",
    "tttt": "rg",
  };

  void _editKey(String oldKey, String newKey) {
    setState(() {
      if (oldKey != newKey && !(jsondummy.containsKey(newKey))) {
        var val = jsondummy[oldKey];
        jsondummy.remove(oldKey);
        jsondummy.addAll({newKey: val ?? ""});
      }
    });
  }

  void _editValue(String key, dynamic value) {
    setState(() {
      jsondummy[key] = value;
    });
  }

  void _addRow() {
    setState(() {
      jsondummy["newKey"] = "newValue";
    });
  }

  void _deleteRow(String key) {
    setState(() {
      jsondummy.remove(key);
    });
  }

  Future<void> openDir() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // User canceled the picker
    } else {
      setState(() {
        details = selectedDirectory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Text(details),
          FilledButton(
            onPressed: () {
              ref.read(todotxtFilePathProvider.notifier).state = "";
            },
            child: Text("Close"),
          ),
          FilledButton(
            onPressed: () => print(jsondummy),
            child: Text("print json"),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Key')),
                  DataColumn(label: Text('Value')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: jsondummy.entries.map((entry) {
                  String key = entry.key;
                  dynamic value = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(
                        TextFormField(
                          initialValue: key,
                          decoration: InputDecoration(border: InputBorder.none),
                          onFieldSubmitted: (newKey) => _editKey(key, newKey),
                        ),
                      ),
                      DataCell(
                        TextFormField(
                          initialValue: value.toString(),
                          decoration: InputDecoration(border: InputBorder.none),
                          onFieldSubmitted: (newValue) =>
                              _editValue(key, newValue),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteRow(key),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
