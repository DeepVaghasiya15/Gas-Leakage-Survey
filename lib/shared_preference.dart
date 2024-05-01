import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String KEYLOGIN = "login";

  static Future<void> saveLoginState(bool isLoggedIn) async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(KEYLOGIN, isLoggedIn);
  }
}
