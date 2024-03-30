class TodoTXT {
  TodoTXT(
      {required this.completion,
      this.priority,
      this.completionDate,
      required this.creationDate,
      required this.text,
      this.tags,
      this.context,
      this.due});
  bool completion;
  String? priority;
  String? completionDate;
  String creationDate;
  String text;
  List<String>? tags;
  List<String>? context;
  String? due;
}

class TodoTXTPraser {
  TodoTXT todotxt(value) {
    var todo = TodoTXT(
      completion: getCompletion(value),
      priority: getPriority(value),
      completionDate: getCompletionDate(value),
      creationDate: getCreationDate(value),
      text: getText(value),
      tags: getTags(value),
      context: getContext(value),
      due: getDueDate(value),
    );
    return todo;
  }

  String getCreationDate(String value) {
    var checkCompletion = RegExp(r"^x\s");
    var checkDate =
        RegExp(r"^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])*\s");
    var priorityRegExp = RegExp(r"^(\([A-Z]\)[\s])");
    if (checkCompletion.hasMatch(value)) {
      var removeCompletionMark = value.replaceAll("x ", "").trim();
      if (priorityRegExp.hasMatch(removeCompletionMark)) {
        var removePriority =
            removeCompletionMark.replaceFirst(priorityRegExp, "").trim();
        var removeCompletionDate =
            removePriority.replaceFirst(checkDate, "").trim();
        var matches = checkDate.firstMatch(removeCompletionDate)!;
        return matches[0]!;
      } else {
        var removeCompletionDate =
            removeCompletionMark.replaceFirst(checkDate, "").trim();
        var matches = checkDate.firstMatch(removeCompletionDate)!;
        return matches[0]!;
      }
    } else {
      if (priorityRegExp.hasMatch(value)) {
        var removePriority = value.replaceFirst(priorityRegExp, "").trim();
        var matches = checkDate.firstMatch(removePriority)!;
        return matches[0]!;
      } else {
        var matches = checkDate.firstMatch(value)!;
        return matches[0]!;
      }
    }
  }

  String getText(String value) {
    var checkCompletion = RegExp(r"^x\s");
    var checkDate =
        RegExp(r"^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])*\s");
    var priorityRegExp = RegExp(r"^(\([A-Z]\)[\s])");
    var checkDueDate =
        RegExp(r"(due\:(\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])*))");

    if (checkCompletion.hasMatch(value)) {
      var removeCompletionMark = value.replaceAll("x ", "").trim();
      if (priorityRegExp.hasMatch(removeCompletionMark)) {
        var removePriority =
            removeCompletionMark.replaceFirst(priorityRegExp, "").trim();
        var removeCompletionDate =
            removePriority.replaceFirst(checkDate, "").trim();
        var removeCreationDate =
            removeCompletionDate.replaceFirst(checkDate, "").trim();
        return removeCreationDate;
      } else {
        var removeCompletionDate =
            removeCompletionMark.replaceFirst(checkDate, "").trim();
        var removeCreationDate =
            removeCompletionDate.replaceFirst(checkDate, "").trim();
        return removeCreationDate;
      }
    } else {
      if (priorityRegExp.hasMatch(value)) {
        var removePriority = value.replaceFirst(priorityRegExp, "").trim();

        var removeCreationDate =
            removePriority.replaceFirst(checkDate, "").trim();
        return removeCreationDate;
      } else {
        var removeCreationDate = value.replaceFirst(checkDate, "").trim();
        return removeCreationDate;
      }
    }
  }

  bool getCompletion(String value) {
    var checkCompletion = RegExp(r"^x\s");
    if (checkCompletion.hasMatch(value)) {
      var matches = checkCompletion.allMatches(value);
      for (Match m in matches) {
        String getCompletion = m[0]!;
        return getCompletion == "x ";
      }
    }
    return false;
  }

  String? getPriority(String value) {
    var checkCompletion = RegExp(r"^x\s");
    var priorityRegExp = RegExp(r"^(\([A-Z]\)[\s])");
    if (checkCompletion.hasMatch(value)) {
      var removeCompletionMark = value.replaceAll("x ", "").trim();
      if (priorityRegExp.hasMatch(removeCompletionMark)) {
        var matches = priorityRegExp.firstMatch(removeCompletionMark)!;
        return matches[0]!;
      } else {
        return "";
      }
    } else {
      if (priorityRegExp.hasMatch(value)) {
        var matches = priorityRegExp.firstMatch(value)!;
        return matches[0]!;
      } else {
        return "";
      }
    }
  }

  String? getCompletionDate(String value) {
    var checkCompletion = RegExp(r"^x\s");
    var priorityRegExp = RegExp(r"^(\([A-Z]\)[\s])");
    var checkDate =
        RegExp(r"^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])*\s");
    if (checkCompletion.hasMatch(value)) {
      var removeCompletionMark = value.replaceAll("x ", "").trim();
      if (priorityRegExp.hasMatch(removeCompletionMark)) {
        var removePriority =
            removeCompletionMark.replaceFirst(priorityRegExp, "").trim();
        var matches = checkDate.firstMatch(removePriority)!;
        return matches[0]!;
      } else {
        var matches = checkDate.firstMatch(removeCompletionMark)!;
        return matches[0]!;
      }
    }
    return "";
  }

  List<String> getTags(String value) {
    var checkTags = RegExp(r"((\s|^)\+[0-9A-Za-z]+(?=\s|$))");
    List<String> tempTagsList = [];

    var matches = checkTags.allMatches(value);
    for (final Match m in matches) {
      String match = m[0]!;
      tempTagsList.add(match);
    }
    return tempTagsList;
  }

  List<String> getContext(String value) {
    var checkContext = RegExp(r"((\s|^)\@[0-9A-Za-z]+(?=\s|$))");
    List<String> tempContextList = [];

    var matches = checkContext.allMatches(value);
    for (final Match m in matches) {
      String match = m[0]!;
      tempContextList.add(match);
    }
    return tempContextList;
  }

  String? getDueDate(String value) {
    var checkDueDate =
        RegExp(r"(due\:(\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])*))");
    if (checkDueDate.hasMatch(value)) {
      var match = checkDueDate.firstMatch(value)!;
      return match[0];
    } else {
      return "";
    }
  }
}
