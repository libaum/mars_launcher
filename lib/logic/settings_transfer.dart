import 'dart:convert';
import 'dart:io';

import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:path_provider/path_provider.dart';

/// Admin-only settings transfer. Dumps / restores the full SharedPreferences
/// state as JSON in the app's external files dir, which adb can read and write
/// without root:
///   /sdcard/Android/data/<applicationId>/files/mars_settings.json
///
/// Triggered by hidden search keywords ([exportSettingsCode] /
/// [importSettingsCode]) and only when the private Mars apps are already
/// unlocked, so normal users never reach it. Pull/push it with settings.sh.
const exportSettingsCode = "#exportsettings";
const importSettingsCode = "#importsettings";

const _settingsFileName = "mars_settings.json";

Future<File?> _settingsFile() async {
  final dir = await getExternalStorageDirectory();
  if (dir == null) return null;
  return File("${dir.path}/$_settingsFileName");
}

/// Write all preferences to the JSON file. Returns the file path on success.
Future<String?> exportSettings() async {
  final file = await _settingsFile();
  if (file == null) return null;
  final data = getIt<SharedPrefsManager>().exportAll();
  await file.writeAsString(const JsonEncoder.withIndent("  ").convert(data));
  return file.path;
}

/// Read the JSON file and overwrite all preferences with its contents.
/// The app must be restarted afterwards for managers to reload from prefs.
/// Returns the file path on success, or null if the file is missing/invalid.
Future<String?> importSettings() async {
  final file = await _settingsFile();
  if (file == null || !await file.exists()) return null;
  try {
    final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    await getIt<SharedPrefsManager>().importAll(data);
    return file.path;
  } catch (_) {
    return null;
  }
}
