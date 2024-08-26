import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controller/db.dart';
import '../controller/tasklist.dart';
import '../model/customlist.dart';

class BaseView extends ConsumerStatefulWidget {
  const BaseView({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends ConsumerState<BaseView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Future<void> updateCustomList() async {
    final dbHelper = DatabaseHelper.instance;
    final customlist = await dbHelper.getCustomList();

    ref.read(customListProvider.notifier).state = customlist
        .map(
          (e) => CustomList.fromJson(e),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    updateCustomList();

    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surfaceContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.surfaceContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            leading: IconButton(
                onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
            actions: [
              IconButton(
                  onPressed: () => _key.currentState!.openEndDrawer(),
                  icon: const Icon(Icons.menu_open)),
            ],
          ),
          SliverToBoxAdapter(
            child: widget.child,
          )
        ],
      ),
      endDrawer: Drawer(
        child: ListView(shrinkWrap: true, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 64,
              child: TextButton(
                  onPressed: () {
                    context.go("/");
                    _key.currentState!.closeEndDrawer();
                  },
                  style: ButtonStyle(
                    backgroundColor: GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .last
                                .matchedLocation ==
                            "/"
                        ? WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.secondaryContainer)
                        : const WidgetStatePropertyAll(Colors.transparent),
                    foregroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.onSurfaceVariant),
                    textStyle:
                        Theme.of(context).navigationDrawerTheme.labelTextStyle,
                  ),
                  child: Row(
                    children: [
                      Icon(GoRouter.of(context)
                                  .routerDelegate
                                  .currentConfiguration
                                  .last
                                  .matchedLocation ==
                              "/"
                          ? Icons.home
                          : Icons.home_outlined),
                      const SizedBox(width: 12),
                      const Text("Home"),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(Icons.list),
                    SizedBox(width: 12),
                    Text("Custom List"),
                  ],
                ),
                IconButton(
                    onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController textEditingController =
                                TextEditingController();
                            return AlertDialog(
                              title: const Text("Custom List"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    autofocus: true,
                                    controller: textEditingController,
                                    decoration: const InputDecoration.collapsed(
                                        hintText: "Name"),
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Close"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (textEditingController.text.isNotEmpty) {
                                      final dbHelper = DatabaseHelper.instance;
                                      await dbHelper.addCustomList(
                                          textEditingController.text.trim());
                                      if (!mounted) return;
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text("Add"),
                                )
                              ],
                            );
                          },
                        ),
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
          ...ref.watch(customListProvider).map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 64,
                    child: TextButton(
                        onPressed: () {
                          context.push('/list/${e.id}');
                          _key.currentState!.closeEndDrawer();
                        },
                        style: ButtonStyle(
                          backgroundColor: GoRouter.of(context)
                                      .routerDelegate
                                      .currentConfiguration
                                      .last
                                      .matchedLocation ==
                                  "/list/${e.id}"
                              ? WidgetStatePropertyAll(Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer)
                              : const WidgetStatePropertyAll(
                                  Colors.transparent),
                          foregroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.onSurfaceVariant),
                          textStyle: Theme.of(context)
                              .navigationDrawerTheme
                              .labelTextStyle,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.list_alt),
                            const SizedBox(width: 12),
                            Text(e.name!),
                          ],
                        )),
                  ),
                ),
              ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
