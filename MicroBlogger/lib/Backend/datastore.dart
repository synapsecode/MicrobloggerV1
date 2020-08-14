import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'server.dart';

Map currentUser = {};
String serverURL = "https://5769f5d5f42b.ngrok.io";

saveUserLoginInfo(username) async {
  if (!Platform.isWindows) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_username', username);
  }
  currentUser = await loadMyProfile(username);
  print("Saved User Login Info");
}

logoutSavedUser() async {
  if (!Platform.isWindows) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_username', "");
  }
  currentUser = {};
  print("Logged Out User");
}

setServerURL(url) {
  serverURL = url;
}

loadSavedUsername() async {
  if (!Platform.isWindows) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = (prefs.getString('logged_in_username') ?? "");
    if (username == "") return "";
    print("\nDATASTORE<loadSavedUsername>: username: $username");
    currentUser = await loadMyProfile(username);
    if (currentUser.containsKey('message')) {
      if (currentUser['code'] == 'E2') {
        print("Error while connecting to user");
        await prefs.setString('logged_in_username', "");
        return "";
      }
    }
    print(
        "\n\nDATASTORE<loadSavedUsername>: Stored the CurrentUser: $currentUser");
    return username;
  }
  return "";
}
