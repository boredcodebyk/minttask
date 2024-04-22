import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/components/createworkspace_dir.dart';
import 'package:minttask/components/listitemcard.dart';
import 'package:minttask/model/file_model.dart';
import 'package:minttask/model/todo_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ref.watch(filePathProvider).isNotEmpty
            ? ref.watch(todoListProvider).isNotEmpty
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
                        itemCount: ref.watch(todoListProvider).length,
                        itemBuilder: (context, index) {
                          var todo = ref.watch(todoListProvider)[index];
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
                : const Text("Empty")
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
                    FilledButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => const Dialog.fullscreen(
                              child: CreateWorkspaceDir()),
                        );
                      },
                      child: const Text("Create New Workspace"),
                    ),
                    FilledButton(
                      onPressed: () async {
                        var result = await FileManagementModel().openTextFile();

                        if (result.error == 687869) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                  "Folder does not contain \"todo.txt\" file")));
                        } else {
                          ref.read(configfilePathProvider.notifier).state =
                              result.result!.split(",")[0];
                          ref.read(filePathProvider.notifier).state =
                              result.result!.split(",")[1];
                        }
                      },
                      child: const Text("Open Existing Workspace"),
                    ),
                  ],
                ),
              )
      ],
    );
  }
}
