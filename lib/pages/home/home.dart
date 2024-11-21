import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/app_search_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/logic/temperature_manager.dart';
import 'package:mars_launcher/pages/home/app_shortcuts_fragment.dart';
import 'package:mars_launcher/pages/home/app_search_fragment.dart';
import 'package:mars_launcher/pages/home/top_row/top_row.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:mars_launcher/pages/settings/settings.dart';
import 'package:mars_launcher/services/service_locator.dart';

const double HEIGHT_SIZED_BOX = 50;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  const Home();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final themeManager = getIt<ThemeManager>();
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final temperatureManager = getIt<TemperatureManager>();
  final sensitivity = 8;

  final ValueNotifier<bool> searchAppsNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive && mounted) {
      searchAppsNotifier.value = false;
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("BUILDING HOME SCREEN");
    return PopScope( /// Detect back button to close app search
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {_onWillPop(didPop);},
      child: GestureDetector(
        /// SWIPE DETECTION
        onHorizontalDragUpdate: _horizontalDragHandler,
        onVerticalDragUpdate: _verticalDragHandler,
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Settings()),
          );
        },
        onDoubleTap: () {
          themeManager.toggleTheme();
        },
        onPanDown: (details) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },

        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopRow(),
                SizedBox(
                  height: HEIGHT_SIZED_BOX,
                  child: ValueListenableBuilder<String>(
                    valueListenable: temperatureManager.sunriseSunsetNotifier,
                    builder: (context, sunriseSunset, child) {
                      return Center(child: Text(sunriseSunset));
                })),
                Expanded(
                  child: ValueListenableBuilder<bool>(
                      valueListenable: searchAppsNotifier,
                      builder: (context, searchApps, child) {
                      return !searchApps
                          ? Align(
                          alignment:
                          Alignment.centerLeft, // Center only vertically
                          child: AppShortcutsFragment())
                          : AppSearchFragment(appSearchMode: AppSearchMode.openApp);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onWillPop(didPop) async {
    searchAppsNotifier.value = false;
    return;
  }

  _horizontalDragHandler(details) {
    if (searchAppsNotifier.value) {
      return;
    }

    if (details.delta.dx > sensitivity) {
      /// Right Swipe
      appShortcutsManager.swipeRightAppNotifier.value.open();
    } else if (details.delta.dx < -sensitivity) {
      /// Left Swipe
      appShortcutsManager.swipeLeftAppNotifier.value.open();
    }
  }

  _verticalDragHandler(details) {
    if (details.delta.dy > sensitivity) { /// Down Swipe
      searchAppsNotifier.value = false; /// Close app search
    } else if (details.delta.dy < -sensitivity) { /// Up Swipe
      searchAppsNotifier.value = true; /// Open app search
    }
  }
}
