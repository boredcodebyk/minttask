import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:minttask/model/db_model.dart';
import 'package:minttask/pages/ui/snooze_ui.dart';

class NotifyAction extends StatefulWidget {
  const NotifyAction({super.key, required this.receivedAction});
  final ReceivedAction receivedAction;

  @override
  State<NotifyAction> createState() => _NotifyActionState();
}

class _NotifyActionState extends State<NotifyAction> {
  String notificationbuttonkeypressed = "";
  void markDone(id) async {
    final isar = IsarHelper.instance;
    isar.markTaskDone(id, true);
  }

  @override
  void initState() {
    setState(() {
      notificationbuttonkeypressed = widget.receivedAction.buttonKeyPressed;
    });
    if (notificationbuttonkeypressed.split("_").first == "done") {
      var tmpid = widget.receivedAction.payload!.values.toList().first;
      markDone(int.parse(tmpid!));
    } else if (notificationbuttonkeypressed.split("_").first == "snooze") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await showDialog(
            context: context,
            builder: (context) =>
                SnoozeUI(receivedActionData: widget.receivedAction));
      });
    }

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
