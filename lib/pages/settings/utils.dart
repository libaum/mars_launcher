import 'package:flutter/material.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

/// Generic button for the settings page
class GenericSettingsButton extends StatelessWidget {
  final Function onPressed;
  final String name;
  final TextStyle style;

  GenericSettingsButton({
    Key? key,
    required Function this.onPressed,
    required String this.name,
    this.style=TEXT_STYLE_SETTINGS_ITEM
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          name,
          style: style,
        )
    );
  }
}