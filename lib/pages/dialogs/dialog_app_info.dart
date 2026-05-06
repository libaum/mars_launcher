import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/apps_manager.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/pages/dialogs/dialog_rename_app.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

const TEXT_HIDE = "Hide";
const TEXT_RENAME = "Rename";
const TEXT_INFO = "Info";
const TEXT_UNINSTALL = "Uninstall";

const WIDTH_SIZED_BOX = 70.0;

class AppInfoDialog extends StatelessWidget {
  AppInfoDialog({
    Key? key,
    required this.appInfo,
  }) : super(key: key);

  final AppInfo appInfo;
  final appsManager = getIt<AppsManager>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isThemeDark(context);
    final buttonStyle = getDialogButtonStyle(isDarkMode);

    return AlertDialog(
        title: Center(
            child: Text(appInfo.appName,
                    style: TEXT_STYLE_DIALOG_TITLE,
            )
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
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
                    child: const SizedBox(width: WIDTH_SIZED_BOX, child: Center(child: Text(TEXT_RENAME))),
                    style: buttonStyle,
                  ),
                  TextButton(
                      onPressed: () {
                        appsManager.updateHiddenApps(appInfo.packageName, true);
                        Fluttertoast.showToast(
                            msg: "${appInfo.appName} is now hidden!",
                            backgroundColor: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).scaffoldBackgroundColor);
                        Navigator.pop(context, null);
                      },
                      child: const SizedBox(width: WIDTH_SIZED_BOX, child: Center(child: Text(TEXT_HIDE))),
                      style: buttonStyle),
                ]),
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              TextButton(
                onPressed: () {
                  appInfo.openSettings();
                  Navigator.pop(context, null);
                },
                child: const SizedBox(
                    width: WIDTH_SIZED_BOX,
                    child: Center(
                      child: Text(TEXT_INFO),
                    )),
                style: buttonStyle,
              ),
              appInfo.systemApp
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        appInfo.uninstall();
                        Navigator.pop(context, null);
                      },
                      child: const SizedBox(
                          width: WIDTH_SIZED_BOX,
                          child: Center(
                            child: Text(TEXT_UNINSTALL),
                          )),
                      style: buttonStyle,
                    ),
            ])
          ],
        ));
  }
}
