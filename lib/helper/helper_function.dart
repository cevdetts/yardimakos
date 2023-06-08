import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPasswordKey = "USERPASSWORDKEY";
  static String userGroupsKey = "USERGROUPSKEY";

  // saving the data to Shared Preferences

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserPasswordSF(String userPassword) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userPasswordKey, userPassword);
  }

  static Future<bool> saveUserGroupsSF(List<String> userGroups) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setStringList(userGroupsKey, userGroups);
  }

  // getting the data from Shared Preferences

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserPasswordFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userPasswordKey);
  }

  static Future<List<String>> getUserGroupsFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getStringList(userGroupsKey) ?? [];
  }

  static Future<List<String>> getLoggedInUserGroupsSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('userGroups') ?? [];
  }
}
