import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/constants/global.dart';
import 'package:mars_launcher/logic/apps_manager.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/strings.dart';

final Map<String, AppInfo> MAP_SHORTCUT_TYPE_TO_UNINITIALIZED_APP_INFO = {
  Keys.typeAppClock: AppInfo(packageName: Strings.packageNameClockUninitialized, appName: Strings.appNameUninitialized),
  Keys.typeAppBattery: AppInfo(packageName: Strings.packageNameBatteryUninitialized, appName: Strings.appNameUninitialized),
  Keys.typeAppCalendar: AppInfo(packageName: Strings.packageNameCalendarUninitialized, appName: Strings.appNameUninitialized),
  Keys.typeAppWeather: AppInfo(packageName: Strings.packageNameWeatherUninitialized, appName: Strings.appNameUninitialized),
  Keys.typeAppSwipeLeft: AppInfo(packageName: Strings.packageNameSwipeLeftUninitialized, appName: Strings.appNameUninitialized),
  Keys.typeAppSwipeRight: AppInfo(packageName: Strings.packageNameSwipeRightUninitialized, appName: Strings.appNameUninitialized),
};

class AppShortcutsManager {
  final sharedPrefsManager = getIt<SharedPrefsManager>();

  late final ValueNotifierWithKey<AppInfo> clockAppNotifier;
  late final ValueNotifierWithKey<AppInfo> batteryAppNotifier;
  late final ValueNotifierWithKey<AppInfo> calendarAppNotifier;
  late final ValueNotifierWithKey<AppInfo> weatherAppNotifier;
  late final ValueNotifierWithKey<AppInfo> swipeLeftAppNotifier;
  late final ValueNotifierWithKey<AppInfo> swipeRightAppNotifier;
  late final ShortcutAppsNotifier shortcutAppsNotifier;

  final appsManager = getIt<AppsManager>();

  AppShortcutsManager() {
    print("[$runtimeType] INITIALIZING");

    if (sharedPrefsManager.readData(Keys.appsAreSaved) ?? false) {
      loadShortcutAppsFromSharedPrefs();
    } else {
      generateGenericShortcutApps();
      if (LOAD_APPS_FROM_JSON) {
        loadShortcutAppsFromJson();
      }
      saveShortcutAppsToSharedPrefs(); /// Save shortcut apps and set appsAreSaved to true
    }

    appsManager.renamedAppsUpdatedNotifier.addListener(() {
      updateDisplayNames();
    });
  }

  AppInfo getUninitializedAppInfo(String shortcutType) {
    return MAP_SHORTCUT_TYPE_TO_UNINITIALIZED_APP_INFO[shortcutType]!;
  }

  AppInfo getUninitializedShortcutAppInfo(int index) {
    return AppInfo(packageName: index.toString(), appName: Strings.appNameUninitialized);
  }

  void generateGenericShortcutApps() async {
    /// Assign generic display name to shortcutApps, set packageName = index
    shortcutAppsNotifier = ShortcutAppsNotifier(List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (index) => getUninitializedShortcutAppInfo(index)));

