import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/model/db_model.dart';
import 'package:provider/provider.dart';
import './pages.dart';
import 'ui/listbuilder_ui.dart';

class ListSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        toolbarHeight: 72,
        elevation: 1,
        shape: LinearBorder.bottom(size: 1),
        systemOverlayStyle: colorScheme.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        backgroundColor: Color(CorePalette.of(
                Theme.of(context).colorScheme.primary.value)
            .neutral
            .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
        titleTextStyle: theme.textTheme.titleLarge,
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      scaffoldBackgroundColor: colorScheme.brightness == Brightness.dark
          ? colorScheme.surface
          : Color(CorePalette.of(Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(92)),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Stream<List<TaskData>> searchBuild() async* {
      final isarInstance = await IsarHelper.instance.isar;
      final queryBuild = isarInstance.taskDatas.where().filter().group((q) => q
          .titleMatches(query, caseSensitive: false)
          .xor()
          .descriptionMatches(query, caseSensitive: false)
          .xor()
          .titleContains(query, caseSensitive: false)
          .xor()
          .descriptionContains(query, caseSensitive: false));
      await for (final results in queryBuild.watch(fireImmediately: true)) {
        if (results.isNotEmpty) {
          yield results;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder(
        stream: searchBuild(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (snapshot.data!.isEmpty) {
            return const Column(
              children: <Widget>[
                Text(
                  "No Results Found.",
                ),
              ],
            );
          } else {
            var results = snapshot.data;
            return ListBuilder(
              itemCount: results!.length,
              itemBuilder: (context, index) {
                var result = results[index];
                return ListViewCardSearch(
                  id: result.id!,
                  doneStatus: result.doneStatus!,
                  taskTitle: result.title!,
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Stream<List<TaskData>> searchBuild() async* {
      final isarInstance = await IsarHelper.instance.isar;
      final queryBuild = isarInstance.taskDatas.where().filter().group((q) => q
          .titleMatches(query, caseSensitive: false)
          .xor()
          .descriptionMatches(query, caseSensitive: false)
          .xor()
          .titleContains(query, caseSensitive: false)
          .xor()
          .descriptionContains(query, caseSensitive: false));
      await for (final results in queryBuild.watch(fireImmediately: true)) {
        if (results.isNotEmpty) {
          yield results;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder(
        stream: searchBuild(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var results = snapshot.data;
            return ListBuilder(
              itemCount: results!.length,
              itemBuilder: (context, index) {
                var result = results[index];
                return ListViewCardSearch(
                  id: result.id!,
                  doneStatus: result.doneStatus!,
                  taskTitle: result.title!,
                );
              },
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.search,
                    color: Color(CorePalette.of(
                            Theme.of(context).colorScheme.primary.value)
                        .neutral
                        .get(Theme.of(context).brightness == Brightness.light
                            ? 84
                            : 17)),
                    size: 64,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class ListViewCardSearch extends ListTile {
  const ListViewCardSearch({
    super.key,
    required this.id,
    required this.taskTitle,
    required this.doneStatus,
  });
  final int id;
  final String taskTitle;
  final bool doneStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
      child: OpenContainer(
        closedElevation: 0,
        closedColor: Color(CorePalette.of(
                Theme.of(context).colorScheme.primary.value)
            .neutral
            .get(Theme.of(context).brightness == Brightness.light ? 98 : 17)),
        clipBehavior: Clip.antiAlias,
        closedBuilder: (context, action) => ListTile(
          tileColor: Color(CorePalette.of(
                  Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 98 : 17)),
          onTap: () async {
            action();
          },
          leading: Checkbox(
            value: doneStatus,
            onChanged: (value) => IsarHelper.instance.markTaskDone(id, value!),
          ),
          title: Text(
            taskTitle,
            style: TextStyle(
                decoration: doneStatus ? TextDecoration.lineThrough : null),
          ),
        ),
        openBuilder: (context, action) => EditPage(todoId: id),
      ),
    );
  }
}
