import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ArchiveView extends StatelessWidget {
  const ArchiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            leading: IconButton(
                onPressed: () => context.pop(), icon: Icon(Icons.arrow_back)),
          )
        ],
      ),
    );
  }
}
