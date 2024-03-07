/// Top row of home screen, contains widgets from pages/fragments/top_row

import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:mars_launcher/logic/battery_manager.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/logic/temperature_manager.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/pages/home/top_row/battery.dart';
import 'package:mars_launcher/pages/home/top_row/event.dart';
import 'package:mars_launcher/pages/home/top_row/clock.dart';
import 'package:mars_launcher/pages/home/top_row/temperature.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

class TopRow extends StatelessWidget {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final settingsManager = getIt<SettingsManager>();
  final batteryManager = getIt<BatteryManager>();
  final temperatureManager = getIt<TemperatureManager>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = isThemeDark(context);
    final is24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// CLOCK WIDGET
          ValueListenableBuilder<bool>(
              valueListenable: settingsManager.clockWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? TextButton(
                        onPressed: () =>
                            appShortcutsManager.clockAppNotifier.value.open(),
                        onLongPress: () {
                          openCreateAlarmDialog(
                              context, isDarkMode);
                        },
                        child: Clock(is24HourFormat: is24HourFormat,))
                    : TextButton(onPressed: () {}, child: const SizedBox.shrink());
              }),

          ValueListenableBuilder<bool>(
              valueListenable: settingsManager.batteryWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return Expanded(
                  child: Container(),
                  flex: isEnabled ? 1 : 0,
                );
              }),

          /// BATTERY WIDGET
          ValueListenableBuilder<bool>(
              valueListenable: settingsManager.batteryWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? TextButton(
                  onPressed: () => appShortcutsManager.batteryAppNotifier.value.open(),
                  child: ValueListenableBuilder<int>(
                      valueListenable:
                      batteryManager.batteryLevelNotifier,
                      builder: (context, batteryLevel, child) {
                        print("BUILDING BATTERYICON AGAIN: $batteryLevel");
                        return BatteryIcon(
                            batteryLevel: batteryLevel,
                            paintColor: Theme.of(context).primaryColor);
                      }),
                )
                    : const SizedBox.shrink();
              }),

          //
          ValueListenableBuilder<bool>(
              valueListenable: settingsManager.weatherWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return Expanded(
                  child: Container(),
                  flex: isEnabled ? 1 : 0,
                );
              }),

          /// WEATHER WIDGET
          ValueListenableBuilder<bool>(
              valueListenable: settingsManager.weatherWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? TextButton(
                        onPressed: () =>
                            appShortcutsManager.weatherAppNotifier.value.open(),
                        onLongPress: () {
                          temperatureManager.showSunriseSunsetForAFewSeconds();
                        },
                        child: Temperature(),
                      )
                    : const SizedBox.shrink();
              }),


          Expanded(
            child: Container(),
          ),

          /// CALENDAR WIDGET
          ValueListenableBuilder<bool>(
              valueListenable: settingsManager.calendarWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? EventView()
                    : TextButton(
                        onPressed: () {},
                        child: const SizedBox.shrink(),
                      ); // SizedBox.shrink();
              }),
        ],
      ),
    );
  }
}

void openCreateAlarmDialog(context, isDarkMode) async {
  final themeDark = basicDarkTheme;
  final themeLight = basicLightTheme;

  var time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    helpText: "Create a new alarm",
    builder: (context, child) {
      return Theme(
        data: isDarkMode ? themeDark : themeLight,
        child: child!,
      );
    },
  );
  if (time != null) {
    FlutterAlarmClock.createAlarm(hour: time.hour, minutes: time.minute);
  }
}
