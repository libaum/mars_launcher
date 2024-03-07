import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/apps_manager.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:mars_launcher/pages/fragments/cards/hidden_app_card.dart';
import 'package:mars_launcher/services/service_locator.dart';

const TEXT_STYLE_TITLE = TextStyle(fontSize: 30, fontWeight: FontWeight.normal);
const TEXT_STYLE_ITEMS = TextStyle(fontSize: 22, height: 1);
const ROW_PADDING_RIGHT = 60.0;

class HiddenApps extends StatefulWidget {
  const HiddenApps({Key? key}) : super(key: key);

  @override
  State<HiddenApps> createState() => _HiddenAppsState();
}

class _HiddenAppsState extends State<HiddenApps> with WidgetsBindingObserver {
  final themeManager = getIt<ThemeManager>();
  final appsManager = getIt<AppsManager>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void callbackRemoveFromHiddenApps(appInfo) {
    appsManager.updateHiddenApps(appInfo.packageName, false);
  }

  @override
  Widget build(BuildContext context) {
    const title = "Hidden apps";

    return GestureDetector(
      onDoubleTap: () {
        themeManager.toggleTheme();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(40, 20, 0, 20),
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TEXT_STYLE_TITLE,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                      child: ValueListenableBuilder<List<AppInfo>>(
                          valueListenable: appsManager.appsNotifier,
                          builder: (context, apps, child) {
                            final hiddenApps = apps.where((app) => app.isHidden);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: hiddenApps
                                  .map<Widget>((app) => HiddenAppCard(
                                      appInfo: app, callbackRemoveFromHiddenApps: callbackRemoveFromHiddenApps))
                                  .toList(),
                            );
                          })),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
