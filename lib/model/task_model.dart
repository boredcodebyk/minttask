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
}
