import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:minttask/pages/pages.dart';

import 'package:minttask/main.dart' show MyApp;

class NotificationController {
  static ReceivedAction? initialAction;
  static Future<void> initializeLocalNotification() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: "reminders",
              channelKey: "task_reminder",
              channelName: "Mint Task",
              channelDescription: "Reminder",
              defaultColor: Colors.orange,
              importance: NotificationImportance.High,
              icon: "resource://drawable/ic_launcher_foreground"),
        ],
        debug: true);
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    if (MyApp.navigatorKey.currentState != null) {
      MyApp.navigatorKey.currentState!.push(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => NotifyAction(
            receivedAction: receivedAction,
          ),
          transitionDuration: const Duration(milliseconds: 0),
        ),
      );
      print(receivedAction);
    }
  }
}
