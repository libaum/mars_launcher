import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

class AppCard extends StatelessWidget {
  final AppInfo appInfo;
  final bool isShortcutItem;
  final Function(BuildContext, AppInfo) callbackHandleOnPress;
  final Function(BuildContext, AppInfo) callbackHandleOnLongPress;

  const AppCard({
    required this.appInfo,
    required this.callbackHandleOnPress,
    required this.callbackHandleOnLongPress,
    this.isShortcutItem = false,
  });

  @override
  Widget build(BuildContext context) {
    var fontFamily = isShortcutItem ? FONT_REGULAR : FONT_LIGHT;
    var letterSpacing = isShortcutItem ? 1.0 : 0.0;
    var textColor = isShortcutItem ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.secondary;


    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      alignment: Alignment.topLeft,
      child: TextButton(
        onPressed: () {
          callbackHandleOnPress(context, appInfo);
        },
        onLongPress: () {
          callbackHandleOnLongPress(context, appInfo);
        },
        child: Text(
          appInfo.displayName,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w100,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
          ),
          maxLines: isShortcutItem ? 1 : 2,
        ),
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(textColor),
        ),
      ),
    );
  }
}
