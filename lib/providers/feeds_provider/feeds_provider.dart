


import 'package:flutter/cupertino.dart';

import '../../model/api_models/feed_models/feed_model.dart';


class FeedsProvider extends ChangeNotifier{
  List<FeedModel> feedsList=[];

  updateFeeds(List<FeedModel> feeds){
    feedsList=feeds;
    notifyListeners();
  }

}