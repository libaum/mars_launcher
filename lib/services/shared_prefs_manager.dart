import 'package:mars_launcher/constants/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

printSharedPrefAccess(text) {
  if (PRINT_SHARED_PREF_ACCESS) {
    print(text);
  }
}

class SharedPrefsManager {
  static SharedPrefsManager? _instance;
  static late SharedPreferences _prefs;


  static Future<SharedPrefsManager> getInstance() async {
    if (_instance == null) {
      _instance = SharedPrefsManager();
    }

    _prefs = await SharedPreferences.getInstance();

    return _instance!;
  }


  Future<void> saveData(String key, dynamic value) async {
    printSharedPrefAccess("[SharedPrefsManager] WRITE $key: $value");
    if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      printSharedPrefAccess("[SharedPrefsManager] Invalid Type");
    }
  }

  dynamic readData(String key) {
    dynamic obj = _prefs.get(key);
    printSharedPrefAccess("[SharedPrefsManager] READ $key: $obj");
    return obj;
  }

  dynamic readDataWithDefault(String key, defaultValue) {
    dynamic obj = _prefs.get(key);
    printSharedPrefAccess("[SharedPrefsManager] READ $key: $obj");
    return obj != null ? obj : defaultValue;
  }

  List<String>? readStringList(String key) {
    List<String>? objList = _prefs.getStringList(key);
    printSharedPrefAccess("[SharedPrefsManager] READ $key: $objList");
    return objList;
  }

  Future<bool> deleteData(String key) async {
    printSharedPrefAccess("[SharedPrefsManager] DELETE $key");
    return _prefs.remove(key);
  }

  Future<bool> clearAll() async {
    printSharedPrefAccess("[SharedPrefsManager] CLEAR ALL");
    return _prefs.clear();
  }

  /// Snapshot of every stored preference (admin settings transfer).
  Map<String, dynamic> exportAll() {
    final Map<String, dynamic> data = {};
    for (final key in _prefs.getKeys()) {
      data[key] = _prefs.get(key);
    }
    return data;
  }

  /// Overwrite all preferences with [data] (admin settings transfer).
  /// Existing prefs are cleared first so the result is an exact copy.
  Future<void> importAll(Map<String, dynamic> data) async {
    await _prefs.clear();
    for (final entry in data.entries) {
      var value = entry.value;
      // JSON decodes string lists as List<dynamic>; saveData needs List<String>.
      if (value is List) {
        value = value.map((e) => e.toString()).toList();
      }
      await saveData(entry.key, value);
    }
  }
}
