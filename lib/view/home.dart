import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/model/dummy.dart';
import 'package:minttask/view/components/todo_listview.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var dummylist =
      List.generate(10, (index) => index * index + 1, growable: true);
  var dummytextlist = text.trim().split('\n');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surfaceContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: const Text("Home"),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.surfaceContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            leading: IconButton(
              onPressed: () => context.push('/settingsview'),
              icon: const Icon(Icons.settings_outlined),
            ),
            actions: [
              IconButton(
                  onPressed: () => context.push("/test"),
                  icon: const Icon(Icons.safety_check))
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: Card(
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color:
                                Theme.of(context).colorScheme.outlineVariant),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        onTap: () => context.push('/archive'),
                        leading: const Icon(Icons.archive_outlined),
                        title: const Text("Archive"),
                        subtitle: const Text("View archived tasks"),
                        trailing: const Icon(Icons.chevron_right_outlined),
                      ),
                    ),
                  ),
                  if (dummytextlist.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TodoListview(listItem: dummytextlist),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        "That's all!",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color:
                                Theme.of(context).colorScheme.outlineVariant),
                      ),
                    )
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        "So empty",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color:
                                Theme.of(context).colorScheme.outlineVariant),
                      ),
                    )
                  ]
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
