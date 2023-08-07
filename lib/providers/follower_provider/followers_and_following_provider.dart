



import 'package:flutter/cupertino.dart';

class FollowAndFollowingProvider extends ChangeNotifier{
  int followers=0;
  int following=0;

  updateFollowersAndFollowing(int follows,int followings){
    followers=follows;
    following=followings;
    notifyListeners();
  }

}