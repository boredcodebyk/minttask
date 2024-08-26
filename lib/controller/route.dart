import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/views.dart';

final rootRouteProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  return rootNavigatorKey;
});

final shellRouteProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');
  return shellNavigatorKey;
});

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: ref.watch(rootRouteProvider),
    initialLocation: "/",
    debugLogDiagnostics: true,

    routes: [
      ShellRoute(
        navigatorKey: ref.watch(shellRouteProvider),
        builder: (context, state, child) => BaseView(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: HomeView(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // Change the opacity of the screen using a Curve based on the the animation's
                  // value
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: '/list/:id',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: SubListView(
                    taskID: int.tryParse(state.pathParameters['id']!)!),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // Change the opacity of the screen using a Curve based on the the animation's
                  // value
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/new',
        builder: (context, state) => const EditView(
          editState: EditState.newTask,
        ),
      ),
      GoRoute(
        path: '/task/:id',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: EditView(
              editState: EditState.editTask,
              taskID: int.tryParse(state.pathParameters['id']!)),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          ),
        ),
      ),
    ],
    // redirect: (context, state) {
    //   if (!ref.watch(runSetup)) {
    //     "continue";
    //   } else {
    //     return '/';
    //   }
    // },
  );
  return router;
});
