// Reference from https://pub.dev/packages/todo_txt

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

class TaskParser {
  RegExp dateRegExp =
      RegExp(r"(^\d{4}[\-](0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$)");

  RegExp priorityRegExp = RegExp(r"^(\([A-Z]\)$)");
  parser(String line) {
    List<String> lineSplit = line.split(" ");
    bool completion = false;
    int? priority;
    DateTime? completionDate;
    DateTime? creationDate;
    String text = "";
    List<String> projectTag = [];
    List<String> contextTag = [];
    Map<String, String> metadata = {};

    if (lineSplit[0] == "x") {
      completion = true;
      lineSplit.removeAt(0);
      if (priorityRegExp.hasMatch(lineSplit[0])) {
        priority = lettersToIndex(lineSplit[0].split("")[1]);
        lineSplit.removeAt(0);
      }
      if (dateRegExp.hasMatch(lineSplit[0])) {
        completionDate = DateTime.tryParse(lineSplit[0]);
        lineSplit.removeAt(0);
      }
    } else if (priorityRegExp.hasMatch(lineSplit[0])) {
      priority = lettersToIndex(lineSplit[0].split("")[1]);
      lineSplit.removeAt(0);
    }

    if (dateRegExp.hasMatch(lineSplit[0])) {
      creationDate = DateTime.tryParse(lineSplit[0]);
      lineSplit.removeAt(0);
    }

    for (String e in lineSplit) {
      if (e.startsWith("@")) {
        contextTag.add(e.substring(1));
      } else if (e.startsWith("+")) {
        projectTag.add(e.substring(1));
      } else if (e.contains(":") && RegExp(r"\w+\:(\d+|\w+)").hasMatch(e)) {
        var keyvalue = e.split(":");
        metadata[keyvalue[0]] = keyvalue[1];
      } else {
        text += " $e";
      }
    }

    text = text.trim();

    TaskText value = TaskText(
      completion: completion,
      priority: priority,
      completionDate: completionDate,
      creationDate: creationDate!,
      text: text,
      projectTag: projectTag,
      contextTag: contextTag,
      metadata: metadata,
    );
    return value;
  }

  lineConstructor(TaskText value) {
    String line = "";

    if (value.completion) {
      line += "x ";
      if (value.priority != null) {
        line += "(${indexToLetters(value.priority!)}) ";
      }
      if (value.completionDate != null) {
        line +=
            "${value.completionDate?.year}-${value.completionDate!.month < 9 ? "0${value.completionDate!.month}" : value.completionDate!.month}-${value.completionDate!.day < 9 ? "0${value.completionDate!.day}" : value.completionDate!.day} ";
      }
    } else if (value.priority != null) {
      line += "(${indexToLetters(value.priority!)}) ";
    }
    line +=
        "${value.creationDate.year}-${value.creationDate.month < 9 ? "0${value.creationDate.month}" : value.creationDate.month}-${value.creationDate.day < 9 ? "0${value.creationDate.day}" : value.creationDate.day} ";
    line += value.text;
    if (value.contextTag!.isNotEmpty) {
      line += " ${value.contextTag?.map((e) => "@$e").join(" ")}";
    }
    if (value.projectTag!.isNotEmpty) {
      line += " ${value.projectTag?.map((e) => "+$e").join(" ")}";
    }
    if (value.metadata!.isNotEmpty) {
      line +=
          " ${value.metadata?.entries.map((e) => "${e.key}:${e.value}").join(" ")}";
    }

    line = line.trim();

    return line;
  }

  // Credit to https://stackoverflow.com/questions/68565990/dart-how-to-convert-a-column-letter-into-number
  int lettersToIndex(String letters) {
    var result = 0;
    for (var i = 0; i < letters.length; i++) {
      result = result * 26 + (letters.codeUnitAt(i) & 0x1f);
    }
    return result;
  }

  String indexToLetters(int index) {
    if (index <= 0) throw RangeError.range(index, 1, null, "index");
    const letters0 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if (index < 27) return letters0[index - 1];
    var letters = <String>[];
    do {
      index -= 1;
      letters.add(letters0[index.remainder(26)]);
      index ~/= 26;
    } while (index > 0);
    return letters.reversed.join("");
  }
}
