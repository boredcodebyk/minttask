import 'package:flutter/material.dart';
import 'package:minttask/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../model/settings_model.dart';

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class SwipeActionPage extends StatefulWidget {
  const SwipeActionPage({super.key});

  @override
  State<SwipeActionPage> createState() => _SwipeActionPageState();
}

class _SwipeActionPageState extends State<SwipeActionPage> {
  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar.large(
            title: Text("Swipe actions"),
          ),
          SliverToBoxAdapter(
            child: Column(children: [
              ListTile(
                title: const Text("Left swipe"),
                subtitle: Text(settings.leftSwipeAction
                    .toString()
                    .split(".")
                    .last
                    .capitalize()),
                onTap: () async => await showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            RadioListTile(
                              title: const Text("Trash"),
                              value: LeftSwipeAction.trash,
                              groupValue: settings.leftSwipeAction,
                              onChanged: (val) =>
                                  settings.leftSwipeAction = val!,
                            ),
                            RadioListTile(
                              title: const Text("Archive"),
                              value: LeftSwipeAction.archive,
                              groupValue: settings.leftSwipeAction,
                              onChanged: (val) =>
                                  settings.leftSwipeAction = val!,
                            ),
                            RadioListTile(
                              title: const Text("Pin"),
                              value: LeftSwipeAction.pin,
                              groupValue: settings.leftSwipeAction,
                              onChanged: (val) =>
                                  settings.leftSwipeAction = val!,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              ListTile(
                title: const Text("Right swipe"),
                subtitle: Text(settings.rightSwipeAction
                    .toString()
                    .split(".")
                    .last
                    .capitalize()),
                onTap: () async => await showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            RadioListTile(
                              title: const Text("Trash"),
                              value: RightSwipeAction.trash,
                              groupValue: settings.rightSwipeAction,
                              onChanged: (val) =>
                                  settings.rightSwipeAction = val!,
                            ),
                            RadioListTile(
                              title: const Text("Archive"),
                              value: RightSwipeAction.archive,
                              groupValue: settings.rightSwipeAction,
                              onChanged: (val) =>
                                  settings.rightSwipeAction = val!,
                            ),
                            RadioListTile(
                              title: const Text("Pin"),
                              value: RightSwipeAction.pin,
                              groupValue: settings.rightSwipeAction,
                              onChanged: (val) =>
                                  settings.rightSwipeAction = val!,
                            ),
                          ],
                        ),
                      );
                    }),
              )
            ]),
          )
        ],
      ),
    );
  }
}
