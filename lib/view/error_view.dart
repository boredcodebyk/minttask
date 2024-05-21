import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minttask/controller/error_provider.dart';

class ErrorView extends ConsumerWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline),
              const Text("Error has occured"),
              Text(ref.watch(errorProvider)),
            ],
          ),
          FilledButton(
              onPressed: () {
                context.go('/');
              },
              child: Text("Clean state and relaunch"))
        ],
      ),
    );
  }
}
