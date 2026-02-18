import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mars_launcher/logic/app_search_manager.dart';
import 'package:mars_launcher/logic/apps_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/pages/home/app_search_fragment.dart';

class MockAppsManager extends Mock implements AppsManager {}
class MockAppShortcutsManager extends Mock implements AppShortcutsManager {}
class MockSettingsManager extends Mock implements SettingsManager {}

void main() {
  final getIt = GetIt.instance;

  setUp(() async {
    await getIt.reset();

    final mockAppsManager = MockAppsManager();
    final mockAppShortcutsManager = MockAppShortcutsManager();
    final mockSettingsManager = MockSettingsManager();

    when(() => mockAppsManager.appsNotifier)
        .thenReturn(ValueNotifier([]));
    when(() => mockAppsManager.syncingNotifier)
        .thenReturn(ValueNotifier(true));

    when(() => mockSettingsManager.keyboardAutofocusEnabledNotifier)
        .thenReturn(ValueNotifierWithKey<bool>(false, "kb"));

    getIt.registerSingleton<AppsManager>(mockAppsManager);
    getIt.registerSingleton<AppShortcutsManager>(mockAppShortcutsManager);
    getIt.registerSingleton<SettingsManager>(mockSettingsManager);
    getIt.registerSingleton<AppSearchManager>(AppSearchManager());
  });

  testWidgets("Shows themed spinner while apps are syncing", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(brightness: Brightness.light),
        home: Scaffold(
          body: AppSearchFragment(appSearchMode: AppSearchMode.openApp),
        ),
      ),
    );

    final spinnerFinder = find.byType(CircularProgressIndicator);
    expect(spinnerFinder, findsOneWidget);
    final indicator = tester.widget<CircularProgressIndicator>(spinnerFinder);
    expect(indicator.color, Colors.black);
  });
}
