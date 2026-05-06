import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/strings.dart';

const INDEX_TO_WEEKDAY = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday',
};

const INDEX_TO_MONTH = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

String getPostfixForDayIndex(index) {
  switch (index) {
    case 1:
      return "st";
    case 2:
      return "nd";
    default:
      return "th";
  }
}


class CalenderManager {
  final eventNotifier = ValueNotifier(Strings.textCalendarEmpty);
  final _deviceCalendarPlugin = DeviceCalendarPlugin();
  final permissionService = getIt<PermissionService>();
  var _calendars = <Calendar>[];
  var _lastUpdatedCalendars = DateTime.now();
  late Timer timer;
  var currentDate = "";

  CalenderManager() {
    updateEvents();
    timer = Timer.periodic(Duration(minutes: 1), (timer) => updateEvents());
    permissionService.permissionCalendarGranted.addListener(initializeEvents);
  }

  void initializeEvents() {
    if (permissionService.permissionCalendarGranted.value) {
      print("[$runtimeType] initializing events");
      permissionService.permissionCalendarGranted.removeListener(initializeEvents);
      updateEvents();
    }
  }

  Future updateEvents() async {
    DateTime now = DateTime.now();
    if (now.compareTo(_lastUpdatedCalendars) >= 0) {
      await _retrieveCalendars();
      _lastUpdatedCalendars = now.add(Duration(days: 7));
    }


    currentDate = "${INDEX_TO_WEEKDAY[now.weekday]},  ${now.day}${getPostfixForDayIndex(now.day)} ${INDEX_TO_MONTH[now.month]?.substring(0,3)}";
    // var event = "$currentDate\n${await _retrieveCalendarEvents()}";

    eventNotifier.value = await _retrieveCalendarEvents();
  }

  Future _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null ||
              permissionsGranted.data == false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            permissionsGranted.data == false) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      _calendars = calendarsResult.data as List<Calendar>;
    } on PlatformException catch (e) {
      print("[$runtimeType] $e");
    }
  }

  /// Reads calendar events
  /// returns next occuring event
  Future<String> _retrieveCalendarEvents() async {
    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day + 1);

    List<Event> events = [];
    for (Calendar calendar in _calendars) {
      var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendar.id, RetrieveEventsParams(startDate: now, endDate: midnight));
      events.addAll(calendarEventsResult.data as List<Event>);
    }
    String newNextEvent = Strings.textCalendarEmpty;
    events.removeWhere((e) => e.start == null);
    if (events.isNotEmpty) {
      events.sort((a, b) => a.start!.compareTo(b.start!));
      if (events.length > 1 && events.any((element) => element.allDay != true)) {
        events.removeWhere((element) => element.allDay == true);
      }

      var nextEvent = events.first;
      final title = nextEvent.title ?? "";
      if (nextEvent.allDay == true) {
        newNextEvent = title;
      } else {
        final start = nextEvent.start!;
        String startTime =
            "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}";
        newNextEvent = "$title ($startTime)";
      }
    }
    return newNextEvent;
  }

  void stopTimer() {
    timer.cancel();
  }
}
