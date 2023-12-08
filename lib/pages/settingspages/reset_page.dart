import 'package:flutter/material.dart';
import 'package:minttask/model/db_model.dart';
import 'package:minttask/pages/pages.dart';
import 'package:minttask/utils/transition.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final isarInstance = IsarHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar.large(
            title: Text("Reset"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "⚠️ Danger section!\nAre you sure you want to erase your entire database?\nMake sure to back up before else you can't recover erased tasks.",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 36, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 60,
                          child: FilledButton.tonal(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    createRouteSharedAxisTransition(
                                        const BackupPage()));
                              },
                              child: const Text("Backup")),
                        ),
                        SizedBox(
                          width: 120,
                          height: 60,
                          child: FilledButton(
                            onPressed: () {
                              isarInstance.resetDB();
                              Navigator.of(context).pop();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Done!"),
                                behavior: SnackBarBehavior.floating,
                              ));
                            },
                            style: FilledButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error),
                            child: const Text("Reset"),
                          ),
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
    );
  }
}
