import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotifyAction extends StatefulWidget {
  const NotifyAction({super.key, this.receivedAction});
  final ReceivedAction? receivedAction;

  @override
  State<NotifyAction> createState() => _NotifyActionState();
}

class _NotifyActionState extends State<NotifyAction> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification page"),
      ),
      body: Column(
        children: [
          Text("Notification page: ${widget.receivedAction}"),
        ],
      ),
    );
  }
}
