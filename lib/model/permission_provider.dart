import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionState extends ChangeNotifier {
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  PermissionStatus get permissionStatus => _permissionStatus;

  Future<void> requestPermission() async {
    _permissionStatus = await Permission.manageExternalStorage.request();
    notifyListeners();
  }

  Future<void> checkPermissionStatus() async {
    _permissionStatus = await Permission.manageExternalStorage.status;
    notifyListeners();
  }
}

final permissionStateProvider =
    ChangeNotifierProvider<AppPermissionState>((ref) {
  return AppPermissionState();
});
