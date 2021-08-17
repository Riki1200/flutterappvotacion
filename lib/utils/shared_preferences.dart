import 'package:shared_preferences/shared_preferences.dart';

abstract class UserPreferences {}

abstract class AdminPreferences {}

Future<SharedPreferences> getInstance() async =>
    await SharedPreferences.getInstance();

class SharedPreferencesStorage {
  Future<String> getPrefsById(String id) async {
    var prefs = await getInstance();
    return Future.delayed(Duration(seconds: 0), () async {
      return prefs.getString(id) ?? '';
    });
  }

  Future<bool> registerDevice(String mobileId, String nameId) async {
    var prefs = await getInstance();
    return await prefs.setString(mobileId, nameId);
  }
}
