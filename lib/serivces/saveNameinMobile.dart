import 'package:shared_preferences/shared_preferences.dart';

class SaveName {
  saveNameInMobile(String name) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("name", name);
    } catch (e) {
      print(e);
    }
  }
}
