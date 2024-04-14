import 'dart:io';

import 'dart:convert';

class FileModel {
  saveFile(String path, String content) async {
    File outputFile = File(path);
    await outputFile.writeAsString(content);
  }

  loadFile(String path, String state) async {
    try {
      final todotxt = File(path);
      state = await todotxt.readAsString();
    } catch (e) {
      print(e);
    }
  }

  loadWorkspaceSettingsFile(String path, String state) async {
    try {
      final wsf = File(path);
      state = await wsf.readAsString();
    } catch (e) {
      print(e);
    }
  }
}

class WorkspaceConfig {
  List<String>? contexts;
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
            : List<String>.from(json["contexts"]!.map((x) => x)),
        projects: json["projects"] == null
            ? []
            : List<String>.from(json["projects"]!.map((x) => x)),
        metadatakeys: json["metadatakeys"] == null
            ? []
            : List<String>.from(json["metadatakeys"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "contexts":
            contexts == null ? [] : List<dynamic>.from(contexts!.map((x) => x)),
        "projects":
            projects == null ? [] : List<dynamic>.from(projects!.map((x) => x)),
        "metadatakeys": metadatakeys == null
            ? []
            : List<dynamic>.from(metadatakeys!.map((x) => x)),
      };
}

class FileManagementModel {
  readTextFile({required String path}) async {
    try {
      File textFile = File(path);
      var r = await textFile.readAsString();
      return _FileResult(result: r, error: null);
    } on FileSystemException catch (e) {
      return _FileResult(result: null, error: e);
    }
  }

  saveTextFile({required String path, required String content}) async {
    try {
      File textFile = File(path);
      var r = await textFile.writeAsString(content);
      return _FileResult(result: r.path, error: null);
    } on FileSystemException catch (e) {
      return _FileResult(result: null, error: e);
    }
  }
}

class _FileResult {
  _FileResult({
    this.result,
    this.error,
  });
  String? result;
  dynamic error;
}
