



import 'package:flutter/cupertino.dart';

import '../../model/api_models/feed_models/current_user_feed_model.dart';

class CurrentUserFeedsProvider extends ChangeNotifier{
  List<CurrentUserFeedsModel> feeds=[];

  updateFeeds(List<CurrentUserFeedsModel> feedsList){
    feeds.clear();
    feeds=feedsList;
    notifyListeners();
  }

}