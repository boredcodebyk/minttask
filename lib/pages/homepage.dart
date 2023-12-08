import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/pages/archive.dart';
import 'package:minttask/pages/ui/snooze_ui.dart';
import 'package:provider/provider.dart';
import '../model/db_model.dart';
import '../model/settings_model.dart';
import '../utils/utils.dart';
import 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.receivedAction});
  final ReceivedAction? receivedAction;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int screenIndex = 0;
  late bool showNavigationDrawer;
  String notificationbuttonkeypressed = "";

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
    Navigator.pop(context);
  }

  void deleteafter30d() async {
    var today = DateTime.now();
    final isarInstance = IsarHelper.instance;

    final trashList = await isarInstance.listTrash().toList();

    if (trashList.first.isNotEmpty) {
      for (var element in trashList.first) {
        final difference = today.difference(element.dateModified!).inDays;
        print(difference);
        if (difference > 30) {
          isarInstance.deleteTask(element.id!);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.receivedAction != null) {
      setState(() {
        notificationbuttonkeypressed = widget.receivedAction!.buttonKeyPressed;
      });
    }
    //deleteafter30d();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TodoListModel tdl = Provider.of<TodoListModel>(context);
    if (notificationbuttonkeypressed.split("_").first == "done") {
      IsarHelper.instance.markTaskDone(
          int.parse(notificationbuttonkeypressed.split("_").last), true);
    } else if (notificationbuttonkeypressed.split("_").first == "snooze") {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        await showDialog(
            context: context,
            builder: (context) =>
                SnoozeUI(receivedActionData: widget.receivedAction!));
      });
    }
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(
          CorePalette.of(Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
      drawer: NavigationDrawer(
        onDestinationSelected: handleScreenChanged,
        selectedIndex: screenIndex,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Mint Task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...destinations.map(
            (NavDest destination) {
              return NavigationDrawerDestination(
                label: Text(destination.label),
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: SizedBox(
              height: 56,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        createRouteSharedAxisTransition(const SettingsPage()));
                    scaffoldKey.currentState!.closeDrawer();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.settings_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Settings",
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            leading: IconButton(
                onPressed: () => scaffoldKey.currentState!.openDrawer(),
                icon: const Icon(Icons.menu_open_rounded)),
            title: Text(destinations[screenIndex].label),
            backgroundColor: Color(
                CorePalette.of(Theme.of(context).colorScheme.primary.value)
                    .neutral
                    .get(Theme.of(context).brightness == Brightness.light
                        ? 92
                        : 10)),
            actions: [
              IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      createRouteSharedAxisTransition(NotifyAction(
                        receivedAction: widget.receivedAction,
                      ))),
                  icon: const Icon(Icons.deblur_outlined)),
              IconButton(
                  onPressed: () => showSearch(
                      context: context, delegate: ListSearchDelegate()),
                  icon: const Icon(Icons.search)),
              if (screenIndex != 1 && screenIndex != 2)
                IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onPressed: () async => await showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              elevation: 0,
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  RadioListTile(
                                    value: SortList.id,
                                    groupValue: tdl.sort,
                                    onChanged: (value) {
                                      tdl.sort = value!;
                                    },
                                    title: const Text("Default"),
                                  ),
                                  RadioListTile(
                                    value: SortList.title,
                                    groupValue: tdl.sort,
                                    onChanged: (value) {
                                      tdl.sort = value!;
                                    },
                                    title: const Text("Title"),
                                  ),
                                  RadioListTile(
                                    value: SortList.dateCreated,
                                    groupValue: tdl.sort,
                                    onChanged: (value) {
                                      tdl.sort = value!;
                                    },
                                    title: const Text("Date Created"),
                                  ),
                                  RadioListTile(
                                    value: SortList.dateModified,
                                    groupValue: tdl.sort,
                                    onChanged: (value) {
                                      tdl.sort = value!;
                                    },
                                    title: const Text("Date Modified"),
                                  ),
                                  const Divider(),
                                  RadioListTile(
                                    value: FilterList.asc,
                                    groupValue: tdl.filter,
                                    onChanged: (value) {
                                      tdl.filter = value!;
                                    },
                                    title: const Text("Ascending"),
                                  ),
                                  RadioListTile(
                                    value: FilterList.desc,
                                    groupValue: tdl.filter,
                                    onChanged: (value) {
                                      tdl.filter = value!;
                                    },
                                    title: const Text("Descending"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FilledButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Done")),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 84),
              child: [
                const MainListView(),
                const ArchivePage(),
                const TrashCan()
              ].elementAt(screenIndex),
            ),
          )
        ],
      ),
      floatingActionButton: screenIndex == 0
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              heroTag: "drawerIconToBackIcon",
              onPressed: () {
                Navigator.push(
                  context,
                  createRouteSharedAxisTransition(
                    const AddTaskBox(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class NavDest {
  const NavDest(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<NavDest> destinations = <NavDest>[
  NavDest(
    'Home',
    Icon(Icons.home_outlined),
    Icon(Icons.home_rounded),
  ),
  NavDest(
    'Archive',
    Icon(Icons.archive_outlined),
    Icon(Icons.archive_rounded),
  ),
  NavDest(
    'Trash',
    Icon(Icons.delete_outline_rounded),
    Icon(Icons.delete_rounded),
  ),
];
