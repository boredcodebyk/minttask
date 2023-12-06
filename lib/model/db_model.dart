import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/utils/enum_utils.dart';
import 'package:path_provider/path_provider.dart';

class TaskListProvider with ChangeNotifier {
  TaskListProvider() {
    init();
  }

  IsarCollection<TaskData>? _isarCollectionTaskData;
  IsarCollection<TaskData>? get isarCollectionTaskData =>
      _isarCollectionTaskData;

  IsarCollection<CategoryList>? _isarCollectionCategoryData;
  IsarCollection<CategoryList>? get isarCollectionCategoryData =>
      _isarCollectionCategoryData;

  List<TaskData> _taskList = [];
  List<TaskData> get taskList => _taskList;

  List<TaskData> _taskANDarchiveList = [];
  List<TaskData> get taskANDarchiveList => _taskANDarchiveList;

  List<TaskData> _taskListPinned = [];
  List<TaskData> get taskListPinned => _taskListPinned;

  List<TaskData> _taskListUnpinned = [];
  List<TaskData> get taskListUnpinned => _taskListUnpinned;

  List<TaskData> _completedTaskList = [];
  List<TaskData> get completedTaskList => _completedTaskList;

  List<TaskData> _incompletedTaskUnpinnedList = [];
  List<TaskData> get incompletedTaskUnpinnedList =>
      _incompletedTaskUnpinnedList;

  List<TaskData> _archiveList = [];
  List<TaskData> get archiveList => _archiveList;

  List<TaskData> _trashList = [];
  List<TaskData> get trashList => _trashList;

  List<CategoryList> _categoryList = [];
  List<CategoryList> get categoryList => _categoryList;

  Map<int, bool> _sortLabelSelection = {};
  Map<int, bool> _editLabelSelection = {};
  Map<int, bool> _addLabelSelection = {};

  Map<int, bool> get sortLabelSelection => _sortLabelSelection;
  set sortLabelSelectionModify(Map<int, bool> value) {
    if (_sortLabelSelection == value) return;
    _sortLabelSelection = value;

    notifyListeners();
  }

  Map<int, bool> get editLabelSelection => _editLabelSelection;
  set editLabelSelectionModify(Map<int, bool> value) {
    if (_editLabelSelection == value) return;
    _editLabelSelection = value;
    notifyListeners();
  }

  Map<int, bool> get addLabelSelection => _addLabelSelection;
  set addLabelSelectionModify(Map<int, bool> value) {
    if (_addLabelSelection == value) return;
    _addLabelSelection = value;
    notifyListeners();
  }

  Isar? isar;

