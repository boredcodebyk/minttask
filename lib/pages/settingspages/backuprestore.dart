import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:parchment/codecs.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:minttask/model/db.dart';
import 'package:minttask/model/db_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool exportDescriptionAsMD = false;
  FleatherController fleatherController = FleatherController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Backup"),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text("Markdown"),
                  subtitle: const Text("Export description as markdown"),
                  value: exportDescriptionAsMD,
                  onChanged: (value) => setState(
                    () {
                      exportDescriptionAsMD = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FilledButton(
                      onPressed: () async {
                        Directory tempDir = await getTemporaryDirectory();

                        const deltaToMd = ParchmentMarkdownCodec();
                        if (tempDir.existsSync()) {
                          tempDir.deleteSync(recursive: true);
                        }

                        tempDir.createSync(recursive: true);
                        final timeNow =
                            DateFormat("yyyy-MM-dd_h-m").format(DateTime.now());
                        final backupNameTemp = 'db_backup_$timeNow.json';
                        final backupPathTemp =
                            '${tempDir.path}/$backupNameTemp';

                        if (!mounted) return;
                        final collectionsJSON = await IsarHelper.instance.isar;
                        final jsonExport = await collectionsJSON.taskDatas
                            .where()
                            .exportJson();
                        File(backupPathTemp)
                            .writeAsStringSync(jsonEncode(jsonExport));
                        final backupName = 'backup_$timeNow.zip';
                        final backupPath = '${tempDir.path}/$backupName';
                        var encoder = ZipFileEncoder();
                        encoder.create(backupPath);

                        encoder.addFile(File(backupPathTemp));
                        if (exportDescriptionAsMD) {
                          for (var task in await collectionsJSON.taskDatas
                              .where()
                              .filter()
                              .trashEqualTo(false)
                              .findAll()) {
                            File f = File(
                                '${tempDir.path}/${task.id}_${task.title!.trim()}.md');
                            f.writeAsStringSync(deltaToMd.encoder.convert(
                                ParchmentDocument.fromJson(
                                    jsonDecode(task.description!))));
                            encoder.addFile(f);
                          }
                        }
                        encoder.close();

                        String? selectedDirectory =
                            await FilePicker.platform.getDirectoryPath();
                        if (selectedDirectory == null) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Backup stopped"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          File(backupPath)
                              .copy("$selectedDirectory/$backupName");
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Saved in $selectedDirectory"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }

                        tempDir.deleteSync(recursive: true);
                      },
                      child: const Text("Backup")),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RestorePage extends StatefulWidget {
  const RestorePage({super.key});

  @override
  State<RestorePage> createState() => _RestorePageState();
}

class _RestorePageState extends State<RestorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Restore"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      "Restoring will add tasks from backup to existing database so that your current data is not overwriten."),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: FilledButton(
                        onPressed: () async {
                          Directory tempDir = await getTemporaryDirectory();
                          if (tempDir.existsSync()) {
                            tempDir.deleteSync(recursive: true);
                          }

                          tempDir.createSync(recursive: true);
                          FilePickerResult? selectedZip =
                              await FilePicker.platform.pickFiles();
                          if (selectedZip != null) {
                            File file = File(selectedZip.files.single.path!);
                            var tempName = file.path.split('/').last;

                            final archive = ZipDecoder().decodeBytes(File(
                                    join(tempDir.path, "file_picker", tempName))
                                .readAsBytesSync());
                            if (!mounted) return;

                            for (var file in archive) {
                              final filename = file.name;
                              if (file.isFile &&
                                  "${filename.split("_")[0]}_${filename.split("_")[1]}" ==
                                      "db_backup" &&
                                  filename.split(".").last == "json") {
                                final data = file.content as List<int>;
                                String decoded =
                                    jsonDecode(jsonEncode(utf8.decode(data)));

                                List<dynamic> jsond = jsonDecode(decoded);
                                for (var element in jsond) {
                                  IsarHelper.instance.restoreFromJson(
                                      element["title"],
                                      element["description"],
                                      element["doneStatus"],
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          element["dateCreated"]),
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          element["dateModified"]),
                                      element["labels"],
                                      element["archive"],
                                      element["trash"],
                                      element["doNotify"],
                                      element["notifyID"],
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          element["notifyTime"]),
                                      element["priority"],
                                      element["pinned"]);
                                }
                              }
                            }
                          } else {
                            // User canceled the picker
                          }
                          tempDir.deleteSync(recursive: true);
                        },
                        child: const Text("Restore")),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
