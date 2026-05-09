import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mars_launcher/constants/global.dart';

/// Colors
const COLOR_LIGHT_BACKGROUND = Colors.white;
const COLOR_LIGHT_PRIMARY = Colors.black;

const COLOR_DARK_BACKGROUND = Colors.black;
const COLOR_DARK_PRIMARY = Colors.white;

const COLOR_ACCENT = Color(0xffc9184a);
const COLOR_ACCENT_HIGHLIGHT = Color(0xffEA4876);
const COLOR_DIALOG_BUTTONS = Color(0xffFF6F5C);

/// Default font (used as fallback and initial value)
const FONT = "NotoSans";

/// All selectable fonts — order determines cycle direction in settings
const List<String> AVAILABLE_FONTS = ["NotoSans", "Outfit", "Geist", "SpaceGrotesk"];

/// Display names for fonts shown in settings (fallback: font key itself)
const Map<String, String> FONT_DISPLAY_NAMES = {"SpaceGrotesk": "Space"};

/// Settings page text styles
const TEXT_STYLE_SETTINGS_TITLE = TextStyle(fontSize: 35, fontWeight: FontWeight.w300);
const TEXT_STYLE_SETTINGS_ITEM = TextStyle(fontSize: 22, height: 1, fontWeight: FontWeight.w200);

/// Named text styles — fontFamily intentionally omitted so they inherit from ThemeData
const TEXT_STYLE_APP_SMALL = TextStyle(fontSize: 20, fontWeight: FontWeight.w200);
const TEXT_STYLE_APP_LARGE = TextStyle(fontSize: 30, fontWeight: FontWeight.w300);
const TEXT_STYLE_TOP_ROW = TextStyle(fontSize: FONT_SIZE_TOP_ROW, fontWeight: FontWeight.w400, fontFeatures: [FontFeature.tabularFigures()]);

const TEXT_STYLE_CHEAT_SHEET = TextStyle(fontSize: 18, fontWeight: FontWeight.w200);
const TEXT_STYLE_INPUT_HINT = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
const TEXT_STYLE_ABOUT_BODY = TextStyle(fontSize: 15, fontWeight: FontWeight.w200);

const TEXT_STYLE_DIALOG_TITLE = TextStyle(fontSize: 20, fontWeight: FontWeight.w300);
const TEXT_STYLE_DIALOG_BODY = TextStyle(fontSize: 16, fontWeight: FontWeight.w200);
const TEXT_STYLE_DIALOG_BUTTON = TextStyle(fontSize: 14, fontWeight: FontWeight.w300);




ButtonStyle getDialogButtonStyle(isDarkMode) {
  return ButtonStyle(
      overlayColor: WidgetStateProperty.all<Color>(
        isDarkMode ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
      ),
      foregroundColor: WidgetStateProperty.all<Color>(COLOR_ACCENT),
      textStyle: WidgetStateProperty.all(TEXT_STYLE_DIALOG_BUTTON),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      )));
}

ThemeData buildLightTheme(String font) => ThemeData(
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
  dialogTheme: DialogThemeData(
    backgroundColor: COLOR_LIGHT_PRIMARY,
    contentTextStyle: TextStyle(color: COLOR_LIGHT_BACKGROUND),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontFamily: font,
      fontWeight: FontWeight.w300,
      color: COLOR_LIGHT_BACKGROUND,
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
  ),
  dialogBackgroundColor: COLOR_LIGHT_PRIMARY,
  primaryColor: Colors.black,
  disabledColor: COLOR_ACCENT,
  fontFamily: font,
  scaffoldBackgroundColor: COLOR_LIGHT_BACKGROUND,
  brightness: Brightness.light,
  iconTheme: IconThemeData(color: COLOR_LIGHT_PRIMARY),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(COLOR_LIGHT_PRIMARY),
          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent))),
);

ThemeData buildDarkTheme(String font) => ThemeData(
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
  dialogTheme: DialogThemeData(
    backgroundColor: COLOR_DARK_BACKGROUND,
    contentTextStyle: TextStyle(color: COLOR_DARK_PRIMARY),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontFamily: font,
      fontWeight: FontWeight.w300,
      color: COLOR_DARK_PRIMARY,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      side: BorderSide(color: Color(0x5FFFFFFF), width: 0.7),
    ),
  ),
  primaryColor: COLOR_DARK_PRIMARY,
  disabledColor: COLOR_ACCENT,
  fontFamily: font,
  scaffoldBackgroundColor: COLOR_DARK_BACKGROUND,
  brightness: Brightness.dark,
  iconTheme: IconThemeData(color: COLOR_DARK_PRIMARY),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(COLOR_DARK_PRIMARY),
          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent))),
);

SystemUiOverlayStyle lightSystemUiOverlayStyle = const SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
);

SystemUiOverlayStyle darkSystemUiOverlayStyle = const SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
);
