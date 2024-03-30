import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:minttask/model/permission_provider.dart';
import 'package:minttask/model/settings_provider.dart';
import 'package:minttask/model/todo_provider.dart';
import 'package:minttask/page/addtodo.dart';
import 'package:minttask/page/archive_page.dart';
import 'package:minttask/page/home_page.dart';
import 'package:permission_handler/permission_handler.dart';

class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  final Permission _permission = Permission.manageExternalStorage;
  late PermissionStatus _permissionStatus = PermissionStatus.denied;
  late var pages = [const HomePage(), const ArchivePage()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _permission.status.then(updateStatus);
  }

  void loadFile() async {
    try {
      final todotxt = File(ref.read(filePathProvider.notifier).state);
      todotxt.readAsString().then(
          (value) => ref.read(todoContentProvider.notifier).state = value);
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_permissionStatus == PermissionStatus.granted) {
      loadFile();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _permission.status.then(updateStatus);
    }
  }

  void updateStatus(PermissionStatus status) {
    if (status != _permissionStatus) {
      setState(() {
        _permissionStatus = status;
      });
    }
  }

  void requestPermission() {
    _permission.request().then(updateStatus);
  }

  void onStatusRequested(status) {
    _permission.status.then((value) {
      if (value != PermissionStatus.granted) {
        openAppSettings();
      } else {
        updateStatus(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(ref.watch(filePathProvider));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: Color(
          CorePalette.of(Theme.of(context).colorScheme.primary.value)
              .neutral
              .get(Theme.of(context).brightness == Brightness.light ? 92 : 10)),
      drawer: NavigationDrawer(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
          scaffoldKey.currentState!.closeDrawer();
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text(
              "Mint Task",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          ...destinations.map(
            (e) => NavigationDrawerDestination(
              icon: e.icon,
              label: Text(e.title),
              selectedIcon: e.selectedIcon,
            ),
          ),
          SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  iconColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onSecondaryContainer),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
                      child: Icon(
                        Icons.settings_outlined,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(destinations[selectedIndex].title),
            backgroundColor: Color(
                CorePalette.of(Theme.of(context).colorScheme.primary.value)
                    .neutral
                    .get(Theme.of(context).brightness == Brightness.light
                        ? 92
                        : 10)),
            actions: [
              IconButton(
                  onPressed: () {
                    ref.read(filePathProvider.notifier).state = "";
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          SliverToBoxAdapter(
            child: _permissionStatus == PermissionStatus.granted
                ? pages[selectedIndex]
                : Center(
                    child: FilledButton(
                      onPressed: () => _permission.request(),
                      child: const Text("Request Permission"),
                    ),
                  ),
          )
        ],
      ),
      floatingActionButton: _permissionStatus == PermissionStatus.granted
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTodo(),
                  )),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class SubPage {
  const SubPage({required this.title, required this.icon, this.selectedIcon});
  final String title;
  final Widget icon;
  final Widget? selectedIcon;
}

const List<SubPage> destinations = [
  SubPage(
    title: "Home",
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
  ),
  SubPage(
    title: "Archive",
    icon: Icon(Icons.archive_outlined),
    selectedIcon: Icon(Icons.archive),
  ),
];
