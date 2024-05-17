import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionNotifier extends Notifier<PermissionStatus> {
  final Permission _permission = Permission.manageExternalStorage;

  @override
  PermissionStatus build() => PermissionStatus.denied;

  void requestPermission() {
    _permission.request().then(updatePermissionStatus);
  }

  void updatePermissionStatus(PermissionStatus status) {
    if (status != state) {
      state = status;
    }
  }

  void fetchPermissionStatus() {
    _permission.status.then(updatePermissionStatus);
  }

  void onStatusRequested(status) {
    _permission.status.then((value) {
      if (value != PermissionStatus.granted) {
        openAppSettings();
      } else {
        updatePermissionStatus(value);
      }
    });
  }
}

final permissionProvider =
    NotifierProvider<PermissionNotifier, PermissionStatus>(
        PermissionNotifier.new);
