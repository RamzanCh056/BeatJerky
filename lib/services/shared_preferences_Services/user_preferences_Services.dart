


import 'package:beat_jerky/model/api_models/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesServices{

  setPreferences({required UserModel user})async{
    SharedPreferences instance= await SharedPreferences.getInstance();

    // instance.setInt(UserModelFields.userId, user.userId);
    // instance.setString(UserModelFields.firstName, user.firstName);
    // instance.setString(UserModelFields.lastName, user.lastName);
    // instance.setString(UserModelFields.email, user.email);
    // instance.setBool(UserModelFields.admin, user!.admin);
  }

  getPreferences()async{
    SharedPreferences instance= await SharedPreferences.getInstance();
    UserModel ? user;
    user!.userId=instance.getInt(UserModelFields.userId)!;
    user.firstName=instance.getString(UserModelFields.firstName)!;
    user.lastName=instance.getString(UserModelFields.lastName)!;
    user.email=instance.getString(UserModelFields.email)!;
    user.admin=instance.getBool(UserModelFields.admin)!;
  }

}