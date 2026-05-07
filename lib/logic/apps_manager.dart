import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/strings.dart';
import 'package:mars_launcher/constants/method_channels.dart';


class AppsManager {
  static const MethodChannel _installedAppsChannel    = MethodChannel(MethodChannels.installedApps);
  static const MethodChannel _launchAppChannel        = MethodChannel(MethodChannels.launchApp);
  static const MethodChannel _openAppSettingsChannel  = MethodChannel(MethodChannels.openAppSettings);
  static const MethodChannel _notifyAppChangesChannel = MethodChannel(MethodChannels.notifyAppChanges);

  /// LIST of INSTALLED APPs
  final appsNotifier = ValueNotifier<List<AppInfo>>([]);

  /// Expose sync state for loading UI.
  final ValueNotifier<bool> syncingNotifier = ValueNotifier(false);

  final sharedPrefsManager = getIt<SharedPrefsManager>();

  /// LIST of HIDDEN APPs (as packageName)
  late final ValueNotifier<Set<String>> hiddenAppsNotifier;

  /// MAP of RENAMED APPs
  final Map<String, String> renamedApps = {}; /// {"packageName": "displayName"}
  final ValueNotifier<bool> renamedAppsUpdatedNotifier = ValueNotifier(false);

  var currentlySyncing = false;
  bool _hasLoadedApps = false;
  bool suppressLifecycleReset = false;

  AppsManager() {
    print("[$runtimeType] INITIALISING");
    hiddenAppsNotifier = ValueNotifier((sharedPrefsManager.readStringList(Keys.hiddenApps) ?? []).toSet());
    loadRenamedAppsFromSharedPrefs();

    /// Listen to change of apps (install/uninstall)
    _notifyAppChangesChannel.setMethodCallHandler(_handleAppChange);
  }

  Future<void> _handleAppChange(MethodCall call) async {
    if (call.method != 'onAppRemoved' && call.method != 'onAppInstalled') return;
    final packageName = call.arguments as String;
    print("[$runtimeType] received ${call.method} for packageName: $packageName");

    if (call.method == 'onAppRemoved') {
      appsNotifier.value = appsNotifier.value
          .where((app) => app.packageName != packageName)
          .toList();
      renamedApps.remove(packageName);
      final updated = Set<String>.from(hiddenAppsNotifier.value)..remove(packageName);
      if (updated.length != hiddenAppsNotifier.value.length) {
        hiddenAppsNotifier.value = updated;
        sharedPrefsManager.saveData(Keys.hiddenApps, updated.toList());
      }
    } else if (call.method == 'onAppInstalled') {
      if (!currentlySyncing) {
        currentlySyncing = true;
        await syncInstalledApps();
        currentlySyncing = false;
      }
    }
  }

  /// Startet eine App anhand ihres Paketnamens
  Future<bool> launchApp(String packageName) async {
    try {
      final bool success = await _launchAppChannel.invokeMethod('launchApp', {'packageName': packageName});
      return success;
    } on PlatformException catch (e) {
      print("Fehler beim Starten der App: ${e.message}");
      return false;
    }
  }

  /// Öffnet die Einstellungsseite einer App anhand ihres Paketnamens
  Future<bool> openAppSettings(String packageName) async {
    try {
      final bool success = await _openAppSettingsChannel.invokeMethod('openAppSettings', {'packageName': packageName});
      return success;
    } on PlatformException catch (e) {
      print("Fehler beim Öffnen der App-Einstellungen: ${e.message}");
      return false;
    }
  }

  Future<void> loadAndSyncApps({bool force = false}) async {
    if (_hasLoadedApps && !force) {
      return;
    }

    await syncInstalledApps();
  }

  void addOrUpdateRenamedApp(AppInfo appInfo, String newName) {
    if (appInfo.appName == newName) {
      renamedApps.remove(appInfo.packageName);
    } else {
      renamedApps[appInfo.packageName] = newName;
    }

    int appNotifierIndex = appsNotifier.value.indexWhere(
          (oldAppInfo) => oldAppInfo.packageName == appInfo.packageName,
    );
    if (appNotifierIndex != -1) {
      appsNotifier.value[appNotifierIndex].displayName = newName;
      appsNotifier.value.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
      appsNotifier.value = List.from(appsNotifier.value); // Trigger update
    }

    /// Notify that renamedApps have been updated
    renamedAppsUpdatedNotifier.value = !renamedAppsUpdatedNotifier.value;

    saveRenamedAppsToSharedPrefs();
  }

  void updateHiddenApps(String packageName, bool hide) {
    var updatedHiddenApps = Set.of(hiddenAppsNotifier.value);

    if (hide) { /// Add to hiddenApps if hide==true
      updatedHiddenApps.add(packageName);
    } else { /// Remove from hiddenApps if hide==false
      updatedHiddenApps.remove(packageName);
    }
    hiddenAppsNotifier.value = updatedHiddenApps;

    /// Save to shared prefs
    sharedPrefsManager.saveData(Keys.hiddenApps, hiddenAppsNotifier.value.toList());

    /// Update appsNotifier
    updateAppsNotifierWithHideStatus(packageName, hide);
  }

  updateAppsNotifierWithHideStatus(String hiddenAppPackageName, bool hideStatus)  {
    /// Update appsNotifier by replacing the element
    var appsCopy = List.of(appsNotifier.value);
    int appNotifierIndex = appsCopy.indexWhere(
          (appInfo) => appInfo.packageName == hiddenAppPackageName,
    );
    if (appNotifierIndex != -1) {
      appsCopy[appNotifierIndex].isHidden = hideStatus;
      appsNotifier.value = appsCopy; /// Trigger update
    }
  }

  syncInstalledApps() async {
    print("START SYNCING APPS");
    final stopwatch = Stopwatch()..start();
    syncingNotifier.value = true;

    try {
      List<AppInfo> apps = [];
      final List<dynamic> applications = await _installedAppsChannel.invokeMethod('getInstalledApps');

      for (var app in applications) {
        final Map<String, dynamic> appMap = Map<String, dynamic>.from(app);

        AppInfo appInfo = AppInfo(
            packageName: appMap['packageName'],
            appName: appMap['appName'],
            systemApp: bool.parse(appMap['isSystemApp']),
            isHidden: hiddenAppsNotifier.value.contains(appMap['packageName']), /// If in hiddenApps set hide status true else false
            displayName: renamedApps[appMap['packageName']] /// Get display name if in renamedApps else null
        );

        apps.add(appInfo);
      }

      /// Sort from A-Z
      apps.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
      appsNotifier.value = apps;
      _hasLoadedApps = true;
      print("[$runtimeType] syncInstalledApps() executed in ${stopwatch.elapsed.inMilliseconds}ms");
    } finally {
      syncingNotifier.value = false;
    }
  }

  loadRenamedAppsFromSharedPrefs() {
    final jsonString = sharedPrefsManager.readData(Keys.renamedApps);

    if (jsonString != null) {
      final Map<String, dynamic> loadedMap = json.decode(jsonString);
      renamedApps.clear();
      loadedMap.forEach((key, value) {
        renamedApps[key] = value;
      });
    }
  }

  saveRenamedAppsToSharedPrefs() {
    final jsonString = json.encode(renamedApps);
    sharedPrefsManager.saveData(Keys.renamedApps, jsonString);
  }
}
