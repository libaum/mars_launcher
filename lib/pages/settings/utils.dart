import 'package:flutter/material.dart';

const TEXT_STYLE_ITEMS = TextStyle(fontSize: 22, height: 1);
const TEXT_STYLE_TITLE = TextStyle(fontSize: 35, fontWeight: FontWeight.normal);

/// Generic button for the settings page
class GenericSettingsButton extends StatelessWidget {
  final Function onPressed;
  final String name;
  final TextStyle style;

  GenericSettingsButton({
    Key? key,
    required Function this.onPressed,
    required String this.name,
    this.style=TEXT_STYLE_ITEMS
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