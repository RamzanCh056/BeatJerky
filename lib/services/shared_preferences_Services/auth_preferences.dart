


import 'package:beat_jerky/model/api_models/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences{

  setAuthPreferences(String email, String password)async{
    SharedPreferences instance=await SharedPreferences.getInstance();

    instance.setString(UserModelFields.email, email);
    /// here we are saving user password with key of userId
    instance.setString(UserModelFields.userId, password);

  }

  getAuthPreferences()async{
    SharedPreferences instance=await SharedPreferences.getInstance();

    Map<String,dynamic> authMap={
      UserModelFields.email:instance.getString(UserModelFields.email)??'',
    /// here we are saving user password with key of userId
    UserModelFields.userId:instance.getString(UserModelFields.userId)??''
    };
    return authMap;

  }




}