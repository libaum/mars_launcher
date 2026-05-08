
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionService {
  final settingsManager = getIt<SettingsManager>();
  final permissionCalendarGranted = ValueNotifier(false);

  PermissionService() {
    /// Defer the permission request until after the first frame so the
    /// system dialog does not pop up before the launcher UI has rendered.
    /// Only request when the calendar widget is actually enabled — no point
    /// asking a user who turned it off.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (settingsManager.calendarWidgetEnabledNotifier.value) {
        ensureCalendarPermission();
      }
    });

    /// Re-request when user enables the calendar widget later (e.g. after
    /// initially denying). No-op if already granted.
    settingsManager.calendarWidgetEnabledNotifier.addListener(() {
      if (settingsManager.calendarWidgetEnabledNotifier.value) {
        ensureCalendarPermission();
      }
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
