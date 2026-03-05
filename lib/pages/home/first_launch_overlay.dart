import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/pages/fragments/cards/app_card.dart';
import 'package:mars_launcher/strings.dart';
import 'package:mars_launcher/constants/global.dart';

class FirstLaunchOverlay extends StatelessWidget {
  final VoidCallback onDismiss;
  final Widget topSpacer;

  const FirstLaunchOverlay({
    super.key,
    required this.onDismiss,
    required this.topSpacer,
  });

  static final _dummyApp = AppInfo(packageName: '', appName: Strings.slotDefault);
  static final _noOp = (BuildContext ctx, AppInfo app) {};

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).primaryColor;
    final dimColor = textColor.withValues(alpha: 0.4);

    final overlayTexts = [
      (Strings.overlayLine1, TextStyle(fontFamily: 'monospace', fontSize: 16, color: textColor)),
      (Strings.overlayLine2, TextStyle(fontFamily: 'monospace', fontSize: 16, color: textColor)),
      (Strings.overlayLine3, TextStyle(fontFamily: 'monospace', fontSize: 16, color: textColor)),
      (Strings.overlayTip, TextStyle(fontFamily: 'monospace', fontSize: 12, color: dimColor)),
    ];

    final titleWidget = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        Strings.overlayTitle,
        style: TextStyle(fontFamily: 'monospace', fontSize: 14, color: dimColor),
      ),
    );

    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.85),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Opacity(opacity: 0, child: topSpacer),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title above slots — balanced by invisible copy at bottom
                      Center(child: titleWidget),
                      // 4 slots: invisible AppCard + overlay text
                      for (int i = 0; i < NUMBER_OF_SHORTCUT_ITEMS_ON_STARTUP; i++)
                        Stack(
                          children: [
                            Opacity(
                              opacity: 0,
                              child: AppCard(
                                appInfo: _dummyApp,
                                isShortcutItem: true,
                                callbackHandleOnPress: _noOp,
                                callbackHandleOnLongPress: _noOp,
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  overlayTexts[i].$1,
                                  textAlign: TextAlign.center,
                                  style: overlayTexts[i].$2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      // Invisible counterweight so title doesn't shift centering
                      Opacity(opacity: 0, child: titleWidget),
                    ],
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
