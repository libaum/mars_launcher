/// Shortcut apps fragment in middle of home screen

import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/app_search_manager.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/pages/home/app_search_fragment.dart';
import 'package:mars_launcher/pages/fragments/cards/app_card.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/strings.dart';

class AppShortcutsFragment extends StatelessWidget {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final settingsLogic = getIt<SettingsManager>();

  callbackOpenApp(BuildContext context, AppInfo appInfo) {
    appInfo.open();
  }

  String? _placeholderFor(AppInfo app, int index) {
    if (app.appName != Strings.appNameUninitialized) return null;
    if (index < Strings.shortcutPlaceholders.length) {
      return Strings.shortcutPlaceholders[index];
    }
    return Strings.shortcutPlaceholderDefault;
  }

  callbackHandleOnLongPress(BuildContext context, AppInfo appInfo) {
    int shortcutIndex = appShortcutsManager.shortcutAppsNotifier.value.indexOf(appInfo);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => Scaffold(
              body: SafeArea(
                  child: AppSearchFragment(
                      appSearchMode: AppSearchMode.chooseShortcut,
                      shortcutIndex: shortcutIndex)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: settingsLogic.numberOfShortcutItemsNotifier,
        builder: (context, numOfShortcutItems, child) {
          return Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0, 30, 20),
            child: ValueListenableBuilder<List<AppInfo>>(
                valueListenable: appShortcutsManager.shortcutAppsNotifier,
                builder: (context, shortcutApps, child) {
                  final visibleApps = shortcutApps.getRange(0, numOfShortcutItems).toList();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < visibleApps.length; i++)
                        AppCard(
                          appInfo: visibleApps[i],
                          isShortcutItem: true,
                          placeholderText: _placeholderFor(visibleApps[i], i),
                          callbackHandleOnPress: callbackOpenApp,
                          callbackHandleOnLongPress: callbackHandleOnLongPress,
                        ),
                    ],
                  );
                }),
          );
        });
  }

}
