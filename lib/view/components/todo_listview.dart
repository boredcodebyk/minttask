import 'package:flutter/material.dart';
import 'package:minttask/model/task_model.dart';
import 'package:minttask/view/components/todo_list_item.dart';

class TodoListview extends StatelessWidget {
  const TodoListview({super.key, required this.listItem});

  final List<TaskText> listItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listItem.length,
        itemBuilder: (context, index) {
          var item = listItem[index];
          return TodoListItem(
            todoIndex: index,
            listItem: item,
          );
        },
      ),
    );
  }
}
