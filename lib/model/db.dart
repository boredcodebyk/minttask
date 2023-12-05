import 'package:isar/isar.dart';

part 'db.g.dart';

@collection
class TaskData {
  TaskData({
    this.id,
    this.title,
    this.description,
    this.doneStatus,
    this.dateCreated,
    this.dateModified,
    this.labels,
    this.archive,
    this.trash,
    this.doNotify,
    this.notifyID,
    this.notifyTime,
    this.priority,
    this.pinned,
    this.orderID,
  });
  Id? id = Isar.autoIncrement;
  String? title;
  String? description;
  bool? doneStatus = false;
  DateTime? dateCreated;
  DateTime? dateModified;
  List<int>? labels = [];
  bool? archive = false;
  bool? trash = false;
  bool? doNotify = false;
  DateTime? notifyTime;
  int? notifyID;
  @Enumerated(EnumType.name)
  Priority? priority;
  bool? pinned = false;
  int? orderID;
}

enum Priority {
  low,
  moderate,
  high,
}

@collection
class CategoryList {
  Id id = Isar.autoIncrement;
  String? name;
  int? orderID;
}
