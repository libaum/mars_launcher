import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          return Text(currentTime, style: TEXT_STYLE_TOP_ROW);
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
  Timer? _timer;
  final DateFormat _fmt;

  ClockLogic(bool is24HourFormat) : _fmt = DateFormat(is24HourFormat ? 'Hm' : 'jm') {
    _updateClock();
    _scheduleNextTick();
  }

  void _scheduleNextTick() {
    final now = DateTime.now();
    final msUntilNextMinute = (60 - now.second) * 1000 - now.millisecond;
    _timer = Timer(Duration(milliseconds: msUntilNextMinute), () {
      _updateClock();
      _scheduleNextTick();
    });
  }

  void _updateClock() {
    timeNotifier.value = _fmt.format(DateTime.now());
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
