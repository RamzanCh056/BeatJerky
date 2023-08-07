



import 'package:beat_jerky/model/api_models/user_model/user_model.dart';
import 'package:beat_jerky/services/api_services/user_services.dart';
import 'package:flutter/cupertino.dart';

class CurrentUserProvider extends ChangeNotifier{
  UserModel? user;

  updateUser(UserModel userData){
    user=userData;
    notifyListeners();
  }
  getCurrentUser(BuildContext context){
    UserServices().getCurrentUser(context);
  }

  uploadProfilePicture(String imagePath,BuildContext context)async{
    await UserServices().uploadProfileImage(imagePath, context);
  }


}