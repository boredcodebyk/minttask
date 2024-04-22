import 'dart:io';

import 'dart:convert';

import 'package:file_picker/file_picker.dart';

class WorkspaceConfig {
  List<ContextTag>? contexts;
  List<String>? projects;
  List<String>? metadatakeys;

  WorkspaceConfig({
    this.contexts,
    this.projects,
    this.metadatakeys,
  });

  factory WorkspaceConfig.fromRawJson(String str) =>
      WorkspaceConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WorkspaceConfig.fromJson(Map<String, dynamic> json) =>
      WorkspaceConfig(
        contexts: json["contexts"] == null
            ? []
            : List<ContextTag>.from(
                json["contexts"]!.map((x) => ContextTag.fromJson(x))),
        projects: json["projects"] == null
            ? []
            : List<String>.from(json["projects"]!.map((x) => x)),
        metadatakeys: json["metadatakeys"] == null
            ? []
            : List<String>.from(json["metadatakeys"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "contexts": contexts == null
            ? []
            : List<dynamic>.from(contexts!.map((x) => x.toJson())),
        "projects":
            projects == null ? [] : List<dynamic>.from(projects!.map((x) => x)),
        "metadatakeys": metadatakeys == null
            ? []
            : List<dynamic>.from(metadatakeys!.map((x) => x)),
      };
}

class ContextTag {
  String? title;
  String? description;

  ContextTag({
    this.title,
    this.description,
  });

  List<ContextTag> convertList(List<String> list) {
    return list.map((e) => ContextTag(title: e, description: "")).toList();
  }

  factory ContextTag.fromRawJson(String str) =>
      ContextTag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContextTag.fromJson(Map<String, dynamic> json) => ContextTag(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}

class FileManagementModel {
  Future<FileResult> readTextFile({required String path}) async {
    try {
      File textFile = File(path);
      var r = await textFile.readAsString();
      return FileResult(result: r, error: null);
    } on FileSystemException catch (e) {
      return FileResult(result: null, error: e);
    }
  }

  Future<FileResult> saveTextFile(
      {required String path, required String content}) async {
    try {
      File textFile = File(path);
      var r = await textFile.writeAsString(content);
      return FileResult(result: r.path, error: null);
    } on FileSystemException catch (e) {
      return FileResult(result: null, error: e);
    }
  }

  Future<FileResult> openTextFile() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      // Canceled
    } else {
      File workspaceConfigFile = File("$selectedDirectory/workspace.json");
      File textFile = File("$selectedDirectory/todo.txt");
      if (await textFile.exists()) {
        if (await workspaceConfigFile.exists()) {
          return FileResult(
              result: "${workspaceConfigFile.path},${textFile.path}",
              error: null);
        } else {
          // Workspace file does not exist
          // Create new file or create a new workspace config file in the same folder with name of the file
          await workspaceConfigFile.create();
          await workspaceConfigFile.writeAsString(WorkspaceConfig(
            contexts: [],
            projects: [],
            metadatakeys: [],
          ).toRawJson());

          return FileResult(
              result: "${workspaceConfigFile.path},${textFile.path}",
              error: null);
        }
      } else {
        // Error code 687869: DoesNotExist
        return FileResult(result: null, error: 687869);
      }
    }
    return FileResult(result: null, error: null);
  }

  Future<FileResult> readWorkspaceConfig({required String path}) async {
    try {
      File configFile = File(path);
      var r = await configFile.readAsString();
      return FileResult(result: r, error: null);
    } on FileSystemException catch (e) {
      return FileResult(result: null, error: e);
    }
  }

  Future<FileResult> saveConfigFile(
      {required String path, required String content}) async {
    try {
      File configFile = File(path);
      var r = await configFile.writeAsString(content);
      return FileResult(result: r.path, error: null);
    } on FileSystemException catch (e) {
      return FileResult(result: null, error: e);
    }
  }
}

class FileResult {
  FileResult({
    this.result,
    this.error,
  });
  String? result;
  dynamic error;
}
