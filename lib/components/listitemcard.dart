import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/model/todotxt_parser.dart';
import 'package:minttask/page/edit_page.dart';

class ListItemCard extends StatelessWidget {
  const ListItemCard(
      {super.key,
      required this.todo,
      required this.doneStatus,
      required this.todoIndex});

  final String todo;
  final bool doneStatus;
  final int todoIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
      child: OpenContainer(
        closedElevation: 0,
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: ContainerTransitionType.fadeThrough,
        closedColor: Color(
            CorePalette.of(Theme.of(context).colorScheme.primary.value)
                .neutral
                .get(
                    Theme.of(context).colorScheme.brightness == Brightness.light
                        ? 98
                        : 17)),
        clipBehavior: Clip.antiAlias,
        middleColor: Color(
            CorePalette.of(Theme.of(context).colorScheme.primary.value)
                .neutral
                .get(
                    Theme.of(context).colorScheme.brightness == Brightness.light
                        ? 98
                        : 17)),
        closedBuilder: (context, action) {
          return ListTile(
            isThreeLine: true,
            tileColor: Color(
                CorePalette.of(Theme.of(context).colorScheme.primary.value)
                    .neutral
                    .get(Theme.of(context).brightness == Brightness.light
                        ? 98
                        : 17)),
            onTap: () async {
              action();
            },
            leading: Checkbox(
                value: TodoTXTPraser().getCompletion(todo),
                onChanged: (value) {}),
            title: Text(
              TodoTXTPraser().getText(todo).trim(),
              style: TextStyle(
                  decoration: todo.split(" ").first == "x "
                      ? TextDecoration.lineThrough
                      : null),
            ),
            subtitle: Row(
              children: [
                ...TodoTXTPraser().getTags(todo).map((e) => Text(e)),
                ...TodoTXTPraser().getContext(todo).map((e) => Text(e)),
              ],
            ),
          );
        },
        openBuilder: (context, action) => EditPage(index: todoIndex),
      ),
    );
  }
}
