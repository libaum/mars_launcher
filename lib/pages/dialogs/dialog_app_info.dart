import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/apps_manager.dart';
import 'package:mars_launcher/pages/dialogs/dialog_rename_app.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

class AppInfoDialog extends StatelessWidget {
  AppInfoDialog({
    Key? key,
    required this.appInfo,
  }) : super(key: key);

  final AppInfo appInfo;
  final appsManager = getIt<AppsManager>();

  @override
  Widget build(BuildContext context) {
    final dialogTextColor = Theme.of(context).dialogTheme.contentTextStyle?.color
        ?? Theme.of(context).primaryColor;

    return AlertDialog(
      title: Text(appInfo.appName, style: TEXT_STYLE_DIALOG_TITLE),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
      contentPadding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ActionRow(
            label: "Rename",
            color: dialogTextColor,
            onTap: () async {
              final result = await showDialog(
                context: context,
                builder: (_) => RenameAppDialog(appInfo: appInfo),
              );
              if (result != null) {
                appsManager.addOrUpdateRenamedApp(appInfo, result);
                var message = "Renamed \"${appInfo.appName}\" to \"$result\".";
                if (appInfo.appName == result) {
                  message = "Reset name to \"${appInfo.appName}\"";
                }
                Fluttertoast.showToast(
                    msg: message,
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).scaffoldBackgroundColor);
              }
            },
          ),
          _ActionRow(
            label: "Hide",
            color: dialogTextColor,
            onTap: () {
              appsManager.updateHiddenApps(appInfo.packageName, true);
              Fluttertoast.showToast(
                  msg: "${appInfo.appName} is now hidden!",
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).scaffoldBackgroundColor);
              Navigator.pop(context, null);
            },
          ),
          _ActionRow(
            label: "Info",
            color: dialogTextColor,
            onTap: () {
              appInfo.openSettings();
              Navigator.pop(context, null);
            },
          ),
          if (!appInfo.systemApp)
            _ActionRow(
              label: "Uninstall",
              color: COLOR_ACCENT,
              onTap: () {
                appInfo.uninstall();
                Navigator.pop(context, null);
              },
            ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionRow({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      overlayColor: WidgetStateProperty.all(
        isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(label, style: TEXT_STYLE_DIALOG_BODY.copyWith(color: color)),
      ),
    );
  }
}
