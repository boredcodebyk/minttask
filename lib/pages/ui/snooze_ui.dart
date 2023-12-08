import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minttask/model/db_model.dart';
import 'package:minttask/utils/utils.dart';

class SnoozeUI extends StatefulWidget {
  const SnoozeUI({super.key, this.receivedActionData});
  final ReceivedAction? receivedActionData;
  @override
  State<SnoozeUI> createState() => _SnoozeUIState();
}

class _SnoozeUIState extends State<SnoozeUI> {
  SnoozeType selectedSnoozeType = SnoozeType.preset;
  TextEditingController timeTextController = TextEditingController();

  Map<String, bool> durationType = {
    "Minute": true,
    "Hour": false,
    "Day": false,
  };
  DateTime? oldReminderDateTime;
  DateTime? newReminderCustom;
  int selectedDuration = 1;
  @override
  void initState() {
    super.initState();
    timeTextController.text = selectedDuration.toString();
    setState(() {
      oldReminderDateTime = widget.receivedActionData?.actionDate;
    });
  }

  @override
  void dispose() {
    timeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.receivedActionData!.payload!.entries.first.value!),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SegmentedButton(
            segments: const [
              ButtonSegment(value: SnoozeType.preset, label: Text("Preset")),
              ButtonSegment(value: SnoozeType.custom, label: Text("Custom"))
            ],
            selected: {selectedSnoozeType},
            onSelectionChanged: (p0) {
              setState(() {
                selectedSnoozeType = p0.first;
              });
            },
          ),
          if (selectedSnoozeType == SnoozeType.preset) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: selectedDuration == 0
                          ? null
                          : () {
                              setState(() {
                                selectedDuration = selectedDuration - 1;
                                timeTextController.text =
                                    selectedDuration.toString();
                              });
                            },
                      child: const SizedBox(
                          height: 48, child: Icon(Icons.remove))),
                  SizedBox(
                      width: 92,
                      height: 100,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: timeTextController,
                        style: Theme.of(context).textTheme.displayMedium,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDuration = selectedDuration + 1;
                          timeTextController.text = selectedDuration.toString();
                        });
                      },
                      child: const SizedBox(
                          height: 48, child: Icon(Icons.add_rounded)))
                ],
              ),
            ),
            Wrap(
              spacing: 2,
              children: [
                ChoiceChip(
                  label: Text("Minute${selectedDuration > 1 ? "s" : ""}"),
                  selected: durationType["Minute"]!,
                  onSelected: (val) {
                    setState(() {
                      durationType["Minute"] = true;
                      durationType["Hour"] = false;
                      durationType["Day"] = false;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text("Hour${selectedDuration > 1 ? "s" : ""}"),
                  selected: durationType["Hour"]!,
                  onSelected: (val) {
                    setState(() {
                      durationType["Minute"] = false;
                      durationType["Hour"] = true;
                      durationType["Day"] = false;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text("Day${selectedDuration > 1 ? "s" : ""}"),
                  selected: durationType["Day"]!,
                  onSelected: (val) {
                    setState(() {
                      durationType["Minute"] = false;
                      durationType["Hour"] = false;
                      durationType["Day"] = true;
                    });
                  },
                ),
              ],
            )
          ] else if (selectedSnoozeType == SnoozeType.custom) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                  onPressed: () async {
                    var remindtime = await showDateTimePicker(context: context);
                    setState(() {
                      newReminderCustom = remindtime;
                    });
                  },
                  child: const Text("Open time picker")),
            ),
            if (newReminderCustom != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    "Selected: ${DateFormat("E d, h:mm a").format(newReminderCustom!)}"),
              )
            ]
          ]
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              IsarHelper.instance.updateReminder(
                  int.parse(
                      widget.receivedActionData!.payload!.entries.first.value!),
                  true,
                  oldReminderDateTime);
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              if (selectedSnoozeType == SnoozeType.preset) {
                if (durationType["Minute"] = true) {
                  var tempDateTime = oldReminderDateTime!
                      .add(Duration(minutes: selectedDuration));
                  IsarHelper.instance.updateReminder(
                      int.parse(widget
                          .receivedActionData!.payload!.entries.first.value!),
                      true,
                      tempDateTime);
                } else if (durationType["Hour"] = true) {
                  var tempDateTime = oldReminderDateTime!
                      .add(Duration(hours: selectedDuration));
                  IsarHelper.instance.updateReminder(
                      int.parse(widget
                          .receivedActionData!.payload!.entries.first.value!),
                      true,
                      tempDateTime);
                } else if (durationType["Day"] = true) {
                  var tempDateTime = oldReminderDateTime!
                      .add(Duration(days: selectedDuration));
                  IsarHelper.instance.updateReminder(
                      int.parse(widget
                          .receivedActionData!.payload!.entries.first.value!),
                      true,
                      tempDateTime);
                }
              } else if (selectedSnoozeType == SnoozeType.custom) {
                IsarHelper.instance.updateReminder(
                    int.parse(widget
                        .receivedActionData!.payload!.entries.first.value!),
                    true,
                    newReminderCustom);
              }
              Navigator.of(context).pop();
            },
            child: const Text("Done")),
      ],
    );
  }
}
