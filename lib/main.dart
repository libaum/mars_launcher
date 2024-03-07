import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mars_launcher/pages/home/home.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:sizer/sizer.dart';


void main() async {
  print("# ---- STARTING APP MARS LAUNCHER ---- #");
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();

  runApp(MarsLauncher());
}

class MarsLauncher extends StatelessWidget {
  final themeManager = getIt<ThemeManager>();

  @override
  Widget build(BuildContext context) {
    print("[$runtimeType] INITIALISING");
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeModeNotifier,
      builder: (context, themeMode, homeScreen) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: themeManager.systemUiOverlayStyle,
          child: Sizer(builder: (context, orientation, deviceType) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: themeManager.lightTheme,
                darkTheme: themeManager.darkTheme,
                themeMode: themeMode,
                home: homeScreen!);
          })),
      child: const Home(),
    );
  }
}
