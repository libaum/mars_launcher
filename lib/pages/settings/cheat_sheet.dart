import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mars_launcher/theme/theme_constants.dart';
import 'package:mars_launcher/strings.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:mars_launcher/services/service_locator.dart';

const _sections = <(String, List<(String, String)>)>[
  ('core', [
    ('tap app', 'open'),
    ('hold app', 'reassign'),
    ('hold void', 'settings'),
    ('double tap', 'toggle theme'),
  ]),
  ('navigation', [
    ('swipe up', 'search'),
    ('swipe left', 'quick app 1'),
    ('swipe right', 'quick app 2'),
  ]),
  ('widgets', [
    ('tap widget', 'open linked app'),
    ('hold clock', 'alarm maker'),
    ('hold event', 'todo list'),
    ('hold temp', 'sunrise/sunset'),
  ]),
];

class FlightManual extends StatelessWidget {
  final themeManager = getIt<ThemeManager>();

  FlightManual({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: themeManager.toggleTheme,
      child: Scaffold(
        appBar: defaultTargetPlatform == TargetPlatform.linux
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                iconTheme: IconThemeData(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              )
            : null,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 50, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.cheatSheetTitle, style: TEXT_STYLE_SETTINGS_TITLE),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final section in _sections) ...[
                          _SectionHeader(title: section.$1),
                          for (final entry in section.$2)
                            _CheatRow(action: entry.$1, result: entry.$2),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _CheatRow extends StatelessWidget {
  final String action;
  final String result;
  const _CheatRow({required this.action, required this.result});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              action,
              style: TEXT_STYLE_SETTINGS_ITEM.copyWith(
                color: primary.withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(result, style: TEXT_STYLE_SETTINGS_ITEM),
          ),
        ],
      ),
    );
  }
}
