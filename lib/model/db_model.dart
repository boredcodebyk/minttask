import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:isar/isar.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/utils/enum_utils.dart';
import 'package:path_provider/path_provider.dart';

class IsarHelper {
  static final IsarHelper instance = IsarHelper._();
  IsarHelper._();

  static Isar? _isar;

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    _isar = await initDB();
    return _isar!;
  }

  Future<Isar> initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([TaskDataSchema, CategoryListSchema],
        directory: dir.path);
  }

  void addCategory({String? title}) async {
    final isarInstance = await instance.isar;
    final newCat = CategoryList()..name = title;
    var tempid = await isarInstance
        .writeTxn(() async => await isarInstance.categoryLists.put(newCat));
    final update = await isarInstance.categoryLists.get(tempid);
    update?.orderID = tempid;
    await isarInstance
        .writeTxn(() async => await isarInstance.categoryLists.put(update!));
  }

  void addTask(
      {String? title,
      String? description,
      List<int>? labels,
      bool? doNotify,
      DateTime? notifyTime,
      Priority? selectedPriority}) async {
    final isarInstance = await instance.isar;

    final newTask = TaskData()
      ..title = title
      ..description = description
      ..doneStatus = false
      ..dateCreated = DateTime.now()
      ..dateModified = DateTime.now()
      ..labels = labels
      ..archive = false
      ..trash = false
      ..doNotify = doNotify
      ..notifyTime = notifyTime
      ..priority = selectedPriority
      ..pinned = false;

    var tmpid = await isarInstance
        .writeTxn(() async => await isarInstance.taskDatas.put(newTask));
    final update = await isarInstance.taskDatas.get(tmpid);
    update?.orderID = tmpid;
    await isarInstance
        .writeTxn(() async => await isarInstance.taskDatas.put(update!));
    if (doNotify!) {
      update?.notifyID = tmpid;
      await AwesomeNotifications().createNotification(
        schedule: NotificationCalendar.fromDate(date: notifyTime!),
        content: NotificationContent(
            id: tmpid,
            channelKey: 'task_reminder',
            actionType: ActionType.Default,
            title: title,
            category: NotificationCategory.Reminder,
            payload: {
              "id": tmpid.toString(),
            }),
        actionButtons: [
          NotificationActionButton(key: "done_$tmpid", label: "Done"),
          NotificationActionButton(key: "snooze_$tmpid", label: "Snooze"),
        ],
      );
    }
  }

  Future<TaskData?> getEachTaskData({int? id}) async {
    final isarInstance = await instance.isar;
    final updateTask = await isarInstance.taskDatas.get(id!);
    return updateTask;
  }

  void updateTitle({int? id, String? title}) async {
    final isarInstance = await instance.isar;
    await isarInstance.writeTxn(() async {
      final updateTask = await isarInstance.taskDatas.get(id!);
      updateTask?.title = title;

      updateTask?.dateModified = DateTime.now();
      return await isarInstance.taskDatas.put(updateTask!);
    });
  }

  void updateDescription({int? id, String? description}) async {
    final isarInstance = await instance.isar;
    await isarInstance.writeTxn(() async {
      final updateTask = await isarInstance.taskDatas.get(id!);
      updateTask?.description = description;
      updateTask?.dateModified = DateTime.now();
      return await isarInstance.taskDatas.put(updateTask!);
    });
  }

  void updateLabels({int? id, List<int>? labels}) async {
    final isarInstance = await instance.isar;
    await isarInstance.writeTxn(() async {
      final updateTask = await isarInstance.taskDatas.get(id!);
      updateTask?.labels = labels;
      updateTask?.dateModified = DateTime.now();
      return await isarInstance.taskDatas.put(updateTask!);
    });
  }

  void updatePriority(int id, Priority selectedPriority) async {
    final isarInstance = await instance.isar;
    final updateTask = await isarInstance.taskDatas.get(id);
    updateTask?.priority = selectedPriority;
    updateTask?.dateModified = DateTime.now();
    await isarInstance.writeTxn(() async {
      isarInstance.taskDatas.put(updateTask!);
    });
  }

  void deleteTask(int id) async {
    final isarInstance = await instance.isar;
    await isarInstance.writeTxn(() async {
      await isarInstance.taskDatas.delete(id);
    });
  }

  void markTaskDone(id, doneStatus) async {
    final isarInstance = await instance.isar;
    await isarInstance.writeTxn(() async {
      final updateTask = await isarInstance.taskDatas.get(id);
      updateTask?.doneStatus = doneStatus;
      updateTask?.pinned = false;
      updateTask?.dateModified = DateTime.now();
      return await isarInstance.taskDatas.put(updateTask!);
    });
  }

  void moveToArchive(int id) async {
    final isarInstance = await instance.isar;
    final updateTask = await isarInstance.taskDatas.get(id);
    updateTask?.archive = true;

    updateTask?.trash = false;

    updateTask?.dateModified = DateTime.now();
    await isarInstance.writeTxn(() async {
      return await isarInstance.taskDatas.put(updateTask!);
    });
  }

  void moveToTrash(int id) async {
    final isarInstance = await instance.isar;
    final updateTask = await isarInstance.taskDatas.get(id);
    updateTask?.trash = true;

    updateTask?.archive = false;

    updateTask?.dateModified = DateTime.now();

    await isarInstance.writeTxn(() async {
      return await isarInstance.taskDatas.put(updateTask!);
    });
  }

  void undoArchive(int id) async {
    final isarInstance = await instance.isar;
    final updateTask = await isarInstance.taskDatas.get(id);
    updateTask?.archive = false;

    updateTask?.dateModified = DateTime.now();
    await isarInstance.writeTxn(() async {
      return await isarInstance.taskDatas.put(updateTask!);
    });
  }

  void undoTrash(int id) async {
    final isarInstance = await instance.isar;
    final updateTask = await isarInstance.taskDatas.get(id);
    updateTask?.trash = false;
    updateTask?.dateModified = DateTime.now();
    await isarInstance.writeTxn(() async {
      return await isarInstance.taskDatas.put(updateTask!);
    });
  }

  void pinToggle(int id, bool value) async {
    final isarInstance = await instance.isar;
    await isarInstance.writeTxn(() async {
      final updateTask = await isarInstance.taskDatas.get(id);
      updateTask?.pinned = value;
      updateTask?.dateModified = DateTime.now();
      if (updateTask?.archive == true) {
        updateTask?.archive = false;
      }
      if (updateTask?.trash == true) {
        updateTask?.trash = false;
      }
      isarInstance.taskDatas.put(updateTask!);
    });
  }

  void updateReminder(int id, bool hasReminder, DateTime? reminderValue) async {
    final isarInstance = await instance.isar;
    final updateTask = await isarInstance.taskDatas.get(id);
    updateTask?.doNotify = hasReminder;
    updateTask?.notifyTime = reminderValue;
    updateTask?.notifyID ??= updateTask.id;
    updateTask?.dateModified = DateTime.now();

    await isarInstance.writeTxn(() async {
      isarInstance.taskDatas.put(updateTask!);
    });

    await AwesomeNotifications().cancel(updateTask!.notifyID!);
    if (hasReminder) {
      await AwesomeNotifications().createNotification(
        schedule: NotificationCalendar.fromDate(date: reminderValue!),
        content: NotificationContent(
            id: updateTask.notifyID!,
            channelKey: 'task_reminder',
            actionType: ActionType.Default,
            title: updateTask.title,
            category: NotificationCategory.Reminder,
            payload: {
              "id": id.toString(),
            }),
        actionButtons: [
          NotificationActionButton(
              key: "done_${updateTask.notifyID!}", label: "Done"),
          NotificationActionButton(
              key: "snooze_${updateTask.notifyID!}", label: "Snooze"),
        ],
      );
    }
  }

  void reorderCategoryLabels(int oldIndex, int newIndex) async {
    final isarInstance = await instance.isar;
    final oldItemTemp = await isarInstance.categoryLists
        .where()
        .filter()
        .orderIDEqualTo(oldIndex)
        .findFirst();
    final newItemTemp = await isarInstance.categoryLists
        .where()
        .filter()
        .orderIDEqualTo(newIndex)
        .findFirst();
    var oldID = oldItemTemp!.id;
    var newID = newItemTemp!.id;
    var oldItem = await isarInstance.categoryLists.get(oldID);
    var newItem = await isarInstance.categoryLists.get(newID);

    oldItem?.orderID = newIndex;
    newItem?.orderID = oldIndex;
    await isarInstance.writeTxn(() async {
      await isarInstance.categoryLists.put(oldItem!);
      await isarInstance.categoryLists.put(newItem!);
    });
  }

  void reorderTasks(int oldIndex, int newIndex) async {
    final isarInstance = await instance.isar;
    final oldItemTemp = await isarInstance.taskDatas
        .where()
        .filter()
        .orderIDEqualTo(oldIndex)
        .findFirst();
    final newItemTemp = await isarInstance.taskDatas
        .where()
        .filter()
        .orderIDEqualTo(newIndex)
        .findFirst();
    var oldID = oldItemTemp!.id;
    var newID = newItemTemp!.id;
    var oldItem = await isarInstance.taskDatas.get(oldID!);
    var newItem = await isarInstance.taskDatas.get(newID!);

    oldItem?.orderID = newIndex;
    newItem?.orderID = oldIndex;
    await isarInstance.writeTxn(() async {
      await isarInstance.taskDatas.put(oldItem!);
      await isarInstance.taskDatas.put(newItem!);
    });
  }

  void deleteCategory(int id) async {
    final isarInstance = await instance.isar;
    List<int> blanklist = [];

    var taskListTemp = await isarInstance.taskDatas.where().findAll();
    for (var element in taskListTemp) {
      for (var e in element.labels!) {
        blanklist.add(e);
      }
      if (blanklist.contains(id)) {
        blanklist.removeWhere((e) => e == id);
        var getID = element.id;
        var updateItem = await isarInstance.taskDatas.get(getID!);
        updateItem?.labels = blanklist;
        await isarInstance.writeTxn(() async {
          await isarInstance.taskDatas.put(updateItem!);
        });
      }
    }

    await isarInstance.writeTxn(() async {
      await isarInstance.categoryLists.delete(id);
    });
  }

  void updateLabelTitle({required int id, required String title}) async {
    final isarInstance = await instance.isar;
    final updateCategory = await isarInstance.categoryLists.get(id);
    updateCategory?.name = title;
    await isarInstance.writeTxn(() async {
      isarInstance.categoryLists.put(updateCategory!);
    });
  }

  void restoreFromJson(
      title,
      description,
      doneStatus,
      dateCreated,
      dateModified,
      labels,
      archive,
      trash,
      doNotify,
      notifyID,
      notifyTime,
      priority,
      pinned) async {
    final isarInstance = await instance.isar;
    final newTask = TaskData()
      ..title = title
      ..description = description
      ..doneStatus = doneStatus
      ..dateCreated = dateCreated
      ..dateModified = dateModified
      ..labels = labels.cast<int>()
      ..archive = archive
      ..trash = trash
      ..doNotify = doNotify
      ..notifyID = notifyID
      ..notifyTime = notifyTime
      ..priority = priority == "low"
          ? Priority.low
          : priority == "moderate"
              ? Priority.moderate
              : Priority.high
      ..pinned = pinned;
    var tmpid = await isarInstance
        .writeTxn(() async => await isarInstance.taskDatas.put(newTask));
    final update = await isarInstance.taskDatas.get(tmpid);
    update?.orderID = tmpid;
    await isarInstance
        .writeTxn(() async => await isarInstance.taskDatas.put(update!));
  }

  Stream<List<CategoryList>> listCategory() async* {
    final isarInstance = await instance.isar;
    yield* isarInstance.categoryLists.where().watch(fireImmediately: true);
  }

  Stream<List<TaskData>> listTasks(
      {SortList? sort, FilterList? filter}) async* {
    final isarInstance = await instance.isar;
    switch (sort) {
      case SortList.id:
        if (filter == FilterList.asc) {
          yield* isarInstance.taskDatas
              .where()
              .filter()
              .archiveEqualTo(false)
              .trashEqualTo(false)
              .sortByOrderID()
              .watch(fireImmediately: true);
        } else if (filter == FilterList.desc) {
          yield* isarInstance.taskDatas
              .where()
              .filter()
              .archiveEqualTo(false)
              .trashEqualTo(false)
              .sortByOrderIDDesc()
              .watch(fireImmediately: true);
        }
        break;
      case SortList.title:
        if (filter == FilterList.asc) {
          yield* isarInstance.taskDatas
              .where()
              .filter()
              .archiveEqualTo(false)
              .trashEqualTo(false)
              .sortByTitle()
              .watch(fireImmediately: true);
        } else if (filter == FilterList.desc) {
          yield* isarInstance.taskDatas
              .where()
              .filter()
              .archiveEqualTo(false)
              .trashEqualTo(false)
              .sortByTitleDesc()
              .watch(fireImmediately: true);
        }
        break;
      case SortList.dateCreated:
        if (filter == FilterList.asc) {
          yield* isarInstance.taskDatas
              .where()
              .filter()
              .archiveEqualTo(false)
              .trashEqualTo(false)
              .sortByDateCreated()
              .watch(fireImmediately: true);
        } else if (filter == FilterList.desc) {
          yield* isarInstance.taskDatas
              .where()
              .filter()
              .archiveEqualTo(false)
              .trashEqualTo(false)
              .sortByDateCreatedDesc()
              .watch(fireImmediately: true);
        }
        break;
      case SortList.dateModified:
        if (filter == FilterList.asc) {
          yield* isarInstance.taskDatas
              .where()
              .filter()
              .archiveEqualTo(false)
              .trashEqualTo(false)
              .sortByDateModified()
              .watch(fireImmediately: true);
        } else if (filter == FilterList.desc) {
          yield* isarInstance.taskDatas
              .where()
              .filter()
              .archiveEqualTo(false)
              .trashEqualTo(false)
              .sortByDateModifiedDesc()
              .watch(fireImmediately: true);
        }
        break;
      case null:
        if (filter == FilterList.asc) {
          yield* isarInstance.taskDatas
              .where()
              .filter()
              .archiveEqualTo(false)
              .trashEqualTo(false)
              .sortByOrderID()
              .watch(fireImmediately: true);
        } else if (filter == FilterList.desc) {
          yield* isarInstance.taskDatas
              .where()
              .filter()
              .archiveEqualTo(false)
              .trashEqualTo(false)
              .sortByOrderIDDesc()
              .watch(fireImmediately: true);
        }
    }
  }

  Stream<List<TaskData>> listArchive() async* {
    final isarInstance = await instance.isar;
    yield* isarInstance.taskDatas
        .where()
        .filter()
        .archiveEqualTo(true)
        .trashEqualTo(false)
        .watch(fireImmediately: true);
  }

  Stream<List<TaskData>> listTrash() async* {
    final isarInstance = await instance.isar;
    yield* isarInstance.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(true)
        .watch(fireImmediately: true);
  }

  void resetDB() async {
    final isarInstance = await instance.isar;

    await isarInstance.writeTxn(() async => await isarInstance.clear());
  }
}
