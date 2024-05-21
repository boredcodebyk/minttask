import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minttask/controller/todotxt_parser.dart';
import 'package:minttask/model/task_model.dart';

void main() {
  group(
    "Task Parser Tests",
    () {
      test(
        'Parser Test 1: Single TaskTest to line',
        () {
          var task = TaskText(
              completion: false,
              creationDate: DateTime(2024, 5, 20),
              text: 'Test 1 parser to line');
          var line = task.line();

          expect(line, "2024-05-20 Test 1 parser to line");

          if (kDebugMode) {
            print("(Pass) Parser Test 1: Single TaskTest to line");
          }
        },
      );

      test(
        'Parser Test 2: Single line to TaskText',
        () {
          var fromLine =
              TaskParser().parser("2024-05-20 Test 1 parser to line");
          var task = TaskText(
              completion: false,
              creationDate: DateTime(2024, 5, 20),
              text: 'Test 1 parser to line');

          expect(task.line(), fromLine.line());

          if (kDebugMode) {
            print("(Pass) Parser Test 2: Single line to TaskText");
          }
        },
      );
      test(
        'Parser Test 3: Single line to TaskText (completed task)',
        () {
          var fromLine = TaskParser().parser(
              "x (A) 2024-05-20 2024-05-20 Test 1 parser to line +projectText @contextText due:2024-05-21");
          var task = TaskText(
              priority: 1,
              completion: true,
              completionDate: DateTime(2024, 5, 20),
              creationDate: DateTime(2024, 5, 20),
              text: 'Test 1 parser to line',
              projectTag: ['projectText'],
              contextTag: ['contextText'],
              metadata: {'due': '2024-05-21'});

          expect(task.line(), fromLine.line());

          if (kDebugMode) {
            print(
                "(Pass) Parser Test 3: Single line to TaskText (completed task)");
          }
        },
      );
      test(
        'Parser Test 4: Multiple line (list) to TaskText',
        () {
          var todoList = [
            "2024-05-20 Test 1 parser to line",
            "2024-05-20 Test 1 parser to line +projectText",
            "2024-05-20 Test 1 parser to line @contextText",
            "2024-05-20 Test 1 parser to line +projectText @contextText",
            "2024-05-20 Test 1 parser to line due:2024-05-21",
            "2024-05-20 Test 1 parser to line +projectText due:2024-05-21",
            "2024-05-20 Test 1 parser to line @contextText due:2024-05-21",
            "2024-05-20 Test 1 parser to line +projectText @contextText due:2024-05-21",
            "(A) 2024-05-20 Test 1 parser to line",
            "(A) 2024-05-20 Test 1 parser to line +projectText",
            "(A) 2024-05-20 Test 1 parser to line @contextText",
            "(A) 2024-05-20 Test 1 parser to line +projectText @contextText",
            "(A) 2024-05-20 Test 1 parser to line due:2024-05-21",
            "(A) 2024-05-20 Test 1 parser to line +projectText due:2024-05-21",
            "(A) 2024-05-20 Test 1 parser to line @contextText due:2024-05-21",
            "(A) 2024-05-20 Test 1 parser to line +projectText @contextText due:2024-05-21",
            "x 2024-05-20 2024-05-20 Test 1 parser to line",
            "x 2024-05-20 2024-05-20 Test 1 parser to line +projectText",
            "x 2024-05-20 2024-05-20 Test 1 parser to line @contextText",
            "x 2024-05-20 2024-05-20 Test 1 parser to line +projectText @contextText",
            "x 2024-05-20 2024-05-20 Test 1 parser to line due:2024-05-21",
            "x 2024-05-20 2024-05-20 Test 1 parser to line +projectText due:2024-05-21",
            "x 2024-05-20 2024-05-20 Test 1 parser to line @contextText due:2024-05-21",
            "x 2024-05-20 2024-05-20 Test 1 parser to line +projectText @contextText due:2024-05-21",
            "x (A) 2024-05-20 2024-05-20 Test 1 parser to line",
            "x (A) 2024-05-20 2024-05-20 Test 1 parser to line +projectText",
            "x (A) 2024-05-20 2024-05-20 Test 1 parser to line @contextText",
            "x (A) 2024-05-20 2024-05-20 Test 1 parser to line +projectText @contextText",
            "x (A) 2024-05-20 2024-05-20 Test 1 parser to line due:2024-05-21",
            "x (A) 2024-05-20 2024-05-20 Test 1 parser to line +projectText due:2024-05-21",
            "x (A) 2024-05-20 2024-05-20 Test 1 parser to line @contextText due:2024-05-21",
            "x (A) 2024-05-20 2024-05-20 Test 1 parser to line +projectText @contextText due:2024-05-21",
          ];
          for (var element in todoList) {
            var fromLine = TaskParser().parser(element);
            var task = TaskText(
              priority: fromLine.priority,
              completion: fromLine.completion,
              completionDate: fromLine.completionDate,
              creationDate: fromLine.creationDate,
              text: fromLine.text,
              contextTag: fromLine.contextTag,
              projectTag: fromLine.projectTag,
              metadata: fromLine.metadata,
            );

            expect(task.line(), fromLine.line());
            if (kDebugMode) {
              print("Pass (index: ${todoList.indexWhere(
                (e) => e == element,
              )})");
            }
          }

          if (kDebugMode) {
            print("(Pass) Parser Test 4: Multiple line (list) to TaskText");
          }
        },
      );
      test(
        'Parser Test 5: Multiple line (raw) to TaskText',
        () {
          var todoRaw = """
2024-05-20 Test 1 parser to line
2024-05-20 Test 1 parser to line +projectText
2024-05-20 Test 1 parser to line @contextText
2024-05-20 Test 1 parser to line +projectText @contextText
2024-05-20 Test 1 parser to line due:2024-05-21
2024-05-20 Test 1 parser to line +projectText due:2024-05-21
2024-05-20 Test 1 parser to line @contextText due:2024-05-21
2024-05-20 Test 1 parser to line +projectText @contextText due:2024-05-21
(A) 2024-05-20 Test 1 parser to line
(A) 2024-05-20 Test 1 parser to line +projectText
(A) 2024-05-20 Test 1 parser to line @contextText
(A) 2024-05-20 Test 1 parser to line +projectText @contextText
(A) 2024-05-20 Test 1 parser to line due:2024-05-21
(A) 2024-05-20 Test 1 parser to line +projectText due:2024-05-21
(A) 2024-05-20 Test 1 parser to line @contextText due:2024-05-21
(A) 2024-05-20 Test 1 parser to line +projectText @contextText due:2024-05-21
x 2024-05-20 2024-05-20 Test 1 parser to line
x 2024-05-20 2024-05-20 Test 1 parser to line +projectText
x 2024-05-20 2024-05-20 Test 1 parser to line @contextText
x 2024-05-20 2024-05-20 Test 1 parser to line +projectText @contextText
x 2024-05-20 2024-05-20 Test 1 parser to line due:2024-05-21
x 2024-05-20 2024-05-20 Test 1 parser to line +projectText due:2024-05-21
x 2024-05-20 2024-05-20 Test 1 parser to line @contextText due:2024-05-21
x 2024-05-20 2024-05-20 Test 1 parser to line +projectText @contextText due:2024-05-21
x (A) 2024-05-20 2024-05-20 Test 1 parser to line
x (A) 2024-05-20 2024-05-20 Test 1 parser to line +projectText
x (A) 2024-05-20 2024-05-20 Test 1 parser to line @contextText
x (A) 2024-05-20 2024-05-20 Test 1 parser to line +projectText @contextText
x (A) 2024-05-20 2024-05-20 Test 1 parser to line due:2024-05-21
x (A) 2024-05-20 2024-05-20 Test 1 parser to line +projectText due:2024-05-21
x (A) 2024-05-20 2024-05-20 Test 1 parser to line @contextText due:2024-05-21
x (A) 2024-05-20 2024-05-20 Test 1 parser to line +projectText @contextText due:2024-05-21
""";
          for (var element in todoRaw.trim().split("\n")) {
            var fromLine = TaskParser().parser(element);
            var task = TaskText(
              priority: fromLine.priority,
              completion: fromLine.completion,
              completionDate: fromLine.completionDate,
              creationDate: fromLine.creationDate,
              text: fromLine.text,
              contextTag: fromLine.contextTag,
              projectTag: fromLine.projectTag,
              metadata: fromLine.metadata,
            );

            expect(task.line(), fromLine.line());
            if (kDebugMode) {
              print("Pass (index: ${todoRaw.trim().split('\n').indexWhere(
                    (e) => e == element,
                  )}) for $element");
            }
          }

          if (kDebugMode) {
            print("(Pass) Parser Test 5: Multiple line (raw) to TaskText");
          }
        },
      );
    },
  );
}
