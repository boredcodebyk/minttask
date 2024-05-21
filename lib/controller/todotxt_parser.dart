import 'package:minttask/model/task_model.dart';

class TaskParser {
  RegExp dateRegExp =
      RegExp(r"(^\d{4}[\-](0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$)");

  RegExp priorityRegExp = RegExp(r"^(\([A-Z]\)$)");
  TaskText parser(String line) {
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
  if (index <= 0) {
    //throw RangeError.range(index, 1, null, "index");
  }
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
