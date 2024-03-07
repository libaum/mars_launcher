import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/theme/theme_constants.dart';



class Clock extends StatefulWidget {
  final bool is24HourFormat;

  const Clock({Key? key, required this.is24HourFormat}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late final clockLogic;

  @override
  void initState() {
    clockLogic = ClockLogic(widget.is24HourFormat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<String>(
        valueListenable: clockLogic.timeNotifier,
        builder: (context, currentTime, child) {
          return Text(
            currentTime,
            style: const TextStyle(
              fontSize: FONT_SIZE_CLOCK,
              fontFamily: FONT_REGULAR,
            ),
          );
        });
  }

  @override
  void dispose() {
    clockLogic.stopTimer();
    super.dispose();
  }
}

class ClockLogic {
  final timeNotifier = ValueNotifier("");
  late Timer timer;
  bool is24HourFormat;

  ClockLogic(is24HourFormat) : this.is24HourFormat = is24HourFormat {
    _updateClock();
    timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateClock());
  }

  void _updateClock() {
    var now = DateTime.now();
    String formattedTime = _formatTime(now);
    if (formattedTime != timeNotifier.value) {
      timeNotifier.value = formattedTime;
    }
  }

  String _formatTime(DateTime time) {
    String pattern = is24HourFormat ? 'Hm' : 'jm';
    return DateFormat(pattern).format(time);
  }

  void stopTimer() {
    timer.cancel();
  }
}
