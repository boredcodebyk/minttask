import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minttask/controller/permission_provider.dart';

class PermissionView extends ConsumerWidget {
  const PermissionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Request Permission"),
        FilledButton(
          onPressed: () =>
              ref.read(permissionProvider.notifier).requestPermission(),
          child: const Text("Request Permission"),
        ),
      ],
    );
  }
}
