class Strings {
  /// Settings page names
  static const settingsTitle = "Settings";
  static const settingsClockApp = "clock app";
  static const settingsBattery = "battery";
  static const settingsWeatherApp = "weather app";
  static const settingsCalendarApp = "calendar app";
  static const settingsSwipeLeft = "swipe left";
  static const settingsSwipeRight = "swipe right";
  static const settingsHiddenApps = "hidden apps";
  static const settingsCredits = "about";
  static const settingsColors = "colors";
  static const settingsMore = "more";
  static const settingsChangeDefaultLauncher = "set default launcher";
  static const settingsAppNumber = "app number";
  static const String settingsKeyboardAutofocus = "Keyboard";

  static const settingsGroupAppShortcuts = " App Shortcuts";
  static const settingsGroupAppearance = " Appearance";
  static const settingsGroupOther = " Other";

  static const creditsTitle = "About";
  static const cheatSheetTitle = "Cheat Sheet";
  static const settingsColorsTitle = "Colors";
  static const settingsColorsSearchColor = "search color";
  static const settingsColorsLightBackground = "light background";
  static const settingsColorsDarkBackground = "dark background";

  /// Standard names
  static const defaultTemperatureString = "-°C";
  static const appNameUninitialized = slotDefault;
  static const packageNameClockUninitialized = "uninitialized clock app";
  static const packageNameBatteryUninitialized = "uninitialized battery app";
  static const packageNameCalendarUninitialized = "uninitialized calendar app";
  static const packageNameWeatherUninitialized = "uninitialized weather app";
  static const packageNameSwipeLeftUninitialized = "uninitialized swipe left app";
  static const packageNameSwipeRightUninitialized = "uninitialized swipe right app";
  static const textCalendarEmpty = "no events";

  /// Default slots
  static const slotDefault = ' + ';

  /// First launch overlay
  static const overlayTitle = '/// quick start ///';
  static const overlayLine1 = 'hold + to set app';
  static const overlayLine2 = 'swipe up to search';
  static const overlayLine3 = 'hold void for settings';
  static const overlayTip = 'tip: find all commands in\nsettings > flight manual';

  /// Flight manual
  static const settingsFlightManual = "cheat sheet";
  static const flightManualContent = '''
[ CORE ]
tap app     :: open
hold app    :: reassign
hold void   :: settings
double tap  :: toggle theme

[ NAVIGATION ]
swipe up    :: search
swipe left  :: quick app 1
swipe right :: quick app 2

[ WIDGETS ]
tap widget  :: open linked app
hold clock  :: ???
hold date   :: ???
hold temp   :: ???
''';
}

/// Shared preferences keys
class Keys {
  static const weatherEnabled = "weatherEnabled";
  static const clockEnabled = "clockEnabled";
  static const batteryEnabled = "batteryEnabled";
  static const calendarEnabled = "calendarEnabled";
  static const numOfShortcutItems = "numOfShortcutItems";
  static const shortcutMode = "shortcutMode";
  static const isFirstStartup = "isFirstStartup";
  static const todoList = "todoList";
  static const hiddenApps = "hiddenApps";
  static const renamedApps = 'renamedApps';
  static const appsAreSaved = "appsAreSaved";
  static const typeAppClock = "clockApp";
  static const typeAppBattery = "batteryApp";
  static const typeAppCalendar = "calendarApp";
  static const typeAppWeather = "weatherApp";
  static const typeAppSwipeLeft = "swipeLeftApp";
  static const typeAppSwipeRight = "swipeRightApp";
  static const themeMode = "themeMode";
  static const lightBackground = "light_background";
  static const searchColor = "search_color";
  static const darkBackground = "dark_background";
  static const weatherActivatedAtLeastOnce = "weatherActivatedAtLeastOnce";
  static const keyboardAutofocusEnabled = "keyboard_autofocus_enabled";
  static const isFirstLaunch = "isFirstLaunch";
  static const font = "font";
}

class JsonKeys {
  static const packageName = "packageName";
  static const appName = "appName";
  static const systemApp = "systemApp";
  static const displayName = "appDisplayName";
  static const appIsHidden = "appIsHidden";
}

