import "package:shared_preferences/shared_preferences.dart";
class  SharedPreferencesHelper{
  static String userIdkey = "USERIDKEY";
  static String userNamekey = "USERNAMEKEY";
  static String userEmailkey = "USEREMAILKEY";
  static String userImagekey = "USERIMAGEKEY";

  Future<bool> saveUserId(String getUserId)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdkey,getUserId);
  }
  Future<bool> saveUserName(String getUserName)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNamekey,getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailkey,getUserEmail);
  }

  Future<bool> saveUserImage(String getUserImage)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userImagekey,getUserImage);
  }

  Future<String?> getUserId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdkey);

  }

  Future<String?> getUserName() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNamekey);

  }

  Future<String?> getUserEmail() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailkey);

  }
  Future<String?> getUserImage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userImagekey);

  }


}