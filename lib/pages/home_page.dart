import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';

import '../models/settings_model.dart';
import 'pages.dart';

import '../models/db.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, TextEditingController> textEditingControllers = {};
  Map<int, bool> isEditing = {};
  List<Map<String, dynamic>> _todoList = [];
  final TextEditingController _textEditingController = TextEditingController();
  Map<String, String> filter_col = {"sortby": "", "filter": ""};
  Future<void> _listTodos(col, filter) async {
    final dbHelper = DatabaseHelper.instance;
    final todolist = await dbHelper.getTodos(col, filter);

    setState(() {
      _todoList = todolist;
    });
  }

  Future<void> _addTodo(String title) async {
    final newTodo = {
      'title': title,
      'description': "",
      'is_done': 0,
      'date_created': DateTime.now().millisecondsSinceEpoch,
      'date_modified': DateTime.now().millisecondsSinceEpoch
    };
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insertTodo(newTodo);
    await _listTodos(filter_col["sortby"], filter_col["filter"]);
  }

  Future<void> _toggleTodoStatus(int id, int isDone) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateTodoStauts(
        id, isDone, DateTime.now().millisecondsSinceEpoch);
    await _listTodos(filter_col["sortby"], filter_col["filter"]);
  }

  Future<void> _deleteTodo(int id) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteTodo(id);
    await _listTodos(filter_col["sortby"], filter_col["filter"]);
  }

  @override
  void initState() {
    super.initState();
    TodoListModel tdl = context.read<TodoListModel>();

    setState(() {
      filter_col["sortby"] = tdl.sort;
      filter_col["filter"] = tdl.filter;
    });

    _listTodos(filter_col["sortby"], filter_col["filter"]);
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
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
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("Mint Task"),
            actions: [
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        RadioListTile.adaptive(
                          value: "id",
                          groupValue: tdl.sort,
                          onChanged: (value) {
                            tdl.sort = value!;
                            _listTodos(value, tdl.filter);
                            Navigator.pop(context);
                          },
                          title: const Text("Default (order by ID)"),
                        ),
                        RadioListTile.adaptive(
                          value: "title",
                          groupValue: tdl.sort,
                          onChanged: (value) {
                            tdl.sort = value!;
                            _listTodos(value, tdl.filter);
                            Navigator.pop(context);
                          },
                          title: const Text("Title"),
                        ),
                        RadioListTile.adaptive(
                          value: "date_created",
                          groupValue: tdl.sort,
                          onChanged: (value) {
                            tdl.sort = value!;
                            _listTodos(value, tdl.filter);
                            Navigator.pop(context);
                          },
                          title: const Text("Date Created"),
                        ),
                        RadioListTile.adaptive(
                          value: "date_modified",
                          groupValue: tdl.sort,
                          onChanged: (value) {
                            tdl.sort = value!;
                            _listTodos(value, tdl.filter);
                            Navigator.pop(context);
                          },
                          title: const Text("Date Modified"),
                        ),
                      ],
                    ),
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
                        RadioListTile.adaptive(
                          value: "asc",
                          groupValue: tdl.filter,
                          onChanged: (value) {
                            tdl.filter = value!;
                            _listTodos(tdl.sort, value);
                            Navigator.pop(context);
                          },
                          title: const Text("Ascending"),
                        ),
                        RadioListTile.adaptive(
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
                    ListView.builder(
                      itemCount: notfinishedList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final todo = notfinishedList[index];
                        final isDone = todo['is_done'] == 1;

                        if (settings.removeMethod == "gesture") {
                          return Dismissible(
                            key: Key(todo['id'].toString()),
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
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                            child: ListTile(
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
                          );
                        } else if (settings.removeMethod == "button") {
                          return ListTile(
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
                              onChanged: (value) =>
                                  _toggleTodoStatus(todo["id"], value! ? 1 : 0),
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Deleted"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.close),
                            ),
                          );
                        }

                        return null;
                      },
                    ),
                    ExpansionTile(
                      title: Text("Completed ${completedList.length}"),
                      children: [
                        ListView.builder(
                          itemCount: completedList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final todo = completedList[index];
                            final isDone = todo['is_done'] == 1;

                            if (settings.removeMethod == "gesture") {
                              return Dismissible(
                                key: Key(todo['id'].toString()),
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
                                child: ListTile(
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
                              );
                            } else if (settings.removeMethod == "button") {
                              return ListTile(
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
                                    _deleteTodo(todo["id"]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Deleted"),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              );
                            }

                            return null;
                          },
                        ),
                      ],
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
        onPressed: () {
          showModalBottomSheet(
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
          ).whenComplete(() => _textEditingController.clear());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
