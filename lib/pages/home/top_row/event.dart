import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/calendar_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/pages/todo_list.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

class EventView extends StatefulWidget {
  const EventView({Key? key}) : super(key: key);

  @override
  State<EventView> createState() => _EventViewState();
}

// Horizontal padding on the calendar TextButton — must match the styleFrom below
// so _fitFromEnd receives the actual text display width, not the button width.
const _kCalendarHPad = 8.0;

class _EventViewState extends State<EventView> {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final calenderLogic = CalenderManager();

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder is OUTSIDE TextButton so it sees the real available width
    // from Align/Expanded. We subtract the button's horizontal padding so the
    // text is fitted to the actual display area, not the full button width.
    return LayoutBuilder(
      builder: (context, constraints) {
        final style = DefaultTextStyle.of(context).style.merge(TEXT_STYLE_TOP_ROW);
        return ValueListenableBuilder<String>(
          valueListenable: calenderLogic.eventNotifier,
          builder: (context, event, child) {
            final displayText = _fitFromEnd(
                event, constraints.maxWidth - _kCalendarHPad * 2, style);
            return TextButton(
              onPressed: () => appShortcutsManager.calendarAppNotifier.value.open(),
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TodoList()),
                );
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: _kCalendarHPad),
              ),
              child: Text(displayText, softWrap: false, style: TEXT_STYLE_TOP_ROW),
            );
          },
        );
      },
    );
  }

  /// Returns the longest suffix of [text] (prefixed with "..") that fits in [maxWidth]
  /// when rendered with [style]. Returns the full text if it already fits.
  String _fitFromEnd(String text, double maxWidth, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    if (painter.width <= maxWidth) return text;

    // Binary search for the longest suffix length whose ".."-prefixed form fits.
    int lo = 0;
    int hi = text.length;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      final candidate = ".." + text.substring(text.length - mid);
      painter.text = TextSpan(text: candidate, style: style);
      painter.layout();
      if (painter.width <= maxWidth) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    return ".." + text.substring(text.length - lo);
  }

  @override
  void dispose() {
    calenderLogic.stopTimer();
    super.dispose();
  }
}
