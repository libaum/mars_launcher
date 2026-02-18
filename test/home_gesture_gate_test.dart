import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/logic/temperature_manager.dart';
import 'package:mars_launcher/pages/home/home.dart';
import 'package:mars_launcher/theme/theme_manager.dart';

class MockThemeManager extends Mock implements ThemeManager {}
class MockAppShortcutsManager extends Mock implements AppShortcutsManager {}
class MockTemperatureManager extends Mock implements TemperatureManager {}

void main() {
  final getIt = GetIt.instance;

  setUp(() async {
    await getIt.reset();

    final mockThemeManager = MockThemeManager();
    final mockAppShortcutsManager = MockAppShortcutsManager();
    final mockTemperatureManager = MockTemperatureManager();

    when(() => mockTemperatureManager.sunriseSunsetNotifier)
        .thenReturn(ValueNotifier<String>(""));

    getIt.registerSingleton<ThemeManager>(mockThemeManager);
    getIt.registerSingleton<AppShortcutsManager>(mockAppShortcutsManager);
    getIt.registerSingleton<TemperatureManager>(mockTemperatureManager);
  });

  testWidgets("Swipe from bottom edge does not open search", (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(400, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(400, 800),
            viewPadding: EdgeInsets.only(bottom: 24),
          ),
          child: Home(
            topRowOverride: const SizedBox.shrink(),
            appShortcutsBuilder: () => const SizedBox(key: Key("shortcuts")),
            appSearchBuilder: () => const SizedBox(key: Key("search")),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key("shortcuts")), findsOneWidget);
    expect(find.byKey(const Key("search")), findsNothing);

    await tester.dragFrom(const Offset(200, 790), const Offset(0, -120));
    await tester.pump(const Duration(milliseconds: 80));

    expect(find.byKey(const Key("search")), findsNothing);
    expect(find.byKey(const Key("shortcuts")), findsOneWidget);
  });

  testWidgets("Swipe above bottom edge opens search", (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(400, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(400, 800),
            viewPadding: EdgeInsets.only(bottom: 24),
          ),
          child: Home(
            topRowOverride: const SizedBox.shrink(),
            appShortcutsBuilder: () => const SizedBox(key: Key("shortcuts")),
            appSearchBuilder: () => const SizedBox(key: Key("search")),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key("shortcuts")), findsOneWidget);
    expect(find.byKey(const Key("search")), findsNothing);

    await tester.dragFrom(const Offset(200, 740), const Offset(0, -120));
    await tester.pump(const Duration(milliseconds: 80));

    expect(find.byKey(const Key("search")), findsOneWidget);
    expect(find.byKey(const Key("shortcuts")), findsNothing);
  });
}
