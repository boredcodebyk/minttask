import '../controller/todotxt_parser.dart';

class TaskText {
  TaskText({
    required this.completion,
    this.priority,
    this.completionDate,
    required this.creationDate,
    required this.text,
    this.projectTag,
    this.contextTag,
    this.metadata,
  });
  bool completion;
  int? priority;
  DateTime? completionDate;
  DateTime creationDate;
  String text;
  List<String>? projectTag;
  List<String>? contextTag;
  Map<String, String>? metadata;

  Map toJson() => {
        "completion": completion,
        "priority": priority,
        "completionDate": completionDate,
        "creationDate": creationDate,
        "text": text,
        "projectTag": projectTag,
        "contextTag": contextTag,
        "metadata": metadata,
      };

  factory TaskText.fromJson(Map<String, dynamic> json) => TaskText(
        completion: json["completion"],
        priority: json["priority"],
        completionDate: json["completionDate"],
        creationDate: json["creationDate"]!,
        text: json["text"],
        projectTag: json["projectTag"],
        contextTag: json["contextTag"],
        metadata: json["metadata"],
      );
  TaskText copyWith({
    bool? completion,
    int? priority,
    DateTime? completionDate,
    DateTime? creationDate,
    String? text,
    List<String>? projectTag,
    List<String>? contextTag,
    Map<String, String>? metadata,
  }) {
    return TaskText(
      completion: completion ?? this.completion,
      completionDate: completionDate ?? this.completionDate,
      creationDate: creationDate ?? this.creationDate,
      text: text ?? this.text,
      contextTag: contextTag ?? this.contextTag,
      priority: priority ?? this.priority,
      metadata: metadata ?? this.metadata,
      projectTag: projectTag ?? this.projectTag,
    );
  }

  String line() {
    String line = "";

    if (completion) {
      line += "x ";
      if (priority != null) {
        line += "(${indexToLetters(priority!)}) ";
      }
      if (completionDate != null) {
        line +=
            "${completionDate?.year}-${completionDate!.month < 9 ? "0${completionDate!.month}" : completionDate!.month}-${completionDate!.day < 9 ? "0${completionDate!.day}" : completionDate!.day} ";
      }
    } else if (priority != null) {
      line += "(${indexToLetters(priority!)}) ";
    }
    line +=
        "${creationDate.year}-${creationDate.month < 9 ? "0${creationDate.month}" : creationDate.month}-${creationDate.day < 9 ? "0${creationDate.day}" : creationDate.day} ";
    line += text;
    // Context Tag
    if (contextTag != null) {
      if (contextTag!.isNotEmpty) {
        line += " ${contextTag?.map((e) => "@$e").join(" ")}";
      }
    }
    //Project Tag
    if (projectTag != null) {
      if (projectTag!.isNotEmpty) {
        line += " ${projectTag?.map((e) => "+$e").join(" ")}";
      }
    }
    //Metadata
    if (metadata != null) {
      if (metadata!.isNotEmpty) {
        line +=
            " ${metadata?.entries.map((e) => "${e.key}:${e.value}").join(" ")}";
      }
    }

    line = line.trim();

    return line;
  }
}
