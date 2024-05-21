import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/controller/filehandle.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';
import 'package:minttask/view/components/new_dialog.dart';
import 'package:minttask/view/components/todo_listview.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
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
                  if (ref.watch(todotxtFilePathProvider).isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
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
                    if (ref.watch(todoListProvider).isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TodoListview(
                            listItem: ref.watch(todoListProvider)!),
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
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
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
                          onTap: () async => showDialog(
                            context: context,
                            builder: (context) => const NewDialog(),
                          ),
                          leading: const Icon(Icons.add_box_outlined),
                          title: const Text("Create"),
                          subtitle: const Text("Create new todo.txt workspace"),
                          trailing: const Icon(Icons.chevron_right_outlined),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
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
                          onTap: () =>
                              ref.read(rawFileProvider.notifier).openFile(),
                          leading: const Icon(Icons.file_open_outlined),
                          title: const Text("Open"),
                          subtitle: const Text("Open a todo.txt workspace"),
                          trailing: const Icon(Icons.chevron_right_outlined),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: (ref.watch(todotxtFilePathProvider).isNotEmpty)
          ? FloatingActionButton(
              onPressed: () => context.push('/newtodo'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