  void init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([TaskDataSchema, CategoryListSchema],
        directory: dir.path);
    _taskList = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(false)
        .findAll();
    _taskANDarchiveList =
        await isar!.taskDatas.where().filter().trashEqualTo(false).findAll();
    _taskListPinned = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(false)
        .pinnedEqualTo(true)
        .findAll();
    _taskListUnpinned = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(false)
        .pinnedEqualTo(false)
        .findAll();
    _completedTaskList = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(false)
        .doneStatusEqualTo(true)
        .pinnedEqualTo(false)
        .findAll();
    _incompletedTaskUnpinnedList = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(false)
        .doneStatusEqualTo(false)
        .pinnedEqualTo(false)
        .findAll();
    _archiveList = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(true)
        .trashEqualTo(false)
        .findAll();
    _trashList = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(true)
        .findAll();
    _categoryList = await isar!.categoryLists.where().sortByOrderID().findAll();
    _isarCollectionTaskData = isar!.taskDatas;
    _isarCollectionCategoryData = isar!.categoryLists;
    if (_sortLabelSelection.isEmpty) {
      saveLabelSelectionForSort({
        for (var item in await isar!.categoryLists.where().findAll())
          item.id: false
      });
    }
    if (_editLabelSelection.isEmpty) {
      saveLabelSelectionForEdit({
        for (var item in await isar!.categoryLists.where().findAll())
          item.id: false
      });
    }
    if (_addLabelSelection.isEmpty) {
      saveLabelSelectionForAdd({
        for (var item in await isar!.categoryLists.where().findAll())
          item.id: false
      });
    }
    notifyListeners();
  }

  saveCategoryState(int index, bool value, CategorySelectMode mode) {
    switch (mode) {
      case CategorySelectMode.sort:
        sortLabelSelection[index] = value;
        break;
      case CategorySelectMode.add:
        addLabelSelection[index] = value;
        break;
      case CategorySelectMode.modify:
        editLabelSelection[index] = value;

        break;
    }
    notifyListeners();
  }

  saveLabelSelectionForSort(Map<int, bool> selection) {
    sortLabelSelectionModify = selection;
    notifyListeners();
  }

  saveLabelSelectionForEdit(Map<int, bool> selection) {
    editLabelSelectionModify = selection;
    notifyListeners();
  }

  saveLabelSelectionForAdd(Map<int, bool> selection) {
    addLabelSelectionModify = selection;
    notifyListeners();
  }

  void addCategory(String title) async {
    final newCat = CategoryList()..name = title;
    var tempid =
        await isar?.writeTxn(() async => await isar!.categoryLists.put(newCat));
    final update = await isar!.categoryLists.get(tempid!);
    update?.orderID = tempid;
    await isar?.writeTxn(() async => await isar?.categoryLists.put(update!));

    await updateListinProvider();

    notifyListeners();
  }

  Future<TaskData?> fetchDataWithID(int todoID) async {
    final res = await isar!.taskDatas.get(todoID);

    return res;
  }

  void updateCategoryInTask(int id, List<int> catkeys) async {
    final updateTask = await isar!.taskDatas.get(id);
    updateTask?.labels = catkeys;
    await isar?.writeTxn(() async => await isar!.taskDatas.put(updateTask!));
    await updateListinProvider();
    notifyListeners();
  }

  void addTask(String title, String description, List<int> labels,
      bool doNotify, DateTime notifyTime, Priority selectedPriority) async {
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

    var tmpid =
        await isar?.writeTxn(() async => await isar!.taskDatas.put(newTask));
    final update = await isar!.taskDatas.get(tmpid!);
    update?.orderID = tmpid;
    await isar?.writeTxn(() async => await isar?.taskDatas.put(update!));
    if (doNotify) {
      update?.notifyID = tmpid;
      await AwesomeNotifications().createNotification(
        schedule: NotificationCalendar.fromDate(date: notifyTime),
        content: NotificationContent(
          id: tmpid,
          channelKey: 'task_reminder',
          actionType: ActionType.Default,
          title: title,
          category: NotificationCategory.Reminder,
        ),
        actionButtons: [
          NotificationActionButton(key: "done_$tmpid", label: "Done"),
          NotificationActionButton(key: "snooze_$tmpid", label: "Snooze"),
        ],
      );
    }
    await updateListinProvider();
    notifyListeners();
  }

  void deleteTask(int id) async {
    await isar?.writeTxn(() async {
      await isar?.taskDatas.delete(id);
      notifyListeners();
    });
    await updateListinProvider();
  }

  void markTaskDone(id, doneStatus) async {
    final updateTask = await isar!.taskDatas.get(id);
    updateTask?.doneStatus = doneStatus;
    updateTask?.pinned = false;
    updateTask?.dateModified = DateTime.now();
    await isar?.writeTxn(() async => await isar?.taskDatas.put(updateTask!));
    await updateListinProvider();
    notifyListeners();
  }

  void moveToArchive(int id) async {
    final updateTask = await isar!.taskDatas.get(id);
    updateTask?.archive = true;
    if (updateTask!.trash!) {
      updateTask.trash = false;
    }
    updateTask.dateModified = DateTime.now();
    await isar?.writeTxn(() async => await isar!.taskDatas.put(updateTask));
    await updateListinProvider();
    notifyListeners();
  }

  void moveToTrash(int id) async {
    final updateTask = await isar!.taskDatas.get(id);
    updateTask?.trash = true;
    if (updateTask!.archive!) {
      updateTask.trash = false;
    }
    updateTask.dateModified = DateTime.now();
    await isar?.writeTxn(() async => await isar!.taskDatas.put(updateTask));
    await updateListinProvider();
    notifyListeners();
  }

  void undoArchive(int id) async {
    final updateTask = await isar!.taskDatas.get(id);
    updateTask?.archive = false;

    updateTask?.dateModified = DateTime.now();
    await isar?.writeTxn(() async => await isar!.taskDatas.put(updateTask!));
    await updateListinProvider();
    notifyListeners();
  }

  void undoTrash(int id) async {
    final updateTask = await isar!.taskDatas.get(id);
    updateTask?.trash = false;

    updateTask?.dateModified = DateTime.now();
    await isar?.writeTxn(() async => await isar!.taskDatas.put(updateTask!));
    await updateListinProvider();
    notifyListeners();
  }

  void updateTodoTitle(int id, String t) async {
    final updateTask = await isar!.taskDatas.get(id);
    updateTask?.title = t;
    updateTask?.dateModified = DateTime.now();
    await isar?.writeTxn(() async {
      isar!.taskDatas.put(updateTask!);
    });
    await updateListinProvider();
    notifyListeners();
  }

  //TODO: fixing of code to update description
  void updateTodoDescription(int id, String desc) async {
    print(desc); // Passes the updated string
    final updateTask = await isar!.taskDatas.get(id);

    updateTask?.description = desc;
    updateTask!.dateModified = DateTime.now();
    await isar?.writeTxn(() async {
      await isar!.taskDatas.put(updateTask);
    });
    await updateListinProvider();
    notifyListeners();
  }

  void updatePriority(int id, Priority selectedPriority) async {
    final updateTask = await isar!.taskDatas.get(id);
    updateTask?.priority = selectedPriority;
    updateTask?.dateModified = DateTime.now();
    await isar?.writeTxn(() async {
      isar!.taskDatas.put(updateTask!);
    });
    await updateListinProvider();
    notifyListeners();
  }

  void pinToggle(int id, bool value) async {
    final updateTask = await isar!.taskDatas.get(id);
    updateTask?.pinned = value;
    updateTask?.dateModified = DateTime.now();
    await isar?.writeTxn(() async {
      isar!.taskDatas.put(updateTask!);
    });
    await updateListinProvider();
    notifyListeners();
  }

  void updateReminder(int id, bool hasReminder, DateTime? reminderValue) async {
    final updateTask = await isar!.taskDatas.get(id);
    updateTask?.doNotify = hasReminder;
    updateTask?.notifyTime = reminderValue;
    updateTask?.notifyID ??= updateTask.id;
    updateTask?.dateModified = DateTime.now();

    await isar?.writeTxn(() async {
      isar!.taskDatas.put(updateTask!);
    });
    print(hasReminder);
    await AwesomeNotifications().cancel(updateTask!.notifyID!);
    if (hasReminder) {
      await AwesomeNotifications().createNotification(
        schedule: NotificationCalendar.fromDate(
            date: DateTime.fromMicrosecondsSinceEpoch(
                reminderValue!.microsecondsSinceEpoch)),
        content: NotificationContent(
          id: updateTask.notifyID!,
          channelKey: 'task_reminder',
          actionType: ActionType.Default,
          title: updateTask.title,
          category: NotificationCategory.Reminder,
        ),
        actionButtons: [
          NotificationActionButton(
              key: "done_${updateTask.notifyID!}", label: "Done"),
          NotificationActionButton(
              key: "snooze_${updateTask.notifyID!}", label: "Snooze"),
        ],
      );
    }
    await updateListinProvider();
    notifyListeners();
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
    var tmpid =
        await isar?.writeTxn(() async => await isar!.taskDatas.put(newTask));
    final update = await isar!.taskDatas.get(tmpid!);
    update?.orderID = tmpid;
    await isar?.writeTxn(() async => await isar?.taskDatas.put(update!));
    await updateListinProvider();
    notifyListeners();
  }

  void resetDB() async {
    await isar?.writeTxn(() async => await isar?.clear());
    await updateListinProvider();
    notifyListeners();
  }

  void reorderTasks(int oldIndex, int newIndex) async {
    final oldItemTemp = await isar?.taskDatas
        .where()
        .filter()
        .orderIDEqualTo(oldIndex)
        .findFirst();
    final newItemTemp = await isar?.taskDatas
        .where()
        .filter()
        .orderIDEqualTo(newIndex)
        .findFirst();
    var oldID = oldItemTemp!.id;
    var newID = newItemTemp!.id;
    var oldItem = await isar!.taskDatas.get(oldID!);
    var newItem = await isar!.taskDatas.get(newID!);

    oldItem?.orderID = newIndex;
    newItem?.orderID = oldIndex;
    await isar?.writeTxn(() async {
      await isar?.taskDatas.put(oldItem!);
      await isar?.taskDatas.put(newItem!);
    });
    await updateListinProvider();
    notifyListeners();
  }

  void reorderCategoryLabels(int oldIndex, int newIndex) async {
    final oldItemTemp = await isar?.categoryLists
        .where()
        .filter()
        .orderIDEqualTo(oldIndex)
        .findFirst();
    final newItemTemp = await isar?.categoryLists
        .where()
        .filter()
        .orderIDEqualTo(newIndex)
        .findFirst();
    var oldID = oldItemTemp!.id;
    var newID = newItemTemp!.id;
    var oldItem = await isar!.categoryLists.get(oldID);
    var newItem = await isar!.categoryLists.get(newID);

    oldItem?.orderID = newIndex;
    newItem?.orderID = oldIndex;
    await isar?.writeTxn(() async {
      await isar?.categoryLists.put(oldItem!);
      await isar?.categoryLists.put(newItem!);
    });
    await updateListinProvider();
    notifyListeners();
  }

  void updateCategoryTitle(int id, String t) async {
    final updateTask = await isar!.categoryLists.get(id);
    updateTask?.name = t;
    await isar?.writeTxn(() async {
      isar!.categoryLists.put(updateTask!);
    });
    await updateListinProvider();
    notifyListeners();
  }

  void deleteCategory(int id) async {
    var taskListTemp = await isar!.taskDatas.where().findAll();
    for (var element in taskListTemp) {
      if (element.labels!.contains(id)) {
        element.labels!.removeWhere((e) => e == id);
      }
    }
    await isar?.writeTxn(() async {
      await isar?.categoryLists.delete(id);
    });
    await updateListinProvider();
    notifyListeners();
  }

  Future<void> updateListinProvider() async {
    _taskList = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(false)
        .findAll();
    _taskListPinned = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(false)
        .pinnedEqualTo(true)
        .findAll();
    _taskListUnpinned = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(false)
        .pinnedEqualTo(false)
        .findAll();
    _completedTaskList = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(false)
        .doneStatusEqualTo(true)
        .pinnedEqualTo(false)
        .findAll();
    _incompletedTaskUnpinnedList = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(false)
        .doneStatusEqualTo(false)
        .pinnedEqualTo(false)
        .findAll();
    _archiveList = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(true)
        .trashEqualTo(false)
        .findAll();
    _trashList = await isar!.taskDatas
        .where()
        .filter()
        .archiveEqualTo(false)
        .trashEqualTo(true)
        .findAll();
    _categoryList = await isar!.categoryLists.where().sortByOrderID().findAll();
    _isarCollectionTaskData = isar!.taskDatas;
    _isarCollectionCategoryData = isar!.categoryLists;
    if (_sortLabelSelection.isEmpty) {
      saveLabelSelectionForSort({
        for (var item in await isar!.categoryLists.where().findAll())
          item.id: false
      });
    }
    if (_editLabelSelection.isEmpty) {
      saveLabelSelectionForEdit({
        for (var item in await isar!.categoryLists.where().findAll())
          item.id: false
      });
    }
    if (_addLabelSelection.isEmpty) {
      saveLabelSelectionForAdd({
        for (var item in await isar!.categoryLists.where().findAll())
          item.id: false
      });
    }
  }
}

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
        ),
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
    print(hasReminder);
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
        ),
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
