import 'dart:convert';

enum Filter {
  id(filterName: "Default"),
  title(filterName: "Title"),
  // ignore: constant_identifier_filterNames, constant_identifier_names
  date_modified(filterName: "Date Modified"),
  // ignore: constant_identifier_filterNames, constant_identifier_names
  date_created(filterName: "Date Created");

  const Filter({required this.filterName});

  final String filterName;
}

enum Sort {
  asc(sortName: "Ascending"),
  desc(sortName: "Descending");

  const Sort({required this.sortName});

  final String sortName;
}

class Task {
  int? id;
  String? title;
  DateTime? dateCreated;
  DateTime? dateModified;
  String? description;
  bool? isDone;
  List<int>? customList;
  bool? trash;

  Task({
    this.id,
    this.title,
    this.dateCreated,
    this.dateModified,
    this.description,
    this.isDone,
    this.customList,
    this.trash,
  });

  Task copyWith({
    int? id,
    String? title,
    DateTime? dateCreated,
    DateTime? dateModified,
    String? description,
    bool? isDone,
    List<int>? customList,
    bool? trash,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        dateCreated: dateCreated ?? this.dateCreated,
        dateModified: dateModified ?? this.dateModified,
        description: description ?? this.description,
        isDone: isDone ?? this.isDone,
        customList: customList ?? this.customList,
        trash: trash ?? this.trash,
      );

  factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        dateCreated: DateTime.fromMillisecondsSinceEpoch(json["date_created"]),
        dateModified:
            DateTime.fromMillisecondsSinceEpoch(json["date_modified"]),
        description: json["description"],
        isDone: json["is_done"] == 0 ? false : true,
        customList: json["custom_list"].length > 0
            ? jsonDecode(json["custom_list"])
            : <int>[],
        trash: json["trash"] == 0 ? false : true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date_created": dateCreated!.millisecondsSinceEpoch,
        "date_modified": dateModified!.millisecondsSinceEpoch,
        "description": description,
        "is_done": isDone! ? 1 : 0,
        "custom_list": jsonEncode(customList),
        "trash": trash! ? 1 : 0
      };
}