    clockAppNotifier = ValueNotifierWithKey(getUninitializedAppInfo(Keys.typeAppClock), Keys.typeAppClock);
    batteryAppNotifier = ValueNotifierWithKey(getUninitializedAppInfo(Keys.typeAppBattery), Keys.typeAppBattery);
    calendarAppNotifier = ValueNotifierWithKey(getUninitializedAppInfo(Keys.typeAppCalendar), Keys.typeAppCalendar);
    weatherAppNotifier = ValueNotifierWithKey(getUninitializedAppInfo(Keys.typeAppWeather), Keys.typeAppWeather);
    swipeLeftAppNotifier = ValueNotifierWithKey(getUninitializedAppInfo(Keys.typeAppSwipeLeft), Keys.typeAppSwipeLeft);
    swipeRightAppNotifier = ValueNotifierWithKey(getUninitializedAppInfo(Keys.typeAppSwipeRight), Keys.typeAppSwipeRight);
  }

  void loadShortcutAppsFromJson() async {
    print("[$runtimeType] LOADING APPS FROM JSON");
    try {
      final String response = await rootBundle.loadString('assets/apps.json');
      final shortcutAppsJson = await json.decode(response);

      shortcutAppsNotifier.value = List.generate(
          MAX_NUM_OF_SHORTCUT_ITEMS, (index) => AppInfo(packageName: shortcutAppsJson["shortcutApps"][index][JsonKeys.packageName], appName: shortcutAppsJson["shortcutApps"][index]["name"]));

      clockAppNotifier.value = AppInfo(packageName: shortcutAppsJson["clock"][JsonKeys.packageName], appName: shortcutAppsJson["clock"][JsonKeys.appName]);
      calendarAppNotifier.value = AppInfo(packageName: shortcutAppsJson["calendar"][JsonKeys.packageName], appName: shortcutAppsJson["calendar"][JsonKeys.appName]);
      weatherAppNotifier.value = AppInfo(packageName: shortcutAppsJson["weather"][JsonKeys.packageName], appName: shortcutAppsJson["weather"][JsonKeys.appName]);
      swipeLeftAppNotifier.value = AppInfo(packageName: shortcutAppsJson["camera"][JsonKeys.packageName], appName: shortcutAppsJson["camera"][JsonKeys.appName]);
      swipeRightAppNotifier.value = AppInfo(packageName: shortcutAppsJson["contacts"][JsonKeys.packageName], appName: shortcutAppsJson["contacts"][JsonKeys.appName]);
    } catch (e) {
      print("[$runtimeType] error loading from json: $e");
    }
  }

  /// Loading shortcut apps from shared prefs, if not present initialize with AppInfo
  Future<void> loadShortcutAppsFromSharedPrefs() async {
    print("[$runtimeType] LOADING APPS FROM SHARED PREFS");
    shortcutAppsNotifier = ShortcutAppsNotifier(List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (index) =>
        AppInfo.fromJsonString(sharedPrefsManager.readDataWithDefault("shortcut$index", getUninitializedShortcutAppInfo(index)))));

    final jsonStringClockApp = sharedPrefsManager.readData(Keys.typeAppClock) ?? getUninitializedAppInfo(Keys.typeAppClock).toJsonString();
    final jsonStringBatteryApp = sharedPrefsManager.readData(Keys.typeAppBattery) ?? getUninitializedAppInfo(Keys.typeAppBattery).toJsonString();
    final jsonStringCalendarApp = sharedPrefsManager.readData(Keys.typeAppCalendar) ?? getUninitializedAppInfo(Keys.typeAppCalendar).toJsonString();
    final jsonStringWeatherApp = sharedPrefsManager.readData(Keys.typeAppWeather) ?? getUninitializedAppInfo(Keys.typeAppWeather).toJsonString();
    final jsonStringSwipeLeftApp = sharedPrefsManager.readData(Keys.typeAppSwipeLeft) ?? getUninitializedAppInfo(Keys.typeAppSwipeLeft).toJsonString();
    final jsonStringSwipeRightApp = sharedPrefsManager.readData(Keys.typeAppSwipeRight) ?? getUninitializedAppInfo(Keys.typeAppSwipeRight).toJsonString();

    clockAppNotifier = ValueNotifierWithKey(AppInfo.fromJsonString(jsonStringClockApp), Keys.typeAppClock);
    batteryAppNotifier = ValueNotifierWithKey(AppInfo.fromJsonString(jsonStringBatteryApp), Keys.typeAppBattery);
    calendarAppNotifier = ValueNotifierWithKey(AppInfo.fromJsonString(jsonStringCalendarApp), Keys.typeAppCalendar);
    weatherAppNotifier = ValueNotifierWithKey(AppInfo.fromJsonString(jsonStringWeatherApp), Keys.typeAppWeather);
    swipeLeftAppNotifier = ValueNotifierWithKey(AppInfo.fromJsonString(jsonStringSwipeLeftApp), Keys.typeAppSwipeLeft);
    swipeRightAppNotifier = ValueNotifierWithKey(AppInfo.fromJsonString(jsonStringSwipeRightApp), Keys.typeAppSwipeRight);
  }

  void saveShortcutAppsToSharedPrefs() {
    int i = 0;
    for (var appInfo in shortcutAppsNotifier.value) {
      sharedPrefsManager.saveData("shortcut$i", appInfo.toJsonString());
      i++;
    }
    sharedPrefsManager.saveData(clockAppNotifier.key, clockAppNotifier.value.toJsonString());
    sharedPrefsManager.saveData(batteryAppNotifier.key, batteryAppNotifier.value.toJsonString());
    sharedPrefsManager.saveData(calendarAppNotifier.key, calendarAppNotifier.value.toJsonString());
    sharedPrefsManager.saveData(weatherAppNotifier.key, weatherAppNotifier.value.toJsonString());
    sharedPrefsManager.saveData(swipeLeftAppNotifier.key, swipeLeftAppNotifier.value.toJsonString());
    sharedPrefsManager.saveData(swipeRightAppNotifier.key, swipeRightAppNotifier.value.toJsonString());

    sharedPrefsManager.saveData(Keys.appsAreSaved, true);
  }

  void setSpecialShortcutValue(ValueNotifierWithKey notifier, AppInfo appInfo) {
    notifier.value = appInfo;
    sharedPrefsManager.saveData(notifier.key, notifier.value.toJsonString());
  }

  void updateDisplayNames() {
    for (int index = 0; index < shortcutAppsNotifier.value.length; index++) {
      final shortcutApp = shortcutAppsNotifier.value[index];
      final displayName = appsManager.renamedApps[shortcutApp.packageName];

      final isDisplayNameNew = displayName != null && displayName != shortcutApp.displayName;
      final hasDisplayNameBeenReset = displayName == null && shortcutApp.appName != shortcutApp.displayName; /// Check if display name has been reset
      if (isDisplayNameNew || hasDisplayNameBeenReset) {
        shortcutApp.displayName = displayName;
        shortcutAppsNotifier.replaceShortcut(index, shortcutApp);
      }
    }
  }
}

class ShortcutAppsNotifier extends ValueNotifier<List<AppInfo>> {
  final sharedPrefsManager = getIt<SharedPrefsManager>();

  ShortcutAppsNotifier(List<AppInfo> initialShortcutApps) : super(initialShortcutApps);

  void replaceShortcut(int index, AppInfo newShortcutApp) async {
    print("[$runtimeType] replacing index: $index");

    if (List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (i) => i).contains(index)) {
      value[index] = newShortcutApp;
      print("[$runtimeType] replaced shortcut");
      notifyListeners();
    }
    sharedPrefsManager.saveData("shortcut$index", newShortcutApp.toJsonString());
  }
}
