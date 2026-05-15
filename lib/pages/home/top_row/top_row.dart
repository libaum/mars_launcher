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
import 'package:mars_launcher/theme/theme_manager.dart';

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
      child: LayoutBuilder(
        builder: (context, constraints) => ListenableBuilder(
          listenable: Listenable.merge([
            settingsManager.clockWidgetEnabledNotifier,
            settingsManager.batteryWidgetEnabledNotifier,
            settingsManager.weatherWidgetEnabledNotifier,
            settingsManager.calendarWidgetEnabledNotifier,
          ]),
          builder: (context, _) {
            final clockOn = settingsManager.clockWidgetEnabledNotifier.value;
            final batteryOn = settingsManager.batteryWidgetEnabledNotifier.value;
            final weatherOn = settingsManager.weatherWidgetEnabledNotifier.value;
            final calendarOn = settingsManager.calendarWidgetEnabledNotifier.value;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (clockOn)
                  TextButton(
                    onPressed: () => appShortcutsManager.clockAppNotifier.value.open(),
                    onLongPress: () => openCreateAlarmDialog(context, isDarkMode),
                    child: Clock(is24HourFormat: is24HourFormat),
                  ),
                if (weatherOn)
                  TextButton(
                    onPressed: () => appShortcutsManager.weatherAppNotifier.value.open(),
                    onLongPress: () => temperatureManager.showSunriseSunsetForAFewSeconds(),
                    child: Temperature(),
                  ),
                if (batteryOn)
                  TextButton(
                    onPressed: () => appShortcutsManager.batteryAppNotifier.value.open(),
                    child: ValueListenableBuilder<int>(
                      valueListenable: batteryManager.batteryLevelNotifier,
                      builder: (context, batteryLevel, _) => BatteryIcon(
                        batteryLevel: batteryLevel,
                        paintColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                if (calendarOn)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.45),
                    child: const EventView(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void openCreateAlarmDialog(context, isDarkMode) async {
  final themeManager = getIt<ThemeManager>();

  var time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    helpText: "Create a new alarm",
    builder: (context, child) {
      return Theme(
        data: isDarkMode ? themeManager.darkTheme : themeManager.lightTheme,
        child: child!,
      );
    },
  );
  if (time != null) {
    FlutterAlarmClock.createAlarm(hour: time.hour, minutes: time.minute);
  }
}
