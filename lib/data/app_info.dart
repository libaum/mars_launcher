import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:mars_launcher/logic/apps_manager.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/strings.dart';


class AppInfo {

  final String packageName;
  final String appName;
  final bool systemApp;
  var isHidden;

  String? _displayName;
  get displayName => _displayName ?? appName; /// If _displayName not set return appName
  set displayName(newName) => _displayName = newName;

  AppInfo({
    required this.packageName,
    required this.appName,
    this.systemApp = false,
    this.isHidden = false,
    String? displayName
  }) : _displayName = displayName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppInfo &&
          runtimeType == other.runtimeType &&
          packageName == other.packageName &&
          appName == other.appName &&
          systemApp == other.systemApp &&
          _displayName == other._displayName &&
          isHidden == other.isHidden;

  @override
  int get hashCode =>
      packageName.hashCode ^ appName.hashCode ^ systemApp.hashCode ^ _displayName.hashCode ^ isHidden.hashCode;

  void open() {
    if (this.packageName.isNotEmpty && this.appName != Strings.appNameUninitialized) {
      final appsManager = getIt<AppsManager>();
      appsManager.launchApp(packageName);
    } else {
      print("[$runtimeType] Could not open app: packageName is empty");
    }
  }

  void uninstall() async {
      final AndroidIntent intent = AndroidIntent(
        action: "android.intent.action.DELETE",
        data: "package:${this.packageName}",
      );
      await intent.launch();
  }


  void openSettings() {
    if (this.packageName.isNotEmpty && this.appName != Strings.appNameUninitialized) {
      final appsManager = getIt<AppsManager>();
      appsManager.openAppSettings(packageName);
    } else {
      print("[$runtimeType] Could not open app settings: packageName is empty");
    }
  }

  AppInfo.fromJson(Map<String, dynamic> json)
    : packageName = json[JsonKeys.packageName],
      appName = json[JsonKeys.appName],
      systemApp = json[JsonKeys.systemApp],
      isHidden = json[JsonKeys.appIsHidden],
      _displayName = json[JsonKeys.displayName];

  Map<String, dynamic> toJson() => {
    JsonKeys.packageName: packageName,
    JsonKeys.appName: appName,
    JsonKeys.systemApp: systemApp,
    JsonKeys.appIsHidden: isHidden,
    JsonKeys.displayName: _displayName,
  };

  static AppInfo fromJsonString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString) as Map<String, dynamic>;
    return AppInfo(
      packageName: json[JsonKeys.packageName],
      appName: json[JsonKeys.appName],
      systemApp: json[JsonKeys.systemApp],
      isHidden: json[JsonKeys.appIsHidden],
      displayName: json[JsonKeys.displayName],
    );
  }

  String toJsonString() => jsonEncode({
    JsonKeys.packageName: packageName,
    JsonKeys.appName: appName,
    JsonKeys.systemApp: systemApp,
    JsonKeys.appIsHidden: isHidden,
    JsonKeys.displayName: _displayName
  });



  void hide(bool value) {
    isHidden = value;
  }
}
