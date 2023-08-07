


import 'package:flutter/cupertino.dart';

import '../../model/api_models/user_model/all_users_model.dart';

class AllUsersProvider extends ChangeNotifier{
  List<AllUserModel> usersList=[];

  updateUsers(List<AllUserModel> users){
    usersList.clear();
    usersList=users;
    notifyListeners();
  }
}