import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/controller/filehandle.dart';
import 'package:minttask/controller/todotxt_file_provider.dart';
import 'package:minttask/view/components/new_dialog.dart';

class ActivefileView extends ConsumerWidget {
  const ActivefileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar.large(
            title: Text("Active File"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("File path: ${ref.watch(todotxtFilePathProvider)}"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: FilledButton(
                        onPressed: () {
                          ref.read(todotxtFilePathProvider.notifier).state = "";
                          context.go('/');
                        },
                        child: const Text("Close")),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: FilledButton(
                        onPressed: () =>
                            ref.read(rawFileProvider.notifier).openFile(),
                        child: const Text("Open")),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: FilledButton(
                        onPressed: () async => showDialog(
                              context: context,
                              builder: (context) => const NewDialog(),
                            ),
                        child: const Text("New")),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
