import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

class PermissionNotifier extends Notifier<PermissionStatus> {
  final Permission _permissionManageExternalStorage =
      Permission.manageExternalStorage;

  final Permission _permissionStorage = Permission.storage;

  @override
  PermissionStatus build() => PermissionStatus.denied;

  void requestPermission() {
    deviceInfo.androidInfo.then(
      (value) {
        value.version.sdkInt > 32
            ? _permissionManageExternalStorage
                .request()
                .then(updatePermissionStatus)
            : _permissionStorage.request().then(updatePermissionStatus);
      },
    );
  }

  void updatePermissionStatus(PermissionStatus status) {
    if (status != state) {
      state = status;
    }
  }

  void fetchPermissionStatus() {
    deviceInfo.androidInfo.then((value) {
      value.version.sdkInt > 32
          ? _permissionManageExternalStorage.status.then(updatePermissionStatus)
          : _permissionStorage.status.then(updatePermissionStatus);
    });
  }

  void onStatusRequested(status) {
    deviceInfo.androidInfo.then((value) {
      value.version.sdkInt > 32
          ? _permissionManageExternalStorage.status.then((value) {
              if (value != PermissionStatus.granted) {
                openAppSettings();
              } else {
                updatePermissionStatus(value);
              }
            })
          : _permissionStorage.status.then((value) {
              if (value != PermissionStatus.granted) {
                openAppSettings();
              } else {
                updatePermissionStatus(value);
              }
            });
    });
  }
}

final permissionProvider =
    NotifierProvider<PermissionNotifier, PermissionStatus>(
        PermissionNotifier.new);
