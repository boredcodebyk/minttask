import 'package:flutter/material.dart';
import 'package:minttask/model/task.dart';

import 'listitemcard.dart';

class ListViewCard extends StatelessWidget {
  const ListViewCard({super.key, required this.list});

  final List<Task> list;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (context, index) => Divider(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.surfaceContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          height: 2,
        ),
        itemBuilder: (context, index) {
          var task = list[index];
          return ListItemCard(
            task: task,
          );
        },
      ),
    );
  }
}
