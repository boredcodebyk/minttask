import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/controller/permission_provider.dart';
import 'package:minttask/view/test.dart';
import 'package:minttask/view/views.dart';
import 'package:permission_handler/permission_handler.dart';

final routerProvider = Provider<GoRouter>((ref) {
  var permission = ref.watch(permissionProvider);
  final router = GoRouter(
    redirect: (context, state) {
      if (Platform.isAndroid) {
        if (permission != PermissionStatus.granted) {
          return '/permissionrequest';
        } else {
          return null;
        }
      } else {
        return null;
      }
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/test',
        builder: (context, state) => const TestView(),
      ),
      GoRoute(
        path: '/settingsview',
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
      GoRoute(
        path: '/settingsview/theme',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ThemeView(),
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
        path: '/todo/:id',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: TodoView(
                todoIndex: int.tryParse(state.pathParameters['id'] ?? "")!),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            ),
          );
        },
      ),
      GoRoute(
        path: '/archive',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ArchiveView(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            ),
          );
        },
      ),
      GoRoute(
        path: '/archive/:id',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: TodoView(
                todoIndex: int.tryParse(state.pathParameters['id'] ?? "")!),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            ),
          );
        },
      ),
      GoRoute(
        path: '/permissionrequest',
        builder: (context, state) => const PermissionView(),
      ),
    ],
  );
  return router;
});
