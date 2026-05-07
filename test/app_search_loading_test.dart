import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mars_launcher/data/app_info.dart';
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

  late ValueNotifier<List<AppInfo>> appsNotifier;
  late ValueNotifier<bool> syncingNotifier;
  late ValueNotifier<bool> renamedAppsUpdatedNotifier;

  setUp(() async {
    await getIt.reset();

    appsNotifier = ValueNotifier([]);
    syncingNotifier = ValueNotifier(true);
    renamedAppsUpdatedNotifier = ValueNotifier(false);

    final mockAppsManager = MockAppsManager();
    final mockAppShortcutsManager = MockAppShortcutsManager();
    final mockSettingsManager = MockSettingsManager();

    when(() => mockAppsManager.appsNotifier).thenReturn(appsNotifier);
    when(() => mockAppsManager.syncingNotifier).thenReturn(syncingNotifier);
    when(() => mockAppsManager.renamedAppsUpdatedNotifier)
        .thenReturn(renamedAppsUpdatedNotifier);

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

  testWidgets(
      "Renaming an app refreshes the displayed name in the search list",
      (tester) async {
    syncingNotifier.value = false;
    final appInfo = AppInfo(packageName: "com.test.app", appName: "OriginalName");
    appsNotifier.value = [appInfo];

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(brightness: Brightness.light),
        home: Scaffold(
          body: AppSearchFragment(appSearchMode: AppSearchMode.openApp),
        ),
      ),
    );

    expect(find.text("OriginalName"), findsOneWidget);

    /// Simulate AppsManager.addOrUpdateRenamedApp: mutate displayName on the
    /// existing instance, refire appsNotifier, then fire renamedAppsUpdatedNotifier.
    /// Without the cache invalidation in AppSearchManager, the cached AppCard
    /// would be reused (AppInfo equality is packageName-only) and the Text would
    /// still show "OriginalName".
    appInfo.displayName = "RenamedName";
    appsNotifier.value = List.from(appsNotifier.value);
    renamedAppsUpdatedNotifier.value = !renamedAppsUpdatedNotifier.value;

    await tester.pumpAndSettle();

    expect(find.text("RenamedName"), findsOneWidget);
    expect(find.text("OriginalName"), findsNothing);
  });
}
