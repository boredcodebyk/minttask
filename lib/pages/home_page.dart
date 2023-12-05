/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:zefyrka/zefyrka.dart';

import '../model/settings_model.dart';
import 'pages.dart';

import '../model/db.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, TextEditingController> textEditingControllers = {};
  Map<int, bool> isEditing = {};
  List<Map<String, dynamic>> _todoList = [];
  final TextEditingController _titleController = TextEditingController();

  ZefyrController _zefyrController = ZefyrController();

  Map<String, String> filterCol = {"sortby": "", "filter": ""};
  Future<void> _listTodos(col, filter) async {
    final dbHelper = DatabaseHelper.instance;
    final todolist = await dbHelper.getTodos(col, filter);

    setState(() {
      _todoList = todolist;
    });
  }

  Future<void> _addTodo(String title, String description) async {
    final newTodo = {
      'title': title,
      'description': description,
      'is_done': 0,
      'date_created': DateTime.now().millisecondsSinceEpoch,
      'date_modified': DateTime.now().millisecondsSinceEpoch
    };
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insertTodo(newTodo);
    await _listTodos(filterCol["sortby"], filterCol["filter"]);
  }

  Future<void> _toggleTodoStatus(int id, int isDone) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateTodoStauts(
        id, isDone, DateTime.now().millisecondsSinceEpoch);
    await _listTodos(filterCol["sortby"], filterCol["filter"]);
  }

  Future<void> _deleteTodo(int id) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteTodo(id);
    await _listTodos(filterCol["sortby"], filterCol["filter"]);
  }

  @override
  void initState() {
    super.initState();
    TodoListModel tdl = context.read<TodoListModel>();

    setState(() {
      filterCol["sortby"] = tdl.sort;
      filterCol["filter"] = tdl.filter;
    });

    _listTodos(filterCol["sortby"], filterCol["filter"]);
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _zefyrController.dispose();
  }

  Route _createRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);
    TodoListModel tdl = Provider.of<TodoListModel>(context);

    List notfinishedList =
        _todoList.where((element) => element['is_done'] == 0).toList();
    List completedList =
        _todoList.where((element) => element['is_done'] == 1).toList();
    notfinishedList.toList().sort(
          (a, b) => tdl.filter == "asc"
              ? a[tdl.sort.toLowerCase()].compareTo(b[tdl.sort.toLowerCase()])
              : b[tdl.sort].compareTo(a[tdl.sort]),
        );
    return Scaffold(
      backgroundColor: Color(
          CorePalette.of(Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Color(
                CorePalette.of(Theme.of(context).colorScheme.primary.value)
                    .neutral
                    .get(Theme.of(context).brightness == Brightness.light
                        ? 92
                        : 10)),
            title: const Text("Mint Task"),
            actions: [
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Category"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(),
                        SizedBox(
                          width: double.maxFinite,
                          height: 240,
                          child: SingleChildScrollView(
                            child: ListView(shrinkWrap: true, children: [
                              CheckboxListTile(
                                value: true,
                                onChanged: (value) {},
                              ),
                              CheckboxListTile(
                                value: true,
                                onChanged: (value) {},
                              ),
                              CheckboxListTile(
                                value: true,
                                onChanged: (value) {},
                              )
                            ]),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () {}, child: const Text("Done"))
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        RadioListTile(
                          value: "id",
                          groupValue: tdl.sort,
                          onChanged: (value) {
                            tdl.sort = value!;
                            _listTodos(value, tdl.filter);
                            Navigator.pop(context);
                          },
                          title: const Text("Default (order by ID)"),
                        ),
                        RadioListTile(
                          value: "title",
                          groupValue: tdl.sort,
                          onChanged: (value) {
                            tdl.sort = value!;
                            _listTodos(value, tdl.filter);
                            Navigator.pop(context);
                          },
                          title: const Text("Title"),
                        ),
                        RadioListTile(
                          value: "date_created",
                          groupValue: tdl.sort,
                          onChanged: (value) {
                            tdl.sort = value!;
                            _listTodos(value, tdl.filter);
                            Navigator.pop(context);
                          },
                          title: const Text("Date Created"),
                        ),
                        RadioListTile(
                          value: "date_modified",
                          groupValue: tdl.sort,
                          onChanged: (value) {
                            tdl.sort = value!;
                            _listTodos(value, tdl.filter);
                            Navigator.pop(context);
                          },
                          title: const Text("Date Modified"),
                        ),
                        const Divider(),
                        RadioListTile(
                          value: "asc",
                          groupValue: tdl.filter,
                          onChanged: (value) {
                            tdl.filter = value!;
                            _listTodos(tdl.sort, value);
                            Navigator.pop(context);
                          },
                          title: const Text("Ascending"),
                        ),
                        RadioListTile(
                          value: "desc",
                          groupValue: tdl.filter,
                          onChanged: (value) {
                            tdl.filter = value!;
                            _listTodos(tdl.sort, value);
                            Navigator.pop(context);
                          },
                          title: const Text("Descending"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () => Navigator.push(
                      context, _createRoute(const SettingsPage())),
                  icon: const Icon(Icons.settings_outlined))
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 84),
              child: Column(
                children: [
                  if (_todoList.isNotEmpty) ...[
                    Card(
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: ListView.builder(
                        itemCount: notfinishedList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final todo = notfinishedList[index];
                          final isDone = todo['is_done'] == 1;

                          if (settings.removeMethod == "gesture") {
                            return Dismissible(
                              key: Key(todo['id'].toString()),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete'),
                                    content:
                                        const Text('Are you sure to delete?'),
                                    actions: [
                                      TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () =>
                                              Navigator.pop(context, true)),
                                      TextButton(
                                          child: const Text("No"),
                                          onPressed: () =>
                                              Navigator.pop(context, false)),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) {
                                _deleteTodo(todo['id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Deleted"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              background: Container(
                                color: Theme.of(context).colorScheme.error,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.onError,
                                    ),
                                    Icon(
                                      Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.onError,
                                    ),
                                  ],
                                ),
                              ),
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 1),
                                elevation: 0,
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
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      _createRoute(
                                        EditPage(
                                          todoId: Future.value(todo["id"]),
                                        ),
                                      ),
                                    );
                                    if (!mounted) return;
                                    if (result) {
                                      _listTodos(tdl.sort, tdl.filter);
                                    }
                                  },
                                  leading: Checkbox(
                                    value: isDone,
                                    onChanged: (value) => _toggleTodoStatus(
                                        todo["id"], value! ? 1 : 0),
                                  ),
                                  title: Text(
                                    todo['title'],
                                    style: TextStyle(
                                        decoration: todo["is_done"] == 1
                                            ? TextDecoration.lineThrough
                                            : null),
                                  ),
                                ),
                              ),
                            );
                          } else if (settings.removeMethod == "button") {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 1),
                              elevation: 0,
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
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    _createRoute(
                                      EditPage(
                                        todoId: Future.value(todo["id"]),
                                      ),
                                    ),
                                  );
                                  if (!mounted) return;
                                  if (result) {
                                    _listTodos(tdl.sort, tdl.filter);
                                  }
                                },
                                leading: Checkbox(
                                  value: isDone,
                                  onChanged: (value) => _toggleTodoStatus(
                                      todo["id"], value! ? 1 : 0),
                                ),
                                title: Text(
                                  todo['title'],
                                  style: TextStyle(
                                      decoration: todo["is_done"] == 1
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete'),
                                        content: const Text(
                                            'Are you sure to delete?'),
                                        actions: [
                                          TextButton(
                                              child: const Text("Yes"),
                                              onPressed: () {
                                                Navigator.pop(context, true);

                                                _deleteTodo(todo["id"]);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text("Deleted"),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ),
                                                );
                                              }),
                                          TextButton(
                                              child: const Text("No"),
                                              onPressed: () => Navigator.pop(
                                                  context, false)),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            );
                          }

                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ExpansionTile(
                        title: Text("Completed ${completedList.length}"),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Card(
                              elevation: 0,
                              clipBehavior: Clip.antiAlias,
                              color: Colors.transparent,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              child: ListView.builder(
                                itemCount: completedList.length,
                                shrinkWrap: true,
                                clipBehavior: Clip.antiAlias,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final todo = completedList[index];
                                  final isDone = todo['is_done'] == 1;

                                  if (settings.removeMethod == "gesture") {
                                    return Dismissible(
                                      key: Key(todo['id'].toString()),
                                      onDismissed: (direction) {
                                        _deleteTodo(todo['id']);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text("Deleted"),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      background: Container(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onError,
                                            ),
                                            Icon(
                                              Icons.delete,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onError,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 1),
                                        elevation: 0,
                                        child: ListTile(
                                          tileColor: Color(CorePalette.of(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .value)
                                              .neutral
                                              .get(Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? 98
                                                  : 17)),
                                          onTap: () async {
                                            final result = await Navigator.push(
                                              context,
                                              _createRoute(
                                                EditPage(
                                                  todoId:
                                                      Future.value(todo["id"]),
                                                ),
                                              ),
                                            );
                                            if (!mounted) return;
                                            if (result) {
                                              _listTodos(tdl.sort, tdl.filter);
                                            }
                                          },
                                          leading: Checkbox(
                                            value: isDone,
                                            onChanged: (value) =>
                                                _toggleTodoStatus(
                                                    todo["id"], value! ? 1 : 0),
                                          ),
                                          title: Text(
                                            todo['title'],
                                            style: TextStyle(
                                                decoration: todo["is_done"] == 1
                                                    ? TextDecoration.lineThrough
                                                    : null),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (settings.removeMethod ==
                                      "button") {
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 1),
                                      elevation: 0,
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
                                        onTap: () async {
                                          final result = await Navigator.push(
                                            context,
                                            _createRoute(
                                              EditPage(
                                                todoId:
                                                    Future.value(todo["id"]),
                                              ),
                                            ),
                                          );
                                          if (!mounted) return;
                                          if (result) {
                                            _listTodos(tdl.sort, tdl.filter);
                                          }
                                        },
                                        leading: Checkbox(
                                          value: isDone,
                                          onChanged: (value) =>
                                              _toggleTodoStatus(
                                                  todo["id"], value! ? 1 : 0),
                                        ),
                                        title: Text(
                                          todo['title'],
                                          style: TextStyle(
                                              decoration: todo["is_done"] == 1
                                                  ? TextDecoration.lineThrough
                                                  : null),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            _deleteTodo(todo["id"]);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text("Deleted"),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.close),
                                        ),
                                      ),
                                    );
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (_todoList.isEmpty)
                    const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'The list is empty. Click ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Icon(Icons.add),
                          Text(
                            ' to add a todo',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog.fullscreen(
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  body: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 16.0),
                      child: TextField(
                        controller: _titleController,
                        onChanged: (value) {},
                        autofocus: true,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Title"),
                      ),
                    ),
                    const Divider(),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      child: Row(
                        children: [Chip(label: Text("label"))],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: Column(
                        children: [
                          ZefyrToolbar.basic(controller: _zefyrController),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 16.0),
                              child: Scrollbar(
                                child: ZefyrEditor(
                                  controller: _zefyrController,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      if (_titleController.text != '') {
                        Navigator.pop(context);
                        _addTodo(_titleController.text,
                            jsonEncode(_zefyrController.document.toJson()));
                        _titleController.clear();
                        _zefyrController = ZefyrController(
                            NotusDocument.fromJson(
                                jsonDecode(r"""[{"insert":"\n"}]""")));
                      } else {
                        null;
                      }
                    },
                    child: const Icon(Icons.done_rounded),
                  ),
                ),
              );
            },
          );

          /* showModalBottomSheet(
            isScrollControlled: true,
            showDragHandle: true,
            context: context,
            useRootNavigator: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  height: 108,
                  child: ListTile(
                    leading: const Icon(Icons.text_fields),
                    title: TextField(
                      controller: _textEditingController,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      autofocus: true,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        if (_textEditingController.text != '') {
                          Navigator.pop(context);
                          _addTodo(_textEditingController.text);
                          _textEditingController.clear();
                        } else {
                          null;
                        }
                      },
                      icon: const Icon(Icons.done),
                    ),
                  ),
                ),
              );
            },
          ).whenComplete(() => _textEditingController.clear()); */
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/