import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mars_launcher/pages/dialogs/dialog_color_picker.dart';
import 'package:mars_launcher/pages/settings/utils.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/strings.dart';

class SettingsColors extends StatefulWidget {
  const SettingsColors({Key? key}) : super(key: key);

  @override
  State<SettingsColors> createState() => _SettingsColorsState();
}

class _SettingsColorsState extends State<SettingsColors> with WidgetsBindingObserver {
  final themeManager = getIt<ThemeManager>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        themeManager.toggleTheme();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(Strings.settingsColorsTitle, style: TEXT_STYLE_TITLE),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// LIGHT COLOR / DARK COLOR
                          GenericSettingsButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ColorPickerDialog(colorType: ColorType.lightBackground);
                                  },
                                );
                              },
                              name: Strings.settingsColorsLightBackground
                          ),

                          GenericSettingsButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ColorPickerDialog(colorType: ColorType.darkBackground);
                                  },
                                );
                              },
                              name: Strings.settingsColorsDarkBackground
                          ),

                          ValueListenableBuilder<ThemeMode>(
                            valueListenable: themeManager.themeModeNotifier,
                            builder: (context, themeMode, child) {
                              return GenericSettingsButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ColorPickerDialog(colorType: ColorType.searchTextColor);
                                      },
                                    );
                                  },
                                  name: Strings.settingsColorsSearchColor,
                              style: TEXT_STYLE_ITEMS.copyWith(color: themeManager.searchTextColor),
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
