import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/todosettings.dart';

import '../controller/db.dart';
import '../controller/tasklist.dart';
import '../model/task.dart';
import 'components/listview.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  Future<void> updateTodos(sortbycol, filter) async {
    final dbHelper = DatabaseHelper.instance;
    final todolist = await dbHelper.getTodos(sortbycol, filter);

    ref.read(taskListProvider.notifier).state = todolist
        .map(
          (e) => Task.fromJson(e),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateTodos(ref.watch(filterProvider).name, ref.watch(sortProvider).name);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              "Home",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                avatar: const Icon(Icons.sort),
                label: const Text("Sort"),
                onPressed: () => showDialog(
                    context: context, builder: (context) => const SortDialog()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                avatar: const Icon(Icons.filter_alt_outlined),
                label: const Text("Filter"),
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const FilterDialog()),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: const Text("Hide Done"),
                  selected: ref.watch(hideCompleted),
                  onSelected: (value) =>
                      ref.read(hideCompleted.notifier).state = value,
                )),
          ],
        ),
      ),
      if (ref.watch(hideCompleted)) ...[
        notDone(),
        ExpansionTile(
          title: Text("Completed"),
          children: [done()],
        ),
      ] else ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ListViewCard(list: ref.watch(taskListProvider)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 36,
          ),
          child: Text(
            ref.watch(taskListProvider).isNotEmpty
                ? "That's all!"
                : "It's lonely here.",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.outline),
          ),
        )
      ]
    ]);
  }

  Widget done() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ListViewCard(
              list:
                  ref.watch(taskListProvider).where((e) => e.isDone!).toList()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 36,
          ),
          child: Text(
            ref
                    .watch(taskListProvider)
                    .where((e) => e.isDone!)
                    .toList()
                    .isNotEmpty
                ? "That's all!"
                : "It's lonely here.",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.outline),
          ),
        )
      ],
    );
  }

  Widget notDone() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ListViewCard(
              list: ref
                  .watch(taskListProvider)
                  .where((e) => !e.isDone!)
                  .toList()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 36,
          ),
          child: Text(
            ref
                    .watch(taskListProvider)
                    .where((e) => !e.isDone!)
                    .toList()
                    .isNotEmpty
                ? "That's all!"
                : "It's lonely here.",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.outline),
          ),
        )
      ],
    );
  }
}

class SortDialog extends ConsumerStatefulWidget {
  const SortDialog({super.key});

  @override
  ConsumerState<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends ConsumerState<SortDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surfaceContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      title: const Text("Sort"),
      content: SizedBox(
        width: double.maxFinite,
        child: Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.surfaceContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              height: 2,
            ),
            itemCount: Sort.values.length,
            itemBuilder: (context, index) {
              var sortType = Sort.values[index];
              return RadioListTile(
                tileColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surfaceContainerHigh
                    : Theme.of(context).colorScheme.surfaceContainerLowest,
                title: Text(sortType.sortName),
                value: sortType,
                groupValue: ref.watch(sortProvider),
                onChanged: (value) {
                  setState(
                      () => ref.read(sortProvider.notifier).state = value!);
                },
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"))
      ],
    );
  }
}

class FilterDialog extends ConsumerStatefulWidget {
  const FilterDialog({super.key});

  @override
  ConsumerState<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends ConsumerState<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surfaceContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      title: const Text("Filter"),
      content: SizedBox(
        width: double.maxFinite,
        child: Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.surfaceContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              height: 2,
            ),
            itemCount: Filter.values.length,
            itemBuilder: (context, index) {
              var filterType = Filter.values[index];
              return RadioListTile(
                tileColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surfaceContainerHigh
                    : Theme.of(context).colorScheme.surfaceContainerLowest,
                title: Text(filterType.filterName),
                value: filterType,
                groupValue: ref.watch(filterProvider),
                onChanged: (value) {
                  setState(
                      () => ref.read(filterProvider.notifier).state = value!);
                },
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"))
      ],
    );
  }
}
