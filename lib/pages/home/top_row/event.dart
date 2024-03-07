import 'package:flutter/material.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/calendar_manager.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/pages/todo_list.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

class EventView extends StatefulWidget {
  const EventView({
    Key? key,
  }) : super(key: key);

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final settingsLogic = getIt<SettingsManager>();
  final calenderLogic = CalenderManager();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: settingsLogic.weatherWidgetEnabledNotifier,
        builder: (context, isWeatherEnabled, child) {
          var letterLength = isWeatherEnabled ? 15 : 21;
          return Container(
            constraints: BoxConstraints(maxWidth: isWeatherEnabled ? 140 : 180),
            child: TextButton(
              onPressed: () {
                appShortcutsManager.calendarAppNotifier.value.open();
              },
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const TodoList()),
                );
              },
              child: ValueListenableBuilder<String>(
                  valueListenable: calenderLogic.eventNotifier,
                  builder: (context, event, child) {
                    return Text(
                      event.length > letterLength
                          ? ".." + event.substring(event.length - letterLength)
                          : event,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: FONT_SIZE_EVENTS,
                        fontFamily: FONT_LIGHT,
                      ),
                    );
                  }),
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  alignment: Alignment.center,
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    calenderLogic.stopTimer();
    super.dispose();
  }
}
