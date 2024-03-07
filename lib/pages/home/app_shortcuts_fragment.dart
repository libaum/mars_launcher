/// Shortcut apps fragment in middle of home screen

import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/app_search_manager.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/pages/home/app_search_fragment.dart';
import 'package:mars_launcher/pages/fragments/cards/app_card.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/services/service_locator.dart';

class AppShortcutsFragment extends StatelessWidget {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final settingsLogic = getIt<SettingsManager>();

  callbackOpenApp(BuildContext context, AppInfo appInfo) {
    appInfo.open();
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
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: shortcutApps
                        .getRange(0, numOfShortcutItems)
                        .map((app) => AppCard(
                              appInfo: app,
                              isShortcutItem: true,
                              callbackHandleOnPress: callbackOpenApp,
                              callbackHandleOnLongPress: callbackHandleOnLongPress,
                            ))
                        .toList(),
                  );
                }),
          );
        });
  }

}
