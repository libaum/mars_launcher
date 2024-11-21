import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Colors
const COLOR_LIGHT_BACKGROUND = Colors.white;
const COLOR_LIGHT_PRIMARY = Colors.black;

const COLOR_DARK_BACKGROUND = Colors.black;
const COLOR_DARK_PRIMARY = Colors.white;

const COLOR_ACCENT = Color(0xffc9184a);
const COLOR_ACCENT_HIGHLIGHT = Color(0xffEA4876);
const COLOR_DIALOG_BUTTONS = Color(0xffFF6F5C);

/// Fonts
const FONT_LIGHT = "NotoSansLight";
const FONT_REGULAR = "NotoSansRegular";

ButtonStyle getDialogButtonStyle(isDarkMode) {
  return ButtonStyle(
      // backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
      backgroundColor: WidgetStateProperty.all<Color>(COLOR_ACCENT.withOpacity(isDarkMode ? 0.1 : 0.25)),
      overlayColor: WidgetStateProperty.all<Color>(COLOR_ACCENT.withOpacity(0.05)),
      foregroundColor: WidgetStateProperty.all<Color>(COLOR_ACCENT),
      textStyle: WidgetStateProperty.all(TextStyle(
        fontFamily: FONT_LIGHT,
        fontWeight: FontWeight.bold,
      )),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      )));
}

ThemeData basicLightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    surface: COLOR_LIGHT_BACKGROUND,
    primary: COLOR_LIGHT_PRIMARY,
    secondary: COLOR_ACCENT,
    brightness: Brightness.light,
  ),
  primaryTextTheme: TextTheme(
    bodyLarge: TextStyle(color: COLOR_LIGHT_PRIMARY),
    bodyMedium: TextStyle(color: COLOR_LIGHT_PRIMARY),
    bodySmall: TextStyle(color: COLOR_LIGHT_PRIMARY),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: COLOR_LIGHT_PRIMARY,
    contentTextStyle: TextStyle(
      color: COLOR_LIGHT_BACKGROUND
    ),
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontFamily: FONT_REGULAR,
      fontWeight: FontWeight.bold,
      color: COLOR_LIGHT_BACKGROUND,
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
  ),
  dialogBackgroundColor: COLOR_LIGHT_PRIMARY,
  primaryColor: Colors.black,
  disabledColor: COLOR_ACCENT,
  fontFamily: FONT_LIGHT,
  scaffoldBackgroundColor: COLOR_LIGHT_BACKGROUND,
  brightness: Brightness.light,
  iconTheme: IconThemeData(
    color: COLOR_LIGHT_PRIMARY,
  ),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(COLOR_LIGHT_PRIMARY),
          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent))),
);

ThemeData basicDarkTheme = ThemeData(

  colorScheme: ColorScheme.dark(
    surface: COLOR_DARK_BACKGROUND,
    primary: COLOR_DARK_PRIMARY,
    secondary: COLOR_ACCENT,
    brightness: Brightness.dark,
  ),
  primaryTextTheme: TextTheme(
    bodyLarge: TextStyle(color: COLOR_DARK_PRIMARY),
    bodyMedium: TextStyle(color: COLOR_DARK_PRIMARY),
    bodySmall: TextStyle(color: COLOR_DARK_PRIMARY),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: COLOR_DARK_PRIMARY,
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontFamily: FONT_REGULAR,
      fontWeight: FontWeight.bold,
      color: COLOR_DARK_BACKGROUND,
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
  ),
  // dialogBackgroundColor: COLOR_DARK_PRIMARY,
  primaryColor: COLOR_DARK_PRIMARY,
  disabledColor: COLOR_ACCENT,
  fontFamily: FONT_LIGHT,
  scaffoldBackgroundColor: COLOR_DARK_BACKGROUND,
  brightness: Brightness.dark,
  iconTheme: IconThemeData(
    color: COLOR_DARK_PRIMARY,
  ),

  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(COLOR_DARK_PRIMARY),
          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent))),
);

SystemUiOverlayStyle lightSystemUiOverlayStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
);

SystemUiOverlayStyle darkSystemUiOverlayStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.black,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarColor: Colors.black,
  statusBarIconBrightness: Brightness.light,
);
