import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/app_search_manager.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/pages/settings/colors.dart';
import 'package:mars_launcher/pages/settings/credits.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/pages/home/app_search_fragment.dart';
import 'package:mars_launcher/pages/settings/utils.dart';
import 'package:mars_launcher/pages/settings/hidden_apps.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/strings.dart';

const ROW_PADDING_RIGHT = 50.0; // TODO look for overflow

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final themeManager = getIt<ThemeManager>();
  final permissionService = getIt<PermissionService>();
  final settingsManager = getIt<SettingsManager>();
  final sharedPrefsManager = getIt<SharedPrefsManager>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void pushAppSearch(ValueNotifierWithKey<AppInfo> specialAppNotifier) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
          builder: (_) => Scaffold(
                  body: SafeArea(
                      child: AppSearchFragment(
                appSearchMode: AppSearchMode.chooseSpecialShortcut,
                specialShortcutAppNotifier: specialAppNotifier,
              )))),
    );
  }

  void pushOtherPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        themeManager.toggleTheme();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, ROW_PADDING_RIGHT, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Strings.settingsTitle, style: TEXT_STYLE_TITLE),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        /// SET DEFAULT LAUNCHER
                        GenericSettingsButton(
                            onPressed: () {
                              settingsManager.openDefaultLauncherSettings();
                            },
                            name: Strings.settingsChangeDefaultLauncher),

                        /// APPS NUMBER
                        buildAppsNumberRow(),

                        /// CLOCK APP
                        buildTopRowAppRow(
                            specialShortcutAppNotifier: appShortcutsManager.clockAppNotifier,
                            widgetEnabledNotifier: settingsManager.clockWidgetEnabledNotifier,
                            name: Strings.settingsClockApp),

                        /// WEATHER APP
                        buildWeatherAppRow(context),

                        /// CALENDAR APP
                        buildTopRowAppRow(
                            specialShortcutAppNotifier: appShortcutsManager.calendarAppNotifier,
                            widgetEnabledNotifier: settingsManager.calendarWidgetEnabledNotifier,
                            name: Strings.settingsCalendarApp),

                        /// BATTERY
                        buildTopRowAppRow(
                            specialShortcutAppNotifier: appShortcutsManager.batteryAppNotifier,
                            widgetEnabledNotifier: settingsManager.batteryWidgetEnabledNotifier,
                            name: Strings.settingsBattery),

                        /// SWIPE LEFT
                        GenericSettingsButton(
                            onPressed: () {
                              pushAppSearch(appShortcutsManager.swipeLeftAppNotifier);
                            },
                            name: Strings.settingsSwipeLeft),

                        /// SWIPE RIGHT
                        GenericSettingsButton(
                            onPressed: () {
                              pushAppSearch(appShortcutsManager.swipeRightAppNotifier);
                            },
                            name: Strings.settingsSwipeRight),

                        /// COLORS
                        GenericSettingsButton(
                            onPressed: () {
                              pushOtherPage(SettingsColors());
                            },
                            name: Strings.settingsColors),

                        /// HIDDEN APPS
                        GenericSettingsButton(
                            onPressed: () {
                              pushOtherPage(HiddenApps());
                            },
                            name: Strings.settingsHiddenApps),

                        /// CREDITS
                        GenericSettingsButton(
                            onPressed: () {
                              pushOtherPage(Credits());
                            },
                            name: Strings.settingsCredits),
                      ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildTopRowAppRow(
      {required ValueNotifierWithKey<AppInfo> specialShortcutAppNotifier, required ValueNotifierWithKey<bool> widgetEnabledNotifier, required String name}) {
    return Row(
      children: [
        GenericSettingsButton(
            onPressed: () {
              pushAppSearch(specialShortcutAppNotifier);
            },
            name: name),
        Expanded(
          child: Container(),
        ),
        ShowHideButton(
          notifier: widgetEnabledNotifier,
          onPressed: () {
            settingsManager.setNotifierValueAndSave(widgetEnabledNotifier);
          },
        ),
      ],
    );
  }

  Row buildWeatherAppRow(BuildContext context) {
    return Row(
      children: [
        GenericSettingsButton(
            onPressed: () {
              pushAppSearch(appShortcutsManager.weatherAppNotifier);
            },
            name: Strings.settingsWeatherApp),
        Expanded(child: Container()),
        ShowHideButton(
          notifier: settingsManager.weatherWidgetEnabledNotifier,
          onPressed: () {
            if (sharedPrefsManager.readData(Keys.weatherActivatedAtLeaseOnce) == null) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Requesting location permission"),
                      titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                      content: Text(
                        "mars launcher collects location data to be able to show accurate temperature information.",
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        TextButton(
                          style: ButtonStyle(foregroundColor: MaterialStatePropertyAll<Color>(Colors.blue)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  }).then((value) {
                settingsManager.setNotifierValueAndSave(settingsManager.weatherWidgetEnabledNotifier);
              });

              sharedPrefsManager.saveData(Keys.weatherActivatedAtLeaseOnce, true);
            } else {
              settingsManager.setNotifierValueAndSave(settingsManager.weatherWidgetEnabledNotifier);
            }
          },
        ),
      ],
    );
  }

  Row buildAppsNumberRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GenericSettingsButton(
            onPressed: () {
              settingsManager.setNotifierValueAndSave(settingsManager.numberOfShortcutItemsNotifier);
            },
            name: Strings.settingsAppNumber),
        Expanded(child: Container()),
        ValueListenableBuilder<int>(
            valueListenable: settingsManager.numberOfShortcutItemsNotifier,
            builder: (context, numOfShortcutItems, child) {
              return SizedBox(
                  width: 86,
                  child: TextButton(
                    onPressed: () {
                      settingsManager.setNotifierValueAndSave(settingsManager.numberOfShortcutItemsNotifier);
                    },
                    child: Center(child: Text(numOfShortcutItems.toString(), style: TEXT_STYLE_ITEMS)),
                  ));
            }),
      ],
    );
  }
}

class ShowHideButton extends StatelessWidget {
  const ShowHideButton({Key? key, required this.notifier, required this.onPressed}) : super(key: key);

  final ValueNotifierWithKey<bool> notifier;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: notifier,
          builder: (context, enabled, child) {
            return SizedBox(
              width: 70,
              child: Center(
                child: Text(
                  enabled ? "hide" : "show",
                  style: TEXT_STYLE_ITEMS,
                ),
              ),
            );
          }),
    );
  }
}
