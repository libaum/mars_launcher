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


  void saveData(String key, dynamic value) async {
    printSharedPrefAccess("[SharedPrefsManager] WRITE $key: $value");
    if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is String) {
      _prefs.setString(key, value);
    } else if (value is bool) {
      _prefs.setBool(key, value);
    } else if (value is List<String>) {
      _prefs.setStringList(key, value);
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

}


