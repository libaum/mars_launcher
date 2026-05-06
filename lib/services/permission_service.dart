
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionService {
  final permissionCalendarGranted = ValueNotifier(false);

  PermissionService() {
    /// Defer the permission request until after the first frame so the
    /// system dialog does not pop up before the launcher UI has rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ensureCalendarPermission();
    });
  }

  Future<void> ensureCalendarPermission() async {
    try {
      if (await Permission.calendarFullAccess.isGranted) {
        permissionCalendarGranted.value = true;
      } else {
        PermissionStatus status = await Permission.calendarFullAccess.request();
        permissionCalendarGranted.value = status.isGranted;
      }
    } on PlatformException catch (e) {
      print("[PermissionService] calendar permission request failed: $e");
    }
  }
}
