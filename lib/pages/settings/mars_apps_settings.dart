/// Lets the user choose which Mars apps appear in the swipe-down overview.
/// Each app has a show/hide toggle; the selection is persisted.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mars_launcher/data/mars_apps.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/strings.dart';
import 'package:mars_launcher/theme/theme_constants.dart';
import 'package:mars_launcher/theme/theme_manager.dart';

class MarsAppsSettings extends StatelessWidget {
  MarsAppsSettings({Key? key}) : super(key: key);

  final themeManager = getIt<ThemeManager>();
  final settingsManager = getIt<SettingsManager>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        themeManager.toggleTheme();
      },
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
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(50, 20, 0, 0),
                  child: Text(
                    Strings.marsAppsTitle,
                    textAlign: TextAlign.left,
                    style: TEXT_STYLE_SETTINGS_TITLE,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
                    child: ValueListenableBuilder<List<String>>(
                      valueListenable: settingsManager.enabledMarsAppsNotifier,
                      builder: (context, enabled, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final app in marsApps)
                              _MarsAppToggleRow(
                                name: app.name,
                                enabled: enabled.contains(app.packageName),
                                onPressed: () =>
                                    settingsManager.toggleMarsApp(app.packageName),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarsAppToggleRow extends StatelessWidget {
  final String name;
  final bool enabled;
  final VoidCallback onPressed;

  const _MarsAppToggleRow({
    required this.name,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onPressed,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(name, style: TEXT_STYLE_SETTINGS_ITEM),
            ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: SizedBox(
            width: 70,
            child: Center(
              child: Text(
                enabled ? "●" : "○",
                style: TEXT_STYLE_SETTINGS_ITEM,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
