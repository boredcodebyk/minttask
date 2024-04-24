import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_color_utilities/palettes/core_palette.dart';
import 'package:minttask/components/createworkspace_dir.dart';
import 'package:minttask/components/listitemcard.dart';
import 'package:minttask/model/file_model.dart';
import 'package:minttask/model/pagetransition.dart';
import 'package:minttask/model/todo_provider.dart';
import 'package:minttask/model/todotxt_parser.dart';

class ContextTagListPage extends ConsumerWidget {
  const ContextTagListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("data"),
        ),
        ref.watch(workspaceConfigStateProvider).contexts!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(bottom: 96.0),
                child: Card(
                  elevation: 0,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.transparent,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: ref
                        .watch(workspaceConfigStateProvider)
                        .contexts!
                        .length,
                    itemBuilder: (context, index) {
                      var item = ref
                          .watch(workspaceConfigStateProvider)
                          .contexts![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 1),
                        child: ListTile(
                          tileColor: Color(CorePalette.of(
                                  Theme.of(context).colorScheme.primary.value)
                              .neutral
                              .get(Theme.of(context).colorScheme.brightness ==
                                      Brightness.light
                                  ? 98
                                  : 17)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                              context,
                              createRouteSharedAxisTransition(
                                  FilterByListContextTagPage(
                                      contextTagData: item))),
                          title: Text(item.title!),
                        ),
                      );
                    },
                  ),
                ),
              )
            : const Text("Empty"),
      ],
    );
  }
}

class FilterByListContextTagPage extends ConsumerWidget {
  const FilterByListContextTagPage({super.key, required this.contextTagData});

  final ContextTag contextTagData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color(
          CorePalette.of(Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            backgroundColor: Color(
                CorePalette.of(Theme.of(context).colorScheme.primary.value)
                    .neutral
                    .get(Theme.of(context).brightness == Brightness.light
                        ? 92
                        : 10)),
            title: Text(contextTagData.title!),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contextTagData.description!),
                ref.watch(filePathProvider).isNotEmpty
                    ? ref
                            .watch(todoListProvider)
                            .where((element) => TaskParser()
                                .parser(element)
                                .contextTag!
                                .contains(contextTagData.title))
                            .toList()
                            .isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 96),
                            child: Card(
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.transparent,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                clipBehavior: Clip.antiAlias,
                                padding: EdgeInsets.zero,
                                itemCount: ref
                                    .watch(todoListProvider)
                                    .where((element) => TaskParser()
                                        .parser(element)
                                        .contextTag!
                                        .contains(contextTagData.title))
                                    .toList()
                                    .length,
                                itemBuilder: (context, index) {
                                  var todo = ref
                                      .watch(todoListProvider)
                                      .where((element) => TaskParser()
                                          .parser(element)
                                          .contextTag!
                                          .contains(contextTagData.title))
                                      .toList()[index];
                                  var isSelected =
                                      ref.watch(selectedItem).contains(index);
                                  return ListItemCard(
                                      todo: todo,
                                      todoIndex: index,
                                      isSelected: isSelected);
                                },
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: const Text("Empty"),
                          )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome to Mint task\n",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const Text(
                                "Goto home tab to open or creat a new workspace.")
                          ],
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
